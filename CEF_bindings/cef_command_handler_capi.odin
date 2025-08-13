package odin_cef

import "core:c"

// Forward declarations for enums
cef_window_open_disposition_t :: enum c.int {}
cef_chrome_page_action_icon_type_t :: enum c.int {}
cef_chrome_toolbar_button_type_t :: enum c.int {}

command_handler :: struct {
    base: cef_base_ref_counted_t,
    
    on_chrome_command: proc "c" (self: ^command_handler, browser: ^Browser, command_id: c.int, disposition: cef_window_open_disposition_t) -> b32,
    is_chrome_app_menu_item_visible: proc "c" (self: ^command_handler, browser: ^Browser, command_id: c.int) -> b32,
    is_chrome_app_menu_item_enabled: proc "c" (self: ^command_handler, browser: ^Browser, command_id: c.int) -> b32,
    is_chrome_page_action_icon_visible: proc "c" (self: ^command_handler, icon_type: cef_chrome_page_action_icon_type_t) -> b32,
    is_chrome_toolbar_button_visible: proc "c" (self: ^command_handler, button_type: cef_chrome_toolbar_button_type_t) -> b32,
} 