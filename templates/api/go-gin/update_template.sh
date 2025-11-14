#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/go-gin-backup-$(date +%Y%m%d-%H%M%S)"

check_go() {
    if ! command -v go >/dev/null 2>&1; then
        echo "Error: Go is not installed"
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

    echo "Updating Go modules..."
    go get -u all

    if ! go mod tidy; then
        echo "Error: Failed to tidy modules"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! go build -o /tmp/build-test .; then
        echo "Warning: Build test failed"
    else
        rm -f /tmp/build-test
    fi

    if ! go vet ./...; then
        echo "Warning: Go vet found issues"
    fi
}

main() {
    check_go

    if [ ! -f "$TEMPLATE_DIR/go.mod" ]; then
        echo "Error: Not in a Go project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"