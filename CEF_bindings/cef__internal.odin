package odin_cef

import "internal"

string_list :: internal.string_list;
string_map :: internal.string_map;
string_multimap :: internal.string_multimap;

audio_parameters :: internal.audio_parameters 
browser_settings :: internal.cef_browser_settings

log_severity :: internal.log_severity;

// Geometry types
point :: internal.point;
rect :: internal.rect;
size :: internal.size;
insets :: internal.insets;

// Legacy type aliases for compatibility
cef_point_t :: internal.point;
cef_rect :: internal.rect;
cef_size :: internal.size;
cef_size_t :: internal.size;

// String types
cef_string :: internal.cef_string;
cef_string_userfree :: internal.cef_string_userfree;

// Thread types
cef_thread_id :: internal.thread_id;

// Process types
process_id :: internal.process_id;

// Time types  
cef_basetime :: internal.base_time;

// Platform types - cursor_handle is defined in internal/cef_types.odin
cursor_handle :: internal.cursor_handle;

// URL request types
url_request :: urlrequest;
url_request_client :: urlrequest_client;

// DOM types  
dom_visitor :: cef_domvisitor_t;

// Process message types
process_message :: cef_process_message_t;

// Response types
response :: cef_response_t;

// Shared memory types
cef_shared_memory_region_t :: shared_memory_region;

// String container types (legacy names)
cef_string_multimap_t :: string_multimap;

// Value types
cef_dictionary_value :: cef_dictionary_value_t;

// Drag and drop types
cef_drag_operations_mask :: internal.drag_operations_mask;

// Focus types
cef_focus_source :: internal.focus_source;

// URL request types
cef_urlrequest_status :: internal.urlrequest_status;

// Key event types
cef_key_event :: internal.key_event;

// Platform event handle
cef_event_handle :: internal.event_handle;

// Permission types
cef_permission_request_result :: internal.permission_request_result;