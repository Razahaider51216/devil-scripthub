-- Fishing Master v11 / Ouroboros backend plus island travel and catch dismissal
local Loading=(function()
-- Release loading overlay shared by the small loader and protected entry point.
local Loading = {}
function Loading.Begin()
    local env = type(getgenv)=="function" and getgenv() or _G
    local current = env.DevilFishingTestLoading
    if current and current.Gui and current.Gui.Parent and not current.Failed then return current end
    if current and current.Destroy then current:Destroy() end
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local screen = Instance.new("ScreenGui")
    screen.Name = "DevilFishingTestLoading"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 10001
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    local function make(class,parent,properties)
        local object = Instance.new(class)
        for key,value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function corner(parent,radius) make("UICorner",parent,{CornerRadius = UDim.new(0,radius)}) end
    local shade = make("Frame",screen,{Size = UDim2.fromScale(1,1),BackgroundColor3 = Color3.fromRGB(0,0,0),BackgroundTransparency = .35,BorderSizePixel = 0,Active = true})
    local panel = make("Frame",shade,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(.5,.5),Size = UDim2.new(.86,0,0,270),BackgroundColor3 = Color3.fromRGB(8,14,22),BorderSizePixel = 0})
    make("UISizeConstraint",panel,{MaxSize = Vector2.new(420,270)})
    corner(panel,16)
    -- Keep this overlay independent of the native library stroke scaler.
    local logo = make("ImageLabel",panel,{AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,17),Size = UDim2.fromOffset(76,64),BackgroundTransparency = 1,Image = "",ScaleType = Enum.ScaleType.Fit})
    corner(logo,9)
    local title = make("TextLabel",panel,{Position = UDim2.fromOffset(20,92),Size = UDim2.new(1,-40,0,30),BackgroundTransparency = 1,Text = "DEVIL HUB / FISHING MASTER",Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = Color3.fromRGB(56,148,255)})
    local status = make("TextLabel",panel,{Position = UDim2.fromOffset(20,131),Size = UDim2.new(1,-40,0,37),BackgroundTransparency = 1,Text = "Preparing your session...",Font = Enum.Font.Gotham,TextSize = 12,TextColor3 = Color3.fromRGB(187,161,179),TextWrapped = true})
    local track = make("Frame",panel,{Position = UDim2.fromOffset(28,181),Size = UDim2.new(1,-56,0,5),BackgroundColor3 = Color3.fromRGB(52,29,44),BorderSizePixel = 0})
    corner(track,3)
    local fill = make("Frame",track,{Size = UDim2.fromScale(.04,1),BackgroundColor3 = Color3.fromRGB(56,148,255),BorderSizePixel = 0})
    corner(fill,3)
    local detail = make("TextLabel",panel,{Position = UDim2.fromOffset(20,203),Size = UDim2.new(1,-40,0,20),BackgroundTransparency = 1,Text = "DEVIL HUB / FISHING MASTER / STARTING",Font = Enum.Font.Gotham,TextSize = 9,TextColor3 = Color3.fromRGB(120,98,113)})
    local actions = make("Frame",panel,{Position = UDim2.new(0,24,1,-42),Size = UDim2.new(1,-48,0,28),BackgroundTransparency = 1,Visible = false})
    local function action(text,x)
        local button = make("TextButton",actions,{Position = UDim2.new(x,0,0,0),Size = UDim2.new(.48,0,1,0),Text = text,Font = Enum.Font.GothamMedium,TextSize = 11,TextColor3 = Color3.new(1,1,1),BackgroundColor3 = Color3.fromRGB(65,29,44),BorderSizePixel = 0,AutoButtonColor = false})
        corner(button,6)
        return button
    end
    local retry,close = action("Retry",0),action("Close",.52)
    local controller = {Gui = screen,HoldHub = true,Busy = false,PayloadRunning = false,Failed = false,Progress = 0,Connections = {}}
    env.DevilFishingTestLoading = controller
    local animation
    function controller:SetStage(message,progress)
        if not screen.Parent then return end
        self.Progress = math.max(self.Progress,math.clamp(progress or self.Progress,0,1))
        status.Text = message
        detail.Text = string.format("DEVIL HUB / FISHING MASTER / %d%%",math.floor(self.Progress*100))
        if animation then animation:Cancel() end
        animation = TweenService:Create(fill,TweenInfo.new(.18),{Size = UDim2.fromScale(self.Progress,1)})
        animation:Play()
    end
    function controller:Destroy()
        self.HoldHub = false self.Busy = false
        if animation then animation:Cancel() end
        for _,connection in ipairs(self.Connections) do connection:Disconnect() end
        if env.DevilFishingTestLoading == self then env.DevilFishingTestLoading = nil end
        if screen.Parent then screen:Destroy() end
    end
    function controller:Finish(success,message)
        self.Busy = false self.HoldHub = false self.PayloadRunning = false
        if success then
            self:SetStage("Ready. Welcome to Devil Hub.",1)
            self:Destroy()
        else
            self.Failed = true
            status.Text = message or "Unable to start. Please retry."
            detail.Text = "LOAD FAILED / CHECK CONSOLE"
            actions.Visible = true
        end
    end
    table.insert(controller.Connections,close.Activated:Connect(function() controller:Destroy() end))
    table.insert(controller.Connections,retry.Activated:Connect(function()
        if controller.Busy or not screen.Parent then return end
        controller.Busy=true controller.Failed=false actions.Visible=false
        controller:SetStage("Downloading Fishing Master test...",.08)
        task.spawn(function()
            local ok,err = pcall(function()
                local run,parseError = loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=11"),"Devil Hub / Retry")
                assert(run,parseError)
                if not screen.Parent then return end
                controller:Destroy()
                run()
            end)
            if not ok then
                if screen.Parent then controller:Finish(false,"Retry failed. Check your connection.") end
                warn("[Devil Hub] Retry failed: "..tostring(err))
            end
        end)
    end))
    task.spawn(function()
        local custom = getcustomasset or getsynasset
        if type(custom) ~= "function" or type(writefile) ~= "function" then return end
        local ok,asset = pcall(function()
            local path = "devil-hub-logo-daceb9cac221.png"
            if type(isfile) ~= "function" or not isfile(path) then
                local data = game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png")
                assert(data:sub(1,8) == "\137PNG\13\10\26\10") writefile(path,data)
            end
            return custom(path)
        end)
        if ok and screen.Parent then logo.Image = asset end
    end)
    return controller
end
return Loading

end)()
local CompatFactory=(function()
-- Fishing Master client compatibility and automation orchestration.
-- Uses existing client callbacks. No server validation or cooldown bypass.
return function(deps)
	local input = deps.Input
	local player = deps.Player
	local clock = deps.Clock or os.clock
	local wait = deps.Wait or (task and task.wait)
	local fire = deps.FireSignal
	local connections = deps.GetConnections
	local letters = { "Z", "X", "C", "V" }
	local digits = { "One", "Two", "Three", "Four" }
	local cycleFlags = {
		"AutoPerfectCast",
		"AutoMinigame",
		"AutoEquipBestRod",
		"SkillSlot1",
		"SkillSlot2",
		"SkillSlot3",
		"SkillSlot4",
		"AutoSkills",
	}
	local allFlags = {
		"AutoSkills",
		"AutoPerfectCast",
		"AutoMinigame",
		"AutoEquipBestRod",
		"AutoBuyRod",
		"AutoDaily",
		"AutoSell",
		"AutoSellRarities",
		"AutoRollSkill",
		"AutoRollAura",
		"AutoRollChest",
		"AutoReconnect",
	}
	local self =
		{ LastSkill = {}, Stopped = false, Active = false, PauseTyping = true, PauseRespawn = true, Duration = 0 }
	local function child(parent, name, recursive)
		return parent and parent:FindFirstChild(name, recursive) or nil
	end
	local function visible(object)
		local current = object
		while current do
			if current:IsA("GuiObject") and not current.Visible then
				return false
			end
			if current:IsA("ScreenGui") and not current.Enabled then
				return false
			end
			current = current.Parent
		end
		return object ~= nil
	end
	function self:RodGui()
		return child(child(player, "PlayerGui"), "Rod")
	end
	function self:IsMobile()
		local rod = self:RodGui()
		local mobile, desktop = child(rod, "Mobile"), child(rod, "Desktop")
		if visible(mobile) ~= visible(desktop) then
			return visible(mobile)
		end
		local ok, preferred = pcall(function()
			return input.PreferredInput
		end)
		if ok and preferred then
			return tostring(preferred):match("Touch$") ~= nil
		end
		local lastOk, last = pcall(input.GetLastInputType, input)
		if lastOk and last then
			if tostring(last):match("Touch$") then
				return true
			end
			if tostring(last):match("Keyboard$") or tostring(last):match("Mouse") then
				return false
			end
		end
		return input.TouchEnabled and not input.KeyboardEnabled
	end
	function self:SkillLabel(slot)
		if self:IsMobile() then
			return tostring(slot) .. " / " .. letters[slot]
		end
		return letters[slot] .. " / " .. tostring(slot)
	end
	function self:SlotButton(slot)
		local slots = child(child(self:RodGui(), "Mobile"), "Slots")
		local button = child(slots, "Slot" .. slot)
		return button and button:IsA("GuiButton") and button or nil
	end
	function self:SlotReady(slot)
		local rod = self:RodGui()
		local slotGui
		if self:IsMobile() then
			slotGui = self:SlotButton(slot)
		else
			slotGui = child(child(rod, "Desktop"), "Slot" .. slot)
		end
		if not slotGui then
			return true
		end -- Unknown UI does not fabricate a cooldown.
		for _, node in ipairs(slotGui:GetDescendants()) do
			if node.Name == "Locked" and node:IsA("GuiObject") and node.Visible then
				return false
			end
			if node.Name == "Timer" and node:IsA("TextLabel") and node.Visible then
				local remaining = tonumber(node.Text)
				if remaining and remaining > 0 then
					return false
				end
			end
		end
		return true
	end
	function self:MobileCallback(slot)
		if type(fire) ~= "function" or type(connections) ~= "function" then
			return nil
		end
		local button = self:SlotButton(slot)
		if not button or not visible(button) then
			return nil
		end
		-- Choose one registered click signal; never fire both for the same skill.
		for _, name in ipairs({ "Activated", "MouseButton1Click" }) do
			local signal = button[name]
			local ok, listeners = pcall(connections, signal)
			if ok and type(listeners) == "table" then
				for _, listener in pairs(listeners) do
					if listener.Enabled ~= false and listener.Connected ~= false then
						return function()
							fire(signal, nil, 1)
						end
					end
				end
			end
		end
		return nil
	end
	function self:SkillCallback(context, slot)
		if self.Stopped or not letters[slot] or not self:SlotReady(slot) then
			return nil
		end
		local keys = context and context.Keybinds and context.Keybinds.Keys
		local callback
		if type(keys) == "table" then
			local canonical = keys["Slot" .. slot]
			if type(canonical) == "table" and type(canonical.callback) == "function" then
				callback = canonical.callback
			end
		end
		if not callback and self:IsMobile() then
			callback = self:MobileCallback(slot)
		end
		if not callback and type(keys) == "table" then
			-- Slot identity is primary; key labels are compatibility fallbacks.
			local names = self:IsMobile() and { tostring(slot), digits[slot], letters[slot] }
				or { letters[slot], tostring(slot), digits[slot] }
			for _, name in ipairs(names) do
				local entry = keys[name]
				if type(entry) == "table" and type(entry.callback) == "function" then
					callback = entry.callback
					break
				end
			end
			if not callback and deps.KeyCode then
				for _, name in ipairs({ letters[slot], digits[slot] }) do
					local entry = keys[deps.KeyCode[name]]
					if type(entry) == "table" and type(entry.callback) == "function" then
						callback = entry.callback
						break
					end
				end
			end
		end
		if not callback then
			callback = self:MobileCallback(slot)
		end
		if not callback then
			self.SkillStatus = "No registered callback for slot " .. slot
			return nil
		end
		return function(...)
			if self.Stopped or not self:SlotReady(slot) or input:GetFocusedTextBox() then
				return
			end
			local now = clock()
			if self.LastSkill[slot] and now - self.LastSkill[slot] < 0.35 then
				return
			end
			self.LastSkill[slot] = now
			local values = table.pack(pcall(callback, ...))
			if not values[1] then
				self.SkillStatus = "Slot " .. slot .. ": " .. tostring(values[2])
				return -- Do not retry another input path after a partially executed callback.
			end
			self.SkillStatus = "Slot " .. slot .. " (" .. self:SkillLabel(slot) .. ")"
			return table.unpack(values, 2, values.n)
		end
	end
	function self:Control(name)
		return self.Library and self.Library.Flags and self.Library.Flags[name]
	end
	function self:HoldCast(phase)
		return (phase == "Idling" and self.TravelBusy==true) or phase == "Idling" and self.SellTicket ~= nil and not self.SellTicket.Cancelled and not self.Stopped
	end
	function self:RestoreSellPosition(ticket)
		if not ticket or not ticket.Root then
			return
		end
		local root, frame = ticket.Root, ticket.Frame
		ticket.Root, ticket.Frame = nil, nil
		-- A replaced character must never inherit the old character's position.
		if root.Parent and ticket.Context.GetRoot() == root then
			local ok, err = pcall(function()
				root.CFrame = frame
			end)
			if not ok then
				self.SellStatus = "Return failed: " .. tostring(err)
			end
		end
	end
	function self:SaleSnapshot(context)
		local ok, data = pcall(context.GetData)
		if not ok or type(data) ~= "table" then
			return nil
		end
		-- Coin is the replicated field used by the original runtime. Optional
		-- inventory schemas are read only when they actually contain fish records.
		local snapshot = { Coin = type(data.Coin) == "number" and data.Coin or nil }
		local paths =
			{ { "Fish" }, { "Fishes" }, { "FishInventory" }, { "Inventory", "Fish" }, { "Inventory", "Fishes" } }
		for _, path in ipairs(paths) do
			local records = data
			for _, key in ipairs(path) do
				records = type(records) == "table" and records[key] or nil
			end
			if type(records) == "table" then
				local count, valid = 0, true
				for _, record in pairs(records) do
					if type(record) ~= "table" or type(record.fishId or record.FishId) ~= "string" then
						valid = false
						break
					end
					local protected = record.favorite == true
						or record.Favorite == true
						or record.locked == true
						or record.Locked == true
					if not protected then
						count += 1
					end
				end
				if valid then
					snapshot.Count = count
					snapshot.Path = table.concat(path, ".")
					break
				end
			end
		end
		return snapshot
	end
	function self:WaitForSale(context, ticket, method, controller, allowed)
		local before = self:SaleSnapshot(context)
		if not before or before.Coin == nil then
			self.SellStatus = "Waiting for player balance before selling"
			while allowed() and (not before or before.Coin == nil) do
				wait(0.25)
				before = self:SaleSnapshot(context)
			end
		end
		if not allowed() then
			return false
		end
		local attempts, lastAttempt, lastChange = 0, -math.huge, clock()
		local observedCoin, observedCount = before.Coin, before.Count
		local evidence = false
		while allowed() do
			if ticket.Root and (not ticket.Root.Parent or context.GetRoot() ~= ticket.Root) then
				self.SellStatus = "Character changed; sell cancelled"
				return false
			end
			local current = self:SaleSnapshot(context)
			local sameInventory = current
				and before.Path ~= nil
				and current.Path == before.Path
				and current.Count ~= nil
			local paid = current and current.Coin ~= nil and current.Coin > before.Coin
			local emptied = sameInventory and before.Count > 0 and current.Count == 0
			-- A recognized inventory must finish selling, including batched updates.
			-- Otherwise use the replicated Coin increase as the available receipt.
			evidence = before.Path ~= nil and emptied or before.Path == nil and paid
			if current and (current.Coin ~= observedCoin or sameInventory and current.Count ~= observedCount) then
				observedCoin = current.Coin
				observedCount = current.Count
				lastChange = clock()
			end
			if evidence then
				self.SellStatus = "Sale update received; waiting for updates to finish"
				if clock() - lastChange >= 2 and context.Phase() == "Idling" then
					self.SellStatus = "Sale confirmed; returning to fishing spot"
					return true
				end
			elseif attempts < 3 and clock() - lastAttempt >= 5 and context.Phase() == "Idling" then
				attempts += 1
				lastAttempt = clock()
				lastChange = clock()
				local sent, err = pcall(method, controller)
				if not sent then
					self.SellStatus = "Sell request failed: " .. tostring(err)
				else
					self.SellStatus = "Waiting for sale payment (attempt " .. attempts .. "/3)"
				end
			elseif attempts >= 3 and clock() - lastAttempt >= 5 then
				self.SellStatus = "No sale confirmation yet; staying at seller. Stop All cancels."
			end
			wait(0.25)
		end
		self.SellStatus = "Sell cancelled"
		return false
	end
	function self:SellOnce(context)
		if self.Stopped or self.SellTicket then
			return false
		end
		local ticket = { Context = context }
		self.SellTicket = ticket
		local function allowed()
			return not self.Stopped
				and not ticket.Cancelled
				and not context.Runtime.Unloaded
				and context.State.autoSell == true
		end
		local ok, result = pcall(function()
			local services = context.Services
			local controller = services and services.Controllers and services.Controllers.SellController
			assert(controller, "SellController unavailable")
			self.SellStatus = "Waiting for fishing to finish"
			local deadline = clock() + 45
			while allowed() and context.Phase() ~= "Idling" and clock() < deadline do
				wait(0.1)
			end
			if not allowed() then
				self.SellStatus = "Sell cancelled"
				return false
			end
			if context.Phase() ~= "Idling" then
				self.SellStatus = "Fishing still busy; retry next sell interval"
				return false
			end
			local data = context.GetData()
			assert(type(data) == "table", "Player data unavailable")
			local inventory = self:SaleSnapshot(context)
			if inventory and inventory.Count == 0 then
				self.SellStatus = "No sellable fish"
				return false
			end
			local entitlement = services.SellConfig and services.SellConfig.SellAnywhereEntitlement
			if
				entitlement
				and type(data.Entitlements) == "table"
				and data.Entitlements[entitlement] == true
				and type(controller.SellAllAnywhere) == "function"
			then
				return self:WaitForSale(context, ticket, controller.SellAllAnywhere, controller, allowed)
			end
			assert(type(controller.SellAll) == "function", "SellAll method unavailable")
			local root = context.GetRoot()
			assert(root and root.Parent, "Character root unavailable")
			local seller = context.FindSeller(root.Position)
			assert(seller, "No fish seller streamed in nearby islands")
			ticket.Root, ticket.Frame = root, root.CFrame
			self.SellStatus = "Moving to fish seller"
			root.CFrame = deps.SellerCFrame(seller)
			wait(0.6)
			if not allowed() or context.GetRoot() ~= root or not root.Parent then
				self.SellStatus = "Sell cancelled or character changed"
				return false
			end
			if context.Phase() ~= "Idling" then
				self.SellStatus = "Fishing restarted; sell skipped"
				return false
			end
			return self:WaitForSale(context, ticket, controller.SellAll, controller, allowed)
		end)
		local restored, restoreError = pcall(self.RestoreSellPosition, self, ticket)
		if self.SellTicket == ticket then
			self.SellTicket = nil
		end
		if not restored then
			self.SellStatus = "Return failed: " .. tostring(restoreError)
		end
		if not ok then
			self.SellStatus = "Sell failed: " .. tostring(result)
			return false
		end
		return result
	end
	function self:ApplySellRarities(context)
		if self.Stopped or context.Runtime.Unloaded then
			return
		end
		local services, state = context.Services, context.State
		local config = services and services.AutoSellConfig
		if
			not config
			or type(config.Order) ~= "table"
			or type(config.SettingName) ~= "function"
			or not services.SetSettings
			or type(services.SetSettings.Fire) ~= "function"
		then
			self.RarityStatus = "Auto sell setting contract unavailable"
			return
		end
		local data = context.GetData()
		if type(data) ~= "table" then
			self.RarityStatus = "Waiting for player data"
			return
		end
		local current = type(data.Settings) == "table" and data.Settings.AutoSell
		local hasAcknowledgement = type(current) == "table"
		self.SellSettingAttempts = self.SellSettingAttempts or {}
		self.RarityError = nil
		local pending = 0
		for _, rarity in ipairs(config.Order) do
			local name = config.SettingName(rarity)
			if type(name) ~= "string" or name == "" then
				self.RarityStatus = "Invalid setting for rarity " .. tostring(rarity)
				return
			end
			local desired = state.autoSellRarities == true and state.sellRarities[rarity] == true
			local attempt = self.SellSettingAttempts[rarity]
			if hasAcknowledgement and (current[name] == true) == desired then
				self.SellSettingAttempts[rarity] = nil
				state.sellApplied[rarity] = desired and true or nil
			else
				if not attempt or attempt.Desired ~= desired then
					attempt = { Desired = desired, Count = 0, At = -math.huge }
					self.SellSettingAttempts[rarity] = attempt
				end
				pending += 1
				state.sellApplied[rarity] = true -- Pending intent, not a confirmed server update.
				if attempt.Count < 3 and clock() - attempt.At >= 5 then
					attempt.At = clock()
					attempt.Count += 1
					local sent, err = pcall(services.SetSettings.Fire, services.SetSettings, name, desired)
					if not sent then
						self.RarityError = tostring(err)
					end
				end
				if not desired and attempt.Count >= 3 then
					state.sellApplied[rarity] = nil
				end
			end
		end
		self.RarityStatus = pending == 0 and "Rarity settings confirmed"
			or "Waiting for rarity setting confirmation (" .. pending .. ")"
		if state.autoSellRarities == true and next(state.sellRarities) == nil then
			self.RarityStatus = "Select one or more rarities in Selling"
		end
		if self.RarityError then
			self.RarityStatus = "Rarity settings: " .. self.RarityError
		end
	end
	function self:Write(name, value)
		local control = self:Control(name)
		if control and type(control.Set) == "function" then
			local ok, err = pcall(control.Set, control, value)
			if not ok then
				self.Status = name .. ": " .. tostring(err)
			end
			return ok
		end
		return false
	end
	function self:SetCycle(enabled)
		if self.Stopped or enabled == self.Active then
			return
		end
		if enabled then
			for _, name in ipairs(cycleFlags) do
				local control = self:Control(name)
				if not control or type(control.Get) ~= "function" or type(control.Set) ~= "function" then
					self.Status = "Missing native control: " .. name
					if self.CycleControl then
						self.CycleControl:Set(false, true)
					end
					return
				end
			end
			self.Snapshot = {}
			for _, name in ipairs(cycleFlags) do
				self.Snapshot[name] = self:Control(name):Get()
			end
			self.Active = true
			self.StartedAt = clock()
			self.Paused = nil
			self:Update()
		else
			self.Active = false
			self.Paused = nil
			for _, name in ipairs(cycleFlags) do
				self:Write(name, self.Snapshot[name])
			end
			self.Snapshot = nil
			self.Status = "Idle"
		end
	end
	function self:StopAll()
		if self.SellTicket then
			self.SellTicket.Cancelled = true
			pcall(self.RestoreSellPosition, self, self.SellTicket)
		end
		self:SetCycle(false)
		if self.CycleControl then
			self.CycleControl:Set(false, true)
		end
		for _, name in ipairs(allFlags) do
			self:Write(name, false)
		end
		self.Status = "All automation stopped"
	end
	function self:Update()
		if self.Stopped or not self.Active then
			return
		end
		if self.Duration > 0 and clock() - self.StartedAt >= self.Duration * 60 then
			self:StopAll()
			self.Status = "Session timer completed"
			return
		end
		local typing = self.PauseTyping and input:GetFocusedTextBox() ~= nil
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local respawn = self.PauseRespawn
			and (not character or not character.Parent or not humanoid or humanoid.Health <= 0)
		local paused = typing or respawn or self.TravelBusy==true
		if paused ~= self.Paused then
			self.Paused = paused
			for _, name in ipairs(cycleFlags) do
				self:Write(name, not paused)
			end
		end
		self.Status = typing and "Paused while typing" or respawn and "Waiting for character" or "Fishing cycle active"
	end
	function self:Attach(library, window)
		self.Library = library
		local tab = window:CreateTab({ Name = "Automation+", Icon = "zap" })
		local cycle = tab:AddLeftGroupbox({ Name = "Fishing Cycle", Icon = "fish" })
		self.CycleControl = cycle:CreateToggle({
			Name = "Auto Fishing Cycle",
			CurrentValue = false,
			Callback = function(value)
				self:SetCycle(value)
			end,
		})
		cycle:CreateLabel({ Name = "Perfect cast, minigame, four skills and best owned rod." })
		cycle:CreateToggle({
			Name = "Pause While Typing",
			CurrentValue = true,
			Callback = function(value)
				self.PauseTyping = value
				self:Update()
			end,
		})
		cycle:CreateToggle({
			Name = "Pause During Respawn",
			CurrentValue = true,
			Callback = function(value)
				self.PauseRespawn = value
				self:Update()
			end,
		})
		cycle:CreateSlider({
			Name = "Auto Stop After (minutes; 0 = unlimited)",
			Range = { 0, 180 },
			Increment = 1,
			CurrentValue = 0,
			Callback = function(value)
				self.Duration = value
			end,
		})
		cycle:CreateLabel({
			Name = "Idle",
			Update = function()
				return self.Status or "Idle"
			end,
			UpdateRate = 0.5,
		})
		local controls = tab:AddRightGroupbox({ Name = "Skills & Controls", Icon = "sparkles" })
		controls:CreateLabel({ Name = "Skills: Z / 1, X / 2, C / 3, V / 4" })
		controls:CreateLabel({
			Name = "Input mode",
			Update = function()
				return self:IsMobile() and "Mobile: 1 2 3 4" or "Desktop: Z X C V"
			end,
			UpdateRate = 0.5,
		})
		controls:CreateLabel({
			Name = "Skill status",
			Update = function()
				return self.SkillStatus or "Waiting for a skill"
			end,
			UpdateRate = 0.5,
		})
		controls:CreateLabel({
			Name = "Sell status",
			Update = function()
				return self.SellStatus or "Auto Sell idle"
			end,
			UpdateRate = 0.5,
		})
		controls:CreateLabel({
			Name = "Rarity status",
			Update = function()
				return self.RarityStatus or "Select rarities in Selling"
			end,
			UpdateRate = 0.5,
		})
		controls:CreateButton({
			Name = "Stop All Automation",
			Callback = function()
				self:StopAll()
			end,
		})
		local elapsed = 0
		self.Connection = deps.Heartbeat:Connect(function(dt)
			elapsed += dt
			if elapsed < 0.25 then
				return
			end
			elapsed = 0
			self:Update()
		end)
	end
	function self:Stop()
		if self.Stopped then
			return
		end
		self:StopAll()
		self.Stopped = true
		if self.Connection then
			self.Connection:Disconnect()
			self.Connection = nil
		end
	end
	return self
end

end)()
local function PatchFishing(source)
do
local before=[====[function(g,aa,z)local R,J,q,au,ak=nil,nil,nil,nil,nil;local ah=nil;local c8=aV;ah=7;while true do ah+=276.;if ah<1437. then if ah<281 then if ah<278 then if ah<277 then if ah==276. then R=x[c8[91]][c8[595]][c8[332]..g];ah=3. else break end else local c9=c8[673];local da=q*au;ah=if(q*c8[223]+au*c8[781]+da)%c9==c8[391]then 9. else 2 end elseif ah<279. then return nil elseif ah<280 then if ah==279. then J=R;R=((function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(type(J),c8[711.],c8[416],c8[272]));ah=if R then 4 else 8 else ah=2655.;continue end else R=(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(type(J[c8[153.]]),c8[107],c8[586],c8[745]);ah=8 end elseif ah<283 then if ah<282. then local db=c8[60.]-ak;au=c8[127]*ak+c8[335]*db;ah=1 else break end elseif ah<284 then if ah==283 then R=x[c8[91]][c8[595]];ah=if R then 0. else 3. else ah=284;continue end elseif ah<285. then if ah==284 then ak=if R then c8[60.]else c8[813.];local dc=c8[60.]-ak;q=c8[257]*ak+c8[1029.]*dc;ah=5 else ah=280;continue end elseif ah==285. then return J[c8[153.]]else ah=283;continue end else break end end end]====]
local after=[====[function(slot) return __devilCompat:SkillCallback(x,slot) end]====]
local first,last=source:find(before,1,true)
assert(first and not source:find(before,last+1,true),"Unexpected skill patch target")
source=source:sub(1,first-1)..after..source:sub(last+1)
end
do
local before=[====[function(y)local ag,v,as,au,o,aO,aB=nil,nil,nil,nil,nil,nil,nil;local aQ=nil;local cN=aV;aQ=14;while true do aQ=14800-aQ;if aQ<14786 then if aQ<12181 then break elseif aQ<13339 then break elseif aQ<14784. then if aQ<14783 then break else v=e();aQ=if not v then 2 else 13 end elseif aQ<14785 then if aQ==14784. then aQ=if as then 4 else 17 else aQ=14786;continue end elseif aQ==14785 then v=as;as=((function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(type(v),cN[711.],cN[416],cN[272]));aQ=if as then 3. else 16 else aQ=14786;continue end elseif aQ<14793. then if aQ<14789 then if aQ<14787. then aQ=if not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(P(),cN[842],cN[824],cN[933.])then 1 else 10 elseif aQ<14788 then as=r(v[cN[567.]]);aQ=if not as then 8 else 0. else as=v[cN[582.]];aQ=15. end elseif aQ<14791 then if aQ<14790. then if aQ==14789 then v[cN[794]]=au;aQ=9. else aQ=14786;continue end elseif aQ==14790. then ag=O[cN[622]][cN[766]];v=G();as=v;aB=if as then cN[60.]else cN[813.];local cO=cN[60.]-aB;o=cN[260]*aB+cN[206]*cO;cO=cN[60.]-aB;aO=cN[302]*aB+cN[211]*cO;cO=cN[673];local cP=o*aO;aQ=if(o*cN[725]+aO*cN[549.]+cP)%cO==cN[829]then 12. else 15. else aQ=14798;continue end elseif aQ<14792 then aQ=6. elseif aQ==14792 then return else aQ=14785;continue end elseif aQ<14797 then if aQ<14795 then if aQ<14794 then if aQ==14793. then ag[cN[978.]](ag);local cQ=cN[433][cN[463]];cN[436](cN[955]);aQ=5 else aQ=14796.;continue end else break end elseif aQ<14796. then v=e();aQ=if v then 11 else 9. else ag[cN[74]](ag);return end elseif aQ<14799. then if aQ<14798 then if aQ==14797 then as=v[O[cN[944]][cN[513.]]]==true;aQ=16 else aQ=14800;continue end else return end elseif aQ<14800 then if aQ==14799. then return else aQ=14786;continue end else au=v[cN[794]];local cR=cN[548][cN[229]];v[cN[794]]=cN[521][cN[229]](as+cN[820](cN[842],cN[736],cN[813.]));cR=cN[433][cN[463]];cN[436](cN[222.]);aQ=if not E[cN[517]]then 7 else 5 end end end]====]
local after=[====[function() return __devilCompat:SellOnce({Services=O,State=u,Runtime=E,GetData=G,GetRoot=e,Phase=P,FindSeller=r}) end]====]
local first,last=source:find(before,1,true)
assert(first and not source:find(before,last+1,true),"Unexpected skill patch target")
source=source:sub(1,first-1)..after..source:sub(last+1)
end
do
local before=[====[function(q,ao,ae)local B,aR,r,o,G,ax,Z=nil,nil,nil,nil,nil,nil,nil;local af=nil;local dd=aV;af=7;while true do af=12177.-af;if af<12160 then if af<10045 then break elseif af<12155 then if af<12153. then break elseif af<12154 then if af==12153. then aR=u[dd[1039]];af=if aR then 16 else 20 else af=12172;continue end elseif af==12154 then B=P();af=if u[dd[1039]]then 1 else 24. else af=12168.;continue end elseif af<12157 then if af<12156. then if af==12155 then aR=os[dd[464]]()-u[dd[1039]]>dd[736];af=18. else af=12166;continue end elseif af==12156. then u[dd[1039]]=nil;af=9. else af=5717;continue end elseif af<12158 then if af==12157 then aR=not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[842],dd[824],dd[933.]);af=16 else af=12163;continue end elseif af<12159. then af=if aR then 6. else 14 elseif af==12159. then af=if aR then 21. else 17 else af=12156.;continue end elseif af<12169 then if af<12164 then if af<12162. then if af<12161 then if af==12160 then local de=(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[842],dd[824],dd[933.]);local df=dd[842];local dg=dd[824];local dh=dd[933.];aR=not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[946],dd[537.],dd[1041.]);r=not de;Z=if r then dd[60.]else dd[813.];de=dd[60.]-Z;G=dd[654.]*Z+dd[31]*de;de=dd[60.]-Z;ax=dd[617]*Z+dd[751]*de;de=dd[673];dh=G*ax;af=if(G*dd[594.]+ax*dd[1]+dh)%de==dd[103]then 5 else 2 else af=12153.;continue end else af=if aR then 19 else 15. end elseif af<12163 then aR=an();af=19 elseif af==12163 then aR=not D();af=6. else af=8232.;continue end elseif af<12166 then if af<12165. then u[dd[1039]]=os[dd[464]]();U(dd[610]);af=10 else af=if o then 0. else 11 end elseif af<12167 then af=9. elseif af<12168. then break elseif af==12168. then af=24. else af=12159.;continue end elseif af<12174. then if af<12171. then if af<12170 then if af==12169 then o=aR;af=12. else af=12168.;continue end else af=if not D()then 3. else 23 end elseif af<12172 then if af==12171. then af=if aR then 4 else 13 else af=12154;continue end elseif af<12173 then if af==12172 then r=aR;af=2 else af=12174.;continue end else return end elseif af<12176 then if af<12175 then l();return else aR=not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[107],dd[34],dd[859]);o=r;af=if o then 8 else 12. end elseif af<12177. then aR=((function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[842],dd[824],dd[933.]));af=if aR then 22 else 18. elseif af<15616 then if af==12177. then u[dd[1039]]=nil;af=11 else af=12160;continue end else break end end end]====]
local after=[====[function(q,ao,ae) if __devilCompat:HoldCast(P()) then return end local B,aR,r,o,G,ax,Z=nil,nil,nil,nil,nil,nil,nil;local af=nil;local dd=aV;af=7;while true do af=12177.-af;if af<12160 then if af<10045 then break elseif af<12155 then if af<12153. then break elseif af<12154 then if af==12153. then aR=u[dd[1039]];af=if aR then 16 else 20 else af=12172;continue end elseif af==12154 then B=P();af=if u[dd[1039]]then 1 else 24. else af=12168.;continue end elseif af<12157 then if af<12156. then if af==12155 then aR=os[dd[464]]()-u[dd[1039]]>dd[736];af=18. else af=12166;continue end elseif af==12156. then u[dd[1039]]=nil;af=9. else af=5717;continue end elseif af<12158 then if af==12157 then aR=not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[842],dd[824],dd[933.]);af=16 else af=12163;continue end elseif af<12159. then af=if aR then 6. else 14 elseif af==12159. then af=if aR then 21. else 17 else af=12156.;continue end elseif af<12169 then if af<12164 then if af<12162. then if af<12161 then if af==12160 then local de=(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[842],dd[824],dd[933.]);local df=dd[842];local dg=dd[824];local dh=dd[933.];aR=not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[946],dd[537.],dd[1041.]);r=not de;Z=if r then dd[60.]else dd[813.];de=dd[60.]-Z;G=dd[654.]*Z+dd[31]*de;de=dd[60.]-Z;ax=dd[617]*Z+dd[751]*de;de=dd[673];dh=G*ax;af=if(G*dd[594.]+ax*dd[1]+dh)%de==dd[103]then 5 else 2 else af=12153.;continue end else af=if aR then 19 else 15. end elseif af<12163 then aR=an();af=19 elseif af==12163 then aR=not D();af=6. else af=8232.;continue end elseif af<12166 then if af<12165. then u[dd[1039]]=os[dd[464]]();U(dd[610]);af=10 else af=if o then 0. else 11 end elseif af<12167 then af=9. elseif af<12168. then break elseif af==12168. then af=24. else af=12159.;continue end elseif af<12174. then if af<12171. then if af<12170 then if af==12169 then o=aR;af=12. else af=12168.;continue end else af=if not D()then 3. else 23 end elseif af<12172 then if af==12171. then af=if aR then 4 else 13 else af=12154;continue end elseif af<12173 then if af==12172 then r=aR;af=2 else af=12174.;continue end else return end elseif af<12176 then if af<12175 then l();return else aR=not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[107],dd[34],dd[859]);o=r;af=if o then 8 else 12. end elseif af<12177. then aR=((function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(B,dd[842],dd[824],dd[933.]));af=if aR then 22 else 18. elseif af<15616 then if af==12177. then u[dd[1039]]=nil;af=11 else af=12160;continue end else break end end end]====]
local first,last=source:find(before,1,true)
assert(first and not source:find(before,last+1,true),"Unexpected skill patch target")
source=source:sub(1,first-1)..after..source:sub(last+1)
end
do
local before=[====[function(ag,aw)local Q,al,aA,L,ay,q,aq,aF,n=nil,nil,nil,nil,nil,nil,nil,nil,nil;local aR=nil;local cY=aV;aR=5;while true do aR=bit32.bxor(aR,3451);if aR<3451 then if aR<3449 then if aR==3448 then local cZ=O;local c_=cZ[cY[865]];local c0=c_[cY[983]];local c1=cY[865];local c2=cY[983];aq=false;for k,f in c0 do aF=k;n=f;local aK=aF;local ao=n;local q=nil;q=cY[711.];while true do if q<6. then if q<3. then if q<1 then al[ao]=aA;q=cY[60.]elseif q<2 then q=cY[736]else aA=u[cY[984.]][ao];q=cY[842]end elseif q<4 then break elseif q<5 then aA=nil;q=cY[813.]else al=O[cY[865]][cY[203]](ao);aA=u[cY[82]];q=if aA then cY[107]else cY[749]end elseif q<9. then if q<7 then ay=aA;q=cY[892]elseif q<8 then cY[554](O[cY[496]][cY[638]],O[cY[496]],al,L);al=u[cY[984.]];aA=L;q=if aA then cY[813.]else cY[249.]else aA=u[cY[1025]][ao]==true;q=cY[749]end elseif q<11 then if q<10 then aA=L;q=if aA then cY[842]else cY[52]else L=aA;aA=Q[al]==true;ay=L~=aA;q=if ay then cY[402.]else cY[892]end elseif q<12. then aq=true;q=cY[736]else q=if ay then cY[946]else cY[60.]end end;if aq then break end end;aR=1 else break end elseif aR<3450. then if aR==3449 then al=Q[cY[536]];aR=6. else aR=3451;continue end else break end elseif aR<8260 then if aR<3455 then if aR<3453. then if aR<3452 then al=Q[cY[536]][cY[99.]];aR=7 else Q=al;aR=if not(function(k,f,j,e)if type(k)~="string"then return false end;if#k~=f then return false end;local g=5381;local c=buffer.fromstring(k);local a=0.;while true do if a<=f-4 then local l=buffer.readu32(c,a);g=bit32.bxor(g,l);g=bit32.band(g*33.,4294967295.);a=a+4 else break end end;while true do if a<f then local m=buffer.readu8(c,a);g=bit32.bxor(g,m);g=bit32.band(g*33.,4294967295.);a=a+1 else break end end;if g~=j then return false end;return k==e end)(type(Q),cY[711.],cY[416],cY[272])then 4 else 3. end elseif aR<3454 then aR=if al then 0. else 7 elseif aR==3454 then Q=G();al=Q;aR=if al then 2 else 6. else aR=3455;continue end elseif aR<6279. then if aR<5719 then if aR==3455 then return else break end else break end else break end else break end end end]====]
local after=[====[function() return __devilCompat:ApplySellRarities({Services=O,State=u,Runtime=E,GetData=G}) end]====]
local first,last=source:find(before,1,true)
assert(first and not source:find(before,last+1,true),"Unexpected skill patch target")
source=source:sub(1,first-1)..after..source:sub(last+1)
end
do
local before=[====[x[ef[423.]][ef[735.]](Y,false)]====]
local after=[====[__devilCompat:SkillLabel(Y)]====]
local first,last=source:find(before,1,true)
assert(first and not source:find(before,last+1,true),"Unexpected skill patch target")
source=source:sub(1,first-1)..after..source:sub(last+1)
end
do
local before=[====[x[er[423.]][er[735.]](Y,false)]====]
local after=[====[__devilCompat:SkillLabel(Y)]====]
local first,last=source:find(before,1,true)
assert(first and not source:find(before,last+1,true),"Unexpected skill patch target")
source=source:sub(1,first-1)..after..source:sub(last+1)
end
source=source:gsub("https://discord%.gg/synapsex","https://discord.gg/ZY7PRcVJe2"):gsub("https://ouroboros%-hub%-rbx%.web%.app/","https://discord.gg/ZY7PRcVJe2")
return [====[local __devilCompat=((getgenv and getgenv())or _G).DevilFishingTestCompat
]====]..source
end
local AddonsFactory=(function()
-- Additive travel and catch-popup controls; native Ouroboros fishing is unchanged.
return function(deps)
    local self={Stopped=false,Connections={},AutoDismiss=true,TravelMode="Fast Travel",SelectedIsland="Starter Island",Status="Ready"}
    local Task,V3,CF,Enum=deps.Task,deps.Vector3,deps.CFrame,deps.Enum
    local islands={{"Starter Island","island_starter"},{"Jungle Island","island_jungle"},{"Desert Island","island_desert"},{"Snow Island","island_snow"},{"Volcano Island","island_volcano"},{"Fossil Island","island_fossil"}}
    self.Islands=islands
    local function root()local char=deps.Player.Character return char and char:FindFirstChild("HumanoidRootPart")end
    function self:GetController(name)
        if not self.Client then
            local module=deps.ReplicatedStorage:FindFirstChild("Stardust")
            if not module then return nil end
            local ok,value=pcall(deps.Require,module)
            if ok and type(value)=="table"then self.Client=value.Client self.Stardust=value end
        end
        if not self.Client or type(self.Client.GetController)~="function"then return nil end
        local ok,value=pcall(self.Client.GetController,name)
        return ok and value or nil
    end
    function self:Visible(object)
        if not object then return false end
        while object do
            if object:IsA("GuiObject")and object.Visible==false then return false end
            if object:IsA("ScreenGui")and object.Enabled==false then return false end
            object=object.Parent
        end
        return true
    end
    function self:PopupButton()
        local gui=deps.Player:FindFirstChild("PlayerGui")
        if not gui then return nil end
        for _,screen in ipairs(gui:GetChildren())do
            if screen~=self.Window.Gui and screen:IsA("ScreenGui")and screen.Enabled then
                local caught=false
                for _,node in ipairs(screen:GetDescendants())do
                    if node:IsA("TextLabel")and self:Visible(node)then
                        local text=tostring(node.Text):lower()
                        if text:find("caught",1,true)or((text:find("click",1,true)or text:find("tap",1,true))and text:find("continue",1,true))then caught=true break end
                    end
                end
                if caught then
                    for _,button in ipairs(screen:GetDescendants())do
                        if button:IsA("GuiButton")and self:Visible(button)then
                            local name=button.Name:lower()
                            local text=button:IsA("TextButton")and tostring(button.Text):lower()or ""
                            if name:find("continue",1,true)or name:find("dismiss",1,true)or name=="close"or name=="ok"or name=="confirm"or text:find("continue",1,true)or text:find("tap",1,true)or text:find("click",1,true)then return button end
                        end
                    end
                    for _,label in ipairs(screen:GetDescendants())do
                        if label:IsA("TextLabel")and self:Visible(label)then
                            local text=tostring(label.Text):lower()
                            if (text:find("click",1,true)or text:find("tap",1,true))and text:find("continue",1,true)then return label end
                        end
                    end
                end
            end
        end
        return nil
    end
    function self:Activate(button)
        if button:IsA("GuiButton")and type(deps.FireSignal)=="function"and type(deps.GetConnections)=="function"then
            for _,name in ipairs({"MouseButton1Click","Activated"})do
                local ok,list=pcall(deps.GetConnections,button[name])
                if ok and type(list)=="table"then for _,listener in pairs(list)do
                    if listener.Connected~=false and listener.Enabled~=false then return pcall(deps.FireSignal,button[name],nil,1)end
                end end
            end
        end
        if not deps.VirtualInput or not button.AbsolutePosition or not button.AbsoluteSize then return false end
        local point=button.AbsolutePosition+button.AbsoluteSize/2
        local root=self.Window.Root
        if root and root.Visible then
            local p,size=root.AbsolutePosition,root.AbsoluteSize
            if point.X>=p.X and point.X<=p.X+size.X and point.Y>=p.Y and point.Y<=p.Y+size.Y then return false end
        end
        deps.VirtualInput:SendMouseButtonEvent(point.X,point.Y,0,true,deps.Game,0)
        local release=function()deps.VirtualInput:SendMouseButtonEvent(point.X,point.Y,0,false,deps.Game,0)end
        self.ReleasePopup=release
        Task.wait(.03)
        release()
        if self.ReleasePopup==release then self.ReleasePopup=nil end
        return true
    end
    function self:Dismiss()
        if self.Stopped or not self.AutoDismiss or self.PopupBusy or deps.Input:GetFocusedTextBox()then return false end
        local ctrl=self:GetController("FishingController")
        if not ctrl or type(ctrl.GetState)~="function"then return false end
        local ok,state=pcall(ctrl.GetState,ctrl)
        if not ok or state~="Caught"then self.CaughtDismissed=false return false end
        if self.CaughtDismissed then return false end
        if not self.CatchConnection and ctrl.StateChanged then
            local okConnect,connection=pcall(function()return ctrl.StateChanged:Connect(function(newState)
                if newState~="Caught"then self.CaughtDismissed=false end
            end)end)
            if okConnect then self.CatchConnection=connection self.Connections[#self.Connections+1]=connection end
        end
        local button=self:PopupButton()
        if not button then self.PopupStatus="Caught: waiting for Continue button"return false end
        self.PopupBusy=true
        local succeeded,result=pcall(self.Activate,self,button)
        self.PopupBusy=false
        local clicked=succeeded and result==true
        self.CaughtDismissed=clicked
        self.PopupStatus=clicked and "Catch confirmed"or "Continue input unavailable"
        return clicked
    end
    function self:IsUnlocked(id)
        if id=="island_starter"then return true end
        local controller=self:GetController("PlayerDataV2Controller")
        if not controller or type(controller.Fetch)~="function"then return false end
        local ok,data=pcall(controller.Fetch,controller)
        return ok and type(data)=="table"and type(data.UnlockedIslands)=="table"and data.UnlockedIslands[id]==true
    end
    function self:Target(id)
        local world=workspace:FindFirstChild("World")
        local list=world and world:FindFirstChild("Islands")
        local island=list and list:FindFirstChild(id)
        if not island then return nil end
        for _,name in ipairs({"FastTravelSpawn","PlayerSpawn","SpawnPoint","Spawn","npc_fish_seller_1","npc_fish_seller"})do
            local object=island:FindFirstChild(name,true)
            if object then
                if object:IsA("BasePart")then return object.CFrame+V3.new(0,4,0)end
                if object:IsA("Model")then return object:GetPivot()+V3.new(0,4,0)end
            end
        end
        return nil
    end
    function self:PauseTravel(on)
        deps.Compat.TravelBusy=on
        if on then
            self.SavedFlags={}
            for _,name in ipairs({"AutoPerfectCast","AutoMinigame","AutoSkills","AutoEquipBestRod","AutoSell","Fly"})do
                local flag=self.Library.Flags and self.Library.Flags[name]
                if flag then self.SavedFlags[name]=flag.Value flag:Set(false)end
            end
        elseif self.SavedFlags then
            for name,value in pairs(self.SavedFlags)do
                local flag=self.Library.Flags and self.Library.Flags[name]
                if flag and not self.Stopped then pcall(flag.Set,flag,value)end
            end
            self.SavedFlags=nil
        end
    end
    function self:Travel()
        if self.Stopped or self.TravelBusy then return false end
        if deps.Compat.SellTicket then self.Status="Wait for the current sale to finish"return false end
        local mode,selected=self.TravelMode,self.SelectedIsland
        local id
        for _,pair in ipairs(islands)do if pair[1]==selected then id=pair[2]break end end
        local localBypass=self.LocalIslandBypass==true and mode~="Fast Travel"
        if not id or(not localBypass and not self:IsUnlocked(id))then self.Status="Island is locked or player data is not ready"return false end
        if deps.Compat.SellTicket then self.Status="Wait for the current sale to finish"return false end
        local start=root()
        if not start then self.Status="Waiting for character"return false end
        local ctrl=self:GetController("FishingController")
        if ctrl and type(ctrl.GetState)=="function"then
            local ok,state=pcall(ctrl.GetState,ctrl)
            if ok and state~="Idling"then self.Status="Finish the current catch before travelling"return false end
        end
        self.TravelBusy=true
        local origin=start.Position
        local target=mode~="Fast Travel"and self:Target(id)or nil
        local success,errorText=pcall(function()
            self:PauseTravel(true)
            if mode=="Fast Travel"then
                local travel=self:GetController("FastTravelController")
                local packet=travel and travel.TravelToIsland
                if not packet and self.Stardust and self.Stardust.Packet then
                    packet=self.Stardust.Packet("TravelToIsland",self.Stardust.Packet.String)
                end
                assert(packet and type(packet.Fire)=="function","Fast Travel service unavailable")
                self.Status="Requesting Fast Travel (stand near a portal)"
                local reply=packet:Fire(id)
                assert(reply==nil or reply==0,"Fast Travel rejected: "..tostring(reply))
            else
                assert(target,"Island spawn is not streamed; use Fast Travel")
                if mode=="Teleport"then start.CFrame=target else
                    local duration=math.clamp((origin-target.Position).Magnitude/80,.25,25)
                    self.TravelTween=deps.Tween:Create(start,deps.TweenInfo.new(duration,Enum.EasingStyle.Linear),{CFrame=target})
                    self.TravelTween:Play()
                    local elapsed=0
                    while not self.Stopped and elapsed<duration do Task.wait(.1)elapsed+=.1 end
                    assert(not self.Stopped,"Travel cancelled")
                end
            end
            local elapsed=0
            while not self.Stopped and root()==start and elapsed<8 do
                local arrived=target and (start.Position-target.Position).Magnitude<16 or(not target and (start.Position-origin).Magnitude>30)
                if arrived then self.Status="Arrived: "..selected return end
                Task.wait(.1)elapsed+=.1
            end
            error("Travel was not confirmed; the game may have rejected movement")
        end)
        self.TravelBusy=false
        if self.TravelTween then self.TravelTween:Cancel()self.TravelTween=nil end
        self:PauseTravel(false)
        if not success then self.Status=tostring(errorText)end
        return success
    end
    function self:SetFly(value)
        local native=self.Library.Flags and self.Library.Flags.Fly
        if not native then self.Status="Native Fly control is unavailable"return end
        native:Set(value)
        self.OwnFly=value==true
        self.Status=value and "Fly / Float enabled"or "Fly / Float disabled"
    end
    function self:Attach(library,window)
        self.Library=library self.Window=window
        local tab=window:CreateTab({Name="Islands & Flight",Icon="map"})
        local travel=tab:AddLeftGroupbox({Name="Island Travel",Icon="navigation"})
        local names={}for _,pair in ipairs(islands)do names[#names+1]=pair[1]end
        travel:CreateDropdown({Name="Island",Options=names,CurrentOption=self.SelectedIsland,Callback=function(value)self.SelectedIsland=value end})
        travel:CreateDropdown({Name="Travel Mode",Options={"Fast Travel","Teleport","Tween"},CurrentOption=self.TravelMode,Callback=function(value)self.TravelMode=value end})
        travel:CreateToggle({Name="Bypass Local Island Filter",CurrentValue=false,
            Tooltip="Teleport/Tween only. Destination must be streamed; this does not unlock the island or bypass server checks.",
            Callback=function(value)self.LocalIslandBypass=value end})
        travel:CreateButton({Name="Go To Island",Icon="navigation",Callback=function()if not self.Stopped then self:Travel()end end})
        travel:CreateLabel({Name="Travel Status",Update=function()return self.Status end,UpdateRate=.5})
        local flight=tab:AddRightGroupbox({Name="Fly / Float",Icon="feather"})
        flight:CreateToggle({Name="Fly / Float",CurrentValue=false,Callback=function(value)if not self.Stopped then self:SetFly(value)end end})
        flight:CreateSlider({Name="Fly Speed",Range={10,100},Increment=1,CurrentValue=30,Callback=function(value)local flag=library.Flags and library.Flags.FlySpeed if flag then flag:Set(value)end end})
        for _,pair in ipairs({{"Rise +5",5},{"Lower -5",-5}})do
            flight:CreateButton({Name=pair[1],Callback=function()local r=root()if r and not self.Stopped then r.CFrame=r.CFrame+V3.new(0,pair[2],0)end end})
        end
        local result=tab:AddRightGroupbox({Name="After Catch",Icon="mouse-pointer-click"})
        result:CreateToggle({Name="Auto Click After Successful Catch",CurrentValue=true,Callback=function(value)self.AutoDismiss=value end})
        result:CreateLabel({Name="Catch Status",Update=function()return self.PopupStatus or "Waiting for a successful catch"end,UpdateRate=.5})
        local elapsed=0
        self.Connections[#self.Connections+1]=deps.Run.Heartbeat:Connect(function(dt)
            if self.Stopped then return end
            elapsed+=dt if elapsed<.5 then return end elapsed=0
            local ok,err=pcall(self.Dismiss,self)
            if not ok then self.PopupStatus=tostring(err)end
        end)
    end
    function self:Stop()
        if self.Stopped then return end self.Stopped=true
        for _,connection in ipairs(self.Connections)do connection:Disconnect()end self.Connections={}
        if self.TravelTween then self.TravelTween:Cancel()self.TravelTween=nil end
        deps.Compat.TravelBusy=false
        if self.ReleasePopup then pcall(self.ReleasePopup)self.ReleasePopup=nil end
        if self.OwnFly and self.Library then
            local flag=self.Library.Flags and self.Library.Flags.Fly
            if flag then pcall(flag.Set,flag,false)end
        end
        self.SavedFlags=nil
    end
    return self
end

end)()
return (function(...)
-- Runs the historical Fishing Master runtime with its original GUI and callbacks.
local env = type(getgenv) == "function" and getgenv() or _G
if env.DevilFishingTestStarting or env.DevilFishingTestRunning then
	return
end
local args = table.pack(...)
local loading = Loading.Begin()
loading.Busy = true
env.DevilFishingTestStarting = true
local originalGui = "https://raw.githubusercontent.com/joustingmatch/OuroFlow/main/Source.luau"
local pinnedGui =
	"https://raw.githubusercontent.com/joustingmatch/OuroFlow/7c495f5a17a2390d70809d628c82cd5384142dbd/Source.luau"
local runtimeUrl =
	"https://raw.githubusercontent.com/joustingmatch/Ouroboros/3dcb41a2b95847bc0b526489c19a391df16fd36f/games/buttsex.luau"
local compiler = loadstring
local hooks = {}
local library, createWindow, window, ownedRuntime
local oldAttach = env.DevilFishingTestAttach
local oldCompat = env.DevilFishingTestCompat
local compat,addons
local worker, cancelled
local function cleanup()
	cancelled = true
	if worker and type(task.cancel) == "function" then
		pcall(task.cancel, worker)
	end
	for i = #hooks, 1, -1 do
		pcall(hookfunction, hooks[i][1], hooks[i][2])
	end
	hooks = {}
	if library and createWindow then
		library.CreateWindow = createWindow
	end
	if env.DevilFishingTestAttach ~= oldAttach then
		env.DevilFishingTestAttach = oldAttach
	end
	if env.DevilFishingTestCompat ~= oldCompat then
		env.DevilFishingTestCompat = oldCompat
	end
end
local function dispose()
	cleanup()
    if addons then pcall(addons.Stop,addons)end
	if compat then
		pcall(compat.Stop, compat)
	end
	if type(ownedRuntime) == "table" and type(ownedRuntime.Unload) == "function" then
		pcall(ownedRuntime.Unload, ownedRuntime)
	end
	if window and type(window.Destroy) == "function" then
		pcall(window.Destroy, window)
	end
	env.DevilFishingTestStarting = false
	env.DevilFishingTestRunning = false
end
local function fetch(url)
	local done, ok, body = false, false, nil
	task.spawn(function()
		ok, body = pcall(game.HttpGet, game, url)
		done = true
	end)
	local deadline = os.clock() + 30
	while not done and os.clock() < deadline do
		task.wait(0.1)
	end
	assert(done, "Download timed out after 30 seconds")
	assert(ok, body)
	assert(type(body) == "string" and #body > 0, "Empty download")
	return body
end
local ok, result = xpcall(function()
	assert(game.PlaceId == 99925503388128 or game.GameId == 10039889230, "Open Fishing Master first")
	assert(
		type(compiler) == "function" and type(hookfunction) == "function",
		"This test requires loadstring and hookfunction"
	)
	assert(not env.DevilFishingNNVNRunning and not env.DevilFishingNNVNStarting,"Rejoin before switching from the previous Fishing Master backend")
	local prior = env.OuroborosFishingMaster
	assert(not prior or prior.Unloaded == true, "Fishing Master is already running; rejoin before testing")
	loading:SetStage("Downloading the original Fishing Master GUI...", 0.12)
	local gui = fetch(pinnedGui)
	assert(#gui == 413023, "Unexpected GUI revision")
	loading:SetStage("Downloading Fishing Master game controls...", 0.38)
	local source = fetch(runtimeUrl)
	assert(#source == 208259, "Unexpected game runtime revision")
	compat = CompatFactory({
		Input = game:GetService("UserInputService"),
		Player = game:GetService("Players").LocalPlayer,
		Heartbeat = game:GetService("RunService").Heartbeat,
		FireSignal = firesignal,
		GetConnections = getconnections,
		KeyCode = Enum.KeyCode,
		SellerCFrame = function(position)
			return CFrame.new(position + Vector3.new(6, 3, 0))
		end,
	})
	env.DevilFishingTestCompat = compat
	source = PatchFishing(source)
	local guiSource = "local ui=(function()\n"
		.. gui
		.. "\nend)()\nreturn ((getgenv and getgenv())or _G).DevilFishingTestAttach(ui)"
	env.DevilFishingTestAttach = function(ui)
		assert(not cancelled, "Test startup was cancelled")
		assert(type(ui) == "table" and type(ui.CreateWindow) == "function", "Original GUI did not return a library")
		library = ui
		createWindow = ui.CreateWindow
		ui.CreateWindow = function(self, info, ...)
			assert(not cancelled, "Test startup was cancelled")
			local config={}for key,value in pairs(info or {})do config[key]=value end
            config.Name="DEVIL HUB"config.Theme="Abyss"config.Loading=false
            config.Density="Compact"config.Search=true config.KeepOnScreen=true config.IslandDraggable=true
            config.ConfigurationSaving={Enabled=false,FolderName="DevilFishingStandalone"}
            local logo="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"
            local custom=getcustomasset or getsynasset
            if type(custom)=="function"and type(isfile)=="function"and isfile("devil-hub-logo-daceb9cac221.png")then
                local assetOK,asset=pcall(custom,"devil-hub-logo-daceb9cac221.png")if assetOK then logo=asset end
            end
            config.Icon=logo config.ToggleButton={Platform="Both",Icon=logo}
            if type(config.Home)=="table"then
                local home={}for key,value in pairs(config.Home)do home[key]=value end
                home.Title="DEVIL HUB"home.Discord="https://discord.gg/ZY7PRcVJe2"home.Website="https://discord.gg/ZY7PRcVJe2"
                config.Home=home
            end
            local values = table.pack(createWindow(self, config, ...))
			window = values[1]
            if ui.SetTheme then ui:SetTheme("Abyss")end
            if window and window.SetToggleButtonIcon then window:SetToggleButtonIcon(config.Icon)end
			loading:SetStage("Connecting native game controls...", 0.88)
			return table.unpack(values, 1, values.n)
		end
		return ui
	end
	for _, name in ipairs({ "HttpGet", "HttpGetAsync" }) do
		local target = game[name]
		if type(target) == "function" then
			local old
			local intercept = function(self, url, ...)
				if not cancelled and (url == originalGui or url == pinnedGui) then
					return guiSource
				end
				return old(self, url, ...)
			end
			old = hookfunction(target, intercept)
			assert(type(old) == "function", "HTTP hook did not return the original method")
			hooks[#hooks + 1] = { target, old }
		end
	end
	loading:SetStage("Starting the original GUI and game modules...", 0.65)
	local run, parseError = compiler(source, "Fishing Master / TEST public revision")
	assert(run, parseError)
	local done, started, value = false, false, nil
	worker = task.spawn(function()
		started, value = xpcall(function()
			return run(table.unpack(args, 1, args.n))
		end, debug.traceback)
		done = true
	end)
	local deadline = os.clock() + 90
	while not done and os.clock() < deadline do
		task.wait(0.1)
	end
	ownedRuntime = env.OuroborosFishingMaster
	assert(done, "Startup timed out after 90 seconds; check the game modules in the console")
	assert(started, value)
	assert(window and window.Gui and window.Gui.Parent, "Original runtime did not create a visible GUI")
	compat:Attach(library, window)
    addons=AddonsFactory({Game=game,Player=game:GetService("Players").LocalPlayer,
        Input=game:GetService("UserInputService"),Run=game:GetService("RunService"),
        ReplicatedStorage=game:GetService("ReplicatedStorage"),Tween=game:GetService("TweenService"),
        FireSignal=firesignal,GetConnections=getconnections,VirtualInput=game:GetService("VirtualInputManager"),
        Task=task,Compat=compat,Require=require,Instance=Instance,Vector3=Vector3,CFrame=CFrame,Enum=Enum,TweenInfo=TweenInfo})
    addons:Attach(library,window)
	cleanup()
	env.DevilFishingTestCleanup = dispose
	env.DevilFishingTestRunning = window
	if type(window.Destroy) == "function" then
		local destroy = window.Destroy
		window.Destroy = function(self, ...)
            if addons then pcall(addons.Stop,addons)end
			pcall(compat.Stop, compat)
			env.DevilFishingTestRunning = false
			return destroy(self, ...)
		end
		if window.Unload == destroy then
			window.Unload = window.Destroy
		end
	end
	if window.Gui.Destroying then
		window.Gui.Destroying:Once(function()
            if addons then pcall(addons.Stop,addons)end
			pcall(compat.Stop, compat)
			env.DevilFishingTestRunning = false
		end)
	end
	return value
end, function(err)
	return debug.traceback(tostring(err), 2)
end)
env.DevilFishingTestStarting = false
if ok then
	loading:Finish(true)
	if type(firesignal) ~= "function" then
		warn("[FISHING MASTER TEST] firesignal unavailable; native automation is disabled")
	end
	return result
end
dispose()
loading:Finish(false, "Test could not start. Check console for the exact error.")
warn("[FISHING MASTER TEST] " .. tostring(result))

end)(...)
