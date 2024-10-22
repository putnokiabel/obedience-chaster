#!/bin/bash
# Exit on error
set -e

# Build the app
flutter build web --web-renderer canvaskit --output public

# Deploy to Firebase
firebase deploy --only hosting