package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// X509_certificate is defined in cef_x509_certificate_capi.odin
// Cert_status is defined in cef_types_capi.odin

///
/// Structure representing SSL information.
///
/// NOTE: This struct is allocated DLL-side.
///
ssl_info :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Returns a bitmask containing any and all problems verifying the server
    /// certificate.
    ///
    get_cert_status: proc "c" (self: ^ssl_info) -> Cert_status,

    ///
    /// Returns the X.509 certificate.
    ///
    get_x509_certificate: proc "c" (self: ^ssl_info) -> ^X509_certificate,
}

///
/// Returns true (1) if the certificate status represents an error.
///
is_cert_status_error :: proc "c" (status: Cert_status) -> b32 