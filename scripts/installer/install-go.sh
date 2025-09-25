#!/bin/bash
set -euo pipefail

# Go Development Setup - Minimal and Secure
echo "Installing Go development environment..."

# Install essential build tools
sudo apt-get update -qq
sudo apt-get install -y -qq curl wget git build-essential

# Install Go
GO_VERSION="1.22.0"
if [ ! -d "/usr/local/go" ]; then
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
fi

# Setup Go environment
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
mkdir -p "$HOME/go/bin"

# Install essential Go tools only
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Add to bashrc if not already present
if ! grep -q "GOPATH" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
EOF
fi

echo "Go setup complete."
go version