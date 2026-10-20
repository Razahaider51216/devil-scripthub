from pathlib import Path
import hashlib,json,subprocess
ROOT=Path(__file__).resolve().parents[2]
manifest=json.loads((ROOT/'climb-eggs-release.json').read_text())
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
entry=(ROOT/'climb-for-eggs.lua').read_bytes()
assert hashlib.sha256(entry).hexdigest()==manifest['entry_sha256']==audit['climb_entry_sha256']
assert subprocess.check_output(['git','show',manifest['runtime_commit']+':climb-for-eggs.lua'],cwd=ROOT)==entry
loader=(ROOT/'loader').read_bytes()
assert hashlib.sha256(loader).hexdigest()==manifest['main_loader_sha256']==audit['public_loader_sha256']
old=subprocess.check_output(['git','show','78b26f780aa2fcb0992aab82640aa3f94f32a1aa:tools/blue-gui/router.lua'],cwd=ROOT).decode()
old=old.replace('e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="climb-fly-speed-10',manifest['runtime_commit']+'",Version="'+manifest['release'])
old=old.replace('entry.File=="climb-for-eggs.lua"and"climb-fly-speed-10','entry.File=="climb-for-eggs.lua"and"'+manifest['release'])
current=(ROOT/'tools/blue-gui/router.lua').read_text(encoding='utf-8')
assert old==current,'Changes outside the Climb pin/version'
assert hashlib.sha256(current.encode()).hexdigest()==audit['after_native_sha256']
print('PASS Climb immutable entry/main-loader hashes; all other router bytes preserved')
