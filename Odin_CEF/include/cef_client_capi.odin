package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// audio_handler is defined in cef_audio_handler_capi.odin
// command_handler is defined in cef_command_handler_capi.odin
// context_menu_handler is defined in cef_context_menu_handler_capi.odin
// dialog_handler is defined in cef_dialog_handler_capi.odin
// display_handler is defined in cef_display_handler_capi.odin
// download_handler is defined in cef_download_handler_capi.odin
// drag_handler is defined in cef_drag_handler_capi.odin
// find_handler is defined in cef_find_handler_capi.odin
// focus_handler is defined in cef_focus_handler_capi.odin
// frame_handler is defined in cef_frame_handler_capi.odin
// jsdialog_handler is defined in cef_jsdialog_handler_capi.odin
// keyboard_handler is defined in cef_keyboard_handler_capi.odin
// life_span_handler is defined in cef_life_span_handler_capi.odin
// load_handler is defined in cef_load_handler_capi.odin
// permission_handler is defined in cef_permission_handler_capi.odin
// print_handler is defined in cef_print_handler_capi.odin
// render_handler is defined in cef_render_handler_capi.odin
// request_handler is defined in cef_request_handler_capi.odin
// browser is defined in cef_browser_capi.odin
// frame is defined in cef_frame_capi.odin
// process_message is defined in cef_process_message_capi.odin
// cef_process_id is defined in cef_types_capi.odin

///
/// Implement this structure to provide handler implementations.
///
/// NOTE: This struct is allocated client-side.
///
cef_client_t :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Return the handler for audio rendering events.
    ///
    get_audio_handler: proc "c" (self: ^cef_client_t) -> ^audio_handler,

    ///
    /// Return the handler for commands. If no handler is provided the default
    /// implementation will be used.
    ///
    get_command_handler: proc "c" (self: ^cef_client_t) -> ^command_handler,

    ///
    /// Return the handler for context menus. If no handler is provided the
    /// default implementation will be used.
    ///
    get_context_menu_handler: proc "c" (self: ^cef_client_t) -> ^context_menu_handler,

    ///
    /// Return the handler for dialogs. If no handler is provided the default
    /// implementation will be used.
    ///
    get_dialog_handler: proc "c" (self: ^cef_client_t) -> ^dialog_handler,

    ///
    /// Return the handler for browser display state events.
    ///
    get_display_handler: proc "c" (self: ^cef_client_t) -> ^display_handler,

    ///
    /// Return the handler for download events. If no handler is returned
    /// downloads will not be allowed.
    ///
    get_download_handler: proc "c" (self: ^cef_client_t) -> ^download_handler,

    ///
    /// Return the handler for drag events.
    ///
    get_drag_handler: proc "c" (self: ^cef_client_t) -> ^drag_handler,

    ///
    /// Return the handler for find result events.
    ///
    get_find_handler: proc "c" (self: ^cef_client_t) -> ^find_handler,

    ///
    /// Return the handler for focus events.
    ///
    get_focus_handler: proc "c" (self: ^cef_client_t) -> ^focus_handler,

    ///
    /// Return the handler for events related to frame lifespan. This
    /// function will be called once during browser creation and the result
    /// will be cached for performance reasons.
    ///
    get_frame_handler: proc "c" (self: ^cef_client_t) -> ^frame_handler,

    ///
    /// Return the handler for permission requests.
    ///
    get_permission_handler: proc "c" (self: ^cef_client_t) -> ^permission_handler,

    ///
    /// Return the handler for JavaScript dialogs. If no handler is provided the
    /// default implementation will be used.
    ///
    get_jsdialog_handler: proc "c" (self: ^cef_client_t) -> ^jsdialog_handler,

    ///
    /// Return the handler for keyboard events.
    ///
    get_keyboard_handler: proc "c" (self: ^cef_client_t) -> ^keyboard_handler,

    ///
    /// Return the handler for browser life span events.
    ///
    get_life_span_handler: proc "c" (self: ^cef_client_t) -> ^cef_life_span_handler_t,

    ///
    /// Return the handler for browser load status events.
    ///
    get_load_handler: proc "c" (self: ^cef_client_t) -> ^load_handler,

    ///
    /// Return the handler for printing on Linux. If a print handler is not
    /// provided then printing will not be supported on the Linux platform.
    ///
    get_print_handler: proc "c" (self: ^cef_client_t) -> ^print_handler,

    ///
    /// Return the handler for off-screen rendering events.
    ///
    get_render_handler: proc "c" (self: ^cef_client_t) -> ^render_handler,

    ///
    /// Return the handler for browser request events.
    ///
    get_request_handler: proc "c" (self: ^cef_client_t) -> ^request_handler,

    ///
    /// Called when a new message is received from a different process. Return
    /// true (1) if the message was handled or false (0) otherwise. Do not
    /// keep a reference to |message| outside of this callback.
    ///
    on_process_message_received: proc "c" (self: ^cef_client_t, browser: ^cef_browser_t, frame: ^cef_frame_t, source_process: cef_process_id, message: ^process_message) -> b32,
} 