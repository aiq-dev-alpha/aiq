#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/flutter-backup-$(date +%Y%m%d-%H%M%S)"

check_flutter() {
    if ! command -v flutter >/dev/null 2>&1; then
        echo "Error: Flutter is not installed"
        exit 1
    fi
}

create_backup() {
    mkdir -p "$BACKUP_DIR"
    cp -r "$TEMPLATE_DIR" "$BACKUP_DIR/template"
    echo "Backup created: $BACKUP_DIR"
}

update_dependencies() {
    cd "$TEMPLATE_DIR"

    echo "Updating Flutter SDK..."
    flutter upgrade --force

    echo "Updating dependencies..."
    flutter pub upgrade --major-versions

    if ! flutter pub get; then
        echo "Error: Failed to resolve dependencies"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! flutter analyze --no-fatal-warnings; then
        echo "Warning: Static analysis found issues"
    fi
}

update_gradle() {
    local gradle_wrapper="$TEMPLATE_DIR/android/gradle/wrapper/gradle-wrapper.properties"
    if [ -f "$gradle_wrapper" ]; then
        sed -i.bak "s/distributionUrl=.*/distributionUrl=https\:\/\/services.gradle.org\/distributions\/gradle-8.5-all.zip/" "$gradle_wrapper"
        rm -f "$gradle_wrapper.bak"
        echo "Gradle updated to 8.5"
    fi
}

main() {
    check_flutter

    if [ ! -f "$TEMPLATE_DIR/pubspec.yaml" ]; then
        echo "Error: Not in a Flutter project directory"
        exit 1
    fi

    create_backup
    update_dependencies
    update_gradle

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"