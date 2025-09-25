#!/bin/bash

set -euo pipefail

set -e

echo "🚀 Android Kotlin Template Setup"
echo "================================="

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --package-name PACKAGE    Set the package name (e.g., com.company.app)"
    echo "  -a, --app-name APP_NAME       Set the application name"
    echo "  -h, --help                    Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 --package-name com.mycompany.myapp --app-name \"My App\""
    exit 0
}

# Default values
PACKAGE_NAME=""
APP_NAME=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--package-name)
            PACKAGE_NAME="$2"
            shift 2
            ;;
        -a|--app-name)
            APP_NAME="$2"
            shift 2
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

# Interactive setup if no arguments provided
if [[ -z "$PACKAGE_NAME" ]]; then
    echo -n "Enter your package name (e.g., com.company.app): "
    read PACKAGE_NAME

    if [[ -z "$PACKAGE_NAME" ]]; then
        echo "❌ Package name is required!"
        exit 1
    fi
fi

if [[ -z "$APP_NAME" ]]; then
    echo -n "Enter your app name: "
    read APP_NAME

    if [[ -z "$APP_NAME" ]]; then
        echo "❌ App name is required!"
        exit 1
    fi
fi

# Validate package name format
if [[ ! "$PACKAGE_NAME" =~ ^[a-z][a-z0-9]*(\.[a-z][a-z0-9_]*)*$ ]]; then
    echo "❌ Invalid package name format. Use format like: com.company.app"
    exit 1
fi

echo ""
echo "📝 Configuration:"
echo "   Package Name: $PACKAGE_NAME"
echo "   App Name: $APP_NAME"
echo ""

# Extract package components
IFS='.' read -ra PACKAGE_PARTS <<< "$PACKAGE_NAME"
PACKAGE_PATH=""
for part in "${PACKAGE_PARTS[@]}"; do
    PACKAGE_PATH="$PACKAGE_PATH/$part"
done
PACKAGE_PATH="${PACKAGE_PATH:1}" # Remove leading slash

echo "🔄 Setting up your Android project..."

# Update package name in files
echo "   • Updating package declarations..."

# Find all Kotlin files and update package declarations
find app/src -name "*.kt" -type f -exec sed -i "s/package com\.template\.android/package $PACKAGE_NAME/g" {} \;

# Update imports in Kotlin files
find app/src -name "*.kt" -type f -exec sed -i "s/com\.template\.android/$PACKAGE_NAME/g" {} \;

# Update AndroidManifest.xml
sed -i "s/com\.template\.android/$PACKAGE_NAME/g" app/src/main/AndroidManifest.xml

# Update build.gradle.kts
sed -i "s/com\.template\.android/$PACKAGE_NAME/g" app/build.gradle.kts

# Update app name in strings.xml
sed -i "s/<string name=\"app_name\">Android Kotlin Template<\/string>/<string name=\"app_name\">$APP_NAME<\/string>/g" app/src/main/res/values/strings.xml

# Update root project name
sed -i "s/AndroidKotlinTemplate/$APP_NAME/g" settings.gradle.kts

# Create new package directory structure
echo "   • Creating new package directory structure..."
NEW_PACKAGE_DIR="app/src/main/java/$PACKAGE_PATH"
mkdir -p "$NEW_PACKAGE_DIR"

# Move files to new package structure
if [[ -d "app/src/main/java/com/template/android" ]]; then
    cp -r app/src/main/java/com/template/android/* "$NEW_PACKAGE_DIR/"
    rm -rf app/src/main/java/com/template
fi

# Update test directories
echo "   • Updating test directories..."
NEW_TEST_DIR="app/src/test/java/$PACKAGE_PATH"
NEW_ANDROID_TEST_DIR="app/src/androidTest/java/$PACKAGE_PATH"

mkdir -p "$NEW_TEST_DIR"
mkdir -p "$NEW_ANDROID_TEST_DIR"

if [[ -d "app/src/test/java/com/template/android" ]]; then
    cp -r app/src/test/java/com/template/android/* "$NEW_TEST_DIR/" 2>/dev/null || true
    rm -rf app/src/test/java/com/template
fi

if [[ -d "app/src/androidTest/java/com/template/android" ]]; then
    cp -r app/src/androidTest/java/com/template/android/* "$NEW_ANDROID_TEST_DIR/" 2>/dev/null || true
    rm -rf app/src/androidTest/java/com/template
fi

# Create basic test files
echo "   • Creating basic test files..."

cat > "$NEW_TEST_DIR/ExampleUnitTest.kt" << EOF
package $PACKAGE_NAME

import org.junit.Test
import org.junit.Assert.*

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class ExampleUnitTest {
    @Test
    fun addition_isCorrect() {
        assertEquals(4, 2 + 2)
    }
}
EOF

cat > "$NEW_ANDROID_TEST_DIR/ExampleInstrumentedTest.kt" << EOF
package $PACKAGE_NAME

import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.ext.junit.runners.AndroidJUnit4

import org.junit.Test
import org.junit.runner.RunWith

import org.junit.Assert.*

/**
 * Instrumented test, which will execute on an Android device.
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
@RunWith(AndroidJUnit4::class)
class ExampleInstrumentedTest {
    @Test
    fun useAppContext() {
        // Context of the app under test.
        val appContext = InstrumentationRegistry.getInstrumentation().targetContext
        assertEquals("$PACKAGE_NAME", appContext.packageName)
    }
}
EOF

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "📁 Your project structure:"
echo "   • Package: $PACKAGE_NAME"
echo "   • App Name: $APP_NAME"
echo "   • Main source: $NEW_PACKAGE_DIR"
echo "   • Tests: $NEW_TEST_DIR"
echo "   • Instrumented tests: $NEW_ANDROID_TEST_DIR"
echo ""
echo "🔧 Next steps:"
echo "   1. Update the API base URL in NetworkModule.kt"
echo "   2. Replace sample data models with your actual models"
echo "   3. Update the database entities and DAOs as needed"
echo "   4. Customize the UI theme colors and typography"
echo "   5. Add your app icons to the mipmap directories"
echo ""
echo "🚀 You're ready to start developing!"