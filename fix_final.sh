#!/bin/bash
# EasyOpenClawInstaller 最终修复脚本 - 使用 -target 替代 -scheme

set -e

echo "========================================"
echo "  EasyOpenClawInstaller 最终修复"
echo "========================================"
echo ""

# 检查是否在仓库目录
if [ ! -f "build.sh" ]; then
    echo "错误: 请在 EasyOpenClawInstaller 仓库根目录运行此脚本"
    exit 1
fi

echo "Step 1: 更新 build.sh (使用 -target 而不是 -scheme)..."

cat > build.sh << 'BUILDEEOF'
#!/bin/bash
set -e

APP_NAME="OpenClawInstaller"
BUNDLE_ID="com.openclaw.installer"
VERSION="1.0.0"
BUILD_DIR="build"
DMG_NAME="OpenClaw-Installer-$VERSION.dmg"
VOLUME_NAME="OpenClaw Installer"

echo "========================================"
echo "  OpenClaw Installer Build Script"
echo "========================================"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "Building OpenClaw Installer..."

# 使用 -target 而不是 -scheme，并指定 SYMROOT 来设置构建输出目录
xcodebuild \
    -project "$APP_NAME.xcodeproj" \
    -target "$APP_NAME" \
    -configuration Release \
    -sdk macosx \
    SYMROOT="$BUILD_DIR" \
    build \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

echo "Build successful!"

# 查找构建产物
BUILT_APP_PATH="$BUILD_DIR/Release/$APP_NAME.app"

if [ ! -d "$BUILT_APP_PATH" ]; then
    echo "Error: Built app not found at $BUILT_APP_PATH"
    echo "Searching for built app..."
    find "$BUILD_DIR" -name "$APP_NAME.app" -type d 2>/dev/null || true
    exit 1
fi

echo "Built app: $BUILT_APP_PATH"

echo "Creating DMG..."
DMG_TEMP_DIR="$BUILD_DIR/dmg_temp"
mkdir -p "$DMG_TEMP_DIR"
cp -R "$BUILT_APP_PATH" "$DMG_TEMP_DIR/"
ln -s /Applications "$DMG_TEMP_DIR/Applications"
hdiutil create -volname "$VOLUME_NAME" -srcfolder "$DMG_TEMP_DIR" -ov -format UDZO "$BUILD_DIR/$DMG_NAME"

echo "Creating PKG..."
pkgbuild \
    --component "$BUILT_APP_PATH" \
    --install-location /Applications \
    --identifier "$BUNDLE_ID" \
    --version "$VERSION" \
    "$BUILD_DIR/OpenClaw-Installer-$VERSION.pkg" || true

echo "========================================"
echo "  Build Complete!"
echo "========================================"
ls -lh "$BUILD_DIR"/*.dmg "$BUILD_DIR"/*.pkg 2>/dev/null || true
BUILDEEOF

chmod +x build.sh

echo "Step 2: 更新 GitHub Actions..."

mkdir -p .github/workflows

cat > .github/workflows/build.yml << 'YAMLEOF'
name: Build OpenClaw Installer

on:
  push:
    branches: [ main, master ]
    tags: [ 'v*' ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: macos-14
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: '15.4'
    
    - name: Show Xcode version
      run: |
        xcodebuild -version
        echo "--- Project Info ---"
        xcodebuild -list -project OpenClawInstaller.xcodeproj || true
    
    - name: Build OpenClaw Installer
      run: |
        chmod +x build.sh
        ./build.sh
    
    - name: Upload DMG artifact
      uses: actions/upload-artifact@v4
      with:
        name: OpenClaw-Installer-DMG
        path: build/OpenClaw-Installer-*.dmg
        if-no-files-found: error
    
    - name: Upload PKG artifact
      uses: actions/upload-artifact@v4
      with:
        name: OpenClaw-Installer-PKG
        path: build/OpenClaw-Installer-*.pkg
        if-no-files-found: warn
    
    - name: Upload App artifact
      uses: actions/upload-artifact@v4
      with:
        name: OpenClaw-Installer-App
        path: build/Release/OpenClawInstaller.app
        if-no-files-found: warn
    
    - name: Create Release
      if: startsWith(github.ref, 'refs/tags/')
      uses: softprops/action-gh-release@v1
      with:
        files: |
          build/OpenClaw-Installer-*.dmg
          build/OpenClaw-Installer-*.pkg
        draft: false
        prerelease: false
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
YAMLEOF

echo "Step 3: Git 提交..."
git add -A
git commit -m "Fix: Use xcodebuild -target instead of -scheme to fix build"

echo ""
echo "========================================"
echo "  修复完成！"
echo "========================================"
echo ""
echo "请运行: git push origin main"
echo ""
