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
steal_publication='78b26f780aa2fcb0992aab82640aa3f94f32a1aa'
assert sha(blob(steal_publication,'loader'))==release['main_loader_sha256']
current=(root/'tools/blue-gui/router.lua').read_text(encoding='utf-8')
old=blob('e4c2fe339b3c5fd26c9ec45467120307a430b31d','tools/blue-gui/router.lua').decode()
old=old.replace('e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="chilli-startup-fix-20261019',release['delegate_commit']+'",Version="'+release['release'])
old=old.replace('entry.File=="devil-steal-an-egg.lua"and"chilli-startup-fix-20261019','entry.File=="devil-steal-an-egg.lua"and"'+release['release'])
published=blob(steal_publication,'tools/blue-gui/router.lua').decode()
assert published==old,'Unexpected router changes in the Steal publication'
steal_row=lambda text:re.search(r'^    \{Name="Steal an Egg"[^\n]+',text,re.M)[0]
assert steal_row(current)==steal_row(published),'Current Steal dependency chain changed'
print('PASS complete immutable chain: loader -> delegate -> GUI -> adapted runtime; current Steal pin preserved; publication router verified')
