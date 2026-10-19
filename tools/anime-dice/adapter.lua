return function(scope)
    local rs=game:GetService("ReplicatedStorage")
    local player=game:GetService("Players").LocalPlayer
    local ctx={Catalog={},Ready=false,Warnings={},Links={},Spawn=task.spawn,Wait=task.wait,WallTime=os.time}
    local flights=scope.DevilAnimeDiceFlights or{};scope.DevilAnimeDiceFlights=flights
    local requireModule=require
    local paths={
        Data="Data.DataController",Registry="Inventory.EntryRegistry",Buffs="Buffs.BuffController",
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
            local module=path(rs,"Framework.Features."..name)
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
    function ctx.DoorInitialReady()return player:GetAttribute("TrickOrTreatReadyAt")or ctx.Now()+30 end
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
                    result[#result+1]={key=part,position=home.Position,front=front,range=math.max(2,tonumber(model and model:GetAttribute("Range"))or 14)}
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
    function ctx.Walk(goal,valid)
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health<=0 then return false,"Character unavailable"end
        goal=Vector3.new(goal.X,root.Position.Y,goal.Z)
        local route=game:GetService("PathfindingService"):CreatePath({AgentCanJump=true,WaypointSpacing=5})
        local ok=pcall(route.ComputeAsync,route,root.Position,goal)
        if not valid()then return false,"Cancelled"end
        if not ok or route.Status~=Enum.PathStatus.Success then return false,"No walkable path"end
        for _,waypoint in ipairs(route:GetWaypoints())do
            if not valid()or player.Character~=char then return false,"Cancelled"end
            if waypoint.Action==Enum.PathWaypointAction.Jump then hum.Jump=true end
            hum:MoveTo(waypoint.Position)
            local untilAt=os.clock()+8
            while valid()and player.Character==char and root.Parent and hum.Health>0 and(root.Position-waypoint.Position).Magnitude>4 do
                if os.clock()>untilAt then ctx.CancelMovement();return false,"Path blocked"end
                task.wait(.1)
            end
            if not valid()or player.Character~=char or not root.Parent or hum.Health<=0 then return false,"Character unavailable / cancelled"end
        end
        return valid(),valid()and"Arrived"or"Cancelled"
    end
    function ctx.Destroy()
        ctx.CancelMovement()
        for _,link in ipairs(ctx.Links)do link:Disconnect()end
        table.clear(ctx.Links)
    end
    return ctx
end
