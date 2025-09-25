#!/bin/bash
set -euo pipefail

# React Development Setup
echo "Installing React development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Install React development tools
npm install -g create-react-app
npm install -g vite
npm install -g @vitejs/plugin-react

# Install testing and linting tools
npm install -g eslint prettier jest

echo "React setup complete."
echo "Create new app with: npm create vite@latest my-app -- --template react"