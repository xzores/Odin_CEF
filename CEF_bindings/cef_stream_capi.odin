package odin_cef

import "core:c"

// Forward declarations for dependencies
// base_ref_counted is defined in cef_base_capi.odin
// cef_string is defined in cef_string_capi.odin

/// Structure the client can implement to provide a custom stream reader. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated client-side.
read_handler :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Read raw binary data.
	read: proc "c" (self: ^read_handler, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Return zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^read_handler, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^read_handler) -> i64,

	/// Return non-zero if at end of file.
	eof: proc "c" (self: ^read_handler) -> c.int,

	/// Return true (1) if this handler performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the handler from.
	may_block: proc "c" (self: ^read_handler) -> c.int,
}

/// Structure used to read data from a stream. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated DLL-side.
stream_reader :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Read raw binary data.
	read: proc "c" (self: ^stream_reader, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Returns zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^stream_reader, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^stream_reader) -> i64,

	/// Return non-zero if at end of file.
	eof: proc "c" (self: ^stream_reader) -> c.int,

	/// Returns true (1) if this reader performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the reader from.
	may_block: proc "c" (self: ^stream_reader) -> c.int,
}

/// Create a new stream_reader object from a file.
stream_reader_create_for_file :: proc "c" (fileName: ^cef_string) -> ^stream_reader

/// Create a new stream_reader object from data.
stream_reader_create_for_data :: proc "c" (data: rawptr, size: c.size_t) -> ^stream_reader

/// Create a new stream_reader object from a custom handler.
stream_reader_create_for_handler :: proc "c" (handler: ^read_handler) -> ^stream_reader

/// Structure the client can implement to provide a custom stream writer. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated client-side.
write_handler :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Write raw binary data.
	write: proc "c" (self: ^write_handler, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Return zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^write_handler, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^write_handler) -> i64,

	/// Flush the stream.
	flush: proc "c" (self: ^write_handler) -> c.int,

	/// Return true (1) if this handler performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the handler from.
	may_block: proc "c" (self: ^write_handler) -> c.int,
}

/// Structure used to write data to a stream. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated DLL-side.
stream_writer :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Write raw binary data.
	write: proc "c" (self: ^stream_writer, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Returns zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^stream_writer, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^stream_writer) -> i64,

	/// Flush the stream.
	flush: proc "c" (self: ^stream_writer) -> c.int,

	/// Returns true (1) if this writer performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the writer from.
	may_block: proc "c" (self: ^stream_writer) -> c.int,
} 