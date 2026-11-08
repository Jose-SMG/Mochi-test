import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
const read = p => readFileSync(new URL(`../${p}`, import.meta.url), 'utf8');
const metadata = JSON.parse(read('mochi-preview.json'));
const tauri = JSON.parse(read('windows/src-tauri/tauri.conf.json'));
assert.equal(metadata.product_name, 'Coucou');
assert.equal(metadata.display_name, 'Coucou');
assert.equal(metadata.official_release, false);
assert.notEqual(metadata.identifier, 'fr.louisraille.coucou');
assert.notEqual(metadata.identifier, 'fr.louisraille.NotchBuddy');
assert.equal(tauri.identifier, metadata.identifier);
assert.equal(tauri.productName, metadata.product_name);
assert.equal(tauri.app.windows[0].title, metadata.display_name);
assert.equal(tauri.bundle.windows.wix.upgradeCode, '13438c9a-7818-5d98-838b-49ce80db1008', 'keep the original preview MSI upgrade identity');
assert.equal(tauri.version, metadata.application_version);
assert.equal(tauri.bundle.windows.wix.version, metadata.windows_msi_version);
assert.equal(JSON.parse(read('windows/package.json')).version, tauri.version);
assert.equal(metadata.agent_hooks_enabled, false);
assert.equal(metadata.automatic_updates_enabled, false);
const mac = read('NotchBuddy/project.yml').split('\ntargets:')[1].split('\n  CoucouAppStore:')[0];
assert(mac.includes(`PRODUCT_BUNDLE_IDENTIFIER: ${metadata.identifier}`));
assert(mac.includes(`PRODUCT_NAME: ${metadata.product_name}`));
assert(mac.includes(`CFBundleDisplayName: ${metadata.display_name}`));
assert(mac.includes(`CFBundleShortVersionString: "${metadata.application_version}"`));
assert(!mac.includes('PHONE_LINK'), 'preview must not use the upstream iCloud container');
for (const file of ['NotchBuddy/Sources/App/PreviewIdentity.swift', 'windows/preview-identity.rs']) {
  const text = read(file);
  assert(text.includes(metadata.identifier));
  assert(text.includes(metadata.data_directory));
  assert(text.includes(`name = "${metadata.display_name}"`) || text.includes(`NAME: &str = "${metadata.display_name}"`));
}
const uninstaller = read('windows/src-tauri/nsis/hooks.nsh');
for (const line of uninstaller.split('\n').filter(l => /^\s*(RMDir|Delete)\b/.test(l))) {
  assert(line.includes('$LOCALAPPDATA\\MochiStudioPreview\\'), `Unsafe removal: ${line}`);
}
assert(read('scripts/dev-install.sh').includes('[[ "$EXISTING" == "$ID" ]]'));
assert(!read('scripts/dev-install.sh').includes('pkill -x Coucou'));
assert(read('NotchBuddy/Sources/App/ClaudeService.swift').includes(`static let service = "${metadata.identifier}"`));
assert(read('windows/src-tauri/src/secrets.rs').includes('preview_identity::IDENTIFIER'));
assert(read('windows/src-tauri/src/platform/windows.rs').includes('preview_identity::DATA_DIRECTORY'));
assert(read('windows/src-tauri/src/pipe.rs').includes('preview_identity::PIPE_PREFIX'));
assert(read('windows/hook/src/win.rs').includes('preview_identity::PIPE_PREFIX'));
console.log('Preview identifiers, versions, credentials, data, transport and uninstall scope are independent.');

const installer = read('windows/src-tauri/installer/installer.nsi');
assert.equal(tauri.bundle.windows.nsis.template, 'installer/installer.nsi');
assert.equal(tauri.bundle.windows.wix.template, 'installer/main.wxs');
assert(installer.includes('!define INSTALLNAMESPACE "Coucou Community"'));
assert(installer.includes('Uninstall\\${INSTALLNAMESPACE}'));
assert(installer.includes('"PreviewIdentifier"'));
assert(read('windows/src-tauri/src/lib.rs').includes('.app_name(preview_identity::IDENTIFIER)'));
assert(read('windows/src-tauri/Cargo.toml').includes('default-run = "coucou"'));
assert(read('windows/src-tauri/src/mochi_studio.rs').includes('.title(crate::preview_identity::NAME)'));
assert(read('NotchBuddy/Sources/App/MochiStudioWindow.swift').includes('view.title=PreviewIdentity.name'));
