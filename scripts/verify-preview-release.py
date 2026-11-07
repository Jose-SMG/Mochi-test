"""Publish only native artifacts built by this run from this exact repository source."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
preview = json.loads((root / 'mochi-preview.json').read_text())
incoming, output = map(Path, sys.argv[1:])
source = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
assert source == os.environ['GITHUB_SHA']
assert os.environ['GITHUB_REPOSITORY'] == 'Jose-SMG/Mochi-test'
output.mkdir(parents=True, exist_ok=True)
files = []
platforms = {}
for platform, folder, extensions in [('macOS','Mochi-Studio-Preview-macOS',{'.dmg'}), ('Windows','Mochi-Studio-Preview-Windows',{'.exe','.msi','.zip'})]:
    directory = incoming / folder
    manifest = json.loads((directory / 'build-manifest.json').read_text(encoding='utf-8-sig'))
    assert manifest['source_commit'] == source
    assert manifest['source_repository'] == 'Jose-SMG/Mochi-test'
    assert manifest['identifier'] == preview['identifier']
    assert manifest['product'] == preview['product_name']
    assert manifest['version'] == preview['version']
    assert manifest['agent_hooks_enabled'] is False
    assert manifest['automatic_updates_enabled'] is False
    assert manifest['platform'] == platform
    assert {Path(a['name']).suffix for a in manifest['artifacts']} == extensions
    for item in manifest['artifacts']:
        assert Path(item['name']).name == item['name']
        assert item['name'].startswith('Mochi-Studio-Preview-' + preview['version'] + '-')
        artifact = directory / item['name']
        assert artifact.stat().st_size == item['size_bytes']
        assert hashlib.sha256(artifact.read_bytes()).hexdigest() == item['sha256']
        shutil.copy2(artifact, output / artifact.name)
        files.append(item)
    shutil.copy2(directory / 'build-manifest.json', output / f'{platform}-build-manifest.json')
    platforms[platform] = manifest
proof_path = incoming / 'Mochi-Studio-Preview-Windows/windows-coexistence.json'
proof = json.loads(proof_path.read_text(encoding='utf-8-sig'))
assert proof['passed'] is True and proof['source_commit'] == source
shutil.copy2(proof_path, output / proof_path.name)
(output / 'SHA256SUMS.txt').write_text(''.join(f"{f['sha256']}  {f['name']}\n" for f in files))
(output / 'release-manifest.json').write_text(json.dumps({'version':preview['version'],'source_commit':source,'source_repository':'Jose-SMG/Mochi-test','official_release':False,'platforms':platforms,'files':files},indent=2)+'\n')
print('Both native platforms, exact source, hashes, independent identity and Windows coexistence verified.')
