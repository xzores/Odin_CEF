package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

cef_process_message_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_valid: proc "c" (self: ^cef_process_message_t) -> b32,
    is_read_only: proc "c" (self: ^cef_process_message_t) -> b32,
    copy: proc "c" (self: ^cef_process_message_t) -> ^cef_process_message_t,
    get_name: proc "c" (self: ^cef_process_message_t) -> cef_string_userfree_t,
    get_argument_list: proc "c" (self: ^cef_process_message_t) -> ^cef_list_value_t,
    get_shared_memory_region: proc "c" (self: ^cef_process_message_t) -> ^cef_shared_memory_region_t,
}

@(default_calling_convention="c")
foreign lib {
    cef_process_message_create :: proc(name: ^cef_string_t) -> ^cef_process_message_t ---
} 