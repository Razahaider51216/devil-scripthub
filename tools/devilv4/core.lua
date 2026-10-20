return function(A,P)
    local C={Config=P.Defaults(),Jobs={},Alive=true,Mining=false,Generation=0,Report={Version="devilv4-test-20261020-2",Jobs={},Requests=0,Replies=0,Confirmed=0,Errors={},LiveVerified=false},Target=nil}
    local cfg=C.Config;local busyMoney=false;local movingJob=nil;local epoch={};local plans={};local collected={};local eventState
    local aimAt,lastAimTarget=0,nil;local nextAt={};local farmRetryAt=0
    local function status(key,text)C.Report.Jobs[key]=tostring(text)end
    local function result(key,data,err)
        if type(data)=="table"then
            C.Report.Replies+=1;status(key,data.Code or data.reason or(data.success and"Confirmed")or"Server replied")
            if data.success or ({Purchased=true,Equipped=true,Upgraded=true,Claimed=true,Rebirthed=true,Sold=true})[data.Code]or(tonumber(data.CashAdded)or 0)>0 then C.Report.Confirmed+=1 end
        else status(key,err or"Waiting for server state")end
        return data
    end
    function C.Request(key,remote,...)
        C.Report.Requests+=1;local data,err=A.Invoke(remote,...);return result(key,data,err)
    end
    function C.StopMining()
        if C.Mining then A.Fire("Mining","Stop");C.Mining=false end;aimAt=0;lastAimTarget=nil
    end
    function C.Set(key,value)
        if type(cfg[key])~="boolean"then return end
        cfg[key]=value==true;epoch[key]=(epoch[key]or 0)+1
        nextAt[key]=nil
        if not value then status(key,"Off");if key=="Dig"or key=="FarmFinds"or key=="Train"then C.StopMining();C.Target=nil;if A.ReleasePhase then A.ReleasePhase()end end end
    end
    function C.StopAll()
        C.Generation+=1
        for _,key in ipairs(P.Jobs)do C.Set(key,false)end
        C.StopMining();C.Target=nil;status("System","Stopped")
        if A.ReleasePhase then A.ReleasePhase()end
    end
    function C.Run(key,fn,manual)
        if C.Jobs[key]or not C.Alive then return end
        C.Jobs[key]=true;local generation=C.Generation;local version=epoch[key]or 0
        local function valid()return C.Alive and C.Generation==generation and(epoch[key]or 0)==version and(manual or cfg[key])and not A.Blocked()end
        A.Spawn(function()
            local ok,err=xpcall(function()if valid()then fn(valid)end end,debug.traceback)
            C.Jobs[key]=nil
            if not ok then status(key,"Error; retrying");C.Report.Errors[key]=tostring(err)end
        end)
    end
    local function invoke(valid,key,remote,...)
        if valid()then return C.Request(key,remote,...)end
    end
    local function money(valid,key,fn)
        if busyMoney or not valid()then status(key,"Waiting for purchase queue");return end
        busyMoney=true
        local ok,err=xpcall(fn,debug.traceback);busyMoney=false;if not ok then error(err)end
    end
    local function move(valid,key,target)
        if C.Selling and C.Selling~=key then status(key,"Waiting for sale");return false end
        if movingJob and movingJob~=key then status(key,"Waiting for movement queue");return false end
        movingJob=key;C.StopMining()
        local callOK,ok,msg=pcall(A.Move,target,valid,key);movingJob=nil
        if not callOK then error(ok)end
        status(key,msg);return ok
    end
    function C.Teleport(target)
        C.Run("Teleport",function(valid)
            target=A.ResolveTarget(target)
            if not target then status("Teleport","No loaded instance of the selected item");return end
            C.Target=nil;move(valid,"Teleport",target)
        end,true)
    end
    function C.Surface(mode)
        C.Run("Travel",function(valid)
            if movingJob or C.Selling then return end;C.StopMining();C.Target=nil;if A.ReleasePhase then A.ReleasePhase()end
            local _,_,r=A.Character();local before=r and r.Position
            if valid()then A.Fire("Surface",mode);A.Wait(.6)end
            if not valid()then return end
            local _,_,now=A.Character();status("Travel",now and before and(now.Position-before).Magnitude>3 and"Travel confirmed"or"Travel requested; check position")
        end,true)
    end
    function C.RefreshShop()
        C.Run("ShopRefresh",function(valid)
            local sh=invoke(valid,"ShopRefresh","Shovels","Open");if type(sh)=="table"and sh.Owned then A.Snapshots.Shovels=sh end
            local gear=invoke(valid,"ShopRefresh","Gear","Open");if type(gear)=="table"and gear.Counts then A.Snapshots.Gear=gear end
        end,true)
    end
    local handlers={}
    handlers.FarmFinds=function(valid)
        if C.Selling or C.Jobs.Plant or A.Attr("AfkTraining",false)or(cfg.Train and not cfg.Rotate)then return end
        local target=C.Target
        if not target or not A.ValidFind(target.Instance)or target.Kind~=cfg.FindKind and cfg.FindKind~="All"or target.Rarity~=cfg.FindRarity and cfg.FindRarity~="All"then
            target=A.Targets(cfg.FindKind,cfg.FindRarity)[1];C.Target=target
        end
        if not target then status("FarmFinds","Waiting for streamed targets");return end
        if not A.Aim(target)then
            if A.Clock()<farmRetryAt then return end
            local arrived=move(valid,"FarmFinds",target)
            if not arrived then farmRetryAt=A.Clock()+.5;return end
        end
        if valid()then status("FarmFinds","Target: "..target.Name.." #"..target.Serial);C.UpdateMining()end
    end
    handlers.Plant=function(valid)
        if movingJob or C.Jobs.Train or A.Attr("AfkTraining",false)then return end
        local tool;for _,t in ipairs(A.Tools())do if t:GetAttribute("ItemId")=="Egg"then tool=t;break end end
        if not tool then status("Plant","Waiting for inventory eggs");return end
        local position=A.PlantPosition();if not position then status("Plant","Waiting for free ground on your plot");return end
        local _,_,root=A.Character();if not root then return end
        if(root.Position-position).Magnitude>25 and not move(valid,"Plant",{Position=position})then return end
        C.StopMining()
        local _,h=A.Character();if valid()and h then h:EquipTool(tool);A.Wait(.15)end
        if valid()and tool.Parent==A.Player.Character then
            A.Fire("Plant",position);status("Plant","Plant requested; waiting for inventory");A.Wait(.5)
            local reply=A.Snapshots.LastPlant
            if valid()and reply and A.Clock()-reply.At<2 then status("Plant",reply.Success and"Plant confirmed"or tostring(reply.Message or"Placement rejected"))end
        end
    end
    handlers.Hatch=function(valid)
        local snapshot=invoke(valid,"Hatch","Eggs","Snapshot");local ready=P.ReadyEggs(snapshot,A.ServerTime())
        if #ready==0 then status("Hatch","Waiting for ready eggs");return end
        -- One ready ID per cycle; a rejected hatch cannot block the others forever.
        C.HatchIndex=(C.HatchIndex or 0)%#ready+1
        invoke(valid,"Hatch","Eggs","Hatch",ready[C.HatchIndex])
    end
    for key,entry in pairs({SellLoot={"SellAll"},SellEggs={"SellSpareEggs","SpareEggs"},SellPets={"SellStoredPets","StoredPets"}})do
        local job,action,quoteKey=key,entry[1],entry[2]
        handlers[job]=function(valid)
            if C.Selling or movingJob or A.MoveBusy then nextAt[job]=A.Clock()+.2;return end
            C.Selling=job;C.StopMining()
            local ok,err=xpcall(function()
                local function snapshot()
                    local snap=invoke(valid,job,"Sell","Open")
                    if type(snap)=="table"and(snap.Code=="TooFar"or snap.Code=="OutOfRange")and valid()then
                        if A.ReleasePhase then A.ReleasePhase()end
                        A.Fire("Surface","Sell");status(job,"Travelling to sell area");A.Wait(.25)
                        for _=1,3 do
                            if not valid()then return end
                            snap=invoke(valid,job,"Sell","Open")
                            if type(snap)=="table"and type(snap.Items)=="table"then break end
                            if type(snap)~="table"or(snap.Code~="TooFar"and snap.Code~="OutOfRange")then break end
                            A.Wait(.2)
                        end
                    end
                    return snap
                end
                local snap=snapshot();if type(snap)~="table"then return end
                if type(snap.Items)~="table"then status(job,snap.Code or"Invalid sale snapshot");return end
                A.Snapshots.Sell=snap
                local quote=quoteKey and P.Quote(snap,quoteKey)
                if quoteKey and quote==nil or not quoteKey and(tonumber(snap.Total)or 0)<=0 then status(job,"Nothing to sell");return end
                local reply=invoke(valid,job,"Sell",action,quote)
                if type(reply)=="table"and reply.Code=="Changed"and valid()then
                    snap=snapshot();quote=quoteKey and P.Quote(snap,quoteKey)
                    if snap and(quoteKey and quote~=nil or not quoteKey and(tonumber(snap.Total)or 0)>0)then reply=invoke(valid,job,"Sell",action,quote)end
                end
                if type(reply)=="table"then
                    if reply.Items then A.Snapshots.Sell=reply end
                    local cash=tonumber(reply.CashAdded)or 0
                    status(job,cash>0 and("Sold +$"..P.Money(cash))or(reply.Code or"Sale not confirmed"))
                end
            end,debug.traceback)
            C.Selling=nil;if not ok then error(err)end
        end
    end
    function C.BuyShovel(valid,choice)
        money(valid,"BuyShovel",function()
            local snap=invoke(valid,"BuyShovel","Shovels","Open");if type(snap)~="table"or not snap.Owned then return end;A.Snapshots.Shovels=snap
            local catalog=A.Modules.ShovelCatalog;if not catalog then status("BuyShovel","Waiting for shovel catalog");return end
            local active=catalog.tier(A.Attr("ShovelLevel",1));local item,action=P.ShopChoice(catalog.Tiers,snap,choice or cfg.Shovel,A.Attr("Cash",0),cfg.Reserve,active and active.Id)
            if not item then status("BuyShovel","Equipped best / saving cash");return end
            local reply=invoke(valid,"BuyShovel","Shovels",action,item.Id);if type(reply)=="table"and reply.Owned then A.Snapshots.Shovels=reply end
        end)
    end
    handlers.BuyShovel=function(valid)C.BuyShovel(valid)end
    function C.BuyGear(valid,id)
        money(valid,"BuyGear",function()
            local snap=invoke(valid,"BuyGear","Gear","Open");if type(snap)~="table"or not snap.Counts then return end;A.Snapshots.Gear=snap
            local catalog=A.Modules.ShovelCatalog;local tier=catalog and catalog.index(id);tier=tier and catalog.Tiers[tier]
            if tier and tier.Kind~="Drill"then return end
            if tier and snap.Owned and snap.Owned[id]then
                if A.Attr("ActiveDrillId")~=id then invoke(valid,"BuyGear","Gear","Equip",id,tier.Cost,snap.Stock and snap.Stock.Key)end;return
            end
            local def=(A.Modules.GearConfig or{}).Types;def=def and def[id]
            if not tier and not def then status("BuyGear","Choose gear or a drill");return end
            if not tier and(tonumber(snap.Counts[id])or 0)>=cfg.GearLimit then status("BuyGear","Inventory limit reached");return end
            if def and def.SingleOwned and snap.Owned and snap.Owned[id]then status("BuyGear","Already owned");return end
            local price=tier and tier.Cost or snap.Prices and snap.Prices[id]
            local stock=snap.Stock
            if not stock or not stock.Key or not stock.Remaining or(tonumber(stock.Remaining[id])or 0)<=0 then status("BuyGear","Waiting for stock");return end
            if not P.Affordable(price,A.Attr("Cash",0),cfg.Reserve)then status("BuyGear","Saving cash / waiting for live price");return end
            local reply=invoke(valid,"BuyGear","Gear","Buy",id,price,stock.Key);if type(reply)=="table"and reply.Counts then A.Snapshots.Gear=reply end
        end)
    end
    handlers.BuyGear=function(valid)C.BuyGear(valid,cfg.Gear)end
    handlers.EquipPets=function(valid)
        if A.Attr("PetEquipBestNeeded",false)then invoke(valid,"EquipPets","Pets","EquipBest",nil,1)else status("EquipPets","Best pets already equipped")end
    end
    for key,def in pairs({TrainingUpgrade={"TrainingUpgradeConfig","TrainingLevel","Training"},PlotUpgrade={"PlotUpgradeConfig","PlotLevel","Plot"}})do
        local job,module,attribute,remote=key,def[1],def[2],def[3]
        handlers[job]=function(valid)money(valid,job,function()
            local config=A.Modules[module];if not config then return end
            local level=config.level(A.Attr(attribute));local offer=config.offer(level)
            if not offer then status(job,"Maximum level");return end
            if not P.Affordable(offer.CashCost,A.Attr("Cash",0),cfg.Reserve)then status(job,"Saving cash");return end
            local sign=A.TaggedOwn(config.SignTag)
            if not sign and remote=="Training"then status(job,"Waiting for your upgrade sign");return end
            invoke(valid,job,remote,sign,"Cash",level)
        end)end
    end
    for _,key in ipairs({"HoleLuck","AnimalIncome"})do
        local job=key;handlers[job]=function(valid)money(valid,job,function()
            local config=A.Modules.BoothUpgradeConfig;if not config or not config.Types[job]then return end
            local d=config.Types[job];local level=config.level(job,A.Attr(d.Attribute));local cost=config.cost(job,level)
            if not P.Affordable(cost,A.Attr("Cash",0),cfg.Reserve)then status(job,"Maximum level / saving cash");return end
            invoke(valid,job,"Booth","Buy",job,level)
        end)end
    end
    handlers.Rebirth=function(valid)
        local snap=invoke(valid,"Rebirth","Rebirth","Snapshot",A.Attr("Rebirths",0))
        if type(snap)~="table"then return end
        if type(snap.Count)~="number"or snap.Count>=cfg.RebirthLimit then status("Rebirth","Rebirth limit reached");return end
        if not snap.Eligible then status("Rebirth","Waiting for requirements");return end
        money(valid,"Rebirth",function()C.StopMining();invoke(valid,"Rebirth","Rebirth","Rebirth",snap.Count)end)
    end
    handlers.Potions=function(valid)
        local id=cfg.Potion;local config=A.Modules.PotionConfig
        if not config or not config.Types[id]then return end
        if A.Attr("Potion"..id.."Until",0)>A.ServerTime()then status("Potions","Potion is active");return end
        if A.Attr("DrinkingPotion",false)then return end
        C.StopMining();local tool=A.Equip("Potion","PotionId",id)
        if not tool then status("Potions","Waiting for owned potion");return end
        A.Wait(.2);if valid()and tool.Parent==A.Player.Character then A.Fire("Potion",id);status("Potions","Consume requested")end
    end
    handlers.Daily=function(valid)
        local s=invoke(valid,"Daily","DailyState")
        if type(s)=="table"and s.CanClaim and type(s.TotalClaims)=="number"then invoke(valid,"Daily","DailyClaim",s.TotalClaims)else status("Daily","Daily reward not ready")end
    end
    handlers.Offline=function(valid)
        local s=invoke(valid,"Offline","Offline","Snapshot")
        if type(s)=="table"and(tonumber(s.Base)or 0)>0 then invoke(valid,"Offline","Offline","Claim")else status("Offline","No offline earnings")end
    end
    handlers.PetIndex=function(valid)
        local s=invoke(valid,"PetIndex","Index","Snapshot")
        if type(s)=="table"then invoke(valid,"PetIndex","Index","ClaimAll")end
    end
    local function events(valid,key)
        local s=invoke(valid,key,"EventState");if type(s)=="table"then eventState=s;A.Snapshots.Events=s end;return eventState
    end
    local function allowed()
        local rule=A.Modules.AdminAbuseEligibility;return rule and rule.allowed(A.Player)==true
    end
    handlers.EventEggs=function(valid)
        local s=events(valid,"EventEggs");if not s or not s.live or not allowed()then status("EventEggs","Waiting for eligible event");return end
        local rains={};if type(s.event)=="table"then rains[#rains+1]=s.event end
        for _,rain in pairs(s.eggRains or{})do if type(rain)=="table"then rains[#rains+1]=rain end end
        local now=A.ServerTime();local selected,bestDrop,bestDistance,deadline
        local _,_,root=A.Character();if not root then return end
        for _,event in ipairs(rains)do
            local config=A.Modules.AbuseEventConfig;config=config and config.getEvent(event.kind)
            if config and config.CollectRadius and type(event.endTime)=="number"and event.id then
                local limit=event.endTime+(config.CleanupAfterShowerSeconds or 0)
                if now<limit then
                    local cache=plans[event.id]
                    if not cache or now-cache.At>5 then
                        local plan=invoke(valid,"EventEggs","EggPlan",event.id)
                        if type(plan)=="table"and type(plan.Drops)=="table"then cache={At=now,Data=plan};plans[event.id]=cache end
                    end
                    if not valid()then return end
                    for _,drop in ipairs(cache and cache.Data.Drops or{})do
                        local claimed=table.clone(cache and cache.Data.Claimed or{})
                        for index,value in pairs(collected[event.id]or{})do if value then claimed[index]=true end end
                        if P.DropEligible(drop,claimed,now,limit)and typeof(drop.Position)=="Vector3"then
                            local dist=(root.Position-drop.Position).Magnitude
                            if not bestDistance or dist<bestDistance then selected=event;bestDrop=drop;bestDistance=dist;deadline=limit end
                        end
                    end
                end
            end
        end
        -- Prune finished event plans instead of retaining drops for a long session.
        for id,cache in pairs(plans)do if now-cache.At>120 then plans[id]=nil;collected[id]=nil end end
        if not bestDrop then status("EventEggs","Waiting for landed event drops");return end
        local config=A.Modules.AbuseEventConfig.getEvent(selected.kind);local radius=config.CollectRadius
        if bestDistance>math.max(2,radius-2)and not move(valid,"EventEggs",{Position=bestDrop.Position})then return end
        local _,_,current=A.Character()
        if not valid()or not current or(current.Position-bestDrop.Position).Magnitude>radius or A.ServerTime()>=deadline then return end
        local reply=invoke(valid,"EventEggs","ClaimEgg",selected.id,bestDrop.Index)
        if type(reply)=="table"and(reply.success or reply.reason=="already_claimed"or reply.reason=="too_late")then
            collected[selected.id]=collected[selected.id]or{};collected[selected.id][bestDrop.Index]=true
        end
    end
    handlers.EventWaves=function(valid)
        local s=events(valid,"EventWaves");local e=s and s.event;local session=s and s.session
        local config=A.Modules.AbuseEventConfig;local rules=A.Modules.AbuseEventRules
        if not s or not s.live or not allowed()or not e or e.kind~="CashTsunami"or not session or typeof(session.groundPosition)~="Vector3"or not config or not rules then status("EventWaves","Waiting for Cash Tsunami");return end
        local _,_,root=A.Character();if not root then return end
        local d=root.Position-session.groundPosition;local distance=Vector2.new(d.X,d.Z).Magnitude
        local now=A.ServerTime();local waveConfig=config.getEvent("CashTsunami")
        for index,offset in ipairs(config.getWaveLaunchOffsets())do
            local id=tostring(e.id)..":"..index
            if not collected[id]and rules.waveEligible(now,e.startTime+offset,distance,waveConfig)then
                local reply=invoke(valid,"EventWaves","ClaimWave",e.id,index)
                if type(reply)=="table"and(reply.success or reply.reason=="already_claimed")then collected[id]=true end
                return
            end
        end
        status("EventWaves","Waiting for wave arrival")
    end
    handlers.UseGear=function(valid)
        if movingJob then return end
        local config=A.Modules.GearConfig;local id=cfg.UseGearId;local d=config and config.Types[id]
        if not d or d.Kind=="Launcher"then status("UseGear","Select placement gear");return end
        C.StopMining();local tool=A.Equip("Gear","GearId",id);if not tool then status("UseGear","Waiting for owned gear");return end
        local c,_,root,head=A.Character();if not head then return end
        local target
        if d.Kind=="MoonTotem"then target=A.PlantPosition()
        else
            local hit=A.Ground(root.Position+root.CFrame.LookVector*4+Vector3.new(0,2,0),{c},12)
            local mine=A.Mine();local grid=A.Modules.GearPlacementGrid;local frame=mine and mine:GetAttribute("DigFrame")
            if hit and hit.Normal.Y>=.65 and mine and hit.Instance:IsDescendantOf(mine)and not hit.Instance:GetAttribute("MineBoundary")and grid and typeof(frame)=="CFrame"then target=grid.snap(frame,hit.Position)end
        end
        if not target or(target-head.Position).Magnitude>(config.Reach or 16)then status("UseGear","Move to clear placement ground");return end
        A.Wait(.15);if valid()then A.Fire("PlaceGear",id,target);status("UseGear","Placement requested")end
    end
    handlers.Pumpkin=function(valid)
        if movingJob then return end
        local target=C.Target or A.Targets(cfg.FindKind,cfg.FindRarity)[1]
        if not target or not A.Aim(target)then status("Pumpkin","Waiting for nearby target");return end
        C.StopMining();local tool=A.Equip("Gear","GearId","PumpkinLauncher")
        if not tool then status("Pumpkin","Waiting for Pumpkin Launcher");return end
        A.Wait(.15);if valid()then A.Fire("Pumpkin",target.Instance.Position);status("Pumpkin","Shot requested")end
    end
    local trainStarted=0;local miningStarted=A.Clock()
    handlers.Train=function(valid)
        local now=A.Clock()
        if cfg.Rotate and trainStarted>0 and now-trainStarted>=cfg.TrainSeconds then
            C.StopMining();if valid()then A.Fire("Surface","DigSite")end
            miningStarted=now;trainStarted=0;status("Train","Mining rotation");return
        end
        if cfg.Rotate and trainStarted==0 and now-miningStarted<cfg.DigSeconds then status("Train","Mining rotation");return end
        if A.Attr("AfkTraining",false)then if trainStarted==0 then trainStarted=now end;status("Train","Training confirmed");return end
        local plot=A.Plot();local frame=plot and plot:GetAttribute("PlotFrame");local progression=A.Modules.ProgressionConfig
        if typeof(frame)~="CFrame"or not progression or typeof(progression.TrainingOffset)~="Vector3"then status("Train","Training area not streamed");return end
        move(valid,"Train",{Position=frame:PointToWorldSpace(progression.TrainingOffset),Training=true})
        if valid()then status("Train",A.Attr("AfkTraining",false)and"Training confirmed"or"Arrived; waiting for training trigger")end
    end
    local intervals={FarmFinds=.1,Plant=2,Hatch=2,SellLoot=5,SellEggs=5,SellPets=5,BuyShovel=6,BuyGear=6,EquipPets=4,TrainingUpgrade=6,PlotUpgrade=6,HoleLuck=6,AnimalIncome=6,Rebirth=10,Potions=5,Daily=30,Offline=30,PetIndex=30,EventEggs=.65,EventWaves=.5,UseGear=23,Pumpkin=1,Train=3}
    function C.Tick()
        if not C.Alive then return end
        if A.UpdatePhase then A.UpdatePhase()end
        local now=A.Clock()
        for key,fn in pairs(handlers)do
            local urgent=key=="FarmFinds"and C.Target and not A.ValidFind(C.Target.Instance)
            if cfg[key]and(now>=(nextAt[key]or 0)or urgent)then nextAt[key]=now+(intervals[key]or 5);C.Run(key,fn)end
        end
        C.UpdateMining()
    end
    function C.UpdateMining()
        local now=A.Clock()
        if not C.Alive or not(cfg.Dig or cfg.FarmFinds)or C.Selling or movingJob or A.MoveBusy or C.Jobs.Plant or C.Jobs.Potions or C.Jobs.UseGear or C.Jobs.Pumpkin or A.Blocked()or A.Attr("AfkTraining",false)then C.StopMining();return end
        if cfg.FarmFinds and not C.Target then C.StopMining();status("Dig","Waiting for selected target");return end
        local targetKey=cfg.FarmFinds and C.Target and C.Target.Instance or"Down"
        if now<aimAt and lastAimTarget==targetKey then return end
        local rate=cfg.FastDig and P.Number(cfg.AimRate,20,5,40)or 10;aimAt=now+1/rate
        local equipment=A.Modules.Equipment
        if equipment and not equipment.shovel(A.Player.Character)then C.StopMining();status("Dig","Waiting for equipped shovel / drill");return end
        local origin,direction,mode,selected=A.Aim(cfg.FarmFinds and C.Target or nil)
        if not origin then C.StopMining();status("Dig","Waiting for reachable diggable ground");return end
        local sent,err=A.Fire("Mining",C.Mining and"Aim"or"Start",origin,direction,mode,selected)
        if sent then C.Mining=true;lastAimTarget=targetKey;status("Dig",string.format("Continuous mining | %d aim updates/s",rate))else C.Mining=false;status("Dig",err)end
    end
    function C.Destroy()C.StopAll();C.Alive=false;A.Destroy()end
    C.Handlers=handlers
    return C
end
