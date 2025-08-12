package odin_cef

import "core:c"

// Forward declarations for enums
cef_download_interrupt_reason_t :: enum c.int {}

cef_download_item_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_valid: proc "c" (self: ^cef_download_item_t) -> b32,
    is_in_progress: proc "c" (self: ^cef_download_item_t) -> b32,
    is_complete: proc "c" (self: ^cef_download_item_t) -> b32,
    is_canceled: proc "c" (self: ^cef_download_item_t) -> b32,
    is_interrupted: proc "c" (self: ^cef_download_item_t) -> b32,
    get_interrupt_reason: proc "c" (self: ^cef_download_item_t) -> cef_download_interrupt_reason_t,
    get_current_speed: proc "c" (self: ^cef_download_item_t) -> i64,
    get_percent_complete: proc "c" (self: ^cef_download_item_t) -> c.int,
    get_total_bytes: proc "c" (self: ^cef_download_item_t) -> i64,
    get_received_bytes: proc "c" (self: ^cef_download_item_t) -> i64,
    get_start_time: proc "c" (self: ^cef_download_item_t) -> cef_basetime_t,
    get_end_time: proc "c" (self: ^cef_download_item_t) -> cef_basetime_t,
    get_full_path: proc "c" (self: ^cef_download_item_t) -> cef_string_userfree_t,
    get_id: proc "c" (self: ^cef_download_item_t) -> u32,
    get_url: proc "c" (self: ^cef_download_item_t) -> cef_string_userfree_t,
    get_original_url: proc "c" (self: ^cef_download_item_t) -> cef_string_userfree_t,
    get_suggested_file_name: proc "c" (self: ^cef_download_item_t) -> cef_string_userfree_t,
    get_content_disposition: proc "c" (self: ^cef_download_item_t) -> cef_string_userfree_t,
    get_mime_type: proc "c" (self: ^cef_download_item_t) -> cef_string_userfree_t,
} 