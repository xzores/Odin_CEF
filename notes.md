# CEF to Odin Translation Notes - Comprehensive Analysis

## Understanding the Task

I need to translate CEF (Chromium Embedded Framework) C++ headers to Odin-compatible bindings. This involves:

1. **C++ to Odin Translation**: Unlike the C libraries (fastnoise, glslang), CEF is C++ with classes, inheritance, virtual functions, templates, etc.
2. **Reference Counting**: CEF uses a sophisticated reference counting system with `CefBaseRefCounted` and `CefRefPtr<T>`
3. **Platform-Specific Code**: CEF has platform-specific implementations
4. **Complex Type System**: CEF uses templates, smart pointers, and complex inheritance hierarchies

## Detailed Translation Patterns from Examples

### 1. C Library Translation Patterns (fastnoise, glslang)

#### Foreign Import Pattern
```odin
// Platform-specific library imports
when ODIN_OS == .Windows {
    foreign import lib "CEF/Release/libcef.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "CEF/Release/libcef.so"
} else when ODIN_OS == .Darwin {
    foreign import lib "CEF/Release/libcef.dylib"
}
```

#### Type Mapping Examples
```cpp
// C++: void* node
// Odin: distinct rawptr
Node_tree :: distinct rawptr;

// C++: const char* encodedString
// Odin: cstring
fnNewFromEncodedNodeTree :: proc(encodedString: cstring, simdLevel: u32) -> Node_tree ---;

// C++: float* noise_out
// Odin: [^]f32 (slice of f32)
fnGenUniformGrid2D :: proc(node_tree: Node_tree, noise_out: [^]f32, ...) ---;

// C++: float output_min_max[2] or nullptr
// Odin: ^[2]f32 (pointer to array of 2 f32)
fnGenUniformGrid2D :: proc(..., output_min_max: ^[2]f32) ---;
```

#### Function Declaration Pattern
```odin
@(default_calling_convention="c")
foreign lib {
    fnNewFromEncodedNodeTree :: proc(encodedString: cstring, simdLevel: u32) -> Node_tree ---;
    fnDeleteNodeRef :: proc(node_tree: Node_tree) ---;
}
```

#### Struct Translation Examples
```cpp
// C++: struct with bool fields
struct TLimits {
    bool non_inductive_for_loops;
    bool while_loops;
    // ...
};
```

```odin
// Odin: Direct struct mapping
Limits :: struct {
    non_inductive_for_loops: bool,
    while_loops: bool,
    // ...
}
```

#### Enum Translation Examples
```cpp
// C++: enum with explicit values
enum Stage {
    vertex = 0,
    tesscontrol = 1,
    // ...
};
```

```odin
// Odin: enum with explicit values
Stage :: enum u32 {
    vertex,
    tesscontrol,
    // ...
}
```

#### Bit Set Translation
```cpp
// C++: enum flags
enum Messages {
    relaxed_errors = 0,
    suppress_warnings = 1,
    // ...
};
```

```odin
// Odin: bit_set for flags
Messages_enum :: enum u32 {
    relaxed_errors = 0,
    suppress_warnings = 1,
    // ...
}
Messages :: bit_set[Messages_enum; u32];
```

### 2. C++ Translation Patterns (steamworks)

#### Class to Struct Translation
```cpp
// C++: Class with methods
class SteamNetworkingMessage {
    void* pData;
    int cbSize;
    // ...
};
```

```odin
// Odin: Struct with alignment (NOTE: Only steamworks uses alignment!)
SteamNetworkingMessage :: struct #align(CALLBACK_ALIGN) {
    pData: rawptr,
    cbSize: i32,
    // ...
}
```

**IMPORTANT**: The steamworks translation uses `#align(CALLBACK_ALIGN)` but the C libraries (fastnoise, glslang) do NOT use alignment at all. This suggests that alignment is only needed for specific C++ libraries that require it.

#### Virtual Function Translation
```cpp
// C++: Virtual functions become function pointers
virtual void OnComplete() = 0;
```

```odin
// Odin: Function pointer types
Completion_OnComplete_Proc :: #type proc "c" (callback: CefCompletionCallback)
```

#### Template Translation
```cpp
// C++: Template types
CefRefPtr<CefApp> application;
```

```odin
// Odin: Generic structs
CefRefPtr :: struct($T: typeid) {
    ptr: ^T,
}
```

#### Union Translation
```cpp
// C++: Union
union {
    analogAction: SteamInputActionEvent_AnalogAction,
    digitalAction: SteamInputActionEvent_DigitalAction,
};
```

```odin
// Odin: Raw union
using actions: struct #raw_union {
    analogAction: SteamInputActionEvent_AnalogAction,
    digitalAction: SteamInputActionEvent_DigitalAction,
}
```

### 3. CEF-Specific Translation Challenges

#### Reference Counting System
```cpp
// C++: Virtual reference counting
class CefBaseRefCounted {
    virtual void AddRef() const = 0;
    virtual bool Release() const = 0;
    virtual bool HasOneRef() const = 0;
    virtual bool HasAtLeastOneRef() const = 0;
};
```

**Translation Strategy**:
```odin
// Odin: Distinct types for reference counting
CefRefCounted :: distinct rawptr

// Helper functions
add_ref :: proc(obj: CefRefCounted) {
    if obj != nil {
        cef_add_ref(obj)
    }
}

release :: proc(obj: CefRefCounted) -> bool {
    if obj != nil {
        return cef_release(obj)
    }
    return false
}
```

#### String Handling - ACTUAL C++ vs Odin Comparison
```cpp
// C++: Actual CEF string struct
typedef struct _cef_string_utf16_t {
    char16_t* str;
    size_t length;
    void (*dtor)(char16_t* str);
} cef_string_utf16_t;
```

```odin
// Odin: Direct translation
CefString :: struct {
    str: [^]u16,  // char16_t* -> [^]u16
    length: c.size_t,  // size_t -> c.size_t
    dtor: proc "c" ([^]u16),  // void (*dtor)(char16_t* str) -> proc "c" ([^]u16)
}
```

#### Virtual Function Translation
```cpp
// C++: Virtual functions in interfaces
virtual void OnBeforeCommandLineProcessing(
    const CefString& process_type,
    CefRefPtr<CefCommandLine> Command_line) {}
```

**Translation Strategy**:
```odin
// Odin: Function pointer types with context
CommandLine_Processing_Proc :: #type proc "c" (
    ctx: rawptr,  // 'this' pointer
    process_type: CefString,
    Command_line: CefRefPtr(CefCommandLine)
)

// Struct to hold callbacks
CommandLine_Handler :: struct {
    on_before_processing: CommandLine_Processing_Proc,
    ctx: rawptr,  // Context for 'this' pointer
}
```

## Critical Gotchas and Solutions

### 1. Type Size Differences

#### Integer Sizes
```cpp
// C++: int is 32-bit
int argc;
const char* const* argv;
```

```odin
// Odin: int is 64-bit, must use i32 for 32-bit
argc: i32,
argv: [^]cstring,
```

#### Pointer Sizes
```cpp
// C++: void* is platform-dependent
void* data;
```

```odin
// Odin: rawptr matches platform pointer size
data: rawptr,
```

#### Enum Sizes
```cpp
// C++: enum defaults to int (32-bit)
enum Stage { vertex, fragment };
```

```odin
// Odin: Must explicitly specify size
Stage :: enum u32 {  // Explicit 32-bit
    vertex,
    fragment,
}
```

### 2. Function Calling Conventions

#### Context Parameter Issue
```cpp
// C++: Member functions have implicit 'this'
class CefApp {
    virtual void OnBeforeCommandLineProcessing(...);
};
```

```odin
// Odin: Must explicitly pass context
OnBeforeCommandLineProcessing_Proc :: #type proc "c" (
    ctx: rawptr,  // 'this' pointer
    process_type: CefString,
    Command_line: CefRefPtr(CefCommandLine)
)
```

#### Calling Convention Mismatches
```cpp
// C++: __stdcall on Windows, __cdecl on others
CEF_EXPORT int cef_string_utf8_set(...);
```

```odin
// Odin: Must match C++ calling convention
@(default_calling_convention="c")  // or "stdcall" on Windows
foreign lib {
    cef_string_utf8_set :: proc(...) -> i32 ---;
}
```

### 3. Memory Management Issues

#### Reference Counting
```cpp
// C++: Automatic reference counting
CefRefPtr<CefApp> app = CefApp::Create();
```

```odin
// Odin: Manual reference counting
app := ref_ptr_create(cef_app_create())
defer ref_ptr_destroy(&app)
```

#### String Lifetime
```cpp
// C++: CefString manages its own memory
CefString str = "Hello";
```

```odin
// Odin: Must manually manage string memory
str := cef_string_create("Hello")
defer cef_string_destroy(&str)
```

### 4. Struct Layout and Alignment

#### Alignment Issues - CORRECTED
```cpp
// C++: Struct alignment (CEF doesn't use explicit alignment)
struct cef_string_utf16_t {
    char16_t* str;
    size_t length;
    void (*dtor)(char16_t* str);
};
```

```odin
// Odin: No alignment needed for CEF (unlike steamworks)
CefString :: struct {  // No #align needed!
    str: [^]u16,
    length: c.size_t,
    dtor: proc "c" ([^]u16),
}
```

**IMPORTANT CORRECTION**: I was wrong about alignment. Looking at the actual translations:
- **fastnoise/glslang**: No alignment used
- **steamworks**: Uses `#align(CALLBACK_ALIGN)` 
- **CEF**: Should NOT use alignment unless specifically required

#### Packing Issues
```cpp
// C++: Packed structs
#pragma pack(push, 1)
struct CefSettings {
    // ...
};
#pragma pack(pop)
```

```odin
// Odin: Must match packing
CefSettings :: struct #packed {
    // ...
}
```

### 5. Template and Generic Issues

#### Template Specialization
```cpp
// C++: Template types
CefRefPtr<CefApp> app;
CefRefPtr<CefBrowser> browser;
```

```odin
// Odin: Must create specific types
CefRefPtr_App :: struct {
    ptr: ^CefApp,
}
CefRefPtr_Browser :: struct {
    ptr: ^CefBrowser,
}
```

#### Generic Constraints
```cpp
// C++: Template constraints
template<typename T>
class CefRefPtr {
    static_assert(std::is_base_of<CefBaseRefCounted, T>::value);
};
```

```odin
// Odin: No compile-time constraints, must be careful
CefRefPtr :: struct($T: typeid) {
    ptr: ^T,  // No constraint checking
}
```

### 6. Platform-Specific Code

#### Conditional Compilation
```cpp
// C++: Platform-specific includes
#if defined(OS_WIN)
#include "include/internal/cef_win.h"
#elif defined(OS_MAC)
#include "include/internal/cef_mac.h"
#endif
```

```odin
// Odin: Platform-specific code
when ODIN_OS == .Windows {
    // Windows-specific code
} else when ODIN_OS == .Darwin {
    // macOS-specific code
} else when ODIN_OS == .Linux {
    // Linux-specific code
}
```

#### Platform-Specific Types
```cpp
// C++: Platform-specific types
#ifdef _WIN32
typedef HWND WindowHandle;
#else
typedef void* WindowHandle;
#endif
```

```odin
// Odin: Platform-specific types
when ODIN_OS == .Windows {
    WindowHandle :: distinct rawptr  // HWND
} else {
    WindowHandle :: distinct rawptr  // void*
}
```

## Testing Strategy

### 1. Print-Based Testing
```odin
test_reference_counting :: proc() {
    fmt.println("  Testing reference counting functions...")
    
    // Test with nil pointer
    nil_ptr: CefRefCounted = nil
    
    result := has_one_ref(nil_ptr)
    fmt.println("    has_one_ref(nil) =", result)
    
    // If execution reaches here, no crash occurred
    fmt.println("  Reference counting test completed")
}
```

### 2. Memory Corruption Detection
```odin
test_string_handling :: proc() {
    fmt.println("  Testing string handling...")
    
    // Test string creation
    str := cef_string_create("test")
    fmt.println("    Created string")
    
    // Test string conversion
    utf8_str := cef_stringo_utf8(str)
    fmt.println("    Converted to UTF8")
    
    // If execution reaches here, no memory corruption
    fmt.println("  String handling test completed")
}
```

### 3. Incremental Testing
```odin
// Test each component as it's translated
test_basic_types :: proc() {
    fmt.println("Test 1: Basic types")
    // Test basic type translations
}

test_reference_counting :: proc() {
    fmt.println("Test 2: Reference counting")
    // Test reference counting
}

test_string_handling :: proc() {
    fmt.println("Test 3: String handling")
    // Test string operations
}
```

## Implementation Plan

### Phase 1: Core Infrastructure (Start Here)
1. **Base Types** (`cef_base.h`): Reference counting, basic types
2. **String Handling** (`cef_string.h`): UTF8/UTF16/Wide string conversion
3. **Platform Abstractions**: OS-specific types and functions

### Phase 2: Application Framework
1. **App Interface** (`cef_app.h`): Main application interface
2. **Settings and Configuration**: Command line, settings structures
3. **Process Handlers**: Browser and render process handlers

### Phase 3: Browser Interface
1. **Browser Objects**: Browser, frame, client interfaces
2. **Lifecycle Handlers**: Load, display, focus handlers
3. **Navigation**: URL handling, navigation events

### Phase 4: Advanced Features
1. **V8 Integration**: JavaScript engine interface
2. **DOM Access**: Document object model
3. **Custom Schemes**: URL scheme handling

## Specific Translation Examples

### Example 1: CefString Translation - ACTUAL COMPARISON
```cpp
// C++: Actual CEF string struct
typedef struct _cef_string_utf16_t {
    char16_t* str;
    size_t length;
    void (*dtor)(char16_t* str);
} cef_string_utf16_t;
```

```odin
// Odin: Direct translation
CefString :: struct {
    str: [^]u16,  // char16_t* -> [^]u16
    length: c.size_t,  // size_t -> c.size_t
    dtor: proc "c" ([^]u16),  // void (*dtor)(char16_t* str) -> proc "c" ([^]u16)
}

// Helper functions
string_create :: proc(text: string) -> CefString {
    // Convert UTF8 to UTF16
}

string_destroy :: proc(str: ^CefString) {
    if str.dtor != nil {
        str.dtor(str.str)
    }
}
```

### Example 2: CefRefPtr Translation
```cpp
// C++: Smart pointer template
CefRefPtr<CefApp> app = CefApp::Create();
```

```odin
// Odin: Manual reference counting
CefRefPtr_App :: struct {
    ptr: ^CefApp,
}

ref_ptr_create :: proc(ptr: ^CefApp) -> CefRefPtr_App {
    if ptr != nil {
        add_ref(cast(CefRefCounted)ptr)
    }
    return CefRefPtr_App{ptr = ptr}
}

ref_ptr_destroy :: proc(ref_ptr: ^CefRefPtr_App) {
    if ref_ptr != nil && ref_ptr.ptr != nil {
        release(cast(CefRefCounted)ref_ptr.ptr)
        ref_ptr.ptr = nil
    }
}
```

### Example 3: Virtual Function Translation
```cpp
// C++: Virtual interface
class CefApp {
    virtual void OnBeforeCommandLineProcessing(
        const CefString& process_type,
        CefRefPtr<CefCommandLine> Command_line) = 0;
};
```

```odin
// Odin: Function pointer with context
CommandLine_Processing_Proc :: #type proc "c" (
    ctx: rawptr,
    process_type: CefString,
    Command_line: CefRefPtr_CommandLine
)

CefApp_Handler :: struct {
    on_before_command_line_processing: CommandLine_Processing_Proc,
    ctx: rawptr,
}
```

## Questions and Uncertainties

1. **C++ Exception Handling**: How to handle C++ exceptions in Odin?
2. **Template Specialization**: How to handle complex template types?
3. **Virtual Function Tables**: How to properly map virtual function calls?
4. **Platform-Specific Features**: How to handle OS-specific APIs?
5. **Memory Layout**: How to ensure struct layout matches C++ exactly?
6. **String Encoding**: How to handle UTF8/UTF16/Wide string conversions?
7. **Reference Counting**: How to prevent memory leaks and use-after-free?
8. **Calling Conventions**: How to match C++ calling conventions exactly?

## Next Steps

1. Create the `Odin_CEF` directory structure
2. Start with `cef_base.h` translation
3. Implement basic reference counting
4. Create simple test to verify basic functionality
5. Iterate and expand based on testing results

## CEF Translation Guidelines - UPDATED

### File-by-File Translation Approach

**CRITICAL**: Each CEF C API file should be translated to a separate Odin file with the same name and location in the `Odin_CEF` directory structure as the original CEF file.

### Directory Structure Mapping
```
CEF/include/cef_accessibility_handler_capi.h
↓
Odin_CEF/include/cef_accessibility_handler_capi.odin
```

### Package Name
All Odin files should use the package name `odin_cef` (not individual package names per file).

### What to Include in Each File

**INCLUDE ONLY**:
- The main struct/type that the file defines
- Minimal forward declarations for dependencies used in that file
- Comments and documentation from the original file

**DO NOT INCLUDE**:
- Complete definitions of dependency types (those go in their own files)
- Helper functions (those go in separate utility files)
- Platform-specific imports (those go in a central imports file)
- Foreign library declarations (those go in a central bindings file)

### Translation Example: cef_accessibility_handler_capi.h

**Original C file contains**:
```c
typedef struct _cef_accessibility_handler_t {
  base_ref_counted base;
  void(cef_callback* on_accessibility_tree_change)(
      struct _cef_accessibility_handler_t* self,
      struct _cef_value_t* value);
  void(cef_callback* on_accessibility_location_change)(
      struct _cef_accessibility_handler_t* self,
      struct _cef_value_t* value);
} cef_accessibility_handler_t;
```

**Translated to Odin**:
```odin
package odin_cef

import "core:c"

// Forward declarations for dependencies
CefBaseRefCounted :: struct {
    size: c.size_t,
    add_ref: proc "c" (self: ^CefBaseRefCounted),
    release: proc "c" (self: ^CefBaseRefCounted) -> i32,
    has_one_ref: proc "c" (self: ^CefBaseRefCounted) -> i32,
    has_at_least_one_ref: proc "c" (self: ^CefBaseRefCounted) -> i32,
}

CefValue :: struct {
    base: CefBaseRefCounted,
    // ... other members will be defined in cef_values_capi.odin
}

///
/// Implement this structure to receive accessibility notification when
/// accessibility events have been registered. The functions of this structure
/// will be called on the UI thread.
///
/// NOTE: This struct is allocated client-side.
///
CefAccessibilityHandler :: struct {
    ///
    /// Base structure.
    ///
    base: CefBaseRefCounted,

    ///
    /// Called after renderer process sends accessibility tree changes to the
    /// browser process.
    ///
    on_accessibility_tree_change: proc "c" (self: ^CefAccessibilityHandler, value: ^CefValue),

    ///
    /// Called after renderer process sends accessibility location changes to the
    /// browser process.
    ///
    on_accessibility_location_change: proc "c" (self: ^CefAccessibilityHandler, value: ^CefValue),
}
```

### What Was Left Out (Will Be in Other Files)

**From cef_base_capi.h** (will be in `cef_base_capi.odin`):
- Complete `CefBaseRefCounted` definition
- Reference counting helper functions
- Platform-specific types

**From cef_values_capi.h** (will be in `cef_values_capi.odin`):
- Complete `CefValue` definition with all methods
- `CefValueType` enum
- `CefBinaryValue`, `CefDictionaryValue`, `CefListValue` structs
- All value manipulation functions

**From cef_string_capi.h** (will be in `cef_string_capi.odin`):
- `CefString` struct definition
- `CefStringUserFree` type
- `CefStringList` type
- String manipulation functions

**Helper Functions** (will be in separate utility files):
- Reference counting wrappers
- Creation/destruction helpers
- Memory management utilities

### Common Confusion Points

1. **Package Names**: Always use `odin_cef`, never create individual package names
2. **File Locations**: Mirror the exact CEF directory structure in Odin_CEF
3. **Dependencies**: Only include forward declarations, not full definitions
4. **Function Pointers**: Use `proc "c"` calling convention for all CEF functions
5. **Return Types**: Use `b32` for 32-bit booleans, `c.int` for C ints
6. **Struct Names**: Use snake_case without cef_ prefix (e.g., `accessibility_handler`) following Odin convention
7. **Generic Names**: Use Cef prefix for generic names to avoid conflicts (e.g., `CefString`, `CefValue`)
7. **Comments**: Preserve all original comments and documentation
8. **Copyright**: Do NOT include the original copyright header (remove all boilerplate text)

### Translation Checklist

For each file:
- [ ] Use correct package name (`odin_cef`)
- [ ] Place file in correct directory structure
- [ ] Include only the main struct/type from the original file
- [ ] Add minimal forward declarations for dependencies
- [ ] Preserve all original comments and documentation
- [ ] Use `proc "c"` calling convention for function pointers
- [ ] Use `b32` for 32-bit booleans, `c.int` for C ints (following furbs convention)
- [ ] Use snake_case without cef_ prefix for struct names (following Odin convention)
- [ ] Use Cef prefix for generic names to avoid conflicts (e.g., CefString, CefValue)
- [ ] Do NOT include original copyright header (remove all boilerplate text)
- [ ] Do NOT include helper functions or utility code
- [ ] Do NOT include complete dependency definitions

## Existing Translation Patterns from furbs/fastnoise, furbs/glslang, and odin_steamworks

### 1. fastnoise Translation Pattern
**File**: `furbs/fastnoise/fast_noise.odin`

**Key Patterns**:
- **Package name**: Uses descriptive package name (`fast_noise`)
- **Foreign imports**: Platform-specific library imports with debug/release variants
- **Type mapping**: `void*` → `distinct rawptr` (e.g., `Node_tree :: distinct rawptr`)
- **Function declarations**: Uses `@(default_calling_convention="c")` and `foreign lib` block
- **Array parameters**: `float*` → `[^]f32` (pointer to array, provides context)
- **Optional parameters**: `float output_min_max[2]` → `^[2]f32` (pointer to array)
- **Comments**: Preserves original C comments and documentation

**Example**:
```odin
Node_tree :: distinct rawptr;

@(default_calling_convention="c")
foreign lib {
    fnGenUniformGrid2D :: proc(node_tree: Node_tree, noise_out: [^]f32,
                               x_start: i32, y_start: i32,
                               x_size: i32, y_size: i32,
                               frequency: f32, seed: i32, 
                               output_min_max: ^[2]f32) ---;
}
```

### 2. glslang Translation Pattern
**File**: `furbs/glslang/glslang_bindings/glslang.odin`

**Key Patterns**:
- **Package name**: Uses descriptive package name (`glslang_bindings`)
- **Complex foreign imports**: Multiple library files with debug/release variants
- **Enum translations**: Direct mapping with explicit values
- **Bit sets**: Uses `bit_set[Enum; u32]` for flags
- **Struct alignment**: No explicit alignment (unlike steamworks)
- **Version handling**: Includes version constants and comparison functions

**Example**:
```odin
Stage :: enum u32 {
    vertex,
    tesscontrol,
    // ...
}

Messages_enum :: enum u32 {
    relaxed_errors = 0,
    suppress_warnings = 1,
    // ...
}
Messages :: bit_set[Messages_enum; u32];
```

### 3. steamworks Translation Pattern
**File**: `odin_steamworks/steamworks/steamworks.odin`

**Key Patterns**:
- **Package name**: Uses descriptive package name (`steamworks`)
- **Struct alignment**: Uses `#align(CALLBACK_ALIGN)` for callback structs
- **Union handling**: Uses `#raw_union` for C unions
- **Endian handling**: Platform-specific struct layouts
- **Distinct types**: Uses `distinct` for opaque handles
- **Function pointer types**: Uses `#type proc "c"` for callback types

**Example**:
```odin
CALLBACK_ALIGN :: 8 when CALLBACK_PACK_LARGE else 4

SteamNetworkingMessage :: struct #align(CALLBACK_ALIGN) {
    pData: rawptr,
    cbSize: i32,
    // ...
}

SteamInputActionEventCallbackPointer :: #type proc "c" (_: ^SteamInputActionEvent)
```

### Key Differences from CEF Translation

1. **Package Names**: 
   - fastnoise/glslang/steamworks: Use descriptive package names
   - CEF: Use unified `odin_cef` package name

2. **Struct Alignment**:
   - fastnoise/glslang: No alignment
   - steamworks: Uses `#align(CALLBACK_ALIGN)`
   - CEF: No alignment (like fastnoise/glslang)

3. **Foreign Imports**:
   - fastnoise/glslang/steamworks: Include in each file
   - CEF: Should be centralized (per notes)

4. **File Organization**:
   - fastnoise/glslang/steamworks: Single comprehensive files
   - CEF: File-by-file translation with separate dependency files

### Lessons for CEF Translation

1. **Use `distinct rawptr`** for opaque C pointers
2. **Use `[^]f32`** for array parameters (provides context that it's an array, not single element)
3. **Use `^[2]f32`** for optional array pointers
4. **Preserve original comments** and documentation
5. **Use `proc "c"`** calling convention for all C functions
6. **No alignment needed** for CEF (unlike steamworks)
7. **File-by-file approach** is different from these examples

**Note**: The furbs translations are user-created and may contain bugs. The steamworks translation is for a C++ API, not C API, so its approach is likely more correct for CEF translation. 