package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

cef_shared_process_message_builder_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_valid: proc "c" (self: ^cef_shared_process_message_builder_t) -> b32,
    size: proc "c" (self: ^cef_shared_process_message_builder_t) -> c.size_t,
    memory: proc "c" (self: ^cef_shared_process_message_builder_t) -> rawptr,
    build: proc "c" (self: ^cef_shared_process_message_builder_t) -> ^cef_process_message_t,
} 