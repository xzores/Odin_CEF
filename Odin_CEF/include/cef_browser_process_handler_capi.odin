package odin_cef

import "core:c"

// Forward declarations for types
cef_preferences_type_t :: enum c.int {}
cef_preference_registrar_t :: struct {}
cef_request_context_handler_t :: struct {}

cef_browser_process_handler_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_register_custom_preferences: proc "c" (self: ^cef_browser_process_handler_t, type: cef_preferences_type_t, registrar: ^cef_preference_registrar_t),
    on_context_initialized: proc "c" (self: ^cef_browser_process_handler_t),
    on_before_child_process_launch: proc "c" (self: ^cef_browser_process_handler_t, command_line: ^cef_command_line_t),
    on_already_running_app_relaunch: proc "c" (self: ^cef_browser_process_handler_t, command_line: ^cef_command_line_t, current_directory: ^cef_string_t) -> b32,
    on_schedule_message_pump_work: proc "c" (self: ^cef_browser_process_handler_t, delay_ms: i64),
    get_default_client: proc "c" (self: ^cef_browser_process_handler_t) -> ^cef_client_t,
    get_default_request_context_handler: proc "c" (self: ^cef_browser_process_handler_t) -> ^cef_request_context_handler_t,
} 