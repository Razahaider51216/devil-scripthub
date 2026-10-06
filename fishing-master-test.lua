-- Fishing Master TEST v2 / adaptive skills and fishing cycle
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
    local panel = make("Frame",shade,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(.5,.5),Size = UDim2.new(.86,0,0,270),BackgroundColor3 = Color3.fromRGB(20,13,20),BorderSizePixel = 0})
    make("UISizeConstraint",panel,{MaxSize = Vector2.new(420,270)})
    corner(panel,16)
    -- Keep this overlay independent of the native library stroke scaler.
    local logo = make("ImageLabel",panel,{AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,17),Size = UDim2.fromOffset(76,64),BackgroundTransparency = 1,Image = "",ScaleType = Enum.ScaleType.Fit})
    corner(logo,9)
    local title = make("TextLabel",panel,{Position = UDim2.fromOffset(20,92),Size = UDim2.new(1,-40,0,30),BackgroundTransparency = 1,Text = "FISHING MASTER / TEST",Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = Color3.fromRGB(247,48,75)})
    local status = make("TextLabel",panel,{Position = UDim2.fromOffset(20,131),Size = UDim2.new(1,-40,0,37),BackgroundTransparency = 1,Text = "Preparing your session...",Font = Enum.Font.Gotham,TextSize = 12,TextColor3 = Color3.fromRGB(187,161,179),TextWrapped = true})
    local track = make("Frame",panel,{Position = UDim2.fromOffset(28,181),Size = UDim2.new(1,-56,0,5),BackgroundColor3 = Color3.fromRGB(52,29,44),BorderSizePixel = 0})
    corner(track,3)
    local fill = make("Frame",track,{Size = UDim2.fromScale(.04,1),BackgroundColor3 = Color3.fromRGB(247,48,75),BorderSizePixel = 0})
    corner(fill,3)
    local detail = make("TextLabel",panel,{Position = UDim2.fromOffset(20,203),Size = UDim2.new(1,-40,0,20),BackgroundTransparency = 1,Text = "FISHING MASTER / TEST / STARTING",Font = Enum.Font.Gotham,TextSize = 9,TextColor3 = Color3.fromRGB(120,98,113)})
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
        detail.Text = string.format("FISHING MASTER / TEST / %d%%",math.floor(self.Progress*100))
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
                local run,parseError = loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=2"),"Devil Hub / Retry")
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
		local paused = typing or respawn
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
return [====[local __devilCompat=((getgenv and getgenv())or _G).DevilFishingTestCompat
]====]..source
end
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
	"https://raw.githubusercontent.com/joustingmatch/OuroFlow/836b20c6a25cca72dd8530f54462d978251b3024/Source.luau"
local runtimeUrl =
	"https://raw.githubusercontent.com/joustingmatch/Ouroboros/3dcb41a2b95847bc0b526489c19a391df16fd36f/games/buttsex.luau"
local compiler = loadstring
local hooks = {}
local library, createWindow, window, ownedRuntime
local oldAttach = env.DevilFishingTestAttach
local oldCompat = env.DevilFishingTestCompat
local compat
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
	local prior = env.OuroborosFishingMaster
	assert(not prior or prior.Unloaded == true, "Fishing Master is already running; rejoin before testing")
	loading:SetStage("Downloading the original Fishing Master GUI...", 0.12)
	local gui = fetch(pinnedGui)
	assert(#gui == 382255, "Unexpected GUI revision")
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
			local values = table.pack(createWindow(self, info, ...))
			window = values[1]
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
	cleanup()
	env.DevilFishingTestCleanup = dispose
	env.DevilFishingTestRunning = window
	if type(window.Destroy) == "function" then
		local destroy = window.Destroy
		window.Destroy = function(self, ...)
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
