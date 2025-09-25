#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/cordova-ionic-backup-$(date +%Y%m%d-%H%M%S)"

check_prerequisites() {
    if ! command -v node >/dev/null 2>&1; then
        echo "Error: Node.js is not installed"
        exit 1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "Error: npm is not installed"
        exit 1
    fi

    if ! command -v ionic >/dev/null 2>&1; then
        echo "Error: Ionic CLI is not installed"
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

    echo "Updating Ionic packages..."
    npm update @ionic/angular @ionic/cli

    echo "Updating Cordova plugins..."
    ionic cordova plugin ls | while read plugin version; do
        if [ -n "$plugin" ] && [[ ! "$plugin" =~ "Installed platforms" ]]; then
            echo "Updating $plugin..."
            ionic cordova plugin rm "$plugin" --no-interactive
            ionic cordova plugin add "$plugin" --no-interactive
        fi
    done

    if ! npm install; then
        echo "Error: Failed to install dependencies"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    echo "Preparing project..."
    ionic cordova prepare

    if ! ionic build; then
        echo "Warning: Build failed after update"
    fi
}

main() {
    check_prerequisites

    if [ ! -f "$TEMPLATE_DIR/package.json" ] || [ ! -f "$TEMPLATE_DIR/ionic.config.json" ]; then
        echo "Error: Not in a Cordova Ionic project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"