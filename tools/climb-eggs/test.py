from pathlib import Path
import json,subprocess
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
CLI=ROOT.parent/'luau-tools/luau.exe'
planner=(WORK/'planner.lua').read_text(encoding='utf-8')
core=(WORK/'core.lua').read_text(encoding='utf-8')
fixture=(WORK/'core-tests.luau').read_text(encoding='utf-8')
def run(name,text):
 path=WORK/(name+'.generated.luau');path.write_text(text,encoding='utf-8')
 subprocess.run([str(CLI),str(path)],check=True,timeout=45)
run('core',fixture.replace('-- CLIMB_PLANNER',planner).replace('-- CLIMB_CORE',core))
# Retain the same independent runtime stubs, then replay five failures against
# the exact prior production source as well as this revision.
prefix=fixture.split('-- The native hold may not activate',1)[0]
regressions=(WORK/'regression-tests.luau').read_text(encoding='utf-8')
baseline=(WORK/'baseline-core.lua').read_text(encoding='utf-8')
for old,engine in [(True,baseline),(False,core)]:
 text='local EXPECT_BASELINE='+str(old).lower()+'\n'+prefix.replace('-- CLIMB_PLANNER',planner).replace('-- CLIMB_CORE',engine)+'\n'+regressions
 run('regressions-old'if old else'regressions',text)
ui=(WORK/'ui.lua').read_text(encoding='utf-8').replace('-- CLIMB_PLANNER',planner).replace('-- CLIMB_CORE','return MOCK_MAKE').replace('-- CLIMB_LOGO',"return function()return 'asset://devil'end")
run('ui','local UI_TEST_SOURCE='+json.dumps(ui,ensure_ascii=False)+'\n'+(WORK/'ui-tests.luau').read_text(encoding='utf-8'))
