# Hello WASI (C)

This example shows how to compile C code to WebAssembly with WASI support and run it in WasmEdge.

## The Code

Here's a minimal C program using WASI:

```c
#include <stdio.h>

int main(int argc, char** argv) {
    const char* name = (argc > 1) ? argv[1] : "WasmEdge";
    printf("Hello, %s! 🚀 Running in WasmEdge (WASI).\n", name);
    return 0;
}
```

### How It Works

1. **Standard C Library**: We use `stdio.h` for `printf`
2. **Command-line Arguments**: Access via `argc` and `argv` (WASI provides these)
3. **Output**: `printf` writes to stdout through WASI's `fd_write`

## Building

Compile C to WebAssembly using Clang with the WASI target:

```bash
cd demo/examples/c/hello
mkdir -p build && cd build

clang --target=wasm32-wasi -O3 \
  -nostartfiles \
  -Wl,--export=main \
  -Wl,--allow-undefined \
  ../hello.c -o hello.wasm
```

### Build Flags Explained

- `--target=wasm32-wasi`: Target WebAssembly with WASI
- `-O3`: Optimize for performance
- `-nostartfiles`: Don't use standard C startup files (WASI provides its own)
- `-Wl,--export=main`: Export the main function
- `-Wl,--allow-undefined`: Allow WASI imports

## Alternative: Using WASI SDK

For a more complete WASI environment, use the [WASI SDK](https://github.com/WebAssembly/wasi-sdk):

```bash
# Download WASI SDK
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-21/wasi-sdk-21.0-linux.tar.gz
tar xf wasi-sdk-21.0-linux.tar.gz

# Compile with WASI SDK
./wasi-sdk-21.0/bin/clang hello.c -o hello.wasm
```

## Running

Execute with WasmEdge:

```bash
wasmedge demo/examples/c/hello/build/hello.wasm World
```

Output:
```
Hello, World! 🚀 Running in WasmEdge (WASI).
```

## Why C + WebAssembly?

C is an excellent choice for WebAssembly because:

- **Mature Ecosystem**: Decades of libraries and code
- **Performance**: Direct mapping to Wasm instructions
- **Portability**: Recompile existing C code to Wasm with minimal changes
- **Small Binaries**: C produces compact Wasm modules

## Inspecting the Wasm Module

Use `wasm-objdump` to examine the compiled module:

```bash
wasm-objdump -x hello.wasm
```

You'll see:
- Imported WASI functions (`fd_write`, `environ_get`, etc.)
- Exported functions (`main`, `_start`)
- Memory layout
- Function signatures

## WASI Functions Used

This simple program relies on several WASI functions:

- `fd_write`: Write to file descriptor (stdout)
- `args_get`: Retrieve command-line arguments
- `args_sizes_get`: Get argument buffer sizes
- `proc_exit`: Exit the process

## Advanced Example: Reading a File

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("input.txt", "r");
    if (!file) {
        printf("Could not open file\n");
        return 1;
    }
    
    char buffer[256];
    while (fgets(buffer, sizeof(buffer), file)) {
        printf("%s", buffer);
    }
    
    fclose(file);
    return 0;
}
```

Run with file access:
```bash
# Allow reading from current directory
wasmedge --dir .:. hello.wasm
```

## Performance Comparison

C-compiled WebAssembly is typically:

- **Near-native speed** with AOT compilation
- **Smaller than JavaScript** for equivalent functionality
- **Faster startup** than JIT-compiled languages

## Porting Existing C Code

To port existing C projects:

1. Replace platform-specific code with WASI equivalents
2. Use WASI SDK for complete libc support
3. Test with multiple WASI runtimes (WasmEdge, Wasmtime, etc.)
4. Consider using [wasi-libc](https://github.com/WebAssembly/wasi-libc) for additional functions

## Common Challenges

### Missing libc Functions

Some functions may not be available in WASI:

- Threading (WASI doesn't support threads yet)
- Network sockets (use WasmEdge socket extension)
- Process forking (not applicable in sandboxed environment)

### Solution: WasmEdge Extensions

WasmEdge provides extensions for common needs:

```c
// Use WasmEdge socket extension
#include <wasmedge/socket.h>

int sock = socket_create(AF_INET, SOCK_STREAM);
```

## Next Steps

- Compare with the [Rust version](rust-hello.md)
- Try the [serverless function demo](serverless-function.md)
- Build a [microservice CLI](microservice-cli.md)

---

*For more on C and WebAssembly, see the [WebAssembly C API documentation](https://github.com/WebAssembly/wasm-c-api)*
