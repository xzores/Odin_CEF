package main

import "core:reflect"
import "core:fmt"
import "core:c"
import "core:log"
import "core:mem"
import "core:os"
import "core:dynlib"
import win32 "core:sys/windows"
import "core:unicode/utf16"


check_win32_error :: proc (err_msg : string, loc := #caller_location) {
	error_msg_id := win32.GetLastError()

	if error_msg_id != 0 {
		messageBuffer := make([]u16, 1028);

		win32.FormatMessageW(win32.FORMAT_MESSAGE_FROM_SYSTEM | win32.FORMAT_MESSAGE_IGNORE_INSERTS,
		nil, error_msg_id, win32.MAKELANGID(win32.LANG_NEUTRAL, win32.SUBLANG_DEFAULT), raw_data(messageBuffer), auto_cast len(messageBuffer), nil);

		msg_u8 := make([]u8, 2*1028);

		utf16.decode_to_utf8(msg_u8, messageBuffer);

		log.errorf("win32 API call error : %v", string(msg_u8));
		fmt.panicf("%v, error code was %v\nError message : %v", err_msg, error_msg_id, string(msg_u8), loc = loc);
	}
}