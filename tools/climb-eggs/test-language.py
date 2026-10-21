from pathlib import Path
import json,subprocess
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
mocks=(ROOT/'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
# Language fixtures substitute MOCK_MAKE so gameplay revisions do not affect
# this UI regression suite; the actual core is exercised by test.py.
checks=(WORK/'language-tests.luau').read_text(encoding='utf-8').replace('-- SHARED MODULE HERE',(ROOT/'devil-blue-gui.lua').read_text(encoding='utf-8'))
for old in (True,False):
 ui=subprocess.check_output(['git','show','cfb08293efa6ea72e12c76f12a3e11d7ce007364:tools/climb-eggs/ui.lua'],cwd=ROOT).decode()if old else(WORK/'ui.lua').read_text(encoding='utf-8')
 ui=ui.replace('-- CLIMB_PLANNER',(WORK/'planner.lua').read_text(encoding='utf-8')).replace('-- CLIMB_CORE','return MOCK_MAKE').replace('-- CLIMB_LOGO',"return function()return 'asset://devil'end")
 source=mocks+'\nlocal EXPECT_BASELINE='+str(old).lower()+'\nlocal UI_SOURCE='+json.dumps(ui,ensure_ascii=False)+'\n'+checks
 path=WORK/('language-old.generated.luau'if old else'language.generated.luau');path.write_text(source,encoding='utf-8')
 result=subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],capture_output=True,timeout=30)
 if result.stdout:print(result.stdout.decode().strip())
 if result.returncode:
  print(result.stderr.decode().strip());raise SystemExit(result.returncode)
