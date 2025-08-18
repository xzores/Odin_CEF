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
			context = {};
			super := cast(^Super)self;
			new_val := intrinsics.atomic_sub(&super.ref_cnt, 1);
			freed := new_val <= 1;
			
			//free the object
			if freed {
				mem.free(super, cef_allocator, super.alloc_location);
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

to_cef_str :: proc (str : string, loc := #caller_location) -> cef.cef_string {
	if str == "" {
		return {};
	}
	str16 := make([]u16, len(str), context.temp_allocator, loc);
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

destroy_application :: proc (app : ^cef.App) {
	fmt.printf("calling release\n");
	app.base.release(auto_cast app);
}

make_client :: proc (loc := #caller_location) -> ^cef.Client {
	client := alloc_cef_object(cef.Client, loc);



	return client;
}