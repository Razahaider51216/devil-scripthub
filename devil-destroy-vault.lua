-- DEVIL HUB / Destroy a Vault. Observed gameplay actions and owned-plot prompts.
local shared = type(getgenv) == "function" and getgenv() or _G
if game.PlaceId ~= 91034536684382 and game.GameId ~= 10561166339 then
    warn("DEVIL HUB: This entry supports Destroy a Vault.")
    return
end
if shared.DevilVaultSession then pcall(shared.DevilVaultSession.Destroy) end
local stopped = false
local controller, library, window, playerTools
local controls = {}
local player = game:GetService("Players").LocalPlayer
local storage = game:GetService("ReplicatedStorage")
local connection
local restoreWarp
local function rootPart()
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid")
end
local function stopMovement()
    if restoreWarp then pcall(restoreWarp) end
    local root, humanoid = rootPart()
    if root and humanoid then humanoid:MoveTo(root.Position) end
end
local function cleanup()
    if stopped then return end
    stopped = true
    if controller then controller.Stop() end
    if playerTools then playerTools.Destroy() end
    stopMovement()
    if connection then connection:Disconnect() end
    if library and library.Destroy then pcall(function() library:Destroy() end) end
end
shared.DevilVaultSession = {Destroy = cleanup}
local function resolve(path)
    local item = game
    for segment in path:gmatch("[^.]+") do
        item = item and item:FindFirstChild(segment)
        if not item then return nil end
    end
    return item
end
local function cash()
    for _, folderName in ipairs({"leaderstats", "Stats"}) do
        local folder = player:FindFirstChild(folderName)
        if folder then
            for _, name in ipairs({"Cash", "Money"}) do
                local value = folder:FindFirstChild(name)
                if value and (value:IsA("NumberValue") or value:IsA("IntValue") or value:IsA("StringValue")) then
                    local result = tonumber(value.Value)
                    if result then return result end
                end
            end
        end
    end
    return tonumber(player:GetAttribute("Cash"))
end
local function remoteCall(name, ...)
    local remotes = storage:FindFirstChild("VaultRemotes")
    local remote = remotes and remotes:FindFirstChild(name)
    if not remote or not remote:IsA("RemoteFunction") then return nil, "ไม่พบ Remote: " .. name end
    local args = table.pack(...)
    local completed, ok, result = false, false, nil
    local thread = task.spawn(function()
        ok, result = pcall(remote.InvokeServer, remote, table.unpack(args,1,args.n))
        completed = true
    end)
    local deadline = os.clock() + 10
    while not completed and not stopped and os.clock() < deadline do task.wait(0.1) end
    if not completed then
        if task.cancel and thread then pcall(task.cancel,thread) end
        return false, stopped and "หยุดแล้ว" or ("หมดเวลารอผล: " .. name)
    end
    if not ok then return false, tostring(result) end
    if result == true then return true, name .. ": สำเร็จ" end
    if result == false then return false, name .. ": เกมไม่รับคำขอ" end
    if type(result) == "table" then
        local message = tostring(result.Message or result.message or result.Reason or result.reason or result.Result or result.result or "เกมตอบกลับแล้ว")
        if result.Success == true or result.success == true then return true, message end
        if result.Success == false or result.success == false then return false, message end
        return nil, message .. " (ยังไม่ยืนยันผลสำเร็จ)"
    end
    return nil, name .. ": " .. tostring(result) .. " (ยังไม่ยืนยันผลสำเร็จ)"
end
local function interact(prompt, feedback, valid, walk, stationary, fastWarp, expandClientRange, warpReturn)
    if playerTools and playerTools.flags.fly then return nil,"ปิด Fly ก่อนใช้ Auto ที่ต้องเคลื่อนตัวละคร" end
    if stopped or not valid() or not prompt.Parent or not prompt.Enabled then return nil, "หยุด หรือ Prompt ยังไม่พร้อม" end
    local parent = prompt.Parent
    local position = parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position
    if not position then return nil, "ยังหาตำแหน่ง Prompt ไม่ได้" end
    local root, humanoid = rootPart()
    if not root or not humanoid or humanoid.Health <= 0 then return nil, "รอตัวละครเกิด" end
    local radius = math.max(1, prompt.MaxActivationDistance - 1)
    local returnPosition
    local savedPrompt
    local targetPosition
    local originalRoot=root
    local function returnHome()
        if savedPrompt then
            local properties=savedPrompt
            savedPrompt=nil
            pcall(function()
                prompt.MaxActivationDistance=properties.distance
                prompt.RequiresLineOfSight=properties.lineOfSight
            end)
        end
        if returnPosition then
            local currentRoot=rootPart()
            if currentRoot==originalRoot and originalRoot.Parent then
                originalRoot.CFrame=returnPosition
                originalRoot.AssemblyLinearVelocity=Vector3.new(0,0,0)
            end
            returnPosition=nil
        end
        if restoreWarp==returnHome then restoreWarp=nil end
    end
    local function finish(ok,message)
        if ok == true and warpReturn == false then returnPosition=nil end
        pcall(returnHome)
        return ok,message
    end
    if (root.Position - position).Magnitude > radius then
        if fastWarp then
            returnPosition=root.CFrame
            targetPosition=position+Vector3.new(0,math.min(2,radius*0.25),0)
            restoreWarp=returnHome
            local warped,reason=pcall(function()
                root.CFrame=CFrame.new(targetPosition)*returnPosition.Rotation
                root.AssemblyLinearVelocity=Vector3.new(0,0,0)
                root.AssemblyAngularVelocity=Vector3.new(0,0,0)
            end)
            if not warped then return finish(false,"วาร์ปไม่สำเร็จ: "..tostring(reason)) end
            task.wait(0.2)
            if stopped or not valid() then return finish(nil,"หยุดแล้ว") end
            local currentRoot,currentHumanoid=rootPart()
            if currentRoot~=originalRoot or not currentHumanoid or currentHumanoid.Health<=0 then return finish(nil,"ตัวละครเปลี่ยน รอเกิดใหม่") end
            if (root.Position-position).Magnitude>radius then return finish(false,"ตำแหน่งถูกดึงกลับก่อนกด Prompt") end
        elseif stationary then
            if type(fireproximityprompt) ~= "function" then return nil, "โหมดยืนฟาร์มต้องใช้ fireproximityprompt ของตัวรัน" end
        else
        if not walk then return nil, "เดินเข้าใกล้ " .. prompt.Name .. " ก่อน" end
        local offset = root.Position - position
        local destination = position + (offset.Magnitude > 0 and offset.Unit or Vector3.new(1,0,0)) * math.max(1, radius - 2)
        humanoid:MoveTo(destination)
        local deadline = os.clock() + 8
        repeat
            task.wait(0.1)
            if stopped or not valid() then stopMovement(); return nil, "หยุดการเดิน" end
            root, humanoid = rootPart()
            if not root or not humanoid or humanoid.Health <= 0 then return nil, "รอตัวละครเกิด" end
        until (root.Position - position).Magnitude <= radius or os.clock() >= deadline
        stopMovement()
        if (root.Position - position).Magnitude > radius then return false, "เดินไปไม่ถึง " .. prompt.Name .. " ลองยืนใกล้จุดนั้น" end
        end
    end
    if not valid() or not prompt.Enabled then return finish(nil, "Prompt ยังไม่พร้อม") end
    if expandClientRange then
        savedPrompt={distance=prompt.MaxActivationDistance,lineOfSight=prompt.RequiresLineOfSight}
        local adjusted,reason=pcall(function()
            prompt.MaxActivationDistance=math.max(prompt.MaxActivationDistance,(root.Position-position).Magnitude+20)
            prompt.RequiresLineOfSight=false
        end)
        if not adjusted then return finish(false,"ปรับระยะฝั่ง Client ไม่สำเร็จ: "..tostring(reason)) end
    end
    local before = prompt:GetAttribute(feedback.sequence)
    local ok, reason = pcall(function()
        if type(fireproximityprompt) == "function" then
            fireproximityprompt(prompt, prompt.HoldDuration)
        else
            prompt:InputHoldBegin()
            local untilTime = os.clock() + prompt.HoldDuration
            while os.clock() < untilTime and valid() and not stopped do task.wait(0.05) end
            prompt:InputHoldEnd()
        end
    end)
    if not ok then return finish(false, tostring(reason)) end
    local deadline = os.clock() + (fastWarp and 1.5 or 3)
    repeat
        if stopped or not valid() then return finish(nil, "หยุดแล้ว") end
        if not prompt.Parent then return finish(nil, "Prompt เปลี่ยน รอรอบถัดไป") end
        if prompt:GetAttribute(feedback.sequence) ~= before then
            local success = prompt:GetAttribute(feedback.success)
            return finish(success == true, tostring(prompt:GetAttribute(feedback.result) or "ผลตอบกลับเปลี่ยนแล้ว"))
        end
        task.wait(fastWarp and 0.05 or 0.1)
    until os.clock() >= deadline
    return finish(false, (expandClientRange and "Roll ระยะไกลไม่มีผลยืนยัน: การขยายระยะ Client ยังไม่ผ่านเกม • กดเก็บโค้ดระบบ Roll" or (stationary and "โหมดยืนฟาร์มไม่มีผลยืนยัน เกมอาจตรวจระยะ: " or "ยังไม่มีผลยืนยันจากเกม: ") .. prompt.Name))
end
local rarityNames={"Common","Uncommon","Rare","Epic","Legendary","Mythic","Divine","Secret","Omnipotent","Transcendant","Indestructible","Limited"}
local function offerRarity(surface)
    local offer = surface:GetAttribute("RollOfferId")
    local robot = surface:GetAttribute("RollRobotId")
    if not offer or not robot then return nil end
    -- Tie rarity to the current offer rather than a stale billboard/previous reveal.
    for _, item in ipairs(surface:GetDescendants()) do
        if item:GetAttribute("RollOfferId") == offer and item:GetAttribute("RobotId") == robot then
            local rarity = item:GetAttribute("Rarity")
            if type(rarity)=="string" and rarity~="" then return rarity end
        end
    end
    return nil
end
local factory = (function()
-- DEVIL HUB Destroy a Vault controller. Only observed interactions are used.
return function(env)
    local api = {running = true, flags = {}, settings = {interval = 0.5, minimumOdds = 1, reserve = 0, walk = false, stationary = false, fastWarp = true, warpReturn = false, freeRoamRoll = false, stopAtRarity = false, stopRarities = {}}, status = {}, nextRun = {}, failures = {}}
    local claimed = {}
    local purchasedUpgrades = {}
    api.settings.rollDelay = 0.5
    api.settings.buyRarities = nil
    api.settings.maxBuyPrice = nil
    local revisions = {}
    local cursor = 0
    local jobs = {"gold", "claim", "roll", "holders", "damage", "battery", "luck", "spots", "daily"}
    local boards = {
        damage = {"PurchaseRobotDamage", "ReplicatedStorage.SharedUpgradeBoardTemplates.RobotUpgrades.RobotUpgrades.RobotDamage.BoardPart"},
        battery = {"PurchaseRobotBattery", "ReplicatedStorage.SharedUpgradeBoardTemplates.RobotUpgrades.RobotUpgrades.RobotBattery.BoardPart"},
        luck = {"PurchaseRollLuck", "ReplicatedStorage.SharedUpgradeBoardTemplates.RollUpgrades.RollUpgrades.RobotLuck.BoardPart"},
        spots = {"PurchaseRollSpots", "ReplicatedStorage.SharedUpgradeBoardTemplates.RollUpgrades.RollUpgrades.RobotRolls.BoardPart"},
    }
    local function attr(item, key) return item and item:GetAttribute(key) end
    local function number(value) return tonumber(value) end
    function api.Plot()
        local root = env.plotRoot()
        if not root then return nil end
        local plots = root:GetChildren()
        for _, plot in ipairs(plots) do
            if plot.Name:match("^Plot_%d+$") and number(attr(plot, "OwnerUserId")) == env.userId then return plot end
        end
        for _, plot in ipairs(plots) do
            if plot.Name:match("^Plot_%d+$") then
                local owner = attr(plot, "OwnerUserId")
                if owner == nil then
                    for _, item in ipairs(plot:GetDescendants()) do
                        if number(attr(item, "TreasureOwnerUserId")) == env.userId then return plot end
                    end
                end
            end
        end
        return nil
    end
    function api.Set(key, enabled)
        revisions[key] = (revisions[key] or 0) + 1
        api.flags[key] = enabled == true
        api.nextRun[key] = 0
        api.failures[key] = 0
        if not enabled and env.cancelMovement then env.cancelMovement() end
    end
    function api.Stop()
        api.running = false
        for key in pairs(api.flags) do api.flags[key] = false end
        if env.cancelMovement then env.cancelMovement() end
    end
    function api.StopAll()
        for key in pairs(api.flags) do api.Set(key, false) end
    end
    local function valid(job, plot)
        return api.running and api.flags[job] and (not plot or api.Plot() == plot)
    end
    local function prompt(plot, name)
        for _, item in ipairs(plot:GetDescendants()) do
            if item:IsA("ProximityPrompt") and item.Name == name and item.Enabled then return item end
        end
        return nil
    end
    local function interact(job, plot, item, sequence, success, result)
        if not item then return nil, "ไม่พบ Prompt ที่เปิดใช้งาน" end
        local revision = revisions[job]
        local function stillValid() return revisions[job] == revision and valid(job, plot) end
        if job=="roll" and api.settings.freeRoamRoll then
            return env.interact(item,{sequence=sequence,success=success,result=result},stillValid,false,true,false,true)
        end
        return env.interact(item, {sequence = sequence, success = success, result = result}, stillValid, api.settings.walk, api.settings.stationary, api.settings.fastWarp, false, api.settings.warpReturn)
    end
    local function withinBudget(price)
        local cash = env.cash()
        if api.settings.reserve > 0 and not cash then return false, "ยังอ่านเงินไม่ได้ จึงรักษาเงินสำรองไว้" end
        if cash and cash - (price or 0) < api.settings.reserve then return false, "รอเงินให้พอหลังหักเงินสำรอง" end
        return true
    end
    local function invoke(remote, ...)
        return env.invoke(remote, ...)
    end
    local function gold(plot)
        local pickup, deposit = prompt(plot, "TreasurePickupPrompt"), prompt(plot, "SmelterDepositPrompt")
        local carried, pile = 0, 0
        for _, item in ipairs(plot:GetDescendants()) do
            carried = math.max(carried, number(attr(item, "CarriedGold")) or 0)
            pile = math.max(pile, number(attr(item, "TreasurePileGold")) or 0)
        end
        if carried > 0 then return interact("gold", plot, deposit, "InteractionFeedbackSequence", "InteractionSucceeded", "InteractionResult") end
        if pile > 0 then return interact("gold", plot, pickup, "InteractionFeedbackSequence", "InteractionSucceeded", "InteractionResult") end
        return nil, "รอทองจากหุ่น"
    end
    local function eligibleOffer(surface)
        local offer, robot = attr(surface, "RollOfferId"), attr(surface, "RollRobotId")
        local odds = number(attr(surface, "RollRobotOddsDenominator"))
        if not offer or not robot or not odds or odds < api.settings.minimumOdds or claimed[offer] or attr(surface, "RollPedestalUnlocked") == false then return false end
        if api.settings.buyRarities then
            local rarity = env.offerRarity and env.offerRarity(surface)
            if not rarity or not api.settings.buyRarities[rarity] then return false end
        end
        if api.settings.maxBuyPrice then
            local price = env.offerPrice and number(env.offerPrice(surface))
            if not price or price < 0 or price > api.settings.maxBuyPrice then return false end
        end
        return true, offer
    end
    local function claim(plot)
        local allowed, reason = withinBudget()
        if not allowed then return nil, reason end
        if api.settings.reserve > 0 then return nil, "ราคาซื้อหุ่นยังอ่านไม่ครบ: ตั้งเงินสำรองเป็น 0 เพื่อเปิดการซื้อ" end
        for _, item in ipairs(plot:GetDescendants()) do
            if item:IsA("ProximityPrompt") and item.Name == "ClaimRobotPrompt" and item.Enabled then
                local surface = item.Parent
                local eligible, offer = eligibleOffer(surface)
                if eligible then
                    local ok, message = interact("claim", plot, item, "RobotClaimPurchaseFeedbackSequence", "PurchaseSucceeded", "PurchaseResult")
                    if ok then claimed[offer] = true end
                    return ok, message
                end
            end
        end
        return nil, api.settings.maxBuyPrice and "รอราคาหุ่นที่ยืนยันได้ภายใน Max Buy Price" or "รอหุ่นตาม Buy Rarities / Odds ที่เลือก"
    end
    local function roll(plot)
        -- Leave qualifying offers in place while the buyer is enabled.
        if api.flags.claim then
            for _, item in ipairs(plot:GetDescendants()) do
                if item:IsA("ProximityPrompt") and item.Name == "ClaimRobotPrompt" and item.Enabled then
                    if eligibleOffer(item.Parent) then return nil, "รอรับหุ่นก่อน Roll รอบถัดไป" end
                end
            end
        end
        return interact("roll", plot, prompt(plot, "RollPrompt"), "RollFeedbackSequence", "RollSucceeded", "RollResult")
    end
    local function holders(plot)
        local candidates = {}
        for _, item in ipairs(plot:GetDescendants()) do
            local id, price = attr(item, "RobotHolderId"), number(attr(item, "RobotHolderPurchasePrice"))
            if type(id) == "string" and price and price >= 0 and attr(item, "Unlocked") == false then
                local island = item.Parent
                local unlocked = true
                while island and island ~= plot do
                    if attr(island, "IslandUnlocked") == false then unlocked = false; break end
                    island = island.Parent
                end
                if unlocked then candidates[#candidates + 1] = {id = id, price = price} end
            end
        end
        table.sort(candidates, function(a,b) return a.price < b.price end)
        for _, item in ipairs(candidates) do
            local allowed = withinBudget(item.price)
            local cash = env.cash()
            if allowed and cash and cash >= item.price + api.settings.reserve then return invoke("RobotHolderPurchaseRequest", item.id) end
        end
        return nil, "ไม่มีช่องที่ซื้อได้ตอนนี้ หรือยังอ่านเงินไม่ได้"
    end
    local function upgrade(job,plot)
        local board = boards[job]
        if not env.pathExists(board[2]) then return nil, "ไม่พบป้าย Upgrade ตามข้อมูลที่จับไว้" end
        if not env.readUpgrade then return nil,"รอข้อมูลค่าถัดไปจากป้าย Upgrade" end
        local data,reason=env.readUpgrade(plot,board[1])
        if data and env.activateUpgrade then
            if api.settings.reserve>0 and type(data.price)~="number" then return nil,"ยังอ่านราคา Upgrade ไม่ได้ จึงรักษาเงินสำรองไว้" end
            local allowed,message=withinBudget(data.price)
            if not allowed then return nil,message end
            local revision=revisions[job]
            return env.activateUpgrade(data,board[1],function() return revisions[job]==revision and valid(job,plot) end)
        end
        if not data or type(data.target)~="number" or data.target%1~=0 or data.target<1 then return nil,reason or "ยังอ่านค่า Upgrade ถัดไปไม่ได้" end
        local previous=purchasedUpgrades[job]
        if previous and previous.plot==plot and previous.target==data.target then return nil,"ซื้อสำเร็จแล้ว รอป้ายแสดงค่าถัดไป" end
        if api.settings.reserve>0 and type(data.price)~="number" then return nil,"ยังอ่านราคา Upgrade ไม่ได้ จึงรักษาเงินสำรองไว้" end
        local allowed,message=withinBudget(data.price)
        if not allowed then return nil,message end
        local ok,result=invoke("UpgradeBoardAction",board[1],board[2],data.target)
        if ok==true then purchasedUpgrades[job]={plot=plot,target=data.target} end
        return ok,(result or "ยังไม่มีผลตอบกลับ").." • ค่าที่ส่ง: "..tostring(data.target)
    end
    function api.CheckTargets(plot)
        if not api.flags.roll or not api.settings.stopAtRarity or not env.offerRarity or not plot then return end
        for _, item in ipairs(plot:GetDescendants()) do
            if item:IsA("ProximityPrompt") and item.Name == "ClaimRobotPrompt" and item.Enabled then
                local offer = attr(item.Parent,"RollOfferId")
                if offer and not claimed[offer] and attr(item.Parent,"RollPedestalUnlocked") ~= false then
                    local rarity = env.offerRarity(item.Parent)
                    if rarity and api.settings.stopRarities[rarity] then
                        api.Set("roll",false)
                        api.status.roll = "พบ " .. rarity .. " • หยุด Roll เพื่อเก็บผลไว้"
                        if env.disabled then env.disabled("roll",api.status.roll) end
                        return rarity
                    end
                end
            end
        end
    end
    function api.Step()
        if not api.running then return end
        api.CheckTargets(api.Plot())
        for _ = 1, #jobs do
            cursor = cursor % #jobs + 1
            local job = jobs[cursor]
            if api.flags[job] and env.now() >= (api.nextRun[job] or 0) then
                local delay = job == "roll" and api.settings.rollDelay or api.settings.interval
                api.nextRun[job] = env.now() + delay
                local plot = job ~= "daily" and api.Plot() or nil
                if job ~= "daily" and not plot then api.status[job] = "รอฐานของผู้เล่น"; return end
                local executed, ok, message = pcall(function()
                    if job == "gold" then return gold(plot) end
                    if job == "claim" then return claim(plot) end
                    if job == "roll" then return roll(plot) end
                    if job == "holders" then return holders(plot) end
                    if job == "daily" then return invoke("DailyRewardsAction", "Claim") end
                    return upgrade(job,plot)
                end)
                if not executed then message, ok = tostring(ok), false end
                if not api.running or not api.flags[job] then return end
                api.status[job] = message or "ไม่มีผลตอบกลับ"
                api.nextRun[job] = env.now() + (job == "daily" and 120 or (ok == false and 15 or delay))
                if ok == false then
                    api.failures[job] = (api.failures[job] or 0) + 1
                    if api.failures[job] >= 3 then
                        api.flags[job] = false
                        if env.disabled then env.disabled(job, api.status[job]) end
                    end
                elseif ok == true then api.failures[job] = 0 end
                return job, ok
            end
        end
    end
    function api.Inspect()
        local plot = api.Plot()
        local prompts, holders, offers, plots, upgrades = {}, {}, {}, {}, {}
        local plotRoot = env.plotRoot()
        if plotRoot then
            for _, candidate in ipairs(plotRoot:GetChildren()) do
                if candidate.Name:match("^Plot_%d+$") then plots[#plots+1]={name=candidate.Name,owner=attr(candidate,"OwnerUserId")} end
            end
        end
        if plot then
            for _, item in ipairs(plot:GetDescendants()) do
                if item:IsA("ProximityPrompt") then prompts[#prompts + 1] = {name = item.Name, path = item:GetFullName(), enabled = item.Enabled, distance = item.MaxActivationDistance, hold = item.HoldDuration} end
                if attr(item, "RobotHolderPurchasePrice") then holders[#holders + 1] = {id = attr(item,"RobotHolderId"), price = attr(item,"RobotHolderPurchasePrice"), unlocked = attr(item,"Unlocked")} end
                if attr(item,"RollOfferId") and attr(item,"RollRobotId") then
                    offers[#offers+1]={offerId=attr(item,"RollOfferId"),robotId=attr(item,"RollRobotId"),odds=attr(item,"RollRobotOddsDenominator"),rarity=env.offerRarity and env.offerRarity(item) or nil}
                end
            end
        end
        if plot and env.readUpgrade then
            for job,board in pairs(boards) do
                local ok,data,reason=pcall(env.readUpgrade,plot,board[1])
                upgrades[job]={action=board[1],requestPath=board[2]}
                if ok and data then
                    upgrades[job].target=data.target;upgrades[job].current=data.current;upgrades[job].price=data.price;upgrades[job].valueText=data.valueText
                    upgrades[job].liveBoard=data.part and data.part:GetFullName() or nil
                    if env.inspectUpgradeButton then upgrades[job].gameButton=env.inspectUpgradeButton(data,board[1]) end
                else upgrades[job].reason=ok and reason or tostring(data) end
            end
        end
        return {placeId = env.placeId, userId = env.userId, plot = plot and plot:GetFullName() or "Not found", plots = plots, cash = env.cash(), prompts = prompts, holders = holders, offers = offers, upgrades = upgrades, status = api.status, settings = api.settings}
    end
    return api
end

end)()
local playerFactory = (function()
-- DEVIL HUB reversible local player controls; no remote or anti-cheat hooks.
return function(env)
    local player, world = env.player, env.world
    local services = env.services
    local api = {flags={},speed=32,flySpeed=60,alive=true}
    local links, saved, speedHumanoid, speedOriginal = {}, {}, nil, nil
    local flyRoot, flyHumanoid, velocity, gyro, autoRotate = nil,nil,nil,nil,nil
    local reconnectGeneration = 0
    local renderOriginal = true
    local function connect(signal,fn)
        if signal and signal.Connect then
            local ok,link=pcall(function() return signal:Connect(fn) end)
            if ok then links[#links+1]=link end
        end
    end
    local function remember(item,property,value,group)
        local bucket=saved[group] or {};saved[group]=bucket
        local values=bucket[item] or {};bucket[item]=values
        if values[property]==nil then values[property]=item[property] end
        item[property]=value
    end
    local function restore(group)
        for item,values in pairs(saved[group] or {}) do
            for key,value in pairs(values) do pcall(function() item[key]=value end) end
        end
        saved[group]=nil
    end
    local function character()
        local c=player.Character
        return c,c and c:FindFirstChild("HumanoidRootPart"),c and c:FindFirstChildOfClass("Humanoid")
    end
    local function stopFly()
        if velocity then velocity:Destroy();velocity=nil end
        if gyro then gyro:Destroy();gyro=nil end
        if flyHumanoid and autoRotate~=nil then pcall(function() flyHumanoid.AutoRotate=autoRotate end) end
        if flyRoot then
            local _,root,human=character()
            if root==flyRoot and human then
                root.AssemblyLinearVelocity=Vector3.zero
            end
        end
        flyRoot=nil;flyHumanoid=nil;autoRotate=nil
    end
    local function restoreSpeed()
        if speedHumanoid then pcall(function() speedHumanoid.WalkSpeed=speedOriginal end) end
        speedHumanoid=nil;speedOriginal=nil
    end
    local function prompt(item)
        if api.flags.instant and item:IsA("ProximityPrompt") then remember(item,"HoldDuration",0,"instant") end
    end
    local function effects(item)
        if not api.flags.fps then return end
        if item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam") or item:IsA("Smoke") or item:IsA("Fire") or item:IsA("Sparkles") then
            remember(item,"Enabled",false,"fps")
        elseif item:IsA("PostEffect") then remember(item,"Enabled",false,"fps") end
    end
    function api.Set(key,on)
        if not api.alive then return end
        if (api.flags[key]==true)==(on==true) then return end
        api.flags[key]=on==true
        if key=="reconnect" then reconnectGeneration+=1 end
        if key=="speed" and not on then restoreSpeed() end
        if key=="fly" and not on then stopFly() end
        if key=="noclip" and not on then restore("noclip") end
        if key=="instant" then
            if on then for _,item in ipairs(world:GetDescendants()) do prompt(item) end else restore("instant") end
        end
        if key=="fps" then
            if on then
                remember(services.Lighting,"GlobalShadows",false,"fps")
                for _,item in ipairs(world:GetDescendants()) do effects(item) end
                for _,item in ipairs(services.Lighting:GetDescendants()) do effects(item) end
            else restore("fps") end
        end
        if key=="render" then
            if on then
                local ok,value=pcall(function() return services.RunService:Is3dRenderingEnabled() end)
                if ok and type(value)=="boolean" then renderOriginal=value else renderOriginal=true end
            end
            services.RunService:Set3dRenderingEnabled(not on and renderOriginal or false)
        end
    end
    function api.Step()
        if not api.alive then return end
        local c,root,human=character()
        if not root or not human or human.Health<=0 then stopFly();restoreSpeed();restore("noclip");return end
        if api.flags.speed then
            if speedHumanoid~=human then restoreSpeed();speedHumanoid=human;speedOriginal=human.WalkSpeed end
            human.WalkSpeed=api.speed
        end
        if api.flags.noclip then
            for _,item in ipairs(c:GetDescendants()) do if item:IsA("BasePart") then remember(item,"CanCollide",false,"noclip") end end
        end
        if api.flags.fly then
            if flyRoot~=root then
                stopFly();flyRoot=root;flyHumanoid=human;autoRotate=human.AutoRotate;human.AutoRotate=false
                velocity=Instance.new("BodyVelocity");velocity.Name="DevilVaultFly";velocity.MaxForce=Vector3.new(1e6,1e6,1e6);velocity.Velocity=Vector3.zero;velocity.Parent=root
                gyro=Instance.new("BodyGyro");gyro.Name="DevilVaultFlyOrientation";gyro.MaxTorque=Vector3.new(1e6,1e6,1e6);gyro.P=9000;gyro.Parent=root
            end
            local camera=world.CurrentCamera
            if camera then
                local move=human.MoveDirection
                local forward=camera.CFrame.LookVector
                local flat=Vector3.new(forward.X,0,forward.Z)
                local projected=flat.Magnitude>0.01 and move:Dot(flat.Unit) or 0
                local vertical=human.Jump and 1 or 0
                local input=services.UserInputService
                if not input:GetFocusedTextBox() then
                    if input:IsKeyDown(Enum.KeyCode.Space) then vertical=1 end
                    if input:IsKeyDown(Enum.KeyCode.LeftControl) then vertical=-1 end
                end
                local direction=move+Vector3.new(0,forward.Y*projected+vertical,0)
                velocity.Velocity=(direction.Magnitude>1 and direction.Unit or direction)*api.flySpeed
                gyro.CFrame=camera.CFrame
            end
        end
    end
    function api.Destroy()
        if not api.alive then return end
        api.alive=false
        reconnectGeneration+=1
        for _,link in ipairs(links) do link:Disconnect() end
        stopFly();restoreSpeed()
        for _,group in ipairs({"noclip","fps","instant"}) do restore(group) end
        if api.flags.render then pcall(function() services.RunService:Set3dRenderingEnabled(renderOriginal) end) end
    end
    connect(services.RunService.Heartbeat,function() local ok,err=pcall(api.Step);if not ok and env.error then env.error(err) end end)
    connect(services.UserInputService.JumpRequest,function()
        if api.flags.jump and api.alive then local _,_,h=character();if h and h.Health>0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end)
    connect(world.DescendantAdded,function(item) if api.alive then prompt(item);effects(item) end end)
    connect(services.Lighting.DescendantAdded,function(item) if api.alive then effects(item) end end)
    local errorSignal
    pcall(function() errorSignal=services.GuiService and services.GuiService.ErrorMessageChanged end)
    connect(errorSignal,function(message)
        if not api.alive or not api.flags.reconnect or type(message)~="string" then return end
        local lower=message:lower()
        if not (lower:find("kick",1,true) or lower:find("disconnect",1,true) or lower:find("connection",1,true)) then return end
        reconnectGeneration+=1
        local generation=reconnectGeneration
        task.delay(10,function()
            if api.alive and api.flags.reconnect and generation==reconnectGeneration then
                local ok,err=pcall(function() services.TeleportService:Teleport(env.placeId,player) end)
                if not ok and env.error then env.error(err) end
            end
        end)
    end)
    function api.Mount(tab)
        local movement=tab:CreateGroupbox({Name="Movement",Icon="move",Side="Left"})
        local flying=tab:CreateGroupbox({Name="Fly",Icon="plane",Side="Right"})
        local client=tab:CreateGroupbox({Name="Client",Icon="monitor",Side="Left"})
        local function toggle(group,title,key)
            local ready=false
            group:CreateToggle({Name=title,CurrentValue=false,Callback=function(value)
                if not ready then return end
                local ok,err=pcall(api.Set,key,value)
                if not ok and env.error then env.error(err) end
            end});ready=true
        end
        toggle(movement,"WalkSpeed","speed")
        movement:CreateSlider({Name="Speed",Range={16,150},CurrentValue=32,Increment=1,Callback=function(value) api.speed=math.clamp(value,16,150) end})
        toggle(movement,"Infinite Jump","jump")
        toggle(movement,"Noclip","noclip")
        toggle(movement,"Instant ProximityPrompt","instant")
        toggle(flying,"Fly","fly")
        flying:CreateSlider({Name="Fly Speed",Range={10,200},CurrentValue=60,Increment=1,Callback=function(value) api.flySpeed=math.clamp(value,10,200) end})
        flying:CreateParagraph({Name="Controls",Content="มือถือ: ใช้จอยและหันกล้องเพื่อขึ้น/ลง • ปุ่มกระโดดขึ้น • PC: Space ขึ้น / Ctrl ลง • ปิด Fly เพื่อใช้ Auto วาร์ป"})
        toggle(client,"Disable 3D Rendering","render")
        toggle(client,"FPS Boost","fps")
        toggle(client,"Auto Reconnect on Kick","reconnect")
        client:CreateToggle({Name="Hide UI on Start",CurrentValue=env.hideOnStart==true,Callback=function(value) if env.setHideOnStart then env.setHideOnStart(value==true) end end})
        client:CreateParagraph({Name="Client behavior",Content="Reconnect รอ 10 วินาทีหลังข้อความ kick/disconnect • Hide UI มีผลรันครั้งถัดไปในตัวรันเดิม เปิดคืนด้วยโลโก้/K • เกมเป็นผู้กำหนด GameplayPaused จึงยังไม่มีระบบแก้"})
    end
    return api
end

end)()
local upgradeReader = (function()
-- Read an observed upgrade board's current display; never scan numeric targets.
local reader = {}
local function plain(value)
    return tostring(value or ""):gsub("</?[%a][^>]*>", ""):gsub("→", ">"):gsub("➜", ">"):gsub("&gt;", ">")
end
function reader.Target(text)
    local current, nextValue = plain(text):match("^%s*(%d+)%s*>%s*(%d+)%s*$")
    current, nextValue = tonumber(current), tonumber(nextValue)
    if not current or not nextValue or nextValue <= current then return nil end
    return nextValue, current
end
function reader.Price(text)
    local value=plain(text):gsub("[$,%s]", ""):upper()
    local number,suffix=value:match("^(%d+%.?%d*)([KMB]?)$")
    number=tonumber(number)
    if not number then return nil end
    return number * (({K=1000,M=1000000,B=1000000000})[suffix] or 1)
end
function reader.Read(plot, action)
    if not plot then return nil,"รอฐานของผู้เล่น" end
    local candidates={}
    local displays={}
    for _,item in ipairs(plot:GetDescendants()) do
        if item:IsA("SurfaceGui") and item:GetAttribute("UpgradeBoardAction")==action then
            local part=item.Parent
            if part and part:IsA("BasePart") and part:IsDescendantOf(plot) then
                local value=item:FindFirstChild("ValueLabel")
                local buy=item:FindFirstChild("BuyButton")
                local price=buy and buy:FindFirstChild("PriceLabel")
                local text=value and value:IsA("TextLabel") and value.Text or ""
                displays[#displays+1]=text:sub(1,100)
                local nextValue,current=reader.Target(text)
                candidates[#candidates+1]={part=part,surface=item,target=nextValue,current=current,valueText=text,
                    price=price and price:IsA("TextLabel") and reader.Price(price.Text) or nil}
            end
        end
    end
    if #candidates==1 then return candidates[1] end
    if #candidates>1 then return nil,"พบป้าย Upgrade ซ้ำในฐาน รอระบุป้ายที่ใช้งาน" end
    return nil,"รอป้าย Upgrade ที่แสดงค่าเดิม > ค่าถัดไปเป็นจำนวนเต็ม • อ่านได้: "..table.concat(displays," / ")
end
return reader

end)()
local upgradeButtonsFactory = (function()
-- Activate only the game's existing local upgrade button, bound to an owned board.
return function(env)
    local names={PurchaseRollLuck="RobotLuckUpgradeInteraction",PurchaseRollSpots="RobotRollsUpgradeInteraction",
        PurchaseRobotDamage="RobotDamageUpgradeInteraction",PurchaseRobotBattery="RobotBatteryUpgradeInteraction"}
    local function gui(data,action)
        local root=env.playerGui()
        local item=root and root:FindFirstChild(names[action] or "")
        if item and item:IsA("SurfaceGui") and item.Adornee==data.part then return item end
        return nil
    end
    local function callback(button)
        if type(env.getconnections)=="function" then
            for _,signal in ipairs({button.MouseButton1Click,button.Activated}) do
                local ok,links=pcall(env.getconnections,signal)
                local callbacks={}
                if ok and type(links)=="table" then for _,link in ipairs(links) do
                    if link.Enabled~=false then
                        local fire=link.Fire
                        local fn=link.Function
                        if type(fire)=="function" then callbacks[#callbacks+1]=function() fire(link) end
                        elseif type(fn)=="function" then callbacks[#callbacks+1]=fn end
                    end
                end end
                if #callbacks>0 then
                    if type(env.firesignal)=="function" then return function() env.firesignal(signal) end end
                    return function() for _,fn in ipairs(callbacks) do fn() end end
                end
            end
        end
        if type(env.firesignal)=="function" then return function() env.firesignal(button.MouseButton1Click) end end
        return nil
    end
    local api={}
    function api.Inspect(data,action)
        local surface=gui(data,action)
        if not surface then
            local root=env.playerGui()
            local observed=root and root:FindFirstChild(names[action] or "")
            return {bound=false,path=observed and observed:GetFullName() or nil,
                adornee=observed and observed.Adornee and observed.Adornee:GetFullName() or nil,
                signalSupport=type(env.firesignal)=="function",connectionsSupport=type(env.getconnections)=="function"}
        end
        local button=surface:FindFirstChild("BuyButton")
        local value=surface:FindFirstChild("ValueLabel")
        return {bound=true,path=surface:GetFullName(),enabled=surface.Enabled,
            valueText=value and value.Text or nil,buttonVisible=button and button.Visible or nil,
            buttonActive=button and button.Active or nil,signalSupport=type(env.firesignal)=="function",connectionsSupport=type(env.getconnections)=="function"}
    end
    function api.Read(plot,action)
        local data,reason=env.readBoard(plot,action)
        if not data then return nil,reason end
        local surface=gui(data,action)
        if surface then
            local value=surface:FindFirstChild("ValueLabel")
            local buy=surface:FindFirstChild("BuyButton")
            local price=buy and buy:FindFirstChild("PriceLabel")
            if value then data.valueText=value.Text end
            if price then data.price=env.parsePrice(price.Text) end
        end
        return data
    end
    function api.Buy(data,action,valid)
        if not valid() then return nil,"หยุดแล้ว" end
        local surface=gui(data,action)
        if not surface then return nil,"รอปุ่มเกมที่ผูกกับป้าย Upgrade ในฐานเรา" end
        local button=surface:FindFirstChild("BuyButton")
        local value=surface:FindFirstChild("ValueLabel")
        if not surface.Enabled or not button or not button:IsA("GuiButton") or not button.Visible or not button.Active then return nil,"ปุ่ม Upgrade ของเกมยังไม่พร้อม" end
        local run=callback(button)
        if not run then return nil,"ตัวรันยังไม่เปิด callback ปุ่มเกม • ต้องมี firesignal หรือ getconnections" end
        local display=value and value.Text or ""
        if display=="" or display:upper():find("MAX",1,true) then return nil,"รอค่าบนป้าย หรือ Upgrade ถึง MAX แล้ว" end
        local sequence=data.surface:GetAttribute("UpgradeVfxFeedbackSequence")
        local executed,err=pcall(run)
        if not executed then return false,"ปุ่มเกมทำงานผิดพลาด: "..tostring(err) end
        local deadline=env.now()+2
        repeat
            if not valid() then return nil,"หยุดแล้ว" end
            if surface.Adornee~=data.part then return nil,"ป้ายของปุ่มเกมเปลี่ยน รอรอบถัดไป" end
            if data.surface:GetAttribute("UpgradeVfxFeedbackSequence")~=sequence then
                local recipient=data.surface:GetAttribute("UpgradeVfxRecipientUserId")
                if recipient==nil or tonumber(recipient)==env.userId then
                    local success=data.surface:GetAttribute("UpgradeVfxSucceeded")
                    if success==true then return true,"Upgrade ผ่านปุ่มเกมสำเร็จ" end
                    if success==false then return false,"เกมไม่รับการซื้อ Upgrade" end
                end
            end
            if value and value.Parent and value.Text~=display then return true,"ค่า Upgrade บนป้ายเกมเปลี่ยนแล้ว: "..value.Text end
            env.wait(0.05)
        until env.now()>=deadline
        return nil,"กดปุ่มเกมแล้ว ยังไม่มีผลยืนยัน • ป้าย: "..display
    end
    return api
end

end)()
local upgradeButtons=upgradeButtonsFactory({playerGui=function() return player:FindFirstChild("PlayerGui") end,
    userId=player.UserId,now=os.clock,wait=task.wait,firesignal=firesignal,getconnections=getconnections,
    readBoard=upgradeReader.Read,parsePrice=upgradeReader.Price})
local names = {gold="เก็บทอง / ฝากหลอม",claim="รับ / ซื้อหุ่น",roll="Roll",holders="ซื้อช่องวางหุ่น",damage="Damage",battery="Battery",luck="Roll Luck",spots="Roll Spots",daily="Daily"}
controller = factory({
    userId = player.UserId, placeId = game.PlaceId,
    plotRoot = function() return workspace:FindFirstChild("playable") end,
    now = os.clock, cash = cash, interact = interact, invoke = remoteCall,
    offerRarity = offerRarity,
    readUpgrade = upgradeButtons.Read,
    activateUpgrade = upgradeButtons.Buy,
    inspectUpgradeButton = upgradeButtons.Inspect,
    pathExists = function(path) return resolve(path) ~= nil end,
    cancelMovement = stopMovement,
    disabled = function(key, reason)
        if controls[key] then controls[key]:Set(false, true) end
        if library then library:Notify({Title="DEVIL HUB",Content="หยุด " .. (names[key] or key) .. ": " .. reason,Duration=6}) end
    end,
})
local ok, errorText = xpcall(function()
    local source = game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    local compiled, compileError = loadstring(source, "DEVIL HUB UI")
    assert(compiled, compileError)
    library = compiled()
    local logo = "https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"
    local asset = getcustomasset or getsynasset
    if type(asset) == "function" and type(writefile) == "function" then
        local loaded, image = pcall(function()
            local filename = "DevilHub_Vault_Logo.png"
            if not (type(isfile) == "function" and isfile(filename)) then
                local png = game:HttpGet(logo)
                assert(png:sub(1,8) == "\137PNG\r\n\26\n", "Invalid logo")
                writefile(filename, png)
            end
            return asset(filename)
        end)
        if loaded then logo = image end
    end
    if library.Assets then library.Assets.Logo = logo end
    window = library:CreateWindow({
        Name="DEVIL HUB",Icon=logo,Theme="Abyss",Size=UDim2.fromOffset(880,520),Density="Compact",
        Profile=true,Search=true,Loading=false,Backdrop=false,Disclaimer=false,UnsupportedExecutor=false,
        KeepOnScreen=true,ConfigurationSaving={Enabled=false},
        Home={Title="DEVIL HUB / Destroy a Vault",Discord="https://discord.gg/ZY7PRcVJe2"},
        ToggleButton={Title="DEVIL HUB",Icon=logo,Platform="Both",Keybind=Enum.KeyCode.K},
    })
    if library.Gui and library.Gui.Destroying then connection=library.Gui.Destroying:Connect(cleanup) end
    local main=window:CreateTab({Name="Main",Icon="swords"})
    local playerTab=window:CreateTab({Name="Player",Icon="user"})
    local settings=window:CreateTab({Name="Settings",Icon="settings"})
    local farm=main:CreateGroupbox({Name="Rolling",Icon="repeat",Side="Left"})
    local holders=main:CreateGroupbox({Name="Base",Icon="layout-grid",Side="Right"})
    local upgrades=main:CreateGroupbox({Name="Upgrades",Icon="trending-up",Side="Left"})
    local economy=main:CreateGroupbox({Name="Economy",Icon="coins",Side="Right"})
    local advanced=settings:CreateGroupbox({Name="Advanced Rolling",Icon="dices",Side="Left"})
    local detailedUpgrades=settings:CreateGroupbox({Name="Individual Upgrades",Icon="trending-up",Side="Right"})
    local movement=settings:CreateGroupbox({Name="Movement & Timing",Icon="navigation",Side="Left"})
    local session=settings:CreateGroupbox({Name="Session",Icon="activity",Side="Right"})
    local modeControl,speedControl,freeRoamControl,rollDelayControl
    local hideOnStart=shared.DevilVaultHideUIOnStart==true
    playerTools=playerFactory({player=player,world=workspace,placeId=game.PlaceId,hideOnStart=hideOnStart,
        setHideOnStart=function(value) shared.DevilVaultHideUIOnStart=value end,services={
        RunService=game:GetService("RunService"),UserInputService=game:GetService("UserInputService"),Lighting=game:GetService("Lighting"),
        GuiService=game:GetService("GuiService"),TeleportService=game:GetService("TeleportService")},
        error=function(message) if library then library:Notify({Title="Player",Content=tostring(message),Duration=4}) end end})
    playerTools.Mount(playerTab)
    controller.settings.buyRarities={}
    for _,rarity in ipairs(rarityNames) do controller.settings.buyRarities[rarity]=true end
    local function toggle(group,key,title)
        local ready=false
        controls[key]=group:CreateToggle({Name=title,CurrentValue=false,Callback=function(value) if ready and not stopped then controller.Set(key,value) end end})
        ready=true
    end
    toggle(farm,"roll","Auto Roll")
    rollDelayControl=farm:CreateSlider({Name="Roll Delay",Range={0.35,15},CurrentValue=0.5,Increment=0.05,Callback=function(value) controller.settings.rollDelay=math.clamp(value,0.35,15) end})
    toggle(farm,"claim","Auto Buy Rolled Robots")
    local function selection(value)
        local result={}
        if type(value)=="table" then for key,item in pairs(value) do
            if type(key)=="number" and type(item)=="string" then result[item]=true
            elseif type(key)=="string" and item==true then result[key]=true end
        end elseif type(value)=="string" then result[value]=true end
        return result
    end
    farm:CreateDropdown({Name="Buy Rarities",Options=rarityNames,CurrentOption=rarityNames,MultipleOptions=true,AllowNone=true,Callback=function(value) controller.settings.buyRarities=selection(value) end})
    farm:CreateDropdown({Name="Max Buy Price",Options={"No Limit","1,000","10,000","100,000","1,000,000"},CurrentOption={"No Limit"},Callback=function(value)
        if type(value)=="table" then value=value[1] end
        controller.settings.maxBuyPrice=value~="No Limit" and tonumber((tostring(value):gsub(",",""))) or nil
    end})
    farm:CreateParagraph({Name="Price data",Content="ตั้งเพดานราคาจะรอจนอ่านราคาจริงได้ • Dump ปัจจุบันยังไม่มีราคาผล Roll • No Limit ซื้อเฉพาะ Buy Rarities/Odds ที่เลือก"})
    freeRoamControl=advanced:CreateToggle({Name="Roll อิสระ • ไม่เดิน/ไม่วาร์ป",CurrentValue=false,Callback=function(value) controller.settings.freeRoamRoll=value==true end})
    advanced:CreateButton({Name="เริ่มฟาร์มเร็ว • Roll + รับหุ่น + ทอง",Callback=function()
        if stopped then return end
        controller.settings.fastWarp=true
        controller.settings.warpReturn=false
        controller.settings.freeRoamRoll=false
        freeRoamControl:Set(false,true)
        controller.settings.stationary=false
        controller.settings.walk=false
        controller.settings.interval=0.5
        controller.settings.rollDelay=0.5
        rollDelayControl:Set(0.5,true)
        if modeControl then modeControl:Set({"Fast • วาร์ปต่อจุดฟาร์ม"},true) end
        if speedControl then speedControl:Set(0.5,true) end
        for _,key in ipairs({"roll","claim","gold"}) do
            controller.Set(key,true)
            controls[key]:Set(true,true)
        end
        library:Notify({Title="DEVIL HUB",Content="เปิดฟาร์มเร็วแล้ว • รับหุ่นใช้เงินในเกม",Duration=4})
    end})
    advanced:CreateInput({Name="รับเฉพาะ Odds 1 ใน X ขึ้นไป",CurrentValue="1",PlaceholderText="เช่น 1000",Numeric=true,Callback=function(value)
        controller.settings.minimumOdds=math.max(1,tonumber(value) or 1)
    end})
    advanced:CreateToggle({Name="หยุด Roll เมื่อพบระดับที่เลือก",CurrentValue=false,Callback=function(value) controller.settings.stopAtRarity=value==true end})
    local rarityControl
    rarityControl=advanced:CreateDropdown({Name="ระดับที่ให้หยุด (เลือกได้หลายระดับ)",Options=rarityNames,CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,Callback=function(value)
        local selected={}
        if type(value)=="table" then
            for key,entry in pairs(value) do
                if type(key)=="number" and type(entry)=="string" then selected[entry]=true
                elseif type(key)=="string" and entry==true then selected[key]=true end
            end
        elseif type(value)=="string" then selected[value]=true end
        controller.settings.stopRarities=selected
    end})
    advanced:CreateParagraph({Name="Stop at rarity",Content="อ่านระดับจากผล Roll จริง • หยุดเฉพาะ Roll • เลือก Buy Rarities ให้รวมระดับที่ต้องการรับไว้ด้วย"})
    toggle(economy,"gold","Auto Collect Gold")
    toggle(economy,"daily","Auto รับ Daily Reward")
    local statusWidget=economy:CreateParagraph({Name="Status",Content="กำลังตรวจฐาน..."})
    local upgradeKeys={Damage="damage",Battery="battery",["Roll Luck"]="luck",["Roll Spots"]="spots"}
    local selectedUpgrades={Damage=true,Battery=true,["Roll Luck"]=true,["Roll Spots"]=true}
    local upgradeMaster
    local function setUpgrades(enabled)
        for label,key in pairs(upgradeKeys) do local on=enabled and selectedUpgrades[label]==true;controller.Set(key,on);controls[key]:Set(on,true) end
    end
    for _,key in ipairs({"damage","battery","luck","spots"}) do toggle(detailedUpgrades,key,"Auto Upgrade "..names[key]) end
    local upgradeReady=false
    upgradeMaster=upgrades:CreateToggle({Name="Auto Buy Upgrades",CurrentValue=false,Callback=function(value) if upgradeReady and not stopped then setUpgrades(value==true) end end});upgradeReady=true
    upgrades:CreateDropdown({Name="Upgrades",Options={"Roll Spots","Roll Luck","Damage","Battery"},CurrentOption={"Roll Spots","Roll Luck","Damage","Battery"},MultipleOptions=true,AllowNone=true,Callback=function(value)
        selectedUpgrades=selection(value)
        local active=false;for _,key in pairs(upgradeKeys) do if controller.flags[key] then active=true end end
        if active then setUpgrades(true) end
    end})
    upgrades:CreateParagraph({Name="Upgrade control",Content="ใช้ปุ่มซื้อเดิมของเกม • ถ้าขึ้นรอปุ่ม ให้เข้าใกล้ป้าย Upgrade ก่อน • ถ้าไม่มีเงินหรือถึง MAX จะรอ"})
    upgrades:CreateParagraph({Name="Auto Upgrade Gold Vault",Content="ยังไม่พร้อมใช้งานในเวอร์ชันนี้ • Upgrade ด้านบนใช้ได้เฉพาะรายการที่เลือก"})
    holders:CreateParagraph({Name="Auto Place Robots / Auto Replace With Better",Content="ยังไม่พร้อมใช้งานในเวอร์ชันนี้ • Auto Buy Rolled Robots รับหุ่นที่สุ่มได้ แต่ยังไม่จัดหุ่นลงช่องหรือแทนตัวเดิม"})
    toggle(holders,"holders","Auto Buy Tank Slots")
    holders:CreateParagraph({Name="Auto Unlock Islands",Content="ยังไม่พร้อมใช้งานในเวอร์ชันนี้ • Auto Buy Tank Slots ซื้อเฉพาะช่องบนเกาะที่ปลดล็อกแล้ว"})
    economy:CreateParagraph({Name="Auto Buy Gem Shop",Content="ยังไม่พร้อมใช้งานในเวอร์ชันนี้ • Auto Collect Gold เก็บแล้วฝากหลอมให้อัตโนมัติ"})
    session:CreateInput({Name="เงินสำรอง",CurrentValue="0",Numeric=true,Callback=function(value) controller.settings.reserve=math.max(0,tonumber(value) or 0) end})
    session:CreateParagraph({Name="Budget",Content="เงินสำรองใช้กับช่องวาง/Upgrade ที่อ่านราคาได้ • ถ้าราคาไม่ชัดจะรอ • ตั้งมากกว่า 0 จะพักการซื้อหุ่นที่ยังไม่ทราบราคา"})
    local holderId=""
    session:CreateInput({Name="ID ช่องสำหรับ Upgrade ครั้งเดียว",CurrentValue="",PlaceholderText="robot_holder_6",Callback=function(value) holderId=tostring(value) end})
    session:CreateButton({Name="Upgrade ช่องที่ระบุครั้งเดียว",Callback=function()
        if stopped then return end
        local plot=controller.Plot()
        local found=false
        if plot then for _,item in ipairs(plot:GetDescendants()) do if item:GetAttribute("RobotHolderId")==holderId and item:GetAttribute("Unlocked")==true then found=true;break end end end
        if not found then library:Notify({Title="DEVIL HUB",Content="ไม่พบช่องที่ปลดล็อกในฐานของเรา"});return end
        task.spawn(function() local _,message=remoteCall("RobotHolderAction","Upgrade",holderId,1);if not stopped then library:Notify({Title="DEVIL HUB",Content=message}) end end)
    end})
    local preset="ครบวงจร • Roll + รับหุ่น + ทอง"
    local presets={
        ["ครบวงจร • Roll + รับหุ่น + ทอง"]={"roll","claim","gold"},
        ["Roll + รับหุ่น"]={"roll","claim"},
        ["เก็บทอง + ฝากหลอม"]={"gold"},
        ["Auto Upgrade + ซื้อช่อง"]={"damage","battery","luck","spots","holders"},
    }
    local modes=settings:CreateGroupbox({Name="Farm Modes",Icon="layers",Side="Left"})
    modes:CreateDropdown({Name="เลือกชุดฟาร์ม",Options={"ครบวงจร • Roll + รับหุ่น + ทอง","Roll + รับหุ่น","เก็บทอง + ฝากหลอม","Auto Upgrade + ซื้อช่อง"},CurrentOption={preset},Callback=function(value)
        if type(value)=="table" then value=value[1] end
        if presets[value] then preset=value end
    end})
    modes:CreateParagraph({Name="เลือกแล้วกดเริ่ม",Content="เริ่มชุดใหม่จะหยุด Auto ชุดเดิม • รับหุ่นและ Upgrade ใช้เงินในเกม • ตั้งระดับหยุด Roll ได้หลายระดับใน Roll & Robots"})
    modes:CreateButton({Name="เริ่มชุดฟาร์มที่เลือก",Callback=function()
        if stopped then return end
        controller.StopAll()
        for _,control in pairs(controls) do control:Set(false,true) end
        controller.settings.freeRoamRoll=false
        freeRoamControl:Set(false,true)
        for _,key in ipairs(presets[preset]) do controller.Set(key,true);controls[key]:Set(true,true) end
        library:Notify({Title="DEVIL HUB",Content="เริ่ม "..preset,Duration=4})
    end})
    modeControl=movement:CreateDropdown({Name="โหมดทำงาน",Options={"Fast • วาร์ปต่อจุดฟาร์ม","Fast • วาร์ปไปกดแล้วกลับ","ยืนฟาร์ม (ไม่เดิน)","เดินเข้าใกล้ Prompt","เฉพาะจุดที่อยู่ในระยะ"},CurrentOption={"Fast • วาร์ปต่อจุดฟาร์ม"},Callback=function(value)
        if type(value)=="table" then value=value[1] end
        controller.settings.stationary=value=="ยืนฟาร์ม (ไม่เดิน)"
        controller.settings.walk=value=="เดินเข้าใกล้ Prompt"
        controller.settings.fastWarp=value=="Fast • วาร์ปไปกดแล้วกลับ" or value=="Fast • วาร์ปต่อจุดฟาร์ม"
        controller.settings.warpReturn=value=="Fast • วาร์ปไปกดแล้วกลับ"
        controller.settings.freeRoamRoll=false
        freeRoamControl:Set(false,true)
        stopMovement()
    end})
    movement:CreateParagraph({Name="Fast farming",Content="วาร์ปต่อจุดฟาร์ม: อยู่จุดที่ทำสำเร็จแล้วไปงานถัดไป • วาร์ปไปกดแล้วกลับ: กลับตำแหน่งก่อนกด • งานล้มเหลวหรือยกเลิกจะกลับตำแหน่งก่อนวาร์ป"})
    speedControl=movement:CreateSlider({Name="ช่วงพักงาน (วินาที)",Range={0.35,15},CurrentValue=0.5,Increment=0.05,Callback=function(value) controller.settings.interval=math.max(0.35,value) end})
    movement:CreateButton({Name="หยุด Auto ทั้งหมด",Callback=function()
        controller.StopAll()
        for _,control in pairs(controls) do control:Set(false,true) end
    end})
    session:CreateButton({Name="บันทึกข้อมูลฐาน / Status Report",Callback=function()
        if type(writefile)~="function" then library:Notify({Title="DEVIL HUB",Content="ตัวรันไม่รองรับ writefile"});return end
        local report=controller.Inspect()
        local path="DevilVault_Report_"..os.date("%Y%m%d_%H%M%S")..".json"
        local saved,reason=pcall(function() writefile(path,game:GetService("HttpService"):JSONEncode(report)) end)
        library:Notify({Title="DEVIL HUB",Content=saved and ("บันทึกใน Workspace ตัวรัน: "..path) or tostring(reason)})
    end})
    session:CreateButton({Name="ตรวจระบบตอนนี้",Callback=function()
        local report=controller.Inspect()
        local enabled=0
        for _,item in ipairs(report.prompts) do if item.enabled then enabled+=1 end end
        library:Notify({Title="DEVIL HUB • ตรวจระบบ",Content="ฐาน: "..report.plot.."\nUserId: "..player.UserId.." • Prompts เปิด: "..enabled.."/"..#report.prompts.."\nVaultRemotes: "..tostring(storage:FindFirstChild("VaultRemotes")~=nil).."\nfireproximityprompt: "..tostring(type(fireproximityprompt)=="function"),Duration=12})
    end})
    session:CreateButton({Name="เก็บโค้ดระบบ Roll ลงไฟล์",Callback=function()
        if type(writefile)~="function" then library:Notify({Title="DEVIL HUB",Content="ตัวรันไม่รองรับ writefile"});return end
        task.spawn(function()
            local report=controller.Inspect()
            local records={}
            local remoteNames={}
            local roots={storage}
            local scripts=player:FindFirstChild("PlayerScripts")
            if scripts then roots[#roots+1]=scripts end
            local folder=storage:FindFirstChild("VaultRemotes")
            if folder then for _,item in ipairs(folder:GetDescendants()) do
                if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then remoteNames[#remoteNames+1]={name=item.Name,path=item:GetFullName(),class=item.ClassName} end
            end end
            for _,container in ipairs(roots) do
                for _,item in ipairs(container:GetDescendants()) do
                    if stopped then return end
                    if item:IsA("LocalScript") or item:IsA("ModuleScript") then
                        local name=item.Name:lower()
                        if name:find("roll",1,true) or name:find("prompt",1,true) or name:find("interact",1,true) or name=="main" or name=="bootstrap" or name=="init" then
                            local record={path=item:GetFullName(),class=item.ClassName,source=""}
                            local readOK,source=pcall(function() return item.Source end)
                            if readOK and type(source)=="string" and source~="" then record.source=source
                            elseif type(decompile)=="function" then
                                local decoded,result=pcall(decompile,item)
                                if decoded and type(result)=="string" then record.source=result else record.error=tostring(result) end
                            else record.error="Source unavailable; decompile unsupported" end
                            if #record.source>500000 then record.source=record.source:sub(1,500000);record.truncated=true end
                            records[#records+1]=record
                            task.wait()
                        end
                    end
                end
            end
            local path="DevilVault_RollCapture_"..os.date("%Y%m%d_%H%M%S")..".json"
            local saved,reason=pcall(function() writefile(path,game:GetService("HttpService"):JSONEncode({schema="devil-vault-roll-capture-1",report=report,remotes=remoteNames,scripts=records})) end)
            if not stopped then library:Notify({Title="DEVIL HUB",Content=saved and ("บันทึก "..#records.." Scripts: "..path) or tostring(reason),Duration=10}) end
        end)
    end})
    session:CreateButton({Name="Discord DEVIL HUB",Callback=function()
        if type(setclipboard)=="function" then setclipboard("https://discord.gg/ZY7PRcVJe2") end
        library:Notify({Title="DEVIL HUB",Content="https://discord.gg/ZY7PRcVJe2"})
    end})
    session:CreateButton({Name="ปิดสคริปต์และหยุดการเดิน",Callback=cleanup})
    task.spawn(function()
        while not stopped do
            local plot=controller.Plot()
            local upgradesActive=false
            for _,key in pairs(upgradeKeys) do if controller.flags[key] then upgradesActive=true end end
            upgradeMaster:Set(upgradesActive,true)
            local lines={"ฐาน: "..(plot and plot.Name or "รอเจ้าของฐาน"),"เงิน: "..tostring(cash() or "ยังอ่านไม่ได้")}
            if controller.status.roll and not controller.flags.roll then lines[#lines+1]=controller.status.roll end
            for _,key in ipairs({"roll","claim","gold","holders","damage","battery","luck","spots","daily"}) do
                if controller.flags[key] then lines[#lines+1]=(names[key] or key)..": "..(controller.status[key] or "พร้อม") end
            end
            pcall(function() statusWidget:Set(table.concat(lines,"\n"),true) end)
            task.wait(1)
        end
    end)
    task.spawn(function()
        while not stopped do
            controller.Step()
            task.wait(0.05)
        end
    end)
    library:Notify({Title="DEVIL HUB",Content="Destroy a Vault พร้อมแล้ว • เปิด Auto ที่ต้องการ",Duration=5})
    if hideOnStart then task.spawn(function()
        local deadline=os.clock()+10
        repeat task.wait(0.1) until stopped or window._introDone or os.clock()>=deadline
        if not stopped and window.Toggle then window:Toggle(false) end
    end) end
end,debug.traceback)
if not ok then cleanup();warn("DEVIL HUB startup failed: "..tostring(errorText)) end
