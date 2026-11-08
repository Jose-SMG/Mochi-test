> **Preview update (2026-11-07):** legacy 0.6 installers are withdrawn. Current main uses independent Mochi Studio Preview identity. See [isolation and build status](INDEPENDENT-PREVIEW.md). Older test/build references below are historical, not validation of the new installers.

# Preview status and known limitations

## Current community build: 0.1.2-beta.1

[Both native builds and the source-verified publication passed](https://github.com/Jose-SMG/Mochi-test/actions/runs/42535359515), from `ae695a41ade5711db568159bff7d29017c71885b`.

- Universal macOS bundle: own identifier/version, bundled scene checks, real WebKit rendering/PNG export, ad-hoc signature and DMG verification.
- Windows: 620 app tests and 36 relay tests passed (7 app tests ignored); EXE, MSI and portable ZIP compiled. Native edge-selection tests passed.
- The actual NSIS EXE was installed, launched with separate preferences, and uninstalled in CI. The preview executable was removed and all six official Coucou/Claude sentinel files kept their hashes. [Result](../../distribution/windows-coexistence.json).
- The app, installer, executable and Start menu shortcut use exactly Coucou. Windows CI upgrades the previously published installer, verifies the old executable/shortcut are replaced, and checks original application and startup registry values are unchanged. Room and appearance preferences survive uninstalling this build. The app retains the former preview settings directory.
- The native edge indicator exists and remains hidden during cold startup, verified through Windows HWND visibility inspection.
- Both installers' public download URLs returned HTTP 200. The published artifact sizes and GitHub SHA-256 digests match the [source-build manifest](../../distribution/published-preview-manifest.json).

This is a CI smoke/coexistence check. MSI installation, physical Mac/Windows coexistence, and full drag/follow/jump interactions have not been verified. Signing limitations below still apply.

The production utility page also passed 12 Chromium size/DPI cases locally: empty at startup, visible only when enabled, cleared after the target, and empty after a renderer reload. This is renderer validation, not a full installed-app drag test.

## Historical withdrawn beta packages

The Mac and Windows installers were built from `6b4e5ea2f80ab59375973c73034d1f16d020b49e`, based on upstream `b1bc09de7f7c24a80bd8eca5729b8bee60f66402`.

- Windows: 618 app tests passed, 7 ignored; 35 relay tests; 569 frontend tests; 22 shared scene/data tests.
- Native Windows edge selection: 7 tests passed, with a separate fixture helper.
- Mac: universal ARM64/Intel build, packaged-resource checks, ad-hoc signature and DMG verification; the packaged room rendered and exported a valid PNG in real WebKit.

[Original build evidence](https://github.com/Jose-SMG/Pruebas/actions/runs/42304291267). The overall workflow failed in its interactive automation job; successful compilation and geometry tests are not proof of complete native interaction behavior.

## Still pending

- Full installed-app drag/follow/jump automation has not passed. Later controllers also failed to validate that experience. A verified native jump recording is not available.
- Physical multi-monitor and mixed-DPI checks, target movement/minimization/closure, and Mac Accessibility permission checks.
- Resource comparisons against the official application on the same physical hardware and longer usage sessions.
- Integration decisions around upstream wardrobe PRs #1025, #737 and #738. These contributions were reviewed for overlap, not merged or compatibility-tested here.
- Maintainer review of the bundled offline Three.js dependency, additional Windows webviews and resource budget.

The screenshots/GIF/videos show the real shared editor with its development bridge. The grip-renderer image shows the character scene, not a native window capture. These previews are useful for design review and do not establish native interaction success.

## Distribution limits

Windows is unsigned. Mac is ad-hoc signed and not notarized. Signing scripts have optional identity settings, but trusted signing has not been validated with real certificates.

The Mac beta uses upstream Debug with `-O` optimization and excludes the PHONE_LINK/iCloud flag enabled by upstream Release. The Windows package uses Release. Current packages use the independent preview identifiers and data directories. The withdrawn legacy packages shared Coucou identifiers and must not be installed over Coucou.

The full source is preserved. [Manual QA checklist](QA-CHECKLIST.md) and [signing notes](SIGNING.es.md) describe the remaining work. Neither migration nor a successful package import marks these checks complete.
