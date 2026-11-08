Coucou Community, an independent community build, based on Coucou by Louis Raillé.

- Keep the edge drawing transparent until explicitly enabled by a drag, even if Windows surfaces the auxiliary overlay.
- Fix the persistent pale-blue oval at Windows startup: the edge indicator starts hidden and only appears for a valid drag target.
- Native Windows startup checks confirm that the indicator exists and remains hidden before publication.
- Customizable room, room styles, lighting, appearances and accessory combinations.
- Coucou in the app title and tray; Coucou Community in the installer and launcher. Existing preview preferences and identifiers are retained.
- Close and uninstall the old Coucou and Mochi Studio Preview in Windows Settings before installing this build if you want a single launcher. The preview uninstaller preserves saved room and appearance preferences.
- Agent-hook installation, global shortcuts and automatic updates are disabled in this preview.
- macOS universal DMG and Windows x64 EXE/MSI/portable ZIP are compiled by this repository's GitHub Actions from the source commit in the attached manifests. SHA-256 checksums are included.
- Windows installation, startup and uninstallation must preserve six official Coucou/Claude settings and file sentinels before publication. This is a CI coexistence check, not full testing on personal computers.

The room remains an independent project. This is not an official Coucou release or an endorsement. Window attachment and jumps remain experimental: full native interaction validation and a native jump recording are still pending.

Windows builds are unsigned; the Mac build is ad-hoc signed and not notarized. iCloud/iPhone integration is excluded. Original credits, licenses and third-party dependency notices are retained.

The earlier preview that shared Coucou's identifiers has been withdrawn. Do not install it over Coucou.
