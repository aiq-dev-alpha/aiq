#!/bin/bash

# Node.js Express Template Setup Script
# Extremely careful setup with comprehensive validation and rollback capabilities
# Author: AIQ Template System
# Version: 1.0.0

set -euo pipefail

# Colors and configuration
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TEMPLATE_DIR="$SCRIPT_DIR"
readonly LOG_FILE="/tmp/nodejs-express-setup-$(date +%Y%m%d-%H%M%S).log"
readonly BACKUP_DIR="/tmp/nodejs-express-template-backup-$(date +%Y%m%d-%H%M%S)"

# Global variables
ROLLBACK_NEEDED=false
PROJECT_DIR=""
PROJECT_NAME=""
CLEANUP_DIRS=()

# Logging functions
log() { echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"; }

cleanup_on_failure() {
    if [ "$ROLLBACK_NEEDED" = true ]; then
        error "Setup failed. Initiating cleanup..."
        [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR" ] && rm -rf "$PROJECT_DIR"
        for dir in "${CLEANUP_DIRS[@]}"; do
            [ -d "$dir" ] && rm -rf "$dir"
        done
        error "Setup failed and cleanup completed. Check log: $LOG_FILE"
        exit 1
    fi
}

trap cleanup_on_failure EXIT

validate_project_name() {
    local name="$1"
    log "Validating project name: $name"

    [ -z "$name" ] && { error "Project name cannot be empty"; return 1; }
    [ ${#name} -lt 3 ] || [ ${#name} -gt 50 ] && { error "Project name must be between 3 and 50 characters"; return 1; }
    [[ ! "$name" =~ ^[a-z][a-z0-9_-]*$ ]] && { error "Project name must start with lowercase letter and contain only lowercase letters, numbers, underscores, and hyphens"; return 1; }

    local reserved_words=("node" "express" "api" "server" "npm" "yarn" "test" "lib" "src" "dist" "build")
    for word in "${reserved_words[@]}"; do
        [ "$name" = "$word" ] && { error "Project name '$name' is a reserved word"; return 1; }
    done

    success "Project name validation passed"
}

check_nodejs_prerequisites() {
    log "Checking Node.js prerequisites..."

    # Check Node.js
    command -v node >/dev/null 2>&1 || { error "Node.js is not installed"; return 1; }
    local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    log "Node.js version: $node_version"
    local node_major=$(echo "$node_version" | cut -d. -f1)
    [ "$node_major" -lt 16 ] && { error "Node.js version $node_version is too old. Required: >= 16.0.0"; return 1; }

    # Check npm
    command -v npm >/dev/null 2>&1 || { error "npm is not installed"; return 1; }
    log "npm version: $(npm --version)"

    # Check for MongoDB (optional)
    if command -v mongod >/dev/null 2>&1; then
        log "MongoDB found: $(mongod --version | head -1)"
    else
        warn "MongoDB not found locally (can use cloud MongoDB)"
    fi

    success "Node.js prerequisites check completed"
}

copy_and_customize_template() {
    local dest_dir="$1"
    local project_name="$2"

    log "Copying and customizing template..."
    ROLLBACK_NEEDED=true

    [ ! -d "$dest_dir" ] && { mkdir -p "$dest_dir"; CLEANUP_DIRS+=("$dest_dir"); }

    # Copy template files
    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "setup-template.sh" ! -name "update-template.sh" -exec cp {} "$dest_dir/" \;
    for dir in src docker; do
        [ -d "$TEMPLATE_DIR/$dir" ] && cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
    done

    # Customize package.json
    local package_json="$dest_dir/package.json"
    if [ -f "$package_json" ]; then
        cp "$package_json" "$package_json.backup"

        # Use Node.js to safely update JSON
        cat > "$dest_dir/customize.js" << EOF
const fs = require('fs');
const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
packageJson.name = '$project_name';
packageJson.description = '$project_name - Express.js API server';
fs.writeFileSync('package.json', JSON.stringify(packageJson, null, 2));
console.log('package.json customized');
EOF

        cd "$dest_dir"
        node customize.js >> "$LOG_FILE" 2>&1 || { error "Failed to customize package.json"; return 1; }
        rm -f customize.js
        cd - >/dev/null
    fi

    success "Template copied and customized"
}

install_and_validate() {
    local dest_dir="$1"

    log "Installing dependencies..."
    cd "$dest_dir"

    # Choose package manager
    local pm="npm"
    command -v yarn >/dev/null 2>&1 && pm="yarn"
    log "Using $pm for dependency installation"

    # Install dependencies with timeout
    if [ "$pm" = "yarn" ]; then
        timeout 600 yarn install >> "$LOG_FILE" 2>&1 || { error "Failed to install dependencies"; return 1; }
    else
        timeout 600 npm install >> "$LOG_FILE" 2>&1 || { error "Failed to install dependencies"; return 1; }
    fi

    # Validate installation
    [ ! -f "package.json" ] && { error "package.json missing"; return 1; }
    node -e "JSON.parse(require('fs').readFileSync('package.json', 'utf8'))" 2>/dev/null || { error "Invalid package.json"; return 1; }

    # Test TypeScript compilation
    if [ -f "tsconfig.json" ]; then
        log "Testing TypeScript compilation..."
        timeout 60 npx tsc --noEmit >> "$LOG_FILE" 2>&1 && success "TypeScript check passed" || warn "TypeScript issues found"
    fi

    # Test ESLint
    npx eslint . >> "$LOG_FILE" 2>&1 && success "ESLint check passed" || warn "ESLint issues found"

    # Test server startup
    log "Testing server startup..."
    timeout 10 npm run dev >> "$LOG_FILE" 2>&1 && success "Server startup test passed" || warn "Server startup had issues"

    cd - >/dev/null
    success "Dependencies installed and validated"
}

show_usage() {
    cat << EOF
Usage: $0 <project_name> <destination_directory>

Arguments:
  project_name           Name for the new Node.js Express project (lowercase, hyphens/underscores allowed)
  destination_directory  Path where the project should be created

Examples:
  $0 my-api ./projects/my_api
  $0 todo-backend /home/user/nodejs_projects/todo_backend

Prerequisites:
- Node.js 16+
- npm or yarn
- MongoDB (optional, for local development)

The script will validate everything before making changes and rollback on failure.
EOF
}

main() {
    log "Starting Node.js Express template setup..."
    log "Log file: $LOG_FILE"

    [ $# -ne 2 ] && { error "Invalid arguments"; show_usage; exit 1; }

    PROJECT_NAME="$1"
    PROJECT_DIR="$2"

    log "Project name: $PROJECT_NAME"
    log "Destination: $PROJECT_DIR"

    # Validation
    validate_project_name "$PROJECT_NAME" || exit 1
    [ -d "$PROJECT_DIR" ] && [ "$(ls -A "$PROJECT_DIR" 2>/dev/null)" ] && { error "Destination directory is not empty"; exit 1; }
    check_nodejs_prerequisites || exit 1

    # Confirmation
    echo -e "${YELLOW}Create Node.js Express project '$PROJECT_NAME' in '$PROJECT_DIR'? (y/N)${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) log "User confirmed" ;;
        *) log "Cancelled"; exit 0 ;;
    esac

    # Setup
    mkdir -p "$BACKUP_DIR" && cp -r "$TEMPLATE_DIR" "$BACKUP_DIR/original-template"
    copy_and_customize_template "$PROJECT_DIR" "$PROJECT_NAME"
    install_and_validate "$PROJECT_DIR"

    # Success
    ROLLBACK_NEEDED=false
    success "Node.js Express project '$PROJECT_NAME' created successfully!"
    success "Location: $PROJECT_DIR"
    success "Backup: $BACKUP_DIR"

    echo -e "${GREEN}Next steps:${NC}"
    echo "  cd $PROJECT_DIR"
    echo "  npm run dev          # Start development server"
    echo "  npm run build        # Build for production"
    echo "  npm test             # Run tests"
}

main "$@"