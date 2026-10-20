from pathlib import Path
import hashlib,json,re,subprocess
ROOT=Path(__file__).resolve().parents[2]
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
release=json.loads((ROOT/'anime-dice-test-release.json').read_text())
route=next(r for r in audit['routes'] if r['File']=='anime-dice-test.lua')
entry=subprocess.check_output(['git','show',route['Commit']+':anime-dice-test.lua'],cwd=ROOT)
assert entry==(ROOT/'anime-dice-test.lua').read_bytes()
assert hashlib.sha256(entry).hexdigest()==release['entry_sha256']==audit['anime_dice_entry_sha256']
assert route['Version']==release['release'] and route['Commit']==release['main_loader_entry_commit']
before=subprocess.check_output(['git','show',audit['anime_router_baseline_commit']+':tools/blue-gui/router.lua'],cwd=ROOT).decode()
row='    {Name="Anime Dice",Universe=10708913337,Place=113290951185459,File="anime-dice-test.lua",Commit="'+route['Commit']+'",Version="'+route['Version']+'"},'
expected,n=re.subn(r'^    \{Name="Anime Dice"[^\n]+',lambda _:row,before,flags=re.M);assert n==1
expected,n=re.subn(r'(for _,entry in ipairs\(games\)do if entry.File=="anime-dice-test.lua"then entry.Version=")[^"]+',lambda m:m[1]+route['Version'],expected);assert n==1
current=(ROOT/'tools/blue-gui/router.lua').read_text(encoding='utf-8')
assert expected==current,'Non-Anime router bytes changed'
assert hashlib.sha256(current.encode()).hexdigest()==audit['after_native_sha256']
assert hashlib.sha256((ROOT/'loader').read_bytes()).hexdigest()==audit['public_loader_sha256']==release['main_loader_sha256']
print('PASS Anime Dice immutable entry and main hashes; all non-Anime router bytes preserved')
