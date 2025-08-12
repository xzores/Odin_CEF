package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for types
// cef_size_t :: struct {}
// cef_rect_t :: struct {}
cef_range_t :: struct {}
cef_color_model_t :: enum c.int {}
cef_duplex_mode_t :: enum c.int {}

cef_print_settings_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_valid: proc "c" (self: ^cef_print_settings_t) -> b32,
    is_read_only: proc "c" (self: ^cef_print_settings_t) -> b32,
    set_orientation: proc "c" (self: ^cef_print_settings_t, landscape: b32),
    is_landscape: proc "c" (self: ^cef_print_settings_t) -> b32,
    set_printer_printable_area: proc "c" (self: ^cef_print_settings_t, physical_size_device_units: ^cef_size_t, printable_area_device_units: ^cef_rect_t, landscape_needs_flip: b32),
    set_device_name: proc "c" (self: ^cef_print_settings_t, name: ^cef_string_t),
    get_device_name: proc "c" (self: ^cef_print_settings_t) -> cef_string_userfree_t,
    set_dpi: proc "c" (self: ^cef_print_settings_t, dpi: c.int),
    get_dpi: proc "c" (self: ^cef_print_settings_t) -> c.int,
    set_page_ranges: proc "c" (self: ^cef_print_settings_t, ranges_count: c.size_t, ranges: ^cef_range_t),
    get_page_ranges_count: proc "c" (self: ^cef_print_settings_t) -> c.size_t,
    get_page_ranges: proc "c" (self: ^cef_print_settings_t, ranges_count: ^c.size_t, ranges: ^cef_range_t),
    set_selection_only: proc "c" (self: ^cef_print_settings_t, selection_only: b32),
    is_selection_only: proc "c" (self: ^cef_print_settings_t) -> b32,
    set_collate: proc "c" (self: ^cef_print_settings_t, collate: b32),
    will_collate: proc "c" (self: ^cef_print_settings_t) -> b32,
    set_color_model: proc "c" (self: ^cef_print_settings_t, model: cef_color_model_t),
    get_color_model: proc "c" (self: ^cef_print_settings_t) -> cef_color_model_t,
    set_copies: proc "c" (self: ^cef_print_settings_t, copies: c.int),
    get_copies: proc "c" (self: ^cef_print_settings_t) -> c.int,
    set_duplex_mode: proc "c" (self: ^cef_print_settings_t, mode: cef_duplex_mode_t),
    get_duplex_mode: proc "c" (self: ^cef_print_settings_t) -> cef_duplex_mode_t,
}

@(default_calling_convention="c")
foreign lib {
    cef_print_settings_create :: proc() -> ^cef_print_settings_t ---
} 