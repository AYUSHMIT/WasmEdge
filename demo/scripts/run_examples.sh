#!/usr/bin/env bash
set -euo pipefail

echo "[Run] Rust hello"
wasmedge demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.wasm "Explorer"

echo "[Run] C hello"
wasmedge demo/examples/c/hello/build/hello.wasm "Explorer"

# Optional AOT compilation for performance exploration
if command -v wasmedgec >/dev/null 2>&1; then
  echo "[AOT] Compiling Rust hello to native..."
  wasmedgec demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.wasm demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.aot.wasm
  echo "[Run AOT] Rust hello"
  wasmedge demo/examples/rust/hello/target/wasm32-wasi/release/wasmedge_hello.aot.wasm "Explorer"
fi
