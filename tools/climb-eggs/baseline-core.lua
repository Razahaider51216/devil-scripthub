return function(config, notify, P, dependencies)
    local D=dependencies or {}
    local Players=D.Players or game:GetService("Players")
    local RS=D.RS or game:GetService("ReplicatedStorage")
    local Http=D.Http or game:GetService("HttpService")
    local player=D.Player or Players.LocalPlayer
    local world=D.World or workspace
    local clock=D.Clock or os.clock
    local controllers=D.Controllers or {}
    local modules=D.Modules or {}
    local links,esp,delays={}, {}, {}
    local stopped, movementBusy, rpcBusy=false,false,false
    local stopFlight
    local target,carriedBefore,awaitClaim,awaitPlace,awaitHatch,fuseRecipe
    local blockedUntil={}
    local R={release="climb-fly-speed-10",status="Ready",phase="Idle",picked=0,stored=0,placed=0,hatched=0,
        lost=0,errors={},jobs={},placeId=game.PlaceId}
    local core={Config=config,Report=R,Tiers=P.Tiers,Variants=P.Variants,Mutations=P.Mutations}
    local function status(text) R.status=text;if notify then notify(R) end end
    local function job(name,text)
        local value=R.jobs[name] or {requests=0,confirmed=0}
        value.status=text;value.updatedAt=clock();R.jobs[name]=value
        return value
    end
    local function errorLog(value)
        table.insert(R.errors,tostring(value));if #R.errors>20 then table.remove(R.errors,1) end
    end
    if not D.Controllers then
        local src=RS:WaitForChild("src",20);assert(src,"Game src not loaded")
        local packages=src:WaitForChild("Packages",20);assert(packages,"Game packages not loaded")
        local Knit=require(packages:WaitForChild("knit",20))
        local needed={"DataController","BaseController","ZoneController","FallController","TreadmillController",
            "EggHatchController","EggCarryController","GiftPlayTimeController","DayCycleController","EventController"}
        local timeout=clock()+25
        repeat
            for _,name in ipairs(needed) do
                if not controllers[name] then local ok,result=pcall(Knit.GetController,name);if ok then controllers[name]=result end end
            end
            if controllers.DataController and controllers.BaseController then break end
            task.wait(.2)
        until clock()>=timeout
        assert(controllers.DataController and controllers.BaseController,"Game controllers not ready; rejoin and retry")
        local gc=src:FindFirstChild("GameConfiguration")
        local definitions={Egg={"Gameplay","eggConfig"},Fuse={"Gameplay","fuseConfig"},
            Rebirth={"Economy","rebirthConfig"},Trails={"Economy","trailsConfig"},
            Base={"Economy","baseUpgradeConfig"},Stamina={"Economy","staminaUpgradeConfig"},
            Treadmill={"Economy","treadmillConfig"}}
        for name,path in pairs(definitions) do
            local parent=gc and gc:FindFirstChild(path[1]);local instance=parent and parent:FindFirstChild(path[2])
            if instance then local ok,result=pcall(require,instance);if ok then modules[name]=result end end
        end
        local utility=src:FindFirstChild("utility")
        for name,file in pairs({Earning="earningCurve",Day="dayCycle"}) do
            local instance=utility and utility:FindFirstChild(file)
            if instance then local ok,result=pcall(require,instance);if ok then modules[name]=result end end
        end
    end
    local function data(name,default)
        local controller=controllers.DataController
        local value=controller and controller.Data and controller.Data[name]
        return value==nil and default or value
    end
    local function character()
        local model=player.Character;return model,model and model:FindFirstChild("HumanoidRootPart"),model and model:FindFirstChildOfClass("Humanoid")
    end
    local function base() local c=controllers.BaseController;return c and c.Base end
    local function home()
        local c=controllers.BaseController
        if c and c.TpCFrame then return c.TpCFrame.Position end
        local b=base();local tp=b and b:FindFirstChild("TpCFrame")
        return tp and tp:GetPivot().Position+Vector3.new(0,3,0)
    end
    local function equipped()
        local out={}
        for _,key in ipairs({"EquippedAnimals","AnimalLoadout","Loadout"}) do
            for k,v in pairs(data(key,{})) do
                if type(v)=="string" then out[v]=true elseif v==true then out[k]=true
                elseif type(v)=="table" and v.ReferenceName then out[v.ReferenceName]=true end
            end
        end
        for key,item in pairs(data("Inventory",{})) do
            if type(item)=="table" and (item.Equipped or item.Placed or item.IsEquipped) then out[key]=true end
        end
        local b=base();local animals=b and b:FindFirstChild("Animals")
        if animals then for _,item in ipairs(animals:GetChildren()) do out[item:GetAttribute("ReferenceName") or item.Name]=true end end
        return out
    end
    local function rarity(name)
        local entry=modules.Egg and modules.Egg.Eggs[name]
        return entry and entry.Rarity or "Unknown"
    end
    local function score(item)
        local d=item.CustomData or {}
        if modules.Earning and modules.Earning.GetCashPerSecond then
            local ok,value=pcall(modules.Earning.GetCashPerSecond,item.Name,d.AssetScale or 1,d.Variant,d.Mutation)
            if ok and type(value)=="number" then return value end
        end
        return (d.AssetScale or 1)^3
    end
    local function remote(service,method,channel)
        if D.Services then return D.Services[service] and D.Services[service][method] end
        local src=RS:FindFirstChild("src");local packages=src and src:FindFirstChild("Packages")
        local index=packages and packages:FindFirstChild("_Index")
        local knit=index and index:FindFirstChild("sleitnick_knit@1.7.0")
        local k=knit and knit:FindFirstChild("knit");local services=k and k:FindFirstChild("Services")
        local s=services and services:FindFirstChild(service);local ch=s and s:FindFirstChild(channel or "RF")
        return ch and ch:FindFirstChild(method)
    end
    function core.Call(service,method,args,name)
        if stopped or rpcBusy then return nil,"Busy" end
        local r=remote(service,method);local j=job(name or service,"Sending request")
        if not r then j.status="Remote not found: "..service.."."..method;return nil,j.status end
        rpcBusy=true;j.requests+=1
        local done,result,problem,timedOut=false,nil,nil,false
        task.spawn(function()
            local ok,value=pcall(r.InvokeServer,r,table.unpack(args or {},1,(args and args.n) or #(args or {})))
            if ok then result=value else problem=tostring(value) end
            done=true;rpcBusy=false
            if timedOut and not stopped then
                j.pending=false;j.result=result
                j.status=problem or (type(result)=="table" and (result.Reason or result.message)) or "Late server reply received"
                if type(result)=="table" and (result.Status==true or result.ok==true) then j.confirmed+=1 end
            end
        end)
        local deadline=clock()+10
        while not done and not stopped and clock()<deadline do task.wait(.05) end
        if stopped then return nil,"Stopped" end
        if not done then
            timedOut=true
            j.status="Request pending; waiting for server";j.pending=true
            return nil,j.status -- retain the lock until the actual request finishes
        end
        j.pending=false;j.result=result
        if problem then j.status=problem;errorLog(problem);return nil,problem end
        if type(result)=="table" and (result.Status==false or result.ok==false) then
            j.status=result.Reason or result.message or "Server rejected request";return result,j.status
        end
        j.status="Server replied"
        if type(result)=="table" and (result.Status==true or result.ok==true) then j.confirmed+=1 end
        return result
    end
    local function accepted(result) return type(result)=="table" and (result.Status==true or result.ok==true) end
    local function due(name,delay)
        if clock()<(delays[name] or 0) then return false end
        delays[name]=clock()+delay;return true
    end
    function core.Travel(position,canContinue)
        local model,root,hum=character()
        if stopped or not root or not hum or hum.Health<=0 or (canContinue and not canContinue()) then return false end
        if hum.PlatformStand or model:GetAttribute("Ragdolled") then status("Waiting to recover from knockdown");return false end
        local training=controllers.TreadmillController
        if training and training.OnTreadmill then training:DeactivateTreadmill() end
        root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
        root.CFrame=CFrame.new(position)*root.CFrame.Rotation
        R.travel={mode="Teleport",stage="Position set",destination={x=position.X,y=position.Y,z=position.Z}}
        task.wait(.15)
        local currentModel,currentRoot,currentHum=character()
        if stopped or currentModel~=model or currentRoot~=root or not currentHum or currentHum.Health<=0 then
            R.travel.stage="Cancelled";return false
        end
        root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
        local distance=(root.Position-position).Magnitude
        R.travel.distance=distance
        R.travel.actual={x=root.Position.X,y=root.Position.Y,z=root.Position.Z}
        if canContinue and not canContinue() then R.travel.stage="Cancelled";return false end
        if distance>6 then
            R.travel.stage="Position not confirmed";status("Teleport not confirmed; retrying");return false
        end
        R.travel.stage="Arrived";return true
    end
    function core.FlyTo(position,canContinue,carryId,releaseInAir)
        local model,root,hum=character()
        if stopped or not root or not hum or hum.Health<=0 or(canContinue and not canContinue())then return false end
        if carryId~=nil and player:GetAttribute("CarryingEgg")~=carryId then return false end
        if stopFlight then return false end
        if hum.PlatformStand or model:GetAttribute("Ragdolled")then return false end
        local training=controllers.TreadmillController
        if training and training.OnTreadmill then training:DeactivateTreadmill()end
        local attachment,mover
        local collisions={}
        local function phaseParts()
            for _,part in ipairs(model:GetDescendants())do
                if part:IsA("BasePart")then
                    if collisions[part]==nil then collisions[part]=part.CanCollide end
                    part.CanCollide=false
                end
            end
        end
        local cleaned=false
        local function clean()
            if cleaned then return end
            cleaned=true
            if mover then mover:Destroy()end
            if attachment then attachment:Destroy()end
            for part,original in pairs(collisions)do
                if part.Parent then part.CanCollide=original end
            end
            if R.travel and(R.travel.mode=="CFrameFly"or R.travel.mode=="CFrameReturn")then R.travel.noclip=false end
            if root.Parent then root.AssemblyLinearVelocity=Vector3.zero end
            stopFlight=nil
        end
        stopFlight=clean
        local ok,result=xpcall(function()
            attachment=Instance.new("Attachment");attachment.Name="DevilCollectFlight";attachment.Parent=root
            mover=Instance.new("LinearVelocity");mover.Name="DevilCollectVelocity"
            mover.Attachment0=attachment;mover.RelativeTo=Enum.ActuatorRelativeTo.World
            mover.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector;mover.MaxForce=math.huge
            mover.VectorVelocity=Vector3.zero;mover.Parent=root
            local waypoints={position}
            R.travel={mode=carryId~=nil and"CFrameReturn"or"CFrameFly",stage="Flying",noclip=true,maxStepDistance=0,
                destination={x=position.X,y=position.Y,z=position.Z}}
            local bestDistance=(root.Position-position).Magnitude
            local lastProgress,lastStep=clock(),clock()
            for i,point in ipairs(waypoints)do
                R.travel.waypoint=i;R.travel.waypoints=#waypoints
                while(root.Position-point).Magnitude>1 do
                    local current,currentRoot,currentHum=character()
                    local carrying=player:GetAttribute("CarryingEgg")
                    local wrongCarry=carryId~=nil and carrying~=carryId or carryId==nil and carrying~=nil
                    if stopped or cleaned or current~=model or currentRoot~=root or not currentHum or currentHum.Health<=0
                        or currentHum.PlatformStand or model:GetAttribute("Ragdolled")
                        or wrongCarry or(canContinue and not canContinue())then
                        R.travel.stage="Cancelled";return false
                    end
                    phaseParts()
                    local speed=math.clamp(tonumber(config.FlySpeed)or 60,10,500)
                    local delta=point-root.Position;local distance=delta.Magnitude
                    local now=clock()
                    local dt=math.clamp(now-lastStep,.001,.05);lastStep=now
                    local step=math.min(distance,speed*dt)
                    -- Keep the hover constraint at zero velocity while CFrame
                    -- advances in speed-limited steps through local collisions.
                    root.CFrame=CFrame.new(root.Position+delta*(step/distance))*root.CFrame.Rotation
                    root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
                    R.travel.speed=speed;R.travel.distance=(root.Position-position).Magnitude
                    R.travel.maxStepDistance=math.max(R.travel.maxStepDistance,step)
                    if R.travel.distance<bestDistance-.5 then bestDistance=R.travel.distance;lastProgress=now end
                    if clock()-lastProgress>5 then R.travel.stage="Blocked or position pulled back";return false end
                    task.wait(.03)
                end
            end
            R.travel.stage="Landing";return true
        end,debug.traceback)
        clean()
        if R.travel then R.travel.noclip=false end
        if not ok then errorLog(result);R.travel=R.travel or{mode="Fly"};R.travel.stage="Flight error";return false end
        if not result then return false end
        if releaseInAir then R.travel.stage="Released above Lobby";return true end
        local settledUntil=clock()+2
        repeat
            if stopped or(canContinue and not canContinue())then R.travel.stage="Cancelled";return false end
            local current,_,currentHum=character()
            if current~=model or not currentHum or currentHum.Health<=0 then return false end
            local falling=controllers.FallController
            if not falling or not falling.IsFalling then
                task.wait(.2)
                R.travel.stage="Arrived";return true
            end
            task.wait(.05)
        until clock()>=settledUntil
        R.travel.stage="Waiting for landing";return false
    end
    local function promptPosition(prompt)
        local parent=prompt.Parent
        if parent and parent:IsA("Attachment") then return parent.WorldPosition end
        if parent and parent:IsA("BasePart") then return parent.Position end
        return parent and parent:IsA("Model") and parent:GetPivot().Position or nil
    end
    function core.Scan()
        local out={};local folder=world:FindFirstChild("SpawnedEggs");local _,root=character()
        if not folder or not root then return out end
        local seen={}
        for _,prompt in ipairs(folder:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and (prompt.Name=="StealPrompt" or prompt.ActionText=="Steal") then
                local egg
                local ref=prompt:FindFirstChild("Egg")
                if ref and ref:IsA("ObjectValue") then egg=ref.Value end
                local parent=prompt.Parent
                while not egg and parent and parent~=folder do
                    if parent:IsA("Model") and modules.Egg and modules.Egg.Eggs[parent.Name] then egg=parent end
                    parent=parent.Parent
                end
                local pos=promptPosition(prompt)
                if egg and pos and not seen[egg] then
                    seen[egg]=true
                    out[#out+1]={model=egg,prompt=prompt,position=pos,name=egg.Name,
                        id=egg:GetAttribute("ReferenceName") or egg:GetAttribute("Id") or egg:GetFullName(),
                        rarity=rarity(egg.Name),variant=egg:GetAttribute("Variant") or "Normal",
                        mutation=egg:GetAttribute("Mutation"),distance=(root.Position-pos).Magnitude,
                        enabled=prompt.Enabled and clock()>=(blockedUntil[egg] or 0)}
                end
            end
        end
        R.available=#out
        return out
    end
    local function eventMutation()
        local event=controllers.EventController and controllers.EventController.Event
        return type(event)=="table" and event.Mutation or nil
    end
    local function stealReady(egg)
        local model,root,hum=character()
        local prompt=egg.prompt
        if stopped or not config.Farm then return false,"Cancelled"end
        if not model or not root or not hum or hum.Health<=0 then return false,"Character unavailable"end
        if hum.PlatformStand or model:GetAttribute("Ragdolled")then return false,"Knocked down"end
        if not egg.model.Parent or not prompt.Parent or not prompt.Enabled then return false,"Prompt unavailable"end
        if not P.Match(egg,config)then return false,"Target no longer selected"end
        local pos=promptPosition(prompt)
        if not pos then return false,"Prompt position unavailable"end
        local distance=(root.Position-pos).Magnitude
        if R.interaction then R.interaction.distance=distance;R.interaction.maxDistance=prompt.MaxActivationDistance end
        if distance>math.max(.1,prompt.MaxActivationDistance-.25)then return false,"Outside prompt range"end
        return true
    end
    local function approachPosition(egg)
        local model,root,hum=character()
        local pos=promptPosition(egg.prompt)
        if not pos then return nil end
        -- Stand beside the anchor instead of teleporting above its display attachment.
        local delta=Vector3.new(root.Position.X-pos.X,0,root.Position.Z-pos.Z)
        local offset=delta.Magnitude>.01 and delta/delta.Magnitude or Vector3.new(1,0,0)
        local point=pos+offset*2
        if world.Raycast and type(RaycastParams)=="table"then
            local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances={model,egg.model};params.RespectCanCollide=true
            local hit=world:Raycast(point+Vector3.new(0,4,0),Vector3.new(0,-16,0),params)
            if hit then
                local height=math.max(3,(hum.HipHeight or 2)+(root.Size and root.Size.Y/2 or 1))
                local standing=Vector3.new(point.X,hit.Position.Y+height+.1,point.Z)
                if (standing-pos).Magnitude<egg.prompt.MaxActivationDistance-.5 then point=standing end
            end
        end
        return point
    end
    local function beginSteal(egg)
        local prompt=egg.prompt
        R.interaction={target=egg.id,prompt=prompt.Name,holdDuration=prompt.HoldDuration,stage="Validating",startedAt=clock()}
        local ready,reason=stealReady(egg)
        if not ready then R.interaction.stage=reason;return false end
        R.phase="Steal";status("Holding Steal prompt")
        local triggered
        if prompt.Triggered then triggered=prompt.Triggered:Connect(function()R.interaction.triggeredAt=clock()end)end
        local function finish(ok,stage)
            pcall(prompt.InputHoldEnd,prompt)
            if triggered then triggered:Disconnect()end
            R.interaction.stage=stage;R.interaction.finishedAt=clock()
            return ok
        end
        local function carrying()return player:GetAttribute("CarryingEgg")~=nil end
        local hold=math.max(0,tonumber(prompt.HoldDuration)or .5)
        local ok,err=pcall(prompt.InputHoldBegin,prompt)
        R.interaction.method="InputHoldBegin";R.interaction.stage="Holding native prompt"
        if not ok then R.interaction.inputError=tostring(err)end
        local deadline=clock()+(ok and hold+.15 or 0)
        while clock()<deadline do
            if carrying()then return finish(true,"Pickup confirmed")end
            ready,reason=stealReady(egg)
            if not ready then
                -- The prompt may disappear just before the carrying attribute replicates.
                if reason=="Prompt unavailable"then break end
                return finish(false,reason)
            end
            task.wait(.03)
        end
        pcall(prompt.InputHoldEnd,prompt)
        local settleUntil=clock()+.35
        repeat
            if carrying()then return finish(true,"Pickup confirmed")end
            if stopped or not config.Farm then return finish(false,"Cancelled")end
            task.wait(.05)
        until clock()>=settleUntil
        ready,reason=stealReady(egg)
        local scope=type(getgenv)=="function"and getgenv()or _G
        local fire=D.FirePrompt or scope.fireproximityprompt or fireproximityprompt
        if ready and not R.interaction.refusal and type(fire)=="function"then
            R.interaction.method="InputHoldBegin + prompt fallback";R.interaction.stage="Retrying prompt activation"
            -- Optional parameters differ between executors (count vs duration).
            -- The native hold above already uses the real HoldDuration.
            local fired,problem=pcall(fire,prompt)
            if not fired then R.interaction.fallbackError=tostring(problem)end
            R.interaction.fallbackReturnedAt=clock()
            R.interaction.stage="Waiting for pickup confirmation"
        end
        local waitUntil=clock()+2.5
        repeat
            if carrying()then return finish(true,"Pickup confirmed")end
            if stopped or not config.Farm then return finish(false,"Cancelled")end
            local _,_,hum=character()
            if not hum or hum.Health<=0 then return finish(false,"Character unavailable")end
            task.wait(.05)
        until clock()>=waitUntil
        ready,reason=stealReady(egg)
        if ready and not R.interaction.refusal and prompt.KeyboardKeyCode then
            local input=D.VirtualInputManager
            if not input and game.GetService then
                local found,value=pcall(game.GetService,game,"VirtualInputManager")
                if found then input=value end
            end
            if input then
                R.interaction.method=R.interaction.method.." + keyboard"
                R.interaction.stage="Holding game input"
                local pressed,problem=pcall(input.SendKeyEvent,input,true,prompt.KeyboardKeyCode,false,game)
                if pressed then
                    local keyUntil=clock()+hold+.15
                    while clock()<keyUntil do
                        if carrying()then break end
                        ready,reason=stealReady(egg)
                        if not ready then break end
                        task.wait(.03)
                    end
                    pcall(input.SendKeyEvent,input,false,prompt.KeyboardKeyCode,false,game)
                    R.interaction.keyReleasedAt=clock()
                    local confirmUntil=clock()+2
                    repeat
                        if carrying()then return finish(true,"Pickup confirmed")end
                        if stopped or not config.Farm then return finish(false,"Cancelled")end
                        task.wait(.05)
                    until clock()>=confirmUntil
                else
                    pcall(input.SendKeyEvent,input,false,prompt.KeyboardKeyCode,false,game)
                    R.interaction.keyboardError=tostring(problem)
                end
            end
        end
        return finish(false,R.interaction.refusal and "Server refused pickup"or reason or "No pickup confirmation")
    end
    local function inventory() return data("Inventory",{}) end
    local function findPlacement()
        local b=base();local fences=b and b:FindFirstChild("Fences");local ground=world:FindFirstChild("Ground")
        if not fences or not ground or not ground:IsA("BasePart") then return nil end
        local cf,size=fences:GetBoundingBox();local placed=b:FindFirstChild("PlacedEggs")
        for x=-size.X/2+4,size.X/2-4,6 do
            for z=-size.Z/2+4,size.Z/2-4,6 do
                local point=cf:PointToWorldSpace(Vector3.new(x,0,z));local clear=true
                if placed then
                    for _,egg in ipairs(placed:GetChildren()) do
                        if egg:IsA("Model") then
                            local delta=egg:GetPivot().Position-point
                            if Vector3.new(delta.X,0,delta.Z).Magnitude<5.5 then clear=false;break end
                        end
                    end
                end
                if clear then return CFrame.new(point.X,ground.Position.Y+ground.Size.Y/2,point.Z) end
            end
        end
    end
    function core.FarmStep()
        local carried=player:GetAttribute("CarryingEgg")
        local model,root,hum=character()
        if not root or not hum or hum.Health<=0 then target=nil;movementBusy=false;R.phase="Respawn";return end
        if carried then
            movementBusy=true;R.phase="Return";R.carriedEggId=carried
            if not awaitClaim then awaitClaim={id=carried,before=table.clone(inventory()),at=clock()} end
            carriedBefore=carried
            local point=home()
            if not point then status("Waiting for your own base");return end
            local zone=controllers.ZoneController
            local falling=controllers.FallController
            local native=controllers.EggCarryController
            -- Holding eggs return by the game's jump/fall sequence. Teleporting
            -- here used to end the carry before the server could settle ClaimEgg.
            local reached=zone and zone.Zone=="Lobby" and root.Position.Y<200
            R.returnState={carryingEgg=player:GetAttribute("CarryingEgg"),zone=zone and zone.Zone,
                falling=falling and falling.IsFalling or false,homeDistance=(root.Position-point).Magnitude,
                arrived=reached,nativeClaiming=native and native.Claiming or false,
                nativeRejected=native and native.ClaimRejected or false}
            if not reached then
                status("Jumping back to Lobby")
                if falling and falling.IsFalling then
                    R.travel={mode="NativeFallReturn",stage="Waiting for game landing"}
                elseif(not awaitClaim.releasedAt or clock()-awaitClaim.releasedAt>3)and due("ReturnJump",2)then
                    -- Exit horizontally through the platform wall first, then
                    -- release above our own Lobby spawn so the game can land/claim.
                    local above=Vector3.new(point.X,root.Position.Y+2,point.Z)
                    if core.FlyTo(above,function()
                        return(config.Farm or config.AutoStore)and player:GetAttribute("CarryingEgg")==carried
                    end,carried,true)and player:GetAttribute("CarryingEgg")==carried then
                        awaitClaim.releasedAt=clock();R.returnState.releasedAt=clock()
                        R.returnState.lobby={x=point.X,y=point.Y,z=point.Z}
                    end
                end
                return
            end
            if player:GetAttribute("CarryingEgg")==carried
                and (not falling or not falling.IsFalling) and zone and zone.Zone=="Lobby" then
                if native and type(native.tryClaimEgg)=="function" then
                    -- ZoneChanged/FallingChanged already call this controller. Share its
                    -- Claiming lock instead of sending a second concurrent raw ClaimEgg.
                    local j=job("Store","Waiting for game inventory claim")
                    j.mode="NativeController";awaitClaim.native=true
                    j.pending=native.Claiming==true
                    if not native.Claiming and native.IsCarrying and due("Store",2) then
                        local ok,problem=pcall(native.tryClaimEgg,native)
                        j.requests+=1;j.pending=native.Claiming==true
                        if not ok then j.status=tostring(problem);errorLog(problem)end
                    end
                elseif due("Store",2) then
                    local j=job("Store","Claiming egg");j.mode="RemoteFallback"
                    local response=core.Call("EggSpawnService","ClaimEgg",{},"Store")
                    if accepted(response) then R.lastClaim=response;status("Egg claimed; waiting for inventory") end
                end
            end
            return
        end
        if carriedBefore then
            if awaitClaim and not awaitClaim.confirmationAt then awaitClaim.confirmationAt=clock() end
            local received=false
            for id,item in pairs(inventory()) do
                if awaitClaim and awaitClaim.before[id]==nil and type(item)=="table" and item.Handler=="Egg" then received=true;break end
            end
            if received then
                R.stored+=1;status("Egg stored in inventory")
                if awaitClaim and awaitClaim.native then
                    local j=job("Store","Inventory receipt confirmed");j.confirmed+=1;j.pending=false
                end
            elseif awaitClaim and clock()-awaitClaim.confirmationAt<6 then status("Waiting for inventory confirmation");return
            else R.lost+=1;status("Egg lost; searching again") end
            carriedBefore=nil;awaitClaim=nil;target=nil;R.carriedEggId=nil;R.phase="Idle"
        end
        movementBusy=false
        if not config.Farm then target=nil;R.phase="Idle";return end
        if config.AutoPlace then
            for _,item in pairs(inventory()) do
                if type(item)=="table" and item.Handler=="Egg" then status("Waiting to place inventory eggs");return end
            end
        end
        if modules.Day and modules.Day.IsNight(world:GetServerTimeNow()) then target=nil;R.phase="Night";status("Waiting for daytime");return end
        if hum.PlatformStand or model:GetAttribute("Ragdolled") then target=nil;status("Waiting to recover from knockdown");return end
        if target and (not target.model.Parent or not target.prompt.Parent or not target.prompt.Enabled or not P.Match(target,config)) then target=nil end
        if not target then target=P.Choose(core.Scan(),config,eventMutation()) end
        if not target then R.target=nil;status("Waiting for selected eggs");return end
        local locked=target
        R.target={id=locked.id,name=locked.name,rarity=locked.rarity,variant=locked.variant,mutation=locked.mutation}
        movementBusy=true;R.phase="Approach";status("Flying to "..locked.name)
        local training=controllers.TreadmillController
        if training and training.OnTreadmill then training.DisableActivation=true;training:DeactivateTreadmill();task.wait(.15) end
        local pos=approachPosition(locked)
        if not pos then target=nil;movementBusy=false;return end
        local before=table.clone(inventory())
        local function stillSelected()
            return config.Farm and locked.prompt.Parent~=nil and locked.prompt.Enabled and P.Match(locked,config)
                and (not modules.Day or not modules.Day.IsNight(world:GetServerTimeNow()))
        end
        -- Do not reset character position on every retry at the same egg.
        local reached=stillSelected() and (root.Position-pos).Magnitude<=3
        if not reached then reached=core.FlyTo(pos,stillSelected)end
        if reached and config.Farm and beginSteal(locked) then
            R.picked+=1;carriedBefore=player:GetAttribute("CarryingEgg")
            awaitClaim={id=carriedBefore,before=before,at=clock()}
            R.phase="Return";status("Pickup confirmed; returning")
        elseif not stopped then
            blockedUntil[locked.model]=clock()+4;target=nil;movementBusy=false;status("Pickup not confirmed; retrying")
        end
    end
    local function canSpend(price)
        local cash=tonumber(data("Cash",player:GetAttribute("Cash") or 0)) or 0
        return type(price)=="number" and price>=0 and cash-price>=config.ReserveCash
    end
    local function placeEgg()
        local placed=data("PlacedEggs",{})
        if awaitPlace then
            if placed[awaitPlace.id] then R.placed+=1;job("Place","Placement confirmed");awaitPlace=nil
            elseif clock()-awaitPlace.at>10 then job("Place","Placement not confirmed; retry later");awaitPlace=nil
            else return end
        end
        if not due("Place",2) then return end
        local eggId
        for id,item in pairs(inventory()) do if type(item)=="table" and item.Handler=="Egg" and not P.Protected(item,{},id) then eggId=id;break end end
        if not eggId then job("Place","Waiting for inventory eggs");return end
        local cf=findPlacement();if not cf then job("Place","No free placement position on your base");return end
        movementBusy=true
        local point=home();local _,root=character()
        local reached=root and point and ((root.Position-point).Magnitude<8 or core.Travel(point,function() return config.AutoPlace end))
        if reached and config.AutoPlace then
            local result=core.Call("EggPlacementService","RequestToPlace",{eggId,cf},"Place")
            if accepted(result) then awaitPlace={id=eggId,at=clock()} end
        end
        movementBusy=false
    end
    local function hatch()
        if awaitHatch then
            local placed=data("PlacedEggs",{})
            if not placed[awaitHatch.id] then R.hatched+=1;job("Hatch","Hatching confirmed");awaitHatch=nil
            elseif clock()-awaitHatch.at<20 then return
            else job("Hatch","Waiting for game hatching animation");awaitHatch=nil end
        end
        if not due("Hatch",2) then return end
        local native=controllers.EggHatchController
        for id,item in pairs(data("PlacedEggs",{})) do
            if type(item)=="table" and item.CanHatch and native and not native.Pending[id] then
                job("Hatch","Hatching ready egg").requests+=1
                native:Hatch(id);awaitHatch={id=id,at=clock()};return
            end
        end
        job("Hatch","Waiting for ready eggs")
    end
    local function training()
        local tm=controllers.TreadmillController
        if not tm then job("Train","Treadmill controller missing");return end
        if not config.AutoTrain then
            if core.TrainingStarted and tm.OnTreadmill then tm:DeactivateTreadmill() end
            core.TrainingStarted=false;return
        end
        if movementBusy or player:GetAttribute("CarryingEgg") then return end
        tm.DisableActivation=false
        if tm.OnTreadmill then job("Train","Training; waiting for bonuses");return end
        if not due("Train",3) then return end
        local b=base();local holder=b and b:FindFirstChild("Treadmill")
        local machine=holder and holder:FindFirstChildOfClass("Model")
        if not machine then job("Train","Waiting for your treadmill");return end
        movementBusy=true
        local point=machine:GetPivot().Position+Vector3.new(0,3,0)
        if core.Travel(point,function() return config.AutoTrain and not (config.Farm and P.Choose(core.Scan(),config,eventMutation())) end) then
            tm.DisableActivation=false;tm.OnTreadmill=true;tm:ActivateTreadmill(machine)
            core.TrainingStarted=true;job("Train","Treadmill activated").requests+=1
        end
        movementBusy=false
    end
    local function fuse()
        if not due("Fuse",2) then return end
        local cfg=modules.Fuse;local state=data("Fuse",nil)
        if not cfg or not state then job("Fuse","Waiting for fuse data");return end
        local phase=cfg.GetStatus(state,world:GetServerTimeNow())
        if phase=="Ready" then core.Call("FuseService","Collect",{},"Fuse");fuseRecipe=nil;return end
        if phase=="Running" then job("Fuse","Waiting for mutation to finish");return end
        local slots=state.Slots or {};local selected={};for _,id in pairs(slots) do selected[id]=true end
        -- Resume only our own partially acknowledged deposits; preserve manual recipes.
        if next(slots) then
            local count=0;for _ in pairs(slots) do count+=1 end
            if count<3 and fuseRecipe then
                for slot,id in pairs(slots) do
                    if fuseRecipe[tonumber(slot)]~=id then job("Fuse","Finish or clear the existing manual recipe");fuseRecipe=nil;return end
                end
                for i,id in ipairs(fuseRecipe) do
                    if not slots[tostring(i)] then
                        local item=inventory()[id]
                        if not item or not config.FuseTiers[rarity(item.Name)] or P.Protected(item,equipped(),id) then
                            job("Fuse","Recipe changed; check the machine");return
                        end
                        core.Call("FuseService","SetSlot",{i,id},"Fuse");return
                    end
                end
            end
            if count==3 and cfg.GetResult(state,inventory()) then
                for _,id in pairs(slots) do
                    local item=inventory()[id]
                    if not item or not config.FuseTiers[rarity(item.Name)] or P.Protected(item,equipped(),id) then
                        job("Fuse","Existing recipe contains protected or unselected animals");return
                    end
                end
                local price=cfg.GetPrice(state,inventory())
                if canSpend(price) then
                    local result=core.Call("FuseService","Start",{},"Fuse");if accepted(result) then fuseRecipe=nil end
                else job("Fuse","Not enough reserved cash") end
            else job("Fuse","Finish or clear the existing manual recipe") end
            return
        end
        local materials=P.FuseCandidates(inventory(),equipped(),config,rarity,score,selected)
        if not materials then job("Fuse","Waiting for 3 matching animals");return end
        if config.KeepBest then
            local bestId,bestScore
            for id,item in pairs(inventory()) do if type(item)=="table" and item.Handler=="Animal" then
                local value=score(item);if not bestScore or value>bestScore then bestId,bestScore=id,value end
            end end
            for _,entry in ipairs(materials) do if entry.id==bestId then job("Fuse","Keeping your best animal");return end end
        end
        local recipe={Slots={}}
        for i,entry in ipairs(materials) do recipe.Slots[tostring(i)]=entry.id end
        if not canSpend(cfg.GetPrice(recipe,inventory())) then job("Fuse","Not enough reserved cash");return end
        fuseRecipe={materials[1].id,materials[2].id,materials[3].id}
        R.mergePreview={}
        for i,entry in ipairs(materials) do
            if stopped or not config.AutoFuse then return end
            R.mergePreview[i]={id=entry.id,name=entry.item.Name,rarity=rarity(entry.item.Name)}
            local result=core.Call("FuseService","SetSlot",{i,entry.id},"Fuse")
            if not accepted(result) then return end
            task.wait(.25)
        end
        job("Fuse","Materials deposited; waiting for replicated recipe")
    end
    local function sell()
        if not due("Sell",2) then return end
        local candidates=P.SellCandidates(inventory(),equipped(),config,rarity,score)
        if not candidates[1] then job("Sell","No unprotected animals in selected levels");return end
        local state=data("Fuse",{});local reserved={};for _,id in pairs(state.Slots or {}) do reserved[id]=true end
        for _,entry in ipairs(candidates) do
            if not reserved[entry.id] then
                local j=job("Sell","Selling selected animal");j.id=entry.id;j.name=entry.item.Name;j.rarity=rarity(entry.item.Name)
                core.Call("AnimalSellService","Request",{"Sell",entry.id},"Sell");return
            end
        end
    end
    local function trails()
        if not due("Trails",5) or not modules.Trails then return end
        local result=core.Call("TrailsService","GetTrails",{},"Trails")
        if type(result)~="table" then return end
        local owned=P.Set(result.Owned);local best,bestPrice=nil,-1
        for name,item in pairs(modules.Trails.Trails or {}) do
            if type(item)=="table" and type(item.Price)=="number" and item.Price>bestPrice and (owned[name] or canSpend(item.Price)) then best,bestPrice=name,item.Price end
        end
        if best and best~=result.Equipped then core.Call("TrailsService","SelectTrail",{best},"Trails") end
    end
    function core.JobsStep()
        if stopped or rpcBusy then return end
        if awaitPlace and data("PlacedEggs",{})[awaitPlace.id] then
            R.placed+=1;job("Place","Placement confirmed");awaitPlace=nil
        end
        if config.AutoHatch then hatch() end
        if config.AutoEquip and due("Equip",5) then core.Call("AnimalLoadoutService","Request",{"EquipBest"},"Equip") end
        if config.AutoPlace and not movementBusy and not player:GetAttribute("CarryingEgg") then placeEgg() end
        if config.AutoDaily and due("Daily",30) then core.Call("DailyRewardsService","Claim",{},"Daily") end
        if config.AutoIndex and due("Index",15) then core.Call("IndexService","ClaimAll",{},"Index") end
        if config.AutoOffline and due("Offline",30) and (tonumber(data("PendingOfflineCash",0)) or 0)>0 then core.Call("CashFlowService","ClaimOfflineCash",{},"Offline") end
        if config.AutoGroup and due("Group",60) then core.Call("GroupRewardService","ClaimReward",{},"Group") end
        if config.AutoGifts and due("Gifts",5) then
            local native=controllers.GiftPlayTimeController
            if native then for i=1,12 do if native:IsReady(i) then core.Call("GiftPlayTimeService","Claim",{i},"Gifts");break end end end
        end
        if config.AutoRebirth and due("Rebirth",5) and not movementBusy and not player:GetAttribute("CarryingEgg") and modules.Rebirth then
            local req=modules.Rebirth.GetRequirements(data("Rebirths",0));local ready=true
            for stat,value in pairs(req) do if (tonumber(data(stat,0)) or 0)<value then ready=false end end
            if ready then core.Call("RebirthService","Request",{false},"Rebirth") else job("Rebirth","Waiting for required speed") end
        end
        for _,spec in ipairs({{"AutoBase","BaseUpgradeService","BaseLevel",modules.Base and modules.Base.Levels},
            {"AutoTreadmill","TreadmillService","TreadmillLevel",modules.Treadmill and modules.Treadmill.LevelConfig},
            {"AutoStamina","StaminaUpgradeService","StaminaLevel",modules.Stamina and modules.Stamina.Levels}}) do
            if config[spec[1]] and due(spec[1],3) and spec[4] then
                local level=tonumber(data(spec[3],spec[3]=="StaminaLevel" and 1 or 0)) or 0
                local entry=spec[4][level+1]
                if entry and canSpend(entry.UpgradeCost or entry.Price) then
                    core.Call(spec[2],spec[1]=="AutoStamina" and "Purchase" or "RequestToUpgrade",spec[1]=="AutoStamina" and {level} or {},spec[1])
                else job(spec[1],entry and "Not enough reserved cash" or "Maximum upgrade reached") end
            end
        end
        if config.AutoTrails then trails() end
        if config.AutoFuse then fuse() end
        if config.AutoSell then sell() end
        training()
        if notify then notify(R) end
    end
    function core.ESPUpdate()
        local active={}
        if config.EggESP then
            for _,egg in ipairs(core.Scan()) do
                if P.Match(egg,config) then
                    active[egg.model]=true
                    if not esp[egg.model] then
                        local highlight=Instance.new("Highlight");highlight.Name="DevilEggESP";highlight.Adornee=egg.model
                        highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;highlight.FillTransparency=.7;highlight.OutlineColor=Color3.fromRGB(255,80,95);highlight.Parent=egg.model
                        local gui=Instance.new("BillboardGui");gui.Name="DevilEggLabel";gui.Adornee=egg.model.PrimaryPart or egg.model:FindFirstChildWhichIsA("BasePart",true)
                        gui.Size=UDim2.fromOffset(210,50);gui.AlwaysOnTop=true;gui.StudsOffset=Vector3.new(0,5,0);gui.Parent=egg.model
                        local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Font=Enum.Font.GothamSemibold;text.TextSize=12;text.TextColor3=Color3.new(1,1,1);text.TextStrokeTransparency=.3;text.Parent=gui
                        esp[egg.model]={highlight,gui,text}
                    end
                    esp[egg.model][3].Text=egg.name.." • "..egg.rarity.."\n"..egg.variant.." / "..(egg.mutation or "None").." • "..math.floor(egg.distance).." studs"
                end
            end
        end
        for model,nodes in pairs(esp) do if not active[model] or not model.Parent then for _,node in ipairs(nodes) do node:Destroy() end;esp[model]=nil end end
    end
    function core.Set(key,value)
        config[key]=value
        if key=="Farm" and not value then target=nil end
    end
    function core.Stop()
        if stopFlight then stopFlight()end
        for key,value in pairs(config) do if type(value)=="boolean" and (key=="Farm" or key:match("^Auto")) then config[key]=false end end
        target=nil;carriedBefore=nil;awaitClaim=nil;R.phase="Idle";movementBusy=false
        local tm=controllers.TreadmillController
        if tm then tm.DisableActivation=core.OriginalDisableActivation;if core.TrainingStarted and tm.OnTreadmill then tm:DeactivateTreadmill() end end
        core.TrainingStarted=false;status("Stopped")
    end
    function core.SaveReport()
        local native=controllers.EggCarryController
        R.player={carryingEgg=player:GetAttribute("CarryingEgg"),userId=player.UserId,
            nativeCarrying=native and native.IsCarrying or false,nativeClaiming=native and native.Claiming or false}
        R.data={inventory=inventory(),placedEggs=data("PlacedEggs",{}),fuse=data("Fuse",{}),baseLevel=data("BaseLevel",0),staminaLevel=data("StaminaLevel",1)}
        local text=Http:JSONEncode(R)
        if type(writefile)=="function" then writefile("DevilClimbEggReport.json",text) end
        if type(setclipboard)=="function" then setclipboard(text) end
        return text
    end
    function core.Destroy()
        if stopped then return end
        core.Stop();stopped=true
        for _,link in ipairs(links) do link:Disconnect() end
        for _,nodes in pairs(esp) do for _,node in ipairs(nodes) do node:Destroy() end end
        table.clear(esp);status("Unloaded")
    end
    local tm=controllers.TreadmillController
    local refused=remote("EggSpawnService","StealRefused","RE")
    if refused and refused.OnClientEvent then
        table.insert(links,refused.OnClientEvent:Connect(function(message)
            local text=type(message)=="table"and(message.Reason or message.Message)or message
            R.lastStealRefusal={message=tostring(text),t=clock(),target=R.target and R.target.id}
            if R.interaction then R.interaction.refusal=tostring(text)end
        end))
    end
    core.OriginalDisableActivation=tm and tm.DisableActivation
    if tm and tm.Signals and tm.Signals.ShowMultiplierButton then
        local consumed={}
        table.insert(links,tm.Signals.ShowMultiplierButton:Connect(function(id)
            if not stopped and config.AutoBonus and tm.OnTreadmill and not consumed[id] then
                consumed[id]=true
                local ok,problem=pcall(tm.ClaimMultiplier,tm,id)
                local j=job("Bonus",ok and "Bonus clicked" or tostring(problem));j.requests+=1
                if not ok then errorLog(problem) end
            end
        end))
    end
    if not D.Manual then
        task.spawn(function()
            while not stopped do
                if (not movementBusy or R.phase=="Return" or carriedBefore) and (config.Farm or config.AutoStore or carriedBefore) then
                    local ok,problem=xpcall(core.FarmStep,debug.traceback)
                    if not ok then errorLog(problem);status("Farm error; see report");movementBusy=false;target=nil end
                end
                task.wait(.15)
            end
        end)
        task.spawn(function()
            while not stopped do
                local ok,problem=xpcall(core.JobsStep,debug.traceback);if not ok then errorLog(problem);job("Worker",tostring(problem));movementBusy=false end
                local espOk,espError=pcall(core.ESPUpdate);if not espOk then errorLog(espError) end
                task.wait(1)
            end
        end)
    end
    return core
end
