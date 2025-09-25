#!/bin/bash
set -euo pipefail

echo "Installing security analysis tools..."

# Update packages
sudo apt-get update -qq

# Network tools
sudo apt-get install -y -qq \
    nmap \
    netcat \
    tcpdump \
    wireshark-cli \
    net-tools \
    dnsutils \
    whois

# Web security tools
sudo apt-get install -y -qq \
    curl \
    wget \
    httpie \
    nikto

# Install Python security tools
pip3 install --user \
    requests \
    beautifulsoup4 \
    python-nmap \
    scapy \
    pwntools \
    cryptography \
    paramiko

# Static analysis tools
pip3 install --user \
    bandit \
    safety \
    semgrep

# Install Go security tools
if command -v go &> /dev/null; then
    go install github.com/tomnomnom/httprobe@latest
    go install github.com/ffuf/ffuf@latest
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
fi

# Install Node.js security tools
if command -v npm &> /dev/null; then
    npm install -g snyk retire npm-audit-resolver
fi

echo "Security tools setup complete."