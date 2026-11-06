<div align="center">

# Mochi Studio

**A room to make your own. A look to keep. A companion for your desktop.**

Community contribution to [Coucou](https://github.com/Louis-CFM/coucou), by Louis Raillé. Preview for macOS and Windows.

[Download the beta](https://github.com/Jose-SMG/Mochi-test/releases/tag/mochi-studio-v0.6.0-beta.1) · [Design preview](presentation/review/README.md) · [Build from source](#build-from-source) · [Known limitations](docs/mochi/KNOWN-ISSUES.md)

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
| macOS 15+, Apple Silicon and Intel | [Universal DMG](https://github.com/Jose-SMG/Mochi-test/releases/download/mochi-studio-v0.6.0-beta.1/Coucou-Mochi-0.6.0-beta.1-macOS-universal.dmg) |
| Windows 10/11 x64 | [Setup EXE](https://github.com/Jose-SMG/Mochi-test/releases/download/mochi-studio-v0.6.0-beta.1/Coucou-Mochi-0.6.0-beta.1-Windows-x64-setup.exe) |

The [release](https://github.com/Jose-SMG/Mochi-test/releases/tag/mochi-studio-v0.6.0-beta.1) also includes MSI, portable ZIP, source manifests and SHA-256 checksums. Close Coucou and back up preferences before testing: this beta retains Coucou's application identifiers and can replace an existing installation.

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

The history retains the upstream Coucou snapshot and feature commits. The review branches separate [room/wardrobe](https://github.com/Jose-SMG/Mochi-test/tree/review/room-and-wardrobe) and [window attachment/jumps](https://github.com/Jose-SMG/Mochi-test/tree/review/window-grip-and-jumps). The latter is stacked on the room branch.

[Wardrobe overlap notes](presentation/review/WARDROBE-OVERLAP.md) cover upstream PRs #1025, #737 and #738. They identify shared code and design decisions; compatibility with those unmerged PRs has not been established. The offline Three.js dependency and added webview/resource costs also need maintainer review.

## Validation and provenance

Both existing native installer packages were built from `6b4e5ea2f80ab59375973c73034d1f16d020b49e`, on upstream `b1bc09de7f7c24a80bd8eca5729b8bee60f66402`. Packaging checks passed, including native edge-selection tests and packaged Mac WebKit rendering/PNG export. Full native interaction QA did not pass and is not marked complete. [Detailed status](docs/mochi/KNOWN-ISSUES.md).

Installer migration preserves the original files and verifies every size and SHA-256 digest before publishing them in this repository. No binary is rebuilt or relabeled as fully validated during migration.

## Credits and license

Coucou, Mochi, the original artwork and sounds belong to **Louis Raillé**. This is a community contribution and preview, not an official release or a statement of endorsement. Original code history, [LICENSE](LICENSE), asset notices and dependency notices are retained. The original project's README is preserved as [README.coucou.md](README.coucou.md).
