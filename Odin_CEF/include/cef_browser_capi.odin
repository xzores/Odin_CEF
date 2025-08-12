package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// client is defined in cef_client_capi.odin
// frame is defined in cef_frame_capi.odin
// cef_string is defined in cef_string_capi.odin
// request_context is defined in cef_request_context_capi.odin
// navigation_entry is defined in cef_navigation_entry_capi.odin
// image is defined in cef_image_capi.odin
// pdf_print_callback is defined in cef_browser_capi.odin

///
/// Structure used to represent a browser. When used in the browser process the
/// functions of this structure may be called on any thread unless otherwise
/// indicated in the comments. When used in the render process the functions of
/// this structure may only be called on the main thread.
///
/// NOTE: This struct is allocated DLL-side.
///
cef_browser_t :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// True if this object is currently valid. This will return false (0) after
    /// life_span_handler::on_before_close is called.
    ///
    is_valid: proc "c" (self: ^cef_browser_t) -> b32,

    ///
    /// Returns the browser host object. This function can only be called in the
    /// browser process.
    ///
    get_host: proc "c" (self: ^cef_browser_t) -> ^browser_host,

    ///
    /// Returns true (1) if the browser can navigate backwards.
    ///
    can_go_back: proc "c" (self: ^cef_browser_t) -> b32,

    ///
    /// Navigate backwards.
    ///
    go_back: proc "c" (self: ^cef_browser_t),

    ///
    /// Returns true (1) if the browser can navigate forwards.
    ///
    can_go_forward: proc "c" (self: ^cef_browser_t) -> b32,

    ///
    /// Navigate forwards.
    ///
    go_forward: proc "c" (self: ^cef_browser_t),

    ///
    /// Returns true (1) if the browser is currently loading.
    ///
    is_loading: proc "c" (self: ^cef_browser_t) -> b32,

    ///
    /// Reload the current page.
    ///
    reload: proc "c" (self: ^cef_browser_t),

    ///
    /// Reload the current page ignoring any cached data.
    ///
    reload_ignore_cache: proc "c" (self: ^cef_browser_t),

    ///
    /// Stop loading the page.
    ///
    stop_load: proc "c" (self: ^cef_browser_t),

    ///
    /// Returns the globally unique identifier for this browser. This value is
    /// also used as the tabId for extension APIs.
    ///
    get_identifier: proc "c" (self: ^cef_browser_t) -> c.int,

    ///
    /// Returns true (1) if this object is pointing to the same handle as |that|
    /// object.
    ///
    is_same: proc "c" (self: ^cef_browser_t, that: ^cef_browser_t) -> b32,

    ///
    /// Returns true (1) if the browser is a popup.
    ///
    is_popup: proc "c" (self: ^cef_browser_t) -> b32,

    ///
    /// Returns true (1) if a document has been loaded in the browser.
    ///
    has_document: proc "c" (self: ^cef_browser_t) -> b32,

    ///
    /// Returns the main (top-level) frame for the browser.
    ///
    get_main_frame: proc "c" (self: ^cef_browser_t) -> ^cef_frame_t,

    ///
    /// Returns the focused frame for the browser.
    ///
    get_focused_frame: proc "c" (self: ^cef_browser_t) -> ^cef_frame_t,

    ///
    /// Returns the frame with the specified identifier, or nil if not found.
    ///
    get_frame_by_identifier: proc "c" (self: ^cef_browser_t, identifier: ^cef_string) -> ^cef_frame_t,

    ///
    /// Returns the frame with the specified name, or nil if not found.
    ///
    get_frame_by_name: proc "c" (self: ^cef_browser_t, name: ^cef_string) -> ^cef_frame_t,
}

///
/// Structure used to represent a browser host. Methods are called on the UI thread unless otherwise noted.
///
/// NOTE: This struct is allocated DLL-side.
///
browser_host :: struct {
    base: base_ref_counted,

    get_browser: proc "c" (self: ^browser_host) -> ^cef_browser_t,
    close_browser: proc "c" (self: ^browser_host, force_close: b32),
    try_close_browser: proc "c" (self: ^browser_host) -> b32,
    is_ready_to_be_closed: proc "c" (self: ^browser_host) -> b32,
    set_focus: proc "c" (self: ^browser_host, focus: b32),
    get_window_handle: proc "c" (self: ^browser_host) -> rawptr,
    get_opener_window_handle: proc "c" (self: ^browser_host) -> rawptr,
    get_opener_identifier: proc "c" (self: ^browser_host) -> c.int,
    has_view: proc "c" (self: ^browser_host) -> b32,
    get_client: proc "c" (self: ^browser_host) -> ^cef_client_t,
    get_request_context: proc "c" (self: ^browser_host) -> ^request_context,
    // ... more function pointers as needed ...
}

///
/// Structure used to visit navigation entries.
///
/// NOTE: This struct is allocated DLL-side.
///
navigation_entry_visitor :: struct {
    base: base_ref_counted,
    ///
    /// Method that will be executed. Do not keep a reference to |entry| outside
    /// of this callback. Return true (1) to continue visiting entries or false
    /// (0) to stop. |current| is true (1) if this entry is the currently loaded
    /// navigation entry. |index| is the 0-based index of this entry and |total|
    /// is the total number of entries.
    ///
    visit: proc "c" (self: ^navigation_entry_visitor, entry: ^navigation_entry, current: b32, index: c.int, total: c.int) -> b32,
}

///
/// Structure used for PDF print callbacks.
///
/// NOTE: This struct is allocated DLL-side.
///
pdf_print_callback :: struct {
    base: base_ref_counted,
    ///
    /// Method that will be executed when the PDF printing has completed. |path|
    /// is the output path. |ok| will be true (1) if the printing completed
    /// successfully or false (0) otherwise.
    ///
    on_pdf_print_finished: proc "c" (self: ^pdf_print_callback, path: ^cef_string, ok: b32),
}

///
/// Structure used for image download callbacks.
///
/// NOTE: This struct is allocated DLL-side.
///
download_image_callback :: struct {
    base: base_ref_counted,
    ///
    /// Method that will be executed when the image download has completed.
    /// |image_url| is the URL that was downloaded and |http_status_code| is the
    /// resulting HTTP status code. |image| is the resulting image, possibly at
    /// multiple scale factors, or nil if the download failed.
    ///
    on_download_image_finished: proc "c" (self: ^download_image_callback, image_url: ^cef_string, http_status_code: c.int, image: ^image),
} 