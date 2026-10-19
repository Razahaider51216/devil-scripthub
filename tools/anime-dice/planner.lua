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
function P.Units(data,registry)
    local result={}
    for id,item in pairs(data.Inventory or{})do
        local ok,config=pcall(registry.getEntryConfig,item.name)
        if ok and config and config.kind=="Unit"and P.Number(item.amount)>0 then
            local a=item.attributes or{}
            result[#result+1]={id=id,name=item.name,attributes=a,amount=item.amount,config=config,
                chance=P.Value(config.chance,a),income=P.Value(config.income,a),damage=P.Value(config.damage,a)}
        end
    end
    table.sort(result,function(a,b)if a.chance==b.chance then return a.id<b.id end;return a.chance>b.chance end)
    return result
end
function P.Protected(data,units,cfg)
    local protected={}
    if cfg.SelectedUnit and cfg.SelectedUnit~=""then protected[cfg.SelectedUnit]=true end
    for _,slot in pairs(data.Slots or{})do if slot.unitId then protected[slot.unitId]=true end end
    for _,id in pairs(data.TowerTeam or{})do protected[id]=true end
    local copies={}
    for i,u in ipairs(units)do
        copies[u.name]=(copies[u.name]or 0)+1
        local a=u.attributes
        if a.locked or a.favorite or cfg.KeepIds[u.id]or cfg.KeepNames[u.name]
            or i<=cfg.KeepBest or copies[u.name]<=cfg.KeepCopies
            or cfg.SkipMutations and(a.mutation and a.mutation~=""or a.variant and a.variant~="")then protected[u.id]=true end
    end
    return protected
end
function P.Materials(data,registry,cfg,limit,fusing)
    local units=P.Units(data,registry);local protected=P.Protected(data,units,cfg)
    local result={}
    if limit<=0 or data.PendingTrade then return result end
    for i=#units,1,-1 do
        local u=units[i]
        if not protected[u.id]and u.chance>0 and u.chance<=limit and(not fusing or u.amount==1 and not u.config.limited)then
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
        if wanted and P.Number(dice.luck)>P.Number(current.luck)and(owned or type(dice.price)=="number"and dice.price<=data.Money-cfg.MoneyReserve)then
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
