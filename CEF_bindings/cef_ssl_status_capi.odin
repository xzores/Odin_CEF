package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// x509_certificate is defined in cef_x509_certificate_capi.odin
// cef_cert_status is defined in cef_types_capi.odin
// cef_ssl_version is defined in cef_types_capi.odin
// cef_ssl_content_status is defined in cef_types_capi.odin

///
/// Structure representing the SSL information for a navigation entry.
///
/// NOTE: This struct is allocated DLL-side.
///
ssl_status :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Returns true (1) if the status is related to a secure SSL/TLS connection.
    ///
    is_secure_connection: proc "c" (self: ^ssl_status) -> b32,

    ///
    /// Returns a bitmask containing any and all problems verifying the server
    /// certificate.
    ///
    get_cert_status: proc "c" (self: ^ssl_status) -> cef_cert_status,

    ///
    /// Returns the SSL version used for the SSL connection.
    ///
    get_sslversion: proc "c" (self: ^ssl_status) -> cef_ssl_version,

    ///
    /// Returns a bitmask containing the page security content status.
    ///
    get_content_status: proc "c" (self: ^ssl_status) -> cef_ssl_content_status,

    ///
    /// Returns the X.509 certificate.
    ///
    get_x509_certificate: proc "c" (self: ^ssl_status) -> ^x509_certificate,
} 