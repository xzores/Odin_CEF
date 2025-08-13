package odin_cef

import "core:c"

// Forward declarations for types
// Event_flags :: enum c.int {}
// cef_point :: struct {}

Menu_model_delegate_t :: struct {
    base: base_ref_counted,
    
    execute_command: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model, command_id: c.int, event_flags: Event_flags),
    mouse_outside_menu: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model, screen_point: ^cef_point),
    unhandled_open_submenu: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model, is_rtl: b32),
    unhandled_close_submenu: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model, is_rtl: b32),
    menu_will_show: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model),
    menu_closed: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model),
    format_label: proc "c" (self: ^Menu_model_delegate_t, menu_model: ^Menu_model, label: ^cef_string) -> b32,
} 