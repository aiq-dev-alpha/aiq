#!/bin/bash
set -euo pipefail

# Vue.js Development Setup
echo "Installing Vue.js development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Install Vue CLI and tools
npm install -g @vue/cli
npm install -g vite
npm install -g @vitejs/plugin-vue

echo "Vue setup complete."
echo "Create new app with: npm create vue@latest my-app"