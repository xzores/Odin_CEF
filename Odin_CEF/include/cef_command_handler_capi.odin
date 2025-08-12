package odin_cef

import "core:c"

// Forward declarations for enums
cef_window_open_disposition_t :: enum c.int {}
cef_chrome_page_action_icon_type_t :: enum c.int {}
cef_chrome_toolbar_button_type_t :: enum c.int {}

cef_command_handler_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_chrome_command: proc "c" (self: ^cef_command_handler_t, browser: ^cef_browser_t, command_id: c.int, disposition: cef_window_open_disposition_t) -> b32,
    is_chrome_app_menu_item_visible: proc "c" (self: ^cef_command_handler_t, browser: ^cef_browser_t, command_id: c.int) -> b32,
    is_chrome_app_menu_item_enabled: proc "c" (self: ^cef_command_handler_t, browser: ^cef_browser_t, command_id: c.int) -> b32,
    is_chrome_page_action_icon_visible: proc "c" (self: ^cef_command_handler_t, icon_type: cef_chrome_page_action_icon_type_t) -> b32,
    is_chrome_toolbar_button_visible: proc "c" (self: ^cef_command_handler_t, button_type: cef_chrome_toolbar_button_type_t) -> b32,
} 