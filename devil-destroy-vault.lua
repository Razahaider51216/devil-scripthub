-- DEVIL HUB / Destroy a Vault. Observed gameplay actions and owned-plot prompts.
local shared = type(getgenv) == "function" and getgenv() or _G
if game.PlaceId ~= 91034536684382 and game.GameId ~= 10561166339 then
    warn("DEVIL HUB: This entry supports Destroy a Vault.")
    return
end
if shared.DevilVaultSession then pcall(shared.DevilVaultSession.Destroy) end
local stopped = false
local controller, library, window
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
local function interact(prompt, feedback, valid, walk, stationary, fastWarp)
    if stopped or not valid() or not prompt.Parent or not prompt.Enabled then return nil, "หยุด หรือ Prompt ยังไม่พร้อม" end
    local parent = prompt.Parent
    local position = parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position
    if not position then return nil, "ยังหาตำแหน่ง Prompt ไม่ได้" end
    local root, humanoid = rootPart()
    if not root or not humanoid or humanoid.Health <= 0 then return nil, "รอตัวละครเกิด" end
    local radius = math.max(1, prompt.MaxActivationDistance - 1)
    local returnPosition
    local targetPosition
    local originalRoot=root
    local function returnHome()
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
    return finish(false, (stationary and "โหมดยืนฟาร์มไม่มีผลยืนยัน เกมอาจตรวจระยะ: " or "ยังไม่มีผลยืนยันจากเกม: ") .. prompt.Name)
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
    local api = {running = true, flags = {}, settings = {interval = 0.5, minimumOdds = 1, reserve = 0, walk = false, stationary = false, fastWarp = true, stopAtRarity = false, stopRarities = {}}, status = {}, nextRun = {}, failures = {}}
    local claimed = {}
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
        return env.interact(item, {sequence = sequence, success = success, result = result}, function() return valid(job, plot) end, api.settings.walk, api.settings.stationary, api.settings.fastWarp)
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
    local function claim(plot)
        local allowed, reason = withinBudget()
        if not allowed then return nil, reason end
        if api.settings.reserve > 0 then return nil, "ราคาซื้อหุ่นยังอ่านไม่ครบ: ตั้งเงินสำรองเป็น 0 เพื่อเปิดการซื้อ" end
        for _, item in ipairs(plot:GetDescendants()) do
            if item:IsA("ProximityPrompt") and item.Name == "ClaimRobotPrompt" and item.Enabled then
                local surface = item.Parent
                local offer = attr(surface, "RollOfferId")
                local robot = attr(surface, "RollRobotId")
                local odds = number(attr(surface, "RollRobotOddsDenominator"))
                if offer and robot and odds and odds >= api.settings.minimumOdds and not claimed[offer] and attr(surface, "RollPedestalUnlocked") ~= false then
                    local ok, message = interact("claim", plot, item, "RobotClaimPurchaseFeedbackSequence", "PurchaseSucceeded", "PurchaseResult")
                    if ok then claimed[offer] = true end
                    return ok, message
                end
            end
        end
        return nil, "รอหุ่นตามเงื่อนไข Odds ที่เลือก"
    end
    local function roll(plot)
        -- Leave qualifying offers in place while the buyer is enabled.
        if api.flags.claim then
            for _, item in ipairs(plot:GetDescendants()) do
                if item:IsA("ProximityPrompt") and item.Name == "ClaimRobotPrompt" and item.Enabled then
                    local offer = attr(item.Parent, "RollOfferId")
                    local odds = number(attr(item.Parent, "RollRobotOddsDenominator"))
                    if offer and odds and odds >= api.settings.minimumOdds and not claimed[offer] then return nil, "รอรับหุ่นก่อน Roll รอบถัดไป" end
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
    local function upgrade(job)
        if api.settings.reserve > 0 then return nil, "ราคา Upgrade ยังอ่านไม่ครบ: ตั้งเงินสำรองเป็น 0 เพื่อเปิดการซื้อ" end
        local board = boards[job]
        if not env.pathExists(board[2]) then return nil, "ไม่พบป้าย Upgrade ตามข้อมูลที่จับไว้" end
        return invoke("UpgradeBoardAction", board[1], board[2], 1)
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
                api.nextRun[job] = env.now() + api.settings.interval
                local plot = job ~= "daily" and api.Plot() or nil
                if job ~= "daily" and not plot then api.status[job] = "รอฐานของผู้เล่น"; return end
                local executed, ok, message = pcall(function()
                    if job == "gold" then return gold(plot) end
                    if job == "claim" then return claim(plot) end
                    if job == "roll" then return roll(plot) end
                    if job == "holders" then return holders(plot) end
                    if job == "daily" then return invoke("DailyRewardsAction", "Claim") end
                    return upgrade(job)
                end)
                if not executed then message, ok = tostring(ok), false end
                if not api.running or not api.flags[job] then return end
                api.status[job] = message or "ไม่มีผลตอบกลับ"
                api.nextRun[job] = env.now() + (job == "daily" and 120 or (ok == false and 15 or api.settings.interval))
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
        local prompts, holders, offers, plots = {}, {}, {}, {}
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
        return {placeId = env.placeId, userId = env.userId, plot = plot and plot:GetFullName() or "Not found", plots = plots, cash = env.cash(), prompts = prompts, holders = holders, offers = offers, status = api.status, settings = api.settings}
    end
    return api
end

end)()
local names = {gold="เก็บทอง / ฝากหลอม",claim="รับ / ซื้อหุ่น",roll="Roll",holders="ซื้อช่องวางหุ่น",damage="Damage",battery="Battery",luck="Roll Luck",spots="Roll Spots",daily="Daily"}
controller = factory({
    userId = player.UserId, placeId = game.PlaceId,
    plotRoot = function() return workspace:FindFirstChild("playable") end,
    now = os.clock, cash = cash, interact = interact, invoke = remoteCall,
    offerRarity = offerRarity,
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
    local progression=window:CreateTab({Name="Progression",Icon="trending-up"})
    local settings=window:CreateTab({Name="Settings",Icon="settings"})
    local farm=main:CreateGroupbox({Name="Roll & Robots",Icon="dices",Side="Left"})
    local economy=main:CreateGroupbox({Name="Gold & Rewards",Icon="coins",Side="Right"})
    local upgrades=progression:CreateGroupbox({Name="Auto Upgrades",Icon="trending-up",Side="Left"})
    local holders=progression:CreateGroupbox({Name="Robot Slots",Icon="layout-grid",Side="Right"})
    local movement=settings:CreateGroupbox({Name="Movement & Timing",Icon="navigation",Side="Left"})
    local session=settings:CreateGroupbox({Name="Session",Icon="activity",Side="Right"})
    local modeControl,speedControl
    local function toggle(group,key,title)
        local ready=false
        controls[key]=group:CreateToggle({Name=title,CurrentValue=false,Callback=function(value) if ready and not stopped then controller.Set(key,value) end end})
        ready=true
    end
    farm:CreateParagraph({Name="Owned base only",Content="เลือกฐานจากเจ้าของจริง • ซื้อหุ่นใช้เงินในเกม • ทุก Auto เริ่มปิด"})
    toggle(farm,"roll","Auto Roll")
    toggle(farm,"claim","Auto รับ / ซื้อหุ่นที่สุ่มได้")
    farm:CreateButton({Name="เริ่มฟาร์มเร็ว • Roll + รับหุ่น + ทอง",Callback=function()
        if stopped then return end
        controller.settings.fastWarp=true
        controller.settings.stationary=false
        controller.settings.walk=false
        controller.settings.interval=0.5
        if modeControl then modeControl:Set({"Fast • วาร์ปไปกดแล้วกลับ"},true) end
        if speedControl then speedControl:Set(0.5,true) end
        for _,key in ipairs({"roll","claim","gold"}) do
            controller.Set(key,true)
            controls[key]:Set(true,true)
        end
        library:Notify({Title="DEVIL HUB",Content="เปิดฟาร์มเร็วแล้ว • รับหุ่นใช้เงินในเกม",Duration=4})
    end})
    farm:CreateInput({Name="รับเฉพาะ Odds 1 ใน X ขึ้นไป",CurrentValue="1",PlaceholderText="เช่น 1000",Numeric=true,Callback=function(value)
        controller.settings.minimumOdds=math.max(1,tonumber(value) or 1)
    end})
    farm:CreateToggle({Name="หยุด Roll เมื่อพบระดับที่เลือก",CurrentValue=false,Callback=function(value) controller.settings.stopAtRarity=value==true end})
    local rarityControl
    rarityControl=farm:CreateDropdown({Name="ระดับที่ให้หยุด (เลือกได้หลายระดับ)",Options=rarityNames,CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,Callback=function(value)
        local selected={}
        if type(value)=="table" then
            for key,entry in pairs(value) do
                if type(key)=="number" and type(entry)=="string" then selected[entry]=true
                elseif type(key)=="string" and entry==true then selected[key]=true end
            end
        elseif type(value)=="string" then selected[value]=true end
        controller.settings.stopRarities=selected
    end})
    farm:CreateParagraph({Name="Stop at rarity",Content="อ่านระดับจาก Rarity ของหุ่นในผล Roll จริง • หยุดเฉพาะ Auto Roll • เก็บทองและรับหุ่นยังทำต่อได้"})
    farm:CreateParagraph({Name="Roll control",Content="เมื่อเปิดรับหุ่น ระบบจะรอซื้อผลที่เข้าเงื่อนไขก่อน Roll ต่อ หากไม่มีเงินหรือช่องวาง ให้ปิดรับหุ่นหรือแก้เงื่อนไข"})
    toggle(economy,"gold","Auto เก็บทอง → ฝากเข้าหลอม")
    toggle(economy,"daily","Auto รับ Daily Reward")
    local statusWidget=economy:CreateParagraph({Name="Status",Content="กำลังตรวจฐาน..."})
    for _,key in ipairs({"damage","battery","luck","spots"}) do toggle(upgrades,key,"Auto Upgrade "..names[key]) end
    upgrades:CreateParagraph({Name="Purchase pace",Content="ส่งทีละคำขอ • ยังไม่ทราบราคา Upgrade ล่วงหน้า • เกมเป็นผู้ตรวจเงินและเพดานระดับ"})
    toggle(holders,"holders","Auto ซื้อช่องวางหุ่นที่ราคาเอื้อมถึง")
    holders:CreateInput({Name="เงินสำรอง",CurrentValue="0",Numeric=true,Callback=function(value) controller.settings.reserve=math.max(0,tonumber(value) or 0) end})
    holders:CreateParagraph({Name="Budget",Content="เงินสำรองใช้กับช่องวางที่อ่านราคาได้ หากตั้งมากกว่า 0 จะพักการซื้อหุ่นและ Upgrade ซึ่งยังอ่านราคาไม่ครบ"})
    local holderId=""
    holders:CreateInput({Name="ID ช่องสำหรับ Upgrade ครั้งเดียว",CurrentValue="",PlaceholderText="robot_holder_6",Callback=function(value) holderId=tostring(value) end})
    holders:CreateButton({Name="Upgrade ช่องที่ระบุครั้งเดียว",Callback=function()
        if stopped then return end
        local plot=controller.Plot()
        local found=false
        if plot then for _,item in ipairs(plot:GetDescendants()) do if item:GetAttribute("RobotHolderId")==holderId and item:GetAttribute("Unlocked")==true then found=true;break end end end
        if not found then library:Notify({Title="DEVIL HUB",Content="ไม่พบช่องที่ปลดล็อกในฐานของเรา"});return end
        task.spawn(function() local _,message=remoteCall("RobotHolderAction","Upgrade",holderId,1);if not stopped then library:Notify({Title="DEVIL HUB",Content=message}) end end)
    end})
    modeControl=movement:CreateDropdown({Name="โหมดทำงาน",Options={"Fast • วาร์ปไปกดแล้วกลับ","ยืนฟาร์ม (ไม่เดิน)","เดินเข้าใกล้ Prompt","เฉพาะจุดที่อยู่ในระยะ"},CurrentOption={"Fast • วาร์ปไปกดแล้วกลับ"},Callback=function(value)
        if type(value)=="table" then value=value[1] end
        controller.settings.stationary=value=="ยืนฟาร์ม (ไม่เดิน)"
        controller.settings.walk=value=="เดินเข้าใกล้ Prompt"
        controller.settings.fastWarp=value=="Fast • วาร์ปไปกดแล้วกลับ"
        stopMovement()
    end})
    movement:CreateParagraph({Name="Fast farming",Content="วาร์ปเข้าใกล้จุดกดแล้วกลับตำแหน่งเดิม • ไม่วิ่ง • รอผลจากเกมก่อนรอบถัดไป"})
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
    session:CreateButton({Name="Discord DEVIL HUB",Callback=function()
        if type(setclipboard)=="function" then setclipboard("https://discord.gg/ZY7PRcVJe2") end
        library:Notify({Title="DEVIL HUB",Content="https://discord.gg/ZY7PRcVJe2"})
    end})
    session:CreateButton({Name="ปิดสคริปต์และหยุดการเดิน",Callback=cleanup})
    task.spawn(function()
        while not stopped do
            local plot=controller.Plot()
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
end,debug.traceback)
if not ok then cleanup();warn("DEVIL HUB startup failed: "..tostring(errorText)) end
