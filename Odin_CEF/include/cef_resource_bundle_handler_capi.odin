package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for types that need to be defined before use
// cef_scale_factor_t is defined in cef_resource_bundle_capi.odin

cef_resource_bundle_handler_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_localized_string: proc "c" (self: ^cef_resource_bundle_handler_t, string_id: c.int, string: ^cef_string_t) -> b32,
    get_data_resource: proc "c" (self: ^cef_resource_bundle_handler_t, resource_id: c.int, data: ^^cef_binary_value_t) -> b32,
    get_data_resource_for_scale: proc "c" (self: ^cef_resource_bundle_handler_t, resource_id: c.int, scale_factor: cef_scale_factor_t, data: ^^cef_binary_value_t) -> b32,
} 