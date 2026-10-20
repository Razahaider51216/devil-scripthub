-- DEVIL HUB: standalone prototype for the map recorded in Devilv4.
assert(game.PlaceId==121831322352666 or game.GameId==10765013362,"Open the Devilv4 mining map before running this test")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilV4Test then scope.DevilV4Test.Destroy()end
if scope.DevilV4Starting and os.clock()-scope.DevilV4Starting<30 then return end
scope.DevilV4Starting=os.clock()
local P=(function()
-- V4_POLICY
end)()
local makeAdapter=(function()
-- V4_ADAPTER
end)()
local makeCore=(function()
-- V4_CORE
end)()
local makeView=(function()
-- V4_PRESENTATION
end)()
local assets=__ASSETS__
local catalog=__CATALOG__
local A=makeAdapter(scope,catalog);local C=makeCore(A,P);local cfg=C.Config
local app={Version=C.Report.Version,Core=C,Adapter=A,Config=cfg,Report=C.Report,Stopped=false};scope.DevilV4Test=app
local window,view,library,logo;local rebuilding=false;local language="EN";local languageOwner,baseSet,wrappedSet
local statusWidget,detailsWidget,settingsWidget,travelWidget,sellWidget;local controls={};local jobNames={};local selectedTarget;local lastRefresh=0
local profile="DevilHub_MiningTest_"..A.Player.UserId.."_"..game.PlaceId..".json"
local settingsStatus="Ready";local buildUI
local function t(en,th)return language=="TH"and th or en end
local function languageValue()
    local owner=scope.DevilHubBlueGui
    if owner and type(owner.Get)=="function"then local s=owner.Get();if s.Language=="TH"or s.Language=="EN"then return s.Language,owner end end
    return language
end
function app.Destroy()
    if app.Stopped then return end;app.Stopped=true;C.Destroy()
    if languageOwner and languageOwner.Set==wrappedSet then languageOwner.Set=baseSet end
    if view then view.Destroy()end;if window then window:Destroy()end
    if scope.DevilV4Test==app then scope.DevilV4Test=nil end;scope.DevilV4Starting=nil
end
local function loadSettings()
    assert(type(readfile)=="function","Settings file API unavailable")
    local text=readfile(profile);assert(#text<=65536,"Settings file too large")
    local s=A.Http:JSONDecode(text);assert(s.Version==1 and s.UserId==A.Player.UserId and s.PlaceId==game.PlaceId,"Settings belong to another account or map")
    local restored=P.Settings(s.Config);C.StopAll()
    for key,value in pairs(restored)do cfg[key]=value end
    settingsStatus="Settings loaded";if buildUI then buildUI()end
end
local function saveSettings()
    assert(type(writefile)=="function","Settings file API unavailable")
    writefile(profile,A.Http:JSONEncode({Version=1,UserId=A.Player.UserId,PlaceId=game.PlaceId,Config=P.Settings(cfg)}));settingsStatus="Settings saved"
end
local ok,problem=xpcall(function()
    -- SHARED_BLUE_BOOTSTRAP
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    assert(#source==__OURO_LEN__,"GUI download size mismatch")
    local sum=0;for i=1,#source do sum=(sum*33+source:byte(i))%4294967296 end;assert(sum==__OURO_HASH__,"GUI download checksum mismatch")
    library=assert(loadstring(source,"DEVIL HUB / Mining test GUI"))()
    logo=scope.DevilHubSilverLogo
    if not logo then pcall(function()
        local asset=getcustomasset or getsynasset;if type(asset)~="function"or type(writefile)~="function"then return end
        local bytes=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/assets/devil-logo-silver-transparent.png")
        assert(bytes:sub(1,8)=="\137PNG\13\10\26\10");writefile("DevilHub_Silver_Mining.png",bytes);logo=asset("DevilHub_Silver_Mining.png");scope.DevilHubSilverLogo=logo
    end)end
    language=languageValue()
    local function button(host,en,th,fn)
        return host:CreateButton({Name=t(en,th),Callback=function()A.ReleaseHubFocus(window.Gui);A.Spawn(function()local good,err=xpcall(fn,debug.traceback);if not good then settingsStatus=tostring(err);C.Report.Errors.UI=tostring(err)end end)end})
    end
    local function toggle(host,key,en,th)
        jobNames[key]=t(en,th)
        controls[key]=host:CreateToggle({Name=jobNames[key],CurrentValue=cfg[key],Callback=function(value)if value then A.ReleaseHubFocus(window.Gui)end;C.Set(key,value)end})
    end
    local function slider(host,key,en,th,lo,hi,increment)
        controls[key]=host:CreateSlider({Name=t(en,th),Range={lo,hi},Increment=increment or 1,CurrentValue=cfg[key],Callback=function(v)cfg[key]=P.Number(v,cfg[key],lo,hi)end})
    end
    local function choose(host,key,en,th,options)
        controls[key]=host:CreateDropdown({Name=t(en,th),Options=options,CurrentOption=cfg[key],Searchable=true,Callback=function(v)
            if type(v)~="string"then return end;cfg[key]=v
            if key=="TeleportKind"then cfg.TeleportChoice="";selectedTarget=nil;view.Refresh("Targets",{});lastRefresh=0 end
        end})
    end
    local function group(tab,en,th,side)return tab:CreateGroupbox({Name=t(en,th),Side=side or"Left"})end
    local function tab(en,th,icon)return window:CreateTab({Name=t(en,th),Icon=icon,Backdrop=false})end
    buildUI=function()
        if app.Stopped then return end
        rebuilding=true;if view then view.Destroy()end;if window then window:Destroy()end;controls={};selectedTarget=nil
        window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme={Background=Color3.fromRGB(7,9,13),Surface=Color3.fromRGB(11,13,18),Surface2=Color3.fromRGB(16,19,25),Surface3=Color3.fromRGB(32,39,49),Accent=Color3.fromRGB(164,221,255),Text=Color3.new(1,1,1),Muted=Color3.fromRGB(153,169,185),Warning=Color3.fromRGB(164,221,255)},Density="Compact",Profile=true,Search=true,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(840,570),ToggleButton={Platform="Both",Icon=logo},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false}})
        window.Gui:SetAttribute("DevilHubPresentation",true);app.Window=window;view=makeView(window,A,P,assets)
        window.Gui.Destroying:Connect(function()if not rebuilding then app.Destroy()end end)
        local farm=tab("Farm","ฟาร์ม","pickaxe")
        local dig=group(farm,"Mining controls","ระบบขุด")
        toggle(dig,"Dig","Auto Dig","ขุดอัตโนมัติ");toggle(dig,"FarmFinds","Auto Farm Selected Finds","วาร์ปขุดของตามตัวกรอง")
        toggle(dig,"FastDig","Fast Dig","ขุดต่อเนื่องความเร็วสูง");slider(dig,"AimRate","Aim updates / second","ความถี่อัปเดตเป้าขุด / วินาที",5,40)
        choose(dig,"FindKind","Target type","ประเภทเป้าหมาย",{"All","Egg","Artifact","Potion","Material"})
        choose(dig,"FindRarity","Rarity","ระดับความหายาก",{"All","Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine","Godly","Transcendent","Zero","Astronomical"})
        local grow=group(farm,"Eggs and training","ไข่และการฝึก","Right")
        toggle(grow,"Plant","Auto Plant Inventory Eggs","วางไข่จากกระเป๋าอัตโนมัติ");toggle(grow,"Hatch","Auto Hatch Ready Eggs","ฟักไข่ที่พร้อมอัตโนมัติ")
        toggle(grow,"Train","Auto Training","ฝึกอัตโนมัติ");toggle(grow,"Rotate","Rotate Training / Digging","สลับฝึกและขุดตามเวลา")
        slider(grow,"TrainSeconds","Training seconds","เวลาฝึก (วินาที)",15,900,15);slider(grow,"DigSeconds","Mining seconds","เวลาขุด (วินาที)",15,900,15)
        grow:CreateLabel({Text=t("Planting needs clear ground on your own plot.","การวางไข่ต้องมีพื้นที่ว่างในฐานของคุณ")})
        local travel=tab("Teleport","วาร์ป","map-pin");local targetGroup=group(travel,"Live targets","เป้าหมายที่มีอยู่จริง")
        choose(targetGroup,"TeleportKind","Teleport target type","ประเภทเป้าหมายวาร์ป",{"Egg","Artifact","Potion","Material","All"})
        view.Picker(targetGroup,"Targets",t("Ore / item target","เลือกแร่หรือสิ่งของ"),function(_,item)selectedTarget=item;cfg.TeleportChoice=item.Key end)
        button(targetGroup,"Teleport to selected target","วาร์ปไปเป้าหมายที่เลือก",function()
            local target=selectedTarget
            for _,item in ipairs(A.TeleportOptions(cfg.TeleportKind))do if item.Key==cfg.TeleportChoice then target=item;break end end
            if target and(cfg.TeleportKind=="All"or target.Kind==cfg.TeleportKind)then C.Teleport(target)else C.Report.Jobs.Teleport="Select an egg / item first"end
        end)
        button(targetGroup,"Teleport to nearest matching target","วาร์ปไปเป้าหมายที่ใกล้ที่สุด",function()local target=A.Targets(cfg.TeleportKind,"All",true)[1];if target then C.Teleport(target)else C.Report.Jobs.Teleport="No loaded instance of the selected item"end end)
        targetGroup:CreateLabel({Text=t("Egg names are grouped by type. Not loaded = no current target.","แสดงชื่อไข่แยกตามชนิด หากยังไม่โหลดจะยังไม่มีเป้าหมายวาร์ป")})
        travelWidget=targetGroup:CreateLabel({Text=t("Select an item to teleport through obstacles.","เลือกสิ่งของเพื่อวาร์ปผ่านสิ่งกีดขวาง")})
        local destinations=group(travel,"Destinations","สถานที่","Right")
        for _,dest in ipairs({{"Home","Home","บ้าน"},{"Plot","My plot","ฐานของฉัน"},{"Surface","Surface","พื้นผิว"},{"DigSite","Dig site","จุดขุด"},{"Sell","Sell area","จุดขาย"}})do
            local mode=dest[1];button(destinations,dest[2],dest[3],function()C.Surface(mode)end)
        end
        local shop=tab("Shop","ร้านค้า","shopping-cart");local shovels=group(shop,"Shovels","พลั่ว")
        view.Picker(shovels,"Shovels",t("Shovel / price / ownership","พลั่ว ราคา และสถานะ"),function(id)cfg.Shovel=id end)
        toggle(shovels,"BuyShovel","Auto Buy / Equip Shovel","ซื้อและใช้พลั่วอัตโนมัติ")
        button(shovels,"Buy / Equip Selected Shovel","ซื้อหรือใช้พลั่วที่เลือก",function()C.Run("BuyShovel",function(valid)C.BuyShovel(valid,cfg.Shovel)end,true)end)
        local gear=group(shop,"Drills and gear","สว่านและอุปกรณ์","Right")
        view.Picker(gear,"Gear",t("Gear / live price / stock","อุปกรณ์ ราคาปัจจุบัน และสต็อก"),function(id)cfg.Gear=id end)
        toggle(gear,"BuyGear","Auto Buy / Equip Selected Gear","ซื้อและใช้อุปกรณ์ที่เลือกอัตโนมัติ")
        slider(gear,"GearLimit","Keep gear quantity","จำนวนอุปกรณ์ที่ซื้อเก็บ",1,25)
        button(gear,"Buy / Equip Selected Gear","ซื้อหรือใช้อุปกรณ์ที่เลือก",function()C.Run("BuyGear",function(valid)C.BuyGear(valid,cfg.Gear)end,true)end)
        button(gear,"Refresh prices and stock","อัปเดตราคาและสต็อก",C.RefreshShop)
        controls.Reserve=shovels:CreateInput({Name=t("Cash reserve","เงินสดสำรอง"),CurrentValue=tostring(cfg.Reserve),Callback=function(v)cfg.Reserve=P.Number(v,cfg.Reserve)end})
        local inv=tab("Inventory","กระเป๋า","backpack");local sell=group(inv,"Selling","การขาย")
        toggle(sell,"SellLoot","Auto Sell Loot","ขายของขุดอัตโนมัติ");toggle(sell,"SellEggs","Auto Sell Spare Eggs","ขายไข่สำรองอัตโนมัติ");toggle(sell,"SellPets","Auto Sell Stored Pets","ขายสัตว์ในกระเป๋าอัตโนมัติ")
        sell:CreateParagraph({Name=t("Stored pet sale","ขายสัตว์ในกระเป๋า"),Content=t("Sells unequipped pets. Placed pets stay. Uses the game's current sale quote.","ขายสัตว์ที่ไม่ได้ใช้งาน เก็บตัวที่วางในฐานไว้ ใช้ใบเสนอราคาล่าสุดจากเกม")})
        toggle(sell,"EquipPets","Auto Equip Best Pets","ใช้สัตว์ที่ดีที่สุดอัตโนมัติ")
        sellWidget=sell:CreateLabel({Text=t("Sale results appear here.","ผลการขายจะแสดงตรงนี้")})
        local buffs=group(inv,"Potions and gear use","ยาและการใช้อุปกรณ์","Right")
        view.Picker(buffs,"Potions",t("Potion","ยา"),function(id)cfg.Potion=id end)
        toggle(buffs,"Potions","Auto Use Potion When Expired","ใช้ยาเมื่อบัฟหมดอัตโนมัติ")
        view.Picker(buffs,"UseGear",t("Placement gear","อุปกรณ์ที่ต้องการวาง"),function(id)cfg.UseGearId=id end)
        toggle(buffs,"UseGear","Auto Place Owned Gear","วางอุปกรณ์ที่มีอัตโนมัติ");toggle(buffs,"Pumpkin","Auto Fire Pumpkin Launcher","ยิง Pumpkin Launcher อัตโนมัติ")
        local upgrade=tab("Upgrades","อัปเกรด","trending-up");local levels=group(upgrade,"Cash upgrades","อัปเกรดด้วยเงินสด")
        toggle(levels,"TrainingUpgrade","Auto Upgrade Training","อัปเกรดการฝึกอัตโนมัติ");toggle(levels,"PlotUpgrade","Auto Upgrade Plot","อัปเกรดฐานอัตโนมัติ");toggle(levels,"HoleLuck","Auto Upgrade Hatch Luck","อัปเกรดโชคฟักไข่อัตโนมัติ");toggle(levels,"AnimalIncome","Auto Upgrade Pet Income","อัปเกรดรายได้สัตว์อัตโนมัติ")
        local rebirth=group(upgrade,"Rebirth","รีเบิร์ท","Right")
        rebirth:CreateLabel({Text=t("Rebirth resets progression specified by the game.","รีเบิร์ทจะรีเซ็ตความคืบหน้าตามระบบเกม")})
        slider(rebirth,"RebirthLimit","Stop at rebirth count","หยุดเมื่อจำนวนรีเบิร์ทถึง",1,100)
        toggle(rebirth,"Rebirth","Auto Rebirth","รีเบิร์ทอัตโนมัติ")
        local events=tab("Events & Rewards","อีเวนต์และรางวัล","gift");local seasonal=group(events,"Active events","อีเวนต์ที่กำลังเกิด")
        toggle(seasonal,"EventEggs","Auto Collect Event Eggs / Pumpkin Drops","วาร์ปเก็บไข่และของอีเวนต์ฟักทอง")
        toggle(seasonal,"EventWaves","Auto Claim Cash Tsunami Waves","รับรางวัลคลื่น Cash Tsunami")
        local rewards=group(events,"Free rewards","รางวัลฟรี","Right")
        toggle(rewards,"Daily","Auto Claim Daily Rewards","รับรางวัลรายวันอัตโนมัติ");toggle(rewards,"Offline","Auto Claim Offline Earnings","รับรายได้ออฟไลน์อัตโนมัติ");toggle(rewards,"PetIndex","Auto Claim Pet Index Rewards","รับรางวัลสมุดสัตว์อัตโนมัติ")
        local settings=tab("Settings","ตั้งค่า","settings");local settingsGroup=group(settings,"Settings profile","บันทึกการตั้งค่า")
        button(settingsGroup,"Save settings","บันทึกการตั้งค่า",saveSettings);button(settingsGroup,"Load settings","โหลดการตั้งค่า",loadSettings)
        settingsGroup:CreateLabel({Text=t("Saved settings load on the next run for this account and map.","การตั้งค่าที่บันทึกจะโหลดเมื่อรันครั้งถัดไปในบัญชีและแมพนี้")})
        settingsWidget=settingsGroup:CreateLabel({Text=settingsStatus})
        local diagnostics=group(settings,"Live status","สถานะการทำงาน","Right")
        statusWidget=diagnostics:CreateLabel({Text=t("Ready — automation off by default","พร้อมใช้งาน — ออโต้เริ่มต้นปิด")})
        detailsWidget=diagnostics:CreateParagraph({Name="DEVIL HUB TEST",Content=""})
        button(diagnostics,"Stop all automation","หยุดออโต้ทั้งหมด",function()C.StopAll();for _,key in ipairs(P.Jobs)do if controls[key]then controls[key]:Set(false,true)end end end)
        button(diagnostics,"Copy diagnostic report","คัดลอกรายงานทดสอบ",function()
            local report={Version=app.Version,PlaceId=game.PlaceId,GameId=game.GameId,Report=C.Report,Capabilities={Loadstring=type(loadstring)=="function",Settings=type(writefile)=="function",CustomAsset=type(getcustomasset or getsynasset)=="function"}}
            local bytes=A.Http:JSONEncode(report);if type(setclipboard)=="function"then setclipboard(bytes)elseif type(writefile)=="function"then writefile("DevilV4Report.json",bytes)else print(bytes)end;settingsStatus="Report copied / exported"
        end)
        button(diagnostics,"Unload test","ปิดตัวทดสอบ",app.Destroy)
        rebuilding=false;lastRefresh=0
    end
    buildUI()
    local _,owner=languageValue()
    if owner and type(owner.Set)=="function"then
        languageOwner=owner;baseSet=owner.Set
        wrappedSet=function(values)
            local nextLanguage=type(values)=="table"and values.Language
            if not app.Stopped and(nextLanguage=="TH"or nextLanguage=="EN")and nextLanguage~=language then language=nextLanguage;buildUI()end
            return baseSet(values)
        end
        owner.Set=wrappedSet
    end
    scope.DevilV4Starting=nil
    A.Spawn(A.Init)
    if type(readfile)=="function"and type(isfile)=="function"and isfile(profile)then
        local good,err=pcall(loadSettings);if not good then settingsStatus=tostring(err)end
    end
    local function refresh()
        local options=A.TeleportOptions(cfg.TeleportKind)
        for _,item in ipairs(options)do
            item.Label=item.Name
            item.Detail=item.Count>0 and(tostring(item.Count)..t(" found"," จุด").."\n"..math.floor(item.Distance).." studs")or t("Not loaded","ยังไม่โหลด")
        end
        view.Refresh("Targets",options,cfg.TeleportChoice)
        travelWidget:Set(C.Report.Jobs.Teleport or C.Report.Jobs.Travel or t("Select an item to teleport through obstacles.","เลือกสิ่งของเพื่อวาร์ปผ่านสิ่งกีดขวาง"),true)
        local saleLines={};for _,key in ipairs({"SellLoot","SellEggs","SellPets"})do if cfg[key]then saleLines[#saleLines+1]=(jobNames[key]or key)..": "..(C.Report.Jobs[key]or"Starting")end end
        sellWidget:Set(table.concat(saleLines,"\n"),true)
        local shovelOptions={{Id="Best affordable",Name=t("Best affordable","ดีที่สุดที่ซื้อไหว"),Detail=t("Automatic choice","เลือกอัตโนมัติ")}}
        local gearOptions={};local catalog=A.Modules.ShovelCatalog;local sh=A.Snapshots.Shovels or{};local gs=A.Snapshots.Gear or{}
        for _,item in ipairs(catalog and catalog.Tiers or{})do
            if not item.WorldOnly and not item.RobuxOnly then
                local drill=item.Kind=="Drill";local snap=drill and gs or sh;local owned=snap.Owned and snap.Owned[item.Id]
                local equipped=drill and A.Attr("ActiveDrillId")==item.Id or not drill and catalog.tier(A.Attr("ShovelLevel",1)).Id==item.Id
                local state=equipped and t("Equipped","กำลังใช้")or owned and t("Owned","ซื้อแล้ว")or t("Not owned","ยังไม่ซื้อ")
                local info={Id=item.Id,Name=item.Name,Detail="$"..P.Money(item.Cost).."\n"..state}
                table.insert(drill and gearOptions or shovelOptions,info)
            end
        end
        local gc=A.Modules.GearConfig
        for _,id in ipairs(gc and gc.Order or{})do
            local item=gc.Types[id];local stock=gs.Stock and gs.Stock.Remaining and gs.Stock.Remaining[id]
            local price=gs.Prices and gs.Prices[id]
            gearOptions[#gearOptions+1]={Id=id,Name=item.Name,Detail=(price and"$"..P.Money(price)or t("Refresh price","อัปเดตราคา")).."\n"..t("Stock: ","สต็อก: ")..tostring(stock or"?").." | "..t("Owned: ","มี: ")..tostring(gs.Counts and gs.Counts[id]or 0)}
        end
        view.Refresh("Shovels",shovelOptions,cfg.Shovel);view.Refresh("Gear",gearOptions,cfg.Gear)
        local use={};for _,item in ipairs(gearOptions)do local def=gc and gc.Types[item.Id];if def and def.Kind~="Launcher"then use[#use+1]=item end end
        view.Refresh("UseGear",use,cfg.UseGearId)
        local potionOptions={};local pc=A.Modules.PotionConfig
        for _,id in ipairs(pc and pc.Order or{})do potionOptions[#potionOptions+1]={Id=id,Kind="Potion",Name=pc.Types[id].Name or id,Detail=A.Attr("Potion"..id.."Until",0)>A.ServerTime()and t("Active","กำลังทำงาน")or""}end
        view.Refresh("Potions",potionOptions,cfg.Potion)
        local active=0;local lines={}
        for _,key in ipairs(P.Jobs)do if cfg[key]then active+=1;lines[#lines+1]=(jobNames[key]or key)..": "..(C.Report.Jobs[key]or t("Starting","กำลังเริ่ม"))end end
        statusWidget:Set(string.format("%s %d | %s %d | %s %d",t("Active","เปิด"),active,t("Requests","คำขอ"),C.Report.Requests,t("Confirmed","ยืนยัน"),C.Report.Confirmed),true)
        detailsWidget:Set(table.concat(lines,"\n"),true);settingsWidget:Set(settingsStatus,true)
    end
    A.Spawn(function()
        while not app.Stopped do
            local good,err=pcall(C.Tick);if not good then C.Report.Errors.Tick=tostring(err);C.StopMining()end
            if os.clock()-lastRefresh>=2 then lastRefresh=os.clock();local worked,detail=pcall(refresh);if not worked then C.Report.Errors.Display=tostring(detail)end end
            if view then pcall(view.VisibleModels)end
            A.Wait(.025)
        end
    end)
end,debug.traceback)
if not ok then app.Destroy();error("DEVIL HUB test startup: "..tostring(problem),0)end
return app
