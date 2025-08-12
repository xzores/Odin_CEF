package odin_cef

import "core:c"

// Forward declarations for types
cef_process_id_t :: enum c.int {}
cef_urlrequest_client_t :: struct {}
cef_urlrequest_t :: struct {}
cef_v8_context_t :: struct {}

cef_frame_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_valid: proc "c" (self: ^cef_frame_t) -> b32,
    undo: proc "c" (self: ^cef_frame_t),
    redo: proc "c" (self: ^cef_frame_t),
    cut: proc "c" (self: ^cef_frame_t),
    copy: proc "c" (self: ^cef_frame_t),
    paste: proc "c" (self: ^cef_frame_t),
    paste_and_match_style: proc "c" (self: ^cef_frame_t),
    del: proc "c" (self: ^cef_frame_t),
    select_all: proc "c" (self: ^cef_frame_t),
    view_source: proc "c" (self: ^cef_frame_t),
    get_source: proc "c" (self: ^cef_frame_t, visitor: ^cef_string_visitor_t),
    get_text: proc "c" (self: ^cef_frame_t, visitor: ^cef_string_visitor_t),
    load_request: proc "c" (self: ^cef_frame_t, request: ^cef_request_t),
    load_url: proc "c" (self: ^cef_frame_t, url: ^cef_string_t),
    execute_java_script: proc "c" (self: ^cef_frame_t, code: ^cef_string_t, script_url: ^cef_string_t, start_line: c.int),
    is_main: proc "c" (self: ^cef_frame_t) -> b32,
    is_focused: proc "c" (self: ^cef_frame_t) -> b32,
    get_name: proc "c" (self: ^cef_frame_t) -> cef_string_userfree_t,
    get_identifier: proc "c" (self: ^cef_frame_t) -> cef_string_userfree_t,
    get_parent: proc "c" (self: ^cef_frame_t) -> ^cef_frame_t,
    get_url: proc "c" (self: ^cef_frame_t) -> cef_string_userfree_t,
    get_browser: proc "c" (self: ^cef_frame_t) -> ^cef_browser_t,
    get_v8_context: proc "c" (self: ^cef_frame_t) -> ^cef_v8_context_t,
    visit_dom: proc "c" (self: ^cef_frame_t, visitor: ^cef_domvisitor_t),
    create_urlrequest: proc "c" (self: ^cef_frame_t, request: ^cef_request_t, client: ^cef_urlrequest_client_t) -> ^cef_urlrequest_t,
    send_process_message: proc "c" (self: ^cef_frame_t, target_process: cef_process_id_t, message: ^cef_process_message_t),
} 