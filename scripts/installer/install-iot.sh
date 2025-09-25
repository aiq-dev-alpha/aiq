#!/bin/bash
set -euo pipefail

# IoT Development Libraries for Scripting
echo "Installing IoT development libraries..."

# Python IoT libraries for scripting and simulation
if command -v python3 &> /dev/null; then
    echo "Installing Python IoT libraries"
    pip3 install --user \
        paho-mqtt \
        asyncio-mqtt \
        awsiotsdk \
        azure-iot-device \
        google-cloud-iot \
        bleak \
        bluepy \
        pymodbus \
        minimalmodbus \
        aiocoap \
        websocket-client \
        redis \
        influxdb-client \
        prometheus-client
fi

# Node.js IoT libraries
if command -v npm &> /dev/null; then
    echo "Installing Node.js IoT libraries"
    npm install -g \
        mqtt \
        aws-iot-device-sdk \
        azure-iot-device \
        johnny-five \
        node-red
fi

# Basic network tools for IoT testing
sudo apt-get update -qq
sudo apt-get install -y -qq \
    mosquitto-clients \
    curl \
    jq

echo "IoT development libraries setup complete."