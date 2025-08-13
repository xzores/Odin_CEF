package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

cef_waitable_event_t :: struct {
    base: cef_base_ref_counted_t,
    
    reset: proc "c" (self: ^cef_waitable_event_t),
    signal: proc "c" (self: ^cef_waitable_event_t),
    is_signaled: proc "c" (self: ^cef_waitable_event_t) -> b32,
    wait: proc "c" (self: ^cef_waitable_event_t) -> b32,
}

@(default_calling_convention="c")
foreign lib {
    cef_waitable_event_create :: proc(automatic_reset: b32, initially_signaled: b32) -> ^cef_waitable_event_t ---
} 