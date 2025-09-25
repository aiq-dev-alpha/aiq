#!/bin/bash
# Installation Configuration - Optimized for secure multi-project development & learning
# SECURITY FIRST - No Docker, no cloud tools, no hacking tools

# System - Essential
UPDATE_SYSTEM=true
INSTALL_BUILD_ESSENTIAL=true

# Languages - All major languages for learning
INSTALL_PYTHON=true
INSTALL_NODEJS=true
INSTALL_GO=true
INSTALL_RUST=true
INSTALL_JAVA=true
INSTALL_CPP=true
INSTALL_DOTNET=true
INSTALL_SWIFT=true

# Package Managers
INSTALL_NPM=false      # Comes with Node.js
INSTALL_YARN=true
INSTALL_PNPM=true
INSTALL_PIP=false      # Comes with Python
INSTALL_CARGO=false    # Comes with Rust
INSTALL_MAVEN=false    # Comes with Java
INSTALL_GRADLE=false   # Comes with Java

# Web Frameworks - Essential for web development
INSTALL_REACT=true
INSTALL_NEXTJS=true
INSTALL_VUE=true
INSTALL_ANGULAR=true
INSTALL_SVELTE=true
INSTALL_EXPRESS=true
INSTALL_FASTAPI=true
INSTALL_DJANGO=true
INSTALL_FLASK=true

# Mobile - Full mobile development support
INSTALL_ANDROID_SDK=true
INSTALL_FLUTTER=true
INSTALL_REACT_NATIVE=true
INSTALL_EXPO=true
INSTALL_IONIC=true

# Databases - All common databases
INSTALL_POSTGRESQL_CLIENT=true
INSTALL_MYSQL_CLIENT=true
INSTALL_MONGODB_CLIENT=true
INSTALL_REDIS_CLIENT=true
INSTALL_SQLITE=true

# DevOps Tools - SECURITY: Docker and cloud tools DISABLED
INSTALL_DOCKER=false        # DISABLED FOR SECURITY
INSTALL_DOCKER_COMPOSE=false
INSTALL_KUBERNETES_CLI=false
INSTALL_TERRAFORM=false
INSTALL_ANSIBLE=false
INSTALL_HELM=false

# Cloud CLIs - DISABLED FOR SECURITY
INSTALL_AWS_CLI=false       # DISABLED FOR SECURITY
INSTALL_GCLOUD_CLI=false    # DISABLED FOR SECURITY
INSTALL_AZURE_CLI=false     # DISABLED FOR SECURITY

# Version Control
INSTALL_GIT=true
INSTALL_GH_CLI=true
INSTALL_GIT_LFS=true

# Editors/IDEs
INSTALL_VIM=true
INSTALL_NEOVIM=true
INSTALL_EMACS=false

# CLI Tools - Essential tools only
INSTALL_CURL=true
INSTALL_WGET=true
INSTALL_JQ=true
INSTALL_YQ=true
INSTALL_HTOP=true
INSTALL_TMUX=true
INSTALL_SCREEN=false
INSTALL_TREE=true
INSTALL_RIPGREP=true
INSTALL_FZF=true
INSTALL_BAT=true
INSTALL_FD=true
INSTALL_NCDU=true
INSTALL_HTTPIE=true

# Code Quality - All for learning best practices
INSTALL_PRETTIER=true
INSTALL_ESLINT=true
INSTALL_BLACK=true
INSTALL_FLAKE8=true
INSTALL_PYLINT=true
INSTALL_MYPY=true
INSTALL_SHELLCHECK=true

# ML/Data Science - Essential for learning
INSTALL_JUPYTER=true
INSTALL_NUMPY=true
INSTALL_PANDAS=true
INSTALL_SCIKIT_LEARN=true
INSTALL_TENSORFLOW=false    # Large - install only if needed
INSTALL_PYTORCH=false        # Large - install only if needed
INSTALL_MATPLOTLIB=true
INSTALL_ML_BASIC=true
INSTALL_DATA_SCIENCE=true

# Testing - Essential testing frameworks
INSTALL_JEST=true
INSTALL_MOCHA=true
INSTALL_PYTEST=true
INSTALL_CYPRESS=false       # Large - install only if needed
INSTALL_PLAYWRIGHT=false    # Large - install only if needed

# Build Tools
INSTALL_MAKE=true
INSTALL_CMAKE=true
INSTALL_WEBPACK=true
INSTALL_VITE=true
INSTALL_ROLLUP=false
INSTALL_ESBUILD=true
INSTALL_PARCEL=false

# Security Tools - DISABLED for security
INSTALL_NMAP=false          # DISABLED FOR SECURITY
INSTALL_NETCAT=false        # DISABLED FOR SECURITY
INSTALL_OPENSSL=false
INSTALL_GPG=false
INSTALL_SECURITY_TOOLS=false  # DISABLED FOR SECURITY

# Pentesting/Ethical Hacking - DISABLED FOR SECURITY
INSTALL_PENTESTING=false    # DISABLED FOR SECURITY

# IoT Development
INSTALL_IOT=false

# Hardware/Electronics
INSTALL_HARDWARE=false

# VS Code Extensions - Essential categories only
INSTALL_VSCODE_EXTENSIONS=true

# VS Code Extension Categories
VSCODE_ESSENTIAL=true       # Git, IntelliCode, Error Lens
VSCODE_PYTHON=true         # Python development
VSCODE_JAVASCRIPT=true     # JavaScript/TypeScript
VSCODE_FLUTTER=true        # Flutter/Dart
VSCODE_ANDROID=true        # Java, Kotlin
VSCODE_IOS=true            # Swift
VSCODE_GO=true             # Go
VSCODE_RUST=true           # Rust
VSCODE_CPP=true            # C/C++
VSCODE_CSHARP=true         # C#/.NET
VSCODE_WEB=true            # Web development
VSCODE_DATABASE=true       # Database tools
VSCODE_DOCKER=false        # DISABLED FOR SECURITY
VSCODE_DEVOPS=false        # DISABLED FOR SECURITY
VSCODE_API=true            # API development
VSCODE_AI=true             # GitHub Copilot, AI assistants
VSCODE_TESTING=true        # Testing tools
VSCODE_MARKDOWN=true       # Documentation
VSCODE_PRODUCTIVITY=true   # Themes, productivity
VSCODE_SECURITY=false      # DISABLED FOR SECURITY
VSCODE_REMOTE=false        # DISABLED FOR SECURITY
VSCODE_DATA=true           # Data visualization

# API/Monitoring/Tools
INSTALL_API_TOOLS=true
INSTALL_MONITORING=true
INSTALL_IOS_TOOLS=true
INSTALL_MACOS_TOOLS=false
INSTALL_DATABASES=true

# Other
INSTALL_ZIP=true
INSTALL_UNZIP=true