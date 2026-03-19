# OpenClaw Installer - Build Guide

## ⚠️ Important Notice

**Building macOS applications requires macOS and Xcode.** The DMG file can only be generated on a Mac or using GitHub Actions (free macOS runners).

## Build Options

### Option 1: GitHub Actions (Recommended - Free)

The easiest way to build the DMG is using GitHub Actions. The project includes a pre-configured workflow.

#### Steps:

1. **Push the code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/OpenClawInstaller.git
   git push -u origin main
   ```

2. **Trigger the build**
   - Go to your GitHub repository
   - Click "Actions" tab
   - Select "Build OpenClaw Installer"
   - Click "Run workflow"

3. **Download the artifacts**
   - After the build completes (about 5-10 minutes)
   - Download `OpenClaw-Installer-DMG` artifact
   - The DMG will be named `OpenClaw-Installer-1.0.0.dmg`

4. **Create a release** (optional)
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
   - GitHub Actions will automatically create a release with the DMG attached

### Option 2: Build on macOS (Local)

If you have access to a Mac:

#### Prerequisites:
- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Command Line Tools: `xcode-select --install`

#### Build Steps:

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/OpenClawInstaller.git
   cd OpenClawInstaller
   ```

2. **Build using the script**
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. **Find the output**
   ```bash
   ls -la build/*.dmg
   # Output: build/OpenClaw-Installer-1.0.0.dmg
   ```

#### Alternative: Build with Makefile

```bash
# Build everything (DMG + PKG)
make build

# Build only DMG
make dmg

# Build only PKG
make pkg

# Clean and rebuild
make clean && make build
```

#### Alternative: Build in Xcode

1. Open `OpenClawInstaller.xcodeproj` in Xcode
2. Select Product → Archive
3. Once archived, click "Distribute App"
4. Select "Copy App" and save to a folder
5. Use the `build.sh` script to create the DMG from the built app

### Option 3: Using create-dmg Tool

For more control over the DMG appearance:

```bash
# Install create-dmg
brew install create-dmg

# Build the app first
xcodebuild -project OpenClawInstaller.xcodeproj \
    -scheme OpenClawInstaller \
    -configuration Release \
    -derivedDataPath build/DerivedData

# Create DMG with custom styling
create-dmg \
    --volname "OpenClaw Installer" \
    --window-pos 200 120 \
    --window-size 600 400 \
    --icon-size 100 \
    --app-drop-link 450 185 \
    "OpenClaw-Installer-1.0.0.dmg" \
    "build/DerivedData/Build/Products/Release/OpenClawInstaller.app"
```

## Build Outputs

After successful build, you'll find:

| File | Location | Description |
|------|----------|-------------|
| DMG | `build/OpenClaw-Installer-1.0.0.dmg` | Drag-and-drop installer |
| PKG | `build/OpenClaw-Installer-1.0.0.pkg` | Package installer |
| App | `build/OpenClawInstaller.xcarchive/Products/Applications/OpenClawInstaller.app` | Standalone app |

## Troubleshooting

### "xcodebuild: command not found"
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Or download full Xcode from App Store
```

### "No signing certificate found"
```bash
# Build without code signing (for local testing)
./build.sh
# The script already sets CODE_SIGNING_REQUIRED=NO
```

### "hdiutil: create failed - Permission denied"
```bash
# Check disk space
df -h

# Try building in a different location
cd /tmp
git clone <repo-url>
cd OpenClawInstaller
./build.sh
```

### Build fails with linker errors
```bash
# Clean build and try again
rm -rf build/
rm -rf ~/Library/Developer/Xcode/DerivedData
./build.sh
```

## CI/CD Integration

### GitHub Actions (Already Configured)

The `.github/workflows/build.yml` file is pre-configured to:
- Build on every push to main/master
- Build on every tag starting with 'v'
- Upload artifacts for download
- Create releases automatically for tags

### Other CI Platforms

#### GitLab CI
```yaml
build:
  stage: build
  image: macos-14
  script:
    - chmod +x build.sh
    - ./build.sh
  artifacts:
    paths:
      - build/*.dmg
      - build/*.pkg
```

#### Azure Pipelines
```yaml
pool:
  vmImage: 'macOS-14'

steps:
- script: |
    chmod +x build.sh
    ./build.sh
  displayName: 'Build OpenClaw Installer'

- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: 'build'
    artifactName: 'installer'
```

#### CircleCI
```yaml
version: 2.1
jobs:
  build:
    macos:
      xcode: "15.0.0"
    steps:
      - checkout
      - run:
          name: Build
          command: |
            chmod +x build.sh
            ./build.sh
      - store_artifacts:
          path: build/*.dmg
```

## Notarization (For Distribution)

If you plan to distribute the app outside the Mac App Store, you should notarize it:

```bash
# Sign the app
 codesign --force --options runtime --sign "Developer ID Application: YOUR_NAME" \
     OpenClawInstaller.app

# Create DMG
./build.sh

# Notarize
echo "Notarizing..."
xcrun altool --notarize-app \
    --primary-bundle-id "com.openclaw.installer" \
    --username "your-apple-id@example.com" \
    --password "@keychain:AC_PASSWORD" \
    --file OpenClaw-Installer-1.0.0.dmg

# Staple the ticket
xcrun stapler staple OpenClaw-Installer-1.0.0.dmg
```

## Quick Start for Users

Once you have the DMG:

1. **Distribute the DMG**
   - Upload to GitHub Releases
   - Share via cloud storage
   - Host on your website

2. **User Installation**
   - Download `OpenClaw-Installer-1.0.0.dmg`
   - Open the DMG
   - Drag `OpenClawInstaller.app` to Applications
   - Launch from Applications

## Support

- GitHub Issues: Create an issue in the repository
- Documentation: See README.md for usage instructions
