"""Replay native Break dialog geometry against the previous menu policy."""
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
checks = (root / 'tests/blue-gui-checks.luau').read_text(encoding='utf-8')
checks = checks.replace('-- NATIVE TRANSITIONS INSERTED HERE',
    (root / 'tests/blue-gui-native-minimize.luau').read_text(encoding='utf-8'))
baseline = subprocess.check_output(['git', 'show',
    '30b809e8e82987401fea3f7cfdd179905fa69eb6:devil-blue-gui.lua'], cwd=root).decode('utf-8')
for marker in ['native dialog dimmer painted as an opaque menu card',
               'Break dialog overlay remains visible while main GUI is minimized']:
    focused = mocks.replace('local function check(v,message) assert(v,message); checks+=1 end',
        'local function check(v,message) if message==' + repr(marker) + ' then assert(v,message) end;checks+=1 end')
    path = Path(__file__).with_suffix('.generated.luau')
    path.write_text(focused + checks.replace('-- MODULE INSERTED HERE', baseline), encoding='utf-8', newline='\n')
    result = subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)],
                            capture_output=True, text=True, timeout=15)
    assert result.returncode != 0 and marker in result.stderr, result.stdout + result.stderr
    print('PASS reproduced previous-release bug:', marker)
