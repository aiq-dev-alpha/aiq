#!/bin/bash
set -euo pipefail

# Basic Machine Learning Setup
echo "Installing basic ML tools..."

# Ensure Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python is required. Run ./install-python.sh first"
    exit 1
fi

# Install essential ML packages
pip3 install --user \
    numpy \
    pandas \
    scikit-learn \
    matplotlib \
    jupyter \
    notebook

echo "Basic ML setup complete."