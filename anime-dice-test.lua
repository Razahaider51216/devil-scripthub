-- DEVIL HUB Anime Dice entry, available directly and through the main loader.
assert(game.GameId==10708913337 or game.PlaceId==113290951185459,"Open Anime Dice before running this test")
local scope=type(getgenv)=="function"and getgenv()or _G
-- BEGIN DEVIL AUTO EXECUTE
do
    local scope=type(getgenv)=="function"and getgenv()or _G
    local current=scope.DevilHubAutoExecute
    if not(current and current.Version=="devil-auto-execute-1"and(current.Link or current.Queued))then
        local state={Version="devil-auto-execute-1",Status="Unavailable",Queued=false}
        scope.DevilHubAutoExecute=state
        local ok,problem=pcall(function()
            local candidates={}
            local function add(fn)
                if type(fn)~="function"then return end
                for _,existing in ipairs(candidates)do if existing==fn then return end end
                candidates[#candidates+1]=fn
            end
            add(queue_on_teleport);add(queueonteleport)
            add(scope.queue_on_teleport);add(scope.queueonteleport)
            for _,namespace in ipairs({"syn","fluxus"})do
                local api=scope[namespace]or(namespace=="syn"and syn or fluxus)
                if type(api)=="table"then add(api.queue_on_teleport);add(api.queueonteleport)end
            end
            if #candidates==0 then return end
            local payload=[==[
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilHubAutoExecuteArrival then return end
scope.DevilHubAutoExecuteArrival=true
if not game:IsLoaded()then game.Loaded:Wait()end
for attempt=1,3 do
    local ok,problem=pcall(function()
        local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1")
        assert(type(source)=="string"and #source>0 and not source:match("^%s*<"),"Invalid DEVIL HUB loader response")
        local run,err=loadstring(source,"DEVIL HUB / Auto Execute")
        assert(run,err)
        return run()
    end)
    if ok then return end
    if attempt<3 then task.wait(attempt*2)
    else scope.DevilHubAutoExecuteArrival=nil;warn("DEVIL HUB Auto Execute: "..tostring(problem))end
end
]==]
            local function queue()
                if state.Queued then return end
                for _,fn in ipairs(candidates)do
                    local queued,result=pcall(fn,payload)
                    if queued and result~=false then state.Queued=true;state.Status="Queued";state.LastError=nil;return end
                    state.LastError=tostring(result)
                end
                state.Status="Queue failed"
            end
            local player=game:GetService("Players").LocalPlayer
            if player and player.OnTeleport then
                state.Link=player.OnTeleport:Connect(function(status)
                    if status==Enum.TeleportState.Started or status==Enum.TeleportState.InProgress then queue()
                    elseif status==Enum.TeleportState.Failed then state.Queued=false;state.Status="Ready"end
                end)
                state.Status="Ready"
            else
                -- Some executors cannot expose the event; preload their queue.
                queue()
            end
        end)
        if not ok then state.Status="Unavailable";state.LastError=tostring(problem)end
    end
end
-- END DEVIL AUTO EXECUTE

local release="anime-dice-test-20261020-12"
local previous=scope.DevilAnimeDiceTest
if previous and not previous.Stopped then
    if previous.Version==release then return previous end
    assert(type(previous.Destroy)=="function","Close the previous Anime Dice test before updating")
    previous.Destroy()
end
if scope.DevilAnimeDiceStarting and os.clock()-scope.DevilAnimeDiceStarting.At<30 then warn("DEVIL HUB: Anime Dice test is already starting");return end
local startup={At=os.clock()};scope.DevilAnimeDiceStarting=startup
local planner=(function()
-- Pure inventory/budget planning. No game actions or captured player IDs.
local P={}
function P.Number(value,default)
    local n=tonumber(value)
    return n and n==n and n>=0 and n<math.huge and n or(default or 0)
end
function P.Value(fn,...)
    if type(fn)~="function"then return P.Number(fn)end
    local ok,value=pcall(fn,...)
    return ok and P.Number(value)or 0
end
function P.Chance(value,default)
    if type(value)=="string"then
        value=value:gsub(",",""):gsub("%s",""):gsub("^1/","")
    end
    return P.Number(value,default)
end
function P.Rarity(config,attributes)
    if type(config.getRarity)=="function"then
        local ok,value=pcall(config.getRarity,attributes)
        return ok and type(value)=="string"and value or nil
    end
    return type(config.rarity)=="string"and config.rarity or nil
end
function P.RarityOptions(catalog,units,selected)
    local names={};local order={};local result={}
    for _,name in pairs(catalog and catalog.Refs or{})do if type(name)=="string"then
        names[name]=true
        local ok,spec=pcall(function()return catalog.Get(name)end)
        if ok and type(spec)=="table"then order[name]=P.Number(spec.sortOrder,math.huge)end
    end end
    for _,unit in ipairs(units)do if unit.rarity then names[unit.rarity]=true end end
    for name,value in pairs(selected or{})do if value==true then names[name]=true end end
    for name in pairs(names)do result[#result+1]=name end
    table.sort(result,function(a,b)
        local x,y=order[a]or math.huge,order[b]or math.huge
        return x==y and a<b or x<y
    end)
    return result
end
function P.Units(data,registry)
    local result={}
    for id,item in pairs(data.Inventory or{})do
        local ok,config=pcall(registry.getEntryConfig,item.name)
        if ok and config and config.kind=="Unit"and P.Number(item.amount)>0 then
            local a=item.attributes or{}
            result[#result+1]={id=id,name=item.name,attributes=a,amount=item.amount,config=config,
                rarity=P.Rarity(config,a),chance=P.Value(config.chance,a),income=P.Value(config.income,a),damage=P.Value(config.damage,a)}
        end
    end
    table.sort(result,function(a,b)if a.chance==b.chance then return a.id<b.id end;return a.chance>b.chance end)
    return result
end
function P.Protected(data,units,cfg,allUnused)
    local protected={}
    if data.EquippedUnit then protected[data.EquippedUnit]=true end
    if cfg.SelectedUnit and cfg.SelectedUnit~=""then protected[cfg.SelectedUnit]=true end
    for _,slot in pairs(data.Slots or{})do if slot.unitId then protected[slot.unitId]=true end end
    for _,id in pairs(data.TowerTeam or{})do protected[id]=true end
    local copies={}
    for i,u in ipairs(units)do
        copies[u.name]=(copies[u.name]or 0)+1
        local a=u.attributes
        if a.locked or a.favorite or cfg.KeepIds[u.id]or cfg.KeepNames[u.name]
            or not allUnused and(i<=cfg.KeepBest or copies[u.name]<=cfg.KeepCopies
            or cfg.SkipMutations and(a.mutation and a.mutation~=""or a.variant and a.variant~=""))then protected[u.id]=true end
    end
    return protected
end
function P.Materials(data,registry,cfg,limit,fusing)
    local allUnused=not fusing
    local units=P.Units(data,registry);local protected=P.Protected(data,units,cfg,allUnused)
    local result={}
    if data.PendingTrade or allUnused and data.EquippedUnitKnown==false or fusing and limit<=0 then return result end
    local rarities=cfg.SellRarities or{};local filtered=allUnused and next(rarities)~=nil
    for i=#units,1,-1 do
        local u=units[i]
        if not protected[u.id]and(not filtered or u.rarity and rarities[u.rarity]==true)
            and(allUnused or u.chance>0 and u.chance<=limit and u.amount==1 and not u.config.limited)then
            result[#result+1]=u
        end
    end
    return result
end
function P.Amount(data,name)
    local item=(data.Inventory or{})[name]
    if item and item.name==name then return P.Number(item.amount)end
    local count=0
    for _,entry in pairs(data.Inventory or{})do if entry.name==name then count+=P.Number(entry.amount)end end
    return count
end
function P.Upgrade(data,catalog,cfg)
    local choices={}
    for id,upgrade in pairs(catalog.Upgrades or{})do
        local selected=cfg.UpgradeBranch=="All"or id:sub(1,#cfg.UpgradeBranch)==cfg.UpgradeBranch
        if selected and not(data.Upgrades or{})[id]and P.Number(upgrade.price)<=data.Money-cfg.MoneyReserve then
            local parent=catalog.TreeStructure.GetParent(id)
            if not parent or parent=="Start"or(data.Upgrades or{})[parent]then choices[#choices+1]={id=id,price=upgrade.price or 0}end
        end
    end
    table.sort(choices,function(a,b)if a.price==b.price then return a.id<b.id end;return a.price<b.price end)
    return choices[1]
end
function P.Dice(data,catalog,cfg)
    local all=catalog.Dice.GetAll();local current=all[data.Dice]or{}
    local best
    for name,dice in pairs(all)do
        local wanted=cfg.DiceChoice=="Best affordable"or cfg.DiceChoice==name
        local owned=(data.OwnedDice or{})[name]==true or data.Dice==name
        if wanted and data.Dice~=name and(cfg.DiceChoice~="Best affordable"or P.Number(dice.luck)>P.Number(current.luck))
            and(owned or type(dice.price)=="number"and dice.price<=data.Money-cfg.MoneyReserve)then
            if not best or dice.luck>best.luck then best={name=name,luck=dice.luck,owned=owned,price=dice.price or 0}end
        end
    end
    return best
end
function P.Quest(data,config,halloween)
    local periods=halloween and config.PERIODS or{"Daily","Weekly"}
    for _,period in ipairs(periods or{})do
        local spec=halloween and config[period]or(config.Periods or{})[period]
        local state=halloween and(data.Halloween or{})[spec and spec.dataKey or""]or(data.Quests or{})[period]
        if spec and state then
            for _,quest in pairs(spec.pool or spec.quests or{})do
                local active=not halloween or table.find(state.ids or{},quest.id)
                if active and not(state.claimed or{})[quest.id]and P.Number((state.progress or{})[quest.id])>=P.Number(quest.target,math.huge)then
                    return period,quest.id,state.expiresAt
                end
            end
        end
    end
end
return P

end)()
local makeAdapter=(function()
return function(scope)
    local rs=game:GetService("ReplicatedStorage")
    local player=game:GetService("Players").LocalPlayer
    local ctx={Catalog={},Ready=false,Warnings={},Links={},Spawn=task.spawn,Wait=task.wait,WallTime=os.time,
        UserId=player and player.UserId,PlaceId=game.PlaceId}
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

end)()
local makeCore=(function()
return function(ctx,P)
    local jobs={"Roll","Collect","EquipBase","Level","Upgrade","Dice","Sell","Lock","Tower","Haunted","Rebirth","Stats",
        "Trait","Grade","Quirk","Fuse","Boost","Spin","Gear","Rewards","Quests","Codes","Pumpkin","Pass","EventQuests","CandyShop","Doors","QuestShop"}
    local cfg={MoneyReserve=0,CandyReserve=0,PumpkinReserve=0,KeepBest=1,KeepCopies=1,KeepIds={},KeepNames={},SellRarities={},SkipMutations=true,
        FuseChanceMax=0,LockChanceMin=0,UpgradeBranch="All",DiceChoice="Best affordable",LevelCap=100,
        TowerChoice="",WingChoice="Front Yard",RebirthLimit=1,StatChoice="Luck",SelectedUnit="",RerollLimit=50,
        TraitTargets={},GradeTargets={},QuirkTargets={},BoostNames={},SpinNames={},GearPriority="Luck",PumpkinCount=1,
        PumpkinSellNames={},OfferChoice="",OfferLimit=1,QuestOffer="",QuestLimit=1,TicketReserve=0,CodeList={},UseNativeRoll=true,
        ProtectedTraits={},ProtectedGrades={},ProtectedQuirks={}}
    local clock=ctx.Clock or os.clock
    local ctl={Config=cfg,Report={Version="anime-dice-test-20261020-12",Jobs={},Log={},TowerRewards={},LiveVerified=false},Stopped=false,Generation={}}
    local states,handlers,pending,spend={}, {}, {}, {}
    local towerOwned=false;local towerName;local towerEpoch=0;local originalRoll,rollOwned=nil,false
    local doorReady=setmetatable({},{__mode="k"});local lastKnock;local nextIslandTravel=0;local stopEpoch=0
    local function log(name,message)
        local list=ctl.Report.Log
        list[#list+1]={At=math.floor(clock()*10)/10,Job=name,Message=tostring(message):sub(1,400)}
        if #list>40 then table.remove(list,1)end
    end
    for _,name in ipairs(jobs)do
        cfg[name]=false;ctl.Generation[name]=0
        local state={Status="Off",Requests=0,Confirmed=0,Errors=0,Next=0,Busy=false}
        states[name]=state;ctl.Report.Jobs[name]=state
    end
    local function valid(name,token)return not ctl.Stopped and cfg[name]and ctl.Generation[name]==token end
    local function data()local snapshot=ctx.Snapshot();assert(snapshot,"Waiting for live player data");return snapshot end
    local function catalog(key)assert(ctx.Catalog[key],"Unavailable module: "..key);return ctx.Catalog[key]end
    local function status(name,message)states[name].Status=message end
    local function call(name,token,kind,ns,method,...)
        if not valid(name,token)then return end
        local s=states[name];s.Requests+=1;s.LastRequest=ns.."/"..method;s.LastRequestAt=clock()
        if kind=="RF"then return ctx.Invoke(ns,method,...)end
        ctx.Fire(ns,method,...)
    end
    local function expect(name,fn,detail)
        if states[name].RunToken~=nil and states[name].RunToken~=ctl.Generation[name]then return end
        pending[name]={Check=fn,Until=clock()+10,Detail=detail or"Waiting for game data"}
        status(name,detail or"Waiting for game data")
    end
    local function spendable(currency,value,cost,reserve)
        local prior=spend[currency]
        if prior and prior.Until>clock()and prior.Value==value then return false end
        if cost<0 or cost~=cost or cost==math.huge or value-cost<reserve then return false end
        spend[currency]={Value=value,Until=clock()+3};return true
    end
    local function finish(name,detail)
        states[name].Confirmed+=1;status(name,detail or"Confirmed");log(name,detail or"Confirmed")
    end
    local function inventoryChange(name,before,detail)
        expect(name,function(d)
            for id,item in pairs(before.Inventory or{})do
                local after=(d.Inventory or{})[id]
                if not after or item.amount~=after.amount then return true end
            end
            for id in pairs(d.Inventory or{})do if not(before.Inventory or{})[id]then return true end end
            return false
        end,detail)
    end
    local function moneyAction(name,token,d,cost,ns,method,...)
        if not spendable("Money",d.Money,P.Number(cost),cfg.MoneyReserve)then status(name,"Waiting for money / reserve");return false end
        call(name,token,"RE",ns,method,...);return true
    end
    function ctl.Set(name,value)
        assert(states[name],"Unknown feature")
        value=value==true
        if cfg[name]==value then return end
        cfg[name]=value;ctl.Generation[name]+=1;pending[name]=nil
        states[name].Status=value and"Ready"or"Off";states[name].Next=0
        if value and(name=="Trait"or name=="Grade"or name=="Quirk")then states[name].Attempts=0 end
        if value and(name=="CandyShop"or name=="QuestShop")then states[name].Purchases=0 end
        if value and name=="Tower"then ctl.Set("Haunted",false)elseif value and name=="Haunted"then ctl.Set("Tower",false)end
        if not value and name=="Doors"then
            states[name].Busy=false;states[name].RunToken=nil
            ctx.CancelMovement()
        end
        if not value and name=="Roll"and rollOwned then
            rollOwned=false;pcall(ctx.Fire,"RollService","SetAutoRoll",originalRoll==true)
        end
        if not value and(name=="Tower"or name=="Haunted")and towerOwned then
            towerOwned=false;towerName=nil;towerEpoch+=1
            ctx.Spawn(function()pcall(ctx.Invoke,"Towers","CancelTower")end)
        end
    end
    function ctl.StopAll()
        stopEpoch+=1
        for _,name in ipairs(jobs)do ctl.Set(name,false)end
        ctx.CancelMovement()
    end
    function ctl.Destroy()
        if ctl.Stopped then return end
        ctl.StopAll();ctl.Stopped=true;ctx.Destroy()
    end
    function ctl.Preview(kind)
        local d=data()
        return P.Materials(d,catalog("Registry"),cfg,kind=="Fuse"and cfg.FuseChanceMax or 0,kind=="Fuse")
    end
    function ctl.SellSummary()
        local d=data();local units=P.Units(d,catalog("Registry"));local items=P.Materials(d,catalog("Registry"),cfg,0,false)
        if d.PendingTrade then return "Sale paused: trade in progress."end
        if d.EquippedUnitKnown==false then return "Sale paused: waiting for carried unit data."end
        local selected={};for rarity,value in pairs(cfg.SellRarities)do if value==true then selected[#selected+1]=rarity end end;table.sort(selected)
        local mode=#selected>0 and"Sell ["..table.concat(selected,", ").."]"or"Sell All Unused"
        return string.format("%s: %d eligible / %d units | Used, locked and kept units excluded",mode,#items,#units)
    end
    handlers.Roll=function(name,token,d)
        if cfg.UseNativeRoll then
            if d.AutoRoll then status(name,"Native Auto Roll active");return 2 end
            if originalRoll==nil then originalRoll=d.AutoRoll==true end
            rollOwned=true;call(name,token,"RE","RollService","SetAutoRoll",true)
            expect(name,function(s)return s.AutoRoll==true end,"Enabling game Auto Roll");return 2
        end
        if d.AutoRoll then status(name,"Game Auto Roll already active");return 2 end
        if P.Number(d.Storage)>0 and #P.Units(d,catalog("Registry"))>=d.Storage then status(name,"Inventory full");return 2 end
        local results=call(name,token,"RF","RollService","RollDice")
        if results then inventoryChange(name,d,"Waiting for rolled units")else status(name,"Roll not ready / fusion active")end
        return math.max(.75,ctx.Buff("Roll Duration")or 1)
    end
    handlers.Collect=function(name,token,d)
        for index,slot in pairs(d.Slots or{})do
            local n=tonumber(index)
            if n and P.Number(slot.balance)>0 then
                call(name,token,"RE","PlotService","CollectBalance",n)
                expect(name,function(s)return P.Number(((s.Slots or{})[index]or{}).balance)<slot.balance end,"Collecting slot "..n)
                return .3
            end
        end
        status(name,"No balance to collect");return 1
    end
    handlers.EquipBase=function(name,token,d)
        local before={};for index,slot in pairs(d.Slots or{})do before[index]=slot.unitId end
        call(name,token,"RE","PlotService","EquipBest")
        expect(name,function(s)
            for i,slot in pairs(s.Slots or{})do if slot.unitId~=before[i]then return true end end
            for i in pairs(before)do if not(s.Slots or{})[i]then return true end end
            return false
        end,"Equip Best requested; may already be optimal")
        return 5
    end
    handlers.Level=function(name,token,d)
        local registry=catalog("Registry");local util=catalog("UnitUtil")
        local choices={}
        for index,slot in pairs(d.Slots or{})do
            local unit=(d.Inventory or{})[slot.unitId]
            if unit and P.Number((unit.attributes or{}).level,1)<cfg.LevelCap then
                local cost=util.GetLevelPrice(unit.name,unit.attributes or{})
                choices[#choices+1]={index=tonumber(index),id=slot.unitId,cost=cost,level=P.Number((unit.attributes or{}).level,1)}
            end
        end
        table.sort(choices,function(a,b)return a.cost<b.cost end)
        local choice=choices[1]
        if choice and moneyAction(name,token,d,choice.cost,"PlotService","LevelUpSlot",choice.index)then
            expect(name,function(s)local u=(s.Inventory or{})[choice.id];return u and P.Number((u.attributes or{}).level,1)>choice.level end,"Level upgrade requested")
        elseif not choice then status(name,"No eligible plotted unit")end
        return .5
    end
    handlers.Upgrade=function(name,token,d)
        local c={Upgrades=catalog("Upgrades"),TreeStructure=catalog("TreeStructure")}
        local item=P.Upgrade(d,c,cfg)
        if item and moneyAction(name,token,d,item.price,"","BuyUpgrade",item.id)then
            expect(name,function(s)return(s.Upgrades or{})[item.id]==true end,"Buying "..item.id)
        elseif not item then status(name,"No affordable unlocked upgrade")end
        return .6
    end
    handlers.Dice=function(name,token,d)
        local item=P.Dice(d,{Dice=catalog("Dice")},cfg)
        if not item then status(name,"Best selected dice equipped / waiting for money");return 2 end
        if item.owned then call(name,token,"RE","DiceShopService","EquipDice",item.name)
        elseif not moneyAction(name,token,d,item.price,"DiceShopService","BuyDice",item.name)then return 1 end
        expect(name,function(s)return s.Dice==item.name end,"Equipping "..item.name);return 1
    end
    handlers.Sell=function(name,token,d)
        local items=P.Materials(d,catalog("Registry"),cfg,0,false)
        local ids={};for i=1,math.min(25,#items)do ids[i]=items[i].id end
        if #ids==0 then status(name,ctl.SellSummary());return 3 end
        local earned,count=call(name,token,"RF","SellService","SellInventory",ids)
        if P.Number(count)>0 then
            states[name].Units=(states[name].Units or 0)+count;states[name].Earned=(states[name].Earned or 0)+P.Number(earned)
            finish(name,"Sold "..count.." units")
        else status(name,"Sale rejected / units protected")end
        return 2
    end
    handlers.Lock=function(name,token,d)
        if cfg.LockChanceMin<=0 then status(name,"Set minimum chance before locking");return 3 end
        local locks={}
        for _,u in ipairs(P.Units(d,catalog("Registry")))do if not u.attributes.locked and u.chance>=cfg.LockChanceMin then locks[u.id]=true end end
        if not next(locks)then status(name,"No units need locking");return 3 end
        call(name,token,"RE","UnitService","SetLocked",locks)
        expect(name,function(s)
            for id in pairs(locks)do local u=(s.Inventory or{})[id];if not u or not(u.attributes or{}).locked then return false end end
            return true
        end,"Locking matching units");return 2
    end
    local function tower(name,token,d)
        local choice=name=="Haunted"and cfg.WingChoice or cfg.TowerChoice
        local spec=catalog("Towers").GetAll()[choice]
        if not spec then status(name,"Select a tower / wing");return 3 end
        if type(d.AutoTower)=="string"and d.AutoTower~=""then status(name,"Turn off the game's Auto Tower first");return 3 end
        if not towerOwned then
            call(name,token,"RE","Towers","EquipBestTowerTeam")
            ctx.Wait(1.1)
            if not valid(name,token)then return end
            local started=call(name,token,"RF","Towers","PlayTower",choice)
            if started then
                if not valid(name,token)then pcall(ctx.Invoke,"Towers","CancelTower");return end
                towerOwned=true;towerName=choice;status(name,"Tower started: "..choice)
            else status(name,"Tower unavailable / already running / locked")end
            return 5.2
        end
        local epoch=towerEpoch
        local actions=call(name,token,"RF","Towers","CompleteTowerFloor")
        if epoch~=towerEpoch or not valid(name,token)then return end
        if actions=="destroyed"then towerOwned=false;towerName=nil;status(name,"Tower finished");return 5.2 end
        local delay=0
        if type(actions)=="table"then
            local refs=catalog("TowerRefs").ActionWaitTime
            for _,action in ipairs(actions)do
                delay+=P.Number(refs[action.action])
                if action.action=="floorCompleted"then
                    finish(name,"Floor "..tostring(action.floor).." complete")
                    local items={}
                    for item,amount in pairs(type(action.rewards)=="table"and action.rewards or{})do
                        local count=P.Number(amount)
                        if type(item)=="string"and count>0 then items[#items+1]={Name=item,Amount=count}end
                    end
                    table.sort(items,function(a,b)return a.Name<b.Name end)
                    local event={Job=name,Tower=towerName or choice,Floor=action.floor,Items=items,At=clock()}
                    local history=ctl.Report.TowerRewards;history[#history+1]=event
                    if #history>20 then table.remove(history,1)end
                    if ctx.OnTowerReward then
                        local ok,err=pcall(ctx.OnTowerReward,event)
                        if not ok then ctl.Report.PresentationError=tostring(err):sub(1,500)end
                    end
                end
                if action.action=="ended"then towerOwned=false;towerName=nil;status(name,"Run complete")end
            end
        end
        return math.max(1,delay+.35)
    end
    handlers.Tower=tower;handlers.Haunted=tower
    handlers.Rebirth=function(name,token,d)
        if d.Rebirth>=cfg.RebirthLimit then status(name,"Rebirth target reached");return 5 end
        local nextTier=catalog("Rebirths").GetNext(d.Rebirth)
        if not nextTier or d.Money<nextTier.cost then status(name,"Waiting for rebirth cost");return 3 end
        if not spendable("Money",d.Money,d.Money,0)then return 2 end
        call(name,token,"RE","RebirthService","Rebirth")
        expect(name,function(s)return s.Rebirth>d.Rebirth end,"Rebirth requested (cash resets)");return 2
    end
    handlers.Stats=function(name,token,d)
        local config=catalog("RebirthStats")
        if not config.Get(cfg.StatChoice)or config.GetRemaining(d.Rebirth,d.RebirthStats)<1 then status(name,"No rebirth points");return 3 end
        local previous=P.Number((d.RebirthStats or{})[cfg.StatChoice]);local selected=cfg.StatChoice
        call(name,token,"RE","RebirthService","AddStat",selected)
        expect(name,function(s)return P.Number((s.RebirthStats or{})[selected])>previous end,"Allocating "..selected);return .4
    end
    local reroll={Trait={Attr="trait",Currency="Trait Reroll",Protected="ProtectedTraits"},Grade={Attr="grade",Currency="Gems",Protected="ProtectedGrades"},Quirk={Attr="quirk",Protected="ProtectedQuirks"}}
    for name,rule in pairs(reroll)do handlers[name]=function(job,token,d)
        local u=(d.Inventory or{})[cfg.SelectedUnit];local id=cfg.SelectedUnit
        if not u then status(job,"Select a live inventory unit");return 2 end
        local targets=cfg[job.."Targets"]
        if not next(targets)then status(job,"Select target values");return 2 end
        local attr=(u.attributes or{})[rule.Attr]
        if targets[attr]then ctl.Set(job,false);status(job,"Target reached: "..tostring(attr));return end
        if (d[rule.Protected]or{})[attr]then status(job,"Current value protected by game");return 3 end
        if states[job].Attempts>=cfg.RerollLimit then status(job,"Reroll request limit reached");return 3 end
        if rule.Currency then
            if P.Amount(d,rule.Currency)<1 then status(job,"No "..rule.Currency);return 3 end
        else
            local cost=catalog("QuirkUtil").GetRollCost(u.name,u.attributes or{})
            if not spendable("Money",d.Money,cost,cfg.MoneyReserve)then status(job,"Waiting for quirk budget");return 2 end
        end
        call(job,token,"RE",job.."Service","Roll",id,false);states[job].Attempts+=1
        -- A reroll may produce the same value. Currency changes also confirm processing.
        local before=rule.Currency and P.Amount(d,rule.Currency)or d.Money
        expect(job,function(s)
            local item=(s.Inventory or{})[id]
            return item and((item.attributes or{})[rule.Attr]~=attr or(rule.Currency and P.Amount(s,rule.Currency)or s.Money)<before)
        end,"Reroll request "..states[job].Attempts)
        return .6
    end end
    handlers.Fuse=function(name,token,d)
        local choices=P.Materials(d,catalog("Registry"),cfg,cfg.FuseChanceMax,true)
        if #choices<3 then status(name,"Need 3 eligible surplus units");return 3 end
        local utility=catalog("FusingUtil");local total=0
        for i=1,3 do local chance=utility.GetChance((d.Inventory or{})[choices[i].id]);if not chance then return 3 end;total+=chance end
        if not utility.BuildPools(total)then status(name,"No balanced fusion pool");return 4 end
        local cost=catalog("FusingConfig").GetCost(total)
        if moneyAction(name,token,d,cost,"FusingService","Fuse",choices[1].id,choices[2].id,choices[3].id)then
            inventoryChange(name,d,"Fusion requested")
        end
        return 3.5
    end
    local function useEntry(name,token,d)
        local names=cfg[name.."Names"]
        for entryName in pairs(names)do
            local config=catalog("Registry").getEntryConfig(entryName)
            if config and config.kind==name and P.Amount(d,entryName)>0 and not(d.ActiveEntries or{})[entryName]then
                call(name,token,"RE",name=="Boost"and"BoostService"or"SpinService","Use",entryName)
                inventoryChange(name,d,"Using "..entryName);return 2
            end
        end
        status(name,"No selected inactive items");return 3
    end
    handlers.Boost=useEntry;handlers.Spin=useEntry
    handlers.Gear=function(name,token,d)
        local best={};local registry=catalog("Registry")
        for _,entry in pairs(d.Inventory or{})do
            local config=registry.getEntryConfig(entry.name)
            if config and config.kind=="Gear"and entry.amount>0 then
                local score=0
                for buff,amount in pairs(config.buffs or{})do
                    if buff:lower():find(cfg.GearPriority:lower(),1,true)then score+=type(amount)=="table"and P.Number(amount.amount)or P.Number(amount)end
                end
                if score>0 and(not best[config.slot]or score>best[config.slot].score)then best[config.slot]={name=entry.name,score=score}end
            end
        end
        for slot,item in pairs(best)do if(d.EquippedGear or{})[slot]~=item.name then
            call(name,token,"RE","GearService","Equip",slot,item.name)
            expect(name,function(s)return(s.EquippedGear or{})[slot]==item.name end,"Equipping "..item.name);return 1
        end end
        status(name,"Selected gear already equipped");return 4
    end
    handlers.Rewards=function(name,token,d)
        if P.Number(d.PendingOfflineEarnings)>0 then
            call(name,token,"RE","OfflineEarningsService","Claim")
            expect(name,function(s)return P.Number(s.PendingOfflineEarnings)==0 end,"Claiming offline earnings");return 1
        end
        local now=ctx.WallTime()
        if d.LastDailyRewardClaim==0 or now-P.Number(d.LastDailyRewardClaim)>=catalog("Daily").Cooldown then
            call(name,token,"RE","DailyRewardService","Claim")
            expect(name,function(s)return s.LastDailyRewardClaim~=d.LastDailyRewardClaim end,"Claiming daily reward");return 1
        end
        if not d.ClaimedGroupReward and ctx.InGroup()then
            call(name,token,"RE","GroupRewardService","Claim")
            expect(name,function(s)return s.ClaimedGroupReward==true end,"Claiming group reward");return 1
        end
        status(name,"No claimable rewards");return 20
    end
    local function quest(name,token,d)
        local event=name=="EventQuests"
        local period,id,expires=P.Quest(d,catalog(event and"HalloweenQuests"or"Quest"),event)
        if not id then status(name,"No completed quests");return 5 end
        if event then call(name,token,"RE","HalloweenQuestService","Claim",period,id)
        else call(name,token,"RE","QuestService","Claim",period,id,expires)end
        expect(name,function(s)
            local key=event and catalog("HalloweenQuests")[period].dataKey
            local state=event and(s.Halloween or{})[key]or(s.Quests or{})[period]
            return state and(state.claimed or{})[id]==true
        end,"Claiming "..period.." / "..id);return .5
    end
    handlers.Quests=quest;handlers.EventQuests=quest
    local codesTried={}
    handlers.Codes=function(name,token,d)
        for _,code in ipairs(cfg.CodeList)do if not codesTried[code]and not(d.RedeemedCodes or{})[code]then
            codesTried[code]=true;call(name,token,"RE","CodesService","RedeemCode",code)
            expect(name,function(s)return(s.RedeemedCodes or{})[code]and true or false end,"Trying code: "..code);return 1
        end end
        status(name,"Code list processed");return 10
    end
    handlers.Pumpkin=function(name,token,d)
        local spec=catalog("PumpkinDice");local count=cfg.PumpkinCount==spec.MULTI and spec.MULTI or 1
        local currency=catalog("Halloween").PUMPKINS
        if P.Number(d.Storage)>0 and #P.Units(d,catalog("Registry"))+count>d.Storage then status(name,"Inventory full");return 3 end
        if not spendable("Pumpkins",P.Amount(d,currency),spec.COST*count,cfg.PumpkinReserve)then status(name,"Waiting for pumpkins / reserve");return 3 end
        local result=call(name,token,"RF","PumpkinDiceService","Roll",count)
        if result and result.ok then finish(name,"Pumpkin rolls: "..#(result.results or{}))else status(name,result and result.message or"Pumpkin roll rejected")end
        return math.max(2.6,P.Number(spec.ROLL_DURATION,2.5)+.25)
    end
    handlers.Pass=function(name,token,d)
        local h=d.Halloween or{};local available=false
        for i,tier in ipairs(catalog("PumpkinPass"))do
            if P.Number(h.CandyEarned)>=tier.candy and(not(h.PathClaimed or{})[tostring(i)]and not(h.PathClaimed or{})[i]
                or h.PathPremium and not(h.PathPremiumClaimed or{})[tostring(i)]and not(h.PathPremiumClaimed or{})[i])then available=true;break end
        end
        if not available then status(name,"No claimable pass tiers");return 5 end
        call(name,token,"RE","HalloweenService","ClaimAllPath")
        inventoryChange(name,d,"Claiming earned pass rewards");return 2
    end
    handlers.CandyShop=function(name,token,d)
        if(states[name].Purchases or 0)>=cfg.OfferLimit then status(name,"Purchase limit reached");return 5 end
        for i,offer in ipairs(catalog("HalloweenShop"))do if offer.name==cfg.OfferChoice then
            local currency=catalog("Halloween").CANDY
            if not spendable("Candy",P.Amount(d,currency),offer.candy,cfg.CandyReserve)then status(name,"Waiting for candy / reserve");return 3 end
            call(name,token,"RE","HalloweenService","BuyOffer",i)
            local before=P.Amount(d,currency)
            expect(name,function(s)
                if P.Amount(s,currency)<before then states[name].Purchases=(states[name].Purchases or 0)+1;return true end
                return false
            end,"Buying "..offer.name);return 1
        end end
        status(name,"Select a candy shop item");return 3
    end
    handlers.QuestShop=function(name,token,d)
        if(states[name].Purchases or 0)>=cfg.QuestLimit then status(name,"Purchase limit reached");return 5 end
        for _,offer in ipairs(catalog("Quest").Shop or{})do if offer.name==cfg.QuestOffer then
            if offer.gamepass and(d.OwnedGamepasses or{})[offer.name]then status(name,"Already owned");return 5 end
            local before=P.Amount(d,"Tickets")
            if not spendable("Tickets",before,offer.tickets,cfg.TicketReserve)then status(name,"Waiting for tickets / reserve");return 3 end
            call(name,token,"RE","QuestService","Buy",offer.name)
            expect(name,function(s)
                if P.Amount(s,"Tickets")<before then states[name].Purchases=(states[name].Purchases or 0)+1;return true end
                return false
            end,"Buying "..offer.name);return 1
        end end
        status(name,"Select a quest shop item");return 3
    end
    handlers.Doors=function(name,token)
        local doors=ctx.Doors();local pos=ctx.Position()
        if not pos then status(name,"Waiting for character");return 2 end
        local config=catalog("Halloween").TrickOrTreat
        assert(config,"TrickOrTreat configuration unavailable")
        states[name].LoadedDoors=#doors
        local now=ctx.Now();local best,distance;local nearest=math.huge;local nextReady=math.huge
        local deadline=clock()+60
        local active=function()return valid(name,token)and clock()<deadline end
        for _,door in ipairs(doors)do
            local dist=(door.position-pos).Magnitude;nearest=math.min(nearest,dist)
            local ready=doorReady[door.key]or ctx.DoorInitialReady();nextReady=math.min(nextReady,ready)
            if ready<=now then
                if not distance or dist<distance then best,distance=door,dist end
            end
        end
        if #doors==0 or nearest>1500 then
            if now>=nextIslandTravel then
                nextIslandTravel=now+30;status(name,"Traveling to Halloween Island / loading doors")
                call(name,token,"RF","HalloweenService","Teleport","Island")
                if not active()then return end
                ctx.StreamEvent();return 2
            end
            ctx.StreamEvent()
            if not active()then return end
            status(name,"Waiting for streamed event doors ("..#doors.." loaded)");return 2
        end
        if not best then status(name,"Door cooldown: "..math.max(0,math.ceil(nextReady-now)).."s | Loaded: "..#doors);return 1 end
        -- Exit the door volume first so the server can arm a previous visit.
        status(name,"Teleporting to door")
        local outside=best.position+best.front*(best.range+10)
        local ok,why=ctx.MoveDoor(outside,active,best)
        if not active()then return end
        if not ok then status(name,why);doorReady[best.key]=now+5;return 2 end
        ctx.Wait(.4) -- Allow the server's door check to observe the outside position.
        local latest=lastKnock
        if latest and latest.position then
            local speed=P.Number(config.MAX_TRAVEL_SPEED,60);if speed<=0 then speed=60 end
            local earliest=latest.at+math.max(P.Number(config.MIN_KNOCK_GAP,2),(best.position-latest.position).Magnitude/speed)
            while active()and ctx.Now()<earliest do
                status(name,"Door travel cooldown: "..math.ceil(earliest-ctx.Now()).."s")
                ctx.Wait(.1)
            end
        end
        if not active()then return end
        ok,why=ctx.MoveDoor(best.position+best.front*math.min(best.range*.6,6),active,best)
        if not active()then return end
        if not ok then status(name,why);doorReady[best.key]=ctx.Now()+5;return 2 end
        status(name,"Waiting for server knock")
        deadline=math.min(deadline,clock()+8)
        local function knocked()return lastKnock and lastKnock.part==best.key and lastKnock.at>=now end
        while active()and clock()<deadline and not knocked()do ctx.Wait(.1)end
        if active()and not knocked()then
            doorReady[best.key]=ctx.Now()+5;status(name,"No knock confirmation; retrying another route")
        end
        return .5
    end
    function ctl.BindEvents()
        ctx.Listen("TrickOrTreatService","Knocked",function(part,_,readyAt)
            if ctl.Stopped or not cfg.Doors or not part then return end
            doorReady[part]=type(readyAt)=="number"and readyAt or ctx.Now()+catalog("Halloween").TrickOrTreat.COOLDOWN
            lastKnock={at=ctx.Now(),position=part.Position,part=part};finish("Doors","Door knock confirmed")
        end)
        ctx.Listen("TrickOrTreatService","Landed",function(_,amount)
            if not ctl.Stopped and cfg.Doors then states.Doors.Candy=(states.Doors.Candy or 0)+P.Number(amount)end
        end)
        ctx.Listen("FusingService","Result",function(result,message)
            if ctl.Stopped or not pending.Fuse then return end
            if not result then pending.Fuse=nil;status("Fuse",message or"Fusion rejected")end
        end)
    end
    function ctl.Tick()
        if ctl.Stopped then return end
        local d=ctx.Snapshot()
        ctl.Report.Ready=d~=nil;ctl.Report.Warnings=ctx.Warnings
        if not d then return end
        ctl.Report.Summary={Money=d.Money,Rolls=d.Rolls,Units=#P.Units(d,catalog("Registry")),Storage=d.Storage,
            Candy=P.Amount(d,(ctx.Catalog.Halloween or{}).CANDY or"Candy"),Pumpkins=P.Amount(d,(ctx.Catalog.Halloween or{}).PUMPKINS or"Pumpkins"),Rebirth=d.Rebirth}
        for _,name in ipairs(jobs)do
            local state=states[name];local waitFor=pending[name]
            if name=="Doors"and cfg[name]and state.Busy and clock()-state.Started>=60 then
                -- Retire a yielded attempt. Its generation check prevents it
                -- from moving or clearing a newer worker when it returns.
                ctl.Generation[name]+=1;state.RunToken=nil;state.Busy=false
                state.Recoveries=(state.Recoveries or 0)+1;state.Next=clock()+1
                pcall(ctx.CancelMovement)
                status(name,"Door route stalled; retrying automatically")
                log(name,state.Status)
            end
            if cfg[name]and waitFor then
                local ok,confirmed=pcall(waitFor.Check,d)
                if ok and confirmed then pending[name]=nil;finish(name,"Confirmed by live data")
                elseif clock()>waitFor.Until then pending[name]=nil;status(name,"No confirmation yet; rechecking live state");state.Next=clock()+3 end
            end
            if cfg[name]and not state.Busy and not pending[name]and clock()>=state.Next then
                local token=ctl.Generation[name];state.Busy=true;state.Started=clock();state.RunToken=token
                ctx.Spawn(function()
                    local result=table.pack(xpcall(function()
                        if valid(name,token)then return handlers[name](name,token,data())end
                    end,debug.traceback))
                    if state.RunToken~=token then return end
                    state.Busy=false;state.Next=clock()+math.max(.25,P.Number(result[2],2))
                    if not result[1]and valid(name,token)then
                        state.Errors+=1;state.LastError=tostring(result[2]):sub(1,700);state.Status="Error: "..state.LastError:match("^[^\n]+")
                        state.Next=clock()+5;log(name,state.LastError)
                    end
                end)
            elseif state.Busy and clock()-state.Started>15 then state.Status="Waiting for request / movement (no duplicate call)"end
        end
    end
    function ctl.Teleport(destination)
        assert(destination=="Island"or destination=="Hub","Unknown destination")
        local resume=destination=="Island"and cfg.Doors;local epoch=stopEpoch
        ctl.Set("Doors",false)
        local generation=ctl.Generation.Doors
        local result=ctx.Invoke("HalloweenService","Teleport",destination)
        if resume and not ctl.Stopped and epoch==stopEpoch and generation==ctl.Generation.Doors then ctl.Set("Doors",true)end
        return result
    end
    function ctl.PumpkinFilter(names)
        local selected={};for _,unit in ipairs(catalog("PumpkinDice").Units or{})do selected[unit.id]=names[unit.id]==true end
        ctx.Spawn(function()
            for name,value in pairs(selected)do
                if ctl.Stopped then return end
                ctx.Fire("PumpkinDiceService","SetAutoSell",name,value);ctx.Wait(.25)
            end
        end)
    end
    function ctl.Protect(kind,names)
        assert(reroll[kind],"Unknown protection type")
        ctx.Spawn(function()for name,value in pairs(names)do
            if ctl.Stopped then return end
            ctx.Fire(kind.."Service","Set"..kind.."Protected",name,value==true);ctx.Wait(.3)
        end end)
    end
    ctl.Jobs=jobs
    return ctl
end

end)()
local makePresentation=(function()
-- Owned UI additions. Native dropdown values and purchase callbacks stay intact.
return function(window,ctx,app,logo)
    local view={Cards={},Language="EN",Collapsed=false}
    local white=Color3.fromRGB(255,255,255);local blue=Color3.fromRGB(164,221,255)
    local muted=Color3.fromRGB(160,178,195);local black=Color3.fromRGB(7,9,13)
    local candyPaths={{7.0,10.0,2.0,7.0,3.0,12.0,2.0,17.0,7.0,14.0},{17.0,10.0,22.0,7.0,21.0,12.0,22.0,17.0,17.0,14.0},{10.0,9.0,12.0,15.0}} -- Generated from assets/devil-candy.svg.
    local discordRects={{22,11,2,1},{39,11,3,1},{18,12,7,1},{39,12,7,1},{15,13,10,1},{30,13,1,1},{32,13,1,1},{38,13,10,1},{13,14,38,1},{12,15,40,1},{11,16,41,1},{11,17,42,1},{10,18,43,1},{9,19,45,2},{8,21,47,2},{8,23,48,1},{7,24,49,1},{7,25,50,1},{6,26,51,2},{6,28,52,1},{5,29,15,1},{25,29,13,1},{44,29,14,1},{5,30,14,1},{26,30,11,1},{45,30,13,2},{5,31,13,3},{46,32,13,4},{27,31,9,6},{4,34,14,3},{45,36,14,2},{4,37,15,1},{26,37,11,1},{4,38,16,1},{25,38,13,1},{44,38,15,1},{4,39,18,1},{23,39,17,1},{42,39,17,1},{4,40,55,5},{4,45,13,1},{19,45,26,1},{46,45,13,1},{5,46,13,1},{21,46,21,1},{46,46,12,1},{7,47,13,1},{25,47,13,1},{44,47,13,1},{8,48,13,1},{42,48,13,1},{10,49,11,1},{43,49,11,1},{12,50,8,1},{43,50,9,1},{14,51,5,1},{44,51,5,1},{17,52,2,1},{45,52,2,1}} -- Offline silhouette from the existing official logo.
    local function node(class,name,parent,props)
        local obj=Instance.new(class);obj.Name=name
        for key,value in pairs(props or{})do obj[key]=value end
        -- Preserve these authored brand colors through the shared theme pass.
        if name=="LogoShape"or name=="CommunityBrand"then obj:SetAttribute("DevilBlueSettings",true)end
        obj.Parent=parent;return obj
    end
    local function label(name,parent,props)
        local defaults={BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=white,
            TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,RichText=false,ZIndex=83}
        for key,value in pairs(props or{})do defaults[key]=value end
        return node("TextLabel",name,parent,defaults)
    end
    local function corner(parent,radius)node("UICorner","Corner",parent,{CornerRadius=UDim.new(0,radius)})end
    function view.Community(host)
        local widget=host:CreateParagraph({Name="DEVIL HUB Community",Content=""})
        local frame=assert(widget._frame,"Community card host unavailable")
        for _,child in ipairs(frame:GetChildren())do child:Destroy()end
        frame.Name="DevilDiscordCommunity";frame.AutomaticSize=Enum.AutomaticSize.None
        frame.Size=UDim2.new(1,0,0,244);frame.BackgroundColor3=black;frame.BackgroundTransparency=.12
        corner(frame,10)
        local icon=node("Frame","DiscordLogo",frame,{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,16),
            Size=UDim2.fromOffset(64,64),BackgroundTransparency=1,ZIndex=3})
        icon:SetAttribute("CustomIcon",true)
        for _,rect in ipairs(discordRects)do
            node("Frame","LogoShape",icon,{Position=UDim2.fromOffset(rect[1],rect[2]),Size=UDim2.fromOffset(rect[3],rect[4]),
                BackgroundColor3=white:Lerp(blue,rect[2]/64),BorderSizePixel=0,ZIndex=3})
        end
        label("CommunityBrand",frame,{Text='<font color="#FFFFFF">DEVIL</font> <font color="#A4DDFF">HUB</font>',RichText=true,
            Font=Enum.Font.GothamBold,TextSize=24,TextXAlignment=Enum.TextXAlignment.Center,
            Position=UDim2.fromOffset(12,88),Size=UDim2.new(1,-24,0,30),ZIndex=3})
        label("CommunityHeading",frame,{Text="Join our Discord",TextColor3=blue,TextSize=14,
            TextXAlignment=Enum.TextXAlignment.Center,Position=UDim2.fromOffset(12,124),Size=UDim2.new(1,-24,0,22),ZIndex=3})
        label("CommunityDescription",frame,{Text="Updates, announcements and community support.",TextColor3=muted,TextSize=12,
            TextWrapped=true,TextTruncate=Enum.TextTruncate.None,TextXAlignment=Enum.TextXAlignment.Center,
            Position=UDim2.fromOffset(20,152),Size=UDim2.new(1,-40,0,36),ZIndex=3})
        local invite=node("TextBox","DiscordInvite",frame,{Text="https://discord.gg/fDwPCmpkkh",TextEditable=false,ClearTextOnFocus=false,
            Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=blue,TextXAlignment=Enum.TextXAlignment.Center,
            Position=UDim2.fromOffset(12,202),Size=UDim2.new(1,-24,0,30),BackgroundColor3=Color3.fromRGB(24,27,33),
            BackgroundTransparency=.15,BorderSizePixel=0,ZIndex=3})
        corner(invite,6)
        view.CommunityCard=frame
    end
    local function line(parent,x1,y1,x2,y2,color,size,z)
        local scale=size/24;local dx,dy=x2-x1,y2-y1
        local part=node("Frame","VectorStroke",parent,{AnchorPoint=Vector2.new(.5,.5),
            Position=UDim2.fromOffset((x1+x2)*scale/2,(y1+y2)*scale/2),
            Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)*scale,1.7*scale),Rotation=math.deg(math.atan2(dy,dx)),
            BackgroundColor3=color,BorderSizePixel=0,ZIndex=z})
        corner(part,2)
    end
    function view.Candy(parent,size,z)
        local canvas=node("Frame","DevilCandyIcon",parent,{BackgroundTransparency=1,Size=UDim2.fromOffset(size,size),Rotation=-25,ZIndex=z})
        canvas:SetAttribute("DevilCandySvg",true)
        local body=node("Frame","CandyBody",canvas,{Position=UDim2.fromOffset(7*size/24,8*size/24),
            Size=UDim2.fromOffset(10*size/24,8*size/24),BackgroundTransparency=1,ZIndex=z})
        corner(body,4*size/24);node("UIStroke","Outline",body,{Color=blue,Thickness=1.7*size/24})
        for i,points in ipairs(candyPaths)do for j=1,#points-2,2 do
            line(canvas,points[j],points[j+1],points[j+2],points[j+3],i==2 and blue or white,size,z)
        end end
        return canvas
    end
    local function imageFor(name)
        local registry=ctx.Catalog.Registry
        local ok,spec=pcall(function()return registry.getEntryConfig(name)end)
        local image=ok and spec and spec.image
        if type(image)=="function"then local worked,value=pcall(image,{});image=worked and value or nil end
        if type(image)=="number"then image="rbxassetid://"..image end
        if type(image)=="string"and image~=""then return image end
        local pass=(ctx.Catalog.Monetization and ctx.Catalog.Monetization.Gamepasses or{})[name]
        if pass and type(pass.image)=="string"then return pass.image end
        local images=ctx.Catalog.Halloween and ctx.Catalog.Halloween.Images or{}
        return images[name]or images[name:gsub("%s","")]
    end
    function view.Item(parent,name,size,z)
        local image=imageFor(name)
        if image then
            local obj=node("ImageLabel","ItemIcon",parent,{Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,
                Image=image,ImageColor3=white,ScaleType=Enum.ScaleType.Fit,ZIndex=z})
            obj:SetAttribute("CustomIcon",true);return obj
        end
        if name=="Candy"then return view.Candy(parent,size,z)end
        return label("ItemIconFallback",parent,{Text="◇",TextColor3=blue,TextSize=size-2,Size=UDim2.fromOffset(size,size),
            TextXAlignment=Enum.TextXAlignment.Center,ZIndex=z})
    end
    local function quantity(value)
        local text=string.format("%.0f",value)
        local result=text:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
        return result
    end
    -- Capture only the popup created by this dropdown; other selectors are untouched.
    local function picker(host,name,selected,default,multiple)
        local before={};if window.Body then for _,child in ipairs(window.Body:GetChildren())do before[child]=true end end
        local widget=host:CreateDropdown({Name=name,Options=default and{default}or{},CurrentOption=multiple and{}or default,MultipleOptions=multiple==true,Searchable=true,PopupWidth=420,
            AllowNone=multiple==true or default==nil,Callback=selected})
        local popup
        if window.Body then for _,child in ipairs(window.Body:GetChildren())do
            if not before[child]and child:IsA("Frame")then popup=child end
        end end
        return widget,popup
    end
    function view.CreateShop(host,selected)
        local widget,popup=picker(host,"Candy shop item",selected)
        view.ShopWidget=widget;view.ShopPopup=popup
        return widget
    end
    local function plainText(text)
        return text:gsub("<[^>]*>",""):gsub("&amp;","&"):gsub("&lt;","<"):gsub("&gt;",">")
    end
    local itemPickers={}
    function view.CreateItems(host,key,name,selected,multiple,default)
        local widget,popup=picker(host,name,selected,default,multiple)
        itemPickers[key]={Widget=widget,Popup=popup,Multiple=multiple,Rows=setmetatable({},{__mode="k"})}
        return widget
    end
    local priorityBuffs={Luck="Luck",Money="Money Multiplier",Damage="Damage Multiplier",Health="Health Multiplier",
        Roll="Roll Duration",Candy="Candy Gain",Pumpkin="Pumpkin Gain"}
    local function priorityImage(name)
        local ok,spec=pcall(function()return ctx.Catalog.BuffConfig.GetBuff(priorityBuffs[name])end)
        if ok and spec and type(spec.image)=="string"then return spec.image end
        local images=ctx.Catalog.Halloween and ctx.Catalog.Halloween.Images or{}
        return images[name=="Pumpkin"and"Pumpkins"or name]
    end
    function view.RefreshItems(key,names,offers)
        local pickerInfo=itemPickers[key];if not pickerInfo then return end
        pickerInfo.Widget:Refresh(names,true,true)
        if not pickerInfo.Popup then return end
        local wanted={};for _,name in ipairs(names)do wanted[name]=true end
        local prices={};for _,offer in ipairs(offers or{})do prices[offer.name]=offer end
        for _,text in ipairs(pickerInfo.Popup:GetDescendants())do
            if text:IsA("TextLabel")and text.Parent and text.Parent:IsA("TextButton")then
                local name=plainText(text.Text)
                if wanted[name]then
                    local row=pickerInfo.Rows[text]
                    if not row then
                        row={};pickerInfo.Rows[text]=row
                        local left=pickerInfo.Multiple and 62 or 42
                        text.Position=UDim2.fromOffset(left,0);text.Size=UDim2.new(1,-(left+30+(offers and 110 or 0)),1,0)
                        local image=key=="GearPriority"and priorityImage(name)or nil
                        if image then
                            row.Icon=node("ImageLabel","PriorityIcon",text.Parent,{Image=image,ImageColor3=white,BackgroundTransparency=1,
                                Size=UDim2.fromOffset(22,22),ScaleType=Enum.ScaleType.Fit,ZIndex=text.ZIndex+1})
                            row.Icon:SetAttribute("CustomIcon",true)
                        else row.Icon=view.Item(text.Parent,name,22,text.ZIndex+1)end
                        row.Icon.AnchorPoint=Vector2.new(0,.5);row.Icon.Position=UDim2.new(0,pickerInfo.Multiple and 34 or 13,.5,0)
                        if offers then
                            row.Price=label("TicketPrice",text.Parent,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-29,.5,0),
                                Size=UDim2.fromOffset(102,22),TextColor3=blue,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                        end
                    end
                    if row.Price and prices[name]then
                        local offer=prices[name]
                        row.Price.Text=quantity(tonumber(offer.tickets)or 0).." Tickets"
                    end
                end
            end
        end
    end
    local shopRows=setmetatable({},{__mode="k"})
    function view.RefreshShop(offers)
        local names,map={},{}
        for _,offer in ipairs(offers or{})do names[#names+1]=offer.name;map[offer.name]=offer end
        view.ShopWidget:Refresh(names,true,true)
        local popup=view.ShopPopup;if not popup then return end
        for _,text in ipairs(popup:GetDescendants())do
            if text:IsA("TextLabel")and text.Parent and text.Parent:IsA("TextButton")then
                local plain=plainText(text.Text)
                local offer=map[plain]
                if offer then
                    local row=shopRows[text]
                    if not row then
                        row={};shopRows[text]=row
                        text.Position=UDim2.fromOffset(42,0);text.Size=UDim2.new(1,-158,1,0)
                        row.Icon=view.Item(text.Parent,plain,22,text.ZIndex+1)
                        row.Icon.AnchorPoint=Vector2.new(0,.5);row.Icon.Position=UDim2.new(0,13,.5,0)
                        local cost=node("Frame","CandyPrice",text.Parent,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-29,.5,0),
                            Size=UDim2.fromOffset(80,22),BackgroundTransparency=1,ZIndex=text.ZIndex+1})
                        local candy=view.Candy(cost,19,text.ZIndex+1);candy.Position=UDim2.fromOffset(0,1)
                        row.Cost=label("CandyAmount",cost,{Size=UDim2.new(1,-21,1,0),Position=UDim2.fromOffset(21,0),
                            TextColor3=blue,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                    end
                    row.Cost.Text=quantity(tonumber(offer.candy)or 0)
                end
            end
        end
    end
    local diceRows=setmetatable({},{__mode="k"});local diceSpecs={};local diceData
    local function dicePrice(value)
        if type(value)~="number"then return view.Language=="TH"and"ฟรี"or"Free"end
        if value<1e6 then return "$"..quantity(value)end
        for _,suffix in ipairs({{1e18,"Qi"},{1e15,"Qa"},{1e12,"T"},{1e9,"B"},{1e6,"M"}})do
            if value>=suffix[1]and value<suffix[1]*1000 then return "$"..string.format("%.3g",value/suffix[1])..suffix[2]end
        end
        return "$"..string.format("%.3g",value)
    end
    function view.CreateDice(host,selected)
        local widget,popup=picker(host,"Dice selection",selected,"Best affordable")
        view.DiceWidget=widget;view.DicePopup=popup;return widget
    end
    function view.UpdateDiceState(data)
        if not data then return end;diceData=data
        for _,row in pairs(diceRows)do
            local equipped=data.Dice==row.Name
            local owned=equipped or(data.OwnedDice or{})[row.Name]==true
            row.Price.Text=dicePrice(row.Spec.price)
            row.State.Text=equipped and(view.Language=="TH"and"กำลังใช้อยู่"or"Equipped")
                or owned and(view.Language=="TH"and"ซื้อแล้ว"or"Purchased")
                or(view.Language=="TH"and"ยังไม่ได้ซื้อ"or"Not purchased")
            row.State.TextColor3=equipped and blue or owned and white or muted
        end
    end
    function view.RefreshDice(catalog,data)
        diceSpecs=catalog and catalog.GetAll()or{}
        local names={};for name in pairs(diceSpecs)do names[#names+1]=name end
        table.sort(names,function(a,b)
            local x,y=tonumber(diceSpecs[a].luck)or 0,tonumber(diceSpecs[b].luck)or 0
            return x==y and a<b or x<y
        end)
        table.insert(names,1,"Best affordable");view.DiceWidget:Refresh(names,true,true)
        if view.DicePopup then for _,text in ipairs(view.DicePopup:GetDescendants())do
            if text:IsA("TextLabel")and text.Parent and text.Parent:IsA("TextButton")then
                local name=plainText(text.Text);local spec=diceSpecs[name]
                if spec then
                    local row=diceRows[text]
                    if not row then
                        row={Name=name,Spec=spec};diceRows[text]=row
                        text.Position=UDim2.fromOffset(42,0);text.Size=UDim2.new(1,-198,1,0)
                        local icon=node("ImageLabel","DiceIcon",text.Parent,{AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,13,.5,0),
                            Size=UDim2.fromOffset(22,22),Image=spec.image or"",ImageColor3=white,BackgroundTransparency=1,
                            ScaleType=Enum.ScaleType.Fit,ZIndex=text.ZIndex+1})
                        icon:SetAttribute("CustomIcon",true)
                        local state=node("Frame","DicePrice",text.Parent,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-29,.5,0),
                            Size=UDim2.fromOffset(120,28),BackgroundTransparency=1,ZIndex=text.ZIndex+1})
                        row.Price=label("MoneyPrice",state,{Size=UDim2.new(1,0,0,14),TextSize=11,TextColor3=blue,
                            TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                        row.State=label("Ownership",state,{Position=UDim2.fromOffset(0,14),Size=UDim2.new(1,0,0,14),TextSize=10,
                            TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                    end
                    row.Spec=spec
                end
            end
        end end
        view.UpdateDiceState(data)
    end
    view.Root=node("Frame","DevilTowerRewardStack",window.Gui,{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,12),
        Size=UDim2.fromOffset(260,240),BackgroundTransparency=1,ZIndex=80})
    local function remove(index)
        local card=table.remove(view.Cards,index)
        if card then
            if card.Link then card.Link:Disconnect()end
            if card.CollapseLink then card.CollapseLink:Disconnect()end
            card.Frame:Destroy()
        end
    end
    local function viewport()
        local camera=workspace.CurrentCamera
        return camera and camera.ViewportSize or Vector2.new(1280,720)
    end
    local function updateText(card)
        card.Stage.Text=card.Event.Tower.."  ·  "..(view.Language=="TH"and"ชั้น "or"Floor ")..tostring(card.Event.Floor)
        if card.Empty then card.Empty.Text=view.Language=="TH"and"ไม่มีไอเท็มดรอปในชั้นนี้"or"No drops this floor"end
    end
    function view.SetLanguage(language,data)
        view.Language=language=="TH"and"TH"or"EN"
        for _,card in ipairs(view.Cards)do updateText(card)end
        view.UpdateDiceState(data or diceData)
    end
    function view.Tick(now)
        if app.Stopped then return end
        for i=#view.Cards,1,-1 do if view.Cards[i].Expires<=now then remove(i)end end
        local screen=viewport();local maxCards=(screen.X<500 or screen.Y<500)and 1 or 2
        while #view.Cards>maxCards do remove(#view.Cards)end
        local width=math.max(180,math.min(260,screen.X-24));local height=math.max(100,screen.Y-24)
        view.Root.Size=UDim2.fromOffset(width,height)
        local bodyMax=math.max(20,math.min(60,(height-6*(maxCards-1))/maxCards-56))
        local y=0
        for _,card in ipairs(view.Cards)do
            local body=math.min(bodyMax,math.max(1,#card.Event.Items)*20)
            local cardHeight=view.Collapsed and 50 or 56+body
            card.Frame.Position=UDim2.fromOffset(0,y);card.Frame.Size=UDim2.new(1,0,0,cardHeight)
            card.List.Visible=not view.Collapsed
            card.Collapse.Text=view.Collapsed and"+"or"−"
            card.List.Size=UDim2.new(1,-16,0,body)
            card.Timer.Size=UDim2.new(math.clamp((card.Expires-now)/7,0,1),0,0,2)
            y+=cardHeight+6
        end
    end
    function view.SetCollapsed(value)
        if app.Stopped then return end
        view.Collapsed=value==true
        -- Keep the setting for subsequent floors, and give an expanded card
        -- enough time to read after clicking near its original expiry.
        local now=os.clock()
        for _,card in ipairs(view.Cards)do card.Expires=now+7 end
        view.Tick(now)
    end
    function view.Notify(event)
        if app.Stopped then return end
        local frame=node("Frame","DevilTowerRewardCard",view.Root,{BackgroundColor3=black,BackgroundTransparency=.1,BorderSizePixel=0,ZIndex=81})
        corner(frame,9);node("UIStroke","Border",frame,{Color=blue,Transparency=.55,Thickness=1})
        if logo then node("ImageLabel","DevilHubLogo",frame,{Position=UDim2.fromOffset(8,6),Size=UDim2.fromOffset(18,18),
            Image=logo,ImageColor3=white,BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,ZIndex=83})
        else label("DevilHubLogo",frame,{Text="D",TextSize=17,TextColor3=white,Position=UDim2.fromOffset(8,5),Size=UDim2.fromOffset(18,20)})end
        label("Brand",frame,{Text="DEVIL HUB",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=blue,Position=UDim2.fromOffset(34,6),Size=UDim2.new(1,-90,0,18)})
        local stage=label("Stage",frame,{Position=UDim2.fromOffset(8,27),Size=UDim2.new(1,-16,0,18),TextSize=11,Font=Enum.Font.GothamMedium})
        local list=node("ScrollingFrame","Rewards",frame,{Position=UDim2.fromOffset(8,49),BackgroundTransparency=1,BorderSizePixel=0,
            ScrollBarThickness=2,ScrollBarImageColor3=blue,CanvasSize=UDim2.fromOffset(0,math.max(1,#event.Items)*20),ZIndex=82})
        local card={Frame=frame,Stage=stage,List=list,Event=event,Expires=os.clock()+7}
        if #event.Items==0 then card.Empty=label("EmptyRewards",list,{Text="",TextSize=11,TextColor3=muted,Size=UDim2.new(1,-4,0,18)})end
        for i,item in ipairs(event.Items)do
            local row=node("Frame","RewardItem",list,{Position=UDim2.fromOffset(0,(i-1)*20),Size=UDim2.new(1,-4,0,18),BackgroundTransparency=1,ZIndex=83})
            view.Item(row,item.Name,18,84)
            label("ItemName",row,{Text=item.Name,TextSize=11,Position=UDim2.fromOffset(24,0),Size=UDim2.new(1,-84,1,0)})
            label("ItemAmount",row,{Text="×"..quantity(item.Amount),TextSize=11,TextColor3=blue,Position=UDim2.new(1,-58,0,0),Size=UDim2.fromOffset(58,18),TextXAlignment=Enum.TextXAlignment.Right})
        end
        card.Timer=node("Frame","Lifetime",frame,{Position=UDim2.new(0,0,1,-2),BackgroundColor3=blue,BorderSizePixel=0,ZIndex=83})
        card.Collapse=node("TextButton","Collapse",frame,{Text="−",Font=Enum.Font.Gotham,TextSize=16,TextColor3=blue,
            AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-27,0,4),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,ZIndex=85})
        card.CollapseLink=card.Collapse.MouseButton1Click:Connect(function()view.SetCollapsed(not view.Collapsed)end)
        local close=node("TextButton","Dismiss",frame,{Text="×",Font=Enum.Font.Gotham,TextSize=16,TextColor3=white,
            AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-5,0,4),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,ZIndex=85})
        card.Link=close.MouseButton1Click:Connect(function()
            local index=table.find(view.Cards,card);if index then remove(index);view.Tick(os.clock())end
        end)
        table.insert(view.Cards,1,card);updateText(card);view.Tick(os.clock())
    end
    function view.Destroy()
        for i=#view.Cards,1,-1 do remove(i)end
        view.Root:Destroy();ctx.OnTowerReward=nil
    end
    ctx.OnTowerReward=view.Notify
    return view
end

end)()
local makeSettings=(function()
-- Local, account/map-specific configuration. No remote storage or executable data.
return function(core,ctx)
    local cfg=core.Config
    local function copy(value)
        if type(value)~="table"then return value end
        local out={};for k,v in pairs(value)do out[k]=copy(v)end;return out
    end
    local defaults=copy(cfg);local jobs={}
    for _,name in ipairs(core.Jobs)do jobs[name]=true end
    local userId,placeId=tonumber(ctx.UserId),tonumber(ctx.PlaceId)
    local identity=userId and userId>0 and placeId and placeId>0
    local file=identity and("DevilHub-AnimeDice-"..userId.."-"..placeId..".json")or nil
    local http=game:GetService("HttpService")
    local api={Report={Status="No saved settings loaded yet.",File=file},Restored=false}
    core.Report.SavedSettings=api.Report
    local function report(ok,message,detail)
        api.Report.Status=message;api.Report.Error=detail and tostring(detail)or nil
        return ok,message
    end
    local function values(input)
        assert(type(input)=="table","Invalid settings values")
        local result=copy(defaults)
        for key,default in pairs(defaults)do
            local value=input[key]
            if value~=nil then
                local kind=type(default)
                assert(type(value)==kind,"Invalid setting type: "..key)
                if kind=="number"then
                    assert(value==value and value>=0 and value<math.huge,"Invalid number: "..key)
                elseif kind=="string"then
                    assert(#value<=4096,"Setting too long: "..key)
                elseif kind=="table"then
                    local count=0
                    for k,v in pairs(value)do
                        count+=1;assert(count<=4096,"Too many selections: "..key)
                        if key=="CodeList"then
                            assert(type(k)=="number"and k>=1 and k%1==0 and k<=#value and type(v)=="string"and #v<=4096,"Invalid code list")
                        else
                            assert(type(k)=="string"and #k<=4096 and type(v)=="boolean","Invalid selection: "..key)
                        end
                    end
                    if key=="CodeList"then assert(count==#value,"Invalid code list")end
                end
                result[key]=copy(value)
            end
        end
        return result
    end
    local function write(input)
        if not file then return report(false,"Waiting for player identity.")end
        if type(writefile)~="function"then return report(false,"Saving unavailable on this executor.")end
        local ok,err=pcall(function()
            local text=http:JSONEncode({Schema=1,UserId=userId,PlaceId=placeId,Values=values(input)})
            assert(#text<=1048576,"Settings file too large")
            writefile(file,text)
        end)
        if not ok then return report(false,"Settings could not be saved.",err)end
        return report(true,"Settings saved. They will load next run.")
    end
    local function apply(input,afterValues,reset)
        if not ctx.Ready and not reset then return report(false,"Waiting for game data.")end
        local ok,err=pcall(function()
            core.StopAll()
            for key,value in pairs(input)do if not jobs[key]then cfg[key]=copy(value)end end
            if afterValues then afterValues()end
            for _,name in ipairs(core.Jobs)do core.Set(name,input[name]==true)end
            api.Restored=true
        end)
        if not ok then return report(false,"Settings could not be applied.",err)end
        return report(true,"Saved settings loaded.")
    end
    function api.Save()return write(cfg)end
    function api.Load(afterValues)
        if not ctx.Ready or type(ctx.Snapshot)=="function"and not ctx.Snapshot()then return report(false,"Waiting for game data.")end
        if not file then return report(false,"Waiting for player identity.")end
        if type(readfile)~="function"then return report(false,"Loading unavailable on this executor.")end
        if type(isfile)=="function"then
            local ok,exists=pcall(isfile,file)
            if ok and not exists then return report(false,"No saved settings found.")end
        end
        local ok,input=pcall(function()
            local text=readfile(file)
            assert(type(text)=="string"and #text<=1048576,"Invalid settings file")
            local saved=http:JSONDecode(text)
            assert(type(saved)=="table"and saved.Schema==1,"Unknown settings format")
            assert(saved.UserId==userId and saved.PlaceId==placeId,"Settings belong to another player or map")
            return values(saved.Values)
        end)
        if not ok then return report(false,"Saved settings could not be read.",input)end
        return apply(input,afterValues)
    end
    function api.Reset(afterValues)
        local ok,message=write(defaults)
        if not ok then return ok,message end
        ok,message=apply(copy(defaults),afterValues,true)
        if not ok then return ok,message end
        return report(true,"Saved settings reset.")
    end
    return api
end

end)()
local ctx=makeAdapter(scope)
local core=makeCore(ctx,planner)
local cfg=core.Config
local saved=makeSettings(core,ctx)
local app={Core=core,Config=cfg,Report=core.Report,Version=core.Report.Version,Stopped=false}
local window,library,presentation
local links,widgets,optionWidgets,valueWidgets={}, {}, {}, {}
local autoLoadPending=true
local controlsReady=false
local function changed()if controlsReady then autoLoadPending=false end end
local function destroy()
    if app.Stopped then return end
    app.Stopped=true;core.Destroy()
    if presentation then presentation.Destroy()end
    for _,link in ipairs(links)do link:Disconnect()end
    if window then window:Destroy()end
    if scope.DevilAnimeDiceTest==app then scope.DevilAnimeDiceTest=nil end
    if scope.DevilAnimeDiceStarting==startup then scope.DevilAnimeDiceStarting=nil end
end
app.Destroy=destroy
local ok,problem=xpcall(function()
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

    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    assert(type(source)=="string"and #source==402130,"GUI download size mismatch")
    local checksum=0;for i=1,#source do checksum=(checksum*33+source:byte(i))%4294967296 end
    assert(checksum==1125396239,"GUI download checksum mismatch")
    local run,err=loadstring(source,"DEVIL HUB / Anime Dice GUI");assert(run,err)
    library=run()
    assert(scope.DevilAnimeDiceStarting==startup,"Startup replaced by a newer run")
    local image=scope.DevilHubSilverLogo
    if not image then pcall(function()
        local asset=getcustomasset or getsynasset
        if type(asset)~="function"or type(writefile)~="function"then return end
        local bytes=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/assets/devil-logo-silver-transparent.png")
        assert(bytes:sub(1,8)=="\137PNG\13\10\26\10","Logo download failed")
        writefile("DevilHub_Silver_AnimeDice.png",bytes)
        image=asset("DevilHub_Silver_AnimeDice.png");scope.DevilHubSilverLogo=image
    end)end
    local theme={Background=Color3.fromRGB(7,9,13),Surface=Color3.fromRGB(11,13,18),Surface2=Color3.fromRGB(16,19,25),
        Surface3=Color3.fromRGB(32,39,49),Accent=Color3.fromRGB(164,221,255),Text=Color3.fromRGB(255,255,255),
        Muted=Color3.fromRGB(153,169,185),Warning=Color3.fromRGB(164,221,255)}
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,LoadingSubtitle="ANIME DICE",
        Theme=theme,Density="Compact",Profile=true,Search=true,Home=false,Loading=false,Backdrop=false,
        UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(840,570),
        ToggleButton={Platform="Both",Icon=image},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false}})
    app.Window=window;window.Gui:SetAttribute("DevilHubPresentation",true)
    presentation=makePresentation(window,ctx,app,image);app.Presentation=presentation
    links[#links+1]=window.Gui.Destroying:Connect(destroy)
    local function group(tab,name,side)return tab:CreateGroupbox({Name=name,Side=side or"Left"})end
    local function tab(name,icon)return window:CreateTab({Name=name,Icon=icon,Backdrop=false})end
    local function toggle(host,key,name)
        local widget=host:CreateToggle({Name=name,CurrentValue=false,Callback=function(v)changed();core.Set(key,v)end})
        widgets[key]=widget;return widget
    end
    local function input(host,key,name,default)
        local widget=host:CreateInput({Name=name,CurrentValue=tostring(default or cfg[key]),Callback=function(v)
            changed()
            local parse=key:find("Chance",1,true)and planner.Chance or planner.Number
            cfg[key]=parse(v,cfg[key])
        end})
        valueWidgets[key]=widget;return widget
    end
    local function multi(value)
        local set={};for k,v in pairs(value or{})do local name=type(k)=="number"and v or v==true and k;if type(name)=="string"then set[name]=true end end
        return set
    end
    local function dropdown(host,key,name,options,default,multiple,convert)
        local widget=host:CreateDropdown({Name=name,Options=options or{},CurrentOption=multiple and{}or default,MultipleOptions=multiple,
            AllowNone=multiple==true,Searchable=true,Callback=function(v)
                changed()
                if multiple then cfg[key]=multi(v)else cfg[key]=convert and convert(v)or v end
            end})
        optionWidgets[key]=widget;return widget
    end
    local function button(host,name,fn)
        return host:CreateButton({Name=name,Callback=function()
            ctx.Spawn(function()
                local success,err=xpcall(fn,debug.traceback)
                if not success then core.Report.LastUIError=tostring(err);warn("DEVIL HUB: "..tostring(err))end
            end)
        end})
    end
    local main=tab("Farm","sprout")
    local farm=group(main,"Farm controls")
    toggle(farm,"Roll","Auto Roll")
    toggle(farm,"Collect","Auto Collect Money")
    toggle(farm,"EquipBase","Auto Equip Best Base")
    toggle(farm,"Level","Auto Level Units")
    input(farm,"LevelCap","Maximum unit level")
    local buy=group(main,"Dice and upgrades","Right")
    toggle(buy,"Dice","Auto Buy / Equip Dice")
    optionWidgets.DiceChoice=presentation.CreateDice(buy,function(name)changed();cfg.DiceChoice=name end)
    toggle(buy,"Upgrade","Auto Upgrade Tree")
    dropdown(buy,"UpgradeBranch","Upgrade branch",{"All","Money","Luck","Damage","Health","Unit Storage","Roll","Trait","Grade"},"All")
    input(buy,"MoneyReserve","Money reserve")
    local overview=group(main,"Live status","Right")
    local summary=overview:CreateLabel({Text="Connecting game modules..."})
    local resultLabel=overview:CreateLabel({Text="All automation starts off."})
    local function stopAll()changed();core.StopAll()end
    button(overview,"Stop all automation",stopAll)
    local inventory=tab("Inventory","backpack")
    local sell=group(inventory,"Sell and protect")
    toggle(sell,"Sell","Auto Sell All Unused Units")
    dropdown(sell,"SellRarities","Rarities to sell (empty = all)",{},nil,true)
    sell:CreateLabel({Text="Select rarities to sell only those tiers. Clear every selection to Sell All Unused."})
    sell:CreateParagraph({Name="Sell All Unused",Content="Sells all unused units, including rare and mutated units. Keeps plotted, Tower team, carried, locked, favorite and explicitly kept units."})
    dropdown(sell,"KeepNames","Keep character names",{},nil,true)
    local keepIdLabels={}
    -- The callback maps friendly labels back to current live inventory IDs.
    local function mapIds(selected)
        changed()
        local set={};for label in pairs(multi(selected))do if keepIdLabels[label]then set[keepIdLabels[label]]=true end end;cfg.KeepIds=set
    end
    local keepWidget=sell:CreateDropdown({Name="Keep specific units",Options={},CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,Callback=mapIds})
    optionWidgets.KeepIds=keepWidget
    local sellStatus=sell:CreateLabel({Text="Sell All Unused: waiting for live inventory."})
    local preview=sell:CreateLabel({Text="Preview matching units before selling or fusing."})
    button(sell,"Preview sale",function()
        local items=core.Preview("Sell");local names={}
        for i=1,math.min(8,#items)do names[#names+1]=items[i].name.." | "..(items[i].rarity or"Unknown").." | 1 / "..string.format("%.3g",items[i].chance)end
        preview:Set(tostring(#items).." matching units\n"..table.concat(names,"\n"))
    end)
    local materials=group(inventory,"Lock and fusion","Right")
    toggle(materials,"Lock","Auto Lock Rare Units")
    input(materials,"LockChanceMin","Lock minimum chance (0 = off)")
    toggle(materials,"Fuse","Auto Fuse Surplus Units")
    input(materials,"FuseChanceMax","Fuse maximum chance (0 = off)")
    input(materials,"KeepBest","Keep best units for fusion")
    input(materials,"KeepCopies","Keep copies per character for fusion")
    valueWidgets.SkipMutations=materials:CreateToggle({Name="Keep mutated / variant units for fusion",CurrentValue=true,Callback=function(v)changed();cfg.SkipMutations=v end})
    button(materials,"Preview fusion",function()
        local items=core.Preview("Fuse");local names={}
        for i=1,math.min(3,#items)do names[#names+1]=items[i].name.." | "..items[i].id:sub(1,8)end
        preview:Set("Fusion candidates: "..#items.."\n"..table.concat(names,"\n"))
    end)
    materials:CreateParagraph({Name="Material filters",Content="Locked, plotted, team and kept units are excluded. Fusion consumes three units. Set chance limits before enabling."})
    local towerTab=tab("Towers","swords")
    local towers=group(towerTab,"Tower farming")
    dropdown(towers,"TowerChoice","Tower selection",{},nil)
    toggle(towers,"Tower","Auto Tower")
    button(towers,"Equip Best Tower Team",function()ctx.Fire("Towers","EquipBestTowerTeam")end)
    towers:CreateParagraph({Name="Tower timing",Content="Uses the actual server battle results and game timing. Only one Tower or Haunted House runs at a time."})
    local rebirth=group(towerTab,"Rebirth and points","Right")
    toggle(rebirth,"Rebirth","Auto Rebirth")
    input(rebirth,"RebirthLimit","Stop at rebirth")
    rebirth:CreateLabel({Text="Rebirth resets your cash to zero."})
    dropdown(rebirth,"StatChoice","Rebirth stat",{"Luck","Money","Damage","Health","Trait Luck","Grade Luck"},"Luck")
    toggle(rebirth,"Stats","Auto Allocate Rebirth Points")
    button(rebirth,"Use one reset token",function()
        local d=ctx.Snapshot();assert(d,"Waiting for data")
        assert(planner.Amount(d,"Reset Token")>0,"No reset tokens")
        ctx.Fire("RebirthService","UseResetToken")
    end)
    local rerollTab=tab("Rerolls","sparkles")
    local target=group(rerollTab,"Selected unit")
    local unitLabels={}
    local unitPicker=target:CreateDropdown({Name="Unit selection",Options={},AllowNone=true,Searchable=true,Callback=function(v)
        changed()
        core.Set("Trait",false);core.Set("Grade",false);core.Set("Quirk",false);cfg.SelectedUnit=unitLabels[v]or""
    end})
    input(target,"RerollLimit","Reroll request limit")
    button(target,"Equip selected unit",function()assert(cfg.SelectedUnit~="","Select a unit");ctx.Invoke("UnitService","Equip",cfg.SelectedUnit)end)
    button(target,"Put unit back",function()ctx.Invoke("UnitService","Unequip")end)
    local rolls=group(rerollTab,"Reroll targets","Right")
    for _,kind in ipairs({"Trait","Grade","Quirk"})do
        dropdown(rolls,kind.."Targets",kind.." targets",{},nil,true)
        toggle(rolls,kind,"Auto "..kind)
    end
    local protection=group(rerollTab,"Game protection")
    local protectedChoices={Trait=cfg.ProtectedTraits,Grade=cfg.ProtectedGrades,Quirk=cfg.ProtectedQuirks}
    local protectionWidgets={}
    for _,kind in ipairs({"Trait","Grade","Quirk"})do
        protectionWidgets[kind]=protection:CreateDropdown({Name="Protect "..kind,Options={},CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,
            Callback=function(v)changed();protectedChoices[kind]=multi(v);cfg['Protected'..kind..'s']=protectedChoices[kind]end})
        button(protection,"Apply "..kind.." protection",function()
            local c=ctx.Catalog[kind=="Trait"and"Traits"or kind=="Grade"and"Grades"or"Quirks"]or{}
            local values={};for name in pairs(c)do values[name]=protectedChoices[kind][name]==true end;core.Protect(kind,values)
        end)
    end
    local items=tab("Items and rewards","gift")
    local use=group(items,"Items and gear")
    optionWidgets.BoostNames=presentation.CreateItems(use,"BoostNames","Boosts to use",function(v)changed();cfg.BoostNames=multi(v)end,true)
    toggle(use,"Boost","Auto Use Selected Boosts")
    optionWidgets.SpinNames=presentation.CreateItems(use,"SpinNames","Spins to use",function(v)changed();cfg.SpinNames=multi(v)end,true)
    toggle(use,"Spin","Auto Use Selected Spins")
    optionWidgets.GearPriority=presentation.CreateItems(use,"GearPriority","Gear priority",function(v)changed();cfg.GearPriority=v end,false,"Luck")
    toggle(use,"Gear","Auto Equip Gear")
    local rewards=group(items,"Rewards and codes","Right")
    toggle(rewards,"Rewards","Auto Claim Daily / Group / Offline")
    toggle(rewards,"Quests","Auto Claim Completed Quests")
    optionWidgets.QuestOffer=presentation.CreateItems(rewards,"QuestOffer","Quest shop item",function(v)cfg.QuestOffer=v end,false)
    input(rewards,"QuestLimit","Quest purchase limit")
    input(rewards,"TicketReserve","Tickets reserve")
    toggle(rewards,"QuestShop","Auto Buy Quest Shop Item")
    valueWidgets.CodeList=rewards:CreateInput({Name="Codes (comma separated)",CurrentValue="",Callback=function(v)
        changed()
        cfg.CodeList={};for code in tostring(v):gmatch("[^,%s]+")do cfg.CodeList[#cfg.CodeList+1]=code end
    end})
    toggle(rewards,"Codes","Auto Redeem Entered Codes")
    local halloween=tab("Halloween","flame")
    local eventFarm=group(halloween,"Pumpkin Dice")
    toggle(eventFarm,"Pumpkin","Auto Pumpkin Dice")
    dropdown(eventFarm,"PumpkinCount","Roll count",{"1","5"},"1",false,tonumber)
    input(eventFarm,"PumpkinReserve","Pumpkins reserve")
    dropdown(eventFarm,"PumpkinSellNames","Pumpkin units to auto sell",{},nil,true)
    button(eventFarm,"Apply Pumpkin sell filter",function()core.PumpkinFilter(cfg.PumpkinSellNames)end)
    local eventTower=group(halloween,"Haunted House","Right")
    dropdown(eventTower,"WingChoice","Haunted wing",{},"Front Yard")
    toggle(eventTower,"Haunted","Auto Haunted House")
    button(eventTower,"Travel to Halloween Island",function()core.Teleport("Island")end)
    button(eventTower,"Return to Hub",function()core.Teleport("Hub")end)
    local candy=group(halloween,"Trick or Treat")
    toggle(candy,"Doors","Auto Trick or Treat")
    button(candy,"Start Event Collection",function()
        changed()
        for _,key in ipairs({"Doors","Pass","EventQuests"})do core.Set(key,true);widgets[key]:Set(true,true)end
    end)
    button(candy,"Stop Event Collection",function()
        changed()
        for _,key in ipairs({"Doors","Pass","EventQuests"})do core.Set(key,false);widgets[key]:Set(false,true)end
    end)
    candy:CreateParagraph({Name="Door route",Content="Teleports to ground at each event door and waits for server travel limits, cooldown and confirmed rewards."})
    local pass=group(halloween,"Pass and event quests","Right")
    toggle(pass,"Pass","Auto Claim Pumpkin Pass")
    toggle(pass,"EventQuests","Auto Claim Halloween Quests")
    local shop=group(halloween,"Candy shop")
    optionWidgets.OfferChoice=presentation.CreateShop(shop,function(name)changed();cfg.OfferChoice=name end)
    input(shop,"OfferLimit","Purchase limit")
    input(shop,"CandyReserve","Candy reserve")
    toggle(shop,"CandyShop","Auto Buy Candy Shop Item")
    local settings=tab("Settings","settings")
    local savedGroup=group(settings,"Saved settings")
    local savedStatus=savedGroup:CreateLabel({Text="No saved settings loaded yet."})
    savedGroup:CreateParagraph({Name="Restore settings",Content="Save filters, item choices and enabled automation. Saved settings load automatically next run."})
    local reportGroup=group(settings,"Test report")
    local statuses={}
    for _,name in ipairs(core.Jobs)do statuses[name]=reportGroup:CreateLabel({Text=name..": Off"})end
    local actions=group(settings,"Test controls","Right")
    button(actions,"Stop all automation",stopAll)
    button(actions,"Copy / save test report",function()
        local text=game:GetService("HttpService"):JSONEncode(core.Report)
        if type(setclipboard)=="function"then pcall(setclipboard,text)end
        if type(writefile)=="function"then pcall(writefile,"DevilHub-AnimeDice-test-report.json",text)end
        print(text)
    end)
    valueWidgets.UseNativeRoll=actions:CreateToggle({Name="Use game Auto Roll",CurrentValue=true,Callback=function(v)changed();core.Set("Roll",false);cfg.UseNativeRoll=v end})
    button(actions,"Close test",destroy)
    actions:CreateParagraph({Name="Anime Dice",Content="Automation starts off without a saved profile. Saved settings restore after game data is ready."})
    local discord=tab("Discord","users")
    local community=group(discord,"DEVIL HUB Community")
    presentation.Community(community)
    local inviteStatus=community:CreateLabel({Text="Invite ready to copy."})
    community:CreateButton({Name="Copy Discord Invite",Icon="copy",Style="Primary",Callback=function()
        if app.Stopped then return end
        local copy=setclipboard or toclipboard
        local copied=type(copy)=="function"and pcall(copy,"https://discord.gg/fDwPCmpkkh")
        inviteStatus:Set(copied and"Discord invite copied!"or"Clipboard unavailable. Select and copy the invite above.")
    end})
    local news=group(discord,"Stay connected","Right")
    news:CreateParagraph({Name="Updates and announcements",Content="New releases, supported games and DEVIL HUB news."})
    news:CreateParagraph({Name="Support and feedback",Content="Report bugs, share suggestions and connect with the community."})
    local function keys(t)
        local list={};for name in pairs(t or{})do if type(name)=="string"then list[#list+1]=name end end;table.sort(list);return list
    end
    local protectionInitialized={};local pumpkinFilterInitialized=false
    local function refreshOptions()
        if not ctx.Ready or app.Stopped then return end
        local c=ctx.Catalog;local d=ctx.Snapshot();if not d then return end
        local function options(key,values)
            if optionWidgets[key]then optionWidgets[key]:Refresh(values,true,true)end
        end
        presentation.RefreshDice(c.Dice,d)
        local towerNames,wingNames={},{}
        if c.Towers then for name,tower in pairs(c.Towers.GetAll())do if not tower.event then towerNames[#towerNames+1]=name end end end;table.sort(towerNames)
        for _,wing in ipairs(c.HauntedHouse and c.HauntedHouse.Wings or{})do wingNames[#wingNames+1]=wing.name end
        options("TowerChoice",towerNames);options("WingChoice",wingNames)
        for _,kind in ipairs({"Trait","Grade","Quirk"})do
            local values=keys(c[kind=="Trait"and"Traits"or kind=="Grade"and"Grades"or"Quirks"])
            options(kind.."Targets",values);protectionWidgets[kind]:Refresh(values,true,true)
            if not protectionInitialized[kind]then
                protectionInitialized[kind]=true;local chosen={}
                for name,value in pairs(d["Protected"..(kind=="Trait"and"Traits"or kind=="Grade"and"Grades"or"Quirks")]or{})do
                    if value then chosen[#chosen+1]=name;protectedChoices[kind][name]=true end
                end
                cfg['Protected'..kind..'s']=protectedChoices[kind]
                protectionWidgets[kind]:Set(chosen,true)
            end
        end
        presentation.RefreshShop(c.HalloweenShop)
        local questOffers={};for _,offer in ipairs(c.Quest and c.Quest.Shop or{})do questOffers[#questOffers+1]=offer.name end
        presentation.RefreshItems("QuestOffer",questOffers,c.Quest and c.Quest.Shop or{})
        presentation.RefreshItems("GearPriority",{"Luck","Money","Damage","Health","Roll","Candy","Pumpkin"})
        local pumpkinNames={};for _,unit in ipairs(c.PumpkinDice and c.PumpkinDice.Units or{})do pumpkinNames[#pumpkinNames+1]=unit.id end;options("PumpkinSellNames",pumpkinNames)
        if not pumpkinFilterInitialized then
            pumpkinFilterInitialized=true;local chosen={}
            for name,value in pairs(d.Halloween and d.Halloween.DiceAutoSell or{})do if value then cfg.PumpkinSellNames[name]=true;chosen[#chosen+1]=name end end
            optionWidgets.PumpkinSellNames:Set(chosen,true)
        end
        local labels,names,boosts,spins={}, {}, {}, {}
        local liveUnits=planner.Units(d,c.Registry)
        options("SellRarities",planner.RarityOptions(c.Rarities,liveUnits,cfg.SellRarities))
        unitLabels={};keepIdLabels={}
        for _,u in ipairs(liveUnits)do
            local label=u.name.." | "..tostring(u.attributes.level or 1).." | "..u.id:sub(1,8)
            if unitLabels[label]then label=label.." / "..u.id end
            labels[#labels+1]=label;unitLabels[label]=u.id;keepIdLabels[label]=u.id;names[u.name]=true
        end
        for _,entry in pairs(d.Inventory or{})do
            local spec=c.Registry.getEntryConfig(entry.name)
            if spec and spec.kind=="Boost"then boosts[entry.name]=true elseif spec and spec.kind=="Spin"then spins[entry.name]=true end
        end
        unitPicker:Refresh(labels,true,true);options("KeepIds",labels);options("KeepNames",keys(names))
        presentation.RefreshItems("BoostNames",keys(boosts));presentation.RefreshItems("SpinNames",keys(spins))
        local kept={};local selected
        for label,id in pairs(unitLabels)do if id==cfg.SelectedUnit then selected=label end;if cfg.KeepIds[id]then kept[#kept+1]=label end end
        unitPicker:Set(selected,true);keepWidget:Set(kept,true)
    end
    local function selected(values)
        local names={};for name,value in pairs(values)do if value then names[#names+1]=name end end;table.sort(names);return names
    end
    local function restoreWidgets()
        -- Populate choices before setting them silently. Inventory IDs remain IDs.
        pumpkinFilterInitialized=true
        for _,kind in ipairs({"Trait","Grade","Quirk"})do
            protectionInitialized[kind]=true;protectedChoices[kind]=cfg['Protected'..kind..'s']
        end
        refreshOptions()
        for key,widget in pairs(valueWidgets)do
            local value=cfg[key]
            if key=="CodeList"then value=table.concat(value,", ")
            elseif type(value)~="boolean"then value=tostring(value)end
            widget:Set(value,true)
        end
        for key,widget in pairs(optionWidgets)do if key~="KeepIds"then
            local value=cfg[key]
            widget:Set(type(value)=="table"and selected(value)or key=="PumpkinCount"and tostring(value)or value,true)
        end end
        for kind,widget in pairs(protectionWidgets)do widget:Set(selected(protectedChoices[kind]),true)end
    end
    local function settingsResult(ok,message)
        savedStatus:Set(message)
        for key,widget in pairs(widgets)do widget:Set(cfg[key],true)end
        return ok,message
    end
    app.Settings=saved
    button(savedGroup,"Save Settings",function()changed();settingsResult(saved.Save())end)
    button(savedGroup,"Load Saved Settings",function()changed();settingsResult(saved.Load(restoreWidgets))end)
    button(savedGroup,"Reset Saved Settings",function()changed();settingsResult(saved.Reset(restoreWidgets))end)
    local function autoLoad()
        if not autoLoadPending or not ctx.Ready then return false end
        if not ctx.Snapshot()then savedStatus:Set("Waiting for game data.");return false end
        autoLoadPending=false
        return settingsResult(saved.Load(restoreWidgets))
    end
    button(actions,"Refresh inventory and choices",refreshOptions)
    -- Reuse the single language menu provided by the shared DEVIL HUB presentation.
local translations={
    ["Settings"]="ตั้งค่า",["Saved settings"]="ค่าที่บันทึก",["Restore settings"]="คืนค่าตั้งค่า",
    ["Save Settings"]="บันทึกตั้งค่า",["Load Saved Settings"]="โหลดตั้งค่าที่บันทึก",["Reset Saved Settings"]="รีเซ็ตตั้งค่าที่บันทึก",
    ["Save filters, item choices and enabled automation. Saved settings load automatically next run."]="บันทึกฟิลเตอร์ รายการที่เลือก และออโต้ที่เปิดไว้ รันครั้งถัดไปจะโหลดค่าเดิมอัตโนมัติ",
    ["Automation starts off without a saved profile. Saved settings restore after game data is ready."]="หากยังไม่มีค่าที่บันทึก ออโต้จะเริ่มปิดไว้ หากบันทึกแล้วจะโหลดค่าเดิมเมื่อข้อมูลเกมพร้อม",
    ["No saved settings loaded yet."]="ยังไม่ได้โหลดค่าที่บันทึก",["No saved settings found."]="ยังไม่มีค่าที่บันทึก",
    ["Settings saved. They will load next run."]="บันทึกตั้งค่าแล้ว รันครั้งถัดไปจะโหลดให้อัตโนมัติ",
    ["Saved settings loaded."]="โหลดตั้งค่าที่บันทึกแล้ว",["Saved settings reset."]="รีเซ็ตตั้งค่าที่บันทึกแล้ว",
    ["Waiting for player identity."]="กำลังรอข้อมูลผู้เล่น",["Waiting for game data."]="กำลังรอข้อมูลเกม",
    ["Saving unavailable on this executor."]="ตัวรันนี้ไม่รองรับการบันทึกไฟล์",["Loading unavailable on this executor."]="ตัวรันนี้ไม่รองรับการอ่านไฟล์",
    ["Settings could not be saved."]="บันทึกตั้งค่าไม่สำเร็จ",["Settings could not be applied."]="นำค่าที่บันทึกมาใช้ไม่สำเร็จ",
    ["Saved settings could not be read."]="อ่านไฟล์ตั้งค่าไม่สำเร็จ",
    ["DEVIL HUB Community"]="ชุมชน DEVIL HUB",
    ["Join our Discord"]="เข้าร่วม Discord ของเรา",
    ["Updates, announcements and community support."]="อัปเดต ประกาศ และความช่วยเหลือจากชุมชน",
    ["Invite ready to copy."]="พร้อมคัดลอกลิงก์เชิญ",
    ["Copy Discord Invite"]="คัดลอกลิงก์ Discord",
    ["Discord invite copied!"]="คัดลอกลิงก์ Discord แล้ว!",
    ["Clipboard unavailable. Select and copy the invite above."]="คัดลอกอัตโนมัติไม่ได้ เลือกและคัดลอกลิงก์ด้านบน",
    ["Stay connected"]="ติดตามข่าวสาร",
    ["Updates and announcements"]="อัปเดตและประกาศ",
    ["New releases, supported games and DEVIL HUB news."]="เวอร์ชันใหม่ เกมที่รองรับ และข่าวสาร DEVIL HUB",
    ["Support and feedback"]="ช่วยเหลือและเสนอแนะ",
    ["Report bugs, share suggestions and connect with the community."]="แจ้งบั๊ก เสนอแนะ และพูดคุยกับชุมชน",
    ["Anime Dice"]="Anime Dice",
    ["All automation starts off. Launch directly or through the DEVIL HUB main loader. Game rules, balances and inventory updates decide the result."]="ออโต้ทุกระบบเริ่มปิด ใช้ได้โดยตรงหรือผ่าน loader หลัก DEVIL HUB ผลขึ้นกับกติกา ยอดคงเหลือ และกระเป๋าในเกม",
    ["Rarities to sell (empty = all)"]="ระดับที่ต้องการขาย (ไม่เลือก = ขายทั้งหมด)",
    ["Select rarities to sell only those tiers. Clear every selection to Sell All Unused."]="เลือกขายได้หลายระดับ หากไม่เลือกเลยจะขายตัวที่ไม่ได้ใช้ทั้งหมด",
    ["Teleports to ground at each event door and waits for server travel limits, cooldown and confirmed rewards."]="วาร์ปลงพื้นหน้าประตูอีเวนต์ รอเวลาระหว่างประตู คูลดาวน์ และยืนยันรางวัลจากเกม",
    ["Auto Sell All Unused Units"]="ขายตัวที่ไม่ได้ใช้ทั้งหมดอัตโนมัติ",["Sell All Unused"]="ขายตัวที่ไม่ได้ใช้ทั้งหมด",
    ["Sell All Unused: waiting for live inventory."]="ขายตัวที่ไม่ได้ใช้ทั้งหมด: กำลังโหลดกระเป๋า",
    ["Sells all unused units, including rare and mutated units. Keeps plotted, Tower team, carried, locked, favorite and explicitly kept units."]="ขายตัวที่ไม่ได้ใช้ทั้งหมด รวมตัวหายากและ Mutation เว้นตัวในฐาน ทีม Tower ตัวที่ถือ ตัวล็อก รายการโปรด และตัวที่เลือกเก็บไว้",
    ["Keep best units for fusion"]="เก็บตัวดีที่สุดไว้จากการผสม",["Keep copies per character for fusion"]="จำนวนต่อชื่อที่เก็บจากการผสม",
    ["Keep mutated / variant units for fusion"]="ไม่ใช้ตัว Mutation / Variant ผสม",
    ["Auto Trick or Treat"]="เก็บ Trick or Treat อัตโนมัติ",
    ["Start Event Collection"]="เริ่มเก็บอีเวนต์",["Stop Event Collection"]="หยุดเก็บอีเวนต์",



    ["Farm"]="ฟาร์ม",["Farm controls"]="ระบบฟาร์ม",["Auto Roll"]="สุ่มลูกเต๋าอัตโนมัติ",
    ["Auto Collect Money"]="เก็บเงินฐานอัตโนมัติ",["Auto Equip Best Base"]="จัดตัวหาเงินดีที่สุด",
    ["Auto Level Units"]="อัปเลเวลตัวในฐาน",["Maximum unit level"]="เลเวลตัวสูงสุด",
    ["Dice and upgrades"]="ลูกเต๋าและอัปเกรด",["Auto Buy / Equip Dice"]="ซื้อและใส่ลูกเต๋าอัตโนมัติ",
    ["Dice selection"]="เลือกลูกเต๋า",["Auto Upgrade Tree"]="ซื้อโหนดอัปเกรดอัตโนมัติ",
    ["Upgrade branch"]="สายอัปเกรด",["Money reserve"]="เงินสำรอง",["Live status"]="สถานะปัจจุบัน",
    ["Connecting game modules..."]="กำลังเชื่อมต่อข้อมูลเกม...",["All automation starts off."]="ออโต้ทุกระบบเริ่มปิดไว้",
    ["Stop all automation"]="หยุดออโต้ทั้งหมด",["Inventory"]="กระเป๋า",["Sell and protect"]="ขายและเก็บตัว",


    ["Keep character names"]="ชื่อตัวที่เก็บไว้",
    ["Keep specific units"]="เลือกตัวที่เก็บไว้",
    ["Preview matching units before selling or fusing."]="ดูรายชื่อก่อนเปิดขายหรือผสม",["Preview sale"]="ดูตัวที่จะขาย",
    ["Lock and fusion"]="ล็อกและผสม",["Auto Lock Rare Units"]="ล็อกตัวหายากอัตโนมัติ",
    ["Lock minimum chance (0 = off)"]="โอกาสสุ่มขั้นต่ำที่ล็อก (0 = ปิด)",["Auto Fuse Surplus Units"]="ผสมตัวส่วนเกินอัตโนมัติ",
    ["Fuse maximum chance (0 = off)"]="โอกาสสุ่มสูงสุดที่ใช้ผสม (0 = ปิด)",["Preview fusion"]="ดูตัวที่จะผสม",
    ["Material filters"]="ตัวกรองวัตถุดิบ",
    ["Locked, plotted, team and kept units are excluded. Fusion consumes three units. Set chance limits before enabling."]="ข้ามตัวที่ล็อก อยู่ในฐาน อยู่ในทีม และตัวที่เก็บไว้ การผสมใช้ตัวสามตัว ตั้งขอบเขตก่อนเปิด",
    ["Towers"]="หอคอย",["Tower farming"]="ฟาร์มหอคอย",["Tower selection"]="เลือกหอคอย",["Auto Tower"]="ลงหอคอยอัตโนมัติ",
    ["Equip Best Tower Team"]="จัดทีมตีหอคอยดีที่สุด",["Tower timing"]="จังหวะหอคอย",
    ["Uses the actual server battle results and game timing. Only one Tower or Haunted House runs at a time."]="ใช้ผลต่อสู้และเวลาจริงของเกม เปิด Tower หรือ Haunted House ได้ทีละระบบ",
    ["Rebirth and points"]="รีเบิร์ธและแต้ม",["Auto Rebirth"]="รีเบิร์ธอัตโนมัติ",["Stop at rebirth"]="หยุดที่รีเบิร์ธ",
    ["Rebirth resets your cash to zero."]="รีเบิร์ธจะรีเซ็ตเงินสดเป็นศูนย์",["Rebirth stat"]="ค่าสถานะที่ลงแต้ม",
    ["Auto Allocate Rebirth Points"]="ลงแต้มรีเบิร์ธอัตโนมัติ",["Use one reset token"]="ใช้ Reset Token หนึ่งชิ้น",
    ["Rerolls"]="สุ่มค่าสถานะ",["Selected unit"]="ตัวที่เลือก",["Unit selection"]="เลือกตัวจากกระเป๋า",
    ["Reroll request limit"]="จำกัดจำนวนคำขอสุ่ม",["Equip selected unit"]="ถือตัวที่เลือก",["Put unit back"]="เก็บตัวที่ถือ",
    ["Reroll targets"]="เป้าหมายการสุ่ม",["Trait targets"]="Trait ที่ต้องการ",["Grade targets"]="Grade ที่ต้องการ",["Quirk targets"]="Quirk ที่ต้องการ",
    ["Auto Trait"]="สุ่ม Trait อัตโนมัติ",["Auto Grade"]="สุ่ม Grade อัตโนมัติ",["Auto Quirk"]="สุ่ม Quirk อัตโนมัติ",
    ["Game protection"]="การป้องกันค่าของเกม",["Protect Trait"]="Trait ที่ป้องกัน",["Protect Grade"]="Grade ที่ป้องกัน",["Protect Quirk"]="Quirk ที่ป้องกัน",
    ["Apply Trait protection"]="บันทึกการป้องกัน Trait",["Apply Grade protection"]="บันทึกการป้องกัน Grade",["Apply Quirk protection"]="บันทึกการป้องกัน Quirk",
    ["Items and rewards"]="ไอเทมและรางวัล",["Items and gear"]="ไอเทมและอุปกรณ์",["Boosts to use"]="ยาที่อนุญาตให้ใช้",
    ["Spins to use"]="Spin ที่อนุญาตให้ใช้",["Auto Use Selected Boosts"]="ใช้ยาที่เลือกอัตโนมัติ",["Auto Use Selected Spins"]="ใช้ Spin ที่เลือกอัตโนมัติ",
    ["Gear priority"]="เป้าหมายการจัดอุปกรณ์",["Auto Equip Gear"]="จัดอุปกรณ์อัตโนมัติ",["Rewards and codes"]="รางวัลและโค้ด",
    ["Auto Claim Daily / Group / Offline"]="รับรางวัลรายวัน / กลุ่ม / ออฟไลน์",["Auto Claim Completed Quests"]="รับเควสต์ที่ครบอัตโนมัติ",
    ["Quest shop item"]="สินค้าร้านเควสต์",["Quest purchase limit"]="จำนวนซื้อร้านเควสต์สูงสุด",["Tickets reserve"]="Tickets สำรอง",
    ["Auto Buy Quest Shop Item"]="ซื้อสินค้าร้านเควสต์อัตโนมัติ",["Codes (comma separated)"]="รายการโค้ด (คั่นด้วยจุลภาค)",
    ["Auto Redeem Entered Codes"]="แลกโค้ดในรายการอัตโนมัติ",["Halloween"]="ฮาโลวีน",["Auto Pumpkin Dice"]="สุ่ม Pumpkin Dice อัตโนมัติ",
    ["Roll count"]="จำนวนต่อครั้ง",["Pumpkins reserve"]="Pumpkins สำรอง",["Pumpkin units to auto sell"]="ตัว Pumpkin ที่ขายอัตโนมัติ",
    ["Apply Pumpkin sell filter"]="บันทึกตัวกรองขาย Pumpkin",["Haunted wing"]="เลือกโซนบ้านผีสิง",["Auto Haunted House"]="ลงบ้านผีสิงอัตโนมัติ",
    ["Travel to Halloween Island"]="ไปเกาะฮาโลวีน",["Return to Hub"]="กลับเกาะหลัก",
    ["Door route"]="เส้นทางประตู",
    ["Pass and event quests"]="Pass และเควสต์อีเวนต์",["Auto Claim Pumpkin Pass"]="รับรางวัล Pumpkin Pass อัตโนมัติ",
    ["Auto Claim Halloween Quests"]="รับเควสต์ฮาโลวีนที่ครบ",["Candy shop"]="ร้าน Candy",["Candy shop item"]="สินค้าที่ซื้อด้วย Candy",
    ["Purchase limit"]="จำนวนซื้อสูงสุด",["Candy reserve"]="Candy สำรอง",["Auto Buy Candy Shop Item"]="ซื้อสินค้าด้วย Candy อัตโนมัติ",
    ["Status"]="สถานะ",["Test report"]="รายงานตัวทดสอบ",["Test controls"]="ควบคุมตัวทดสอบ",
    ["Copy / save test report"]="คัดลอก / บันทึกรายงาน",["Use game Auto Roll"]="ใช้ระบบ Auto Roll เดิมของเกม",["Close test"]="ปิดตัวทดสอบ",
    ["Standalone test"]="ตัวทดสอบแยก",["All automation starts off. This test is separate from the main loader. Game rules, balances and inventory updates decide the result."]="ทุกออโต้เริ่มปิด ตัวนี้แยกจาก loader หลัก ผลขึ้นอยู่กับกติกา ยอดคงเหลือ และข้อมูลกระเป๋าจริงของเกม",
    ["Refresh inventory and choices"]="อัปเดตกระเป๋าและตัวเลือก",["Connection failed; copy the test report"]="เชื่อมต่อไม่สำเร็จ กรุณาคัดลอกรายงาน"
}
local localized=setmetatable({},{__mode="k"})
local inverse={};for en,th in pairs(translations)do inverse[th]=en end
local currentLanguage="EN"
local function inspectText(node)
    if node:GetAttribute("DevilLocalizationOverlay")or node:GetAttribute("DevilBlueSettings")then return end
    if not(node:IsA("TextLabel")or node:IsA("TextButton"))or localized[node]then return end
    local record={Writing=false};localized[node]=record
    local function update()
        if record.Writing then return end
        local english=inverse[node.Text]or node.Text
        if not translations[english]then return end
        record.English=english;record.Writing=true
        node.Text=currentLanguage=="TH"and translations[english]or english
        record.Writing=false
    end
    links[#links+1]=node:GetPropertyChangedSignal("Text"):Connect(update)
    update()
end
links[#links+1]=window.Gui.DescendantAdded:Connect(inspectText)
for _,node in ipairs(window.Gui:GetDescendants())do inspectText(node)end
local function refreshLanguage()
    local theme=scope.DevilHubBlueGui
    local language=theme and theme.Get and theme.Get().Language or"EN"
    if language==currentLanguage then return end
    currentLanguage=language
    for node,record in pairs(localized)do
        if node.Parent and record.English then
            record.Writing=true;node.Text=language=="TH"and translations[record.English]or record.English;record.Writing=false
        end
    end
end

    controlsReady=true
    scope.DevilAnimeDiceTest=app
    scope.DevilAnimeDiceStarting=nil
    ctx.Spawn(function()
        local initialized,err=xpcall(function()
            ctx.Initialize(function()return not app.Stopped end)
            if app.Stopped then return end
            core.BindEvents()
            local restored=autoLoad()
            if not restored then refreshOptions()end
        end,debug.traceback)
        if not initialized and not app.Stopped then core.Report.InitializationError=tostring(err);summary:Set("Connection failed; copy the test report");warn(err)end
    end)
    ctx.Spawn(function()
        local refreshAt=0
        while not app.Stopped do
            local worked,err=xpcall(function()autoLoad();core.Tick()end,debug.traceback)
            if not worked then core.Report.LastTickError=tostring(err)end
            local rendered,renderError=xpcall(function()
                local r=core.Report.Summary
                if r then
                    summary:Set(string.format("Money: %.4g | Units: %d / %d\nRolls: %s | Rebirth: %s\nCandy: %.4g | Pumpkins: %.4g",r.Money,r.Units,r.Storage,tostring(r.Rolls),tostring(r.Rebirth),r.Candy,r.Pumpkins))
                    sellStatus:Set(core.SellSummary())
                end
                local enabled=0
                for name,widget in pairs(widgets)do if cfg[name]then enabled+=1 end;widget:Set(cfg[name],true)end
                resultLabel:Set("Enabled: "..enabled.." / "..#core.Jobs)
                for name,label in pairs(statuses)do local s=core.Report.Jobs[name];label:Set(name..": "..s.Status.." | "..s.Requests.." requests / "..s.Confirmed.." confirmed")end
                if os.clock()>refreshAt and ctx.Ready then
                    refreshAt=os.clock()+8
                    local success,err=pcall(refreshOptions);if not success then core.Report.ChoicesError=tostring(err)end
                end
                refreshLanguage()
                presentation.SetLanguage(currentLanguage,ctx.Ready and ctx.Snapshot()or nil);presentation.Tick(os.clock())
            end,debug.traceback)
            if not rendered then core.Report.LastRenderError=tostring(renderError)end
            ctx.Wait(.5)
        end
    end)
end,debug.traceback)
if scope.DevilAnimeDiceStarting==startup then scope.DevilAnimeDiceStarting=nil end
if not ok then destroy();error(problem,0)end
return app
