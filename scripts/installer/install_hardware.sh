#!/bin/bash
set -euo pipefail

# Hardware Simulation and Scripting Libraries
echo "Installing hardware simulation libraries..."

# Python libraries for hardware simulation and scripting
if command -v python3 &> /dev/null; then
    echo "Installing Python hardware simulation libraries"
    pip3 install --user \
        numpy \
        scipy \
        matplotlib \
        simpy \
        pyspice \
        lcapy \
        scikit-rf \
        control \
        filterpy \
        pint \
        pyserial \
        bitstring \
        bitstruct \
        construct
fi

# Verilog/VHDL simulation (lightweight)
sudo apt-get update -qq
sudo apt-get install -y -qq \
    iverilog \
    gtkwave

# Basic calculation and analysis tools
if command -v python3 &> /dev/null; then
    pip3 install --user \
        sympy \
        pandas \
        plotly \
        bokeh
fi

echo "Hardware simulation libraries setup complete."