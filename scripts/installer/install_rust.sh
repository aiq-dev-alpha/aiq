#!/bin/bash
set -euo pipefail

# Rust Development Setup - Minimal and Secure
echo "Installing Rust development environment..."

# Install build essentials
sudo apt-get update -qq
sudo apt-get install -y -qq curl git build-essential

# Install Rust via rustup
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
    source "$HOME/.cargo/env"
fi

# Add essential components only
rustup component add rustfmt clippy rust-analyzer

# Install minimal cargo tools
cargo install cargo-edit
cargo install cargo-watch

echo "Rust setup complete."
rustc --version
cargo --version