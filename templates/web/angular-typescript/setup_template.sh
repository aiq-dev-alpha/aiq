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

check_node() {
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
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up Angular project: $project_name"

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" -exec cp {} "$dest_dir/" \;

    for dir in src public; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    if [ -f "$dest_dir/package.json" ]; then
        sed -i.bak "s/angular-typescript-template/$project_name/g" "$dest_dir/package.json"
        rm -f "$dest_dir/package.json.bak"
    fi

    if [ -f "$dest_dir/angular.json" ]; then
        sed -i.bak "s/angular-typescript-template/$project_name/g" "$dest_dir/angular.json"
        rm -f "$dest_dir/angular.json.bak"
    fi

    find "$dest_dir/src" -type f -name "*.html" -exec sed -i.bak "s/Angular TypeScript Template/$project_name/g" {} \;
    find "$dest_dir" -name "*.bak" -type f -delete
}

install_dependencies() {
    local dest_dir="$1"

    cd "$dest_dir"

    echo "Installing dependencies..."
    npm install

    echo "Running initial build..."
    npm run build
}

main() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <project_name> <destination_directory>"
        echo "Example: $0 my-angular-app ~/projects/"
        exit 1
    fi

    PROJECT_NAME="$1"
    local dest_base="$2"
    PROJECT_DIR="$dest_base/$PROJECT_NAME"

    validate_project_name "$PROJECT_NAME" || exit 1
    check_node

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
    echo "  npm start"
    echo ""
    echo "Available commands:"
    echo "  npm start       - Start development server"
    echo "  npm run build   - Build for production"
    echo "  npm test        - Run tests"
    echo "  npm run lint    - Run linter"
}

main "$@"