package odin_cef

import "core:c"

// Forward declarations for types
cef_base_ref_counted_t :: struct {}
cef_binary_value_t :: struct {}
cef_dictionary_value_t :: struct {}
cef_list_value_t :: struct {}

cef_value_type_t :: enum c.int {}

cef_value_t :: struct {
    base: cef_base_ref_counted_t,
    is_valid: proc "c" (self: ^cef_value_t) -> b32,
    is_owned: proc "c" (self: ^cef_value_t) -> b32,
    is_read_only: proc "c" (self: ^cef_value_t) -> b32,
    is_same: proc "c" (self: ^cef_value_t, that: ^cef_value_t) -> b32,
    is_equal: proc "c" (self: ^cef_value_t, that: ^cef_value_t) -> b32,
    copy: proc "c" (self: ^cef_value_t) -> ^cef_value_t,
    get_type: proc "c" (self: ^cef_value_t) -> cef_value_type_t,
    get_bool: proc "c" (self: ^cef_value_t) -> b32,
    get_int: proc "c" (self: ^cef_value_t) -> c.int,
    get_double: proc "c" (self: ^cef_value_t) -> f64,
    get_string: proc "c" (self: ^cef_value_t) -> cef_string_userfree_t,
    get_binary: proc "c" (self: ^cef_value_t) -> ^cef_binary_value_t,
    get_dictionary: proc "c" (self: ^cef_value_t) -> ^cef_dictionary_value_t,
    get_list: proc "c" (self: ^cef_value_t) -> ^cef_list_value_t,
    set_null: proc "c" (self: ^cef_value_t) -> b32,
    set_bool: proc "c" (self: ^cef_value_t, value: b32) -> b32,
    set_int: proc "c" (self: ^cef_value_t, value: c.int) -> b32,
    set_double: proc "c" (self: ^cef_value_t, value: f64) -> b32,
    set_string: proc "c" (self: ^cef_value_t, value: ^cef_string_t) -> b32,
    set_binary: proc "c" (self: ^cef_value_t, value: ^cef_binary_value_t) -> b32,
    set_dictionary: proc "c" (self: ^cef_value_t, value: ^cef_dictionary_value_t) -> b32,
    set_list: proc "c" (self: ^cef_value_t, value: ^cef_list_value_t) -> b32,
} 