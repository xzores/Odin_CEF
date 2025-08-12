package odin_test_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for types that need to be defined before use
cef_base_ref_counted_t :: struct {}
cef_base_scoped_t :: struct {}

cef_api_version_test_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_ref_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: c.int) -> ^cef_api_version_test_ref_ptr_library_t,
    set_ref_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_library_t) -> c.int,
    set_ref_ptr_library_and_return: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_library_t) -> ^cef_api_version_test_ref_ptr_library_t,
    set_child_ref_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_library_child_t) -> c.int,
    set_child_ref_ptr_library_and_return_parent: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_library_child_t) -> ^cef_api_version_test_ref_ptr_library_t,
    set_ref_ptr_library_list: proc "c" (self: ^cef_api_version_test_t, val_count: c.size_t, val: ^^cef_api_version_test_ref_ptr_library_t, val1: c.int, val2: c.int) -> c.int,
    get_ref_ptr_library_list_by_ref: proc "c" (self: ^cef_api_version_test_t, val_count: ^c.size_t, val: ^^cef_api_version_test_ref_ptr_library_t, val1: c.int, val2: c.int) -> c.int,
    get_ref_ptr_library_list_size: proc "c" (self: ^cef_api_version_test_t) -> c.size_t,
    set_ref_ptr_client: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_client_t) -> c.int,
    set_ref_ptr_client_and_return: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_client_t) -> ^cef_api_version_test_ref_ptr_client_t,
    set_ref_ptr_client_list: proc "c" (self: ^cef_api_version_test_t, val_count: c.size_t, val: ^^cef_api_version_test_ref_ptr_client_t, val1: c.int, val2: c.int) -> c.int,
    get_ref_ptr_client_list_by_ref: proc "c" (self: ^cef_api_version_test_t, val_count: ^c.size_t, val: ^^cef_api_version_test_ref_ptr_client_t, val1: ^cef_api_version_test_ref_ptr_client_t, val2: ^cef_api_version_test_ref_ptr_client_t) -> c.int,
    get_ref_ptr_client_list_size: proc "c" (self: ^cef_api_version_test_t) -> c.size_t,
    get_own_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: c.int) -> ^cef_api_version_test_scoped_library_t,
    set_own_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_library_t) -> c.int,
    set_own_ptr_library_and_return: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_library_t) -> ^cef_api_version_test_scoped_library_t,
    set_child_own_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_library_child_t) -> c.int,
    set_child_own_ptr_library_and_return_parent: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_library_child_t) -> ^cef_api_version_test_scoped_library_t,
    set_own_ptr_client: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_client_t) -> c.int,
    set_own_ptr_client_and_return: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_client_t) -> ^cef_api_version_test_scoped_client_t,
    set_raw_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_library_t) -> c.int,
    set_child_raw_ptr_library: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_library_child_t) -> c.int,
    set_raw_ptr_library_list: proc "c" (self: ^cef_api_version_test_t, val_count: c.size_t, val: ^^cef_api_version_test_scoped_library_t, val1: c.int, val2: c.int) -> c.int,
    set_raw_ptr_client: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_client_t) -> c.int,
    set_raw_ptr_client_list: proc "c" (self: ^cef_api_version_test_t, val_count: c.size_t, val: ^^cef_api_version_test_scoped_client_t, val1: c.int, val2: c.int) -> c.int,
    set_child_ref_ptr_client_v2: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_client_child_v2_t) -> c.int,
    set_child_ref_ptr_client_and_return_parent_v2: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_ref_ptr_client_child_v2_t) -> ^cef_api_version_test_ref_ptr_client_t,
    set_child_own_ptr_client_v2: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_client_child_v2_t) -> c.int,
    set_child_own_ptr_client_and_return_parent_v2: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_client_child_v2_t) -> ^cef_api_version_test_scoped_client_t,
    set_child_raw_ptr_client_v2: proc "c" (self: ^cef_api_version_test_t, val: ^cef_api_version_test_scoped_client_child_v2_t) -> c.int,
}

cef_api_version_test_ref_ptr_library_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_value_legacy: proc "c" (self: ^cef_api_version_test_ref_ptr_library_t) -> c.int,
    set_value_legacy: proc "c" (self: ^cef_api_version_test_ref_ptr_library_t, value: c.int),
    get_value_v2: proc "c" (self: ^cef_api_version_test_ref_ptr_library_t) -> c.int,
    set_value_v2: proc "c" (self: ^cef_api_version_test_ref_ptr_library_t, value: c.int),
    get_value_exp: proc "c" (self: ^cef_api_version_test_ref_ptr_library_t) -> c.int,
    set_value_exp: proc "c" (self: ^cef_api_version_test_ref_ptr_library_t, value: c.int),
}

cef_api_version_test_ref_ptr_library_child_t :: struct {
    base: cef_api_version_test_ref_ptr_library_t,
    
    get_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_t) -> c.int,
    set_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_t, value: c.int),
}

cef_api_version_test_ref_ptr_library_child_child_t :: struct {
    base: cef_api_version_test_ref_ptr_library_child_t,
    
    get_other_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_child_t) -> c.int,
    set_other_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_child_t, value: c.int),
}

cef_api_version_test_ref_ptr_library_child_child_v1_t :: struct {
    base: cef_api_version_test_ref_ptr_library_child_t,
    
    get_other_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_child_v1_t) -> c.int,
    set_other_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_child_v1_t, value: c.int),
}

cef_api_version_test_ref_ptr_library_child_child_v2_t :: struct {
    base: cef_api_version_test_ref_ptr_library_child_t,
    
    get_other_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_child_v2_t) -> c.int,
    set_other_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_library_child_child_v2_t, value: c.int),
}

cef_api_version_test_ref_ptr_client_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_value_legacy: proc "c" (self: ^cef_api_version_test_ref_ptr_client_t) -> c.int,
    get_value_v2: proc "c" (self: ^cef_api_version_test_ref_ptr_client_t) -> c.int,
    get_value_exp: proc "c" (self: ^cef_api_version_test_ref_ptr_client_t) -> c.int,
}

cef_api_version_test_ref_ptr_client_child_t :: struct {
    base: cef_api_version_test_ref_ptr_client_t,
    
    get_other_value_v1: proc "c" (self: ^cef_api_version_test_ref_ptr_client_child_t) -> c.int,
}

cef_api_version_test_ref_ptr_client_child_v2_t :: struct {
    base: cef_api_version_test_ref_ptr_client_t,
    
    get_other_value: proc "c" (self: ^cef_api_version_test_ref_ptr_client_child_v2_t) -> c.int,
    get_another_value: proc "c" (self: ^cef_api_version_test_ref_ptr_client_child_v2_t) -> c.int,
}

cef_api_version_test_scoped_library_t :: struct {
    base: cef_base_scoped_t,
    
    get_value_legacy: proc "c" (self: ^cef_api_version_test_scoped_library_t) -> c.int,
    set_value_legacy: proc "c" (self: ^cef_api_version_test_scoped_library_t, value: c.int),
    get_value_v2: proc "c" (self: ^cef_api_version_test_scoped_library_t) -> c.int,
    set_value_v2: proc "c" (self: ^cef_api_version_test_scoped_library_t, value: c.int),
    get_value_exp: proc "c" (self: ^cef_api_version_test_scoped_library_t) -> c.int,
    set_value_exp: proc "c" (self: ^cef_api_version_test_scoped_library_t, value: c.int),
}

cef_api_version_test_scoped_library_child_t :: struct {
    base: cef_api_version_test_scoped_library_t,
    
    get_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_t) -> c.int,
    set_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_t, value: c.int),
}

cef_api_version_test_scoped_library_child_child_t :: struct {
    base: cef_api_version_test_scoped_library_child_t,
    
    get_other_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_child_t) -> c.int,
    set_other_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_child_t, value: c.int),
}

cef_api_version_test_scoped_library_child_child_v1_t :: struct {
    base: cef_api_version_test_scoped_library_child_t,
    
    get_other_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_child_v1_t) -> c.int,
    set_other_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_child_v1_t, value: c.int),
}

cef_api_version_test_scoped_library_child_child_v2_t :: struct {
    base: cef_api_version_test_scoped_library_child_t,
    
    get_other_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_child_v2_t) -> c.int,
    set_other_other_value: proc "c" (self: ^cef_api_version_test_scoped_library_child_child_v2_t, value: c.int),
}

cef_api_version_test_scoped_client_t :: struct {
    base: cef_base_scoped_t,
    
    get_value_legacy: proc "c" (self: ^cef_api_version_test_scoped_client_t) -> c.int,
    get_value_v2: proc "c" (self: ^cef_api_version_test_scoped_client_t) -> c.int,
    get_value_exp: proc "c" (self: ^cef_api_version_test_scoped_client_t) -> c.int,
}

cef_api_version_test_scoped_client_child_t :: struct {
    base: cef_api_version_test_scoped_client_t,
    
    get_other_value_v1: proc "c" (self: ^cef_api_version_test_scoped_client_child_t) -> c.int,
}

cef_api_version_test_scoped_client_child_v2_t :: struct {
    base: cef_api_version_test_scoped_client_t,
    
    get_other_value: proc "c" (self: ^cef_api_version_test_scoped_client_child_v2_t) -> c.int,
    get_another_value: proc "c" (self: ^cef_api_version_test_scoped_client_child_v2_t) -> c.int,
}

// Function declarations
cef_api_version_test_create :: proc "c" () -> ^cef_api_version_test_t
cef_api_version_test_ref_ptr_library_create_with_default :: proc "c" (value: c.int) -> ^cef_api_version_test_ref_ptr_library_t
cef_api_version_test_ref_ptr_library_child_create_with_default :: proc "c" (value: c.int, other_value: c.int) -> ^cef_api_version_test_ref_ptr_library_child_t
cef_api_version_test_ref_ptr_library_child_child_create_with_default :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_api_version_test_ref_ptr_library_child_child_t
cef_api_version_test_ref_ptr_library_child_child_v1_create_with_default :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_api_version_test_ref_ptr_library_child_child_v1_t
cef_api_version_test_ref_ptr_library_child_child_v2_create_with_default :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_api_version_test_ref_ptr_library_child_child_v2_t
cef_api_version_test_scoped_library_create_with_default :: proc "c" (value: c.int) -> ^cef_api_version_test_scoped_library_t
cef_api_version_test_scoped_library_child_create_with_default :: proc "c" (value: c.int, other_value: c.int) -> ^cef_api_version_test_scoped_library_child_t
cef_api_version_test_scoped_library_child_child_create_with_default :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_api_version_test_scoped_library_child_child_t
cef_api_version_test_scoped_library_child_child_v1_create_with_default :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_api_version_test_scoped_library_child_child_v1_t
cef_api_version_test_scoped_library_child_child_v2_create_with_default :: proc "c" (value: c.int, other_value: c.int, other_other_value: c.int) -> ^cef_api_version_test_scoped_library_child_child_v2_t 