-- DEVIL HUB standalone trial. Uses native client modules from the supplied dump.
assert(game.GameId==3317771874 or game.PlaceId==8737899170,"Open the map from dump Place 8737899170")
local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilPetSimTest then env.DevilPetSimTest.Destroy() end
local makeCore=(function()
return function(config, d, changed)
    local C={Config=config,Report={release="petsim-auto-test-3",jobs={},errors={},liveTest=false}}
    local names={"Farm","Tap","Orbs","Magnet","Hatch","Equip","Gifts","Ranks","Zones","Rebirth"}
    local jobs=C.Report.jobs
    local alive=true
    local locked, assigned, lastEquip, lastJoin, lastHealth, lastDamage, lastFarmEquip
    local travelling=false
    local function notify() if changed then pcall(changed,C.Report) end end
    local function status(key,text,details)
        local j=jobs[key];j.status=text;j.updatedAt=d.Now()
        if details then for k,v in pairs(details) do j[k]=v end end
        notify()
    end
    for _,key in ipairs(names) do jobs[key]={status="Disabled",requests=0,confirmed=0,nextAt=0,generation=0} end
    local function request(key,remote,...)
        local j=jobs[key]
        if not alive or not config[key] then return false,"Cancelled" end
        if d.CanInvoke and not d.CanInvoke() then return false,"Waiting for previous server request" end
        local generation=j.generation
        j.requests+=1
        local result=table.pack(d.Invoke(remote,...))
        if not alive or not config[key] or generation~=j.generation then return false,"Cancelled" end
        j.serverMessage=result[2] and tostring(result[2]) or nil
        if result[1]==true then j.confirmed+=1 end
        return table.unpack(result,1,result.n)
    end
    local function pending(key,id,confirmed)
        local j=jobs[key]
        if j.pending then
            if confirmed(j.pending.id) then
                j.confirmed+=1;j.pending=nil;status(key,"Confirmed")
            elseif d.Now()-j.pending.at>12 then
                j.pending=nil;j.nextAt=d.Now()+20;status(key,"No confirmation; waiting before retry")
            else status(key,"Waiting for server confirmation") end
            return true
        end
        if id then j.pending={id=id,at=d.Now()} end
        return false
    end
    local actions={}
    actions.Farm=function()
        if not locked or not d.TargetValid(locked,config) then
            locked=d.FindTarget(config);assigned={};lastJoin=nil;lastHealth=nil;lastDamage=d.Now()
        end
        if not locked then status("Farm","Waiting for loaded targets in selected zone");return end
        local count=0
        for id,pet in pairs(d.Pets()) do
            count+=1
            if assigned[id]~=locked.id or not d.PetOnTarget(pet,locked) then
                if not config.Farm then break end
                d.AssignPet(pet,locked);assigned[id]=locked.id;jobs.Farm.requests+=1
            end
        end
        if count==0 and d.EquipBest and (not lastFarmEquip or d.Now()-lastFarmEquip>=15) then
            d.EquipBest();jobs.Farm.requests+=1;lastFarmEquip=d.Now()
        end
        if count>0 and d.JoinPets and (not lastJoin or d.Now()-lastJoin>=3) then
            local joined=d.JoinPets(assigned,locked)
            jobs.Farm.requests+=joined>0 and 2 or 0;lastJoin=d.Now()
        end
        local health=d.TargetHealth and d.TargetHealth(locked)
        if health and lastHealth and health<lastHealth then
            jobs.Farm.damageUpdates=(jobs.Farm.damageUpdates or 0)+1;lastDamage=d.Now()
        end
        lastHealth=health
        local text=count==0 and "Equip pets first" or "Pet target and join requested"
        if count>0 and d.Now()-lastDamage>10 then text="No damage observed; check pet reach or selected zone"
        elseif jobs.Farm.damageUpdates and d.Now()-lastDamage<2 then text="Target taking damage" end
        status("Farm",text,{target=locked.id,targetName=locked.name,pets=count,health=health})
    end
    actions.Tap=function()
        local target=locked and d.TargetValid(locked,config) and locked or d.FindTarget(config)
        if not target then status("Tap","Waiting for loaded targets in selected zone");return end
        if target.distance>40 then status("Tap","Move closer to target");return end
        d.Fire("AutoClicker_Nearby",target.id);jobs.Tap.requests+=1
        status("Tap","Tap requested; damage not yet confirmed",{target=target.id})
    end
    actions.Orbs=function()
        if config.Magnet then status("Orbs","Handled by item magnet");return end
        local ids=d.OrbBatch(100)
        if #ids==0 then status("Orbs","Waiting for new server-created orbs");return end
        d.Fire("Orbs: Collect",ids);d.OrbSent(ids);jobs.Orbs.requests+=1
        status("Orbs","Collection requested; inventory not yet confirmed",{batch=#ids})
    end
    actions.Magnet=function()
        if d.MagnetMode and d.MagnetMode()=="NativeAttraction" then
            status("Magnet","Native item magnet active; server inventory controls rewards",{mode="NativeAttraction"});return
        end
        local ids=d.OrbBatch(100,true)
        if #ids==0 then status("Magnet","Waiting for new server-created orbs");return end
        d.Fire("Orbs: Collect",ids);d.OrbSent(ids);jobs.Magnet.requests+=1
        status("Magnet","Collection requested; inventory not yet confirmed",{batch=#ids,mode="PacketCollect"})
    end
    actions.Hatch=function()
        local j=jobs.Hatch
        for _,field in ipairs({"blocked","serverMessage","remote","effectiveCount","maxHatch","price","eggDistance","error"}) do j[field]=nil end
        j.egg=config.Egg
        if config.Egg=="" then status("Hatch","Select an egg first");return end
        local egg=d.Egg(config.Egg)
        if not egg then status("Hatch","Selected egg unavailable");return end
        local plan=d.HatchPlan and d.HatchPlan(config.Egg,egg,config.HatchCount) or
            {remote="Eggs_RequestPurchase",id=egg._id or config.Egg,count=math.clamp(math.floor(config.HatchCount),1,100),cooldown=3}
        if plan.blocked then status("Hatch",plan.blocked,plan);jobs.Hatch.nextAt=d.Now()+5;return end
        if plan.needsApproach then
            travelling=true
            if assigned then pcall(d.ClearAssigned,assigned) end
            locked=nil;assigned={};lastJoin=nil
            local ok,arrived,reason,distance=pcall(d.ApproachEgg,config.Egg)
            travelling=false
            status("Hatch",ok and arrived and "Arrived near selected egg" or "Egg approach not confirmed",
                {eggDistance=distance or plan.distance,serverMessage=ok and tostring(reason or "") or tostring(arrived)})
            j.nextAt=d.Now()+(ok and arrived and 0.5 or 8)
            return
        end
        if plan.remote=="Eggs_RequestUnlock" then
            local ok,message=request("Hatch",plan.remote,plan.id)
            if ok==true then
                jobs.Hatch.confirmed-=1;jobs.Hatch.unlockConfirmed=(jobs.Hatch.unlockConfirmed or 0)+1
            end
            status("Hatch",ok==true and "Egg unlock requested; waiting for replication" or "Server rejected egg unlock",
                {egg=config.Egg,remote=plan.remote,serverMessage=tostring(message or "")})
            jobs.Hatch.nextAt=d.Now()+3;return
        end
        local ok,message=request("Hatch",plan.remote,plan.id,plan.count)
        status("Hatch",ok==true and "Hatch confirmed" or "Server rejected hatch",{serverMessage=tostring(message or "")})
        jobs.Hatch.remote=plan.remote;jobs.Hatch.egg=config.Egg;jobs.Hatch.effectiveCount=plan.count
        jobs.Hatch.maxHatch=plan.maxHatch;jobs.Hatch.price=plan.price;jobs.Hatch.eggDistance=plan.distance
        jobs.Hatch.nextAt=d.Now()+math.max(0.5,plan.cooldown or 3)
        if ok~=true then jobs.Hatch.nextAt=d.Now()+8 end
    end
    actions.Equip=function()
        local snapshot=d.EquippedSnapshot()
        if lastEquip and snapshot~=lastEquip then jobs.Equip.confirmed+=1 end
        lastEquip=snapshot
        d.EquipBest();jobs.Equip.requests+=1
        status("Equip","Equip Best requested; watching equipped pets")
    end
    actions.Gifts=function()
        local save=d.Save()
        if pending("Gifts",nil,function(id) return table.find(save.FreeGiftsRedeemed or {},id)~=nil end) then return end
        for _,gift in ipairs(d.Gifts()) do
            if (save.FreeGiftsTime or 0)>=gift.WaitTime and not table.find(save.FreeGiftsRedeemed or {},gift.Id) then
                local ok,message=request("Gifts","Redeem Free Gift",gift.Id)
                status("Gifts",ok==true and "Gift confirmed" or "Server rejected gift",{gift=gift.Id,serverMessage=tostring(message or "")})
                jobs.Gifts.nextAt=d.Now()+5
                return
            end
        end
        status("Gifts","Waiting for eligible gifts")
    end
    actions.Ranks=function()
        local save=d.Save()
        if pending("Ranks",nil,function(id) return (save.RedeemedRankRewards or {})[tostring(id)]~=nil end) then return end
        local stars=0
        for index,reward in ipairs(d.RankRewards(save.Rank)) do
            stars+=reward.StarsRequired or 0
            if stars>(save.RankStars or 0) then break end
            if (save.RedeemedRankRewards or {})[tostring(index)]==nil then
                d.Fire("Ranks_ClaimReward",index);jobs.Ranks.requests+=1
                pending("Ranks",index,function() return false end)
                status("Ranks","Waiting for server confirmation",{reward=index});return
            end
        end
        status("Ranks","Waiting for eligible rank rewards")
    end
    actions.Zones=function()
        local zone=d.NextZone()
        if not zone then status("Zones","No next zone");return end
        if not d.ZoneQuestsReady() then status("Zones","Complete zone quests first");return end
        local currency,price=d.GatePrice(zone)
        if not currency or not price then status("Zones","Zone price unavailable");return end
        if d.Currency(currency)<price+config.Reserve then status("Zones","Insufficient funds after reserve");return end
        local ok,message=request("Zones","Zones_RequestPurchase",zone._id)
        status("Zones",ok==true and "Zone purchase confirmed" or "Server rejected zone purchase",{zone=zone._id,serverMessage=tostring(message or "")})
        if ok~=true then jobs.Zones.nextAt=d.Now()+12 end
    end
    actions.Rebirth=function()
        local next=d.NextRebirth()
        if not next then status("Rebirth","Maximum rebirth reached");return end
        if d.MaxZoneNumber()<next.ZoneNumberRequired then status("Rebirth","Unlock required zone first");return end
        local ok,message=request("Rebirth","Rebirth_Request",next._id)
        status("Rebirth",ok==true and "Rebirth confirmed" or "Server rejected rebirth",{serverMessage=tostring(message or "")})
        if ok~=true then jobs.Rebirth.nextAt=d.Now()+15 end
    end
    local intervals={Farm=0.8,Tap=0.3,Orbs=0.5,Magnet=0.3,Hatch=0.5,Equip=8,Gifts=2,Ranks=2,Zones=5,Rebirth=8}
    function C.Tick(key)
        local j=jobs[key]
        if not alive or not config[key] or j.busy or travelling or d.Now()<j.nextAt then return end
        j.busy=true
        local generation=j.generation
        local ok,problem=xpcall(function()
            if not d.Ready() then status(key,"Waiting for player profile");return end
            actions[key]()
        end,function(err) return tostring(err) end)
        j.busy=false
        j.nextAt=math.max(j.nextAt,d.Now()+intervals[key])
        if not alive or generation~=j.generation then j.status="Disabled";notify();return end
        if not ok then
            j.nextAt=d.Now()+10
            table.insert(C.Report.errors,{job=key,message=tostring(problem),t=d.Now()})
            if #C.Report.errors>40 then table.remove(C.Report.errors,1) end
            status(key,"Error; see report",{error=tostring(problem)})
        end
    end
    function C.Set(key,value)
        assert(jobs[key],"Unknown automation")
        config[key]=value==true
        jobs[key].generation+=1;jobs[key].nextAt=0;jobs[key].pending=nil
        if key=="Hatch" and d.SetHatchBypass then
            local ok,mode=pcall(d.SetHatchBypass,value==true)
            jobs[key].bypassMode=ok and mode or "Unavailable"
            if not ok then jobs[key].error=tostring(mode) end
        end
        if key=="Magnet" and d.SetMagnet then
            local ok,mode=pcall(d.SetMagnet,value==true)
            jobs[key].mode=ok and mode or "PacketCollect"
            if not ok then jobs[key].error=tostring(mode) end
        end
        if key=="Farm" then
            if not value then pcall(d.ClearAssigned,assigned) end
            locked=nil;assigned={}
        end
        status(key,value and "Enabled" or "Disabled")
    end
    function C.Stop() for _,key in ipairs(names) do C.Set(key,false) end end
    function C.Teleport(probe)
        if not alive or travelling then return false,"Travel already pending or stopped" end
        if C.Report.travel and d.Now()-(C.Report.travel.started or 0)<10 then return false,"Wait before another teleport request" end
        travelling=true
        local travel={mode=probe and "FinalZoneProbe" or "HighestUnlocked",started=d.Now(),status="Selecting zone"}
        C.Report.travel=travel
        local ok,problem=xpcall(function()
            local best,highest
            local world=d.WorldNumber()
            for id,zone in pairs(d.ZoneDirectory()) do
                if zone.WorldNumber==world and type(zone.ZoneNumber)=="number" then
                    if not highest or zone.ZoneNumber>highest.number then highest={id=id,number=zone.ZoneNumber} end
                    if d.ZoneEligible(id) and (not best or zone.ZoneNumber>best.number) then best={id=id,number=zone.ZoneNumber} end
                end
            end
            local goal=probe and highest or best
            if not goal then travel.status="No eligible zone in this world";return end
            travel.zone=goal.id;travel.zoneNumber=goal.number;travel.ownedBefore=d.ZoneOwns(goal.id)
            if not probe then
                local allowed,reason=d.CanTeleport(goal.id)
                if not allowed then travel.status="Teleport blocked by game conditions";travel.serverMessage=tostring(reason or "");return end
            end
            if d.CanInvoke and not d.CanInvoke() then travel.status="Waiting for previous server request";return end
            if assigned then pcall(d.ClearAssigned,assigned) end
            locked=nil;assigned={};lastJoin=nil
            travel.status="Sending one teleport request";notify()
            local accepted,reason=d.Invoke("Teleports_RequestTeleport",goal.id)
            travel.serverAccepted=accepted==true;travel.serverMessage=tostring(reason or "")
            if not alive then return end
            if accepted~=true then travel.status="Server rejected teleport";return end
            travel.arrived=d.WaitForZone(goal.id)
            travel.ownedAfter=d.ZoneOwns(goal.id)
            if not alive then return end
            travel.status=travel.arrived and "Teleport arrival confirmed" or "Accepted; arrival not confirmed"
            if travel.arrived then config.Zone=goal.id end
        end,function(err) return tostring(err) end)
        travelling=false
        if not ok then travel.status="Teleport error";travel.serverMessage=tostring(problem) end
        notify()
        return ok and travel.arrived==true,travel.serverMessage or travel.status
    end
    function C.Destroy()
        if not alive then return end
        C.Stop();alive=false;if d.Destroy then d.Destroy() end
    end
    C.Names=names
    return C
end

end)()
local makeHatchSkip=(function()
-- Only replaces the presentation functions. The game's hatch-result handler
-- still decodes rewards, unhides items, sends SM_Unmask and CompletedHatching.
return function(d)
    local S={Report={mode="Disabled",skipped=0,tapReleased=0,errors={}}}
    local enabled,dead=false,false
    local flagHeld,oldFlag=false,nil
    local leases={}
    local scene
    local lastAttempt=-math.huge
    local function problem(err)
        local errors=S.Report.errors
        errors[#errors+1]=tostring(err)
        if #errors>10 then table.remove(errors,1) end
    end
    local function instant()
        if not flagHeld then
            oldFlag=d.GetInstant()
            flagHeld=true
        end
        if d.GetInstant()~=true then d.SetInstant(true) end
    end
    local function restore()
        enabled=false
        for i=#leases,1,-1 do
            local lease=leases[i]
            local ok,err=pcall(lease.restore)
            if not ok then problem(err) end
        end
        table.clear(leases)
        scene=nil
        if flagHeld then
            local ok,err=pcall(function()
                if d.GetInstant()==true then d.SetInstant(oldFlag) end
            end)
            if not ok then problem(err) end
        end
        flagHeld=false;oldFlag=nil;lastAttempt=-math.huge
        S.Report.mode="Disabled"
    end
    local function install()
        if #leases>0 or d.Now()-lastAttempt<2 then return end
        lastAttempt=d.Now()
        local source=d.FindScript()
        if not source then return end
        scene=source
        local scriptEnv=d.ScriptEnv(source)
        if type(scriptEnv)~="table" then return end
        for _,name in ipairs({"PlayNormalEggAnimation","PlayTowerDefenseAnimations"}) do
            local target=scriptEnv[name]
            if type(target)=="function" then
                local original=target
                local wrapper=function(...)
                    if enabled and not dead then S.Report.skipped+=1;return end
                    return original(...)
                end
                if d.Hook then
                    original=d.Hook(target,wrapper)
                    assert(type(original)=="function","Animation hook did not return original function")
                    leases[#leases+1]={restore=function() d.Hook(target,original) end}
                    S.Report.mode="AnimationHook"
                else
                    scriptEnv[name]=wrapper
                    assert(scriptEnv[name]==wrapper,"Animation environment is read-only")
                    leases[#leases+1]={restore=function()
                        if scriptEnv[name]==wrapper then scriptEnv[name]=original end
                    end}
                    S.Report.mode="AnimationEnvironment"
                end
            end
        end
    end
    function S.Set(value)
        value=value==true and not dead
        if not value then restore();return S.Report.mode end
        enabled=true
        S.Report.mode=#leases>0 and S.Report.mode or "NativeInstant"
        local ok,err=pcall(instant);if not ok then problem(err) end
        ok,err=pcall(install);if not ok then problem(err) end
        return S.Report.mode
    end
    function S.Pulse()
        if not enabled or dead then return end
        local ok,err=pcall(instant);if not ok then problem(err) end
        ok,err=pcall(install);if not ok then problem(err) end
        -- Releases a presentation that began before the hook was installed.
        -- The adapter restricts callbacks to the exact egg-opening LocalScript.
        if scene and d.TapWaiting and d.OpeningCount()>0 then
            ok,err=pcall(d.TapWaiting,scene)
            if ok then S.Report.tapReleased+=tonumber(err) or 0 else problem(err) end
        end
    end
    function S.Destroy()
        if dead then return end
        restore();dead=true
    end
    return S
end

end)()
local makeLogo=(function()
local function logo()
    local version="silver-break-20261014"
    local url="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/a28a74d3b5c98f687c165dcefaadfe0a743d280c/assets/devil-logo.png"
    local cached=env.DevilHubSilverLogo
    if env.DevilHubSilverLogoVersion==version and type(cached)=="string"and cached~=""and not cached:match("^https?://")then return cached end
    local file="DevilHub_Silver_20261014.png"
    local signature="\137PNG\r\n\26\n"
    local ok,value=pcall(function()
        assert(type(writefile)=="function","Logo file API unavailable")
        local exists=type(isfile)=="function"and isfile(file)
        if exists and type(readfile)=="function"then
            local readable,data=pcall(readfile,file)
            exists=readable and type(data)=="string"and data:sub(1,8)==signature
        end
        if not exists then
            local data=game:HttpGet(url)
            assert(type(data)=="string"and data:sub(1,8)==signature,"Invalid DEVIL HUB logo response")
            writefile(file,data)
        end
        for _,key in ipairs({"getcustomasset","getsynasset"})do
            local custom=getfenv()[key]
            if type(custom)=="function"then
                local resolved,image=pcall(custom,file)
                if resolved and type(image)=="string"and image~=""and not image:match("^https?://")then return image end
            end
        end
        error("Logo asset API unavailable")
    end)
    if ok then
        env.DevilHubSilverLogo=value;env.DevilHubSilverLogoVersion=version;env.DevilHubLogoError=nil
        return value
    end
    env.DevilHubLogoError=tostring(value)
    -- Do not cache an HTTP URL as a resolved Roblox asset: later calls can retry.
    return url
end
return logo

end)()
local RS=game:GetService("ReplicatedStorage")
local Http=game:GetService("HttpService")
local player=game:GetService("Players").LocalPlayer
local client=RS:WaitForChild("Library",15):WaitForChild("Client",15)
local modules={}
local function module(name)
    if modules[name] then return modules[name] end
    local instance=client:FindFirstChild(name)
    assert(instance and instance:IsA("ModuleScript"),"Missing game module: "..name)
    modules[name]=require(instance)
    return modules[name]
end
local directory
local function dirs()
    if not directory then directory=require(RS.Library.Directory) end
    return directory
end
local config={Farm=false,Tap=false,Orbs=false,Magnet=false,Hatch=false,Equip=false,Gifts=false,Ranks=false,Zones=false,Rebirth=false,
    Zone="Current",Class="All",Radius=150,MagnetRange=1000,Egg="",HatchCount=1,SkipHatchAnimation=true,AutoApproachEgg=true,Reserve=0,Language="TH"}
local api={Config=config}
local window,core,paragraphs,controls={},{},{},{}
window=nil;core=nil
local build
local destroyed,rebuilding=false,false
local connections={}
local function rpcPending() return env.DevilPetSimRPCPending end
local orbQueue,orbCount={},0
local magnetHook
local magnetMode="PacketCollect"
local now=os.clock
local function openingCount()
    local ok,vars=pcall(require,RS.Library.Variables)
    return ok and tonumber(vars.OpeningEgg) or 0
end
local hatchSkip=makeHatchSkip({
    Now=now,
    GetInstant=function() return workspace:GetAttribute("GlobalInstantHatch") end,
    SetInstant=function(value) workspace:SetAttribute("GlobalInstantHatch",value) end,
    FindScript=function()
        local scripts=player:FindFirstChild("PlayerScripts")
        if not scripts then return nil end
        for _,candidate in ipairs(scripts:GetDescendants()) do
            if candidate:IsA("LocalScript") and candidate.Name:lower():gsub("[%s_]","")=="eggopeningfrontend" then return candidate end
        end
    end,
    ScriptEnv=function(source)
        if type(getsenv)=="function" then return getsenv(source) end
    end,
    Hook=type(hookfunction)=="function" and hookfunction or nil,
    OpeningCount=openingCount,
    TapWaiting=function(source)
        local count=0
        local mouse=player:GetMouse()
        if type(getconnections)=="function" and type(getfenv)=="function" then
            for _,connection in ipairs(getconnections(mouse.Button1Down)) do
                local callback=connection.Function
                if connection.Enabled~=false and type(callback)=="function" then
                    local ok,scope=pcall(getfenv,callback)
                    if ok and type(scope)=="table" and scope.script==source then
                        callback();count+=1
                    end
                end
            end
        end
        if count==0 and type(firesignal)=="function" then firesignal(mouse.Button1Down);count=1 end
        return count
    end,
})
local function message(text) if api.Info then api.Info:Set(tostring(text),true) end end
local function root()
    local character=player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health>0 and character:FindFirstChild("HumanoidRootPart") or nil
end
local function position(model)
    if model:IsA("BasePart") then return model.Position end
    if model:IsA("Model") then return model:GetPivot().Position end
end
local function activeZone()
    if config.Zone~="Current" then return config.Zone end
    return module("MapCmds").GetCurrentZone()
end
local function targetInfo(id,model)
    local r=root();local p=model and model.Parent and position(model)
    if not r or not p then return nil end
    return {id=id,model=model,name=model.Name,distance=(r.Position-p).Magnitude,zone=activeZone(),classSelection=config.Class}
end
local deps={}
deps.Now=now
deps.Save=function() return module("Save").Get() or {} end
deps.Ready=function() return not destroyed and module("Save").Get()~=nil end
deps.CanInvoke=function() return rpcPending()==nil end
deps.Invoke=function(name,...)
    if rpcPending() then return false,"Waiting for previous server request" end
    local packet=table.pack(...)
    local ticket={name=name,started=now()}
    env.DevilPetSimRPCPending=ticket
    task.spawn(function()
        ticket.result=table.pack(pcall(function() return module("Network").Invoke(name,table.unpack(packet,1,packet.n)) end))
        ticket.done=true
        if rpcPending()==ticket then env.DevilPetSimRPCPending=nil end
    end)
    while not ticket.done and now()-ticket.started<12 and not destroyed do task.wait(0.05) end
    if not ticket.done then return false,"Request pending; no duplicate request sent" end
    if not ticket.result[1] then error(ticket.result[2]) end
    return table.unpack(ticket.result,2,ticket.result.n)
end
deps.Fire=function(name,...) module("Network").Fire(name,...) end
deps.Pets=function() return module("PlayerPet").GetByPlayer(player) end
deps.PetOnTarget=function(pet,target)
    return pet:GetTarget()==target.model and pet:GetTargetType()=="Breakable" and pet:GetTargetValue()==target.id
end
deps.AssignPet=function(pet,target)
    assert(target.model:GetAttribute("BreakableClass") and target.model:GetAttribute("BreakableUID")==target.id,"Invalid native breakable target")
    pet:SetTarget(target.model)
end
deps.JoinPets=function(assigned,target)
    local route,join={},{}
    local types=require(RS.Library.Types.Pets)
    local count=0
    for id,pet in pairs(deps.Pets()) do
        if assigned[id]==target.id and not pet.destroyed and pet.euid and deps.PetOnTarget(pet,target) then
            route[pet.euid]={t=types.TargetTypeId.Breakable,v=target.id}
            join[pet.euid]=target.id;count+=1
        end
    end
    if count>0 then
        deps.Fire("CQ_Route",route)
        deps.Fire("Breakables_JoinPetBulk",join)
    end
    return count
end
deps.TargetHealth=function(target)
    local record=module("BreakableFrontend").Get(target.id)
    return record and type(record.health)=="number" and record.health or nil
end
deps.ClearAssigned=function(assigned)
    for id,pet in pairs(deps.Pets()) do if assigned[id] then pet:ClearTarget() end end
end
deps.FindTarget=function()
    if not root() then return nil end
    local zone=activeZone()
    if not zone then return nil end
    local instance=module("InstancingCmds")
    local breakables=module("BreakableCmds")
    local pools={}
    local classes=config.Class=="All" and {"Chest","Normal"} or {config.Class}
    if instance.IsInInstance() then
        pools[1]=breakables.AllByInstanceAndClasses(table.unpack(classes))
    else
        if not module("ZoneCmds").Owns(zone) then return nil end
        for _,class in ipairs(classes) do table.insert(pools,breakables.AllByZoneAndClass(zone,class)) end
    end
    local best
    for _,pool in ipairs(pools) do
        for id,model in pairs(pool) do
            local t=targetInfo(id,model)
            if t and t.distance<=config.Radius and (not best or t.distance<best.distance) then best=t end
        end
    end
    -- Also inspect loaded native models when the legacy index has not caught up.
    if not best then
        local things=workspace:FindFirstChild("__THINGS")
        local folder=things and things:FindFirstChild("Breakables")
        if folder then
            local parentTypes=require(RS.Library.Types.Breakables).ParentType
            local instanceId=instance.GetInstanceID()
            for _,model in ipairs(folder:GetChildren()) do
                local class=model:GetAttribute("BreakableClass")
                local uid=model:GetAttribute("BreakableUID")
                local parent=model:GetAttribute("ParentID")
                local parentType=model:GetAttribute("ParentType")
                local inZone=instanceId and parentType==parentTypes.Instance and parent==instanceId or
                    not instanceId and parentType==parentTypes.Zone and parent==zone
                if uid and inZone and (config.Class=="All" or class==config.Class) then
                    local t=targetInfo(uid,model)
                    if t and t.distance<=config.Radius and (not best or t.distance<best.distance) then best=t end
                end
            end
        end
    end
    return best
end
deps.TargetValid=function(target)
    if target.zone~=activeZone() or target.classSelection~=config.Class then return false end
    local model=module("BreakableCmds").Get(target.id)
    if not model or not model.Parent then return false end
    target.model=model
    local t=targetInfo(target.id,model)
    if not t or t.distance>config.Radius then return false end
    target.distance=t.distance;return true
end
deps.OrbBatch=function(limit,includeItems)
    local out={}
    for id,record in pairs(orbQueue) do
        if now()-record.created>30 then orbQueue[id]=nil;orbCount-=1
        elseif (includeItems or not record.lootbag) and #out<limit then out[#out+1]=id end
    end
    return out
end
deps.OrbSent=function(ids) for _,id in ipairs(ids) do if orbQueue[id] then orbQueue[id]=nil;orbCount-=1 end end end
deps.SetMagnet=function(enabled)
    if not enabled or magnetHook then return magnetMode end
    if type(hookfunction)~="function" then return "PacketCollect" end
    local parent=client:FindFirstChild("OrbCmds")
    local source=parent and parent:FindFirstChild("Orb")
    if not source then return "PacketCollect" end
    local class=require(source)
    local target=class.RenderStepped
    if type(target)~="function" then return "PacketCollect" end
    local original
    original=hookfunction(target,function(orb,...)
        if destroyed or not config.Magnet then return original(orb,...) end
        local args=table.pack(...)
        if args.n<8 then return original(orb,...) end
        local previous=orb._superMagnet
        orb._superMagnet=true
        args[7]=math.max(tonumber(args[7]) or 0,config.MagnetRange)
        args[8]=true
        local result=table.pack(pcall(original,orb,table.unpack(args,1,args.n)))
        orb._superMagnet=previous
        if not result[1] then error(result[2],0) end
        return table.unpack(result,2,result.n)
    end)
    if type(original)~="function" then return "PacketCollect" end
    magnetHook={target=target,original=original};magnetMode="NativeAttraction";return magnetMode
end
deps.MagnetMode=function() return magnetMode end
deps.Egg=function(id) return dirs().Eggs[id] end
deps.SetHatchBypass=function(enabled) return hatchSkip.Set(enabled and config.SkipHatchAnimation) end
local function liveEgg(id,egg)
    local things=workspace:FindFirstChild("__THINGS")
    if egg.eggNumber then
        local modelName=require(RS.Library.Util.WorldsUtil).GetEggsModelName()
        if things and modelName then
            for _,name in ipairs({"Eggs","ZoneEggs"}) do
                local folder=things:FindFirstChild(name)
                local world=folder and folder:FindFirstChild(modelName)
                if world then
                    for _,stand in ipairs(world:GetChildren()) do
                        if tonumber(stand.Name:match("^(%d+)"))==egg.eggNumber then
                            local center=stand:FindFirstChild("Center",true)
                            return center and center:IsA("BasePart") and center.Position or position(stand)
                        end
                    end
                end
            end
        end
        return nil
    end
    local custom=module("CustomEggsCmds")
    local uid=custom.GetClosestById(id)
    local live=uid and custom.Get(uid)
    return live and live:GetPosition(),live,uid
end
deps.ApproachEgg=function(id)
    if destroyed or not config.Hatch then return false,"Cancelled" end
    local egg=dirs().Eggs[id]
    local point=egg and liveEgg(id,egg)
    local r=root()
    if not point or not r then return false,"Selected egg model is not loaded" end
    -- Use the game's own teleport helper once, then verify the actual distance.
    local teleport=require(RS.Library.Functions.TeleportCharacterTo)
    local destination=point+Vector3.new(0,-2,8)
    r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero
    teleport(destination,point)
    local started=now();local distance;local stable=0
    while not destroyed and config.Hatch and now()-started<1.5 do
        r=root();distance=r and (r.Position-point).Magnitude or math.huge
        if distance<=14 then stable+=1 else stable=0 end
        if stable>=3 then return true,"",distance end
        task.wait(0.1)
    end
    return false,"Position not stable near selected egg",distance
end
deps.HatchPlan=function(id,egg,requested)
    hatchSkip.Set(config.Hatch and config.SkipHatchAnimation)
    hatchSkip.Pulse()
    if openingCount()>0 then return {blocked="Waiting for hatch reveal to finish"} end
    local cmd=module("EggCmds")
    if module("HatchingCmds").IsHatching() then return {blocked="Native auto hatch already running"} end
    local max=math.max(1,math.floor(cmd.GetMaxHatch(egg)))
    local plan={id=id,remote="Eggs_RequestPurchase",maxHatch=max,cooldown=cmd.ComputeDebounce()}
    local r=root()
    if not r then return {blocked="Waiting for character"} end
    if egg.eggNumber then
        if not cmd.IsEggAvailable(id) then return {blocked="Unlock more zones to make this egg available",egg=id} end
        local p=liveEgg(id,egg)
        if not p then return {blocked="Selected egg model is not loaded",egg=id} end
        plan.distance=p and (r.Position-p).Magnitude or nil
        plan.locked=not cmd.IsUnlocked(id)
    else
        local point,live,uid=liveEgg(id,egg)
        if not live or not live:IsHatchable() then return {blocked="Selected custom egg is not active or hatchable",egg=id} end
        local cap=live:GetMaxEggCount()
        if type(cap)=="number" then max=math.min(max,math.max(1,math.floor(cap))) end
        plan.id=uid;plan.remote="CustomEggs_Hatch";plan.maxHatch=max
        plan.distance=(r.Position-point).Magnitude
    end
    local price=require(RS.Library.Balancing.CalcEggPricePlayer)(egg)
    if type(price)~="number" or price<0 or price~=price then return {blocked="Egg price unavailable",egg=id} end
    plan.price=price
    local count=math.clamp(math.floor(requested),1,max)
    if price>0 then
        if not egg.currency then return {blocked="Egg currency unavailable",egg=id} end
        count=math.min(count,math.floor(module("CurrencyCmds").Get(egg.currency)/price))
    end
    if count<1 then return {blocked="Insufficient currency for this egg",egg=id,price=price,distance=plan.distance} end
    if plan.distance and plan.distance>14 then
        if config.AutoApproachEgg then plan.needsApproach=true
        else plan.blocked="Move closer to selected egg" end
        return plan
    end
    if plan.locked then plan.remote="Eggs_RequestUnlock";return plan end
    plan.count=count;return plan
end
deps.EquipBest=function() module("PetCmds").EquipBest() end
deps.EquippedSnapshot=function()
    local ids={}
    for id,pet in pairs(module("PetCmds").GetEquipped()) do ids[#ids+1]=tostring(pet.euid or id) end
    table.sort(ids);return table.concat(ids,"|")
end
deps.Gifts=function()
    local out={};for _,gift in pairs(dirs().FreeGifts) do out[#out+1]=gift end
    table.sort(out,function(a,b) return a.WaitTime<b.WaitTime end);return out
end
deps.RankRewards=function(rank)
    for _,entry in pairs(dirs().Ranks) do if entry.RankNumber==rank then return entry.Rewards or {} end end
    local cmd=require(RS.Library.Util.RanksUtil)
    local id=cmd.RankIDFromNumber(rank)
    return id and dirs().Ranks[id] and dirs().Ranks[id].Rewards or {}
end
deps.NextZone=function() local _,zone=module("ZoneCmds").GetNextZone();return zone end
deps.ZoneQuestsReady=function() return module("ZoneCmds").HasCompletedNextZoneQuests() end
deps.GatePrice=function(zone) return zone.Currency,require(RS.Library.Balancing).CalcGatePrice(zone) end
deps.Currency=function(currency) return module("CurrencyCmds").Get(currency) end
deps.NextRebirth=function() return module("RebirthCmds").GetNextRebirth() end
deps.MaxZoneNumber=function() local _,zone=module("ZoneCmds").GetMaxOwnedZone();return zone and zone.ZoneNumber or 0 end
deps.WorldNumber=function() return require(RS.Library.Util.WorldsUtil).GetWorldNumber() end
deps.ZoneDirectory=function() return dirs().Zones end
deps.ZoneOwns=function(id) return module("ZoneCmds").Owns(id) end
deps.ZoneEligible=function(id) return module("ZoneCmds").MeetsRequirement(id)==true end
deps.CanTeleport=function(id)
    if module("InstancingCmds").IsInInstance() then return false,"Leave the instance before world-zone teleport" end
    return module("TeleportMapCmds").CanTeleportTo(id)
end
deps.WaitForZone=function(id)
    local started=now()
    while not destroyed and now()-started<6 do
        if module("MapCmds").GetCurrentZone()==id then return true end
        task.wait(0.1)
    end
    return false
end
deps.Destroy=function()
    hatchSkip.Destroy()
    if magnetHook then
        pcall(hookfunction,magnetHook.target,magnetHook.original)
        magnetHook=nil
    end
    for _,connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
    table.clear(connections);table.clear(orbQueue);orbCount=0
end
local labels={
    Farm={"Pet Farm","ฟาร์มด้วยสัตว์"},Tap={"Auto Tap","ตีเป้าหมายอัตโนมัติ"},Orbs={"Collect Orbs","เก็บออร์บอัตโนมัติ"},
    Magnet={"Item Magnet / Orbs + Lootbags","แม่เหล็กดูดออร์บและของดรอป"},
    Hatch={"Open Selected Egg","เปิดไข่ที่เลือก"},Equip={"Equip Best","ใส่สัตว์ดีที่สุด"},
    Gifts={"Free Gifts","รับของขวัญเวลาเล่น"},Ranks={"Rank Rewards","รับรางวัล Rank"},
    Zones={"Buy Next Zone","ซื้อด่านถัดไป"},Rebirth={"Auto Rebirth","รีเบิร์ธอัตโนมัติ"}}
local texts={
    Disabled="ปิดอยู่",Enabled="เปิดแล้ว",Confirmed="ยืนยันสำเร็จ",
    ["Waiting for loaded targets in selected zone"]="รอเป้าหมายในโซนที่เลือกโหลด",
    ["Equip pets first"]="ใส่สัตว์ก่อน",["Pet target and join requested"]="ส่งเป้าหมายและคำขอให้สัตว์เข้าตีแล้ว",
    ["No damage observed; check pet reach or selected zone"]="ยังไม่เห็นดาเมจ ตรวจระยะสัตว์และโซนที่เลือก",
    ["Target taking damage"]="เป้าหมายกำลังเสียเลือด",
    ["Native auto hatch already running"]="ระบบเปิดไข่ของเกมกำลังทำงานอยู่",
    ["Waiting for hatch reveal to finish"]="รอเกมแสดงผลรอบเปิดไข่ให้เสร็จ",
    ["Selected egg model is not loaded"]="ยังไม่พบโมเดลไข่ที่เลือกในโลกนี้",
    ["Move closer to selected egg"]="เข้าใกล้ไข่ที่เลือกก่อนเปิด",
    ["Arrived near selected egg"]="ถึงจุดเปิดไข่แล้ว",
    ["Egg approach not confirmed"]="ยังไม่ยืนยันว่าไปถึงไข่",
    ["Waiting for character"]="รอตัวละครพร้อม",
    ["Unlock more zones to make this egg available"]="ต้องปลดล็อกด่านเพิ่มก่อนเปิดไข่นี้",
    ["Egg unlock requested; waiting for replication"]="ส่งคำขอปลดล็อกไข่แล้ว รอข้อมูลเกม",
    ["Server rejected egg unlock"]="เกมปฏิเสธปลดล็อกไข่",
    ["Selected custom egg is not active or hatchable"]="ไข่ Custom ที่เลือกยังไม่เปิดหรือยังฟักไม่ได้",
    ["Egg price unavailable"]="ไม่พบราคาไข่",["Egg currency unavailable"]="ไม่พบสกุลเงินของไข่",
    ["Insufficient currency for this egg"]="เงินไม่พอเปิดไข่นี้",
    ["Handled by item magnet"]="ใช้ระบบแม่เหล็กเก็บแทน",
    ["Native item magnet active; server inventory controls rewards"]="เปิดแรงดึงดูดของแล้ว กระเป๋าขึ้นอยู่กับผลจากเกม",
    ["Selecting zone"]="กำลังเลือกด่าน",["Sending one teleport request"]="ส่งคำขอวาร์ปครั้งเดียว",
    ["No eligible zone in this world"]="ไม่มีด่านที่เข้าได้ในโลกนี้",
    ["Teleport blocked by game conditions"]="วาร์ปติดเงื่อนไขของเกม",
    ["Waiting for previous server request"]="รอคำขอก่อนหน้าเสร็จ",
    ["Server rejected teleport"]="เกมปฏิเสธการวาร์ป",
    ["Teleport arrival confirmed"]="ยืนยันถึงด่านแล้ว",
    ["Accepted; arrival not confirmed"]="เกมรับคำขอ ยังไม่ยืนยันว่าถึงด่าน",
    ["Teleport error"]="วาร์ปเกิดข้อผิดพลาด",
    ["Move closer to target"]="เข้าใกล้เป้าหมายก่อน",["Select an egg first"]="เลือกไข่ก่อน",
    ["Selected egg unavailable"]="ไม่พบไข่ที่เลือก",["Hatch confirmed"]="เกมยืนยันเปิดไข่",
    ["Server rejected hatch"]="เกมปฏิเสธเปิดไข่",["Waiting for new server-created orbs"]="รอออร์บใหม่จากเกม",
    ["Collection requested; inventory not yet confirmed"]="ส่งคำขอเก็บแล้ว ยังไม่ยืนยันกระเป๋า",
    ["Tap requested; damage not yet confirmed"]="ส่งคำขอตีแล้ว ยังไม่ยืนยันดาเมจ",
    ["Equip Best requested; watching equipped pets"]="ส่งคำขอ Equip Best รอการเปลี่ยนสัตว์",
    ["Waiting for player profile"]="รอข้อมูลผู้เล่น",["Error; see report"]="เกิดข้อผิดพลาด ดูรายงาน",
    ["Waiting for server confirmation"]="รอเกมยืนยัน",["No confirmation; waiting before retry"]="ยังไม่ยืนยัน รอก่อนลองใหม่",
    ["Waiting for eligible gifts"]="รอของขวัญครบเวลา",["Waiting for eligible rank rewards"]="รอรางวัล Rank ที่รับได้",
    ["Gift confirmed"]="เกมยืนยันรับของขวัญ",["Server rejected gift"]="เกมปฏิเสธของขวัญ",
    ["No next zone"]="ไม่มีด่านถัดไป",["Complete zone quests first"]="ทำเควสต์ด่านให้ครบก่อน",
    ["Zone price unavailable"]="ไม่พบราคาด่าน",["Insufficient funds after reserve"]="เงินไม่พอหลังหักเงินสำรอง",
    ["Zone purchase confirmed"]="เกมยืนยันซื้อด่าน",["Server rejected zone purchase"]="เกมปฏิเสธซื้อด่าน",
    ["Maximum rebirth reached"]="รีเบิร์ธถึงสูงสุด",["Unlock required zone first"]="เปิดด่านที่ต้องการก่อน",
    ["Rebirth confirmed"]="เกมยืนยันรีเบิร์ธ",["Server rejected rebirth"]="เกมปฏิเสธรีเบิร์ธ"}
local function t(en,th) return config.Language=="TH" and th or en end
local function refresh(report)
    if destroyed then return end
    for name,j in pairs(report.jobs) do
        local widget=paragraphs[name]
        if widget then
            local counters=t("Requests: ","คำขอ: ")..j.requests..t(" | Server accepted: "," | เกมตอบรับ: ")..j.confirmed
            if name=="Farm" then
                counters=t("Pets assigned: ","สัตว์ที่ส่ง: ")..(j.pets or 0)..t(" | Damage updates: "," | ครั้งที่เห็นดาเมจ: ")..(j.damageUpdates or 0)
            elseif name=="Orbs" or name=="Magnet" or name=="Tap" then
                counters=t("Requests: ","คำขอ: ")..j.requests..t(" | No reply on this event"," | คำขอนี้ไม่มีผลตอบกลับ")
            end
            widget:Set((config.Language=="TH" and texts[j.status] or nil or j.status)..
                "\n"..counters..
                (j.serverMessage and j.serverMessage~="" and "\n"..j.serverMessage or "")..
                (j.targetName and "\n"..j.targetName or "")..
                (name=="Hatch" and config.SkipHatchAnimation and config.Hatch and
                    ("\n"..((hatchSkip.Report.mode=="AnimationHook" or hatchSkip.Report.mode=="AnimationEnvironment") and
                        t("Egg presentation bypass active","ข้ามหน้าเปิดไข่แล้ว") or t("Instant Tap bypass active","ข้ามช่วง Tap อัตโนมัติ"))) or ""),true)
        end
    end
    if api.TravelInfo and report.travel then
        local tr=report.travel
        api.TravelInfo:Set((config.Language=="TH" and texts[tr.status] or nil or tr.status)..(tr.zone and "\n"..tr.zone or "")..
            (tr.serverMessage and tr.serverMessage~="" and "\n"..tr.serverMessage or ""),true)
    end
end
function api.Teleport(probe)
    task.spawn(function()
        local ok,problem=pcall(core.Teleport,probe)
        if not ok then message(problem) end
        if ok and not destroyed and build then build() end
    end)
end
function api.SaveReport()
    core.Report.placeId=game.PlaceId;core.Report.userId=player.UserId
    local pending=rpcPending()
    core.Report.pendingRPC=pending and {name=pending.name,age=now()-pending.started} or nil
    core.Report.config=config;core.Report.orbsQueued=orbCount
    core.Report.hatchUI=hatchSkip.Report
    local bytes=Http:JSONEncode(core.Report)
    local saved,copied=false,false
    if type(writefile)=="function" then saved=pcall(writefile,"DevilPetSimTestReport.json",bytes) end
    if type(setclipboard)=="function" then copied=pcall(setclipboard,bytes) end
    message(t("Report: ","รายงาน: ")..(saved and "DevilPetSimTestReport.json" or t("file API unavailable","เขียนไฟล์ไม่ได้"))..
        (copied and t(" | copied"," | คัดลอกแล้ว") or ""))
    return bytes
end
function api.Destroy()
    if destroyed then return end
    destroyed=true
    if core then core.Destroy() else deps.Destroy() end
    if window then window:Destroy();window=nil end
    if env.DevilPetSimTest==api then env.DevilPetSimTest=nil end
end
local library
build=function()
    rebuilding=true
    if window then window:Destroy() end
    paragraphs={};controls={}
    local image=makeLogo()
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,Theme="Crimson",Density="Compact",Profile=true,
        Search=false,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,
        Size=UDim2.fromOffset(820,570),ToggleButton={Platform="Both",Icon=image},KeepOnScreen=true,
        ConfigurationSaving={Enabled=false}})
    local bound=window
    if window.Gui then window.Gui.Destroying:Connect(function() if not rebuilding and window==bound then api.Destroy() end end) end
    local function tab(en,th,icon) return window:CreateTab({Name=t(en,th),Icon=icon,Backdrop=false}) end
    local function group(parent,en,th,side,icon) return parent:CreateGroupbox({Name=t(en,th),Side=side,Icon=icon}) end
    local function toggle(parent,name)
        controls[name]=parent:CreateToggle({Name=t(table.unpack(labels[name])),CurrentValue=config[name],Callback=function(value) core.Set(name,value) end})
        paragraphs[name]=parent:CreateParagraph({Name=t("Status","สถานะ"),Content=""})
    end
    local farmTab=tab("Farm","ฟาร์ม","pickaxe")
    local farm=group(farmTab,"Farming","ระบบฟาร์ม","Left","pickaxe")
    toggle(farm,"Farm");toggle(farm,"Tap");toggle(farm,"Orbs");toggle(farm,"Magnet");toggle(farm,"Equip")
    local selection=group(farmTab,"Target filters","เลือกเป้าหมาย","Right","filter")
    local zoneOptions={t("Current zone","โซนที่ยืนอยู่")};local zoneIds={[zoneOptions[1]]="Current"};local zoneCurrent=zoneOptions[1]
    local zones={};for id,zone in pairs(dirs().Zones) do zones[#zones+1]={id=id,n=zone.ZoneNumber or 0} end
    table.sort(zones,function(a,b) return a.n<b.n end)
    for _,zone in ipairs(zones) do
        local label=string.format("%03d | %s",zone.n,zone.id)
        zoneOptions[#zoneOptions+1]=label;zoneIds[label]=zone.id
        if config.Zone==zone.id then zoneCurrent=label end
    end
    selection:CreateDropdown({Name=t("Zone","โซน"),Options=zoneOptions,CurrentOption={zoneCurrent},Searchable=true,Callback=function(value)
        value=type(value)=="table" and value[1] or value;config.Zone=zoneIds[value] or "Current"
    end})
    selection:CreateDropdown({Name=t("Target type","ประเภทเป้าหมาย"),Options={"All","Chest","Normal"},CurrentOption={config.Class},Callback=function(value)
        config.Class=type(value)=="table" and value[1] or value
    end})
    selection:CreateSlider({Name=t("Search radius","ระยะหาเป้าหมาย"),Range={25,300},Increment=5,CurrentValue=config.Radius,Callback=function(value) config.Radius=value end})
    selection:CreateSlider({Name=t("Item magnet radius","ระยะแม่เหล็กดูดของ"),Range={50,3000},Increment=50,CurrentValue=config.MagnetRange,Callback=function(value) config.MagnetRange=value end})
    selection:CreateParagraph({Name=t("Farm behavior","รูปแบบฟาร์ม"),Content=t(
        "Locks one loaded target until it disappears. Sends your equipped pets using the game controller. Stand in a breakable zone. Auto Tap needs a nearby target.",
        "ล็อกเป้าหมายจนหาย ใช้สัตว์ที่ใส่อยู่ผ่านระบบเกม ให้ยืนในโซนฟาร์ม Auto Tap ต้องอยู่ใกล้เป้าหมาย")})
    selection:CreateButton({Name=t("Teleport to Highest Unlocked Zone","วาร์ปไปด่านสูงสุดที่เข้าได้"),Callback=function() api.Teleport(false) end})
    selection:CreateButton({Name=t("Try Final Zone Once","ลองเข้าด่านสุดท้ายครั้งเดียว"),Callback=function() api.Teleport(true) end})
    api.TravelInfo=selection:CreateParagraph({Name=t("Teleport status","สถานะวาร์ป"),Content=t(
        "Current world only. Final-zone test sends one request, skips the client ownership gate, and stops if the server rejects it. Arrival is checked separately from unlock.",
        "เฉพาะโลกที่อยู่ ปุ่มทดลองส่งคำขอครั้งเดียว ข้ามตัวเช็คสิทธิ์ฝั่งผู้เล่น หยุดเมื่อเกมปฏิเสธ แยกผลถึงด่านออกจากการปลดล็อก")})
    local eggTab=tab("Eggs","เปิดไข่","egg")
    local hatch=group(eggTab,"Hatching","ระบบเปิดไข่","Left","egg")
    local eggOptions={t("Select an egg","เลือกไข่")};local eggIds={};local eggCurrent=eggOptions[1];local eggs={}
    local eggCmd=module("EggCmds")
    local util=require(RS.Library.Util.WorldsUtil)
    local currency=type(util.GetWorldCurrency)=="function" and util.GetWorldCurrency() or nil
    for id,egg in pairs(dirs().Eggs) do
        if type(egg.eggNumber)=="number" and egg.eggNumber>0 and eggCmd.IsEggAvailable(id) and (not currency or egg.currency==currency) then
            eggs[#eggs+1]={id=id,n=egg.eggNumber}
        end
    end
    table.sort(eggs,function(a,b) if a.n==b.n then return a.id<b.id end;return a.n<b.n end)
    for _,egg in ipairs(eggs) do
        local label=string.format("%03d | %s",egg.n,egg.id);eggOptions[#eggOptions+1]=label;eggIds[label]=egg.id
        if config.Egg==egg.id then eggCurrent=label end
    end
    local ok,customs=pcall(function() return module("CustomEggsCmds").All() end)
    if ok and type(customs)=="table" then
        local liveIds={}
        for _,live in pairs(customs) do
            if live:IsRenderable() and live:IsHatchable() then
                local dir=live:Directory()
                if dir and dir._id and dirs().Eggs[dir._id] and not dir.eggNumber then liveIds[dir._id]=true end
            end
        end
        local ids={};for id in pairs(liveIds) do ids[#ids+1]=id end;table.sort(ids)
        for _,id in ipairs(ids) do
            local label=t("Event | ","อีเวนต์ | ")..id
            eggOptions[#eggOptions+1]=label;eggIds[label]=id
            if config.Egg==id then eggCurrent=label end
        end
    end
    if config.Egg~="" and eggCurrent==eggOptions[1] then config.Egg="" end
    hatch:CreateDropdown({Name=t("Egg","ไข่"),Options=eggOptions,CurrentOption={eggCurrent},Searchable=true,Callback=function(value)
        value=type(value)=="table" and value[1] or value;config.Egg=eggIds[value] or ""
    end})
    hatch:CreateSlider({Name=t("Eggs per request","จำนวนไข่ต่อครั้ง"),Range={1,100},Increment=1,CurrentValue=config.HatchCount,Callback=function(value) config.HatchCount=value end})
    hatch:CreateButton({Name=t("Refresh Available Eggs","รีเฟรชรายการไข่ที่เปิดได้"),Callback=function() task.defer(build) end})
    hatch:CreateToggle({Name=t("Go Near Egg Before Opening","ไปหาไข่ก่อนเปิดอัตโนมัติ"),CurrentValue=config.AutoApproachEgg,Callback=function(value) config.AutoApproachEgg=value==true end})
    toggle(hatch,"Hatch")
    hatch:CreateToggle({Name=t("Bypass Tap / Skip Egg Animation","ข้าม Tap To Open / หน้าเปิดไข่"),CurrentValue=config.SkipHatchAnimation,Callback=function(value)
        config.SkipHatchAnimation=value==true
        hatchSkip.Set(config.Hatch and config.SkipHatchAnimation)
    end})
    hatch:CreateParagraph({Name=t("Instant reveal","เปิดทันที"),Content=t(
        "Skips the native egg presentation when the executor supports script access. Otherwise uses the game's instant-hatch branch. Keeps the original reward confirmation and respects the server cooldown.",
        "ข้ามแอนิเมชันเปิดไข่เมื่อเครื่องมือรองรับ ถ้าไม่รองรับใช้ Instant Hatch ของเกม คงขั้นตอนยืนยันสัตว์และคูลดาวน์ของเซิร์ฟเวอร์")})
    hatch:CreateParagraph({Name=t("Game conditions","เงื่อนไขเกม"),Content=t(
        "Unlocks eligible eggs before hatching, clamps the amount to your native hatch limit and funds, and uses CustomEggs_Hatch for active custom eggs. Stand near the selected egg if the server requires distance.",
        "ปลดล็อกไข่ที่ถึงเงื่อนไขก่อนเปิด จำกัดจำนวนตามสิทธิ์และเงิน ใช้คำขอแยกสำหรับไข่ Custom ที่เปิดอยู่ หากเกมตรวจระยะให้ยืนใกล้ไข่ที่เลือก")})
    local progressTab=tab("Progress & Rewards","ความคืบหน้า / รางวัล","gift")
    local rewards=group(progressTab,"Rewards","รับรางวัล","Left","gift")
    toggle(rewards,"Gifts");toggle(rewards,"Ranks")
    local progress=group(progressTab,"Progression","ปลดล็อก","Right","flag")
    progress:CreateInput({Name=t("Zone purchase reserve","เงินสำรองสำหรับซื้อด่าน"),CurrentValue=tostring(config.Reserve),PlaceholderText="0",RemoveTextAfterFocusLost=false,Callback=function(value)
        local n=tonumber(value);if n and n>=0 and n<math.huge then config.Reserve=n end
    end})
    toggle(progress,"Zones");toggle(progress,"Rebirth")
    local settings=tab("Settings / Report","ตั้งค่า / รายงาน","settings")
    local diagnostics=group(settings,"Test report","รายงานทดลอง","Left","file-text")
    api.Info=diagnostics:CreateParagraph({Name=t("Trial build","รุ่นทดลอง"),Content="petsim-auto-test-3"})
    diagnostics:CreateButton({Name=t("Copy / Save Report","คัดลอก / บันทึกรายงาน"),Callback=api.SaveReport})
    diagnostics:CreateButton({Name=t("Stop All","หยุดออโต้ทั้งหมด"),Callback=function() core.Stop();task.defer(build) end})
    diagnostics:CreateButton({Name=t("Unload","ปิดสคริปต์"),Callback=api.Destroy})
    diagnostics:CreateParagraph({Name=t("Confirmation counters","ตัวนับผลสำเร็จ"),Content=t(
        "Requests and confirmations are separate. Orb collection, taps and pet assignment do not count as confirmed rewards. No live Roblox test has been performed.",
        "แยกคำขอออกจากผลยืนยัน การส่งสัตว์ ตี และขอเก็บออร์บไม่ถูกนับว่าได้รางวัลแล้ว รุ่นนี้ยังไม่ได้ทดสอบในเกมจริง")})
    local appearance=group(settings,"GUI","รูปแบบ GUI","Right","palette")
    appearance:CreateSlider({Name=t("Width","ความกว้าง"),Range={600,1000},Increment=10,CurrentValue=820,Callback=function(value) window:SetSize(Vector2.new(value,570),true) end})
    appearance:CreateToggle({Name=t("Transparent","โปร่งใส"),CurrentValue=false,Callback=function(value) window:SetTransparent(value) end})
    local discord=tab("Discord","Discord","message-circle")
    local social=group(discord,"DEVIL HUB","DEVIL HUB","Left","message-circle")
    social:CreateImage({Name="DEVIL HUB",Image=image,Height=120,ScaleType="Fit"})
    social:CreateParagraph({Name="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
    social:CreateButton({Name=t("Copy Invite","คัดลอกลิงก์เชิญ"),Callback=function() if type(setclipboard)=="function" then setclipboard("https://discord.gg/ZY7PRcVJe2") end end})
    if window.MinimizeButton then
        local minimize=window.MinimizeButton;local button=Instance.new("TextButton")
        button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
        button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
        button.Text="ไทย / EN";button.TextSize=13;button.Font=Enum.Font.GothamSemibold
        button.TextColor3=Color3.new(1,1,1);button.BackgroundColor3=Color3.fromRGB(45,23,30);button.Parent=minimize.Parent
        local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=button
        button.Activated:Connect(function() config.Language=config.Language=="TH" and "EN" or "TH";task.defer(build) end)
    end
    rebuilding=false;refresh(core.Report)
end
env.DevilPetSimTest=api
local ok,problem=xpcall(function()
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    local run,err=loadstring(source,"DEVIL HUB / OuroFlow");assert(run,err);library=run()
    core=makeCore(config,deps,refresh);api.Core=core
    build()
    connections[#connections+1]=module("Network").Fired("Orbs: Create"):Connect(function(batch)
        if destroyed or type(batch)~="table" then return end
        for _,packet in ipairs(batch) do
            if type(packet)=="table" and (type(packet.id)=="string" or type(packet.id)=="number") then
                if not orbQueue[packet.id] and orbCount<3000 then
                    orbQueue[packet.id]={created=now(),lootbag=type(packet.config)=="table" and packet.config.Type==2}
                    orbCount+=1
                end
            end
        end
    end)
    connections[#connections+1]=module("Network").Fired("Orbs: Clear"):Connect(function() table.clear(orbQueue);orbCount=0 end)
    for _,name in ipairs(core.Names) do
        task.spawn(function()
            while not destroyed do core.Tick(name);task.wait(0.15) end
        end)
    end
    task.spawn(function()
        while not destroyed do
            hatchSkip.Pulse()
            core.Report.hatchUI=hatchSkip.Report
            task.wait(0.15)
        end
    end)
end,debug.traceback)
if not ok then api.Destroy();error("DEVIL HUB Pet Auto Test: "..tostring(problem),0) end
return api
