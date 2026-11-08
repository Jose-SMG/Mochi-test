# Independent community preview

Louis’s November 7 review asks for independent builds, reproducible provenance and small upstream contributions.

| Scope | Preview |
| --- | --- |
| Application | Mochi Studio Preview 0.1.0 beta 4 |
| Bundle identifiers, both platforms | io.github.jose-smg.mochistudio.preview |
| Mac support and log directories | MochiStudioPreview |
| Windows roaming/local data | MochiStudioPreview |
| Windows executable | mochi-studio-preview.exe |
| Windows credential service | independent bundle identifier |
| Windows relay/pipe | mochi-studio-preview-hook / mochi-studio-preview-SID |
| Agent-hook writes/removals | disabled at public mutation entry points |
| Automatic updates and global shortcuts | disabled |
| iCloud | excluded from preview target compilation |

The legacy release is retained privately as a draft, not offered for download. The old importer refuses publication. Native builds run in this repo; publication verifies the exact source commit, both platforms and artifact hashes. Windows CI tests install, startup and uninstall against official app/data/hook sentinels. Mac CI checks the actual universal bundle ID/version, resource packaging and policy rejection.

No migration from official Coucou is performed. Tests do not establish full drag/follow/jump behavior, physical-machine coexistence or trusted signing. Those remain pending. Historical review branches must not be installed.

The Three.js room stays here. An upstream contribution should contain one Canvas-only accessory feature, no room, WebView, dependency or identity change, and account for wardrobe PRs #1025/#737/#738.
