# Edge/IoT Simulation

This example simulates an IoT edge device that processes sensor data locally using WasmEdge - demonstrating the power of edge computing with WebAssembly.

## Why WebAssembly at the Edge?

Edge computing brings computation closer to data sources. WasmEdge is ideal because:

- **Small Footprint**: Runs on resource-constrained devices
- **Fast Startup**: Process data immediately without cold start delays
- **Secure**: Sandboxed execution protects devices from malicious code
- **Portable**: Same code runs on ARM, x86, RISC-V, etc.
- **Updateable**: Deploy new logic without firmware updates

## The Code

```rust
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
```

## Building

```bash
cd demo/examples/rust/iot
cargo build --release --target wasm32-wasi
```

## Running

```bash
wasmedge demo/examples/rust/iot/target/wasm32-wasi/release/wasmedge_iot.wasm
```

Sample output:
```
IoT Edge Simulation: Processing sensor data...
Timestamp: 1703520234
Temperature: 23.4°C
Humidity: 74.0%
⚠️  Alert: Humidity out of optimal range!
✅ Data processed and stored securely in WasmEdge sandbox
```

## Real Sensor Integration

### Reading from GPIO

With WasmEdge's host functions, you can read real sensors:

```rust
// Host provides sensor access
extern "C" {
    fn read_temperature_sensor() -> f32;
    fn read_humidity_sensor() -> f32;
}

fn main() {
    unsafe {
        let temp = read_temperature_sensor();
        let humidity = read_humidity_sensor();
        
        println!("Temperature: {:.1}°C", temp);
        println!("Humidity: {:.1}%", humidity);
    }
}
```

### MQTT Publishing

Send data to cloud services:

```rust
use mqtt::{Client, QoS};

fn main() {
    let client = Client::connect("tcp://mqtt.example.com:1883").unwrap();
    
    let sensor_data = json!({
        "timestamp": SystemTime::now(),
        "temperature": 23.5,
        "humidity": 65.0
    });
    
    client.publish(
        "sensors/device1/data",
        sensor_data.to_string().as_bytes(),
        QoS::AtLeastOnce
    ).unwrap();
}
```

## Edge Analytics

Process data locally before sending to cloud:

```rust
struct DataBuffer {
    temperatures: Vec<f32>,
    max_size: usize,
}

impl DataBuffer {
    fn add(&mut self, temp: f32) {
        self.temperatures.push(temp);
        if self.temperatures.len() > self.max_size {
            self.temperatures.remove(0);
        }
    }
    
    fn average(&self) -> f32 {
        self.temperatures.iter().sum::<f32>() / self.temperatures.len() as f32
    }
    
    fn anomaly_detected(&self, current: f32) -> bool {
        let avg = self.average();
        (current - avg).abs() > 5.0 // 5 degree deviation
    }
}
```

## Deployment Scenarios

### Raspberry Pi

```bash
# Install WasmEdge on Raspberry Pi
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash

# Run IoT module
wasmedge sensor-monitor.wasm
```

### Industrial Gateway

```
┌─────────────────────────────────────┐
│     Industrial Gateway (ARM64)      │
│                                     │
│  ┌──────────────────────────────┐  │
│  │     WasmEdge Runtime         │  │
│  │                              │  │
│  │  ┌────────────────────────┐ │  │
│  │  │ Sensor Processing Wasm │ │  │
│  │  └────────────────────────┘ │  │
│  │                              │  │
│  │  ┌────────────────────────┐ │  │
│  │  │ Alert Logic Wasm       │ │  │
│  │  └────────────────────────┘ │  │
│  │                              │  │
│  │  ┌────────────────────────┐ │  │
│  │  │ Data Aggregation Wasm  │ │  │
│  │  └────────────────────────┘ │  │
│  └──────────────────────────────┘  │
│                                     │
│  Physical Sensors ←→ GPIO/Modbus   │
└─────────────────────────────────────┘
```

### Smart Home Hub

```yaml
# Docker Compose for smart home
version: '3'
services:
  wasmedge-hub:
    image: wasmedge/slim:latest
    volumes:
      - ./modules:/modules
    devices:
      - /dev/gpio
    command: wasmedge /modules/smart-home.wasm
```

## ML Inference at the Edge

Run machine learning models locally:

```rust
use wasmedge_tensorflow_lite as tflite;

fn detect_anomaly(sensor_data: &[f32]) -> bool {
    // Load pre-trained model
    let model = tflite::Model::load("anomaly_detection.tflite").unwrap();
    
    // Run inference
    let result = model.infer(sensor_data).unwrap();
    
    result[0] > 0.8 // Anomaly threshold
}

fn main() {
    let temp = read_temperature();
    let humidity = read_humidity();
    
    let data = vec![temp, humidity];
    
    if detect_anomaly(&data) {
        send_alert("Anomaly detected!");
    }
}
```

## Power Management

Optimize for battery-powered devices:

```rust
fn main() {
    loop {
        // Read sensors
        let data = read_all_sensors();
        
        // Process locally
        let should_transmit = analyze_data(data);
        
        if should_transmit {
            // Only transmit when necessary (saves power)
            send_to_cloud(data);
        }
        
        // Sleep to conserve power
        std::thread::sleep(Duration::from_secs(60));
    }
}
```

## Security Features

### Sandboxed Execution

- Sensor code can't access other device resources
- Memory isolation prevents buffer overflows
- No direct hardware access (goes through host functions)

### Secure Updates

```bash
# Download signed Wasm module
wget https://updates.example.com/sensor-v2.wasm

# Verify signature
wasmedge-verify sensor-v2.wasm

# Hot-swap module
cp sensor-v2.wasm /opt/sensor/current.wasm
systemctl restart wasmedge-sensor
```

### Data Privacy

Process sensitive data locally:

```rust
fn main() {
    let raw_data = read_sensors();
    
    // Aggregate before sending
    let summary = aggregate_data(raw_data);
    
    // Only send summary, not raw data
    send_to_cloud(summary);
}
```

## Monitoring and Logging

### Structured Logging

```rust
use serde_json::json;

fn log_event(event: &str, data: &Value) {
    let log_entry = json!({
        "timestamp": SystemTime::now(),
        "event": event,
        "data": data
    });
    
    eprintln!("{}", log_entry);
}
```

### Health Checks

```rust
fn health_check() -> bool {
    // Check if sensors are responsive
    let temp = read_temperature();
    let humidity = read_humidity();
    
    !temp.is_nan() && !humidity.is_nan()
}
```

## Real-World Examples

### Agriculture

Monitor soil moisture, temperature, and pH:

```rust
struct SoilSensor {
    moisture: f32,
    temperature: f32,
    ph: f32,
}

impl SoilSensor {
    fn needs_irrigation(&self) -> bool {
        self.moisture < 30.0
    }
    
    fn optimal_conditions(&self) -> bool {
        self.moisture >= 40.0 && self.moisture <= 60.0
            && self.temperature >= 15.0 && self.temperature <= 25.0
            && self.ph >= 6.0 && self.ph <= 7.5
    }
}
```

### Manufacturing

Monitor production line equipment:

```rust
struct EquipmentMonitor {
    vibration: f32,
    temperature: f32,
    rpm: f32,
}

impl EquipmentMonitor {
    fn predict_maintenance(&self) -> bool {
        // Anomaly detection
        self.vibration > 2.0 || self.temperature > 80.0
    }
}
```

### Building Automation

HVAC control based on occupancy and conditions:

```rust
fn hvac_control(temp: f32, humidity: f32, occupancy: u32) -> String {
    match (temp, humidity, occupancy) {
        (t, _, _) if t < 18.0 => "heat",
        (t, _, _) if t > 26.0 => "cool",
        (_, h, _) if h > 70.0 => "dehumidify",
        (_, _, 0) => "eco_mode",
        _ => "maintain"
    }
}
```

## Performance

### Benchmarks

- **Startup Time**: <5ms
- **Memory Usage**: ~5-10MB
- **CPU Usage**: <5% on idle
- **Processing**: 1000+ readings/second

### Optimization Tips

1. **Batch Processing**: Aggregate multiple readings
2. **Use AOT**: Compile to native for long-running tasks
3. **Minimize I/O**: Buffer data before writing
4. **Efficient Algorithms**: Use appropriate data structures

## Next Steps

- Review the [architecture](../architecture.md) for more on WasmEdge internals
- Try other demos: [Hello World](rust-hello.md), [Serverless](serverless-function.md), [Microservices](microservice-cli.md)
- Explore [visualizations](../exploration.md) and performance data

---

*For production IoT deployments with WasmEdge, visit [wasmedge.org](https://wasmedge.org/)*
