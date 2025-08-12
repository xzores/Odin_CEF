package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// accessibility_handler is defined in cef_accessibility_handler_capi.odin
// drag_data is defined in cef_drag_data_capi.odin
// cef_string is defined in cef_string_capi.odin
// cef_rect is defined in cef_types_capi.odin
// cef_screen_info is defined in cef_types_capi.odin
// cef_paint_element_type is defined in cef_types_capi.odin
// cef_accelerated_paint_info is defined in cef_types_capi.odin
// cef_horizontal_alignment is defined in cef_types_capi.odin
// cef_size is defined in cef_types_capi.odin
// cef_touch_handle_state is defined in cef_types_capi.odin
// cef_drag_operations_mask is defined in cef_types_capi.odin
// cef_range is defined in cef_types_capi.odin
// cef_text_input_mode is defined in cef_types_capi.odin

///
/// Implement this structure to handle events when window rendering is disabled.
/// The functions of this structure will be called on the UI thread.
///
/// NOTE: This struct is allocated client-side.
///
render_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Return the handler for accessibility notifications. If no handler is
    /// provided the default implementation will be used.
    ///
    get_accessibility_handler: proc "c" (self: ^render_handler) -> ^accessibility_handler,

    ///
    /// Called to retrieve the root window rectangle in screen DIP coordinates.
    /// Return true (1) if the rectangle was provided. If this function returns
    /// false (0) the rectangle from get_view_rect will be used.
    ///
    get_root_screen_rect: proc "c" (self: ^render_handler, browser: ^cef_browser_t, rect: ^cef_rect) -> b32,

    ///
    /// Called to retrieve the view rectangle in screen DIP coordinates. This
    /// function must always provide a non-NULL rectangle.
    ///
    get_view_rect: proc "c" (self: ^render_handler, browser: ^cef_browser_t, rect: ^cef_rect),

    ///
    /// Called to retrieve the translation from view DIP coordinates to screen
    /// coordinates. Windows/Linux should provide screen device (pixel)
    /// coordinates and MacOS should provide screen DIP coordinates. Return true
    /// (1) if the requested coordinates were provided.
    ///
    get_screen_point: proc "c" (self: ^render_handler, browser: ^cef_browser_t, viewX: c.int, viewY: c.int, screenX: ^c.int, screenY: ^c.int) -> b32,

    ///
    /// Called to allow the client to fill in the cef_screen_info object with
    /// appropriate values. Return true (1) if the |screen_info| structure has
    /// been modified.
    ///
    /// If the screen info rectangle is left NULL the rectangle from get_view_rect
    /// will be used. If the rectangle is still NULL or invalid popups may not be
    /// drawn correctly.
    ///
    get_screen_info: proc "c" (self: ^render_handler, browser: ^cef_browser_t, screen_info: ^cef_screen_info) -> b32,

    ///
    /// Called when the browser wants to show or hide the popup widget. The popup
    /// should be shown if |show| is true (1) and hidden if |show| is false (0).
    ///
    on_popup_show: proc "c" (self: ^render_handler, browser: ^cef_browser_t, show: b32),

    ///
    /// Called when the browser wants to move or resize the popup widget. |rect|
    /// contains the new location and size in view coordinates.
    ///
    on_popup_size: proc "c" (self: ^render_handler, browser: ^cef_browser_t, rect: ^cef_rect),

    ///
    /// Called when an element should be painted. Pixel values passed to this
    /// function are scaled relative to view coordinates based on the value of
    /// cef_screen_info.device_scale_factor returned from get_screen_info. |type|
    /// indicates whether the element is the view or the popup widget. |buffer|
    /// contains the pixel data for the whole image. |dirtyRects| contains the set
    /// of rectangles in pixel coordinates that need to be repainted. |buffer|
    /// will be |width|*|height|*4 bytes in size and represents a BGRA image with
    /// an upper-left origin. This function is only called when
    /// cef_window_info::shared_texture_enabled is set to false (0).
    ///
    on_paint: proc "c" (self: ^render_handler, browser: ^cef_browser_t, type: cef_paint_element_type, dirtyRectsCount: c.size_t, dirtyRects: ^cef_rect, buffer: rawptr, width: c.int, height: c.int),

    ///
    /// Called when an element has been rendered to the shared texture handle.
    /// |type| indicates whether the element is the view or the popup widget.
    /// |dirtyRects| contains the set of rectangles in pixel coordinates that need
    /// to be repainted. |info| contains the shared handle; on Windows it is a
    /// HANDLE to a texture that can be opened with D3D11 OpenSharedResource, on
    /// macOS it is an IOSurface pointer that can be opened with Metal or OpenGL,
    /// and on Linux it contains several planes, each with an fd to the underlying
    /// system native buffer.
    ///
    /// The underlying implementation uses a pool to deliver frames. As a result,
    /// the handle may differ every frame depending on how many frames are in-
    /// progress. The handle's resource cannot be cached and cannot be accessed
    /// outside of this callback. It should be reopened each time this callback is
    /// executed and the contents should be copied to a texture owned by the
    /// client application. The contents of |info| will be released back to the
    /// pool after this callback returns.
    ///
    on_accelerated_paint: proc "c" (self: ^render_handler, browser: ^cef_browser_t, type: cef_paint_element_type, dirtyRectsCount: c.size_t, dirtyRects: ^cef_rect, info: ^cef_accelerated_paint_info),

    ///
    /// Called to retrieve the size of the touch handle for the specified
    /// |orientation|.
    ///
    get_touch_handle_size: proc "c" (self: ^render_handler, browser: ^cef_browser_t, orientation: cef_horizontal_alignment, size: ^cef_size),

    ///
    /// Called when touch handle state is updated. The client is responsible for
    /// rendering the touch handles.
    ///
    on_touch_handle_state_changed: proc "c" (self: ^render_handler, browser: ^cef_browser_t, state: ^cef_touch_handle_state),

    ///
    /// Called when the user starts dragging content in the web view. Contextual
    /// information about the dragged content is supplied by |drag_data|.
    /// OS APIs that run a system message loop may be used within the
    /// start_dragging call.
    ///
    /// Return false (0) to abort the drag operation. Don't call any of
    /// browser_host::drag_source*_ended* functions after returning false (0).
    ///
    /// Return true (1) to handle the drag operation. Call
    /// browser_host::drag_source_ended_at and drag_source_system_drag_ended either
    /// synchronously or asynchronously to inform the web view that the drag
    /// operation has ended.
    ///
    start_dragging: proc "c" (self: ^render_handler, browser: ^cef_browser_t, drag_data: ^drag_data, allowed_ops: cef_drag_operations_mask, x: c.int, y: c.int) -> b32,

    ///
    /// Called when the web view wants to update the mouse cursor during a drag &
    /// drop operation. |operation| describes the allowed operation (none, move,
    /// copy, link).
    ///
    update_drag_cursor: proc "c" (self: ^render_handler, browser: ^cef_browser_t, operation: cef_drag_operations_mask),

    ///
    /// Called when the scroll offset has changed.
    ///
    on_scroll_offset_changed: proc "c" (self: ^render_handler, browser: ^cef_browser_t, x: f64, y: f64),

    ///
    /// Called when the IME composition range has changed. |selected_range| is the
    /// range of characters that have been selected. |character_bounds| is the
    /// bounds of each character in view coordinates.
    ///
    on_ime_composition_range_changed: proc "c" (self: ^render_handler, browser: ^cef_browser_t, selected_range: ^cef_range, character_boundsCount: c.size_t, character_bounds: ^cef_rect),

    ///
    /// Called when text selection has changed for the specified |browser|.
    /// |selected_text| is the currently selected text and |selected_range| is the
    /// character range.
    ///
    on_text_selection_changed: proc "c" (self: ^render_handler, browser: ^cef_browser_t, selected_text: ^cef_string, selected_range: ^cef_range),

    ///
    /// Called when an on-screen keyboard should be shown or hidden for the
    /// specified |browser|. |input_mode| specifies what kind of keyboard should
    /// be opened. If |input_mode| is CEF_TEXT_INPUT_MODE_NONE, any existing
    /// keyboard for this browser should be hidden.
    ///
    on_virtual_keyboard_requested: proc "c" (self: ^render_handler, browser: ^cef_browser_t, input_mode: cef_text_input_mode),
} 