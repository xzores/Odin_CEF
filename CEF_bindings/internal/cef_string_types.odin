package cef_internal;

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

string_wide :: struct {
	str : [^]c.wchar_t,
	length : c.size_t,
	dtor: proc "c" (str: [^]c.wchar_t),
};

string_utf8 :: struct {
	str : [^]c.char,
	length : c.size_t,
	dtor : proc "c" (str : [^]c.char),
};

string_utf16 :: struct {
	str : [^]u16,
	length : c.size_t,
	dtor : proc "c" (str : [^]u16),
};

/// It is sometimes necessary for the system to allocate string structures with
/// the expectation that the user will free them. The userfree types act as a
/// hint that the user is responsible for freeing the structure.
cef_string_userfree_wide_t	:: ^string_wide
cef_string_userfree_utf8_t	:: ^string_utf8
cef_string_userfree_utf16_t :: ^string_utf16

// CEF is built with UTF16 as default, so cef_string_userfree maps to UTF16
cef_string_userfree :: cef_string_userfree_utf16_t

// CEF is built with UTF16 as default, so cef_string maps to UTF16
cef_string :: string_utf16

/// These functions set string values. If |copy| is true (1) the value will be copied instead of referenced. It is up to the user to properly manage
/// the lifespan of references.
///
@(default_calling_convention="c", link_prefix="cef_", require_results)
foreign lib {
	cef_string_wide_set :: proc (src : [^]c.wchar_t, src_len : c.size_t, output : ^string_wide, copy : c.int) -> c.int ---
	cef_string_utf8_set	:: proc (src: [^]c.char,	 src_len: c.size_t, output: ^string_utf8,	copy: c.int) -> c.int ---
	cef_string_utf16_set :: proc (src: [^]u16, src_len: c.size_t, output: ^string_utf16, copy: c.int) -> c.int ---

	/// These functions clear string values. The structure itself is not freed.
	cef_string_wide_clear	:: proc (str: ^string_wide) ---
	cef_string_utf8_clear	:: proc (str: ^string_utf8) ---
	cef_string_utf16_clear :: proc (str: ^string_utf16) ---

	/// These functions compare two string values with the same results as strcmp().
	cef_string_wide_cmp	:: proc (str1: ^string_wide,	str2: ^string_wide)	 -> c.int ---
	cef_string_utf8_cmp	:: proc (str1: ^string_utf8,	str2: ^string_utf8)	 -> c.int ---
	cef_string_utf16_cmp :: proc (str1: ^string_utf16, str2: ^string_utf16)	-> c.int ---

	/// These functions convert between UTF-8, -16, and -32 strings. They are potentially slow so unnecessary conversions should be avoided. The best
	/// possible result will always be written to |output| with the boolean return
	/// value indicating whether the conversion is 100% valid.
	cef_string_wide_to_utf8	:: proc (src: [^]c.wchar_t,	src_len: c.size_t, output: ^string_utf8)	-> c.int ---
	cef_string_utf8_to_wide	:: proc (src: [^]c.char,	 src_len: c.size_t, output: ^string_wide)	-> c.int ---

	cef_string_wide_to_utf16 :: proc (src: [^]c.wchar_t,	src_len: c.size_t, output: ^string_utf16) -> c.int ---
	cef_string_utf16_to_wide :: proc (src: [^]u16, src_len: c.size_t, output: ^string_wide)	-> c.int ---

	cef_string_utf8_to_utf16 :: proc (src: [^]c.char,	 src_len: c.size_t, output: ^string_utf16) -> c.int ---
	cef_string_utf16_to_utf8 :: proc (src: [^]u16, src_len: c.size_t, output: ^string_utf8)	-> c.int ---

	/// These functions convert an ASCII string, typically a hardcoded constant, to a Wide/UTF16 string. Use instead of the UTF8 conversion routines if you know
	/// the string is ASCII.
	cef_string_ascii_to_wide	:: proc (src: [^]c.char, src_len: c.size_t, output: ^string_wide)	-> c.int ---
	cef_string_ascii_to_utf16 :: proc (src: [^]c.char, src_len: c.size_t, output: ^string_utf16) -> c.int ---

	/// These functions allocate a new string structure. They must be freed by calling the associated free function.
	cef_string_userfree_wide_alloc	:: proc () -> cef_string_userfree_wide_t ---
	cef_string_userfree_utf8_alloc	:: proc () -> cef_string_userfree_utf8_t ---
	cef_string_userfree_utf16_alloc :: proc () -> cef_string_userfree_utf16_t ---

	/// These functions free the string structure allocated by the associated alloc function. Any string contents will first be cleared.
	cef_string_userfree_wide_free	:: proc (str: cef_string_userfree_wide_t) ---
	cef_string_userfree_utf8_free	:: proc (str: cef_string_userfree_utf8_t) ---
	cef_string_userfree_utf16_free :: proc (str: cef_string_userfree_utf16_t) ---

	/// These functions convert utf16 string case using the current ICU locale. This may change the length of the string in some cases.
	cef_string_utf16_to_lower :: proc (src: [^]u16, src_len: c.size_t, output: ^string_utf16) -> c.int ---
	cef_string_utf16_to_upper :: proc (src: [^]u16, src_len: c.size_t, output: ^string_utf16) -> c.int ---
}
