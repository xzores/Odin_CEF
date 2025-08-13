package odin_cef

import "core:c"

// Forward declarations for types
// cef_event_flags_t :: enum c.int {}
// cef_point_t :: struct {}

cef_menu_model_delegate_t :: struct {
    base: cef_base_ref_counted_t,
    
    execute_command: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t, command_id: c.int, event_flags: cef_event_flags_t),
    mouse_outside_menu: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t, screen_point: ^cef_point_t),
    unhandled_open_submenu: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t, is_rtl: b32),
    unhandled_close_submenu: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t, is_rtl: b32),
    menu_will_show: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t),
    menu_closed: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t),
    format_label: proc "c" (self: ^cef_menu_model_delegate_t, menu_model: ^cef_menu_model_t, label: ^cef_string) -> b32,
} 