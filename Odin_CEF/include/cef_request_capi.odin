package odin_cef

import "core:c"

// Forward declarations for enums and types
cef_referrer_policy_t :: enum c.int {}
cef_resource_type_t :: enum c.int {}
cef_transition_type_t :: enum c.int {}
cef_postdataelement_type_t :: enum c.int {}

cef_request_t :: struct {
    base: cef_base_ref_counted_t,
    is_read_only: proc "c" (self: ^cef_request_t) -> b32,
    get_url: proc "c" (self: ^cef_request_t) -> cef_string_userfree_t,
    set_url: proc "c" (self: ^cef_request_t, url: ^cef_string_t),
    get_method: proc "c" (self: ^cef_request_t) -> cef_string_userfree_t,
    set_method: proc "c" (self: ^cef_request_t, method: ^cef_string_t),
    set_referrer: proc "c" (self: ^cef_request_t, referrer_url: ^cef_string_t, policy: cef_referrer_policy_t),
    get_referrer_url: proc "c" (self: ^cef_request_t) -> cef_string_userfree_t,
    get_referrer_policy: proc "c" (self: ^cef_request_t) -> cef_referrer_policy_t,
    get_post_data: proc "c" (self: ^cef_request_t) -> ^cef_post_data_t,
    set_post_data: proc "c" (self: ^cef_request_t, postData: ^cef_post_data_t),
    get_header_map: proc "c" (self: ^cef_request_t, headerMap: cef_string_multimap_t),
    set_header_map: proc "c" (self: ^cef_request_t, headerMap: cef_string_multimap_t),
    get_header_by_name: proc "c" (self: ^cef_request_t, name: ^cef_string_t) -> cef_string_userfree_t,
    set_header_by_name: proc "c" (self: ^cef_request_t, name: ^cef_string_t, value: ^cef_string_t, overwrite: b32),
    set: proc "c" (self: ^cef_request_t, url: ^cef_string_t, method: ^cef_string_t, postData: ^cef_post_data_t, headerMap: cef_string_multimap_t),
    get_flags: proc "c" (self: ^cef_request_t) -> c.int,
    set_flags: proc "c" (self: ^cef_request_t, flags: c.int),
    get_first_party_for_cookies: proc "c" (self: ^cef_request_t) -> cef_string_userfree_t,
    set_first_party_for_cookies: proc "c" (self: ^cef_request_t, url: ^cef_string_t),
    get_resource_type: proc "c" (self: ^cef_request_t) -> cef_resource_type_t,
    get_transition_type: proc "c" (self: ^cef_request_t) -> cef_transition_type_t,
    get_identifier: proc "c" (self: ^cef_request_t) -> u64,
}

cef_post_data_t :: struct {
    base: cef_base_ref_counted_t,
    is_read_only: proc "c" (self: ^cef_post_data_t) -> b32,
    has_excluded_elements: proc "c" (self: ^cef_post_data_t) -> b32,
    get_element_count: proc "c" (self: ^cef_post_data_t) -> c.size_t,
    get_elements: proc "c" (self: ^cef_post_data_t, elementsCount: ^c.size_t, elements: ^^cef_post_data_element_t),
    remove_element: proc "c" (self: ^cef_post_data_t, element: ^cef_post_data_element_t) -> b32,
    add_element: proc "c" (self: ^cef_post_data_t, element: ^cef_post_data_element_t) -> b32,
    remove_elements: proc "c" (self: ^cef_post_data_t),
}

cef_post_data_element_t :: struct {
    base: cef_base_ref_counted_t,
    is_read_only: proc "c" (self: ^cef_post_data_element_t) -> b32,
    set_to_empty: proc "c" (self: ^cef_post_data_element_t),
    set_to_file: proc "c" (self: ^cef_post_data_element_t, fileName: ^cef_string_t),
    set_to_bytes: proc "c" (self: ^cef_post_data_element_t, size: c.size_t, bytes: rawptr),
    get_type: proc "c" (self: ^cef_post_data_element_t) -> cef_postdataelement_type_t,
    get_file: proc "c" (self: ^cef_post_data_element_t) -> cef_string_userfree_t,
    get_bytes_count: proc "c" (self: ^cef_post_data_element_t) -> c.size_t,
    get_bytes: proc "c" (self: ^cef_post_data_element_t, size: c.size_t, bytes: rawptr) -> c.size_t,
} 