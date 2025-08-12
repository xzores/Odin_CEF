package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// cef_string is defined in cef_string_capi.odin
// download_item is defined in cef_download_item_capi.odin

///
/// Callback structure used to asynchronously continue a download.
///
/// NOTE: This struct is allocated DLL-side.
///
before_download_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Call to continue the download. Set |download_path| to the full file path
    /// for the download including the file name or leave blank to use the
    /// suggested name and the default temp directory. Set |show_dialog| to true
    /// (1) if you do wish to show the default "Save As" dialog.
    ///
    cont: proc "c" (self: ^before_download_callback, download_path: ^cef_string, show_dialog: b32),
}

///
/// Callback structure used to asynchronously cancel a download.
///
/// NOTE: This struct is allocated DLL-side.
///
download_item_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Call to cancel the download.
    ///
    cancel: proc "c" (self: ^download_item_callback),

    ///
    /// Call to pause the download.
    ///
    pause: proc "c" (self: ^download_item_callback),

    ///
    /// Call to resume the download.
    ///
    resume: proc "c" (self: ^download_item_callback),
}

///
/// Structure used to handle file downloads. The functions of this structure
/// will called on the browser process UI thread.
///
/// NOTE: This struct is allocated client-side.
///
download_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called before a download begins in response to a user-initiated action
    /// (e.g. alt + link click or link click that returns a `Content-Disposition:
    /// attachment` response from the server). |url| is the target download URL
    /// and |request_function| is the target function (GET, POST, etc). Return
    /// true (1) to proceed with the download or false (0) to cancel the download.
    ///
    can_download: proc "c" (self: ^download_handler, browser: ^cef_browser_t, url: ^cef_string, request_method: ^cef_string) -> b32,

    ///
    /// Called before a download begins. |suggested_name| is the suggested name
    /// for the download file. Return true (1) and execute |callback| either
    /// asynchronously or in this function to continue or cancel the download.
    /// Return false (0) to proceed with default handling (cancel with Alloy
    /// style, download shelf with Chrome style). Do not keep a reference to
    /// |download_item| outside of this function.
    ///
    on_before_download: proc "c" (self: ^download_handler, browser: ^cef_browser_t, download_item: ^download_item, suggested_name: ^cef_string, callback: ^before_download_callback) -> b32,

    ///
    /// Called when a download's status or progress information has been updated.
    /// This may be called multiple times before and after on_before_download().
    /// Execute |callback| either asynchronously or in this function to cancel the
    /// download if desired. Do not keep a reference to |download_item| outside of
    /// this function.
    ///
    on_download_updated: proc "c" (self: ^download_handler, browser: ^cef_browser_t, download_item: ^download_item, callback: ^download_item_callback),
} 