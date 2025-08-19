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
import win32 "core:sys/windows"
import "core:unicode/utf16"

import "base:intrinsics"
import "base:runtime"

import cef "../CEF_bindings"

@(private)
cef_allocator : mem.Allocator;
set_cef_allocator :: proc (alloc := context.allocator) {
	cef_allocator = alloc;
}

@(private)
cef_logger : log.Logger;
//sets the cef logger
set_cef_logger :: proc (logger := context.logger) {
	cef_logger = logger;
}

restore_context :: proc () -> runtime.Context {
	ctx := runtime.default_context();
	ctx.logger = cef_logger;
	ctx.allocator = cef_allocator;

	return ctx;
}

//Must be called when creating a cef object.
@(require_results)
alloc_cef_object :: proc ($T : typeid, loc := #caller_location) -> ^T where intrinsics.type_has_field(T, "base") {
	assert(cef_allocator != {}, "You must call set_cef_allocator first", loc);

	Super :: struct {
		obj : T,
		ref_cnt : i32,
		alloc_location : runtime.Source_Code_Location,
	}
	
	base : cef.base_ref_counted = {
		size_of(T), //size
		proc "system" (self: ^cef.base_ref_counted) { //add_ref 
			context = {};
			super := cast(^Super)self;
			new_val := intrinsics.atomic_add(&super.ref_cnt, 1);
		},
		proc "system" (self: ^cef.base_ref_counted) -> b32 { //release
			context = restore_context();
			super := cast(^Super)self;
			new_val := intrinsics.atomic_sub(&super.ref_cnt, 1);
			fmt.assertf(new_val >= 1, "Freed %v to many times", super, loc = super.alloc_location);
			freed := new_val == 1;
			
			//free the object
			if freed {
				log.debugf("freeing %v\n", type_info_of(T), location = super.alloc_location);
				mem.free(super);
			}
			
			return auto_cast freed;
		},
		proc "system" (self: ^cef.base_ref_counted) -> b32 { //has_one_ref
			super := cast(^Super)self;
			return super.ref_cnt == 1;
		},
		proc "system" (self: ^cef.base_ref_counted) -> b32 { //has_at_least_one_ref
			super := cast(^Super)self;
			return super.ref_cnt >= 1;
		}
	}

	ptr, err := mem.alloc(size = size_of(Super), allocator = cef_allocator, loc = loc);
	super := cast(^Super)ptr;
	assert(err == nil, "Failed to allocate memory for CEF object");
	super.obj.base = base;
	super.ref_cnt = 1;
	super.alloc_location = loc;
	
	return &super.obj;
}

release :: proc (t : ^$T) where intrinsics.type_has_field(T, "base") {
	t.base.release(auto_cast t);
}

increment :: proc (t : ^$T) where intrinsics.type_has_field(T, "base") {
	t.base.add_ref(auto_cast t);
}

to_cef_str :: proc (str : string, loc := #caller_location) -> cef.cef_string {
	if str == "" {
		return {};
	}
	str16 := make([]u16, len(str) + 2, context.temp_allocator, loc);
	str16_len := utf16.encode_string(str16, str);
	res : cef.cef_string;
	code := cef.cef_string_utf16_set(raw_data(str16), auto_cast str16_len, &res, 1);
	assert(code != 0, "failed to set the CEF string????");

	return res;
}

destroy_cef_string :: proc (str : cef.cef_string) {
	str := str;
	cef.cef_string_utf16_clear(&str);
}

On_before_command_line_processing :: #type proc "system" (self: ^cef.App, process_type: ^cef.cef_string, Command_line: ^cef.Command_line);
On_register_custom_schemes :: #type proc "system" (self: ^cef.App, registrar: ^cef.Scheme_registrar);

make_application :: proc (on_cmd_process : On_before_command_line_processing, on_reg_schemes : On_register_custom_schemes, loc := #caller_location) -> ^cef.App {
	app := alloc_cef_object(cef.App, loc);

	assert(reflect.struct_field_by_name(cef.App, "base").offset == 0);

	app.on_before_command_line_processing = on_cmd_process;
	app.on_register_custom_schemes = on_reg_schemes;

	app.get_resource_bundle_handler =  proc "system" (self: ^cef.App) -> ^cef.Resource_bundle_handler {
		return nil;
	}
	app.get_browser_process_handler = proc "system" (self: ^cef.App) -> ^cef.Browser_process_handler {
		return nil;
	}
	app.get_render_process_handler = proc "system" (self: ^cef.App) -> ^cef.Render_process_handler {
		return nil;
	}

	return app;
}

release_application :: proc (app : ^cef.App) {
	log.debugf("releasing application");
	release(auto_cast app);
}

make_client :: proc (loc := #caller_location) -> ^cef.Client {
	client := alloc_cef_object(cef.Client, loc);

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
		return nil;
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
		context = restore_context();

		log.warnf("get_render_handler");

		return nil;
	}

	/// Return the handler for browser request events.
	client.get_request_handler = proc "system" (self: ^cef.Client) -> ^cef.Request_handler {
		context = restore_context();

		log.warnf("get_request_handler");

		return nil;
	}

	/// Called when a new message is received from a different process. Return true (1) if the message was handled or false (0) otherwise. Do not
	/// keep a reference to |message| outside of this callback.
	client.on_process_message_received = proc "system" (self: ^cef.Client, browser: ^cef.Browser, frame: ^cef.Frame, source_process: cef.cef_process_id, message: ^cef.Process_message) -> b32 {
		context = restore_context();

		log.warnf("on_process_message_received");

		return true;
	}
	return client;
}


utf16_str :: proc (str : string, alloc := context.allocator) -> []u16 {
	class_name_w := make([]u16, len(str) + 2, alloc);
	utf16.encode_string(class_name_w, str);
	return class_name_w
}