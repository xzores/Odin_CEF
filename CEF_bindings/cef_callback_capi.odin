package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin

///
/// Generic callback structure used for asynchronous continuation.
///
/// NOTE: This struct is allocated DLL-side.
///
callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Continue processing.
    ///
    cont: proc "c" (self: ^callback),

    ///
    /// Cancel processing.
    ///
    cancel: proc "c" (self: ^callback),
}

///
/// Generic callback structure used for asynchronous completion.
///
/// NOTE: This struct is allocated client-side.
///
completion_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Method that will be called once the task is complete.
    ///
    on_complete: proc "c" (self: ^completion_callback),
} 