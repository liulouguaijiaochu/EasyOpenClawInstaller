//
//  ModelProviderView.swift
//  OpenClawInstaller
//
//  AI model provider configuration (OpenAI, Anthropic, Gemini, etc.)
//

import SwiftUI

struct ModelProviderView: View {
    @ObservedObject var viewModel: InstallerViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("AI Model Providers")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Configure at least one AI model provider. OpenClaw supports OpenAI, Anthropic, Gemini, and more. You can add multiple providers for redundancy.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                
                // Warning if no provider selected
                if !viewModel.configuration.modelProvider.hasAtLeastOneProvider {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                        
                        Text("Please enable and configure at least one model provider to continue.")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
                }
                
                // OpenAI Section
                ProviderSection(title: "OpenAI", icon: "openai", color: .green) {
                    VStack(spacing: 12) {
                        Toggle(isOn: $viewModel.configuration.modelProvider.openAIEnabled) {
                            Text("Enable OpenAI")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .onChange(of: viewModel.configuration.modelProvider.openAIEnabled) { _ in
                            viewModel.validateCurrentStep()
                        }
                        
                        if viewModel.configuration.modelProvider.openAIEnabled {
                            SecureField("OpenAI API Key (sk-...)", text: $viewModel.configuration.modelProvider.openAIKey)
                                .textFieldStyle(InstallerTextFieldStyle())
                                .onChange(of: viewModel.configuration.modelProvider.openAIKey) { _ in
                                    viewModel.validateCurrentStep()
                                }
                            
                            TextField("Additional API Keys (comma-separated, optional)", text: $viewModel.configuration.modelProvider.openAIKeys)
                                .textFieldStyle(InstallerTextFieldStyle())
                        }
                    }
                }
                
                // Anthropic Section
                ProviderSection(title: "Anthropic Claude", icon: "a.circle.fill", color: .orange) {
                    VStack(spacing: 12) {
                        Toggle(isOn: $viewModel.configuration.modelProvider.anthropicEnabled) {
                            Text("Enable Anthropic")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .onChange(of: viewModel.configuration.modelProvider.anthropicEnabled) { _ in
                            viewModel.validateCurrentStep()
                        }
                        
                        if viewModel.configuration.modelProvider.anthropicEnabled {
                            SecureField("Anthropic API Key (sk-ant-...)", text: $viewModel.configuration.modelProvider.anthropicKey)
                                .textFieldStyle(InstallerTextFieldStyle())
                                .onChange(of: viewModel.configuration.modelProvider.anthropicKey) { _ in
                                    viewModel.validateCurrentStep()
                                }
                            
                            TextField("Additional API Keys (comma-separated, optional)", text: $viewModel.configuration.modelProvider.anthropicKeys)
                                .textFieldStyle(InstallerTextFieldStyle())
                        }
                    }
                }
                
                // Gemini Section
                ProviderSection(title: "Google Gemini", icon: "g.circle.fill", color: .blue) {
                    VStack(spacing: 12) {
                        Toggle(isOn: $viewModel.configuration.modelProvider.geminiEnabled) {
                            Text("Enable Gemini")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .onChange(of: viewModel.configuration.modelProvider.geminiEnabled) { _ in
                            viewModel.validateCurrentStep()
                        }
                        
                        if viewModel.configuration.modelProvider.geminiEnabled {
                            SecureField("Gemini API Key", text: $viewModel.configuration.modelProvider.geminiKey)
                                .textFieldStyle(InstallerTextFieldStyle())
                                .onChange(of: viewModel.configuration.modelProvider.geminiKey) { _ in
                                    viewModel.validateCurrentStep()
                                }
                            
                            TextField("Additional API Keys (comma-separated, optional)", text: $viewModel.configuration.modelProvider.geminiKeys)
                                .textFieldStyle(InstallerTextFieldStyle())
                        }
                    }
                }
                
                // OpenRouter Section
                ProviderSection(title: "OpenRouter", icon: "arrow.left.arrow.right.circle.fill", color: .purple) {
                    VStack(spacing: 12) {
                        Toggle(isOn: $viewModel.configuration.modelProvider.openRouterEnabled) {
                            Text("Enable OpenRouter")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .onChange(of: viewModel.configuration.modelProvider.openRouterEnabled) { _ in
                            viewModel.validateCurrentStep()
                        }
                        
                        if viewModel.configuration.modelProvider.openRouterEnabled {
                            SecureField("OpenRouter API Key (sk-or-...)", text: $viewModel.configuration.modelProvider.openRouterKey)
                                .textFieldStyle(InstallerTextFieldStyle())
                                .onChange(of: viewModel.configuration.modelProvider.openRouterKey) { _ in
                                    viewModel.validateCurrentStep()
                                }
                        }
                    }
                }
                
                // Live Keys Section (Collapsible)
                DisclosureGroup {
                    VStack(spacing: 12) {
                        Text("These keys are used for live/continuous operations")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        
                        SecureField("Live OpenAI Key (optional)", text: $viewModel.configuration.modelProvider.liveOpenAIKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        SecureField("Live Anthropic Key (optional)", text: $viewModel.configuration.modelProvider.liveAnthropicKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                        
                        SecureField("Live Gemini Key (optional)", text: $viewModel.configuration.modelProvider.liveGeminiKey)
                            .textFieldStyle(InstallerTextFieldStyle())
                    }
                    .padding(.top, 8)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                        
                        Text("Live Operation Keys (Optional)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .disclosureGroupStyle(DarkDisclosureGroupStyle())
                
                // Additional Providers
                DisclosureGroup {
                    VStack(spacing: 16) {
                        // ZAI
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: $viewModel.configuration.modelProvider.zaiEnabled) {
                                Text("ZAI")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            
                            if viewModel.configuration.modelProvider.zaiEnabled {
                                SecureField("ZAI API Key", text: $viewModel.configuration.modelProvider.zaiKey)
                                    .textFieldStyle(InstallerTextFieldStyle())
                            }
                        }
                        
                        // AI Gateway
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: $viewModel.configuration.modelProvider.aiGatewayEnabled) {
                                Text("AI Gateway")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            
                            if viewModel.configuration.modelProvider.aiGatewayEnabled {
                                SecureField("AI Gateway API Key", text: $viewModel.configuration.modelProvider.aiGatewayKey)
                                    .textFieldStyle(InstallerTextFieldStyle())
                            }
                        }
                        
                        // Minimax
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: $viewModel.configuration.modelProvider.minimaxEnabled) {
                                Text("Minimax")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            
                            if viewModel.configuration.modelProvider.minimaxEnabled {
                                SecureField("Minimax API Key", text: $viewModel.configuration.modelProvider.minimaxKey)
                                    .textFieldStyle(InstallerTextFieldStyle())
                            }
                        }
                    }
                    .padding(.top, 8)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Additional Providers")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .disclosureGroupStyle(DarkDisclosureGroupStyle())
                
                // Help text
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Don't have API keys?")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text("Visit the provider websites to create API keys. OpenClaw will use the strongest available model by default.")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
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
            }
            .padding(.vertical, 10)
        }
    }
}

struct ProviderSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            content
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
    }
}

struct DarkDisclosureGroupStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isExpanded.toggle()
                }
            }) {
                HStack {
                    configuration.label
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if configuration.isExpanded {
                configuration.content
                    .padding(.leading, 4)
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
}

#Preview {
    ModelProviderView(viewModel: InstallerViewModel())
        .background(Color.black)
}
