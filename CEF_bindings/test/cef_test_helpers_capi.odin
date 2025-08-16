package odin_test_cef

import "core:c"
import "../common"

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

// Function declarations
cef_execute_java_script_with_user_gesture_for_tests :: proc "system" (frame: ^Frame, javascript: ^common.cef_string)
cef_set_data_directory_for_tests :: proc "system" (dir: ^common.cef_string)
cef_is_feature_enabled_for_tests :: proc "system" (feature_name: ^common.cef_string) -> c.int
foreign lib {
	cef_test_runner_get_global :: proc() -> ^cef_test_runner_t ---
} 