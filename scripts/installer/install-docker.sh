#!/bin/bash
set -euo pipefail

# Docker Check for GitHub Codespaces
echo "Checking Docker..."

# Docker is pre-installed in GitHub Codespaces
if command -v docker &> /dev/null; then
    echo "Docker is available"
    docker --version

    # Check if docker compose is available
    if docker compose version &> /dev/null; then
        echo "Docker Compose v2 is available"
    elif command -v docker-compose &> /dev/null; then
        echo "Docker Compose v1 is available"
    fi
else
    echo "Docker not available in this environment"
    echo "Note: Docker requires special permissions in Codespaces"
fi

echo "Docker check complete."