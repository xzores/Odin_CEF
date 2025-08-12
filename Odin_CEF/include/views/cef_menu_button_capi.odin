package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

cef_menu_button_t :: struct {
    base: cef_label_button_t,
    
    as_menu_button: proc "c" (self: ^cef_menu_button_t) -> ^cef_menu_button_t,
    show_menu: proc "c" (self: ^cef_menu_button_t, menu_model: ^cef_menu_model_t, screen_point: ^cef_point_t, anchor_position: cef_menu_anchor_position_t),
    trigger_menu: proc "c" (self: ^cef_menu_button_t),
    set_ink_drop_enabled: proc "c" (self: ^cef_menu_button_t, enabled: b32),
    set_focus_painter: proc "c" (self: ^cef_menu_button_t, painter: ^cef_view_t),
    set_horizontal_alignment: proc "c" (self: ^cef_menu_button_t, alignment: cef_horizontal_alignment_t),
    set_minimum_size: proc "c" (self: ^cef_menu_button_t, size: ^cef_size_t),
    set_maximum_size: proc "c" (self: ^cef_menu_button_t, size: ^cef_size_t),
    set_is_focusable: proc "c" (self: ^cef_menu_button_t, focusable: b32),
    set_accessibility_focusable: proc "c" (self: ^cef_menu_button_t, focusable: b32),
    set_draw_strings_disabled: proc "c" (self: ^cef_menu_button_t, disabled: b32),
} 