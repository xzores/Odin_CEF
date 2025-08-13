package cef_internal

import "core:c"

when ODIN_OS == .Windows {
	platform_thread_id :: c.DWORD
	platform_thread_handle :: c.DWORD
	INVALID_PLATFORM_THREAD_ID: u32 : 0
	INVALID_PLATFORM_THREAD_HANDLE: u32 : 0
} else when ODIN_OS == .Linux || ODIN_OS == .Darwin {
	platform_thread_id :: c.pid_t
	platform_thread_handle :: c.pthread_t
	INVALID_PLATFORM_THREAD_ID: c.int : 0
	INVALID_PLATFORM_THREAD_HANDLE: c.pthread_t : 0
}

@(default_calling_convention="c", link_prefix="cef_", require_results)
foreign lib {
	///
	/// Returns the current platform thread ID.
	///
	get_current_platform_thread_id :: proc () -> platform_thread_id ---

	///
	/// Returns the current platform thread handle.
	///
	get_current_platform_thread_handle :: proc () -> platform_thread_handle ---
}
