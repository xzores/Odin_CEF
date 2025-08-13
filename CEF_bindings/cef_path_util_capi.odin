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
cef_path_key_t :: enum c.int {}

@(default_calling_convention="c")
foreign lib {
    cef_get_path :: proc(key: cef_path_key_t, path: ^cef_string) -> b32 ---
} 