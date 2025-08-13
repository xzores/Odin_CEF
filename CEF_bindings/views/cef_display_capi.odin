package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

cef_display_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_id: proc "c" (self: ^cef_display_t) -> c.int64,
    get_display_id: proc "c" (self: ^cef_display_t) -> c.int64,
    get_device_scale_factor: proc "c" (self: ^cef_display_t) -> f64,
    convert_rect_to_pixels: proc "c" (self: ^cef_display_t, rect: ^cef_rect) -> cef_rect,
    convert_rect_from_pixels: proc "c" (self: ^cef_display_t, rect: ^cef_rect) -> cef_rect,
    get_bounds: proc "c" (self: ^cef_display_t) -> cef_rect,
    get_work_area: proc "c" (self: ^cef_display_t) -> cef_rect,
    get_rotation: proc "c" (self: ^cef_display_t) -> c.int,
    get_color_depth: proc "c" (self: ^cef_display_t) -> c.int,
    get_bits_per_component: proc "c" (self: ^cef_display_t) -> c.int,
    get_monochrome: proc "c" (self: ^cef_display_t) -> b32,
    get_is_internal: proc "c" (self: ^cef_display_t) -> b32,
    get_is_primary: proc "c" (self: ^cef_display_t) -> b32,
    get_device_scale_factor: proc "c" (self: ^cef_display_t) -> f64,
    convert_rect_to_pixels: proc "c" (self: ^cef_display_t, rect: ^cef_rect) -> cef_rect,
    convert_rect_from_pixels: proc "c" (self: ^cef_display_t, rect: ^cef_rect) -> cef_rect,
    get_bounds: proc "c" (self: ^cef_display_t) -> cef_rect,
    get_work_area: proc "c" (self: ^cef_display_t) -> cef_rect,
    get_rotation: proc "c" (self: ^cef_display_t) -> c.int,
    get_color_depth: proc "c" (self: ^cef_display_t) -> c.int,
    get_bits_per_component: proc "c" (self: ^cef_display_t) -> c.int,
    get_monochrome: proc "c" (self: ^cef_display_t) -> b32,
    get_is_internal: proc "c" (self: ^cef_display_t) -> b32,
    get_is_primary: proc "c" (self: ^cef_display_t) -> b32,
} 