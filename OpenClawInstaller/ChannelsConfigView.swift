//
//  ChannelsConfigView.swift
//  OpenClawInstaller
//
//  Channel integration configuration (Telegram, Discord, Slack, etc.)
//

import SwiftUI

struct ChannelsConfigView: View {
    @ObservedObject var viewModel: InstallerViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "message.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Channel Integration")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Configure messaging channels for OpenClaw. These are optional - you can always add them later. OpenClaw supports WhatsApp, Telegram, Slack, Discord, and many more.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                
                // Info note
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                    
                    Text("Channel configuration is optional. You can use OpenClaw via the web interface or add channels later.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
                
                // Telegram
                ChannelCard(
                    title: "Telegram",
                    icon: "paperplane.fill",
                    color: .blue,
                    isEnabled: $viewModel.configuration.channels.telegramEnabled
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        SecureField("Bot Token (123456:ABC...)", text: $viewModel.configuration.channels.telegramBotToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Get a Bot Token from @BotFather", destination: URL(string: "https://t.me/botfather")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // Discord
                ChannelCard(
                    title: "Discord",
                    icon: "bubble.left.fill",
                    color: .purple,
                    isEnabled: $viewModel.configuration.channels.discordEnabled
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        SecureField("Bot Token", text: $viewModel.configuration.channels.discordBotToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Create a Discord Bot", destination: URL(string: "https://discord.com/developers/applications")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // Slack
                ChannelCard(
                    title: "Slack",
                    icon: "slack",
                    color: .green,
                    isEnabled: $viewModel.configuration.channels.slackEnabled
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        SecureField("Bot Token (xoxb-...)", text: $viewModel.configuration.channels.slackBotToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        SecureField("App Token (xapp-..., optional)", text: $viewModel.configuration.channels.slackAppToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Create a Slack App", destination: URL(string: "https://api.slack.com/apps")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // Mattermost
                ChannelCard(
                    title: "Mattermost",
                    icon: "person.2.fill",
                    color: .cyan,
                    isEnabled: $viewModel.configuration.channels.mattermostEnabled
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        SecureField("Bot Token", text: $viewModel.configuration.channels.mattermostBotToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        TextField("Server URL (https://chat.example.com)", text: $viewModel.configuration.channels.mattermostURL)
                            .textFieldStyle(InstallerTextFieldStyle())
                    }
                }
                
                // Zalo
                ChannelCard(
                    title: "Zalo",
                    icon: "z.circle.fill",
                    color: .blue,
                    isEnabled: $viewModel.configuration.channels.zaloEnabled
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        SecureField("Bot Token", text: $viewModel.configuration.channels.zaloBotToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Zalo Developer Portal", destination: URL(string: "https://developers.zalo.me")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // Twitch
                ChannelCard(
                    title: "Twitch",
                    icon: "play.rectangle.fill",
                    color: .purple,
                    isEnabled: $viewModel.configuration.channels.twitchEnabled
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        SecureField("Access Token (oauth:...)", text: $viewModel.configuration.channels.twitchAccessToken)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Twitch Token Generator", destination: URL(string: "https://twitchtokengenerator.com")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // More channels info
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("More Channels Available")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text("OpenClaw also supports: WhatsApp, Signal, iMessage (BlueBubbles), Google Chat, Microsoft Teams, Matrix, Feishu, LINE, Nextcloud Talk, Nostr, Synology Chat, Tlon, IRC, WebChat, and more.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                    
                    Link("View full channel documentation", destination: URL(string: "https://docs.openclaw.ai/channels")!)
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                
                // Security notice
                HStack(spacing: 10) {
                    Image(systemName: "shield.lefthalf.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Security Note")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text("By default, OpenClaw uses DM pairing mode for security. Unknown senders receive a pairing code that must be approved before messages are processed.")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                )
            }
            .padding(.vertical, 10)
        }
    }
}

struct ChannelCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var isEnabled: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Toggle("", isOn: $isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .labelsHidden()
            }
            
            if isEnabled {
                content
                    .padding(.top, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isEnabled ? color.opacity(0.4) : Color.white.opacity(0.08), lineWidth: isEnabled ? 2 : 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

#Preview {
    ChannelsConfigView(viewModel: InstallerViewModel())
        .background(Color.black)
}
