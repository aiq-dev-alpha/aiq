#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
LOG_FILE="/tmp/aspnet-core-setup-$(date +%Y%m%d-%H%M%S).log"

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

    if [[ ! "$name" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
        echo "Error: Project name must start with uppercase letter and contain only letters and numbers (PascalCase)"
        return 1
    fi

    return 0
}

check_prerequisites() {
    if ! command -v dotnet >/dev/null 2>&1; then
        echo "Error: .NET SDK is not installed"
        exit 1
    fi

    local dotnet_version=$(dotnet --version | cut -d. -f1)
    if [ "$dotnet_version" -lt 8 ]; then
        echo "Error: .NET 8.0 or higher required"
        exit 1
    fi
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up $project_name..."

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" -exec cp {} "$dest_dir/" \;

    for dir in Data Models Controllers Services DTOs Configurations Validators; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    find "$dest_dir" -name "*.cs" -type f -exec sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" {} \;
    find "$dest_dir" -name "*.json" -type f -exec sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" {} \;
    find "$dest_dir" -name "*.csproj" -type f -exec sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" {} \;
    find "$dest_dir" -name "*.bak" -type f -delete

    if [ -f "$dest_dir/{{PROJECT_NAME}}.csproj" ]; then
        mv "$dest_dir/{{PROJECT_NAME}}.csproj" "$dest_dir/$project_name.csproj"
    fi
}

main() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <ProjectName> <destination_directory>"
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

    dotnet restore >> "$LOG_FILE" 2>&1 || {
        echo "Error: Failed to restore packages"
        exit 1
    }

    dotnet build --no-restore >> "$LOG_FILE" 2>&1 || {
        echo "Error: Failed to build project"
        exit 1
    }

    echo "Project created: $PROJECT_DIR"
    echo "Run: cd $PROJECT_DIR && dotnet run"
}

main "$@"