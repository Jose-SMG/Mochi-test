<div align="center">

# Coucou

**Coucou: room, appearances and window-edge attachment.**

**Independent community build:** separate identifiers, version and data. The earlier preview that shared Coucou’s identity has been withdrawn. Agent hooks, global shortcuts and automatic updates are disabled. New installers are published only after both native builds and isolation checks pass.

**A room to make your own. A look to keep. A companion for your desktop.**

Independent community project based on [Coucou](https://github.com/Louis-CFM/coucou), by Louis Raillé. Preview for macOS and Windows.

For Coucou itself: [head/face/neck stacking proposal](presentation/review/canvas/STACKING-PROPOSAL.md), awaiting design agreement and PR #1025. The [previous Canvas prototype](presentation/review/canvas/README.md) is retained as a reference. The room remains an independent project.

[Download the beta](https://github.com/Jose-SMG/Mochi-test/releases/tag/coucou-v0.1.2-beta.1) · [Design preview](presentation/review/README.md) · [Build from source](#build-from-source) · [Known limitations](docs/mochi/KNOWN-ISSUES.md)

![Room styles and editor](presentation/review/room-preview.gif)

</div>

## Make room for Mochi

Choose Cozy, Gamer, Minimalist or Mediterranean. Arrange furniture, adjust the camera and light, and save named rooms. Mochi can read, play and rest in the room.

![Mochi Studio room editor](presentation/review/room.png)

## Make a look your own

Combine a body appearance, outfit, glasses and scarf. Save looks and export transparent 1600 × 1600 PNG photos. Diamond Mochi keeps his rounded black body with many small bright stones.

![Appearance and accessory combinations](presentation/review/outfits.png)

[Watch the room and outfit demo](presentation/review/room-and-outfits.mp4) · [Vídeo en español](presentation/review/room-and-outfits.es.mp4)

These recordings show the actual shared editor with its development bridge. They are visual demonstrations, not native window-interaction recordings.

## Native window companionship — draft

The source includes automatic exposed-edge selection, arm grip, window following and jumps. No keyboard modifier is required to attach Mochi. Full installed-app drag/follow/jump validation and a verified native jump recording remain pending. [Review status and limitations](docs/mochi/KNOWN-ISSUES.md).

## Downloads

| System | Installer |
| --- | --- |
| macOS 15+, Apple Silicon and Intel | [Universal DMG](https://github.com/Jose-SMG/Mochi-test/releases/download/coucou-v0.1.2-beta.1/Coucou-0.1.2-beta.1-macOS-universal.dmg) |
| Windows 10/11 x64 | [Setup EXE](https://github.com/Jose-SMG/Mochi-test/releases/download/coucou-v0.1.2-beta.1/Coucou-0.1.2-beta.1-Windows-x64-setup.exe) |

The [release](https://github.com/Jose-SMG/Mochi-test/releases/tag/coucou-v0.1.2-beta.1) also includes MSI, portable ZIP, source manifests and SHA-256 checksums. This preview uses `io.github.jose-smg.mochistudio.preview` and its own `MochiStudioPreview` data directory. It does not migrate or remove official Coucou settings. The release link becomes available after the native CI checks pass.

Windows is unsigned. The Mac package is ad-hoc signed and not notarized; its optimized Debug configuration excludes the PHONE_LINK/iCloud integration enabled by upstream Release. Browser/system warnings may remain. [Installation guide in Spanish](INSTALLERS.md).

## Build from source

```sh
git clone https://github.com/Jose-SMG/Mochi-test.git
cd Mochi-test
```

**Mac:** install Xcode and XcodeGen, then:

```sh
cd NotchBuddy
xcodegen generate
open NotchBuddy.xcodeproj
```

**Windows:** install Node and the upstream Rust/Tauri/WebView2 prerequisites, then:

```sh
cd windows
npm ci
npm run tauri -- dev
```

See [the original Coucou README](README.coucou.md) and [contribution guidelines](CONTRIBUTING.md) for the full application and platform setup.

## Review and project map

| Location | Contents |
| --- | --- |
| `NotchBuddy/` | Original Mac application and Mochi Studio integration |
| `windows/` | Tauri application and Windows integration |
| `shared/mochi-scenes/` | Bundled offline room/character renderer and dependency notices |
| `tests/`, `scripts/` | Existing regression tests, native packaging and QA helpers |
| `presentation/review/` | Screenshots, GIF, recordings and wardrobe overlap review |
| `docs/mochi/` | Known issues, QA checklist, signing and proposal |
| `docs/mochi-home/`, `docs/mochi-perch/` | Original concept documents |
| `distribution/` | Verified source release and installer migration manifest |

The room and native interaction work remain part of this independent project. The historical room/window review branches and their draft PRs are archived design references: they retain the former app identity and must not be used to build or install the preview. Build current `main` only.

[Wardrobe overlap notes](presentation/review/WARDROBE-OVERLAP.md) cover upstream PRs #1025, #737 and #738. Contributions to Coucou itself must be small, separate Canvas-only changes with no new dependencies, following upstream `CLAUDE.md`. The Three.js room is not proposed for upstream merging.

## Validation and provenance

**Published build:** `0.1.2-beta.1`, built from `ae695a41ade5711db568159bff7d29017c71885b` in [the successful native build](https://github.com/Jose-SMG/Mochi-test/actions/runs/42535359515). [Published source and artifact manifest](distribution/published-preview-manifest.json) · [Windows coexistence result](distribution/windows-coexistence.json).

The installers workflow builds both native platforms directly from this repository. Release manifests identify the source commit, repository, independent app identifier and artifact hashes. Publishing requires both builds, isolation checks, native edge-selection tests and a Windows NSIS EXE install/start/uninstall coexistence check and native startup marker visibility, exact product/executable/shortcut names, an upgrade from the previous installer and retained room/appearance preference checks to pass. Full native drag/follow/jump validation is still pending.

Previous copied installers are withdrawn; the import workflow is disabled by its retirement guard. See [the isolation changes](docs/mochi/INDEPENDENT-PREVIEW.md).

## Versions

| Version | Changes |
| --- | --- |
| [0.1.2-beta.1](https://github.com/Jose-SMG/Mochi-test/releases/tag/coucou-v0.1.2-beta.1) | Coucou app, executable, installer and shortcuts; upgrade retains preferences |
| [0.1.1-beta.1](https://github.com/Jose-SMG/Mochi-test/releases/tag/coucou-community-v0.1.1-beta.1) | Coucou app name, Coucou Community installer, retained preferences and transparent inactive edge marker |
| [0.1.0-beta.4](https://github.com/Jose-SMG/Mochi-test/releases/tag/mochi-studio-preview-v0.1.0-beta.4) | Hide the window-edge indicator at startup; native Windows visibility regression check |
| [0.1.0-beta.3](https://github.com/Jose-SMG/Mochi-test/releases/tag/mochi-studio-preview-v0.1.0-beta.3) | Independent community preview, separate identity and data, source-built installers |

## Credits and license

Coucou, Mochi, the original artwork and sounds belong to **Louis Raillé**. This is a community contribution and preview, not an official release or a statement of endorsement. Original code history, [LICENSE](LICENSE), asset notices and dependency notices are retained. The original project's README is preserved as [README.coucou.md](README.coucou.md).
