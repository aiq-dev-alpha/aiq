#!/bin/bash
set -euo pipefail

echo "Installing DevOps tools..."

# Source config if it exists
if [ -f "./config.sh" ]; then
    source ./config.sh
fi

# Update packages
sudo apt-get update -qq

# Kubernetes CLI
if [ "${INSTALL_KUBERNETES_CLI:-false}" = "true" ]; then
    echo "Installing kubectl"
    curl -LO -s "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# Terraform
if [ "${INSTALL_TERRAFORM:-false}" = "true" ]; then
    echo "Installing Terraform"
    wget -q https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
    unzip -q terraform_1.6.6_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.6.6_linux_amd64.zip
fi

# Helm
if [ "${INSTALL_HELM:-false}" = "true" ]; then
    echo "Installing Helm"
    curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Ansible (Python-based)
if [ "${INSTALL_ANSIBLE:-false}" = "true" ] && command -v python3 &> /dev/null; then
    echo "Installing Ansible"
    pip3 install --user ansible
fi

echo "DevOps tools setup complete."