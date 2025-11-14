#!/bin/bash

set -euo pipefail

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup file
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backed up $file"
    fi
}

# Function to update file if different
update_file_if_different() {
    local template_file="$1"
    local target_file="$2"
    local force_update="$3"

    if [ ! -f "$template_file" ]; then
        print_warning "Template file $template_file not found"
        return 1
    fi

    if [ ! -f "$target_file" ]; then
        print_status "Creating new file: $target_file"
        mkdir -p "$(dirname "$target_file")"
        cp "$template_file" "$target_file"
        return 0
    fi

    if [ "$force_update" = "true" ] || ! cmp -s "$template_file" "$target_file"; then
        print_status "Updating file: $target_file"
        backup_file "$target_file"
        cp "$template_file" "$target_file"
        return 0
    else
        print_status "File unchanged: $target_file"
        return 1
    fi
}

# Main update function
update_ios_project() {
    print_status "Starting iOS Swift project update..."

    # Check if we're in a valid project directory
    if [ ! -f "Package.swift" ]; then
        print_error "Not in a valid Swift project directory. Package.swift not found."
        exit 1
    fi

    # Check prerequisites
    print_status "Checking prerequisites..."

    if ! command_exists "swift"; then
        print_error "Swift is not installed. Please install Xcode or Swift toolchain."
        exit 1
    fi

    if ! command_exists "git"; then
        print_error "Git is not installed. Please install Git."
        exit 1
    fi

    # Get template directory
    TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [ ! -d "$TEMPLATE_DIR/Sources" ]; then
        print_error "Template directory structure is invalid"
        exit 1
    fi

    # Check for uncommitted changes
    if command_exists "git" && [ -d ".git" ]; then
        if ! git diff-index --quiet HEAD --; then
            print_warning "You have uncommitted changes in your repository."
            read -p "Continue with update? This may overwrite your changes. (y/N): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_warning "Update cancelled by user"
                exit 0
            fi
        fi
    fi

    # Show update options
    echo ""
    print_status "Update Options:"
    echo "1. Core architecture only (Models, ViewModels, Services)"
    echo "2. UI components only (Views)"
    echo "3. Configuration files only (Info.plist, Package.swift)"
    echo "4. Full update (all files)"
    echo "5. Custom selection"
    echo ""

    read -p "Choose update type (1-5): " -n 1 -r UPDATE_TYPE
    echo ""

    case $UPDATE_TYPE in
        1)
            print_status "Updating core architecture files..."
            UPDATE_CORE=true
            UPDATE_UI=false
            UPDATE_CONFIG=false
            ;;
        2)
            print_status "Updating UI components..."
            UPDATE_CORE=false
            UPDATE_UI=true
            UPDATE_CONFIG=false
            ;;
        3)
            print_status "Updating configuration files..."
            UPDATE_CORE=false
            UPDATE_UI=false
            UPDATE_CONFIG=true
            ;;
        4)
            print_status "Performing full update..."
            UPDATE_CORE=true
            UPDATE_UI=true
            UPDATE_CONFIG=true
            ;;
        5)
            print_status "Custom selection mode..."
            read -p "Update core architecture? (y/N): " -n 1 -r
            echo ""
            UPDATE_CORE=$([[ $REPLY =~ ^[Yy]$ ]] && echo true || echo false)

            read -p "Update UI components? (y/N): " -n 1 -r
            echo ""
            UPDATE_UI=$([[ $REPLY =~ ^[Yy]$ ]] && echo true || echo false)

            read -p "Update configuration files? (y/N): " -n 1 -r
            echo ""
            UPDATE_CONFIG=$([[ $REPLY =~ ^[Yy]$ ]] && echo true || echo false)
            ;;
        *)
            print_error "Invalid selection"
            exit 1
            ;;
    esac

    # Create update branch if git is available
    if command_exists "git" && [ -d ".git" ]; then
        BRANCH_NAME="template-update-$(date +%Y%m%d_%H%M%S)"
        print_status "Creating update branch: $BRANCH_NAME"
        git checkout -b "$BRANCH_NAME"
    fi

    UPDATED_FILES=0

    # Update core architecture files
    if [ "$UPDATE_CORE" = "true" ]; then
        print_status "Updating core architecture files..."

        # Models
        for file in "$TEMPLATE_DIR"/Sources/App/Models/*.swift; do
            if [ -f "$file" ]; then
                target="Sources/App/Models/$(basename "$file")"
                update_file_if_different "$file" "$target" && ((UPDATED_FILES++))
            fi
        done

        # ViewModels
        for file in "$TEMPLATE_DIR"/Sources/App/ViewModels/*.swift; do
            if [ -f "$file" ]; then
                target="Sources/App/ViewModels/$(basename "$file")"
                update_file_if_different "$file" "$target" && ((UPDATED_FILES++))
            fi
        done

        # Services
        find "$TEMPLATE_DIR/Sources/App/Services" -name "*.swift" -type f | while read -r file; do
            rel_path="${file#$TEMPLATE_DIR/Sources/App/Services/}"
            target="Sources/App/Services/$rel_path"
            update_file_if_different "$file" "$target" && ((UPDATED_FILES++))
        done
    fi

    # Update UI components
    if [ "$UPDATE_UI" = "true" ]; then
        print_status "Updating UI components..."

        # Views
        find "$TEMPLATE_DIR/Sources/App/Views" -name "*.swift" -type f | while read -r file; do
            rel_path="${file#$TEMPLATE_DIR/Sources/App/Views/}"
            target="Sources/App/Views/$rel_path"

            # Ask user for each view file since these are likely customized
            if [ -f "$target" ]; then
                print_warning "View file exists: $target"
                read -p "Update this view file? (y/N): " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    update_file_if_different "$file" "$target" true && ((UPDATED_FILES++))
                fi
            else
                update_file_if_different "$file" "$target" && ((UPDATED_FILES++))
            fi
        done

        # ContentView (special handling)
        if [ -f "$TEMPLATE_DIR/Sources/App/ContentView.swift" ]; then
            if [ -f "Sources/App/ContentView.swift" ]; then
                print_warning "ContentView.swift exists and may be customized"
                read -p "Update ContentView.swift? (y/N): " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    update_file_if_different "$TEMPLATE_DIR/Sources/App/ContentView.swift" "Sources/App/ContentView.swift" true && ((UPDATED_FILES++))
                fi
            else
                update_file_if_different "$TEMPLATE_DIR/Sources/App/ContentView.swift" "Sources/App/ContentView.swift" && ((UPDATED_FILES++))
            fi
        fi
    fi

    # Update configuration files
    if [ "$UPDATE_CONFIG" = "true" ]; then
        print_status "Updating configuration files..."

        # Package.swift (ask user since it may be customized)
        if [ -f "Package.swift" ]; then
            print_warning "Package.swift may contain custom dependencies"
            read -p "Update Package.swift? This may overwrite custom dependencies. (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                update_file_if_different "$TEMPLATE_DIR/Package.swift" "Package.swift" true && ((UPDATED_FILES++))
            fi
        fi

        # Info.plist (preserve customizations)
        if [ -f "Resources/Info.plist" ] && [ -f "$TEMPLATE_DIR/Resources/Info.plist" ]; then
            print_warning "Info.plist may contain custom configuration"
            read -p "Update Info.plist? This may overwrite custom settings. (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                update_file_if_different "$TEMPLATE_DIR/Resources/Info.plist" "Resources/Info.plist" true && ((UPDATED_FILES++))
            fi
        fi
    fi

    # Update App.swift if requested
    if [ "$UPDATE_CORE" = "true" ] && [ -f "$TEMPLATE_DIR/Sources/App/App.swift" ]; then
        if [ -f "Sources/App/App.swift" ]; then
            print_warning "App.swift may be customized"
            read -p "Update App.swift? (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                update_file_if_different "$TEMPLATE_DIR/Sources/App/App.swift" "Sources/App/App.swift" true && ((UPDATED_FILES++))
            fi
        fi
    fi

    # Build project to verify updates
    print_status "Building project to verify updates..."
    if swift build; then
        print_success "Project built successfully after updates!"
    else
        print_warning "Project build failed after updates. You may need to resolve conflicts manually."
    fi

    # Commit changes if git is available
    if command_exists "git" && [ -d ".git" ]; then
        if [ $UPDATED_FILES -gt 0 ]; then
            git add .
            git commit -m "Update from iOS Swift template

Updated $UPDATED_FILES file(s):
- Core architecture: $UPDATE_CORE
- UI components: $UPDATE_UI
- Configuration: $UPDATE_CONFIG

Template update performed on $(date)"

            print_status "Changes committed to branch: $BRANCH_NAME"
            print_status "To merge changes: git checkout main && git merge $BRANCH_NAME"
            print_status "To discard changes: git checkout main && git branch -D $BRANCH_NAME"
        else
            git checkout main
            git branch -D "$BRANCH_NAME"
            print_status "No files were updated, branch removed"
        fi
    fi

    # Final status
    if [ $UPDATED_FILES -gt 0 ]; then
        print_success "Template update completed! Updated $UPDATED_FILES file(s)."
        echo ""
        print_status "Next steps:"
        echo "  1. Review the updated files for any conflicts"
        echo "  2. Test your app to ensure everything works correctly"
        echo "  3. Update any customized code that may have been overwritten"
        echo "  4. Commit your changes if you're satisfied with the updates"
    else
        print_success "No files needed updating. Your project is up to date!"
    fi

    echo ""
    print_status "Update completed successfully! 🎉"
}

# Show usage if help requested
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "iOS Swift Template Update Script"
    echo ""
    echo "This script updates an existing iOS Swift project with the latest template changes."
    echo ""
    echo "Usage: ./update-template.sh"
    echo ""
    echo "The script will:"
    echo "  - Create a backup of modified files"
    echo "  - Allow selective updates of different components"
    echo "  - Create a git branch for the update (if git is available)"
    echo "  - Build the project to verify the updates"
    echo ""
    echo "Update categories:"
    echo "  - Core architecture: Models, ViewModels, Services"
    echo "  - UI components: Views and SwiftUI code"
    echo "  - Configuration: Package.swift, Info.plist"
    exit 0
fi

# Run update
update_ios_project