package odin_cef

import "core:c"

// Forward declarations for enums and types
cef_errorcode_t :: enum c.int {}
cef_content_setting_types_t :: enum c.int {}
cef_content_setting_values_t :: enum c.int {}
cef_color_variant_t :: enum c.int {}
cef_color_t :: enum c.int {}
cef_request_context_settings_t :: struct {}

cef_resolve_callback_t :: struct {
    base: cef_base_ref_counted_t,
    on_resolve_completed: proc "c" (self: ^cef_resolve_callback_t, result: cef_errorcode_t, resolved_ips: cef_string_list_t),
}

cef_setting_observer_t :: struct {
    base: cef_base_ref_counted_t,
    on_setting_changed: proc "c" (self: ^cef_setting_observer_t, requesting_url: ^cef_string_t, top_level_url: ^cef_string_t, content_type: cef_content_setting_types_t),
}

cef_request_context_t :: struct {
    base: cef_preference_manager_t,
    is_same: proc "c" (self: ^cef_request_context_t, other: ^cef_request_context_t) -> b32,
    is_sharing_with: proc "c" (self: ^cef_request_context_t, other: ^cef_request_context_t) -> b32,
    is_global: proc "c" (self: ^cef_request_context_t) -> b32,
    get_handler: proc "c" (self: ^cef_request_context_t) -> ^cef_request_context_handler_t,
    get_cache_path: proc "c" (self: ^cef_request_context_t) -> cef_string_userfree_t,
    get_cookie_manager: proc "c" (self: ^cef_request_context_t, callback: ^cef_completion_callback_t) -> ^cef_cookie_manager_t,
    register_scheme_handler_factory: proc "c" (self: ^cef_request_context_t, scheme_name: ^cef_string_t, domain_name: ^cef_string_t, factory: ^cef_scheme_handler_factory_t) -> b32,
    clear_scheme_handler_factories: proc "c" (self: ^cef_request_context_t) -> b32,
    clear_certificate_exceptions: proc "c" (self: ^cef_request_context_t, callback: ^cef_completion_callback_t),
    clear_http_auth_credentials: proc "c" (self: ^cef_request_context_t, callback: ^cef_completion_callback_t),
    close_all_connections: proc "c" (self: ^cef_request_context_t, callback: ^cef_completion_callback_t),
    resolve_host: proc "c" (self: ^cef_request_context_t, origin: ^cef_string_t, callback: ^cef_resolve_callback_t),
    get_media_router: proc "c" (self: ^cef_request_context_t, callback: ^cef_completion_callback_t) -> ^cef_media_router_t,
    get_website_setting: proc "c" (self: ^cef_request_context_t, requesting_url: ^cef_string_t, top_level_url: ^cef_string_t, content_type: cef_content_setting_types_t) -> ^cef_value_t,
    set_website_setting: proc "c" (self: ^cef_request_context_t, requesting_url: ^cef_string_t, top_level_url: ^cef_string_t, content_type: cef_content_setting_types_t, value: ^cef_value_t),
    get_content_setting: proc "c" (self: ^cef_request_context_t, requesting_url: ^cef_string_t, top_level_url: ^cef_string_t, content_type: cef_content_setting_types_t) -> cef_content_setting_values_t,
    set_content_setting: proc "c" (self: ^cef_request_context_t, requesting_url: ^cef_string_t, top_level_url: ^cef_string_t, content_type: cef_content_setting_types_t, value: cef_content_setting_values_t),
    set_chrome_color_scheme: proc "c" (self: ^cef_request_context_t, variant: cef_color_variant_t, user_color: cef_color_t),
    get_chrome_color_scheme_mode: proc "c" (self: ^cef_request_context_t) -> cef_color_variant_t,
    get_chrome_color_scheme_color: proc "c" (self: ^cef_request_context_t) -> cef_color_t,
    get_chrome_color_scheme_variant: proc "c" (self: ^cef_request_context_t) -> cef_color_variant_t,
    add_setting_observer: proc "c" (self: ^cef_request_context_t, observer: ^cef_setting_observer_t) -> ^cef_registration_t,
} 