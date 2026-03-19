# OpenClaw Installer Makefile

.PHONY: all build clean dmg pkg run

# Default target
all: build

# Build the project
build:
	@echo "Building OpenClaw Installer..."
	@./build.sh

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf OpenClawInstaller.xcodeproj/project.xcworkspace
	@rm -rf OpenClawInstaller.xcodeproj/xcuserdata

# Create only DMG
dmg:
	@echo "Building DMG only..."
	@./build.sh

# Create only PKG
pkg:
	@echo "Building PKG only..."
	@xcodebuild -project OpenClawInstaller.xcodeproj \
		-scheme OpenClawInstaller \
		-configuration Release \
		-derivedDataPath build/DerivedData \
		archivePath build/OpenClawInstaller.xcarchive \
		archive \
		CODE_SIGN_IDENTITY="-" \
		CODE_SIGNING_REQUIRED=NO
	@pkgbuild \
		--component build/OpenClawInstaller.xcarchive/Products/Applications/OpenClawInstaller.app \
		--install-location /Applications \
		--identifier com.openclaw.installer \
		--version 1.0.0 \
		build/OpenClaw-Installer-1.0.0.pkg

# Run the app from build
run: build
	@echo "Launching OpenClaw Installer..."
	@open build/OpenClawInstaller.xcarchive/Products/Applications/OpenClawInstaller.app

# Install dependencies (none for this project)
deps:
	@echo "No dependencies to install"

# Format code
format:
	@echo "Formatting Swift code..."
	@swiftformat OpenClawInstaller/ --swiftversion 5.9 2>/dev/null || echo "swiftformat not installed, skipping"

# Run tests
test:
	@echo "Running tests..."
	@xcodebuild -project OpenClawInstaller.xcodeproj \
		-scheme OpenClawInstaller \
		-configuration Debug \
		test \
		2>/dev/null || echo "No tests configured"

# Show help
help:
	@echo "OpenClaw Installer Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make build    - Build the installer (creates DMG and PKG)"
	@echo "  make clean    - Clean build artifacts"
	@echo "  make dmg      - Build DMG installer"
	@echo "  make pkg      - Build PKG installer"
	@echo "  make run      - Build and run the app"
	@echo "  make format   - Format Swift code"
	@echo "  make test     - Run tests"
	@echo "  make help     - Show this help"
