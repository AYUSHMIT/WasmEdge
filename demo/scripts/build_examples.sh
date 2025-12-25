#!/usr/bin/env bash
set -euo pipefail

# Build Rust examples to wasm32-wasip1
echo "[Rust] Building hello example..."
pushd demo/examples/rust/hello >/dev/null
cargo build --release --target wasm32-wasip1
popd >/dev/null

echo "[Rust] Building serverless example..."
pushd demo/examples/rust/serverless >/dev/null
cargo build --release --target wasm32-wasip1
popd >/dev/null

echo "[Rust] Building microservice example..."
pushd demo/examples/rust/microservice >/dev/null
cargo build --release --target wasm32-wasip1
popd >/dev/null

echo "[Rust] Building IoT example..."
pushd demo/examples/rust/iot >/dev/null
cargo build --release --target wasm32-wasip1
popd >/dev/null

# Build C example to wasm32-wasi using clang
echo "[C] Building hello example..."
pushd demo/examples/c/hello >/dev/null
mkdir -p build && cd build

# Check if WASI SDK is available or if clang has WASI support
if command -v wasi-sdk-clang >/dev/null 2>&1; then
  # Use WASI SDK if available
  wasi-sdk-clang -O3 ../hello.c -o hello.wasm
elif [ -n "${WASI_SDK_PATH:-}" ]; then
  # Use WASI_SDK_PATH if set
  ${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot -O3 ../hello.c -o hello.wasm
else
  # Try with system clang (may not work on all systems)
  echo "Note: WASI SDK not found. C example may not build successfully."
  echo "Install WASI SDK from: https://github.com/WebAssembly/wasi-sdk/releases"
  # Try anyway with clang
  if clang --target=wasm32-wasi -O3 -nostartfiles -Wl,--export=main \
    -Wl,--allow-undefined \
    ../hello.c -o hello.wasm 2>/dev/null; then
    echo "C example built successfully."
  else
    echo "Skipping C example (WASI SDK not available)."
    # Create a placeholder so the rest of the build continues
    touch hello.wasm.skip
  fi
fi
popd >/dev/null

echo "Build complete."
