return function(scope)
    local rs=game:GetService("ReplicatedStorage")
    local player=game:GetService("Players").LocalPlayer
    local ctx={Catalog={},Ready=false,Warnings={},Links={},Spawn=task.spawn,Wait=task.wait,WallTime=os.time}
    local flights=scope.DevilAnimeDiceFlights or{};scope.DevilAnimeDiceFlights=flights
    local requireModule=require
    local paths={
        Data="Data.DataController",Registry="Inventory.EntryRegistry",Buffs="Buffs.BuffController",BuffConfig="Buffs.BuffsConfig",Monetization="Monetization.MonetizationConfig",UnitController="Inventory.Kinds.Unit.UnitController",Rarities="Rarities",
        Dice="Rolling.Dice",PlotConfig="Plot.PlotConfig",UnitUtil="Inventory.Kinds.Unit.UnitUtil",
        Upgrades="Upgrades.Upgrades",TreeStructure="Upgrades.TreeStructure",Towers="Towers.Towers",TowerRefs="Towers.TowerRefs",
        Rebirths="Rebirth.Rebirths",RebirthStats="Rebirth.RebirthStatsConfig",Traits="Traits.Traits",Grades="Grades.Grades",
        Quirks="Quirks.Quirks",QuirkUtil="Quirks.QuirkUtil",FusingUtil="Fusing.FusingUtil",FusingConfig="Fusing.FusingConfig",
        Daily="DailyRewards.DailyRewardConfig",Group="GroupReward.GroupRewardConfig",Quest="Quests.QuestConfig",Halloween="Halloween.HalloweenConfig",
        HauntedHouse="Halloween.HauntedHouse",HalloweenShop="Halloween.HalloweenShop",PumpkinPass="Halloween.PumpkinPass",
        HalloweenQuests="Halloween.HalloweenQuests",PumpkinDice="Halloween.PumpkinDice",Gear="Inventory.Kinds.Gear.GearConfig"}
    local function path(root,text)
        for part in text:gmatch("[^.]+")do root=root and root:FindFirstChild(part);if not root then return end end
        return root
    end
    function ctx.Initialize(valid)
        local deadline=os.clock()+20
        while valid()and os.clock()<deadline do
            if path(rs,"Framework.Features.Data.DataController")and rs:FindFirstChild("Network")then break end
            task.wait(.2)
        end
        assert(valid(),"Startup cancelled")
        for key,name in pairs(paths)do
            if not valid()then return end
            local module=path(rs,(key=="Rarities"and"Framework.Other."or"Framework.Features.")..name)
            -- Locate alternate feature folder names from the actual live tree.
            if not module then
                local leaf=name:match("([^.]+)$")
                local features=path(rs,"Framework.Features")
                if features then for _,candidate in ipairs(features:GetDescendants())do
                    if candidate:IsA("ModuleScript")and candidate.Name==leaf then module=candidate;break end
                end end
            end
            local ok,result=false,nil
            if module then ok,result=pcall(requireModule,module)end
            if ok then ctx.Catalog[key]=result else ctx.Warnings[key]=module and tostring(result)or"Module unavailable"end
        end
        assert(ctx.Catalog.Data and ctx.Catalog.Registry,"Game data/registry unavailable; see initialization report")
        ctx.Ready=true
    end
    local fields={"Inventory","Money","Slots","TowerTeam","Dice","OwnedDice","Upgrades","Rebirth","RebirthStats","AutoRoll","AutoTower",
        "PendingTrade","ProtectedTraits","ProtectedGrades","ProtectedQuirks","ActiveEntries","EquippedGear","Rolls","Halloween",
        "Quests","LastDailyRewardClaim","ClaimedGroupReward","PendingOfflineEarnings","RedeemedCodes","AutoSell","OwnedGamepasses"}
    local function copy(value,depth)
        if type(value)~="table"or depth==0 then return value end
        local out={};for key,item in pairs(value)do out[key]=copy(item,depth-1)end;return out
    end
    function ctx.Snapshot()
        if not ctx.Ready then return end
        local data={}
        for _,key in ipairs(fields)do
            local value=ctx.Catalog.Data[key]
            local ok,result=pcall(function()return value()end)
            if ok then data[key]=copy(result,5)elseif type(value)~="function"then data[key]=copy(value,5)end
        end
        if type(data.Inventory)~="table"or type(data.Money)~="number"then return end
        data.Storage=ctx.Buff("Unit Storage")
        local ok,equipped=pcall(function()return ctx.Catalog.UnitController.EquippedUnit()end)
        data.EquippedUnitKnown=ok;data.EquippedUnit=ok and equipped or nil
        return data
    end
    function ctx.Buff(name)
        local module=ctx.Catalog.Buffs
        if not module or not module.GetBuff then return 0 end
        return module.GetBuff(name)
    end
    local function remote(ns,kind,name)
        local root=rs:FindFirstChild("Network")
        local folder=root and(ns==""and root or root:FindFirstChild(ns))
        local group=folder and folder:FindFirstChild(kind)
        local obj=group and group:FindFirstChild(name)
        assert(obj and obj:IsA(kind=="RF"and"RemoteFunction"or"RemoteEvent"),"Missing remote: "..ns.."/"..kind.."/"..name)
        return obj
    end
    function ctx.Fire(ns,name,...)remote(ns,"RE",name):FireServer(...)end
    function ctx.Invoke(ns,name,...)
        local key=ns.."/"..name
        assert(not flights[key],"Previous request still pending: "..key)
        flights[key]=true
        local result=table.pack(pcall(function(...)return remote(ns,"RF",name):InvokeServer(...)end,...))
        flights[key]=nil
        assert(result[1],result[2])
        return table.unpack(result,2,result.n)
    end
    function ctx.Listen(ns,name,fn)
        local ok,obj=pcall(remote,ns,"RE",name)
        if not ok then return end
        local link=obj.OnClientEvent:Connect(fn);ctx.Links[#ctx.Links+1]=link;return link
    end
    function ctx.Now()return workspace:GetServerTimeNow()end
    local fallbackDoorReady
    function ctx.DoorInitialReady()
        local ready=player:GetAttribute("TrickOrTreatReadyAt")
        if type(ready)=="number"then return ready end
        if not fallbackDoorReady then fallbackDoorReady=ctx.Now()+30 end
        return fallbackDoorReady
    end
    local streamRequest
    local function streamAround(position,timeout,valid)
        -- A pending terrain request must not hold the farming worker forever.
        -- Keep one outstanding request; use already loaded ground if it stalls.
        if streamRequest or valid and not valid()then return end
        local request={Done=false};streamRequest=request
        ctx.Spawn(function()
            pcall(player.RequestStreamAroundAsync,player,position,timeout)
            request.Done=true
            if streamRequest==request then streamRequest=nil end
        end)
        local deadline=os.clock()+timeout
        while not request.Done and os.clock()<deadline and(not valid or valid())do ctx.Wait(.1)end
    end
    function ctx.StreamEvent()
        local island=workspace:FindFirstChild("Halloween")
        local arrival=island and island:FindFirstChild("ArrivalPoint",true)
        if arrival and arrival:IsA("BasePart")then
            streamAround(arrival.Position,3)
        end
    end
    function ctx.InGroup()
        local group=ctx.Catalog.Group
        if not group then return false end
        local ok,value=pcall(player.IsInGroupAsync,player,group.GroupId)
        return ok and value==true
    end
    function ctx.Doors()
        local result={}
        for _,part in ipairs(game:GetService("CollectionService"):GetTagged("TrickOrTreatDoor"))do
            if part:IsA("BasePart")and part:IsDescendantOf(workspace)then
                local home,front=part:GetAttribute("TrickOrTreatHome"),part:GetAttribute("TrickOrTreatFront")
                local model=part:FindFirstAncestorWhichIsA("Model")
                if typeof(home)=="CFrame"and typeof(front)=="Vector3"then
                    result[#result+1]={key=part,position=home.Position,groundY=home.Position.Y-part.Size.Y/2,front=front,range=math.max(2,tonumber(model and model:GetAttribute("Range"))or 14)}
                end
            end
        end
        return result
    end
    function ctx.Position()
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        return root and root.Position
    end
    function ctx.CancelMovement()
        local char=player.Character;local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if hum then if root then hum:MoveTo(root.Position)end;hum:Move(Vector3.zero)end
    end
    function ctx.MoveDoor(goal,valid,door)
        if not valid()then return false,"Cancelled"end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health<=0 then return false,"Character unavailable"end
        streamAround(goal,2,valid)
        if not valid()or player.Character~=char or not root.Parent or hum.Health<=0 then return false,"Cancelled"end
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances={char};params.RespectCanCollide=true
        -- Start just above the door sill, below porch/house roofs. A ray from
        -- above the building hits its roof and puts the character upstairs.
        local originY=math.min(door.groundY+2,door.position.Y+.5)
        local floor=workspace:Raycast(Vector3.new(goal.X,originY,goal.Z),Vector3.new(0,-40,0),params)
        if not floor then return false,"Door ground not loaded; retrying"end
        if floor.Normal.Y<.55 then return false,"No level ground at door; retrying"end
        local position=Vector3.new(goal.X,floor.Position.Y+hum.HipHeight+root.Size.Y/2,goal.Z)
        if math.abs(position.Y-door.position.Y)>=19 then return false,"Ground outside door height; retrying"end
        char:PivotTo(CFrame.new(position)*root.CFrame.Rotation)
        root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
        ctx.Wait(.35)
        if not valid()or player.Character~=char or not root.Parent or hum.Health<=0 then return false,"Cancelled"end
        if(root.Position-position).Magnitude>8 or math.abs(root.Position.Y-door.position.Y)>=20 then return false,"Door teleport corrected; retrying"end
        return true,"Arrived"
    end
    function ctx.Destroy()
        ctx.CancelMovement()
        for _,link in ipairs(ctx.Links)do link:Disconnect()end
        table.clear(ctx.Links)
    end
    return ctx
end
