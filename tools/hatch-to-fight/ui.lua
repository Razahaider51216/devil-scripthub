assert(game.PlaceId==127231827405683 or game.GameId==10768001644,"Open the HatchToFight map recorded in Devilv10")
local scope=type(getgenv)=="function"and getgenv()or _G
local release="hatch-to-fight-stage-farm-20261022-2"
if scope.DevilHtFStarting and os.clock()-scope.DevilHtFStarting<40 then return end
if scope.DevilHtFTest and type(scope.DevilHtFTest.Destroy)=="function"then scope.DevilHtFTest.Destroy()end
scope.DevilHtFStarting=os.clock()
local K=__CATALOG__
local makeAdapter=(function()
-- HTF_ADAPTER
end)()
local makeCore=(function()
-- HTF_CORE
end)()
local A=makeAdapter(scope,K)
local C=makeCore(A,K);local cfg,R=C.Config,C.Report
local app={Version=release,Core=C,Adapter=A,Config=cfg,Report=R,Stopped=false}
scope.DevilHtFTest=app
local window,library,logo;local ready=false;local rebuilding=false
local widgets,labels={},{}
local profile="DevilHub_HatchToFight_"..A.Player.UserId.."_"..game.PlaceId..".json"
local settingsText="Ready";local autoLoad=false;local buildUI
local function t(en,th)return cfg.Language=="TH"and th or en end
function app.Destroy()
    if app.Stopped then return end;app.Stopped=true;C.Destroy()
    if window then window:Destroy()end
    if scope.DevilHtFTest==app then scope.DevilHtFTest=nil end
    scope.DevilHtFStarting=nil
end
local function profileRead()
    assert(type(readfile)=="function","readfile is unavailable")
    local raw=readfile(profile);assert(#raw<=131072,"Settings file too large")
    local data=A.Http:JSONDecode(raw)
    assert(data.Version==1 and data.UserId==A.Player.UserId and data.PlaceId==game.PlaceId,"Settings belong to another account/map")
    return data
end
local function save()
    assert(type(writefile)=="function","writefile is unavailable")
    writefile(profile,A.Http:JSONEncode({Version=1,UserId=A.Player.UserId,PlaceId=game.PlaceId,AutoLoad=autoLoad,Config=C.Export()}))
    settingsText=t("Settings saved","บันทึกตั้งค่าแล้ว")
end
local function load()
    local data=profileRead();C.Import(data.Config);autoLoad=data.AutoLoad==true
    settingsText=t("Settings loaded","โหลดตั้งค่าแล้ว");if buildUI then buildUI()end
end
local function guarded(fn)return function(...)
    local args=table.pack(...)
    task.spawn(function()
        local ok,err=xpcall(function()fn(table.unpack(args,1,args.n))end,debug.traceback)
        if not ok then settingsText=tostring(err);R.Errors.UI=tostring(err)end
    end)
end end
local function multi(value)
    local result={}
    if type(value)=="table"then for key,item in pairs(value)do
        if type(key)=="string"and item==true then result[key]=true elseif type(item)=="string"then result[item]=true end
    end elseif type(value)=="string"and value~=""then result[value]=true end
    return result
end
local jobNames={
    Farm={"Auto Stage Farm","ฟาร์มด่านอัตโนมัติ"},Train={"Auto Train","ฝึกพลังอัตโนมัติ"},Tower={"Auto Tower","ลงหอคอยอัตโนมัติ"},Boss={"Auto World Boss","ตีเวิลด์บอสอัตโนมัติ"},
    Attack={"Auto Attack","ตีอัตโนมัติ"},Special={"Auto Special","ใช้สกิลอัตโนมัติ"},Collect={"Auto Collect Shells","เก็บเปลือกไข่อัตโนมัติ"},
    Sell={"Auto Sell Shells","ขายเปลือกไข่อัตโนมัติ"},SellPets={"Auto Sell Unused Pets","ขายสัตว์ที่ไม่ได้ใช้อัตโนมัติ"},Craft={"Auto Craft Eggs","คราฟต์ไข่อัตโนมัติ"},
    Hatch={"Auto Hatch Eggs","ฟักไข่อัตโนมัติ"},Equip={"Auto Equip Best Pet","ใส่สัตว์ที่ดีที่สุดอัตโนมัติ"},Upgrade={"Auto Buy Upgrades","ซื้ออัปเกรดอัตโนมัติ"},
    Rebirth={"Auto Rebirth","เกิดใหม่อัตโนมัติ"},Rewards={"Auto Claim Rewards","รับรางวัลอัตโนมัติ"},Crates={"Auto Open Key Crates","เปิดกล่องด้วยกุญแจอัตโนมัติ"},
    RaceRoll={"Auto Roll Race","สุ่มเผ่าอัตโนมัติ"},RaceEquip={"Auto Equip Best Race","ใส่เผ่าอัตโนมัติ"},Retreat={"Auto Retreat at Low HP","กลับบ้านเมื่อ HP ต่ำ"}
}
local function setJob(job,value)
    if not ready then return end
    C.Set(job,value)
    ready=false
    for key,widget in pairs(widgets)do if jobNames[key]then widget:Set(cfg[key],true)end end
    ready=true
end
local function group(tab,en,th,side)return tab:CreateGroupbox({Name=t(en,th),Side=side or"Left"})end
local function tab(en,th,icon)return window:CreateTab({Name=t(en,th),Icon=icon,Backdrop=false})end
local function button(host,en,th,fn)return host:CreateButton({Name=t(en,th),Callback=guarded(fn)})end
local function toggle(host,key)
    local pair=jobNames[key]
    widgets[key]=host:CreateToggle({Name=t(pair[1],pair[2]),CurrentValue=cfg[key],Callback=function(value)setJob(key,value==true)end})
end
local function input(host,key,en,th,lo,hi)
    return host:CreateInput({Name=t(en,th),CurrentValue=tostring(cfg[key]),RemoveTextAfterFocusLost=false,Callback=function(v)
        if ready then
            cfg[key]=C.Number(v,cfg[key],lo,hi)
            if key=="CraftCount"or key=="KeepPets"or key=="TowerCheckpoint"or key=="TowerStop"then cfg[key]=math.floor(cfg[key])end
            if key=="CrateCount"then cfg[key]=cfg[key]==3 and 3 or 1 end
        end
    end})
end
local function options(host,key,en,th,values,multiple)
    local current=cfg[key]
    if multiple then current={};for id in pairs(cfg[key])do table.insert(current,id)end;table.sort(current)end
    return host:CreateDropdown({Name=t(en,th),Options=values,CurrentOption=current,MultipleOptions=multiple==true,AllowNone=multiple==true,Searchable=true,
        Callback=function(value)if not ready then return end
            if multiple then cfg[key]=multi(value)else cfg[key]=type(value)=="table"and value[1]or value end
        end})
end
local function paragraph(host,key,en,th)
    local widget=host:CreateParagraph({Name=t(en,th),Content="..."});labels[key]=widget;return widget
end
local function statusRefresh()
    if not window or app.Stopped then return end
    local s=A.Snapshot();local d=A.Cache.Data or{}
    local lines={t("Stage cleared: ","ผ่านด่าน: ")..s.StagesCleared.." / 60",
        "FightStage: "..s.FightStage.." | Pet HP: "..tostring(s.HP or"?").." / "..tostring(s.MaxHP or"?"),
        t("Requests sent: ","ส่งคำขอ: ")..R.Sent.." | "..t("Game events observed: ","เหตุการณ์จากเกม: ")..R.Observed,
        t("Shells: ","เปลือกไข่: ")..tostring(d.bagCount or"?").." / "..tostring(d.bagCapacity or"?").." | Pets: "..#(d.pets or{}).." | Eggs: "..#(d.eggs or{})}
    if R.Blocked then table.insert(lines,R.Blocked)end
    if R.Watchdog then table.insert(lines,R.Watchdog)end
    if C.Service and R.Jobs.Movement then table.insert(lines,R.Jobs.Movement)end
    if C.Farm then table.insert(lines,"Farm: Stage "..C.Farm.Target.." | "..C.Farm.Phase.." | cleared "..tostring(R.FarmStagesCompleted or 0))end
    if labels.Overview then labels.Overview:Set(table.concat(lines,"\n"),true)end
    local jobs={}
    for _,key in ipairs(C.JobKeys)do if cfg[key]then table.insert(jobs,t(jobNames[key][1],jobNames[key][2])..": "..(R.Jobs[key]or"Waiting"))end end
    for key,err in pairs(R.Errors)do table.insert(jobs,key..": "..err)end
    for key,err in pairs(A.LastError)do table.insert(jobs,key..": "..err)end
    for lane,pending in pairs(A.Pending)do if A.Now()-pending.At>8 then table.insert(jobs,lane..": request still pending; no duplicate request started")end end
    if labels.Jobs then labels.Jobs:Set(#jobs>0 and table.concat(jobs,"\n")or t("All automation is off","ปิดระบบอัตโนมัติทั้งหมดอยู่"),true)end
    if labels.Settings then labels.Settings:Set(settingsText.."\n"..profile,true)end
    if labels.Tower then
        local tower=A.Cache.Tower or{}
        labels.Tower:Set("Floor: "..tostring(R.TowerFloor or"-").." | Best: "..tostring(tower.best or"-").." | Tickets: "..tostring(tower.tickets or"-"),true)
    end
    if labels.Manual then labels.Manual:Set(R.Jobs.Manual or t("Ready","พร้อม"),true)end
    if labels.Godmode then labels.Godmode:Set(t("No verified server HP bypass was found. Changing local Humanoid.Health or PetHP would not establish invulnerability.","ยังไม่พบวิธีป้องกันดาเมจฝั่งเซิร์ฟเวอร์ที่ยืนยันได้ การเปลี่ยน HP ฝั่งเครื่องไม่ได้ยืนยันว่าเป็นอมตะ").."\nPet HP: "..tostring(s.HP or"?").." / "..tostring(s.MaxHP or"?"),true)end
    if labels.Upgrades then
        local prices={}
        for _,id in ipairs(K.Upgrades.Order)do
            local spec=K.Upgrades.Upgrades[id];local level=d.upgrades and d.upgrades[id]or 0
            local cost=level<spec.maxLevel and(spec.costs and spec.costs[level+1]or spec.baseCost*spec.costGrowth^level)
            table.insert(prices,id.." Lv "..level.." / "..spec.maxLevel.." | "..(cost and tostring(cost).." coins"or"MAX"))
        end
        labels.Upgrades:Set(table.concat(prices,"\n"),true)
    end
end
local ok,problem=xpcall(function()
    local folder=A.RS:WaitForChild("HatchToFight",12);assert(folder,"HatchToFight is not loaded")
    assert(folder:WaitForChild("Remotes",12),"Game remotes are not loaded")
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    assert(type(source)=="string"and #source==__OURO_LEN__,"GUI download size mismatch")
    local sum=0;for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 then task.wait()end end
    assert(sum==__OURO_HASH__,"GUI checksum mismatch")
    library=assert(loadstring(source,"DEVIL HUB / HatchToFight GUI"))()
    logo=scope.DevilHubSilverLogo
    if not logo then pcall(function()
        local custom=getcustomasset or getsynasset
        if type(custom)~="function"or type(writefile)~="function"then return end
        local bytes=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/assets/devil-logo-silver-transparent.png")
        assert(bytes:sub(1,8)=="\137PNG\13\10\26\10","Logo is not PNG")
        writefile("DevilHub_Silver_HatchToFight.png",bytes);logo=custom("DevilHub_Silver_HatchToFight.png");scope.DevilHubSilverLogo=logo
    end)end
    pcall(function()local data=profileRead();if data.AutoLoad==true then C.Import(data.Config);autoLoad=true;settingsText="Saved profile restored"end end)
    buildUI=function()
        ready=false;rebuilding=true
        if window then window:Destroy()end;widgets={};labels={}
        window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme={Background=Color3.fromRGB(7,9,13),Surface=Color3.fromRGB(11,13,18),Surface2=Color3.fromRGB(16,19,25),Surface3=Color3.fromRGB(32,39,49),Accent=Color3.fromRGB(164,221,255),Text=Color3.new(1,1,1),Muted=Color3.fromRGB(153,169,185),Warning=Color3.fromRGB(164,221,255)},
            Density="Compact",Profile=true,Search=true,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,
            Size=UDim2.fromOffset(840,570),ToggleButton={Platform="Both",Icon=logo},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false}})
        app.Window=window
        window.Gui.Destroying:Connect(function()if not rebuilding then app.Destroy()end end)
        local home=tab("Overview","ภาพรวม","layout-dashboard")
        local main=group(home,"HatchToFight test","ตัวทดสอบ HatchToFight")
        paragraph(main,"Overview","Live status","สถานะสด")
        button(main,"Refresh game data","อ่านข้อมูลเกมใหม่",C.Refresh)
        button(main,"Stop all automation","หยุดทุกระบบ",function()C.StopAll();buildUI()end)
        local details=group(home,"Automation status","สถานะระบบอัตโนมัติ","Right")
        paragraph(details,"Jobs","Jobs","งานทั้งหมด")
        details:CreateParagraph({Name=t("Movement ownership","การเคลื่อนที่"),Content=t("Farm, Train, Tower and World Boss use one movement mode at a time. Enabling one disables the other three. Server events, not sent requests, indicate game activity.","ฟาร์ม ฝึก Tower และ World Boss ใช้การเคลื่อนที่ทีละโหมด เปิดโหมดหนึ่งจะปิดอีกสามโหมด จำนวนคำขอไม่ได้หมายถึงทำสำเร็จ")})
        local fight=tab("Combat","ต่อสู้","swords")
        local farm=group(fight,"Stage farming","ฟาร์มด่าน")
        toggle(farm,"Farm");toggle(farm,"Attack");toggle(farm,"Special")
        farm:CreateToggle({Name=t("Auto mount selected pet","ขี่สัตว์ที่เลือกอัตโนมัติ"),CurrentValue=cfg.AutoMount,Callback=function(v)if ready then cfg.AutoMount=v==true end end})
        local stages={t("Highest unlocked","ด่านสูงสุดที่ปลดล็อก")};local stageMap={[stages[1]]=0};local stageChoice=stages[1]
        for index=1,60 do local spec=K.Stages.List[index];local label="Stage "..index.." | "..spec.World..(spec.Boss and" | "..spec.Boss or"");table.insert(stages,label);stageMap[label]=index;if cfg.Stage==index then stageChoice=label end end
        farm:CreateDropdown({Name=t("Start stage","เลือกด่านเริ่มต้น"),Options=stages,CurrentOption=stageChoice,Searchable=true,Callback=function(v)if ready then cfg.Stage=stageMap[type(v)=="table"and v[1]or v]or 0;C.Farm=nil end end})
        input(farm,"CombatDistance","Distance from target","ระยะห่างเป้าหมาย",3,30)
        farm:CreateParagraph({Name=t("Stage progression","การเคลียร์ด่าน"),Content=t("Teleports onto the actual stage floor, waits for FightStage and live enemies, faces targets and attacks. Only server clear progress or a won FightEnded advances to the next stage.","วาร์ปลงพื้นด่านจริง รอ FightStage และมอน หันหาเป้าหมายแล้วตี ขึ้นด่านต่อเมื่อเซิร์ฟเวอร์ยืนยันความคืบหน้าหรือ FightEnded ชนะ")})
        local life=group(fight,"Health and survival","พลังชีวิตและการเอาตัวรอด","Right")
        paragraph(life,"Godmode","Godmode availability","สถานะ Godmode")
        toggle(life,"Retreat");input(life,"RetreatHP","Return home below HP %","กลับบ้านเมื่อ HP ต่ำกว่า %",1,90)
        life:CreateParagraph({Name=t("Retreat","กลับบ้าน"),Content=t("Retreat requests the game's Return Home action. It does not prevent server damage or guarantee escape during a fight.","ระบบถอยใช้คำสั่งกลับบ้านของเกม ไม่ได้ป้องกันดาเมจและไม่ได้ยืนยันว่าจะออกจากการต่อสู้ได้ทุกครั้ง")})
        local damage=group(fight,"Damage setup","จัดชุดดาเมจ","Right")
        options(damage,"PetPriority","Pet selection priority","เกณฑ์เลือกสัตว์",{"Damage per hit","Damage per second"})
        button(damage,"Equip strongest single-hit setup","จัดชุดสัตว์ที่ดาเมจต่อครั้งสูงสุด",function()
            cfg.PetPriority="Damage per hit";cfg.RaceKind="Fight";C.Set("Equip",true);C.Set("RaceEquip",true);C.Set("Special",true);buildUI()
        end)
        damage:CreateParagraph({Name="One-hit",Content=t("Unverified: the native attack request sends only Attack/Special; no client damage amount was found. This setup chooses the highest listed hit damage and owned fight race; it does not force one-hit kills.","ยังไม่พบวิธี One-hit ที่ยืนยันได้ คำสั่งเกมส่งแค่ Attack/Special ไม่มีค่าดาเมจให้กำหนด ชุดนี้เลือกสัตว์ที่ตีต่อครั้งแรงสุดและเผ่าต่อสู้ที่มี ไม่ได้บังคับให้ตีครั้งเดียวตาย")})
        local training=tab("Training","ฝึกพลัง","dumbbell")
        local train=group(training,"Power training","ฝึกพลัง")
        toggle(train,"Train");toggle(train,"Rebirth")
        local dummies={"Best available"};for _,def in ipairs(K.Training.Dummies)do table.insert(dummies,def.id)end
        options(train,"Dummy","Training dummy","เลือกหุ่นฝึก",dummies)
        train:CreateParagraph({Name=t("Training selection","เงื่อนไขหุ่น"),Content=t("Best available checks rebirths, owned premium dummies and active events. Requests wait for observed PowerGain; server rates are retained.","เลือกหุ่นที่ใช้ได้ตาม Rebirth สิทธิ์ที่มี และอีเวนต์ ตรวจ PowerGain ที่ส่งกลับจากเกม อัตราที่เซิร์ฟเวอร์อนุญาตยังมีผล")})
        local inventory=tab("Inventory","กระเป๋า","backpack")
        local collection=group(inventory,"Shell collection and sale","เก็บและขายเปลือกไข่")
        toggle(collection,"Collect");toggle(collection,"Sell")
        options(collection,"ShellRarities","Shell rarities (empty = all)","ระดับเปลือกไข่ (ว่าง = ทั้งหมด)",K.Rarities.Order,true)
        input(collection,"PickupDistance","Pickup distance","ระยะเก็บของ",3,30)
        local pets=group(inventory,"Pet equipment and sale","ใส่และขายสัตว์","Right")
        toggle(pets,"Equip");toggle(pets,"SellPets")
        options(pets,"PetRarities","Pet rarities to sell (empty = all unused)","ระดับสัตว์ที่จะขาย (ว่าง = ตัวที่ไม่ได้ใช้ทั้งหมด)",K.Rarities.Order,true)
        input(pets,"KeepPets","Minimum pets to keep","จำนวนสัตว์ขั้นต่ำที่เก็บ",1,10000)
        pets:CreateParagraph({Name=t("Sale selection","ตัวที่เก็บไว้"),Content=t("Keeps equipped, buff, locked and favorite pets. Check rarity selections before enabling sale. Shells reserved for active crafting are not sold.","เก็บตัวที่ใส่อยู่ ตัวบัฟ ตัวล็อก และตัวโปรด ตรวจระดับที่จะขายก่อนเปิด เปลือกไข่ที่สำรองให้คราฟต์จะไม่ขาย")})
        local forgeTab=tab("Forge","คราฟต์และฟัก","egg")
        local forge=group(forgeTab,"Forge controls","ระบบคราฟต์")
        toggle(forge,"Craft");toggle(forge,"Hatch")
        forge:CreateToggle({Name=t("Auto visit hub between fights","ไปทำงานในฮับระหว่างการต่อสู้อัตโนมัติ"),CurrentValue=cfg.AutoHub,Callback=function(v)if ready then cfg.AutoHub=v==true end end})
        options(forge,"CraftShells","Shell IDs to use (empty = any)","เปลือกไข่ที่จะใช้ (ว่าง = ทั้งหมด)",K.Eggs.Order,true)
        input(forge,"CraftCount","Shells per craft (4–32)","จำนวนเปลือกต่อครั้ง (4–32)",4,32)
        button(forge,"Teleport to forge","วาร์ปไปจุดคราฟต์",function()local point=A.HubPoint("EggForge");local moved,why=A.Move(point);R.Jobs.Manual=moved and"Moved to forge"or why;C.ManualUntil=A.Now()+2 end)
        forge:CreateParagraph({Name=t("Forge scheduling","ลำดับงานคราฟต์"),Content=t("Auto hub visits pause the primary movement mode between fights for hatching, forging, full-bag selling or affordable upgrades. Jobs resume after data changes; a stalled visit retries later.","ไปฮับระหว่างการต่อสู้เพื่อฟัก คราฟต์ ขายเมื่อกระเป๋าเต็ม หรือซื้ออัปเกรด แล้วกลับมาทำโหมดหลักต่อเมื่อข้อมูลเปลี่ยน หากงานค้างจะพักแล้วลองใหม่")})
        local shopTab=tab("Shop","ร้านค้า","shopping-cart")
        local shop=group(shopTab,"Coin upgrades","อัปเกรดด้วยเหรียญ")
        toggle(shop,"Upgrade");options(shop,"UpgradeIds","Upgrades to buy","อัปเกรดที่จะซื้อ",K.Upgrades.Order,true)
        paragraph(shop,"Upgrades","Current prices","ราคาปัจจุบัน")
        button(shop,"Teleport to upgrades","วาร์ปไปร้านอัปเกรด",function()A.Move(A.HubPoint("Upgrades"));C.ManualUntil=A.Now()+2 end)
        local rewardsTab=tab("Rewards","รางวัล","gift")
        local rewards=group(rewardsTab,"Daily / Gifts / Quests","รายวัน / ของขวัญ / เควสต์")
        toggle(rewards,"Rewards")
        rewards:CreateParagraph({Name=t("Reward state","สถานะรางวัล"),Content=t("Claims only rewards reported ready by game state. No timer completion or quest progress is fabricated.","รับเฉพาะรางวัลที่ข้อมูลเกมระบุว่าพร้อม ไม่แก้เวลาหรือความคืบหน้าเควสต์")})
        local crates=group(rewardsTab,"Key crates","กล่องกุญแจ","Right")
        toggle(crates,"Crates");options(crates,"Crate","Crate","เลือกกล่อง",K.Crates.Order)
        input(crates,"CrateCount","Open count (1 or 3)","จำนวนเปิด (1 หรือ 3)",1,3)
        crates:CreateParagraph({Name=t("Crate currency","สกุลเงินกล่อง"),Content=t("Auto opening uses owned keys only. Premium crates are listed for reference; no Robux purchases are started.","เปิดอัตโนมัติด้วยกุญแจที่มีเท่านั้น กล่องพรีเมียมแสดงเป็นข้อมูล ไม่เริ่มซื้อด้วย Robux")})
        local towerTab=tab("Tower & Boss","หอคอยและบอส","castle")
        local tower=group(towerTab,"Tower controls","ระบบหอคอย")
        toggle(tower,"Tower");input(tower,"TowerCheckpoint","Checkpoint index (0 = start)","เลขเช็คพอยต์ (0 = เริ่มต้น)",0,10000)
        input(tower,"TowerStop","Stop floor (0 = unlimited)","ชั้นที่หยุด (0 = ไม่จำกัด)",0,1000000)
        paragraph(tower,"Tower","Tower state","สถานะหอคอย")
        button(tower,"Claim daily Tower ticket","รับตั๋วรายวัน Tower",function()A.Call("Tower",table.pack("Daily",nil,nil),function(ok,value)settingsText=ok and tostring(value)or tostring(value)end)end)
        local boss=group(towerTab,"World Boss","เวิลด์บอส","Right");toggle(boss,"Boss")
        boss:CreateParagraph({Name=t("Boss availability","เวลาบอส"),Content=t("Waits for WorldBossAlive, requests Enter, then attacks the spawned boss. Tower and normal stage battles use separate game state.","รอ WorldBossAlive ขอเข้าบอส แล้วตีเป้าหมายที่เกิด ตรวจสถานะ Tower และด่านแยกกัน")})
        local racesTab=tab("Races","เผ่า","sparkles")
        local races=group(racesTab,"Race controls","ระบบเผ่า")
        toggle(races,"RaceRoll");toggle(races,"RaceEquip")
        options(races,"RaceStop","Stop at owned rarity","หยุดเมื่อมีระดับนี้",K.Rarities.Order)
        options(races,"RaceKind","Equipment role","ประเภทเผ่าที่ใส่",{"Fight","Train","Hatch"})
        races:CreateParagraph({Name=t("Race selection","การเลือกเผ่า"),Content=t("Rolls consume existing rolls. Best equipment compares listed stat bonuses for the selected role; it is a heuristic, not a guarantee for every build.","สุ่มด้วยจำนวนครั้งที่มีอยู่ เลือกเผ่าจากโบนัสสถานะของประเภทที่เลือก เป็นการประเมิน ไม่ได้ยืนยันว่าเหมาะที่สุดกับทุกสาย")})
        local travel=tab("Teleport","วาร์ป","map-pin")
        local destinations=group(travel,"Stage destinations","จุดวาร์ปด่าน")
        local selectedStage=60
        destinations:CreateDropdown({Name=t("Destination","เลือกจุดหมาย"),Options={table.unpack(stages,2)},CurrentOption=stages[61],Searchable=true,Callback=function(v)selectedStage=stageMap[type(v)=="table"and v[1]or v]or 60 end})
        button(destinations,"Teleport to selected stage","วาร์ปไปด่านที่เลือก",function()C.WarpStage(selectedStage)end)
        button(destinations,"Test teleport to Stage 60","ทดสอบวาร์ปไปด่าน 60",function()C.WarpStage(60)end)
        button(destinations,"Return home","กลับบ้าน",C.ReturnHome)
        paragraph(destinations,"Manual","Travel result","ผลการเดินทาง")
        destinations:CreateParagraph({Name=t("Last-stage test","ทดสอบด่านสุดท้าย"),Content=t("Moving to Stage 60 does not prove a stage unlock. Check FightStage and actual enemy/reward events. Missing streamed coordinates are reported instead of teleporting to a guessed location.","ย้ายไปด่าน 60 ไม่ได้ยืนยันว่าปลดล็อกแล้ว ตรวจ FightStage มอน และรางวัลจริง หากไม่มีพิกัดที่โหลดอยู่ จะแจ้งแทนการเดาจุดวาร์ป")})
        local worlds=group(travel,"Native world travel","เดินทางผ่านระบบเกม","Right")
        local worldIndex=1;local worldLabels={};local worldMap={}
        for i,world in ipairs(K.Stages.Worlds)do local label=i.." | "..world.Biome;table.insert(worldLabels,label);worldMap[label]=i end
        worlds:CreateDropdown({Name=t("World","เลือกโลก"),Options=worldLabels,CurrentOption=worldLabels[1],Callback=function(v)worldIndex=worldMap[type(v)=="table"and v[1]or v]or 1 end})
        button(worlds,"Travel to world","เดินทางไปโลก",function()C.TravelWorld(worldIndex)end)
        local settingsTab=tab("Settings","ตั้งค่า","settings")
        local settings=group(settingsTab,"Settings profile","บันทึกตั้งค่า")
        settings:CreateDropdown({Name=t("Language","ภาษา"),Options={"English","ไทย"},CurrentOption=cfg.Language=="TH"and"ไทย"or"English",Callback=function(v)
            if ready then cfg.Language=(type(v)=="table"and v[1]or v)=="ไทย"and"TH"or"EN";task.defer(buildUI)end
        end})
        settings:CreateToggle({Name=t("Restore saved profile on next run","โหลดตั้งค่าที่บันทึกเมื่อรันครั้งหน้า"),CurrentValue=autoLoad,Callback=function(v)if ready then autoLoad=v==true end end})
        button(settings,"Save settings","บันทึกตั้งค่า",save);button(settings,"Load saved settings","โหลดตั้งค่าที่บันทึก",load)
        paragraph(settings,"Settings","Profile status","สถานะการบันทึก")
        button(settings,"Unload DEVIL HUB","ปิด DEVIL HUB",app.Destroy)
        local community=group(settingsTab,"DEVIL HUB community","ชุมชน DEVIL HUB","Right")
        community:CreateParagraph({Name="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
        button(community,"Copy Discord invite","คัดลอกลิงก์ Discord",function()local copy=setclipboard or toclipboard;assert(type(copy)=="function","Clipboard API unavailable");copy("https://discord.gg/ZY7PRcVJe2");settingsText="Discord invite copied"end)
        ready=true;rebuilding=false;statusRefresh()
    end
    A.Bind(C);buildUI();scope.DevilHtFStarting=nil
    task.spawn(function()
        local lastUI=0
        while not app.Stopped do
            local good,err=pcall(C.Tick);if not good then R.Errors.Scheduler=tostring(err)end
            if A.Now()-lastUI>=1 then lastUI=A.Now();pcall(statusRefresh)end
            task.wait(.1)
        end
    end)
end,debug.traceback)
if not ok then app.Destroy();error("DEVIL HUB HatchToFight: "..tostring(problem),0)end
return app
