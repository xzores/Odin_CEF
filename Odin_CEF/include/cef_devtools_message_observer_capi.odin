package odin_cef

import "core:c"

cef_dev_tools_message_observer_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_dev_tools_message: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^cef_browser_t, message: rawptr, message_size: c.size_t) -> b32,
    on_dev_tools_method_result: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^cef_browser_t, message_id: c.int, success: b32, result: rawptr, result_size: c.size_t),
    on_dev_tools_event: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^cef_browser_t, method: ^cef_string_t, params: rawptr, params_size: c.size_t),
    on_dev_tools_agent_attached: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^cef_browser_t),
    on_dev_tools_agent_detached: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^cef_browser_t),
} 