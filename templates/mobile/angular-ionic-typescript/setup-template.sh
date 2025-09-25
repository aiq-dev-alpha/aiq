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
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up Angular Ionic project: $project_name"

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" ! -name "README.md" -exec cp {} "$dest_dir/" \;

    for dir in src; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    if [ -f "$dest_dir/package.json" ]; then
        sed -i.bak "s/angular-ionic-template/$project_name/g" "$dest_dir/package.json"
        rm -f "$dest_dir/package.json.bak"
    fi

    if [ -f "$dest_dir/ionic.config.json" ]; then
        sed -i.bak "s/angular-ionic-template/$project_name/g" "$dest_dir/ionic.config.json"
        rm -f "$dest_dir/ionic.config.json.bak"
    fi

    if [ -f "$dest_dir/capacitor.config.json" ]; then
        sed -i.bak "s/angular-ionic-template/$project_name/g" "$dest_dir/capacitor.config.json"
        sed -i.bak "s/io.ionic.starter/com.$project_name.app/g" "$dest_dir/capacitor.config.json"
        rm -f "$dest_dir/capacitor.config.json.bak"
    fi

    find "$dest_dir" -name "*.bak" -type f -delete
}

install_dependencies() {
    local dest_dir="$1"

    cd "$dest_dir"

    echo "Installing dependencies..."
    npm install

    echo "Building project..."
    npm run build
}

main() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <project_name> <destination_directory>"
        echo "Example: $0 my-ionic-app ~/projects/"
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

    copy_template "$PROJECT_DIR" "$PROJECT_NAME"
    customize_template "$PROJECT_DIR" "$PROJECT_NAME"
    install_dependencies "$PROJECT_DIR"

    echo "Setup completed successfully"
    echo "Project created at: $PROJECT_DIR"
    echo ""
    echo "Next steps:"
    echo "  cd $PROJECT_DIR"
    echo "  ionic serve"
    echo ""
    echo "To add platforms:"
    echo "  ionic capacitor add ios"
    echo "  ionic capacitor add android"
    echo ""
    echo "To run on device:"
    echo "  ionic capacitor run ios"
    echo "  ionic capacitor run android"
}

main "$@"