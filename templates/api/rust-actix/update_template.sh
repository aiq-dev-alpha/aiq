#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/rust-actix-backup-$(date +%Y%m%d-%H%M%S)"

check_rust() {
    if ! command -v cargo >/dev/null 2>&1; then
        echo "Error: Rust/Cargo is not installed"
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

    echo "Updating Rust dependencies..."
    cargo update

    if ! cargo check; then
        echo "Error: Failed to validate dependencies"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! cargo build --release --quiet; then
        echo "Warning: Release build failed"
    fi

    if ! cargo clippy --all-targets -- -D warnings; then
        echo "Warning: Clippy found issues"
    fi
}

main() {
    check_rust

    if [ ! -f "$TEMPLATE_DIR/Cargo.toml" ]; then
        echo "Error: Not in a Rust project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"