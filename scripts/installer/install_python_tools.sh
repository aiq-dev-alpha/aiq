#!/bin/bash
set -euo pipefail

# Python Development Tools
echo "Installing Python development tools..."

# Source config if it exists
if [ -f "./config.sh" ]; then
    source ./config.sh
fi

# Ensure Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python is required. Run ./install-python.sh first"
    exit 1
fi

# Code Quality Tools
[ "${INSTALL_BLACK:-false}" = "true" ] && pip3 install --user black
[ "${INSTALL_FLAKE8:-false}" = "true" ] && pip3 install --user flake8
[ "${INSTALL_PYLINT:-false}" = "true" ] && pip3 install --user pylint
[ "${INSTALL_MYPY:-false}" = "true" ] && pip3 install --user mypy

# Testing
[ "${INSTALL_PYTEST:-false}" = "true" ] && pip3 install --user pytest

# Data Science
[ "${INSTALL_JUPYTER:-false}" = "true" ] && pip3 install --user jupyter notebook
[ "${INSTALL_NUMPY:-false}" = "true" ] && pip3 install --user numpy
[ "${INSTALL_PANDAS:-false}" = "true" ] && pip3 install --user pandas
[ "${INSTALL_SCIKIT_LEARN:-false}" = "true" ] && pip3 install --user scikit-learn
[ "${INSTALL_MATPLOTLIB:-false}" = "true" ] && pip3 install --user matplotlib

# Web Frameworks
[ "${INSTALL_FASTAPI:-false}" = "true" ] && pip3 install --user fastapi uvicorn
[ "${INSTALL_DJANGO:-false}" = "true" ] && pip3 install --user django
[ "${INSTALL_FLASK:-false}" = "true" ] && pip3 install --user flask

echo "Python tools installation complete."