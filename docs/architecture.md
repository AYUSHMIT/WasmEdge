# Architecture

WasmEdge is designed with a modular architecture that balances performance, safety, and extensibility. This page explores the key components and how they work together.

## High-Level Overview

![WasmEdge Architecture](visuals/architecture.svg)

WasmEdge consists of several layers:

1. **Host Application Layer** - Your application that embeds WasmEdge
2. **Runtime Core** - The heart of WasmEdge with validation, execution, and memory management
3. **Plugins & Extensions** - WASI, networking, AI/ML, and custom extensions
4. **WebAssembly Modules** - Your compiled Wasm applications

## Core Components

### Validator

The validator ensures that WebAssembly modules are well-formed and safe to execute:

- **Structure Validation**: Verifies the module format and structure
- **Type Checking**: Ensures type safety of all operations
- **Instruction Validation**: Validates each instruction against the spec
- **Resource Limits**: Checks against configured limits (memory, tables, etc.)

```cpp
// Validation ensures safety before execution
Validator validator;
Result<void> validation_result = validator.validate(wasm_module);
```

### Executor

The executor runs WebAssembly bytecode using two strategies:

#### Interpreter Mode

- Bytecode is executed directly
- Faster startup time
- Lower memory footprint
- Ideal for short-lived functions

#### AOT (Ahead-of-Time) Compilation

- Compiles Wasm to native machine code
- Significantly faster execution
- Requires compilation step
- Best for long-running processes

```bash
# Compile with AOT
wasmedgec input.wasm output.aot.wasm

# Execute compiled module
wasmedge output.aot.wasm
```

### Memory Manager

WasmEdge provides robust memory isolation:

- **Linear Memory**: Sandboxed memory regions for each module
- **Bounds Checking**: Automatic protection against out-of-bounds access
- **Controlled Growth**: Memory can only grow, preventing use-after-free
- **Host-Guest Separation**: Clear boundaries between host and Wasm memory

```
┌─────────────────────────────┐
│   Host Application Memory   │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Wasm Module 1        │  │
│  │  Linear Memory        │  │
│  │  (Isolated)           │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Wasm Module 2        │  │
│  │  Linear Memory        │  │
│  │  (Isolated)           │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

## Plugin System

WasmEdge's plugin architecture allows extending functionality without modifying the core runtime:

### WASI (WebAssembly System Interface)

The foundation for portable system access:

- File system operations
- Environment variables
- Command-line arguments
- Clock and random number generation
- Socket operations (with extensions)

### Network Sockets

Extended networking capabilities beyond WASI:

- TCP/UDP socket support
- HTTP client functionality
- Async I/O for scalable network applications

### AI/ML Extensions

Run inference directly in Wasm:

- **PyTorch** backend for neural network inference
- **TensorFlow Lite** for optimized mobile models
- Hardware acceleration support (GPU, NPU)

### Database Drivers

Connect to databases from Wasm:

- PostgreSQL connector
- MySQL connector
- Query execution in isolated environment

## Execution Flow

Here's how a typical WasmEdge execution proceeds:

```
1. Load Wasm Module
   ↓
2. Validate Module Structure
   ↓
3. Instantiate Module
   ↓
4. Link Imports (WASI, plugins, host functions)
   ↓
5. Execute Entry Point
   ↓
6. Handle Calls Between Wasm and Host
   ↓
7. Clean Up and Return Results
```

## Performance Optimizations

WasmEdge employs several techniques to achieve high performance:

### Register-Based Interpreter

- More efficient than stack-based interpretation
- Reduced memory access operations
- Better CPU cache utilization

### LLVM-Based AOT

- Native code generation for target architecture
- Aggressive optimization passes
- Profile-guided optimization support

### Memory Layout Optimization

- Efficient allocation strategies
- Minimal copying between host and guest
- Cache-friendly data structures

## Security Model

Security is a fundamental design principle:

### Sandboxing

- Complete memory isolation between modules
- No direct access to host resources
- All I/O goes through controlled APIs

### Capability-Based Security

- Explicit grants for resource access
- Fine-grained permission control
- Principle of least privilege

### Resource Limits

- Configurable memory limits
- CPU time limits
- Fuel-based execution metering

## Language Support

WasmEdge can execute WebAssembly compiled from:

- **Rust** - First-class support with excellent tooling
- **C/C++** - Via clang with wasm target
- **Go** - Via TinyGo compiler
- **JavaScript** - Via QuickJS or other JS engines compiled to Wasm
- **AssemblyScript** - TypeScript-like language for Wasm
- **Swift** - Experimental support
- **Kotlin** - Via Kotlin/Native

## Next Steps

- Explore [hands-on demos](demos/rust-hello.md) to see WasmEdge in action
- Review [performance comparisons](exploration.md) between interpreter and AOT modes
- Check the [appendix](appendix.md) for setup instructions

---

*For detailed API documentation and advanced architecture topics, visit the [official WasmEdge documentation](https://wasmedge.org/docs/).*
