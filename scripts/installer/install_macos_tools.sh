#!/bin/bash
set -euo pipefail

echo "Installing macOS/Swift development libraries..."

# Install Swift if available
if [ -f "./install-swift.sh" ]; then
    ./install-swift.sh
fi

# Python macOS development libraries
if command -v python3 &> /dev/null; then
    echo "Installing Python macOS libraries"
    pip3 install --user \
        pyobjc-core \
        mac-alias \
        macholib \
        dmgbuild
fi

# Basic Objective-C support
sudo apt-get update -qq
sudo apt-get install -y -qq gobjc

echo "macOS development libraries setup complete."
echo "Note: Full macOS development requires macOS"