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
cef_window_delegate_t :: struct {}
cef_display_t :: struct {}
cef_overlay_controller_t :: struct {}

cef_window_t :: struct {
    base: cef_base_ref_counted_t,
    
    as_window: proc "c" (self: ^cef_window_t) -> ^cef_window_t,
    show: proc "c" (self: ^cef_window_t),
    hide: proc "c" (self: ^cef_window_t),
    center_window: proc "c" (self: ^cef_window_t, size: ^cef_size_t),
    close: proc "c" (self: ^cef_window_t),
    is_closed: proc "c" (self: ^cef_window_t) -> b32,
    activate: proc "c" (self: ^cef_window_t),
    deactivate: proc "c" (self: ^cef_window_t),
    is_active: proc "c" (self: ^cef_window_t) -> b32,
    bring_to_top: proc "c" (self: ^cef_window_t),
    set_always_on_top: proc "c" (self: ^cef_window_t, on_top: b32),
    is_always_on_top: proc "c" (self: ^cef_window_t) -> b32,
    maximize: proc "c" (self: ^cef_window_t),
    minimize: proc "c" (self: ^cef_window_t),
    is_maximized: proc "c" (self: ^cef_window_t) -> b32,
    is_minimized: proc "c" (self: ^cef_window_t) -> b32,
    restore: proc "c" (self: ^cef_window_t),
    set_fullscreen: proc "c" (self: ^cef_window_t, fullscreen: b32),
    is_fullscreen: proc "c" (self: ^cef_window_t) -> b32,
    set_title: proc "c" (self: ^cef_window_t, title: ^cef_string_t),
    get_title: proc "c" (self: ^cef_window_t) -> cef_string_userfree_t,
    set_window_icon: proc "c" (self: ^cef_window_t, image: ^cef_image_t),
    get_window_icon: proc "c" (self: ^cef_window_t) -> ^cef_image_t,
    set_window_app_icon: proc "c" (self: ^cef_window_t, image: ^cef_image_t),
    get_window_app_icon: proc "c" (self: ^cef_window_t) -> ^cef_image_t,
    get_display: proc "c" (self: ^cef_window_t) -> ^cef_display_t,
    get_client_area_bounds_in_screen: proc "c" (self: ^cef_window_t) -> cef_rect_t,
    set_draggable_regions: proc "c" (self: ^cef_window_t, regions_count: c.size_t, regions: ^cef_draggable_region_t),
    get_window_handle: proc "c" (self: ^cef_window_t) -> cef_window_handle_t,
    send_key_press: proc "c" (self: ^cef_window_t, key_code: c.int, event_flags: c.uint),
    send_mouse_move: proc "c" (self: ^cef_window_t, screen_x: c.int, screen_y: c.int),
    send_mouse_events: proc "c" (self: ^cef_window_t, type: cef_mouse_button_type_t, down: b32, double_click: b32),
    send_touch_event: proc "c" (self: ^cef_window_t, event: ^cef_touch_event_t),
    set_accelerator: proc "c" (self: ^cef_window_t, command_id: c.int, key_code: c.int, shift_pressed: b32, ctrl_pressed: b32, alt_pressed: b32),
    remove_accelerator: proc "c" (self: ^cef_window_t, command_id: c.int),
    remove_all_accelerators: proc "c" (self: ^cef_window_t),
    set_menu: proc "c" (self: ^cef_window_t, menu_model: ^cef_menu_model_t),
    get_menu: proc "c" (self: ^cef_window_t) -> ^cef_menu_model_t,
    add_overlay_view: proc "c" (self: ^cef_window_t, view: ^cef_view_t, docking_mode: cef_docking_mode_t) -> ^cef_overlay_controller_t,
    remove_overlay_view: proc "c" (self: ^cef_window_t, view: ^cef_view_t),
    resize_overlay_view: proc "c" (self: ^cef_window_t, view: ^cef_view_t, bounds: ^cef_rect_t),
    set_overlay_view_insets: proc "c" (self: ^cef_window_t, view: ^cef_view_t, insets: ^cef_insets_t),
    set_visible: proc "c" (self: ^cef_window_t, visible: b32),
    is_visible: proc "c" (self: ^cef_window_t) -> b32,
    is_drawn: proc "c" (self: ^cef_window_t) -> b32,
    set_enabled: proc "c" (self: ^cef_window_t, enabled: b32),
    is_enabled: proc "c" (self: ^cef_window_t) -> b32,
    set_focusable: proc "c" (self: ^cef_window_t, focusable: b32),
    is_focusable: proc "c" (self: ^cef_window_t) -> b32,
    is_accessibility_focusable: proc "c" (self: ^cef_window_t) -> b32,
    has_focus: proc "c" (self: ^cef_window_t) -> b32,
    request_focus: proc "c" (self: ^cef_window_t),
    set_background_color: proc "c" (self: ^cef_window_t, color: cef_color_t),
    get_background_color: proc "c" (self: ^cef_window_t) -> cef_color_t,
    get_theme_color: proc "c" (self: ^cef_window_t, color_id: c.int) -> cef_color_t,
    convert_point_to_screen: proc "c" (self: ^cef_window_t, point: ^cef_point_t) -> b32,
    convert_point_from_screen: proc "c" (self: ^cef_window_t, point: ^cef_point_t) -> b32,
    convert_point_to_window: proc "c" (self: ^cef_window_t, point: ^cef_point_t) -> b32,
    convert_point_from_window: proc "c" (self: ^cef_window_t, point: ^cef_point_t) -> b32,
    convert_point_to_view: proc "c" (self: ^cef_window_t, view: ^cef_view_t, point: ^cef_point_t) -> b32,
    convert_point_from_view: proc "c" (self: ^cef_window_t, view: ^cef_view_t, point: ^cef_point_t) -> b32,
} 