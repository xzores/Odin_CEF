package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for types
cef_urlparts_t :: struct {}
cef_uri_unescape_rule_t :: enum c.int {}
cef_json_parser_options_t :: enum c.int {}
cef_json_writer_options_t :: enum c.int {}

@(default_calling_convention="c")
foreign lib {
    cef_resolve_url :: proc(base_url: ^cef_string, relative_url: ^cef_string, resolved_url: ^cef_string) -> b32 ---
    cef_parse_url :: proc(url: ^cef_string, parts: ^cef_urlparts_t) -> b32 ---
    cef_create_url :: proc(parts: ^cef_urlparts_t, url: ^cef_string) -> b32 ---
    cef_format_url_for_security_display :: proc(origin_url: ^cef_string) -> cef_string_userfree ---
    cef_get_mime_type :: proc(extension: ^cef_string) -> cef_string_userfree ---
    cef_get_extensions_for_mime_type :: proc(mime_type: ^cef_string, extensions: string_list) ---
    cef_base64_encode :: proc(data: rawptr, data_size: c.size_t) -> cef_string_userfree ---
    cef_base64_decode :: proc(data: ^cef_string) -> ^cef_binary_value_t ---
    cef_uriencode :: proc(text: ^cef_string, use_plus: b32) -> cef_string_userfree ---
    cef_uridecode :: proc(text: ^cef_string, convert_to_utf8: b32, unescape_rule: cef_uri_unescape_rule_t) -> cef_string_userfree ---
    cef_parse_json :: proc(json_string: ^cef_string, options: cef_json_parser_options_t) -> ^cef_value_t ---
    cef_parse_json_buffer :: proc(json: rawptr, json_size: c.size_t, options: cef_json_parser_options_t) -> ^cef_value_t ---
    cef_parse_jsonand_return_error :: proc(json_string: ^cef_string, options: cef_json_parser_options_t, error_msg_out: ^cef_string) -> ^cef_value_t ---
    cef_write_json :: proc(node: ^cef_value_t, options: cef_json_writer_options_t) -> cef_string_userfree ---
} 