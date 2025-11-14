#!/bin/bash
set -euo pipefail

echo "Installing iOS/Swift development libraries..."

# Install Swift if available
if [ -f "./install-swift.sh" ]; then
    ./install-swift.sh
fi

# Python iOS development libraries
if command -v python3 &> /dev/null; then
    echo "Installing Python iOS libraries"
    pip3 install --user \
        frida-tools \
        objection \
        biplist \
        iOSbackup
fi

# Node.js iOS libraries
if command -v npm &> /dev/null; then
    echo "Installing Node.js iOS libraries"
    npm install -g \
        ios-deploy \
        ios-sim \
        plist
fi

echo "iOS development libraries setup complete."
echo "Note: Full iOS development requires macOS"