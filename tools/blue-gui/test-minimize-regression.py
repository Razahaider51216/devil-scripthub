"""Show that the previous release adopts a native animation frame as its window."""
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
# The full current fixture also tests new input styles. Only the transition
# assertion is relevant when replaying it against the previous presentation.
mocks = mocks.replace('local function check(v,message) assert(v,message); checks+=1 end',
    "local function check(v,message) if message=='theme adopted a minimize animation frame' then assert(v,message) end;checks+=1 end")
assert 'then assert(v,message)' in mocks
checks = (root / 'tests/blue-gui-checks.luau').read_text(encoding='utf-8')
checks = checks.replace('-- NATIVE TRANSITIONS INSERTED HERE',
    (root / 'tests/blue-gui-native-minimize.luau').read_text(encoding='utf-8'))
# New fullscreen-layer cases are a separate regression. Keep them from changing
# the older fixture's root selection before it reaches the minimize transition.
checks = checks.replace('AbsoluteSize=Vector2.new(1920,1080)', 'AbsoluteSize=Vector2.new(0,0)')
checks = checks.replace('local layers=controller.InspectLayers()',
                        'local layers=controller.InspectLayers and controller.InspectLayers()or{}')
baseline = subprocess.check_output(['git', 'show',
    '742ae9720de5e5a9f486eb0ed430b846f628e14e:devil-blue-gui.lua'], cwd=root).decode('utf-8')
path = Path(__file__).with_suffix('.generated.luau')
path.write_text(mocks + checks.replace('-- MODULE INSERTED HERE', baseline), encoding='utf-8', newline='\n')
result = subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)],
                        capture_output=True, text=True, timeout=15)
assert result.returncode != 0 and 'theme adopted a minimize animation frame' in result.stderr, result.stdout + result.stderr
print('PASS regression proof: previous release adopts the native animation frame')
