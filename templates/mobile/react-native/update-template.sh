#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/react-native-backup-$(date +%Y%m%d-%H%M%S)"

check_prerequisites() {
    if ! command -v node >/dev/null 2>&1; then
        echo "Error: Node.js is not installed"
        exit 1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "Error: npm is not installed"
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

    echo "Updating dependencies..."
    npm update

    if ! npm install; then
        echo "Error: Failed to install dependencies"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if [ -f "tsconfig.json" ]; then
        npx tsc --noEmit || echo "Warning: TypeScript compilation issues"
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

update_pods() {
    if [[ "$OSTYPE" == "darwin"* ]] && [ -d "$TEMPLATE_DIR/ios" ] && command -v pod >/dev/null 2>&1; then
        cd "$TEMPLATE_DIR/ios"
        pod install --repo-update
        cd "$TEMPLATE_DIR"
        echo "iOS pods updated"
    fi
}

main() {
    check_prerequisites

    if [ ! -f "$TEMPLATE_DIR/package.json" ]; then
        echo "Error: Not in a React Native project directory"
        exit 1
    fi

    create_backup
    update_dependencies
    update_gradle
    update_pods

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"