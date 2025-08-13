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
cef_button_delegate_t :: struct {}

cef_button_t :: struct {
    base: cef_view_t,
    
    as_button: proc "c" (self: ^cef_button_t) -> ^cef_button_t,
    set_state: proc "c" (self: ^cef_button_t, state: cef_button_state_t),
    get_state: proc "c" (self: ^cef_button_t) -> cef_button_state_t,
    set_ink_drop_enabled: proc "c" (self: ^cef_button_t, enabled: b32),
    set_text: proc "c" (self: ^cef_button_t, text: ^cef_string),
    get_text: proc "c" (self: ^cef_button_t) -> cef_string_userfree,
    set_text_color: proc "c" (self: ^cef_button_t, for_state: cef_button_state_t, color: cef_color_t),
    set_enabled_text_colors: proc "c" (self: ^cef_button_t, disabled: cef_color_t, enabled: cef_color_t),
    set_text_color_disabled: proc "c" (self: ^cef_button_t, color: cef_color_t),
    set_text_color_enabled: proc "c" (self: ^cef_button_t, color: cef_color_t),
    set_background_color: proc "c" (self: ^cef_button_t, for_state: cef_button_state_t, color: cef_color_t),
    set_enabled_background_colors: proc "c" (self: ^cef_button_t, disabled: cef_color_t, enabled: cef_color_t),
    set_background_color_disabled: proc "c" (self: ^cef_button_t, color: cef_color_t),
    set_background_color_enabled: proc "c" (self: ^cef_button_t, color: cef_color_t),
    get_text_color: proc "c" (self: ^cef_button_t, for_state: cef_button_state_t) -> cef_color_t,
    get_background_color: proc "c" (self: ^cef_button_t, for_state: cef_button_state_t) -> cef_color_t,
    set_font_list: proc "c" (self: ^cef_button_t, font_list: ^cef_string),
    set_horizontal_alignment: proc "c" (self: ^cef_button_t, alignment: cef_horizontal_alignment_t),
    set_minimum_size: proc "c" (self: ^cef_button_t, size: ^cef_size_t),
    set_maximum_size: proc "c" (self: ^cef_button_t, size: ^cef_size_t),
    set_is_focusable: proc "c" (self: ^cef_button_t, focusable: b32),
    set_accessibility_focusable: proc "c" (self: ^cef_button_t, focusable: b32),
    set_draw_strings_disabled: proc "c" (self: ^cef_button_t, disabled: b32),
    set_button_text: proc "c" (self: ^cef_button_t, text: ^cef_string),
    get_button_text: proc "c" (self: ^cef_button_t) -> cef_string_userfree,
    set_button_state: proc "c" (self: ^cef_button_t, state: cef_button_state_t),
    get_button_state: proc "c" (self: ^cef_button_t) -> cef_button_state_t,
    set_ink_drop_enabled: proc "c" (self: ^cef_button_t, enabled: b32),
} 