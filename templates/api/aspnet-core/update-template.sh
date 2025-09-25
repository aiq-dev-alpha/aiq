#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="/tmp/aspnet-core-backup-$(date +%Y%m%d-%H%M%S)"

check_dotnet() {
    if ! command -v dotnet >/dev/null 2>&1; then
        echo "Error: .NET SDK is not installed"
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

    echo "Updating NuGet packages..."
    dotnet list package --outdated

    dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
    dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
    dotnet add package Microsoft.EntityFrameworkCore.Design
    dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
    dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection
    dotnet add package Swashbuckle.AspNetCore
    dotnet add package FluentValidation.AspNetCore
    dotnet add package Serilog.AspNetCore

    if ! dotnet restore; then
        echo "Error: Failed to restore packages"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! dotnet build --no-restore; then
        echo "Error: Failed to build after update"
        echo "Restoring from backup..."
        cp -r "$BACKUP_DIR/template/"* "$TEMPLATE_DIR/"
        exit 1
    fi

    if ! dotnet test --no-build; then
        echo "Warning: Tests failed after update"
    fi
}

main() {
    check_dotnet

    if [ ! -f "$TEMPLATE_DIR"/*.csproj ]; then
        echo "Error: Not in a .NET project directory"
        exit 1
    fi

    create_backup
    update_dependencies

    echo "Update completed"
    echo "Backup location: $BACKUP_DIR"
}

main "$@"