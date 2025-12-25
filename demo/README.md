# WasmEdge Creative Exploratory Demo

This demo showcases WasmEdge — a lightweight, high-performance, and extensible WebAssembly runtime for cloud-native, edge, and decentralized applications.

## Quickstart

1. Build WasmEdge (or install via your package manager).
2. Build and run the examples:
   ```bash
   ./demo/scripts/build_examples.sh
   ./demo/scripts/run_examples.sh
   ```

3. Explore the docs site (if using GitHub Pages):
   - Visit: https://ayushmit.github.io/WasmEdge/

## What you'll see

- Hello WASI examples in Rust and C
- Serverless-style function demo (input/output processing)
- Microservice-style CLI demo
- Edge/IoT simulation demo
- Architecture diagram & charts (language composition, simple performance)
- AOT vs interpreter exploration

## Requirements

- WasmEdge CLI (e.g., `wasmedge`, `wasmedgec`)
- clang or gcc for C (with WASI toolchain)
- Rust (with `wasm32-wasi` target)
- Python 3 (optional) for generating charts/diagrams

## Structure

```
demo/
  examples/
    rust/hello/
    c/hello/
  scripts/
    build_examples.sh
    run_examples.sh
  visuals/
    architecture.svg
    languages.svg
    performance.svg
```

## Notes

- This demo is descriptive and exploratory. It is not intended to benchmark formally.
- For deeper usage (plugins, host extensions), consult the official WasmEdge docs and repo.
