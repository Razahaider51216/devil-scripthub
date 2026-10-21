from pathlib import Path
import hashlib, importlib.util, json, subprocess
import dependency
import xml.etree.ElementTree as ET
from PIL import Image

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('blue_entries', root / 'tools/blue-gui/build-entries.py')
blue = importlib.util.module_from_spec(spec)
spec.loader.exec_module(blue)
module_ref = json.loads((root / 'devil-blue-gui-release.json').read_text())['module_commit']
source = (here / 'ui.lua').read_text(encoding='utf-8')
for marker, name in [('ANIME_WEBHOOK','webhook.lua'),('ANIME_PLANNER','planner.lua'),('ANIME_ADAPTER','adapter.lua'),('ANIME_CORE','core.lua'),('ANIME_PRESENTATION','presentation.lua'),('ANIME_SETTINGS','settings.lua'),('TEST_TRANSLATIONS','translations.lua')]:
    assert source.count('-- ' + marker) == 1
    source = source.replace('-- ' + marker, (here / name).read_text(encoding='utf-8'))
source=source.replace('-- ANIME_TOWER_CATALOG',(here/'tower-catalog.lua').read_text(encoding='utf-8'))
source = source.replace('-- SHARED_BLUE_BOOTSTRAP', blue.prefix(module_ref))
source = source.replace('-- AUTO_EXECUTE_BOOTSTRAP', (root / 'tools/auto-execute/bootstrap.lua').read_text(encoding='utf-8'))
svg = root / 'assets/devil-candy.svg'
art = ET.fromstring(svg.read_bytes())
assert art.attrib['viewBox'] == '0 0 24 24'
candy_paths = [[float(n) for n in path.attrib['points'].replace(',', ' ').split()]
               for path in art.findall('.//{http://www.w3.org/2000/svg}polyline')]
assert len(candy_paths) == 3 and all(len(p) >= 4 and len(p) % 2 == 0 for p in candy_paths)
source = source.replace('__CANDY_PATHS__', '{' + ','.join('{' + ','.join(map(str, p)) + '}' for p in candy_paths) + '}')
# Native GUI rectangles keep the official silhouette available on executors
# without custom-asset support, with no extra network request at startup.
discord = root / 'assets/discord-logo.png'
mask = Image.open(discord).convert('RGBA').resize((64,64), Image.Resampling.LANCZOS).getchannel('A')
rects, active = [], {}
for y in range(64):
    runs, x = set(), 0
    while x < 64:
        if mask.getpixel((x,y)) < 128:
            x += 1
            continue
        start = x
        while x < 64 and mask.getpixel((x,y)) >= 128:
            x += 1
        runs.add((start,x-start))
    for run in list(active):
        if run not in runs:
            rects.append(active.pop(run))
    for start,width in sorted(runs):
        if (start,width) in active:
            active[start,width][3] += 1
        else:
            active[start,width] = [start,y,width,1]
rects.extend(active.values())
source = source.replace('__DISCORD_RECTS__', '{' + ','.join('{' + ','.join(map(str,r)) + '}' for r in rects) + '}')
ouro = dependency.read(root)
source = source.replace('__OURO_LEN__', str(len(ouro))).replace('__OURO_HASH__', str(blue.checksum(ouro)))
public = root / 'anime-dice-test.lua'
pack_spec=importlib.util.spec_from_file_location('anime_protection',root/'tools/protection/pack.py')
protection=importlib.util.module_from_spec(pack_spec);pack_spec.loader.exec_module(protection)
protection.RELEASE='anime-dice-webhook-20261022-2'
public.write_bytes(protection.pack(source,public.name))
subprocess.run([str(root.parent / 'luau-tools/luau-compile.exe'), '--null', str(public)], check=True)
audit = json.loads((root / 'devil-blue-gui-router-audit.json').read_text(encoding='utf-8'))
routes = audit['routes']
anime_route = next((r for r in routes if r['File'] == 'anime-dice-test.lua'), None)
manifest = {'release':'anime-dice-webhook-20261022-2','place_id':113290951185459,'universe_id':10708913337,
    'production_router_changed':anime_route is not None,'live_game_verified':False,'all_automation_defaults_off':True,
    'saved_settings_auto_load':True,'saved_automation_restored_after_initialization':True,
    'theme_module_commit':module_ref,'ouroflow_commit':'c8251f76f74d9942114ebccb0564aa0ac196320a',
    'ouroflow_sha256':hashlib.sha256(ouro).hexdigest(),'entry_sha256':hashlib.sha256(public.read_bytes()).hexdigest(),
    'candy_svg_sha256':hashlib.sha256(svg.read_bytes()).hexdigest(),
    'discord_logo_sha256':hashlib.sha256(discord.read_bytes()).hexdigest(),
    'auto_execute_enabled':True,
    'webhook_opt_in':True,'webhook_mock_http_verified':True,'webhook_no_live_delivery_test':True,
    'single_startup_vm_boundary':True,'native_gameplay_callbacks':True,
    'native_entry_sha256':hashlib.sha256(source.encode()).hexdigest(),
    'tower_selection_native_images_difficulty_floors':True,
    'tower_metadata_fallback':True,'catalog_retry_single_worker':True,'independent_choice_refresh':True,
    'pumpkin_unit_native_model_previews':True,'pumpkin_preview_limit':6,'pumpkin_preview_creations_per_tick':1,
    'auto_execute_sha256':hashlib.sha256((root / 'tools/auto-execute/bootstrap.lua').read_bytes()).hexdigest(),
    'sources':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in here.glob('*.lua')}}
if anime_route:
    manifest['main_loader_entry_commit'] = anime_route['Commit']
    manifest['main_loader_sha256'] = audit['public_loader_sha256']
(root / 'anime-dice-test-release.json').write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8', newline='\n')
print('PASS built Anime Dice entry; main loader integrated:', anime_route is not None)
