# Beta review checklist

Automated results belong in verification.json and the native reports. Do not mark human-device checks complete from a CI build alone.

## Manual checks to complete before calling this a stable release

- [ ] Windows 10 and Windows 11: install, upgrade from the official app, relaunch and uninstall.
- [ ] Mac Intel and Apple Silicon: install/relaunch and grant/check Accessibility permissions for window tracking.
- [ ] Native drag from both island and desktop; grip stays attached while moving, resizing, minimizing and closing the target.
- [ ] Two physical monitors: 100%, 125%, 150%, 200% scaling, crossing screens and negative monitor origins.
- [ ] Every room style at the smallest supported Studio size and on a 720p display.
- [ ] Saved rooms and looks persist across a real app restart and settings migration.
- [ ] Combined appearances retain their color and accessories during grip and jumps.
- [ ] PNG save dialog: success, cancel, invalid location and transparent output.
- [ ] GPU fallback and reduced motion on actual target hardware.
- [ ] CPU/memory after 10 minutes of use and after closing/minimizing Studio; compare to the official app on the same machine.
- [ ] Screen reader/keyboard navigation and all newly localized strings reviewed by speakers.
- [ ] Trusted Windows signing and Mac Developer ID/notarization verified after certificates are configured.

## Suggested bug report

Beta version and source commit:
OS version:
CPU/GPU and memory (optional):
Monitor sizes/scales:
Steps to reproduce:
Expected:
Actual:
Reproduces after restart:
Attachment with personal data removed:
