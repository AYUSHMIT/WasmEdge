#!/usr/bin/env bash
set -euo pipefail

# Build Rust example to wasm32-wasi
echo "[Rust] Building hello example..."
pushd demo/examples/rust/hello >/dev/null
cargo build --release --target wasm32-wasi
popd >/dev/null

# Build C example to wasm32-wasi using clang
echo "[C] Building hello example..."
pushd demo/examples/c/hello >/dev/null
mkdir -p build && cd build
# Requires WASI toolchain; for simplicity, we use clang with wasi sysroot if available.
# If wasi-sysroot is not installed, consider using zig as a portable toolchain.
clang --target=wasm32-wasi -O3 -nostartfiles -Wl,--export=main \
  -Wl,--allow-undefined \
  ../hello.c -o hello.wasm
popd >/dev/null

echo "Build complete."
