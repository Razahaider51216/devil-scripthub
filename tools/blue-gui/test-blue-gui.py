from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
checks = (root / 'tests/blue-gui-checks.luau').read_text(encoding='utf-8')
checks = checks.replace('-- NATIVE TRANSITIONS INSERTED HERE', (root / 'tests/blue-gui-native-minimize.luau').read_text(encoding='utf-8'))
module = (root / 'devil-blue-gui.lua').read_text(encoding='utf-8')
fixture = mocks + checks.replace('-- MODULE INSERTED HERE', module)
path = Path(__file__).with_suffix('.generated.luau')
path.write_text(fixture, encoding='utf-8')
subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)], check=True)
