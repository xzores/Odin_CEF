package odin_cef

import "core:c"

// cef_request_context_handler_t :: struct {}

//cef_request_context_handler_t :: struct {
//    base: cef_base_ref_counted_t,
//    
//    on_request_context_initialized: proc "c" (self: ^cef_request_context_handler_t, request_context: ^cef_request_context_t),
//    get_resource_request_handler: proc "c" (self: ^cef_request_context_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t, request: ^cef_request_t, is_navigation: b32, is_download: b32, request_initiator: ^cef_string, disable_default_handling: ^b32) -> ^cef_resource_request_handler_t,
//} 