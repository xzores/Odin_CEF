package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
cef_string :: struct {
    str: [^]u16,
    length: c.size_t,
    dtor: proc "c" ([^]u16),
}

///
/// Callback structure used for asynchronous continuation of authentication
/// requests.
///
/// NOTE: This struct is allocated DLL-side.
///
auth_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Continue the authentication request.
    ///
    cont: proc "c" (self: ^auth_callback, username: ^cef_string, password: ^cef_string),

    ///
    /// Cancel the authentication request.
    ///
    cancel: proc "c" (self: ^auth_callback),
} 