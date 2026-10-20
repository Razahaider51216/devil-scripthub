-- Pure selection rules, shared by the runtime and offline tests.
local P = {}
P.Tiers = {"Exclusive","Royal","Astral","Radiant","Eternal","Celestial","Divine","Mythic","Legendary","Epic","Rare","Uncommon","Common"}
P.Variants = {"Rainbow","Ruby","Diamond","Golden","Normal"}
P.Mutations = {"All","None","Festive","Hacked","Lava","Candy"}
local ranks = {}; for i, name in ipairs(P.Tiers) do ranks[name] = #P.Tiers-i+1 end
function P.Set(values)
    local out = {}
    for key, value in pairs(values or {}) do
        if type(key)=="number" then out[value]=true elseif value==true then out[key]=true end
    end
    return out
end
function P.Defaults()
    return {Farm=false,AutoStore=true,AutoPlace=false,AutoHatch=false,AutoTrain=false,AutoBonus=false,
        AutoBase=false,AutoTreadmill=false,AutoStamina=false,AutoRebirth=false,AutoEquip=false,
        AutoDaily=false,AutoGifts=false,AutoIndex=false,AutoOffline=false,AutoGroup=false,
        AutoTrails=false,AutoFuse=false,AutoSell=false,AutoEvent=false,EggESP=false,
        Tiers={Epic=true,Legendary=true,Mythic=true},Variants={All=true},Mutations={All=true},
        SellTiers={},FuseTiers={Common=true,Uncommon=true,Rare=true},KeepBest=true,
        ReserveCash=0,FlySpeed=60,Language="TH",Theme="Crimson",Width=790,Height=550,
        Transparent=false,HideName=false,HideAvatar=false,ToggleButton=true}
end
function P.Match(egg, config)
    if not config.Tiers[egg.rarity] then return false end
    if not (config.Variants.All or config.Variants[egg.variant or "Normal"]) then return false end
    return config.Mutations.All or config.Mutations[egg.mutation or "None"]==true
end
function P.Choose(eggs, config, eventMutation)
    local best
    for _, egg in ipairs(eggs) do
        if egg.enabled and P.Match(egg,config) then
            local event = config.AutoEvent and eventMutation and egg.mutation==eventMutation and 1 or 0
            egg.priority = event
            if not best or event>best.priority or (event==best.priority and
                ((ranks[egg.rarity] or 0)>(ranks[best.rarity] or 0) or
                (egg.rarity==best.rarity and egg.distance<best.distance))) then best=egg end
        end
    end
    return best
end
function P.Protected(item, equipped, id)
    local d=item.CustomData or {}
    return item.Locked==true or item.Favorite==true or item.Favourited==true or item.IsLocked==true
        or d.Locked==true or d.Favorite==true or item.Placed==true or equipped[id]==true
end
function P.SellCandidates(inventory, equipped, config, rarity, score)
    local bestId, bestScore
    if config.KeepBest then
        for id,item in pairs(inventory) do
            if type(item)=="table" and item.Handler=="Animal" then
                local value=score(item)
                if not bestScore or value>bestScore then bestId,bestScore=id,value end
            end
        end
    end
    local out={}
    for id,item in pairs(inventory) do
        if type(item)=="table" and item.Handler=="Animal" and config.SellTiers[rarity(item.Name)]
            and id~=bestId and not P.Protected(item,equipped,id) then
            out[#out+1]={id=id,item=item,score=score(item)}
        end
    end
    table.sort(out,function(a,b) return a.score<b.score end)
    return out
end
function P.FuseCandidates(inventory, equipped, config, rarity, score, selected)
    local groups={}
    local nextVariant={Normal="Golden",Golden="Diamond",Diamond="Ruby",Ruby="Rainbow"}
    for id,item in pairs(inventory) do
        if type(item)=="table" and item.Handler=="Animal" and config.FuseTiers[rarity(item.Name)]
            and not P.Protected(item,equipped,id) and not selected[id] then
            local d=item.CustomData or {}; local variant=d.Variant or item.Variant or "Normal"
            if nextVariant[variant] then
                -- Preserve different mutations as separate recipes.
                local key=item.Name.."\0"..variant.."\0"..(d.Mutation or "None")
                groups[key]=groups[key] or {}
                table.insert(groups[key],{id=id,item=item,score=score(item)})
            end
        end
    end
    local chosen
    for _,group in pairs(groups) do
        table.sort(group,function(a,b) return a.score<b.score end)
        if #group>=3 and (not chosen or group[1].score<chosen[1].score) then chosen=group end
    end
    return chosen and {chosen[1],chosen[2],chosen[3]} or nil
end
function P.Validate(saved)
    if type(saved)~="table" then return nil,"Invalid settings" end
    local out=P.Defaults()
    for key,value in pairs(saved) do
        local default=out[key]
        if type(default)=="boolean" then
            if type(value)~="boolean" then return nil,"Invalid toggle: "..key end
            out[key]=value
        elseif type(default)=="table" then
            if type(value)~="table" then return nil,"Invalid filter: "..key end
            local set={};for name,enabled in pairs(value) do
                if type(name)~="string" or type(enabled)~="boolean" then return nil,"Invalid filter: "..key end
                if enabled then set[name]=true end
            end;out[key]=set
        elseif type(default)=="number" then
            if type(value)~="number" or value~=value or math.abs(value)==math.huge then return nil,"Invalid number: "..key end
            out[key]=value
        elseif type(default)=="string" then
            if type(value)~="string" then return nil,"Invalid text: "..key end
            out[key]=value
        end
    end
    out.ReserveCash=math.max(0,out.ReserveCash)
    out.FlySpeed=math.clamp(out.FlySpeed,10,500)
    out.Width=math.clamp(out.Width,600,1100);out.Height=math.clamp(out.Height,400,800)
    if out.Language~="TH" and out.Language~="EN" then return nil,"Invalid language" end
    local themes={Crimson=true,Midnight=true,Ocean=true,Emerald=true,Mono=true,Obsidian=true}
    if not themes[out.Theme] then return nil,"Invalid theme" end
    return out
end
return P
