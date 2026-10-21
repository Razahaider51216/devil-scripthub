return function(A,K)
    local C={Stopped=false,Config={Farm=false,Train=false,Tower=false,Boss=false,Attack=false,Special=false,
        Collect=false,Sell=false,SellPets=false,Craft=false,Hatch=false,Equip=false,Upgrade=false,Rebirth=false,
        Rewards=false,Crates=false,RaceRoll=false,RaceEquip=false,Retreat=false,Stage=0,Dummy="Best available",
        PickupDistance=18,CombatDistance=8,ShellRarities={},PetRarities={},CraftShells={},CraftCount=4,
        KeepPets=1,UpgradeIds={BagCapacity=true,TrainBoost=true,LuckBoost=true},TowerCheckpoint=0,TowerStop=0,
        Crate="Secret",CrateCount=1,RaceStop="Secret",RaceKind="Fight",RetreatHP=20,Language="EN",AutoMount=true,AutoHub=true},
        Report={Version="hatch-to-fight-test-20261022-1",Jobs={},Sent=0,Observed=0,Events={},Errors={},
            Godmode="Unavailable: no verified server HP bypass in the supplied client dump"},Next={},Pending={},Rejected={},LastActivity=A.Now()}
    local cfg,R=C.Config,C.Report
    local primary={Farm=true,Train=true,Tower=true,Boss=true}
    local jobKeys={"Farm","Train","Tower","Boss","Attack","Special","Collect","Sell","SellPets","Craft","Hatch","Equip","Upgrade","Rebirth","Rewards","Crates","RaceRoll","RaceEquip","Retreat"}
    C.JobKeys=jobKeys
    local function num(v,default,lo,hi)
        v=tonumber(v);if not v or v~=v or math.abs(v)==math.huge then return default end
        return math.clamp(v,lo,hi)
    end
    C.Number=num
    local function state(job,text)R.Jobs[job]=tostring(text)end
    local function due(key,seconds)
        local now=A.Now();if (C.Next[key]or 0)>now then return false end
        C.Next[key]=now+seconds;return true
    end
    local function emit(job,key,...)
        if C.Stopped or (job and not cfg[job])then return false end
        local ok,err=A.Fire(key,...)
        if ok then R.Sent+=1;C.LastActivity=A.Now()else state(job or"Manual",err or"Remote unavailable")end
        return ok
    end
    local function call(job,lane,command,...)
        if C.Stopped or (job and not cfg[job])then return false end
        local args=table.pack(command,...)
        local accepted,why=A.Call(lane,args,function(ok,result)
            if C.Stopped then return end
            if ok then state(job or"Manual",lane.." / "..tostring(command)..": "..(type(result)=="table"and"state received"or tostring(result)))
            else state(job or"Manual",result or"Request failed")end
        end,job)
        if accepted then R.Sent+=1 else state(job or"Manual",why or"Waiting for pending request")end
        return accepted
    end
    local function rarityAllowed(filter,rarity)
        if next(filter)==nil then return true end
        return filter[rarity]==true
    end
    local function petDef(pet)return K.Pets.List[pet.id or pet.petId or""]end
    local function equipped(data,pet)
        return pet.uid==data.equipped or pet.uid==data.buffPet or pet.equipped==true or pet.locked==true or pet.favorite==true or pet.favourite==true
    end
    local function score(pet)
        local def=petDef(pet);if not def then return -1 end
        local attack=def.Abilities and def.Abilities.Attack or def.Attack or{}
        local special=def.Abilities and def.Abilities.Special or def.Special or{}
        return ((attack.Damage or 0)/math.max(.05,attack.Cooldown or 1)+(special.Damage or 0)/math.max(.05,special.Cooldown or 10))*(pet.sizeMult or 1)
    end
    C.Score=score;C.Protected=equipped
    local function move(job,point,look)
        if not point then state(job,"Destination is not streamed; refresh targets or travel to this world first");return false end
        if A.Now()<(C.ManualUntil or 0)then return false end
        if not due("move",.35)then return false end
        local ok,why=A.Move(point,look)
        if not ok then state(job,why or"Movement failed")end
        return ok
    end
    function C.StopAll()
        for _,job in ipairs(jobKeys)do cfg[job]=false;state(job,"Off")end
        A.CancelQueued();C.ManualUntil=nil;C.Service=nil
    end
    function C.Set(job,value)
        assert(table.find(jobKeys,job),"Unknown job")
        value=value==true
        if primary[job]and value then
            for other in pairs(primary)do if other~=job then cfg[other]=false;state(other,"Off")end end
        end
        cfg[job]=value;state(job,value and"Waiting for game state"or"Off")
        C.Next[job]=0
        if not value then A.CancelJob(job);if C.Service and C.Service.Job==job then C.Service=nil end end
    end
    function C.Export()
        local output={}
        for k,v in pairs(cfg)do output[k]=type(v)=="table"and table.clone(v)or v end
        return output
    end
    function C.Import(saved)
        assert(type(saved)=="table","Invalid saved settings")
        C.StopAll()
        for key,value in pairs(saved)do
            if type(cfg[key])=="number"then cfg[key]=num(value,cfg[key],0,1000000)
            elseif type(cfg[key])=="string"and type(value)=="string"and #value<120 then cfg[key]=value
            elseif type(cfg[key])=="table"and type(value)=="table"then
                local filter={};local count=0
                for item,on in pairs(value)do if type(item)=="string"and #item<100 and on==true and count<300 then filter[item]=true;count+=1 end end
                cfg[key]=filter
            end
        end
        if type(saved.AutoMount)=="boolean"then cfg.AutoMount=saved.AutoMount end
        if type(saved.AutoHub)=="boolean"then cfg.AutoHub=saved.AutoHub end
        cfg.Stage=math.floor(num(cfg.Stage,0,0,60));cfg.CraftCount=math.floor(num(cfg.CraftCount,4,4,32))
        cfg.CombatDistance=num(cfg.CombatDistance,8,3,30);cfg.PickupDistance=num(cfg.PickupDistance,18,3,30)
        cfg.CrateCount=cfg.CrateCount==3 and 3 or 1;cfg.RetreatHP=num(cfg.RetreatHP,20,1,90)
        cfg.KeepPets=math.floor(num(cfg.KeepPets,1,1,10000));cfg.TowerCheckpoint=math.floor(num(cfg.TowerCheckpoint,0,0,10000))
        cfg.TowerStop=math.floor(num(cfg.TowerStop,0,0,1000000))
        if not K.Crates.List[cfg.Crate]then cfg.Crate="Secret"end
        if cfg.Language~="TH"then cfg.Language="EN"end
        for _,job in ipairs(jobKeys)do if saved[job]==true then C.Set(job,true)end end
    end
    function C.Observe(name,...)
        if C.Stopped then return end
        R.Observed+=1;C.LastActivity=A.Now();R.Events[name]=(R.Events[name]or 0)+1
        if name=="Tower:floor"then local d=...;if type(d)=="table"then R.TowerFloor=d.floor end end
        if name=="Tower:cleared"then local d=...;if type(d)=="table"then R.LastTowerReward=d end end
        if name=="FightEnded"then R.LastFight={...}end
    end
    function C.WarpStage(index)
        index=math.floor(num(index,1,1,60))
        local point,look=A.StagePoint(index)
        local ok,why=A.Move(point,look)
        C.ManualUntil=A.Now()+2
        state("Manual",ok and("Moved to Stage "..index.."; waiting for server FightStage="..index)or why or"Stage not streamed")
        return ok
    end
    function C.TravelWorld(world)
        return call(nil,"Meta","Travel",math.floor(num(world,1,1,12)))
    end
    function C.ReturnHome()C.ManualUntil=A.Now()+2;return emit(nil,"RequestReturnHome")end
    function C.Refresh()A.Refresh(true)end
    local function serviceSignature(job,d)
        if type(d)~="table"then return "no-data"end
        if job=="Hatch"then
            local ids={};for _,egg in ipairs(d.eggs or{})do table.insert(ids,tostring(egg.uid))end
            table.sort(ids);return table.concat(ids,",").."/pets="..#(d.pets or{})
        elseif job=="Upgrade"then
            local values={};for _,id in ipairs(K.Upgrades.Order)do table.insert(values,id.."="..tostring(d.upgrades and d.upgrades[id]or 0))end
            return table.concat(values,",")
        end
        local values={};for id,n in pairs(d.shells or d.bag or{})do table.insert(values,tostring(id).."="..tostring(n))end
        table.sort(values);return table.concat(values,",")..(job=="Craft"and"/eggs="..#(d.eggs or{})or"")
    end
    local function hubService(s)
        if s.InFight or not cfg.AutoHub then C.Service=nil;return false end
        local d=A.Cache.Data
        if C.Service then
            local service=C.Service
            local changed=serviceSignature(service.Job,d)~=service.Signature
            if not cfg[service.Job]or changed or A.Now()-service.Started>12 then
                if not changed and cfg[service.Job]then state(service.Job,"Hub visit timed out without a data change; retrying later")end
                C.Service=nil;C.Next["hub-service"]=A.Now()+3
            end
        end
        if not C.Service and type(d)=="table"and A.Now()>=(C.Next["hub-service"]or 0)then
            local selected,place
            if cfg.Hatch and #(d.eggs or{})>0 and #(d.pets or{})<(d.maxPets or K.Economy.MaxPets)+A.Attr("BonusPets",0)then selected,place="Hatch","EggForge"
            elseif cfg.Craft and #(d.eggs or{})<K.Forge.MaxEggs then
                local available=0
                for id,count in pairs(d.shells or d.bag or{})do
                    if type(count)=="number"and(next(cfg.CraftShells)==nil or cfg.CraftShells[id])then available+=count end
                end
                if available>=4 then selected,place="Craft","EggForge"end
            end
            if not selected and cfg.Sell and ((d.bagCount or 0)>=(d.bagCapacity or math.huge)or not(cfg.Farm or cfg.Train or cfg.Tower or cfg.Boss))then
                for id,count in pairs(d.shells or d.bag or{})do
                    local egg=K.Eggs.List[id]
                    if type(count)=="number"and count>0 and egg and rarityAllowed(cfg.ShellRarities,egg.Rarity)
                        and not(cfg.Craft and(next(cfg.CraftShells)==nil or cfg.CraftShells[id]))then selected,place="Sell","Sell";break end
                end
            end
            if not selected and cfg.Upgrade then
                for _,id in ipairs(K.Upgrades.Order)do
                    local spec=K.Upgrades.Upgrades[id];local level=d.upgrades and d.upgrades[id]or 0
                    local price=spec.costs and spec.costs[level+1]or spec.baseCost*spec.costGrowth^level
                    if cfg.UpgradeIds[id]and level<spec.maxLevel and(d.coins or A.Attr("Coins",0))>=price then selected,place="Upgrade","Upgrades";break end
                end
            end
            if selected then C.Service={Job=selected,Place=place,Signature=serviceSignature(selected,d),Started=A.Now()}end
        end
        local service=C.Service
        if service then
            if not A.NearHub(service.Place,30)then move(service.Job,A.HubPoint(service.Place))end
            state("Movement","Hub visit for "..service.Job.."; primary mode resumes after data changes")
            return true
        end
        return false
    end
    local function combat()
        local current=A.Snapshot()
        if not current.Mounted then
            if cfg.AutoMount and(cfg.Farm or cfg.Tower or cfg.Boss)and due("mount",4)then
                local ok=A.Fire("EquipPet",current.PetId or K.Pets.Starter)
                if ok then R.Sent+=1;state("Attack","Mount requested")end
            end
            return
        end
        if not current.Mob then return end
        local def=K.Pets.List[current.PetId or K.Pets.Starter]
        if not def then state("Attack","Pet data unavailable");return end
        for _,slot in ipairs({"Attack","Special"})do
            local enabled=cfg[slot]or cfg.Farm or cfg.Tower or cfg.Boss
            local ability=def.Abilities and def.Abilities[slot]or def[slot]
            if enabled and ability then
                local range=slot=="Special"and 150 or(ability.Range or 8)+2
                local seconds=(ability.Cooldown or(slot=="Attack"and .6 or 10))*(slot=="Special"and(current.SpecialCooldownMult or 1)or 1)
                if current.Mob.Distance<=range and due("ability:"..slot,math.max(.1,seconds))then
                    -- Fire the same slot request as the native client. Damage is server-owned.
                    local ok,why=A.Fire("Ability",slot)
                    if ok then R.Sent+=1;state(slot,"Requested "..slot.."; awaiting game effects")else state(slot,why)end
                end
            end
        end
    end
    local function primaryStep(s)
        if cfg.Retreat and s.HP and s.MaxHP and s.HP>0 and s.HP/s.MaxHP*100<=cfg.RetreatHP then
            if due("retreat",8)then emit("Retreat","RequestReturnHome");C.RecoveryUntil=A.Now()+10;state("Retreat","Return requested at low HP; not invulnerability")end
        end
        if A.Now()<(C.RecoveryUntil or 0)then return end
        if hubService(s)then return end
        if s.InFight and s.Mob and (cfg.Farm or cfg.Tower or cfg.Boss)then
            local job=cfg.Tower and"Tower"or cfg.Boss and"Boss"or"Farm"
            if s.Mob.Distance>cfg.CombatDistance+3 then move(job,A.Approach(s.Mob,cfg.CombatDistance),s.Mob.Pos)end
            state(job,"Fighting "..(s.Mob.Name or"target").." | HP "..tostring(s.Mob.HP))
            return
        end
        if cfg.Tower then
            if cfg.TowerStop>0 and (R.TowerFloor or 0)>=cfg.TowerStop then state("Tower","Floor limit reached; waiting for you to change the limit");return end
            if s.InFight then state("Tower","Waiting for current fight");return end
            local tower=A.Cache.Tower
            if type(tower)~="table"then state("Tower","Waiting for Tower state");return end
            if tower.open~=true then state("Tower","Tower opens after Stage "..K.Tower.OpenAfterStage);return end
            if (tower.tickets or 0)<1 then state("Tower","Waiting for tickets");return end
            local checkpoint=cfg.TowerCheckpoint
            if checkpoint>0 and not(tower.owned and(tower.owned[checkpoint]or tower.owned[tostring(checkpoint)]))then state("Tower","Selected checkpoint is not owned");return end
            if due("Tower",5)then call("Tower","Tower","Climb",checkpoint,nil)end
        elseif cfg.Boss then
            if s.InFight then state("Boss","Waiting for current fight");return end
            if not s.BossAlive then state("Boss","Waiting for World Boss");return end
            if due("Boss",5)then emit("Boss","WorldBoss","Enter")end
        elseif cfg.Farm then
            if s.InFight then state("Farm","Waiting for spawned enemies / next wave");return end
            local stage=cfg.Stage>0 and cfg.Stage or math.min(60,(s.StagesCleared or 0)+1)
            if stage>(s.StagesCleared or 0)+1 then state("Farm","Stage locked; use the separate warp test to inspect it");return end
            if due("Farm",1.5)then local point,look=A.StagePoint(stage);move("Farm",point,look)end
            state("Farm","Entering Stage "..stage.."; server FightStage="..tostring(s.FightStage))
        elseif cfg.Train then
            if s.InFight then state("Train","Waiting for current fight");return end
            local dummy=A.Dummy(cfg.Dummy,K.Training.Dummies,s)
            if not dummy then state("Train","No available training dummy");return end
            if dummy.Distance>16 then move("Train",dummy.Pos,dummy.Look);state("Train","Moving to "..dummy.Name);return end
            if due("Train",math.max(.3,K.Progression.HitCooldown or .3))then emit("Train","RequestTrainHit")end
            state("Train","Training "..dummy.Name.."; PowerGain events: "..tostring(R.Events.PowerGain or 0))
        end
    end
    local function collect(s)
        if not cfg.Collect or not due("Collect",.3)then return end
        local data=A.Cache.Data
        if data and data.bagCapacity and (data.bagCount or 0)>=data.bagCapacity then state("Collect","Bag full; waiting for Sell/Craft");return end
        local drop=A.Drop(cfg.ShellRarities)
        if not drop then state("Collect","Waiting for eligible shells");return end
        if drop.Distance>cfg.PickupDistance then
            if s.InFight or cfg.Train then state("Collect","Waiting for nearby drops during current activity");return end
            if not(cfg.Farm or cfg.Tower or cfg.Boss)then move("Collect",drop.Pos,drop.Pos)end
            return
        end
        if due("pickup:"..drop.Key,1.5)then emit("Collect","RequestPickupShell",drop.Ref);state("Collect","Pickup requested: "..drop.Name)end
    end
    local function inventory(s)
        local d=A.Cache.Data;if type(d)~="table"then return end
        if cfg.Equip and due("Equip",3)then
            local best,bestScore=nil,-1
            for _,p in ipairs(d.pets or{})do local n=score(p);if n>bestScore then best,bestScore=p,n end end
            if best and best.uid~=d.equipped then emit("Equip","RequestEquipPet",best.uid);state("Equip","Equip requested: "..tostring(best.id))end
        end
        if cfg.SellPets and due("SellPets",3)then
            local candidates={};local pets=d.pets or{}
            for _,p in ipairs(pets)do local def=petDef(p)
                if p.uid and def and not equipped(d,p)and rarityAllowed(cfg.PetRarities,def.Rarity)then table.insert(candidates,p)end
            end
            table.sort(candidates,function(a,b)return score(a)<score(b)end)
            if #pets>cfg.KeepPets and candidates[1]then emit("SellPets","RequestSellPet",candidates[1].uid);state("SellPets","Sell requested for unused "..tostring(candidates[1].id))end
        end
        if cfg.Hatch and due("Hatch",3)then
            if #(d.pets or{})>=(d.maxPets or K.Economy.MaxPets or 50)+A.Attr("BonusPets",0)then state("Hatch","Pet storage full")
            elseif A.NearHub("EggForge",K.Forge.UseRange or 40)then
                for _,egg in ipairs(d.eggs or{})do if egg.uid then emit("Hatch","RequestHatchEgg",egg.uid);state("Hatch","Hatch requested: "..tostring(egg.uid));break end end
            else state("Hatch","Waiting to visit the forge")end
        end
        if s.InFight then return end
        local shellCounts=d.shells or d.bag or{}
        if cfg.Craft and due("Craft",3.2)then
            local recipe={};local total=0
            for _,id in ipairs(K.Eggs.Order or{})do
                local amount=shellCounts[id]or 0
                if amount>0 and (next(cfg.CraftShells)==nil or cfg.CraftShells[id])then
                    local n=math.min(8,amount,cfg.CraftCount-total)
                    if n>0 and #recipe<4 then table.insert(recipe,{id,n});total+=n end
                    if total>=cfg.CraftCount then break end
                end
            end
            if total<4 then state("Craft","Waiting for 4+ matching shells")
            elseif #(d.eggs or{})>=K.Forge.MaxEggs then state("Craft","Egg storage full")
            elseif A.NearHub("EggForge",K.Forge.UseRange or 40)then emit("Craft","RequestCraftEgg",recipe);state("Craft","Craft requested: "..total.." shells")
            elseif not(cfg.Farm or cfg.Train or cfg.Tower or cfg.Boss)then move("Craft",A.HubPoint("EggForge"));state("Craft","Moving to forge")
            else state("Craft","Waiting to visit the forge")end
        end
        if cfg.Sell and due("Sell",3)then
            local sell={};local total=0
            for id,count in pairs(shellCounts)do
                local egg=K.Eggs.List and K.Eggs.List[id]
                if type(count)=="number"and count>0 and egg and rarityAllowed(cfg.ShellRarities,egg.Rarity or egg.rarity)then
                    -- Shells selected for crafting are reserved when both jobs run.
                    if not(cfg.Craft and(next(cfg.CraftShells)==nil or cfg.CraftShells[id]))then sell[id]=count;total+=count end
                end
            end
            if total==0 then state("Sell","No matching shells (craft selections are reserved)")
            elseif A.NearHub("Sell",35)then emit("Sell","RequestSell",sell);state("Sell","Sell requested: "..total.." shells")
            elseif not(cfg.Farm or cfg.Train or cfg.Tower or cfg.Boss or cfg.Craft)then move("Sell",A.HubPoint("Sell"));state("Sell","Moving to shop")
            else state("Sell","Waiting to visit Sell")end
        end
    end
    local function extras(s)
        local m=A.Cache.Meta
        if cfg.Upgrade and due("Upgrade",3)then
            local d=A.Cache.Data or{}
            for _,id in ipairs(K.Upgrades.Order)do
                local spec=K.Upgrades.Upgrades[id];local level=(d.upgrades and d.upgrades[id])or 0
                local cost=spec.costs and spec.costs[level+1]or spec.baseCost*spec.costGrowth^level
                if cfg.UpgradeIds[id]and level<spec.maxLevel and (d.coins or A.Attr("Coins",0))>=cost then
                    if A.NearHub("Upgrades",35)then emit("Upgrade","RequestBuyUpgrade",id)
                    elseif not s.InFight and not(cfg.Farm or cfg.Train or cfg.Tower or cfg.Boss)then move("Upgrade",A.HubPoint("Upgrades"))end
                    break
                end
            end
        end
        if cfg.Rebirth and due("Rebirth",5)then
            local rebirths=A.Attr("Rebirths",0);local required=K.RebirthLevels[rebirths]
            if required and A.Attr("Level",1)>=required then emit("Rebirth","RequestRebirth")else state("Rebirth","Waiting for level "..tostring(required or"requirement not in dump"))end
        end
        if cfg.Rewards and type(m)=="table"and due("Rewards",1.5)then
            if m.daily and m.daily.canClaim then call("Rewards","Meta","ClaimDaily");return end
            if m.gifts then for i,gift in ipairs(K.Rewards.Gifts or{})do
                local claimed=m.gifts.claimed and(m.gifts.claimed[i]or m.gifts.claimed[tostring(i)])
                if not claimed and (m.gifts.elapsed or 0)>=gift.minutes*60 then call("Rewards","Meta","ClaimGift",i);return end
            end end
            if m.quests and type(m.quests.list)=="table"then
                local all=#m.quests.list>0
                for i,quest in ipairs(m.quests.list)do
                    if not quest.claimed then all=false;if (quest.progress or 0)>=(quest.target or math.huge)then call("Rewards","Meta","ClaimQuest",i);return end end
                end
                if all and not m.quests.bonus then call("Rewards","Meta","ClaimQuestBonus")end
            end
            local tower=A.Cache.Tower
            if tower and tower.open and tower.daily then call("Rewards","Tower","Daily",nil,nil)end
        end
        if cfg.Crates and type(m)=="table"and due("Crates",4)then
            local spec=K.Crates.List[cfg.Crate]
            if spec and spec.keys and(m.keys or 0)>=cfg.CrateCount then call("Crates","Meta","OpenCrate",cfg.Crate,cfg.CrateCount)
            else state("Crates","Waiting for selected crate keys/state")end
        end
        local races=A.Cache.Race
        if cfg.RaceRoll and type(races)=="table"and due("RaceRoll",4)then
            local stop=false
            for id,stars in pairs(races.stars or{})do
                local spec=K.Races.List[id]
                local rank=spec and table.find(K.Rarities.Order,spec.Rarity)
                local stopRank=table.find(K.Rarities.Order,cfg.RaceStop)
                if (tonumber(stars)or 0)>0 and rank and stopRank and rank>=stopRank then stop=true;break end
            end
            if stop then state("RaceRoll","Selected stop rarity owned; waiting")
            elseif(races.rolls or 0)>0 then call("RaceRoll","Race","Roll",nil)
            else state("RaceRoll","No race rolls")end
        end
        if cfg.RaceEquip and type(races)=="table"and due("RaceEquip",4)then
            local best,points
            for slot,id in ipairs(races.slots or{})do
                local stars=races.stars and races.stars[id]or 1
                local def=K.Races.List[id]
                if def and def.Kind==cfg.RaceKind and races.open and races.open[slot]and(tonumber(stars)or 0)>0 then
                    local n=0;for _,v in pairs(def.Stats or{})do if type(v)=="number"then n+=v end end;n*=K.Races.StarMult[tonumber(stars)]or 1
                    if not points or n>points then best,points=slot,n end
                end
            end
            if best and races.equipped~=best and not s.InFight then call("RaceEquip","Race","Equip",best)end
        end
    end
    local workers={{"Movement",primaryStep},{"Combat",combat},{"Collect",collect},{"Inventory",inventory},{"Extras",extras}}
    function C.Tick()
        if C.Stopped then return end
        local any=false;for _,job in ipairs(jobKeys)do if cfg[job]then any=true;break end end
        if not any then return end
        A.Refresh(false,cfg)
        local blocked=A.Blocked()
        if blocked then R.Blocked=blocked;return end;R.Blocked=nil
        local s=A.Snapshot()
        for _,worker in ipairs(workers)do
            local name,fn=worker[1],worker[2]
            if due("worker:"..name,.1)then
                local ok,err=pcall(fn,s)
                if not ok then R.Errors[name]=tostring(err);C.Next["worker:"..name]=A.Now()+2 end
            end
        end
        if A.Now()-C.LastActivity>20 then R.Watchdog="No recent confirmed game events; jobs remain enabled, checking targets/state"else R.Watchdog=nil end
    end
    function C.Destroy()if C.Stopped then return end;C.StopAll();C.Stopped=true;A.Destroy()end
    return C
end
