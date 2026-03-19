//
//  ToolsConfigView.swift
//  OpenClawInstaller
//
//  Tools and media configuration (search, voice, etc.)
//

import SwiftUI

struct ToolsConfigView: View {
    @ObservedObject var viewModel: InstallerViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Tools & Media")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Configure additional tools and media services. These enhance OpenClaw's capabilities with search, voice, and more.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                
                // Search Tools Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Search & Browse", icon: "magnifyingglass.circle.fill")
                    
                    // Brave Search
                    ToolCard(
                        title: "Brave Search",
                        description: "Privacy-focused web search API",
                        icon: "safari.fill",
                        color: .orange,
                        isEnabled: $viewModel.configuration.tools.braveEnabled
                    ) {
                        SecureField("Brave API Key", text: $viewModel.configuration.tools.braveAPIKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Get Brave API Key", destination: URL(string: "https://brave.com/search/api")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                    
                    // Perplexity
                    ToolCard(
                        title: "Perplexity",
                        description: "AI-powered search and answers",
                        icon: "questionmark.circle.fill",
                        color: .teal,
                        isEnabled: $viewModel.configuration.tools.perplexityEnabled
                    ) {
                        SecureField("Perplexity API Key (pplx-...)", text: $viewModel.configuration.tools.perplexityAPIKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Get Perplexity API Key", destination: URL(string: "https://www.perplexity.ai/settings/api")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                    
                    // Firecrawl
                    ToolCard(
                        title: "Firecrawl",
                        description: "Web scraping and data extraction",
                        icon: "flame.fill",
                        color: .red,
                        isEnabled: $viewModel.configuration.tools.firecrawlEnabled
                    ) {
                        SecureField("Firecrawl API Key", text: $viewModel.configuration.tools.firecrawlAPIKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Get Firecrawl API Key", destination: URL(string: "https://firecrawl.dev")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // Voice & Media Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Voice & Media", icon: "waveform.circle.fill")
                    
                    // ElevenLabs
                    ToolCard(
                        title: "ElevenLabs",
                        description: "High-quality text-to-speech",
                        icon: "speaker.wave.2.fill",
                        color: .purple,
                        isEnabled: $viewModel.configuration.tools.elevenLabsEnabled
                    ) {
                        SecureField("ElevenLabs API Key", text: $viewModel.configuration.tools.elevenLabsAPIKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Get ElevenLabs API Key", destination: URL(string: "https://elevenlabs.io")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                    
                    // Deepgram
                    ToolCard(
                        title: "Deepgram",
                        description: "Speech-to-text transcription",
                        icon: "mic.fill",
                        color: .blue,
                        isEnabled: $viewModel.configuration.tools.deepgramEnabled
                    ) {
                        SecureField("Deepgram API Key", text: $viewModel.configuration.tools.deepgramAPIKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        Link("Get Deepgram API Key", destination: URL(string: "https://deepgram.com")!)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                // System Settings Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "System Settings", icon: "gearshape.2.fill")
                    
                    VStack(spacing: 12) {
                        Toggle(isOn: $viewModel.configuration.tools.installDaemon) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Image(systemName: "server.rack")
                                        .font(.system(size: 14))
                                        .foregroundColor(.orange)
                                    
                                    Text("Install System Daemon")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Install OpenClaw as a background service that starts automatically")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        Divider()
                            .background(Color.white.opacity(0.1))
                        
                        Toggle(isOn: $viewModel.configuration.tools.autoStart) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Image(systemName: "power")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                    
                                    Text("Auto-start on Login")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Automatically start OpenClaw when you log in to macOS")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .disabled(!viewModel.configuration.tools.installDaemon)
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
                }
                
                // Summary
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Installation Summary")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        SummaryRow(
                            icon: "checkmark.circle.fill",
                            color: .green,
                            label: "Gateway Authentication",
                            value: "Configured"
                        )
                        
                        SummaryRow(
                            icon: "checkmark.circle.fill",
                            color: .green,
                            label: "AI Model Providers",
                            value: viewModel.configuration.modelProvider.hasAtLeastOneProvider ? "Configured" : "Not Configured"
                        )
                        
                        SummaryRow(
                            icon: viewModel.configuration.channels.anyChannelEnabled ? "checkmark.circle.fill" : "minus.circle.fill",
                            color: viewModel.configuration.channels.anyChannelEnabled ? .green : .gray,
                            label: "Channels",
                            value: viewModel.configuration.channels.anyChannelEnabled ? "\(enabledChannelsCount) enabled" : "None (optional)"
                        )
                        
                        SummaryRow(
                            icon: "server.rack",
                            color: viewModel.configuration.tools.installDaemon ? .orange : .gray,
                            label: "System Daemon",
                            value: viewModel.configuration.tools.installDaemon ? "Will Install" : "Skip"
                        )
                    }
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
            }
            .padding(.vertical, 10)
        }
    }
    
    private var enabledChannelsCount: Int {
        var count = 0
        if viewModel.configuration.channels.telegramEnabled { count += 1 }
        if viewModel.configuration.channels.discordEnabled { count += 1 }
        if viewModel.configuration.channels.slackEnabled { count += 1 }
        if viewModel.configuration.channels.mattermostEnabled { count += 1 }
        if viewModel.configuration.channels.zaloEnabled { count += 1 }
        if viewModel.configuration.channels.twitchEnabled { count += 1 }
        return count
    }
}

struct ToolCard<Content: View>: View {
    let title: String
    let description: String
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
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(description)
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
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

struct SummaryRow: View {
    let icon: String
    let color: Color
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
        }
    }
}

#Preview {
    ToolsConfigView(viewModel: InstallerViewModel())
        .background(Color.black)
}
