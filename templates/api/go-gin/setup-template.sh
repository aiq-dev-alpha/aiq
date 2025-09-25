#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
LOG_FILE="/tmp/go-gin-setup-$(date +%Y%m%d-%H%M%S).log"

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

    if [[ ! "$name" =~ ^[a-z][a-z0-9_-]*$ ]]; then
        echo "Error: Project name must start with lowercase letter and contain only lowercase letters, numbers, hyphens, and underscores"
        return 1
    fi

    return 0
}

check_prerequisites() {
    if ! command -v go >/dev/null 2>&1; then
        echo "Error: Go is not installed"
        exit 1
    fi

    local go_version=$(go version | cut -d' ' -f3 | sed 's/go//' | cut -d. -f1-2)
    if [ "$(echo "$go_version < 1.19" | bc)" -eq 1 ]; then
        echo "Error: Go version 1.19 or higher required"
        exit 1
    fi
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up $project_name..."

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" -exec cp {} "$dest_dir/" \;

    for dir in internal; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    if [ -f "$dest_dir/go.mod" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" "$dest_dir/go.mod"
        rm -f "$dest_dir/go.mod.bak"
    fi

    if [ -f "$dest_dir/.env.example" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" "$dest_dir/.env.example"
        rm -f "$dest_dir/.env.example.bak"
    fi

    find "$dest_dir" -name "*.go" -type f -exec sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" {} \;
    find "$dest_dir" -name "*.bak" -type f -delete
}

main() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <project_name> <destination_directory>"
        exit 1
    fi

    PROJECT_NAME="$1"
    PROJECT_DIR="$2"

    validate_project_name "$PROJECT_NAME" || exit 1
    check_prerequisites

    if [ -d "$PROJECT_DIR" ]; then
        echo "Error: Directory $PROJECT_DIR already exists"
        exit 1
    fi

    copy_template "$PROJECT_DIR" "$PROJECT_NAME"
    customize_template "$PROJECT_DIR" "$PROJECT_NAME"

    cd "$PROJECT_DIR"

    cp .env.example .env

    go mod tidy >> "$LOG_FILE" 2>&1 || {
        echo "Error: Failed to download dependencies"
        exit 1
    }

    echo "Project created: $PROJECT_DIR"
    echo "Run: cd $PROJECT_DIR && go run main.go"
}

main "$@"