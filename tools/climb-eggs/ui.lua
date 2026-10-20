assert(game.PlaceId==85738654635245 or game.GameId==10765490774,"Open the egg map with Place ID 85738654635245")
local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilClimbEggs then env.DevilClimbEggs.Destroy() end
local P=(function()
-- CLIMB_PLANNER
end)()
local make=(function()
-- CLIMB_CORE
end)()
local makeLogo=(function()
-- CLIMB_LOGO
end)()
local config=P.Defaults()
local Http=game:GetService("HttpService")
local player=game:GetService("Players").LocalPlayer
local prefsFile="DevilClimbEggSettings_"..player.UserId..".json"
local controller={Config=config}
local core,library,window,statusWidget,totalsWidget,jobWidgets,prefsWidget
local destroyed,rebuilding=false,false
local controls={}
local prefsStatus="No saved settings yet"
local translations={
    Ready="พร้อมใช้งาน",Idle="รอทำงาน",Stopped="หยุดแล้ว",Unloaded="ปิดสคริปต์แล้ว",
    ["Waiting for daytime"]="รอกลางคืนสิ้นสุด",
    ["Waiting for selected eggs"]="รอไข่ตามระดับที่เลือก",
    ["Waiting for your own base"]="รอฐานของคุณโหลด",
    ["Waiting for landing"]="?????????????????????",
    ["No safe standing point near egg"]="????????????????????????????",
    ["Waiting for previous prompt activation"]="???????????????????????",
    ["Holding Steal prompt"]="กำลังกดขโมยไข่",
    ["Jumping back to Lobby"]="กำลังลอยออกเหนือ Lobby เพื่อกลับจุดเริ่มต้น",
    ["Waiting for a clear platform edge"]="รอเส้นทางออกจากขอบชั้น",
    ["Pickup confirmed; returning"]="รับไข่แล้ว กำลังกลับฐาน",
    ["Returning egg to Lobby"]="กำลังนำไข่กลับ Lobby",
    ["Egg claimed; waiting for inventory"]="เกมรับไข่แล้ว รอข้อมูลกระเป๋า",
    ["Egg stored in inventory"]="เก็บไข่เข้ากระเป๋าแล้ว",
    ["Waiting for inventory confirmation"]="รอยืนยันไข่เข้ากระเป๋า",
    ["Egg lost; searching again"]="ไข่หลุด กำลังหาเป้าหมายใหม่",
    ["Pickup not confirmed; retrying"]="ยังไม่ยืนยันการรับไข่ กำลังลองใหม่",
    ["Teleport not confirmed; retrying"]="ยังไม่ยืนยันวาร์ปถึงเป้าหมาย กำลังลองใหม่",
    ["Waiting to recover from knockdown"]="รอตัวละครลุกจากการล้ม",
    ["Farm error; see report"]="ระบบเก็บไข่พบข้อผิดพลาด ดูรายงาน",
    ["Server replied"]="ได้รับคำตอบจากเกม",
    ["Sending request"]="กำลังส่งคำขอ",
    ["Waiting for inventory eggs"]="รอไข่ในกระเป๋า",
    ["Placement confirmed"]="ยืนยันวางไข่สำเร็จ",
    ["No free placement position on your base"]="ฐานไม่มีพื้นที่ว่างสำหรับวางไข่",
    ["Waiting for ready eggs"]="รอไข่พร้อมฟัก",
    ["Hatching ready egg"]="กำลังฟักไข่ที่พร้อม",
    ["Hatching confirmed"]="ฟักไข่เสร็จแล้ว",
    ["Training; waiting for bonuses"]="กำลังฝึก รอรับโบนัส",
    ["Bonus clicked"]="กดโบนัสแล้ว",
    ["Waiting for required speed"]="รอค่าความเร็วถึงเงื่อนไขรีเบิร์ท",
    ["Waiting for 3 matching animals"]="รอสัตว์ชนิดและ Variant เดียวกัน 3 ตัว",
    ["Waiting for mutation to finish"]="รอเครื่องผสมเสร็จ",
    ["Keeping your best animal"]="เก็บสัตว์ที่ดีที่สุดไว้",
    ["Not enough reserved cash"]="เงินไม่พอหลังหักเงินสำรอง",
    ["Maximum upgrade reached"]="อัปเกรดถึงระดับสูงสุดแล้ว",
    ["No unprotected animals in selected levels"]="ไม่มีสัตว์ที่ขายได้ในระดับที่เลือก",
    ["Selling selected animal"]="กำลังขายสัตว์ตามตัวกรอง",
    ["Settings saved"]="บันทึกตั้งค่าแล้ว",
    ["Saved settings loaded"]="โหลดตั้งค่าที่บันทึกแล้ว",
    ["No saved settings yet"]="ยังไม่มีค่าที่บันทึก",
    ["Settings file API unavailable"]="ตัวรันไม่รองรับไฟล์ตั้งค่า",
}
local function t(en,th) return config.Language=="TH" and th or en end
local function translate(text)
    text=tostring(text or "")
    if config.Language~="TH" then return text end
    if translations[text] then return translations[text] end
    if text:sub(1,15)=="Teleporting to " then return "กำลังวาร์ปไปหา "..text:sub(16) end
    if text:sub(1,10)=="Flying to " then return "กำลังลอยไปหา "..text:sub(11)end
    return text
end
local function selected(set,options)
    local out={};for _,name in ipairs(options) do if set[name] then out[#out+1]=name end end;return out
end
local function refresh(report)
    if destroyed or not report then return end
    if statusWidget then statusWidget:Set(translate(report.status),true) end
    if totalsWidget then totalsWidget:Set(t("Picked: ","เก็บ: ")..report.picked..t(" | Stored: "," | เข้ากระเป๋า: ")..report.stored..
        t(" | Placed: "," | วาง: ")..report.placed..t(" | Hatched: "," | ฟัก: ")..report.hatched..t(" | Lost: "," | หลุด: ")..report.lost) end
    for name,widget in pairs(jobWidgets or {}) do
        local j=report.jobs[name]
        widget:Set(j and (translate(j.status).."\n"..t("Requests: ","ส่งคำขอ: ")..j.requests..t(" | Confirmed: "," | เกมยืนยัน: ")..j.confirmed) or t("Disabled / waiting","ปิดอยู่ / รอทำงาน"),true)
    end
    if prefsWidget then prefsWidget:Set(translate(prefsStatus),true) end
end
local buildUI
local function readSaved()
    if type(readfile)~="function" then return nil,"Settings file API unavailable" end
    if type(isfile)=="function" and not isfile(prefsFile) then return nil,"No saved settings yet" end
    local bytes=readfile(prefsFile);assert(#bytes<=1024*1024,"Settings file too large")
    local document=Http:JSONDecode(bytes)
    assert(document.version==1 and document.placeId==game.PlaceId and document.userId==player.UserId,"Settings belong to another account or map")
    local restored,problem=P.Validate(document.config);assert(restored,problem)
    return restored
end
local function restoreSettings(startup)
    local ok,restored,problem=pcall(readSaved)
    if not ok or not restored then prefsStatus=not ok and tostring(restored) or problem;refresh(core and core.Report);return false end
    if core then core.Stop() end
    -- All filters and numbers are restored before enabled workers can run again.
    for key,value in pairs(restored) do if type(value)~="boolean" or not (key=="Farm" or key:match("^Auto")) then config[key]=value end end
    for key,value in pairs(restored) do if type(value)=="boolean" and (key=="Farm" or key:match("^Auto")) then config[key]=value end end
    prefsStatus="Saved settings loaded"
    if not startup then buildUI() end
    refresh(core and core.Report)
    return true
end
function controller.SaveSettings()
    local ok,problem=pcall(function()
        assert(type(writefile)=="function","Settings file API unavailable")
        local payload=Http:JSONEncode({version=1,placeId=game.PlaceId,userId=player.UserId,config=config})
        writefile(prefsFile,payload)
        if type(readfile)=="function" then assert(readfile(prefsFile)==payload,"Settings write verification failed") end
    end)
    prefsStatus=ok and "Settings saved" or tostring(problem);refresh(core.Report)
    return ok,problem
end
function controller.Destroy()
    if destroyed then return end
    destroyed=true
    if core then core.Destroy() end
    if window then local old=window;window=nil;old:Destroy() end
    if env.DevilClimbEggs==controller then env.DevilClimbEggs=nil end
end
buildUI=function()
    rebuilding=true
    statusWidget=nil;totalsWidget=nil;prefsWidget=nil;jobWidgets={};controls={}
    if window then local old=window;window=nil;old:Destroy() end
    local image=makeLogo()
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,Theme=config.Theme,Density="Compact",Profile=true,
        Search=false,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,
        Size=UDim2.fromOffset(config.Width,config.Height),ToggleButton={Platform="Both",Icon=image},
        IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false}})
    window:SetTransparent(config.Transparent);window:SetHideName(config.HideName);window:SetHideAvatar(config.HideAvatar);window:SetToggleButton(config.ToggleButton)
    local bound=window
    if window.Gui and window.Gui.Destroying then window.Gui.Destroying:Connect(function() if not rebuilding and window==bound then controller.Destroy() end end) end
    local function tab(en,th,icon) return window:CreateTab({Name=t(en,th),Icon=icon,Backdrop=false}) end
    local function group(parent,en,th,side,icon) return parent:CreateGroupbox({Name=t(en,th),Side=side,Icon=icon}) end
    local function toggle(parent,key,en,th)
        controls[key]=parent:CreateToggle({Name=t(en,th),CurrentValue=config[key],Callback=function(value) core.Set(key,value) end})
    end
    local function filter(parent,key,en,th,options)
        controls[key]=parent:CreateDropdown({Name=t(en,th),Options=options,CurrentOption=selected(config[key],options),
            MultipleOptions=true,AllowNone=true,Searchable=true,Callback=function(values) config[key]=P.Set(values) end})
    end
    local function reportButton(parent)
        parent:CreateButton({Name=t("Copy / Save Report","คัดลอก / บันทึกรายงาน"),Callback=function()
            local ok,problem=pcall(core.SaveReport);prefsStatus=ok and t("Report copied: DevilClimbEggReport.json","คัดลอกรายงานแล้ว: DevilClimbEggReport.json") or tostring(problem);refresh(core.Report)
        end})
    end
    local main=tab("Auto Egg","เก็บไข่อัตโนมัติ","egg")
    local farm=group(main,"Collection","ระบบเก็บไข่","Left","egg")
    local filters=group(main,"Egg Filters","ตัวกรองไข่","Right","filter")
    statusWidget=farm:CreateParagraph({Name=t("Status","สถานะ"),Content=""})
    totalsWidget=farm:CreateLabel({Text=""})
    toggle(farm,"Farm","Auto Collect + Return","เก็บไข่และกลับฐานอัตโนมัติ")
    toggle(farm,"AutoStore","Auto Put In Inventory","นำไข่ที่ถือกลับเข้ากระเป๋าอัตโนมัติ")
    toggle(farm,"AutoPlace","Auto Place Eggs","วางไข่จากกระเป๋าบนฐานอัตโนมัติ")
    toggle(farm,"AutoHatch","Auto Hatch Ready Eggs","ฟักไข่ที่พร้อมอัตโนมัติ")
    toggle(farm,"AutoEvent","Prioritize Active Event Eggs","เก็บไข่อีเวนต์ก่อน เมื่อผ่านตัวกรอง")
    farm:CreateParagraph({Name=t("Travel mode","รูปแบบการเดินทาง"),Content=t("CFrame flight passes through walls, restores collision before Steal, then carries the egg out above your Lobby spawn and releases for landing.","ลอยด้วย CFrame ผ่านกำแพง คืนการชนก่อนขโมย แล้วพาไข่ออกมาเหนือจุด Lobby ของคุณเพื่อปล่อยตกกลับ")})
    farm:CreateSlider({Name=t("Collection fly speed","ความเร็วลอยเก็บไข่"),Range={10,500},Increment=1,CurrentValue=config.FlySpeed,Callback=function(value)core.Set("FlySpeed",math.clamp(value,10,500))end})
    reportButton(farm)
    farm:CreateButton({Name=t("Stop All","หยุดออโต้ทั้งหมด"),Callback=function() core.Stop();buildUI() end})
    filter(filters,"Tiers","Egg Levels: highest first","ระดับไข่: สูงสุดอยู่บน",P.Tiers)
    filter(filters,"Variants","Variants","รูปแบบไข่",{"All","Rainbow","Ruby","Diamond","Golden","Normal"})
    filter(filters,"Mutations","Mutations / Event Effects","สถานะไข่ / เอฟเฟกต์อีเวนต์",P.Mutations)
    filters:CreateParagraph({Name=t("Selection","การเลือกไข่"),Content=t("All accepts any effect. Remove All to filter. A selected egg stays locked until pickup, loss, or disappearance.",
        "All = ทุกสถานะ เอา All ออกเพื่อกรอง เลือกระดับสูงสุดที่ติ๊กไว้ก่อน และล็อกเป้าหมายจนรับไข่เสร็จ ไข่หาย หรือหลุด")})
    local automatic=tab("Automation","ระบบออโต้","gift")
    local train=group(automatic,"Training & Upgrades","ฝึกและอัปเกรด","Left","dumbbell")
    for _,spec in ipairs({
        {"AutoTrain","Auto Treadmill","ฝึกบนลู่วิ่งอัตโนมัติ"},{"AutoBonus","Auto Training Bonuses","กดโบนัสฝึกอัตโนมัติ"},
        {"AutoBase","Auto Upgrade Base","อัปเกรดฐานอัตโนมัติ"},{"AutoTreadmill","Auto Upgrade Treadmill","อัปเกรดลู่วิ่งอัตโนมัติ"},
        {"AutoStamina","Auto Upgrade Stamina","อัปเกรด Stamina อัตโนมัติ"},{"AutoRebirth","Auto Rebirth","รีเบิร์ทอัตโนมัติ"},
        {"AutoEquip","Auto Equip Best Animals","ใส่สัตว์ดีที่สุดอัตโนมัติ"},{"AutoTrails","Auto Buy / Equip Best Trail","ซื้อและใส่ Trail ดีที่สุดอัตโนมัติ"}}) do toggle(train,table.unpack(spec)) end
    train:CreateInput({Name=t("Cash reserve","เงินสำรอง"),CurrentValue=tostring(config.ReserveCash),PlaceholderText="0",RemoveTextAfterFocusLost=false,Callback=function(value)
        local number=tonumber(value);if number and number>=0 and number<math.huge then config.ReserveCash=number end
    end})
    local rewards=group(automatic,"Rewards","รับรางวัล","Right","gift")
    for _,spec in ipairs({
        {"AutoDaily","Auto Daily Rewards","รับรางวัลรายวัน"},{"AutoGifts","Auto Playtime Gifts","รับของขวัญเวลาเล่น"},
        {"AutoIndex","Auto Index Rewards","รับรางวัล Index"},{"AutoOffline","Auto Offline Cash","รับเงินออฟไลน์"},
        {"AutoGroup","Auto Group Rewards","รับรางวัลกลุ่ม"}}) do toggle(rewards,table.unpack(spec)) end
    local progress=group(automatic,"Live Status","สถานะการทำงาน","Right","activity")
    for _,spec in ipairs({{"Train","Training","ฝึก"},{"Bonus","Training bonuses","โบนัสฝึก"},{"Rebirth","Rebirth","รีเบิร์ท"},{"Hatch","Hatching","ฟักไข่"}}) do
        jobWidgets[spec[1]]=progress:CreateParagraph({Name=t(spec[2],spec[3]),Content=""})
    end
    local inventoryTab=tab("Animals","สัตว์ / ผสม / ขาย","paw-print")
    local fusion=group(inventoryTab,"Auto Fuse","ผสมสัตว์อัตโนมัติ","Left","combine")
    toggle(fusion,"AutoFuse","Auto Fuse + Collect","ผสมและรับสัตว์อัตโนมัติ")
    filter(fusion,"FuseTiers","Allowed animal levels","ระดับสัตว์ที่อนุญาตให้ผสม",P.Tiers)
    fusion:CreateParagraph({Name=t("Recipe","สูตรผสม"),Content=t("Uses 3 animals of the same species, variant and mutation. Normal → Golden → Diamond → Ruby → Rainbow. Waits for the game timer.",
        "ใช้สัตว์ชนิดเดียวกัน รูปแบบและสถานะเดียวกัน 3 ตัว Normal → Golden → Diamond → Ruby → Rainbow รอเวลาผสมตามเกม")})
    jobWidgets.Fuse=fusion:CreateParagraph({Name=t("Fuse status","สถานะการผสม"),Content=""})
    local selling=group(inventoryTab,"Auto Sell","ขายสัตว์อัตโนมัติ","Right","coins")
    toggle(selling,"AutoSell","Sell Selected Levels","ขายสัตว์เฉพาะระดับที่เลือก")
    filter(selling,"SellTiers","Levels to sell","ระดับที่จะขาย",P.Tiers)
    toggle(selling,"KeepBest","Keep Your Best Animal","เก็บสัตว์ดีที่สุดไว้ (ขายและผสม)")
    selling:CreateParagraph({Name=t("Protected animals","สัตว์ที่เก็บไว้"),Content=t("Skips equipped, placed, locked, favorite animals and fuse materials. Sells individual IDs to preserve level filters.",
        "ข้ามสัตว์ที่ใส่อยู่ วางอยู่ ล็อก Favorite และวัตถุดิบในเครื่องผสม ขายตาม ID เพื่อรักษาตัวกรองระดับ")})
    jobWidgets.Sell=selling:CreateParagraph({Name=t("Sale status","สถานะการขาย"),Content=""})
    local visual=tab("ESP","ESP","eye")
    local vg=group(visual,"Egg ESP","มองเห็นไข่","Left","eye")
    toggle(vg,"EggESP","Show Egg Names + Levels + Distance","แสดงชื่อ ระดับ และระยะไข่ทะลุกำแพง")
    vg:CreateParagraph({Name=t("ESP filter","ตัวกรอง ESP"),Content=t("Uses the same level, variant and mutation filters as egg farming.","ใช้ตัวกรองระดับ รูปแบบ และสถานะเดียวกับระบบเก็บไข่")})
    local settings=tab("Settings","ตั้งค่า","settings")
    local save=group(settings,"Saved Settings","บันทึกตั้งค่า","Left","save")
    prefsWidget=save:CreateParagraph({Name=t("Settings status","สถานะตั้งค่า"),Content=""})
    save:CreateButton({Name=t("Save Current Settings","บันทึกค่าปัจจุบัน"),Callback=controller.SaveSettings})
    save:CreateButton({Name=t("Load Saved Settings","โหลดค่าที่บันทึก"),Callback=function() restoreSettings(false) end})
    save:CreateParagraph({Name=t("Automatic restore","โหลดค่าอัตโนมัติ"),Content=t("Saved settings restore on the next run, including enabled automations. Settings are stored locally for this account and map.",
        "รันใหม่จะโหลดค่าที่บันทึก รวมสถานะออโต้ เก็บไฟล์ในเครื่องแยกตามบัญชีและแมพ")})
    reportButton(save)
    save:CreateButton({Name=t("Unload Script","ปิดสคริปต์"),Callback=controller.Destroy})
    local appearance=group(settings,"GUI Appearance","รูปแบบ GUI","Right","palette")
    appearance:CreateDropdown({Name=t("Theme","ธีม"),Options={"Crimson","Midnight","Ocean","Emerald","Mono","Obsidian"},CurrentOption={config.Theme},Callback=function(value)
        value=type(value)=="table" and value[1] or value;if value~=config.Theme then config.Theme=value;task.defer(buildUI) end
    end})
    for _,spec in ipairs({{"Transparent","Transparent window","หน้าต่างโปร่งใส"},{"HideName","Hide username","ซ่อนชื่อผู้ใช้"},{"HideAvatar","Hide avatar","ซ่อนรูปโปรไฟล์"},{"ToggleButton","Floating open button","ปุ่มเปิดเมนูลอย"}}) do
        local key=spec[1]
        appearance:CreateToggle({Name=t(spec[2],spec[3]),CurrentValue=config[key],Callback=function(value)
            config[key]=value
            local methods={Transparent="SetTransparent",HideName="SetHideName",HideAvatar="SetHideAvatar",ToggleButton="SetToggleButton"}
            window[methods[key]](window,value)
        end})
    end
    appearance:CreateSlider({Name=t("Width","ความกว้าง"),Range={600,1100},Increment=10,CurrentValue=config.Width,Callback=function(value) config.Width=value;window:SetSize(Vector2.new(config.Width,config.Height),true) end})
    appearance:CreateSlider({Name=t("Height","ความสูง"),Range={400,800},Increment=10,CurrentValue=config.Height,Callback=function(value) config.Height=value;window:SetSize(Vector2.new(config.Width,config.Height),true) end})
    local discord=tab("Discord","Discord","message-circle")
    local social=group(discord,"DEVIL HUB","DEVIL HUB","Left","message-circle")
    social:CreateImage({Name="DEVIL HUB",Image=image,Height=140,ScaleType="Fit"})
    social:CreateParagraph({Name=t("Join Discord","เข้าร่วม Discord"),Content="DEVIL HUB\nhttps://discord.gg/ZY7PRcVJe2"})
    social:CreateButton({Name=t("Copy Invite Link","คัดลอกลิงก์เชิญ"),Callback=function() if type(setclipboard)=="function" then setclipboard("https://discord.gg/ZY7PRcVJe2") end end})
    if window.MinimizeButton then
        local minimize=window.MinimizeButton
        local button=Instance.new("TextButton");button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
        button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
        button.BackgroundColor3=Color3.fromRGB(45,23,30);button.BorderSizePixel=0;button.Text="ไทย / EN"
        button.TextColor3=Color3.new(1,1,1);button.TextSize=13;button.Font=Enum.Font.GothamSemibold;button.Parent=minimize.Parent
        local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,8);round.Parent=button
        button.Activated:Connect(function() config.Language=config.Language=="TH" and "EN" or "TH";task.defer(buildUI) end)
    end
    rebuilding=false;refresh(core.Report)
end
env.DevilClimbEggs=controller
local ok,problem=xpcall(function()
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    local run,compileError=loadstring(source,"DEVIL HUB / OuroFlow");assert(run,compileError);library=run()
    core=make(config,refresh,P);controller.Core=core
    restoreSettings(true)
    buildUI()
end,debug.traceback)
if not ok then controller.Destroy();error("DEVIL HUB Egg Map: "..tostring(problem),0) end
return controller
