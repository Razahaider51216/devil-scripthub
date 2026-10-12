assert(game.PlaceId==104050046639813,"Open Aqua / เปิดแมพ Aqua")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilAquaAutoEgg then scope.DevilAquaAutoEgg.Destroy()end
local config={Farm=false,Hatch=false,EquipBest=false,AutoDaily=false,AutoGift=false,AutoLuck=false,AutoSell=false,SellRarities={},KeepBest=true,Tiers={},MinKg=0,MinLuck=0,Order="Highest Luck",Dropped=true,Teleport=true,Language=scope.DevilAquaLanguage or"TH",SpeedEnabled=false,WalkSpeed=16,Fly=false,FlySpeed=50,Theme="Crimson",Width=790,Height=550,Transparent=false,HideName=false,HideAvatar=false,ToggleButton=true}
local window,core,library,stateLabel,totalsLabel,autoLabel,sellLabel,sellToggle
local done=false
local controller={}
local function t(en,th)return config.Language=="TH"and th or en end
local statusThai={
    ["Auto Egg enabled"]="เปิดเก็บไข่อัตโนมัติแล้ว",["Auto Egg stopped"]="หยุดเก็บไข่แล้ว",
    ["Ready - teleport egg collection"]="พร้อมวาร์ปเก็บไข่",["Waiting for character"]="กำลังรอตัวละคร",
    ["Waiting for your PlayerPot to load"]="กำลังรอบ้านของคุณโหลด",["Waiting for hatch rack / deposit prompts to load"]="กำลังรอช่องฝากไข่โหลด",
    ["No owned deposit slots found; save report"]="ไม่พบช่องฝากของคุณ กรุณาบันทึกรายงาน",["No empty hatch slot; waiting for hatch completion"]="ช่องฟักเต็ม กำลังรอฟักเสร็จ",
    ["Waiting for an available egg matching your filters"]="กำลังรอไข่ตามระดับที่เลือก",["Returning carried egg to your pot"]="กำลังนำไข่กลับช่องฝาก",
    ["Returning egg to your home spawn"]="กำลังนำไข่กลับจุดเกิดที่บ้าน",["Egg pickup confirmed - returning now"]="เก็บไข่สำเร็จ กำลังวาร์ปกลับ",
    ["Returned home with egg; hatch approaches blocked - save report"]="กลับบ้านพร้อมไข่แล้ว แต่จุดฝากถูกบล็อก กรุณาบันทึกรายงาน",
    ["Holding egg: all empty hatch approaches blocked; save report"]="ถือไข่แล้ว แต่จุดฝากทุกช่องถูกบล็อก กรุณาบันทึกรายงาน",
    ["At empty hatch slot, but DepositSeaEgg is disabled; save report"]="ถึงช่องว่างแล้ว แต่เกมยังไม่เปิดให้ฝาก กรุณาบันทึกรายงาน",
    ["Deposit unconfirmed; check hatch state before retry"]="ยังยืนยันการฝากไม่ได้ กำลังรอลองใหม่",
    ["Pickup unconfirmed: no CarriedEggId received; save report"]="ยังไม่ได้รับรหัสไข่ที่ถือ กรุณาบันทึกรายงาน",
    ["Retrying after error; check report"]="เกิดข้อผิดพลาด กำลังลองใหม่ ดูรายละเอียดในรายงาน",
    ["Teleport cancelled"]="ยกเลิกการวาร์ป",["Teleport did not stay near target; save farm report"]="ตำแหน่งหลังวาร์ปถูกเปลี่ยน กรุณาบันทึกรายงาน",
    ["No clear space outside hatch cabinet; save report"]="ไม่พบพื้นที่ว่างนอกตู้ กรุณาบันทึกรายงาน",
    ["Target disappeared"]="เป้าหมายหายไป",["Movement interrupted"]="การเคลื่อนที่ถูกหยุด",["Travel timed out"]="เคลื่อนที่เกินเวลาที่กำหนด",
    ["Movement blocked; skipping this target"]="เคลื่อนที่ติด กำลังข้ามเป้าหมาย",["Remote unavailable"]="ยังไม่พบระบบคำขอ",
    ["Waiting for reward state"]="กำลังรอสถานะรางวัล",["Waiting for daily cooldown"]="รอเวลารับรางวัลรายวัน",
    ["Claiming daily reward"]="กำลังรับรางวัลรายวัน",["Daily reward claimed"]="รับรางวัลรายวันแล้ว",["Daily claim not confirmed"]="ยังยืนยันรางวัลรายวันไม่ได้",
    ["Claiming free gift"]="กำลังรับของขวัญฟรี",["Free gift claimed"]="รับของขวัญฟรีแล้ว",["Free gift already claimed"]="รับของขวัญฟรีไปแล้ว",
    ["Free gift claim rejected"]="เกมไม่อนุมัติของขวัญ",["Join the game group to qualify"]="ต้องเข้ากลุ่มของเกมก่อนรับของขวัญ",
    ["Waiting for owned pot"]="กำลังรอบ้านของคุณ",["Waiting for luck level"]="กำลังรอข้อมูลระดับโชค",["Waiting for coins"]="กำลังรอเงินในเกม",
    ["Requesting max affordable luck upgrade"]="กำลังอัปโชคตามเงินที่มี",["Equipping best fish"]="กำลังเลือกปลาที่ดีที่สุด",["Auto request failed"]="คำขออัตโนมัติล้มเหลว",
    ["Waiting for farm or movement to finish"]="รอเก็บไข่หรือเคลื่อนที่เสร็จก่อนขาย",["Choose fish rarities to sell"]="กรุณาเลือกระดับปลาที่จะขาย",
    ["Waiting for inventory"]="กำลังรอข้อมูลปลาในกระเป๋า",["Waiting for best fish confirmation"]="กำลังรอยืนยันปลาที่ดีที่สุด",
    ["No fish matching sell filters"]="ไม่มีปลาที่ตรงระดับขาย หรือเป็นปลาที่ต้องเก็บไว้",["Equipping selected fish"]="กำลังถือปลาที่จะขาย",
    ["Fish equip not confirmed"]="ยังยืนยันการถือปลาไม่ได้",["Waiting for fish seller NPC"]="กำลังรอ NPC ขายปลาโหลด",
    ["Teleporting to fish seller"]="กำลังวาร์ปไป NPC ขายปลา",["Fish seller not reached"]="ยังไปไม่ถึง NPC ขายปลา",
    ["Quote or fish changed; sale cancelled"]="ข้อมูลใบเสนอราคาหรือปลาเปลี่ยน ยกเลิกการขายรอบนี้",
    ["Fish sale confirmed"]="ขายปลาสำเร็จ",["Fish sale rejected"]="เกมไม่อนุมัติการขาย",
    ["Sale succeeded; inventory pending - auto sell paused"]="ขายสำเร็จ แต่ข้อมูลกระเป๋ายังไม่อัปเดต จึงพักออโต้ขาย",
    ["Requesting quote from current position"]="กำลังขอราคาจากตำแหน่งปัจจุบัน",["Server rejected quote"]="เซิร์ฟเวอร์ไม่อนุมัติใบเสนอราคา",
}
local function translated(text)
    text=tostring(text or"")
    if config.Language~="TH"then return text end
    if statusThai[text]then return statusThai[text]end
    local count=text:match("^Egg deposited: (%d+)")
    if count then return "ฝากไข่สำเร็จ: "..count end
    if text:match("^Teleporting to ")then return text:find("SpawnPlayer",1,true)and"กำลังวาร์ปกลับจุดเกิดที่บ้าน"or text:find("DepositSeaEgg",1,true)and"กำลังวาร์ปไปจุดฝากนอกตู้"or"กำลังวาร์ปหาไข่"end
    if text:match("^Activating ")then return text:find("DepositSeaEgg",1,true)and"กำลังกดฝากไข่"or"กำลังกดเก็บไข่"end
    count=text:match("^Moving: (%d+)")
    if count then return "กำลังเคลื่อนที่ เหลือ "..count.." studs"end
    return "กำลังดำเนินการ ดูรายละเอียดในรายงาน"
end
local function refresh(text,report)
    if done then return end
    if stateLabel then stateLabel:Set(translated(text),true)end
    if totalsLabel then totalsLabel:Set(t("Picked: ","เก็บ: ")..report.picked..t(" | Deposited: "," | ฝาก: ")..report.deposited..t(" | Hatch requests: "," | คำขอฟัก: ")..report.hatchRequests,true)end
    if autoLabel then
        local lines={}
        for _,pair in ipairs({{"Daily",t("Daily","รายวัน")},{"Gift",t("Gift","ของขวัญ")},{"Luck",t("Luck","โชค")},{"Equip",t("Fish","ปลา")}})do
            local entry=report.automation[pair[1]]
            if entry then lines[#lines+1]=pair[2]..": "..translated(entry.status)end
        end
        autoLabel:Set(#lines>0 and table.concat(lines,"\n")or t("Choose the auto features you want below.","เลือกเปิดระบบออโต้ที่ต้องการด้านล่าง"),true)
    end
    if sellLabel then
        local entry=report.automation.Sell
        sellLabel:Set(entry and(translated(entry.status)..(entry.serverMessage and("\n"..t("Server: ","ข้อความจากเกม: ")..entry.serverMessage)or"")..t("\nSold: ","\nขายแล้ว: ")..entry.confirmed..t(" | Earned: "," | ได้เงิน: ")..tostring(entry.earned or 0))or t("Select rarities, then enable Auto Sell.","เลือกระดับปลาก่อน แล้วเปิดขายอัตโนมัติ"),true)
    end
    if sellToggle then sellToggle:Set(config.AutoSell==true,true)end
end
local function logo()
    local url="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png?logo=aqua-1"
    local asset=getcustomasset or getsynasset
    if type(asset)=="function"and type(writefile)=="function"then
        local ok,result=pcall(function()
            local file="DevilHub_Aqua_Logo.png"
            if not(type(isfile)=="function"and isfile(file))then local data=game:HttpGet(url);assert(data:sub(1,8)=="\137PNG\r\n\26\n","Invalid logo");writefile(file,data)end
            return asset(file)
        end)
        if ok then return result end
    end
    return url
end
function controller.Destroy()
    if done then return end;done=true
    if core then core.Destroy()end
    if scope.DevilAquaAutoEgg==controller then scope.DevilAquaAutoEgg=nil end
    if window then window:Destroy()end
end
scope.DevilAquaAutoEgg=controller
local image
local buildUI
function controller.SetLanguage(language)
    if done or(language~="TH"and language~="EN")or language==config.Language then return end
    config.Language=language;scope.DevilAquaLanguage=language
    task.defer(function()local ok,err=xpcall(buildUI,debug.traceback);if not ok then controller.Destroy();warn(err)end end)
end
local function headerLanguage()
    local minimize=assert(window.MinimizeButton,"DEVIL HUB minimize button unavailable")
    local parent=minimize.Parent
    local theme=library.Theme
    local button=Instance.new("TextButton")
    button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
    button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
    button.Text=config.Language=="TH"and"ไทย / EN"or"EN / ไทย"
    button.TextSize=13;button.Font=Enum.Font.GothamSemibold;button.TextColor3=theme.Text
    button.BackgroundColor3=theme.Surface2;button.BorderSizePixel=0;button.ZIndex=50
    button:SetAttribute("NoDrag",true);button.Parent=parent
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=button
    local list=Instance.new("Frame")
    list.Name="DevilLanguageMenu";list.AnchorPoint=Vector2.new(1,0)
    list.Position=button.Position+UDim2.fromOffset(0,38);list.Size=UDim2.fromOffset(100,72)
    list.BackgroundColor3=theme.Surface2;list.BorderSizePixel=0;list.Visible=false;list.ZIndex=51
    list:SetAttribute("NoDrag",true);list.Parent=parent
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,8);round.Parent=list
    for index,choice in ipairs({{"TH","ไทย"},{"EN","English"}})do
        local item=Instance.new("TextButton")
        item.Name="Language"..choice[1];item.Position=UDim2.fromOffset(4,(index-1)*34+2)
        item.Size=UDim2.fromOffset(92,34);item.BackgroundTransparency=1
        item.Text=choice[2];item.TextSize=13;item.Font=Enum.Font.GothamSemibold
        item.TextColor3=config.Language==choice[1]and theme.Accent or theme.Text
        item.ZIndex=52;item:SetAttribute("NoDrag",true);item.Parent=list
        item.MouseButton1Click:Connect(function()list.Visible=false;controller.SetLanguage(choice[1])end)
    end
    button.MouseButton1Click:Connect(function()list.Visible=not list.Visible end)
    window._controlsDirty=true
end
buildUI=function()
    if done then return end
    local previous=window
    stateLabel=nil;totalsLabel=nil;autoLabel=nil;sellLabel=nil;sellToggle=nil
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,Theme=config.Theme,Density="Compact",Profile=true,Search=false,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(config.Width,config.Height),ToggleButton={Platform="Both",Icon=image},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false,FolderName="DevilAqua"}})
    window:SetTransparent(config.Transparent);window:SetHideName(config.HideName);window:SetHideAvatar(config.HideAvatar);window:SetToggleButton(config.ToggleButton)
    headerLanguage()
    if previous then previous:Destroy()end
    local tab=window:CreateTab({Name=t("Auto Egg","เก็บไข่อัตโนมัติ"),Icon="egg",Backdrop=false})
    local farm=tab:CreateGroupbox({Name=t("Egg Farm","ระบบเก็บไข่"),Side="Left"})
    local filters=tab:CreateGroupbox({Name=t("Egg Filters","เลือกระดับไข่"),Side="Right"})
    stateLabel=farm:CreateParagraph({Name=t("Farm status","สถานะฟาร์ม"),Content=""});totalsLabel=farm:CreateLabel({Text=""})
    local toggles={}
    local function toggle(group,flag,en,th,callback)
        local widget=group:CreateToggle({Name=t(en,th),CurrentValue=config[flag]==true,Callback=function(value)
            if callback then callback(value)else config[flag]=value end
            for key,existing in pairs(toggles)do existing:Set(config[key]==true,true)end
        end})
        toggles[flag]=widget;return widget
    end
    toggle(farm,"Farm","Auto Collect + Return Egg","เก็บไข่และกลับบ้านอัตโนมัติ",core.SetFarm)
    toggle(farm,"Hatch","Auto Hatch Ready Eggs","ฟักไข่ที่ครบเวลาอัตโนมัติ")
    toggle(farm,"EquipBest","Auto Equip Best Fish","เลือกปลาที่ดีที่สุดอัตโนมัติ")
    farm:CreateButton({Name=t("Start Egg Farm + Hatch","เริ่มเก็บไข่และฟัก"),Callback=function()config.Hatch=true;toggles.Hatch:Set(true,true);toggles.Farm:Set(true,true);core.SetFarm(true)end})
    farm:CreateButton({Name=t("Stop All","หยุดออโต้ทั้งหมด"),Callback=function()core.StopAll();for _,widget in pairs(toggles)do widget:Set(false,true)end;refresh(core.Report.status,core.Report)end})
    farm:CreateButton({Name=t("Save Farm Report","บันทึกรายงาน"),Callback=core.SaveReport})
    farm:CreateParagraph({Name=t("Return route","เส้นทางกลับ"),Content=t("Collect egg, return to your home SpawnPlayer, then approach an empty hatch slot from outside the cabinet.","เก็บไข่แล้วกลับจุดเกิดของบ้านคุณก่อน จากนั้นไปฝากช่องว่างโดยยืนอยู่นอกตู้")})
    local tiers={"AbuseEvent","KrakenGlory","SolarOrbit","AzureCrown","AmethystSpiral","GlacialSpiral","CoralReef","Eternal","Celestial","Sovereign","Trench","Abyss","Deep","Tidal","Reef","Coral","Common"}
    local seen={};for _,tier in ipairs(tiers)do seen[tier]=true end
    local runtime=workspace:FindFirstChild("EggRuntime")
    for _,name in ipairs({"WildEggs","DroppedEggs"})do
        local folder=runtime and runtime:FindFirstChild(name)
        for _,model in ipairs(folder and folder:GetChildren()or{})do local tier=model:GetAttribute("EggTier");if type(tier)=="string"and tier:match("^Abuseall%d+$")then tier="AbuseEvent"end;if type(tier)=="string"and not seen[tier]then seen[tier]=true;tiers[#tiers+1]=tier end end
    end
    local function selectTiers(values)
        local selected={}
        if type(values)=="table"then for key,value in pairs(values)do if type(key)=="number"and type(value)=="string"then selected[value]=true elseif type(key)=="string"and value==true then selected[key]=true end end end
        config.Tiers=selected
    end
    local current={};for _,tier in ipairs(tiers)do if config.Tiers[tier]then current[#current+1]=tier end end
    local tierDropdown=filters:CreateDropdown({Name=t("Egg Levels: Highest First","ระดับไข่: สูงสุดอยู่บน"),Options=tiers,CurrentOption=current,MultipleOptions=true,AllowNone=true,Searchable=true,Callback=selectTiers})
    filters:CreateButton({Name=t("Select Abyss / Sovereign / Trench","เลือก Abyss / Sovereign / Trench"),Callback=function()local values={"Abyss","Sovereign","Trench"};selectTiers(values);tierDropdown:Set(values,true)end})
    filters:CreateButton({Name=t("Allow All Egg Types","รับไข่ทุกระดับ"),Callback=function()selectTiers({});tierDropdown:Set({},true)end})
    local nearest=t("Nearest","ใกล้ที่สุด");local highest=t("Highest Luck","ค่าโชคสูงสุด")
    filters:CreateDropdown({Name=t("Priority","ลำดับการเลือก"),Options={highest,nearest},CurrentOption={config.Order=="Nearest"and nearest or highest},Callback=function(value)value=type(value)=="table"and value[1]or value;config.Order=value==nearest and"Nearest"or"Highest Luck"end})
    local function minimum(field,value)local n=tonumber(value);if n and n==n and n>=0 and n<math.huge then config[field]=n end end
    filters:CreateInput({Name=t("Minimum KG","น้ำหนักขั้นต่ำ"),CurrentValue=tostring(config.MinKg),Numeric=true,Callback=function(value)minimum("MinKg",value)end})
    filters:CreateInput({Name=t("Minimum Egg Luck","ค่าโชคไข่ขั้นต่ำ"),CurrentValue=tostring(config.MinLuck),Numeric=true,Callback=function(value)minimum("MinLuck",value)end})
    filters:CreateToggle({Name=t("Include Dropped Eggs","รวมไข่ที่ผู้เล่นทำตก"),CurrentValue=config.Dropped,Callback=function(value)config.Dropped=value end})
    filters:CreateParagraph({Name=t("Selection","การเลือกไข่"),Content=t("AbuseEvent groups all event egg stages and searches event Rewards when present. Empty selection allows all types. An unavailable selected type is waited for.","AbuseEvent รวมไข่ทุกด่านของอีเวนต์ และตรวจไข่รางวัลเมื่ออีเวนต์เกิด ไม่เลือกระดับจะรับทุกชนิด ถ้าระดับที่เลือกยังไม่เกิด ระบบจะรอ")})
    local autoTab=window:CreateTab({Name=t("Other Auto","ระบบออโต้อื่น"),Icon="gift",Backdrop=false})
    local rewards=autoTab:CreateGroupbox({Name=t("Rewards","รับรางวัล"),Side="Left"})
    autoLabel=rewards:CreateParagraph({Name=t("Auto status","สถานะออโต้"),Content=""})
    toggle(rewards,"AutoDaily","Auto Daily Reward","รับรางวัลรายวันอัตโนมัติ")
    toggle(rewards,"AutoGift","Auto Free Gift","รับของขวัญฟรีอัตโนมัติ")
    rewards:CreateParagraph({Name=t("Free gift eligibility","เงื่อนไขของขวัญ"),Content=t("Claims only when the server says your account qualifies. Join the game's group yourself if required.","รับเมื่อเซิร์ฟเวอร์แจ้งว่าบัญชีผ่านเงื่อนไข หากต้องเข้ากลุ่ม ให้เข้ากลุ่มของเกมก่อน")})
    local upgrades=autoTab:CreateGroupbox({Name=t("Upgrades","อัปเกรด"),Side="Right"})
    toggle(upgrades,"AutoLuck","Auto Upgrade Hatch Luck (uses coins)","อัปโชคฟักอัตโนมัติ (ใช้เงินในเกม)")
    upgrades:CreateParagraph({Name=t("Luck upgrade","การอัปโชค"),Content=t("When enabled, requests the maximum affordable Hatch Luck upgrade every 5 seconds using game coins.","เมื่อเปิด จะขออัปโชคฟักสูงสุดที่ซื้อไหวทุก 5 วินาที โดยใช้เงินในเกม")})
    local sellTab=window:CreateTab({Name=t("Auto Sell Fish","ขายปลาอัตโนมัติ"),Icon="coins",Backdrop=false})
    local sell=sellTab:CreateGroupbox({Name=t("Fish sales","ระบบขายปลา"),Side="Left"})
    sellLabel=sell:CreateParagraph({Name=t("Sale status","สถานะการขาย"),Content=""})
    sellToggle=toggle(sell,"AutoSell","Auto Sell Selected Rarities","ขายเฉพาะระดับที่เลือกอัตโนมัติ")
    sell:CreateToggle({Name=t("Keep the fish selected by EquipBest","เก็บปลาที่ระบบเลือกว่าดีที่สุด"),CurrentValue=config.KeepBest,Callback=function(value)config.KeepBest=value end})
    sell:CreateParagraph({Name=t("Protected fish","ปลาที่เก็บไว้"),Content=t("Favorite, locked and aquarium display fish are always skipped. Empty rarity selection sells nothing. Sales use single-fish quotes and server confirmation.","ข้ามปลา Favorite ปลาที่ล็อก และปลาในตู้เสมอ หากไม่เลือกระดับจะไม่ขายปลา ขายทีละตัวตามใบเสนอราคาและยืนยันผลจากเกม")})
    local choices=sellTab:CreateGroupbox({Name=t("Rarity filter","เลือกระดับปลาที่ขาย"),Side="Right"})
    local catalog=game:GetService("ReplicatedStorage").EggGame:FindFirstChild("Catalog")
    local raritySet={};for _,entry in ipairs(catalog and catalog:GetChildren()or{})do local rarity=entry:GetAttribute("Rarity");if type(rarity)=="string"then raritySet[rarity]=true end end
    local rarityOrder={"Secret","Mythic","Mythical","Legendary","Epic","Rare","Uncommon","Common"};local rarities={}
    for _,rarity in ipairs(rarityOrder)do if raritySet[rarity]then rarities[#rarities+1]=rarity;raritySet[rarity]=nil end end
    for rarity in pairs(raritySet)do rarities[#rarities+1]=rarity end
    local selected={};for _,rarity in ipairs(rarities)do if config.SellRarities[rarity]then selected[#selected+1]=rarity end end
    choices:CreateDropdown({Name=t("Sell these fish rarities","ขายปลาเฉพาะระดับเหล่านี้"),Options=rarities,CurrentOption=selected,MultipleOptions=true,AllowNone=true,Searchable=true,Callback=function(values)
        local selected={};if type(values)=="table"then for key,value in pairs(values)do if type(key)=="number"and type(value)=="string"then selected[value]=true elseif type(key)=="string"and value==true then selected[key]=true end end end
        config.SellRarities=selected
    end})
    choices:CreateParagraph({Name=t("Remote sale","ขายด้วยคำขอ remote"),Content=t("Requests Quote and Sell from your current position. No NPC teleport is used. Server eligibility still applies; rejection messages appear above. Works while holding an egg if the game allows the fish to be equipped.","ส่งคำขอราคาและขายจากตำแหน่งปัจจุบัน โดยไม่วาร์ปหา NPC หากเกมไม่อนุมัติจะแสดงเหตุผลด้านบน ลองขายขณะถือไข่ได้เมื่อเกมอนุญาตให้ถือปลา")})
    local playerTab=window:CreateTab({Name=t("Player","ผู้เล่น"),Icon="user",Backdrop=false})
    local movement=playerTab:CreateGroupbox({Name=t("Movement","การเคลื่อนที่"),Side="Left"})
    toggle(movement,"SpeedEnabled","Enable Walk Speed","เปิดปรับความเร็วเดิน",core.SetSpeed)
    movement:CreateSlider({Name=t("Walk Speed","ความเร็วเดิน"),Range={16,200},Increment=1,CurrentValue=config.WalkSpeed,Callback=function(value)config.WalkSpeed=value end})
    toggle(movement,"Fly","Fly","บิน",core.SetFly)
    movement:CreateSlider({Name=t("Fly Speed","ความเร็วบิน"),Range={10,200},Increment=1,CurrentValue=config.FlySpeed,Callback=function(value)config.FlySpeed=value end})
    movement:CreateParagraph({Name=t("Flight controls","ควบคุมการบิน"),Content=t("WASD to move, Space up, Ctrl down. Fly stops Auto Egg; starting Auto Egg stops Fly. Disabling restores normal movement.","ใช้ WASD เคลื่อนที่ Space ขึ้น Ctrl ลง การเปิดบินจะหยุดเก็บไข่ และเปิดเก็บไข่จะหยุดบิน ปิดแล้วคืนการเคลื่อนที่เดิม")})
    local identity=playerTab:CreateGroupbox({Name=t("Profile","โปรไฟล์"),Side="Right"})
    local player=game:GetService("Players").LocalPlayer
    identity:CreateLabel({Text=t("Username: ","ชื่อผู้ใช้: ")..tostring(player.Name or"Player")})
    identity:CreateLabel({Text=t("Display name: ","ชื่อแสดง: ")..tostring(player.DisplayName or player.Name or"Player")})
    identity:CreateLabel({Text=t("Place ID: ","รหัสแมพ: ")..tostring(game.PlaceId)})
    local settings=window:CreateTab({Name=t("GUI Settings","ตั้งค่า GUI"),Icon="settings",Backdrop=false})
    local appearance=settings:CreateGroupbox({Name=t("Appearance","รูปแบบหน้าต่าง"),Side="Left"})
    appearance:CreateDropdown({Name=t("Theme","ธีม"),Options={"Crimson","Midnight","Ocean","Emerald","Mono","Obsidian"},CurrentOption={config.Theme},Callback=function(value)
        value=type(value)=="table"and value[1]or value
        if value==config.Theme then return end;config.Theme=value
        task.defer(buildUI)
    end})
    appearance:CreateToggle({Name=t("Transparent window","หน้าต่างโปร่งใส"),CurrentValue=config.Transparent,Callback=function(value)config.Transparent=value;window:SetTransparent(value)end})
    appearance:CreateToggle({Name=t("Hide username","ซ่อนชื่อผู้ใช้"),CurrentValue=config.HideName,Callback=function(value)config.HideName=value;window:SetHideName(value)end})
    appearance:CreateToggle({Name=t("Hide avatar","ซ่อนรูปโปรไฟล์"),CurrentValue=config.HideAvatar,Callback=function(value)config.HideAvatar=value;window:SetHideAvatar(value)end})
    appearance:CreateToggle({Name=t("Floating open button","แสดงปุ่มเปิดเมนูลอย"),CurrentValue=config.ToggleButton,Callback=function(value)config.ToggleButton=value;window:SetToggleButton(value)end})
    local sizing=settings:CreateGroupbox({Name=t("Window size","ขนาดหน้าต่าง"),Side="Right"})
    sizing:CreateSlider({Name=t("Width","ความกว้าง"),Range={600,1100},Increment=10,CurrentValue=config.Width,Callback=function(value)config.Width=value;window:SetSize(Vector2.new(config.Width,config.Height),true)end})
    sizing:CreateSlider({Name=t("Height","ความสูง"),Range={400,800},Increment=10,CurrentValue=config.Height,Callback=function(value)config.Height=value;window:SetSize(Vector2.new(config.Width,config.Height),true)end})
    sizing:CreateButton({Name=t("Reset GUI settings","คืนค่าหน้าต่างเริ่มต้น"),Callback=function()
        config.Theme="Crimson";config.Width=790;config.Height=550;config.Transparent=false;config.HideName=false;config.HideAvatar=false;config.ToggleButton=true;task.defer(buildUI)
    end})
    local discordTab=window:CreateTab({Name="Discord",Icon="message-circle",Backdrop=false})
    local social=discordTab:CreateGroupbox({Name="DEVIL HUB",Side="Left"})
    social:CreateImage({Name="DEVIL HUB",Image=image,Height=120,ScaleType="Fit"})
    social:CreateParagraph({Name=t("Join Discord","เข้าร่วม Discord"),Content="DEVIL HUB\nhttps://discord.gg/ZY7PRcVJe2"})
    local copied=social:CreateLabel({Text=""})
    social:CreateButton({Name=t("Copy invite link","คัดลอกลิงก์เชิญ"),Callback=function()
        local copy=setclipboard or toclipboard
        if type(copy)=="function"then local ok=pcall(copy,"https://discord.gg/ZY7PRcVJe2");copied:Set(ok and t("Copied invite link","คัดลอกลิงก์แล้ว")or t("Copy failed","คัดลอกไม่สำเร็จ"))
        else copied:Set(t("Clipboard unavailable; copy the link above.","ตัวรันไม่รองรับคลิปบอร์ด ให้คัดลอกลิงก์ด้านบน"))end
    end})
    local discordLogo=discordTab:CreateGroupbox({Name="Discord",Side="Right"})
    discordLogo:CreateImage({Name="Discord",Image="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/discord-logo.png",Height=140,ScaleType="Fit"})
    local info=window:CreateTab({Name=t("Info","ข้อมูล"),Icon="info",Backdrop=false})
    local about=info:CreateGroupbox({Name="DEVIL HUB",Side="Left"})
    about:CreateLabel({Text=t("Aqua Auto Egg - release 10","ระบบเก็บไข่ Aqua - เวอร์ชัน 10")})
    about:CreateParagraph({Name=t("Diagnostics","ตรวจปัญหา"),Content=t("Save report and send DevilAquaAutoEgg-report.json if an auto action fails.","หากระบบค้าง กดบันทึกรายงานแล้วส่งไฟล์ DevilAquaAutoEgg-report.json")})
    about:CreateButton({Name=t("Unload","ปิดสคริปต์"),Callback=controller.Destroy})
    local boundWindow=window
    if window.Gui and window.Gui.Destroying then window.Gui.Destroying:Connect(function()if window==boundWindow then controller.Destroy()end end)end
    refresh(core.Report.status,core.Report)
end
local ok,err=xpcall(function()
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    local run,problem=loadstring(source,"DEVIL HUB / OuroFlow");assert(run,problem);library=run();image=logo()
    local make=(function()
return function(config,onStatus)
    local Players=game:GetService("Players")
    local player=Players.LocalPlayer
    local RS=game:GetService("ReplicatedStorage")
    local Run=game:GetService("RunService")
    local requests=assert(RS:WaitForChild("EggGame",15),"EggGame unavailable"):WaitForChild("Requests",15)
    local events=RS.EggGame:WaitForChild("Events",15)
    assert(requests and events,"Egg remotes unavailable")
    local api={Config=config,Report={release="aqua-auto-egg-10",picked=0,deposited=0,hatchRequests=0,errors={},automation={}}}
    local active=true
    local links={}
    local hatches={}
    local collection={}
    local collectionReady=false
    local selling=false
    local farmBusy=false
    local retryEgg={}
    local hatchRetry={}
    local selected
    local motion
    local heldPrompt
    local collisionProbe
    local returnedHomeId
    local speedHumanoid,originalSpeed
    local flight
    local lastEquip=-math.huge
    local now=os.clock
    local function status(text)
        api.Report.status=text
        api.Report.carriedEggId=player:GetAttribute("CarriedEggId")
        if onStatus then pcall(onStatus,text,api.Report)end
    end
    local function logError(err)
        local text=tostring(err)
        if #api.Report.errors>=20 then table.remove(api.Report.errors,1)end
        api.Report.errors[#api.Report.errors+1]={t=now(),message=text}
        warn("[DEVIL HUB / AQUA] "..text)
    end
    local function alive()
        local c=player.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local root=c and c:FindFirstChild("HumanoidRootPart")
        if h and root and h.Health>0 then return c,h,root end
    end
    local function carried()
        local id=player:GetAttribute("CarriedEggId")
        return type(id)=="string"and id~=""and id or nil
    end
    local function promptPosition(prompt)
        local parent=prompt and prompt.Parent
        if not parent then return end
        if parent:IsA("Attachment")then return parent.WorldPosition end
        if parent:IsA("BasePart")then return parent.Position end
        if parent:IsA("Model")then return parent:GetPivot().Position end
    end
    local function ownPot()
        local name=player:GetAttribute("PlayerPot")
        return type(name)=="string"and workspace:FindFirstChild(name)or nil
    end
    local function ownPrompt(prompt)
        local pot=ownPot()
        if not pot or not prompt:IsDescendantOf(pot)then return false end
        local object=prompt.Parent
        while object and object~=workspace do
            local owner=object:GetAttribute("OwnerUserId")
            if owner~=nil then return tonumber(owner)==player.UserId end
            if object==pot then break end
            object=object.Parent
        end
        return true -- PlayerPot itself is a player attribute supplied by the game.
    end
    local function hatchInteraction(prompt)
        local object=prompt and prompt.Parent
        local pot=ownPot()
        while object and object~=pot and object~=workspace do
            if object:GetAttribute("HatchSlot")~=nil then return object end
            object=object.Parent
        end
        return prompt and prompt.Parent
    end
    local function availableDeposit(prompt,requireEnabled)
        if not prompt or not prompt.Parent or not ownPrompt(prompt)then return false end
        local interaction=hatchInteraction(prompt)
        local state=interaction and interaction:GetAttribute("Status")
        -- Enabled is an interaction gate; the game may disable deposits until
        -- the player carries an egg. Empty is the slot capacity signal.
        local empty=state=="Empty"or(state==nil and prompt.Enabled)
        return empty and(not requireEnabled or prompt.Enabled)
    end
    local function nearestDeposit(requireEnabled)
        local _,_,root=alive()
        local pot=ownPot()
        local scan={playerPot=player:GetAttribute("PlayerPot"),potFound=pot~=nil,prompts=0,owned=0,empty=0,enabled=0,slots={}}
        api.Report.slotScan=scan
        if not root or not pot then return end
        local best,distance
        for _,node in ipairs(pot:GetDescendants())do
            if node:IsA("ProximityPrompt")and node.Name=="DepositSeaEgg"then
                scan.prompts+=1
                if node.Enabled then scan.enabled+=1 end
                local interaction=hatchInteraction(node)
                local state=interaction and interaction:GetAttribute("Status")
                local owned=ownPrompt(node)
                if owned then scan.owned+=1;if state=="Empty"then scan.empty+=1 end end
                scan.slots[#scan.slots+1]={slot=interaction and interaction:GetAttribute("HatchSlot"),status=state,enabled=node.Enabled,owned=owned,owner=interaction and interaction:GetAttribute("OwnerUserId")}
                if availableDeposit(node,requireEnabled)then
                    local point=promptPosition(node)
                    local d=point and(root.Position-point).Magnitude
                    if d and(not distance or d<distance)then best,distance=node,d end
                end
            end
        end
        return best
    end
    local function noDepositStatus()
        local scan=api.Report.slotScan or{}
        if not scan.potFound then return "Waiting for your PlayerPot to load"end
        if scan.prompts==0 then return "Waiting for hatch rack / deposit prompts to load"end
        if scan.owned==0 then return "No owned deposit slots found; save report"end
        return "No empty hatch slot; waiting for hatch completion"
    end
    local function pickupPrompt(model)
        for _,node in ipairs(model:GetDescendants())do
            if node:IsA("ProximityPrompt")and(node.Name=="TakeSeaEgg"or node.Name=="PickupDroppedEgg"or node:GetAttribute("EggPrompt")=="Pickup"or node:GetAttribute("EggPrompt")=="PickupDropped")and node.Enabled then return node end
        end
    end
    local function eventRewards()
        local runtime=workspace:FindFirstChild("AbuseEventRuntime")
        return runtime and runtime:FindFirstChild("Rewards")
    end
    local function eggSource(model)
        local event=eventRewards()
        if event and model:IsDescendantOf(event)then return "AbuseEvent"end
        local runtime=workspace:FindFirstChild("EggRuntime")
        if runtime and model.Parent==runtime:FindFirstChild("WildEggs")then return "WildEggs"end
        if config.Dropped and runtime and model.Parent==runtime:FindFirstChild("DroppedEggs")then return "DroppedEggs"end
    end
    local function eligible(model)
        if not model or not model.Parent or not model:IsA("Model")then return false end
        local source=eggSource(model)
        if not source then return false end
        local id=model:GetAttribute("EggId")
        if type(id)~="string"or id==""or now()<(retryEgg[id]or 0)then return false end
        local tier=model:GetAttribute("EggTier")
        local group=(source=="AbuseEvent"or(type(tier)=="string"and tier:match("^Abuseall%d+$")))and"AbuseEvent"or tier
        if next(config.Tiers)and not config.Tiers[group]and not config.Tiers[tier]then return false end
        if(tonumber(model:GetAttribute("EggKg"))or 0)<config.MinKg then return false end
        if(tonumber(model:GetAttribute("EggLuck"))or 0)<config.MinLuck then return false end
        return pickupPrompt(model)~=nil
    end
    local function chooseEgg()
        local _,_,root=alive()
        if not root then return end
        local runtime=workspace:FindFirstChild("EggRuntime")
        local sources={}
        if runtime then
            sources[#sources+1]=runtime:FindFirstChild("WildEggs")
            if config.Dropped then sources[#sources+1]=runtime:FindFirstChild("DroppedEggs")end
        end
        local rewards=eventRewards()
        local scan={present=rewards~=nil,models=0,eligible=0,missingId=0,prompts={}}
        api.Report.eventScan=scan
        if rewards then sources[#sources+1]=rewards end
        local best,bestScore
        for _,folder in ipairs(sources)do
            for _,model in ipairs(folder==rewards and folder:GetDescendants()or folder:GetChildren())do
                if folder==rewards and model:IsA("Model")then
                    scan.models+=1
                    if not model:GetAttribute("EggId")then scan.missingId+=1 end
                    if eligible(model)then scan.eligible+=1 end
                elseif folder==rewards and model:IsA("ProximityPrompt")and #scan.prompts<12 then
                    scan.prompts[#scan.prompts+1]={name=model.Name,enabled=model.Enabled,kind=model:GetAttribute("EggPrompt")}
                end
                if eligible(model)then
                    local point=promptPosition(pickupPrompt(model))
                    if point then
                        local distance=(root.Position-point).Magnitude
                        local score=config.Order=="Highest Luck"and-(tonumber(model:GetAttribute("EggLuck"))or 0)or distance
                        if not bestScore or score<bestScore then best,bestScore=model,score end
                    end
                end
            end
        end
        return best
    end
    local function stopMotion()
        local old=motion;motion=nil
        if not old then return end
        pcall(Run.UnbindFromRenderStep,Run,old.bindName)
        if old.controls and old.controls.GetMoveVector==old.override then old.controls.GetMoveVector=old.originalMove end
        if old.controls and old.wasEnabled then pcall(old.controls.Enable,old.controls)end
        if old.camera and workspace.CurrentCamera==old.camera then
            pcall(function()old.camera.CameraType=old.cameraType;old.camera.CFrame=old.cameraFrame end)
        end
        if old.humanoid and old.root.Parent then
            pcall(function()old.humanoid:Move(Vector3.zero,false);old.humanoid:MoveTo(old.root.Position)end)
        end
        if player:GetAttribute("MilkfishRiding")==true then
            local remote=RS:FindFirstChild("MilkfishRideInput")
            if remote then pcall(remote.FireServer,remote,Vector3.zero)end
        end
    end
    local function teleportDestination(prompt,point,character)
        if prompt.Name=="SpawnPlayer"then return point+Vector3.new(0,3,0)end
        if prompt.Name~="DepositSeaEgg"then return point+Vector3.new(0,math.min(3,prompt.MaxActivationDistance*.25),0)end
        -- Stand outside the cabinet, still within its activation radius.
        local radius=math.max(2,math.min(7,prompt.MaxActivationDistance-2))
        local interaction=hatchInteraction(prompt)
        local cabinet=interaction and interaction.Parent
        local front=Vector3.new(0,0,1)
        if cabinet then
            local emblem=cabinet:FindFirstChild("Lambang permata",true)or cabinet:FindFirstChild("Pelat pengunci",true)
            if emblem and emblem:IsA("BasePart")then
                local delta=emblem.Position-point;local flat=Vector3.new(delta.X,0,delta.Z)
                if flat.Magnitude>.1 then front=flat.Unit end
            end
        end
        local side=Vector3.new(front.Z,0,-front.X)
        local destinations={}
        for _,direction in ipairs({front,side,side*-1,front*-1,(front+side).Unit,(front-side).Unit,((front+side)*-1).Unit,((front-side)*-1).Unit})do
            destinations[#destinations+1]=point+direction*radius+Vector3.new(0,1,0)
        end
        for _,destination in ipairs(destinations)do
            local free=true
            if workspace.GetPartBoundsInBox then
                local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances={character}
                params.RespectCanCollide=true
                local root=character:FindFirstChild("HumanoidRootPart")
                params.CollisionGroup=root and root.CollisionGroup or"Default"
                local parts=workspace:GetPartBoundsInBox(CFrame.new(destination),Vector3.new(3.5,5,3.5),params)
                -- Mesh bounding boxes can cover empty space. Confirm against
                -- actual collision geometry instead of rejecting their bounds.
                if #parts>0 and workspace.GetPartsInPart and Instance and Instance.new then
                    local ok,result=pcall(function()
                        if not collisionProbe then
                            collisionProbe=Instance.new("Part")
                            collisionProbe.Name="DevilAquaLandingProbe";collisionProbe.Anchored=true
                            collisionProbe.CanCollide=false;collisionProbe.CanTouch=false;collisionProbe.CanQuery=false
                            collisionProbe.Transparency=1;collisionProbe.Size=Vector3.new(3.5,5,3.5)
                        end
                        collisionProbe.CFrame=CFrame.new(destination);collisionProbe.Parent=workspace
                        params.FilterDescendantsInstances={character,collisionProbe}
                        return workspace:GetPartsInPart(collisionProbe,params)
                    end)
                    if ok then parts=result else api.Report.approachQueryError=tostring(result)end
                end
                for _,part in ipairs(parts)do
                    if part.CanCollide then
                        free=false
                        local blockers=api.Report.approachBlockers or{}
                        api.Report.approachBlockers=blockers
                        if #blockers<12 then
                            blockers[#blockers+1]={part=part.GetFullName and part:GetFullName()or part.Name or"Unknown",class=part.ClassName,collisionGroup=part.CollisionGroup,at={x=destination.X,y=destination.Y,z=destination.Z}}
                        end
                        break
                    end
                end
            end
            if free then return destination end
        end
        return nil
    end
    local function returnDeposit()
        local default=nearestDeposit()
        if not config.Teleport then return default end
        local character,_,root=alive();local pot=ownPot()
        if not character or not pot then return end
        local best,bestDistance
        local scan={candidates=0,blocked=0}
        api.Report.returnScan=scan
        for _,prompt in ipairs(pot:GetDescendants())do
            if prompt:IsA("ProximityPrompt")and prompt.Name=="DepositSeaEgg"and availableDeposit(prompt,false)then
                local point=promptPosition(prompt)
                if point then
                    scan.candidates+=1
                    local destination=teleportDestination(prompt,point,character)
                    if destination then
                        local distance=(root.Position-destination).Magnitude
                        if not bestDistance or distance<bestDistance then best,bestDistance=prompt,distance end
                    else scan.blocked+=1 end
                end
            end
        end
        if best then scan.selectedSlot=hatchInteraction(best):GetAttribute("HatchSlot")end
        return best
    end
    local function travel(prompt,check,allowDisabled)
        stopMotion()
        local character,humanoid,root=alive()
        if not root then return false,"Waiting for character"end
        local riding=player:GetAttribute("MilkfishRiding")==true
        local point=promptPosition(prompt)
        if not point then return false,"Target disappeared"end
        -- Ground movement uses the normal humanoid. Underwater steering uses
        -- the existing ride controller's GetMoveVector input and camera direction.
        if not config.Teleport and not riding and point.Y<root.Position.Y-15 then return false,"Mount a fish to reach underwater eggs"end
        local token={humanoid=humanoid,root=root,bindName="DevilAquaEggMovement"}
        motion=token
        local ok,module=pcall(function()return require(player.PlayerScripts:WaitForChild("PlayerModule",5))end)
        if ok and module then
            token.controls=module:GetControls()
            token.wasEnabled=token.controls.controlsEnabled~=false
            token.originalMove=token.controls.GetMoveVector
            token.controls:Disable()
            token.override=function(self,...)
                if motion==token then return not config.Teleport and player:GetAttribute("MilkfishRiding")==true and Vector3.new(0,0,-1)or Vector3.zero end
                return token.originalMove(self,...)
            end
            token.controls.GetMoveVector=token.override
        elseif riding and not config.Teleport then stopMotion();return false,"Ride controls unavailable"end
        if config.Teleport then
            local function coordinates(v)return {x=v.X,y=v.Y,z=v.Z}end
            local record={mode="Teleport",prompt=prompt.Name,from=coordinates(root.Position),target=coordinates(point),stage="Starting"}
            api.Report.travel=record
            if riding then
                local remote=RS:FindFirstChild("MilkfishRideInput")
                if remote then pcall(remote.FireServer,remote,Vector3.zero)end
            end
            for attempt=1,2 do
                if not active or not config.Farm or motion~=token then break end
                local c,h=alive()
                if c~=character or h~=humanoid or not prompt.Parent or(check and not check())then break end
                if not prompt.Enabled and not allowDisabled then break end
                point=promptPosition(prompt)
                if not point then break end
                record.attempt=attempt;record.stage="Settling"
                status("Teleporting to "..prompt.Name)
                local destination=teleportDestination(prompt,point,character)
                if not destination then
                    record.stage="No clear approach outside cabinet";stopMotion()
                    return false,"No clear space outside hatch cabinet; save report"
                end
                record.destination=coordinates(destination)
                character:PivotTo(character:GetPivot()+(destination-root.Position))
                root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
                task.wait(.35)
                c,h=alive()
                if not active or not config.Farm or motion~=token or c~=character or h~=humanoid then break end
                if not prompt.Parent or(check and not check())then break end
                point=promptPosition(prompt)
                if not point then break end
                record.actual=coordinates(root.Position);record.distance=(root.Position-point).Magnitude
                if record.distance<=math.max(2,prompt.MaxActivationDistance-2)then
                    record.stage="Arrived";stopMotion();return true
                end
                record.stage="Position corrected or moved away"
            end
            stopMotion()
            if not active or not config.Farm then record.stage="Cancelled";return false,"Teleport cancelled"end
            return false,"Teleport did not stay near target; save farm report"
        end
        local direction=Vector3.zero
        if riding then
            local camera=workspace.CurrentCamera
            if not camera then stopMotion();return false,"Camera unavailable"end
            token.camera=camera;token.cameraType=camera.CameraType;token.cameraFrame=camera.CFrame
            camera.CameraType=Enum.CameraType.Scriptable
            Run:BindToRenderStep(token.bindName,Enum.RenderPriority.Camera.Value+1,function()
                if motion==token and root.Parent and direction.Magnitude>.001 then
                    local pos=root.Position+Vector3.new(0,4,0)
                    local up=math.abs(direction.Unit.Y)>.98 and Vector3.new(0,0,1)or Vector3.yAxis
                    camera.CFrame=CFrame.lookAt(pos,pos+direction.Unit*20,up)
                end
            end)
        end
        local beginning=now();local lastProgress=beginning;local bestDistance=math.huge
        local lastMove=-math.huge
        while active and config.Farm and motion==token do
            local c,h=alive()
            if c~=character or h~=humanoid then break end
            if not prompt.Parent or(not prompt.Enabled and not allowDisabled)or(check and not check())then break end
            point=promptPosition(prompt)
            if not point then break end
            direction=point-root.Position
            local distance=direction.Magnitude
            if distance<=math.max(2,prompt.MaxActivationDistance-2)then stopMotion();return true end
            if distance<bestDistance-1 then bestDistance=distance;lastProgress=now()end
            if now()-lastProgress>10 then stopMotion();return false,"Movement blocked; skipping this target"end
            if now()-beginning>120 then stopMotion();return false,"Travel timed out"end
            if not riding and now()-lastMove>.6 then
                lastMove=now();humanoid:MoveTo(point)
                -- A short forward obstacle check allows normal humanoid jumping.
                local params=RaycastParams.new();params.FilterDescendantsInstances={character};params.FilterType=Enum.RaycastFilterType.Exclude
                local flat=Vector3.new(direction.X,0,direction.Z)
                if flat.Magnitude>1 and workspace:Raycast(root.Position,flat.Unit*3,params)then humanoid.Jump=true end
            end
            status("Moving: "..math.floor(distance).." studs remaining")
            task.wait(.1)
        end
        stopMotion();return false,"Movement interrupted"
    end
    local function activate(prompt,confirmed)
        local _,_,root=alive()
        local point=promptPosition(prompt)
        if not root or not point or not prompt.Enabled or(root.Position-point).Magnitude>prompt.MaxActivationDistance then return false end
        if prompt.Name=="DepositSeaEgg"and not ownPrompt(prompt)then return false end
        api.Report.interaction={prompt=prompt.Name,enabled=prompt.Enabled,distance=(root.Position-point).Magnitude,stage="Holding"}
        status("Activating "..prompt.Name)
        heldPrompt=prompt
        local ok,err=pcall(function()
            prompt:InputHoldBegin()
            local finish=now()+math.max(0,prompt.HoldDuration)+.15
            repeat
                if confirmed and confirmed()then break end
                if not active or not config.Farm then break end
                task.wait(.03)
            until now()>=finish
        end)
        pcall(prompt.InputHoldEnd,prompt);heldPrompt=nil
        api.Report.interaction.stage=ok and"Hold ended; waiting for game confirmation"or"Prompt call failed"
        if not ok then
            if type(fireproximityprompt)=="function"then return pcall(fireproximityprompt,prompt,prompt.HoldDuration)end
            logError(err)
        end
        return ok
    end
    local function waitFor(predicate,seconds)
        local finish=now()+seconds
        repeat if predicate()then return true end;task.wait(.03)until not active or not config.Farm or now()>=finish
        return predicate()
    end
    local function returnEgg(id)
            if not active or not config.Farm or not alive()or carried()~=id then return end
            selected=nil
            api.Report.phase="Returning carried egg"
            api.Report.target=nil
            api.Report.returnStartedAt=now()
            -- Returning home must not depend on finding a clear hatch approach.
            -- SpawnPlayer is the game's own spawn marker under the owned pot.
            if config.Teleport and returnedHomeId~=id then
                local pot=ownPot()
                local spawn=pot and pot:FindFirstChild("SpawnPlayer",true)
                if spawn and spawn:IsA("BasePart")then
                    status("Returning egg to your home spawn")
                    local waypoint={Name="SpawnPlayer",Parent=spawn,Enabled=true,MaxActivationDistance=10}
                    local arrived,err=travel(waypoint,function()return carried()==id end,true)
                    api.Report.homeReturn={eggId=id,arrived=arrived,marker="SpawnPlayer",message=err}
                    if not arrived then status(err);return end
                    returnedHomeId=id
                else
                    api.Report.homeReturn={eggId=id,arrived=false,message="Owned pot SpawnPlayer is not loaded"}
                end
            end
            api.Report.approachBlockers={}
            local deposit=returnDeposit()
            if not deposit then
                if api.Report.returnScan and api.Report.returnScan.candidates>0 then
                    status(returnedHomeId==id and"Returned home with egg; hatch approaches blocked - save report"or"Holding egg: all empty hatch approaches blocked; save report")
                else status(noDepositStatus())end
                return
            end
            status("Returning carried egg to your pot")
            local arrived,err=travel(deposit,function()return carried()==id and availableDeposit(deposit,false)end,true)
            if not arrived then status(err);return end
            if not active or not config.Farm or carried()~=id then return end
            if not waitFor(function()return deposit.Parent and deposit.Enabled end,3)then
                status("At empty hatch slot, but DepositSeaEgg is disabled; save report");return
            end
            if not active or not config.Farm or carried()~=id or not availableDeposit(deposit,true)then return end
            local interaction=hatchInteraction(deposit)
            local slot=interaction and interaction:GetAttribute("HatchSlot")
            local oldStatus=interaction and interaction:GetAttribute("Status")
            local previousEntry
            for _,entry in ipairs(hatches)do if entry.Slot==slot then previousEntry=entry end end
            local function confirmed()
                if carried()or not alive()then return false end
                local newStatus=interaction and interaction.Parent and interaction:GetAttribute("Status")
                if newStatus and newStatus~=oldStatus and newStatus~="Empty"then return true end
                for _,entry in ipairs(hatches)do
                    if entry.Slot==slot and entry~=previousEntry and tonumber(entry.FinishAt)then return true end
                end
                return false
            end
            activate(deposit,confirmed)
            if waitFor(confirmed,5)then
                returnedHomeId=nil;api.Report.deposited+=1;status("Egg deposited: "..api.Report.deposited)
            else status("Deposit unconfirmed; check hatch state before retry");task.wait(2)end
            return
    end
    local function farmStep()
        if not alive()then selected=nil;status("Waiting for character");return end
        local id=carried()
        if id then returnEgg(id);return end
        returnedHomeId=nil
        if not nearestDeposit()then status(noDepositStatus());return end
        if not eligible(selected)then selected=chooseEgg()end
        if not selected then status("Waiting for an available egg matching your filters");return end
        local model=selected;local eggId=model:GetAttribute("EggId");local prompt=pickupPrompt(model)
        api.Report.phase="Collecting wild egg"
        api.Report.target={id=eggId,tier=model:GetAttribute("EggTier"),kg=model:GetAttribute("EggKg"),luck=model:GetAttribute("EggLuck"),source=eggSource(model)}
        local arrived,err=travel(prompt,function()return not carried()and eligible(model)end)
        if not arrived then
            retryEgg[eggId]=now()+30;selected=nil;status(err);return
        end
        if not active or not config.Farm or carried()then return end
        activate(prompt,function()return carried()~=nil end)
        if waitFor(function()return carried()~=nil end,5)then
            local heldId=carried()
            api.Report.pickup={requestedEggId=eggId,carriedEggId=heldId,idChanged=heldId~=eggId}
            api.Report.picked+=1;api.Report.pickupConfirmedAt=now();status("Egg pickup confirmed - returning now")
            selected=nil;returnEgg(heldId);return
        else
            retryEgg[eggId]=now()+20
            api.Report.pickup={requestedEggId=eggId,hasSeaEgg=player:GetAttribute("HasSeaEgg"),eggEquipped=player:GetAttribute("EggEquipped"),confirmed=false}
            status("Pickup unconfirmed: no CarriedEggId received; save report")
        end
        selected=nil
    end
    links[#links+1]=events.OnClientEvent:Connect(function(kind,data)
        if kind=="Hatches"and type(data)=="table"then hatches=data end
        if kind=="Collection"and type(data)=="table"then collection=data;collectionReady=true end
        if kind=="Collection"and config.EquipBest and not selling and now()-lastEquip>3 then
            lastEquip=now();local ok,err=pcall(requests.FireServer,requests,"EquipBest");if not ok then logError(err)end
        end
    end)
    local function hatchStep()
        for _,entry in ipairs(hatches)do
            local slot=tonumber(entry.Slot)
            if slot and tonumber(entry.FinishAt)and workspace:GetServerTimeNow()>=entry.FinishAt and not entry.Triggered and now()>=(hatchRetry[slot]or 0)then
                if not active or not config.Hatch then return end
                hatchRetry[slot]=now()+4
                requests:FireServer("HatchFromUI",slot);api.Report.hatchRequests+=1
            end
        end
    end
    local function autoState(key,text)
        local entry=api.Report.automation[key]or{requests=0,confirmed=0}
        api.Report.automation[key]=entry;entry.status=text;entry.updatedAt=now()
        if onStatus then pcall(onStatus,api.Report.status,api.Report)end
        return entry
    end
    local giftConnection
    local function dailyStep()
        local remote=RS:FindFirstChild("DailyRewardRequest")
        if not remote then autoState("Daily","Remote unavailable");return end
        local response=remote:InvokeServer("State")
        if not active or not config.AutoDaily then return end
        local state=type(response)=="table"and response.Ok and response.State
        local claimAt=state and tonumber(state.NextClaimAt)
        if not claimAt then autoState("Daily","Waiting for reward state");return end
        if claimAt>workspace:GetServerTimeNow()then
            local entry=autoState("Daily","Waiting for daily cooldown");entry.nextClaimAt=claimAt;return
        end
        local entry=autoState("Daily","Claiming daily reward");entry.requests+=1
        local result=remote:InvokeServer("Claim")
        if not active then return end
        if type(result)=="table"and result.Ok then entry.confirmed+=1;autoState("Daily","Daily reward claimed")
        else autoState("Daily","Daily claim not confirmed")end
    end
    local function giftStep()
        local folder=RS:FindFirstChild("FreeGiftRemotes")
        local check=folder and folder:FindFirstChild("FreeGiftCheck")
        local claim=folder and folder:FindFirstChild("FreeGiftClaim")
        if not check or not claim then autoState("Gift","Remote unavailable");return end
        if not giftConnection then
            giftConnection=claim.OnClientEvent:Connect(function(ok,message)
                if not active then return end
                local entry=autoState("Gift",ok and"Free gift claimed"or"Free gift claim rejected")
                if ok then entry.confirmed+=1 end
                entry.message=message and tostring(message)or nil
            end)
            links[#links+1]=giftConnection
        end
        local state=check:InvokeServer()
        if not active or not config.AutoGift then return end
        if type(state)~="table"then autoState("Gift","Waiting for reward state");return end
        if state.claimed then autoState("Gift","Free gift already claimed");return end
        if state.joinedGroup~=true then autoState("Gift","Join the game group to qualify");return end
        local entry=autoState("Gift","Claiming free gift");entry.requests+=1;claim:FireServer()
    end
    local function luckStep()
        local pot=ownPot()
        if not pot or tonumber(pot:GetAttribute("OwnerUserId"))~=player.UserId then autoState("Luck","Waiting for owned pot");return end
        local level=tonumber(pot:GetAttribute("HatchLuckLevel"))
        if not level then autoState("Luck","Waiting for luck level");return end
        if(tonumber(player:GetAttribute("Coins"))or 0)<=0 then autoState("Luck","Waiting for coins");return end
        local entry=autoState("Luck","Requesting max affordable luck upgrade")
        entry.level=level;entry.requests+=1;requests:FireServer("UpgradeLuckMax",level)
    end
    local function equipStep()
        if selling then return end
        if now()-lastEquip<3 then return end
        lastEquip=now();local entry=autoState("Equip","Equipping best fish")
        entry.requests+=1;requests:FireServer("EquipBest")
    end
    local function fishRecord(id)
        for _,fish in ipairs(collection)do if fish.Id==id then return fish end end
    end
    local function fishRarity(fish)
        local catalog=RS.EggGame:FindFirstChild("Catalog")
        local entry=catalog and catalog:FindFirstChild(fish.Name)
        return entry and entry:GetAttribute("Rarity")or fish.Rarity
    end
    local function canSell(fish,bestId)
        return fish and type(fish.Id)=="string"and type(fish.Name)=="string"
            and not fish.Favorite and not fish.Locked and(tonumber(fish.AquariumSlot)or 0)==0
            and(config.SellRarities or{})[fishRarity(fish)]==true
            and(not config.KeepBest or fish.Id~=bestId)
    end
    local function sellWait(predicate,seconds)
        local finish=now()+seconds
        repeat
            if not active or not config.AutoSell then return false end
            if predicate()then return true end
            task.wait(.05)
        until now()>=finish
        return false
    end
    local function sellStep()
        if farmBusy or selling then autoState("Sell","Waiting for farm or movement to finish");return end
        if not next(config.SellRarities or{})then autoState("Sell","Choose fish rarities to sell");return end
        if not collectionReady then autoState("Sell","Waiting for inventory");return end
        local folder=RS:FindFirstChild("FishSellRemotes")
        local remote=folder and folder:FindFirstChild("Request")
        if not remote then autoState("Sell","Remote unavailable");return end
        selling=true
        local original=player:GetAttribute("EquippedFishId")
        local keepBestAtStart=config.KeepBest
        local touched=false
        local controlledId
        local ok,err=xpcall(function()
            local bestId
            if config.KeepBest then
                touched=true;requests:FireServer("EquipBest");task.wait(.4)
                if not active or not config.AutoSell then return end
                bestId=player:GetAttribute("EquippedFishId")
                controlledId=bestId
                if not fishRecord(bestId)then autoState("Sell","Waiting for best fish confirmation");return end
            end
            local fish
            for _,entry in ipairs(collection)do if canSell(entry,bestId)then fish=entry;break end end
            if not fish then autoState("Sell","No fish matching sell filters");return end
            local entry=autoState("Sell","Equipping selected fish")
            entry.fishId=fish.Id;entry.name=fish.Name;entry.rarity=fishRarity(fish)
            entry.mode="RemoteOnly";entry.serverMessage=nil;entry.result=nil
            touched=true;requests:FireServer("EquipFish",fish.Id)
            if not sellWait(function()return player:GetAttribute("EquippedFishId")==fish.Id end,3)then autoState("Sell","Fish equip not confirmed");return end
            controlledId=fish.Id
            if not active or not config.AutoSell or not alive()then return end
            autoState("Sell","Requesting quote from current position")
            local quote=remote:InvokeServer("Quote",nil)
            if not active or not config.AutoSell then return end
            entry.quote=type(quote)=="table"and{ok=quote.ok,name=quote.name,id=quote.id or quote.fishId or quote.Id,kg=quote.kg,message=quote.message}or{type=type(quote)}
            if type(quote)~="table"or quote.ok~=true then
                entry.serverMessage=type(quote)=="table"and tostring(quote.message or quote.error or"Unknown rejection")or"Invalid quote response"
                autoState("Sell","Server rejected quote");return
            end
            local current=fishRecord(fish.Id)
            local quoteId=type(quote)=="table"and(quote.id or quote.fishId or quote.Id)
            local matches=type(quote)=="table"and quote.ok==true and type(quote.token)=="string"and quote.token~=""
                and quote.name==fish.Name and(quoteId==nil or quoteId==fish.Id)
                and tonumber(quote.kg)and tonumber(current and current.Kg)
                and math.abs(quote.kg-current.Kg)<.01 and tostring(quote.mutation or"")==tostring(current.Mutation or"")
            if not matches or config.KeepBest~=keepBestAtStart or not alive()or not canSell(current,bestId)or player:GetAttribute("EquippedFishId")~=fish.Id then
                autoState("Sell","Quote or fish changed; sale cancelled");return
            end
            entry.requests+=1
            local result=remote:InvokeServer("Sell",quote.token)
            entry.result=type(result)=="table"and{ok=result.ok,amount=result.amount,message=result.message,error=result.error}or{type=type(result),value=tostring(result)}
            if type(result)=="table"and result.ok then
                entry.confirmed+=1;entry.earned=(entry.earned or 0)+(tonumber(result.amount)or 0)
                entry.status="Fish sale confirmed"
                -- Wait for inventory removal, preventing a second quote for this ID.
                if not sellWait(function()return fishRecord(fish.Id)==nil end,3)then
                    config.AutoSell=false;autoState("Sell","Sale succeeded; inventory pending - auto sell paused")
                else autoState("Sell","Fish sale confirmed")end
            else
                entry.serverMessage=type(result)=="table"and tostring(result.message or result.error or"Unknown rejection")or"Invalid sell response"
                autoState("Sell","Fish sale rejected")
            end
        end,debug.traceback)
        local equipped=player:GetAttribute("EquippedFishId")
        if touched and active and(equipped==nil or equipped==false or equipped==controlledId)then
            local restore=original and fishRecord(original)and original or false
            pcall(requests.FireServer,requests,"EquipFish",restore)
        end
        selling=false
        if not ok then logError(err);autoState("Sell","Auto request failed")end
    end
    local autoFlags={"AutoDaily","AutoGift","AutoLuck","EquipBest","AutoSell"}
    function api.StopAll()
        config.Hatch=false
        for _,flag in ipairs(autoFlags)do config[flag]=false end
        api.SetFly(false);api.SetSpeed(false)
        api.SetFarm(false)
    end
    local function restoreSpeed()
        if speedHumanoid then pcall(function()speedHumanoid.WalkSpeed=originalSpeed end)end
        speedHumanoid=nil;originalSpeed=nil
    end
    function api.SetSpeed(enabled)
        config.SpeedEnabled=enabled==true
        if not config.SpeedEnabled then restoreSpeed()end
    end
    local function stopFlight()
        local old=flight;flight=nil
        if not old then return end
        if old.link then old.link:Disconnect()end
        for _,object in ipairs(old.objects)do pcall(object.Destroy,object)end
        pcall(function()old.humanoid.PlatformStand=old.platformStand;old.humanoid.AutoRotate=old.autoRotate;old.root.AssemblyLinearVelocity=Vector3.zero end)
    end
    function api.SetFly(enabled)
        config.Fly=enabled==true
        if not config.Fly then stopFlight();return end
        api.SetFarm(false)
    end
    local function startFlight(character,humanoid,root)
        local token={humanoid=humanoid,root=root,objects={},platformStand=humanoid.PlatformStand,autoRotate=humanoid.AutoRotate}
        flight=token
        local function create(class)local obj=Instance.new(class);token.objects[#token.objects+1]=obj;return obj end
        local attachment=create("Attachment");attachment.Name="DevilAquaFlight";attachment.Parent=root
        local velocity=create("LinearVelocity");velocity.Attachment0=attachment;velocity.RelativeTo=Enum.ActuatorRelativeTo.World
        velocity.MaxForce=math.huge;velocity.VectorVelocity=Vector3.zero;velocity.Parent=root
        local facing=create("AlignOrientation");facing.Attachment0=attachment;facing.Mode=Enum.OrientationAlignmentMode.OneAttachment
        facing.MaxTorque=math.huge;facing.Responsiveness=50;facing.Parent=root
        humanoid.PlatformStand=true;humanoid.AutoRotate=false
        local input=game:GetService("UserInputService")
        local controls
        pcall(function()controls=require(player.PlayerScripts:WaitForChild("PlayerModule",3)):GetControls()end)
        token.link=Run.Heartbeat:Connect(function()
            if flight~=token or not active or not config.Fly then return end
            local c,h=alive()
            if c~=character or h~=humanoid then stopFlight();return end
            local camera=workspace.CurrentCamera
            if not camera then return end
            local move=Vector3.zero
            if not input:GetFocusedTextBox()then
                local keys=Enum.KeyCode
                if input:IsKeyDown(keys.W)then move+=camera.CFrame.LookVector end
                if input:IsKeyDown(keys.S)then move-=camera.CFrame.LookVector end
                if input:IsKeyDown(keys.D)then move+=camera.CFrame.RightVector end
                if input:IsKeyDown(keys.A)then move-=camera.CFrame.RightVector end
                if input:IsKeyDown(keys.Space)then move+=Vector3.yAxis end
                if input:IsKeyDown(keys.LeftControl)then move-=Vector3.yAxis end
                if move.Magnitude==0 and controls then
                    local vector=controls:GetMoveVector()
                    move=camera.CFrame.RightVector*vector.X-camera.CFrame.LookVector*vector.Z
                end
            end
            if move.Magnitude>0 then move=move.Unit end
            velocity.VectorVelocity=move*(tonumber(config.FlySpeed)or 50)
            facing.CFrame=camera.CFrame.Rotation
        end)
    end
    function api.SaveReport()
        nearestDeposit()
        api.Report.player={userId=player.UserId,carriedEggId=carried(),hasSeaEgg=player:GetAttribute("HasSeaEgg"),eggEquipped=player:GetAttribute("EggEquipped"),riding=player:GetAttribute("MilkfishRiding")}
        if type(writefile)=="function"then pcall(function()
            writefile("DevilAquaAutoEgg-report.json",game:GetService("HttpService"):JSONEncode(api.Report))
        end)end
    end
    function api.SetFarm(enabled)
        if enabled and config.Fly then api.SetFly(false)end
        config.Farm=enabled
        if not enabled then selected=nil;stopMotion();if heldPrompt then pcall(heldPrompt.InputHoldEnd,heldPrompt);heldPrompt=nil end end
        status(enabled and"Auto Egg enabled"or"Auto Egg stopped")
    end
    function api.Destroy()
        if not active then return end
        api.SetFly(false);api.SetSpeed(false)
        api.SetFarm(false);active=false
        for _,link in ipairs(links)do link:Disconnect()end
        if collisionProbe then collisionProbe:Destroy();collisionProbe=nil end
        api.SaveReport()
    end
    -- Pure selection helpers exposed for diagnostics and offline regression.
    api.ChooseEgg=chooseEgg;api.NearestDeposit=nearestDeposit;api.Carried=carried
    task.spawn(function()
        while active do
            api.Report.workerTick=now()
            if config.Farm and not selling then
                farmBusy=true
                local ok,err=xpcall(farmStep,debug.traceback)
                farmBusy=false
                if not ok then stopMotion();logError(err);status("Retrying after error; check report");task.wait(2)end
            end
            task.wait(.5)
        end
    end)
    for _,job in ipairs({{"AutoDaily","Daily",30,dailyStep},{"AutoGift","Gift",30,giftStep},{"AutoLuck","Luck",5,luckStep},{"EquipBest","Equip",10,equipStep},{"AutoSell","Sell",5,sellStep}})do
        task.spawn(function()
            local due=0
            while active do
                if config[job[1]]and now()>=due then
                    due=now()+job[3]
                    local ok,err=pcall(job[4])
                    if not ok then logError(err);autoState(job[2],"Auto request failed")end
                elseif not config[job[1]]then due=0 end
                task.wait(1)
            end
        end)
    end
    task.spawn(function()
        while active do
            local c,h,root=alive()
            if config.SpeedEnabled and h then
                if speedHumanoid~=h then restoreSpeed();speedHumanoid=h;originalSpeed=h.WalkSpeed end
                h.WalkSpeed=tonumber(config.WalkSpeed)or 16
            elseif speedHumanoid then restoreSpeed()end
            if config.Fly and h then
                if not flight then local ok,err=pcall(startFlight,c,h,root);if not ok then stopFlight();config.Fly=false;logError(err)end end
            elseif flight then stopFlight()end
            task.wait(.2)
        end
    end)
    task.spawn(function()
        while active do
            if config.Hatch then local ok,err=pcall(hatchStep);if not ok then logError(err)end end
            task.wait(1)
        end
    end)
    local ready,readyError=pcall(requests.FireServer,requests,"Ready")
    if not ready then logError(readyError)end
    status(config.Teleport and"Ready - teleport egg collection"or"Ready - mount your fish before collecting underwater eggs")
    return api
end

    end)()
    core=make(config,refresh);controller.Core=core
    buildUI()
end,debug.traceback)
if not ok then controller.Destroy();error("DEVIL HUB Aqua: "..tostring(err),0)end
return controller
