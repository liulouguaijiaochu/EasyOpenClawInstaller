# OpenClaw Installer - Quick Start Guide

## For End Users

### Installing OpenClaw

1. **Download the Installer**
   - Download `OpenClaw-Installer-1.0.0.dmg`
   - Open the DMG file

2. **Install the App**
   - Drag `OpenClawInstaller.app` to your Applications folder
   - Or run the PKG installer for system-wide installation

3. **Run the Installer**
   - Open `OpenClawInstaller` from Applications
   - If you see a security warning, go to System Settings → Privacy & Security → Open Anyway

4. **Configure OpenClaw**
   - Follow the step-by-step wizard:
     1. **Welcome** - Introduction and requirements
     2. **Gateway Config** - Set authentication token (use "Generate" button)
     3. **Model Providers** - Add at least one AI API key (OpenAI, Anthropic, etc.)
     4. **Channels** - (Optional) Configure messaging platforms
     5. **Tools** - (Optional) Add search, voice capabilities
     6. **Install** - Start the installation

5. **Access OpenClaw**
   - Web UI: http://localhost:18789
   - CLI: `openclaw` command in Terminal

## For Developers

### Building from Source

```bash
# 1. Clone or download the project
cd OpenClawInstaller

# 2. Build the installer
make build

# 3. Find outputs in build/
ls build/*.dmg build/*.pkg
```

### Development Setup

```bash
# Open in Xcode
open OpenClawInstaller.xcodeproj

# Build and run
Cmd+R in Xcode
```

### Project Structure

```
OpenClawInstaller/
├── OpenClawInstaller/          # Source code
│   ├── *.swift                 # Swift source files
│   ├── Assets.xcassets/        # Icons and images
│   └── Info.plist              # App configuration
├── OpenClawInstaller.xcodeproj/# Xcode project
├── build.sh                    # Build script
├── Makefile                    # Build automation
└── README.md                   # Full documentation
```

## Configuration Reference

### Required Settings

| Setting | Description | Example |
|---------|-------------|---------|
| Gateway Token | Authentication token | `openssl rand -hex 32` |
| AI API Key | At least one provider | `sk-...` |

### Optional Settings

| Category | Options |
|----------|---------|
| Channels | Telegram, Discord, Slack, Mattermost, Zalo, Twitch |
| Search | Brave, Perplexity, Firecrawl |
| Voice | ElevenLabs, Deepgram |
| System | Daemon, Auto-start |

## Troubleshooting

### "App can't be opened"
```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine /Applications/OpenClawInstaller.app
```

### "Node.js is not installed"
```bash
# Install Node.js 22
brew install node@22
```

### "Installation failed"
- Check the installation log in the app
- Ensure internet connectivity
- Try running with administrator privileges

### "Gateway won't start"
```bash
# Check logs
cat ~/.openclaw/logs/gateway.error.log

# Verify configuration
openclaw doctor

# Manual start for debugging
openclaw gateway --verbose
```

## File Locations

| File | Location |
|------|----------|
| Config | `~/.openclaw/openclaw.json` |
| Environment | `~/.openclaw/.env` |
| Logs | `~/.openclaw/logs/` |
| LaunchAgent | `~/Library/LaunchAgents/com.openclaw.gateway.plist` |

## Useful Commands

```bash
# Check OpenClaw status
openclaw doctor

# View gateway logs
tail -f ~/.openclaw/logs/gateway.log

# Start gateway manually
openclaw gateway --verbose

# Stop gateway
launchctl unload ~/Library/LaunchAgents/com.openclaw.gateway.plist

# Start gateway
launchctl load ~/Library/LaunchAgents/com.openclaw.gateway.plist
```

## Support

- OpenClaw Docs: https://docs.openclaw.ai
- GitHub: https://github.com/openclaw/openclaw
- Issues: Create an issue in this repository

## License

MIT License - See LICENSE file
