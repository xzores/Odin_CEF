package odin_cef

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
	foreign import lib "CEF/Release/libcef.dylib"
}

// Structure used to represent a web request. May be called on any thread.
// NOTE: This struct is allocated DLL-side.
Request :: struct {
	// Base structure.
	base: base_ref_counted,

	// Returns true (1) if this object is read-only.
	is_read_only: proc "c" (self: ^Request) -> c.int,

	// Get the fully qualified URL.
	// The resulting string must be freed by calling cef_string_userfree_free().
	get_url: proc "c" (self: ^Request) -> cef_string_userfree,

	// Set the fully qualified URL.
	set_url: proc "c" (self: ^Request, url: ^cef_string),

	// Get the request function type. Defaults to POST if post data is provided and GET otherwise.
	// The resulting string must be freed by calling cef_string_userfree_free().
	get_method: proc "c" (self: ^Request) -> cef_string_userfree,

	// Set the request function type.
	set_method: proc "c" (self: ^Request, method: ^cef_string),

	// Set the referrer URL and policy. If non-NULL the URL must be fully qualified with HTTP/HTTPS.
	set_referrer: proc "c" (self: ^Request, referrer_url: ^cef_string, policy: Referrer_policy),

	// Get the referrer URL.
	// The resulting string must be freed by calling cef_string_userfree_free().
	get_referrer_url: proc "c" (self: ^Request) -> cef_string_userfree,

	// Get the referrer policy.
	get_referrer_policy: proc "c" (self: ^Request) -> Referrer_policy,

	// Get/Set the post data.
	get_post_data: proc "c" (self: ^Request) -> ^Post_data,
	set_post_data: proc "c" (self: ^Request, post_data: ^Post_data),

	// Get/Set the header values. Will not include the Referer value if any.
	get_header_map: proc "c" (self: ^Request, header_map: string_multimap),
	set_header_map: proc "c" (self: ^Request, header_map: string_multimap),

	// Returns the first header value for |name| or NULL if not found. Will not return Referer.
	// The resulting string must be freed by calling cef_string_userfree_free().
	get_header_by_name: proc "c" (self: ^Request, name: ^cef_string) -> cef_string_userfree,

	// Set header |name| to |value|. If |overwrite| is true (1) replace existing values. Referer cannot be set here.
	set_header_by_name: proc "c" (self: ^Request, name, value: ^cef_string, overwrite: c.int),

	// Set all values at one time.
	set: proc "c" (self: ^Request, url, method: ^cef_string, post_data: ^Post_data, header_map: string_multimap),

	// Get/Set flags used with cef_urlrequest_t. See cef_urlrequest_flags_t.
	get_flags: proc "c" (self: ^Request) -> c.int,
	set_flags: proc "c" (self: ^Request, flags: c.int),

	// Get/Set the URL to the first party for cookies used with cef_urlrequest_t.
	// The resulting string must be freed by calling cef_string_userfree_free().
	get_first_party_for_cookies: proc "c" (self: ^Request) -> cef_string_userfree,
	set_first_party_for_cookies: proc "c" (self: ^Request, url: ^cef_string),

	// Get the resource type for this request. Only available in the browser process.
	get_resource_type: proc "c" (self: ^Request) -> Resource_type,

	// Get the transition type for this request. Browser process only; applies to main/sub-frame navigations.
	get_transition_type: proc "c" (self: ^Request) -> Transition_type,

	// Returns the globally unique identifier for this request or 0 if not specified.
	get_identifier: proc "c" (self: ^Request) -> u64,
}

// Create a new cef_request object.
@(default_calling_convention="c", link_prefix="cef_", require_results)
foreign lib {
	request_create :: proc "c" () -> ^Request ---
}


// Structure used to represent post data for a web request. May be called on any thread.
// NOTE: This struct is allocated DLL-side.
Post_data :: struct {
	// Base structure.
	base: base_ref_counted,

	// Returns true (1) if this object is read-only.
	is_read_only: proc "c" (self: ^Post_data) -> c.int,

	// Returns true (1) if underlying POST data includes elements not represented by this object.
	has_excluded_elements: proc "c" (self: ^Post_data) -> c.int,

	// Returns the number of existing post data elements.
	get_element_count: proc "c" (self: ^Post_data) -> c.size_t,

	// Retrieve the post data elements.
	get_elements: proc "c" (self: ^Post_data, elements_count: ^c.size_t, elements: ^^Post_data_element),

	// Remove/Add elements. Return true (1) on success.
	remove_element: proc "c" (self: ^Post_data, element: ^Post_data_element) -> c.int,
	add_element:    proc "c" (self: ^Post_data, element: ^Post_data_element)    -> c.int,

	// Remove all existing post data elements.
	remove_elements: proc "c" (self: ^Post_data),
}

// Create a new cef_post_data object.
@(default_calling_convention="c", link_prefix="cef_", require_results)
foreign lib {
	post_data_create :: proc "c" () -> ^Post_data ---
}


// Structure for a single element in the request post data. May be called on any thread.
// NOTE: This struct is allocated DLL-side.
Post_data_element :: struct {
	// Base structure.
	base: base_ref_counted,

	// Returns true (1) if this object is read-only.
	is_read_only: proc "c" (self: ^Post_data_element) -> c.int,

	// Mutators for element contents.
	set_to_empty: proc "c" (self: ^Post_data_element),
	set_to_file:  proc "c" (self: ^Post_data_element, file_name: ^cef_string),
	// The bytes passed in will be copied.
	set_to_bytes: proc "c" (self: ^Post_data_element, size: c.size_t, bytes: rawptr),

	// Return the type of this post data element.
	get_type: proc "c" (self: ^Post_data_element) -> Postdataelement_type,

	// Return the file name.
	// The resulting string must be freed by calling cef_string_userfree_free().
	get_file: proc "c" (self: ^Post_data_element) -> cef_string_userfree,

	// Return the number of bytes.
	get_bytes_count: proc "c" (self: ^Post_data_element) -> c.size_t,

	// Read up to |size| bytes into |bytes| and return the number of bytes actually read.
	get_bytes: proc "c" (self: ^Post_data_element, size: c.size_t, bytes: rawptr) -> c.size_t,
}

// Create a new cef_post_data_element object.
@(default_calling_convention="c", link_prefix="cef_", require_results)
foreign lib {
	post_data_element_create :: proc "c" () -> ^Post_data_element ---
}
