#!/bin/bash
set -euo pipefail

echo "Installing API development tools..."

# HTTP clients
sudo apt-get update -qq
sudo apt-get install -y -qq \
    curl \
    wget \
    httpie

# Install Postman CLI
curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh

# Install API testing tools
if command -v npm &> /dev/null; then
    npm install -g newman insomnia-cli
fi

# Install Python API tools
if command -v pip3 &> /dev/null; then
    pip3 install --user httpx aiohttp fastapi uvicorn
fi

# Install grpcurl for gRPC testing
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest 2>/dev/null || true

echo "API tools setup complete."