package main

import "core:time"
import "core:fmt"
import "core:c"
import "core:log"
import "core:mem"

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
			super.ref_cnt += 1; //whatever object must have ref_count defined
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

On_before_command_line_processing :: #type proc "c" (self: ^cef.App, process_type: ^cef.cef_string, Command_line: ^cef.Command_line);
On_register_custom_schemes :: #type proc "c" (self: ^cef.App, registrar: ^cef.Scheme_registrar);

make_application :: proc (on_cmd_process : On_before_command_line_processing, on_reg_schemes : On_register_custom_schemes) -> ^cef.App {
	app := alloc_cef_object(cef.App);

	app.on_before_command_line_processing = on_cmd_process;
	app.on_register_custom_schemes = on_reg_schemes;

	app.get_resource_bundle_handler =  proc "c" (self: ^cef.App) -> ^cef.Resource_bundle_handler {
		return nil;
	}
	app.get_browser_process_handler = proc "c" (self: ^cef.App) -> ^cef.Browser_process_handler {
		return nil;
	}
	app.get_render_process_handler = proc "c" (self: ^cef.App) -> ^cef.Render_process_handler {
		return nil;
	}

	return app;
}

g_render_handler : ^cef.Render_handler;
g_load_handler : ^cef.Load_handler;

entry :: proc () { 
	
	log.infof("Starting....");
	set_cef_allocator();
	
	app := make_application(
		proc "c" (self: ^cef.App, process_type: ^cef.cef_string, Command_line: ^cef.Command_line) {
			context = runtime.default_context();
			fmt.printf("proccessing command line arguments, %v and %v\n", process_type, Command_line);
		},
		proc "c" (self: ^cef.App, registrar: ^cef.Scheme_registrar) {
			context = runtime.default_context();
			fmt.printf("registering scheme %v\n", registrar);
		}
	);

	code := cef.initialize(nil, nil, app, nil);
	if (code == 0) {
		fmt.panicf("CEF initialize failed, code was %v", code);
	}

	/*
	exit_code : i32 = cef.execute_process(nil, nil, nil);
  	if (exit_code >= 0) {
		panic("CEF failed to start");
	}

	// Global handlers
	g_render_handler = make_render_handler();
	g_load_handler = make_load_handler();
	*/

	log.infof("Shutting down gracefully");
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
