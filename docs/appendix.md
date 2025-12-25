# Appendix

This page provides setup instructions, troubleshooting tips, and additional resources for working with WasmEdge.

## Installation

### Quick Install (Linux/macOS)

```bash
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
```

This installs:
- `wasmedge` - The runtime CLI
- `wasmedgec` - The AOT compiler

### Manual Installation

#### Ubuntu/Debian

```bash
wget https://github.com/WasmEdge/WasmEdge/releases/download/0.13.5/WasmEdge-0.13.5-ubuntu20.04_x86_64.tar.gz
tar -xzf WasmEdge-0.13.5-ubuntu20.04_x86_64.tar.gz
sudo cp -r WasmEdge-0.13.5-Linux/bin/* /usr/local/bin/
sudo cp -r WasmEdge-0.13.5-Linux/lib/* /usr/local/lib/
sudo ldconfig
```

#### macOS (Homebrew)

```bash
brew install wasmedge
```

#### Windows

```powershell
# Using winget
winget install wasmedge

# Or download from GitHub releases
Invoke-WebRequest -Uri https://github.com/WasmEdge/WasmEdge/releases/download/0.13.5/WasmEdge-0.13.5-windows.zip -OutFile wasmedge.zip
Expand-Archive wasmedge.zip -DestinationPath C:\wasmedge
# Add C:\wasmedge\bin to PATH
```

### Verify Installation

```bash
wasmedge --version
# Expected output: wasmedge version 0.13.5

wasmedgec --version
# Expected output: wasmedgec version 0.13.5
```

## Building from Source

### Prerequisites

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
  cmake \
  build-essential \
  clang \
  lld \
  llvm-dev \
  liblld-dev

# macOS
brew install cmake llvm
```

### Build Steps

```bash
# Clone the repository
git clone https://github.com/WasmEdge/WasmEdge.git
cd WasmEdge

# Create build directory
mkdir build && cd build

# Configure
cmake -DCMAKE_BUILD_TYPE=Release \
      -DWASMEDGE_BUILD_TESTS=OFF \
      -DWASMEDGE_BUILD_AOT_RUNTIME=ON \
      ..

# Build (use all CPU cores)
cmake --build . -- -j$(nproc)

# Install
sudo cmake --install .
```

### Build Options

| Option | Description | Default |
|--------|-------------|---------|
| `WASMEDGE_BUILD_AOT_RUNTIME` | Enable AOT compiler | ON |
| `WASMEDGE_BUILD_TESTS` | Build test suite | ON |
| `WASMEDGE_BUILD_PLUGINS` | Build plugin system | ON |
| `WASMEDGE_PLUGIN_WASI_CRYPTO` | WASI crypto plugin | OFF |
| `WASMEDGE_PLUGIN_WASI_NN` | WASI NN plugin (AI/ML) | OFF |
| `CMAKE_BUILD_TYPE` | Build type (Release/Debug) | Release |

## Setting Up Wasm Development

### Rust Toolchain

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add wasm32-wasi target
rustup target add wasm32-wasi

# Verify
rustc --print target-list | grep wasi
```

### C/C++ with WASI SDK

```bash
# Download WASI SDK
export WASI_VERSION=21
export WASI_VERSION_FULL=${WASI_VERSION}.0
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz

# Extract
tar xf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz

# Add to PATH
export WASI_SDK_PATH=$PWD/wasi-sdk-${WASI_VERSION_FULL}
export PATH=$WASI_SDK_PATH/bin:$PATH

# Compile
clang --sysroot=$WASI_SDK_PATH/share/wasi-sysroot hello.c -o hello.wasm
```

### Go with TinyGo

```bash
# Install TinyGo
wget https://github.com/tinygo-org/tinygo/releases/download/v0.30.0/tinygo_0.30.0_amd64.deb
sudo dpkg -i tinygo_0.30.0_amd64.deb

# Compile Go to Wasm
tinygo build -target=wasi -o main.wasm main.go
```

### JavaScript/TypeScript

```bash
# Install AssemblyScript
npm install -g assemblyscript

# Initialize project
npx asinit .

# Build
npm run asbuild
```

## Running the Demo Examples

### Clone This Repository

```bash
git clone https://github.com/AYUSHMIT/WasmEdge.git
cd WasmEdge
```

### Build All Examples

```bash
# Make scripts executable
chmod +x demo/scripts/*.sh

# Build examples
./demo/scripts/build_examples.sh
```

### Run Examples

```bash
./demo/scripts/run_examples.sh
```

### Generate Visualizations

```bash
./demo/scripts/generate_visuals.sh
```

## Troubleshooting

### Common Issues

#### "wasmedge: command not found"

**Solution:**
```bash
# Check installation
which wasmedge

# Add to PATH if needed
export PATH=$HOME/.wasmedge/bin:$PATH

# Make permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH=$HOME/.wasmedge/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

#### "error loading shared libraries: libwasmedge.so"

**Solution:**
```bash
# Update library cache
sudo ldconfig

# Or set LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/.wasmedge/lib:$LD_LIBRARY_PATH
```

#### "cargo: not found" when building Rust examples

**Solution:**
```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Add wasm32-wasi target
rustup target add wasm32-wasi
```

#### "clang: error: unknown target: wasm32-wasi"

**Solution:**
Use WASI SDK instead of system clang:
```bash
# Download and use WASI SDK
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-21/wasi-sdk-21.0-linux.tar.gz
tar xf wasi-sdk-21.0-linux.tar.gz
./wasi-sdk-21.0/bin/clang hello.c -o hello.wasm
```

#### AOT compilation fails

**Solution:**
```bash
# Check if LLVM is available
wasmedge --version

# Should show "LLVM: YES"
# If not, rebuild WasmEdge with -DWASMEDGE_BUILD_AOT_RUNTIME=ON
```

### Debugging Wasm Modules

#### Enable Verbose Logging

```bash
wasmedge --log-level debug module.wasm
```

#### Inspect Wasm Module

```bash
# Install wabt (WebAssembly Binary Toolkit)
sudo apt-get install wabt

# Disassemble to WAT (WebAssembly Text)
wasm2wat module.wasm > module.wat

# View sections
wasm-objdump -h module.wasm

# View exports
wasm-objdump -x module.wasm | grep export
```

#### Validate Module

```bash
# Check if module is valid
wasm-validate module.wasm

# Validate with WasmEdge
wasmedge compile module.wasm
```

### Performance Issues

#### Slow Execution

Try AOT compilation:
```bash
wasmedgec module.wasm module.aot.wasm
wasmedge module.aot.wasm
```

#### High Memory Usage

Set memory limits:
```bash
wasmedge --default-memory-pages 64 module.wasm
```

#### Startup Latency

- Use AOT for long-running processes
- Use interpreter for short-lived functions
- Pre-warm modules in production

## Configuration

### Environment Variables

```bash
# Set log level
export WASMEDGE_LOG_LEVEL=debug

# Disable AOT cache
export WASMEDGE_DISABLE_AOT_CACHE=1

# Set plugin path
export WASMEDGE_PLUGIN_PATH=/usr/local/lib/wasmedge
```

### Runtime Options

```bash
# Memory configuration
wasmedge --default-memory-pages 256 \
         --default-max-memory-pages 512 \
         module.wasm

# Resource limits
wasmedge --gas-limit 1000000 \
         --time-limit 30 \
         module.wasm

# Directory mapping
wasmedge --dir /host/path:/wasm/path module.wasm

# Allow network access
wasmedge --allow-net module.wasm
```

## Best Practices

### Development

1. **Start Small**: Begin with simple examples
2. **Test Locally**: Validate before deploying
3. **Use Version Control**: Track Wasm modules
4. **Document Dependencies**: List required plugins

### Production

1. **Use AOT**: Compile modules ahead of time
2. **Set Limits**: Configure memory and CPU limits
3. **Monitor Performance**: Track execution time and memory
4. **Handle Errors**: Graceful degradation
5. **Security**: Validate inputs, limit capabilities

### Security

1. **Principle of Least Privilege**: Only grant needed capabilities
2. **Validate Inputs**: Don't trust external data
3. **Update Regularly**: Keep WasmEdge and modules updated
4. **Audit Modules**: Review third-party Wasm code
5. **Use Sandboxing**: Leverage WASI security model

## Additional Resources

### Documentation

- **Official Docs**: [wasmedge.org/docs](https://wasmedge.org/docs/)
- **Book**: [wasmedge.org/book](https://wasmedge.org/book/)
- **API Reference**: [wasmedge.org/docs/embed/c](https://wasmedge.org/docs/embed/c)

### Examples and Tutorials

- **GitHub Examples**: [github.com/WasmEdge/WasmEdge/tree/master/examples](https://github.com/WasmEdge/WasmEdge/tree/master/examples)
- **Awesome WasmEdge**: [github.com/WasmEdge/awesome-wasmedge](https://github.com/WasmEdge/awesome-wasmedge)

### Community

- **Discord**: [discord.gg/h4KDyB8XTt](https://discord.gg/h4KDyB8XTt)
- **Mailing List**: [groups.google.com/g/wasmedge](https://groups.google.com/g/wasmedge/)
- **Twitter**: [@realwasmedge](https://twitter.com/realwasmedge)
- **GitHub Discussions**: [github.com/WasmEdge/WasmEdge/discussions](https://github.com/WasmEdge/WasmEdge/discussions)

### Language Bindings

- **Go SDK**: [github.com/second-state/WasmEdge-go](https://github.com/second-state/WasmEdge-go)
- **Rust SDK**: [github.com/WasmEdge/wasmedge-rust-sdk](https://github.com/WasmEdge/wasmedge-rust-sdk)
- **Python SDK**: [github.com/second-state/wasmedge-python](https://github.com/second-state/wasmedge-python)
- **Node.js SDK**: [github.com/second-state/wasmedge-nodejs](https://github.com/second-state/wasmedge-nodejs)

## Contributing

Want to contribute to this demo or WasmEdge itself?

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

See [CONTRIBUTING.md](https://wasmedge.org/docs/contribute/overview) for details.

## License

This demo is part of the WasmEdge project, licensed under the Apache License 2.0.

---

*For questions or issues, please open an issue on [GitHub](https://github.com/AYUSHMIT/WasmEdge) or ask in the [Discord community](https://discord.gg/h4KDyB8XTt).*
