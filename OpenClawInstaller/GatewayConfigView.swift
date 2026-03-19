//
//  GatewayConfigView.swift
//  OpenClawInstaller
//
//  Gateway authentication and paths configuration
//

import SwiftUI

struct GatewayConfigView: View {
    @ObservedObject var viewModel: InstallerViewModel
    @State private var showToken = false
    @State private var showPassword = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "network.badge.shield.half.filled")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Gateway Configuration")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Configure the OpenClaw gateway authentication and paths. The gateway token is required for secure communication.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                
                // Authentication Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Authentication", icon: "key.fill")
                    
                    VStack(spacing: 16) {
                        // Gateway Token
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Gateway Token")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.generateToken()
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "wand.and.stars")
                                            .font(.system(size: 10))
                                        Text("Generate")
                                            .font(.system(size: 11))
                                    }
                                    .foregroundColor(.orange)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack {
                                if showToken {
                                    TextField("Enter or generate a token", text: $viewModel.configuration.gateway.token)
                                        .textFieldStyle(InstallerTextFieldStyle())
                                        .onChange(of: viewModel.configuration.gateway.token) { _ in
                                            viewModel.validateCurrentStep()
                                        }
                                } else {
                                    SecureField("Enter or generate a token", text: $viewModel.configuration.gateway.token)
                                        .textFieldStyle(InstallerTextFieldStyle())
                                        .onChange(of: viewModel.configuration.gateway.token) { _ in
                                            viewModel.validateCurrentStep()
                                        }
                                }
                                
                                Button(action: {
                                    showToken.toggle()
                                }) {
                                    Image(systemName: showToken ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            Text("A secure token for gateway authentication. Use the generate button for a random token.")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                        
                        // Optional Password
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Gateway Password (Optional)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            if showPassword {
                                TextField("Optional alternative auth", text: $viewModel.configuration.gateway.password)
                                    .textFieldStyle(InstallerTextFieldStyle())
                            } else {
                                SecureField("Optional alternative auth", text: $viewModel.configuration.gateway.password)
                                    .textFieldStyle(InstallerTextFieldStyle())
                            }
                            
                            Text("Optional password-based authentication (use token OR password).")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
                
                // Paths Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Paths & Directories", icon: "folder.fill")
                    
                    VStack(spacing: 16) {
                        // State Directory
                        VStack(alignment: .leading, spacing: 6) {
                            Text("State Directory")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("~/.openclaw", text: $viewModel.configuration.gateway.stateDir)
                                .textFieldStyle(InstallerTextFieldStyle())
                            
                            Text("Directory for OpenClaw state, config, and logs.")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                        
                        // Config Path
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Config File Path")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("~/.openclaw/openclaw.json", text: $viewModel.configuration.gateway.configPath)
                                .textFieldStyle(InstallerTextFieldStyle())
                            
                            Text("Path to the main OpenClaw configuration file.")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
                
                // Shell Environment Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Shell Environment", icon: "terminal.fill")
                    
                    VStack(spacing: 12) {
                        Toggle(isOn: $viewModel.configuration.gateway.loadShellEnv) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Load Shell Environment")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                Text("Import missing keys from your login shell profile")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        if viewModel.configuration.gateway.loadShellEnv {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Shell Env Timeout (ms)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                
                                TextField("15000", value: $viewModel.configuration.gateway.shellEnvTimeout, format: .number)
                                    .textFieldStyle(InstallerTextFieldStyle())
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
                
                // Security Notice
                HStack(spacing: 10) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                    
                    Text("Your credentials are stored securely in ~/.openclaw/.env with restricted permissions.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
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

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

struct InstallerTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 13))
            .foregroundColor(.white)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack(spacing: 10) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundStyle(
                        configuration.isOn ?
                        LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GatewayConfigView(viewModel: InstallerViewModel())
        .background(Color.black)
}
