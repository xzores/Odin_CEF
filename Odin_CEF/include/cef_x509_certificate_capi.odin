package odin_cef

import "core:c"

when ODIN_OS == .Windows {
    foreign import cef "cef.dll"
} else {
    foreign import cef "libcef.so"
}

cef_x509_cert_principal_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_display_name: proc "c" (self: ^cef_x509_cert_principal_t) -> cef_string_userfree_t,
    get_common_name: proc "c" (self: ^cef_x509_cert_principal_t) -> cef_string_userfree_t,
    get_locality_name: proc "c" (self: ^cef_x509_cert_principal_t) -> cef_string_userfree_t,
    get_state_or_province_name: proc "c" (self: ^cef_x509_cert_principal_t) -> cef_string_userfree_t,
    get_country_name: proc "c" (self: ^cef_x509_cert_principal_t) -> cef_string_userfree_t,
    get_organization_names: proc "c" (self: ^cef_x509_cert_principal_t, names: cef_string_list_t),
    get_organization_unit_names: proc "c" (self: ^cef_x509_cert_principal_t, names: cef_string_list_t),
}

cef_x509_certificate_t :: struct {
    base: cef_base_ref_counted_t,
    
    get_subject: proc "c" (self: ^cef_x509_certificate_t) -> ^cef_x509_cert_principal_t,
    get_issuer: proc "c" (self: ^cef_x509_certificate_t) -> ^cef_x509_cert_principal_t,
    get_serial_number: proc "c" (self: ^cef_x509_certificate_t) -> ^cef_binary_value_t,
    get_valid_start: proc "c" (self: ^cef_x509_certificate_t) -> cef_basetime_t,
    get_valid_expiry: proc "c" (self: ^cef_x509_certificate_t) -> cef_basetime_t,
    get_derencoded: proc "c" (self: ^cef_x509_certificate_t) -> ^cef_binary_value_t,
    get_pemencoded: proc "c" (self: ^cef_x509_certificate_t) -> ^cef_binary_value_t,
    get_issuer_chain_size: proc "c" (self: ^cef_x509_certificate_t) -> c.size_t,
    get_derencoded_issuer_chain: proc "c" (self: ^cef_x509_certificate_t, chain_count: ^c.size_t, chain: ^^cef_binary_value_t),
    get_pemencoded_issuer_chain: proc "c" (self: ^cef_x509_certificate_t, chain_count: ^c.size_t, chain: ^^cef_binary_value_t),
} 