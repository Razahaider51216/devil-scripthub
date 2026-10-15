-- DEVIL HUB standalone trial for the supplied dump.
assert(game.PlaceId==72858262610964 or game.GameId==10629695169,"Open the map from dump Place 72858262610964")
local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilTappingTest then env.DevilTappingTest.Destroy() end
local makeCore=(function()
return function(config,d,changed)
    local C={Names={"Stars","Boxes","Tap","Rebirth","Upgrade","Quests","Gifts","Equip"},
        Report={release="tapping-auto-test-6",jobs={},errors={},liveVerified=false}}
    local jobs=C.Report.jobs
    local alive=true
    local intervals={Tap=0,Rebirth=1,Upgrade=2,Quests=1,Gifts=2,Equip=8}
    local tapPending={}
    local sequence=d.SequenceStart or 1000000000
    local function enabled(name)
        return config[name] or(name=="Tap"and(d.BoxTapping and d.BoxTapping()))
    end
    local function notify() if changed then pcall(changed,C.Report) end end
    local function status(name,text) jobs[name].status=text;notify() end
    for _,name in ipairs(C.Names) do jobs[name]={status="Disabled",requests=0,confirmed=0,rejected=0,nextAt=0,generation=0} end
    local function send(name,service,remote,packet)
        if not alive or not enabled(name) then return end
        jobs[name].requests+=1
        d.Fire(service,remote,packet)
    end
    local function rpc(name,method,packet,plan)
        if not d.CanInvoke() then status(name,"Waiting for previous request");return end
        local service=({Upgrade="UpgradeService",Quests="QuestService",Gifts="GiftService"})[name]
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
        job.rpc=nil;job.rpcPlan=nil
        local result=ticket.result
        local accepted=ticket.ok and type(result)=="table" and result.Success==true
        job.result=result;job.reason=not ticket.ok and tostring(ticket.error) or type(result)=="table" and result.Reason or nil
        job.nextAt=d.Now()+(accepted and intervals[name] or 5)
        if accepted then job.confirmed+=1
        else
            job.rejected+=1
            if not ticket.ok then config[name]=false;job.uncertain=true end
        end
        status(name,not config[name] and "Disabled" or accepted and "Server accepted" or "Server rejected request")
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
        local boxTap=d.BoxTapping and d.BoxTapping()
        if boxTap then jobs.Boxes.requests+=count end
        job.mode=boxTap and "BoxLinked"or "ManualToggle"
        for id,at in pairs(tapPending) do if d.Now()-at>5 then tapPending[id]=nil;job.unanswered=(job.unanswered or 0)+1 end end
        status("Tap","Sending taps; counting server replies")
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
    function C.Tick(name)
        local job=assert(jobs[name])
        if not alive then return end
        if name=="Stars"or name=="Boxes"then
            if d.WorldTick then
                local ok,err=pcall(d.WorldTick,name,job,jobs)
                if not ok then
                    job.error=tostring(err);job.isTapping=false;job.status="Error; save report";job.nextAt=d.Now()+5
                    if d.WorldCancel then d.WorldCancel(name)end
                    table.insert(C.Report.errors,{job=name,message=job.error,t=d.Now()})
                    if #C.Report.errors>30 then table.remove(C.Report.errors,1)end
                end
            end
            return
        end
        if poll(name) then return end
        if not enabled(name) then
            if name=="Tap"and job.mode=="BoxLinked"then job.mode=nil;status(name,"Disabled")end
            return
        end
        if job.pending then
            if d.Now()-job.pending.at>12 then
                config[name]=false;job.uncertain=true
                status(name,"No confirmation; stopped to avoid duplicate purchases")
            end
            return
        end
        if d.Now()<job.nextAt then return end
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
        if name=="Rebirth" and result.Index~=nil and result.Index~=pending.index then return end
        if name=="Equip" and result.Action~="EquipBest" then return end
        job.pending=nil;job.result=result;job.reason=result.Error or result.Reason
        if result.Success==true then
            job.confirmed+=1;job.nextAt=d.Now()+intervals[name]
        else
            job.rejected+=1
            job.nextAt=d.Now()+((job.reason=="RateLimited") and 2 or 8)
        end
        if config[name] then status(name,result.Success==true and "Server accepted" or "Server rejected request") else notify() end
    end
    function C.Set(name,value)
        assert(jobs[name],"Unknown automation")
        config[name]=value==true;jobs[name].generation+=1;jobs[name].nextAt=d.Now()
        if(name=="Stars"or name=="Boxes")and not config[name]and d.WorldCancel then d.WorldCancel(name)end
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
    local A={Data=d.Data,Now=d.Now,Fire=d.Fire,Request=d.Request,CanInvoke=d.CanInvoke,SequenceStart=d.SequenceStart,
        WorldTick=d.WorldTick,WorldBusy=d.WorldBusy,WorldCancel=d.WorldCancel,BoxTapping=d.BoxTapping}
    local function get(path) return d.Module(path) end
    function A.Gifts() return get("Shared.Items.GiftConfig").Pools end
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
    return A
end

end)()
local makeMovement=(function()
return function(config,d)
    local M={Report={mode="Teleport",teleports=0},JumpReport={mode="NativeDoubleJump",jumps=0}}
    local player,world=d.Player,d.World
    local active,alive=nil,true
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
    function M.Approach(kind,egg)
        if not alive then return false,"Disabled",M.Report end
        local c,h,r=character()
        if not h then stop();return false,"Waiting for character",M.Report end
        assert(kind=="Stars"or kind=="Boxes","Unknown movement owner")
        local target=egg
        assert(type(target)=="table"and target.point and target.live,"Missing live world target")
        if not active or active.key~=target.key or active.h~=h or active.live~=target.live then
            stop()
            active={key=target.key,h=h,live=target.live,kind=kind,target=target.point,attempts=0,nextTeleport=0}
        end
        if target.pointTolerance and(active.target-target.point).Magnitude>1 then
            active.delivered=nil;active.arrivedAt=nil;active.nextTeleport=0
        end
        active.target=target.point
        M.Report.owner=kind;M.Report.target=point(target.point);M.Report.distance=target.distance
        local arrived=target.ready
        if target.pointTolerance then
            local error=(r.Position-target.point).Magnitude
            M.Report.landingError=error
            if error<=target.pointTolerance then active.delivered=true end
            if not active.delivered then arrived=false end
        else M.Report.landingError=nil end
        M.Report.actual=point(r.Position)
        if arrived then
            if not active.arrivedAt then
                active.arrivedAt=d.Now();h:MoveTo(r.Position)
            end
            local ready=d.Now()-active.arrivedAt>=(target.settle or .6)
            M.Report.status=ready and "In native interaction range"or "Waiting for position replication"
            return ready,M.Report.status,M.Report
        end
        active.arrivedAt=nil
        if d.Now()>=active.nextTeleport then
            if active.attempts>=3 then active.attempts=0 end
            h:MoveTo(r.Position)
            d.Teleport(c,h,r,target.point)
            if target.pointTolerance then active.arrivedAt=d.Now()end
            active.attempts+=1
            active.nextTeleport=d.Now()+(active.attempts>=3 and 10 or 2)
            M.Report.teleports+=1;M.Report.attempt=active.attempts
            M.Report.actual=point(r.Position)
            M.Report.landingError=target.pointTolerance and(r.Position-target.point).Magnitude or nil
        end
        M.Report.status=active.attempts>=3 and "Position not retained; waiting to retry"or
            (kind=="Stars"and "Teleporting to star"or "Teleporting to locked box")
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
        if not config[a.kind]then stop();return end
        local _,h,r=character()
        if not h or h~=a.h then stop();return end
    end
    function M.Cancel()stop()end
    function M.Destroy()alive=false;stop();clearTrack()end
    return M
end

end)()
local makeWorldFarm=(function()
return function(config,d)
    local F={}
    local active,alive=nil,true
    local collected,retry={},{}
    local routes=d.Routes or {Stars={},Chests={},Probes={}}
    local chestCooldown,probeRetry={},{}
    local streamAt=0
    local function position(entry)return Vector3.new(entry.x,entry.y,entry.z)end
    local function serverNow()return d.ServerNow and d.ServerNow()or d.Now()end
    local function stream(pos,job)
        if d.Stream and d.Now()>=streamAt then
            streamAt=d.Now()+4;d.Stream(pos)
            job.streamRequests=(job.streamRequests or 0)+1
        end
    end
    local function status(job,text)job.status=text end
    local function root()
        local c=d.Player.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local r=c and c:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health>0 then return r end
    end
    local function release()
        if active and active.job then active.job.isTapping=false end
        active=nil;d.CancelMovement()
    end
    function F.Busy()return active and active.kind end
    function F.BoxTapping()
        return alive and config.Boxes and active and active.kind=="Boxes"and active.job.isTapping==true
    end
    function F.Cancel(kind)
        if active and active.kind==kind then
            active.job.isTapping=false
            -- An issued Collect/Claim call retains movement until its real reply arrives.
            if not active.job.collectionTicket then release()end
        end
    end
    local function standingHeight()
        local r=root()
        local h=d.Player.Character and d.Player.Character:FindFirstChildOfClass("Humanoid")
        return math.max(3,(h and h.HipHeight or 2)+(r and r.Size and r.Size.Y/2 or 1))
    end
    local function boxLanding(cf,size,pos)
        local p=cf:PointToObjectSpace(pos)
        local hx,hz=size.X/2,size.Z/2
        local x,z=math.clamp(p.X,-hx,hx),math.clamp(p.Z,-hz,hz)
        local delta=Vector3.new(p.X-x,0,p.Z-z)
        if delta.Magnitude>.01 then
            local outward=delta.Unit*3
            x+=outward.X;z+=outward.Z
        elseif hx-math.abs(p.X)<hz-math.abs(p.Z)then
            x=(p.X<0 and -1 or 1)*(hx+3)
        else z=(p.Z<0 and -1 or 1)*(hz+3)end
        return cf:PointToWorldSpace(Vector3.new(x,-size.Y/2+standingHeight()+.1,z))
    end
    local function live(model)return model and model:IsDescendantOf(d.World)end
    local function kind(value)return d.Typeof and d.Typeof(value)or typeof(value)end
    local function starPlan(r)
        local cfg=d.Module("Shared.Game.ShinyStarConfig")
        local data=d.Data()
        local best,nearest
        local candidates={}
        for _,entry in ipairs(routes.Stars or {})do
            if cfg.Get(entry.id)then
                candidates[entry.id]={id=entry.id,center=position(entry),route=entry,source="Route"}
            end
        end
        for _,model in ipairs(d.Collection:GetTagged(cfg.Tag))do
            if live(model)and model:IsA("Model")then
                local id=model:GetAttribute(cfg.IdAttribute)
                local center=model:GetAttribute(cfg.CenterAttribute)
                if type(id)=="string"and kind(center)=="Vector3"and cfg.Get(id)
                    then
                    local previous=candidates[id]
                    candidates[id]={id=id,model=model,center=center,route=previous and previous.route,source="Live"}
                end
            end
        end
        for id,target in pairs(candidates)do
            if not collected[id]and not cfg.IsFound(data,id)and d.Now()>=(retry[id]or 0)then
                local distance=(r.Position-target.center).Magnitude
                if not nearest or distance<nearest then nearest=distance;best=target end
            end
        end
        return best,cfg
    end
    local function boxState(model,cfg)
        local a=cfg.Attributes
        if not model then return nil,"Box disappeared without break confirmation"end
        local hp,max=model:GetAttribute(a.Health),model:GetAttribute(a.MaxHealth)
        if model:GetAttribute(a.Broken)==true or(type(hp)=="number"and hp<=0)then return nil,"Broken"end
        if not live(model)then return nil,"Box disappeared without break confirmation"end
        if model:GetAttribute(a.Despawned)==true then return nil,"Box despawned without break confirmation"end
        local owner=model:GetAttribute(a.Owner)
        if owner~=nil and owner~=d.Player.UserId then return nil,"Box belongs to another player"end
        local cf,size=model:GetAttribute(a.Rest),model:GetAttribute(a.Size)
        if kind(cf)~="CFrame"or kind(size)~="Vector3"or type(hp)~="number"or type(max)~="number"or max<=0 then
            return nil,"Box data unavailable"
        end
        return {hp=hp,max=max,cf=cf,size=size,type=model:GetAttribute(a.Type)}
    end
    local function nearbyPlayer(cf,size)
        if not config.BoxesAvoidPlayers then return false end
        local radius=math.max(size.X,size.Z)/2+18
        for _,p in ipairs(d.Players:GetPlayers())do
            if p~=d.Player then
                local c=p.Character
                local r=c and c:FindFirstChild("HumanoidRootPart")
                local h=c and c:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health>0 and(r.Position-cf.Position).Magnitude<=radius then return true end
            end
        end
        return false
    end
    local function boxPlan(r)
        local cfg=d.Module("Shared.Game.BreakableConfig")
        local best,nearest
        for _,model in ipairs(d.Collection:GetTagged(cfg.Tag))do
            if model:IsA("Model")then
                local state=boxState(model,cfg)
                if state and(state.type=="Crate"or state.type=="Chest"or state.type=="WorldChest")
                    and state.hp==state.max and not nearbyPlayer(state.cf,state.size)then
                    local distance=(r.Position-state.cf.Position).Magnitude
                    if not nearest or distance<nearest then
                        nearest=distance;best={model=model,state=state}
                    end
                end
            end
        end
        return best
    end
    local function prepare(name,job)
        if active and active.kind~=name then status(job,"Waiting for current world target");return false end
        return true
    end
    local function stars(job)
        local cfg=d.Module("Shared.Game.ShinyStarConfig")
        if cfg.CountFound(d.Data())>=cfg.Total then
            if active and active.kind=="Stars"then release()end
            config.Stars=false;status(job,"All stars collected");return
        end
        if not active then
            local target=starPlan(root())
            if not target then status(job,"Waiting for uncollected stars to load");return end
            active={kind="Stars",target=target,job=job}
            job.target={id=target.id,source=target.source};job.reason=nil
        end
        local target=active.target
        if cfg.IsFound(d.Data(),target.id)then
            if not collected[target.id]then job.confirmed+=1 end
            collected[target.id]=true;job.confirmationSource="Replica"
            release();status(job,"Star collection confirmed");return
        end
        -- A known survey anchor can be used before the star streams in.
        -- Once loaded, use the native center rather than the approximate route.
        for _,model in ipairs(d.Collection:GetTagged(cfg.Tag))do
            if live(model)and model:GetAttribute(cfg.IdAttribute)==target.id then
                local center=model:GetAttribute(cfg.CenterAttribute)
                if kind(center)=="Vector3"then target.model=model;target.center=center;target.source="Live"end
            end
        end
        if not live(target.model)and not target.route then release();status(job,"Star unavailable; rescanning");return end
        job.target.source=target.source
        if not live(target.model)then stream(target.center,job)end
        local r=root()
        local distance=(r.Position-target.center).Magnitude
        local position=target.center+Vector3.new(0,3,0)
        local reach=math.min(cfg.PickupRange or 6,math.max(1,(cfg.ServerReach or 22)-2))
        local ready,why,travel=d.Approach("Stars",{point=position,ready=distance<=reach,distance=distance,
            live=live(target.model)and target.model or target.route,key="Star:"..target.id,settle=.2,pointTolerance=4})
        job.travel=table.clone(travel)
        if not ready then status(job,why);return end
        if not d.CanInvoke()then status(job,"Waiting for previous request");return end
        job.collectionTicket=d.Request("ShinyStarService","Collect",target.id)
        job.requests+=1;status(job,"Waiting for star collection result")
    end
    local function pollCollection(name,job)
        local ticket=job.collectionTicket
        if not ticket then return false end
        if not ticket.done then
            status(job,d.Now()-ticket.started>12 and "Request pending; no duplicate sent"or
                (name=="Stars"and "Waiting for star collection result"or "Waiting for tap chest claim result"))
            return true
        end
        local id=job.target and job.target.id
        job.collectionTicket=nil;job.result=ticket.result
        local accepted=ticket.ok and type(ticket.result)=="table"and ticket.result.Success==true
        if accepted then
            if name=="Stars"then
                if id and not collected[id]then job.confirmed+=1;collected[id]=true end
                job.confirmationSource="Collect reply"
            else
                local cfg=d.Module("Shared.Game.TapChestConfig")
                local def=cfg.Get(id)
                job.confirmed+=1;job.claimed=(job.claimed or 0)+1
                chestCooldown[id]=serverNow()+(def and def.Cooldown or 5)
                job.readyAt=chestCooldown[id];job.confirmationSource="Claim reply"
            end
            job.reason=nil
        else
            job.rejected+=1
            job.reason=ticket.ok and type(ticket.result)=="table"and ticket.result.Reason or tostring(ticket.error or "No result")
            if id then retry[(name=="Stars"and ""or "Chest:")..id]=d.Now()+8 end
        end
        if active and active.kind==name then release()end
        job.nextAt=d.Now()+(accepted and .2 or 2)
        status(job,not config[name]and "Disabled"or(accepted and
            (name=="Stars"and "Star collection confirmed"or "Tap chest claim confirmed")or
            (name=="Stars"and "Star collection rejected"or "Tap chest claim rejected")))
        return true
    end
    local function liveChests(cfg)
        local candidates={}
        for _,model in ipairs(d.Collection:GetTagged(cfg.Tag))do
            if live(model)and model:IsA("Model")then
                local id=model:GetAttribute(cfg.Attributes.Id)
                local cf,size=model:GetAttribute(cfg.Attributes.Front),model:GetAttribute(cfg.Attributes.Size)
                if cfg.Get(id)and kind(cf)=="CFrame"and kind(size)=="Vector3"then
                    local point=cf.Position-Vector3.new(0,size.Y*.5,0)+
                        cf.LookVector*(size.Z*.5+cfg.PromptInset)+Vector3.new(0,cfg.PromptHeight,0)
                    candidates[id]={mode="TapChest",id=id,model=model,center=point,source="Live"}
                end
            end
        end
        return candidates
    end
    local function chestPlan(r,near)
        local cfg=d.Module("Shared.Game.TapChestConfig")
        local candidates=liveChests(cfg)
        for _,entry in ipairs(routes.Chests or {})do
            if cfg.Get(entry.id)and not candidates[entry.id]then
                candidates[entry.id]={mode="TapChest",id=entry.id,center=position(entry),route=entry,source="Route"}
            end
        end
        local best,nearest
        for id,target in pairs(candidates)do
            local readyAt=math.max(cfg.GetReadyAt(d.Data(),id),chestCooldown[id]or 0)
            if readyAt<=serverNow()and d.Now()>=(retry["Chest:"..id]or 0)and
                (not near or(target.center-near).Magnitude<=256)then
                local distance=(r.Position-target.center).Magnitude
                if not nearest or distance<nearest then nearest=distance;best=target end
            end
        end
        return best,cfg
    end
    local function probePlan(r)
        local best,nearest
        for index,entry in ipairs(routes.Probes or {})do
            if d.Now()>=(probeRetry[index]or 0)then
                local distance=(r.Position-position(entry)).Magnitude
                if not nearest or distance<nearest then
                    nearest=distance;best={mode="Probe",index=index,route=entry,center=position(entry)}
                end
            end
        end
        return best
    end
    local function tapChest(job,target)
        local cfg=d.Module("Shared.Game.TapChestConfig")
        local current=liveChests(cfg)[target.id]
        if current then
            target.model=current.model;target.center=current.center;target.source="Live"
            job.target.source="Live"
        end
        local readyAt=math.max(cfg.GetReadyAt(d.Data(),target.id),chestCooldown[target.id]or 0)
        job.readyAt=readyAt;job.serverNow=serverNow()
        if readyAt>serverNow()then release();status(job,"Tap chest is on cooldown");return end
        stream(target.center,job)
        local distance=(root().Position-target.center).Magnitude
        -- Center is already the native prompt anchor, PromptHeight above the base.
        local point=target.center+Vector3.new(0,standingHeight()-cfg.PromptHeight+.1,0)
        local reach=math.min((cfg.ClaimReach or 45)-2,16)
        local ready,why,travel=d.Approach("Boxes",{point=point,ready=distance<=reach,distance=distance,
            live=target.model or target.route,key="TapChest:"..target.id,settle=.3,pointTolerance=2.5})
        job.travel=table.clone(travel);job.isTapping=false
        if not ready then status(job,why);return end
        if not d.CanInvoke()then status(job,"Waiting for previous request");return end
        job.collectionTicket=d.Request("TapChestService","Claim",target.id)
        job.requests+=1;status(job,"Waiting for tap chest claim result")
    end
    local function probe(job,target)
        stream(target.center,job)
        -- An unidentified survey point only requests streaming. Move after a real target is found.
        job.isTapping=false
        active.probeAt=active.probeAt or d.Now()
        local found
        if config.BoxesMode~="Breakables"then found=chestPlan(root(),target.center)end
        if not found and config.BoxesMode~="TapChest"then
            found=boxPlan(root())
            if found and(found.state.cf.Position-target.center).Magnitude>256 then found=nil end
        end
        if found then
            release()
            active={kind="Boxes",target=found,job=job,lastHealth=found.state and found.state.hp,progressAt=d.Now()}
            job.target={id=found.id,name=found.model and found.model.Name,source=found.source,mode=found.mode or "Breakables"}
            status(job,"Target discovered at survey point")
        elseif d.Now()-active.probeAt>=3 then
            probeRetry[target.index]=d.Now()+90
            job.probesSkipped=(job.probesSkipped or 0)+1
            release();status(job,"No compatible chest at survey point")
        else status(job,"Loading chest survey point")end
    end
    local function boxes(job)
        if not active then
            local mode=config.BoxesMode or "Breakables"
            local target
            if mode~="Breakables"then target=chestPlan(root())end
            if not target and mode~="TapChest"then target=boxPlan(root())end
            if not target then target=probePlan(root())end
            if not target then status(job,mode=="TapChest"and "Waiting for ready tap chests"or "Waiting for untouched boxes");return end
            active={kind="Boxes",target=target,job=job,lastHealth=target.state and target.state.hp,progressAt=d.Now()}
            job.target={id=target.id,name=target.model and target.model.Name,type=target.state and target.state.type,
                mode=target.mode or "Breakables",source=target.source}
            job.reason=nil;job.health=target.state and target.state.hp;job.maxHealth=target.state and target.state.max
        end
        local target=active.target
        if target.mode=="TapChest"then tapChest(job,target);return end
        if target.mode=="Probe"then probe(job,target);return end
        local cfg=d.Module("Shared.Game.BreakableConfig")
        local state,reason=boxState(target.model,cfg)
        if not state then
            job.isTapping=false
            if reason=="Broken"then job.confirmed+=1;job.health=0
            else job.lost=(job.lost or 0)+1 end
            release();status(job,reason=="Broken"and "Box broken; selecting next"or reason);return
        end
        if state.hp<active.lastHealth then
            job.healthChanges=(job.healthChanges or 0)+1;active.progressAt=d.Now()
        end
        active.lastHealth=state.hp;job.health=state.hp;job.maxHealth=state.max
        local r=root()
        if target.landingFrame~=state.cf or target.landingSize~=state.size then
            target.landing=boxLanding(state.cf,state.size,r.Position)
            target.landingFrame=state.cf;target.landingSize=state.size
        end
        local ready,why,travel=d.Approach("Boxes",{point=target.landing,ready=cfg.InRange(r.Position,state.cf,state.size),
            distance=(r.Position-state.cf.Position).Magnitude,live=target.model,key="Box:"..tostring(target.model),pointTolerance=3})
        job.travel=table.clone(travel);job.isTapping=ready==true
        if not ready then status(job,why)
        else status(job,d.Now()-active.progressAt>10 and "Tapping locked box; no health change yet"or "Tapping locked box until broken")end
    end
    function F.Tick(name,job,jobs)
        if not alive then return end
        if pollCollection(name,job)then return end
        if not config[name]then
            F.Cancel(name)
            if job.status~="All stars collected"then status(job,"Disabled")end
            return
        end
        if d.Now()<(job.nextAt or 0)then return end
        job.nextAt=d.Now()+.1
        if not d.Data()then status(job,"Waiting for player data");return end
        if not root()then job.isTapping=false;status(job,"Waiting for character");return end
        if not prepare(name,job)then return end
        if name=="Stars"then stars(job)else boxes(job)end
    end
    function F.Destroy()alive=false;release()end
    return F
end

end)()
local surveyRoutes=(function()
-- User supplied survey points; live attributes take precedence over these anchors.
-- Missing Spawn3 position is intentionally left to live discovery.
return {
    Stars={
        {id="Autumn1",x=-125.5,y=905.13,z=-1978.3},
        {id="Autumn2",x=23.6,y=882.83,z=-1947.9},
        {id="Mushroom1",x=78.9,y=2034.53,z=-1996.0},
        {id="Mushroom2",x=-124.1,y=2032.53,z=-2067.9},
        {id="Desert1",x=13.2,y=3643.33,z=-2165.9},
        {id="Desert2",x=59.1,y=3636.43,z=-1979.1},
        {id="CrystalCave1",x=-235,y=5444.93,z=-2050.9},
        {id="CrystalCave2",x=19.7,y=5446.53,z=-2033.5},
        {id="ShadowRelm1",x=13.2,y=7692.23,z=-2106.3},
        {id="ShadowRelm2",x=197.8,y=7698.43,z=-1858.6},
        {id="SkyIsland1",x=-79.7,y=-49.07,z=-1930.4},
        {id="SkyIsland2",x=14.9,y=-53.57,z=-1770.3},
        -- Face positions from the supplied client map, rounded survey anchors.
        {id="Spawn1",x=53.6,y=-513.34,z=-2015.7},
        {id="Spawn2",x=-4.4,y=-513.02,z=-1699.5},
    },
    Chests={
        -- Native Sky Island TapChest.RootPart from the supplied dump.
        {id="SkyIsland",x=-15.42363,y=-57.32753,z=-1871.45776},
    },
    Probes={
        -- No TapChest ID was supplied for these points. Discover actual tagged objects there.
        {x=-99.5,y=879.8,z=-1782.3},
        {x=-84.1,y=2038.7,z=-2043.2},
        {x=-297.9,y=2017.6,z=-1972.1},
        {x=-92.6,y=887.9,z=-1906.5},
        {x=-124.2,y=2014.8,z=-1814.7},
        -- A Desert survey position can stream in the native Desert TapChest.
        {x=13.2,y=3643.33,z=-2165.9},
    },
}

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
local config={Tap=false,Rebirth=false,Upgrade=false,Quests=false,Gifts=false,Equip=false,Stars=false,Boxes=false,BoxesAvoidPlayers=true,BoxesMode="TapChest",
    InfiniteJump=false,CPS=40,Gift="",ReserveCoins=0,ReserveGems=0,RebirthAmount="Auto",
    Upgrades={ClickMultiplier=true,CriticalChance=true,AutoClickerSpeed=true},
    Language="TH"}
local api={Config=config}
local alive,rebuilding=true,false
local core,adapter,window,replica,movement,worldFarm
local connections,controls={},{}
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
local deps={
    Data=function() return replica and replica.Data end,
    Module=module,Now=now,Attribute=function(name)return player:GetAttribute(name)end,
    CanInvoke=function()return env.DevilTappingRPCPending==nil end,
    SequenceStart=math.floor(now()*1000)+1000000000,
    Fire=function(service,name,packet)
        local endpoint=remote(service,"RE",name)
        if packet==nil then endpoint:FireServer()else endpoint:FireServer(packet)end
    end,
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
worldFarm=makeWorldFarm(config,{
    Data=deps.Data,Module=module,Now=now,Player=player,Players=game:GetService("Players"),
    Collection=game:GetService("CollectionService"),World=workspace,Approach=deps.Approach,
    Request=deps.Request,CanInvoke=deps.CanInvoke,CancelMovement=movement.Cancel,
    Routes=surveyRoutes,ServerNow=function()return workspace:GetServerTimeNow()end,
    Stream=function(pos)task.spawn(function()pcall(player.RequestStreamAroundAsync,player,pos,2)end)end,
})
deps.WorldTick=worldFarm.Tick;deps.WorldBusy=worldFarm.Busy
deps.WorldCancel=worldFarm.Cancel;deps.BoxTapping=worldFarm.BoxTapping
local labels={
    Tap={"Fast Auto Click","ออโต้คลิกเร็ว"},
    Rebirth={"Auto Rebirth","รีเบิร์ทอัตโนมัติ"},Upgrade={"Auto Buy Upgrades","ซื้ออัปเกรดอัตโนมัติ"},
    Quests={"Auto Claim Quests","รับเควสต์ที่สำเร็จ"},Gifts={"Auto Open Gift","เปิดของขวัญอัตโนมัติ"},
    Equip={"Auto Equip Best","ใส่สัตว์ที่ดีที่สุด"},
    Stars={"Auto Collect Stars","วาร์ปเก็บดาวอัตโนมัติ"},Boxes={"Auto Boxes / Tap Chest","ออโต้กล่อง / Tap Chest"},
}
local function t(en,th)return config.Language=="TH" and th or en end
local refreshAt=0
local function refresh(report,force)
    if not alive then return end
    if not force and now()<refreshAt then return end
    refreshAt=now()+.2
    for _,name in ipairs(core.Names) do
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
    local bytes=Http:JSONEncode(clean(core.Report,0))
    if type(writefile)=="function" then pcall(writefile,"DevilTappingTestReport.json",bytes) end
    if type(setclipboard)=="function" then pcall(setclipboard,bytes) end
    return bytes
end
function api.Destroy()
    if not alive then return end
    alive=false
    if core then core.Destroy() end
    worldFarm.Destroy()
    movement.Destroy()
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
local library
build=function()
    rebuilding=true
    if window then window:Destroy() end
    controls={}
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
    end
    local farm=tab("Click / Player","คลิก / ผู้เล่น","mouse-pointer-click")
    local taps=group(farm,"Fast clicking","ออโต้คลิกเร็ว","Left","mouse-pointer-click")
    toggle(taps,"Tap")
    taps:CreateSlider({Name=t("Requested clicks / second","จำนวนคลิกที่ส่งต่อวินาที"),Range={1,100},Increment=1,CurrentValue=config.CPS,Callback=function(value)config.CPS=value end})
    toggle(taps,"Equip")
    local movement=group(farm,"Player","ผู้เล่น","Right","person-standing")
    controls.InfiniteJump=movement:CreateToggle({Name=t("Infinite Jump","กระโดดไม่จำกัด"),CurrentValue=config.InfiniteJump,Callback=function(value)config.InfiniteJump=value==true end})
    movement:CreateParagraph({Name=t("Jump control","วิธีกระโดด"),Content=t(
        "Press jump again in midair. Reuses native double jumps; players without an air jump use the map's jump force, direction and animation.",
        "กดปุ่มกระโดดของเกมซ้ำกลางอากาศ ใช้ Double Jump ของแมพต่อเนื่อง หากยังไม่มี ใช้แรงส่ง ทิศทาง และท่ากระโดดแบบเดียวกับแมพ")})
    local worldTab=tab("Stars / Boxes","ดาว / กล่อง","star")
    local starGroup=group(worldTab,"Shiny stars","เก็บดวงดาว","Left","star")
    toggle(starGroup,"Stars")
    starGroup:CreateParagraph({Name=t("Collection route","การเก็บดาว"),Content=t(
        "Collects unclaimed stars using their live centers, with saved survey coordinates as a fallback.",
        "เก็บดาวที่ยังไม่เคยเก็บโดยใช้ตำแหน่งจริง และใช้พิกัดสำรวจเมื่อดาวยังไม่โหลด")})
    local boxGroup=group(worldTab,"Break boxes","ทุบกล่อง","Right","box")
    local modeLabels={TapChest="Tap Chest",Breakables=t("Breakables","กล่องทุบ"),Both=t("Both","ทั้งสองแบบ")}
    boxGroup:CreateDropdown({Name=t("Box type","ประเภทกล่อง"),Options={modeLabels.TapChest,modeLabels.Breakables,modeLabels.Both},
        CurrentOption={modeLabels[config.BoxesMode]},Callback=function(value)
            value=single(value)
            for mode,label in pairs(modeLabels)do if value==label then config.BoxesMode=mode;worldFarm.Cancel("Boxes");break end end
        end})
    toggle(boxGroup,"Boxes")
    boxGroup:CreateToggle({Name=t("Avoid nearby players","หลีกเลี่ยงกล่องใกล้ผู้เล่นอื่น"),CurrentValue=config.BoxesAvoidPlayers,Callback=function(value)config.BoxesAvoidPlayers=value==true end})
    boxGroup:CreateParagraph({Name=t("Locked target","ล็อกเป้าหมายจนแตก"),Content=t(
        "Tap Chest: collects ready rewards. Breakables: taps one full-health box until it breaks, then moves to the next. Survey points load the area to find a live target.",
        "Tap Chest: รับรางวัลจากกล่องที่พร้อม ส่วนกล่องทุบจะตีเป้าหมายเดิมจนแตกแล้วค่อยไปกล่องถัดไป พิกัดสำรวจใช้โหลดพื้นที่เพื่อค้นหากล่องจริง")})
    boxGroup:CreateParagraph({Name=t("Movement queue","คิวการวาร์ป"),Content=t(
        "Finishes the current star or box before moving to another target.",
        "เก็บดาวหรือทุบกล่องเป้าหมายปัจจุบันให้เสร็จก่อนย้ายไปเป้าหมายถัดไป")})
    local progressTab=tab("Progress / Rewards","พัฒนา / รางวัล","gift")
    local progress=group(progressTab,"Progression","พัฒนาตัวละคร","Left","trending-up")
    progress:CreateDropdown({Name=t("Rebirth amount","จำนวนรีเบิร์ท"),Options=adapter.RebirthAmounts(),CurrentOption={config.RebirthAmount},Callback=function(value)
        config.RebirthAmount=tostring(single(value))
    end})
    progress:CreateParagraph({Name=t("Rebirth selection","การเลือกจำนวน"),Content=t(
        "Auto chooses the largest unlocked amount you can afford. A specific amount waits for its unlock and full price.",
        "Auto เลือกจำนวนสูงสุดที่ปลดล็อกและเงินพอ หากเลือก 1 / 5 / 25 / 125 จะใช้จำนวนนั้นเท่านั้น รอจนปลดล็อกและเงินพอ")})
    toggle(progress,"Rebirth");toggle(progress,"Upgrade")
    progress:CreateDropdown({Name=t("Selected upgrades","อัปเกรดที่ซื้อ"),Options={"ClickMultiplier","CriticalChance","AutoClickerSpeed"},
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
    local settings=tab("Settings / Report","ตั้งค่า / รายงาน","settings")
    local diagnostics=group(settings,"Trial controls","ตัวควบคุมรุ่นทดลอง","Left","file-text")
    api.Info=diagnostics:CreateParagraph({Name=t("Build","รุ่น"),Content="tapping-auto-test-6"})
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
    rebuilding=false;refresh(core.Report,true)
end
env.DevilTappingTest=api
local ok,problem=xpcall(function()
    adapter=makeAdapter(config,deps)
    core=makeCore(config,adapter,refresh);api.Core=core
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    library=assert(loadstring(source,"DEVIL HUB / OuroFlow"))()
    build()
    for _,entry in ipairs({{"Tap","TapService","TapResult"},{"Rebirth","RebirthService","RebirthResult"},{"Equip","PetService","PetActionResult"}})do
        local name=entry[1]
        connections[#connections+1]=remote(entry[2],"RE",entry[3]).OnClientEvent:Connect(function(result)
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
        for _,name in ipairs(core.Names)do core.Tick(name)end
        refresh(core.Report)
    end)
    task.spawn(function()
        local loaded,value=pcall(function()return module("Controllers.Core.DataController"):GetReplica()end)
        if alive then
            if loaded then replica=value
            else core.Report.dataError=tostring(value)end
        end
    end)
end,debug.traceback)
if not ok then api.Destroy();error("DEVIL HUB Tapping Test: "..tostring(problem),0)end
return api
