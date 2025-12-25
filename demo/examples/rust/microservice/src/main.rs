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
