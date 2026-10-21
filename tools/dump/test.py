from pathlib import Path
import ast,base64,hashlib,json,re,subprocess
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
WORK=ROOT.parent/'devil-dump-development';CLI=ROOT.parent/'luau-tools/luau.exe'
ns={'re':re,'base64':base64,'RELEASE':ROOT}
tree=ast.parse((ROOT.parent/'naphub-loot-to-forge/build_update.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name=='unpack'],type_ignores=[]),'dump-packing','exec'),ns)
report=json.loads((ROOT/'devil-dump-release.json').read_text())
if report['release'].startswith(('dump-14-','dump-15-')):
 subprocess.run(['python',str(HERE/'test-runtime.py')],check=True)
 raise SystemExit(0)
public=(ROOT/'devil-dump.lua').read_bytes();source=ns['unpack'](public.decode('utf-8')).decode('utf-8')
assert hashlib.sha256(public).hexdigest()==report['entry_sha256']
assert hashlib.sha256(source.encode()).hexdigest()==report['native_sha256']
old_public=subprocess.check_output(['git','show',report['baseline_commit']+':devil-dump.lua'],cwd=ROOT).decode('utf-8')
old=ns['unpack'](old_public).decode('utf-8')
start=old.index('\tdecoded_local_1186[40] = decoded_local_1186[36]\n\tdecoded_local_1186[40]()')
end=old.index('\tdecoded_local_1186[40] = {}',start)
old_block=old[start:end]
begin=source.index('    -- Startup never applies a saved profile')
end=source.index('\tdecoded_local_1186[40] = {}',begin)
new_block=source[begin:end]
restored=source.replace(new_block,old_block,1).replace('Folder="DevilDump_Dumps",Auto=false,Sources=false,MaxNodes=50000','Folder="DevilDump_Dumps",Auto=true,Sources=false,MaxNodes=50000',1).replace('\tdecoded_local_1186[19] = { false }','\tdecoded_local_1186[19] = { true }',1).replace('devil-dump.lua?v='+report['release'],'devil-dump.lua?v=dump-12')
assert restored==old,'Unrelated native tools/callbacks changed'
assert 'screen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")'not in public.decode('utf-8')
assert (HERE/'gui-parent.lua').read_text(encoding='utf-8')in public.decode('utf-8')
results=[]
def run(name,text):
 path=WORK/(name+'.generated.luau');path.write_text(text,encoding='utf-8',newline='\n')
 result=subprocess.run([str(CLI),str(path)],capture_output=True,timeout=40)
 if result.returncode:print(result.stderr.decode('utf-8'));result.check_returncode()
 out=result.stdout.decode('utf-8').strip();print(out);results.append(out)
fixture='''local changes=0
local decoded_local_1186={[19]={true},[18]={"Saved profile"},[36]=function()end,[39]={function()changes+=1 end}}
-- BLOCK
assert(changes==EXPECTED,"unexpected startup profile changes")
decoded_local_1186[39][1]("Saved profile")
assert(changes==EXPECTED+1,"manual profile Load removed")
'''
run('profile-old',fixture.replace('-- BLOCK',old_block).replace('EXPECTED','1')+'\nprint("PASS reproduced automatic saved-profile application in previous release")')
run('profile-new',fixture.replace('-- BLOCK',new_block).replace('EXPECTED','0')+'\nprint("PASS startup does not apply old profile actions; explicit profile Load retained")')
parent='''local function instance(name)return {name=name,Instance=true}end
local typeof=function(v)return type(v)=="table"and v.Instance and"Instance"or type(v)end
local hidden,core,player=instance("hidden"),instance("core"),instance("player")
local coreDenied=false
local game={GetService=function(_,name)
 if name=="CoreGui"then if coreDenied then error("denied")end;return core end
 return {LocalPlayer={FindFirstChildOfClass=function()return player end}}
end}
local gethui,get_hidden_gui
-- PARENT
gethui=function()return hidden end;assert(dumpGuiParent()==hidden)
gethui=nil;get_hidden_gui=function()return hidden end;assert(dumpGuiParent()==hidden)
get_hidden_gui=nil;assert(dumpGuiParent()==core)
gethui=function()error("unavailable")end;assert(dumpGuiParent()==core)
coreDenied=true;assert(dumpGuiParent()==player)
print("PASS five UI parenting cases: hidden host/alternate helper/CoreGui/error/fallback")
'''
run('gui-parent',parent.replace('-- PARENT',(HERE/'gui-parent.lua').read_text(encoding='utf-8')))
module_start=source.index('local DevilMapAnalyst=(function()\n')+len('local DevilMapAnalyst=(function()\n')
module_end=source.index('\nend)()\n',module_start)
module=source[module_start:module_end]
fixture='''local Analyst=(function()
-- MODULE
end)()
local queue,controls={},{}
local a=Analyst.New({APIs={},Alive=function()return true end,Spawn=function(fn)table.insert(queue,fn)end,Wait=function()end})
local started=0;a.Start=function()started+=1 end
local group={}
for _,method in ipairs({"CreateParagraph","CreateInput","CreateToggle","CreateButton"})do
 group[method]=function(_,info)controls[info.Name]=info;return {Set=function()end}end
end
local window={CreateTab=function()return {CreateGroupbox=function()return group end}end}
a:Mount(window)
for _,fn in ipairs(queue)do fn()end
assert(started==EXPECTED,"automatic map scan at startup")
controls["Analyze & Dump"].Callback();assert(started==EXPECTED+1,"explicit dump removed")
'''
run('scan-old',fixture.replace('-- MODULE',module.replace('Auto=false,Sources=false','Auto=true,Sources=false',1)).replace('EXPECTED','1')+'\nprint("PASS reproduced automatic map scan in previous release")')
run('scan-new',fixture.replace('-- MODULE',module).replace('EXPECTED','0')+'\nprint("PASS startup has no automatic map scan; manual Analyze & Dump retained")')
# Existing actual-handler tests prove hooks remain explicit, including saved configs.
code=(WORK/'test-no-auto-hook.py').read_text(encoding='utf-8').replace("'dump-v12.lua'","'dump-v13.lua'")
exec(compile(code,str(WORK/'test-no-auto-hook.py'),'exec'),{'__file__':str(WORK/'test-no-auto-hook.py'),'__name__':'__main__'})
(ROOT/'devil-dump-validation.json').write_text(json.dumps({'release':report['release'],'live_verified':False,'results':results,'native_other_tools_unchanged':True,'entry_sha256':report['entry_sha256'],'kick_root_cause_confirmed':False},indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS packed integrity and all unrelated dumper, recorder, runtime and image tools preserved')
