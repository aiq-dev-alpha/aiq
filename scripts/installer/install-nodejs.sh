#!/bin/bash
set -euo pipefail

echo "Installing Node.js..."

# Use NodeSource repository for consistent installation
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y -qq nodejs

# Install essential tools
npm install -g yarn pnpm typescript ts-node nodemon

echo "Node.js setup complete."
node --version
npm --version