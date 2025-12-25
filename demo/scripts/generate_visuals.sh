#!/usr/bin/env bash
set -euo pipefail

echo "Generating visualizations..."

python3 demo/scripts/generate_language_chart.py demo/visuals/languages.svg
python3 demo/scripts/generate_architecture.py demo/visuals/architecture.svg
python3 demo/scripts/generate_performance_chart.py demo/visuals/performance.svg

echo "All visualizations generated successfully!"
