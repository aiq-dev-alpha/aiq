#!/bin/bash
set -euo pipefail

# React Native Development Setup for GitHub Codespaces
echo "Installing React Native development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y -qq nodejs
fi

# Install React Native CLI
npm install -g react-native-cli
npm install -g expo-cli
npm install -g eas-cli

# Install Watchman (optional but recommended)
sudo apt-get update -qq
sudo apt-get install -y -qq watchman 2>/dev/null || echo "Watchman not available in repo"

echo "React Native setup complete."
echo "Node: $(node --version)"
echo "NPM: $(npm --version)"
echo "React Native CLI installed"
echo ""
echo "Note: For Android development, also run ./install-android.sh"