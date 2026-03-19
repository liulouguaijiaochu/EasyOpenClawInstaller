//
//  WelcomeView.swift
//  OpenClawInstaller
//
//  Welcome screen for the installer
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: InstallerViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated logo
            ZStack {
                // Outer glow rings
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.orange.opacity(0.3 - Double(i) * 0.1), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                        .frame(width: 150 + CGFloat(i) * 40, height: 150 + CGFloat(i) * 40)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .opacity(isAnimating ? 0.5 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.3),
                            value: isAnimating
                        )
                }
                
                // Main icon
                Image(systemName: "lobster")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .orange.opacity(0.5), radius: 20, x: 0, y: 0)
            }
            .onAppear {
                isAnimating = true
            }
            
            VStack(spacing: 12) {
                Text("Welcome to OpenClaw")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Your Personal AI Assistant")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
            }
            
            // Feature cards
            HStack(spacing: 16) {
                FeatureCard(
                    icon: "network",
                    title: "Multi-Channel",
                    description: "WhatsApp, Telegram, Slack, Discord & more"
                )
                
                FeatureCard(
                    icon: "brain.head.profile",
                    title: "AI Powered",
                    description: "OpenAI, Anthropic, Gemini & other models"
                )
                
                FeatureCard(
                    icon: "lock.shield",
                    title: "Privacy First",
                    description: "Runs locally on your machine"
                )
            }
            .padding(.top, 20)
            
            // Requirements
            VStack(alignment: .leading, spacing: 10) {
                Text("System Requirements")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 6) {
                    RequirementRow(text: "macOS 14.0 or later")
                    RequirementRow(text: "Node.js 22 or later")
                    RequirementRow(text: "Internet connection for setup")
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 140, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct RequirementRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(.green)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    WelcomeView(viewModel: InstallerViewModel())
        .background(Color.black)
}
