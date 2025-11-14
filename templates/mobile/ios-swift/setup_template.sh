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

# Function to validate input
validate_input() {
    if [ -z "$1" ]; then
        print_error "Input cannot be empty"
        return 1
    fi
    return 0
}

# Main setup function
setup_ios_project() {
    print_status "Starting iOS Swift project setup..."

    # Get project details from user
    echo ""
    read -p "Enter your app name (e.g., MyAwesomeApp): " APP_NAME
    validate_input "$APP_NAME" || exit 1

    read -p "Enter your bundle identifier (e.g., com.yourcompany.myapp): " BUNDLE_ID
    validate_input "$BUNDLE_ID" || exit 1

    read -p "Enter your organization name (e.g., Your Company): " ORG_NAME
    validate_input "$ORG_NAME" || exit 1

    read -p "Enter project directory name (default: ${APP_NAME}): " PROJECT_DIR
    PROJECT_DIR=${PROJECT_DIR:-$APP_NAME}

    read -p "Enter your API base URL (e.g., https://api.yourapp.com/v1): " API_BASE_URL
    validate_input "$API_BASE_URL" || exit 1

    echo ""
    print_status "Project Configuration:"
    echo "  App Name: $APP_NAME"
    echo "  Bundle ID: $BUNDLE_ID"
    echo "  Organization: $ORG_NAME"
    echo "  Project Directory: $PROJECT_DIR"
    echo "  API Base URL: $API_BASE_URL"
    echo ""

    read -p "Continue with setup? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Setup cancelled by user"
        exit 0
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

    # Create project directory
    print_status "Creating project directory: $PROJECT_DIR"

    if [ -d "$PROJECT_DIR" ]; then
        print_error "Directory $PROJECT_DIR already exists"
        read -p "Remove existing directory? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$PROJECT_DIR"
        else
            exit 1
        fi
    fi

    # Copy template files
    print_status "Copying template files..."

    TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp -R "$TEMPLATE_DIR" "$PROJECT_DIR"
    cd "$PROJECT_DIR"

    # Remove setup scripts from the new project
    rm -f setup-template.sh update-template.sh

    # Replace template placeholders
    print_status "Customizing project files..."

    # Update Package.swift
    sed -i.bak "s/iOSApp/$APP_NAME/g" Package.swift
    rm Package.swift.bak

    # Update Info.plist
    sed -i.bak "s/com.yourcompany.iosapp/$BUNDLE_ID/g" Resources/Info.plist
    sed -i.bak "s/iOS App/$APP_NAME/g" Resources/Info.plist
    rm Resources/Info.plist.bak

    # Update App.swift
    sed -i.bak "s/iOSApp/$APP_NAME/g" Sources/App/App.swift
    rm Sources/App/App.swift.bak

    # Update NetworkingService.swift with API base URL
    sed -i.bak "s|https://api.yourapp.com/v1|$API_BASE_URL|g" Sources/App/Services/Networking/NetworkingService.swift
    rm Sources/App/Services/Networking/NetworkingService.swift.bak

    # Initialize git repository
    print_status "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: iOS Swift project setup

- App Name: $APP_NAME
- Bundle ID: $BUNDLE_ID
- Organization: $ORG_NAME
- API Base URL: $API_BASE_URL

Generated from iOS Swift template"

    # Create .gitignore
    print_status "Creating .gitignore file..."
    cat > .gitignore << 'EOF'
# Xcode
*.xcodeproj/
*.xcworkspace/
.DS_Store
.build/
/Packages
/*.xcodeproj
xcuserdata/

# Swift Package Manager
.swiftpm/
.build/
/Packages/
/*.xcodeproj

# CocoaPods (if using)
/Pods/
Podfile.lock

# Carthage (if using)
/Carthage/

# Fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output

# Environment files
.env
.env.local
.env.production

# IDE files
.vscode/
.idea/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF

    git add .gitignore
    git commit -m "Add .gitignore file"

    # Build project to verify setup
    print_status "Building project to verify setup..."
    if swift build; then
        print_success "Project built successfully!"
    else
        print_warning "Project build failed. You may need to resolve dependencies manually."
    fi

    # Create development scripts
    print_status "Creating development scripts..."

    # Create run script
    cat > run.sh << 'EOF'
#!/bin/bash
# Run the iOS app (for command line testing)
swift run
EOF
    chmod +x run.sh

    # Create test script
    cat > test.sh << 'EOF'
#!/bin/bash
# Run tests
swift test
EOF
    chmod +x test.sh

    # Create build script
    cat > build.sh << 'EOF'
#!/bin/bash
# Build the project
swift build
EOF
    chmod +x build.sh

    git add *.sh
    git commit -m "Add development scripts"

    # Final setup complete
    print_success "iOS Swift project setup completed successfully!"
    echo ""
    print_status "Next steps:"
    echo "  1. cd $PROJECT_DIR"
    echo "  2. Open the project in Xcode or your preferred editor"
    echo "  3. Update the API base URL in NetworkingService.swift if needed"
    echo "  4. Add your specific business logic and UI customizations"
    echo "  5. Update the README.md with project-specific information"
    echo "  6. Configure your CI/CD pipelines"
    echo ""
    print_status "Available commands:"
    echo "  ./build.sh  - Build the project"
    echo "  ./test.sh   - Run tests"
    echo "  ./run.sh    - Run the app (command line)"
    echo ""
    print_status "Project structure:"
    echo "  Sources/App/               - Main application code"
    echo "  ├── Views/                - SwiftUI views"
    echo "  ├── ViewModels/           - MVVM view models"
    echo "  ├── Models/               - Data models"
    echo "  ├── Services/             - Business services"
    echo "  │   ├── Networking/       - Network layer"
    echo "  │   └── Persistence/      - Core Data layer"
    echo "  └── Utils/                - Utility classes"
    echo "  Resources/                - App resources"
    echo "  Tests/AppTests/           - Unit tests"
    echo ""
    print_success "Happy coding! 🚀"
}

# Run setup
setup_ios_project