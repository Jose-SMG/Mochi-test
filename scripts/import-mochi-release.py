"""Verify the published beta byte for byte before importing it into this repository."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--input', type=Path, default=root / 'build/import')
parser.add_argument('--output', type=Path, default=root / 'build/import-ready')
args = parser.parse_args()
config = json.loads((root / 'distribution/import.json').read_text())
assert config['distribution_permission_confirmed'] is True
assert config['official_release'] is False
assert config['source_repository'] == 'Jose-SMG/Pruebas'
assert config['target_repository'] == 'Jose-SMG/Mochi-test'
assert os.environ.get('GITHUB_REPOSITORY', config['target_repository']) == config['target_repository']
assert config['tag'] == 'mochi-studio-v0.6.0-beta.1'
subprocess.run(['git', 'merge-base', '--is-ancestor', config['source_commit'], 'HEAD'], cwd=root, check=True)
subprocess.run(['git', 'diff', '--exit-code', config['source_commit'], 'HEAD', '--',
                'NotchBuddy', 'windows', 'shared', 'mochi-preview.json'], cwd=root, check=True)

expected = {item['name']: item for item in config['assets']}
assert len(expected) == 8
assert {file.name for file in args.input.iterdir()} == set(expected), 'Unexpected or missing release assets'
args.output.mkdir(parents=True, exist_ok=True)
for name, item in expected.items():
    assert Path(name).name == name
    file = args.input / name
    assert file.is_file() and file.stat().st_size == item['size_bytes'], name
    assert hashlib.sha256(file.read_bytes()).hexdigest() == item['sha256'], name
    shutil.copy2(file, args.output / name)

for platform in ['macOS', 'Windows']:
    manifest = json.loads((args.input / f'{platform}-build-manifest.json').read_text())
    assert manifest['source_commit'] == config['source_commit']
    assert manifest['source_base'] == config['upstream_commit']
    assert manifest['version'] == config['version'] and manifest['official_release'] is False
    for item in manifest['artifacts']:
        original = expected[item['name']]
        assert item['size_bytes'] == original['size_bytes'] and item['sha256'] == original['sha256']

release = json.loads((args.input / 'release-manifest.json').read_text())
assert release['source_commit'] == config['source_commit'] and release['official_release'] is False
for line in (args.input / 'SHA256SUMS.txt').read_text().splitlines():
    digest, name = line.split('  ', 1)
    assert expected[name]['sha256'] == digest

provenance = {
    'source_repository': config['source_repository'],
    'source_release': f"https://github.com/{config['source_repository']}/releases/tag/{config['tag']}",
    'target_repository': config['target_repository'],
    'source_commit': config['source_commit'],
    'repository_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip(),
    'byte_for_byte_verified': True,
    'rebuilt_during_migration': False,
    'native_interaction_qa': 'Incomplete; migration does not mark native drag/follow/jump validation as passed.',
    'assets': config['assets'],
}
(args.output / 'migration-provenance.json').write_text(json.dumps(provenance, indent=2) + '\n')
print('Verified all 8 original assets; prepared 9 release files including migration provenance.')
