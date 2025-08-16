package odin_cef

import "core:c"

/// Structure the client can implement to provide a custom stream reader. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated client-side.
Read_handler :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Read raw binary data.
	read: proc "c" (self: ^Read_handler, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Return zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^Read_handler, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^Read_handler) -> i64,

	/// Return non-zero if at end of file.
	eof: proc "c" (self: ^Read_handler) -> c.int,

	/// Return true (1) if this handler performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the handler from.
	may_block: proc "c" (self: ^Read_handler) -> c.int,
}

/// Structure used to read data from a stream. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated DLL-side.
Stream_reader :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Read raw binary data.
	read: proc "c" (self: ^Stream_reader, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Returns zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^Stream_reader, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^Stream_reader) -> i64,

	/// Return non-zero if at end of file.
	eof: proc "c" (self: ^Stream_reader) -> c.int,

	/// Returns true (1) if this reader performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the reader from.
	may_block: proc "c" (self: ^Stream_reader) -> c.int,
}

/// Create a new Stream_reader object from a file.
stream_reader_create_for_file :: proc "c" (fileName: ^cef_string) -> ^Stream_reader

/// Create a new Stream_reader object from data.
stream_reader_create_for_data :: proc "c" (data: rawptr, size: c.size_t) -> ^Stream_reader

/// Create a new Stream_reader object from a custom handler.
stream_reader_create_for_handler :: proc "c" (handler: ^Read_handler) -> ^Stream_reader

/// Structure the client can implement to provide a custom stream writer. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated client-side.
Write_handler :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Write raw binary data.
	write: proc "c" (self: ^Write_handler, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Return zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^Write_handler, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^Write_handler) -> i64,

	/// Flush the stream.
	flush: proc "c" (self: ^Write_handler) -> c.int,

	/// Return true (1) if this handler performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the handler from.
	may_block: proc "c" (self: ^Write_handler) -> c.int,
}

/// Structure used to write data to a stream. The functions of this structure may be called on any thread.
/// NOTE: This struct is allocated DLL-side.
Stream_writer :: struct {
	/// Base structure.
	base: base_ref_counted,

	/// Write raw binary data.
	write: proc "c" (self: ^Stream_writer, ptr: rawptr, size: c.size_t, n: c.size_t) -> c.size_t,

	/// Seek to the specified offset position. |whence| may be any one of SEEK_CUR, SEEK_END or SEEK_SET. Returns zero on success and non-zero on
	/// failure.
	seek: proc "c" (self: ^Stream_writer, offset: i64, whence: c.int) -> c.int,

	/// Return the current offset position.
	tell: proc "c" (self: ^Stream_writer) -> i64,

	/// Flush the stream.
	flush: proc "c" (self: ^Stream_writer) -> c.int,

	/// Returns true (1) if this writer performs work like accessing the file system which may block. Used as a hint for determining the thread to
	/// access the writer from.
	may_block: proc "c" (self: ^Stream_writer) -> c.int,
} 