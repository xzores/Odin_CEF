package odin_cef

import "core:c"

// Forward declarations for types
// cef_transition_type_t :: enum c.int {}
cef_basetime_t :: enum c.int {}

cef_navigation_entry_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_valid: proc "c" (self: ^cef_navigation_entry_t) -> b32,
    get_url: proc "c" (self: ^cef_navigation_entry_t) -> cef_string_userfree_t,
    get_display_url: proc "c" (self: ^cef_navigation_entry_t) -> cef_string_userfree_t,
    get_original_url: proc "c" (self: ^cef_navigation_entry_t) -> cef_string_userfree_t,
    get_title: proc "c" (self: ^cef_navigation_entry_t) -> cef_string_userfree_t,
    get_transition_type: proc "c" (self: ^cef_navigation_entry_t) -> cef_transition_type_t,
    has_post_data: proc "c" (self: ^cef_navigation_entry_t) -> b32,
    get_completion_time: proc "c" (self: ^cef_navigation_entry_t) -> cef_basetime_t,
    get_http_status_code: proc "c" (self: ^cef_navigation_entry_t) -> c.int,
    get_sslstatus: proc "c" (self: ^cef_navigation_entry_t) -> ^cef_sslstatus_t,
} 