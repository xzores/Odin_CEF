package odin_cef

import "core:c"

// Structure used to represent a download item.
// NOTE: This struct is allocated DLL-side.
Download_item :: struct {
	// Base structure.
	base: base_ref_counted,

	// Returns 1 if this object is valid. Do not call other functions if 0.
	is_valid: proc "c" (self: ^Download_item) -> c.int,

	// Returns 1 if the download is in progress.
	is_in_progress: proc "c" (self: ^Download_item) -> c.int,

	// Returns 1 if the download is complete.
	is_complete: proc "c" (self: ^Download_item) -> c.int,

	// Returns 1 if the download has been canceled.
	is_canceled: proc "c" (self: ^Download_item) -> c.int,

	// Returns 1 if the download has been interrupted.
	is_interrupted: proc "c" (self: ^Download_item) -> c.int,

	// Returns the most recent interrupt reason.
	get_interrupt_reason: proc "c" (self: ^Download_item) -> Download_interrupt_reason,

	// Returns a simple speed estimate in bytes/s.
	get_current_speed: proc "c" (self: ^Download_item) -> c.int64_t,

	// Returns rough percent complete, or -1 if total size is unknown.
	get_percent_complete: proc "c" (self: ^Download_item) -> c.int,

	// Returns total number of bytes.
	get_total_bytes: proc "c" (self: ^Download_item) -> c.int64_t,

	// Returns number of received bytes.
	get_received_bytes: proc "c" (self: ^Download_item) -> c.int64_t,

	// Returns the time that the download started.
	get_start_time: proc "c" (self: ^Download_item) -> Basetime,

	// Returns the time that the download ended.
	get_end_time: proc "c" (self: ^Download_item) -> Basetime,

	// Returns the full path to the downloaded/downloading file.
	// Result must be freed with cef_string_userfree_free().
	get_full_path: proc "c" (self: ^Download_item) -> cef_string_userfree,

	// Returns the unique identifier for this download.
	get_id: proc "c" (self: ^Download_item) -> c.uint32_t,

	// Returns the URL.
	// Result must be freed with cef_string_userfree_free().
	get_url: proc "c" (self: ^Download_item) -> cef_string_userfree,

	// Returns the original URL before any redirections.
	// Result must be freed with cef_string_userfree_free().
	get_original_url: proc "c" (self: ^Download_item) -> cef_string_userfree,

	// Returns the suggested file name.
	// Result must be freed with cef_string_userfree_free().
	get_suggested_file_name: proc "c" (self: ^Download_item) -> cef_string_userfree,

	// Returns the content disposition.
	// Result must be freed with cef_string_userfree_free().
	get_content_disposition: proc "c" (self: ^Download_item) -> cef_string_userfree,

	// Returns the mime type.
	// Result must be freed with cef_string_userfree_free().
	get_mime_type: proc "c" (self: ^Download_item) -> cef_string_userfree,
}
