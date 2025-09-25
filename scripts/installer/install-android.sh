#!/bin/bash
set -euo pipefail

# Android SDK for VS Code Development
echo "Installing Android SDK for VS Code development..."

# Install Java (required for Android)
sudo apt-get update -qq
sudo apt-get install -y -qq openjdk-17-jdk

# Set JAVA_HOME
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

# Android SDK setup
ANDROID_HOME="$HOME/Android/Sdk"
mkdir -p "$ANDROID_HOME"

# Install Android command-line tools
if [ ! -d "$ANDROID_HOME/cmdline-tools" ]; then
    echo "Downloading Android SDK tools..."
    cd "$ANDROID_HOME"
    wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -O cmdline-tools.zip
    unzip -q cmdline-tools.zip
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    rm cmdline-tools.zip
    cd -
else
    echo "Android SDK tools already installed"
fi

# Set paths
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools/34.0.0"

# Accept licenses and install SDK components
yes | sdkmanager --licenses 2>/dev/null || true

echo "Installing Android SDK components..."
sdkmanager --install \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "sources;android-34" \
    "system-images;android-34;google_apis;x86_64" 2>/dev/null || true

# Install Gradle
sudo apt-get install -y -qq gradle

# Install Kotlin compiler for better VS Code support
sudo snap install kotlin --classic 2>/dev/null || \
    sudo apt-get install -y -qq kotlin 2>/dev/null || true

# Add to bashrc
if ! grep -q "ANDROID_HOME" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools/34.0.0"
EOF
fi

echo "Android SDK setup complete for VS Code."
echo "ANDROID_HOME: $ANDROID_HOME"
echo ""
echo "VS Code will have full Android/Kotlin/Java IntelliSense support."
echo "Install Android/Kotlin extensions in VS Code for best experience."