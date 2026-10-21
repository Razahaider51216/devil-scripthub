return function(scope,K)
    local A={Alive=true,Cache={},Links={},LastPoll={},LastError={},Targets={},LastScan=0,Serials=setmetatable({},{__mode="k"}),Serial=0}
    A.Player=game:GetService("Players").LocalPlayer
    A.RS=game:GetService("ReplicatedStorage");A.Http=game:GetService("HttpService")
    A.Input=game:GetService("UserInputService");A.Now=os.clock
    A.Pending=scope.DevilHtFPending or{};scope.DevilHtFPending=A.Pending
    local shared={RequestPickupShell=true,RequestTrainHit=true,RequestEquipPet=true,RequestCraftEgg=true,
        RequestHatchEgg=true,RequestSell=true,RequestSellPet=true,RequestBuyUpgrade=true,RequestRebirth=true,
        RequestReturnHome=true,GetData=true}
    local functions={Data="GetData",Meta="Meta",Tower="Tower",Race="Race"}
    function A.Remote(name)
        local folder
        if shared[name]then folder=A.RS:FindFirstChild("Remotes")else
            local h=A.RS:FindFirstChild("HatchToFight");folder=h and h:FindFirstChild("Remotes")
        end
        return folder and folder:FindFirstChild(name)
    end
    function A.Attr(name,default)local v=A.Player:GetAttribute(name);if v==nil then return default end;return v end
    function A.Character()
        local char=A.Player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if char and hum and hum.Health>0 and root then return char,hum,root end
    end
    function A.Blocked()
        if not A.Character()then return "Waiting for a living character"end
        if A.Input:GetFocusedTextBox()then return "Paused while typing"end
        if game:GetService("GuiService").MenuIsOpen then return "Paused in the Roblox menu"end
        if A.Attr("DataLoaded",true)==false then return "Waiting for player data"end
    end
    function A.Fire(name,...)
        if not A.Alive then return false,"Unloaded"end
        local remote=A.Remote(name)
        if not remote or not remote:IsA("RemoteEvent")then return false,"Missing RemoteEvent: "..name end
        return pcall(remote.FireServer,remote,...)
    end
    function A.Call(lane,args,callback,job)
        if not A.Alive then return false,"Unloaded"end
        local remote=A.Remote(functions[lane]or lane)
        if not remote or not remote:IsA("RemoteFunction")then return false,"Missing RemoteFunction: "..lane end
        if A.Pending[lane]then
            local elapsed=A.Now()-A.Pending[lane].At
            return false,elapsed>8 and("Server call still pending: "..lane)or("Waiting for "..lane)
        end
        local token={At=A.Now(),Job=job};A.Pending[lane]=token
        task.spawn(function()
            if not A.Alive or token.Cancelled then if A.Pending[lane]==token then A.Pending[lane]=nil end;return end
            token.Started=true
            local packed=table.pack(pcall(remote.InvokeServer,remote,table.unpack(args,1,args.n or #args)))
            if A.Pending[lane]==token then A.Pending[lane]=nil end
            if not A.Alive then return end
            local ok,value=packed[1],packed[2]
            if ok and type(value)=="table"and (args[1]=="State"or lane=="Data")then
                A.Cache[lane]=value;A.LastPoll[lane..":received"]=A.Now()
            end
            if not ok then A.LastError[lane]=tostring(value)else A.LastError[lane]=nil end
            if callback and not token.Cancelled then pcall(callback,ok,value)end
        end)
        return true
    end
    function A.CancelJob(job)
        for _,token in pairs(A.Pending)do if token.Job==job then token.Cancelled=true end end
    end
    function A.CancelQueued()for _,token in pairs(A.Pending)do token.Cancelled=true end end
    function A.Refresh(force,cfg)
        if not A.Alive then return end
        local polls={Data=3,Meta=4}
        if force or cfg and(cfg.Tower or cfg.Rewards)then polls.Tower=4 end
        if force or cfg and(cfg.RaceRoll or cfg.RaceEquip)then polls.Race=5 end
        for lane,interval in pairs(polls)do
            if force or A.Now()-(A.LastPoll[lane]or-math.huge)>=interval then
                A.LastPoll[lane]=A.Now()
                A.Call(lane,lane=="Data"and table.pack()or table.pack("State"))
            end
        end
    end
    local function rootOf(object)
        if not object then return end
        if object:IsA("BasePart")then return object end
        return object.PrimaryPart or object:FindFirstChild("HumanoidRootPart")or object:FindFirstChildWhichIsA("BasePart",true)
    end
    local function position(object)local part=rootOf(object);return part and part.Position end
    function A.Distance(point)
        local _,_,root=A.Character();return root and point and(root.Position-point).Magnitude or math.huge
    end
    local function stageFloor(index)
        local map=workspace:FindFirstChild("Map");local stages=map and map:FindFirstChild("Stages")
        local stage=stages and stages:FindFirstChild("Stage"..tostring(index))
        local floor=stage and stage:FindFirstChild("Floor")
        return floor and floor:IsA("BasePart")and floor or nil,stage
    end
    function A.Move(point,look,ground)
        if not A.Alive then return false,"Unloaded"end
        if typeof(point)~="Vector3"then return false,"Destination unavailable / not streamed"end
        local char,hum,root=A.Character();if not root then return false,"Waiting for character"end
        if not ground then
            local floor=stageFloor(A.Attr("FightStage",0))
            if floor then
                local localPoint=floor.CFrame:PointToObjectSpace(point)
                if math.abs(localPoint.X)<=floor.Size.X/2 and math.abs(localPoint.Z)<=floor.Size.Z/2 then ground=floor end
            end
        end
        local ray=RaycastParams.new();ray.RespectCanCollide=true;ray.FilterType=Enum.RaycastFilterType.Exclude
        local ignore={char}
        for _,name in ipairs({"HtF_Runtime","ClientGates","StageGateLabels"})do local obj=workspace:FindFirstChild(name);if obj then table.insert(ignore,obj)end end
        ray.FilterDescendantsInstances=ignore
        if ground and ground:IsA("BasePart")then
            local localPoint=ground.CFrame:PointToObjectSpace(point)
            localPoint=Vector3.new(math.clamp(localPoint.X,-ground.Size.X/2+2,ground.Size.X/2-2),ground.Size.Y/2,math.clamp(localPoint.Z,-ground.Size.Z/2+2,ground.Size.Z/2-2))
            point=ground.CFrame:PointToWorldSpace(localPoint)+Vector3.new(0,hum.HipHeight+root.Size.Y/2+.15,0)
        else
            local hit=workspace:Raycast(point+Vector3.new(0,4,0),Vector3.new(0,-24,0),ray)
            if hit then point=Vector3.new(point.X,hit.Position.Y+hum.HipHeight+root.Size.Y/2+.15,point.Z)end
        end
        local destination=CFrame.new(point)*root.CFrame.Rotation
        if typeof(look)=="Vector3"then
            local flat=Vector3.new(look.X,point.Y,look.Z)
            if(flat-point).Magnitude>.1 then destination=CFrame.lookAt(point,flat)end
        end
        local offset=root.CFrame:ToObjectSpace(char:GetPivot())
        return pcall(char.PivotTo,char,destination*offset)
    end
    function A.Face(target)
        local char,_,root=A.Character()
        if not root or typeof(target)~="Vector3"then return false end
        local look=Vector3.new(target.X,root.Position.Y,target.Z)
        if(look-root.Position).Magnitude<.1 then return true end
        local offset=root.CFrame:ToObjectSpace(char:GetPivot())
        return pcall(char.PivotTo,char,CFrame.lookAt(root.Position,look)*offset)
    end
    function A.HubPoint(name)
        local map=workspace:FindFirstChild("Map");local hub=map and map:FindFirstChild("Hub")
        local object=hub and hub:FindFirstChild(name)
        if not object then return nil end
        local prompt=object:FindFirstChildWhichIsA("ProximityPrompt",true)
        local promptPart=prompt and prompt.Parent
        if promptPart and promptPart:IsA("Attachment")then promptPart=promptPart.Parent end
        local anchor=object:FindFirstChild("Interact",true)or object:FindFirstChild("Trigger",true)or object:FindFirstChild("PromptPart",true)or promptPart or rootOf(object)
        local p=position(anchor);return p and p+Vector3.new(0,3,5)
    end
    function A.NearHub(name,range)return A.Distance(A.HubPoint(name))<=range end
    function A.StagePoint(index,attempt)
        local floor,model=stageFloor(index)
        if floor then
            local p=floor.CFrame:PointToWorldSpace(Vector3.new(0,floor.Size.Y/2+3,0))
            local spawns=model:FindFirstChild("EnemySpawns")
            local first=spawns and spawns:FindFirstChild("EnemySpawn1")
            local look=first and position(first)or p+Vector3.new(0,0,-10)
            if attempt and attempt>0 then
                local direction=Vector3.new(look.X-p.X,0,look.Z-p.Z)
                if direction.Magnitude>.1 then p+=direction.Unit*(attempt==1 and 12 or-12)end
            end
            return p,look,floor
        end
        local gate=model and model:FindFirstChild("EntranceGate")
        local frame=gate and gate:GetAttribute("GateCFrame")
        local labels=workspace:FindFirstChild("StageGateLabels")
        local marker=labels and labels:FindFirstChild("Stage"..index)
        local streamAt=typeof(frame)=="CFrame"and frame.Position or marker and marker:IsA("BasePart")and marker.Position
        if streamAt and not A.Pending.StageStream and A.Now()-(A.LastPoll.StageStream or-math.huge)>5 then
            local token={At=A.Now(),Job="Farm"};A.Pending.StageStream=token;A.LastPoll.StageStream=A.Now()
            task.spawn(function()
                if A.Alive and not token.Cancelled then
                    token.Started=true
                    local ok,err=pcall(A.Player.RequestStreamAroundAsync,A.Player,streamAt,2)
                    if not ok and A.Alive then A.LastError.StageStream=tostring(err)end
                end
                if A.Pending.StageStream==token then A.Pending.StageStream=nil end
            end)
        end
        return nil
    end
    local function own(object)
        local owner=object:GetAttribute("OwnerId")
        return owner==nil or owner==A.Player.UserId
    end
    function A.Mob()
        local runtime=workspace:FindFirstChild("HtF_Runtime");local folder=runtime and runtime:FindFirstChild("Mobs")
        local best
        for _,obj in ipairs(folder and folder:GetChildren()or{})do
            local p=position(obj);local hp=obj:GetAttribute("HP")
            local ownerStage=obj:GetAttribute("StageIndex")or obj:GetAttribute("Stage")
            local currentStage=A.Attr("FightStage",0)
            local sameStage=type(ownerStage)~="number"or currentStage<=0 or ownerStage==currentStage
            if p and type(hp)=="number"and hp>0 and own(obj)and sameStage then
                local distance=A.Distance(p)
                if not best or distance<best.Distance then best={Ref=obj,Pos=p,HP=hp,Distance=distance,Name=obj.Name}end
            end
        end
        return best
    end
    function A.Approach(target,distance)
        local _,_,root=A.Character();if not root then return nil end
        local direction=Vector3.new(root.Position.X-target.Pos.X,0,root.Position.Z-target.Pos.Z)
        if direction.Magnitude<.1 then direction=Vector3.new(0,0,1)else direction=direction.Unit end
        return target.Pos+direction*distance
    end
    function A.Snapshot()
        local char=A.Player.Character;local gui=A.Player:FindFirstChildOfClass("PlayerGui")
        local stage=A.Attr("FightStage",0)
        return {Mounted=char and char:GetAttribute("Mounted")==true,PetId=A.Attr("PetId",K.Pets.Starter),
            InFight=stage>0 or A.Attr("TowerFight",false)or A.Attr("OnBossIsland",false),
            FightStage=stage,StagesCleared=A.Attr("StagesCleared",0),Rebirths=A.Attr("Rebirths",0),TowerFight=A.Attr("TowerFight",false),OnBossIsland=A.Attr("OnBossIsland",false),
            WaveTotal=A.Attr("WaveTotal",0),WaveKills=A.Attr("WaveKills",0),
            BossAlive=workspace:GetAttribute("WorldBossAlive")==true,HP=gui and gui:GetAttribute("PetHP"),
            MaxHP=gui and gui:GetAttribute("PetMaxHP"),SpecialCooldownMult=A.Attr("QCooldownMult",1),Mob=A.Mob()}
    end
    function A.Drop(filter)
        local runtime=workspace:FindFirstChild("HtF_Runtime");local folder=runtime and runtime:FindFirstChild("Drops")
        local best
        for _,obj in ipairs(folder and folder:GetChildren()or{})do
            local eggId=obj:GetAttribute("EggId");local spec=eggId and K.Eggs.List[eggId]
            local rarity=obj:GetAttribute("Rarity")or(spec and spec.Rarity)
            local p=position(obj)
            if p and eggId and own(obj)and(next(filter)==nil or filter[rarity])then
                local distance=A.Distance(p)
                if not A.Serials[obj]then A.Serial+=1;A.Serials[obj]=A.Serial end
                if not best or distance<best.Distance then best={Ref=obj,Pos=p,Distance=distance,Key=tostring(A.Serials[obj]),Name=spec and spec.Name or eggId}end
            end
        end
        return best
    end
    function A.Dummy(selected,definitions,s)
        local map=workspace:FindFirstChild("Map");local hub=map and map:FindFirstChild("Hub")
        local area=hub and hub:FindFirstChild("Train")
        if not area then return end
        if A.Now()-A.LastScan>2 then
            A.LastScan=A.Now();A.Targets={}
            for _,obj in ipairs(area:GetDescendants())do if obj:IsA("Model")and obj:GetAttribute("DummyId")then A.Targets[obj:GetAttribute("DummyId")]=obj end end
        end
        local best
        for _,def in ipairs(definitions)do
            local obj=A.Targets[def.id];local p=obj and obj.Parent and position(obj)
            local eligible=(not def.gamePassId or A.Attr("VipDummy",false)or A.Attr("OwnsDummy_"..def.id,false))
                and(not def.abuseOnly or(workspace:GetAttribute("AbuseUntil_Dummy")or 0)>workspace:GetServerTimeNow())
                and(s.Rebirths or 0)>=(def.rebirths or 0)
            if p and eligible and(selected=="Best available"or selected==def.id)then
                if not best or(def.multiplier or 1)>best.Multiplier then
                    best={Pos=p+Vector3.new(0,0,7),Look=p,Name=def.displayName or def.id,Multiplier=def.multiplier or 1,Distance=A.Distance(p)}
                end
            end
        end
        return best
    end
    local function keep(signal,fn)
        if not signal then return end
        local link=signal:Connect(function(...)if A.Alive then fn(...)end end);table.insert(A.Links,link)
    end
    function A.Bind(core)
        local function bind(name,fn)local remote=A.Remote(name);if remote and remote:IsA("RemoteEvent")then keep(remote.OnClientEvent,fn)end end
        bind("MetaState",function(value)if type(value)=="table"then A.Cache.Meta=value end end)
        local folder=A.RS:FindFirstChild("Remotes")
        for _,name in ipairs({"DataChanged","HatchResult","EggForged","FightEnded","TrainHit","PowerGain","RebirthDone","RewardGranted","Notify"})do
            local remote=folder and folder:FindFirstChild(name)
            if remote and remote:IsA("RemoteEvent")then keep(remote.OnClientEvent,function(...)
                local value=...
                if name=="DataChanged"and type(value)=="table"then A.Cache.Data=value end
                core.Observe(name,...)
            end)end
        end
        bind("TowerEvent",function(event,value)
            if event=="state"and type(value)=="table"then A.Cache.Tower=value end
            core.Observe("Tower:"..tostring(event),value)
        end)
        bind("RaceState",function(value)if type(value)=="table"then A.Cache.Race=value end end)
    end
    function A.Destroy()
        if not A.Alive then return end;A.Alive=false;A.CancelQueued()
        for _,link in ipairs(A.Links)do link:Disconnect()end;table.clear(A.Links)
    end
    return A
end
