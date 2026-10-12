assert(game.PlaceId==104050046639813,"Open Aqua / เปิดแมพ Aqua")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilAquaAutoEgg then scope.DevilAquaAutoEgg.Destroy()end
local config={Farm=false,Hatch=false,EquipBest=false,AutoDaily=false,AutoGift=false,AutoLuck=false,Tiers={},MinKg=0,MinLuck=0,Order="Highest Luck",Dropped=true,Teleport=true,Language=scope.DevilAquaLanguage or"TH"}
local window,core,library,stateLabel,totalsLabel,autoLabel
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
buildUI=function()
    if done then return end
    local previous=window
    stateLabel=nil;totalsLabel=nil;autoLabel=nil
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,Theme="Crimson",Density="Compact",Profile=false,Search=false,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(790,550),ToggleButton={Platform="Both",Icon=image},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false,FolderName="DevilAqua"}})
    if previous then previous:Destroy()end
    local tab=window:CreateTab({Name=t("Auto Egg","เก็บไข่อัตโนมัติ"),Icon="egg",Backdrop=false})
    local farm=tab:CreateGroupbox({Name=t("Egg Farm","ระบบเก็บไข่"),Side="Left"})
    local filters=tab:CreateGroupbox({Name=t("Egg Filters","เลือกระดับไข่"),Side="Right"})
    farm:CreateDropdown({Name="ภาษา / Language",Options={"ไทย","English"},CurrentOption={config.Language=="TH"and"ไทย"or"English"},Callback=function(value)
        value=type(value)=="table"and value[1]or value
        local language=value=="English"and"EN"or"TH"
        if language==config.Language then return end
        config.Language=language;scope.DevilAquaLanguage=language
        task.defer(function()local ok,err=xpcall(buildUI,debug.traceback);if not ok then controller.Destroy();warn(err)end end)
    end})
    stateLabel=farm:CreateParagraph({Name=t("Farm status","สถานะฟาร์ม"),Content=""});totalsLabel=farm:CreateLabel({Text=""})
    local toggles={}
    local function toggle(group,flag,en,th,callback)
        local widget=group:CreateToggle({Name=t(en,th),CurrentValue=config[flag]==true,Callback=function(value)if callback then callback(value)else config[flag]=value end end})
        toggles[flag]=widget;return widget
    end
    toggle(farm,"Farm","Auto Collect + Return Egg","เก็บไข่และกลับบ้านอัตโนมัติ",core.SetFarm)
    toggle(farm,"Hatch","Auto Hatch Ready Eggs","ฟักไข่ที่ครบเวลาอัตโนมัติ")
    toggle(farm,"EquipBest","Auto Equip Best Fish","เลือกปลาที่ดีที่สุดอัตโนมัติ")
    farm:CreateButton({Name=t("Start Egg Farm + Hatch","เริ่มเก็บไข่และฟัก"),Callback=function()config.Hatch=true;toggles.Hatch:Set(true,true);toggles.Farm:Set(true,true);core.SetFarm(true)end})
    farm:CreateButton({Name=t("Stop All","หยุดออโต้ทั้งหมด"),Callback=function()core.StopAll();for _,widget in pairs(toggles)do widget:Set(false,true)end;refresh(core.Report.status,core.Report)end})
    farm:CreateButton({Name=t("Save Farm Report","บันทึกรายงาน"),Callback=core.SaveReport})
    farm:CreateParagraph({Name=t("Return route","เส้นทางกลับ"),Content=t("Collect egg, return to your home SpawnPlayer, then approach an empty hatch slot from outside the cabinet.","เก็บไข่แล้วกลับจุดเกิดของบ้านคุณก่อน จากนั้นไปฝากช่องว่างโดยยืนอยู่นอกตู้")})
    local tiers={"Abuseall6","Abuseall5","Abuseall4","Abuseall3","Abuseall2","Abuseall1","KrakenGlory","SolarOrbit","AzureCrown","AmethystSpiral","GlacialSpiral","CoralReef","Eternal","Celestial","Sovereign","Trench","Abyss","Deep","Tidal","Reef","Coral","Common"}
    local seen={};for _,tier in ipairs(tiers)do seen[tier]=true end
    local runtime=workspace:FindFirstChild("EggRuntime")
    for _,name in ipairs({"WildEggs","DroppedEggs"})do
        local folder=runtime and runtime:FindFirstChild(name)
        for _,model in ipairs(folder and folder:GetChildren()or{})do local tier=model:GetAttribute("EggTier");if type(tier)=="string"and not seen[tier]then seen[tier]=true;tiers[#tiers+1]=tier end end
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
    filters:CreateParagraph({Name=t("Selection","การเลือกไข่"),Content=t("Empty selection allows all types. Selected types that have not spawned are waited for. Tier names keep their game names.","ไม่เลือกระดับจะรับทุกชนิด ถ้าระดับที่เลือกยังไม่เกิด ระบบจะรอ ชื่อชนิดไข่ใช้ชื่อตามเกม")})
    local autoTab=window:CreateTab({Name=t("Other Auto","ระบบออโต้อื่น"),Icon="gift",Backdrop=false})
    local rewards=autoTab:CreateGroupbox({Name=t("Rewards","รับรางวัล"),Side="Left"})
    autoLabel=rewards:CreateParagraph({Name=t("Auto status","สถานะออโต้"),Content=""})
    toggle(rewards,"AutoDaily","Auto Daily Reward","รับรางวัลรายวันอัตโนมัติ")
    toggle(rewards,"AutoGift","Auto Free Gift","รับของขวัญฟรีอัตโนมัติ")
    rewards:CreateParagraph({Name=t("Free gift eligibility","เงื่อนไขของขวัญ"),Content=t("Claims only when the server says your account qualifies. Join the game's group yourself if required.","รับเมื่อเซิร์ฟเวอร์แจ้งว่าบัญชีผ่านเงื่อนไข หากต้องเข้ากลุ่ม ให้เข้ากลุ่มของเกมก่อน")})
    local upgrades=autoTab:CreateGroupbox({Name=t("Upgrades","อัปเกรด"),Side="Right"})
    toggle(upgrades,"AutoLuck","Auto Upgrade Hatch Luck (uses coins)","อัปโชคฟักอัตโนมัติ (ใช้เงินในเกม)")
    upgrades:CreateParagraph({Name=t("Luck upgrade","การอัปโชค"),Content=t("When enabled, requests the maximum affordable Hatch Luck upgrade every 5 seconds using game coins.","เมื่อเปิด จะขออัปโชคฟักสูงสุดที่ซื้อไหวทุก 5 วินาที โดยใช้เงินในเกม")})
    local info=window:CreateTab({Name=t("Info","ข้อมูล"),Icon="info",Backdrop=false})
    local about=info:CreateGroupbox({Name="DEVIL HUB",Side="Left"})
    about:CreateLabel({Text=t("Aqua Auto Egg - release 7","ระบบเก็บไข่ Aqua - เวอร์ชัน 7")})
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
    local api={Config=config,Report={release="aqua-auto-egg-7",picked=0,deposited=0,hatchRequests=0,errors={},automation={}}}
    local active=true
    local links={}
    local hatches={}
    local retryEgg={}
    local hatchRetry={}
    local selected
    local motion
    local heldPrompt
    local collisionProbe
    local returnedHomeId
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
            if node:IsA("ProximityPrompt")and(node.Name=="TakeSeaEgg"or node.Name=="PickupDroppedEgg")and node.Enabled then return node end
        end
    end
    local function eligible(model)
        if not model or not model.Parent or not model:IsA("Model")then return false end
        local runtime=workspace:FindFirstChild("EggRuntime")
        if not runtime then return false end
        local wild=runtime:FindFirstChild("WildEggs")
        local dropped=config.Dropped and runtime:FindFirstChild("DroppedEggs")
        if model.Parent~=wild and model.Parent~=dropped then return false end
        local id=model:GetAttribute("EggId")
        if type(id)~="string"or id==""or now()<(retryEgg[id]or 0)then return false end
        local tier=model:GetAttribute("EggTier")
        if next(config.Tiers)and not config.Tiers[tier]then return false end
        if(tonumber(model:GetAttribute("EggKg"))or 0)<config.MinKg then return false end
        if(tonumber(model:GetAttribute("EggLuck"))or 0)<config.MinLuck then return false end
        return pickupPrompt(model)~=nil
    end
    local function chooseEgg()
        local _,_,root=alive()
        if not root then return end
        local runtime=workspace:FindFirstChild("EggRuntime")
        if not runtime then return end
        local best,bestScore
        for _,folderName in ipairs(config.Dropped and{"WildEggs","DroppedEggs"}or{"WildEggs"})do
            local folder=runtime:FindFirstChild(folderName)
            for _,model in ipairs(folder and folder:GetChildren()or{})do
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
        api.Report.target={id=eggId,tier=model:GetAttribute("EggTier"),kg=model:GetAttribute("EggKg"),luck=model:GetAttribute("EggLuck"),source=model.Parent.Name}
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
        if kind=="Collection"and config.EquipBest and now()-lastEquip>3 then
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
        if now()-lastEquip<3 then return end
        lastEquip=now();local entry=autoState("Equip","Equipping best fish")
        entry.requests+=1;requests:FireServer("EquipBest")
    end
    local autoFlags={"AutoDaily","AutoGift","AutoLuck","EquipBest"}
    function api.StopAll()
        config.Hatch=false
        for _,flag in ipairs(autoFlags)do config[flag]=false end
        api.SetFarm(false)
    end
    function api.SaveReport()
        nearestDeposit()
        api.Report.player={userId=player.UserId,carriedEggId=carried(),hasSeaEgg=player:GetAttribute("HasSeaEgg"),eggEquipped=player:GetAttribute("EggEquipped"),riding=player:GetAttribute("MilkfishRiding")}
        if type(writefile)=="function"then pcall(function()
            writefile("DevilAquaAutoEgg-report.json",game:GetService("HttpService"):JSONEncode(api.Report))
        end)end
    end
    function api.SetFarm(enabled)
        config.Farm=enabled
        if not enabled then selected=nil;stopMotion();if heldPrompt then pcall(heldPrompt.InputHoldEnd,heldPrompt);heldPrompt=nil end end
        status(enabled and"Auto Egg enabled"or"Auto Egg stopped")
    end
    function api.Destroy()
        if not active then return end
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
            if config.Farm then
                local ok,err=xpcall(farmStep,debug.traceback)
                if not ok then stopMotion();logError(err);status("Retrying after error; check report");task.wait(2)end
            end
            task.wait(.5)
        end
    end)
    for _,job in ipairs({{"AutoDaily","Daily",30,dailyStep},{"AutoGift","Gift",30,giftStep},{"AutoLuck","Luck",5,luckStep},{"EquipBest","Equip",10,equipStep}})do
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
