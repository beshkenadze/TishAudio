#!/bin/bash
set -e

# TishAudio Build Script
# Builds a customized version of BlackHole for Tish noise cancellation app

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/build"

# Configuration
DRIVER_NAME="TishAudio"
BUNDLE_ID="app.beshkenadze.tish.audio"
DEVICE_NAME="Tish Audio"
CHANNELS=2
SAMPLE_RATES="44100,48000,96000"

echo "=== Building TishAudio ==="
echo "Driver Name: $DRIVER_NAME"
echo "Bundle ID: $BUNDLE_ID"
echo "Device Name: $DEVICE_NAME"
echo "Channels: $CHANNELS"
echo ""

cd "$PROJECT_DIR"

# Clean previous build
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Build for both architectures
echo "Building universal binary (arm64 + x86_64)..."

xcodebuild \
  -project BlackHole.xcodeproj \
  -scheme BlackHole \
  -configuration Release \
  -arch arm64 \
  -arch x86_64 \
  ONLY_ACTIVE_ARCH=NO \
  PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" \
  PRODUCT_NAME="$DRIVER_NAME" \
  GCC_PREPROCESSOR_DEFINITIONS='$(inherited)
    kDriver_Name=\"'"$DRIVER_NAME"'\"
    kPlugIn_BundleID=\"'"$BUNDLE_ID"'\"
    kDevice_Name=\"'"$DEVICE_NAME"'\"
    kNumber_Of_Channels='"$CHANNELS"'
    kSampleRates='"$SAMPLE_RATES"'' \
  SYMROOT="$OUTPUT_DIR" \
  2>&1 | tee "$OUTPUT_DIR/build.log"

# Find the built driver
BUILT_DRIVER="$OUTPUT_DIR/Release/${DRIVER_NAME}.driver"

if [ -d "$BUILT_DRIVER" ]; then
    echo ""
    echo "=== Build Successful ==="
    echo "Driver: $BUILT_DRIVER"
    
    # Show architectures
    echo ""
    echo "Architectures:"
    lipo -info "$BUILT_DRIVER/Contents/MacOS/$DRIVER_NAME" 2>/dev/null || true
    
    echo ""
    echo "To install:"
    echo "  sudo cp -R '$BUILT_DRIVER' /Library/Audio/Plug-Ins/HAL/"
    echo "  sudo killall -9 coreaudiod"
    echo ""
    echo "To uninstall:"
    echo "  sudo rm -rf '/Library/Audio/Plug-Ins/HAL/${DRIVER_NAME}.driver'"
    echo "  sudo killall -9 coreaudiod"
else
    echo "ERROR: Build failed. Check $OUTPUT_DIR/build.log"
    exit 1
fi
