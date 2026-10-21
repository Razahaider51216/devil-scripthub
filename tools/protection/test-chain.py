from pack import *
manifest=json.loads((ROOT/'vm-protection-release.json').read_text())
gui=native((ROOT/'devil-steal-an-egg-chilli-recovered-ui-test.lua').read_text(encoding='utf-8'),'gui')
runtime=(ROOT/'devil-chilli-native-ui-runtime.lua').read_bytes()
assert '/'+manifest['shared_commit']+'/devil-chilli-native-ui-runtime.lua'in gui
assert '#originalGameSource=='+str(len(runtime))in gui
assert 'assert(checksum=='+str(checksum(runtime))+',"Pinned runtime'in gui
delegate=native((ROOT/'devil-steal-an-egg.lua').read_text(encoding='utf-8'),'delegate')
payload=(ROOT/'devil-steal-an-egg-chilli-recovered-ui-test.lua').read_bytes()
assert '/'+manifest['dependencies_commit']+'/devil-steal-an-egg-chilli-recovered-ui-test.lua'in delegate
assert '#source=='+str(len(payload))in delegate
assert 'assert(checksum=='+str(checksum(payload))+',"Pinned script'in delegate
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
baseline=json.loads(subprocess.check_output(['git','show',manifest['baseline_commit']+':devil-blue-gui-router-audit.json'],cwd=ROOT))
retained=0
for current in audit['routes']:
    old=next(r for r in baseline['routes']if r['File']==current['File'])
    assert current['Universe']==old['Universe']and current['Place']==old['Place']
    assert current.get('Version')==old.get('Version')
    if current['File']in manifest['skip_existing']:
        assert current['Commit']==old.get('Commit',baseline['game_entries_commit'])
        retained+=1
assert retained==6
print('PASS protected Steal GUI/runtime checksums and immutable chain; six existing game files and route pins unchanged')
