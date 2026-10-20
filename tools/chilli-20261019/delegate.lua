local env=type(getgenv)=="function"and getgenv()or _G
if game.GameId~=10563114921 and game.PlaceId~=107778070777162 then
 local run,err=loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))
 assert(run,err);return run(...)
end
if env.DevilChilliUiStarting or env.DevilChilliPresentation or env.DevilChilliMainUI then return env.DevilChilliMainUI end
local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/c46380dda2b652a5dfc6c53e45112000912e9421/devil-steal-an-egg-chilli-recovered-ui-test.lua")
assert(type(source)=="string"and #source==450394,"Pinned script download checksum mismatch or unexpected size")
local checksum=0
for i=1,#source do checksum=(checksum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
assert(checksum==2108406679,"Pinned script download checksum mismatch")
local run,err=loadstring(source,"DEVIL HUB / Steal an Egg native UI")
assert(run,err);return run(...)
