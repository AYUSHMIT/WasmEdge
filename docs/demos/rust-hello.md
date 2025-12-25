# Hello WASI (Rust)

This example demonstrates the simplest possible WebAssembly System Interface (WASI) application written in Rust.

## What is WASI?

WASI (WebAssembly System Interface) is a modular system interface for WebAssembly. It provides:

- Portable system calls across different operating systems
- Secure, capability-based access to resources
- Standard interfaces for files, networking, and more

## The Code

Here's our Hello World implementation in Rust:

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let name = args.get(1).map(|s| s.as_str()).unwrap_or("WasmEdge");
    println!("Hello, {name}! 🚀 Running in WasmEdge (WASI).");
}
```

### What's Happening?

1. **Import environment module**: Access to command-line arguments
2. **Read arguments**: Get the first argument or use default
3. **Print output**: Use standard output (WASI provides this)

## Building

The Rust toolchain makes it easy to compile to WebAssembly:

```bash
cd demo/examples/rust/hello
cargo build --release --target wasm32-wasi
```

This produces a `.wasm` file at:
```
target/wasm32-wasi/release/wasmedge_hello.wasm
```

### Build Configuration

Our `Cargo.toml` is minimal:

```toml
[package]
name = "wasmedge_hello"
version = "0.1.0"
edition = "2021"

[[bin]]
name = "wasmedge_hello"
path = "src/main.rs"
```

## Running

Execute the WebAssembly module with WasmEdge:

```bash
wasmedge demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.wasm Explorer
```

Output:
```
Hello, Explorer! 🚀 Running in WasmEdge (WASI).
```

## AOT Compilation

For better performance, compile to native code first:

```bash
# Compile Wasm to AOT
wasmedgec demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.wasm \
         demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.aot.wasm

# Run AOT-compiled module
wasmedge demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.aot.wasm Explorer
```

The AOT-compiled version:
- Executes significantly faster
- Uses more disk space
- Takes time to compile upfront

## Benefits of Rust + WASI

- **Memory Safety**: Rust's ownership system prevents common bugs
- **Zero-Cost Abstractions**: High-level code compiles to efficient Wasm
- **Rich Ecosystem**: Use Cargo crates (many are WASI-compatible)
- **Great Tooling**: `cargo`, `rustc`, and `rust-analyzer` support Wasm targets

## Exploring Further

Try modifying the code:

```rust
// Read from stdin
use std::io::{self, BufRead};

fn main() {
    println!("What's your name?");
    let stdin = io::stdin();
    let name = stdin.lock().lines().next().unwrap().unwrap();
    println!("Hello, {}!", name);
}
```

Build and run with:
```bash
echo "Alice" | wasmedge your_module.wasm
```

## Common WASI Functions

Rust's standard library maps to WASI automatically:

| Rust API | WASI Function | Purpose |
|----------|---------------|---------|
| `std::fs::File` | `fd_read`, `fd_write` | File I/O |
| `std::env::args()` | `args_get` | Command-line args |
| `std::env::var()` | `environ_get` | Environment variables |
| `std::time::SystemTime` | `clock_time_get` | Get current time |
| `println!()` | `fd_write` (stdout) | Print to console |

## Next Steps

- Try the [C Hello World](c-hello.md) example
- Build a [serverless function](serverless-function.md) that processes input
- Explore [microservice patterns](microservice-cli.md)

---

*Learn more about Rust and WebAssembly at [rustwasm.github.io](https://rustwasm.github.io/)*
