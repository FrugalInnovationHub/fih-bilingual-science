#!/bin/bash

# Measurement Adventure - Setup Script
echo "🎮 Setting up Measurement Adventure Flutter Game..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "📋 Please install Flutter first:"
    echo "   1. Visit: https://flutter.dev/docs/get-started/install"
    echo "   2. Follow the installation guide for your OS"
    echo "   3. Add Flutter to your PATH"
    echo ""
    echo "🔄 After installing Flutter, run this script again"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Check Flutter doctor
echo "🔍 Running Flutter doctor..."
flutter doctor

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

# Build for testing
echo "🏗️ Building for testing..."
flutter build apk --debug

echo ""
echo "🎉 Setup complete! Your Measurement Adventure game is ready!"
echo ""
echo "🚀 To run the game:"
echo "   flutter run"
echo ""
echo "📱 To run on specific device:"
echo "   flutter devices"
echo "   flutter run -d <device-id>"
echo ""
echo "🎵 Don't forget to add sound files to assets/sounds/:"
echo "   - background_music.mp3"
echo "   - correct.mp3" 
echo "   - wrong.mp3"
echo ""
echo "📖 Read README.md for more details!"


