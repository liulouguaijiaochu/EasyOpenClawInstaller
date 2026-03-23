#!/bin/bash
# 完整的 EasyOpenClawInstaller 构建修复脚本

set -e

echo "========================================"
echo "  EasyOpenClawInstaller 构建修复"
echo "========================================"
echo ""

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查是否在仓库目录
if [ ! -f "build.sh" ]; then
    echo -e "${RED}错误: 请在 EasyOpenClawInstaller 仓库根目录运行此脚本${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: 创建 Scheme 文件...${NC}"

# 创建 scheme 目录
mkdir -p OpenClawInstaller.xcodeproj/xcshareddata/xcschemes

# 创建 scheme 文件
cat > OpenClawInstaller.xcodeproj/xcshareddata/xcschemes/OpenClawInstaller.xcscheme << 'EOF'
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
EOF

echo -e "${YELLOW}Step 2: 更新 build.sh...${NC}"

cat > build.sh << 'EOF'
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

# Build using scheme
echo -e "${YELLOW}Building OpenClaw Installer...${NC}"
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

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Build successful!${NC}"

# Find the built app
BUILT_APP_PATH="$ARCHIVE_PATH/Products/Applications/$APP_NAME.app"

if [ ! -d "$BUILT_APP_PATH" ]; then
    echo -e "${RED}Error: Built app not found at $BUILT_APP_PATH${NC}"
    echo -e "${YELLOW}Searching in $BUILD_DIR...${NC}"
    find "$BUILD_DIR" -name "*.app" -type d 2>/dev/null || true
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
EOF

chmod +x build.sh

echo -e "${YELLOW}Step 3: 更新 GitHub Actions...${NC}"

mkdir -p .github/workflows

cat > .github/workflows/build.yml << 'EOF'
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
        xcodebuild -showsdks
    
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
        path: build/OpenClawInstaller.xcarchive/Products/Applications/OpenClawInstaller.app
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
EOF

echo -e "${YELLOW}Step 4: Git 提交更改...${NC}"
git add -A
git commit -m "Fix: Add Xcode scheme and fix build configuration

- 添加 OpenClawInstaller.xcscheme 文件
- 更新 build.sh 使用 -scheme 参数
- 修复 archive 路径配置
- 更新 GitHub Actions 工作流"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  修复完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}请运行以下命令推送更改:${NC}"
echo -e "${YELLOW}  git push origin main${NC}"
echo ""
echo -e "${BLUE}推送后，GitHub Actions 将自动开始构建${NC}"
echo ""
