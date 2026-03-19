//
//  InstallerViewModel.swift
//  OpenClawInstaller
//
//  View model managing the installation flow
//

import SwiftUI
import Combine

enum InstallationStatus {
    case notStarted
    case inProgress(step: String, progress: Double)
    case success
    case failure(error: String)
}

@MainActor
class InstallerViewModel: ObservableObject {
    @Published var currentStep: InstallationStep = .welcome
    @Published var configuration = OpenClawConfiguration()
    @Published var installationStatus: InstallationStatus = .notStarted
    @Published var canProceed: Bool = true
    @Published var installationLog: [String] = []
    
    private let installerService = InstallerService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        validateCurrentStep()
    }
    
    var isFirstStep: Bool {
        currentStep == .welcome
    }
    
    var isLastStep: Bool {
        currentStep == .completion
    }
    
    var progress: Double {
        Double(currentStep.rawValue) / Double(InstallationStep.allCases.count - 1)
    }
    
    var currentStepTitle: String {
        currentStep.title
    }
    
    func nextStep() {
        guard currentStep.rawValue < InstallationStep.allCases.count - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = InstallationStep(rawValue: currentStep.rawValue + 1) ?? .completion
        }
        validateCurrentStep()
    }
    
    func previousStep() {
        guard currentStep.rawValue > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = InstallationStep(rawValue: currentStep.rawValue - 1) ?? .welcome
        }
        validateCurrentStep()
    }
    
    func goToStep(_ step: InstallationStep) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = step
        }
        validateCurrentStep()
    }
    
    func validateCurrentStep() {
        switch currentStep {
        case .welcome:
            canProceed = true
        case .gatewayConfig:
            canProceed = configuration.gateway.isValid
        case .modelProvider:
            canProceed = configuration.modelProvider.hasAtLeastOneProvider
        case .channels:
            canProceed = true // Optional step
        case .tools:
            canProceed = true // Optional step
        case .installation:
            canProceed = installationStatus == .notStarted || 
                        (case .success = installationStatus)
        case .completion:
            canProceed = false
        }
    }
    
    func generateToken() {
        let length = 32
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var token = ""
        for _ in 0..<length {
            if let randomChar = characters.randomElement() {
                token.append(randomChar)
            }
        }
        configuration.gateway.token = token
        validateCurrentStep()
    }
    
    func startInstallation() async {
        installationStatus = .inProgress(step: "Preparing installation...", progress: 0.0)
        addLog("Starting OpenClaw installation...")
        
        do {
            // Step 1: Create directories
            installationStatus = .inProgress(step: "Creating directories...", progress: 0.1)
            addLog("Creating OpenClaw directories...")
            try await installerService.createDirectories(config: configuration)
            try await Task.sleep(nanoseconds: 500_000_000)
            
            // Step 2: Write .env file
            installationStatus = .inProgress(step: "Writing configuration...", progress: 0.3)
            addLog("Writing environment configuration...")
            try await installerService.writeEnvFile(config: configuration)
            try await Task.sleep(nanoseconds: 500_000_000)
            
            // Step 3: Install Node.js dependencies
            installationStatus = .inProgress(step: "Installing OpenClaw package...", progress: 0.5)
            addLog("Installing OpenClaw npm package...")
            try await installerService.installOpenClaw()
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Step 4: Run onboarding
            installationStatus = .inProgress(step: "Running OpenClaw onboarding...", progress: 0.7)
            addLog("Running OpenClaw onboarding...")
            try await installerService.runOnboarding(config: configuration)
            try await Task.sleep(nanoseconds: 500_000_000)
            
            // Step 5: Install daemon if requested
            if configuration.tools.installDaemon {
                installationStatus = .inProgress(step: "Installing system daemon...", progress: 0.85)
                addLog("Installing launchd daemon...")
                try await installerService.installDaemon(config: configuration)
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            
            // Step 6: Setup auto-start if requested
            if configuration.tools.autoStart {
                installationStatus = .inProgress(step: "Configuring auto-start...", progress: 0.95)
                addLog("Configuring auto-start...")
                try await installerService.configureAutoStart(config: configuration)
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            
            installationStatus = .inProgress(step: "Finalizing...", progress: 0.99)
            addLog("Installation complete!")
            try await Task.sleep(nanoseconds: 500_000_000)
            
            installationStatus = .success
            addLog("✅ OpenClaw has been successfully installed!")
            
        } catch {
            installationStatus = .failure(error: error.localizedDescription)
            addLog("❌ Installation failed: \(error.localizedDescription)")
        }
        
        validateCurrentStep()
    }
    
    func addLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        installationLog.append("[\(timestamp)] \(message)")
    }
    
    func openOpenClaw() {
        installerService.openOpenClaw()
    }
    
    func openDocumentation() {
        if let url = URL(string: "https://docs.openclaw.ai") {
            NSWorkspace.shared.open(url)
        }
    }
}
