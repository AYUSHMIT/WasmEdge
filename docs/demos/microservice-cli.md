# Microservice-style CLI

This example demonstrates a microservice pattern where different commands are handled by a single WebAssembly module - perfect for building modular, extensible CLIs.

## Concept

Instead of a monolithic application, we build:
- A single Wasm module with multiple commands
- Each command is a separate logical service
- Commands can be extended without recompiling the host
- Sandboxed execution ensures safety

## The Code

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() < 2 {
        println!("Microservice CLI - Available commands:");
        println!("  info    - Display system information");
        println!("  greet   - Greet a user");
        println!("  compute - Perform a simple calculation");
        return;
    }
    
    match args[1].as_str() {
        "info" => {
            println!("System: WasmEdge Runtime");
            println!("Architecture: WebAssembly (WASI)");
            println!("Isolation: Full sandbox");
        },
        "greet" => {
            let name = args.get(2).map(|s| s.as_str()).unwrap_or("User");
            println!("Hello, {}! Welcome to the microservice.", name);
        },
        "compute" => {
            let a = args.get(2).and_then(|s| s.parse::<i32>().ok()).unwrap_or(10);
            let b = args.get(3).and_then(|s| s.parse::<i32>().ok()).unwrap_or(5);
            println!("Computing: {} + {} = {}", a, b, a + b);
            println!("Computing: {} * {} = {}", a, b, a * b);
        },
        _ => {
            println!("Unknown command: {}", args[1]);
            println!("Use no arguments to see available commands.");
        }
    }
}
```

## Building

```bash
cd demo/examples/rust/microservice
cargo build --release --target wasm32-wasi
```

## Running

### Show Help

```bash
wasmedge demo/examples/rust/microservice/target/wasm32-wasi/release/wasmedge_microservice.wasm
```

Output:
```
Microservice CLI - Available commands:
  info    - Display system information
  greet   - Greet a user
  compute - Perform a simple calculation
```

### Info Command

```bash
wasmedge demo/examples/rust/microservice/target/wasm32-wasi/release/wasmedge_microservice.wasm info
```

Output:
```
System: WasmEdge Runtime
Architecture: WebAssembly (WASI)
Isolation: Full sandbox
```

### Greet Command

```bash
wasmedge demo/examples/rust/microservice/target/wasm32-wasi/release/wasmedge_microservice.wasm greet Alice
```

Output:
```
Hello, Alice! Welcome to the microservice.
```

### Compute Command

```bash
wasmedge demo/examples/rust/microservice/target/wasm32-wasi/release/wasmedge_microservice.wasm compute 15 7
```

Output:
```
Computing: 15 + 7 = 22
Computing: 15 * 7 = 105
```

## Architecture Pattern

This pattern is useful for:

### Plugin Systems

Load user-contributed commands as Wasm modules:

```
host-app
├── core (native)
└── plugins/
    ├── user-plugin1.wasm
    ├── user-plugin2.wasm
    └── user-plugin3.wasm
```

### Multi-Tenant SaaS

Each tenant gets isolated Wasm modules:

```rust
// Host application in Rust
use wasmedge_sdk::*;

fn handle_tenant_request(tenant_id: &str, command: &str) {
    let wasm_path = format!("tenants/{}/commands.wasm", tenant_id);
    let vm = Vm::new(Store::new()).unwrap();
    vm.run_func_from_file(&wasm_path, "execute", params!(command)).unwrap();
}
```

### Command Router

Route commands to different Wasm modules:

```
Request: "image resize"
  ↓
Router (native)
  ↓
image-tools.wasm → resize function
```

## Advanced Pattern: Shared State

Use host functions to share state between invocations:

```rust
// Host provides a key-value store
#[no_mangle]
pub extern "C" fn host_set(key: i32, value: i32) {
    // Host implementation
}

#[no_mangle]
pub extern "C" fn host_get(key: i32) -> i32 {
    // Host implementation
}
```

Wasm module uses it:

```rust
extern "C" {
    fn host_set(key: i32, value: i32);
    fn host_get(key: i32) -> i32;
}

fn main() {
    unsafe {
        host_set(42, 100);
        let value = host_get(42);
        println!("Value: {}", value);
    }
}
```

## Real-World Use Cases

### Development Tools

```bash
# Version control plugin
wasmedge devtool.wasm git commit -m "Update"

# Build tool plugin
wasmedge devtool.wasm build --release

# Test runner plugin
wasmedge devtool.wasm test --all
```

### Database CLI

```bash
# Connect and query
wasmedge dbcli.wasm connect postgres://localhost
wasmedge dbcli.wasm query "SELECT * FROM users"
wasmedge dbcli.wasm migrate up
```

### Infrastructure Management

```bash
# Deploy services
wasmedge infra.wasm deploy app-v1.2.3

# Scale services
wasmedge infra.wasm scale app --replicas 5

# Monitor services
wasmedge infra.wasm status
```

## Benefits

### For Host Applications

- **Safety**: Third-party code runs in sandbox
- **Portability**: Same plugins work everywhere
- **Performance**: Near-native speed with AOT
- **Simplicity**: No complex IPC or networking

### For Plugin Developers

- **Easy Development**: Use Rust, C, Go, etc.
- **Standard Interface**: WASI provides consistent API
- **Distribution**: Ship a single .wasm file
- **Version Management**: Clear versioning of plugins

## Error Handling

Robust error handling in commands:

```rust
fn execute_command(cmd: &str, args: &[String]) -> Result<(), String> {
    match cmd {
        "process" => {
            let input = args.get(0)
                .ok_or("Missing input file")?;
            
            // Process file
            std::fs::read_to_string(input)
                .map_err(|e| format!("Cannot read file: {}", e))?;
            
            Ok(())
        },
        _ => Err(format!("Unknown command: {}", cmd))
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if let Err(e) = execute_command(&args[1], &args[2..]) {
        eprintln!("Error: {}", e);
        std::process::exit(1);
    }
}
```

## Configuration

Pass configuration via environment variables:

```bash
CONFIG_PATH=/etc/app.conf \
LOG_LEVEL=debug \
wasmedge microservice.wasm process
```

Read in Wasm:

```rust
use std::env;

let config_path = env::var("CONFIG_PATH")
    .unwrap_or("/default/config".to_string());
let log_level = env::var("LOG_LEVEL")
    .unwrap_or("info".to_string());
```

## Testing

Test individual commands:

```bash
# Test info command
./test-info.sh

# Test greet command with various inputs
for name in Alice Bob Charlie; do
  wasmedge microservice.wasm greet "$name"
done

# Test compute edge cases
wasmedge microservice.wasm compute 0 0
wasmedge microservice.wasm compute -5 10
```

## Performance Optimization

### Command Dispatch

Use efficient matching:

```rust
// Instead of repeated if/else
match command.as_str() {
    "cmd1" => handle_cmd1(),
    "cmd2" => handle_cmd2(),
    "cmd3" => handle_cmd3(),
    _ => handle_unknown(),
}
```

### Lazy Loading

Only load what you need:

```rust
fn main() {
    let cmd = args[1].as_str();
    
    // Only load heavy dependencies for specific commands
    if cmd == "ml-infer" {
        let model = load_ml_model(); // Heavy operation
        ml_infer(model);
    }
}
```

## Next Steps

- Try the [IoT simulation](iot-sim.md) for edge computing patterns
- Learn about [serverless functions](serverless-function.md)
- Explore the [architecture](../architecture.md) behind WasmEdge

---

*For building production CLIs with Wasm, check out the [WasmEdge Go SDK](https://wasmedge.org/docs/category/go-sdk-for-embedding-wasmedge)*
