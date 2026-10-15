-- DEVIL HUB standalone trial for the supplied dump.
assert(game.PlaceId==72858262610964 or game.GameId==10629695169,"Open the map from dump Place 72858262610964")
local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilTappingTest then env.DevilTappingTest.Destroy() end
local makeCore=(function()
return function(config,d,changed)
    local C={Names={"Tap","Hatch","Rebirth","Upgrade","Quests","Gifts","Equip","Enchant"},
        Report={release="tapping-auto-test-3",jobs={},errors={},liveVerified=false}}
    local jobs=C.Report.jobs
    local alive=true
    local intervals={Tap=0,Hatch=1,Rebirth=1,Upgrade=2,Quests=1,Gifts=2,Equip=8,Enchant=.5}
    local tapPending={}
    local sequence=d.SequenceStart or 1000000000
    local function enabled(name)
        return config[name] or(name=="Tap"and config.Hatch and config.HatchTap)
    end
    local function notify() if changed then pcall(changed,C.Report) end end
    local function status(name,text) jobs[name].status=text;notify() end
    for _,name in ipairs(C.Names) do jobs[name]={status="Disabled",requests=0,confirmed=0,rejected=0,nextAt=0,generation=0} end
    local function send(name,service,remote,packet)
        if not alive or not enabled(name) then return end
        jobs[name].requests+=1
        d.Fire(service,remote,packet)
    end
    local function stopHatch()
        local job=jobs.Hatch
        if not job.ownsAuto then return end
        local ok,err=pcall(d.Fire,"EggService","StopOfflineHatch")
        job.stopError=not ok and tostring(err) or nil
        job.stopRequests=(job.stopRequests or 0)+1
        job.ownsAuto=nil;job.stoppedPending=job.pending~=nil
    end
    local function rpc(name,method,packet,plan)
        if not d.CanInvoke() then status(name,"Waiting for previous request");return end
        local service=({Upgrade="UpgradeService",Quests="QuestService",Gifts="GiftService",Enchant="EnchantService"})[name]
        local job=jobs[name]
        job.rpc=d.Request(service,method,packet)
        job.rpcPlan=plan or {};job.rpcPlan.method=method;job.rpcGeneration=job.generation
        job.requests+=1;status(name,"Waiting for server result")
    end
    local function poll(name)
        local job=jobs[name];local ticket=job.rpc
        if not ticket then return false end
        if not ticket.done then
            status(name,d.Now()-ticket.started>12 and "Request pending; no duplicate sent" or "Waiting for server result")
            return true
        end
        local plan=job.rpcPlan
        job.rpc=nil;job.rpcPlan=nil
        local result=ticket.result
        local accepted=ticket.ok and type(result)=="table" and result.Success==true
        job.result=result;job.reason=not ticket.ok and tostring(ticket.error) or type(result)=="table" and result.Reason or nil
        job.nextAt=d.Now()+(accepted and intervals[name] or 5)
        if accepted then
            job.confirmed+=1
            if name=="Enchant" and plan.method=="Enchant" then
                job.enchantPending=type(result.Pending)=="table" and table.clone(result.Pending) or nil
                if job.enchantPending then job.enchantPending.PetId=job.enchantPending.PetId or plan.pet end
                job.rolls=(job.rolls or 0)+1
            elseif name=="Enchant" and plan.method=="Resolve" then
                job.enchantPending=nil
                if plan.wanted and result.Enchant==plan.enchant then
                    job.matches=(job.matches or 0)+1;config.Enchant=false
                end
            end
        else
            job.rejected+=1
            if name=="Enchant" and plan.method=="Resolve" and job.reason=="PetChangedChooseKeep" then job.keepPrevious=true end
            if not ticket.ok then
                config[name]=false;job.uncertain=true
            elseif name=="Enchant" and plan.method=="Enchant" and job.reason~="RateLimited" and job.reason~="VisitEnchantMachine" then
                config.Enchant=false
            end
        end
        if not config[name] then status(name,accepted and name=="Enchant" and plan.wanted and "Wanted enchant confirmed" or "Disabled")
        else status(name,accepted and "Server accepted" or "Server rejected request") end
        return true
    end
    local actions={}
    actions.Tap=function()
        local job=jobs.Tap
        local blocked=d.TapBlocked()
        if blocked then job.nextAt=d.Now()+.5;status("Tap",blocked);return end
        local rate=math.clamp(tonumber(config.CPS) or 40,1,100)
        local count=math.clamp(math.floor((d.Now()-job.nextAt)*rate)+1,1,4)
        job.nextAt=math.max(job.nextAt,d.Now()-.05)+count/rate
        for _=1,count do
            sequence+=1
            tapPending[sequence]=d.Now()
            send("Tap","TapService","TapRequested",{Auto=false,ClientSequence=sequence,Source="button_hold"})
        end
        job.requestedCPS=rate
        job.mode=config.Tap and "ManualToggle"or "HatchLinked"
        for id,at in pairs(tapPending) do if d.Now()-at>5 then tapPending[id]=nil;job.unanswered=(job.unanswered or 0)+1 end end
        status("Tap","Sending taps; counting server replies")
    end
    actions.Hatch=function()
        local job=jobs.Hatch
        if config.Enchant then stopHatch();status("Hatch","Waiting for enchant movement");return end
        local plan,why=d.HatchPlan(config)
        if not plan then status("Hatch",why);return end
        if d.Approach then
            local ready,reason,travel=d.Approach("Hatch",plan.egg)
            job.travel=travel
            if not ready then job.nextAt=d.Now()+.2;status("Hatch",reason);return end
        end
        sequence+=1
        job.pending={sequence=sequence,egg=plan.egg,at=d.Now(),count=plan.count}
        job.ownsAuto=true;job.stoppedPending=nil
        job.egg=plan.egg;job.count=plan.count;job.price=plan.price;job.reason=nil
        send("Hatch","EggService","EggHatchRequested",{Egg=plan.egg,Count=plan.count,Auto=true,Seq=sequence})
        status("Hatch","Waiting for server result")
    end
    actions.Rebirth=function()
        local plan,why=d.RebirthPlan(config)
        if not plan then status("Rebirth",why);return end
        jobs.Rebirth.pending={index=plan.index,at=d.Now()}
        jobs.Rebirth.index=plan.index
        jobs.Rebirth.amount=plan.amount
        send("Rebirth","RebirthService","RebirthRequested",{Index=plan.index})
        status("Rebirth","Waiting for server result")
    end
    actions.Upgrade=function()
        local plan,why=d.UpgradePlan(config)
        if not plan then status("Upgrade",why);return end
        jobs.Upgrade.target=plan.name
        rpc("Upgrade","Purchase",{Name=plan.name})
    end
    actions.Quests=function()
        local id=d.Quest()
        if not id then status("Quests","Waiting for completed quests");return end
        jobs.Quests.target=id;rpc("Quests","ClaimQuest",{Quest=id})
    end
    actions.Gifts=function()
        local name=d.Gift(config)
        if not name then status("Gifts","Select an owned gift");return end
        rpc("Gifts","OpenGift",{Gift=name,Amount=1})
    end
    actions.Equip=function()
        jobs.Equip.pending={at=d.Now()}
        send("Equip","PetService","PetActionRequested",{Action="EquipBest",Mode="Clicks"})
        status("Equip","Waiting for server result")
    end
    actions.Enchant=function()
        local job=jobs.Enchant
        if jobs.Hatch.pending then status("Enchant","Waiting for hatch result before moving");return end
        stopHatch()
        local function approach()
            if not d.Approach then return true end
            local ready,reason,travel=d.Approach("Enchant")
            job.travel=travel
            if not ready then job.nextAt=d.Now()+.2;status("Enchant",reason)end
            return ready
        end
        local pending=job.enchantPending
        if pending then
            if pending.PetId and pending.PetId~=config.EnchantPet then status("Enchant","Finish pending enchant on previous pet");return end
            if not approach() then return end
            assert(type(pending.Token)=="string","Missing native enchant token")
            local wanted=not job.keepPrevious and config.EnchantFilters[pending.Enchant]==true
            rpc("Enchant","Resolve",{Token=pending.Token,UseNew=wanted},{enchant=pending.Enchant,wanted=wanted})
            return
        end
        local plan,why=d.EnchantPlan(config)
        if not plan then
            if why=="Selected pet already has wanted enchant" then config.Enchant=false end
            status("Enchant",why);return
        end
        if not approach() then return end
        job.keepPrevious=nil
        rpc("Enchant","Enchant",{PetId=plan.id,Slot=config.EnchantSlot,RequestId=d.GUID()},{pet=plan.id})
    end
    function C.Tick(name)
        local job=assert(jobs[name])
        if not alive then return end
        if poll(name) then return end
        if not enabled(name) then
            if name=="Tap"and job.mode=="HatchLinked"then job.mode=nil;status(name,"Disabled")end
            return
        end
        if job.pending then
            if d.Now()-job.pending.at>12 then
                config[name]=false;job.uncertain=true
                if name=="Hatch" then stopHatch() end
                status(name,"No confirmation; stopped to avoid duplicate purchases")
            end
            return
        end
        if d.Now()<job.nextAt then return end
        if (name=="Hatch" and jobs.Rebirth.pending) or (name=="Rebirth" and jobs.Hatch.pending) then
            status(name,"Waiting for other coin purchase");return
        end
        if name~="Tap" then job.nextAt=d.Now()+intervals[name] end
        local ok,problem=xpcall(function()
            if not d.Data() then status(name,"Waiting for player data");return end
            actions[name]()
        end,function(err)return tostring(err)end)
        if not ok then
            job.nextAt=d.Now()+5;job.error=problem;status(name,"Error; save report")
            table.insert(C.Report.errors,{job=name,message=problem,t=d.Now()})
            if #C.Report.errors>30 then table.remove(C.Report.errors,1) end
        end
    end
    function C.Receive(name,result)
        if not alive or type(result)~="table" then return end
        local job=jobs[name]
        if name=="Tap" then
            local id=result.ClientSequence
            if not id or not tapPending[id] then return end
            tapPending[id]=nil
            if type(result.Amount)=="number" and result.Amount>0 then
                job.confirmed+=1;job.income=(job.income or 0)+result.Amount
            else job.rejected+=1 end
            notify();return
        end
        local pending=job.pending
        if not pending then return end
        if name=="Hatch" and ((result.Seq~=nil and result.Seq~=pending.sequence) or result.Egg~=pending.egg or result.Forced==true) then return end
        if name=="Rebirth" and result.Index~=nil and result.Index~=pending.index then return end
        if name=="Equip" and result.Action~="EquipBest" then return end
        if name=="Hatch" and not config.Hatch and job.stoppedPending then job.ownsAuto=true;stopHatch() end
        job.pending=nil;job.result=result;job.reason=result.Error or result.Reason
        if name=="Hatch" then job.correlation=result.Seq~=nil and "SequenceMatched" or "UnsequencedSameEgg" end
        if result.Success==true then
            job.confirmed+=1;job.nextAt=d.Now()+(name=="Hatch" and config.HatchDelay or intervals[name])
        else
            job.rejected+=1
            job.nextAt=d.Now()+((job.reason=="RateLimited") and 2 or 8)
        end
        if config[name] then status(name,result.Success==true and "Server accepted" or "Server rejected request") else notify() end
    end
    function C.Set(name,value)
        assert(jobs[name],"Unknown automation")
        config[name]=value==true;jobs[name].generation+=1;jobs[name].nextAt=d.Now()
        if name=="Hatch" and not config.Hatch then stopHatch() end
        status(name,value and "Enabled" or "Disabled")
    end
    function C.Stop()
        for _,name in ipairs(C.Names) do C.Set(name,false) end
        config.InfiniteJump=false;notify()
    end
    function C.Destroy() C.Stop();alive=false;table.clear(tapPending) end
    return C
end

end)()
local makeAdapter=(function()
return function(config,d)
    local A={Data=d.Data,Now=d.Now,Fire=d.Fire,Request=d.Request,CanInvoke=d.CanInvoke,GUID=d.GUID,SequenceStart=d.SequenceStart,Approach=d.Approach}
    local function get(path) return d.Module(path) end
    function A.Eggs() return get("Shared.Pets.LaunchEggConfig") end
    function A.Gifts() return get("Shared.Items.GiftConfig").Pools end
    function A.Enchants() return get("Shared.Pets.EnchantConfig").Enchants end
    function A.RebirthAmounts()
        local world=d.Data() and d.Data().Progression.World or "Main"
        local out={"Auto"}
        for index=1,get("Shared.Progression.RebirthButtonConfig").GetMaximumOptions(world) do
            out[#out+1]=tostring(get("Shared.Progression.RebirthConfig").GetAmountFromIndex(index))
        end
        return out
    end
    function A.TapBlocked()
        for _,key in ipairs({"MiningActive","AtDigsite","DiggingActive","ColosseumActive"}) do
            if d.Attribute(key)==true then return "Finish current minigame before tapping" end
        end
        if get("Shared.Progression.OnboardingFlow").IsPending(d.Data()) then return "Finish game introduction first" end
    end
    function A.HatchPlan(c)
        if c.Egg=="" then return nil,"Select an egg" end
        if d.NativeHatch() then return nil,"Stop game auto hatch first" end
        local data=d.Data()
        local egg=A.Eggs()[c.Egg]
        if not egg then return nil,"Selected egg unavailable" end
        if egg.Island and not (data.Progression.UnlockedIslands or {})[egg.Island] then return nil,"IslandLocked" end
        local perks=get("Shared.Monetization.GamepassPerks")
        local boosts=get("Shared.Items.BoostFormula")
        local max=(perks.Has(data,"x8Egg") or boosts.HasType(data,"OctoHatch")) and 8 or 3
        local total=0;for _ in pairs(data.Pets.Owned or {}) do total+=1 end
        local free=(data.Pets.StorageLimit or 0)-total
        local requested=tonumber(c.HatchCount) or 1
        local pricing=get("Shared.Pets.EggPricing")
        for _,count in ipairs({8,3,1}) do
            if count<=requested and count<=max and count<=free then
                local price=pricing.GetTotal(data,c.Egg,egg.Price,count)
                if type(price)=="number" and price>=0 and price<math.huge and price<=(data.Currencies.Coins or 0)-c.ReserveCoins then
                    return {egg=c.Egg,count=count,price=price}
                end
            end
        end
        return nil,free<1 and "StorageFull" or "Not enough coins for selected egg"
    end
    function A.RebirthPlan(c)
        local data=d.Data()
        if (data.Settings or {}).AutoRebirthSlot and data.Settings.AutoRebirthSlot>0 then return nil,"Stop game auto rebirth first" end
        local buttons=get("Shared.Progression.RebirthButtonConfig")
        local formula=get("Shared.Progression.RebirthConfig")
        local max=buttons.GetOptionCount(data.Upgrades.RebirthButtons or 0,data.Progression.World or "Main")
        local selected=c.RebirthAmount or "Auto"
        local first,last=max,1
        if selected~="Auto" then
            local wanted=tonumber(selected)
            first=nil
            for index=1,buttons.GetMaximumOptions(data.Progression.World or "Main") do
                if formula.GetAmountFromIndex(index)==wanted then first=index;break end
            end
            if not first then return nil,"Invalid rebirth amount" end
            if first>max then return nil,"Selected rebirth amount not unlocked" end
            last=first
        end
        for index=first,last,-1 do
            local amount=formula.GetAmountFromIndex(index)
            local price=formula.GetPrice(amount,data.Statistics.Rebirths or 0)
            if type(price)=="number" and price>0 and price<=data.Currencies.Coins-c.ReserveCoins then return {index=index,amount=amount,price=price} end
        end
        return nil,"Not enough coins to rebirth"
    end
    function A.UpgradePlan(c)
        local data=d.Data();local cfg=get("Shared.Progression.UpgradeConfig")
        local best
        for name,selected in pairs(c.Upgrades) do
            local def=selected and cfg.Get(name)
            if def and name~="Teleport" and not def.SkillTreeNode then
                local level=math.floor(data.Upgrades[name] or 0)
                local zone=cfg.GetRetainedRequirement(name,level)
                local price=cfg.GetPrice(name,level+1)
                if level<def.LaunchTotal and (not zone or (data.Progression.UnlockedZones or {})[zone]) and type(price)=="number"
                    and price<=data.Currencies.Gems-c.ReserveGems and (not best or price<best.price) then best={name=name,price=price} end
            end
        end
        return best,best and nil or "No affordable selected upgrades"
    end
    function A.Quest()
        local data=d.Data();local defs=get("Shared.Quests.QuestConfig").Definitions
        local visibility=get("Shared.Quests.QuestVisibility")
        local ids={}
        for id,state in pairs(data.Quests or {}) do
            local def=defs[id]
            if type(state)=="table" and def and state.Claimed~=true and visibility.IsShown(data,id)
                and (state.Completed==true or (state.Amount or 0)>=(def.Goal or math.huge)) then ids[#ids+1]=id end
        end
        table.sort(ids);return ids[1]
    end
    function A.Gift(c)
        local data=d.Data()
        if c.Gift~="" and A.Gifts()[c.Gift] and ((data.Items or {}).Owned or {})[c.Gift] and data.Items.Owned[c.Gift]>=1 then return c.Gift end
    end
    function A.EnchantPlan(c)
        if c.EnchantPet=="" then return nil,"Select a pet" end
        if not next(c.EnchantFilters) then return nil,"Select wanted enchants" end
        local data=d.Data();local pet=data.Pets.Owned[c.EnchantPet]
        if not pet then return nil,"Selected pet unavailable" end
        if d.Attribute("EnchantAutoPet") then return nil,"Stop game auto enchant first" end
        if (data.Enchanting or {}).Pending then return nil,"Finish pending enchant in game" end
        local cfg=get("Shared.Pets.EnchantConfig")
        if c.EnchantSlot>cfg.GetSlotCount(pet) then return nil,"InvalidSlot" end
        local current=c.EnchantSlot==2 and pet.Enchant2 or pet.Enchant
        if current and c.EnchantFilters[current] then return nil,"Selected pet already has wanted enchant" end
        if current and not c.ReplaceEnchant then return nil,"Enable replace existing enchant first" end
        local price=cfg.GetRollPrice(pet)
        if type(price)~="number" or price>data.Currencies.Gems-c.ReserveGems then return nil,"Not enough gems for enchant" end
        if pet.Locked or pet.Reserved or pet.Frozen then return nil,"Selected pet locked or reserved" end
        return {id=c.EnchantPet,price=price}
    end
    return A
end

end)()
local makeMovement=(function()
return function(config,d)
    local M={Report={mode="Teleport",teleports=0},JumpReport={mode="NativeDoubleJump",jumps=0}}
    local player,world=d.Player,d.World
    local active,alive=nil,true
    local knownEggs,knownEnchant={},nil
    local streamAt=0
    local function character()
        local c=player.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local r=c and c:FindFirstChild("HumanoidRootPart")
        if c and h and r and h.Health>0 then return c,h,r end
    end
    local function point(v)return {x=v.X,y=v.Y,z=v.Z}end
    local function stop()
        if active then
            local _,h,r=character()
            if h and h==active.h then h:MoveTo(r.Position)end
        end
        active=nil
    end
    local function stream(position)
        if d.Now()<streamAt then return end
        streamAt=d.Now()+5
        d.Spawn(function()pcall(player.RequestStreamAroundAsync,player,position,2)end)
    end
    local function box(item)
        if item:IsA("BasePart")then return item.CFrame,item.Size end
        if item:IsA("Model")then return item:GetBoundingBox()end
    end
    local function inside(cf,size,pos)
        local offset=cf:PointToObjectSpace(pos)
        local half=size/2+Vector3.new(3,2,3)
        return math.abs(offset.X)<=half.X and math.abs(offset.Y)<=half.Y and math.abs(offset.Z)<=half.Z
    end
    local function locate(kind,egg,r)
        if kind=="Hatch"then
            local folder=world:FindFirstChild("Eggs")
            local model=folder and folder:FindFirstChild(egg)
            local pos
            if model and model:IsA("Model") then
                pos=d.Module("Modules.Client.Pets.EggIdleAnimation").GetPosition(model)
                if not pos then
                    local source=model:FindFirstChild("Egg")
                    local part
                    if source and source:IsA("BasePart")then part=source
                    elseif source and source:IsA("Model")then part=source.PrimaryPart or source:FindFirstChildWhichIsA("BasePart",true)end
                    part=part or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
                    pos=part and part.Position
                end
                if pos then knownEggs[egg]=pos end
            end
            if not pos then
                if knownEggs[egg]then stream(knownEggs[egg])end
                return nil,"Waiting for selected egg to stream in"
            end
            local distance=(r.Position-pos).Magnitude
            local offset=Vector3.new(r.Position.X-pos.X,0,r.Position.Z-pos.Z)
            offset=offset.Magnitude>.1 and offset.Unit or Vector3.new(1,0,0)
            local destination=pos+offset*5
            -- Raycast beside the egg, excluding its pedestal/model. Avoid walking into its center.
            local params=RaycastParams.new()
            params.FilterType=Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances={player.Character,model}
            params.RespectCanCollide=true
            local floor=world:Raycast(destination+Vector3.new(0,8,0),Vector3.new(0,-30,0),params)
            if floor then
                local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                local height=math.max(3,(h and h.HipHeight or 2)+(r.Size and r.Size.Y/2 or 1))
                destination=Vector3.new(destination.X,floor.Position.Y+height,destination.Z)
            end
            return {point=destination,ready=distance<=9,distance=distance,live=model,key="Hatch:"..egg}
        end
        local best,nearest
        for _,item in ipairs(d.Collection:GetTagged("InteractionPoint"))do
            if item.Name=="Enchant"and item:IsDescendantOf(world)then
                local cf,size=box(item)
                if cf then
                    local distance=(r.Position-cf.Position).Magnitude
                    if not nearest or distance<nearest then best={cf=cf,size=size,item=item};nearest=distance end
                end
            end
        end
        if not best then
            if knownEnchant then stream(knownEnchant.cf.Position)end
            return nil,"Enchant point not loaded; approach machine once"
        end
        knownEnchant=best
        local destination=best.cf.Position
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances={player.Character,best.item}
        params.RespectCanCollide=true
        local floor=world:Raycast(destination+Vector3.new(0,8,0),Vector3.new(0,-30,0),params)
        if floor then
            local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local height=math.max(3,(h and h.HipHeight or 2)+(r.Size and r.Size.Y/2 or 1))
            local standing=Vector3.new(destination.X,floor.Position.Y+height,destination.Z)
            if inside(best.cf,best.size,standing)then destination=standing end
        end
        return {point=destination,ready=inside(best.cf,best.size,r.Position),
            distance=nearest,live=best.item,key="Enchant"}
    end
    function M.Approach(kind,egg)
        if not alive then return false,"Disabled",M.Report end
        local c,h,r=character()
        if not h then stop();return false,"Waiting for character",M.Report end
        local target,reason=locate(kind,egg,r)
        if not target then stop();M.Report.status=reason;return false,reason,M.Report end
        if not active or active.key~=target.key or active.h~=h or active.live~=target.live then
            stop()
            active={key=target.key,h=h,live=target.live,kind=kind,target=target.point,attempts=0,nextTeleport=0}
        end
        active.target=target.point
        M.Report.owner=kind;M.Report.target=point(target.point);M.Report.distance=target.distance
        if target.ready then
            if not active.arrivedAt then
                active.arrivedAt=d.Now();h:MoveTo(r.Position)
            end
            local ready=d.Now()-active.arrivedAt>=.6
            M.Report.status=ready and "In native interaction range"or "Waiting for position replication"
            return ready,M.Report.status,M.Report
        end
        active.arrivedAt=nil
        if d.Now()>=active.nextTeleport then
            if active.attempts>=3 then active.attempts=0 end
            h:MoveTo(r.Position)
            d.Teleport(c,h,r,target.point)
            active.attempts+=1
            active.nextTeleport=d.Now()+(active.attempts>=3 and 10 or 2)
            M.Report.teleports+=1;M.Report.attempt=active.attempts
        end
        M.Report.status=active.attempts>=3 and "Position not retained; waiting to retry"or
            (kind=="Hatch"and "Teleporting to selected egg"or "Teleporting to enchant machine")
        return false,M.Report.status,M.Report
    end
    local jumpModule,jumpTrack,jumpCharacter,jumpAt
    local function jumpController()
        jumpModule=jumpModule or d.Module("Controllers.Game.DoubleJumpController")
        return jumpModule
    end
    local function jumpBlocked(c)
        if d.IsFocused()then return true end
        for _,key in ipairs({"SecretCutsceneActive","BallTrialActive","BouncyObbyActive","MiningActive"})do
            if player:GetAttribute(key)==true then return true end
        end
        if c:GetAttribute("BouncyBallMounted")==true then return true end
        local cf,size=world:GetAttribute("BouncyObbyBoxCFrame"),world:GetAttribute("BouncyObbyBoxSize")
        if typeof(cf)=="CFrame"and typeof(size)=="Vector3"then
            local r=c:FindFirstChild("HumanoidRootPart")
            if r then
                local v=cf:PointToObjectSpace(r.Position);local half=size/2+Vector3.new(40,120,40)
                if math.abs(v.X)<=half.X and math.abs(v.Y)<=half.Y and math.abs(v.Z)<=half.Z then return true end
            end
        end
        return false
    end
    local function clearTrack()
        if jumpTrack then pcall(jumpTrack.Stop,jumpTrack);pcall(jumpTrack.Destroy,jumpTrack)end
        jumpTrack=nil;jumpCharacter=nil
    end
    function M.Jump()
        if not alive or not config.InfiniteJump then return end
        local c,h,r=character()
        if not h or jumpBlocked(c)then return end
        local native=jumpController()
        local state=native:GetState()
        -- Owned air jumps are performed by the game's existing JumpRequest listener.
        -- Refilling in Tick removes only the per-flight count; never apply a second impulse.
        if state.Maximum>0 then return end
        if state.Character~=c or not state.CanJump or h:GetState()~=Enum.HumanoidStateType.Freefall then return end
        local cfg=d.Module("Shared.Progression.DoubleJumpConfig")
        if d.Now()<(jumpAt or 0)then return end
        jumpAt=d.Now()+math.max(cfg.FreefallDelay,.15)
        local direction=h.MoveDirection
        local force=cfg.VelocityMultiplier
        if math.abs(direction.X)<.01 and math.abs(direction.Z)<.01 then force*=1.15 end
        r.AssemblyLinearVelocity=Vector3.new(direction.X,1.35,direction.Z)*force
        h:ChangeState(Enum.HumanoidStateType.Jumping)
        M.JumpReport.jumps+=1;M.JumpReport.mode="NativePhysics"
        -- Reuse the game's own animation and already-created particle attachment.
        if jumpCharacter~=c then clearTrack();jumpCharacter=c end
        pcall(function()
            local animator=h:FindFirstChildOfClass("Animator")
            local controllers=d.Replicated:FindFirstChild("Controllers")
            local gameModules=controllers and controllers:FindFirstChild("Game")
            local controller=gameModules and gameModules:FindFirstChild("DoubleJumpController")
            local animation=controller and controller:FindFirstChild("Animation")
            if animator and animation then
                jumpTrack=jumpTrack or animator:LoadAnimation(animation)
                jumpTrack:Play()
            end
        end)
        pcall(function()d.Module("Controllers.Audio.SoundController"):Play("DoubleJump",1.01)end)
        pcall(function()d.Module("Controllers.Pets.PetController"):FlipOwnedPets()end)
        local particles=r:FindFirstChild("TS2DoubleJumpParticles")
        local wind=particles and particles:FindFirstChild("Wind")
        if wind and wind:IsA("ParticleEmitter")then wind:Emit(wind:GetAttribute("EmitCount")or 1)end
    end
    function M.Tick()
        if not alive then return end
        if config.InfiniteJump then
            local c=character()
            if c and not jumpBlocked(c)then
                local native=jumpController()
                local state=native:GetState()
                if state.Current>0 then native:Refill()end
                M.JumpReport.maximum=state.Maximum
                M.JumpReport.mode=state.Maximum>0 and "NativeControllerRefill"or "NativePhysics"
            end
        else clearTrack()end
        local a=active
        if not a then return end
        if not config[a.kind]or(a.kind=="Hatch"and config.Enchant)then stop();return end
        local _,h,r=character()
        if not h or h~=a.h then stop();return end
    end
    function M.Cancel()stop()end
    function M.Destroy()alive=false;stop();clearTrack()end
    return M
end

end)()
local makePresentation=(function()
return function(config,d)
    local P={Report={skipped=0,secretSkipped=0,installed=false}}
    local alive=true
    local expected,petIds={},{}
    local results=setmetatable({},{__mode="k"})
    local patches={}
    local function owns(result)
        if type(result)~="table"or result.Success~=true or result.Forced==true then return false end
        if results[result]then return true end
        local request,key
        if result.Seq~=nil then request=expected[result.Seq];key=result.Seq
        else
            for id,candidate in pairs(expected)do
                if candidate.egg==result.Egg and candidate.expires>=d.Now()then request=candidate;key=id;break end
            end
        end
        if not request or request.egg~=result.Egg or request.expires<d.Now()then return false end
        expected[key]=nil
        results[result]=true
        for _,pet in pairs(type(result.Pets)=="table"and result.Pets or {})do
            if type(pet)=="table"and type(pet.Id)=="string"then petIds[pet.Id]=d.Now()+180 end
        end
        return true
    end
    local function skipping()return alive and config.SkipHatchGUI==true end
    local function ownedPet(pet)
        return type(pet)=="table"and petIds[pet.Id]and petIds[pet.Id]>=d.Now()
    end
    local function patch(object,key,wrap)
        local original=assert(object[key],"Missing native presentation method: "..key)
        assert(type(original)=="function","Invalid native presentation method: "..key)
        local replacement=wrap(original)
        object[key]=replacement
        patches[#patches+1]={object=object,key=key,original=original,replacement=replacement}
    end
    function P.Install()
        if P.Report.installed or not alive then return end
        patch(d.Module("Modules.Client.Pets.HatchRenderer"),"Play",function(original)
            return function(self,egg,result,done,...)
                if skipping()and owns(result)and type(done)=="function"then
                    P.Report.skipped+=1
                    d.Defer(done)
                    return
                end
                return original(self,egg,result,done,...)
            end
        end)
        local secrets=d.Module("Modules.Client.Pets.SecretHatchRenderer")
        for _,key in ipairs({"Play","PlayReveal"})do
            patch(secrets,key,function(original)
                return function(self,pet,done,...)
                    local args=table.pack(...)
                    -- The native result listener may run before our observer. Defer the ownership check.
                    d.Defer(function()
                        if skipping()and ownedPet(pet)and type(done)=="function"then
                            P.Report.secretSkipped+=1;done()
                        else original(self,pet,done,table.unpack(args,1,args.n))end
                    end)
                end
            end)
        end
        patch(d.Module("Modules.Client.Pets.SecretHatchCutscenes"),"Play",function(original)
            return function(self,pet,done,...)
                if skipping()and ownedPet(pet)and type(done)=="function"then
                    d.Defer(function()done("Skipped")end)
                    return true,"Skipped by DEVIL HUB"
                end
                return original(self,pet,done,...)
            end
        end)
        P.Report.installed=true
    end
    function P.Expect(packet)
        if not alive then return end
        if config.SkipHatchGUI then
            if not P.Report.installed then
                local ok,err=pcall(P.Install)
                if not ok then
                    P.Report.error=tostring(err)
                    -- Roll back a partial installation; never stack wrappers on retry.
                    for i=#patches,1,-1 do
                        local p=patches[i]
                        if p.object[p.key]==p.replacement then p.object[p.key]=p.original end
                        patches[i]=nil
                    end
                end
            end
            expected[packet.Seq]={egg=packet.Egg,expires=d.Now()+30}
        end
    end
    function P.Observe(result)if alive then owns(result)end end
    function P.Tick()
        for id,item in pairs(expected)do if item.expires<d.Now()then expected[id]=nil end end
        for id,expires in pairs(petIds)do if expires<d.Now()then petIds[id]=nil end end
    end
    function P.Destroy()
        alive=false
        for i=#patches,1,-1 do
            local p=patches[i]
            if p.object[p.key]==p.replacement then p.object[p.key]=p.original end
        end
        table.clear(patches);table.clear(expected);table.clear(petIds)
        P.Report.installed=false
    end
    return P
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
local player=game:GetService("Players").LocalPlayer
local Http=game:GetService("HttpService")
local runService=game:GetService("RunService")
local inputs=game:GetService("UserInputService")
local config={Tap=false,Hatch=false,Rebirth=false,Upgrade=false,Quests=false,Gifts=false,Equip=false,Enchant=false,
    InfiniteJump=false,CPS=40,Egg="",HatchCount=1,HatchDelay=2,Gift="",ReserveCoins=0,ReserveGems=0,RebirthAmount="Auto",SkipHatchGUI=true,HatchTap=true,
    Upgrades={ClickMultiplier=true,HatchSpeed=true,CriticalChance=true,AutoClickerSpeed=true},
    EnchantPet="",EnchantSlot=1,EnchantFilters={},ReplaceEnchant=false,Language="TH"}
local api={Config=config}
local alive,rebuilding=true,false
local core,adapter,window,replica,movement,presentation
local connections,controls,paragraphs={},{},{}
local cache={}
local now=os.clock
local function module(path)
    if cache[path] then return cache[path] end
    local item=RS
    for name in path:gmatch("[^.]+") do item=item and item:FindFirstChild(name) end
    assert(item and item:IsA("ModuleScript"),"Missing game module: "..path)
    cache[path]=require(item);return cache[path]
end
local function remote(service,folder,name)
    local services=RS:FindFirstChild("RemoteServices")
    local host=services and services:FindFirstChild(service)
    local group=host and host:FindFirstChild(folder)
    local item=group and group:FindFirstChild(name)
    assert(item,"Missing remote: "..service.."/"..name)
    return item
end
movement=makeMovement(config,{
    Player=player,World=workspace,Replicated=RS,Collection=game:GetService("CollectionService"),
    Module=module,Now=now,
    Spawn=task.spawn,IsFocused=function()return inputs:GetFocusedTextBox()~=nil end,
    Teleport=function(c,h,r,position)
        h.Sit=false
        r.AssemblyLinearVelocity=Vector3.new(0,0,0)
        r.AssemblyAngularVelocity=Vector3.new(0,0,0)
        r.CFrame=CFrame.new(position)
    end,
})
presentation=makePresentation(config,{Module=module,Now=now,Defer=task.defer})
local deps={
    Data=function() return replica and replica.Data end,
    Module=module,Now=now,Attribute=function(name)return player:GetAttribute(name)end,
    GUID=function()return Http:GenerateGUID(false)end,
    CanInvoke=function()return env.DevilTappingRPCPending==nil end,
    SequenceStart=math.floor(now()*1000)+1000000000,
    Fire=function(service,name,packet)
        local endpoint=remote(service,"RE",name)
        if service=="EggService"and name=="EggHatchRequested"then presentation.Expect(packet)end
        if packet==nil then endpoint:FireServer()else endpoint:FireServer(packet)end
    end,
    NativeHatch=function()return module("Controllers.Pets.EggController"):GetAutoHatchEgg()~=nil end,
    Approach=function(kind,egg)return movement.Approach(kind,egg)end,
    Request=function(service,name,packet)
        assert(not env.DevilTappingRPCPending,"Previous request still pending")
        local endpoint=remote(service,"RF",name)
        local ticket={service=service,method=name,started=now()}
        env.DevilTappingRPCPending=ticket
        task.spawn(function()
            local ok,result=pcall(endpoint.InvokeServer,endpoint,packet)
            ticket.ok=ok;ticket.done=true
            if ok then ticket.result=result else ticket.error=tostring(result) end
            if env.DevilTappingRPCPending==ticket then env.DevilTappingRPCPending=nil end
        end)
        return ticket
    end,
}
local labels={
    Tap={"Fast Auto Click","ออโต้คลิกเร็ว"},Hatch={"Auto Open Egg","เปิดไข่อัตโนมัติ"},
    Rebirth={"Auto Rebirth","รีเบิร์ทอัตโนมัติ"},Upgrade={"Auto Buy Upgrades","ซื้ออัปเกรดอัตโนมัติ"},
    Quests={"Auto Claim Quests","รับเควสต์ที่สำเร็จ"},Gifts={"Auto Open Gift","เปิดของขวัญอัตโนมัติ"},
    Equip={"Auto Equip Best","ใส่สัตว์ที่ดีที่สุด"},Enchant={"Auto Enchant","สุ่ม Enchant อัตโนมัติ"},
}
local texts={
    Disabled="ปิดอยู่",Enabled="เปิดแล้ว",IslandLocked="ยังไม่ปลดล็อกเกาะ",StorageFull="กระเป๋าสัตว์เต็ม",
    ["Sending taps; counting server replies"]="กำลังคลิกและนับผลตอบกลับ",
    ["Waiting for server result"]="รอผลจากเกม",["Server accepted"]="เกมตอบรับคำขอ",
    ["Waiting for other coin purchase"]="รอรายการใช้เงินอีกระบบเสร็จ",
    ["Server rejected request"]="เกมปฏิเสธ ดูเหตุผลด้านล่าง",["Waiting for previous request"]="รอคำขอก่อนหน้า",
    ["Request pending; no duplicate sent"]="เกมยังไม่ตอบ รอโดยไม่ส่งซ้ำ",
    ["Waiting for player data"]="รอข้อมูลผู้เล่น",["Select an egg"]="เลือกไข่ก่อน",
    ["Select an owned gift"]="เลือกของขวัญที่มีในกระเป๋า",["Select a pet"]="เลือกสัตว์ก่อน",
    ["Select wanted enchants"]="เลือกผล Enchant ที่ต้องการก่อน",
    ["Selected pet already has wanted enchant"]="สัตว์มี Enchant ที่เลือกแล้ว หยุดออโต้",
    ["Enable replace existing enchant first"]="เปิดอนุญาตเปลี่ยน Enchant เดิมก่อน",
    ["Wanted enchant confirmed"]="เกมยืนยัน Enchant ที่ต้องการแล้ว",
    ["Finish pending enchant in game"]="มีผล Enchant ค้างอยู่ ให้จบรายการนั้นก่อน",
    ["Finish pending enchant on previous pet"]="มีผล Enchant ของสัตว์ก่อนหน้าค้างอยู่",
    ["No affordable selected upgrades"]="ยังไม่มีอัปเกรดที่เลือกและเงินพอ",
    ["Not enough coins to rebirth"]="เงินยังไม่พอรีเบิร์ท",
    ["Selected rebirth amount not unlocked"]="ยังไม่ปลดล็อกจำนวนรีเบิร์ทที่เลือก",
    ["Invalid rebirth amount"]="จำนวนรีเบิร์ทไม่ถูกต้อง",
    ["Waiting for enchant movement"]="รอ Enchant เสร็จก่อนเปิดไข่",
    ["Waiting for hatch result before moving"]="รอผลเปิดไข่ก่อนเดินไป Enchant",
    ["Teleporting to selected egg"]="กำลังวาร์ปไปใกล้ไข่ที่เลือก",
    ["Teleporting to enchant machine"]="กำลังวาร์ปไปจุด Enchant ใกล้ที่สุด",
    ["Position not retained; waiting to retry"]="ตำแหน่งถูกดึงกลับ รอก่อนลองใหม่",
    ["Waiting for position replication"]="รอเกมรับตำแหน่งก่อนส่งคำขอ",
    ["Waiting for selected egg to stream in"]="รอโหลดไข่ที่เลือก ลองเข้าใกล้ไข่ครั้งแรก",
    ["Enchant point not loaded; approach machine once"]="ยังไม่พบจุด Enchant ให้เข้าใกล้เครื่องหนึ่งครั้ง",
    ["Waiting for character"]="รอตัวละครพร้อม",
    ["Not enough coins for selected egg"]="เงินยังไม่พอเปิดไข่",
    ["Not enough gems for enchant"]="เพชรยังไม่พอ Enchant",
    ["Waiting for completed quests"]="รอเควสต์สำเร็จ",
    ["Stop game auto hatch first"]="ปิดออโต้เปิดไข่ของเกมก่อน",
    ["Stop game auto rebirth first"]="ปิดออโต้รีเบิร์ทของเกมก่อน",
    ["Stop game auto enchant first"]="ปิดออโต้ Enchant ของเกมก่อน",
    ["Finish current minigame before tapping"]="รอมินิเกมปัจจุบันจบก่อนคลิก",
    ["Finish game introduction first"]="ทำขั้นตอนเริ่มเกมให้จบก่อน",
    ["No confirmation; stopped to avoid duplicate purchases"]="เกมไม่ยืนยัน หยุดไว้เพื่อไม่ให้ซื้อซ้ำ",
    ["Error; save report"]="เกิดข้อผิดพลาด กรุณาบันทึกรายงาน",
    ["Selected pet unavailable"]="ไม่พบสัตว์ที่เลือก",["Selected egg unavailable"]="ไม่พบไข่ที่เลือก",
    ["Selected pet locked or reserved"]="สัตว์ถูกล็อกหรือกำลังใช้งาน",InvalidSlot="สัตว์ใช้ช่องนี้ไม่ได้",
}
local function t(en,th)return config.Language=="TH" and th or en end
local refreshAt=0
local function refresh(report,force)
    if not alive then return end
    if not force and now()<refreshAt then return end
    refreshAt=now()+.2
    for name,label in pairs(paragraphs) do
        local job=report.jobs[name]
        local text=config.Language=="TH" and texts[job.status] or nil
        label:Set((text or job.status).."\n"..t("Requests: ","ส่งคำขอ: ")..job.requests..
            t(" | Server accepted: "," | เกมตอบรับ: ")..job.confirmed..
            t(" | Rejected: "," | ปฏิเสธ: ")..job.rejected..
            (job.reason and "\n"..tostring(job.reason) or "")..(job.error and "\n"..job.error or ""),true)
        if controls[name] then controls[name]:Set(config[name],true) end
    end
    if controls.InfiniteJump then controls.InfiniteJump:Set(config.InfiniteJump,true) end
end
local function clean(value,depth)
    if depth>7 then return "[depth limit]" end
    local kind=type(value)
    if kind=="number" then return value==value and math.abs(value)~=math.huge and value or tostring(value) end
    if kind=="string" or kind=="boolean" or kind=="nil" then return value end
    if kind~="table" then return tostring(value) end
    local out,count={},0
    for key,item in pairs(value) do
        count+=1;if count>128 then out._truncated=true;break end
        out[tostring(key)]=clean(item,depth+1)
    end
    return out
end
function api.SaveReport()
    core.Report.placeId=game.PlaceId;core.Report.userId=player.UserId;core.Report.config=config
    core.Report.pendingRPC=env.DevilTappingRPCPending
    core.Report.movement=movement.Report;core.Report.jump=movement.JumpReport
    core.Report.presentation=presentation.Report
    local bytes=Http:JSONEncode(clean(core.Report,0))
    if type(writefile)=="function" then pcall(writefile,"DevilTappingTestReport.json",bytes) end
    if type(setclipboard)=="function" then pcall(setclipboard,bytes) end
    if api.Info then api.Info:Set(t("Report copied / saved","คัดลอก / บันทึกรายงานแล้ว"),true) end
    return bytes
end
function api.Destroy()
    if not alive then return end
    alive=false
    if core then core.Destroy() end
    movement.Destroy()
    presentation.Destroy()
    for _,link in ipairs(connections) do pcall(link.Disconnect,link) end
    table.clear(connections)
    if window then window:Destroy();window=nil end
    if env.DevilTappingTest==api then env.DevilTappingTest=nil end
end
local function single(value)return type(value)=="table" and value[1] or value end
local function selection(value)
    local out={}
    if type(value)=="table" then
        for key,item in pairs(value) do
            if type(key)=="number" and type(item)=="string" then out[item]=true
            elseif item==true and type(key)=="string" then out[key]=true end
        end
    elseif type(value)=="string" then out[value]=true end
    return out
end
local function keys(map)local out={};for name in pairs(map or {})do out[#out+1]=name end;table.sort(out);return out end
local function selected(map)local out={};for name,value in pairs(map)do if value then out[#out+1]=name end end;table.sort(out);return out end
local build
function api.RefreshPetList()
    if not controls.EnchantPet then return end
    local placeholder=t("Select a pet","เลือกสัตว์")
    local options={};api.PetIds={}
    local data=deps.Data()
    if data then
        for id,pet in pairs(data.Pets.Owned or {}) do
            local label=tostring(pet.Name or id).." ["..tostring(pet.Tier or "Normal").."] | "..id
            options[#options+1]=label;api.PetIds[label]=id
        end
    end
    table.sort(options);table.insert(options,1,placeholder)
    local current=placeholder
    for label,id in pairs(api.PetIds) do if id==config.EnchantPet then current=label;break end end
    controls.EnchantPet:Refresh(options,true,true);controls.EnchantPet:Set(current,true)
end
local library
build=function()
    rebuilding=true
    if window then window:Destroy() end
    controls={};paragraphs={}
    local logo=makeLogo()
    window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme="Crimson",Density="Compact",Profile=true,
        Search=false,Home=false,Loading=false,Backdrop=false,Disclaimer=false,UnsupportedExecutor=false,
        Size=UDim2.fromOffset(850,590),KeepOnScreen=true,ToggleButton={Platform="Both",Icon=logo},
        ConfigurationSaving={Enabled=false}})
    local bound=window
    if window.Gui then window.Gui.Destroying:Connect(function()if not rebuilding and window==bound then api.Destroy()end end)end
    local function tab(en,th,icon)return window:CreateTab({Name=t(en,th),Icon=icon})end
    local function group(parent,en,th,side,icon)return parent:CreateGroupbox({Name=t(en,th),Side=side,Icon=icon})end
    local function toggle(parent,name)
        controls[name]=parent:CreateToggle({Name=t(table.unpack(labels[name])),CurrentValue=config[name],Callback=function(value)core.Set(name,value)end})
        paragraphs[name]=parent:CreateParagraph({Name=t("Status","สถานะ"),Content=""})
    end
    local farm=tab("Click / Player","คลิก / ผู้เล่น","mouse-pointer-click")
    local taps=group(farm,"Fast clicking","ออโต้คลิกเร็ว","Left","mouse-pointer-click")
    toggle(taps,"Tap")
    taps:CreateSlider({Name=t("Requested clicks / second","จำนวนคลิกที่ส่งต่อวินาที"),Range={1,100},Increment=1,CurrentValue=config.CPS,Callback=function(value)config.CPS=value end})
    taps:CreateParagraph({Name=t("Real results","ผลจริงจากเกม"),Content=t(
        "Counts matching TapResult replies separately from sent requests. The server may count fewer taps than the selected rate.",
        "แยกจำนวนที่ส่งกับผล TapResult ที่ตรงคำขอ เกมอาจนับคลิกให้น้อยกว่าความเร็วที่ตั้ง")})
    toggle(taps,"Equip")
    local movement=group(farm,"Player","ผู้เล่น","Right","person-standing")
    controls.InfiniteJump=movement:CreateToggle({Name=t("Infinite Jump","กระโดดไม่จำกัด"),CurrentValue=config.InfiniteJump,Callback=function(value)config.InfiniteJump=value==true end})
    movement:CreateParagraph({Name=t("Jump control","วิธีกระโดด"),Content=t(
        "Press jump again in midair. Reuses native double jumps; players without an air jump use the map's jump force, direction and animation.",
        "กดปุ่มกระโดดของเกมซ้ำกลางอากาศ ใช้ Double Jump ของแมพต่อเนื่อง หากยังไม่มี ใช้แรงส่ง ทิศทาง และท่ากระโดดแบบเดียวกับแมพ")})
    local eggs=tab("Eggs","เปิดไข่","egg")
    local hatch=group(eggs,"Auto hatching","เปิดไข่อัตโนมัติ","Left","egg")
    local eggOptions=keys(adapter.Eggs());table.insert(eggOptions,1,t("Select an egg","เลือกไข่"))
    controls.Egg=hatch:CreateDropdown({Name=t("Egg","ไข่"),Options=eggOptions,CurrentOption={config.Egg~="" and config.Egg or eggOptions[1]},Searchable=true,Callback=function(value)
        value=single(value);config.Egg=adapter.Eggs()[value] and value or ""
    end})
    hatch:CreateDropdown({Name=t("Eggs per request","จำนวนไข่ต่อครั้ง"),Options={"1","3","8"},CurrentOption={tostring(config.HatchCount)},Callback=function(value)config.HatchCount=tonumber(single(value))or 1 end})
    hatch:CreateSlider({Name=t("Delay after confirmation","เว้นช่วงหลังเกมยืนยัน"),Range={.5,5},Increment=.1,CurrentValue=config.HatchDelay,Callback=function(value)config.HatchDelay=value end})
    toggle(hatch,"Hatch")
    hatch:CreateToggle({Name=t("Skip hatch GUI","ข้ามหน้าเปิดไข่"),CurrentValue=config.SkipHatchGUI,Callback=function(value)config.SkipHatchGUI=value==true end})
    hatch:CreateToggle({Name=t("Tap while hatching","คลิก Tap คู่กับเปิดไข่"),CurrentValue=config.HatchTap,Callback=function(value)config.HatchTap=value==true end})
    local hatchInfo=group(eggs,"Hatch results","ผลเปิดไข่","Right","info")
    hatchInfo:CreateParagraph({Name=t("Automatic teleport","วาร์ปเข้าใกล้อัตโนมัติ"),Content=t(
        "Teleports beside the selected loaded egg, skips its reveal and taps at the selected CPS. Enchant takes movement priority. Locked islands remain unavailable.",
        "วาร์ปไปด้านใกล้ของไข่ที่เลือก ข้ามหน้าเปิดไข่ และส่ง Tap ตาม CPS ที่ตั้ง หากเปิด Enchant จะทำ Enchant ก่อน ไข่บนเกาะที่ยังไม่ปลดล็อกใช้ไม่ได้")})
    local progressTab=tab("Progress / Rewards","พัฒนา / รางวัล","gift")
    local progress=group(progressTab,"Progression","พัฒนาตัวละคร","Left","trending-up")
    progress:CreateDropdown({Name=t("Rebirth amount","จำนวนรีเบิร์ท"),Options=adapter.RebirthAmounts(),CurrentOption={config.RebirthAmount},Callback=function(value)
        config.RebirthAmount=tostring(single(value))
    end})
    progress:CreateParagraph({Name=t("Rebirth selection","การเลือกจำนวน"),Content=t(
        "Auto chooses the largest unlocked amount you can afford. A specific amount waits for its unlock and full price.",
        "Auto เลือกจำนวนสูงสุดที่ปลดล็อกและเงินพอ หากเลือก 1 / 5 / 25 / 125 จะใช้จำนวนนั้นเท่านั้น รอจนปลดล็อกและเงินพอ")})
    toggle(progress,"Rebirth");toggle(progress,"Upgrade")
    progress:CreateDropdown({Name=t("Selected upgrades","อัปเกรดที่ซื้อ"),Options={"ClickMultiplier","HatchSpeed","CriticalChance","AutoClickerSpeed"},
        CurrentOption=selected(config.Upgrades),MultipleOptions=true,Callback=function(value)config.Upgrades=selection(value)end})
    for _,name in ipairs({"Coins","Gems"})do
        progress:CreateInput({Name=t(name.." reserve",name=="Coins" and "เงินสำรอง" or "เพชรสำรอง"),CurrentValue=tostring(config["Reserve"..name]),RemoveTextAfterFocusLost=false,Callback=function(value)
            local n=tonumber(value);if n and n>=0 and n<math.huge then config["Reserve"..name]=n end
        end})
    end
    local rewards=group(progressTab,"Rewards","รับรางวัล","Right","gift")
    toggle(rewards,"Quests")
    local gifts=keys(adapter.Gifts());table.insert(gifts,1,t("Select a gift","เลือกของขวัญ"))
    rewards:CreateDropdown({Name=t("Gift","ของขวัญ"),Options=gifts,CurrentOption={config.Gift~="" and config.Gift or gifts[1]},Callback=function(value)
        value=single(value);config.Gift=adapter.Gifts()[value] and value or ""
    end})
    toggle(rewards,"Gifts")
    local enchantTab=tab("Enchant","Enchant","sparkles")
    local enchant=group(enchantTab,"Selected pet","เลือกสัตว์และผลลัพธ์","Left","paw-print")
    enchant:CreateParagraph({Name=t("Machine teleport","วาร์ปเข้าเครื่อง"),Content=t(
        "Teleports inside the closest loaded Enchant interaction point before rolling. If it is not loaded, approach the machine once.",
        "วาร์ปเข้าจุด Enchant ที่ใกล้ที่สุดก่อนสุ่ม หากจุดเครื่องยังไม่โหลด ให้เข้าใกล้เครื่องหนึ่งครั้งเพื่อให้สคริปต์พบตำแหน่ง")})
    controls.EnchantPet=enchant:CreateDropdown({Name=t("Pet","สัตว์"),Options={t("Select a pet","เลือกสัตว์")},CurrentOption={t("Select a pet","เลือกสัตว์")},Searchable=true,Callback=function(value)
        config.EnchantPet=api.PetIds[single(value)]or ""
    end})
    enchant:CreateButton({Name=t("Refresh Pets","รีเฟรชรายชื่อสัตว์"),Callback=api.RefreshPetList})
    enchant:CreateDropdown({Name=t("Slot","ช่อง Enchant"),Options={"1","2"},CurrentOption={tostring(config.EnchantSlot)},Callback=function(value)config.EnchantSlot=tonumber(single(value))or 1 end})
    local filters={}
    for name in pairs(adapter.Enchants())do
        if module("Shared.Pets.EnchantConfig").IsFilterable(name)then filters[#filters+1]=name end
    end
    table.sort(filters)
    enchant:CreateDropdown({Name=t("Wanted results","ผลที่ต้องการ"),Options=filters,CurrentOption=selected(config.EnchantFilters),MultipleOptions=true,Searchable=true,Callback=function(value)config.EnchantFilters=selection(value)end})
    enchant:CreateToggle({Name=t("Allow replacing existing enchant","อนุญาตเปลี่ยน Enchant เดิม"),CurrentValue=config.ReplaceEnchant,Callback=function(value)config.ReplaceEnchant=value==true end})
    toggle(enchant,"Enchant")
    local enchantInfo=group(enchantTab,"Roll behavior","รูปแบบการสุ่ม","Right","info")
    enchantInfo:CreateParagraph({Name=t("Uses gems","ใช้เพชรของเกม"),Content=t(
        "Rolls one request at a time. Applies only selected results; unwanted results keep the previous enchant. Stops after a matching result is confirmed. Stand at the native enchant machine if the server requires it.",
        "สุ่มครั้งละคำขอ ใช้เฉพาะผลที่เลือก ผลอื่นคง Enchant เดิม หยุดเมื่อเกมยืนยันผลที่ต้องการ หากเกมกำหนดระยะให้ยืนที่เครื่อง Enchant ใช้เพชรจริงตามราคาเกม")})
    local settings=tab("Settings / Report","ตั้งค่า / รายงาน","settings")
    local diagnostics=group(settings,"Trial controls","ตัวควบคุมรุ่นทดลอง","Left","file-text")
    api.Info=diagnostics:CreateParagraph({Name=t("Build","รุ่น"),Content="tapping-auto-test-3"})
    diagnostics:CreateButton({Name=t("Copy / Save Report","คัดลอก / บันทึกรายงาน"),Callback=api.SaveReport})
    diagnostics:CreateButton({Name=t("Stop All","หยุดทั้งหมด"),Callback=function()core.Stop();task.defer(build)end})
    diagnostics:CreateButton({Name=t("Unload","ปิดสคริปต์"),Callback=api.Destroy})
    local appearance=group(settings,"GUI","ปรับ GUI","Right","palette")
    appearance:CreateSlider({Name=t("Width","ความกว้าง"),Range={600,1000},Increment=10,CurrentValue=850,Callback=function(value)window:SetSize(Vector2.new(value,590),true)end})
    appearance:CreateToggle({Name=t("Transparent","โปร่งใส"),CurrentValue=false,Callback=function(value)window:SetTransparent(value)end})
    local discord=tab("Discord","Discord","message-circle")
    local social=group(discord,"DEVIL HUB","DEVIL HUB","Left","message-circle")
    social:CreateImage({Name="DEVIL HUB",Image=logo,Height=120,ScaleType="Fit"})
    social:CreateParagraph({Name="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
    social:CreateButton({Name=t("Copy Invite","คัดลอกลิงก์เชิญ"),Callback=function()if type(setclipboard)=="function"then setclipboard("https://discord.gg/ZY7PRcVJe2")end end})
    if window.MinimizeButton then
        local minimize=window.MinimizeButton
        local button=Instance.new("TextButton");button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
        button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
        button.Text="ไทย / EN";button.TextSize=13;button.Font=Enum.Font.GothamSemibold
        button.TextColor3=Color3.new(1,1,1);button.BackgroundColor3=Color3.fromRGB(45,23,30);button.Parent=minimize.Parent
        local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=button
        button.Activated:Connect(function()config.Language=config.Language=="TH" and "EN"or "TH";task.defer(build)end)
    end
    api.RefreshPetList()
    rebuilding=false;refresh(core.Report,true)
end
env.DevilTappingTest=api
local ok,problem=xpcall(function()
    adapter=makeAdapter(config,deps)
    core=makeCore(config,adapter,refresh);api.Core=core
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    library=assert(loadstring(source,"DEVIL HUB / OuroFlow"))()
    build()
    for _,entry in ipairs({{"Tap","TapService","TapResult"},{"Hatch","EggService","EggHatchResult"},{"Rebirth","RebirthService","RebirthResult"},{"Equip","PetService","PetActionResult"}})do
        local name=entry[1]
        connections[#connections+1]=remote(entry[2],"RE",entry[3]).OnClientEvent:Connect(function(result)
            if name=="Hatch"then presentation.Observe(result)end
            core.Receive(name,result)
        end)
    end
    connections[#connections+1]=inputs.JumpRequest:Connect(function()
        local success,err=pcall(movement.Jump)
        if not success then movement.JumpReport.error=tostring(err)end
    end)
    connections[#connections+1]=runService.Heartbeat:Connect(function()
        local success,err=pcall(movement.Tick)
        if not success then movement.Report.error=tostring(err)end
        presentation.Tick()
        for _,name in ipairs(core.Names)do core.Tick(name)end
        refresh(core.Report)
    end)
    task.spawn(function()
        local loaded,value=pcall(function()return module("Controllers.Core.DataController"):GetReplica()end)
        if alive then
            if loaded then replica=value;api.RefreshPetList()
            else core.Report.dataError=tostring(value)end
        end
    end)
end,debug.traceback)
if not ok then api.Destroy();error("DEVIL HUB Tapping Test: "..tostring(problem),0)end
return api
