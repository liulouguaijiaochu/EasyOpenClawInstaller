//
//  ConfigurationModel.swift
//  OpenClawInstaller
//
//  Configuration data model for OpenClaw installation
//

import Foundation

// MARK: - Installation Step
enum InstallationStep: Int, CaseIterable {
    case welcome = 0
    case gatewayConfig = 1
    case modelProvider = 2
    case channels = 3
    case tools = 4
    case installation = 5
    case completion = 6
    
    var title: String {
        switch self {
        case .welcome: return "Welcome"
        case .gatewayConfig: return "Gateway Configuration"
        case .modelProvider: return "AI Model Providers"
        case .channels: return "Channel Integration"
        case .tools: return "Tools & Media"
        case .installation: return "Installation"
        case .completion: return "Complete"
        }
    }
    
    var icon: String {
        switch self {
        case .welcome: return "hand.wave.fill"
        case .gatewayConfig: return "network.badge.shield.half.filled"
        case .modelProvider: return "brain.head.profile"
        case .channels: return "message.circle.fill"
        case .tools: return "wrench.and.screwdriver.fill"
        case .installation: return "arrow.down.circle.fill"
        case .completion: return "checkmark.circle.fill"
        }
    }
}

// MARK: - Gateway Configuration
struct GatewayConfiguration: Codable {
    var token: String = ""
    var password: String = ""
    var stateDir: String = "~/.openclaw"
    var configPath: String = "~/.openclaw/openclaw.json"
    var loadShellEnv: Bool = true
    var shellEnvTimeout: Int = 15000
    
    var isValid: Bool {
        !token.isEmpty || !password.isEmpty
    }
}

// MARK: - Model Provider Configuration
struct ModelProviderConfiguration: Codable {
    // OpenAI
    var openAIEnabled: Bool = false
    var openAIKey: String = ""
    var openAIKeys: String = ""
    
    // Anthropic
    var anthropicEnabled: Bool = false
    var anthropicKey: String = ""
    var anthropicKeys: String = ""
    
    // Gemini
    var geminiEnabled: Bool = false
    var geminiKey: String = ""
    var geminiKeys: String = ""
    
    // OpenRouter
    var openRouterEnabled: Bool = false
    var openRouterKey: String = ""
    
    // Live Keys
    var liveOpenAIKey: String = ""
    var liveAnthropicKey: String = ""
    var liveGeminiKey: String = ""
    
    // Additional providers
    var zaiEnabled: Bool = false
    var zaiKey: String = ""
    var aiGatewayEnabled: Bool = false
    var aiGatewayKey: String = ""
    var minimaxEnabled: Bool = false
    var minimaxKey: String = ""
    
    var hasAtLeastOneProvider: Bool {
        (openAIEnabled && !openAIKey.isEmpty) ||
        (anthropicEnabled && !anthropicKey.isEmpty) ||
        (geminiEnabled && !geminiKey.isEmpty) ||
        (openRouterEnabled && !openRouterKey.isEmpty) ||
        (zaiEnabled && !zaiKey.isEmpty) ||
        (aiGatewayEnabled && !aiGatewayKey.isEmpty) ||
        (minimaxEnabled && !minimaxKey.isEmpty)
    }
}

// MARK: - Channel Configuration
struct ChannelConfiguration: Codable {
    // Telegram
    var telegramEnabled: Bool = false
    var telegramBotToken: String = ""
    
    // Discord
    var discordEnabled: Bool = false
    var discordBotToken: String = ""
    
    // Slack
    var slackEnabled: Bool = false
    var slackBotToken: String = ""
    var slackAppToken: String = ""
    
    // Mattermost
    var mattermostEnabled: Bool = false
    var mattermostBotToken: String = ""
    var mattermostURL: String = ""
    
    // Zalo
    var zaloEnabled: Bool = false
    var zaloBotToken: String = ""
    
    // Twitch
    var twitchEnabled: Bool = false
    var twitchAccessToken: String = ""
    
    var anyChannelEnabled: Bool {
        telegramEnabled || discordEnabled || slackEnabled || 
        mattermostEnabled || zaloEnabled || twitchEnabled
    }
}

// MARK: - Tools Configuration
struct ToolsConfiguration: Codable {
    // Search
    var braveEnabled: Bool = false
    var braveAPIKey: String = ""
    var perplexityEnabled: Bool = false
    var perplexityAPIKey: String = ""
    var firecrawlEnabled: Bool = false
    var firecrawlAPIKey: String = ""
    
    // Voice
    var elevenLabsEnabled: Bool = false
    var elevenLabsAPIKey: String = ""
    var deepgramEnabled: Bool = false
    var deepgramAPIKey: String = ""
    
    // Install daemon
    var installDaemon: Bool = true
    
    // Auto-start
    var autoStart: Bool = true
}

// MARK: - Complete Configuration
class OpenClawConfiguration: ObservableObject, Codable {
    @Published var gateway = GatewayConfiguration()
    @Published var modelProvider = ModelProviderConfiguration()
    @Published var channels = ChannelConfiguration()
    @Published var tools = ToolsConfiguration()
    
    enum CodingKeys: String, CodingKey {
        case gateway, modelProvider, channels, tools
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gateway, forKey: .gateway)
        try container.encode(modelProvider, forKey: .modelProvider)
        try container.encode(channels, forKey: .channels)
        try container.encode(tools, forKey: .tools)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gateway = try container.decode(GatewayConfiguration.self, forKey: .gateway)
        modelProvider = try container.decode(ModelProviderConfiguration.self, forKey: .modelProvider)
        channels = try container.decode(ChannelConfiguration.self, forKey: .channels)
        tools = try container.decode(ToolsConfiguration.self, forKey: .tools)
    }
    
    init() {}
    
    // Generate .env file content
    func generateEnvFile() -> String {
        var content = """
        # OpenClaw Configuration
        # Generated by OpenClaw Installer
        # Date: \(Date())
        
        # =============================================================================
        # Gateway Authentication
        # =============================================================================
        
        """
        
        // Gateway settings
        if !gateway.token.isEmpty {
            content += "OPENCLAW_GATEWAY_TOKEN=\(gateway.token)\n"
        }
        if !gateway.password.isEmpty {
            content += "OPENCLAW_GATEWAY_PASSWORD=\(gateway.password)\n"
        }
        if !gateway.stateDir.isEmpty {
            content += "OPENCLAW_STATE_DIR=\(gateway.stateDir)\n"
        }
        if !gateway.configPath.isEmpty {
            content += "OPENCLAW_CONFIG_PATH=\(gateway.configPath)\n"
        }
        content += "OPENCLAW_LOAD_SHELL_ENV=\(gateway.loadShellEnv ? "1" : "0")\n"
        content += "OPENCLAW_SHELL_ENV_TIMEOUT_MS=\(gateway.shellEnvTimeout)\n"
        
        // Model Providers
        content += "\n# =============================================================================\n"
        content += "# Model Provider API Keys\n"
        content += "# =============================================================================\n\n"
        
        if modelProvider.openAIEnabled && !modelProvider.openAIKey.isEmpty {
            content += "OPENAI_API_KEY=\(modelProvider.openAIKey)\n"
        }
        if !modelProvider.openAIKeys.isEmpty {
            content += "OPENAI_API_KEYS=\(modelProvider.openAIKeys)\n"
        }
        
        if modelProvider.anthropicEnabled && !modelProvider.anthropicKey.isEmpty {
            content += "ANTHROPIC_API_KEY=\(modelProvider.anthropicKey)\n"
        }
        if !modelProvider.anthropicKeys.isEmpty {
            content += "ANTHROPIC_API_KEYS=\(modelProvider.anthropicKeys)\n"
        }
        
        if modelProvider.geminiEnabled && !modelProvider.geminiKey.isEmpty {
            content += "GEMINI_API_KEY=\(modelProvider.geminiKey)\n"
        }
        if !modelProvider.geminiKeys.isEmpty {
            content += "GEMINI_API_KEYS=\(modelProvider.geminiKeys)\n"
        }
        
        if modelProvider.openRouterEnabled && !modelProvider.openRouterKey.isEmpty {
            content += "OPENROUTER_API_KEY=\(modelProvider.openRouterKey)\n"
        }
        
        if !modelProvider.liveOpenAIKey.isEmpty {
            content += "OPENCLAW_LIVE_OPENAI_KEY=\(modelProvider.liveOpenAIKey)\n"
        }
        if !modelProvider.liveAnthropicKey.isEmpty {
            content += "OPENCLAW_LIVE_ANTHROPIC_KEY=\(modelProvider.liveAnthropicKey)\n"
        }
        if !modelProvider.liveGeminiKey.isEmpty {
            content += "OPENCLAW_LIVE_GEMINI_KEY=\(modelProvider.liveGeminiKey)\n"
        }
        
        if modelProvider.zaiEnabled && !modelProvider.zaiKey.isEmpty {
            content += "ZAI_API_KEY=\(modelProvider.zaiKey)\n"
        }
        if modelProvider.aiGatewayEnabled && !modelProvider.aiGatewayKey.isEmpty {
            content += "AI_GATEWAY_API_KEY=\(modelProvider.aiGatewayKey)\n"
        }
        if modelProvider.minimaxEnabled && !modelProvider.minimaxKey.isEmpty {
            content += "MINIMAX_API_KEY=\(modelProvider.minimaxKey)\n"
        }
        
        // Channels
        content += "\n# =============================================================================\n"
        content += "# Channel Configuration\n"
        content += "# =============================================================================\n\n"
        
        if channels.telegramEnabled && !channels.telegramBotToken.isEmpty {
            content += "TELEGRAM_BOT_TOKEN=\(channels.telegramBotToken)\n"
        }
        if channels.discordEnabled && !channels.discordBotToken.isEmpty {
            content += "DISCORD_BOT_TOKEN=\(channels.discordBotToken)\n"
        }
        if channels.slackEnabled {
            if !channels.slackBotToken.isEmpty {
                content += "SLACK_BOT_TOKEN=\(channels.slackBotToken)\n"
            }
            if !channels.slackAppToken.isEmpty {
                content += "SLACK_APP_TOKEN=\(channels.slackAppToken)\n"
            }
        }
        if channels.mattermostEnabled {
            if !channels.mattermostBotToken.isEmpty {
                content += "MATTERMOST_BOT_TOKEN=\(channels.mattermostBotToken)\n"
            }
            if !channels.mattermostURL.isEmpty {
                content += "MATTERMOST_URL=\(channels.mattermostURL)\n"
            }
        }
        if channels.zaloEnabled && !channels.zaloBotToken.isEmpty {
            content += "ZALO_BOT_TOKEN=\(channels.zaloBotToken)\n"
        }
        if channels.twitchEnabled && !channels.twitchAccessToken.isEmpty {
            content += "OPENCLAW_TWITCH_ACCESS_TOKEN=\(channels.twitchAccessToken)\n"
        }
        
        // Tools
        content += "\n# =============================================================================\n"
        content += "# Tools & Media Configuration\n"
        content += "# =============================================================================\n\n"
        
        if tools.braveEnabled && !tools.braveAPIKey.isEmpty {
            content += "BRAVE_API_KEY=\(tools.braveAPIKey)\n"
        }
        if tools.perplexityEnabled && !tools.perplexityAPIKey.isEmpty {
            content += "PERPLEXITY_API_KEY=\(tools.perplexityAPIKey)\n"
        }
        if tools.firecrawlEnabled && !tools.firecrawlAPIKey.isEmpty {
            content += "FIRECRAWL_API_KEY=\(tools.firecrawlAPIKey)\n"
        }
        if tools.elevenLabsEnabled && !tools.elevenLabsAPIKey.isEmpty {
            content += "ELEVENLABS_API_KEY=\(tools.elevenLabsAPIKey)\n"
            content += "XI_API_KEY=\(tools.elevenLabsAPIKey)\n"
        }
        if tools.deepgramEnabled && !tools.deepgramAPIKey.isEmpty {
            content += "DEEPGRAM_API_KEY=\(tools.deepgramAPIKey)\n"
        }
        
        return content
    }
}
