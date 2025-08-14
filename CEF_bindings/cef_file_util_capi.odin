package odin_cef

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

@(default_calling_convention="c")
foreign lib {
	cef_create_directory :: proc(full_path: ^cef_string) -> b32 ---
	cef_get_temp_directory :: proc(temp_dir: ^cef_string) -> b32 ---
	cef_create_new_temp_directory :: proc(prefix: ^cef_string, new_temp_path: ^cef_string) -> b32 ---
	cef_create_temp_directory_in_directory :: proc(base_dir: ^cef_string, prefix: ^cef_string, new_dir: ^cef_string) -> b32 ---
	cef_directory_exists :: proc(path: ^cef_string) -> b32 ---
	cef_delete_file :: proc(path: ^cef_string, recursive: b32) -> b32 ---
	cef_zip_directory :: proc(src_dir: ^cef_string, dest_file: ^cef_string, include_hidden_files: b32) -> b32 ---
	cef_load_crlsets_file :: proc(path: ^cef_string) ---
} 