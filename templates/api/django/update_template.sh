#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/django-backup-$(date +%Y%m%d-%H%M%S)"

check_python() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "Error: Python 3 is not installed"
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

    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    else
        echo "Warning: Virtual environment not found, using system Python"
    fi

    echo "Updating Python dependencies..."
    pip install --upgrade pip

    pip install -r requirements.txt --upgrade

    if ! python manage.py check; then
        echo "Error: Django check failed"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! python manage.py makemigrations --check; then
        echo "Warning: There are unmade migrations"
    fi
}

main() {
    check_python

    if [ ! -f "$TEMPLATE_DIR/manage.py" ]; then
        echo "Error: Not in a Django project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"