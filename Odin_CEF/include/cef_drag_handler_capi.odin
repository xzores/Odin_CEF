package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// frame is defined in cef_frame_capi.odin
// drag_data is defined in cef_drag_data_capi.odin
// cef_drag_operations_mask is defined in cef_types_capi.odin
// cef_draggable_region is defined in cef_types_capi.odin

///
/// Implement this structure to handle events related to dragging. The functions
/// of this structure will be called on the UI thread.
///
/// NOTE: This struct is allocated client-side.
///
drag_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called when an external drag event enters the browser window. |dragData|
    /// contains the drag event data and |mask| represents the type of drag
    /// operation. Return false (0) for default drag handling behavior or true (1)
    /// to cancel the drag event.
    ///
    on_drag_enter: proc "c" (self: ^drag_handler, browser: ^cef_browser_t, dragData: ^drag_data, mask: cef_drag_operations_mask) -> b32,

    ///
    /// Called whenever draggable regions for the browser window change. These can
    /// be specified using the '-webkit-app-region: drag/no-drag' CSS-property. If
    /// draggable regions are never defined in a document this function will also
    /// never be called. If the last draggable region is removed from a document
    /// this function will be called with an NULL vector.
    ///
    on_draggable_regions_changed: proc "c" (self: ^drag_handler, browser: ^cef_browser_t, frame: ^frame, regionsCount: c.size_t, regions: ^cef_draggable_region),
} 