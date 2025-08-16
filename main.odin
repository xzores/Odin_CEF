package main

import "core:time"
import "core:fmt"
import "core:c"
import "core:log"
import "core:mem"
import "core:os"
import "core:path/filepath"
import "core:dynlib"
import win32 "core:sys/windows"
import "core:unicode/utf16"

import "base:intrinsics"
import "base:runtime"

import cef "CEF_bindings"

import "furbs/utils"

get_view_rect :: proc "c" (self: ^cef.Render_handler, browser: ^cef.Browser, rect: ^cef.cef_rect) {

	
}

on_paint :: proc "c" (self: ^cef.Render_handler, browser: ^cef.Browser, type: cef.Paint_element_type, dirtyRectsCount: c.size_t, dirtyRects: ^cef.cef_rect, buffer: rawptr, width: c.int, height: c.int) {


}

on_loading_state_change :: proc "c" (self: ^cef.Load_handler, browser: ^cef.Browser, isLoading: b32, canGoBack: b32, canGoForward: b32) {

}

@(private)
cef_allocator : mem.Allocator;
set_cef_allocator :: proc (alloc := context.allocator) {
	cef_allocator = alloc;
}

//Must be called when creating a cef object.
@(require_results)
alloc_cef_object :: proc ($T : typeid, loc := #caller_location) -> ^T where intrinsics.type_has_field(T, "base") {
	assert(cef_allocator != {}, "You must call set_cef_allocator first", loc);

	Super :: struct {
		obj : T,
		ref_cnt : i32,
	}

	base : cef.base_ref_counted = {
		size_of(T), //size
		proc "c" (self: ^cef.base_ref_counted) { //add_ref 
			super := cast(^Super)self;
			super.ref_cnt += 1; //whatever object must have ref_count defined.
		},
		proc "c" (self: ^cef.base_ref_counted) -> b32 { //release
			context = {};
			super := cast(^Super)self;
			super.ref_cnt -= 1; //whatever object must have ref_count defined
			res := super.ref_cnt == 0;

			//free the object
			mem.free(super, cef_allocator);

			return auto_cast res;
		},
		proc "c" (self: ^cef.base_ref_counted) -> b32 { //has_one_ref
			super := cast(^Super)self;
			return super.ref_cnt == 1;
		},
		proc "c" (self: ^cef.base_ref_counted) -> b32 { //has_at_least_one_ref
			super := cast(^Super)self;
			return super.ref_cnt >= 1;
		}
	}

	ptr, err := mem.alloc(size = size_of(Super), allocator = cef_allocator, loc = loc);
	super := cast(^Super)ptr;
	assert(err == nil, "Failed to allocate memory for CEF object");
	super.obj.base = base; 

	return &super.obj;
}

make_render_handler :: proc () -> ^cef.Render_handler {
	handler := alloc_cef_object(cef.Render_handler);
	
	handler.get_view_rect = get_view_rect;
	handler.on_paint = on_paint;

	return handler;
}

make_load_handler :: proc () -> ^cef.Load_handler {
	handler := alloc_cef_object(cef.Load_handler);

	handler.on_loading_state_change = on_loading_state_change;
	
	return handler;
}

On_before_command_line_processing :: #type proc "stdcall" (self: ^cef.App, process_type: ^cef.cef_string, Command_line: ^cef.Command_line);
On_register_custom_schemes :: #type proc "stdcall" (self: ^cef.App, registrar: ^cef.Scheme_registrar);

make_application :: proc (on_cmd_process : On_before_command_line_processing, on_reg_schemes : On_register_custom_schemes) -> ^cef.App {
	app := alloc_cef_object(cef.App);

	app.on_before_command_line_processing = on_cmd_process;
	app.on_register_custom_schemes = on_reg_schemes;

	app.get_resource_bundle_handler =  proc "stdcall" (self: ^cef.App) -> ^cef.Resource_bundle_handler {
		return nil;
	}
	app.get_browser_process_handler = proc "stdcall" (self: ^cef.App) -> ^cef.Browser_process_handler {
		return nil;
	}
	app.get_render_process_handler = proc "stdcall" (self: ^cef.App) -> ^cef.Render_process_handler {
		return nil;
	}

	return app;
}

to_cef_str :: proc (str : string) -> cef.cef_string {
	str16 := make([]u16, len(str), cef_allocator);
	str16_len := utf16.encode_string(str16, str);
	res : cef.cef_string;
	code := cef.cef_string_utf16_set(raw_data(str16), auto_cast str16_len, &res, 0);
	assert(code != 0, "failed to set the CEF string????");

	return res;
}


g_render_handler : ^cef.Render_handler;
g_load_handler : ^cef.Load_handler;

entry :: proc () { 
	
	log.infof("Starting....");
	set_cef_allocator();

    // 1) Get hInstance and exe dir
    hinstance := win32.GetModuleHandleW(nil);
    exe_path  := os.args[0];
    exe_dir   := filepath.dir(exe_path);

    // 2) Main args
	args : cef.Main_args = { hinstance };
	
	log.debugf("hinstance : %v, exe_path : %v, exe_dir : %v", hinstance, exe_path, exe_dir);

	app := make_application(
		proc "stdcall" (self: ^cef.App, process_type: ^cef.cef_string, Command_line: ^cef.Command_line) {
			context = runtime.default_context();
			fmt.printf("proccessing command line arguments, %v and %v\n", process_type, Command_line);
		},
		proc "stdcall" (self: ^cef.App, registrar: ^cef.Scheme_registrar) {
			context = runtime.default_context();
			fmt.printf("registering scheme %v\n", registrar);
		}
	);

	log.debugf("size of app: %v", size_of(cef.App));

	code := cef.execute_process(&args, app, nil);
	if (code >= 0) {
		exit_code := cef.get_exit_code();
		fmt.panicf("CEF failed to start, error code: %v(%v)", code, exit_code);
	}

	res_dir := filepath.join({exe_dir, "resources"}, context.temp_allocator);
	loc_dir := filepath.join({res_dir, "locales"}, context.temp_allocator);
	cef_settings := make_cef_settings(
		no_sandbox = true,
		multi_threaded_message_loop = true,
		resources_dir_path = res_dir,
		locales_dir_path = loc_dir,
		browser_subprocess_path = exe_path,
		log_file = "cef.log",
		log_severity = cef.Log_severity.LOGSEVERITY_DEBUG);

	code = cef.initialize(&args, &cef_settings, app, nil);
	if (code == 0) {
		exit_code := cef.get_exit_code();
		fmt.panicf("CEF initialize failed, code was %v (%v)", code, exit_code);
	}
	
	/*
	// Global handlers
	g_render_handler = make_render_handler();
	g_load_handler = make_load_handler();
	*/

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
	) -> cef.Settings {
    cef_settings := cef.Settings {
        // Size of this structure.
        size = size_of(cef.Settings),

        // Set to true (1) to disable the sandbox for sub-processes.
        no_sandbox = c.int(no_sandbox),

        // The path to a separate executable that will be launched for sub-processes.
        browser_subprocess_path = to_cef_str(browser_subprocess_path),

        // The path to the CEF framework directory on macOS.
        framework_dir_path = to_cef_str(framework_dir_path),

        // The path to the main bundle on macOS.
        main_bundle_path = to_cef_str(main_bundle_path),

        // Run browser process message loop in a separate thread.
        multi_threaded_message_loop = c.int(multi_threaded_message_loop),

        // Use external message pump scheduling.
        external_message_pump = c.int(external_message_pump),

        // Enable windowless (off-screen) rendering.
        windowless_rendering_enabled = c.int(windowless_rendering_enabled),

        // Disable command-line argument configuration.
        command_line_args_disabled = c.int(command_line_args_disabled),

        // Directory for global browser cache (empty = incognito).
        cache_path = to_cef_str(cache_path),

        // Root directory for installation-specific data.
        root_cache_path = to_cef_str(root_cache_path),

        // Persist session cookies (requires cache_path).
        persist_session_cookies = c.int(persist_session_cookies),

        // Custom User-Agent string.
        user_agent = to_cef_str(user_agent),

        // Product portion of default User-Agent.
        user_agent_product = to_cef_str(user_agent_product),

        // Locale string passed to WebKit ("en-US" default).
        locale = to_cef_str(locale),

        // Path to debug log file.
        log_file = to_cef_str(log_file),

        // Log severity threshold.
        Log_severity = log_severity,

        // Custom JS engine flags.
        javascript_flags = to_cef_str(javascript_flags),

        // Fully qualified path for resources directory.
        resources_dir_path = to_cef_str(resources_dir_path),

        // Fully qualified path for locales directory.
        locales_dir_path = to_cef_str(locales_dir_path),

        // Remote debugging port (0 = disabled).
        remote_debugging_port = c.int(remote_debugging_port),

        // Number of stack trace frames for uncaught exceptions.
        uncaught_exception_stack_size = c.int(uncaught_exception_stack_size),

        // Background color before page load.
        background_color = background_color,

        // "Accept-Language" HTTP header value.
        accept_language_list = to_cef_str(accept_language_list),

        // Custom cookieable schemes list.
        cookieable_schemes_list = to_cef_str(cookieable_schemes_list),
        cookieable_schemes_exclude_defaults = c.int(cookieable_schemes_exclude_defaults),

        // Chrome policy management ID.
        chrome_policy_id = to_cef_str(chrome_policy_id),

        // Icon resource ID for default Chrome windows (Windows only).
        chrome_app_icon_id = c.int(chrome_app_icon_id),

        // Disable signal handlers (POSIX).
        disable_signal_handlers = c.int(disable_signal_handlers),
    }

    return cef_settings
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
