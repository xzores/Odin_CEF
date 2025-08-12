package odin_common_cef

import "core:c"

// Basic CEF types that are used across multiple files
cef_string_t :: struct {}
cef_string_userfree_t :: cstring
cef_string_list_t :: rawptr
cef_string_map_t :: rawptr
cef_string_multimap_t :: rawptr
cef_base_ref_counted_t :: struct {}
cef_base_scoped_t :: struct {} 