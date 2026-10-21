from pathlib import Path
import json,hashlib,subprocess,runpy
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
RELEASE='hatch-to-fight-stage-farm-20261022-2'
def lua(value):
    if value is None:return 'nil'
    if isinstance(value,bool):return 'true'if value else'false'
    if isinstance(value,(int,float)):return repr(value)
    if isinstance(value,str):return json.dumps(value,ensure_ascii=False)
    if isinstance(value,list):return '{'+','.join(lua(x)for x in value)+'}'
    return '{'+','.join('['+lua(int(k)if isinstance(k,str)and k.isdigit()else k)+']='+lua(v)for k,v in value.items())+'}'
catalog=json.loads((HERE/'catalog.json').read_text(encoding='utf-8'))
source=(HERE/'ui.lua').read_text(encoding='utf-8').replace('__CATALOG__',lua(catalog))
for marker,name in [('HTF_ADAPTER','adapter.lua'),('HTF_CORE','core.lua')]:
    assert source.count('-- '+marker)==1
    source=source.replace('-- '+marker,(HERE/name).read_text(encoding='utf-8'))
gui=runpy.run_path(str(ROOT/'tools/anime-dice/dependency.py'))['read'](ROOT)
checksum=0
for b in gui:checksum=(checksum*33+b)%4294967296
source=source.replace('__OURO_LEN__',str(len(gui))).replace('__OURO_HASH__',str(checksum))
entry=ROOT/'hatch-to-fight-test.lua';entry.write_text(source,encoding='utf-8',newline='\n')
subprocess.run([str(ROOT.parent/'luau-tools/luau-compile.exe'),'--null',str(entry)],check=True,capture_output=True)
manifest={'release':RELEASE,'place_id':127231827405683,'universe_id':10768001644,
 'entry_sha256':hashlib.sha256(entry.read_bytes()).hexdigest(),'live_verified':False,
 'stage_grounding':'Actual stage Floor bounds; streamed floor required; no guessed gate offset',
 'farm_progression':'FightStage/enemy acknowledgment, facing, attack cooldowns, server clear/win before next target',
 'one_hit_supported':False,'damage_setup':'Highest catalog single-hit pet and an owned Fight race slot; no arbitrary damage argument',
 'main_loader_changed':False,'godmode_supported':False,'server_damage_bypass_verified':False,
 'startup_game_remote_requests':False,'module_require_in_game':False,
 'profile_autoload':'Only after explicitly saving AutoLoad=true; may restore enabled jobs',
 'godmode_evidence':'Client HUD reads replicated PlayerGui.PetHP/PetMaxHP. No authoritative HP setter or verified damage bypass in the supplied dump.',
 'known_contract_limits':['RequestTrainHit is present but its arguments/acceptance are not demonstrated by the captured native sender.',
 'Stage 60 movement does not establish server stage unlock or reward eligibility.',
 'Auto retreat may be rejected while fighting; it is not godmode.',
 'Only owned-key crates are opened. Premium crates require the native purchase flow.'],
 'sources':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()for p in HERE.glob('*.lua')},
 'catalog_sha256':hashlib.sha256((HERE/'catalog.json').read_bytes()).hexdigest(),
 'gui_sha256':hashlib.sha256(gui).hexdigest()}
(ROOT/'hatch-to-fight-test-release.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS compiled standalone HatchToFight test:',entry.stat().st_size,'bytes')
