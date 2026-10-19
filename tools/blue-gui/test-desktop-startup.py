"""Viewport readiness, pixel layers and GUI access fallback for every mapped game."""
from pathlib import Path
import json, subprocess

root = Path(__file__).resolve().parents[2]
mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
checks = (root / 'tests/blue-gui-desktop-startup.luau').read_text(encoding='utf-8')
routes = json.loads((root / 'devil-blue-gui-router-audit.json').read_text(encoding='utf-8'))['routes']
definitions = 'local routes={' + ','.join('{Universe=' + str(r['Universe']) + ',Place=' + str(r['Place']) + ',File=' + json.dumps(r['File']) + '}' for r in routes) + '}\n'
path = Path(__file__).with_suffix('.generated.luau')
runtime = str(root.parent / 'luau-tools/luau.exe')
baseline = subprocess.check_output(['git', 'show', 'ed0e12ca6c662e8a4b4cb40561b220d65a362e25:devil-blue-gui.lua'], cwd=root).decode('utf-8')
for marker in ['desktop pixel screen layer was painted as an opaque menu',
               'late real window did not replace the provisional startup root']:
    focused = mocks.replace('local function check(v,message) assert(v,message); checks+=1 end',
        'local function check(v,message) if message==' + repr(marker) + ' then assert(v,message)end;checks+=1 end')
    path.write_text(focused + definitions + checks.replace('-- MODULE INSERTED HERE', baseline), encoding='utf-8', newline='\n')
    result = subprocess.run([runtime, str(path)], capture_output=True, text=True, timeout=25)
    assert result.returncode != 0 and marker in result.stderr, result.stdout + result.stderr
    print('PASS reproduced previous release:', marker)
module = (root / 'devil-blue-gui.lua').read_text(encoding='utf-8')
path.write_text(mocks + definitions + checks.replace('-- MODULE INSERTED HERE', module), encoding='utf-8', newline='\n')
subprocess.run([runtime, str(path)], check=True, timeout=25)
