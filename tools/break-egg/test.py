from pathlib import Path
import subprocess,sys
r=Path(__file__).resolve().parents[2];w=r.parent/'break-large-egg-build'
s=(w/'gameplay.patched.lua').read_text(encoding='utf-8')
def between(a,b):return s[s.index(a):s.index(b,s.index(a))]
functions=between('    local incomeMultipliers=','    local function petIncome(')
functions+=between('    local function surfaceDistance(','    local function shownName(')
functions+=(r/'tools/break-egg/approach.lua').read_text(encoding='utf-8-sig')
f=(r/'tests/break-large-eggs-income.luau').read_text(encoding='utf-8-sig').replace('-- FUNCTIONS',functions)
p=w/'regression.generated.luau';p.write_text(f,encoding='utf-8')
subprocess.run([str(r.parent/'luau-tools/luau.exe'),str(p)],check=True)
# Execute the existing production compiler bridge, including Halloween edits.
native=(w/'runtime.patched.lua').read_text(encoding='utf-8')
a=native.index('local function installResumeSettingsBridge(');b=native.index('local function mountAutoExecute(',a)
bridge=native[a:b]
import sys
sys.path.insert(0,str(r/'tools/protection'));import pack
fixture=bridge+'\nlocal captured\nlocal compat={Scope={loadstring=function(source,label)captured=source;return function()end end}}\nlocal restore=installResumeSettingsBridge(compat)\ncompat.Scope.loadstring('+pack.literal((w/'gameplay.before.lua').read_text(encoding='utf-8'))+',"DEVIL HUB / Break Egg")\nassert(captured:find("local eggReachSettings",1,true))\nassert(captured:find("patchReachAndIncome",1,true)==nil)\nassert(captured:find("local function formatIncome",1,true))\nassert(captured:find("Auto: Best Candy",1,true),"Halloween edits lost")\nassert(loadstring(captured))\nrestore()\nprint("PASS actual production compiler bridge: Halloween + reach + income, final gameplay compilation and cleanup")\n'
p=w/'bridge.generated.luau';p.write_text(fixture,encoding='utf-8')
subprocess.run([str(r.parent/'luau-tools/luau.exe'),str(p)],check=True)
