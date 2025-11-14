#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"

PROJECT_DIR=""
PROJECT_NAME=""

cleanup_on_failure() {
    local exit_code=$?
    if [ $exit_code -ne 0 ] && [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR" ]; then
        echo "Setup failed. Removing $PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
    fi
}

trap cleanup_on_failure EXIT

validate_project_name() {
    local name="$1"

    if [ -z "$name" ]; then
        echo "Error: Project name cannot be empty"
        return 1
    fi

    if [[ ! "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
        echo "Error: Project name must start with lowercase letter and contain only lowercase letters, numbers, and hyphens"
        return 1
    fi

    return 0
}

check_prerequisites() {
    if ! command -v node >/dev/null 2>&1; then
        echo "Error: Node.js is not installed"
        exit 1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "Error: npm is not installed"
        exit 1
    fi

    local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 18 ]; then
        echo "Error: Node.js 18 or higher is required"
        exit 1
    fi

    if ! command -v ionic >/dev/null 2>&1; then
        echo "Installing Ionic CLI globally..."
        npm install -g @ionic/cli
    fi

    if ! command -v cordova >/dev/null 2>&1; then
        echo "Installing Cordova CLI globally..."
        npm install -g cordova
    fi
}

create_project() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Creating Cordova Ionic TypeScript project: $project_name"

    ionic start "$dest_dir" tabs --type=angular --cordova --no-git

    cd "$dest_dir"

    echo "Adding Cordova platforms..."
    ionic cordova platform add browser --no-interactive
}

install_plugins() {
    local dest_dir="$1"

    cd "$dest_dir"

    echo "Installing Cordova plugins..."
    ionic cordova plugin add cordova-plugin-camera
    npm install @ionic-native/camera

    ionic cordova plugin add cordova-plugin-geolocation
    npm install @ionic-native/geolocation

    ionic cordova plugin add cordova-plugin-file
    npm install @ionic-native/file

    ionic cordova plugin add cordova-plugin-network-information
    npm install @ionic-native/network

    ionic cordova plugin add cordova-plugin-device
    npm install @ionic-native/device
}

main() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <project_name> <destination_directory>"
        echo "Example: $0 my-ionic-cordova-app ~/projects/"
        exit 1
    fi

    PROJECT_NAME="$1"
    local dest_base="$2"
    PROJECT_DIR="$dest_base/$PROJECT_NAME"

    validate_project_name "$PROJECT_NAME" || exit 1
    check_prerequisites

    if [ -d "$PROJECT_DIR" ]; then
        echo "Error: Directory $PROJECT_DIR already exists"
        exit 1
    fi

    create_project "$PROJECT_DIR" "$PROJECT_NAME"
    install_plugins "$PROJECT_DIR"

    echo "Setup completed successfully"
    echo "Project created at: $PROJECT_DIR"
    echo ""
    echo "Next steps:"
    echo "  cd $PROJECT_DIR"
    echo "  ionic serve"
    echo ""
    echo "To add mobile platforms:"
    echo "  ionic cordova platform add android"
    echo "  ionic cordova platform add ios"
    echo ""
    echo "To run on device:"
    echo "  ionic cordova run android"
    echo "  ionic cordova run ios"
}

main "$@"