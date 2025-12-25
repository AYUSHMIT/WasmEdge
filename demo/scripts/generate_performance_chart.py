#!/usr/bin/env python3
"""
Generate performance comparison visualization
"""
import sys

def generate_performance_chart():
    svg = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="800" height="500" xmlns="http://www.w3.org/2000/svg">
  <title>WasmEdge Performance Exploration</title>
  <defs>
    <style>
      .bar-interp { fill: #5470C6; }
      .bar-aot { fill: #91CC75; }
      .text { font-family: Arial; font-size: 14px; fill: #333; }
      .title { font-family: Arial; font-size: 24px; font-weight: bold; fill: #333; }
      .axis { stroke: #666; stroke-width: 2; }
    </style>
  </defs>
  
  <rect width="100%" height="100%" fill="white"/>
  
  <text x="400" y="40" text-anchor="middle" class="title">WasmEdge: Interpreter vs AOT Performance</text>
  <text x="400" y="70" text-anchor="middle" class="text" font-style="italic">(Illustrative comparison - actual performance varies by workload)</text>
  
  <!-- Y-axis -->
  <line x1="100" y1="100" x2="100" y2="400" class="axis"/>
  <text x="50" y="250" text-anchor="middle" transform="rotate(-90 50 250)" class="text">Execution Time (ms)</text>
  
  <!-- X-axis -->
  <line x1="100" y1="400" x2="750" y2="400" class="axis"/>
  
  <!-- Bars for Hello World -->
  <rect x="150" y="300" width="80" height="100" class="bar-interp"/>
  <text x="190" y="320" text-anchor="middle" class="text" fill="white">5ms</text>
  
  <rect x="250" y="350" width="80" height="50" class="bar-aot"/>
  <text x="290" y="370" text-anchor="middle" class="text" fill="white">2.5ms</text>
  
  <text x="215" y="430" text-anchor="middle" class="text">Hello World</text>
  
  <!-- Bars for Compute -->
  <rect x="400" y="200" width="80" height="200" class="bar-interp"/>
  <text x="440" y="220" text-anchor="middle" class="text" fill="white">50ms</text>
  
  <rect x="500" y="280" width="80" height="120" class="bar-aot"/>
  <text x="540" y="300" text-anchor="middle" class="text" fill="white">30ms</text>
  
  <text x="465" y="430" text-anchor="middle" class="text">Compute Intensive</text>
  
  <!-- Legend -->
  <rect x="600" y="150" width="30" height="20" class="bar-interp"/>
  <text x="640" y="165" class="text">Interpreter</text>
  
  <rect x="600" y="180" width="30" height="20" class="bar-aot"/>
  <text x="640" y="195" class="text">AOT Compiled</text>
  
  <text x="400" y="470" text-anchor="middle" class="text" font-style="italic" font-size="12">
    AOT (Ahead-of-Time) compilation provides faster execution at the cost of compilation time
  </text>
</svg>'''
    
    return svg

if __name__ == '__main__':
    output_path = sys.argv[1] if len(sys.argv) > 1 else 'demo/visuals/performance.svg'
    svg_content = generate_performance_chart()
    
    with open(output_path, 'w') as f:
        f.write(svg_content)
    
    print(f"Performance chart generated: {output_path}")
