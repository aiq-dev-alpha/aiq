#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/cordova-backup-$(date +%Y%m%d-%H%M%S)"

check_node() {
    if ! command -v node >/dev/null 2>&1; then
        echo "Error: Node.js is not installed"
        exit 1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "Error: npm is not installed"
        exit 1
    fi

    if ! command -v cordova >/dev/null 2>&1; then
        echo "Error: Cordova CLI is not installed"
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

    echo "Updating npm packages..."
    npm update

    echo "Updating Cordova plugins..."
    cordova plugin ls | while read plugin version; do
        if [ -n "$plugin" ]; then
            echo "Updating $plugin..."
            cordova plugin rm "$plugin" --nosave
            cordova plugin add "$plugin"
        fi
    done

    if ! npm install; then
        echo "Error: Failed to install dependencies"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! npm run build; then
        echo "Warning: Build failed after update"
    fi

    echo "Preparing Cordova..."
    cordova prepare
}

main() {
    check_node

    if [ ! -f "$TEMPLATE_DIR/package.json" ] || [ ! -f "$TEMPLATE_DIR/config.xml" ]; then
        echo "Error: Not in a Cordova project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"