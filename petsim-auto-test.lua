-- DEVIL HUB standalone trial. Uses native client modules from the supplied dump.
assert(game.GameId==3317771874 or game.PlaceId==8737899170,"Open the map from dump Place 8737899170")
local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilPetSimTest then env.DevilPetSimTest.Destroy() end
local makeCore=(function()
return function(config, d, changed)
    local C={Config=config,Report={release="petsim-auto-test-1",jobs={},errors={},liveTest=false}}
    local names={"Farm","Tap","Orbs","Hatch","Equip","Gifts","Ranks","Zones","Rebirth"}
    local jobs=C.Report.jobs
    local alive=true
    local locked, assigned, lastEquip
    local function notify() if changed then pcall(changed,C.Report) end end
    local function status(key,text,details)
        local j=jobs[key];j.status=text;j.updatedAt=d.Now()
        if details then for k,v in pairs(details) do j[k]=v end end
        notify()
    end
    for _,key in ipairs(names) do jobs[key]={status="Disabled",requests=0,confirmed=0,nextAt=0,generation=0} end
    local function request(key,remote,...)
        local j=jobs[key]
        if not alive or not config[key] then return false,"Cancelled" end
        if d.CanInvoke and not d.CanInvoke() then return false,"Waiting for previous server request" end
        local generation=j.generation
        j.requests+=1
        local result=table.pack(d.Invoke(remote,...))
        if not alive or not config[key] or generation~=j.generation then return false,"Cancelled" end
        j.serverMessage=result[2] and tostring(result[2]) or nil
        if result[1]==true then j.confirmed+=1 end
        return table.unpack(result,1,result.n)
    end
    local function pending(key,id,confirmed)
        local j=jobs[key]
        if j.pending then
            if confirmed(j.pending.id) then
                j.confirmed+=1;j.pending=nil;status(key,"Confirmed")
            elseif d.Now()-j.pending.at>12 then
                j.pending=nil;j.nextAt=d.Now()+20;status(key,"No confirmation; waiting before retry")
            else status(key,"Waiting for server confirmation") end
            return true
        end
        if id then j.pending={id=id,at=d.Now()} end
        return false
    end
    local actions={}
    actions.Farm=function()
        if not locked or not d.TargetValid(locked,config) then
            locked=d.FindTarget(config);assigned={}
        end
        if not locked then status("Farm","Waiting for loaded targets in selected zone");return end
        local count=0
        for id,pet in pairs(d.Pets()) do
            count+=1
            if assigned[id]~=locked.id or not d.PetOnTarget(pet,locked) then
                if not config.Farm then break end
                d.AssignPet(pet,locked);assigned[id]=locked.id;jobs.Farm.requests+=1
            end
        end
        status("Farm",count==0 and "Equip pets first" or "Pets assigned to locked target",
            {target=locked.id,targetName=locked.name,pets=count})
    end
    actions.Tap=function()
        local target=locked and d.TargetValid(locked,config) and locked or d.FindTarget(config)
        if not target then status("Tap","Waiting for loaded targets in selected zone");return end
        if target.distance>40 then status("Tap","Move closer to target");return end
        d.Fire("AutoClicker_Nearby",target.id);jobs.Tap.requests+=1
        status("Tap","Tap requested; damage not yet confirmed",{target=target.id})
    end
    actions.Orbs=function()
        local ids=d.OrbBatch(100)
        if #ids==0 then status("Orbs","Waiting for new server-created orbs");return end
        d.Fire("Orbs: Collect",ids);d.OrbSent(ids);jobs.Orbs.requests+=1
        status("Orbs","Collection requested; inventory not yet confirmed",{batch=#ids})
    end
    actions.Hatch=function()
        if config.Egg=="" then status("Hatch","Select an egg first");return end
        local egg=d.Egg(config.Egg)
        if not egg then status("Hatch","Selected egg unavailable");return end
        local ok,message=request("Hatch","Eggs_RequestPurchase",egg._id or config.Egg,math.clamp(math.floor(config.HatchCount),1,100))
        status("Hatch",ok==true and "Hatch confirmed" or "Server rejected hatch",{serverMessage=tostring(message or "")})
        if ok~=true then jobs.Hatch.nextAt=d.Now()+8 end
    end
    actions.Equip=function()
        local snapshot=d.EquippedSnapshot()
        if lastEquip and snapshot~=lastEquip then jobs.Equip.confirmed+=1 end
        lastEquip=snapshot
        d.EquipBest();jobs.Equip.requests+=1
        status("Equip","Equip Best requested; watching equipped pets")
    end
    actions.Gifts=function()
        local save=d.Save()
        if pending("Gifts",nil,function(id) return table.find(save.FreeGiftsRedeemed or {},id)~=nil end) then return end
        for _,gift in ipairs(d.Gifts()) do
            if (save.FreeGiftsTime or 0)>=gift.WaitTime and not table.find(save.FreeGiftsRedeemed or {},gift.Id) then
                local ok,message=request("Gifts","Redeem Free Gift",gift.Id)
                status("Gifts",ok==true and "Gift confirmed" or "Server rejected gift",{gift=gift.Id,serverMessage=tostring(message or "")})
                jobs.Gifts.nextAt=d.Now()+5
                return
            end
        end
        status("Gifts","Waiting for eligible gifts")
    end
    actions.Ranks=function()
        local save=d.Save()
        if pending("Ranks",nil,function(id) return (save.RedeemedRankRewards or {})[tostring(id)]~=nil end) then return end
        local stars=0
        for index,reward in ipairs(d.RankRewards(save.Rank)) do
            stars+=reward.StarsRequired or 0
            if stars>(save.RankStars or 0) then break end
            if (save.RedeemedRankRewards or {})[tostring(index)]==nil then
                d.Fire("Ranks_ClaimReward",index);jobs.Ranks.requests+=1
                pending("Ranks",index,function() return false end)
                status("Ranks","Waiting for server confirmation",{reward=index});return
            end
        end
        status("Ranks","Waiting for eligible rank rewards")
    end
    actions.Zones=function()
        local zone=d.NextZone()
        if not zone then status("Zones","No next zone");return end
        if not d.ZoneQuestsReady() then status("Zones","Complete zone quests first");return end
        local currency,price=d.GatePrice(zone)
        if not currency or not price then status("Zones","Zone price unavailable");return end
        if d.Currency(currency)<price+config.Reserve then status("Zones","Insufficient funds after reserve");return end
        local ok,message=request("Zones","Zones_RequestPurchase",zone._id)
        status("Zones",ok==true and "Zone purchase confirmed" or "Server rejected zone purchase",{zone=zone._id,serverMessage=tostring(message or "")})
        if ok~=true then jobs.Zones.nextAt=d.Now()+12 end
    end
    actions.Rebirth=function()
        local next=d.NextRebirth()
        if not next then status("Rebirth","Maximum rebirth reached");return end
        if d.MaxZoneNumber()<next.ZoneNumberRequired then status("Rebirth","Unlock required zone first");return end
        local ok,message=request("Rebirth","Rebirth_Request",next._id)
        status("Rebirth",ok==true and "Rebirth confirmed" or "Server rejected rebirth",{serverMessage=tostring(message or "")})
        if ok~=true then jobs.Rebirth.nextAt=d.Now()+15 end
    end
    local intervals={Farm=0.8,Tap=0.3,Orbs=0.5,Hatch=3,Equip=8,Gifts=2,Ranks=2,Zones=5,Rebirth=8}
    function C.Tick(key)
        local j=jobs[key]
        if not alive or not config[key] or j.busy or d.Now()<j.nextAt then return end
        j.busy=true
        local generation=j.generation
        local ok,problem=xpcall(function()
            if not d.Ready() then status(key,"Waiting for player profile");return end
            actions[key]()
        end,function(err) return tostring(err) end)
        j.busy=false
        j.nextAt=math.max(j.nextAt,d.Now()+intervals[key])
        if not alive or generation~=j.generation then j.status="Disabled";notify();return end
        if not ok then
            j.nextAt=d.Now()+10
            table.insert(C.Report.errors,{job=key,message=tostring(problem),t=d.Now()})
            if #C.Report.errors>40 then table.remove(C.Report.errors,1) end
            status(key,"Error; see report",{error=tostring(problem)})
        end
    end
    function C.Set(key,value)
        assert(jobs[key],"Unknown automation")
        config[key]=value==true
        jobs[key].generation+=1;jobs[key].nextAt=0;jobs[key].pending=nil
        if key=="Farm" then
            if not value then pcall(d.ClearAssigned,assigned) end
            locked=nil;assigned={}
        end
        status(key,value and "Enabled" or "Disabled")
    end
    function C.Stop() for _,key in ipairs(names) do C.Set(key,false) end end
    function C.Destroy()
        if not alive then return end
        C.Stop();alive=false;if d.Destroy then d.Destroy() end
    end
    C.Names=names
    return C
end

end)()
local makeLogo=(function()
local function logo()
    local version="silver-break-20261014"
    local url="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/a28a74d3b5c98f687c165dcefaadfe0a743d280c/assets/devil-logo.png"
    local cached=env.DevilHubSilverLogo
    if env.DevilHubSilverLogoVersion==version and type(cached)=="string"and cached~=""and not cached:match("^https?://")then return cached end
    local file="DevilHub_Silver_20261014.png"
    local signature="\137PNG\r\n\26\n"
    local ok,value=pcall(function()
        assert(type(writefile)=="function","Logo file API unavailable")
        local exists=type(isfile)=="function"and isfile(file)
        if exists and type(readfile)=="function"then
            local readable,data=pcall(readfile,file)
            exists=readable and type(data)=="string"and data:sub(1,8)==signature
        end
        if not exists then
            local data=game:HttpGet(url)
            assert(type(data)=="string"and data:sub(1,8)==signature,"Invalid DEVIL HUB logo response")
            writefile(file,data)
        end
        for _,key in ipairs({"getcustomasset","getsynasset"})do
            local custom=getfenv()[key]
            if type(custom)=="function"then
                local resolved,image=pcall(custom,file)
                if resolved and type(image)=="string"and image~=""and not image:match("^https?://")then return image end
            end
        end
        error("Logo asset API unavailable")
    end)
    if ok then
        env.DevilHubSilverLogo=value;env.DevilHubSilverLogoVersion=version;env.DevilHubLogoError=nil
        return value
    end
    env.DevilHubLogoError=tostring(value)
    -- Do not cache an HTTP URL as a resolved Roblox asset: later calls can retry.
    return url
end
return logo

end)()
local RS=game:GetService("ReplicatedStorage")
local Http=game:GetService("HttpService")
local player=game:GetService("Players").LocalPlayer
local client=RS:WaitForChild("Library",15):WaitForChild("Client",15)
local modules={}
local function module(name)
    if modules[name] then return modules[name] end
    local instance=client:FindFirstChild(name)
    assert(instance and instance:IsA("ModuleScript"),"Missing game module: "..name)
    modules[name]=require(instance)
    return modules[name]
end
local directory
local function dirs()
    if not directory then directory=require(RS.Library.Directory) end
    return directory
end
local config={Farm=false,Tap=false,Orbs=false,Hatch=false,Equip=false,Gifts=false,Ranks=false,Zones=false,Rebirth=false,
    Zone="Current",Class="All",Radius=150,Egg="",HatchCount=1,Reserve=0,Language="TH"}
local api={Config=config}
local window,core,paragraphs,controls={},{},{},{}
window=nil;core=nil
local destroyed,rebuilding=false,false
local connections={}
local function rpcPending() return env.DevilPetSimRPCPending end
local orbQueue,orbCount={},0
local now=os.clock
local function message(text) if api.Info then api.Info:Set(tostring(text),true) end end
local function root()
    local character=player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health>0 and character:FindFirstChild("HumanoidRootPart") or nil
end
local function position(model)
    if model:IsA("BasePart") then return model.Position end
    if model:IsA("Model") then return model:GetPivot().Position end
end
local function activeZone() return config.Zone=="Current" and module("MapCmds").GetCurrentZone() or config.Zone end
local function targetInfo(id,model)
    local r=root();local p=model and model.Parent and position(model)
    if not r or not p then return nil end
    return {id=id,model=model,name=model.Name,distance=(r.Position-p).Magnitude,zone=activeZone(),classSelection=config.Class}
end
local deps={}
deps.Now=now
deps.Save=function() return module("Save").Get() or {} end
deps.Ready=function() return not destroyed and module("Save").Get()~=nil end
deps.CanInvoke=function() return rpcPending()==nil end
deps.Invoke=function(name,...)
    if rpcPending() then return false,"Waiting for previous server request" end
    local packet=table.pack(...)
    local ticket={name=name,started=now()}
    env.DevilPetSimRPCPending=ticket
    task.spawn(function()
        ticket.result=table.pack(pcall(function() return module("Network").Invoke(name,table.unpack(packet,1,packet.n)) end))
        ticket.done=true
        if rpcPending()==ticket then env.DevilPetSimRPCPending=nil end
    end)
    while not ticket.done and now()-ticket.started<12 and not destroyed do task.wait(0.05) end
    if not ticket.done then return false,"Request pending; no duplicate request sent" end
    if not ticket.result[1] then error(ticket.result[2]) end
    return table.unpack(ticket.result,2,ticket.result.n)
end
deps.Fire=function(name,...) module("Network").Fire(name,...) end
deps.Pets=function() return module("PlayerPet").GetByPlayer(player) end
deps.PetOnTarget=function(pet,target) return pet:GetTarget()==target.model end
deps.AssignPet=function(pet,target) pet:SetTarget(target.model) end
deps.ClearAssigned=function(assigned)
    for id,pet in pairs(deps.Pets()) do if assigned[id] then pet:ClearTarget() end end
end
deps.FindTarget=function()
    if not root() then return nil end
    local zone=activeZone()
    if not zone then return nil end
    local instance=module("InstancingCmds")
    local breakables=module("BreakableCmds")
    local pools={}
    local classes=config.Class=="All" and {"Chest","Normal"} or {config.Class}
    if instance.IsInInstance() then
        pools[1]=breakables.AllByInstanceAndClasses(table.unpack(classes))
    else
        if not module("ZoneCmds").Owns(zone) then return nil end
        for _,class in ipairs(classes) do table.insert(pools,breakables.AllByZoneAndClass(zone,class)) end
    end
    local best
    for _,pool in ipairs(pools) do
        for id,model in pairs(pool) do
            local t=targetInfo(id,model)
            if t and t.distance<=config.Radius and (not best or t.distance<best.distance) then best=t end
        end
    end
    return best
end
deps.TargetValid=function(target)
    if target.zone~=activeZone() or target.classSelection~=config.Class then return false end
    local model=module("BreakableCmds").Get(target.id)
    if model~=target.model or not model.Parent then return false end
    local t=targetInfo(target.id,model)
    if not t or t.distance>config.Radius then return false end
    target.distance=t.distance;return true
end
deps.OrbBatch=function(limit)
    local out={}
    for id,created in pairs(orbQueue) do
        if now()-created>30 then orbQueue[id]=nil;orbCount-=1
        elseif #out<limit then out[#out+1]=id end
    end
    return out
end
deps.OrbSent=function(ids) for _,id in ipairs(ids) do if orbQueue[id] then orbQueue[id]=nil;orbCount-=1 end end end
deps.Egg=function(id) return dirs().Eggs[id] end
deps.EquipBest=function() module("PetCmds").EquipBest() end
deps.EquippedSnapshot=function()
    local ids={}
    for id,pet in pairs(module("PetCmds").GetEquipped()) do ids[#ids+1]=tostring(pet.euid or id) end
    table.sort(ids);return table.concat(ids,"|")
end
deps.Gifts=function()
    local out={};for _,gift in pairs(dirs().FreeGifts) do out[#out+1]=gift end
    table.sort(out,function(a,b) return a.WaitTime<b.WaitTime end);return out
end
deps.RankRewards=function(rank)
    for _,entry in pairs(dirs().Ranks) do if entry.RankNumber==rank then return entry.Rewards or {} end end
    local cmd=require(RS.Library.Util.RanksUtil)
    local id=cmd.RankIDFromNumber(rank)
    return id and dirs().Ranks[id] and dirs().Ranks[id].Rewards or {}
end
deps.NextZone=function() local _,zone=module("ZoneCmds").GetNextZone();return zone end
deps.ZoneQuestsReady=function() return module("ZoneCmds").HasCompletedNextZoneQuests() end
deps.GatePrice=function(zone) return zone.Currency,require(RS.Library.Balancing).CalcGatePrice(zone) end
deps.Currency=function(currency) return module("CurrencyCmds").Get(currency) end
deps.NextRebirth=function() return module("RebirthCmds").GetNextRebirth() end
deps.MaxZoneNumber=function() local _,zone=module("ZoneCmds").GetMaxOwnedZone();return zone and zone.ZoneNumber or 0 end
deps.Destroy=function()
    for _,connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
    table.clear(connections);table.clear(orbQueue);orbCount=0
end
local labels={
    Farm={"Pet Farm","ฟาร์มด้วยสัตว์"},Tap={"Auto Tap","ตีเป้าหมายอัตโนมัติ"},Orbs={"Collect Orbs","เก็บออร์บอัตโนมัติ"},
    Hatch={"Open Selected Egg","เปิดไข่ที่เลือก"},Equip={"Equip Best","ใส่สัตว์ดีที่สุด"},
    Gifts={"Free Gifts","รับของขวัญเวลาเล่น"},Ranks={"Rank Rewards","รับรางวัล Rank"},
    Zones={"Buy Next Zone","ซื้อด่านถัดไป"},Rebirth={"Auto Rebirth","รีเบิร์ธอัตโนมัติ"}}
local texts={
    Disabled="ปิดอยู่",Enabled="เปิดแล้ว",Confirmed="ยืนยันสำเร็จ",
    ["Waiting for loaded targets in selected zone"]="รอเป้าหมายในโซนที่เลือกโหลด",
    ["Equip pets first"]="ใส่สัตว์ก่อน",["Pets assigned to locked target"]="ส่งสัตว์ตีเป้าหมายที่ล็อกไว้",
    ["Move closer to target"]="เข้าใกล้เป้าหมายก่อน",["Select an egg first"]="เลือกไข่ก่อน",
    ["Selected egg unavailable"]="ไม่พบไข่ที่เลือก",["Hatch confirmed"]="เกมยืนยันเปิดไข่",
    ["Server rejected hatch"]="เกมปฏิเสธเปิดไข่",["Waiting for new server-created orbs"]="รอออร์บใหม่จากเกม",
    ["Collection requested; inventory not yet confirmed"]="ส่งคำขอเก็บแล้ว ยังไม่ยืนยันกระเป๋า",
    ["Tap requested; damage not yet confirmed"]="ส่งคำขอตีแล้ว ยังไม่ยืนยันดาเมจ",
    ["Equip Best requested; watching equipped pets"]="ส่งคำขอ Equip Best รอการเปลี่ยนสัตว์",
    ["Waiting for player profile"]="รอข้อมูลผู้เล่น",["Error; see report"]="เกิดข้อผิดพลาด ดูรายงาน",
    ["Waiting for server confirmation"]="รอเกมยืนยัน",["No confirmation; waiting before retry"]="ยังไม่ยืนยัน รอก่อนลองใหม่",
    ["Waiting for eligible gifts"]="รอของขวัญครบเวลา",["Waiting for eligible rank rewards"]="รอรางวัล Rank ที่รับได้",
    ["Gift confirmed"]="เกมยืนยันรับของขวัญ",["Server rejected gift"]="เกมปฏิเสธของขวัญ",
    ["No next zone"]="ไม่มีด่านถัดไป",["Complete zone quests first"]="ทำเควสต์ด่านให้ครบก่อน",
    ["Zone price unavailable"]="ไม่พบราคาด่าน",["Insufficient funds after reserve"]="เงินไม่พอหลังหักเงินสำรอง",
    ["Zone purchase confirmed"]="เกมยืนยันซื้อด่าน",["Server rejected zone purchase"]="เกมปฏิเสธซื้อด่าน",
    ["Maximum rebirth reached"]="รีเบิร์ธถึงสูงสุด",["Unlock required zone first"]="เปิดด่านที่ต้องการก่อน",
    ["Rebirth confirmed"]="เกมยืนยันรีเบิร์ธ",["Server rejected rebirth"]="เกมปฏิเสธรีเบิร์ธ"}
local function t(en,th) return config.Language=="TH" and th or en end
local function refresh(report)
    if destroyed then return end
    for name,j in pairs(report.jobs) do
        local widget=paragraphs[name]
        if widget then
            widget:Set((config.Language=="TH" and texts[j.status] or nil or j.status)..
                "\n"..t("Requests: ","คำขอ: ")..j.requests..t(" | Confirmed: "," | ยืนยัน: ")..j.confirmed..
                (j.serverMessage and j.serverMessage~="" and "\n"..j.serverMessage or "")..
                (j.targetName and "\n"..j.targetName or ""),true)
        end
    end
end
function api.SaveReport()
    core.Report.placeId=game.PlaceId;core.Report.userId=player.UserId
    local pending=rpcPending()
    core.Report.pendingRPC=pending and {name=pending.name,age=now()-pending.started} or nil
    core.Report.config=config;core.Report.orbsQueued=orbCount
    local bytes=Http:JSONEncode(core.Report)
    local saved,copied=false,false
    if type(writefile)=="function" then saved=pcall(writefile,"DevilPetSimTestReport.json",bytes) end
    if type(setclipboard)=="function" then copied=pcall(setclipboard,bytes) end
    message(t("Report: ","รายงาน: ")..(saved and "DevilPetSimTestReport.json" or t("file API unavailable","เขียนไฟล์ไม่ได้"))..
        (copied and t(" | copied"," | คัดลอกแล้ว") or ""))
    return bytes
end
function api.Destroy()
    if destroyed then return end
    destroyed=true
    if core then core.Destroy() else deps.Destroy() end
    if window then window:Destroy();window=nil end
    if env.DevilPetSimTest==api then env.DevilPetSimTest=nil end
end
local library
local build
build=function()
    rebuilding=true
    if window then window:Destroy() end
    paragraphs={};controls={}
    local image=makeLogo()
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,Theme="Crimson",Density="Compact",Profile=true,
        Search=false,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,
        Size=UDim2.fromOffset(820,570),ToggleButton={Platform="Both",Icon=image},KeepOnScreen=true,
        ConfigurationSaving={Enabled=false}})
    local bound=window
    if window.Gui then window.Gui.Destroying:Connect(function() if not rebuilding and window==bound then api.Destroy() end end) end
    local function tab(en,th,icon) return window:CreateTab({Name=t(en,th),Icon=icon,Backdrop=false}) end
    local function group(parent,en,th,side,icon) return parent:CreateGroupbox({Name=t(en,th),Side=side,Icon=icon}) end
    local function toggle(parent,name)
        controls[name]=parent:CreateToggle({Name=t(table.unpack(labels[name])),CurrentValue=config[name],Callback=function(value) core.Set(name,value) end})
        paragraphs[name]=parent:CreateParagraph({Name=t("Status","สถานะ"),Content=""})
    end
    local farmTab=tab("Farm","ฟาร์ม","pickaxe")
    local farm=group(farmTab,"Farming","ระบบฟาร์ม","Left","pickaxe")
    toggle(farm,"Farm");toggle(farm,"Tap");toggle(farm,"Orbs");toggle(farm,"Equip")
    local selection=group(farmTab,"Target filters","เลือกเป้าหมาย","Right","filter")
    local zoneOptions={t("Current zone","โซนที่ยืนอยู่")};local zoneIds={[zoneOptions[1]]="Current"};local zoneCurrent=zoneOptions[1]
    local zones={};for id,zone in pairs(dirs().Zones) do zones[#zones+1]={id=id,n=zone.ZoneNumber or 0} end
    table.sort(zones,function(a,b) return a.n<b.n end)
    for _,zone in ipairs(zones) do
        local label=string.format("%03d | %s",zone.n,zone.id)
        zoneOptions[#zoneOptions+1]=label;zoneIds[label]=zone.id
        if config.Zone==zone.id then zoneCurrent=label end
    end
    selection:CreateDropdown({Name=t("Zone","โซน"),Options=zoneOptions,CurrentOption={zoneCurrent},Searchable=true,Callback=function(value)
        value=type(value)=="table" and value[1] or value;config.Zone=zoneIds[value] or "Current"
    end})
    selection:CreateDropdown({Name=t("Target type","ประเภทเป้าหมาย"),Options={"All","Chest","Normal"},CurrentOption={config.Class},Callback=function(value)
        config.Class=type(value)=="table" and value[1] or value
    end})
    selection:CreateSlider({Name=t("Search radius","ระยะหาเป้าหมาย"),Range={25,300},Increment=5,CurrentValue=config.Radius,Callback=function(value) config.Radius=value end})
    selection:CreateParagraph({Name=t("Farm behavior","รูปแบบฟาร์ม"),Content=t(
        "Locks one loaded target until it disappears. Sends your equipped pets using the game controller. Stand in a breakable zone. Auto Tap needs a nearby target.",
        "ล็อกเป้าหมายจนหาย ใช้สัตว์ที่ใส่อยู่ผ่านระบบเกม ให้ยืนในโซนฟาร์ม Auto Tap ต้องอยู่ใกล้เป้าหมาย")})
    local eggTab=tab("Eggs","เปิดไข่","egg")
    local hatch=group(eggTab,"Hatching","ระบบเปิดไข่","Left","egg")
    local eggOptions={t("Select an egg","เลือกไข่")};local eggIds={};local eggCurrent=eggOptions[1];local eggs={}
    for id,egg in pairs(dirs().Eggs) do eggs[#eggs+1]={id=id,n=egg.eggNumber or egg.number or 0} end
    table.sort(eggs,function(a,b) if a.n==b.n then return a.id<b.id end;return a.n<b.n end)
    for _,egg in ipairs(eggs) do
        local label=string.format("%03d | %s",egg.n,egg.id);eggOptions[#eggOptions+1]=label;eggIds[label]=egg.id
        if config.Egg==egg.id then eggCurrent=label end
    end
    hatch:CreateDropdown({Name=t("Egg","ไข่"),Options=eggOptions,CurrentOption={eggCurrent},Searchable=true,Callback=function(value)
        value=type(value)=="table" and value[1] or value;config.Egg=eggIds[value] or ""
    end})
    hatch:CreateSlider({Name=t("Eggs per request","จำนวนไข่ต่อครั้ง"),Range={1,100},Increment=1,CurrentValue=config.HatchCount,Callback=function(value) config.HatchCount=value end})
    toggle(hatch,"Hatch")
    hatch:CreateParagraph({Name=t("Game conditions","เงื่อนไขเกม"),Content=t("Requires an unlocked egg, sufficient currency and a hatch amount allowed by the game. Server rejection appears in status.",
        "ต้องปลดล็อกไข่ มีเงิน และจำนวนเปิดต้องผ่านเงื่อนไขเกม หากเกมปฏิเสธจะแสดงข้อความ")})
    local progressTab=tab("Progress & Rewards","ความคืบหน้า / รางวัล","gift")
    local rewards=group(progressTab,"Rewards","รับรางวัล","Left","gift")
    toggle(rewards,"Gifts");toggle(rewards,"Ranks")
    local progress=group(progressTab,"Progression","ปลดล็อก","Right","flag")
    progress:CreateInput({Name=t("Zone purchase reserve","เงินสำรองสำหรับซื้อด่าน"),CurrentValue=tostring(config.Reserve),PlaceholderText="0",RemoveTextAfterFocusLost=false,Callback=function(value)
        local n=tonumber(value);if n and n>=0 and n<math.huge then config.Reserve=n end
    end})
    toggle(progress,"Zones");toggle(progress,"Rebirth")
    local settings=tab("Settings / Report","ตั้งค่า / รายงาน","settings")
    local diagnostics=group(settings,"Test report","รายงานทดลอง","Left","file-text")
    api.Info=diagnostics:CreateParagraph({Name=t("Trial build","รุ่นทดลอง"),Content="petsim-auto-test-1"})
    diagnostics:CreateButton({Name=t("Copy / Save Report","คัดลอก / บันทึกรายงาน"),Callback=api.SaveReport})
    diagnostics:CreateButton({Name=t("Stop All","หยุดออโต้ทั้งหมด"),Callback=function() core.Stop();task.defer(build) end})
    diagnostics:CreateButton({Name=t("Unload","ปิดสคริปต์"),Callback=api.Destroy})
    diagnostics:CreateParagraph({Name=t("Confirmation counters","ตัวนับผลสำเร็จ"),Content=t(
        "Requests and confirmations are separate. Orb collection, taps and pet assignment do not count as confirmed rewards. No live Roblox test has been performed.",
        "แยกคำขอออกจากผลยืนยัน การส่งสัตว์ ตี และขอเก็บออร์บไม่ถูกนับว่าได้รางวัลแล้ว รุ่นนี้ยังไม่ได้ทดสอบในเกมจริง")})
    local appearance=group(settings,"GUI","รูปแบบ GUI","Right","palette")
    appearance:CreateSlider({Name=t("Width","ความกว้าง"),Range={600,1000},Increment=10,CurrentValue=820,Callback=function(value) window:SetSize(Vector2.new(value,570),true) end})
    appearance:CreateToggle({Name=t("Transparent","โปร่งใส"),CurrentValue=false,Callback=function(value) window:SetTransparent(value) end})
    local discord=tab("Discord","Discord","message-circle")
    local social=group(discord,"DEVIL HUB","DEVIL HUB","Left","message-circle")
    social:CreateImage({Name="DEVIL HUB",Image=image,Height=120,ScaleType="Fit"})
    social:CreateParagraph({Name="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
    social:CreateButton({Name=t("Copy Invite","คัดลอกลิงก์เชิญ"),Callback=function() if type(setclipboard)=="function" then setclipboard("https://discord.gg/ZY7PRcVJe2") end end})
    if window.MinimizeButton then
        local minimize=window.MinimizeButton;local button=Instance.new("TextButton")
        button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
        button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
        button.Text="ไทย / EN";button.TextSize=13;button.Font=Enum.Font.GothamSemibold
        button.TextColor3=Color3.new(1,1,1);button.BackgroundColor3=Color3.fromRGB(45,23,30);button.Parent=minimize.Parent
        local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=button
        button.Activated:Connect(function() config.Language=config.Language=="TH" and "EN" or "TH";task.defer(build) end)
    end
    rebuilding=false;refresh(core.Report)
end
env.DevilPetSimTest=api
local ok,problem=xpcall(function()
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    local run,err=loadstring(source,"DEVIL HUB / OuroFlow");assert(run,err);library=run()
    core=makeCore(config,deps,refresh);api.Core=core
    build()
    connections[#connections+1]=module("Network").Fired("Orbs: Create"):Connect(function(batch)
        if destroyed or type(batch)~="table" then return end
        for _,packet in ipairs(batch) do
            if type(packet)=="table" and (type(packet.id)=="string" or type(packet.id)=="number") then
                if not orbQueue[packet.id] and orbCount<3000 then orbQueue[packet.id]=now();orbCount+=1 end
            end
        end
    end)
    connections[#connections+1]=module("Network").Fired("Orbs: Clear"):Connect(function() table.clear(orbQueue);orbCount=0 end)
    for _,name in ipairs(core.Names) do
        task.spawn(function()
            while not destroyed do core.Tick(name);task.wait(0.15) end
        end)
    end
end,debug.traceback)
if not ok then api.Destroy();error("DEVIL HUB Pet Auto Test: "..tostring(problem),0) end
return api
