

package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin

cef_value :: struct {
    base: base_ref_counted,
    // ... other members will be defined in cef_values_capi.odin
}

///
/// Implement this structure to receive accessibility notification when
/// accessibility events have been registered. The functions of this structure
/// will be called on the UI thread.
///
/// NOTE: This struct is allocated client-side.
///
accessibility_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called after renderer process sends accessibility tree changes to the
    /// browser process.
    ///
    on_accessibility_tree_change: proc "c" (self: ^accessibility_handler, value: ^cef_value),

    ///
    /// Called after renderer process sends accessibility location changes to the
    /// browser process.
    ///
    on_accessibility_location_change: proc "c" (self: ^accessibility_handler, value: ^cef_value),
} 