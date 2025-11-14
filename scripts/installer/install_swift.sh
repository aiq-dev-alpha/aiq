#!/bin/bash
set -euo pipefail

# Swift SDK for VS Code Development
echo "Installing Swift SDK for VS Code development..."

# Install dependencies
sudo apt-get update -qq
sudo apt-get install -y -qq \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-9-dev \
    libpython3.8 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev

# Download and install Swift
SWIFT_VERSION="5.9.2"
UBUNTU_VERSION="22.04"
SWIFT_PLATFORM="ubuntu${UBUNTU_VERSION}"
SWIFT_BRANCH="swift-${SWIFT_VERSION}-RELEASE"
SWIFT_ARCHIVE="${SWIFT_BRANCH}-${SWIFT_PLATFORM}.tar.gz"
SWIFT_URL="https://download.swift.org/${SWIFT_BRANCH,,}/${SWIFT_PLATFORM,,}/${SWIFT_ARCHIVE}"
SWIFT_HOME="$HOME/swift"

if [ ! -d "$SWIFT_HOME" ]; then
    echo "Downloading Swift SDK..."
    wget -q "$SWIFT_URL"
    tar xzf "$SWIFT_ARCHIVE"
    mv "${SWIFT_BRANCH}-${SWIFT_PLATFORM}" "$SWIFT_HOME"
    rm "$SWIFT_ARCHIVE"
else
    echo "Swift already installed at $SWIFT_HOME"
fi

# Add Swift to PATH
export PATH="$SWIFT_HOME/usr/bin:$PATH"

# Install sourcekit-lsp for VS Code
if [ ! -f "$SWIFT_HOME/usr/bin/sourcekit-lsp" ]; then
    echo "Building SourceKit-LSP for VS Code support..."
    git clone https://github.com/apple/sourcekit-lsp.git ~/sourcekit-lsp 2>/dev/null || true
    cd ~/sourcekit-lsp
    swift build -c release 2>/dev/null || echo "SourceKit-LSP build failed"
    if [ -f .build/release/sourcekit-lsp ]; then
        cp .build/release/sourcekit-lsp "$SWIFT_HOME/usr/bin/"
    fi
    cd -
fi

# Install swift-format for code formatting
if [ ! -f "/usr/local/bin/swift-format" ]; then
    echo "Building swift-format..."
    git clone https://github.com/apple/swift-format.git ~/swift-format 2>/dev/null || true
    cd ~/swift-format
    swift build -c release 2>/dev/null || echo "swift-format build failed"
    if [ -f .build/release/swift-format ]; then
        sudo cp .build/release/swift-format /usr/local/bin/
    fi
    cd -
fi

# Add to bashrc
if ! grep -q "swift/usr/bin" ~/.bashrc; then
    echo 'export PATH="$HOME/swift/usr/bin:$PATH"' >> ~/.bashrc
fi

# Create VS Code settings for Swift
mkdir -p ~/.config/Code/User 2>/dev/null || true
if [ ! -f ~/.config/Code/User/settings.json ]; then
    echo '{}' > ~/.config/Code/User/settings.json
fi

# Add Swift LSP configuration to VS Code settings
cat > ~/swift-vscode-settings.json << EOF
{
  "swift.path.swift_driver_bin": "$SWIFT_HOME/usr/bin/swift",
  "swift.path.sourcekit-lsp": "$SWIFT_HOME/usr/bin/sourcekit-lsp",
  "lldb.library": "$SWIFT_HOME/usr/lib/liblldb.so",
  "lldb.launch.expressions": "native",
  "swift.sourcekit-lsp.serverPath": "$SWIFT_HOME/usr/bin/sourcekit-lsp",
  "swift.sourcekit-lsp.serverArguments": [],
  "swift.buildArguments": [],
  "swift.testArguments": []
}
EOF

echo "Swift SDK setup complete for VS Code."
echo "Swift version:"
swift --version
echo ""
echo "VS Code will have full Swift IntelliSense support with SourceKit-LSP."
echo "Install Swift extensions in VS Code for best experience."
echo ""
echo "Swift VS Code settings saved to: ~/swift-vscode-settings.json"
echo "Merge these settings with your VS Code settings.json if needed."