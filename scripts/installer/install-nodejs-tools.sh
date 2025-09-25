#!/bin/bash
set -euo pipefail

# Node.js Development Tools
echo "Installing Node.js development tools..."

# Source config if it exists
if [ -f "./config.sh" ]; then
    source ./config.sh
fi

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required. Run ./install-nodejs.sh first"
    exit 1
fi

# Package Managers
[ "${INSTALL_YARN:-false}" = "true" ] && npm install -g yarn
[ "${INSTALL_PNPM:-false}" = "true" ] && npm install -g pnpm

# Code Quality
[ "${INSTALL_PRETTIER:-false}" = "true" ] && npm install -g prettier
[ "${INSTALL_ESLINT:-false}" = "true" ] && npm install -g eslint

# Testing
[ "${INSTALL_JEST:-false}" = "true" ] && npm install -g jest
[ "${INSTALL_MOCHA:-false}" = "true" ] && npm install -g mocha
[ "${INSTALL_CYPRESS:-false}" = "true" ] && npm install -g cypress
[ "${INSTALL_PLAYWRIGHT:-false}" = "true" ] && npm install -g playwright

# Build Tools
[ "${INSTALL_WEBPACK:-false}" = "true" ] && npm install -g webpack webpack-cli
[ "${INSTALL_VITE:-false}" = "true" ] && npm install -g vite
[ "${INSTALL_ROLLUP:-false}" = "true" ] && npm install -g rollup
[ "${INSTALL_ESBUILD:-false}" = "true" ] && npm install -g esbuild
[ "${INSTALL_PARCEL:-false}" = "true" ] && npm install -g parcel

# Mobile
[ "${INSTALL_EXPO:-false}" = "true" ] && npm install -g expo-cli
[ "${INSTALL_IONIC:-false}" = "true" ] && npm install -g @ionic/cli

echo "Node.js tools installation complete."