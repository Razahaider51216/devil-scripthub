-- BEGIN SHARED DEVIL BLUE GUI
do
    local shared=type(getgenv)=="function"and getgenv()or _G
    local current=shared.DevilHubBlueGui
    if not(current and current.Version=="devil-blue-20261019-10"and not current.Stopped)then
        local ok,problem=pcall(function()
            local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/devil-blue-gui.lua")
            assert(type(source)=="string"and #source==95003,"DEVIL blue GUI download size mismatch")
            local sum=0
            for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
            assert(sum==941138957,"DEVIL blue GUI checksum mismatch")
            local run,err=loadstring(source,"DEVIL HUB / Blue GUI")
            assert(run,err)
            return run()
        end)
        if not ok then warn("DEVIL HUB: blue GUI could not start: "..tostring(problem))end
    end
end
-- END SHARED DEVIL BLUE GUI
local env=type(getgenv)=="function"and getgenv()or _G
if game.GameId~=10563114921 and game.PlaceId~=107778070777162 then
 local run,err=loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))
 assert(run,err);return run(...)
end
pcall(function()game:GetService("TeleportService"):SetTeleportSetting("__ChilliAutoLoadScriptEnabled",false)end)
if env.DevilChilliUiStarting or env.DevilChilliPresentation or env.DevilChilliMainUI then return env.DevilChilliMainUI end
local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/c7b0b616bd7bed1af17b584c640859d1a887d42e/devil-steal-an-egg-chilli-recovered-ui-test.lua")
assert(type(source)=="string"and #source==450399,"Pinned script download checksum mismatch or unexpected size")
local checksum=0
for i=1,#source do checksum=(checksum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
assert(checksum==3211915546,"Pinned script download checksum mismatch")
local run,err=loadstring(source,"DEVIL HUB / Steal an Egg native UI")
assert(run,err);return run(...)
