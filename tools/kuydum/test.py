from pathlib import Path
import json,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'tools/protection'))
from pack import *
m=json.loads((ROOT/'kuydum-release.json').read_text())
sources={}
for name,row in m['artifacts'].items():
 data=(ROOT/name).read_bytes();assert sha(data)==row['public_sha256']and len(data)==row['bytes']
 source=native(data.decode('utf-8'),name);assert sha(source.encode())==row['native_sha256'];sources[name]=source
 assert 'KUYDUM HUB 'in data.decode('utf-8')[:200]
print('PASS all three protected KUYDUM startup artifacts match exact native compilation input')
logo=(ROOT/'assets/kuydumhub.jpg').read_bytes()
assert sha(logo)==m['logo_sha256']and logo==Path('C:/Users/Administrator/Downloads/kuydumhub.jpg').read_bytes()
gui=sources['kuydum-steal-gui.lua'];theme=sources['kuydum-theme.lua']
assert 'Name="KUYDUM HUB"'in gui and 'https://discord.gg/tCnZhrBcM'in gui
assert 'local loading=(function()'not in gui and 'scope.DevilHubLoadScreen'not in gui
assert 'https://discord.gg/fDwPCmpkkh'not in gui and 'Theme="Abyss"'not in gui
assert m['theme_commit']+'/kuydum-theme.lua'in gui and '#source=='+str((ROOT/'kuydum-theme.lua').stat().st_size)in gui
for r,g,b in re.findall(r'Color3.fromRGB\((\d+),(\d+),(\d+)\)',theme):assert r==g==b
runtime=re.search(r'originalGameSource=game:HttpGet\("([^"\n]+)"',gui)[1]
ref=runtime.split('/')[-2]
data=subprocess.check_output(['git','show',ref+':devil-chilli-native-ui-runtime.lua'],cwd=ROOT)
assert data==(ROOT/'devil-chilli-native-ui-runtime.lua').read_bytes(),'fork changed shared gameplay runtime'
for name in ['loader','devil-steal-an-egg.lua','devil-steal-an-egg-chilli-recovered-ui-test.lua','devil-blue-gui.lua','devil-chilli-native-ui-runtime.lua']:
 assert subprocess.check_output(['git','show',m['base_commit']+':'+name],cwd=ROOT)==(ROOT/name).read_bytes(),name+' changed'
def run(name,source):
 path=WORK/(name+'.generated.luau');path.write_text(source,encoding='utf-8',newline='\n')
 r=subprocess.run([str(CLI),str(path)],capture_output=True,timeout=40)
 if r.returncode:print(r.stderr.decode('utf-8'));r.check_returncode()
 print(r.stdout.decode('utf-8').strip())
# Binary logo contents are not inspected by the Lua UI fixture, but length is.
scope='local ENTRY='+literal(sources['kuydum-steal-an-egg.lua'])+'\nlocal GUI='+literal((ROOT/'kuydum-steal-gui.lua').read_text(encoding='utf-8'))+'\nlocal LOGO=string.rep("x",'+str(len(logo))+')\n'
old_ref='a0b8f23'
old_entry=native(subprocess.check_output(['git','show',old_ref+':kuydum-steal-an-egg.lua'],cwd=ROOT).decode('utf-8'),'old-entry')
old_gui=subprocess.check_output(['git','show',old_ref+':kuydum-steal-gui.lua'],cwd=ROOT).decode('utf-8')
old_fixture='local ENTRY='+literal(old_entry)+'\nlocal GUI='+literal(old_gui)+'\nlocal LOGO=string.rep("x",'+str(len(logo))+')\n'+(HERE/'scope-tests.luau').read_text(encoding='utf-8')
old_path=WORK/'kuydum-api-baseline.generated.luau';old_path.write_text(old_fixture,encoding='utf-8',newline='\n')
old_result=subprocess.run([str(CLI),str(old_path)],capture_output=True,timeout=40)
assert old_result.returncode!=0 and b'missing executor APIs in private _G'in old_result.stderr,old_result.stderr
print('PASS reproduced missing executor APIs against actual previous public KUYDUM entry')
run('kuydum-scope',scope+(HERE/'scope-tests.luau').read_text(encoding='utf-8'))
run('kuydum-theme',(ROOT/'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')+(HERE/'theme-tests.luau').read_text(encoding='utf-8').replace('-- THEME',theme))
print('PASS original main loader, DEVIL HUB files and protected gameplay runtime unchanged')
report={'release':m['release'],'live_verified':False,'protected_artifacts':m['artifacts'],
 'original_logo_exact':True,'monochrome_theme':True,'original_hub_isolation':True,
 'discord_manual_copy':m['discord'],'automatic_clipboard_copy':False,
 'separate_rejoin_loader':True,'duplicate_close_reopen_integrity_checks':True,
 'original_main_and_runtime_unchanged':True,'base_commit':m['base_commit'],
 'startup_screen':False,'old_executor_api_defect_reproduced':True,'native_getfenv_preserved':True}
(ROOT/'kuydum-validation.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8',newline='\n')
