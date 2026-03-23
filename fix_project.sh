#!/bin/bash
# EasyOpenClawInstaller 完整修复脚本
# 修复 project.pbxproj 中的 ID 冲突问题

set -e

echo "========================================"
echo "  EasyOpenClawInstaller 项目修复"
echo "========================================"
echo ""

# 检查是否在仓库目录
if [ ! -f "build.sh" ]; then
    echo "错误: 请在 EasyOpenClawInstaller 仓库根目录运行此脚本"
    exit 1
fi

echo "Step 1: 修复 project.pbxproj (修复 ID 冲突)..."

cat > OpenClawInstaller.xcodeproj/project.pbxproj << 'PBXEOF'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		A1000001 /* OpenClawInstallerApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000000 /* OpenClawInstallerApp.swift */; };
		A1000003 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000002 /* ContentView.swift */; };
		A1000005 /* WelcomeView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000004 /* WelcomeView.swift */; };
		A1000007 /* GatewayConfigView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000006 /* GatewayConfigView.swift */; };
		A1000009 /* ModelProviderView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000008 /* ModelProviderView.swift */; };
		A100000B /* ChannelsConfigView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A100000A /* ChannelsConfigView.swift */; };
		A100000D /* ToolsConfigView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A100000C /* ToolsConfigView.swift */; };
		A100000F /* InstallationView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A100000E /* InstallationView.swift */; };
		A1000011 /* CompletionView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000010 /* CompletionView.swift */; };
		A1000013 /* InstallerViewModel.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000012 /* InstallerViewModel.swift */; };
		A1000015 /* ConfigurationModel.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000014 /* ConfigurationModel.swift */; };
		A1000017 /* InstallerService.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1000016 /* InstallerService.swift */; };
		A1000019 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A1000018 /* Assets.xcassets */; };
		A100001C /* Preview Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A100001B /* Preview Assets.xcassets */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		A0FFFFFF /* OpenClawInstaller.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = OpenClawInstaller.app; sourceTree = BUILT_PRODUCTS_DIR; };
		A1000000 /* OpenClawInstallerApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = OpenClawInstallerApp.swift; sourceTree = "<group>"; };
		A1000002 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		A1000004 /* WelcomeView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = WelcomeView.swift; sourceTree = "<group>"; };
		A1000006 /* GatewayConfigView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GatewayConfigView.swift; sourceTree = "<group>"; };
		A1000008 /* ModelProviderView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ModelProviderView.swift; sourceTree = "<group>"; };
		A100000A /* ChannelsConfigView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ChannelsConfigView.swift; sourceTree = "<group>"; };
		A100000C /* ToolsConfigView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ToolsConfigView.swift; sourceTree = "<group>"; };
		A100000E /* InstallationView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = InstallationView.swift; sourceTree = "<group>"; };
		A1000010 /* CompletionView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CompletionView.swift; sourceTree = "<group>"; };
		A1000012 /* InstallerViewModel.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = InstallerViewModel.swift; sourceTree = "<group>"; };
		A1000014 /* ConfigurationModel.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ConfigurationModel.swift; sourceTree = "<group>"; };
		A1000016 /* InstallerService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = InstallerService.swift; sourceTree = "<group>"; };
		A1000018 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		A100001B /* Preview Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = "Preview Assets.xcassets"; sourceTree = "<group>"; };
		A100001D /* OpenClawInstaller.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = OpenClawInstaller.entitlements; sourceTree = "<group>"; };
		A100001E /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		A0FFFFFC /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		A0FFFFF6 = {
			isa = PBXGroup;
			children = (
				A0FFFFFE /* OpenClawInstaller */,
				A0FFFFFF /* Products */,
			);
			sourceTree = "<group>";
		};
		A0FFFFFF /* Products */ = {
			isa = PBXGroup;
			children = (
				A0FFFFFF /* OpenClawInstaller.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		A0FFFFFE /* OpenClawInstaller */ = {
			isa = PBXGroup;
			children = (
				A1000000 /* OpenClawInstallerApp.swift */,
				A1000002 /* ContentView.swift */,
				A1000004 /* WelcomeView.swift */,
				A1000006 /* GatewayConfigView.swift */,
				A1000008 /* ModelProviderView.swift */,
				A100000A /* ChannelsConfigView.swift */,
				A100000C /* ToolsConfigView.swift */,
				A100000E /* InstallationView.swift */,
				A1000010 /* CompletionView.swift */,
				A1000012 /* InstallerViewModel.swift */,
				A1000014 /* ConfigurationModel.swift */,
				A1000016 /* InstallerService.swift */,
				A1000018 /* Assets.xcassets */,
				A100001A /* Preview Content */,
				A100001D /* OpenClawInstaller.entitlements */,
				A100001E /* Info.plist */,
			);
			path = OpenClawInstaller;
			sourceTree = "<group>";
		};
		A100001A /* Preview Content */ = {
			isa = PBXGroup;
			children = (
				A100001B /* Preview Assets.xcassets */,
			);
			path = "Preview Content";
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		A2000000 /* OpenClawInstaller */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = A2000020 /* Build configuration list for PBXNativeTarget "OpenClawInstaller" */;
			buildPhases = (
				A0FFFFFB /* Sources */,
				A0FFFFFC /* Frameworks */,
				A0FFFFFD /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = OpenClawInstaller;
			productName = OpenClawInstaller;
			productReference = A0FFFFFF /* OpenClawInstaller.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		A0FFFFF7 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					A2000000 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = A0FFFFFA /* Build configuration list for PBXProject "OpenClawInstaller" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = A0FFFFF6;
			productRefGroup = A0FFFFFF /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				A2000000 /* OpenClawInstaller */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		A0FFFFFD /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A100001C /* Preview Assets.xcassets in Resources */,
				A1000019 /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		A0FFFFFB /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A1000001 /* OpenClawInstallerApp.swift in Sources */,
				A1000003 /* ContentView.swift in Sources */,
				A1000005 /* WelcomeView.swift in Sources */,
				A1000007 /* GatewayConfigView.swift in Sources */,
				A1000009 /* ModelProviderView.swift in Sources */,
				A100000B /* ChannelsConfigView.swift in Sources */,
				A100000D /* ToolsConfigView.swift in Sources */,
				A100000F /* InstallationView.swift in Sources */,
				A1000011 /* CompletionView.swift in Sources */,
				A1000013 /* InstallerViewModel.swift in Sources */,
				A1000015 /* ConfigurationModel.swift in Sources */,
				A1000017 /* InstallerService.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		A100001F /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 14.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = macosx;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		A1000021 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 14.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = macosx;
				SWIFT_COMPILATION_MODE = wholemodule;
			};
			name = Release;
		};
		A2000022 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = OpenClawInstaller/OpenClawInstaller.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "\"OpenClawInstaller/Preview Content\"";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = OpenClawInstaller/Info.plist;
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.utilities";
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.openclaw.installer;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		A2000023 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = OpenClawInstaller/OpenClawInstaller.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "\"OpenClawInstaller/Preview Content\"";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = OpenClawInstaller/Info.plist;
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.utilities";
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.openclaw.installer;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		A0FFFFFA /* Build configuration list for PBXProject "OpenClawInstaller" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A100001F /* Debug */,
				A1000021 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		A2000020 /* Build configuration list for PBXNativeTarget "OpenClawInstaller" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A2000022 /* Debug */,
				A2000023 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = A0FFFFF7 /* Project object */;
}
PBXEOF

echo "Step 2: 更新 scheme 文件..."

mkdir -p OpenClawInstaller.xcodeproj/xcshareddata/xcschemes

cat > OpenClawInstaller.xcodeproj/xcshareddata/xcschemes/OpenClawInstaller.xcscheme << 'SCHEMEEOF'
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
               BlueprintIdentifier = "A2000000"
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
            BlueprintIdentifier = "A2000000"
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
            BlueprintIdentifier = "A2000000"
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
SCHEMEEOF

echo "Step 3: 更新 build.sh..."

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
    echo "Error: Built app not found"
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

echo "Step 4: Git 提交..."
git add -A
git commit -m "Fix: Resolve ID conflicts in project.pbxproj

- Change target ID from A1000000 to A2000000 to avoid conflict with OpenClawInstallerApp.swift
- Update scheme BlueprintIdentifier to match new target ID
- Update build configurations to use new target ID"

echo ""
echo "========================================"
echo "  修复完成！"
echo "========================================"
echo ""
echo "请运行: git push origin main"
echo ""
