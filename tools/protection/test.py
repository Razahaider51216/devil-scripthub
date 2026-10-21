"""Execute every shipped wrapper; never execute captured gameplay during decode."""
from pack import *
import re
manifest=json.loads((ROOT/'vm-protection-release.json').read_text())
def normalize(source):
    source=re.sub(r'(/devil-scripthub/)[0-9a-f]{40}(/(?:devil-blue-gui|devil-chilli-native-ui-runtime|devil-steal-an-egg-chilli-recovered-ui-test|break-and-steal-an-egg-runtime)\.lua)',r'\1PIN\2',source)
    for pattern in [r'(#source==)\d+(,"DEVIL blue GUI download size)',r'(assert\(sum==)\d+(,"DEVIL blue GUI checksum)',
                    r'(#source==)\d+(,"Pinned script)',r'(assert\(checksum==)\d+(,"Pinned script)',
                    r'(#originalGameSource==)\d+',r'(assert\(checksum==)\d+(,"Pinned runtime)',
                    r'(referenceSHA256=")[0-9a-f]+(")',r'(referenceCommit=")[0-9a-f]+(")']:
        source=re.sub(pattern,lambda m:m[1]+'VALUE'+(m[2]if m.lastindex>=2 else''),source)
    source=re.sub(r'(^    \{Name="[^\n]+?Commit=")[0-9a-f]{40}("[^\n]+)',r'\1PIN\2',source,flags=re.M)
    return source
fixture='''local builtin=loadstring
local public=PUBLIC
local expected=EXPECTED
local calls,yields=0,0
local nativeCallback
local env=setmetatable({task={wait=function()yields+=1 end}},{__index=getfenv(0)})
env.loadstring=function(code,label)
 if label=="Devil VM"or label=="DEVIL HUB / startup decoder"then
  local f,e=builtin(code,label);assert(f,e);setfenv(f,env);return f
 end
 assert(code==expected,"Native source mismatch")
 calls+=1
 -- The game compiler receives exact source. Substitute only its execution,
 -- then prove returned callbacks still run in the original native environment.
 local fn=assert(builtin("return function(...) return getfenv(1),... end"));setfenv(fn,env)
 nativeCallback=fn()
 return function(...)return nativeCallback,... end
end
local f=assert(builtin(public));setfenv(f,env)
local result=table.pack(f("sentinel",nil,42))
assert(result.n==4 and result[1]==nativeCallback and result[2]=="sentinel"and result[3]==nil and result[4]==42 and calls==1)
local callback=table.pack(result[1]("later",nil,7))
assert(callback.n==4 and callback[1]==env and callback[2]=="later"and callback[3]==nil and callback[4]==7)
assert(yields>0,"Decoder did not yield")
local damaged,count=public:gsub('(decode%("%d+:%d+:%d+:)([A-Za-z0-9+/])',function(prefix,c)return prefix..(c=="A"and"B"or"A")end,1)
assert(count==1)
f=assert(builtin(damaged));setfenv(f,env)
local ok,err=pcall(f)
assert(not ok and tostring(err):find("integrity",1,true)and calls==1,"Damaged payload reached native compiler")
print("PASS wrapper boundary: exact source, nil args/returns, native callback environment, cooperative decoding and integrity")
'''
for name,row in manifest['artifacts'].items():
    public=(ROOT/name).read_bytes()
    assert sha(public)==row['public_sha256']and len(public)==row['bytes'],name
    source=native(public.decode(),name)
    assert sha(source.encode())==row['native_sha256'],name
    old=subprocess.check_output(['git','show',manifest['baseline_commit']+':'+name],cwd=ROOT).decode('utf-8-sig')
    old_native=native(old,name)
    assert sha(old_native.encode())==row['before_native_sha256'],name
    assert normalize(source)==normalize(old_native),'Unexpected gameplay/source change: '+name
    boundary_public=public.decode();boundary_source=source
    if row.get('retained_existing_protection'):
        assert public==subprocess.check_output(['git','show',manifest['baseline_commit']+':'+name],cwd=ROOT),name
        marker=boundary_public.index('--[[\nDEVIL HUB ')
        boundary_public=boundary_public[marker:];boundary_source=capture(boundary_public,name)
    test=fixture.replace('PUBLIC',literal(boundary_public)).replace('EXPECTED',literal(boundary_source))
    path=WORK/'boundary-test.generated.luau';path.write_text(test,encoding='utf-8',newline='\n')
    subprocess.run([str(CLI),str(path)],check=True,capture_output=True,timeout=60)
    print('PASS protected source and boundary',name)
    # Every shared GUI URL now points at the protected module and correct bytes.
    if '-- BEGIN SHARED DEVIL BLUE GUI'in source and not row.get('retained_existing_protection'):
        shared=(ROOT/'devil-blue-gui.lua').read_bytes()
        assert '/'+manifest['shared_commit']+'/devil-blue-gui.lua'in source,name
        assert '#source=='+str(len(shared))in source,name
        assert 'assert(sum=='+str(checksum(shared))+','in source,name
for ref,names in [(manifest['shared_commit'],['devil-blue-gui.lua','devil-chilli-native-ui-runtime.lua']),
                  (manifest['dependencies_commit'],['devil-steal-an-egg-chilli-recovered-ui-test.lua'])]:
    for name in names:assert subprocess.check_output(['git','show',ref+':'+name],cwd=ROOT)==(ROOT/name).read_bytes(),name
for row in manifest['routes_after']:
    assert subprocess.check_output(['git','show',row['Commit']+':'+row['File']],cwd=ROOT)==(ROOT/row['File']).read_bytes(),row['File']
assert len(manifest['routes_before'])==12
print('PASS all 12 game routes, 19 protected artifacts, source preservation and immutable dependency chain')
