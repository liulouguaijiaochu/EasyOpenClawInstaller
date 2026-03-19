# OpenClaw Installer - Project Structure

## Overview

This is a native macOS installer application for OpenClaw, built with SwiftUI. It provides a graphical interface for configuring and installing OpenClaw on macOS.

## Directory Structure

```
OpenClawInstaller/
├── OpenClawInstaller.xcodeproj/          # Xcode project file
│   └── project.pbxproj                   # Project configuration
│
├── OpenClawInstaller/                    # Main source code
│   ├── OpenClawInstallerApp.swift        # App entry point & delegate
│   ├── ContentView.swift                 # Main navigation container
│   │
│   ├── ConfigurationModel.swift          # Data models for configuration
│   │   ├── GatewayConfiguration          # Auth tokens, paths
│   │   ├── ModelProviderConfiguration    # AI provider API keys
│   │   ├── ChannelConfiguration          # Messaging channels
│   │   ├── ToolsConfiguration            # Search, voice tools
│   │   └── OpenClawConfiguration         # Main config container
│   │
│   ├── InstallerViewModel.swift          # Business logic & state
│   │   ├── Installation flow control
│   │   ├── Validation logic
│   │   └── Navigation management
│   │
│   ├── InstallerService.swift            # Installation operations
│   │   ├── Directory creation
│   │   ├── File writing
│   │   ├── npm install
│   │   ├── Onboarding
│   │   └── Daemon installation
│   │
│   ├── WelcomeView.swift                 # Welcome screen
│   ├── GatewayConfigView.swift           # Gateway auth config
│   ├── ModelProviderView.swift           # AI provider config
│   ├── ChannelsConfigView.swift          # Channel integration
│   ├── ToolsConfigView.swift             # Tools & media config
│   ├── InstallationView.swift            # Progress & logs
│   └── CompletionView.swift              # Success screen
│
│   ├── Assets.xcassets/                  # App icons & images
│   │   └── AppIcon.appiconset/
│   │       └── Contents.json             # Icon specifications
│   │
│   ├── Preview Content/                  # SwiftUI previews
│   │   └── Preview Assets.xcassets/
│   │
│   ├── Info.plist                        # App metadata
│   └── OpenClawInstaller.entitlements    # Security permissions
│
├── build.sh                              # Build script (DMG/PKG)
├── generate_icons.sh                     # Icon generation script
├── Makefile                              # Build automation
├── README.md                             # User documentation
├── LICENSE                               # MIT License
└── .gitignore                            # Git ignore rules
```

## Architecture

### MVVM Pattern

The app follows the Model-View-ViewModel (MVVM) architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                         View Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ WelcomeView │  │ ContentView │  │ GatewayConfigView   │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ ModelProv...│  │ Channels... │  │ ToolsConfigView     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │ Installat...│  │ Completion..│                          │
│  └─────────────┘  └─────────────┘                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      ViewModel Layer                        │
│                   InstallerViewModel                        │
│  - State management                                         │
│  - Navigation control                                       │
│  - Validation logic                                         │
│  - Installation coordination                                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                          │
│                    InstallerService                         │
│  - File system operations                                   │
│  - Shell command execution                                  │
│  - npm install                                              │
│  - Daemon installation                                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Model Layer                           │
│                  OpenClawConfiguration                      │
│  - GatewayConfiguration                                     │
│  - ModelProviderConfiguration                               │
│  - ChannelConfiguration                                     │
│  - ToolsConfiguration                                       │
└─────────────────────────────────────────────────────────────┘
```

## Installation Flow

```
┌──────────┐     ┌──────────────┐     ┌─────────────────┐
│  Welcome │────▶│   Gateway    │────▶│ Model Providers │
│  Screen  │     │    Config    │     │   (Required)    │
└──────────┘     └──────────────┘     └─────────────────┘
                                             │
                                             ▼
┌──────────┐     ┌──────────────┐     ┌─────────────────┐
│ Complete │◀────│ Installation │◀────│     Tools       │
│  Screen  │     │   Progress   │     │   (Optional)    │
└──────────┘     └──────────────┘     └─────────────────┘
                                             ▲
                                             │
                                       ┌─────────────────┐
                                       │    Channels     │
                                       │   (Optional)    │
                                       └─────────────────┘
```

## Configuration Categories

### 1. Gateway Configuration
- **OPENCLAW_GATEWAY_TOKEN** - Secure authentication token
- **OPENCLAW_GATEWAY_PASSWORD** - Optional password auth
- **OPENCLAW_STATE_DIR** - State directory path
- **OPENCLAW_CONFIG_PATH** - Config file path
- **OPENCLAW_LOAD_SHELL_ENV** - Import shell environment

### 2. Model Providers (At least one required)
- **OpenAI** - OPENAI_API_KEY
- **Anthropic** - ANTHROPIC_API_KEY
- **Gemini** - GEMINI_API_KEY
- **OpenRouter** - OPENROUTER_API_KEY
- **Additional** - ZAI, AI Gateway, Minimax

### 3. Channels (Optional)
- **Telegram** - TELEGRAM_BOT_TOKEN
- **Discord** - DISCORD_BOT_TOKEN
- **Slack** - SLACK_BOT_TOKEN, SLACK_APP_TOKEN
- **Mattermost** - MATTERMOST_BOT_TOKEN, MATTERMOST_URL
- **Zalo** - ZALO_BOT_TOKEN
- **Twitch** - OPENCLAW_TWITCH_ACCESS_TOKEN

### 4. Tools & Media (Optional)
- **Brave Search** - BRAVE_API_KEY
- **Perplexity** - PERPLEXITY_API_KEY
- **Firecrawl** - FIRECRAWL_API_KEY
- **ElevenLabs** - ELEVENLABS_API_KEY
- **Deepgram** - DEEPGRAM_API_KEY

## Key Features

### Security
- Secure token generation using `openssl rand -hex 32`
- `.env` file created with 0600 permissions
- Password fields with show/hide toggle
- Sensitive data never logged

### User Experience
- Step-by-step guided configuration
- Real-time validation
- Progress tracking with detailed logs
- Animated transitions
- Dark theme UI

### System Integration
- LaunchAgent for auto-start
- Daemon installation option
- Shell environment import
- Log file management

## Build Outputs

| File | Description |
|------|-------------|
| `OpenClaw-Installer-1.0.0.dmg` | Drag-and-drop disk image |
| `OpenClaw-Installer-1.0.0.pkg` | Package installer |
| `OpenClawInstaller.app` | Standalone application |

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later (for building)
- Node.js 22 or later (runtime requirement)

## Development Commands

```bash
# Build everything
make build

# Build DMG only
make dmg

# Build PKG only
make pkg

# Clean build artifacts
make clean

# Run the app
make run

# Generate icons
./generate_icons.sh
```

## Customization

### Adding New Configuration Options

1. Add field to appropriate Configuration struct in `ConfigurationModel.swift`
2. Update `generateEnvFile()` method
3. Add UI controls in corresponding View
4. Update validation in `InstallerViewModel.swift`

### Adding New Installation Steps

1. Add case to `InstallationStep` enum
2. Create new View file
3. Add case to `mainContent` in `ContentView.swift`
4. Update navigation logic

## Testing

The app can be tested in Xcode using SwiftUI previews:

```swift
#Preview {
    GatewayConfigView(viewModel: InstallerViewModel())
        .background(Color.black)
}
```

## License

MIT License - See LICENSE file for details
