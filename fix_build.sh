#!/bin/bash
# EasyOpenClawInstaller 构建修复脚本 - 使用 build 命令替代 archive

set -e

echo "========================================"
echo "  EasyOpenClawInstaller 构建修复"
echo "========================================"
echo ""

# 检查是否在仓库目录
if [ ! -f "build.sh" ]; then
    echo "错误: 请在 EasyOpenClawInstaller 仓库根目录运行此脚本"
    exit 1
fi

echo "Step 1: 更新 build.sh (使用 build 命令)..."

cat > build.sh << 'BUILDEOF'
#!/bin/bash

# OpenClaw Installer Build Script for macOS
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
xcodebuild \
    -project "$APP_NAME.xcodeproj" \
    -scheme "$APP_NAME" \
    -configuration Release \
    -destination "platform=macOS" \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    build \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    ENABLE_BITCODE=NO

echo "Build successful!"

BUILT_APP_PATH="$BUILD_DIR/DerivedData/Build/Products/Release/$APP_NAME.app"

if [ ! -d "$BUILT_APP_PATH" ]; then
    echo "Error: Built app not found at $BUILT_APP_PATH"
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
BUILDEOF

chmod +x build.sh

echo "Step 2: 更新 scheme 文件..."

mkdir -p OpenClawInstaller.xcodeproj/xcshareddata/xcschemes

cat > OpenClawInstaller.xcodeproj/xcshareddata/xcschemes/OpenClawInstaller.xcscheme << 'SCHEMEOF'
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "A1000000"
               BuildableName = "OpenClawInstaller.app"
               BlueprintName = "OpenClawInstaller"
               ReferencedContainer = "container:OpenClawInstaller.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "A1000000"
            BuildableName = "OpenClawInstaller.app"
            BlueprintName = "OpenClawInstaller"
            ReferencedContainer = "container:OpenClawInstaller.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "A1000000"
            BuildableName = "OpenClawInstaller.app"
            BlueprintName = "OpenClawInstaller"
            ReferencedContainer = "container:OpenClawInstaller.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
SCHEMEOF

echo "Step 3: 更新 GitHub Actions..."

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
        xcodebuild -list -project OpenClawInstaller.xcodeproj
    
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
        path: build/DerivedData/Build/Products/Release/OpenClawInstaller.app
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

echo "Step 4: Git 提交..."
git add -A
git commit -m "Fix: Use xcodebuild build instead of archive to fix exit code 74"

echo ""
echo "========================================"
echo "  修复完成！"
echo "========================================"
echo ""
echo "请运行: git push origin main"
echo ""
