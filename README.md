# OpenClaw macOS Installer

A beautiful, native macOS graphical installer for [OpenClaw](https://github.com/openclaw/openclaw) - your personal AI assistant.

![OpenClaw Installer](screenshot.png)

## Features

- **Beautiful Native Interface** - Modern SwiftUI-based installer with dark theme
- **Step-by-Step Configuration** - Guided setup for all OpenClaw settings
- **Gateway Authentication** - Secure token generation and configuration
- **AI Model Providers** - Configure OpenAI, Anthropic, Gemini, and more
- **Channel Integration** - Set up Telegram, Discord, Slack, and other messaging platforms
- **Tools & Media** - Configure search, voice, and media services
- **System Integration** - Optional daemon installation and auto-start
- **Real-time Installation Log** - Monitor installation progress

## Requirements

- macOS 14.0 (Sonoma) or later
- Node.js 22 or later (will be checked during installation)
- Internet connection for downloading OpenClaw

## Installation

### Option 1: DMG (Recommended)

1. Download `OpenClaw-Installer-1.0.0.dmg`
2. Open the DMG file
3. Drag `OpenClawInstaller.app` to your Applications folder
4. Launch `OpenClawInstaller` from Applications

### Option 2: Build from Source

```bash
# Clone the repository
git clone <repository-url>
cd OpenClawInstaller

# Make build script executable
chmod +x build.sh

# Build the installer
./build.sh
```

The build script will create:
- `OpenClaw-Installer-1.0.0.dmg` - Drag-and-drop installer
- `OpenClaw-Installer-1.0.0.pkg` - Package installer

## Configuration Options

### 1. Gateway Configuration
- **Gateway Token** - Secure authentication token (auto-generate available)
- **Gateway Password** - Optional password-based authentication
- **State Directory** - Where OpenClaw stores configuration and logs
- **Shell Environment** - Import environment variables from shell profile

### 2. AI Model Providers (Required - at least one)
- **OpenAI** - GPT-4, GPT-3.5 models
- **Anthropic** - Claude models
- **Google Gemini** - Gemini Pro models
- **OpenRouter** - Unified API for multiple providers
- **Additional Providers** - ZAI, AI Gateway, Minimax

### 3. Channel Integration (Optional)
- **Telegram** - Bot-based messaging
- **Discord** - Server integration
- **Slack** - Workspace integration
- **Mattermost** - Self-hosted chat
- **Zalo** - Vietnamese messaging
- **Twitch** - Chat bot integration

### 4. Tools & Media (Optional)
- **Brave Search** - Privacy-focused web search
- **Perplexity** - AI-powered search
- **Firecrawl** - Web scraping
- **ElevenLabs** - Text-to-speech
- **Deepgram** - Speech-to-text

### 5. System Settings
- **Install System Daemon** - Run OpenClaw as a background service
- **Auto-start on Login** - Start automatically when you log in

## What Gets Installed

1. **OpenClaw npm package** - Latest version from npm registry
2. **Configuration files** - Stored in `~/.openclaw/`
3. **Environment file** - `~/.openclaw/.env` with your settings
4. **LaunchAgent plist** - `~/Library/LaunchAgents/com.openclaw.gateway.plist` (if daemon enabled)

## Post-Installation

After installation:

1. **Access the Web UI**: Open http://localhost:18789 in your browser
2. **CLI Access**: Use the `openclaw` command in Terminal
3. **Configuration**: Edit `~/.openclaw/openclaw.json` for advanced settings
4. **Logs**: Check `~/.openclaw/logs/` for gateway logs

## Troubleshooting

### "Node.js is not installed"
Install Node.js 22 or later:
```bash
# Using Homebrew
brew install node@22

# Or download from https://nodejs.org
```

### "Installation failed"
Check the installation log in the installer window for detailed error messages. Common issues:
- Network connectivity problems
- Permission issues (try running with sudo)
- npm registry access issues

### "Gateway won't start"
1. Check logs: `cat ~/.openclaw/logs/gateway.error.log`
2. Verify configuration: `openclaw doctor`
3. Try manual start: `openclaw gateway --verbose`

## Security Notes

- Gateway tokens are generated using cryptographically secure random generation
- The `.env` file is created with 0600 permissions (readable only by owner)
- DM pairing mode is enabled by default for security
- Unknown senders must be approved via pairing codes

## Project Structure

```
OpenClawInstaller/
├── OpenClawInstaller.xcodeproj/    # Xcode project
├── OpenClawInstaller/
│   ├── OpenClawInstallerApp.swift  # App entry point
│   ├── ContentView.swift           # Main navigation
│   ├── ConfigurationModel.swift    # Data models
│   ├── InstallerViewModel.swift    # Business logic
│   ├── InstallerService.swift      # Installation operations
│   ├── WelcomeView.swift           # Welcome screen
│   ├── GatewayConfigView.swift     # Gateway settings
│   ├── ModelProviderView.swift     # AI provider settings
│   ├── ChannelsConfigView.swift    # Channel settings
│   ├── ToolsConfigView.swift       # Tools settings
│   ├── InstallationView.swift      # Progress view
│   ├── CompletionView.swift        # Success screen
│   └── Assets.xcassets/            # App icons and assets
├── build.sh                        # Build script
└── README.md                       # This file
```

## Development

### Prerequisites
- Xcode 15.0 or later
- macOS 14.0 SDK

### Building
```bash
# Open in Xcode
open OpenClawInstaller.xcodeproj

# Or build from command line
xcodebuild -project OpenClawInstaller.xcodeproj -scheme OpenClawInstaller -configuration Release
```

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Support

- OpenClaw Documentation: https://docs.openclaw.ai
- OpenClaw GitHub: https://github.com/openclaw/openclaw
- Report Issues: Create an issue in this repository

---

**Note**: This is an unofficial installer for OpenClaw. OpenClaw is a trademark of its respective owners.
