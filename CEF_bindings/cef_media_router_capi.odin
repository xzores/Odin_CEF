package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for enums and types
cef_media_route_connection_state_t :: enum c.int {}
cef_media_route_create_result_t :: enum c.int {}
cef_media_sink_icon_type_t :: enum c.int {}
cef_media_sink_device_info_t :: struct {}

cef_media_router_t :: struct {
    base: cef_base_ref_counted_t,
    
    add_observer: proc "c" (self: ^cef_media_router_t, observer: ^cef_media_observer_t) -> ^cef_registration_t,
    get_source: proc "c" (self: ^cef_media_router_t, urn: ^cef_string) -> ^cef_media_source_t,
    notify_current_sinks: proc "c" (self: ^cef_media_router_t),
    create_route: proc "c" (self: ^cef_media_router_t, source: ^cef_media_source_t, sink: ^cef_media_sink_t, callback: ^cef_media_route_create_callback_t),
    notify_current_routes: proc "c" (self: ^cef_media_router_t),
}

@(default_calling_convention="c")
foreign lib {
    cef_media_router_get_global :: proc(callback: ^cef_completion_callback_t) -> ^cef_media_router_t ---
}

cef_media_observer_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_sinks: proc "c" (self: ^cef_media_observer_t, sinks_count: c.size_t, sinks: [^]^cef_media_sink_t),
    on_routes: proc "c" (self: ^cef_media_observer_t, routes_count: c.size_t, routes: [^]^cef_media_route_t),
    on_route_state_changed: proc "c" (self: ^cef_media_observer_t, route: ^cef_media_route_t, state: cef_media_route_connection_state_t),
    on_route_message_received: proc "c" (self: ^cef_media_observer_t, route: ^cef_media_route_t, message: rawptr, message_size: c.size_t),
}

cef_media_route_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_id: proc "c" (self: ^cef_media_route_t) -> cef_string_userfree,
    get_source: proc "c" (self: ^cef_media_route_t) -> ^cef_media_source_t,
    get_sink: proc "c" (self: ^cef_media_route_t) -> ^cef_media_sink_t,
    send_route_message: proc "c" (self: ^cef_media_route_t, message: rawptr, message_size: c.size_t),
    terminate: proc "c" (self: ^cef_media_route_t),
}

cef_media_route_create_callback_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_media_route_create_finished: proc "c" (self: ^cef_media_route_create_callback_t, result: cef_media_route_create_result_t, error: ^cef_string, route: ^cef_media_route_t),
}

cef_media_sink_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_id: proc "c" (self: ^cef_media_sink_t) -> cef_string_userfree,
    get_name: proc "c" (self: ^cef_media_sink_t) -> cef_string_userfree,
    get_icon_type: proc "c" (self: ^cef_media_sink_t) -> cef_media_sink_icon_type_t,
    get_device_info: proc "c" (self: ^cef_media_sink_t, callback: ^cef_media_sink_device_info_callback_t),
    is_cast_sink: proc "c" (self: ^cef_media_sink_t) -> b32,
    is_dial_sink: proc "c" (self: ^cef_media_sink_t) -> b32,
    is_compatible_with: proc "c" (self: ^cef_media_sink_t, source: ^cef_media_source_t) -> b32,
}

cef_media_sink_device_info_callback_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_media_sink_device_info: proc "c" (self: ^cef_media_sink_device_info_callback_t, device_info: ^cef_media_sink_device_info_t),
}

cef_media_source_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_id: proc "c" (self: ^cef_media_source_t) -> cef_string_userfree,
    is_cast_source: proc "c" (self: ^cef_media_source_t) -> b32,
    is_dial_source: proc "c" (self: ^cef_media_source_t) -> b32,
} 