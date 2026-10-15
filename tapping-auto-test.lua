-- DEVIL HUB standalone trial for the supplied dump.
assert(game.PlaceId==72858262610964 or game.GameId==10629695169,"Open the map from dump Place 72858262610964")
local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilTappingTest then env.DevilTappingTest.Destroy() end
local makeCore=(function()
return function(config,d,changed)
    local C={Names={"Tap","Hatch","Rebirth","Upgrade","Quests","Gifts","Equip","Enchant"},
        Report={release="tapping-auto-test-1",jobs={},errors={},liveVerified=false}}
    local jobs=C.Report.jobs
    local alive=true
    local intervals={Tap=0,Hatch=1,Rebirth=1,Upgrade=2,Quests=1,Gifts=2,Equip=8,Enchant=.5}
    local tapPending={}
    local sequence=d.SequenceStart or 1000000000
    local function notify() if changed then pcall(changed,C.Report) end end
    local function status(name,text) jobs[name].status=text;notify() end
    for _,name in ipairs(C.Names) do jobs[name]={status="Disabled",requests=0,confirmed=0,rejected=0,nextAt=0,generation=0} end
    local function send(name,service,remote,packet)
        if not alive or not config[name] then return end
        jobs[name].requests+=1
        d.Fire(service,remote,packet)
    end
    local function stopHatch()
        local job=jobs.Hatch
        if not job.ownsAuto then return end
        local ok,err=pcall(d.Fire,"EggService","StopOfflineHatch")
        job.stopError=not ok and tostring(err) or nil
        job.stopRequests=(job.stopRequests or 0)+1
        job.ownsAuto=nil;job.stoppedPending=job.pending~=nil
    end
    local function rpc(name,method,packet,plan)
        if not d.CanInvoke() then status(name,"Waiting for previous request");return end
        local service=({Upgrade="UpgradeService",Quests="QuestService",Gifts="GiftService",Enchant="EnchantService"})[name]
        local job=jobs[name]
        job.rpc=d.Request(service,method,packet)
        job.rpcPlan=plan or {};job.rpcPlan.method=method;job.rpcGeneration=job.generation
        job.requests+=1;status(name,"Waiting for server result")
    end
    local function poll(name)
        local job=jobs[name];local ticket=job.rpc
        if not ticket then return false end
        if not ticket.done then
            status(name,d.Now()-ticket.started>12 and "Request pending; no duplicate sent" or "Waiting for server result")
            return true
        end
        local plan=job.rpcPlan
        job.rpc=nil;job.rpcPlan=nil
        local result=ticket.result
        local accepted=ticket.ok and type(result)=="table" and result.Success==true
        job.result=result;job.reason=not ticket.ok and tostring(ticket.error) or type(result)=="table" and result.Reason or nil
        job.nextAt=d.Now()+(accepted and intervals[name] or 5)
        if accepted then
            job.confirmed+=1
            if name=="Enchant" and plan.method=="Enchant" then
                job.enchantPending=type(result.Pending)=="table" and table.clone(result.Pending) or nil
                if job.enchantPending then job.enchantPending.PetId=job.enchantPending.PetId or plan.pet end
                job.rolls=(job.rolls or 0)+1
            elseif name=="Enchant" and plan.method=="Resolve" then
                job.enchantPending=nil
                if plan.wanted and result.Enchant==plan.enchant then
                    job.matches=(job.matches or 0)+1;config.Enchant=false
                end
            end
        else
            job.rejected+=1
            if name=="Enchant" and plan.method=="Resolve" and job.reason=="PetChangedChooseKeep" then job.keepPrevious=true end
            if not ticket.ok then
                config[name]=false;job.uncertain=true
            elseif name=="Enchant" and plan.method=="Enchant" and job.reason~="RateLimited" then
                config.Enchant=false
            end
        end
        if not config[name] then status(name,accepted and name=="Enchant" and plan.wanted and "Wanted enchant confirmed" or "Disabled")
        else status(name,accepted and "Server accepted" or "Server rejected request") end
        return true
    end
    local actions={}
    actions.Tap=function()
        local job=jobs.Tap
        local blocked=d.TapBlocked()
        if blocked then job.nextAt=d.Now()+.5;status("Tap",blocked);return end
        local rate=math.clamp(tonumber(config.CPS) or 40,1,100)
        local count=math.clamp(math.floor((d.Now()-job.nextAt)*rate)+1,1,4)
        job.nextAt=math.max(job.nextAt,d.Now()-.05)+count/rate
        for _=1,count do
            sequence+=1
            tapPending[sequence]=d.Now()
            send("Tap","TapService","TapRequested",{Auto=false,ClientSequence=sequence,Source="button_hold"})
        end
        job.requestedCPS=rate
        for id,at in pairs(tapPending) do if d.Now()-at>5 then tapPending[id]=nil;job.unanswered=(job.unanswered or 0)+1 end end
        status("Tap","Sending taps; counting server replies")
    end
    actions.Hatch=function()
        local job=jobs.Hatch
        local plan,why=d.HatchPlan(config)
        if not plan then status("Hatch",why);return end
        sequence+=1
        job.pending={sequence=sequence,egg=plan.egg,at=d.Now(),count=plan.count}
        job.ownsAuto=true;job.stoppedPending=nil
        job.egg=plan.egg;job.count=plan.count;job.price=plan.price;job.reason=nil
        send("Hatch","EggService","EggHatchRequested",{Egg=plan.egg,Count=plan.count,Auto=true,Seq=sequence})
        status("Hatch","Waiting for server result")
    end
    actions.Rebirth=function()
        local plan,why=d.RebirthPlan(config)
        if not plan then status("Rebirth",why);return end
        jobs.Rebirth.pending={index=plan.index,at=d.Now()}
        jobs.Rebirth.index=plan.index
        send("Rebirth","RebirthService","RebirthRequested",{Index=plan.index})
        status("Rebirth","Waiting for server result")
    end
    actions.Upgrade=function()
        local plan,why=d.UpgradePlan(config)
        if not plan then status("Upgrade",why);return end
        jobs.Upgrade.target=plan.name
        rpc("Upgrade","Purchase",{Name=plan.name})
    end
    actions.Quests=function()
        local id=d.Quest()
        if not id then status("Quests","Waiting for completed quests");return end
        jobs.Quests.target=id;rpc("Quests","ClaimQuest",{Quest=id})
    end
    actions.Gifts=function()
        local name=d.Gift(config)
        if not name then status("Gifts","Select an owned gift");return end
        rpc("Gifts","OpenGift",{Gift=name,Amount=1})
    end
    actions.Equip=function()
        jobs.Equip.pending={at=d.Now()}
        send("Equip","PetService","PetActionRequested",{Action="EquipBest",Mode="Clicks"})
        status("Equip","Waiting for server result")
    end
    actions.Enchant=function()
        local job=jobs.Enchant
        local pending=job.enchantPending
        if pending then
            if pending.PetId and pending.PetId~=config.EnchantPet then status("Enchant","Finish pending enchant on previous pet");return end
            assert(type(pending.Token)=="string","Missing native enchant token")
            local wanted=not job.keepPrevious and config.EnchantFilters[pending.Enchant]==true
            rpc("Enchant","Resolve",{Token=pending.Token,UseNew=wanted},{enchant=pending.Enchant,wanted=wanted})
            return
        end
        local plan,why=d.EnchantPlan(config)
        if not plan then
            if why=="Selected pet already has wanted enchant" then config.Enchant=false end
            status("Enchant",why);return
        end
        job.keepPrevious=nil
        rpc("Enchant","Enchant",{PetId=plan.id,Slot=config.EnchantSlot,RequestId=d.GUID()},{pet=plan.id})
    end
    function C.Tick(name)
        local job=assert(jobs[name])
        if not alive then return end
        if poll(name) then return end
        if not config[name] then return end
        if job.pending then
            if d.Now()-job.pending.at>12 then
                config[name]=false;job.uncertain=true
                if name=="Hatch" then stopHatch() end
                status(name,"No confirmation; stopped to avoid duplicate purchases")
            end
            return
        end
        if d.Now()<job.nextAt then return end
        if (name=="Hatch" and jobs.Rebirth.pending) or (name=="Rebirth" and jobs.Hatch.pending) then
            status(name,"Waiting for other coin purchase");return
        end
        if name~="Tap" then job.nextAt=d.Now()+intervals[name] end
        local ok,problem=xpcall(function()
            if not d.Data() then status(name,"Waiting for player data");return end
            actions[name]()
        end,function(err)return tostring(err)end)
        if not ok then
            job.nextAt=d.Now()+5;job.error=problem;status(name,"Error; save report")
            table.insert(C.Report.errors,{job=name,message=problem,t=d.Now()})
            if #C.Report.errors>30 then table.remove(C.Report.errors,1) end
        end
    end
    function C.Receive(name,result)
        if not alive or type(result)~="table" then return end
        local job=jobs[name]
        if name=="Tap" then
            local id=result.ClientSequence
            if not id or not tapPending[id] then return end
            tapPending[id]=nil
            if type(result.Amount)=="number" and result.Amount>0 then
                job.confirmed+=1;job.income=(job.income or 0)+result.Amount
            else job.rejected+=1 end
            notify();return
        end
        local pending=job.pending
        if not pending then return end
        if name=="Hatch" and ((result.Seq~=nil and result.Seq~=pending.sequence) or result.Egg~=pending.egg or result.Forced==true) then return end
        if name=="Rebirth" and result.Index~=nil and result.Index~=pending.index then return end
        if name=="Equip" and result.Action~="EquipBest" then return end
        if name=="Hatch" and not config.Hatch and job.stoppedPending then job.ownsAuto=true;stopHatch() end
        job.pending=nil;job.result=result;job.reason=result.Error or result.Reason
        if name=="Hatch" then job.correlation=result.Seq~=nil and "SequenceMatched" or "UnsequencedSameEgg" end
        if result.Success==true then
            job.confirmed+=1;job.nextAt=d.Now()+(name=="Hatch" and config.HatchDelay or intervals[name])
        else
            job.rejected+=1
            job.nextAt=d.Now()+((job.reason=="RateLimited") and 2 or 8)
        end
        if config[name] then status(name,result.Success==true and "Server accepted" or "Server rejected request") else notify() end
    end
    function C.Set(name,value)
        assert(jobs[name],"Unknown automation")
        config[name]=value==true;jobs[name].generation+=1;jobs[name].nextAt=d.Now()
        if name=="Hatch" and not config.Hatch then stopHatch() end
        status(name,value and "Enabled" or "Disabled")
    end
    function C.Stop()
        for _,name in ipairs(C.Names) do C.Set(name,false) end
        config.InfiniteJump=false;notify()
    end
    function C.Destroy() C.Stop();alive=false;table.clear(tapPending) end
    return C
end

end)()
local makeAdapter=(function()
return function(config,d)
    local A={Data=d.Data,Now=d.Now,Fire=d.Fire,Request=d.Request,CanInvoke=d.CanInvoke,GUID=d.GUID,SequenceStart=d.SequenceStart}
    local function get(path) return d.Module(path) end
    function A.Eggs() return get("Shared.Pets.LaunchEggConfig") end
    function A.Gifts() return get("Shared.Items.GiftConfig").Pools end
    function A.Enchants() return get("Shared.Pets.EnchantConfig").Enchants end
    function A.TapBlocked()
        for _,key in ipairs({"MiningActive","AtDigsite","DiggingActive","ColosseumActive"}) do
            if d.Attribute(key)==true then return "Finish current minigame before tapping" end
        end
        if get("Shared.Progression.OnboardingFlow").IsPending(d.Data()) then return "Finish game introduction first" end
    end
    function A.HatchPlan(c)
        if c.Egg=="" then return nil,"Select an egg" end
        if d.NativeHatch() then return nil,"Stop game auto hatch first" end
        local data=d.Data()
        local egg=A.Eggs()[c.Egg]
        if not egg then return nil,"Selected egg unavailable" end
        if egg.Island and not (data.Progression.UnlockedIslands or {})[egg.Island] then return nil,"IslandLocked" end
        local perks=get("Shared.Monetization.GamepassPerks")
        local boosts=get("Shared.Items.BoostFormula")
        local max=(perks.Has(data,"x8Egg") or boosts.HasType(data,"OctoHatch")) and 8 or 3
        local total=0;for _ in pairs(data.Pets.Owned or {}) do total+=1 end
        local free=(data.Pets.StorageLimit or 0)-total
        local requested=tonumber(c.HatchCount) or 1
        local pricing=get("Shared.Pets.EggPricing")
        for _,count in ipairs({8,3,1}) do
            if count<=requested and count<=max and count<=free then
                local price=pricing.GetTotal(data,c.Egg,egg.Price,count)
                if type(price)=="number" and price>=0 and price<math.huge and price<=(data.Currencies.Coins or 0)-c.ReserveCoins then
                    return {egg=c.Egg,count=count,price=price}
                end
            end
        end
        return nil,free<1 and "StorageFull" or "Not enough coins for selected egg"
    end
    function A.RebirthPlan(c)
        local data=d.Data()
        if (data.Settings or {}).AutoRebirthSlot and data.Settings.AutoRebirthSlot>0 then return nil,"Stop game auto rebirth first" end
        local buttons=get("Shared.Progression.RebirthButtonConfig")
        local formula=get("Shared.Progression.RebirthConfig")
        local max=buttons.GetOptionCount(data.Upgrades.RebirthButtons or 0,data.Progression.World or "Main")
        for index=max,1,-1 do
            local amount=formula.GetAmountFromIndex(index)
            local price=formula.GetPrice(amount,data.Statistics.Rebirths or 0)
            if type(price)=="number" and price>0 and price<=data.Currencies.Coins-c.ReserveCoins then return {index=index,price=price} end
        end
        return nil,"Not enough coins to rebirth"
    end
    function A.UpgradePlan(c)
        local data=d.Data();local cfg=get("Shared.Progression.UpgradeConfig")
        local best
        for name,selected in pairs(c.Upgrades) do
            local def=selected and cfg.Get(name)
            if def and name~="Teleport" and not def.SkillTreeNode then
                local level=math.floor(data.Upgrades[name] or 0)
                local zone=cfg.GetRetainedRequirement(name,level)
                local price=cfg.GetPrice(name,level+1)
                if level<def.LaunchTotal and (not zone or (data.Progression.UnlockedZones or {})[zone]) and type(price)=="number"
                    and price<=data.Currencies.Gems-c.ReserveGems and (not best or price<best.price) then best={name=name,price=price} end
            end
        end
        return best,best and nil or "No affordable selected upgrades"
    end
    function A.Quest()
        local data=d.Data();local defs=get("Shared.Quests.QuestConfig").Definitions
        local visibility=get("Shared.Quests.QuestVisibility")
        local ids={}
        for id,state in pairs(data.Quests or {}) do
            local def=defs[id]
            if type(state)=="table" and def and state.Claimed~=true and visibility.IsShown(data,id)
                and (state.Completed==true or (state.Amount or 0)>=(def.Goal or math.huge)) then ids[#ids+1]=id end
        end
        table.sort(ids);return ids[1]
    end
    function A.Gift(c)
        local data=d.Data()
        if c.Gift~="" and A.Gifts()[c.Gift] and ((data.Items or {}).Owned or {})[c.Gift] and data.Items.Owned[c.Gift]>=1 then return c.Gift end
    end
    function A.EnchantPlan(c)
        if c.EnchantPet=="" then return nil,"Select a pet" end
        if not next(c.EnchantFilters) then return nil,"Select wanted enchants" end
        local data=d.Data();local pet=data.Pets.Owned[c.EnchantPet]
        if not pet then return nil,"Selected pet unavailable" end
        if d.Attribute("EnchantAutoPet") then return nil,"Stop game auto enchant first" end
        if (data.Enchanting or {}).Pending then return nil,"Finish pending enchant in game" end
        local cfg=get("Shared.Pets.EnchantConfig")
        if c.EnchantSlot>cfg.GetSlotCount(pet) then return nil,"InvalidSlot" end
        local current=c.EnchantSlot==2 and pet.Enchant2 or pet.Enchant
        if current and c.EnchantFilters[current] then return nil,"Selected pet already has wanted enchant" end
        if current and not c.ReplaceEnchant then return nil,"Enable replace existing enchant first" end
        local price=cfg.GetRollPrice(pet)
        if type(price)~="number" or price>data.Currencies.Gems-c.ReserveGems then return nil,"Not enough gems for enchant" end
        if pet.Locked or pet.Reserved or pet.Frozen then return nil,"Selected pet locked or reserved" end
        return {id=c.EnchantPet,price=price}
    end
    return A
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
local player=game:GetService("Players").LocalPlayer
local Http=game:GetService("HttpService")
local runService=game:GetService("RunService")
local inputs=game:GetService("UserInputService")
local config={Tap=false,Hatch=false,Rebirth=false,Upgrade=false,Quests=false,Gifts=false,Equip=false,Enchant=false,
    InfiniteJump=false,CPS=40,Egg="",HatchCount=1,HatchDelay=2,Gift="",ReserveCoins=0,ReserveGems=0,
    Upgrades={ClickMultiplier=true,HatchSpeed=true,CriticalChance=true,AutoClickerSpeed=true},
    EnchantPet="",EnchantSlot=1,EnchantFilters={},ReplaceEnchant=false,Language="TH"}
local api={Config=config}
local alive,rebuilding=true,false
local core,adapter,window,replica
local connections,controls,paragraphs={},{},{}
local cache={}
local now=os.clock
local function module(path)
    if cache[path] then return cache[path] end
    local item=RS
    for name in path:gmatch("[^.]+") do item=item and item:FindFirstChild(name) end
    assert(item and item:IsA("ModuleScript"),"Missing game module: "..path)
    cache[path]=require(item);return cache[path]
end
local function remote(service,folder,name)
    local services=RS:FindFirstChild("RemoteServices")
    local host=services and services:FindFirstChild(service)
    local group=host and host:FindFirstChild(folder)
    local item=group and group:FindFirstChild(name)
    assert(item,"Missing remote: "..service.."/"..name)
    return item
end
local deps={
    Data=function() return replica and replica.Data end,
    Module=module,Now=now,Attribute=function(name)return player:GetAttribute(name)end,
    GUID=function()return Http:GenerateGUID(false)end,
    CanInvoke=function()return env.DevilTappingRPCPending==nil end,
    SequenceStart=math.floor(now()*1000)+1000000000,
    Fire=function(service,name,packet)
        local endpoint=remote(service,"RE",name)
        if packet==nil then endpoint:FireServer()else endpoint:FireServer(packet)end
    end,
    NativeHatch=function()return module("Controllers.Pets.EggController"):GetAutoHatchEgg()~=nil end,
    Request=function(service,name,packet)
        assert(not env.DevilTappingRPCPending,"Previous request still pending")
        local endpoint=remote(service,"RF",name)
        local ticket={service=service,method=name,started=now()}
        env.DevilTappingRPCPending=ticket
        task.spawn(function()
            local ok,result=pcall(endpoint.InvokeServer,endpoint,packet)
            ticket.ok=ok;ticket.done=true
            if ok then ticket.result=result else ticket.error=tostring(result) end
            if env.DevilTappingRPCPending==ticket then env.DevilTappingRPCPending=nil end
        end)
        return ticket
    end,
}
local labels={
    Tap={"Fast Auto Click","ออโต้คลิกเร็ว"},Hatch={"Auto Open Egg","เปิดไข่อัตโนมัติ"},
    Rebirth={"Auto Rebirth","รีเบิร์ทอัตโนมัติ"},Upgrade={"Auto Buy Upgrades","ซื้ออัปเกรดอัตโนมัติ"},
    Quests={"Auto Claim Quests","รับเควสต์ที่สำเร็จ"},Gifts={"Auto Open Gift","เปิดของขวัญอัตโนมัติ"},
    Equip={"Auto Equip Best","ใส่สัตว์ที่ดีที่สุด"},Enchant={"Auto Enchant","สุ่ม Enchant อัตโนมัติ"},
}
local texts={
    Disabled="ปิดอยู่",Enabled="เปิดแล้ว",IslandLocked="ยังไม่ปลดล็อกเกาะ",StorageFull="กระเป๋าสัตว์เต็ม",
    ["Sending taps; counting server replies"]="กำลังคลิกและนับผลตอบกลับ",
    ["Waiting for server result"]="รอผลจากเกม",["Server accepted"]="เกมตอบรับคำขอ",
    ["Waiting for other coin purchase"]="รอรายการใช้เงินอีกระบบเสร็จ",
    ["Server rejected request"]="เกมปฏิเสธ ดูเหตุผลด้านล่าง",["Waiting for previous request"]="รอคำขอก่อนหน้า",
    ["Request pending; no duplicate sent"]="เกมยังไม่ตอบ รอโดยไม่ส่งซ้ำ",
    ["Waiting for player data"]="รอข้อมูลผู้เล่น",["Select an egg"]="เลือกไข่ก่อน",
    ["Select an owned gift"]="เลือกของขวัญที่มีในกระเป๋า",["Select a pet"]="เลือกสัตว์ก่อน",
    ["Select wanted enchants"]="เลือกผล Enchant ที่ต้องการก่อน",
    ["Selected pet already has wanted enchant"]="สัตว์มี Enchant ที่เลือกแล้ว หยุดออโต้",
    ["Enable replace existing enchant first"]="เปิดอนุญาตเปลี่ยน Enchant เดิมก่อน",
    ["Wanted enchant confirmed"]="เกมยืนยัน Enchant ที่ต้องการแล้ว",
    ["Finish pending enchant in game"]="มีผล Enchant ค้างอยู่ ให้จบรายการนั้นก่อน",
    ["Finish pending enchant on previous pet"]="มีผล Enchant ของสัตว์ก่อนหน้าค้างอยู่",
    ["No affordable selected upgrades"]="ยังไม่มีอัปเกรดที่เลือกและเงินพอ",
    ["Not enough coins to rebirth"]="เงินยังไม่พอรีเบิร์ท",
    ["Not enough coins for selected egg"]="เงินยังไม่พอเปิดไข่",
    ["Not enough gems for enchant"]="เพชรยังไม่พอ Enchant",
    ["Waiting for completed quests"]="รอเควสต์สำเร็จ",
    ["Stop game auto hatch first"]="ปิดออโต้เปิดไข่ของเกมก่อน",
    ["Stop game auto rebirth first"]="ปิดออโต้รีเบิร์ทของเกมก่อน",
    ["Stop game auto enchant first"]="ปิดออโต้ Enchant ของเกมก่อน",
    ["Finish current minigame before tapping"]="รอมินิเกมปัจจุบันจบก่อนคลิก",
    ["Finish game introduction first"]="ทำขั้นตอนเริ่มเกมให้จบก่อน",
    ["No confirmation; stopped to avoid duplicate purchases"]="เกมไม่ยืนยัน หยุดไว้เพื่อไม่ให้ซื้อซ้ำ",
    ["Error; save report"]="เกิดข้อผิดพลาด กรุณาบันทึกรายงาน",
    ["Selected pet unavailable"]="ไม่พบสัตว์ที่เลือก",["Selected egg unavailable"]="ไม่พบไข่ที่เลือก",
    ["Selected pet locked or reserved"]="สัตว์ถูกล็อกหรือกำลังใช้งาน",InvalidSlot="สัตว์ใช้ช่องนี้ไม่ได้",
}
local function t(en,th)return config.Language=="TH" and th or en end
local refreshAt=0
local function refresh(report,force)
    if not alive then return end
    if not force and now()<refreshAt then return end
    refreshAt=now()+.2
    for name,label in pairs(paragraphs) do
        local job=report.jobs[name]
        local text=config.Language=="TH" and texts[job.status] or nil
        label:Set((text or job.status).."\n"..t("Requests: ","ส่งคำขอ: ")..job.requests..
            t(" | Server accepted: "," | เกมตอบรับ: ")..job.confirmed..
            t(" | Rejected: "," | ปฏิเสธ: ")..job.rejected..
            (job.reason and "\n"..tostring(job.reason) or "")..(job.error and "\n"..job.error or ""),true)
        if controls[name] then controls[name]:Set(config[name],true) end
    end
    if controls.InfiniteJump then controls.InfiniteJump:Set(config.InfiniteJump,true) end
end
local function clean(value,depth)
    if depth>7 then return "[depth limit]" end
    local kind=type(value)
    if kind=="number" then return value==value and math.abs(value)~=math.huge and value or tostring(value) end
    if kind=="string" or kind=="boolean" or kind=="nil" then return value end
    if kind~="table" then return tostring(value) end
    local out,count={},0
    for key,item in pairs(value) do
        count+=1;if count>128 then out._truncated=true;break end
        out[tostring(key)]=clean(item,depth+1)
    end
    return out
end
function api.SaveReport()
    core.Report.placeId=game.PlaceId;core.Report.userId=player.UserId;core.Report.config=config
    core.Report.pendingRPC=env.DevilTappingRPCPending
    local bytes=Http:JSONEncode(clean(core.Report,0))
    if type(writefile)=="function" then pcall(writefile,"DevilTappingTestReport.json",bytes) end
    if type(setclipboard)=="function" then pcall(setclipboard,bytes) end
    if api.Info then api.Info:Set(t("Report copied / saved","คัดลอก / บันทึกรายงานแล้ว"),true) end
    return bytes
end
function api.Destroy()
    if not alive then return end
    alive=false
    if core then core.Destroy() end
    for _,link in ipairs(connections) do pcall(link.Disconnect,link) end
    table.clear(connections)
    if window then window:Destroy();window=nil end
    if env.DevilTappingTest==api then env.DevilTappingTest=nil end
end
local function single(value)return type(value)=="table" and value[1] or value end
local function selection(value)
    local out={}
    if type(value)=="table" then
        for key,item in pairs(value) do
            if type(key)=="number" and type(item)=="string" then out[item]=true
            elseif item==true and type(key)=="string" then out[key]=true end
        end
    elseif type(value)=="string" then out[value]=true end
    return out
end
local function keys(map)local out={};for name in pairs(map or {})do out[#out+1]=name end;table.sort(out);return out end
local function selected(map)local out={};for name,value in pairs(map)do if value then out[#out+1]=name end end;table.sort(out);return out end
local build
function api.RefreshPetList()
    if not controls.EnchantPet then return end
    local placeholder=t("Select a pet","เลือกสัตว์")
    local options={};api.PetIds={}
    local data=deps.Data()
    if data then
        for id,pet in pairs(data.Pets.Owned or {}) do
            local label=tostring(pet.Name or id).." ["..tostring(pet.Tier or "Normal").."] | "..id
            options[#options+1]=label;api.PetIds[label]=id
        end
    end
    table.sort(options);table.insert(options,1,placeholder)
    local current=placeholder
    for label,id in pairs(api.PetIds) do if id==config.EnchantPet then current=label;break end end
    controls.EnchantPet:Refresh(options,true,true);controls.EnchantPet:Set(current,true)
end
local library
build=function()
    rebuilding=true
    if window then window:Destroy() end
    controls={};paragraphs={}
    local logo=makeLogo()
    window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme="Crimson",Density="Compact",Profile=true,
        Search=false,Home=false,Loading=false,Backdrop=false,Disclaimer=false,UnsupportedExecutor=false,
        Size=UDim2.fromOffset(850,590),KeepOnScreen=true,ToggleButton={Platform="Both",Icon=logo},
        ConfigurationSaving={Enabled=false}})
    local bound=window
    if window.Gui then window.Gui.Destroying:Connect(function()if not rebuilding and window==bound then api.Destroy()end end)end
    local function tab(en,th,icon)return window:CreateTab({Name=t(en,th),Icon=icon})end
    local function group(parent,en,th,side,icon)return parent:CreateGroupbox({Name=t(en,th),Side=side,Icon=icon})end
    local function toggle(parent,name)
        controls[name]=parent:CreateToggle({Name=t(table.unpack(labels[name])),CurrentValue=config[name],Callback=function(value)core.Set(name,value)end})
        paragraphs[name]=parent:CreateParagraph({Name=t("Status","สถานะ"),Content=""})
    end
    local farm=tab("Click / Player","คลิก / ผู้เล่น","mouse-pointer-click")
    local taps=group(farm,"Fast clicking","ออโต้คลิกเร็ว","Left","mouse-pointer-click")
    toggle(taps,"Tap")
    taps:CreateSlider({Name=t("Requested clicks / second","จำนวนคลิกที่ส่งต่อวินาที"),Range={1,100},Increment=1,CurrentValue=config.CPS,Callback=function(value)config.CPS=value end})
    taps:CreateParagraph({Name=t("Real results","ผลจริงจากเกม"),Content=t(
        "Counts matching TapResult replies separately from sent requests. The server may count fewer taps than the selected rate.",
        "แยกจำนวนที่ส่งกับผล TapResult ที่ตรงคำขอ เกมอาจนับคลิกให้น้อยกว่าความเร็วที่ตั้ง")})
    toggle(taps,"Equip")
    local movement=group(farm,"Player","ผู้เล่น","Right","person-standing")
    controls.InfiniteJump=movement:CreateToggle({Name=t("Infinite Jump","กระโดดไม่จำกัด"),CurrentValue=config.InfiniteJump,Callback=function(value)config.InfiniteJump=value==true end})
    movement:CreateParagraph({Name=t("Jump control","วิธีกระโดด"),Content=t("Press the normal jump button again in midair.","กดปุ่มกระโดดของเกมซ้ำกลางอากาศได้ ใช้ได้ทั้งมือถือและคอมพิวเตอร์")})
    local eggs=tab("Eggs","เปิดไข่","egg")
    local hatch=group(eggs,"Auto hatching","เปิดไข่อัตโนมัติ","Left","egg")
    local eggOptions=keys(adapter.Eggs());table.insert(eggOptions,1,t("Select an egg","เลือกไข่"))
    controls.Egg=hatch:CreateDropdown({Name=t("Egg","ไข่"),Options=eggOptions,CurrentOption={config.Egg~="" and config.Egg or eggOptions[1]},Searchable=true,Callback=function(value)
        value=single(value);config.Egg=adapter.Eggs()[value] and value or ""
    end})
    hatch:CreateDropdown({Name=t("Eggs per request","จำนวนไข่ต่อครั้ง"),Options={"1","3","8"},CurrentOption={tostring(config.HatchCount)},Callback=function(value)config.HatchCount=tonumber(single(value))or 1 end})
    hatch:CreateSlider({Name=t("Delay after confirmation","เว้นช่วงหลังเกมยืนยัน"),Range={.5,5},Increment=.1,CurrentValue=config.HatchDelay,Callback=function(value)config.HatchDelay=value end})
    toggle(hatch,"Hatch")
    local hatchInfo=group(eggs,"Hatch results","ผลเปิดไข่","Right","info")
    hatchInfo:CreateParagraph({Name=t("Current position","เปิดจากตำแหน่งปัจจุบัน"),Content=t(
        "Requests Auto hatching without moving your character. Server TooFar / IslandLocked / RateLimited results are shown. Eight eggs require native entitlement.",
        "ส่งเปิดไข่โหมด Auto จากตำแหน่งที่อยู่ แสดง TooFar / IslandLocked / RateLimited ตามเกม จำนวน 8 ฟองใช้สิทธิ์ตามเกม หากเกมไม่ตอบจะหยุดเพื่อไม่ซื้อซ้ำ")})
    local progressTab=tab("Progress / Rewards","พัฒนา / รางวัล","gift")
    local progress=group(progressTab,"Progression","พัฒนาตัวละคร","Left","trending-up")
    toggle(progress,"Rebirth");toggle(progress,"Upgrade")
    progress:CreateDropdown({Name=t("Selected upgrades","อัปเกรดที่ซื้อ"),Options={"ClickMultiplier","HatchSpeed","CriticalChance","AutoClickerSpeed"},
        CurrentOption=selected(config.Upgrades),MultipleOptions=true,Callback=function(value)config.Upgrades=selection(value)end})
    for _,name in ipairs({"Coins","Gems"})do
        progress:CreateInput({Name=t(name.." reserve",name=="Coins" and "เงินสำรอง" or "เพชรสำรอง"),CurrentValue=tostring(config["Reserve"..name]),RemoveTextAfterFocusLost=false,Callback=function(value)
            local n=tonumber(value);if n and n>=0 and n<math.huge then config["Reserve"..name]=n end
        end})
    end
    local rewards=group(progressTab,"Rewards","รับรางวัล","Right","gift")
    toggle(rewards,"Quests")
    local gifts=keys(adapter.Gifts());table.insert(gifts,1,t("Select a gift","เลือกของขวัญ"))
    rewards:CreateDropdown({Name=t("Gift","ของขวัญ"),Options=gifts,CurrentOption={config.Gift~="" and config.Gift or gifts[1]},Callback=function(value)
        value=single(value);config.Gift=adapter.Gifts()[value] and value or ""
    end})
    toggle(rewards,"Gifts")
    local enchantTab=tab("Enchant","Enchant","sparkles")
    local enchant=group(enchantTab,"Selected pet","เลือกสัตว์และผลลัพธ์","Left","paw-print")
    controls.EnchantPet=enchant:CreateDropdown({Name=t("Pet","สัตว์"),Options={t("Select a pet","เลือกสัตว์")},CurrentOption={t("Select a pet","เลือกสัตว์")},Searchable=true,Callback=function(value)
        config.EnchantPet=api.PetIds[single(value)]or ""
    end})
    enchant:CreateButton({Name=t("Refresh Pets","รีเฟรชรายชื่อสัตว์"),Callback=api.RefreshPetList})
    enchant:CreateDropdown({Name=t("Slot","ช่อง Enchant"),Options={"1","2"},CurrentOption={tostring(config.EnchantSlot)},Callback=function(value)config.EnchantSlot=tonumber(single(value))or 1 end})
    local filters={}
    for name in pairs(adapter.Enchants())do
        if module("Shared.Pets.EnchantConfig").IsFilterable(name)then filters[#filters+1]=name end
    end
    table.sort(filters)
    enchant:CreateDropdown({Name=t("Wanted results","ผลที่ต้องการ"),Options=filters,CurrentOption=selected(config.EnchantFilters),MultipleOptions=true,Searchable=true,Callback=function(value)config.EnchantFilters=selection(value)end})
    enchant:CreateToggle({Name=t("Allow replacing existing enchant","อนุญาตเปลี่ยน Enchant เดิม"),CurrentValue=config.ReplaceEnchant,Callback=function(value)config.ReplaceEnchant=value==true end})
    toggle(enchant,"Enchant")
    local enchantInfo=group(enchantTab,"Roll behavior","รูปแบบการสุ่ม","Right","info")
    enchantInfo:CreateParagraph({Name=t("Uses gems","ใช้เพชรของเกม"),Content=t(
        "Rolls one request at a time. Applies only selected results; unwanted results keep the previous enchant. Stops after a matching result is confirmed. Stand at the native enchant machine if the server requires it.",
        "สุ่มครั้งละคำขอ ใช้เฉพาะผลที่เลือก ผลอื่นคง Enchant เดิม หยุดเมื่อเกมยืนยันผลที่ต้องการ หากเกมกำหนดระยะให้ยืนที่เครื่อง Enchant ใช้เพชรจริงตามราคาเกม")})
    local settings=tab("Settings / Report","ตั้งค่า / รายงาน","settings")
    local diagnostics=group(settings,"Trial controls","ตัวควบคุมรุ่นทดลอง","Left","file-text")
    api.Info=diagnostics:CreateParagraph({Name=t("Build","รุ่น"),Content="tapping-auto-test-1"})
    diagnostics:CreateButton({Name=t("Copy / Save Report","คัดลอก / บันทึกรายงาน"),Callback=api.SaveReport})
    diagnostics:CreateButton({Name=t("Stop All","หยุดทั้งหมด"),Callback=function()core.Stop();task.defer(build)end})
    diagnostics:CreateButton({Name=t("Unload","ปิดสคริปต์"),Callback=api.Destroy})
    local appearance=group(settings,"GUI","ปรับ GUI","Right","palette")
    appearance:CreateSlider({Name=t("Width","ความกว้าง"),Range={600,1000},Increment=10,CurrentValue=850,Callback=function(value)window:SetSize(Vector2.new(value,590),true)end})
    appearance:CreateToggle({Name=t("Transparent","โปร่งใส"),CurrentValue=false,Callback=function(value)window:SetTransparent(value)end})
    local discord=tab("Discord","Discord","message-circle")
    local social=group(discord,"DEVIL HUB","DEVIL HUB","Left","message-circle")
    social:CreateImage({Name="DEVIL HUB",Image=logo,Height=120,ScaleType="Fit"})
    social:CreateParagraph({Name="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
    social:CreateButton({Name=t("Copy Invite","คัดลอกลิงก์เชิญ"),Callback=function()if type(setclipboard)=="function"then setclipboard("https://discord.gg/ZY7PRcVJe2")end end})
    if window.MinimizeButton then
        local minimize=window.MinimizeButton
        local button=Instance.new("TextButton");button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
        button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
        button.Text="ไทย / EN";button.TextSize=13;button.Font=Enum.Font.GothamSemibold
        button.TextColor3=Color3.new(1,1,1);button.BackgroundColor3=Color3.fromRGB(45,23,30);button.Parent=minimize.Parent
        local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=button
        button.Activated:Connect(function()config.Language=config.Language=="TH" and "EN"or "TH";task.defer(build)end)
    end
    api.RefreshPetList()
    rebuilding=false;refresh(core.Report,true)
end
env.DevilTappingTest=api
local ok,problem=xpcall(function()
    adapter=makeAdapter(config,deps)
    core=makeCore(config,adapter,refresh);api.Core=core
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    library=assert(loadstring(source,"DEVIL HUB / OuroFlow"))()
    build()
    for _,entry in ipairs({{"Tap","TapService","TapResult"},{"Hatch","EggService","EggHatchResult"},{"Rebirth","RebirthService","RebirthResult"},{"Equip","PetService","PetActionResult"}})do
        local name=entry[1]
        connections[#connections+1]=remote(entry[2],"RE",entry[3]).OnClientEvent:Connect(function(result)core.Receive(name,result)end)
    end
    local jumpAt=0
    connections[#connections+1]=inputs.JumpRequest:Connect(function()
        if not config.InfiniteJump or not alive or now()<jumpAt or inputs:GetFocusedTextBox()then return end
        local c=player.Character;local h=c and c:FindFirstChildOfClass("Humanoid")
        if h and h.Health>0 then jumpAt=now()+.08;h:ChangeState(Enum.HumanoidStateType.Jumping)end
    end)
    connections[#connections+1]=runService.Heartbeat:Connect(function()
        for _,name in ipairs(core.Names)do core.Tick(name)end
        refresh(core.Report)
    end)
    task.spawn(function()
        local loaded,value=pcall(function()return module("Controllers.Core.DataController"):GetReplica()end)
        if alive then
            if loaded then replica=value;api.RefreshPetList()
            else core.Report.dataError=tostring(value)end
        end
    end)
end,debug.traceback)
if not ok then api.Destroy();error("DEVIL HUB Tapping Test: "..tostring(problem),0)end
return api
