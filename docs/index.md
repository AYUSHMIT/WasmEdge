# WasmEdge Creative Exploratory Demo

Welcome! This site guides you through **what WasmEdge is**, **how it works**, and **what you can build** with it — using **beautiful visuals** and **hands-on examples**.

> WasmEdge is a lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications. It powers serverless apps, embedded functions, microservices, smart contracts, and IoT devices.

## Highlights

- 🎨 **Narrative explanations** with interactive diagrams
- 🚀 **Hello WASI** in Rust and C (run with WasmEdge)
- ⚡ **Serverless-style function** demo
- 🔧 **Microservice-style CLI** demo
- 🌐 **Edge/IoT simulation** demo
- 🏎️ **AOT vs interpreter** exploration
- 📊 **Language composition** and repository maps

## Why WasmEdge?

WasmEdge is recognized as one of the fastest WebAssembly runtimes available. It provides:

- **Performance**: Native-like speed with AOT compilation
- **Safety**: Sandboxed execution environment with memory isolation
- **Portability**: Run the same Wasm binary across platforms
- **Extensibility**: Rich plugin system for custom functionality
- **Standards Compliance**: Full WebAssembly and WASI support

## Quick Navigation

### 🏗️ [Architecture](architecture.md)
Learn about WasmEdge's internal structure, runtime core, plugin system, and how data flows through the system.

### 🎯 [Demos](demos/rust-hello.md)
Explore hands-on examples:
- Hello WASI (Rust & C)
- Serverless function processing
- Microservice CLI patterns
- IoT edge computing simulation

### 📈 [Exploration](exploration.md)
Dive into visualizations:
- Language composition of the codebase
- Performance comparisons
- Architecture diagrams

### 📚 [Appendix](appendix.md)
Setup guides, troubleshooting, and additional resources.

## Getting Started

To run these demos locally:

```bash
# Clone the repository
git clone https://github.com/AYUSHMIT/WasmEdge.git
cd WasmEdge

# Build the examples
./demo/scripts/build_examples.sh

# Run the examples
./demo/scripts/run_examples.sh
```

## Use Cases

WasmEdge excels in scenarios requiring:

- **Cloud-Native Applications**: Lightweight microservices and serverless functions
- **Edge Computing**: Run AI/ML inference at the edge with low latency
- **IoT Devices**: Secure, updateable code for resource-constrained devices
- **Blockchain**: Smart contract execution with safety and performance
- **Plugin Systems**: Safe execution of third-party code in applications

## Community

WasmEdge is a CNCF (Cloud Native Computing Foundation) sandbox project with an active community:

- 🌟 [GitHub Repository](https://github.com/WasmEdge/WasmEdge)
- 💬 [Discord Server](https://discord.gg/h4KDyB8XTt)
- 📧 [Mailing List](https://groups.google.com/g/wasmedge/)
- 📖 [Official Documentation](https://wasmedge.org/docs/)

---

*This demo site is designed to provide an accessible, visual introduction to WasmEdge. For production usage and advanced topics, please consult the [official documentation](https://wasmedge.org/docs/).*
