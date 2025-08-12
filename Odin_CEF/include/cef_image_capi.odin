package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for enums
cef_color_type_t :: enum c.int {}
cef_alpha_type_t :: enum c.int {}

cef_image_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_empty: proc "c" (self: ^cef_image_t) -> b32,
    is_same: proc "c" (self: ^cef_image_t, that: ^cef_image_t) -> b32,
    add_bitmap: proc "c" (self: ^cef_image_t, scale_factor: f32, pixel_width: c.int, pixel_height: c.int, color_type: cef_color_type_t, alpha_type: cef_alpha_type_t, pixel_data: rawptr, pixel_data_size: c.size_t) -> b32,
    add_png: proc "c" (self: ^cef_image_t, scale_factor: f32, png_data: rawptr, png_data_size: c.size_t) -> b32,
    add_jpeg: proc "c" (self: ^cef_image_t, scale_factor: f32, jpeg_data: rawptr, jpeg_data_size: c.size_t) -> b32,
    get_width: proc "c" (self: ^cef_image_t) -> c.size_t,
    get_height: proc "c" (self: ^cef_image_t) -> c.size_t,
    has_representation: proc "c" (self: ^cef_image_t, scale_factor: f32) -> b32,
    remove_representation: proc "c" (self: ^cef_image_t, scale_factor: f32) -> b32,
    get_representation_info: proc "c" (self: ^cef_image_t, scale_factor: f32, actual_scale_factor: ^f32, pixel_width: ^c.int, pixel_height: ^c.int) -> b32,
    get_as_bitmap: proc "c" (self: ^cef_image_t, scale_factor: f32, color_type: cef_color_type_t, alpha_type: cef_alpha_type_t, pixel_width: ^c.int, pixel_height: ^c.int) -> ^cef_binary_value_t,
    get_as_png: proc "c" (self: ^cef_image_t, scale_factor: f32, with_transparency: b32, pixel_width: ^c.int, pixel_height: ^c.int) -> ^cef_binary_value_t,
    get_as_jpeg: proc "c" (self: ^cef_image_t, scale_factor: f32, quality: c.int, pixel_width: ^c.int, pixel_height: ^c.int) -> ^cef_binary_value_t,
}

@(default_calling_convention="c")
foreign lib {
    cef_image_create :: proc() -> ^cef_image_t ---
} 