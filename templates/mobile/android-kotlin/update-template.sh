#!/bin/bash

set -euo pipefail

set -e

echo "🔄 Android Kotlin Template Update"
echo "================================="

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -c, --check                   Check for available updates"
    echo "  -u, --update                  Update dependencies"
    echo "  -r, --refresh                 Refresh Gradle wrapper"
    echo "  -a, --all                     Run all update operations"
    echo "  -h, --help                    Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 --check                    # Check for updates"
    echo "  $0 --update                   # Update dependencies"
    echo "  $0 --all                      # Run all operations"
    exit 0
}

# Default values
CHECK_UPDATES=false
UPDATE_DEPS=false
REFRESH_GRADLE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--check)
            CHECK_UPDATES=true
            shift
            ;;
        -u|--update)
            UPDATE_DEPS=true
            shift
            ;;
        -r|--refresh)
            REFRESH_GRADLE=true
            shift
            ;;
        -a|--all)
            CHECK_UPDATES=true
            UPDATE_DEPS=true
            REFRESH_GRADLE=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option $1"
            show_help
            ;;
    esac
done

# If no arguments provided, show interactive menu
if [[ "$CHECK_UPDATES" == false && "$UPDATE_DEPS" == false && "$REFRESH_GRADLE" == false ]]; then
    echo "What would you like to do?"
    echo "1) Check for dependency updates"
    echo "2) Update dependencies to latest versions"
    echo "3) Refresh Gradle wrapper"
    echo "4) Run all operations"
    echo "5) Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            CHECK_UPDATES=true
            ;;
        2)
            UPDATE_DEPS=true
            ;;
        3)
            REFRESH_GRADLE=true
            ;;
        4)
            CHECK_UPDATES=true
            UPDATE_DEPS=true
            REFRESH_GRADLE=true
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            exit 1
            ;;
    esac
fi

# Check if we're in the right directory
if [[ ! -f "build.gradle.kts" || ! -f "settings.gradle.kts" ]]; then
    echo "❌ Error: This doesn't appear to be an Android project root directory."
    echo "   Please run this script from the root of your Android project."
    exit 1
fi

# Function to check for updates
check_updates() {
    echo "🔍 Checking for dependency updates..."

    if command -v ./gradlew &> /dev/null; then
        echo "   • Running dependency updates check..."
        ./gradlew dependencyUpdates --warning-mode all
    else
        echo "   ❌ Gradle wrapper not found. Run with --refresh first."
        return 1
    fi
}

# Function to update dependencies
update_dependencies() {
    echo "📦 Updating dependencies..."

    # Current versions (these should be updated manually or with a more sophisticated tool)
    echo "   • Checking current versions in libs.versions.toml..."

    if [[ -f "gradle/libs.versions.toml" ]]; then
        echo "   • Found libs.versions.toml"
        echo "   ⚠️  Please manually update versions in gradle/libs.versions.toml"
        echo "      Recommended latest versions (as of template creation):"
        echo "      - AGP: 8.7.2"
        echo "      - Kotlin: 2.0.21"
        echo "      - Compose BOM: 2024.12.01"
        echo "      - Hilt: 2.52"
        echo "      - Room: 2.6.1"
        echo "      - Retrofit: 2.11.0"
        echo "      - Navigation: 2.8.4"
    else
        echo "   ❌ gradle/libs.versions.toml not found"
        return 1
    fi
}

# Function to refresh Gradle wrapper
refresh_gradle() {
    echo "🔧 Refreshing Gradle wrapper..."

    if command -v gradle &> /dev/null; then
        echo "   • Updating Gradle wrapper to latest version..."
        gradle wrapper --gradle-version=8.11.1 --distribution-type=bin
        chmod +x gradlew
        echo "   ✅ Gradle wrapper updated"
    else
        echo "   ❌ Gradle not found in PATH. Please install Gradle first."
        return 1
    fi
}

# Function to clean and sync project
clean_project() {
    echo "🧹 Cleaning and syncing project..."

    if [[ -f "./gradlew" ]]; then
        ./gradlew clean
        echo "   ✅ Project cleaned"
    else
        echo "   ❌ Gradle wrapper not found"
        return 1
    fi
}

# Execute operations based on flags
if [[ "$REFRESH_GRADLE" == true ]]; then
    refresh_gradle
fi

if [[ "$CHECK_UPDATES" == true ]]; then
    check_updates
fi

if [[ "$UPDATE_DEPS" == true ]]; then
    update_dependencies
fi

# Always clean after updates
if [[ "$UPDATE_DEPS" == true || "$REFRESH_GRADLE" == true ]]; then
    clean_project
fi

echo ""
echo "✅ Update operations completed!"
echo ""
echo "📝 Manual update checklist:"
echo "   □ Update versions in gradle/libs.versions.toml"
echo "   □ Update compileSdk and targetSdk in app/build.gradle.kts"
echo "   □ Test the app after updates"
echo "   □ Update ProGuard rules if needed"
echo "   □ Run tests to ensure everything works"
echo ""
echo "🔗 Useful resources:"
echo "   • Android Gradle Plugin: https://developer.android.com/studio/releases/gradle-plugin"
echo "   • Kotlin releases: https://kotlinlang.org/releases.html"
echo "   • Jetpack Compose BOM: https://developer.android.com/jetpack/compose/setup"
echo "   • Dependencies updates: ./gradlew dependencyUpdates"
echo ""
echo "💡 Pro tip: Use 'gradle/libs.versions.toml' to manage all dependency versions centrally!"