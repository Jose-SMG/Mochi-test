# Installer templates

Derived from Tauri CLI `tauri-cli-v2.12.0`:

- https://github.com/tauri-apps/tauri/blob/tauri-cli-v2.12.0/crates/tauri-bundler/src/bundle/windows/nsis/installer.nsi
- https://github.com/tauri-apps/tauri/blob/tauri-cli-v2.12.0/crates/tauri-bundler/src/bundle/windows/msi/main.wxs

The bundled MIT license applies to the original templates. Local changes separate the exact visible name Coucou from the previous private install namespace. NSIS retains its old registry and install-folder keys; MSI retains its upgrade GUID and stores its product-code marker in a separate per-machine registry component. Detection of MSI installs requires the previous distinct name or the product-code marker stored under the private bundle identifier, never the official name/publisher alone. Startup removal uses the private bundle identifier. Obsolete shortcut labels are removed only when their target belongs to this installation.

Windows CI installs the previously published installer, upgrades it, checks the executable/registered name and Start shortcut, and verifies that room preferences and official app files/registry values survive.
