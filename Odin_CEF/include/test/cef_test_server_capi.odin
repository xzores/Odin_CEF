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

// Forward declarations for types that need to be defined before use
cef_completion_callback_t :: struct {}
cef_request_t :: struct {}
cef_test_cert_type_t :: enum c.int {
    // Add enum values as needed
}

cef_test_server_t :: struct {
    base: common.cef_base_ref_counted_t,
    
    stop: proc "c" (self: ^cef_test_server_t),
    get_origin: proc "c" (self: ^cef_test_server_t) -> common.cef_string_userfree_t,
}

cef_test_server_handler_t :: struct {
    base: common.cef_base_ref_counted_t,
    
    on_test_server_request: proc "c" (self: ^cef_test_server_handler_t, server: ^cef_test_server_t, request: ^cef_request_t, connection: ^cef_test_server_connection_t) -> c.int,
}

cef_test_server_connection_t :: struct {
    base: common.cef_base_ref_counted_t,
    
    send_http200_response: proc "c" (self: ^cef_test_server_connection_t, content_type: ^common.cef_string_t, data: rawptr, data_size: c.size_t),
    send_http404_response: proc "c" (self: ^cef_test_server_connection_t),
    send_http500_response: proc "c" (self: ^cef_test_server_connection_t, error_message: ^common.cef_string_t),
    send_http_response: proc "c" (self: ^cef_test_server_connection_t, response_code: c.int, content_type: ^common.cef_string_t, data: rawptr, data_size: c.size_t, extra_headers: common.cef_string_multimap_t),
}

// Function declarations
@(default_calling_convention="c")
foreign lib {
    cef_test_server_create_and_start :: proc(port: c.int, handler: ^cef_test_server_handler_t, completion_callback: ^cef_completion_callback_t) ---
} 