"""Verify every local production dependency against the immutable Git object."""
from pathlib import Path
import hashlib,json,re,subprocess
root=Path(__file__).resolve().parents[2]
release=json.loads((root/'devil-steal-update-release.json').read_text())
recovery=json.loads((root/'devil-chilli-native-ui-recovery.json').read_text())
audit=json.loads((root/'devil-blue-gui-router-audit.json').read_text())
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=root)
def sha(data):return hashlib.sha256(data).hexdigest()
gui=blob(release['gui_commit'],'devil-steal-an-egg-chilli-recovered-ui-test.lua')
assert gui==(root/'devil-steal-an-egg-chilli-recovered-ui-test.lua').read_bytes()
assert gui==(root/'devil-steal-an-egg-chilli-main-gui.lua').read_bytes()
assert sha(gui)==release['gui_sha256'] and len(gui)==release['gui_bytes']
text=gui.decode()
url=re.search(r'originalGameSource=game:HttpGet\("([^"\n]+)"',text)[1]
commit=url.split('/')[-2]
runtime=blob(commit,'devil-chilli-native-ui-runtime.lua')
assert runtime==(root/'devil-chilli-native-ui-runtime.lua').read_bytes()
assert sha(runtime)==recovery['source_sha256']
assert f'#originalGameSource=={len(runtime)}' in text
assert f'assert(checksum=={recovery["transfer_checksum"]},' in text
assert release['delegate_sha256']==sha(blob(release['delegate_commit'],'devil-steal-an-egg.lua'))
assert release['delegate_sha256']==sha((root/'devil-steal-an-egg.lua').read_bytes())
assert sha((root/'loader').read_bytes())==audit['public_loader_sha256']
# The Steal manifest records its publication, while later map-only releases
# may legitimately repin another route in the current root loader.
assert sha((root/'loader').read_bytes())==release['main_loader_sha256']
current=(root/'tools/blue-gui/router.lua').read_text(encoding='utf-8')
old=blob(release['router_baseline_commit'],'tools/blue-gui/router.lua').decode()
expected,count=re.subn(r'(^    \{Name="Steal an Egg"[^\n]*Commit=")[0-9a-f]+("[^\n]*Version=")[^"]+',lambda m:m[1]+release['delegate_commit']+m[2]+release['release'],old,flags=re.M)
assert count==1
expected,count=re.subn(r'(entry.File=="devil-steal-an-egg.lua"and")[^"]+',lambda m:m[1]+release['release'],expected)
assert count==1 and current==expected,'Changes outside the Steal pin/version'
print('PASS complete immutable chain: loader -> delegate -> GUI -> adapted runtime; current Steal pin preserved; publication router verified')
