package odin_test_cef

import "core:c"
import "../common"

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

cef_translator_test_t :: struct {
	base: common.base_ref_counted,
	
	get_void: proc "c" (self: ^cef_translator_test_t),
	get_bool: proc "c" (self: ^cef_translator_test_t) -> c.int,
	get_int: proc "c" (self: ^cef_translator_test_t) -> c.int,
	get_double: proc "c" (self: ^cef_translator_test_t) -> f64,
	get_long: proc "c" (self: ^cef_translator_test_t) -> c.long,
	get_sizet: proc "c" (self: ^cef_translator_test_t) -> c.size_t,
	set_void: proc "c" (self: ^cef_translator_test_t) -> c.int,
	set_bool: proc "c" (self: ^cef_translator_test_t, val: c.int) -> c.int,
	set_int: proc "c" (self: ^cef_translator_test_t, val: c.int) -> c.int,
	set_double: proc "c" (self: ^cef_translator_test_t, val: f64) -> c.int,
	set_long: proc "c" (self: ^cef_translator_test_t, val: c.long) -> c.int,
	set_sizet: proc "c" (self: ^cef_translator_test_t, val: c.size_t) -> c.int,
	set_int_list: proc "c" (self: ^cef_translator_test_t, val_count: c.size_t, val: ^c.int) -> c.int,
	get_int_list_by_ref: proc "c" (self: ^cef_translator_test_t, val_count: ^c.size_t, val: ^c.int) -> c.int,
	get_int_list_size: proc "c" (self: ^cef_translator_test_t) -> c.size_t,
	get_string: proc "c" (self: ^cef_translator_test_t) -> common.cef_string_userfree,
	set_string: proc "c" (self: ^cef_translator_test_t, val: ^common.cef_string) -> c.int,
	get_string_by_ref: proc "c" (self: ^cef_translator_test_t, val: ^common.cef_string),
	set_string_list: proc "c" (self: ^cef_translator_test_t, val: common.string_list) -> c.int,
	get_string_list_by_ref: proc "c" (self: ^cef_translator_test_t, val: common.string_list) -> c.int,
	set_string_map: proc "c" (self: ^cef_translator_test_t, val: common.cef_string_map_t) -> c.int,
	get_string_map_by_ref: proc "c" (self: ^cef_translator_test_t, val: common.cef_string_map_t) -> c.int,
	set_string_multimap: proc "c" (self: ^cef_translator_test_t, val: common.string_multimap) -> c.int,
	get_string_multimap_by_ref: proc "c" (self: ^cef_translator_test_t, val: common.string_multimap) -> c.int,
	get_point: proc "c" (self: ^cef_translator_test_t) -> cef_point,
	set_point: proc "c" (self: ^cef_translator_test_t, val: ^cef_point) -> c.int,
	get_point_by_ref: proc "c" (self: ^cef_translator_test_t, val: ^cef_point),
	set_point_list: proc "c" (self: ^cef_translator_test_t, val_count: c.size_t, val: ^cef_point) -> c.int,
	get_point_list_by_ref: proc "c" (self: ^cef_translator_test_t, val_count: ^c.size_t, val: ^cef_point) -> c.int,
	get_point_list_size: proc "c" (self: ^cef_translator_test_t) -> c.size_t,
	get_ref_ptr_library: proc "c" (self: ^cef_translator_test_t, val: c.int) -> ^cef_translator_test_ref_ptr_library_t,
	set_ref_ptr_library: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_library_t) -> c.int,
	set_ref_ptr_library_and_return: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_library_t) -> ^cef_translator_test_ref_ptr_library_t,
	set_child_ref_ptr_library: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_library_child_t) -> c.int,
	set_child_ref_ptr_library_and_return_parent: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_library_child_t) -> ^cef_translator_test_ref_ptr_library_t,
	set_ref_ptr_library_list: proc "c" (self: ^cef_translator_test_t, val_count: c.size_t, val: ^^cef_translator_test_ref_ptr_library_t, val1: c.int, val2: c.int) -> c.int,
	get_ref_ptr_library_list_by_ref: proc "c" (self: ^cef_translator_test_t, val_count: ^c.size_t, val: ^^cef_translator_test_ref_ptr_library_t, val1: c.int, val2: c.int) -> c.int,
	get_ref_ptr_library_list_size: proc "c" (self: ^cef_translator_test_t) -> c.size_t,
	set_ref_ptr_client: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_client_t) -> c.int,
	set_ref_ptr_client_and_return: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_client_t) -> ^cef_translator_test_ref_ptr_client_t,
	set_child_ref_ptr_client: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_client_child_t) -> c.int,
	set_child_ref_ptr_client_and_return_parent: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_ref_ptr_client_child_t) -> ^cef_translator_test_ref_ptr_client_t,
	set_ref_ptr_client_list: proc "c" (self: ^cef_translator_test_t, val_count: c.size_t, val: ^^cef_translator_test_ref_ptr_client_t, val1: c.int, val2: c.int) -> c.int,
	get_ref_ptr_client_list_by_ref: proc "c" (self: ^cef_translator_test_t, val_count: ^c.size_t, val: ^^cef_translator_test_ref_ptr_client_t, val1: ^cef_translator_test_ref_ptr_client_t, val2: ^cef_translator_test_ref_ptr_client_t) -> c.int,
	get_ref_ptr_client_list_size: proc "c" (self: ^cef_translator_test_t) -> c.size_t,
	get_own_ptr_library: proc "c" (self: ^cef_translator_test_t, val: c.int) -> ^cef_translator_test_scoped_library_t,
	set_own_ptr_library: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_library_t) -> c.int,
	set_own_ptr_library_and_return: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_library_t) -> ^cef_translator_test_scoped_library_t,
	set_child_own_ptr_library: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_library_child_t) -> c.int,
	set_child_own_ptr_library_and_return_parent: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_library_child_t) -> ^cef_translator_test_scoped_library_t,
	set_own_ptr_client: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_client_t) -> c.int,
	set_own_ptr_client_and_return: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_client_t) -> ^cef_translator_test_scoped_client_t,
	set_child_own_ptr_client: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_client_child_t) -> c.int,
	set_child_own_ptr_client_and_return_parent: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_client_child_t) -> ^cef_translator_test_scoped_client_t,
	set_raw_ptr_library: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_library_t) -> c.int,
	set_child_raw_ptr_library: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_library_child_t) -> c.int,
	set_raw_ptr_library_list: proc "c" (self: ^cef_translator_test_t, val_count: c.size_t, val: ^^cef_translator_test_scoped_library_t, val1: c.int, val2: c.int) -> c.int,
	set_raw_ptr_client: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_client_t) -> c.int,
	set_child_raw_ptr_client: proc "c" (self: ^cef_translator_test_t, val: ^cef_translator_test_scoped_client_child_t) -> c.int,
	set_raw_ptr_client_list: proc "c" (self: ^cef_translator_test_t, val_count: c.size_t, val: ^^cef_translator_test_scoped_client_t, val1: c.int, val2: c.int) -> c.int,
}

cef_translator_test_ref_ptr_library_t :: struct {
	base: common.base_ref_counted,
	
	get_value: proc "c" (self: ^cef_translator_test_ref_ptr_library_t) -> c.int,
	set_value: proc "c" (self: ^cef_translator_test_ref_ptr_library_t, value: c.int),
}

cef_translator_test_ref_ptr_library_child_t :: struct {
	base: cef_translator_test_ref_ptr_library_t,
	
	get_other_value: proc "c" (self: ^cef_translator_test_ref_ptr_library_child_t) -> c.int,
	set_other_value: proc "c" (self: ^cef_translator_test_ref_ptr_library_child_t, value: c.int),
}

cef_translator_test_ref_ptr_library_child_child_t :: struct {
	base: cef_translator_test_ref_ptr_library_child_t,
	
	get_other_other_value: proc "c" (self: ^cef_translator_test_ref_ptr_library_child_child_t) -> c.int,
	set_other_other_value: proc "c" (self: ^cef_translator_test_ref_ptr_library_child_child_t, value: c.int),
}

cef_translator_test_ref_ptr_client_t :: struct {
	base: common.base_ref_counted,
	
	get_value: proc "c" (self: ^cef_translator_test_ref_ptr_client_t) -> c.int,
}

cef_translator_test_ref_ptr_client_child_t :: struct {
	base: cef_translator_test_ref_ptr_client_t,
	
	get_other_value: proc "c" (self: ^cef_translator_test_ref_ptr_client_child_t) -> c.int,
}

cef_translator_test_scoped_library_t :: struct {
	base: common.cef_base_scoped_t,
	
	get_value: proc "c" (self: ^cef_translator_test_scoped_library_t) -> c.int,
	set_value: proc "c" (self: ^cef_translator_test_scoped_library_t, value: c.int),
}

cef_translator_test_scoped_library_child_t :: struct {
	base: cef_translator_test_scoped_library_t,
	
	get_other_value: proc "c" (self: ^cef_translator_test_scoped_library_child_t) -> c.int,
	set_other_value: proc "c" (self: ^cef_translator_test_scoped_library_child_t, value: c.int),
}

cef_translator_test_scoped_library_child_child_t :: struct {
	base: cef_translator_test_scoped_library_child_t,
	
	get_other_other_value: proc "c" (self: ^cef_translator_test_scoped_library_child_child_t) -> c.int,
	set_other_other_value: proc "c" (self: ^cef_translator_test_scoped_library_child_child_t, value: c.int),
}

cef_translator_test_scoped_client_t :: struct {
	base: common.cef_base_scoped_t,
	
	get_value: proc "c" (self: ^cef_translator_test_scoped_client_t) -> c.int,
}

cef_translator_test_scoped_client_child_t :: struct {
	base: cef_translator_test_scoped_client_t,
	
	get_other_value: proc "c" (self: ^cef_translator_test_scoped_client_child_t) -> c.int,
}

// Function declarations
cef_translator_test_create :: proc "c" () -> ^cef_translator_test_t
cef_translator_test_ref_ptr_library_create :: proc "c" (value: c.int) -> ^cef_translator_test_ref_ptr_library_t
cef_translator_test_ref_ptr_library_child_create :: proc "c" (value: c.int, other_value: c.int) -> ^cef_translator_test_ref_ptr_library_child_t
cef_translator_test_ref_ptr_library_child_child_create :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_translator_test_ref_ptr_library_child_child_t
cef_translator_test_scoped_library_create :: proc "c" (value: c.int) -> ^cef_translator_test_scoped_library_t
cef_translator_test_scoped_library_child_create :: proc "c" (value: c.int, other_value: c.int) -> ^cef_translator_test_scoped_library_child_t
cef_translator_test_scoped_library_child_child_create :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_translator_test_scoped_library_child_child_t 