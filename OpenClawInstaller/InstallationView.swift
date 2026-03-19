//
//  InstallationView.swift
//  OpenClawInstaller
//
//  Installation progress view
//

import SwiftUI

struct InstallationView: View {
    @ObservedObject var viewModel: InstallerViewModel
    @State private var showLog = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Status icon/animation
            installationStatusView
            
            // Progress indicator
            if case .inProgress(let step, let progress) = viewModel.installationStatus {
                VStack(spacing: 16) {
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progress, height: 6)
                                .cornerRadius(3)
                                .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 6)
                    .frame(maxWidth: 400)
                    
                    // Step text
                    Text(step)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    // Progress percentage
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
            
            // Status message
            statusMessageView
            
            // Log viewer toggle
            if !viewModel.installationLog.isEmpty {
                Button(action: {
                    withAnimation {
                        showLog.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: showLog ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12))
                        Text(showLog ? "Hide Log" : "Show Log")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                
                if showLog {
                    logView
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private var installationStatusView: some View {
        switch viewModel.installationStatus {
        case .notStarted:
            VStack(spacing: 20) {
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Ready to Install")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Click 'Start Installation' to begin installing OpenClaw.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
        case .inProgress:
            ZStack {
                // Animated rings
                ForEach(0..<2) { i in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .red.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 120 + CGFloat(i) * 30, height: 120 + CGFloat(i) * 30)
                        .rotationEffect(.degrees(Double(i) * 180))
                        .animation(
                            Animation.linear(duration: 3)
                                .repeatForever(autoreverses: false),
                            value: UUID()
                        )
                }
                
                // Center icon
                Image(systemName: "gearshape.2")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(360))
                    .animation(
                        Animation.linear(duration: 4)
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            .frame(width: 180, height: 180)
            
        case .success:
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.5), radius: 20, x: 0, y: 0)
                
                Text("Installation Complete!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("OpenClaw has been successfully installed on your Mac.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
        case .failure(let error):
            VStack(spacing: 20) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                    .shadow(color: .red.opacity(0.5), radius: 20, x: 0, y: 0)
                
                Text("Installation Failed")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    private var statusMessageView: some View {
        switch viewModel.installationStatus {
        case .notStarted:
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("What will be installed:")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    InstallItem(text: "OpenClaw npm package (latest version)")
                    InstallItem(text: "Gateway daemon configuration")
                    InstallItem(text: "Environment configuration file")
                    if viewModel.configuration.tools.installDaemon {
                        InstallItem(text: "System launchd service")
                    }
                    if viewModel.configuration.tools.autoStart {
                        InstallItem(text: "Auto-start configuration")
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            
        case .inProgress:
            EmptyView()
            
        case .success:
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.openOpenClaw()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "globe")
                            Text("Open OpenClaw")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        viewModel.openDocumentation()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "book.fill")
                            Text("Documentation")
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
                }
            }
            
        case .failure:
            Button(action: {
                viewModel.installationStatus = .notStarted
                viewModel.installationLog.removeAll()
                viewModel.validateCurrentStep()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Try Again")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.3))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var logView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Installation Log")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 6)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.installationLog, id: \.self) { logEntry in
                        Text(logEntry)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(logEntry.contains("❌") ? .red : logEntry.contains("✅") ? .green : .gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(12)
            }
            .frame(maxHeight: 150)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct InstallItem: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 10))
                .foregroundColor(.green)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    InstallationView(viewModel: InstallerViewModel())
        .background(Color.black)
}
