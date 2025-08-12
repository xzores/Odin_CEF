package odin_cef

import "core:c"

// Forward declarations for enums and types
cef_event_flags_t :: enum c.int {}
cef_quick_menu_edit_state_flags_t :: enum c.int {}
cef_context_menu_type_flags_t :: enum c.int {}
cef_context_menu_media_type_t :: enum c.int {}
cef_context_menu_media_state_flags_t :: enum c.int {}
cef_context_menu_edit_state_flags_t :: enum c.int {}
// cef_point_t :: struct {}
// cef_size_t :: struct {}

cef_run_context_menu_callback_t :: struct {
    base: cef_base_ref_counted_t,
    cont: proc "c" (self: ^cef_run_context_menu_callback_t, command_id: c.int, event_flags: cef_event_flags_t),
    cancel: proc "c" (self: ^cef_run_context_menu_callback_t),
}

cef_run_quick_menu_callback_t :: struct {
    base: cef_base_ref_counted_t,
    cont: proc "c" (self: ^cef_run_quick_menu_callback_t, command_id: c.int, event_flags: cef_event_flags_t),
    cancel: proc "c" (self: ^cef_run_quick_menu_callback_t),
}

cef_context_menu_handler_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_before_context_menu: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t, params: ^cef_context_menu_params_t, model: ^cef_menu_model_t),
    run_context_menu: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t, params: ^cef_context_menu_params_t, model: ^cef_menu_model_t, callback: ^cef_run_context_menu_callback_t) -> b32,
    on_context_menu_command: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t, params: ^cef_context_menu_params_t, command_id: c.int, event_flags: cef_event_flags_t) -> b32,
    on_context_menu_dismissed: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t),
    run_quick_menu: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t, location: ^cef_point_t, size: ^cef_size_t, edit_state_flags: cef_quick_menu_edit_state_flags_t, callback: ^cef_run_quick_menu_callback_t) -> b32,
    on_quick_menu_command: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t, command_id: c.int, event_flags: cef_event_flags_t) -> b32,
    on_quick_menu_dismissed: proc "c" (self: ^cef_context_menu_handler_t, browser: ^cef_browser_t, frame: ^cef_frame_t),
}

cef_context_menu_params_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_xcoord: proc "c" (self: ^cef_context_menu_params_t) -> c.int,
    get_ycoord: proc "c" (self: ^cef_context_menu_params_t) -> c.int,
    get_type_flags: proc "c" (self: ^cef_context_menu_params_t) -> cef_context_menu_type_flags_t,
    get_link_url: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_unfiltered_link_url: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_source_url: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    has_image_contents: proc "c" (self: ^cef_context_menu_params_t) -> b32,
    get_title_text: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_page_url: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_frame_url: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_frame_charset: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_media_type: proc "c" (self: ^cef_context_menu_params_t) -> cef_context_menu_media_type_t,
    get_media_state_flags: proc "c" (self: ^cef_context_menu_params_t) -> cef_context_menu_media_state_flags_t,
    get_selection_text: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_misspelled_word: proc "c" (self: ^cef_context_menu_params_t) -> cef_string_userfree_t,
    get_dictionary_suggestions: proc "c" (self: ^cef_context_menu_params_t, suggestions: cef_string_list_t) -> b32,
    is_editable: proc "c" (self: ^cef_context_menu_params_t) -> b32,
    is_spell_check_enabled: proc "c" (self: ^cef_context_menu_params_t) -> b32,
    get_edit_state_flags: proc "c" (self: ^cef_context_menu_params_t) -> cef_context_menu_edit_state_flags_t,
    is_custom_menu: proc "c" (self: ^cef_context_menu_params_t) -> b32,
} 