#!/bin/bash
set -euo pipefail

echo "Installing C++ development tools..."

# Install compilers and tools
sudo apt-get update -qq
sudo apt-get install -y -qq \
    build-essential \
    g++ \
    clang \
    cmake \
    ninja-build \
    gdb \
    valgrind \
    cppcheck \
    clang-format \
    clang-tidy

# Install vcpkg for package management
git clone https://github.com/Microsoft/vcpkg.git ~/vcpkg 2>/dev/null || true
~/vcpkg/bootstrap-vcpkg.sh

echo "C++ setup complete."
g++ --version