#!/bin/bash
set -euo pipefail

# VS Code Extension Installer with Granular Control
echo "Installing VS Code extensions..."

# Source config if it exists
if [ -f "./config.sh" ]; then
    source ./config.sh
fi

# Check if code CLI is available
if ! command -v code &> /dev/null; then
    echo "VS Code CLI not found. This script works best in GitHub Codespaces."
    exit 1
fi

# Function to install extension
install_extension() {
    local ext_id=$1
    echo "  Installing: $ext_id"
    code --install-extension "$ext_id" --force 2>/dev/null || echo "    Failed: $ext_id"
}

# Essential Extensions (Git, IntelliCode, Error Lens, etc.)
if [ "${VSCODE_ESSENTIAL:-true}" = "true" ]; then
    echo ""
    echo "Installing Essential Extensions..."
    install_extension "ms-vscode.hexeditor"
    install_extension "visualstudioexptteam.vscodeintellicode"
    install_extension "visualstudioexptteam.intellicode-api-usage-examples"
    install_extension "streetsidesoftware.code-spell-checker"
    install_extension "wayou.vscode-todo-highlight"
    install_extension "gruntfuggly.todo-tree"
    install_extension "usernamehw.errorlens"
    install_extension "eamodio.gitlens"
    install_extension "mhutchie.git-graph"
    install_extension "christian-kohler.path-intellisense"
    install_extension "aaron-bond.better-comments"
    install_extension "naumovs.color-highlight"
fi

# Python Development
if [ "${VSCODE_PYTHON:-false}" = "true" ]; then
    echo ""
    echo "Installing Python Extensions..."
    install_extension "ms-python.python"
    install_extension "ms-python.vscode-pylance"
    install_extension "ms-python.black-formatter"
    install_extension "ms-python.pylint"
    install_extension "ms-python.isort"
    install_extension "njpwerner.autodocstring"
    install_extension "kevinrose.vsc-python-indent"
    install_extension "ms-toolsai.jupyter"
    install_extension "ms-toolsai.vscode-jupyter-cell-tags"
    install_extension "ms-toolsai.jupyter-keymap"
    install_extension "ms-toolsai.jupyter-renderers"
fi

# JavaScript/TypeScript Development
if [ "${VSCODE_JAVASCRIPT:-false}" = "true" ]; then
    echo ""
    echo "Installing JavaScript/TypeScript Extensions..."
    install_extension "dbaeumer.vscode-eslint"
    install_extension "esbenp.prettier-vscode"
    install_extension "rvest.vs-code-prettier-eslint"
    install_extension "xabikos.javascriptsnippets"
    install_extension "christian-kohler.npm-intellisense"
    install_extension "wix.vscode-import-cost"
    install_extension "formulahendry.auto-rename-tag"
    install_extension "formulahendry.auto-close-tag"
    install_extension "bradlc.vscode-tailwindcss"
    install_extension "burkeholland.simple-react-snippets"
    install_extension "dsznajder.es7-react-js-snippets"
    install_extension "styled-components.vscode-styled-components"
    install_extension "octref.vetur"
    install_extension "vue.volar"
    install_extension "angular.ng-template"
fi

# Flutter/Dart Development
if [ "${VSCODE_FLUTTER:-false}" = "true" ]; then
    echo ""
    echo "Installing Flutter/Dart Extensions..."
    install_extension "dart-code.dart-code"
    install_extension "dart-code.flutter"
    install_extension "nash.awesome-flutter-snippets"
    install_extension "alexisvt.flutter-snippets"
fi

# Android/Java/Kotlin Development
if [ "${VSCODE_ANDROID:-false}" = "true" ]; then
    echo ""
    echo "Installing Android/Java/Kotlin Extensions..."
    install_extension "vscjava.vscode-java-pack"
    install_extension "redhat.java"
    install_extension "vscjava.vscode-java-debug"
    install_extension "vscjava.vscode-java-test"
    install_extension "vscjava.vscode-maven"
    install_extension "vscjava.vscode-java-dependency"
    install_extension "vscjava.vscode-gradle"
    install_extension "mathiasfrohlich.kotlin"
    install_extension "fwcd.kotlin"
    install_extension "naco-siren.gradle-language"
fi

# iOS/Swift Development
if [ "${VSCODE_IOS:-false}" = "true" ]; then
    echo ""
    echo "Installing Swift Extensions..."
    install_extension "sswg.swift-lang"
    install_extension "vknabel.vscode-swift-development-environment"
fi

# Go Development
if [ "${VSCODE_GO:-false}" = "true" ]; then
    echo ""
    echo "Installing Go Extensions..."
    install_extension "golang.go"
fi

# Rust Development
if [ "${VSCODE_RUST:-false}" = "true" ]; then
    echo ""
    echo "Installing Rust Extensions..."
    install_extension "rust-lang.rust-analyzer"
    install_extension "vadimcn.vscode-lldb"
    install_extension "serayuzgur.crates"
    install_extension "tamasfe.even-better-toml"
fi

# C++ Development
if [ "${VSCODE_CPP:-false}" = "true" ]; then
    echo ""
    echo "Installing C++ Extensions..."
    install_extension "ms-vscode.cpptools"
    install_extension "ms-vscode.cmake-tools"
    install_extension "twxs.cmake"
    install_extension "ms-vscode.makefile-tools"
fi

# C#/.NET Development
if [ "${VSCODE_CSHARP:-false}" = "true" ]; then
    echo ""
    echo "Installing C#/.NET Extensions..."
    install_extension "ms-dotnettools.csharp"
    install_extension "ms-dotnettools.vscode-dotnet-runtime"
    install_extension "kreativ-software.csharpextensions"
    install_extension "jchannon.csharpextensions"
fi

# Web Development Tools
if [ "${VSCODE_WEB:-false}" = "true" ]; then
    echo ""
    echo "Installing Web Development Extensions..."
    install_extension "ritwickdey.liveserver"
    install_extension "glenn2223.live-sass"
    install_extension "zignd.html-css-class-completion"
    install_extension "ecmel.vscode-html-css"
    install_extension "pranaygp.vscode-css-peek"
    install_extension "firefox-devtools.vscode-firefox-debug"
fi

# Database Tools
if [ "${VSCODE_DATABASE:-false}" = "true" ]; then
    echo ""
    echo "Installing Database Extensions..."
    install_extension "mtxr.sqltools"
    install_extension "mtxr.sqltools-driver-pg"
    install_extension "mtxr.sqltools-driver-mysql"
    install_extension "mtxr.sqltools-driver-sqlite"
    install_extension "mongodb.mongodb-vscode"
    install_extension "qwtel.sqlite-viewer"
fi

# Docker/Container Tools
if [ "${VSCODE_DOCKER:-false}" = "true" ]; then
    echo ""
    echo "Installing Docker Extensions..."
    install_extension "ms-azuretools.vscode-docker"
    install_extension "ms-kubernetes-tools.vscode-kubernetes-tools"
fi

# DevOps Tools
if [ "${VSCODE_DEVOPS:-false}" = "true" ]; then
    echo ""
    echo "Installing DevOps Extensions..."
    install_extension "hashicorp.terraform"
    install_extension "redhat.vscode-yaml"
    install_extension "ms-vscode.azure-account"
    install_extension "redhat.ansible"
fi

# API Development
if [ "${VSCODE_API:-false}" = "true" ]; then
    echo ""
    echo "Installing API Development Extensions..."
    install_extension "humao.rest-client"
    install_extension "rangav.vscode-thunder-client"
    install_extension "42crunch.vscode-openapi"
    install_extension "arjun.swagger-viewer"
fi

# AI/ML Assistance
if [ "${VSCODE_AI:-false}" = "true" ]; then
    echo ""
    echo "Installing AI/ML Extensions..."
    install_extension "github.copilot"
    install_extension "github.copilot-chat"
    install_extension "tabnine.tabnine-vscode"
    install_extension "codeium.codeium"
fi

# Testing Tools
if [ "${VSCODE_TESTING:-false}" = "true" ]; then
    echo ""
    echo "Installing Testing Extensions..."
    install_extension "hbenl.vscode-test-explorer"
    install_extension "kavod-io.vscode-jest-test-adapter"
    install_extension "ms-vscode.test-adapter-converter"
    install_extension "orta.vscode-jest"
fi

# Markdown/Documentation
if [ "${VSCODE_MARKDOWN:-false}" = "true" ]; then
    echo ""
    echo "Installing Markdown Extensions..."
    install_extension "yzhang.markdown-all-in-one"
    install_extension "davidanson.vscode-markdownlint"
    install_extension "bierner.markdown-preview-github-styles"
    install_extension "bierner.markdown-mermaid"
    install_extension "shd101wyy.markdown-preview-enhanced"
fi

# Productivity Tools
if [ "${VSCODE_PRODUCTIVITY:-false}" = "true" ]; then
    echo ""
    echo "Installing Productivity Extensions..."
    install_extension "vscodevim.vim"
    install_extension "alefragnani.bookmarks"
    install_extension "alefragnani.project-manager"
    install_extension "pnp.polacode"
    install_extension "oderwat.indent-rainbow"
    install_extension "pkief.material-icon-theme"
    install_extension "zhuangtongfa.material-theme"
    install_extension "github.github-vscode-theme"
fi

# Security Tools
if [ "${VSCODE_SECURITY:-false}" = "true" ]; then
    echo ""
    echo "Installing Security Extensions..."
    install_extension "snyk-security.snyk-vulnerability-scanner"
    install_extension "aquasecurityofficial.trivy-vulnerability-scanner"
fi

# Remote Development
if [ "${VSCODE_REMOTE:-false}" = "true" ]; then
    echo ""
    echo "Installing Remote Development Extensions..."
    install_extension "ms-vscode-remote.remote-containers"
    install_extension "ms-vscode-remote.remote-ssh"
    install_extension "ms-vscode.remote-repositories"
    install_extension "github.codespaces"
fi

# Data Science/Visualization
if [ "${VSCODE_DATA:-false}" = "true" ]; then
    echo ""
    echo "Installing Data Science Extensions..."
    install_extension "mechatroner.rainbow-csv"
    install_extension "randomfractalsinc.vscode-data-preview"
    install_extension "grapecity.gc-excelviewer"
fi

echo ""
echo "VS Code extensions installation complete!"
echo ""
echo "Installed categories:"
[ "${VSCODE_ESSENTIAL:-true}" = "true" ] && echo "  ✓ Essential"
[ "${VSCODE_PYTHON:-false}" = "true" ] && echo "  ✓ Python"
[ "${VSCODE_JAVASCRIPT:-false}" = "true" ] && echo "  ✓ JavaScript/TypeScript"
[ "${VSCODE_FLUTTER:-false}" = "true" ] && echo "  ✓ Flutter/Dart"
[ "${VSCODE_ANDROID:-false}" = "true" ] && echo "  ✓ Android/Java/Kotlin"
[ "${VSCODE_IOS:-false}" = "true" ] && echo "  ✓ iOS/Swift"
[ "${VSCODE_GO:-false}" = "true" ] && echo "  ✓ Go"
[ "${VSCODE_RUST:-false}" = "true" ] && echo "  ✓ Rust"
[ "${VSCODE_CPP:-false}" = "true" ] && echo "  ✓ C++"
[ "${VSCODE_CSHARP:-false}" = "true" ] && echo "  ✓ C#/.NET"
[ "${VSCODE_WEB:-false}" = "true" ] && echo "  ✓ Web Development"
[ "${VSCODE_DATABASE:-false}" = "true" ] && echo "  ✓ Database"
[ "${VSCODE_DOCKER:-false}" = "true" ] && echo "  ✓ Docker/Containers"
[ "${VSCODE_DEVOPS:-false}" = "true" ] && echo "  ✓ DevOps"
[ "${VSCODE_API:-false}" = "true" ] && echo "  ✓ API Development"
[ "${VSCODE_AI:-false}" = "true" ] && echo "  ✓ AI/ML Assistance"
[ "${VSCODE_TESTING:-false}" = "true" ] && echo "  ✓ Testing"
[ "${VSCODE_MARKDOWN:-false}" = "true" ] && echo "  ✓ Markdown/Documentation"
[ "${VSCODE_PRODUCTIVITY:-false}" = "true" ] && echo "  ✓ Productivity"
[ "${VSCODE_SECURITY:-false}" = "true" ] && echo "  ✓ Security"
[ "${VSCODE_REMOTE:-false}" = "true" ] && echo "  ✓ Remote Development"
[ "${VSCODE_DATA:-false}" = "true" ] && echo "  ✓ Data Science"
echo ""
echo "Reload VS Code window for extensions to activate."