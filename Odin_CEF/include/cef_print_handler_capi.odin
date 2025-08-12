package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// browser is defined in cef_browser_capi.odin
// cef_string is defined in cef_string_capi.odin
// cef_size is defined in cef_types_capi.odin
// print_settings is defined in cef_print_settings_capi.odin

///
/// Callback structure for asynchronous continuation of print dialog requests.
///
/// NOTE: This struct is allocated DLL-side.
///
print_dialog_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Continue printing with the specified |settings|.
    ///
    cont: proc "c" (self: ^print_dialog_callback, settings: ^print_settings),

    ///
    /// Cancel the printing.
    ///
    cancel: proc "c" (self: ^print_dialog_callback),
}

///
/// Callback structure for asynchronous continuation of print job requests.
///
/// NOTE: This struct is allocated DLL-side.
///
print_job_callback :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Indicate completion of the print job.
    ///
    cont: proc "c" (self: ^print_job_callback),
}

///
/// Implement this structure to handle printing on Linux. Each browser will have
/// only one print job in progress at a time. The functions of this structure
/// will be called on the browser process UI thread.
///
/// NOTE: This struct is allocated client-side.
///
print_handler :: struct {
    ///
    /// Base structure.
    ///
    base: base_ref_counted,

    ///
    /// Called when printing has started for the specified |browser|. This
    /// function will be called before the other on_print*() functions and
    /// irrespective of how printing was initiated (e.g.
    /// browser_host::print(), JavaScript window.print() or PDF extension
    /// print button).
    ///
    on_print_start: proc "c" (self: ^print_handler, browser: ^cef_browser_t),

    ///
    /// Synchronize |settings| with client state. If |get_defaults| is true (1)
    /// then populate |settings| with the default print settings. Do not keep a
    /// reference to |settings| outside of this callback.
    ///
    on_print_settings: proc "c" (self: ^print_handler, browser: ^cef_browser_t, settings: ^print_settings, get_defaults: b32),

    ///
    /// Show the print dialog. Execute |callback| once the dialog is dismissed.
    /// Return true (1) if the dialog will be displayed or false (0) to cancel the
    /// printing immediately.
    ///
    on_print_dialog: proc "c" (self: ^print_handler, browser: ^cef_browser_t, has_selection: b32, callback: ^print_dialog_callback) -> b32,

    ///
    /// Send the print job to the printer. Execute |callback| once the job is
    /// completed. Return true (1) if the job will proceed or false (0) to cancel
    /// the job immediately.
    ///
    on_print_job: proc "c" (self: ^print_handler, browser: ^cef_browser_t, document_name: ^cef_string, pdf_file_path: ^cef_string, callback: ^print_job_callback) -> b32,

    ///
    /// Reset client state related to printing.
    ///
    on_print_reset: proc "c" (self: ^print_handler, browser: ^cef_browser_t),

    ///
    /// Return the PDF paper size in device units. Used in combination with
    /// browser_host::print_to_pdf().
    ///
    get_pdf_paper_size: proc "c" (self: ^print_handler, browser: ^cef_browser_t, device_units_per_inch: c.int) -> cef_size,
} 