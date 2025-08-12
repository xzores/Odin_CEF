package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin

///
/// Callback structure for asynchronous handling of an unresponsive process.
///
/// NOTE: This struct is allocated DLL-side.
///
unresponsive_process_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Reset the timeout for the unresponsive process.
    ///
    wait: proc "c" (self: ^unresponsive_process_callback),

    ///
    /// Terminate the unresponsive process.
    ///
    terminate: proc "c" (self: ^unresponsive_process_callback),
} 