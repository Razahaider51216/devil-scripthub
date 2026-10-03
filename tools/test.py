"""Compile production files and run UI contract tests with a Roblox API mock.

Usage: python tools/test.py --luau-dir /path/to/luau/binaries
"""
import argparse
import subprocess
import tempfile
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("--luau-dir", required=True, type=Path)
args = parser.parse_args()
source = (ROOT / "src/legacy.lua").read_text(encoding="utf-8")
inventory = {}
for name in ("toggle", "dropdown", "input", "priority", "movementSlider", "animationToggle"):
    inventory[name] = dict(sorted(Counter(re.findall(r"\b" + name + r'\([^,\n]+,\s*"([^"]+)"', source)).items()))
inventory["workers"] = dict(sorted(Counter(re.findall(r'\bworker\("([^"]+)"', source)).items()))
inventory["signals"] = sorted([list(pair) for pair in re.findall(r'\b(?:fire|invoke)\("([^"]+)"\s*,\s*"([^"]+)"', source)])
expected = json.loads((ROOT / "tests/legacy-contract.json").read_text(encoding="utf-8"))
assert inventory == expected, "Original Legacy controls, workers, or game signal calls changed"
print("PASS: original Legacy feature inventory preserved", flush=True)
suffix = ".exe" if (args.luau_dir / "luau.exe").exists() else ""
for name in ("src/ui.lua", "devil.lua", "loader", "movement.lua"):
    subprocess.run([str(args.luau_dir / ("luau-compile" + suffix)), "--null", str(ROOT / name)], check=True)
tests = (ROOT / "tests/ui.spec.luau").read_text(encoding="utf-8")
ui = (ROOT / "src/ui.lua").read_text(encoding="utf-8")
tests = tests.replace("-- UI_UNDER_TEST", "local UI = (function()\n" + ui + "\nend)()")
with tempfile.TemporaryDirectory(prefix="devil-ui-test-") as directory:
    script = Path(directory) / "test.luau"
    script.write_text(tests, encoding="utf-8", newline="\n")
    subprocess.run([str(args.luau_dir / ("luau" + suffix)), str(script)], check=True)
