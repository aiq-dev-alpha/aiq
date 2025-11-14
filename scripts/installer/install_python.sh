#!/bin/bash
set -euo pipefail

# Python Development Setup - Minimal and Secure
echo "Installing Python development environment..."

# Update package list
sudo apt-get update -qq

# Install Python and essential tools only
sudo apt-get install -y -qq \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential

# Upgrade pip securely
python3 -m pip install --user --upgrade pip setuptools wheel

# Install essential development tools only
python3 -m pip install --user \
    black \
    flake8 \
    mypy \
    pytest \
    ipython

echo "Python setup complete."
echo "Version: $(python3 --version)"
echo "Pip: $(pip3 --version)"