local P={}
P.Jobs={"Dig","FarmFinds","Plant","Hatch","SellLoot","SellEggs","SellPets","BuyShovel","BuyGear","EquipPets","TrainingUpgrade","PlotUpgrade","HoleLuck","AnimalIncome","Rebirth","Potions","Daily","Offline","PetIndex","EventEggs","EventWaves","UseGear","Pumpkin","Train"}
function P.Defaults()
    local c={AimRate=20,FastDig=true,Reserve=0,FindKind="All",FindRarity="All",TeleportKind="Egg",TeleportChoice="",Shovel="Best affordable",Gear="",GearLimit=1,Potion="DigSpeed",UseGearId="",RebirthLimit=1,TrainSeconds=120,DigSeconds=300,Rotate=false}
    for _,key in ipairs(P.Jobs)do c[key]=false end
    return c
end
function P.Number(v,fallback,lo,hi)
    v=tonumber(v);if not v or v~=v or math.abs(v)==math.huge then return fallback end
    return math.clamp(v,lo or 0,hi or 1e30)
end
function P.Affordable(cost,cash,reserve)return type(cost)=="number"and cost>=0 and cost<=math.max(0,(tonumber(cash)or 0)-(tonumber(reserve)or 0))end
function P.ShopChoice(tiers,snapshot,choice,cash,reserve,active)
    if type(snapshot)~="table"or type(snapshot.Owned)~="table"then return end
    local best
    for _,item in ipairs(tiers or{})do
        if not item.WorldOnly and not item.RobuxOnly and item.Kind~="Drill"and (choice=="Best affordable"or item.Id==choice)then
            if snapshot.Owned[item.Id]or P.Affordable(item.Cost,cash,reserve)then
                if not best or (item.Multiplier or 0)>(best.Multiplier or 0)then best=item end
            end
        end
    end
    if not best or best.Id==active then return end
    return best,snapshot.Owned[best.Id]and "Equip"or "Buy"
end
function P.Quote(snapshot,key)
    local s=type(snapshot)=="table"and snapshot[key]
    if type(s)=="table"and (tonumber(s.Count)or 0)>0 and s.Quote~=nil then return s.Quote end
end
function P.ReadyEggs(snapshot,now)
    local ready={};for _,e in ipairs(type(snapshot)=="table"and snapshot.Eggs or{})do
        if e.Id and type(e.ReadyAt)=="number"and e.ReadyAt<=now and not e.Hatching then ready[#ready+1]=e.Id end
    end;return ready
end
function P.DropEligible(drop,claimed,now,deadline)
    return type(drop)=="table"and type(drop.Index)=="number"and type(drop.LandTime)=="number"and now>=drop.LandTime and now<deadline and not drop.Claimed and not drop.Expired and not(claimed and claimed[drop.Index])
end
function P.Settings(raw)
    local out=P.Defaults();if type(raw)~="table"then return out end
    for key,default in pairs(out)do
        local v=raw[key]
        if type(default)=="boolean"then if type(v)=="boolean"then out[key]=v end
        elseif type(default)=="number"then out[key]=P.Number(v,default)
        elseif type(v)=="string"and #v<=120 then out[key]=v end
    end
    out.AimRate=P.Number(out.AimRate,20,5,40);out.GearLimit=math.floor(P.Number(out.GearLimit,1,1,25))
    out.RebirthLimit=math.floor(P.Number(out.RebirthLimit,1,1,100))
    out.TrainSeconds=P.Number(out.TrainSeconds,120,15,900);out.DigSeconds=P.Number(out.DigSeconds,300,15,900)
    return out
end
function P.Money(v)
    v=tonumber(v);if not v then return "?"end
    for _,pair in ipairs({{1e18,"Qi"},{1e15,"Qa"},{1e12,"T"},{1e9,"B"},{1e6,"M"},{1e3,"K"}})do if v>=pair[1]then return string.format("%.2f%s",v/pair[1],pair[2])end end
    return string.format("%.0f",v)
end
return P
