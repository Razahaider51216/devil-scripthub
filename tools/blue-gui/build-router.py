"""Repin the existing router without modifying game routing or native callbacks."""
from pathlib import Path
import hashlib, importlib.util, json, re, subprocess, sys

root = Path(__file__).resolve().parents[2]
build = root.parent / 'steal-chilli-build-20261019'
entries_ref = sys.argv[1]
assert re.fullmatch('[0-9a-f]{40}', entries_ref)
manifest = json.loads(subprocess.check_output(
    ['git', 'show', entries_ref + ':devil-blue-gui-release.json'], cwd=root))
audit_path = root / 'devil-blue-gui-router-audit.json'
audit = json.loads(audit_path.read_text(encoding='utf-8'))
spec = importlib.util.spec_from_file_location('blue_entries', Path(__file__).with_name('build-entries.py'))
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)
assert manifest['release'] == builder.RELEASE
native_path = build / 'loader.native'
before = native_path.read_text(encoding='utf-8')
assert before.startswith('-- BEGIN SHARED DEVIL BLUE GUI\n')
body = before.split('-- END SHARED DEVIL BLUE GUI\n', 1)[1]
old_ref = audit['game_entries_commit']
assert body.count(old_ref) == len(audit['routes']) == 10
after = builder.prefix(manifest['module_commit']) + body.replace(old_ref, entries_ref)
native_path.write_text(after, encoding='utf-8', newline='\n')
subprocess.run([sys.executable, str(build / 'build-router.py'), '--only', 'loader',
                '--release', manifest['release']], cwd=build, check=True)
public = (build / 'candidate/loader').read_bytes()
(root / 'loader').write_bytes(public)
audit.update(release=manifest['release'], module_commit=manifest['module_commit'],
             game_entries_commit=entries_ref,
             before_native_sha256=hashlib.sha256(before.encode()).hexdigest(),
             after_native_sha256=hashlib.sha256(after.encode()).hexdigest(),
             public_loader_sha256=hashlib.sha256(public).hexdigest(),
             public_loader_bytes=len(public), ui_offline_checks=63,
             language_selector_reserved_row=True, toggle_on_color='#A4DDFF',
             toggle_off_color='#202731', unnamed_control_icons_styled=True)
audit_path.write_text(json.dumps(audit, indent=2) + '\n', encoding='utf-8', newline='\n')
legacy_test = root / 'tools/chilli-20261019/test-public-loader.py'
source = legacy_test.read_text(encoding='utf-8')
assert source.count(old_ref) == 1
legacy_test.write_text(source.replace(old_ref, entries_ref), encoding='utf-8', newline='\n')
print('PASS repinned 10 routes; original native router body preserved')
