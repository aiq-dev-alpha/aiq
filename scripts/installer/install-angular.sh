#!/bin/bash
set -euo pipefail

# Angular Development Setup
echo "Installing Angular development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Install Angular CLI
npm install -g @angular/cli

# Install additional tools
npm install -g typescript

echo "Angular setup complete."
echo "Create new app with: ng new my-app"
ng version 2>/dev/null || true