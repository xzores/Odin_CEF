package odin_cef

import "core:c"

Request :: struct {
    base: base_ref_counted,
    is_read_only: proc "c" (self: ^Request) -> b32,
    get_url: proc "c" (self: ^Request) -> cef_string_userfree,
    set_url: proc "c" (self: ^Request, url: ^cef_string),
    get_method: proc "c" (self: ^Request) -> cef_string_userfree,
    set_method: proc "c" (self: ^Request, method: ^cef_string),
    set_referrer: proc "c" (self: ^Request, referrer_url: ^cef_string, policy: Referrer_policy),
    get_referrer_url: proc "c" (self: ^Request) -> cef_string_userfree,
    get_referrer_policy: proc "c" (self: ^Request) -> Referrer_policy,
    get_post_data: proc "c" (self: ^Request) -> ^cef_post_data_t,
    set_post_data: proc "c" (self: ^Request, postData: ^cef_post_data_t),
    get_header_map: proc "c" (self: ^Request, headerMap: string_multimap),
    set_header_map: proc "c" (self: ^Request, headerMap: string_multimap),
    get_header_by_name: proc "c" (self: ^Request, name: ^cef_string) -> cef_string_userfree,
    set_header_by_name: proc "c" (self: ^Request, name: ^cef_string, value: ^cef_string, overwrite: b32),
    set: proc "c" (self: ^Request, url: ^cef_string, method: ^cef_string, postData: ^cef_post_data_t, headerMap: string_multimap),
    get_flags: proc "c" (self: ^Request) -> c.int,
    set_flags: proc "c" (self: ^Request, flags: c.int),
    get_first_party_for_cookies: proc "c" (self: ^Request) -> cef_string_userfree,
    set_first_party_for_cookies: proc "c" (self: ^Request, url: ^cef_string),
    get_resource_type: proc "c" (self: ^Request) -> Resource_type,
    get_transition_type: proc "c" (self: ^Request) -> Transition_type,
    get_identifier: proc "c" (self: ^Request) -> u64,
}

cef_post_data_t :: struct {
    base: base_ref_counted,
    is_read_only: proc "c" (self: ^cef_post_data_t) -> b32,
    has_excluded_elements: proc "c" (self: ^cef_post_data_t) -> b32,
    get_element_count: proc "c" (self: ^cef_post_data_t) -> c.size_t,
    get_elements: proc "c" (self: ^cef_post_data_t, elementsCount: ^c.size_t, elements: ^^cef_post_data_element_t),
    remove_element: proc "c" (self: ^cef_post_data_t, element: ^cef_post_data_element_t) -> b32,
    add_element: proc "c" (self: ^cef_post_data_t, element: ^cef_post_data_element_t) -> b32,
    remove_elements: proc "c" (self: ^cef_post_data_t),
}

cef_post_data_element_t :: struct {
    base: base_ref_counted,
    is_read_only: proc "c" (self: ^cef_post_data_element_t) -> b32,
    set_to_empty: proc "c" (self: ^cef_post_data_element_t),
    set_to_file: proc "c" (self: ^cef_post_data_element_t, fileName: ^cef_string),
    set_to_bytes: proc "c" (self: ^cef_post_data_element_t, size: c.size_t, bytes: rawptr),
    get_type: proc "c" (self: ^cef_post_data_element_t) -> Postdataelement_type,
    get_file: proc "c" (self: ^cef_post_data_element_t) -> cef_string_userfree,
    get_bytes_count: proc "c" (self: ^cef_post_data_element_t) -> c.size_t,
    get_bytes: proc "c" (self: ^cef_post_data_element_t, size: c.size_t, bytes: rawptr) -> c.size_t,
} 