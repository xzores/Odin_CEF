package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

cef_response_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_read_only: proc "c" (self: ^cef_response_t) -> b32,
    get_error: proc "c" (self: ^cef_response_t) -> cef_errorcode_t,
    set_error: proc "c" (self: ^cef_response_t, error: cef_errorcode_t),
    get_status: proc "c" (self: ^cef_response_t) -> c.int,
    set_status: proc "c" (self: ^cef_response_t, status: c.int),
    get_status_text: proc "c" (self: ^cef_response_t) -> cef_string_userfree,
    set_status_text: proc "c" (self: ^cef_response_t, status_text: ^cef_string),
    get_mime_type: proc "c" (self: ^cef_response_t) -> cef_string_userfree,
    set_mime_type: proc "c" (self: ^cef_response_t, mime_type: ^cef_string),
    get_header: proc "c" (self: ^cef_response_t, name: ^cef_string) -> cef_string_userfree,
    get_header_map: proc "c" (self: ^cef_response_t, headers: ^cef_string_multimap_t),
    set_header_map: proc "c" (self: ^cef_response_t, headers: ^cef_string_multimap_t),
    set_header_by_name: proc "c" (self: ^cef_response_t, name: ^cef_string, value: ^cef_string, overwrite: b32),
    get_url: proc "c" (self: ^cef_response_t) -> cef_string_userfree,
    set_url: proc "c" (self: ^cef_response_t, url: ^cef_string),
} 