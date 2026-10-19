-- Standalone TEST entry. The production router is intentionally unchanged.
assert(game.GameId==10708913337 or game.PlaceId==113290951185459,"Open Anime Dice before running this test")
local scope=type(getgenv)=="function"and getgenv()or _G
local release="anime-dice-test-20261020-2"
local previous=scope.DevilAnimeDiceTest
if previous and not previous.Stopped then
    if previous.Version==release then return previous end
    assert(type(previous.Destroy)=="function","Close the previous Anime Dice test before updating")
    previous.Destroy()
end
if scope.DevilAnimeDiceStarting and os.clock()-scope.DevilAnimeDiceStarting.At<30 then warn("DEVIL HUB: Anime Dice test is already starting");return end
local startup={At=os.clock()};scope.DevilAnimeDiceStarting=startup
local planner=(function()
-- ANIME_PLANNER
end)()
local makeAdapter=(function()
-- ANIME_ADAPTER
end)()
local makeCore=(function()
-- ANIME_CORE
end)()
local ctx=makeAdapter(scope)
local core=makeCore(ctx,planner)
local cfg=core.Config
local app={Core=core,Config=cfg,Report=core.Report,Version=core.Report.Version,Stopped=false}
local window,library
local links,widgets,optionWidgets={}, {}, {}
local function destroy()
    if app.Stopped then return end
    app.Stopped=true;core.Destroy()
    for _,link in ipairs(links)do link:Disconnect()end
    if window then window:Destroy()end
    if scope.DevilAnimeDiceTest==app then scope.DevilAnimeDiceTest=nil end
    if scope.DevilAnimeDiceStarting==startup then scope.DevilAnimeDiceStarting=nil end
end
app.Destroy=destroy
local ok,problem=xpcall(function()
    -- SHARED_BLUE_BOOTSTRAP
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    assert(type(source)=="string"and #source==__OURO_LEN__,"GUI download size mismatch")
    local checksum=0;for i=1,#source do checksum=(checksum*33+source:byte(i))%4294967296 end
    assert(checksum==__OURO_HASH__,"GUI download checksum mismatch")
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
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,LoadingSubtitle="ANIME DICE / TEST",
        Theme=theme,Density="Compact",Profile=true,Search=true,Home=false,Loading=false,Backdrop=false,
        UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(840,570),
        ToggleButton={Platform="Both",Icon=image},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false}})
    app.Window=window;window.Gui:SetAttribute("DevilHubPresentation",true)
    links[#links+1]=window.Gui.Destroying:Connect(destroy)
    local function group(tab,name,side)return tab:CreateGroupbox({Name=name,Side=side or"Left"})end
    local function tab(name,icon)return window:CreateTab({Name=name,Icon=icon,Backdrop=false})end
    local function toggle(host,key,name)
        local widget=host:CreateToggle({Name=name,CurrentValue=false,Callback=function(v)core.Set(key,v)end})
        widgets[key]=widget;return widget
    end
    local function input(host,key,name,default)
        return host:CreateInput({Name=name,CurrentValue=tostring(default or cfg[key]),Callback=function(v)
            local parse=key:find("Chance",1,true)and planner.Chance or planner.Number
            cfg[key]=parse(v,cfg[key])
        end})
    end
    local function multi(value)
        local set={};for k,v in pairs(value or{})do local name=type(k)=="number"and v or v==true and k;if type(name)=="string"then set[name]=true end end
        return set
    end
    local function dropdown(host,key,name,options,default,multiple,convert)
        local widget=host:CreateDropdown({Name=name,Options=options or{},CurrentOption=multiple and{}or default,MultipleOptions=multiple,
            AllowNone=multiple==true,Searchable=true,Callback=function(v)
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
    dropdown(buy,"DiceChoice","Dice selection",{"Best affordable"},"Best affordable")
    toggle(buy,"Upgrade","Auto Upgrade Tree")
    dropdown(buy,"UpgradeBranch","Upgrade branch",{"All","Money","Luck","Damage","Health","Unit Storage","Roll","Trait","Grade"},"All")
    input(buy,"MoneyReserve","Money reserve")
    local overview=group(main,"Live status","Right")
    local summary=overview:CreateLabel({Text="Connecting game modules..."})
    local resultLabel=overview:CreateLabel({Text="All automation starts off."})
    button(overview,"Stop all automation",core.StopAll)
    local inventory=tab("Inventory","backpack")
    local sell=group(inventory,"Sell and protect")
    toggle(sell,"Sell","Auto Sell Filtered Units")
    local sellLimit=input(sell,"SellChanceMax","Sell maximum chance (0 = off)")
    input(sell,"KeepBest","Keep best units")
    input(sell,"KeepCopies","Keep copies per character")
    sell:CreateToggle({Name="Keep mutated / variant units",CurrentValue=true,Callback=function(v)cfg.SkipMutations=v end})
    dropdown(sell,"KeepNames","Keep character names",{},nil,true)
    local keepIdLabels={}
    -- The callback maps friendly labels back to current live inventory IDs.
    local function mapIds(selected)
        local set={};for label in pairs(multi(selected))do if keepIdLabels[label]then set[keepIdLabels[label]]=true end end;cfg.KeepIds=set
    end
    local keepWidget=sell:CreateDropdown({Name="Keep specific units",Options={},CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,Callback=mapIds})
    optionWidgets.KeepIds=keepWidget
    button(sell,"Disable game Auto Sell",function()ctx.Fire("SellService","UpdateAutoSell",0)end)
    button(sell,"Use game sell threshold",function()
        local d=ctx.Snapshot();assert(d,"Waiting for live data")
        cfg.SellChanceMax=planner.Number(d.AutoSell)
        sellLimit:Set(tostring(cfg.SellChanceMax),true)
    end)
    local sellStatus=sell:CreateLabel({Text="Set Sell maximum chance above 0 (example: 1/1,000)."})
    local preview=sell:CreateLabel({Text="Preview matching units before selling or fusing."})
    button(sell,"Preview sale",function()
        local items=core.Preview("Sell");local names={}
        for i=1,math.min(8,#items)do names[#names+1]=items[i].name.." | 1 / "..string.format("%.3g",items[i].chance)end
        preview:Set(tostring(#items).." matching units\n"..table.concat(names,"\n"))
    end)
    local materials=group(inventory,"Lock and fusion","Right")
    toggle(materials,"Lock","Auto Lock Rare Units")
    input(materials,"LockChanceMin","Lock minimum chance (0 = off)")
    toggle(materials,"Fuse","Auto Fuse Surplus Units")
    input(materials,"FuseChanceMax","Fuse maximum chance (0 = off)")
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
    local protectedChoices={Trait={},Grade={},Quirk={}}
    local protectionWidgets={}
    for _,kind in ipairs({"Trait","Grade","Quirk"})do
        protectionWidgets[kind]=protection:CreateDropdown({Name="Protect "..kind,Options={},CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,
            Callback=function(v)protectedChoices[kind]=multi(v)end})
        button(protection,"Apply "..kind.." protection",function()
            local c=ctx.Catalog[kind=="Trait"and"Traits"or kind=="Grade"and"Grades"or"Quirks"]or{}
            local values={};for name in pairs(c)do values[name]=protectedChoices[kind][name]==true end;core.Protect(kind,values)
        end)
    end
    local items=tab("Items and rewards","gift")
    local use=group(items,"Items and gear")
    dropdown(use,"BoostNames","Boosts to use",{},nil,true);toggle(use,"Boost","Auto Use Selected Boosts")
    dropdown(use,"SpinNames","Spins to use",{},nil,true);toggle(use,"Spin","Auto Use Selected Spins")
    dropdown(use,"GearPriority","Gear priority",{"Luck","Money","Damage","Health","Roll","Candy","Pumpkin"},"Luck")
    toggle(use,"Gear","Auto Equip Gear")
    local rewards=group(items,"Rewards and codes","Right")
    toggle(rewards,"Rewards","Auto Claim Daily / Group / Offline")
    toggle(rewards,"Quests","Auto Claim Completed Quests")
    dropdown(rewards,"QuestOffer","Quest shop item",{},nil)
    input(rewards,"QuestLimit","Quest purchase limit")
    input(rewards,"TicketReserve","Tickets reserve")
    toggle(rewards,"QuestShop","Auto Buy Quest Shop Item")
    rewards:CreateInput({Name="Codes (comma separated)",CurrentValue="",Callback=function(v)
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
    dropdown(candy,"DoorMovement","Event movement",{"Teleport","Walk"},"Teleport")
    button(candy,"Start Event Collection",function()
        for _,key in ipairs({"Doors","Pass","EventQuests"})do core.Set(key,true);widgets[key]:Set(true,true)end
    end)
    button(candy,"Stop Event Collection",function()
        for _,key in ipairs({"Doors","Pass","EventQuests"})do core.Set(key,false);widgets[key]:Set(false,true)end
    end)
    candy:CreateParagraph({Name="Door route",Content="Visits event doors automatically. Teleport or Walk; waits for server travel limits, door cooldown and confirmed rewards."})
    local pass=group(halloween,"Pass and event quests","Right")
    toggle(pass,"Pass","Auto Claim Pumpkin Pass")
    toggle(pass,"EventQuests","Auto Claim Halloween Quests")
    local shop=group(halloween,"Candy shop")
    dropdown(shop,"OfferChoice","Candy shop item",{},nil)
    input(shop,"OfferLimit","Purchase limit")
    input(shop,"CandyReserve","Candy reserve")
    toggle(shop,"CandyShop","Auto Buy Candy Shop Item")
    local settings=tab("Status","activity")
    local reportGroup=group(settings,"Test report")
    local statuses={}
    for _,name in ipairs(core.Jobs)do statuses[name]=reportGroup:CreateLabel({Text=name..": Off"})end
    local actions=group(settings,"Test controls","Right")
    button(actions,"Stop all automation",core.StopAll)
    button(actions,"Copy / save test report",function()
        local text=game:GetService("HttpService"):JSONEncode(core.Report)
        if type(setclipboard)=="function"then pcall(setclipboard,text)end
        if type(writefile)=="function"then pcall(writefile,"DevilHub-AnimeDice-test-report.json",text)end
        print(text)
    end)
    actions:CreateToggle({Name="Use game Auto Roll",CurrentValue=true,Callback=function(v)core.Set("Roll",false);cfg.UseNativeRoll=v end})
    button(actions,"Close test",destroy)
    actions:CreateParagraph({Name="Standalone test",Content="All automation starts off. This test is separate from the main loader. Game rules, balances and inventory updates decide the result."})
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
        local dice={"Best affordable"};if c.Dice then for _,name in ipairs(keys(c.Dice.GetAll()))do dice[#dice+1]=name end end;options("DiceChoice",dice)
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
                protectionWidgets[kind]:Set(chosen,true)
            end
        end
        local offers={};for _,offer in ipairs(c.HalloweenShop or{})do offers[#offers+1]=offer.name end;options("OfferChoice",offers)
        local questOffers={};for _,offer in ipairs(c.Quest and c.Quest.Shop or{})do questOffers[#questOffers+1]=offer.name end;options("QuestOffer",questOffers)
        local pumpkinNames={};for _,unit in ipairs(c.PumpkinDice and c.PumpkinDice.Units or{})do pumpkinNames[#pumpkinNames+1]=unit.id end;options("PumpkinSellNames",pumpkinNames)
        if not pumpkinFilterInitialized then
            pumpkinFilterInitialized=true;local chosen={}
            for name,value in pairs(d.Halloween and d.Halloween.DiceAutoSell or{})do if value then cfg.PumpkinSellNames[name]=true;chosen[#chosen+1]=name end end
            optionWidgets.PumpkinSellNames:Set(chosen,true)
        end
        local labels,names,boosts,spins={}, {}, {}, {}
        unitLabels={};keepIdLabels={}
        for _,u in ipairs(planner.Units(d,c.Registry))do
            local label=u.name.." | "..tostring(u.attributes.level or 1).." | "..u.id:sub(1,8)
            if unitLabels[label]then label=label.." / "..u.id end
            labels[#labels+1]=label;unitLabels[label]=u.id;keepIdLabels[label]=u.id;names[u.name]=true
        end
        for _,entry in pairs(d.Inventory or{})do
            local spec=c.Registry.getEntryConfig(entry.name)
            if spec and spec.kind=="Boost"then boosts[entry.name]=true elseif spec and spec.kind=="Spin"then spins[entry.name]=true end
        end
        unitPicker:Refresh(labels,true,true);options("KeepIds",labels);options("KeepNames",keys(names));options("BoostNames",keys(boosts));options("SpinNames",keys(spins))
        local kept={};local selected
        for label,id in pairs(unitLabels)do if id==cfg.SelectedUnit then selected=label end;if cfg.KeepIds[id]then kept[#kept+1]=label end end
        unitPicker:Set(selected,true);keepWidget:Set(kept,true)
    end
    button(actions,"Refresh inventory and choices",refreshOptions)
    -- TEST_TRANSLATIONS
    scope.DevilAnimeDiceTest=app
    scope.DevilAnimeDiceStarting=nil
    ctx.Spawn(function()
        local initialized,err=xpcall(function()
            ctx.Initialize(function()return not app.Stopped end)
            if app.Stopped then return end
            core.BindEvents();refreshOptions()
        end,debug.traceback)
        if not initialized and not app.Stopped then core.Report.InitializationError=tostring(err);summary:Set("Connection failed; copy the test report");warn(err)end
    end)
    ctx.Spawn(function()
        local refreshAt=0
        while not app.Stopped do
            local worked,err=xpcall(core.Tick,debug.traceback)
            if not worked then core.Report.LastTickError=tostring(err)end
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
            ctx.Wait(.5)
        end
    end)
end,debug.traceback)
if scope.DevilAnimeDiceStarting==startup then scope.DevilAnimeDiceStarting=nil end
if not ok then destroy();error(problem,0)end
return app
