package main

import "core:reflect"
import "core:thread"
import "core:time"
import "core:fmt"
import "core:c"
import "core:log"
import "core:mem"
import "core:os"
import "core:sync"
import "core:path/filepath"
import "core:dynlib"
import "core:slice"
import win32 "core:sys/windows"
import "core:unicode/utf16"

import "base:intrinsics"
import "base:runtime"

import cef "../CEF_bindings"

import "furbs/utils"

get_view_rect :: proc "system" (self: ^cef.Render_handler, browser: ^cef.Browser, rect: ^cef.cef_rect) {

	
}

on_paint :: proc "system" (self: ^cef.Render_handler, browser: ^cef.Browser, type: cef.Paint_element_type, dirtyRectsCount: c.size_t, dirtyRects: ^cef.cef_rect, buffer: rawptr, width: c.int, height: c.int) {


}

on_loading_state_change :: proc "system" (self: ^cef.Load_handler, browser: ^cef.Browser, isLoading: b32, canGoBack: b32, canGoForward: b32) {

}

g_render_handler : ^cef.Render_handler;
g_load_handler : ^cef.Load_handler;

browser_window : win32.HWND;

entry :: proc () { 

	{ //setup the hash, required in newer versions of CEF
		res := cef.api_hash(cef.CEF_API_VERSION_13900, 0);
		assert(res == cef.CEF_API_HASH_13900, "The hash does not match the platform");
		
		log.infof("CEF returned api version %v", cef.api_version());
	}

	hinstance : win32.HMODULE
	args : cef.Main_args; 
	{	//Run common setup

		log.infof("Starting thread %v", os.current_thread_id());
		set_cef_allocator();
			set_cef_logger();

		// 1) Get hInstance and exe dir
		hinstance = win32.GetModuleHandleW(nil);
		if hinstance == nil {
			check_win32_error("Failed to get module handle");
		}

		// 2) Main args
		args = { hinstance };
		
		code := cef.execute_process(&args, nil, nil);
		if (code >= 0) {
			//this is a child process
			return;
		}
		else if code == -1 {
			//we are the browser (main)
			log.infof("Starting browser thread...");
			when ODIN_WINDOWS_SUBSYSTEM == .Windows && ODIN_DEBUG {
				if !win32.AllocConsole() {
					check_win32_error("Failed to create console");
				}
			}
		}
	}

	{	//Run the main thread
		exe_path  := os.args[0];
		exe_dir   := filepath.dir(exe_path);
		defer delete(exe_dir);
		
		log.debugf("hinstance : %v, exe_path : %v, exe_dir : %v", hinstance, exe_path, exe_dir);

		root_cache_dir := filepath.join({exe_dir, "cache"}, context.temp_allocator);
		cache_dir := filepath.join({root_cache_dir, "default"}, context.temp_allocator);
		res_dir := exe_dir;
		loc_dir := filepath.join({res_dir, "locales"}, context.temp_allocator);
		log_dest := filepath.join({exe_dir, "cef.log"}, context.temp_allocator);
		
		utils.ensure_folder_exists(cache_dir);
		
		cef_settings := make_cef_settings(
			no_sandbox = true,
			multi_threaded_message_loop = true,
			cache_path = cache_dir,
			root_cache_path = root_cache_dir,
			resources_dir_path = res_dir,
			locales_dir_path = loc_dir,
			browser_subprocess_path = exe_path,
			log_file = log_dest,
			log_severity = cef.Log_severity.LOGSEVERITY_DEBUG
		);
		defer destroy_cef_settings(cef_settings);

		app := make_application(
			proc "system" (self: ^cef.App, process_type: ^cef.cef_string, Command_line: ^cef.Command_line) {
				context = restore_context();
				fmt.printf("proccessing command line arguments, %v and %#v\n", process_type, Command_line);
			},
			proc "system" (self: ^cef.App, registrar: ^cef.Scheme_registrar) {
				context = restore_context();
				fmt.printf("registering scheme %#v\n", registrar);
			}
		);
		defer release_application(app)
		log.debugf("size of app: %v", size_of(cef.App));

		increment(app);
		if cef.initialize(&args, &cef_settings, app, nil) == 0 {
			exit_code := cef.get_exit_code();
			fmt.panicf("CEF initialize failed, code was %v", exit_code);
		}
		
		class_name := utf16_str("$browser-window$", context.temp_allocator);
		window_name := utf16_str("Odin Browser", context.temp_allocator);
		log.debugf("creating %v with title %v", class_name, window_name);
		
		{ //Use win32 to register a window class
			wcex : win32.WNDCLASSEXW;
			wcex.cbSize = size_of(win32.WNDCLASSEXW);
			wcex.style = win32.CS_HREDRAW | win32.CS_VREDRAW;
			wcex.lpfnWndProc = proc "system" (window_handle : win32.HWND, msg : win32.UINT, wParam : win32.WPARAM, lParam : win32.LPARAM) -> win32.LRESULT {
				context = restore_context();

				switch msg {

					case win32.WM_CREATE: {
						pClient := make_client()  // refcounted; pass with ref=1

						rect : win32.RECT
						win32.GetClientRect(window_handle, &rect)
						bounds : cef.cef_rect = {
							rect.left, rect.top,
							rect.right - rect.left, rect.bottom - rect.top,
						}
						
						info := cef.Window_info {
							size = size_of(cef.Window_info),
							//ex_style = 0,
							//window_name = to_cef_str("$browser-window$"),
							//style = win32.WS_OVERLAPPEDWINDOW | win32.WS_CLIPCHILDREN,
							bounds = bounds,
							//parent_window = nil,
							//menu = nil,
							//windowless_rendering_enabled = 0,
							//shared_texture_enabled = 0,
							//external_begin_frame_enabled = 0,
							//window = window_handle,
							//runtime_style = .RUNTIME_STYLE_DEFAULT,
						}

						url := to_cef_str("https://www.google.com")
						defer destroy_cef_string(url)
						
						ok := cef.browser_host_create_browser(&info, pClient, &url, nil, nil, nil)
						if ok == 0 {
							log.errorf("cef_browser_host_create_browser failed")
							return -1
						}
						return 0
					}
					case win32.WM_DESTROY: {
						win32.PostQuitMessage(0);
						return 0;
					}
					case: {
						return win32.DefWindowProcW(window_handle, msg, wParam, lParam);
					}
				}
				
				unreachable();
			};
			wcex.hInstance = auto_cast hinstance;
			//wcex.hCursor = win32.LoadCursorW(nil, win32._IDC_ARROW);
			wcex.lpszClassName = raw_data(class_name);
			win32.RegisterClassExW(&wcex);

			browser_window = win32.CreateWindowExW(0, wcex.lpszClassName, raw_data(window_name), win32.WS_OVERLAPPEDWINDOW | win32.WS_CLIPCHILDREN, 200, 20, 1080, 1080, nil, nil, auto_cast hinstance, nil);
			if browser_window == nil {
				check_win32_error("failed to create window");
			}

			if !win32.ShowWindow(browser_window, win32.SW_SHOW) {
				check_win32_error("failed to show window");
			}
			if !win32.UpdateWindow(browser_window) {
				check_win32_error("failed to update window");
			}
		}
		
		msg: win32.MSG
		for win32.GetMessageW(&msg, nil, 0, 0) > 0 {
			win32.TranslateMessage(&msg)
			win32.DispatchMessageW(&msg)
		}
	}

	log.infof("Shutting down CEF");
	cef.shutdown();

	log.infof("Shutting down gracefully");
}




















make_cef_settings :: proc(
    no_sandbox: bool = true,
    multi_threaded_message_loop: bool = true,
    external_message_pump: bool = false,
    windowless_rendering_enabled: bool = false,
    command_line_args_disabled: bool = false,
    cache_path: string = "",
    root_cache_path: string = "",
    persist_session_cookies: bool = false,
    user_agent: string = "",
    user_agent_product: string = "",
    locale: string = "en-US",
    log_file: string = "cef.log",
    log_severity: cef.Log_severity = cef.Log_severity.LOGSEVERITY_INFO,
    javascript_flags: string = "",
    resources_dir_path: string = "",
    locales_dir_path: string = "",
    remote_debugging_port: int = 0,
    uncaught_exception_stack_size: int = 0,
    background_color: cef.cef_color = 0xFFFFFFFF, // opaque white
    accept_language_list: string = "en-US",
    cookieable_schemes_list: string = "",
    cookieable_schemes_exclude_defaults: bool = false,
    chrome_policy_id: string = "",
    chrome_app_icon_id: int = 0,
    disable_signal_handlers: bool = false,
    browser_subprocess_path: string = "",
    framework_dir_path: string = "",
    main_bundle_path: string = "",
	loc := #caller_location) -> cef.Settings {
    cef_settings := cef.Settings {
        // Size of this structure.
        size = size_of(cef.Settings),

        // Set to true (1) to disable the sandbox for sub-processes.
        no_sandbox = c.int(no_sandbox),

        // The path to a separate executable that will be launched for sub-processes.
        browser_subprocess_path = to_cef_str(browser_subprocess_path, loc),

        // The path to the CEF framework directory on macOS.
        framework_dir_path = to_cef_str(framework_dir_path, loc),

        // The path to the main bundle on macOS.
        main_bundle_path = to_cef_str(main_bundle_path, loc),

        // Run browser process message loop in a separate thread.
        multi_threaded_message_loop = c.int(multi_threaded_message_loop),

        // Use external message pump scheduling.
        external_message_pump = c.int(external_message_pump),

        // Enable windowless (off-screen) rendering.
        windowless_rendering_enabled = c.int(windowless_rendering_enabled),

        // Disable command-line argument configuration.
        command_line_args_disabled = c.int(command_line_args_disabled),

        // Directory for global browser cache (empty = incognito).
        cache_path = to_cef_str(cache_path, loc),

        // Root directory for installation-specific data.
        root_cache_path = to_cef_str(root_cache_path, loc),

        // Persist session cookies (requires cache_path).
        persist_session_cookies = c.int(persist_session_cookies),

        // Custom User-Agent string.
        user_agent = to_cef_str(user_agent, loc),

        // Product portion of default User-Agent.
        user_agent_product = to_cef_str(user_agent_product, loc),

        // Locale string passed to WebKit ("en-US" default).
        locale = to_cef_str(locale, loc),

        // Path to debug log file.
        log_file = to_cef_str(log_file, loc),

        // Log severity threshold.
        Log_severity = log_severity,

        // Custom JS engine flags.
        javascript_flags = to_cef_str(javascript_flags, loc),

        // Fully qualified path for resources directory.
        resources_dir_path = to_cef_str(resources_dir_path, loc),

        // Fully qualified path for locales directory.
        locales_dir_path = to_cef_str(locales_dir_path, loc),

        // Remote debugging port (0 = disabled).
        remote_debugging_port = c.int(remote_debugging_port),

        // Number of stack trace frames for uncaught exceptions.
        uncaught_exception_stack_size = c.int(uncaught_exception_stack_size),

        // Background color before page load.
        background_color = background_color,

        // "Accept-Language" HTTP header value.
        accept_language_list = to_cef_str(accept_language_list, loc),

        // Custom cookieable schemes list.
        cookieable_schemes_list = to_cef_str(cookieable_schemes_list, loc),
        cookieable_schemes_exclude_defaults = c.int(cookieable_schemes_exclude_defaults),

        // Chrome policy management ID.
        chrome_policy_id = to_cef_str(chrome_policy_id, loc),

        // Icon resource ID for default Chrome windows (Windows only).
        chrome_app_icon_id = c.int(chrome_app_icon_id),

        // Disable signal handlers (POSIX).
        disable_signal_handlers = c.int(disable_signal_handlers),
    }

    return cef_settings
}

destroy_cef_settings :: proc (settings : cef.Settings) {

	destroy_cef_string(settings.browser_subprocess_path);
	destroy_cef_string(settings.framework_dir_path);
	destroy_cef_string(settings.main_bundle_path);
	destroy_cef_string(settings.cache_path);
	destroy_cef_string(settings.root_cache_path);
	destroy_cef_string(settings.user_agent);
	destroy_cef_string(settings.user_agent_product);
	destroy_cef_string(settings.locale);
	destroy_cef_string(settings.log_file);
	destroy_cef_string(settings.javascript_flags);
	destroy_cef_string(settings.resources_dir_path);
	destroy_cef_string(settings.locales_dir_path);
	destroy_cef_string(settings.accept_language_list);
	destroy_cef_string(settings.cookieable_schemes_list);
	destroy_cef_string(settings.chrome_policy_id);
}

make_cef_browser_settings :: proc () {

}

main :: proc () {
	
	context.logger = utils.create_console_logger(.Debug);
	defer utils.destroy_console_logger(context.logger);
	
	when ODIN_DEBUG {
		context.assertion_failure_proc = utils.init_stack_trace();
		defer utils.destroy_stack_trace();
		
		utils.init_tracking_allocators();
		
		{
			tracker : ^mem.Tracking_Allocator;
			context.allocator = utils.make_tracking_allocator(tracker_res = &tracker); //This will use the backing allocator,
			
			entry();
		}
		
		utils.print_tracking_memory_results();
		utils.destroy_tracking_allocators();
	}
	else {
		entry();
	}
}
