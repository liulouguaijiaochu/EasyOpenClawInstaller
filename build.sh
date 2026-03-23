#!/bin/bash

# OpenClaw Installer Build Script for macOS
# This script builds the OpenClaw Installer app and creates a distributable DMG

set -e

# Configuration
APP_NAME="OpenClawInstaller"
BUNDLE_ID="com.openclaw.installer"
VERSION="1.0.0"
BUILD_DIR="build"
DERIVED_DATA_DIR="$BUILD_DIR/DerivedData"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
EXPORT_PATH="$BUILD_DIR/Export"
DMG_NAME="OpenClaw-Installer-$VERSION.dmg"
VOLUME_NAME="OpenClaw Installer"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  OpenClaw Installer Build Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This script must be run on macOS${NC}"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}Error: Xcode is not installed${NC}"
    echo "Please install Xcode from the App Store"
    exit 1
fi

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build the project
echo -e "${YELLOW}Building OpenClaw Installer...${NC}"
xcodebuild \
    -project "$APP_NAME.xcodeproj" \
    -target "$APP_NAME" \
    -configuration Release \
    -derivedDataPath "$DERIVED_DATA_DIR" \
    -archivePath "$ARCHIVE_PATH" \
    archive \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Build successful!${NC}"

# Find the built app
BUILT_APP_PATH="$ARCHIVE_PATH/Products/Applications/$APP_NAME.app"

if [ ! -d "$BUILT_APP_PATH" ]; then
    echo -e "${RED}Error: Built app not found at $BUILT_APP_PATH${NC}"
    exit 1
fi

echo -e "${BLUE}Built app: $BUILT_APP_PATH${NC}"

# Create DMG
echo -e "${YELLOW}Creating DMG...${NC}"

# Create a temporary directory for DMG contents
DMG_TEMP_DIR="$BUILD_DIR/dmg_temp"
mkdir -p "$DMG_TEMP_DIR"

# Copy the app
cp -R "$BUILT_APP_PATH" "$DMG_TEMP_DIR/"

# Create Applications symlink
ln -s /Applications "$DMG_TEMP_DIR/Applications"

# Create the DMG
hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$DMG_TEMP_DIR" \
    -ov \
    -format UDZO \
    "$BUILD_DIR/$DMG_NAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}DMG creation failed!${NC}"
    exit 1
fi

echo -e "${GREEN}DMG created successfully!${NC}"

# Also create a PKG installer option
echo -e "${YELLOW}Creating PKG installer...${NC}"

pkgbuild \
    --component "$BUILT_APP_PATH" \
    --install-location /Applications \
    --identifier "$BUNDLE_ID" \
    --version "$VERSION" \
    "$BUILD_DIR/OpenClaw-Installer-$VERSION.pkg"

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}PKG creation failed (non-critical)${NC}"
else
    echo -e "${GREEN}PKG created successfully!${NC}"
fi

# Output summary
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Build Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Output files:${NC}"
echo -e "  DMG: ${YELLOW}$BUILD_DIR/$DMG_NAME${NC}"
echo -e "  PKG: ${YELLOW}$BUILD_DIR/OpenClaw-Installer-$VERSION.pkg${NC}"
echo -e "  App: ${YELLOW}$BUILT_APP_PATH${NC}"
echo ""
echo -e "${BLUE}To install:${NC}"
echo -e "  1. Open ${YELLOW}$DMG_NAME${NC}"
echo -e "  2. Drag ${YELLOW}OpenClawInstaller.app${NC} to Applications"
echo -e "  3. Launch from Applications folder"
echo ""

# File sizes
echo -e "${BLUE}File sizes:${NC}"
ls -lh "$BUILD_DIR"/*.dmg "$BUILD_DIR"/*.pkg 2>/dev/null || true
