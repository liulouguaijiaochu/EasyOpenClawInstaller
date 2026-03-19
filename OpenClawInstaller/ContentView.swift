//
//  ContentView.swift
//  OpenClawInstaller
//
//  Main content view with navigation
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = InstallerViewModel()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.08, blue: 0.12),
                    Color(red: 0.08, green: 0.10, blue: 0.15),
                    Color(red: 0.05, green: 0.07, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Progress bar
                progressBar
                
                // Main content area
                mainContent
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                
                // Navigation buttons
                navigationBar
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
            }
        }
        .frame(minWidth: 900, minHeight: 650)
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            // Logo
            HStack(spacing: 12) {
                Image(systemName: "lobster")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("OpenClaw")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Personal AI Assistant Installer")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Step indicator
            HStack(spacing: 8) {
                ForEach(InstallationStep.allCases, id: \.self) { step in
                    Circle()
                        .fill(stepIndicatorColor(for: step))
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(step == viewModel.currentStep ? Color.orange : Color.clear, lineWidth: 2)
                                .frame(width: 12, height: 12)
                        )
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(
            Color.black.opacity(0.2)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1)),
                    alignment: .bottom
                )
        )
    }
    
    private func stepIndicatorColor(for step: InstallationStep) -> Color {
        if step.rawValue < viewModel.currentStep.rawValue {
            return .green
        } else if step == viewModel.currentStep {
            return .orange
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    // MARK: - Progress Bar
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 2)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * viewModel.progress, height: 2)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
            }
        }
        .frame(height: 2)
    }
    
    // MARK: - Main Content
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.currentStep {
        case .welcome:
            WelcomeView(viewModel: viewModel)
        case .gatewayConfig:
            GatewayConfigView(viewModel: viewModel)
        case .modelProvider:
            ModelProviderView(viewModel: viewModel)
        case .channels:
            ChannelsConfigView(viewModel: viewModel)
        case .tools:
            ToolsConfigView(viewModel: viewModel)
        case .installation:
            InstallationView(viewModel: viewModel)
        case .completion:
            CompletionView(viewModel: viewModel)
        }
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            // Back button
            if !viewModel.isFirstStep && !viewModel.isLastStep {
                Button(action: {
                    viewModel.previousStep()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Spacer()
                    .frame(width: 100)
            }
            
            Spacer()
            
            // Next/Install button
            if !viewModel.isLastStep {
                Button(action: {
                    if viewModel.currentStep == .installation {
                        Task {
                            await viewModel.startInstallation()
                        }
                    } else {
                        viewModel.nextStep()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(buttonTitle)
                        if viewModel.currentStep != .installation {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: viewModel.canProceed ? [.orange, .red] : [.gray.opacity(0.5), .gray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!viewModel.canProceed)
                .opacity(viewModel.canProceed ? 1.0 : 0.6)
            }
        }
    }
    
    private var buttonTitle: String {
        switch viewModel.currentStep {
        case .welcome:
            return "Get Started"
        case .gatewayConfig:
            return "Continue"
        case .modelProvider:
            return "Continue"
        case .channels:
            return "Continue"
        case .tools:
            return "Install"
        case .installation:
            if case .inProgress = viewModel.installationStatus {
                return "Installing..."
            }
            return "Start Installation"
        case .completion:
            return "Finish"
        }
    }
}

#Preview {
    ContentView()
}
