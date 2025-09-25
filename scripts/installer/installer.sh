#!/bin/bash
set -euo pipefail

# Main Installer Script - Orchestrates all installations
echo "Starting installation..."

# Load configuration
if [ ! -f "./config.sh" ]; then
    echo "Error: config.sh not found"
    echo "Edit config.sh to set what you want installed, then run installer.sh"
    exit 1
fi

source ./config.sh

# System update
if [ "$UPDATE_SYSTEM" = "true" ]; then
    echo "Updating system packages"
    sudo apt-get update -qq
    sudo apt-get upgrade -y -qq
fi

# Build essentials
if [ "$INSTALL_BUILD_ESSENTIAL" = "true" ]; then
    echo "Installing build essentials"
    sudo apt-get install -y -qq build-essential ca-certificates gnupg lsb-release
fi

# Basic system tools
echo "Installing basic tools..."
[ "$INSTALL_GIT" = "true" ] && sudo apt-get install -y -qq git
[ "$INSTALL_CURL" = "true" ] && sudo apt-get install -y -qq curl
[ "$INSTALL_WGET" = "true" ] && sudo apt-get install -y -qq wget
[ "$INSTALL_ZIP" = "true" ] && sudo apt-get install -y -qq zip
[ "$INSTALL_UNZIP" = "true" ] && sudo apt-get install -y -qq unzip
[ "$INSTALL_MAKE" = "true" ] && sudo apt-get install -y -qq make
[ "$INSTALL_OPENSSL" = "true" ] && sudo apt-get install -y -qq openssl
[ "$INSTALL_GPG" = "true" ] && sudo apt-get install -y -qq gnupg

# Core Languages
echo "Installing languages..."
[ "$INSTALL_PYTHON" = "true" ] && ./install-python.sh
[ "$INSTALL_NODEJS" = "true" ] && ./install-nodejs.sh
[ "$INSTALL_GO" = "true" ] && ./install-go.sh
[ "$INSTALL_RUST" = "true" ] && ./install-rust.sh
[ "$INSTALL_JAVA" = "true" ] && ./install-java.sh
[ "$INSTALL_CPP" = "true" ] && ./install-cpp.sh
[ "$INSTALL_DOTNET" = "true" ] && ./install-dotnet.sh
[ "$INSTALL_SWIFT" = "true" ] && ./install-swift.sh

# Language-specific tools
if [ "$INSTALL_PYTHON" = "true" ]; then
    ./install-python-tools.sh
fi

if [ "$INSTALL_NODEJS" = "true" ]; then
    ./install-nodejs-tools.sh
fi

# Web Frameworks
echo "Installing frameworks..."
[ "$INSTALL_REACT" = "true" ] && ./install-react.sh
[ "$INSTALL_NEXTJS" = "true" ] && ./install-nextjs.sh
[ "$INSTALL_VUE" = "true" ] && ./install-vue.sh
[ "$INSTALL_ANGULAR" = "true" ] && ./install-angular.sh
[ "$INSTALL_SVELTE" = "true" ] && ./install-svelte.sh
[ "$INSTALL_EXPRESS" = "true" ] && ./install-express.sh

# Mobile Development
echo "Installing mobile development tools..."
[ "$INSTALL_ANDROID_SDK" = "true" ] && ./install-android.sh
[ "$INSTALL_FLUTTER" = "true" ] && ./install-flutter.sh
[ "$INSTALL_REACT_NATIVE" = "true" ] && ./install-react-native.sh

# ML/AI Frameworks
echo "Installing ML/AI tools..."
[ "$INSTALL_TENSORFLOW" = "true" ] && ./install-tensorflow.sh
[ "$INSTALL_PYTORCH" = "true" ] && ./install-pytorch.sh
[ "$INSTALL_ML_BASIC" = "true" ] && ./install-ml-basic.sh
[ "$INSTALL_DATA_SCIENCE" = "true" ] && ./install-data-science.sh

# DevOps & Cloud
echo "Installing DevOps tools..."
[ "$INSTALL_DOCKER" = "true" ] && ./install-docker.sh
[ "$INSTALL_DOCKER_COMPOSE" = "true" ] && sudo apt-get install -y -qq docker-compose-plugin
if [ "$INSTALL_KUBERNETES_CLI" = "true" ] || [ "$INSTALL_TERRAFORM" = "true" ] || [ "$INSTALL_HELM" = "true" ] || [ "$INSTALL_ANSIBLE" = "true" ]; then
    ./install-devops.sh
fi

# Cloud CLIs
echo "Installing cloud CLIs..."
if [ "$INSTALL_AWS_CLI" = "true" ]; then
    echo "Installing AWS CLI"
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update 2>/dev/null || sudo ./aws/install
    rm -rf awscliv2.zip aws/
fi

if [ "$INSTALL_GCLOUD_CLI" = "true" ]; then
    echo "Installing Google Cloud CLI"
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update -qq && sudo apt-get install -y -qq google-cloud-cli
fi

if [ "$INSTALL_AZURE_CLI" = "true" ]; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

# GitHub CLI
if [ "$INSTALL_GH_CLI" = "true" ]; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq gh
fi

# MongoDB Client (special case)
if [ "$INSTALL_MONGODB_CLIENT" = "true" ]; then
    if command -v lsb_release &> /dev/null; then
        UBUNTU_CODENAME=$(lsb_release -cs)
    else
        UBUNTU_CODENAME="jammy"
    fi
    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add - 2>/dev/null || true
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_CODENAME}/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null 2>/dev/null || true
    sudo apt-get update -qq
    sudo apt-get install -y -qq mongodb-mongosh 2>/dev/null || echo "MongoDB shell not available for this distribution"
fi

# System Tools
./install-system-tools.sh

# Security Tools
[ "$INSTALL_NMAP" = "true" ] && sudo apt-get install -y -qq nmap
[ "$INSTALL_NETCAT" = "true" ] && sudo apt-get install -y -qq netcat

# Specialized Development
echo "Installing specialized tools..."
[ "$INSTALL_PENTESTING" = "true" ] && ./install-pentesting.sh
[ "$INSTALL_IOT" = "true" ] && ./install-iot.sh
[ "$INSTALL_HARDWARE" = "true" ] && ./install-hardware.sh
[ "$INSTALL_SECURITY_TOOLS" = "true" ] && ./install-security-tools.sh
[ "$INSTALL_API_TOOLS" = "true" ] && ./install-api-tools.sh
[ "$INSTALL_MONITORING" = "true" ] && ./install-monitoring.sh
[ "$INSTALL_IOS_TOOLS" = "true" ] && ./install-ios-tools.sh
[ "$INSTALL_MACOS_TOOLS" = "true" ] && ./install-macos-tools.sh
[ "$INSTALL_DATABASES" = "true" ] && ./install-databases.sh

# VS Code Extensions
[ "$INSTALL_VSCODE_EXTENSIONS" = "true" ] && ./install-vscode-extensions.sh

echo ""
echo "Installation complete!"
echo "Restart shell or run: source ~/.bashrc"