#!/bin/bash
set -euo pipefail

# Svelte Development Setup
echo "Installing Svelte development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Install Svelte tools
npm install -g degit
npm install -g vite
npm install -g @sveltejs/adapter-auto

echo "Svelte setup complete."
echo "Create new app with: npm create vite@latest my-app -- --template svelte"