#!/usr/bin/env bash
set -euo pipefail

echo "[Run] Rust hello"
wasmedge demo/examples/rust/hello/target/wasm32-wasip1/release/wasmedge_hello.wasm "Explorer"

echo ""
if [ -f demo/examples/c/hello/build/hello.wasm ] && [ ! -f demo/examples/c/hello/build/hello.wasm.skip ]; then
  echo "[Run] C hello"
  wasmedge demo/examples/c/hello/build/hello.wasm "Explorer"
else
  echo "[Skip] C hello (not built - WASI SDK not available)"
fi

echo ""
echo "[Run] Serverless function"
echo "This is a test input with multiple words" | wasmedge demo/examples/rust/serverless/target/wasm32-wasip1/release/wasmedge_serverless.wasm

echo ""
echo "[Run] Microservice CLI - info"
wasmedge demo/examples/rust/microservice/target/wasm32-wasip1/release/wasmedge_microservice.wasm info

echo ""
echo "[Run] Microservice CLI - greet"
wasmedge demo/examples/rust/microservice/target/wasm32-wasip1/release/wasmedge_microservice.wasm greet "Demo User"

echo ""
echo "[Run] Microservice CLI - compute"
wasmedge demo/examples/rust/microservice/target/wasm32-wasip1/release/wasmedge_microservice.wasm compute 42 7

echo ""
echo "[Run] IoT simulation"
wasmedge demo/examples/rust/iot/target/wasm32-wasip1/release/wasmedge_iot.wasm

# Optional AOT compilation for performance exploration
if command -v wasmedgec >/dev/null 2>&1; then
  echo ""
  echo "[AOT] Compiling Rust hello to native..."
  wasmedgec demo/examples/rust/hello/target/wasm32-wasip1/release/wasmedge_hello.wasm demo/examples/rust/hello/target/wasm32-wasip1/release/wasmedge_hello.aot.wasm
  echo "[Run AOT] Rust hello"
  wasmedge demo/examples/rust/hello/target/wasm32-wasip1/release/wasmedge_hello.aot.wasm "Explorer"
fi

echo ""
echo "✅ All demos completed successfully!"
