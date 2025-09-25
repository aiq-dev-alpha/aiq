#!/bin/bash

set -euo pipefail

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

print_step() {
    print_color $BLUE "🔄 $1"
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_warning() {
    print_color $YELLOW "⚠️  $1"
}

print_error() {
    print_color $RED "❌ $1"
}

# Check if required arguments are provided
if [ $# -lt 2 ]; then
    print_error "Usage: $0 <project-name> <destination-path>"
    print_error "Example: $0 my-app /path/to/projects"
    exit 1
fi

PROJECT_NAME="$1"
DESTINATION="$2"
PROJECT_PATH="$DESTINATION/$PROJECT_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    print_error "Project name can only contain letters, numbers, hyphens, and underscores"
    exit 1
fi

# Check if destination directory exists
if [ ! -d "$DESTINATION" ]; then
    print_error "Destination directory '$DESTINATION' does not exist"
    exit 1
fi

# Check if project already exists
if [ -d "$PROJECT_PATH" ]; then
    print_error "Project '$PROJECT_NAME' already exists at '$PROJECT_PATH'"
    exit 1
fi

print_step "Setting up Next.js 14 TypeScript project: $PROJECT_NAME"

# Create project directory
print_step "Creating project directory..."
mkdir -p "$PROJECT_PATH"

# Copy template files
print_step "Copying template files..."
cp -r "$SCRIPT_DIR/"* "$PROJECT_PATH/" 2>/dev/null || true

# Remove setup script from destination
rm -f "$PROJECT_PATH/setup-template.sh"

# Navigate to project directory
cd "$PROJECT_PATH"

# Replace placeholders in files
print_step "Configuring project settings..."

# Function to replace placeholders in files
replace_placeholders() {
    local file="$1"
    if [ -f "$file" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$file"
        sed -i.bak "s/{{BASE_URL}}/http:\/\/localhost:3000/g" "$file"
        rm -f "${file}.bak"
    fi
}

# List of files to process
FILES_TO_PROCESS=(
    "package.json"
    "app/layout.tsx"
    "app/page.tsx"
    ".env.example"
    ".env.local"
)

for file in "${FILES_TO_PROCESS[@]}"; do
    replace_placeholders "$file"
done

# Make sure required directories exist
print_step "Creating additional directories..."
mkdir -p public/images
mkdir -p public/icons

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null; then
    print_warning "Node.js is not installed. Please install Node.js 18.17.0 or later."
    print_warning "Visit: https://nodejs.org/"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    print_warning "npm is not installed. Please install npm."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2)
REQUIRED_VERSION="18.17.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    print_warning "Node.js version $NODE_VERSION detected. Version 18.17.0 or later is recommended."
fi

# Install dependencies
print_step "Installing dependencies..."
npm install

# Check if git is available and initialize if requested
if command -v git &> /dev/null; then
    read -p "Initialize git repository? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit: Next.js 14 TypeScript template"
        print_success "Git repository initialized"
    fi
fi

# Generate environment file
print_step "Setting up environment configuration..."
if [ ! -f ".env.local" ]; then
    cp ".env.example" ".env.local"
fi

# Run type checking
print_step "Running type check..."
npm run type-check

# Run linting
print_step "Running linter..."
npm run lint

print_success "Project setup complete! 🎉"
echo
print_color $BLUE "📁 Project Location: $PROJECT_PATH"
print_color $BLUE "🚀 To get started:"
echo
print_color $YELLOW "  cd $PROJECT_PATH"
print_color $YELLOW "  npm run dev"
echo
print_color $BLUE "🔗 Open your browser and visit: http://localhost:3000"
echo
print_color $BLUE "📖 Next steps:"
print_color $BLUE "  1. Configure your environment variables in .env.local"
print_color $BLUE "  2. Set up your database (if needed)"
print_color $BLUE "  3. Configure OAuth providers for authentication"
print_color $BLUE "  4. Customize the components and pages to fit your needs"
echo
print_success "Happy coding! 🎨"