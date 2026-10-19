from pathlib import Path
import hashlib, importlib.util, json, subprocess

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
manifest = json.loads((root / 'devil-blue-gui-release.json').read_text())
ref = manifest['module_commit']
spec = importlib.util.spec_from_file_location('blue_entries', here / 'build-entries.py')
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)
prelude = builder.prefix(ref)
module = subprocess.check_output(['git', 'show', ref + ':devil-blue-gui.lua'], cwd=root).decode('utf-8')

for name, record in manifest['entries'].items():
    text = (root / name).read_text(encoding='utf-8')
    assert text.startswith(prelude), name
    assert hashlib.sha256(text[len(prelude):].encode()).hexdigest() == record['original_body_sha256'], name
    if name not in ['devil-steal-an-egg.lua', 'devil-steal-an-egg-chilli-main-gui.lua',
                    'devil-steal-an-egg-chilli-recovered-ui-test.lua']:
        original = subprocess.check_output(['git', 'show', '769d84a:' + name], cwd=root).decode('utf-8-sig').replace('\r\n', '\n')
        assert text[len(prelude):] == original, ('Unexpected engine edit', name)
print('PASS all 14 entry prefixes; 11 engine bodies identical to previous production')

def literal(text):
    eq = '='
    while ']' + eq + ']' in text:
        eq += '='
    return '[' + eq + '[' + text + ']' + eq + ']'

mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
checks = (root / 'tests/blue-gui-checks.luau').read_text(encoding='utf-8').replace('-- MODULE INSERTED HERE', module)
checks = checks.replace('-- NATIVE TRANSITIONS INSERTED HERE', (root / 'tests/blue-gui-native-minimize.luau').read_text(encoding='utf-8'))
test = r'''
local requests,compiled,warnings=0,0,0
local response=moduleSource
function game:HttpGet(url)
 requests+=1
 assert(url:find('/devil-blue-gui.lua',1,true),'wrong presentation URL')
 return response
end
local builtinCompile=loadstring
local host=setmetatable({game=game,getgenv=getgenv,Instance=Instance,Enum=Enum,Color3=Color3,ColorSequence=ColorSequence,
 Vector2=Vector2,UDim=UDim,UDim2=UDim2,task=task,readfile=readfile,writefile=writefile,isfile=isfile,
 warn=function()warnings+=1 end},{__index=getfenv(0)})
host.loadstring=function(code,label)
 compiled+=1;local fn,err=builtinCompile(code,label)
 if fn then setfenv(fn,host)end
 return fn,err
end
local compilerIdentity=host.loadstring
local run=assert(builtinCompile(prelude..'return ...'))
setfenv(run,host)
local result,arg=run('original engine',42)
flush()
check(result=='original engine'and arg==42 and requests==1 and compiled==1,'initial presentation load broke original return/args')
check(env.DevilHubBlueGui.Version=='devil-blue-20261019-8','shared theme not installed')
run('again');check(requests==1 and compiled==1,'duplicate entry downloaded/restarted theme')
env.DevilHubBlueGui.Destroy();response=moduleSource:sub(1,-2)..'x'
check(run('original still runs')=='original still runs'and compiled==1 and warnings==1,'corrupt presentation reached compiler or stopped game entry')
response='<html>error</html>'
check(run('fallback')=='fallback'and compiled==1 and warnings==2,'HTML response stopped game entry')
check(host.loadstring==compilerIdentity and host.getfenv==getfenv,'prefix replaced compiler/environment APIs')
print('PASS entry bootstrap: immutable payload integrity, cached launch, error fallback, original compiler and argument forwarding')
'''
path = here / 'test-entry-prefix.generated.luau'
path.write_text(mocks + checks + '\nlocal moduleSource=' + literal(module) + '\nlocal prelude=' + literal(prelude) + '\n' + test,
                encoding='utf-8', newline='\n')
subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)], check=True)
