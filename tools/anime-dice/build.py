from pathlib import Path
import hashlib, importlib.util, json, subprocess
import dependency
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('blue_entries', root / 'tools/blue-gui/build-entries.py')
blue = importlib.util.module_from_spec(spec)
spec.loader.exec_module(blue)
module_ref = json.loads((root / 'devil-blue-gui-release.json').read_text())['module_commit']
source = (here / 'ui.lua').read_text(encoding='utf-8')
for marker, name in [('ANIME_PLANNER','planner.lua'),('ANIME_ADAPTER','adapter.lua'),('ANIME_CORE','core.lua'),('ANIME_PRESENTATION','presentation.lua'),('TEST_TRANSLATIONS','translations.lua')]:
    assert source.count('-- ' + marker) == 1
    source = source.replace('-- ' + marker, (here / name).read_text(encoding='utf-8'))
source = source.replace('-- SHARED_BLUE_BOOTSTRAP', blue.prefix(module_ref))
svg = root / 'assets/devil-candy.svg'
art = ET.fromstring(svg.read_bytes())
assert art.attrib['viewBox'] == '0 0 24 24'
candy_paths = [[float(n) for n in path.attrib['points'].replace(',', ' ').split()]
               for path in art.findall('.//{http://www.w3.org/2000/svg}polyline')]
assert len(candy_paths) == 3 and all(len(p) >= 4 and len(p) % 2 == 0 for p in candy_paths)
source = source.replace('__CANDY_PATHS__', '{' + ','.join('{' + ','.join(map(str, p)) + '}' for p in candy_paths) + '}')
ouro = dependency.read(root)
source = source.replace('__OURO_LEN__', str(len(ouro))).replace('__OURO_HASH__', str(blue.checksum(ouro)))
public = root / 'anime-dice-test.lua'
public.write_text(source, encoding='utf-8', newline='\n')
subprocess.run([str(root.parent / 'luau-tools/luau-compile.exe'), '--null', str(public)], check=True)
manifest = {'release':'anime-dice-test-20261020-6','place_id':113290951185459,'universe_id':10708913337,
    'production_router_changed':False,'live_game_verified':False,'all_automation_defaults_off':True,
    'theme_module_commit':module_ref,'ouroflow_commit':'c8251f76f74d9942114ebccb0564aa0ac196320a',
    'ouroflow_sha256':hashlib.sha256(ouro).hexdigest(),'entry_sha256':hashlib.sha256(public.read_bytes()).hexdigest(),
    'candy_svg_sha256':hashlib.sha256(svg.read_bytes()).hexdigest(),
    'sources':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in here.glob('*.lua')}}
(root / 'anime-dice-test-release.json').write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8', newline='\n')
print('PASS built standalone Anime Dice test; production loader unchanged')
