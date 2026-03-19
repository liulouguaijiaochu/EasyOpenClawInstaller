//
//  InstallerService.swift
//  OpenClawInstaller
//
//  Service handling the actual installation operations
//

import Foundation

enum InstallerError: Error, LocalizedError {
    case directoryCreationFailed(String)
    case fileWriteFailed(String)
    case npmInstallFailed(String)
    case onboardingFailed(String)
    case daemonInstallFailed(String)
    case autoStartFailed(String)
    case nodeNotInstalled
    
    var errorDescription: String? {
        switch self {
        case .directoryCreationFailed(let msg):
            return "Failed to create directories: \(msg)"
        case .fileWriteFailed(let msg):
            return "Failed to write configuration: \(msg)"
        case .npmInstallFailed(let msg):
            return "npm install failed: \(msg)"
        case .onboardingFailed(let msg):
            return "OpenClaw onboarding failed: \(msg)"
        case .daemonInstallFailed(let msg):
            return "Daemon installation failed: \(msg)"
        case .autoStartFailed(let msg):
            return "Auto-start configuration failed: \(msg)"
        case .nodeNotInstalled:
            return "Node.js is not installed. Please install Node.js 22 or later."
        }
    }
}

@MainActor
class InstallerService {
    
    func checkNodeInstallation() async throws -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = ["node"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        try process.run()
        process.waitUntilExit()
        
        return process.terminationStatus == 0
    }
    
    func getNodeVersion() async throws -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["node", "--version"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func createDirectories(config: OpenClawConfiguration) async throws {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        
        // Expand tilde in paths
        let stateDirPath = config.gateway.stateDir.replacingOccurrences(of: "~", with: homeDir.path)
        
        // Create directories
        let directories = [
            stateDirPath,
            "\(stateDirPath)/config",
            "\(stateDirPath)/logs",
            "\(stateDirPath)/skills"
        ]
        
        for dir in directories {
            let url = URL(fileURLWithPath: dir)
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func writeEnvFile(config: OpenClawConfiguration) async throws {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let stateDirPath = config.gateway.stateDir.replacingOccurrences(of: "~", with: homeDir.path)
        let envFilePath = "\(stateDirPath)/.env"
        
        let envContent = config.generateEnvFile()
        
        guard let data = envContent.data(using: .utf8) else {
            throw InstallerError.fileWriteFailed("Failed to encode configuration")
        }
        
        let url = URL(fileURLWithPath: envFilePath)
        try data.write(to: url, options: .atomic)
        
        // Set file permissions to be readable only by owner
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: envFilePath)
    }
    
    func installOpenClaw() async throws {
        // Check if Node.js is installed
        guard try await checkNodeInstallation() else {
            throw InstallerError.nodeNotInstalled
        }
        
        // Install OpenClaw globally via npm
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["npm", "install", "-g", "openclaw@latest"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != 0 {
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorMsg = String(data: errorData, encoding: .utf8) ?? "Unknown error"
            throw InstallerError.npmInstallFailed(errorMsg)
        }
    }
    
    func runOnboarding(config: OpenClawConfiguration) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        
        var args = ["openclaw", "onboard"]
        if config.tools.installDaemon {
            args.append("--install-daemon")
        }
        
        process.arguments = args
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        // Set environment variables
        var environment = ProcessInfo.processInfo.environment
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let stateDirPath = config.gateway.stateDir.replacingOccurrences(of: "~", with: homeDir.path)
        environment["OPENCLAW_STATE_DIR"] = stateDirPath
        
        if !config.gateway.token.isEmpty {
            environment["OPENCLAW_GATEWAY_TOKEN"] = config.gateway.token
        }
        
        process.environment = environment
        
        try process.run()
        process.waitUntilExit()
        
        // Note: Onboarding might prompt for interactive input
        // In a real implementation, we might need to handle this differently
    }
    
    func installDaemon(config: OpenClawConfiguration) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["openclaw", "onboard", "--install-daemon"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != 0 {
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorMsg = String(data: errorData, encoding: .utf8) ?? "Unknown error"
            throw InstallerError.daemonInstallFailed(errorMsg)
        }
    }
    
    func configureAutoStart(config: OpenClawConfiguration) async throws {
        // Create LaunchAgents plist for auto-start
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let launchAgentsDir = "\(homeDir.path)/Library/LaunchAgents"
        let plistPath = "\(launchAgentsDir)/com.openclaw.gateway.plist"
        
        // Ensure LaunchAgents directory exists
        try FileManager.default.createDirectory(
            at: URL(fileURLWithPath: launchAgentsDir),
            withIntermediateDirectories: true
        )
        
        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>com.openclaw.gateway</string>
            <key>ProgramArguments</key>
            <array>
                <string>/usr/local/bin/openclaw</string>
                <string>gateway</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardOutPath</key>
            <string>\(config.gateway.stateDir)/logs/gateway.log</string>
            <key>StandardErrorPath</key>
            <string>\(config.gateway.stateDir)/logs/gateway.error.log</string>
            <key>EnvironmentVariables</key>
            <dict>
                <key>PATH</key>
                <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
            </dict>
        </dict>
        </plist>
        """
        
        guard let data = plistContent.data(using: .utf8) else {
            throw InstallerError.autoStartFailed("Failed to encode plist")
        }
        
        try data.write(to: URL(fileURLWithPath: plistPath), options: .atomic)
        
        // Load the launch agent
        let loadProcess = Process()
        loadProcess.executableURL = URL(fileURLWithPath: "/bin/launchctl")
        loadProcess.arguments = ["load", plistPath]
        
        try loadProcess.run()
        loadProcess.waitUntilExit()
    }
    
    func openOpenClaw() {
        // Open the OpenClaw Control UI in browser
        if let url = URL(string: "http://localhost:18789") {
            NSWorkspace.shared.open(url)
        }
    }
}
