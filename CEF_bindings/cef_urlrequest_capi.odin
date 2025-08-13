package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// request is defined in cef_request_capi.odin
// response is defined in cef_response_capi.odin
// request_context is defined in cef_request_context_capi.odin
// auth_callback is defined in cef_auth_callback_capi.odin
// cef_string is defined in cef_string_capi.odin
// cef_urlrequest_status is defined in cef_types_capi.odin
// cef_errorcode is defined in cef_types_capi.odin

///
/// Structure used to make a URL request. URL requests are not associated with a
/// browser instance so no client callbacks will be executed. URL requests
/// can be created on any valid CEF thread in either the browser or render
/// process. Once created the functions of the URL request object must be
/// accessed on the same thread that created it.
///
/// NOTE: This struct is allocated DLL-side.
///
urlrequest :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Returns the request object used to create this URL request. The returned
    /// object is read-only and should not be modified.
    ///
    get_request: proc "c" (self: ^urlrequest) -> ^Request,

    ///
    /// Returns the client.
    ///
    get_client: proc "c" (self: ^urlrequest) -> ^urlrequest_client,

    ///
    /// Returns the request status.
    ///
    get_request_status: proc "c" (self: ^urlrequest) -> cef_urlrequest_status,

    ///
    /// Returns the request error if status is UR_CANCELED or UR_FAILED, or 0
    /// otherwise.
    ///
    get_request_error: proc "c" (self: ^urlrequest) -> cef_errorcode,

    ///
    /// Returns the response, or NULL if no response information is available.
    /// Response information will only be available after the upload has
    /// completed. The returned object is read-only and should not be modified.
    ///
    get_response: proc "c" (self: ^urlrequest) -> ^response,

    ///
    /// Returns true (1) if the response body was served from the cache. This
    /// includes responses for which revalidation was required.
    ///
    response_was_cached: proc "c" (self: ^urlrequest) -> b32,

    ///
    /// Cancel the request.
    ///
    cancel: proc "c" (self: ^urlrequest),
}

///
/// Create a new URL request that is not associated with a specific browser or
/// frame. Use frame::create_urlrequest instead if you want the request to
/// have this association, in which case it may be handled differently (see
/// documentation on that function). A request created with this function may
/// only originate from the browser process, and will behave as follows:
///   - It may be intercepted by the client via resource_request_handler or
///     scheme_handler_factory.
///   - POST data may only contain only a single element of type PDE_TYPE_FILE
///     or PDE_TYPE_BYTES.
///   - If |request_context| is empty the global request context will be used.
///
/// The |request| object will be marked as read-only after calling this
/// function.
///
urlrequest_create :: proc "c" (request: ^Request, client: ^urlrequest_client, request_context: ^request_context) -> ^urlrequest

///
/// Structure that should be implemented by the urlrequest client. The
/// functions of this structure will be called on the same thread that created
/// the request unless otherwise documented.
///
/// NOTE: This struct is allocated client-side.
///
urlrequest_client :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Notifies the client that the request has completed. Use the
    /// urlrequest::get_request_status function to determine if the request
    /// was successful or not.
    ///
    on_request_complete: proc "c" (self: ^urlrequest_client, request: ^urlrequest),

    ///
    /// Notifies the client of upload progress. |current| denotes the number of
    /// bytes sent so far and |total| is the total size of uploading data (or -1
    /// if chunked upload is enabled). This function will only be called if the
    /// UR_FLAG_REPORT_UPLOAD_PROGRESS flag is set on the request.
    ///
    on_upload_progress: proc "c" (self: ^urlrequest_client, request: ^urlrequest, current: i64, total: i64),

    ///
    /// Notifies the client of download progress. |current| denotes the number of
    /// bytes received up to the call and |total| is the expected total size of
    /// the response (or -1 if not determined).
    ///
    on_download_progress: proc "c" (self: ^urlrequest_client, request: ^urlrequest, current: i64, total: i64),

    ///
    /// Called when some part of the response is read. |data| contains the current
    /// bytes received since the last call. This function will not be called if
    /// the UR_FLAG_NO_DOWNLOAD_DATA flag is set on the request.
    ///
    on_download_data: proc "c" (self: ^urlrequest_client, request: ^urlrequest, data: rawptr, data_length: c.size_t),

    ///
    /// Called on the IO thread when the browser needs credentials from the user.
    /// |isProxy| indicates whether the host is a proxy server. |host| contains
    /// the hostname and |port| contains the port number. Return true (1) to
    /// continue the request and call auth_callback::cont() when the
    /// authentication information is available. If the request has an associated
    /// browser/frame then returning false (0) will result in a call to
    /// get_auth_credentials on the request_handler associated with that
    /// browser, and eventual cancellation of the request if the browser
    /// returns false (0). Return false (0) to cancel the request
    /// immediately. This function will only be called for requests initiated from
    /// the browser process.
    ///
    get_auth_credentials: proc "c" (self: ^urlrequest_client, isProxy: b32, host: ^cef_string, port: c.int, realm: ^cef_string, scheme: ^cef_string, callback: ^auth_callback) -> b32,
} 