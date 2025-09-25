#!/bin/bash
set -euo pipefail

# Flutter SDK for VS Code Development
echo "Installing Flutter SDK for VS Code development..."

# Install prerequisites
sudo apt-get update -qq
sudo apt-get install -y -qq curl git unzip xz-utils zip

# Install Flutter SDK
FLUTTER_VERSION="3.16.0"
FLUTTER_HOME="$HOME/flutter"

if [ ! -d "$FLUTTER_HOME" ]; then
    echo "Downloading Flutter SDK..."
    wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C $HOME
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
else
    echo "Flutter already installed at $FLUTTER_HOME"
fi

# Add to PATH
export PATH="$PATH:$FLUTTER_HOME/bin"
export PATH="$PATH:$FLUTTER_HOME/bin/cache/dart-sdk/bin"

# Configure Flutter
flutter config --no-analytics --no-cli-animations 2>/dev/null || true
flutter config --enable-web 2>/dev/null || true

# Download Flutter dependencies for VS Code
flutter precache --no-ios --no-android 2>/dev/null || true
flutter doctor -v 2>/dev/null || true

# Add to bashrc
if ! grep -q "flutter/bin" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/flutter/bin/cache/dart-sdk/bin"
EOF
fi

# Install Dart packages for better VS Code support
dart pub global activate dart_code_metrics
dart pub global activate dart_style
dart pub global activate dartfmt

echo "Flutter SDK setup complete for VS Code."
echo "Flutter version:"
flutter --version 2>/dev/null || true
echo ""
echo "VS Code will have full Flutter/Dart IntelliSense support."
echo "Install Flutter/Dart extensions in VS Code for best experience."