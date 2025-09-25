#!/bin/bash
set -euo pipefail

# PyTorch Setup
echo "Installing PyTorch..."

# Ensure Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python is required. Run ./install-python.sh first"
    exit 1
fi

# Install PyTorch (CPU version for Codespaces)
pip3 install --user torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

echo "PyTorch setup complete."
python3 -c "import torch; print(f'PyTorch version: {torch.__version__}')"