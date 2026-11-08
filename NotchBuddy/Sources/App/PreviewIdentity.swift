import Foundation

/// Independent community builds must never own Coucou's settings, hooks or updater.
enum PreviewIdentity {
    static let name = "Coucou"
    static let bundleIdentifier = "io.github.jose-smg.mochistudio.preview"
    static let supportDirectory = "MochiStudioPreview"
    static let agentHooksEnabled = false
    static let automaticUpdatesEnabled = false
    static let globalShortcutsEnabled = false

    static func requireAgentHooks() throws {
        guard agentHooksEnabled else { throw PreviewError.agentHooksDisabled }
    }

    enum PreviewError: LocalizedError {
        case agentHooksDisabled
        var errorDescription: String? {
            "Agent hook installation is disabled in this Coucou build. Your Coucou and coding-agent settings are left unchanged."
        }
    }
}
