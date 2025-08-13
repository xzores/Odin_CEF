package odin_cef

import "core:c"

// Forward declarations for enums
cef_download_interrupt_reason_t :: enum c.int {}

Download_item :: struct {
    base: base_ref_counted,
    
    is_valid: proc "c" (self: ^Download_item) -> b32,
    is_in_progress: proc "c" (self: ^Download_item) -> b32,
    is_complete: proc "c" (self: ^Download_item) -> b32,
    is_canceled: proc "c" (self: ^Download_item) -> b32,
    is_interrupted: proc "c" (self: ^Download_item) -> b32,
    get_interrupt_reason: proc "c" (self: ^Download_item) -> cef_download_interrupt_reason_t,
    get_current_speed: proc "c" (self: ^Download_item) -> i64,
    get_percent_complete: proc "c" (self: ^Download_item) -> c.int,
    get_total_bytes: proc "c" (self: ^Download_item) -> i64,
    get_received_bytes: proc "c" (self: ^Download_item) -> i64,
    get_start_time: proc "c" (self: ^Download_item) -> cef_basetime_t,
    get_end_time: proc "c" (self: ^Download_item) -> cef_basetime_t,
    get_full_path: proc "c" (self: ^Download_item) -> cef_string_userfree,
    get_id: proc "c" (self: ^Download_item) -> u32,
    get_url: proc "c" (self: ^Download_item) -> cef_string_userfree,
    get_original_url: proc "c" (self: ^Download_item) -> cef_string_userfree,
    get_suggested_file_name: proc "c" (self: ^Download_item) -> cef_string_userfree,
    get_content_disposition: proc "c" (self: ^Download_item) -> cef_string_userfree,
    get_mime_type: proc "c" (self: ^Download_item) -> cef_string_userfree,
} 