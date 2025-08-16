package odin_test_cef

import "core:c"
import "../common"

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

cef_test_server_t :: struct {
	base: common.base_ref_counted,
	
	stop: proc "system" (self: ^cef_test_server_t),
	get_origin: proc "system" (self: ^cef_test_server_t) -> common.cef_string_userfree,
}

cef_test_server_handler_t :: struct {
	base: common.base_ref_counted,
	
	on_test_server_request: proc "system" (self: ^cef_test_server_handler_t, server: ^cef_test_server_t, request: ^Request, connection: ^cef_test_server_connection_t) -> c.int,
}

cef_test_server_connection_t :: struct {
	base: common.base_ref_counted,
	
	send_http200_response: proc "system" (self: ^cef_test_server_connection_t, content_type: ^common.cef_string, data: rawptr, data_size: c.size_t),
	send_http404_response: proc "system" (self: ^cef_test_server_connection_t),
	send_http500_response: proc "system" (self: ^cef_test_server_connection_t, error_message: ^common.cef_string),
	send_http_response: proc "system" (self: ^cef_test_server_connection_t, response_code: c.int, content_type: ^common.cef_string, data: rawptr, data_size: c.size_t, extra_headers: common.string_multimap),
}

// Function declarations
@(default_calling_convention="system")
foreign lib {
	cef_test_server_create_and_start :: proc(port: c.int, handler: ^cef_test_server_handler_t, Completion_callback: ^Completion_callback) ---
} 