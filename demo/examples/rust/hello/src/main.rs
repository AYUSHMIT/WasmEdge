use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let name = args.get(1).map(|s| s.as_str()).unwrap_or("WasmEdge");
    println!("Hello, {name}! 🚀 Running in WasmEdge (WASI).");
}
