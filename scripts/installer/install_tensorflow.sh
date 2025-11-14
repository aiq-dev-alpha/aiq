#!/bin/bash
set -euo pipefail

# TensorFlow Setup
echo "Installing TensorFlow..."

# Ensure Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python is required. Run ./install-python.sh first"
    exit 1
fi

# Install TensorFlow (CPU version for Codespaces)
pip3 install --user tensorflow

# Install additional tools
pip3 install --user tensorboard keras

echo "TensorFlow setup complete."
python3 -c "import tensorflow as tf; print(f'TensorFlow version: {tf.__version__}')"