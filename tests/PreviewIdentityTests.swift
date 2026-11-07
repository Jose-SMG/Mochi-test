import Foundation

@main struct PreviewIdentityTests {
    static func main() throws {
        precondition(PreviewIdentity.bundleIdentifier != "fr.louisraille.NotchBuddy")
        precondition(PreviewIdentity.supportDirectory != "NotchBuddy")
        precondition(!PreviewIdentity.automaticUpdatesEnabled)
        precondition(!PreviewIdentity.globalShortcutsEnabled)
        let officialSettings = Data(#"{"hooks":{"Stop":[{"command":"/official/nb-hook"}]}}"#.utf8)
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let path = dir.appendingPathComponent("settings.json")
        try officialSettings.write(to: path)
        var rejected = false
        do { try PreviewIdentity.requireAgentHooks(); try Data("changed".utf8).write(to: path) }
        catch { rejected = true }
        precondition(rejected, "The preview must reject hook installation and removal")
        let after = try Data(contentsOf: path)
        precondition(after == officialSettings)
        print("Preview policy rejects agent changes and keeps official settings intact.")
    }
}
