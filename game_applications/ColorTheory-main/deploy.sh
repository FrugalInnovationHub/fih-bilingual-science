#!/bin/bash

# Flutter Web Deployment Script
# Usage: ./deploy.sh [PORT]
# Example: ./deploy.sh 8080

PORT=${1:-8080}

echo "Building Flutter web app..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo "Starting server on port $PORT..."
echo "Access your app at: http://localhost:$PORT"

# Serve the built web app using Python's built-in HTTP server
cd build/web
python3 -m http.server $PORT

