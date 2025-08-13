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
    base: base_ref_counted,
    
    on_preference_changed: proc "c" (self: ^cef_preference_observer_t, name: ^cef_string),
}

cef_preference_manager_t :: struct {
    base: base_ref_counted,
    
    has_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string) -> b32,
    get_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string) -> ^cef_value,
    get_all_preferences: proc "c" (self: ^cef_preference_manager_t, include_defaults: b32) -> ^cef_dictionary_value,
    can_set_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string) -> b32,
    set_preference: proc "c" (self: ^cef_preference_manager_t, name: ^cef_string, value: ^cef_value, error: ^cef_string) -> b32,
    clear_preferences: proc "c" (self: ^cef_preference_manager_t, error: ^cef_string) -> b32,
}

@(default_calling_convention="c")
foreign lib {
    cef_preference_manager_get_chrome_variations_as_switches :: proc() -> string_list ---
    cef_preference_manager_get_chrome_variations_as_strings :: proc() -> string_list ---
    cef_preference_manager_get_global :: proc() -> ^cef_preference_manager_t ---
} 