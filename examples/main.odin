package main

import "core:reflect"
import "core:thread"
import "core:time"
import "core:fmt"
import "core:c"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"
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
import "furbs/render"

//setup the hash, required in newer versions of CEF
//Must be called before anything else
api_hash_setup :: proc () {
	res := cef.api_hash(cef.CEF_API_VERSION_13900, 0);
	assert(res == cef.CEF_API_HASH_13900, "The hash does not match the platform");
	log.infof("CEF returned api version %v", cef.api_version());
}

//call this before initilizing cef.
pre_init_cef :: proc () -> ( hinstance : win32.HMODULE, args : cef.Main_args, is_main : bool) {

	log.infof("Starting thread %v", os.current_thread_id());
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
		is_main = false;
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
		is_main = true;
	}

	return;
}

BGRA :: [4]u8;

// ===== OSR surface state =====
OSR_Surface :: struct {
	width, height	: i32,
	dirty 			: bool,
	pixels 			: []BGRA,       // BGRA, stride = width*4
	mutex			: sync.Mutex,
}

OdinClient :: struct {
	cef_client : ^cef.Client,
	life_span_handler : ^cef.Life_span_handler,
	
    browser           : ^cef.Browser,
    host              : ^cef.Browser_host,

	//when we use offscreen rendering:
	render_handler : ^cef.Render_handler,
	osr : OSR_Surface,
}

make_client :: proc ($quit_message_loop_on_end : bool, $use_off_screen_rendering : bool, loc := #caller_location) -> ^OdinClient {
	res := new(OdinClient, cef_allocator, loc);
	log.debugf("Allocated odin client at %p", cast(rawptr)res);
	
	alloc_cef_object(&res.cef_client, res);
	alloc_cef_object(&res.life_span_handler, res);

	client := res.cef_client;
	life_span_handler := res.life_span_handler;

	when use_off_screen_rendering { //setup render handler
		alloc_cef_object(&res.render_handler, res)
		render_handler := res.render_handler;

		res.osr = {
			INTERNAL_SIZE, INTERNAL_SIZE,
			true,
			make([]BGRA, INTERNAL_SIZE * INTERNAL_SIZE),
			{},
		}

		// Required: tell CEF our view rect (client area in DIP; assume 1:1 DIP:pixel for simplicity)
		render_handler.get_view_rect = proc "system" (self: ^cef.Render_handler, browser: ^cef.Browser, rect: ^cef.cef_rect) {
			client := cast(^OdinClient) cef_object_get_user_data(self)
			rect.x = 0;
			rect.y = 0;
			rect.width  = client.osr.width;
			rect.height = client.osr.height;
		}

		// Optional but recommended: root screen rect; just mirror view rect for now
		render_handler.get_root_screen_rect = proc "system" (self: ^cef.Render_handler, browser: ^cef.Browser, rect: ^cef.cef_rect) -> b32 {
			return false; //use the rect from get_view_rect
		}

		// Core: paint callback. Buffer = 32-bit premultiplied BGRA.
		// Copy to our pixel buffer (or only dirty rects if you want).
		render_handler.on_paint = proc "system" (self: ^cef.Render_handler, browser: ^cef.Browser, elem_type: cef.Paint_element_type,          // PET_VIEW or PET_POPUP
													dirty_count: c.size_t, dirty_rects: ^cef.cef_rect, buffer: rawptr,	width: c.int, height: c.int) 
		{
			context = restore_context();

			if elem_type != cef.Paint_element_type.PET_VIEW {
				return; // ignore popups for now
			}
			client := cast(^OdinClient) cef_object_get_user_data(self)
			sync.guard(&client.osr.mutex);

			assert(width == INTERNAL_SIZE);
			assert(height == INTERNAL_SIZE);

			// Resize CPU buffer if needed
			new_size := width * height;
			if len(client.osr.pixels) != auto_cast new_size {
				if client.osr.pixels != nil {
					delete(client.osr.pixels);
				}
				client.osr.pixels = make([]BGRA, new_size)
				client.osr.width  = width
				client.osr.height = height
			}
			
			// Copy whole buffer (simple & safe; you can optimize with dirty rects later)
			mem.copy(raw_data(client.osr.pixels), buffer, auto_cast new_size * 4)
			client.osr.dirty = true;
		}
	}
	
	{ // setup life span handler
		using cef;

		life_span_handler.on_before_popup = proc "system" (self: ^Life_span_handler, browser: ^Browser, frame: ^Frame, popup_id: c.int,
											target_url: ^cef_string, target_frame_name: ^cef_string, target_disposition: Window_open_disposition, user_gesture: b32,
											popupFeatures: ^Popup_features, windowInfo: ^Window_info, client: ^^Client, settings: ^Browser_settings, extra_info: ^^cef_dictionary_value, no_javascript_access: ^b32) -> b32 {
			//This is called on the UI thread before a new popup browser is created.
			context = restore_context();
			log.infof("allowing pop-up");
			return false;
		}

		life_span_handler.on_before_popup_aborted = proc "system" (self: ^Life_span_handler, browser: ^Browser, popup_id: c.int) {
			context = restore_context();
			log.errorf("Aborted browser creating.... likely an error");
		}

		life_span_handler.on_before_dev_tools_popup =  proc "system" (self: ^Life_span_handler, browser: ^Browser, windowInfo: ^Window_info,
																		client: ^^Client,settings: ^Browser_settings, extra_info: ^^cef_dictionary_value, use_default_window: ^b32) {
			context = restore_context();
			log.errorf("cef on_before_dev_tools_popup should never be called... exitting");
			panic("cef dev tools request, this is not supported here.");							
		}

		life_span_handler.on_after_created =  proc "system" (self: ^Life_span_handler, browser: ^Browser) {
			context = restore_context();
			log.infof("new cef browser created!");
			client := cast(^OdinClient)cef_object_get_user_data(self)
			
			client.browser = browser
			increment(client.browser) //TODO should i do this???? AI says yes

			client.host    = browser.get_host(browser);
			//increment(client.host) //TODO should i do this???? AI says no
			
			client.host.set_focus(client.host, 1)   // give focus when your window gains focus
		}

		life_span_handler.do_close = proc "system" (self: ^Life_span_handler, browser: ^Browser) -> b32 {
			context = restore_context();
			log.debugf("do_close called handled by default");
			return false;
		}

		life_span_handler.on_before_close = proc "system" (self: ^Life_span_handler, browser: ^Browser) {
			context = restore_context();
			log.debugf("on_before_close called handled on thread : %v", os.current_thread_id());
			when quit_message_loop_on_end {
				cef.quit_message_loop()
			}
		}
	}

	{ // setup cef client
		/// Return the handler for audio rendering events.
		client.get_audio_handler = proc "system" (self: ^cef.Client) -> ^cef.Audio_handler {
			return nil;
		}

		/// Return the handler for commands. If no handler is provided the default implementation will be used.
		client.get_command_handler = proc "system" (self: ^cef.Client) -> ^cef.Command_handler {
			return nil;
		}

		/// Return the handler for context menus. If no handler is provided the default implementation will be used.
		client.get_context_menu_handler = proc "system" (self: ^cef.Client) -> ^cef.Context_menu_handler {
			return nil;
		}

		/// Return the handler for dialogs. If no handler is provided the default implementation will be used.
		client.get_dialog_handler = proc "system" (self: ^cef.Client) -> ^cef.Dialog_handler {
			return nil;
		}

		/// Return the handler for browser display state events.
		client.get_Display_handler = proc "system" (self: ^cef.Client) -> ^cef.Display_handler {
			return nil;
		}
		
		/// Return the handler for download events. If no handler is returned downloads will not be allowed.
		client.get_Download_handler = proc "system" (self: ^cef.Client) -> ^cef.Download_handler {
			return nil;
		}

		/// Return the handler for drag events.
		client.get_drag_handler = proc "system" (self: ^cef.Client) -> ^cef.Drag_handler {
			return nil;
		}

		/// Return the handler for find result events.
		client.get_find_handler = proc "system" (self: ^cef.Client) -> ^cef.Find_handler {
			return nil;
		}

		/// Return the handler for focus events.
		client.get_focus_handler = proc "system" (self: ^cef.Client) -> ^cef.Focus_handler {
			return nil;
		}

		/// Return the handler for events related to frame lifespan. This function will be called once during browser creation and the result
		/// will be cached for performance reasons.
		client.get_frame_handler = proc "system" (self: ^cef.Client) -> ^cef.Frame_handler {
			return nil;
		}

		/// Return the handler for permission requests.
		client.get_permission_handler = proc "system" (self: ^cef.Client) -> ^cef.Permission_handler {
			return nil;
		}

		/// Return the handler for JavaScript dialogs. If no handler is provided the default implementation will be used.
		client.get_jsdialog_handler = proc "system" (self: ^cef.Client) -> ^cef.Jsdialog_handler {
			return nil;
		}

		/// Return the handler for keyboard events.
		client.get_keyboard_handler = proc "system" (self: ^cef.Client) -> ^cef.Keyboard_handler {
			return nil;
		}
		
		/// Return the handler for browser life span events.
		client.get_life_span_handler = proc "system" (self: ^cef.Client) -> ^cef.Life_span_handler {
			client := cast(^OdinClient)cef_object_get_user_data(self);
			increment(client.life_span_handler);
			return client.life_span_handler;
		}

		/// Return the handler for browser load status events.
		client.get_load_handler = proc "system" (self: ^cef.Client) -> ^cef.Load_handler {
			return nil;
		}

		/// Return the handler for printing on Linux. If a print handler is not provided then printing will not be supported on the Linux platform.
		client.get_print_handler = proc "system" (self: ^cef.Client) -> ^cef.Print_handler {
			return nil;
		}
		
		/// Return the handler for off-screen rendering events.
		client.get_render_handler = proc "system" (self: ^cef.Client) -> ^cef.Render_handler {
			when use_off_screen_rendering {
				client := cast(^OdinClient)cef_object_get_user_data(self);
				increment(client.render_handler);
				return client.render_handler;
			} else {
				return nil;
			}
		}

		/// Return the handler for browser request events.
		client.get_request_handler = proc "system" (self: ^cef.Client) -> ^cef.Request_handler {
			context = restore_context();

			//log.warnf("get_request_handler");

			return nil;
		}

		/*
		/// Called when a new message is received from a different process. Return true (1) if the message was handled or false (0) otherwise. Do not
		/// keep a reference to |message| outside of this callback.
		client.on_process_message_received = proc "system" (self: ^cef.Client, browser: ^cef.Browser, frame: ^cef.Frame, source_process: cef.cef_process_id, message: ^cef.Process_message) -> b32 {
			context = restore_context();
			
			log.warnf("on_process_message_received");
			
			return true;
		}
		*/
	}

	return res;
}

destroy_client :: proc (odin_client : ^OdinClient) {
	release_all(odin_client);
	delete(odin_client.osr.pixels);
	free(odin_client);
}





//This allows chome to make its own window just how it likes to, this gives the closest to a "chome experience"
entry_chome_window :: proc () {

	api_hash_setup();
	hinstance, args, is_main := pre_init_cef();

	if !is_main {
		return;
	}

	set_cef_allocator();
	set_cef_logger();

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
			multi_threaded_message_loop = false,
			cache_path = cache_dir,
			root_cache_path = root_cache_dir,
			resources_dir_path = res_dir,
			locales_dir_path = loc_dir,
			browser_subprocess_path = exe_path,
			log_file = log_dest,
			log_severity = cef.Log_severity.LOGSEVERITY_DEBUG,
			command_line_args_disabled = false,
		);
		defer destroy_cef_settings(cef_settings);

		app := make_application(
			proc "system" (self: ^cef.App, process_type: ^cef.cef_string, cmd: ^cef.Command_line) {
				context = restore_context();
				assert(cmd != nil);
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
	
		ex_style :: 0;
		class_name_str :: "BrowserWindowClass";
		window_name_str :: "Odin Browser Chome Owned";
		style : u32 : win32.WS_OVERLAPPEDWINDOW | win32.WS_CLIPCHILDREN | win32.WS_CLIPSIBLINGS | win32.WS_VISIBLE;
	
		log.debugf("creating %v with title %v", class_name_str, window_name_str);
		
		window_name := to_cef_str(window_name_str);
		defer destroy_cef_string(window_name);

		pClient : ^OdinClient;
		defer destroy_client(pClient)
		{ //Use chome to make a window
			pClient = make_client(true, false)

			info := cef.Window_info {
				size = size_of(cef.Window_info),

				// Standard parameters required by CreateWindowEx()
				ex_style = ex_style,			// DWORD
				window_name = window_name,
				style = style,			   // DWORD
			}
			
			url := to_cef_str("https://www.google.com")
			defer destroy_cef_string(url)
			
			browser_settings := cef.Browser_settings {
				// Size of this structure.
				size = size_of(cef.Browser_settings),
			}

			ok := cef.browser_host_create_browser(&info, pClient.cef_client, &url, &browser_settings, nil, nil)
			if ok == 0 {
				log.errorf("CEF failed to create browser")
			}
		}
		
		cef.run_message_loop();
		log.infof("Done");
	}

	log.infof("Shutting down CEF");
	cef.shutdown();

	log.infof("Shutting down gracefully");
}

//This creates a win32 windows and just allows CEF to render into that window. This does not have the chomes tabs.
win32_client : ^OdinClient;
entry_win32_window :: proc () { 

	api_hash_setup();

	hinstance, args, is_main := pre_init_cef();
	
	if !is_main {
		return;
	}

	set_cef_allocator();
	set_cef_logger();

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
			log_severity = cef.Log_severity.LOGSEVERITY_DEBUG,
			command_line_args_disabled = false,
		);
		defer destroy_cef_settings(cef_settings);

		app := make_application(
			proc "system" (self: ^cef.App, process_type: ^cef.cef_string, cmd: ^cef.Command_line) {
				context = restore_context();
				
				assert(cmd != nil);
				cmd.append_switch(cmd, to_cef_str_ptr("disable-gpu", context.temp_allocator));
				cmd.append_switch(cmd, to_cef_str_ptr("disable-gpu-compositing", context.temp_allocator));
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
	
		ex_style :: 0;
		class_name_str :: "BrowserWindowClass";
		window_name_str :: "Odin Browser";
		style : u32 : win32.CS_HREDRAW | win32.CS_VREDRAW;

		class_name := utf16_str(class_name_str, context.temp_allocator);
		window_name := utf16_str(window_name_str, context.temp_allocator);
		log.debugf("creating %v with title %v", class_name, window_name);
		
		defer destroy_client(win32_client);
		{ //Use win32 to register a window class
			wcex : win32.WNDCLASSEXW;
			wcex.cbSize = size_of(win32.WNDCLASSEXW);
			wcex.style = style;
			wcex.lpfnWndProc = proc "system" (window_handle : win32.HWND, msg : win32.UINT, wParam : win32.WPARAM, lParam : win32.LPARAM) -> win32.LRESULT {
				context = restore_context();

				switch msg {

					case win32.WM_CREATE: {
						win32_client = make_client(false, false)
						
						rect : win32.RECT
						win32.GetClientRect(window_handle, &rect)
						bounds : cef.cef_rect = {
							rect.left, rect.top,
							rect.right - rect.left, rect.bottom - rect.top,
						}
						
						log.infof("creating window with bounds : %v", bounds);

						info := cef.Window_info {
							size = size_of(cef.Window_info),
							bounds = bounds,
							parent_window = window_handle, 
						}
						
						url := to_cef_str("https://www.google.com")
						defer destroy_cef_string(url)
						
						browser_settings := cef.Browser_settings {
							// Size of this structure.
							size = size_of(cef.Browser_settings),
						}
						
						ok := cef.browser_host_create_browser(&info, win32_client.cef_client, &url, &browser_settings, nil, nil)
						if ok == 0 {
							log.errorf("CEF failed to create browser")
						}
						return 0
					}
					case win32.WM_CLOSE: {
						log.debugf("WM CLOSE");
						return win32.DefWindowProcW(window_handle, msg, wParam, lParam);
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
			if win32.RegisterClassExW(&wcex) == 0 {
				check_win32_error("failed to register class");
			}

			browser_window := win32.CreateWindowExW(ex_style, wcex.lpszClassName, raw_data(window_name), win32.WS_OVERLAPPEDWINDOW | win32.WS_CLIPCHILDREN | win32.WS_CLIPSIBLINGS | win32.WS_VISIBLE,
														win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, nil, nil, auto_cast hinstance, nil);
			if browser_window == nil {
				check_win32_error("failed to create window");
			}

			if !win32.ShowWindow(browser_window, win32.SW_SHOWDEFAULT) {
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

INTERNAL_SIZE :: 1024;
//this utilizes windowsless rendering at a fixed resolution and then that is rendered to the screen.
//key mapping, mouse input and such might not be 100% correct, pleas check yourself.
entry_furbs_window :: proc () {

	/////////////////////////////// CEF INIT ///////////////////////////////
	api_hash_setup();
	hinstance, args, is_main := pre_init_cef();

	if !is_main {
		return;
	}

	set_cef_allocator();
	set_cef_logger();

	app := make_application(
		proc "system" (self: ^cef.App, process_type: ^cef.cef_string, cmd: ^cef.Command_line) {
			context = restore_context();
			assert(cmd != nil);
		},
		proc "system" (self: ^cef.App, registrar: ^cef.Scheme_registrar) {
			context = restore_context();
			fmt.printf("registering scheme %#v\n", registrar);
		}
	);
	defer release_application(app)
	
	pClient : ^OdinClient;
	defer destroy_client(pClient)
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
			no_sandbox = true, //this should be set to false at some point
			multi_threaded_message_loop = true,
			cache_path = cache_dir,
			root_cache_path = root_cache_dir,
			resources_dir_path = res_dir,
			locales_dir_path = loc_dir,
			browser_subprocess_path = exe_path,
			log_file = log_dest,
			log_severity = cef.Log_severity.LOGSEVERITY_DEBUG,
		);
		defer destroy_cef_settings(cef_settings);

		log.debugf("size of app: %v", size_of(cef.App));
		
		increment(app);
		if cef.initialize(&args, &cef_settings, app, nil) == 0 {
			exit_code := cef.get_exit_code();
			fmt.panicf("CEF initialize failed, code was %v", exit_code);
		}

		{ //Render windowless
			pClient = make_client(false, true)

			info := cef.Window_info {
				size = size_of(cef.Window_info),
				windowless_rendering_enabled = 1,
			}
			
			url := to_cef_str("https://www.google.com")
			defer destroy_cef_string(url)
			
			browser_settings := cef.Browser_settings {
				// Size of this structure.
				size = size_of(cef.Browser_settings),
				windowless_frame_rate = 30,
			}

			ok := cef.browser_host_create_browser(&info, pClient.cef_client, &url, &browser_settings, nil, nil)
			if ok == 0 {
				log.errorf("CEF failed to create browser")
			}
		}

		log.infof("Done");
	}

	/////////////////////////////// RENDER INIT ///////////////////////////////
	render.init({}, required_gl_verion = .opengl_4_4);
	defer render.destroy();
	
	window := render.window_make(512, 512, "CEF in an opengl window", .allow_resize, .none);
	defer render.window_destroy(window);
	//Init a windowless rendering and show me how to read from the buffer (i will handle the uploading to render)
	
	should_close := false;
	
	def_pipeline := render.pipeline_make(render.get_default_shader(), .no_blend, true, false, .fill, .no_cull);
	unit_camera := render.Camera2D { //render space is (-1,-1) to (1, 1) if sqaure
		{0,0},
		{0,0},
		0,
		1,
		-1,
		1,
	}

	cef_texture := render.texture2D_make(true, .repeat, .linear, .RGBA8, INTERNAL_SIZE, INTERNAL_SIZE, .no_upload, nil, [4]f64{1,0,1,1});
	defer render.texture2D_destroy(cef_texture);
	render.window_set_vsync(true);

	cef_buffer := make([][4]u8, INTERNAL_SIZE * INTERNAL_SIZE);
	defer delete(cef_buffer);

	/////////////////////////////// RENDER LOOP ///////////////////////////////
	for !render.window_should_close(window) {
		//draw
		render.begin_frame(); {
			
			{ //Handle mouse input to CEF
				//calculate mouse pointer in cef rect
				pos := render.mouse_pos(window);
				pos.y = cast(f32)window.height - pos.y;
				pos /= cast(f32)window.height;
				pos *= INTERNAL_SIZE;

				mouse_modifiers : cef.Event_flags;
				{	//construct event falg
					if render.is_caps_lock() {
						mouse_modifiers += .EVENTFLAG_CAPS_LOCK_ON;
					}
					if render.is_shift() {
						mouse_modifiers += .EVENTFLAG_SHIFT_DOWN;
					}
					if render.is_control() {
						mouse_modifiers += .EVENTFLAG_CONTROL_DOWN;
					}
					if render.is_alt() {
						mouse_modifiers += .EVENTFLAG_ALT_DOWN;
					}
					if render.is_button_down(.left) {
						mouse_modifiers += .EVENTFLAG_LEFT_MOUSE_BUTTON;
					}
					if render.is_button_down(.middel) {
						mouse_modifiers += .EVENTFLAG_MIDDLE_MOUSE_BUTTON;
					}
					if render.is_button_down(.right) {
						mouse_modifiers += .EVENTFLAG_RIGHT_MOUSE_BUTTON;
					}
					if render.is_super() {
						mouse_modifiers += .EVENTFLAG_COMMAND_DOWN;
					}
					if render.is_num_lock() {
						mouse_modifiers += .EVENTFLAG_NUM_LOCK_ON;
					}
					//ignore EVENTFLAG_IS_LEFT = 1 << 10,
					//ignore EVENTFLAG_IS_RIGHT = 1 << 11,
					if render.is_key_down(.alt_right) && render.is_control() {
						mouse_modifiers += .EVENTFLAG_ALTGR_DOWN;
					}
					//ignore EVENTFLAG_IS_REPEAT = 1 << 13,
					//ignore EVENTFLAG_PRECISION_SCROLLING_DELTA = 1 << 14,
					//ignore EVENTFLAG_SCROLL_BY_PAGE = 1 << 15,
				}
				
				mouse_event := cef.Mouse_event {cast(i32)pos.x, cast(i32)pos.y, mouse_modifiers}; 
				
				//Mouse buttons
				mk_arr := [?]render.Mouse_code{render.Mouse_code.left, render.Mouse_code.middel, render.Mouse_code.right}
				for mk, cef_key in mk_arr { //map to left = 0, middel = 1, right = 2
					if render.is_button_pressed(mk) {
						pClient.host.send_mouse_click_event(pClient.host, &mouse_event, auto_cast cef_key, 0, 1);
					}
					if render.is_button_released(mk) {
						pClient.host.send_mouse_click_event(pClient.host, &mouse_event, auto_cast cef_key, 1, 1);
					}
				}
				
				{//mouse movement
					pClient.host.send_mouse_move_event(pClient.host, &mouse_event, 0);
				}

				//Scroll wheel
				if sd := render.scroll_delta(); sd != {} {
					sd *= 120; //WHY 120 idk??
					pClient.host.send_mouse_wheel_event(pClient.host, &mouse_event, cast(i32)sd.x, cast(i32)sd.y);
				}
				
			}

			{ //DO keyboard input
				//This simply handles text input event nothing more, no rawkey inputs here
				//r is a 4 byte rune (UTF32)
				r, done := render.recive_next_input()
				for !done {
					defer r, done = render.recive_next_input()
					
					fmt.printf("doing key %v\n", r);

					key_modifiers : cef.Event_flags;
					{	//construct event falg
						if render.is_caps_lock() {
							key_modifiers += .EVENTFLAG_CAPS_LOCK_ON;
						}
						if render.is_shift() {
							key_modifiers += .EVENTFLAG_SHIFT_DOWN;
						}
						if render.is_control() {
							key_modifiers += .EVENTFLAG_CONTROL_DOWN;
						}
						if render.is_alt() {
							key_modifiers += .EVENTFLAG_ALT_DOWN;
						}
						if render.is_button_down(.left) {
							key_modifiers += .EVENTFLAG_LEFT_MOUSE_BUTTON;
						}
						if render.is_button_down(.middel) {
							key_modifiers += .EVENTFLAG_MIDDLE_MOUSE_BUTTON;
						}
						if render.is_button_down(.right) {
							key_modifiers += .EVENTFLAG_RIGHT_MOUSE_BUTTON;
						}
						if render.is_super() {
							key_modifiers += .EVENTFLAG_COMMAND_DOWN;
						}
						if render.is_num_lock() {
							key_modifiers += .EVENTFLAG_NUM_LOCK_ON;
						}
						//ignore EVENTFLAG_IS_LEFT = 1 << 10,
						//ignore EVENTFLAG_IS_RIGHT = 1 << 11,
						if render.is_key_down(.alt_right) && render.is_control() {
							key_modifiers += .EVENTFLAG_ALTGR_DOWN;
						}
						//ignore EVENTFLAG_IS_REPEAT = 1 << 13,
						//ignore EVENTFLAG_PRECISION_SCROLLING_DELTA = 1 << 14,
						//ignore EVENTFLAG_SCROLL_BY_PAGE = 1 << 15,
					}

					/// Structure representing keyboard event information.
					ke := cef.Key_event {
						size = size_of(cef.Key_event),
						
						/// The type of keyboard event.
						type = .KEYEVENT_CHAR,

						/// Bit flags describing any pressed modifier keys. See
						/// Event_flags for values.
						modifiers = key_modifiers,

						/// The Windows key code for the key event. This value is used by the DOM
						/// specification. Sometimes it comes directly from the event (i.e. on
						/// Windows) and sometimes it's determined using a mapping function. See
						/// WebCore/platform/chromium/KeyboardCodes.h for the list of values.
						windows_key_code = auto_cast r, //IDK what this is???

						/// The actual key code genenerated by the platform.
						native_key_code = 0, //IDK what this is???

						/// Indicates whether the event is considered a "system key" event (see
						/// http://msdn.microsoft.com/en-us/library/ms646286(VS.85).aspx for details).
						/// This value will always be false on non-Windows platforms.
						is_system_key = render.is_alt() ? 1 : 0,
						
						/// The character generated by the keystroke.
						character = auto_cast r,

						/// Same as |character| but unmodified by any concurrently-held modifiers
						/// (except shift). This is useful for working out shortcut keys.
						unmodified_character  = auto_cast r, //TODO we should do something more here

						/// True if the focus is currently on an editable field on the page. This is
						/// useful for determining if standard key events should be intercepted.
						focus_on_editable_field = 1, //ITDK what this is
					}

					pClient.host.send_key_event(pClient.host, &ke);
				}
			}
			
			{ //Handle the cef texture upload.
				sync.guard(&pClient.osr.mutex);
				if pClient.osr.dirty {
					for pixel, i in pClient.osr.pixels {
						cef_buffer[i] = {pixel[2], pixel[1], pixel[0], pixel[3]} //convert BGRA to RGBA
					}
					render.texture2D_flip(slice.reinterpret([]u8, cef_buffer), pClient.osr.width, pClient.osr.height, 4);
					render.texture2D_upload_data(&cef_texture, .RGBA8, {0,0}, {INTERNAL_SIZE, INTERNAL_SIZE}, cef_buffer);
					pClient.osr.dirty = false;
				}
			}

			render.target_begin(window, [4]f32{0.1,0.5,0.2,1}); {
				render.pipeline_begin(def_pipeline, unit_camera); {
					
					render.set_texture(.texture_diffuse, cef_texture);
					render.draw_quad_rect({-1,-1,2,2});

				}; render.pipeline_end()
			} render.target_end()
		} render.end_frame();
	}
	
	cef.shutdown();
}















main :: proc () {
	
	entry :: proc () {
		//entry_chome_window();
		//entry_win32_window();
		entry_furbs_window();
	}

	context.logger = utils.create_console_logger(.Debug);
	defer utils.destroy_console_logger(context.logger);
	
	if len(os.args) > 1 && strings.starts_with(os.args[1], "--type=") {
		entry();
	}

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
