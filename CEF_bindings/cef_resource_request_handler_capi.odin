package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// frame is defined in cef_frame_capi.odin
// request is defined in cef_request_capi.odin
// response is defined in cef_response_capi.odin
// resource_handler is defined in cef_resource_handler_capi.odin
// response_filter is defined in cef_response_filter_capi.odin
// callback is defined in cef_callback_capi.odin
// cef_string is defined in cef_string_capi.odin
// cef_cookie is defined in cef_types_capi.odin
// cef_return_value is defined in cef_types_capi.odin
// cef_urlrequest_status is defined in cef_types_capi.odin

///
/// Implement this structure to handle events related to browser requests. The
/// functions of this structure will be called on the IO thread unless otherwise
/// indicated.
///
/// NOTE: This struct is allocated client-side.
///
resource_request_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called on the IO thread before a resource request is loaded. The |browser|
    /// and |frame| values represent the source of the request, and may be NULL
    /// for requests originating from service workers or url_request. To
    /// optionally filter cookies for the request return a
    /// cookie_access_filter object. The |request| object cannot not be
    /// modified in this callback.
    ///
    get_cookie_access_filter: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request) -> ^cookie_access_filter,

    ///
    /// Called on the IO thread before a resource request is loaded. The |browser|
    /// and |frame| values represent the source of the request, and may be NULL
    /// for requests originating from service workers or url_request. To
    /// redirect or change the resource load optionally modify |request|.
    /// Modification of the request URL will be treated as a redirect. Return
    /// RV_CONTINUE to continue the request immediately. Return RV_CONTINUE_ASYNC
    /// and call callback functions at a later time to continue or cancel
    /// the request asynchronously. Return RV_CANCEL to cancel the request
    /// immediately.
    ///
    on_before_resource_load: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request, callback: ^callback) -> cef_return_value,

    ///
    /// Called on the IO thread before a resource is loaded. The |browser| and
    /// |frame| values represent the source of the request, and may be NULL for
    /// requests originating from service workers or url_request. To allow
    /// the resource to load using the default network loader return NULL. To
    /// specify a handler for the resource return a resource_handler object.
    /// The |request| object cannot not be modified in this callback.
    ///
    get_resource_handler: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request) -> ^resource_handler,

    ///
    /// Called on the IO thread when a resource load is redirected. The |browser|
    /// and |frame| values represent the source of the request, and may be NULL
    /// for requests originating from service workers or url_request. The
    /// |request| parameter will contain the old URL and other request-related
    /// information. The |response| parameter will contain the response that
    /// resulted in the redirect. The |new_url| parameter will contain the new URL
    /// and can be changed if desired. The |request| and |response| objects cannot
    /// be modified in this callback.
    ///
    on_resource_redirect: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request, response: ^response, new_url: ^cef_string),

    ///
    /// Called on the IO thread when a resource response is received. The
    /// |browser| and |frame| values represent the source of the request, and may
    /// be NULL for requests originating from service workers or url_request.
    /// To allow the resource load to proceed without modification return false
    /// (0). To redirect or retry the resource load optionally modify |request|
    /// and return true (1). Modification of the request URL will be treated as a
    /// redirect. Requests handled using the default network loader cannot be
    /// redirected in this callback. The |response| object cannot be modified in
    /// this callback.
    ///
    /// WARNING: Redirecting using this function is deprecated. Use
    /// on_before_resource_load or get_resource_handler to perform redirects.
    ///
    on_resource_response: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request, response: ^response) -> b32,

    ///
    /// Called on the IO thread to optionally filter resource response content.
    /// The |browser| and |frame| values represent the source of the request, and
    /// may be NULL for requests originating from service workers or
    /// url_request. |request| and |response| represent the request and
    /// response respectively and cannot be modified in this callback.
    ///
    get_resource_response_filter: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request, response: ^response) -> ^response_filter,

    ///
    /// Called on the IO thread when a resource load has completed. The |browser|
    /// and |frame| values represent the source of the request, and may be NULL
    /// for requests originating from service workers or url_request.
    /// |request| and |response| represent the request and response respectively
    /// and cannot be modified in this callback. |status| indicates the load
    /// completion status. |received_content_length| is the number of response
    /// bytes actually read. This function will be called for all requests,
    /// including requests that are aborted due to CEF shutdown or destruction of
    /// the associated browser. In cases where the associated browser is destroyed
    /// this callback may arrive after the life_span_handler::on_before_close
    /// callback for that browser. The frame::is_valid function can be used
    /// to test for this situation, and care should be taken not to call |browser|
    /// or |frame| functions that modify state (like load_url, send_process_message,
    /// etc.) if the frame is invalid.
    ///
    on_resource_load_complete: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request, response: ^response, status: cef_urlrequest_status, received_content_length: i64),

    ///
    /// Called on the IO thread to handle requests for URLs with an unknown
    /// protocol component. The |browser| and |frame| values represent the source
    /// of the request, and may be NULL for requests originating from service
    /// workers or url_request. |request| cannot be modified in this
    /// callback. Set |allow_os_execution| to true (1) to attempt execution via
    /// the registered OS protocol handler, if any. SECURITY WARNING: YOU SHOULD
    /// USE THIS METHOD TO ENFORCE RESTRICTIONS BASED ON SCHEME, HOST OR OTHER URL
    /// ANALYSIS BEFORE ALLOWING OS EXECUTION.
    ///
    on_protocol_execution: proc "c" (self: ^resource_request_handler, browser: ^Browser, frame: ^Frame, request: ^Request, allow_os_execution: ^b32),
}

///
/// Implement this structure to filter cookies that may be sent with a request.
/// The functions of this structure will be called on the IO thread.
///
/// NOTE: This struct is allocated client-side.
///
cookie_access_filter :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called on the IO thread before a resource request is sent. The |browser|
    /// and |frame| values represent the source of the request, and may be NULL
    /// for requests originating from service workers or url_request.
    /// |request| cannot be modified in this callback. Return true (1) if the
    /// specified cookie can be sent with the request or false (0) otherwise.
    ///
    can_send_cookie: proc "c" (self: ^cookie_access_filter, browser: ^Browser, frame: ^Frame, request: ^Request, cookie: ^cef_cookie) -> b32,

    ///
    /// Called on the IO thread after a resource response is received. The
    /// |browser| and |frame| values represent the source of the request, and may
    /// be NULL for requests originating from service workers or url_request.
    /// |request| cannot be modified in this callback. Return true (1) if the
    /// specified cookie returned with the response can be saved or false (0)
    /// otherwise.
    ///
    can_save_cookie: proc "c" (self: ^cookie_access_filter, browser: ^Browser, frame: ^Frame, request: ^Request, response: ^response, cookie: ^cef_cookie) -> b32,
} 