package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// cef_rect is defined in cef_types_capi.odin

///
/// Implement this structure to handle events related to find results. The
/// functions of this structure will be called on the UI thread.
///
/// NOTE: This struct is allocated client-side.
///
find_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called to report find results returned by browser_host::find().
    /// |identifer| is a unique incremental identifier for the currently active
    /// search, |count| is the number of matches currently identified,
    /// |selectionRect| is the location of where the match was found (in window
    /// coordinates), |activeMatchOrdinal| is the current position in the search
    /// results, and |finalUpdate| is true (1) if this is the last find
    /// notification.
    ///
    on_find_result: proc "c" (self: ^find_handler, browser: ^Browser, identifier: c.int, count: c.int, selectionRect: ^cef_rect, activeMatchOrdinal: c.int, finalUpdate: b32),
} 