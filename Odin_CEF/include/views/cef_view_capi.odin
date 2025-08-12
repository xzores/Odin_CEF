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
cef_browser_view_t :: struct {}
cef_button_t :: struct {}
cef_panel_t :: struct {}
cef_scroll_view_t :: struct {}
cef_textfield_t :: struct {}
cef_window_t :: struct {}
cef_view_delegate_t :: struct {}
cef_insets_t :: struct {}
cef_color_t :: struct {}

cef_view_t :: struct {
    base: cef_base_ref_counted_t,
    
    as_browser_view: proc "c" (self: ^cef_view_t) -> ^cef_browser_view_t,
    as_button: proc "c" (self: ^cef_view_t) -> ^cef_button_t,
    as_panel: proc "c" (self: ^cef_view_t) -> ^cef_panel_t,
    as_scroll_view: proc "c" (self: ^cef_view_t) -> ^cef_scroll_view_t,
    as_textfield: proc "c" (self: ^cef_view_t) -> ^cef_textfield_t,
    get_type_string: proc "c" (self: ^cef_view_t) -> cef_string_userfree_t,
    to_string: proc "c" (self: ^cef_view_t, include_children: c.int) -> cef_string_userfree_t,
    is_valid: proc "c" (self: ^cef_view_t) -> b32,
    is_attached: proc "c" (self: ^cef_view_t) -> b32,
    is_same: proc "c" (self: ^cef_view_t, that: ^cef_view_t) -> b32,
    get_delegate: proc "c" (self: ^cef_view_t) -> ^cef_view_delegate_t,
    get_window: proc "c" (self: ^cef_view_t) -> ^cef_window_t,
    get_id: proc "c" (self: ^cef_view_t) -> c.int,
    set_id: proc "c" (self: ^cef_view_t, id: c.int),
    get_group_id: proc "c" (self: ^cef_view_t) -> c.int,
    set_group_id: proc "c" (self: ^cef_view_t, group_id: c.int),
    get_parent_view: proc "c" (self: ^cef_view_t) -> ^cef_view_t,
    get_view_for_id: proc "c" (self: ^cef_view_t, id: c.int) -> ^cef_view_t,
    set_bounds: proc "c" (self: ^cef_view_t, bounds: ^cef_rect_t),
    get_bounds: proc "c" (self: ^cef_view_t) -> cef_rect_t,
    get_bounds_in_screen: proc "c" (self: ^cef_view_t) -> cef_rect_t,
    set_size: proc "c" (self: ^cef_view_t, size: ^cef_size_t),
    get_size: proc "c" (self: ^cef_view_t) -> cef_size_t,
    set_position: proc "c" (self: ^cef_view_t, position: ^cef_point_t),
    get_position: proc "c" (self: ^cef_view_t) -> cef_point_t,
    set_insets: proc "c" (self: ^cef_view_t, insets: ^cef_insets_t),
    get_insets: proc "c" (self: ^cef_view_t) -> cef_insets_t,
    get_preferred_size: proc "c" (self: ^cef_view_t) -> cef_size_t,
    size_to_preferred_size: proc "c" (self: ^cef_view_t),
    get_minimum_size: proc "c" (self: ^cef_view_t) -> cef_size_t,
    get_maximum_size: proc "c" (self: ^cef_view_t) -> cef_size_t,
    get_height_for_width: proc "c" (self: ^cef_view_t, width: c.int) -> c.int,
    invalidate_layout: proc "c" (self: ^cef_view_t),
    set_visible: proc "c" (self: ^cef_view_t, visible: b32),
    is_visible: proc "c" (self: ^cef_view_t) -> b32,
    is_drawn: proc "c" (self: ^cef_view_t) -> b32,
    set_enabled: proc "c" (self: ^cef_view_t, enabled: b32),
    is_enabled: proc "c" (self: ^cef_view_t) -> b32,
    set_focusable: proc "c" (self: ^cef_view_t, focusable: b32),
    is_focusable: proc "c" (self: ^cef_view_t) -> b32,
    is_accessibility_focusable: proc "c" (self: ^cef_view_t) -> b32,
    has_focus: proc "c" (self: ^cef_view_t) -> b32,
    request_focus: proc "c" (self: ^cef_view_t),
    set_background_color: proc "c" (self: ^cef_view_t, color: cef_color_t),
    get_background_color: proc "c" (self: ^cef_view_t) -> cef_color_t,
    get_theme_color: proc "c" (self: ^cef_view_t, color_id: c.int) -> cef_color_t,
    convert_point_to_screen: proc "c" (self: ^cef_view_t, point: ^cef_point_t) -> b32,
    convert_point_from_screen: proc "c" (self: ^cef_view_t, point: ^cef_point_t) -> b32,
    convert_point_to_window: proc "c" (self: ^cef_view_t, point: ^cef_point_t) -> b32,
    convert_point_from_window: proc "c" (self: ^cef_view_t, point: ^cef_point_t) -> b32,
    convert_point_to_view: proc "c" (self: ^cef_view_t, view: ^cef_view_t, point: ^cef_point_t) -> b32,
    convert_point_from_view: proc "c" (self: ^cef_view_t, view: ^cef_view_t, point: ^cef_point_t) -> b32,
} 