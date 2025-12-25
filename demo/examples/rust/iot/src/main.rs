use std::time::{SystemTime, UNIX_EPOCH};

fn main() {
    println!("IoT Edge Simulation: Processing sensor data...");
    
    // Simulate reading sensor data
    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs();
    
    let temperature = 20.0 + ((timestamp % 100) as f64) / 10.0;
    let humidity = 40.0 + ((timestamp % 50) as f64);
    
    println!("Timestamp: {}", timestamp);
    println!("Temperature: {:.1}°C", temperature);
    println!("Humidity: {:.1}%", humidity);
    
    // Simple threshold check
    if temperature > 30.0 {
        println!("⚠️  Alert: High temperature detected!");
    }
    
    if humidity < 30.0 || humidity > 70.0 {
        println!("⚠️  Alert: Humidity out of optimal range!");
    }
    
    println!("✅ Data processed and stored securely in WasmEdge sandbox");
}
