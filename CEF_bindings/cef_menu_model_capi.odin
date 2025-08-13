package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// Forward declarations for enums and types
// cef_color_t :: enum c.int {}
// cef_menu_model_delegate_t :: struct {}
cef_menu_item_type_t :: enum c.int {}
cef_menu_color_type_t :: enum c.int {}

cef_menu_model_t :: struct {
    base: cef_base_ref_counted_t,
    
    is_sub_menu: proc "c" (self: ^cef_menu_model_t) -> b32,
    clear: proc "c" (self: ^cef_menu_model_t) -> b32,
    get_count: proc "c" (self: ^cef_menu_model_t) -> c.size_t,
    add_separator: proc "c" (self: ^cef_menu_model_t) -> b32,
    add_item: proc "c" (self: ^cef_menu_model_t, command_id: c.int, label: ^cef_string) -> b32,
    add_check_item: proc "c" (self: ^cef_menu_model_t, command_id: c.int, label: ^cef_string) -> b32,
    add_radio_item: proc "c" (self: ^cef_menu_model_t, command_id: c.int, label: ^cef_string, group_id: c.int) -> b32,
    add_sub_menu: proc "c" (self: ^cef_menu_model_t, command_id: c.int, label: ^cef_string) -> ^cef_menu_model_t,
    insert_separator_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    insert_item_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, command_id: c.int, label: ^cef_string) -> b32,
    insert_check_item_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, command_id: c.int, label: ^cef_string) -> b32,
    insert_radio_item_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, command_id: c.int, label: ^cef_string, group_id: c.int) -> b32,
    insert_sub_menu_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, command_id: c.int, label: ^cef_string) -> ^cef_menu_model_t,
    remove: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> b32,
    remove_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    get_index_of: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> c.int,
    get_command_id_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> c.int,
    set_command_id_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, command_id: c.int) -> b32,
    get_label: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> cef_string_userfree,
    get_label_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> cef_string_userfree,
    set_label: proc "c" (self: ^cef_menu_model_t, command_id: c.int, label: ^cef_string) -> b32,
    set_label_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, label: ^cef_string) -> b32,
    get_type: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> cef_menu_item_type_t,
    get_type_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> cef_menu_item_type_t,
    get_group_id: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> c.int,
    get_group_id_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> c.int,
    set_group_id: proc "c" (self: ^cef_menu_model_t, command_id: c.int, group_id: c.int) -> b32,
    set_group_id_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, group_id: c.int) -> b32,
    get_sub_menu: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> ^cef_menu_model_t,
    get_sub_menu_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> ^cef_menu_model_t,
    is_visible: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> b32,
    is_visible_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    set_visible: proc "c" (self: ^cef_menu_model_t, command_id: c.int, visible: b32) -> b32,
    set_visible_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, visible: b32) -> b32,
    is_enabled: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> b32,
    is_enabled_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    set_enabled: proc "c" (self: ^cef_menu_model_t, command_id: c.int, enabled: b32) -> b32,
    set_enabled_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, enabled: b32) -> b32,
    is_checked: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> b32,
    is_checked_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    set_checked: proc "c" (self: ^cef_menu_model_t, command_id: c.int, checked: b32) -> b32,
    set_checked_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, checked: b32) -> b32,
    has_accelerator: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> b32,
    has_accelerator_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    set_accelerator: proc "c" (self: ^cef_menu_model_t, command_id: c.int, key_code: c.int, shift_pressed: b32, ctrl_pressed: b32, alt_pressed: b32) -> b32,
    set_accelerator_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, key_code: c.int, shift_pressed: b32, ctrl_pressed: b32, alt_pressed: b32) -> b32,
    remove_accelerator: proc "c" (self: ^cef_menu_model_t, command_id: c.int) -> b32,
    remove_accelerator_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t) -> b32,
    get_accelerator: proc "c" (self: ^cef_menu_model_t, command_id: c.int, key_code: ^c.int, shift_pressed: ^b32, ctrl_pressed: ^b32, alt_pressed: ^b32) -> b32,
    get_accelerator_at: proc "c" (self: ^cef_menu_model_t, index: c.size_t, key_code: ^c.int, shift_pressed: ^b32, ctrl_pressed: ^b32, alt_pressed: ^b32) -> b32,
    set_color: proc "c" (self: ^cef_menu_model_t, command_id: c.int, color_type: cef_menu_color_type_t, color: cef_color_t) -> b32,
    set_color_at: proc "c" (self: ^cef_menu_model_t, index: c.int, color_type: cef_menu_color_type_t, color: cef_color_t) -> b32,
    get_color: proc "c" (self: ^cef_menu_model_t, command_id: c.int, color_type: cef_menu_color_type_t, color: ^cef_color_t) -> b32,
    get_color_at: proc "c" (self: ^cef_menu_model_t, index: c.int, color_type: cef_menu_color_type_t, color: ^cef_color_t) -> b32,
    set_font_list: proc "c" (self: ^cef_menu_model_t, command_id: c.int, font_list: ^cef_string) -> b32,
    set_font_list_at: proc "c" (self: ^cef_menu_model_t, index: c.int, font_list: ^cef_string) -> b32,
}

@(default_calling_convention="c")
foreign lib {
    cef_menu_model_create :: proc(delegate: ^cef_menu_model_delegate_t) -> ^cef_menu_model_t ---
} 