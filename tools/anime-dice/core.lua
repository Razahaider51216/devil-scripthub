return function(ctx,P)
    local jobs={"Roll","Collect","EquipBase","Level","Upgrade","Dice","Sell","Lock","Tower","Haunted","Rebirth","Stats",
        "Trait","Grade","Quirk","Fuse","Boost","Spin","Gear","Rewards","Quests","Codes","Pumpkin","Pass","EventQuests","CandyShop","Doors","QuestShop"}
    local cfg={MoneyReserve=0,CandyReserve=0,PumpkinReserve=0,KeepBest=1,KeepCopies=1,KeepIds={},KeepNames={},SellRarities={},SkipMutations=true,
        FuseChanceMax=0,LockChanceMin=0,UpgradeBranch="All",DiceChoice="Best affordable",LevelCap=100,
        TowerChoice="",WingChoice="Front Yard",RebirthLimit=1,StatChoice="Luck",SelectedUnit="",RerollLimit=50,
        TraitTargets={},GradeTargets={},QuirkTargets={},BoostNames={},SpinNames={},GearPriority="Luck",PumpkinCount=1,
        PumpkinSellNames={},OfferChoice="",OfferLimit=1,QuestOffer="",QuestLimit=1,TicketReserve=0,CodeList={},UseNativeRoll=true}
    local clock=ctx.Clock or os.clock
    local ctl={Config=cfg,Report={Version="anime-dice-test-20261020-5",Jobs={},Log={},TowerRewards={},LiveVerified=false},Stopped=false,Generation={}}
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
        if not value and name=="Doors"then ctx.CancelMovement()end
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
        local active=function()return valid(name,token)end
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
            ctx.StreamEvent();status(name,"Waiting for streamed event doors ("..#doors.." loaded)");return 2
        end
        if not best then status(name,"Door cooldown: "..math.max(0,math.ceil(nextReady-now)).."s | Loaded: "..#doors);return 1 end
        -- Exit the door volume first so the server can arm a previous visit.
        status(name,"Teleporting to door")
        local outside=best.position+best.front*(best.range+10)
        local ok,why=ctx.MoveDoor(outside,active,best)
        if not ok then status(name,why);doorReady[best.key]=now+5;return 2 end
        ctx.Wait(.4) -- Allow the server's door check to observe the outside position.
        local latest=lastKnock
        if latest and latest.position then
            local earliest=latest.at+math.max(config.MIN_KNOCK_GAP,(best.position-latest.position).Magnitude/config.MAX_TRAVEL_SPEED)
            while active()and ctx.Now()<earliest do ctx.Wait(.1)end
        end
        if not active()then return end
        ok,why=ctx.MoveDoor(best.position+best.front*math.min(best.range*.6,6),active,best)
        if not ok then status(name,why);doorReady[best.key]=ctx.Now()+5;return 2 end
        status(name,"Waiting for server knock")
        local deadline=clock()+8
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
            if cfg[name]and waitFor then
                local ok,confirmed=pcall(waitFor.Check,d)
                if ok and confirmed then pending[name]=nil;finish(name,"Confirmed by live data")
                elseif clock()>waitFor.Until then pending[name]=nil;status(name,"No confirmation yet; rechecking live state");state.Next=clock()+3 end
            end
            if cfg[name]and not state.Busy and not pending[name]and clock()>=state.Next then
                local token=ctl.Generation[name];state.Busy=true;state.Started=clock()
                ctx.Spawn(function()
                    state.RunToken=token
                    local result=table.pack(xpcall(function()
                        if valid(name,token)then return handlers[name](name,token,data())end
                    end,debug.traceback))
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
