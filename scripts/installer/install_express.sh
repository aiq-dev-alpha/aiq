#!/bin/bash
set -euo pipefail

# Express.js Development Setup
echo "Installing Express.js development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Install Express generator and tools
npm install -g express-generator
npm install -g nodemon
npm install -g pm2

echo "Express.js setup complete."
echo "Create new app with: express my-app"