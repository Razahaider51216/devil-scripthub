"""Build release dependencies bottom-up, without changing gameplay source."""
from pack import *
import re
state_path=WORK/'state.json'
state=json.loads(state_path.read_text())
stage=sys.argv[1]
def write_state():state_path.write_text(json.dumps(state,indent=2)+'\n')
def before(name):return (WORK/(name+'.before.native')).read_text(encoding='utf-8')
def head():return subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
def shared(source):
    if '-- BEGIN SHARED DEVIL BLUE GUI\n'not in source:return source
    ref=state['shared_commit'];data=(ROOT/'devil-blue-gui.lua').read_bytes()
    source,n=re.subn(r'(/devil-scripthub/)[0-9a-f]{40}(/devil-blue-gui.lua)',lambda m:m[1]+ref+m[2],source)
    assert n==1
    source,n=re.subn(r'(#source==)\d+(,"DEVIL blue GUI download size)',lambda m:m[1]+str(len(data))+m[2],source);assert n==1
    source,n=re.subn(r'(assert\(sum==)\d+(,"DEVIL blue GUI checksum)',lambda m:m[1]+str(checksum(data))+m[2],source);assert n==1
    return source
def build(name,source):
    data=pack(source,name);(ROOT/name).write_bytes(data)
    state['artifacts'][name].update(native_sha256=sha(source.encode()),public_sha256=sha(data),bytes=len(data),startup_only=True)
    print('Protected',name,len(data))
if stage=='base':
    for name in ['devil-blue-gui.lua','devil-chilli-native-ui-runtime.lua']:build(name,before(name))
elif stage=='dependencies':
    state['shared_commit']=head()
    if 'break-and-steal-an-egg-runtime.lua'not in state.get('skip_existing',[]):
        build('break-and-steal-an-egg-runtime.lua',shared(before('break-and-steal-an-egg-runtime.lua')))
    name='devil-steal-an-egg-chilli-recovered-ui-test.lua'
    source=shared(before(name));ref=state['shared_commit'];data=(ROOT/'devil-chilli-native-ui-runtime.lua').read_bytes()
    source,n=re.subn(r'(/devil-scripthub/)[0-9a-f]{40}(/devil-chilli-native-ui-runtime.lua)',lambda m:m[1]+ref+m[2],source);assert n==1
    source,n=re.subn(r'#originalGameSource==\d+','#originalGameSource=='+str(len(data)),source);assert n==1
    source,n=re.subn(r'assert\(checksum==\d+,"Pinned runtime','assert(checksum=='+str(checksum(data))+',"Pinned runtime',source);assert n==1
    source,n=re.subn(r'referenceSHA256="[0-9a-f]+"','referenceSHA256="'+sha(data)+'"',source);assert n==1
    source,n=re.subn(r'referenceCommit="[0-9a-f]+"','referenceCommit="'+ref+'"',source);assert n==1
    build(name,source)
    alias='devil-steal-an-egg-chilli-main-gui.lua'
    (ROOT/alias).write_bytes((ROOT/name).read_bytes())
    (WORK/(alias+'.native')).write_text(source,encoding='utf-8',newline='\n')
    state['artifacts'][alias].update(state['artifacts'][name])
elif stage=='games':
    state['dependencies_commit']=head()
    for row in state['routes_before']:
        if row['File']in state.get('skip_existing',[]):continue
        name=row['File'];source=shared(before(name))
        if name=='break-and-steal-an-egg.lua':
            source,n=re.subn(r'(/devil-scripthub/)[0-9a-f]{40}(/break-and-steal-an-egg-runtime.lua)',lambda m:m[1]+state['dependencies_commit']+m[2],source);assert n==1
        elif name=='devil-steal-an-egg.lua':
            gui=(ROOT/'devil-steal-an-egg-chilli-recovered-ui-test.lua').read_bytes()
            source,n=re.subn(r'(/devil-scripthub/)[0-9a-f]{40}(/devil-steal-an-egg-chilli-recovered-ui-test.lua)',lambda m:m[1]+state['dependencies_commit']+m[2],source);assert n==1
            source,n=re.subn(r'(#source==)\d+(,"Pinned script)',lambda m:m[1]+str(len(gui))+m[2],source);assert n==1
            source,n=re.subn(r'(assert\(checksum==)\d+(,"Pinned script)',lambda m:m[1]+str(checksum(gui))+m[2],source);assert n==1
        build(name,source)
    build('ride-a-pet-delta.lua',shared(before('ride-a-pet-delta.lua')))
elif stage=='router':
    state['games_commit']=head()
    source=shared(before('loader'))
    for row in state['routes_before']:
        if row['File']in state.get('skip_existing',[]):continue
        pattern=r'(^    \{Name="'+re.escape(row['Name'])+r'"[^\n]*Commit=")[0-9a-f]{40}("[^\n]+)'
        source,n=re.subn(pattern,lambda m:m[1]+state['games_commit']+m[2],source,flags=re.M);assert n==1,row['Name']
    # Apart from shared-module checks/pins and game commits, the router is exact.
    audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
    baseline_audit=json.loads(subprocess.check_output(['git','show',state['baseline_commit']+':devil-blue-gui-router-audit.json'],cwd=ROOT))
    for row in audit['routes']:
        original=next(r for r in state['routes_before']if r['File']==row['File'])
        row['Commit']=original.get('Commit',baseline_audit['game_entries_commit'])if row['File']in state.get('skip_existing',[])else state['games_commit']
    (ROOT/'tools/blue-gui/router.lua').write_text(source,encoding='utf-8',newline='\n')
    build('loader',source)
    audit.update(protection_release=RELEASE,protection_baseline_commit=state['baseline_commit'],game_entries_commit=state['games_commit'],
        after_native_sha256=sha(source.encode()),public_loader_sha256=state['artifacts']['loader']['public_sha256'],public_loader_bytes=state['artifacts']['loader']['bytes'],
        anime_dice_entry_commit=state['games_commit'],anime_dice_entry_sha256=state['artifacts']['anime-dice-test.lua']['public_sha256'],
        climb_entry_commit=next(r['Commit']for r in audit['routes']if r['File']=='climb-for-eggs.lua'),climb_entry_sha256=state['artifacts']['climb-for-eggs.lua']['public_sha256'],
        steal_entry_commit=state['games_commit'],steal_entry_sha256=state['artifacts']['devil-steal-an-egg.lua']['public_sha256'])
    (ROOT/'devil-blue-gui-router-audit.json').write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8',newline='\n')
    for filename,entry in [('anime-dice-test-release.json','anime-dice-test.lua'),('climb-eggs-release.json','climb-for-eggs.lua'),('devilv4-test-release.json','devilv4-test.lua')]:
        path=ROOT/filename;metadata=json.loads(path.read_text())
        if entry in state.get('skip_existing',[]):
            metadata=json.loads(subprocess.check_output(['git','show',state['baseline_commit']+':'+filename],cwd=ROOT))
            metadata['main_loader_sha256']=state['artifacts']['loader']['public_sha256']
            path.write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8',newline='\n');continue
        metadata.update(protection_release=RELEASE,native_entry_sha256=state['artifacts'][entry]['native_sha256'],entry_sha256=state['artifacts'][entry]['public_sha256'],main_loader_sha256=state['artifacts']['loader']['public_sha256'])
        if filename=='climb-eggs-release.json':metadata['runtime_commit']=state['games_commit']
        else:metadata['main_loader_entry_commit']=state['games_commit']
        path.write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8',newline='\n')
    metadata=json.loads((ROOT/'devil-steal-update-release.json').read_text())
    metadata.update(protection_release=RELEASE,delegate_commit=state['games_commit'],delegate_sha256=state['artifacts']['devil-steal-an-egg.lua']['public_sha256'],
        gui_commit=state['dependencies_commit'],gui_sha256=state['artifacts']['devil-steal-an-egg-chilli-recovered-ui-test.lua']['public_sha256'],
        gui_bytes=state['artifacts']['devil-steal-an-egg-chilli-recovered-ui-test.lua']['bytes'],main_loader_sha256=state['artifacts']['loader']['public_sha256'])
    (ROOT/'devil-steal-update-release.json').write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8',newline='\n')
    recovery=json.loads((ROOT/'devil-chilli-native-ui-recovery.json').read_text())
    data=(ROOT/'devil-chilli-native-ui-runtime.lua').read_bytes()
    recovery.update(protection_release=RELEASE,native_source_sha256=state['artifacts']['devil-chilli-native-ui-runtime.lua']['native_sha256'],source_sha256=sha(data),source_bytes=len(data),transfer_checksum=checksum(data))
    (ROOT/'devil-chilli-native-ui-recovery.json').write_text(json.dumps(recovery,indent=2)+'\n',encoding='utf-8',newline='\n')
    module=json.loads((ROOT/'devil-blue-gui-release.json').read_text())
    module.update(protection_release=RELEASE,module_commit=state['shared_commit'],module_sha256=state['artifacts']['devil-blue-gui.lua']['public_sha256'])
    (ROOT/'devil-blue-gui-release.json').write_text(json.dumps(module,indent=2)+'\n',encoding='utf-8',newline='\n')
    state.update(architecture='VM startup boundary / native gameplay and UI callbacks',live_verified=False,history_rewritten=False)
    state['routes_after']=audit['routes']
    (ROOT/'vm-protection-release.json').write_text(json.dumps(state,indent=2)+'\n',encoding='utf-8',newline='\n')
else:raise ValueError(stage)
write_state()
