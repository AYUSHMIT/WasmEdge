#!/usr/bin/env python3
"""
Generate language composition chart for WasmEdge repository
"""
import sys

def generate_language_chart():
    # Language composition based on problem statement
    languages = {
        'C++': 92.5,
        'C': 2.0,
        'CMake': 1.5,
        'Shell': 1.5,
        'Python': 1.0,
        'Rust': 0.5,
        'Other': 1.0
    }
    
    # Generate SVG pie chart
    svg_width = 800
    svg_height = 600
    cx = 300
    cy = 300
    radius = 200
    
    colors = ['#5470C6', '#91CC75', '#FAC858', '#EE6666', '#73C0DE', '#3BA272', '#FC8452']
    
    svg = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="{svg_width}" height="{svg_height}" xmlns="http://www.w3.org/2000/svg">
  <title>WasmEdge Language Composition</title>
  <rect width="100%" height="100%" fill="white"/>
  <text x="{svg_width/2}" y="40" text-anchor="middle" font-size="24" font-weight="bold" font-family="Arial">
    WasmEdge Language Composition
  </text>
'''
    
    # Draw pie chart
    start_angle = 0
    legend_y = 100
    
    for idx, (lang, percent) in enumerate(languages.items()):
        angle = (percent / 100) * 360
        end_angle = start_angle + angle
        
        # Calculate pie slice path
        start_x = cx + radius * cos_deg(start_angle)
        start_y = cy + radius * sin_deg(start_angle)
        end_x = cx + radius * cos_deg(end_angle)
        end_y = cy + radius * sin_deg(end_angle)
        
        large_arc = 1 if angle > 180 else 0
        
        path = f'M {cx},{cy} L {start_x},{start_y} A {radius},{radius} 0 {large_arc},1 {end_x},{end_y} Z'
        
        svg += f'  <path d="{path}" fill="{colors[idx % len(colors)]}" stroke="white" stroke-width="2"/>\n'
        
        # Add legend
        legend_x = 550
        svg += f'  <rect x="{legend_x}" y="{legend_y + idx * 40}" width="30" height="20" fill="{colors[idx % len(colors)]}"/>\n'
        svg += f'  <text x="{legend_x + 40}" y="{legend_y + idx * 40 + 15}" font-size="14" font-family="Arial">{lang}: {percent}%</text>\n'
        
        start_angle = end_angle
    
    svg += '</svg>'
    
    return svg

def cos_deg(angle):
    import math
    return math.cos(math.radians(angle))

def sin_deg(angle):
    import math
    return math.sin(math.radians(angle))

if __name__ == '__main__':
    output_path = sys.argv[1] if len(sys.argv) > 1 else 'demo/visuals/languages.svg'
    svg_content = generate_language_chart()
    
    with open(output_path, 'w') as f:
        f.write(svg_content)
    
    print(f"Language chart generated: {output_path}")
