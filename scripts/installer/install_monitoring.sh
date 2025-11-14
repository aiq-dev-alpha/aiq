#!/bin/bash
set -euo pipefail

echo "Installing monitoring libraries..."

# Python monitoring and profiling libraries
if command -v python3 &> /dev/null; then
    echo "Installing Python monitoring libraries"
    pip3 install --user \
        memory-profiler \
        line-profiler \
        py-spy \
        psutil \
        prometheus-client \
        statsd \
        datadog \
        newrelic
fi

# Node.js monitoring libraries
if command -v npm &> /dev/null; then
    echo "Installing Node.js monitoring libraries"
    npm install -g \
        clinic \
        0x \
        autocannon
fi

# Basic system monitoring (lightweight)
sudo apt-get update -qq
sudo apt-get install -y -qq \
    htop \
    sysstat

echo "Monitoring libraries setup complete."