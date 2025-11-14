#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
LOG_FILE="/tmp/spring-boot-setup-$(date +%Y%m%d-%H%M%S).log"

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
    if ! command -v java >/dev/null 2>&1; then
        echo "Error: Java is not installed"
        exit 1
    fi

    local java_version=$(java -version 2>&1 | grep -oP 'version "1\.\d+' | grep -oP '\d+$' || echo "0")
    if [ "$java_version" -lt 17 ]; then
        echo "Error: Java 17 or higher required"
        exit 1
    fi

    if ! command -v mvn >/dev/null 2>&1; then
        echo "Error: Maven is not installed"
        exit 1
    fi
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up $project_name..."

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" -exec cp {} "$dest_dir/" \;

    for dir in src; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    if [ -f "$dest_dir/pom.xml" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" "$dest_dir/pom.xml"
        rm -f "$dest_dir/pom.xml.bak"
    fi

    if [ -f "$dest_dir/application.yml" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" "$dest_dir/application.yml"
        rm -f "$dest_dir/application.yml.bak"
    fi

    find "$dest_dir/src" -name "*.java" -type f -exec sed -i.bak "s/{{PROJECT_NAME}}/$project_name/g" {} \;
    find "$dest_dir" -name "*.bak" -type f -delete

    if [ -d "$dest_dir/src/main/java/com/example/{{PROJECT_NAME}}" ]; then
        mv "$dest_dir/src/main/java/com/example/{{PROJECT_NAME}}" "$dest_dir/src/main/java/com/example/$project_name"
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

    mvn clean compile >> "$LOG_FILE" 2>&1 || {
        echo "Error: Failed to compile project"
        exit 1
    }

    echo "Project created: $PROJECT_DIR"
    echo "Run: cd $PROJECT_DIR && mvn spring-boot:run"
}

main "$@"