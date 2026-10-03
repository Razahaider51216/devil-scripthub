"""Build the self-contained Devil Hub payload from reviewed source modules."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ui = (ROOT / "src/ui.lua").read_text(encoding="utf-8").rstrip()
core = (ROOT / "src/legacy.lua").read_text(encoding="utf-8").rstrip()
bootstrap = '''-- DEVIL HUB / ANIME LEGACY
-- Built from src/ui.lua + src/legacy.lua by tools/build.py.
if not game:IsLoaded() then game.Loaded:Wait() end
local function notify(message)
    local ok = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Devil Hub", Text = message, Duration = 8,
        })
    end)
    if not ok then warn("[Devil Hub] " .. message) end
end
if game.GameId ~= 10765902945 and game.PlaceId ~= 106198175232796 then
    notify("Devil Hub: this build supports Anime Legacy.")
    return
end
local success, result = xpcall(function()
'''
payload = bootstrap + "local DevilUI = (function()\n" + ui + "\nend)()\n" + core
payload += '''
end, debug.traceback)
if not success then
    local env = getgenv()
    local runtime = env.DevilHubLegacy
    if runtime and runtime.Stop then pcall(runtime.Stop) end
    notify("Unable to start Devil Hub. Check the console.")
    warn("[Devil Hub] " .. tostring(result))
    return
end
-- Retain the original Legacy post-load integration.
pcall(function()
    local source = game:HttpGet("https://raw.githubusercontent.com/itachidevrs/gg/refs/heads/main/gg2")
    local run, err = loadstring(source, "Devil Hub / Legacy integration")
    assert(run, err)
    run()
end)
return result
'''
(ROOT / "devil.lua").write_text(payload, encoding="utf-8", newline="\n")
print(f"Built devil.lua: {len(payload.splitlines())} lines")
