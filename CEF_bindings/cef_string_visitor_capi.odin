package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// cef_string is defined in cef_string_capi.odin

/// Implement this structure to receive string values asynchronously.
/// NOTE: This struct is allocated client-side.
///
string_visitor :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Method that will be executed.
	visit: proc "c" (self: ^string_visitor, string: ^cef_string),
} 