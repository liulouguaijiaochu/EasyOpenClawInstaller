#!/bin/bash
set -e

APP_NAME="OpenClawInstaller"
BUNDLE_ID="com.openclaw.installer"
VERSION="1.0.0"
BUILD_DIR="build"
DERIVED_DATA_DIR="$BUILD_DIR/DerivedData"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
DMG_NAME="OpenClaw-Installer-$VERSION.dmg"
VOLUME_NAME="OpenClaw Installer"

echo "========================================"
echo "  OpenClaw Installer Build Script"
echo "========================================"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "Building OpenClaw Installer..."
xcodebuild \
    -project "$APP_NAME.xcodeproj" \
    -scheme "$APP_NAME" \
    -configuration Release \
    -derivedDataPath "$DERIVED_DATA_DIR" \
    -archivePath "$ARCHIVE_PATH" \
    archive \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

echo "Build successful!"

BUILT_APP_PATH="$ARCHIVE_PATH/Products/Applications/$APP_NAME.app"
echo "Built app: $BUILT_APP_PATH"

echo "Creating DMG..."
DMG_TEMP_DIR="$BUILD_DIR/dmg_temp"
mkdir -p "$DMG_TEMP_DIR"
cp -R "$BUILT_APP_PATH" "$DMG_TEMP_DIR/"
ln -s /Applications "$DMG_TEMP_DIR/Applications"
hdiutil create -volname "$VOLUME_NAME" -srcfolder "$DMG_TEMP_DIR" -ov -format UDZO "$BUILD_DIR/$DMG_NAME"

echo "Creating PKG..."
pkgbuild --component "$BUILT_APP_PATH" --install-location /Applications --identifier "$BUNDLE_ID" --version "$VERSION" "$BUILD_DIR/OpenClaw-Installer-$VERSION.pkg" || true

echo "========================================"
echo "  Build Complete!"
echo "========================================"
ls -lh "$BUILD_DIR"/*.dmg "$BUILD_DIR"/*.pkg 2>/dev/null || true
