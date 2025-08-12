package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}

// cef_preference_registrar_t :: struct {}

cef_preference_observer_t :: struct {
    base: cef_base_ref_counted_t,
    
    on_preference_changed: proc "c" (self: ^cef_preference_observer_t, name: ^cef_string_t),
}

cef_preference_manager_t :: struct {
    base: cef_base_ref_counted_t,
    
    has_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string_t) -> b32,
    get_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string_t) -> ^cef_value_t,
    get_all_preferences: proc "c" (self: ^cef_preference_manager_t, include_defaults: b32) -> ^cef_dictionary_value_t,
    can_set_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string_t) -> b32,
    set_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string_t, value: ^cef_value_t, error: ^cef_string_t) -> b32,
    clear_preferences: proc "c" (self: ^cef_preference_manager_t, error: ^cef_string_t) -> b32,
}

@(default_calling_convention="c")
foreign lib {
    cef_preference_manager_get_chrome_variations_as_switches :: proc() -> cef_string_list_t ---
    cef_preference_manager_get_chrome_variations_as_strings :: proc() -> cef_string_list_t ---
    cef_preference_manager_get_global :: proc() -> ^cef_preference_manager_t ---
} 