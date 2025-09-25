#!/bin/bash
set -euo pipefail

# Next.js Development Setup
echo "Installing Next.js development tools..."

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Install Next.js CLI
npm install -g create-next-app

# Install Vercel CLI for deployment
npm install -g vercel

echo "Next.js setup complete."
echo "Create new app with: npx create-next-app@latest my-app"