#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
LOG_FILE="/tmp/django-setup-$(date +%Y%m%d-%H%M%S).log"

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

    if [[ ! "$name" =~ ^[a-z][a-z0-9_]*$ ]]; then
        echo "Error: Project name must start with lowercase letter and contain only lowercase letters, numbers, and underscores"
        return 1
    fi

    return 0
}

check_prerequisites() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "Error: Python 3 is not installed"
        exit 1
    fi

    local python_version=$(python3 --version | cut -d' ' -f2 | cut -d. -f1-2)
    if [ "$(printf '%s\n3.9\n' "$python_version" | sort -V | head -n1)" != "3.9" ]; then
        echo "Error: Python 3.9 or higher required"
        exit 1
    fi

    if ! command -v pip3 >/dev/null 2>&1; then
        echo "Error: pip3 is not installed"
        exit 1
    fi
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up $project_name..."

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" -exec cp {} "$dest_dir/" \;

    for dir in apps "$project_name"; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    find "$dest_dir" -name "*.py" -type f -exec sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" {} \;
    find "$dest_dir" -name "*.bak" -type f -delete

    if [ -f "$dest_dir/.env.example" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" "$dest_dir/.env.example"
        rm -f "$dest_dir/.env.example.bak"
    fi

    if [ -d "$dest_dir/{{PROJECT_NAME}}" ]; then
        mv "$dest_dir/{{PROJECT_NAME}}" "$dest_dir/$project_name"
    fi
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

    python3 -m venv venv >> "$LOG_FILE" 2>&1 || {
        echo "Error: Failed to create virtual environment"
        exit 1
    }

    source venv/bin/activate

    pip install -r requirements.txt >> "$LOG_FILE" 2>&1 || {
        echo "Error: Failed to install dependencies"
        exit 1
    }

    echo "Project created: $PROJECT_DIR"
    echo "Run: cd $PROJECT_DIR && source venv/bin/activate && python manage.py runserver"
}

main "$@"