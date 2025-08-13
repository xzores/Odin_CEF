package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_scoped is defined in cef_base_capi.odin
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// frame is defined in cef_frame_capi.odin
// request is defined in cef_request_capi.odin
// resource_handler is defined in cef_resource_handler_capi.odin
// cef_string is defined in cef_string_capi.odin

///
/// Structure that manages custom scheme registrations.
///
/// NOTE: This struct is allocated DLL-side.
///
scheme_registrar :: struct {
    ///
    /// Base structure.
    ///
    base: base_scoped,

    ///
    /// Register a custom scheme. This function should not be called for the
    /// built-in HTTP, HTTPS, FILE, FTP, ABOUT and DATA schemes.
    ///
    /// See cef_scheme_options for possible values for |options|.
    ///
    /// This function may be called on any thread. It should only be called once
    /// per unique |scheme_name| value. If |scheme_name| is already registered or
    /// if an error occurs this function will return false (0).
    ///
    add_custom_scheme: proc "c" (self: ^scheme_registrar, scheme_name: ^cef_string, options: c.int) -> b32,
}

///
/// Structure that creates resource_handler instances for handling scheme
/// requests. The functions of this structure will always be called on the IO
/// thread.
///
/// NOTE: This struct is allocated client-side.
///
scheme_handler_factory :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Return a new resource handler instance to handle the request or an NULL
    /// reference to allow default handling of the request. |browser| and |frame|
    /// will be the browser window and frame respectively that originated the
    /// request or NULL if the request did not originate from a browser window
    /// (for example, if the request came from url_request). The |request|
    /// object passed to this function cannot be modified.
    ///
    	    create: proc "c" (self: ^scheme_handler_factory, browser: ^Browser, frame: ^Frame, scheme_name: ^cef_string, request: ^Request) -> ^resource_handler,
}

///
/// Register a scheme handler factory with the global request context. An NULL
/// |domain_name| value for a standard scheme will cause the factory to match
/// all domain names. The |domain_name| value will be ignored for non-standard
/// schemes. If |scheme_name| is a built-in scheme and no handler is returned by
/// |factory| then the built-in scheme handler factory will be called. If
/// |scheme_name| is a custom scheme then you must also implement the
/// app::on_register_custom_schemes() function in all processes. This
/// function may be called multiple times to change or remove the factory that
/// matches the specified |scheme_name| and optional |domain_name|. Returns
/// false (0) if an error occurs. This function may be called on any thread in
/// the browser process. Using this function is equivalent to calling request_context::get_global_context()-
/// >register_scheme_handler_factory().
///
register_scheme_handler_factory :: proc "c" (scheme_name: ^cef_string, domain_name: ^cef_string, factory: ^scheme_handler_factory) -> b32

///
/// Clear all scheme handler factories registered with the global request
/// context. Returns false (0) on error. This function may be called on any
/// thread in the browser process. Using this function is equivalent to calling
/// request_context::get_global_context()-
/// >clear_scheme_handler_factories().
///
clear_scheme_handler_factories :: proc "c" () -> b32 