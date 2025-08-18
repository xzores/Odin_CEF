package odin_cef

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

import "core:c"

/// Structure used to represent a browser. When used in the browser process the functions of this structure may be called on any thread unless otherwise
/// indicated in the comments. When used in the render process the functions of
/// this structure may only be called on the main thread.
/// NOTE: This struct is allocated DLL-side.
Browser :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// True if this object is currently valid. This will return false (0) after life_span_handler::on_before_close is called.
	is_valid: proc "system" (self: ^Browser) -> b32,

	/// Returns the browser host object. This function can only be called in the browser process.
	get_host: proc "system" (self: ^Browser) -> ^browser_host,

	/// Returns true (1) if the browser can navigate backwards.
	can_go_back: proc "system" (self: ^Browser) -> b32,

	/// Navigate backwards.
	go_back: proc "system" (self: ^Browser),

	/// Returns true (1) if the browser can navigate forwards.
	can_go_forward: proc "system" (self: ^Browser) -> b32,

	/// Navigate forwards.
	go_forward: proc "system" (self: ^Browser),

	/// Returns true (1) if the browser is currently loading.
	is_loading: proc "system" (self: ^Browser) -> b32,

	/// Reload the current page.
	reload: proc "system" (self: ^Browser),

	/// Reload the current page ignoring any cached data.
	reload_ignore_cache: proc "system" (self: ^Browser),

	/// Stop loading the page.
	stop_load: proc "system" (self: ^Browser),

	/// Returns the globally unique identifier for this browser. This value is also used as the tabId for extension APIs.
	get_identifier: proc "system" (self: ^Browser) -> c.int,

	/// Returns true (1) if this object is pointing to the same handle as |that| object.
	is_same: proc "system" (self: ^Browser, that: ^Browser) -> b32,

	/// Returns true (1) if the browser is a popup.
	is_popup: proc "system" (self: ^Browser) -> b32,

	/// Returns true (1) if a document has been loaded in the browser.
	has_document: proc "system" (self: ^Browser) -> b32,

	/// Returns the main (top-level) frame for the browser.
	get_main_frame: proc "system" (self: ^Browser) -> ^Frame,

	/// Returns the focused frame for the browser.
	get_focused_frame: proc "system" (self: ^Browser) -> ^Frame,

	/// Returns the frame with the specified identifier, or nil if not found.
	get_frame_by_identifier: proc "system" (self: ^Browser, identifier: ^cef_string) -> ^Frame,

	/// Returns the frame with the specified name, or nil if not found.
	get_frame_by_name: proc "system" (self: ^Browser, name: ^cef_string) -> ^Frame,
}

/// Structure used to represent a browser host. Methods are called on the UI thread unless otherwise noted.
/// NOTE: This struct is allocated DLL-side.
///
browser_host :: struct {
	base: base_ref_counted,

	get_browser: proc "system" (self: ^browser_host) -> ^Browser,
	close_browser: proc "system" (self: ^browser_host, force_close: b32),
	try_close_browser: proc "system" (self: ^browser_host) -> b32,
	is_ready_to_be_closed: proc "system" (self: ^browser_host) -> b32,
	set_focus: proc "system" (self: ^browser_host, focus: b32),
	get_window_handle: proc "system" (self: ^browser_host) -> rawptr,
	get_opener_window_handle: proc "system" (self: ^browser_host) -> rawptr,
	get_opener_identifier: proc "system" (self: ^browser_host) -> c.int,
	has_view: proc "system" (self: ^browser_host) -> b32,
	get_client: proc "system" (self: ^browser_host) -> ^Client,
	get_request_context: proc "system" (self: ^browser_host) -> ^Request_context,
	// ... more function pointers as needed ...
}

/// Structure used to visit navigation entries.
/// NOTE: This struct is allocated DLL-side.
///
navigation_entry_visitor :: struct {
	base: base_ref_counted,
	/// Method that will be executed. Do not keep a reference to |entry| outside of this callback. Return true (1) to continue visiting entries or false
	/// (0) to stop. |current| is true (1) if this entry is the currently loaded
	/// navigation entry. |index| is the 0-based index of this entry and |total|
	/// is the total number of entries.
	visit: proc "system" (self: ^navigation_entry_visitor, entry: ^Navigation_entry, current: b32, index: c.int, total: c.int) -> b32,
}

/// Structure used for PDF print callbacks.
/// NOTE: This struct is allocated DLL-side.
///
pdf_print_callback :: struct {
	base: base_ref_counted,
	/// Method that will be executed when the PDF printing has completed. |path| is the output path. |ok| will be true (1) if the printing completed
	/// successfully or false (0) otherwise.
	on_pdf_print_finished: proc "system" (self: ^pdf_print_callback, path: ^cef_string, ok: b32),
}

/// Structure used for image download callbacks.
/// NOTE: This struct is allocated DLL-side.
///
download_image_callback :: struct {
	base: base_ref_counted,
	/// Method that will be executed when the image download has completed. |image_url| is the URL that was downloaded and |http_status_code| is the
	/// resulting HTTP status code. |image| is the resulting image, possibly at
	/// multiple scale factors, or nil if the download failed.
	on_download_image_finished: proc "system" (self: ^download_image_callback, image_url: ^cef_string, http_status_code: c.int, image: ^Image),
} 

@(default_calling_convention="system", link_prefix="cef_", require_results)
foreign lib {
	
	/// Create a new browser using |window_info|; values are copied and any native window is created on the UI thread. If |request_context| is nil the global context is used. Callable from any browser-process thread and non-blocking. Optional |extra_info| is passed to Render_process_handler.on_browser_created in the render process.
	browser_host_create_browser :: proc (window_info: ^Window_info, client: ^Client, url: ^cef_string, settings: ^Browser_settings,
										 extra_info: ^cef_dictionary_value, request_context: ^Request_context,) -> c.int ---

	/// Create a new browser using |window_info| on the browser-process UI thread. If |request_context| is nil the global context is used. Optional |extra_info| is passed to Render_process_handler.on_browser_created in the render process.
	browser_host_create_browser_sync :: proc (window_info: ^Window_info, client: ^Client, url: ^cef_string, settings: ^Browser_settings,	
												extra_info: ^cef_dictionary_value, request_context: ^Request_context) -> ^Browser ---

	/// Returns the browser (if any) with the specified identifier.
	browser_host_get_browser_by_identifier :: proc (browser_id: c.int) -> ^Browser ---
}
