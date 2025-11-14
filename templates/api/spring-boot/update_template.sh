#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/spring-boot-backup-$(date +%Y%m%d-%H%M%S)"

check_java() {
    if ! command -v java >/dev/null 2>&1; then
        echo "Error: Java is not installed"
        exit 1
    fi

    if ! command -v mvn >/dev/null 2>&1; then
        echo "Error: Maven is not installed"
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

    echo "Updating Maven dependencies..."
    mvn versions:use-latest-releases -DallowMajorUpdates=false

    if ! mvn clean compile; then
        echo "Error: Failed to compile after update"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! mvn test; then
        echo "Warning: Tests failed after update"
    fi

    mvn dependency:analyze
}

main() {
    check_java

    if [ ! -f "$TEMPLATE_DIR/pom.xml" ]; then
        echo "Error: Not in a Maven project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"