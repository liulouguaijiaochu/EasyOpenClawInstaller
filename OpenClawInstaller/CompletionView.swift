//
//  CompletionView.swift
//  OpenClawInstaller
//
//  Installation completion view
//

import SwiftUI

struct CompletionView: View {
    @ObservedObject var viewModel: InstallerViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success animation
            ZStack {
                // Confetti-like particles
                ForEach(0..<12) { i in
                    Circle()
                        .fill(
                            [Color.orange, .red, .yellow, .green, .blue, .purple][i % 6]
                        )
                        .frame(width: 8, height: 8)
                        .offset(
                            x: isAnimating ? cos(Double(i) * .pi / 6) * 80 : 0,
                            y: isAnimating ? sin(Double(i) * .pi / 6) * 80 : 0
                        )
                        .opacity(isAnimating ? 0 : 1)
                        .animation(
                            Animation.easeOut(duration: 1)
                                .delay(0.1 * Double(i)),
                            value: isAnimating
                        )
                }
                
                // Main success icon
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .green.opacity(0.5), radius: 20, x: 0, y: 0)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimating)
            }
            .frame(width: 200, height: 200)
            .onAppear {
                isAnimating = true
            }
            
            VStack(spacing: 12) {
                Text("Installation Complete!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("OpenClaw is now ready to use")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            // Quick start guide
            VStack(alignment: .leading, spacing: 16) {
                Text("Quick Start Guide")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    QuickStartItem(
                        number: 1,
                        title: "Access the Web Interface",
                        description: "Open http://localhost:18789 in your browser",
                        action: "Open Now",
                        actionHandler: {
                            viewModel.openOpenClaw()
                        }
                    )
                    
                    QuickStartItem(
                        number: 2,
                        title: "Configure Channels",
                        description: "Add WhatsApp, Telegram, or other messaging channels",
                        action: "Learn More",
                        actionHandler: {
                            viewModel.openDocumentation()
                        }
                    )
                    
                    QuickStartItem(
                        number: 3,
                        title: "Start Using OpenClaw",
                        description: "Send a message to your assistant and start exploring",
                        action: "Documentation",
                        actionHandler: {
                            viewModel.openDocumentation()
                        }
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            
            // Important info
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    
                    Text("Important Information")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(icon: "terminal", text: "CLI: Use 'openclaw' command in Terminal")
                    InfoRow(icon: "folder", text: "Config: ~/.openclaw/openclaw.json")
                    InfoRow(icon: "doc.text", text: "Logs: ~/.openclaw/logs/")
                    InfoRow(icon: "gearshape", text: "Service: com.openclaw.gateway (launchd)")
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            
            Spacer()
            
            // Finish button
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                    Text("Finish")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 40)
    }
}

struct QuickStartItem: View {
    let number: Int
    let title: String
    let description: String
    let action: String
    let actionHandler: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Number circle
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: actionHandler) {
                Text(action)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.orange)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.blue)
                .frame(width: 16)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CompletionView(viewModel: InstallerViewModel())
        .background(Color.black)
}
