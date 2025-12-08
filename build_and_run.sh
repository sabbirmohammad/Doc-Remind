#!/bin/bash

# Doc Remind - Build & Run Script
# This script sets up and runs the Doc Remind application

set -e  # Exit on error

echo "=================================================="
echo "  Doc Remind - Smart Health & Medicine Reminder"
echo "=================================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if in correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found. Please run this script from the project root directory."
    exit 1
fi

echo "✅ Flutter detected"
echo ""

# Step 1: Clean previous build
echo "📦 Step 1: Cleaning previous build..."
flutter clean
echo ""

# Step 2: Get dependencies
echo "📦 Step 2: Getting dependencies..."
flutter pub get
echo ""

# Step 3: Generate Hive adapters
echo "📦 Step 3: Generating Hive database adapters..."
flutter pub run build_runner build --delete-conflicting-outputs
echo ""

# Step 4: Display options
echo "=================================================="
echo "  Setup Complete! Choose an option:"
echo "=================================================="
echo ""
echo "1) Run app on device/emulator"
echo "2) Build APK (Android release)"
echo "3) Build iOS"
echo "4) Run tests"
echo "5) Exit"
echo ""

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Running app..."
        flutter run
        ;;
    2)
        echo ""
        echo "📱 Building APK..."
        flutter build apk --release
        echo "✅ APK built successfully!"
        echo "📁 Location: build/app/outputs/flutter-apk/"
        ;;
    3)
        echo ""
        echo "📱 Building iOS..."
        flutter build ios --release
        echo "✅ iOS built successfully!"
        ;;
    4)
        echo ""
        echo "🧪 Running tests..."
        flutter test
        ;;
    5)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice. Please try again."
        exit 1
        ;;
esac

echo ""
echo "✅ Done!"
