from pathlib import Path
import hashlib, importlib.util, json, re, subprocess, sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
DUMP = Path(r'C:\Users\Administrator\Downloads\Devilv4\DevilDump_Dumps\ClientRuntimeV8\Run_20261020_222718_1')
sys.path.insert(0, str(ROOT / 'tools/anime-dice'))
import dependency

spec = importlib.util.spec_from_file_location('blue_entries', ROOT / 'tools/blue-gui/build-entries.py')
blue = importlib.util.module_from_spec(spec)
spec.loader.exec_module(blue)
theme_commit = json.loads((ROOT / 'devil-blue-gui-release.json').read_text())['module_commit']
assets = {}
evidence = {}
if DUMP.exists():
    for name in ['0509_ShovelAssets.lua', '0518_DrillAssets.lua', '0519_GearAssets.lua', '0191_PotionAssets.lua']:
        raw = (DUMP / name).read_bytes()
        evidence[name] = hashlib.sha256(raw).hexdigest()
        for key, value in re.findall(r'\["([^"]+)"\]\s*=\s*"(rbxassetid://\d+)"', raw.decode()):
            if key != 'DrinkAnimation':
                assets[key] = value
else:
    recorded=json.loads((HERE/'assets.json').read_text(encoding='utf-8'))
    assets,evidence=recorded['images'],recorded['dump_sources_sha256']
(HERE / 'assets.json').write_text(json.dumps({'images': assets, 'dump_sources_sha256': evidence}, indent=2) + '\n', encoding='utf-8')
source = (HERE / 'ui.lua').read_text(encoding='utf-8')
if DUMP.exists():
    runtime = json.loads(next(DUMP.glob('Runtime_*.json')).read_text(encoding='utf-8-sig'))
    export = next(r for r in runtime['scripts'] if r['path']=='ReplicatedStorage.Shared.EggCatalog')['loadedExport']
    types=next(f for f in export['fields'] if f['name']=='Types')['members']['fields']
    eggs={}
    for row in types:
        fields={f['name']:f.get('value',{}).get('value') for f in row.get('members',{}).get('fields',[])}
        if isinstance(fields.get('Name'),str):
            eggs[row['name']]={k:fields[k] for k in ['Name','Rarity','Tier'] if fields.get(k) is not None}
    assert len(eggs)==84
    (HERE/'catalog.json').write_text(json.dumps({'Egg':eggs},indent=2)+'\n',encoding='utf-8',newline='\n')
catalog=json.loads((HERE/'catalog.json').read_text(encoding='utf-8'))
def lua_value(value):
    if isinstance(value,dict):return '{'+','.join('[%s]=%s'%(json.dumps(k),lua_value(v)) for k,v in value.items())+'}'
    return json.dumps(value,ensure_ascii=False)
source=source.replace('__CATALOG__',lua_value(catalog))
for marker, name in [('V4_POLICY', 'policy.lua'), ('V4_ADAPTER', 'adapter.lua'), ('V4_CORE', 'core.lua'), ('V4_PRESENTATION', 'presentation.lua')]:
    assert source.count('-- ' + marker) == 1
    source = source.replace('-- ' + marker, (HERE / name).read_text(encoding='utf-8'))
source = source.replace('-- SHARED_BLUE_BOOTSTRAP', blue.prefix(theme_commit))
source = source.replace('__ASSETS__', '{' + ','.join('[%s]=%s' % (json.dumps(k), json.dumps(v)) for k, v in assets.items()) + '}')
ouro = dependency.read(ROOT)
source = source.replace('__OURO_LEN__', str(len(ouro))).replace('__OURO_HASH__', str(blue.checksum(ouro)))
entry = ROOT / 'devilv4-test.lua'
entry.write_text(source, encoding='utf-8', newline='\n')
subprocess.run([str(ROOT.parent / 'luau-tools/luau-compile.exe'), '--null', str(entry)], check=True)
manifest = {'release': 'devilv4-test-20261021-1', 'place_id': 121831322352666, 'universe_id': 10765013362,
            'production_router_changed': False, 'live_game_verified': False, 'damage_bypass': False,
            'automation_defaults_off': True, 'saved_profile_restores_explicitly_saved_jobs': True,
            'entry_sha256': hashlib.sha256(entry.read_bytes()).hexdigest(), 'theme_module_commit': theme_commit,
            'ouroflow_sha256': hashlib.sha256(ouro).hexdigest(), 'assets': len(assets),
            'named_egg_types':len(catalog['Egg']),'farm_poll_seconds':0.1,'teleport_settle_seconds':0.06,
            'catalog_sha256':hashlib.sha256((HERE/'catalog.json').read_bytes()).hexdigest(),
            'mining_progress_watchdog':True,'buried_egg_teleport':True,
            'sources': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in HERE.glob('*.lua')}}
(ROOT / 'devilv4-test-release.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8', newline='\n')
print('PASS compiled standalone Devilv4 test:', entry.stat().st_size, 'bytes;', len(assets), 'native icons')
