-- DEVIL HUB: full Chilli runtime test, separate from the main loader.
-- Original protected engine/frontend retained; not a devirtualized migration.
if game.GameId~=10563114921 and game.PlaceId~=107778070777162 then
    warn("DEVIL HUB: open Steal an Egg first")
    return
end
local env=type(getgenv)=="function"and getgenv()or _G
if env.DevilChilliFullRuntimeTest then
    warn("DEVIL HUB: this full-runtime test already ran; rejoin before testing again")
    return
end
local report={schema="devil-chilli-full-runtime-test-1",release="chilli-full-test-1",map="Steal an Egg",
    placeId=game.PlaceId,universeId=game.GameId,status="Starting",devirtualized=false,
    frontend="Original Chilli",referenceSHA256="6c0a0cd11368cff8b1b2d18cb1d17f4e57afbed8d3c917f66062324d2332162c",referenceCommit="5718ad8818f412ccca12d67dc18dbc2964b7a829"}
env.DevilChilliFullRuntimeTest=report
local function save()
    if type(writefile)=="function"then
        pcall(function()writefile("DevilChilliFullTest-report.json",game:GetService("HttpService"):JSONEncode(report))end)
    end
end
local function notify(message)
    warn("[DEVIL HUB / Chilli full test] "..message)
    pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="DEVIL HUB / Full Systems Test",Text=message,Duration=8})end)
end
save()
local outcome=table.pack(xpcall(function()
    assert(type(loadstring)=="function","Executor loadstring is unavailable")
    assert(type(buffer)=="table"and type(buffer.readu8)=="function","Executor buffer support is unavailable")
    if env.DevilStealEggSession and type(env.DevilStealEggSession.Destroy)=="function"then
        env.DevilStealEggSession.Destroy()
    end
    notify("Loading the complete Chilli runtime; its own menu will open")
    local originalGameSource=game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-Script/5718ad8818f412ccca12d67dc18dbc2964b7a829/StealAnEgg")
    assert(type(originalGameSource)=="string"and #originalGameSource==848305,"Pinned runtime download has an unexpected size")
    local checksum=0
    for index=1,#originalGameSource do checksum=(checksum*33+string.byte(originalGameSource,index))%4294967296 end
    assert(checksum==3854847166,"Pinned runtime download checksum mismatch")
    local run,err=loadstring(originalGameSource,"Chilli / Steal an Egg / pinned runtime")
    assert(run,err)
    report.status="Runtime compiled";report.transferChecksumVerified=true;save()
    return run()
end,function(err)return debug and type(debug.traceback)=="function"and debug.traceback(tostring(err),2)or tostring(err)end))
report.ok=outcome[1]
report.status=report.ok and "Runtime returned; verify original menu and systems in game"or"Failed"
if not report.ok then report.error=tostring(outcome[2])end
save()
if not report.ok then notify(report.error:sub(1,250));error(report.error,0)end
return table.unpack(outcome,2,outcome.n)
