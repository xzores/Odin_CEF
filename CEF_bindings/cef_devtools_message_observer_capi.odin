package odin_cef

import "core:c"

cef_dev_tools_message_observer_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_dev_tools_message: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^Browser, message: rawptr, message_size: c.size_t) -> b32,
    on_dev_tools_method_result: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^Browser, message_id: c.int, success: b32, result: rawptr, result_size: c.size_t),
    on_dev_tools_event: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^Browser, method: ^cef_string, params: rawptr, params_size: c.size_t),
    on_dev_tools_agent_attached: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^Browser),
    on_dev_tools_agent_detached: proc "c" (self: ^cef_dev_tools_message_observer_t, browser: ^Browser),
} 