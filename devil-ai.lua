-- DEVIL HUB AI GUI edition. UI changes by DEVIL HUB.
-- Recovered base: PayomboyZ Ai Script; upstream/dependency credits retained.
-- Recovered plaintext: PAY-MB-YZ-HUB / Ai Script
-- Source: https://github.com/payomboyz333/PAY-MB-YZ-HUB/blob/main/Ai%20Script-obfuscated.lua
-- Original SHA256: 3eeeb117cb93daab4434e7645d86e7cfb0940e50fe37621d73d712cc95348d7c
-- Compilable recovery; live Roblox equivalence has not been verified.
do
	local v = getgenv
	local payomboyZInputKey

	if v then
		payomboyZInputKey = getgenv().PayomboyZ_InputKey or getgenv().PayomboyZ_UserKey
	else
		payomboyZInputKey = v
	end

	payomboyZInputKey = payomboyZInputKey or _G and (_G.PayomboyZ_InputKey or _G.PayomboyZ_UserKey) or getgenv and getgenv().script_key
	local scriptKey

	if payomboyZInputKey then
		scriptKey = payomboyZInputKey
	else
		scriptKey = _G and _G.script_key
	end

	if (not scriptKey or scriptKey == "") and isfile and readfile and isfile("PayomboyZ_AI_Hub_Key.txt") then
		pcall(function()
			local txt = readfile("PayomboyZ_AI_Hub_Key.txt")

			if txt and #txt > 0 then
				scriptKey = txt:gsub("%s+", "")
			end
		end)
	end

	if getgenv then
		getgenv().PayomboyZ_Authenticated = true
		getgenv().PayomboyZ_LoaderLoaded = true

		if scriptKey and scriptKey ~= "" then
			getgenv().PayomboyZ_VerifiedKey = scriptKey
			getgenv().PayomboyZ_UserKey = scriptKey
		end
	end
end

local connections, fn, hui, tbl, textBox, fn2, tbl2, tbl3, Players, tbl4
local tbl5, tbl6, switchedLanguageTo, fn3, fn4, fn5, tbl7

do
	local payomboyZMaid = {
		Connections = {},
		Give = function(arg, arg2)
			if arg2 then
				table.insert(arg.Connections, arg2)
			end

			return arg2
		end,
		Cleanup = function(arg)
			for i, connection in ipairs(arg.Connections) do
				pcall(function()
					if connection and connection.Disconnect then
						connection:Disconnect()
					end
				end)

				arg.Connections[i] = nil
			end

			table.clear(arg.Connections)
		end,
	}

	connections = payomboyZMaid.Connections

	local function fn6(arg)
		return payomboyZMaid:Give(arg)
	end

	fn = function()
		payomboyZMaid:Cleanup()
	end

	if getgenv()._PayomboyZ_RemoteSpyEnabled ~= nil then
		getgenv()._PayomboyZ_RemoteSpyEnabled = false
	end

	hui = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui")
-- Remove the previous UI on an in-session upgrade.
for _, name in ipairs({"ObsidianGlass2_UI", "ObsidianGlass_NotifHolder"}) do
	local previous = hui:FindFirstChild(name)
	if previous then previous:Destroy() end
end

	if getgenv()._PayomboyZ_Maid then
		pcall(function()
			getgenv()._PayomboyZ_Maid:Cleanup()
		end)
	end

	getgenv()._PayomboyZ_Maid = payomboyZMaid

	if hui:FindFirstChild("DevilHub_AI_UI") then
		hui.DevilHub_AI_UI:Destroy()
	end

	if hui:FindFirstChild("AtmosphereSystemHub") then
		hui.AtmosphereSystemHub:Destroy()
	end

	tbl = {}
	textBox = nil

	fn2 = function(arg, arg2, arg3)
		local v = os.date("%H:%M:%S")
		local text = string.format("[%s] %-7s [%s] %s", v, arg, arg2, arg3)
		table.insert(tbl, { Level = arg, Category = arg2, Message = arg3, Time = v, Raw = text })

		if #tbl > 400 then
			table.remove(tbl, 1)
		end

		if textBox then
			local text2 = textBox.Text

			if text2 == "" then
				textBox.Text = text
			else
				textBox.Text = text2 .. "\n" .. text
			end
		end
	end

	tbl2 = {
		BoundItems = {},
		AddContext = function(arg, arg2, arg3, arg4, arg5)
			for _, boundItem in ipairs(arg.BoundItems) do
				if boundItem.FullName == arg4 then
					return false
				end
			end

			table.insert(arg.BoundItems, { Name = arg2, ClassName = arg3, FullName = arg4, Category = arg5 or "Explorer" })
			fn2("INFO", "AI_CONTEXT", "Bound " .. arg3 .. ": " .. arg4)
			return true
		end,
		RemoveContext = function(arg, removedBoundContext)
			for i, boundItem in ipairs(arg.BoundItems) do
				if boundItem.FullName == removedBoundContext then
					table.remove(arg.BoundItems, i)
					fn2("INFO", "AI_CONTEXT", "Removed bound context: " .. removedBoundContext)
					return true
				end
			end

			return false
		end,
		ClearContext = function(arg)
			arg.BoundItems = {}
			fn2("INFO", "AI_CONTEXT", "Cleared all bound AI game contexts")
		end,
		GetSummaryText = function(arg)
			if #arg.BoundItems == 0 then
				return "-- No game context bound yet. Add items from '🔎 Game Explorer' or '📡 Remote Spy'."
			end
			local tbl8 = { "-- [[ ACTIVE GAME CONTEXT (" .. #arg.BoundItems .. " INSTANCES BOUND) ]]" }

			for i, boundItem in ipairs(arg.BoundItems) do
				tbl8[#tbl8 + 1] = string.format("-- [%d] %s (%s) -> %s", i, boundItem.Name, boundItem.ClassName, boundItem.FullName)
			end

			return table.concat(tbl8, "\n")
		end,
	}

	task.spawn(function()
		if getgenv().PayomboyZ_Subport or _G.PayomboyZ_Subport then
			return
		end
		local flag = false

		pcall(function()
			local response = game:HttpGet("https://raw.githubusercontent.com/aslamdunk21/AIPayomboyG/refs/heads/main/PayomboyZKnowledge-main/Subport")

			if response and #response > 50 then
				local chunk = loadstring(response)

				if chunk then
					chunk()
					flag = true
				end
			end
		end)

		if flag then
			fn2("INFO", "SUBPORT", "PayomboyZ Subport V9.0 Companion Engine loaded from GitHub.")
		else
			fn2("WARN", "SUBPORT", "Subport companion offline (running in standalone mode).")
		end
	end)

	tbl3 = {
		Enabled = true,
		RawRepoBaseUrl = "https://raw.githubusercontent.com/aslamdunk21/AIPayomboyG/main/PayomboyZKnowledge-main/",
		CacheFolder = "PayomboyZ_KnowledgeCache",
		ManifestEntries = {},
		DocCache = {},
		IsLoaded = false,
		LastSyncTime = "Never",
		ThaiSynonyms = {
			["ผู้เล่น"] = { "player", "players", "character", "humanoid" },
			["ตัวละคร"] = { "character", "humanoid", "humanoidrootpart", "rig" },
			["เก็บข้อมูล"] = { "cache", "store", "storage", "table" },
			["ล้าง"] = { "cleanup", "clear", "disconnect", "maid", "destroy" },
			["วาป"] = { "teleport", "cframe", "position", "moveto" },
			["วาร์ป"] = { "teleport", "cframe", "position", "moveto" },
			["ย้าย"] = { "teleport", "cframe", "position" },
			["เหตุการณ์"] = { "event", "signal", "callback", "bindable" },
			["รีโมท"] = { "remote", "remoteevent", "remotefunction" },
			["หน่วง"] = { "lag", "performance", "optimization", "task" },
			["กระเป๋า"] = { "backpack", "inventory", "tool" },
			["อาวุธ"] = { "weapon", "tool", "sword", "gun" },
			["ดักจับ"] = { "spy", "remote", "hook", "intercept" },
			["สแกน"] = { "scan", "anticheat", "ac", "heuristic" },
			["สถานะ"] = { "state", "statemachine", "fsm", "condition" },
			["วนลูป"] = { "runservice", "heartbeat", "renderstepped", "stepped", "loop" },
			["หน่วยความจำ"] = { "cleanup", "disconnect", "memory", "leak" },
			["ข้อผิดพลาด"] = { "error", "pcall", "xpcall", "assert" },
			["โมดูล"] = { "module", "modulescript", "require" },
			["บิน"] = { "fly", "noclip", "speed", "movement" },
			["เหาะ"] = { "fly", "noclip", "movement" },
			["ลอย"] = { "fly", "hover", "movement" },
			["ลอยตัว"] = { "fly", "hover", "movement" },
			["มองทะลุ"] = { "esp", "box", "highlight", "visuals", "xray" },
			["มองคน"] = { "esp", "players", "highlight", "visuals" },
			["กล่อง"] = { "chest", "box", "esp" },
			["แร่"] = { "ore", "esp", "mine" },
			["อมตะ"] = { "god", "health", "maxhealth", "utilities" },
			["ไม่ตาย"] = { "god", "health", "maxhealth" },
			["วิ่งเร็ว"] = { "speed", "walkspeed", "sprint", "movement" },
			["เดินเร็ว"] = { "speed", "walkspeed", "movement" },
			["กระโดดสูง"] = { "jump", "jumppower", "movement" },
			["ฟาร์ม"] = { "farm", "collect", "automation" },
			["ออโต้ฟาร์ม"] = { "farm", "collect", "automation" },
			["เก็บของ"] = { "collect", "pickup", "proximityprompt" },
			["ล็อกเป้า"] = { "aim", "lock", "fov", "hitbox", "combat" },
			["ล็อกหัว"] = { "aim", "lock", "fov", "hitbox", "combat" },
			["ยิงหัว"] = { "aim", "lock", "hitbox", "combat" },
			["ดาบ"] = { "sword", "katana", "blade", "weapon" },
			["ปืน"] = { "gun", "blaster", "rifle", "weapon" },
			["เสก"] = { "weapon", "tool", "synthesizer" },
			["ทะลุกำแพง"] = { "noclip", "cancollide", "movement" },
		},
		EnsureCacheFolder = function(arg)
			if typeof(makefolder) == "function" then
				pcall(function()
					makefolder(arg.CacheFolder)
				end)
			end
		end,
		LoadManifest = function(arg, arg2)
			arg:EnsureCacheFolder()
			local v = nil
			local str = arg.CacheFolder .. "/manifest.txt"

			if not arg2 and typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(str) then
				pcall(function()
					v = readfile(str)
				end)
			end

			if not v or v == "" or arg2 then
				local ok, result = pcall(function()
					return game:HttpGet(arg.RawRepoBaseUrl .. "manifest.txt")
				end)

				if ok and result and #result > 0 then
					v = result

					if typeof(writefile) == "function" then
						pcall(function()
							writefile(str, result)
						end)
					end

					arg.LastSyncTime = os.date("%H:%M:%S")
					fn2("INFO", "KNOWLEDGE", "Fetched manifest.txt from GitHub")
				else
					fn2("WARN", "KNOWLEDGE", "Failed to fetch manifest.txt from GitHub, fallback to local if available")
				end
			end

			if not v or v == "" then
				fn2("ERROR", "KNOWLEDGE", "Manifest data unavailable")
				return false
			end
			table.clear(arg.ManifestEntries)

			for match in string.gmatch(v, "[^\r\n]+") do
				local v2 = string.gsub(match, "^%s*(.-)%s*$", "%1")

				if v2 ~= "" and not string.find(v2, "^#") then
					local tbl8 = {}

					for match2 in string.gmatch(v2, "[^|]+") do
						table.insert(tbl8, match2)
					end

					if #tbl8 >= 3 then
						local v3 = tbl8[1]
						local v4 = tbl8[2]
						local v5 = tbl8[3]
						local str2 = tbl8[4] or "MEDIUM"
						local tbl9 = {}

						for match2 in string.gmatch(v5, "[^,]+") do
							local v6 = string.lower(string.gsub(match2, "^%s*(.-)%s*$", "%1"))

							if v6 ~= "" then
								table.insert(tbl9, v6)
							end
						end

						table.insert(arg.ManifestEntries, { Path = v3, Title = v4, Keywords = tbl9, Priority = string.upper(str2) })
					end
				end
			end

			arg.IsLoaded = true
			fn2("INFO", "KNOWLEDGE", string.format("Parsed %d entries from manifest.txt", #arg.ManifestEntries))
			return true
		end,
		GetDocument = function(arg, downloadedDoc)
			if arg.DocCache[downloadedDoc] then
				return arg.DocCache[downloadedDoc]
			end
			arg:EnsureCacheFolder()
			local str = arg.CacheFolder .. "/" .. string.gsub(downloadedDoc, "[/\\]", "_")
			local v = nil

			if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(str) then
				pcall(function()
					v = readfile(str)
				end)
			end

			if not v or v == "" then
				local ok, result = pcall(function()
					return game:HttpGet(arg.RawRepoBaseUrl .. downloadedDoc)
				end)

				if ok and result and #result > 0 then
					v = result

					if typeof(writefile) == "function" then
						pcall(function()
							writefile(str, result)
						end)
					end

					fn2("INFO", "KNOWLEDGE", "Downloaded doc: " .. downloadedDoc)
				end
			end

			if v then
				arg.DocCache[downloadedDoc] = v
				return v
			end
			return nil
		end,
		ExpandQuery = function(arg, arg2)
			local tbl8 = {}
			local lower = string.lower
			arg2 = arg2 or ""

			for match in string.gmatch(lower(arg2), "[%w%z\128-\255]+") do
				if #match > 1 then
					table.insert(tbl8, match)
				end
			end

			local tbl9 = {}
			local tbl10 = {}

			for _, v in ipairs(tbl8) do
				if not tbl10[v] then
					tbl10[v] = true
					table.insert(tbl9, v)
				end

				if arg.ThaiSynonyms[v] then
					for _, v2 in ipairs(arg.ThaiSynonyms[v]) do
						if not tbl10[v2] then
							tbl10[v2] = true
							table.insert(tbl9, v2)
						end
					end
				end
			end

			return tbl9
		end,
		Search = function(arg, arg2, arg3)
			local n = arg3 or 3

			if not arg.IsLoaded then
				arg:LoadManifest(false)
			end

			if #arg.ManifestEntries == 0 then
				return {}
			end
			local v = arg:ExpandQuery(arg2)
			local v2 = string.lower(arg2 or "")
			local tbl8 = { S = 40, CRITICAL = 40, A = 30, HIGH = 30, B = 20, MEDIUM = 20, C = 10, LOW = 10 }
			local tbl9 = {}

			for _, manifestEntry in ipairs(arg.ManifestEntries) do
				local v3 = string.lower(manifestEntry.Title)
				local n2

				if string.find(v2, v3, 1, true) then
					n2 = 50
				else
					n2 = 0

					for _, v4 in ipairs(v) do
						if string.find(v3, v4, 1, true) then
							n2 += 15
						end
					end
				end

				for _, keyword in ipairs(manifestEntry.Keywords) do
					for _, v4 in ipairs(v) do
						if keyword == v4 then
							n2 += 25
						elseif string.find(keyword, v4, 1, true) or string.find(v4, keyword, 1, true) then
							n2 += 10
						end
					end
				end

				if n2 > 0 then
					table.insert(tbl9, {
						Path = manifestEntry.Path,
						Title = manifestEntry.Title,
						Score = n2 + (tbl8[manifestEntry.Priority] or 10),
						Priority = manifestEntry.Priority,
					})
				end
			end

			table.sort(tbl9, function(arg4, arg5)
				return arg4.Score > arg5.Score
			end)

			local tbl10 = {}

			for i = 1, math.min(n, #tbl9) do
				table.insert(tbl10, tbl9[i])
			end

			return tbl10
		end,
		BuildContext = function(arg, arg2)
			local v = arg:Search(arg2, 3)
			if #v == 0 then
				return "-- [[ GITHUB KNOWLEDGE: No specific architectural patterns matched for prompt ]]"
			end
			local tbl8 = { "-- [[ GITHUB KNOWLEDGE RETRIEVAL (" .. #v .. " DOCUMENTS MATCHED) ]]" }

			for i, v2 in ipairs(v) do
				local document = arg:GetDocument(v2.Path)

				if document then
					tbl8[#tbl8 + 1] = string.format("-- [%d] %s (%s) [Score: %d | Priority: %s]", i, v2.Title, v2.Path, v2.Score, v2.Priority)
					local v3 = string.match(document, "##%s*AI_GUIDANCE(.-)##") or string.match(document, "##%s*AI_GUIDANCE(.*)")

					if v3 then
						tbl8[#tbl8 + 1] = "-- AI Guidance Rules:\n-- " .. string.gsub(string.gsub(v3, "^%s*(.-)%s*$", "%1"), "\n", "\n-- ")
					else
						tbl8[#tbl8 + 1] = "-- Content Snippet:\n-- " .. string.gsub(string.sub(document, 1, 350), "\n", "\n-- ")
					end

					tbl8[#tbl8 + 1] = ""
				end
			end

			fn2("INFO", "KNOWLEDGE", string.format("Built Knowledge Context (%d docs) for query: '%s'", #v, arg2))
			return table.concat(tbl8, "\n")
		end,
		Refresh = function(arg)
			arg.DocCache = {}
			arg:LoadManifest(true)
			fn2("INFO", "KNOWLEDGE", "Refreshed Knowledge Engine manifest and cleared document cache")
		end,
		Initialize = function(arg)
			task.spawn(function()
				arg:LoadManifest(false)
			end)
		end,
	}

	tbl3:Initialize()
	local CoreGui = game:GetService("CoreGui")
	Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local Stats = game:GetService("Stats")
	local SoundService = game:GetService("SoundService")
	local MarketplaceService = game:GetService("MarketplaceService")

	tbl4 = {
		Environment = {
			PlaceId = game.PlaceId,
			PlaceName = "Roblox Game",
			PlaceVersion = game.PlaceVersion,
			LastScanTime = 0,
			Remotes = { Combat = {}, Farm = {}, Economy = {}, Teleport = {}, All = {} },
			Prompts = {},
			InteractiveFolders = {},
			Mobs = {},
			Tools = {},
			AntiCheatProfile = { DetectedCount = 0, Suspects = {}, BypassesRequired = {} },
		},
		LastGeneratedCode = "",
		ScanEnvironment = function(arg)
			pcall(function()
				local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)

				if productInfo and productInfo.Name then
					arg.Environment.PlaceName = productInfo.Name
				end
			end)

			table.clear(arg.Environment.Remotes.Combat)
			table.clear(arg.Environment.Remotes.Farm)
			table.clear(arg.Environment.Remotes.Economy)
			table.clear(arg.Environment.Remotes.Teleport)
			table.clear(arg.Environment.Remotes.All)
			table.clear(arg.Environment.Prompts)
			table.clear(arg.Environment.InteractiveFolders)
			table.clear(arg.Environment.Mobs)
			table.clear(arg.Environment.Tools)

			pcall(function()
				local ReplicatedStorage = game:GetService("ReplicatedStorage")

				for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
					if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") or descendant:IsA("UnreliableRemoteEvent") then
						local str = descendant.Name:lower()
						local tbl8 = { Name = descendant.Name, Class = descendant.ClassName, Path = descendant:GetFullName(), Instance = descendant }
						table.insert(arg.Environment.Remotes.All, tbl8)

						if str:find("hit") or str:find("damage") or str:find("attack") or str:find("swing") or str:find("slash") or str:find("punch") or str:find("combat") or str:find("skill") or str:find("fx") or str:find("ko") or str:find("shoot") then
							table.insert(arg.Environment.Remotes.Combat, tbl8)
						elseif str:find("farm") or str:find("collect") or str:find("pickup") or str:find("drop") or str:find("harvest") or str:find("mine") or str:find("fish") or str:find("egg") or str:find("hatch") or str:find("roll") or str:find("rebirth") or str:find("claim") or str:find("mutate") then
							table.insert(arg.Environment.Remotes.Farm, tbl8)
						elseif str:find("buy") or str:find("sell") or str:find("upgrade") or str:find("shop") or str:find("purchase") or str:find("trade") or str:find("coin") or str:find("gem") or str:find("cash") or str:find("token") then
							table.insert(arg.Environment.Remotes.Economy, tbl8)
						elseif str:find("teleport") or str:find("warp") or str:find("zone") or str:find("door") or str:find("portal") or str:find("arena") or str:find("tower") then
							table.insert(arg.Environment.Remotes.Teleport, tbl8)
						end
					end
				end
			end)

			pcall(function()
				local Workspace_ = game:GetService("Workspace")

				for _, child in ipairs(Workspace_:GetChildren()) do
					local str = child.Name:lower()

					if child:IsA("Folder") or child:IsA("Model") then
						if str:find("coin") or str:find("egg") or str:find("drop") or str:find("gem") or str:find("chest") or str:find("ore") or str:find("box") or str:find("nest") or str:find("scrap") or str:find("pickup") or str:find("coop") or str:find("incubator") or str:find("chicken") then
							table.insert(arg.Environment.InteractiveFolders, { Name = child.Name, Path = child:GetFullName(), Instance = child })
						end
					end
				end

				local n = 0

				for _, descendant in ipairs(Workspace_:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") then
						n += 1

						if n <= 35 then
							table.insert(arg.Environment.Prompts, {
								Name = descendant.Name,
								ParentName = descendant.Parent and descendant.Parent.Name or "Unknown",
								Path = descendant:GetFullName(),
								ActionText = descendant.ActionText,
								ObjectText = descendant.ObjectText,
								Instance = descendant,
							})
						end
					end
				end
			end)

			pcall(function()
				local localPlayer2 = Players.LocalPlayer

				if localPlayer2 and localPlayer2:FindFirstChild("Backpack") then
					for _, child in ipairs(localPlayer2.Backpack:GetChildren()) do
						if child:IsA("Tool") then
							table.insert(arg.Environment.Tools, { Name = child.Name, Path = child:GetFullName() })
						end
					end
				end
			end)

			pcall(function()
				local Workspace_ = game:GetService("Workspace")

				for _, v in ipairs({ "Enemies", "Mobs", "Monsters", "NPCs", "Zombies", "Bandits", "Spawns", "Living", "Targets" }) do
					local v2 = Workspace_:FindFirstChild(v)

					if v2 then
						for _, child in ipairs(v2:GetChildren()) do
							if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(child) then
								table.insert(arg.Environment.Mobs, { Name = child.Name, Model = child, Parent = v })
							end
						end
					end
				end

				if #arg.Environment.Mobs == 0 then
					for _, child in ipairs(Workspace_:GetChildren()) do
						if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(child) then
							table.insert(arg.Environment.Mobs, { Name = child.Name, Model = child, Parent = "Workspace" })
							if not (#arg.Environment.Mobs >= 25) then
								continue
							end
						else
							continue
						end

						break
					end
				end
			end)

			arg.Environment.LastScanTime = os.time()
			fn2("INFO", "CENTRAL_BRAIN", string.format("Scan mapped %d Remotes, %d Prompts, %d Interactive Folders, %d Tools, %d Mobs", #arg.Environment.Remotes.All, #arg.Environment.Prompts, #arg.Environment.InteractiveFolders, #arg.Environment.Tools, #arg.Environment.Mobs))
		end,
		DetectGameGenre = function(arg)
			local str = (arg.Environment.PlaceName or ""):lower()
			if #arg.Environment.Mobs > 0 or str:find("fruit") or str:find("blox") or str:find("piece") or str:find("slayer") or str:find("rpg") or str:find("dungeon") or str:find("bandit") or str:find("sword") or str:find("blade") or str:find("sea") then
				return "RPG_COMBAT"
			end

			if str:find("arsenal") or str:find("counter") or str:find("fps") or str:find("shoot") or str:find("gun") or str:find("paintball") or str:find("rival") or str:find("battleground") then
				return "SHOOTER_FPS"
			end

			if str:find("obby") or str:find("tower") or str:find("parkour") or str:find("jump") then
				return "OBBY"
			end

			if str:find("simulator") or str:find("tycoon") or str:find("pet") or str:find("egg") or str:find("click") or str:find("mine") or str:find("fish") or #arg.Environment.InteractiveFolders > 0 or #arg.Environment.Prompts > 0 then
				return "SIMULATOR"
			end
			return "GENERIC"
		end,
		DetectGameArchetype = function(arg)
			local str = (arg.Environment.PlaceName or ""):lower()
			local all = arg.Environment.Remotes and arg.Environment.Remotes.All
			local str2 = ""

			if all then
				for _, v in ipairs(arg.Environment.Remotes.All) do
					str2 ..= " " .. v.Name:lower()
				end
			end

			local str3 = ""

			if arg.Environment.InteractiveFolders then
				for _, interactiveFolder in ipairs(arg.Environment.InteractiveFolders) do
					str3 ..= " " .. interactiveFolder.Name:lower()
				end
			end

			if str:find("pet") or str:find("egg") or str2:find("egg") or str2:find("pet") or str2:find("hatch") or str3:find("egg") or str3:find("pet") then
				return "PET_SIMULATOR", "🐣 Pet & Egg Simulator"
			end

			if #arg.Environment.Mobs > 0 or str:find("fruit") or str:find("blox") or str:find("piece") or str:find("slayer") or str:find("rpg") or str:find("dungeon") or str:find("bandit") or str2:find("attack") or str2:find("combat") then
				return "ANIME_ACTION_RPG", "⚔️ Anime Action & Mob RPG"
			end

			if str:find("click") or str:find("tap") or str:find("lift") or str:find("muscle") or str2:find("click") or str2:find("tap") or str2:find("rebirth") then
				return "CLICKER_SIMULATOR", "⚡ Clicker & Tapping Simulator"
			end

			if str:find("fish") or str:find("mine") or str2:find("fish") or str2:find("mine") or str3:find("ore") or str3:find("fish") then
				return "RESOURCE_GATHERER", "🎣 Fishing & Mining Gatherer"
			end

			if str:find("obby") or str:find("tower") or str:find("parkour") or str3:find("checkpoint") or str3:find("stage") then
				return "OBBY_PLATFORMER", "🏃 Obby & Parkour Platformer"
			end
			return "GENERIC", "🌐 Universal Sandbox Game"
		end,
		FindMatchingRemote = function(arg, arg2, arg3)
			local tbl8 = arg3 or {}

			local tbl9 = {
				EGG_HATCH = { "egg", "hatch", "buyegg", "openegg", "purchaseegg", "pet", "buy" },
				REBIRTH = { "rebirth", "prestige", "rankup", "ascend", "restart" },
				CLAIM_REWARDS = { "claim", "reward", "gift", "daily", "chest", "quest", "spin", "wheel", "collect" },
				COMBAT = {
					"attack",
					"punch",
					"swing",
					"hit",
					"damage",
					"slash",
					"combat",
					"strike",
					"shoot",
					"fire",
					"re/registerattack",
				},
				GATHER = { "mine", "fish", "cast", "reel", "chop", "harvest", "dig", "ore" },
				AUTO_CLICK = { "click", "tap", "punch", "swing", "add", "gain", "hit" },
				FARM = { "farm", "collect", "drop", "pickup" },
			}

			local tbl10 = {}

			if tbl9[arg2] then
				for _, v in ipairs(tbl9[arg2]) do
					table.insert(tbl10, v)
				end
			end

			for k in pairs(tbl8) do
				table.insert(tbl10, k)
			end

			if typeof(SpyCalls) == "table" and #SpyCalls > 0 then
				for _, v in ipairs(SpyCalls) do
					local str = (v.Name or ""):lower()

					for _, v2 in ipairs(tbl10) do
						if str:find(v2, 1, true) then
							return {
								Remote = v.Remote,
								Name = v.Name,
								Class = v.Class or "RemoteEvent",
								Path = v.Path or v.Remote and v.Remote:GetFullName() or "game:GetService('ReplicatedStorage')",
								Args = v.Args or {},
								Source = "SPY_CAPTURED",
							}
						end
					end
				end
			end

			if arg.Environment and arg.Environment.Remotes and arg.Environment.Remotes.All then
				for _, v in ipairs(arg.Environment.Remotes.All) do
					local str = (v.Name or ""):lower()

					for _, v2 in ipairs(tbl10) do
						if str:find(v2, 1, true) then
							return {
								Remote = v,
								Name = v.Name,
								Class = v.ClassName,
								Path = v:GetFullName(),
								Args = {},
								Source = "ENVIRONMENT_SCAN",
							}
						end
					end
				end
			end

			return nil
		end,
		RegisterACDetection = function(arg, suspects)
			arg.Environment.AntiCheatProfile.Suspects = suspects or {}
			arg.Environment.AntiCheatProfile.DetectedCount = #(suspects or {})

			if #arg.Environment.AntiCheatProfile.Suspects > 0 then
				arg.Environment.AntiCheatProfile.BypassesRequired = { SafeVelocity = true, SafeNoclip = true, SafeLerp = true, RemoteThrottle = true }
				fn2("WARN", "CENTRAL_BRAIN", string.format("Security Alert: Ingested %d Anti-Cheat signatures. Auto-defense bypasses armed.", #suspects))
			else
				arg.Environment.AntiCheatProfile.BypassesRequired = {}
				fn2("INFO", "CENTRAL_BRAIN", "Anti-Cheat scan clean. Standard execution mode enabled.")
			end
		end,
		SynthesizeScript = function(arg, arg2, arg3)
			local flag = arg.Environment.LastScanTime == 0

			if not flag then
				local lastScanTime = arg.Environment.LastScanTime
				flag = os.time() - lastScanTime > 300
			end

			if flag then
				arg:ScanEnvironment()
			end

			arg2 = arg2 or ""
			local v = string.lower(arg2)
			local v2 = tbl3:ExpandQuery(arg2)
			local tbl8 = {}

			for _, v3 in ipairs(v2) do
				tbl8[v3] = true
			end

			tbl8[v] = true
			local num = tonumber(string.match(arg2, "(%d+)"))
			local v3 = arg:DetectGameGenre()
			arg:DetectGameArchetype()

			local function fn7(arg4)
				return tbl8[arg4] or string.find(v, string.lower(arg4), 1, true) ~= nil
			end

			local str

			if fn7("ไง") or fn7("สวัสดี") or fn7("หวัดดี") or fn7("hello") or fn7("hi") or fn7("ดีครับ") or fn7("ดีจ้า") or fn7("hey") or v == "ไง" then
				str = "GREETING"
			elseif fn7("deob") or fn7("ถอดรหัส") or fn7("แกะ") or fn7("แกะโค้ด") or fn7("dumper") or fn7("luraph") or fn7("moonveil") or fn7("ironbrew") or fn7("moonsec") then
				str = "DEOB_CONSULT"
			elseif fn7("fly") or fn7("บิน") or fn7("เหาะ") or fn7("ลอย") then
				str = "FLY"
			elseif fn7("speed") or fn7("วิ่ง") or fn7("เดินเร็ว") or fn7("วิ่งเร็ว") or fn7("สปีด") then
				str = "SPEED"
			elseif fn7("esp") or fn7("มองทะลุ") or fn7("มองคน") or fn7("highlight") or fn7("วอลแฮก") then
				str = "ESP"
			elseif fn7("hitbox") or fn7("ขยายหัว") or fn7("ขยายเป้า") or fn7("เป้าใหญ่") or fn7("หัวใหญ่") or fn7("ขยายตัว") then
				str = "HITBOX"
			elseif fn7("aim") or fn7("lock") or fn7("ล็อกเป้า") or fn7("หัว") or fn7("ยิงหัว") or fn7("aimbot") or fn7("silent") then
				str = "AIMBOT"
			elseif fn7("inf") and (fn7("jump") or fn7("โดด")) or fn7("กระโดดรัว") or fn7("โดดไม่จำกัด") or fn7("กระโดดไม่จำกัด") or fn7("กระโดด") then
				str = "INF_JUMP"
			elseif fn7("egg") or fn7("hatch") or fn7("ไข่") or fn7("สุ่มไข่") or fn7("เปิดไข่") or fn7("pet") or fn7("สัตว์เลี้ยง") then
				str = "EGG_HATCH"
			elseif fn7("rebirth") or fn7("จุติ") or fn7("เกิดใหม่") or fn7("prestige") or fn7("rankup") then
				str = "REBIRTH"
			elseif fn7("claim") or fn7("reward") or fn7("รางวัล") or fn7("รับของ") or fn7("รับรางวัล") or fn7("gift") or fn7("daily") or fn7("quest") or fn7("เควส") or fn7("spin") then
				str = "CLAIM_REWARDS"
			elseif fn7("click") or fn7("tap") or fn7("คลิก") or fn7("คลิกออโต้") or fn7("กดรัว") or fn7("punch") or fn7("ฟาร์มคลิก") then
				str = "AUTO_CLICK"
			elseif fn7("fish") or fn7("ตกปลา") or fn7("เหยื่อ") or fn7("เบ็ด") or fn7("reel") or fn7("cast") then
				str = "FISHING"
			elseif fn7("mine") or fn7("ขุด") or fn7("ขุดแร่") or fn7("ore") or fn7("dig") then
				str = "MINING"
			elseif fn7("pull") or fn7("bring") or fn7("ดึงม็อบ") or fn7("รวมม็อบ") or fn7("ดูดม็อบ") or fn7("gather") then
				str = "MOB_PULL"
			elseif fn7("sword") or fn7("ดาบ") or fn7("kill") or fn7("ตี") or fn7("ฟัน") or fn7("killaura") or fn7("aura") then
				str = "COMBAT"
			elseif fn7("remote") or fn7("รีโมท") or fn7("ยิงรีโมท") or fn7("spy") or arg3 and arg3.Class and arg3.Class:find("Remote") then
				str = "REMOTE_CALL"
			elseif fn7("god") or fn7("อมตะ") or fn7("ไม่ตาย") or fn7("เลือดไม่ลด") then
				str = "GODMODE"
			else
				local noclip = fn7("noclip") or fn7("ทะลุ") or fn7("เดินทะลุ") or fn7("ทะลุกำแพง")
				str = "AUTO_FARM"

				if noclip then
					str = "NOCLIP"
				end
			end

			local boundItems = tbl2.BoundItems
			local name = nil
			local str2 = "RemoteEvent"

			if arg3 then
				if arg3.Class and arg3.Class:find("Remote") then
					name = arg3.Name
					str2 = arg3.Class
				elseif arg3.ClassName and arg3.ClassName:find("Remote") then
					name = arg3.Name
					str2 = arg3.ClassName
				else
					local flag2 = arg3.Class == "ProximityPrompt" or arg3.ClassName == "ProximityPrompt"
					name = nil

					if flag2 then
						name = nil

						if not arg3.Path then
							name = nil
						end
					end
				end
			end

			if not name and #boundItems > 0 then
				for _, boundItem in ipairs(boundItems) do
					if boundItem.ClassName:find("Remote") then
						name = boundItem.Name
						str2 = boundItem.ClassName
						break
					elseif boundItem.ClassName == "ProximityPrompt" then
					end
				end
			end

			if str == "GREETING" then
				return table.concat({
					"-- ======================================================================================",
					"-- [[ 🧠 PAYOMBOYZ CYBER-AI V8 - CO-PILOT ASSISTANT (ONLINE) ]]",
					"-- ======================================================================================",
					"--",
					"-- 💬 สวัสดีครับ! ยินดีต้อนรับสู่ระบบ PAYOMBOYZ AI CO-PILOT ⚡",
					"-- ผมเป็น AI ผู้ช่วยอัจฉริยะประจำ Script Hub พร้อมตอบคำถามและช่วยเหลือคุณ:",
					"--",
					"-- 1. 📜 เขียนและสร้างสคริปต์ (Script Synthesis):",
					"--    • พิมพ์ 'บิน' หรือ 'สคริปต์บิน' -> ระบบสร้างโค้ดบินพร้อมปุ่ม Touch สำหรับมือถือให้อัตโนมัติ",
					"--    • พิมพ์ 'มองทะลุคน' หรือ 'ESP' -> ไฮไลท์ผู้เล่นทะลุกำแพง",
					"--    • พิมพ์ 'วิ่งเร็ว 100' หรือ 'Speed 80' -> ปรับความเร็วเดินอย่างปลอดภัย",
					"--    • พิมพ์ 'ขยายหัว' หรือ 'Hitbox' -> ขยายเป้าศัตรูให้ยิง/ฟันโดนง่ายขึ้น",
					"--    • พิมพ์ 'ออโต้ฟาร์ม' -> สแกนแมพและสร้างลูปฟาร์มอัตโนมัติ",
					"--",
					"-- 2. 🔍 ถอดรหัสและวิเคราะห์โค้ด (Deobfuscation & Reverse Engineering):",
					"--    • แนะนำโครงสร้าง VM ของ Prometheus, WeAreDevs, Luraph, Moonveil, MoonSec, IronBrew",
					"--    • แนะนำการ Hook Metatable (__namecall, __index) เพื่อดักจับ Remote หรือ Bypass Anti-Cheat",
					"--",
					"-- 💡 คุณสามารถพิมพ์คำถามหรือคำสั่งที่ต้องการได้เลยครับ พร้อมตอบทันที!",
					"-- ======================================================================================",
				}, "\n")
			end

			if str == "DEOB_CONSULT" then
				return table.concat({
					"-- ======================================================================================",
					"-- [[ 🔍 PAYOMBOYZ DEOBFUSCATION EXPERT ADVISOR ]]",
					"-- ======================================================================================",
					"--",
					"-- 💡 คำแนะนำการถอดรหัส (Deobfuscate Guide) สำหรับสคริปต์ Roblox:",
					"--",
					"-- 1. 🛠️ WeAreDevs (Prometheus):",
					"--    - ใช้เทคนิค Sandboxed Emulation ดักจับการถอดรหัสในหน่วยความจำและดึง Payload ที่แท้จริงออกมา",
					"-- 2. 🌙 Moonveil 2.0.2+:",
					"--    - ใช้ Luau VM AST Emulation Dumper แกะ Bytecode/Opcode ที่ถูกหุ้มใน VM กลับมาเป็นโค้ดอ่านง่าย",
					"-- 3. 🔒 Luraph (Old / Classic):",
					"--    - ใช้ AST Devirtualizer แปลง Control Flow Flattening และคืนค่า String Table",
					"-- 4. ☕ IronBrew & MoonSec:",
					"--    - ใช้ AST Lifter ถอดสมการ Bitwise และ XOR เพื่อดึงค่า Constants และ Global References",
					"-- 5. 🛡️ 2K Security & Loaders:",
					"--    - ถอดรหัส XOR Layer แรก แล้ว Intercept ฟังก์ชัน loadstring เพื่อดึง Main Script",
					"--",
					"-- 🚀 วิธีใช้งานใน Discord Bot: พิมพ์ /deobf แล้วแนบไฟล์ .lua หรือพิมพ์โค้ดเพื่อถอดรหัสอัตโนมัติ!",
					"-- ======================================================================================",
				}, "\n")
			end

			local tbl9 = {}

			local function fn8(arg4)
				table.insert(tbl9, arg4 or "")
			end

			fn8("-- ======================================================================================")
			fn8("-- [[ 🧠 PAYOMBOYZ CYBER-AI V8 - AUTONOMOUS SYNTHESIZED SYSTEM ]]")
			fn8("-- User Prompt: " .. arg2)
			fn8(string.format("-- Target Environment: %s (PlaceId: %d)", arg.Environment.PlaceName, arg.Environment.PlaceId))
			fn8("-- Architecture Standard: Maid Pattern + Finite State Machine (PayomboyZ Knowledge Base)")
			fn8(string.format("-- Mapped Telemetry: %d Remotes | %d Prompts | %d Interactive Folders", #arg.Environment.Remotes.All, #arg.Environment.Prompts, #arg.Environment.InteractiveFolders))

			if arg.Environment.AntiCheatProfile.DetectedCount > 0 then
				fn8(string.format("-- Security Guard: Armed bypasses against %d detected anti-cheat checks", arg.Environment.AntiCheatProfile.DetectedCount))
			end

			fn8("-- --------------------------------------------------------------------------------------")
			fn8("-- 💡 [คำแนะนำและวิธีใช้งานจาก AI (AI Analysis & Recommendations)]:")

			if str == "FLY" then
				fn8("-- • การตรวจจับของเกม: ตรวจพบโครงสร้างตัวละครและระบบฟิสิกส์ รองรับการบินแบบ Kinematic CFrame/Velocity")
				fn8("-- • วิธีใช้งานบน PC: กด [E] เพื่อเปิด/ปิดการบิน, กด [W/A/S/D] บินตามมุมกล้อง, [Space] ลอยขึ้น, [Left Shift] ลดระดับลง")
				fn8("-- • วิธีใช้งานบน Mobile: ระบบสร้างปุ่มลอยหน้าจอ [✈️ Fly], [⬆️ บินขึ้น], [⬇️ บินลง] ให้อัตโนมัติ เล่นง่ายบนมือถือไม่ต้องใช้คีย์บอร์ด!")
				fn8("-- • คำแนะนำความปลอดภัย: แนะนำความเร็ว 60-100 studs/s เพื่อป้องกัน Anti-Cheat ในบางแมพดีดหลุด")
			elseif str == "SPEED" then
				fn8("-- • การตรวจจับของเกม: ปรับแต่ง WalkSpeed พร้อมระบบ Heartbeat Clamp ป้องกันเกม Reset ค่ากลับ")
				fn8("-- • วิธีใช้งาน: ปรับความเร็วตัวละครทันที และคืนค่าเริ่มต้นอัตโนมัติเมื่อกด Stop Script")
				fn8("-- • คำแนะนำความปลอดภัย: แนะนำความเร็วไม่เกิน 70 studs/s ป้องกันการสะดุดหลุดเซิร์ฟ")
			elseif str == "ESP" then
				fn8("-- • การตรวจจับของเกม: ใช้ Roblox Highlight Object คุณภาพสูง แสดงกรอบแสงทะลุกำแพง ไม่ดรอป FPS")
				fn8("-- • วิธีใช้งาน: แสดงตำแหน่งศัตรู/ผู้เล่นทุกคนในแมพ พร้อมระบุชื่อและระยะห่าง")
			else
				fn8("-- • การตรวจจับของเกม: สแกนโครงสร้าง Remotes และ ProximityPrompts ในแมพอัตโนมัติ")
				fn8("-- • วิธีใช้งาน: สคริปต์ทำงานเบื้องหลัง พร้อมระบบ Maid Cleanup คืนหน่วยความจำเมื่อหยุดทำงาน")
				fn8("-- • คำแนะนำความปลอดภัย: สามารถกดปุ่ม Stop Script สีแดงด้านบนเพื่อยกเลิกการทำงานได้ตลอดเวลา")
			end

			fn8("-- ======================================================================================")
			fn8("")
			fn8("local Players = game:GetService(\"Players\")")
			fn8("local RunService = game:GetService(\"RunService\")")
			fn8("local TweenService = game:GetService(\"TweenService\")")
			fn8("local UserInputService = game:GetService(\"UserInputService\")")
			fn8("local CoreGui = game:GetService(\"CoreGui\")")
			fn8("")
			fn8("local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()")
			fn8("local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()")
			fn8("local Humanoid = Character:WaitForChild(\"Humanoid\")")
			fn8("local RootPart = Character:WaitForChild(\"HumanoidRootPart\")")
			fn8("")
			fn8("-- 🧹 Connection Lifecycle & Resource Maid (From PayomboyZ Knowledge: patterns/cleanup.md)")
			fn8("local Maid = {}")
			fn8("Maid.__index = Maid")
			fn8("function Maid.new() return setmetatable({ _tasks = {} }, Maid) end")
			fn8("function Maid:GiveTask(task) table.insert(self._tasks, task); return task end")
			fn8("function Maid:DoCleaning()")
			fn8("    for i = #self._tasks, 1, -1 do")
			fn8("        local t = self._tasks[i]")
			fn8("        self._tasks[i] = nil")
			fn8("        if typeof(t) == \"RBXScriptConnection\" then t:Disconnect()")
			fn8("        elseif type(t) == \"function\" then pcall(t)")
			fn8("        elseif typeof(t) == \"Instance\" then pcall(function() t:Destroy() end)")
			fn8("        elseif type(t) == \"table\" and type(t.Destroy) == \"function\" then pcall(function() t:Destroy() end)")
			fn8("        elseif typeof(t) == \"thread\" then pcall(function() task.cancel(t) end) end")
			fn8("    end")
			fn8("end")
			fn8("")
			fn8("local ScriptMaid = Maid.new()")
			fn8("local ScriptActive = true")
			fn8("local State = \"RUNNING\"")
			fn8("")
			fn8("-- Character Respawn Handler")
			fn8("ScriptMaid:GiveTask(LocalPlayer.CharacterAdded:Connect(function(newChar)")
			fn8("    Character = newChar")
			fn8("    Humanoid = newChar:WaitForChild(\"Humanoid\")")
			fn8("    RootPart = newChar:WaitForChild(\"HumanoidRootPart\")")
			fn8("end))")
			fn8("")

			if str == "AUTO_FARM" then
				if v3 == "RPG_COMBAT" or #arg.Environment.Mobs > 0 then
					fn8("-- [[ SUB-SYSTEM: AUTONOMOUS RPG MOB COMBAT & HOVER FARM ENGINE ]]")
					fn8("local function getNearestLivingMob()")
					fn8("    local closest, dist = nil, 650")
					fn8("    local candidates = {}")
					fn8("    local mobFolders = { \"Enemies\", \"Mobs\", \"Monsters\", \"NPCs\", \"Zombies\", \"Bandits\", \"Spawns\", \"Living\", \"Targets\" }")
					fn8("    for _, fName in ipairs(mobFolders) do")
					fn8("        local folder = workspace:FindFirstChild(fName)")
					fn8("        if folder then")
					fn8("            for _, c in ipairs(folder:GetChildren()) do table.insert(candidates, c) end")
					fn8("        end")
					fn8("    end")
					fn8("    if #candidates == 0 then")
					fn8("        for _, c in ipairs(workspace:GetChildren()) do table.insert(candidates, c) end")
					fn8("    end")
					fn8("    for _, m in ipairs(candidates) do")
					fn8("        if m:IsA(\"Model\") and m ~= Character and not Players:GetPlayerFromCharacter(m) then")
					fn8("            local h = m:FindFirstChildOfClass(\"Humanoid\")")
					fn8("            local hrp = m:FindFirstChild(\"HumanoidRootPart\") or m:FindFirstChildWhichIsA(\"BasePart\")")
					fn8("            if h and h.Health > 0 and hrp and RootPart then")
					fn8("                local d = (RootPart.Position - hrp.Position).Magnitude")
					fn8("                if d < dist then")
					fn8("                    dist = d")
					fn8("                    closest = { Model = m, Root = hrp, Hum = h }")
					fn8("                end")
					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("    return closest")
					fn8("end")
					fn8("")
					fn8("local mobFarmLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(0.08)")
					fn8("        if State == \"RUNNING\" and RootPart and RootPart.Parent then")
					fn8("            local mob = getNearestLivingMob()")
					fn8("            if mob and mob.Root and mob.Hum and mob.Hum.Health > 0 then")
					fn8("                -- Safe Hover: Position 5.5 studs directly above mob, facing straight down")
					fn8("                RootPart.CFrame = mob.Root.CFrame * CFrame.new(0, 5.5, 0) * CFrame.Angles(math.rad(-90), 0, 0)")
					fn8("                RootPart.AssemblyLinearVelocity = Vector3.zero")
					fn8("                -- Auto Equip Weapon Tool")
					fn8("                local tool = Character:FindFirstChildOfClass(\"Tool\") or LocalPlayer.Backpack:FindFirstChildOfClass(\"Tool\")")
					fn8("                if tool and tool.Parent ~= Character then Humanoid:EquipTool(tool) end")
					fn8("                if tool then tool:Activate() end")
					fn8("                -- VirtualUser Click (Hits targets in Blox Fruits and action RPGs)")
					fn8("                pcall(function()")
					fn8("                    game:GetService(\"VirtualUser\"):CaptureController()")
					fn8("                    game:GetService(\"VirtualUser\"):Button1Down(Vector2.new(0, 0))")
					fn8("                end)")
					fn8("                -- Auto Combat Remote Dispatch")
					fn8("                pcall(function()")
					fn8("                    local net = game:GetService(\"ReplicatedStorage\"):FindFirstChild(\"Net\", true) or game:GetService(\"ReplicatedStorage\")")
					fn8("                    local atkRem = net:FindFirstChild(\"RE/RegisterAttack\", true) or net:FindFirstChild(\"RegisterAttack\", true) or net:FindFirstChild(\"Attack\", true)")
					fn8("                    if atkRem and atkRem:IsA(\"RemoteEvent\") then atkRem:FireServer(0) end")
					fn8("                end)")

					if name then
						fn8("                -- Fire Targeted Combat Remote")
						fn8("                pcall(function()")
						fn8(string.format("                    local rem = game:GetService(\"ReplicatedStorage\"):FindFirstChild(%q, true)", name))
						fn8("                    if rem then")

						if str2:find("Function") then
							fn8("                        rem:InvokeServer(mob.Model)")
						else
							fn8("                        rem:FireServer(mob.Model)")
						end

						fn8("                    end")
						fn8("                end)")
					end

					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(mobFarmLoop)")
					fn8("")
					fn8("-- Continuous Safe Noclip Loop to prevent collision snags")
					fn8("local ncConn = RunService.Stepped:Connect(function()")
					fn8("    if Character then")
					fn8("        for _, p in ipairs(Character:GetChildren()) do")
					fn8("            if p:IsA(\"BasePart\") then p.CanCollide = false end")
					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(ncConn)")
				elseif game.PlaceId == 142823291 or tbl8.coin or tbl8["เหรียญ"] or tbl8["เก็บเหรียญ"] or workspace:FindFirstChild("CoinContainer", true) ~= nil or workspace:FindFirstChild("Coin_Server", true) ~= nil then
					fn8("-- [[ SUB-SYSTEM: ADAPTIVE MULTI-MAP COIN & DROP HARVEST ENGINE ]]")
					fn8("local CoinContainer = nil")
					fn8("local CurrentCoins = {}")
					fn8("local CoinsCollectedCount = 0")
					fn8("")
					fn8("local function findCoinContainer()")
					fn8("    local cc = workspace:FindFirstChild(" .. string.format("%q", "CoinContainer") .. ", true)")
					fn8("    if cc then return cc end")
					fn8("    for _, child in ipairs(workspace:GetChildren()) do")
					fn8("        if child:IsA(\"Model\") and child.Name ~= \"RegularLobby\" then")
					fn8("            local sub = child:FindFirstChild(\"CoinContainer\") or child:FindFirstChild(\"Coins\") or child:FindFirstChild(\"Drops\")")
					fn8("            if sub then return sub end")
					fn8("        end")
					fn8("    end")
					fn8("    return nil")
					fn8("end")
					fn8("")
					fn8("local ncConn = RunService.Stepped:Connect(function()")
					fn8("    if Character then")
					fn8("        for _, p in ipairs(Character:GetChildren()) do")
					fn8("            if p:IsA(\"BasePart\") then p.CanCollide = false end")
					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(ncConn)")
					fn8("")
					fn8("local coinHarvestLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(0.10)")
					fn8("        if State == \"RUNNING\" and RootPart and RootPart.Parent then")
					fn8("            if not CoinContainer or not CoinContainer.Parent then")
					fn8("                CoinContainer = findCoinContainer()")
					fn8("                CoinsCollectedCount = 0")
					fn8("            end")
					fn8("")
					fn8("            if CoinContainer and CoinContainer.Parent then")
					fn8("                local coins = {}")
					fn8("                for _, obj in ipairs(CoinContainer:GetChildren()) do")
					fn8("                    local p = obj:IsA(\"BasePart\") and obj or obj:FindFirstChildWhichIsA(\"BasePart\")")
					fn8("                    if p and p.Parent then")
					fn8("                        local dist = (RootPart.Position - p.Position).Magnitude")
					fn8("                        table.insert(coins, { Part = p, Distance = dist })")
					fn8("                    end")
					fn8("                end")
					fn8("")
					fn8("                if #coins > 0 then")
					fn8("                    table.sort(coins, function(a, b) return a.Distance < b.Distance end)")
					fn8("                    local target = coins[1]")
					fn8("                    if target and target.Part and target.Part.Parent then")
					fn8("                        local travelDist = (RootPart.Position - target.Part.Position).Magnitude")
					fn8("                        local travelTime = math.clamp(travelDist / 50, 0.06, 0.40)")
					fn8("                        local tw = TweenService:Create(RootPart, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {")
					fn8("                            CFrame = target.Part.CFrame + Vector3.new(0, 0.5, 0)")
					fn8("                        })")
					fn8("                        tw:Play()")
					fn8("                        tw.Completed:Wait()")
					fn8("")
					fn8("                        pcall(function()")
					fn8("                            firetouchinterest(RootPart, target.Part, 0)")
					fn8("                            task.wait(0.04)")
					fn8("                            firetouchinterest(RootPart, target.Part, 1)")
					fn8("                        end)")
					fn8("")
					fn8("                        CoinsCollectedCount = CoinsCollectedCount + 1")
					fn8("                        task.wait(0.06)")
					fn8("                    end")
					fn8("                else")
					fn8("                    task.wait(1.5)")
					fn8("                end")
					fn8("            else")
					fn8("                task.wait(2.0)")
					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(coinHarvestLoop)")
				else
					fn8("-- [[ SUB-SYSTEM: AUTONOMOUS INTERACTIVE TARGET FINDER & FARM ENGINE ]]")
					fn8("local function getInteractiveTargets()")
					fn8("    local targets = {}")
					fn8("    -- ProximityPrompts")
					fn8("    for _, obj in ipairs(workspace:GetDescendants()) do")
					fn8("        if obj:IsA(\"ProximityPrompt\") and obj.Enabled then")
					fn8("            local basePart = obj:FindFirstAncestorWhichIsA(\"BasePart\") or obj.Parent")
					fn8("            if basePart and basePart:IsA(\"BasePart\") then")
					fn8("                table.insert(targets, { Type = \"Prompt\", Object = obj, Part = basePart, Position = basePart.Position })")
					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("    -- Interactive Drop/Coin folders")
					fn8("    local checkFolders = { \"Coins\", \"RecyclerCoins\", \"NestEggs\", \"Drops\", \"Chests\", \"Ores\", \"Eggs\", \"CoinContainer\" }")
					fn8("    for _, fName in ipairs(checkFolders) do")
					fn8("        local folder = workspace:FindFirstChild(fName, true)")
					fn8("        if folder then")
					fn8("            for _, item in ipairs(folder:GetChildren()) do")
					fn8("                local p = item:IsA(\"BasePart\") and item or item:FindFirstChildWhichIsA(\"BasePart\")")
					fn8("                if p then")
					fn8("                    table.insert(targets, { Type = \"Pickup\", Object = item, Part = p, Position = p.Position })")
					fn8("                end")
					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("    return targets")
					fn8("end")
					fn8("")
					fn8("local function safeMoveTo(targetPos)")
					fn8("    if not RootPart or not RootPart.Parent then return false end")
					fn8("    local dist = (RootPart.Position - targetPos).Magnitude")
					fn8("    if dist < 4 then return true end")
					fn8("    local steps = math.clamp(math.floor(dist / 14), 1, 8)")
					fn8("    for i = 1, steps do")
					fn8("        if not ScriptActive then break end")
					fn8("        RootPart.CFrame = RootPart.CFrame:Lerp(CFrame.new(targetPos + Vector3.new(0, 2, 0)), i / steps)")
					fn8("        task.wait(0.035)")
					fn8("    end")
					fn8("    return true")
					fn8("end")
					fn8("")
					fn8("local farmLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(0.12)")
					fn8("        if State == \"RUNNING\" and RootPart and RootPart.Parent then")
					fn8("            local list = getInteractiveTargets()")
					fn8("            if #list > 0 then")
					fn8("                table.sort(list, function(a, b)")
					fn8("                    return (RootPart.Position - a.Position).Magnitude < (RootPart.Position - b.Position).Magnitude")
					fn8("                end)")
					fn8("                local nearest = list[1]")
					fn8("                if nearest and (RootPart.Position - nearest.Position).Magnitude < 450 then")
					fn8("                    safeMoveTo(nearest.Position)")
					fn8("                    if nearest.Type == \"Prompt\" then")
					fn8("                        pcall(fireproximityprompt, nearest.Object, 0)")
					fn8("                    elseif nearest.Type == \"Pickup\" then")
					fn8("                        pcall(function()")
					fn8("                            firetouchinterest(RootPart, nearest.Part, 0)")
					fn8("                            firetouchinterest(RootPart, nearest.Part, 1)")
					fn8("                        end)")
					fn8("                    end")
					fn8("                end")
					fn8("            end")

					if name then
						fn8("            -- Call Discovered / Bound Game Remote")
						fn8("            pcall(function()")
						fn8("                local rep = game:GetService(\"ReplicatedStorage\")")
						fn8(string.format("                local rem = rep:FindFirstChild(%q, true)", name))
						fn8("                if rem then")

						if str2:find("Function") then
							fn8("                    rem:InvokeServer()")
						else
							fn8("                    rem:FireServer()")
						end

						fn8("                end")
						fn8("            end)")
					end

					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(farmLoop)")
				end
			elseif str == "FLY" then
				local n = num or 80
				fn8("-- [[ SUB-SYSTEM: DUAL PC + MOBILE TOUCH FLIGHT CONTROLLER ]]")
				fn8(string.format("local FlySpeed = %d", n))
				fn8("local Flying = true")
				fn8("local MobileUp = false")
				fn8("local MobileDown = false")
				fn8("local Camera = workspace.CurrentCamera")
				fn8("")
				fn8("local BV = Instance.new(\"BodyVelocity\")")
				fn8("BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)")
				fn8("BV.Velocity = Vector3.zero")
				fn8("BV.Parent = RootPart")
				fn8("ScriptMaid:GiveTask(BV)")
				fn8("")
				fn8("local BG = Instance.new(\"BodyGyro\")")
				fn8("BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)")
				fn8("BG.CFrame = RootPart.CFrame")
				fn8("BG.Parent = RootPart")
				fn8("ScriptMaid:GiveTask(BG)")
				fn8("")
				fn8("-- 📱 Mobile Touch Controls HUD")
				fn8("local touchHud = Instance.new(\"ScreenGui\")")
				fn8("touchHud.Name = \"PayomboyZ_MobileFlyHUD_\" .. tostring(tick())")
				fn8("touchHud.ResetOnSpawn = false")
				fn8("touchHud.Parent = (typeof(gethui) == \"function\" and gethui()) or game:GetService(\"CoreGui\")")
				fn8("ScriptMaid:GiveTask(touchHud)")
				fn8("")
				fn8("local function createBtn(name, text, pos, color)")
				fn8("    local b = Instance.new(\"TextButton\")")
				fn8("    b.Name = name")
				fn8("    b.Text = text")
				fn8("    b.Size = UDim2.new(0, 75, 0, 42)")
				fn8("    b.Position = pos")
				fn8("    b.BackgroundColor3 = color")
				fn8("    b.TextColor3 = Color3.fromRGB(255, 255, 255)")
				fn8("    b.Font = Enum.Font.GothamBold")
				fn8("    b.TextSize = 13")
				fn8("    b.Parent = touchHud")
				fn8("    local c = Instance.new(\"UICorner\"); c.CornerRadius = UDim.new(0, 8); c.Parent = b")
				fn8("    return b")
				fn8("end")
				fn8("")
				fn8("local flyToggleBtn = createBtn(\"FlyToggle\", \"✈️ Fly: ON\", UDim2.new(1, -95, 0.5, -60), Color3.fromRGB(0, 170, 90))")
				fn8("local upBtn = createBtn(\"UpBtn\", \"⬆️ Up\", UDim2.new(1, -95, 0.5, -10), Color3.fromRGB(30, 120, 210))")
				fn8("local downBtn = createBtn(\"DownBtn\", \"⬇️ Down\", UDim2.new(1, -95, 0.5, 40), Color3.fromRGB(30, 120, 210))")
				fn8("")
				fn8("flyToggleBtn.MouseButton1Click:Connect(function()")
				fn8("    Flying = not Flying")
				fn8("    flyToggleBtn.Text = Flying and \"✈️ Fly: ON\" or \"✈️ Fly: OFF\"")
				fn8("    flyToggleBtn.BackgroundColor3 = Flying and Color3.fromRGB(0, 170, 90) or Color3.fromRGB(150, 40, 40)")
				fn8("    if not Flying then BV.Velocity = Vector3.zero end")
				fn8("end)")
				fn8("")
				fn8("upBtn.InputBegan:Connect(function(input)")
				fn8("    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then")
				fn8("        MobileUp = true")
				fn8("    end")
				fn8("end)")
				fn8("upBtn.InputEnded:Connect(function(input)")
				fn8("    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then")
				fn8("        MobileUp = false")
				fn8("    end")
				fn8("end)")
				fn8("")
				fn8("downBtn.InputBegan:Connect(function(input)")
				fn8("    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then")
				fn8("        MobileDown = true")
				fn8("    end")
				fn8("end)")
				fn8("downBtn.InputEnded:Connect(function(input)")
				fn8("    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then")
				fn8("        MobileDown = false")
				fn8("    end")
				fn8("end)")
				fn8("")
				fn8("-- PC Keybind Toggle [E]")
				fn8("local keyConn = UserInputService.InputBegan:Connect(function(input, gpe)")
				fn8("    if not gpe and input.KeyCode == Enum.KeyCode.E then")
				fn8("        Flying = not Flying")
				fn8("        flyToggleBtn.Text = Flying and \"✈️ Fly: ON\" or \"✈️ Fly: OFF\"")
				fn8("        flyToggleBtn.BackgroundColor3 = Flying and Color3.fromRGB(0, 170, 90) or Color3.fromRGB(150, 40, 40)")
				fn8("        if not Flying then BV.Velocity = Vector3.zero end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(keyConn)")
				fn8("")
				fn8("local flyConn = RunService.Heartbeat:Connect(function()")
				fn8("    if not ScriptActive or not RootPart or not RootPart.Parent or not Flying then")
				fn8("        if BV and BV.Parent then BV.Velocity = Vector3.zero end")
				fn8("        return")
				fn8("    end")
				fn8("    local moveDir = Vector3.zero")
				fn8("    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end")
				fn8("    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end")
				fn8("    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end")
				fn8("    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end")
				fn8("    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or MobileUp then moveDir = moveDir + Vector3.new(0, 1, 0) end")
				fn8("    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or MobileDown then moveDir = moveDir - Vector3.new(0, 1, 0) end")
				fn8("    BV.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * FlySpeed) or Vector3.zero")
				fn8("    BG.CFrame = Camera.CFrame")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(flyConn)")
				fn8("")
				fn8("-- Safe Noclip loop during flight")
				fn8("local noclipConn = RunService.Stepped:Connect(function()")
				fn8("    if Character and Flying then")
				fn8("        for _, part in ipairs(Character:GetChildren()) do")
				fn8("            if part:IsA(\"BasePart\") then part.CanCollide = false end")
				fn8("        end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(noclipConn)")
			elseif str == "SPEED" then
				local n = num or 65
				fn8("-- [[ SUB-SYSTEM: SAFE VELOCITY SPEED BOOSTER ]]")
				fn8(string.format("local TargetSpeed = %d", n))
				fn8("Humanoid.WalkSpeed = TargetSpeed")
				fn8("local speedLoop = RunService.Heartbeat:Connect(function()")
				fn8("    if Humanoid and Humanoid.WalkSpeed ~= TargetSpeed then")
				fn8("        Humanoid.WalkSpeed = TargetSpeed")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(speedLoop)")
			elseif str == "ESP" then
				fn8("-- [[ SUB-SYSTEM: CHAMS & HIGHLIGHT ESP MATRIX ]]")
				fn8("local highlights = {}")
				fn8("local function applyESP(player)")
				fn8("    if player ~= LocalPlayer and player.Character then")
				fn8("        local hl = player.Character:FindFirstChildOfClass(\"Highlight\") or Instance.new(\"Highlight\")")
				fn8("        hl.FillColor = Color3.fromRGB(0, 240, 120)")
				fn8("        hl.OutlineColor = Color3.fromRGB(255, 255, 255)")
				fn8("        hl.FillTransparency = 0.45")
				fn8("        hl.OutlineTransparency = 0.1")
				fn8("        hl.Parent = player.Character")
				fn8("        highlights[player] = hl")
				fn8("    end")
				fn8("end")
				fn8("")
				fn8("for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end")
				fn8("ScriptMaid:GiveTask(Players.PlayerAdded:Connect(function(p)")
				fn8("    ScriptMaid:GiveTask(p.CharacterAdded:Connect(function() task.wait(0.5); applyESP(p) end))")
				fn8("end))")
				fn8("ScriptMaid:GiveTask(Players.PlayerRemoving:Connect(function(p)")
				fn8("    if highlights[p] then highlights[p]:Destroy(); highlights[p] = nil end")
				fn8("end))")
				fn8("ScriptMaid:GiveTask(function()")
				fn8("    for _, hl in pairs(highlights) do pcall(function() hl:Destroy() end) end")
				fn8("end)")
			elseif str == "HITBOX" then
				num = num or 18
				fn8("-- [[ SUB-SYSTEM: UNIVERSAL HITBOX EXPANDER MATRIX ]]")
				fn8(string.format("local HitboxSize = Vector3.new(%d, %d, %d)", num, num, num))
				fn8("local originalSizes = {}")
				fn8("local function expandTarget(character)")
				fn8("    if not character or character == Character then return end")
				fn8("    local hrp = character:FindFirstChild(\"HumanoidRootPart\") or character:FindFirstChild(\"Head\")")
				fn8("    if hrp and hrp:IsA(\"BasePart\") and not originalSizes[hrp] then")
				fn8("        originalSizes[hrp] = { Size = hrp.Size, Transparency = hrp.Transparency, CanCollide = hrp.CanCollide }")
				fn8("        hrp.Size = HitboxSize")
				fn8("        hrp.Transparency = 0.55")
				fn8("        hrp.BrickColor = BrickColor.new(\"Really blue\")")
				fn8("        hrp.Material = Enum.Material.Neon")
				fn8("        hrp.CanCollide = false")
				fn8("    end")
				fn8("end")
				fn8("")
				fn8("for _, p in ipairs(Players:GetPlayers()) do")
				fn8("    if p ~= LocalPlayer and p.Character then expandTarget(p.Character) end")
				fn8("end")
				fn8("ScriptMaid:GiveTask(Players.PlayerAdded:Connect(function(p)")
				fn8("    ScriptMaid:GiveTask(p.CharacterAdded:Connect(function(c) task.wait(0.5); expandTarget(c) end))")
				fn8("end))")
				fn8("ScriptMaid:GiveTask(function()")
				fn8("    for part, data in pairs(originalSizes) do")
				fn8("        if part and part.Parent then")
				fn8("            pcall(function() part.Size = data.Size; part.Transparency = data.Transparency; part.CanCollide = data.CanCollide end)")
				fn8("        end")
				fn8("    end")
				fn8("end)")
			elseif str == "AIMBOT" then
				num = num or 180
				fn8("-- [[ SUB-SYSTEM: PREDICTIVE CAMERA AIMLOCK ENGINE ]]")
				fn8(string.format("local AimFOV = %d", num))
				fn8("local Camera = workspace.CurrentCamera")
				fn8("local function getClosestEnemyToCrosshair()")
				fn8("    local target, minDistance = nil, AimFOV")
				fn8("    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)")
				fn8("    for _, p in ipairs(Players:GetPlayers()) do")
				fn8("        if p ~= LocalPlayer and p.Character then")
				fn8("            local head = p.Character:FindFirstChild(\"Head\")")
				fn8("            local h = p.Character:FindFirstChildOfClass(\"Humanoid\")")
				fn8("            if head and h and h.Health > 0 then")
				fn8("                local sPos, onScreen = Camera:WorldToViewportPoint(head.Position)")
				fn8("                if onScreen then")
				fn8("                    local d = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude")
				fn8("                    if d < minDistance then")
				fn8("                        minDistance = d")
				fn8("                        target = head")
				fn8("                    end")
				fn8("                end")
				fn8("            end")
				fn8("        end")
				fn8("    end")
				fn8("    return target")
				fn8("end")
				fn8("")
				fn8("local aimConn = RunService.RenderStepped:Connect(function()")
				fn8("    if not ScriptActive then return end")
				fn8("    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then")
				fn8("        local t = getClosestEnemyToCrosshair()")
				fn8("        if t then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, t.Position) end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(aimConn)")
			elseif str == "INF_JUMP" then
				fn8("-- [[ SUB-SYSTEM: INFINITE JUMP STATE CONTROLLER ]]")
				fn8("local jumpConn = UserInputService.JumpRequest:Connect(function()")
				fn8("    if not ScriptActive then return end")
				fn8("    if Humanoid and Humanoid.Parent then")
				fn8("        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(jumpConn)")
			elseif str == "COMBAT" then
				fn8("-- [[ SUB-SYSTEM: AUTONOMOUS COMBAT & TARGET ENGAGEMENT ENGINE ]]")
				fn8("local function getNearestEnemy()")
				fn8("    local closest, dist = nil, 250")
				fn8("    for _, m in ipairs(workspace:GetDescendants()) do")
				fn8("        if m:IsA(\"Model\") and m ~= Character and m:FindFirstChildOfClass(\"Humanoid\") then")
				fn8("            local h = m:FindFirstChildOfClass(\"Humanoid\")")
				fn8("            local hrp = m:FindFirstChild(\"HumanoidRootPart\") or m:FindFirstChildWhichIsA(\"BasePart\")")
				fn8("            if h and h.Health > 0 and hrp and RootPart then")
				fn8("                local d = (RootPart.Position - hrp.Position).Magnitude")
				fn8("                if d < dist and not Players:GetPlayerFromCharacter(m) then")
				fn8("                    dist = d")
				fn8("                    closest = { Model = m, Root = hrp, Hum = h }")
				fn8("                end")
				fn8("            end")
				fn8("        end")
				fn8("    end")
				fn8("    return closest")
				fn8("end")
				fn8("")
				fn8("local combatLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.1)")
				fn8("        local enemy = getNearestEnemy()")
				fn8("        if enemy and RootPart then")
				fn8("            -- Equip Weapon Tool")
				fn8("            local tool = Character:FindFirstChildOfClass(\"Tool\") or LocalPlayer.Backpack:FindFirstChildOfClass(\"Tool\")")
				fn8("            if tool and tool.Parent ~= Character then Humanoid:EquipTool(tool) end")
				fn8("            if tool then tool:Activate() end")
				fn8("            RootPart.CFrame = CFrame.lookAt(RootPart.Position, Vector3.new(enemy.Root.Position.X, RootPart.Position.Y, enemy.Root.Position.Z))")

				if name then
					fn8(string.format("            pcall(function() game:GetService(\"ReplicatedStorage\"):FindFirstChild(%q, true):FireServer(enemy.Model) end)", name))
				end

				fn8("        end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(combatLoop)")
			elseif str == "EGG_HATCH" then
				local eggHatch = arg:FindMatchingRemote("EGG_HATCH", tbl8)
				fn8("-- [[ SUB-SYSTEM: AUTONOMOUS EGG HATCHING & PET SPAWNER ENGINE ]]")

				if eggHatch then
					fn8(string.format("-- Discovered Hatch Remote: %s via %s", eggHatch.Name, eggHatch.Source))
					fn8("local rep = game:GetService(\"ReplicatedStorage\")")
					fn8(string.format("local hatchRemote = rep:FindFirstChild(%q, true)", eggHatch.Name))
					local str3

					if #eggHatch.Args > 0 then
						local tbl10 = {}

						for _, arg4 in ipairs(eggHatch.Args) do
							table.insert(tbl10, SerializationEngine.Serialize(arg4))
						end

						str3 = table.concat(tbl10, ", ")
					else
						str3 = "1, false"
					end

					fn8("local hatchLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(0.2)")
					fn8("        if hatchRemote then")

					if eggHatch.Class:find("Function") then
						fn8(string.format("            pcall(function() hatchRemote:InvokeServer(%s) end)", str3))
					else
						fn8(string.format("            pcall(function() hatchRemote:FireServer(%s) end)", str3))
					end

					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(hatchLoop)")
				else
					fn8("-- Fallback: Physical World Egg Hatch Prompt Scanner")
					fn8("local hatchLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(0.25)")
					fn8("        for _, obj in ipairs(workspace:GetDescendants()) do")
					fn8("            if obj:IsA(\"ProximityPrompt\") and (obj.Parent.Name:lower():find(\"egg\") or obj.ObjectText:lower():find(\"egg\")) then")
					fn8("                local eggPart = obj:FindFirstAncestorWhichIsA(\"BasePart\") or obj.Parent")
					fn8("                if eggPart and RootPart and (RootPart.Position - eggPart.Position).Magnitude < 25 then")
					fn8("                    pcall(fireproximityprompt, obj, 0)")
					fn8("                end")
					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(hatchLoop)")
				end
			elseif str == "REBIRTH" then
				local rebirth = arg:FindMatchingRemote("REBIRTH", tbl8)
				fn8("-- [[ SUB-SYSTEM: AUTONOMOUS PRESTIGE & REBIRTH ENGINE ]]")

				if rebirth then
					fn8(string.format("-- Discovered Rebirth Remote: %s via %s", rebirth.Name, rebirth.Source))
					fn8("local rep = game:GetService(\"ReplicatedStorage\")")
					fn8(string.format("local rebRemote = rep:FindFirstChild(%q, true)", rebirth.Name))
					fn8("local rebLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(1.0)")
					fn8("        if rebRemote then")

					if rebirth.Class:find("Function") then
						fn8("            pcall(function() rebRemote:InvokeServer() end)")
					else
						fn8("            pcall(function() rebRemote:FireServer() end)")
					end

					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(rebLoop)")
				else
					fn8("-- Fallback: Scanning for Rebirth Remote in ReplicatedStorage")
					fn8("local rebLoop = task.spawn(function()")
					fn8("    while ScriptActive do")
					fn8("        task.wait(1.5)")
					fn8("        for _, r in ipairs(game:GetService(\"ReplicatedStorage\"):GetDescendants()) do")
					fn8("            if r:IsA(\"RemoteEvent\") and r.Name:lower():find(\"rebirth\") then")
					fn8("                pcall(function() r:FireServer() end)")
					fn8("            end")
					fn8("        end")
					fn8("    end")
					fn8("end)")
					fn8("ScriptMaid:GiveTask(rebLoop)")
				end
			elseif str == "CLAIM_REWARDS" then
				arg:FindMatchingRemote("CLAIM_REWARDS", tbl8)
				fn8("-- [[ SUB-SYSTEM: AUTONOMOUS REWARD, GIFT & QUEST CLAIM ENGINE ]]")
				fn8("local claimLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(5.0)")
				fn8("        local rep = game:GetService(\"ReplicatedStorage\")")
				fn8("        local kws = { \"claim\", \"reward\", \"gift\", \"daily\", \"chest\", \"spin\", \"free\" }")
				fn8("        for _, obj in ipairs(rep:GetDescendants()) do")
				fn8("            local oName = obj.Name:lower()")
				fn8("            for _, kw in ipairs(kws) do")
				fn8("                if oName:find(kw, 1, true) then")
				fn8("                    if obj:IsA(\"RemoteEvent\") then")
				fn8("                        pcall(function() obj:FireServer() end)")
				fn8("                        pcall(function() obj:FireServer(1) end)")
				fn8("                    elseif obj:IsA(\"RemoteFunction\") then")
				fn8("                        pcall(function() obj:InvokeServer() end)")
				fn8("                    end")
				fn8("                    break")
				fn8("                end")
				fn8("            end")
				fn8("        end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(claimLoop)")
			elseif str == "AUTO_CLICK" then
				local autoClick = arg:FindMatchingRemote("AUTO_CLICK", tbl8)
				fn8("-- [[ SUB-SYSTEM: HIGH-FREQUENCY AUTO-CLICK & TAP SIMULATOR ]]")
				fn8("local vu = game:GetService(\"VirtualUser\")")

				if autoClick then
					fn8(string.format("-- Discovered Click Remote: %s via %s", autoClick.Name, autoClick.Source))
					fn8("local rep = game:GetService(\"ReplicatedStorage\")")
					fn8(string.format("local clickRemote = rep:FindFirstChild(%q, true)", autoClick.Name))
				end

				fn8("local clickLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.04)")
				fn8("        pcall(function()")
				fn8("            vu:CaptureController()")
				fn8("            vu:Button1Down(Vector2.new(0, 0))")
				fn8("        end)")

				if autoClick then
					if autoClick.Class:find("Function") then
						fn8("        if clickRemote then pcall(function() clickRemote:InvokeServer() end) end")
					else
						fn8("        if clickRemote then pcall(function() clickRemote:FireServer() end) end")
					end
				end

				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(clickLoop)")
			elseif str == "FISHING" then
				local gather = arg:FindMatchingRemote("GATHER", tbl8)
				fn8("-- [[ SUB-SYSTEM: AUTONOMOUS FISHING & CAST-REEL AUTOMATOR ]]")
				fn8("local fishLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.6)")
				fn8("        local tool = Character:FindFirstChildOfClass(\"Tool\") or LocalPlayer.Backpack:FindFirstChildOfClass(\"Tool\")")
				fn8("        if tool and tool.Parent ~= Character then Humanoid:EquipTool(tool) end")
				fn8("        if tool then tool:Activate() end")

				if gather then
					fn8(string.format("        local rem = game:GetService(\"ReplicatedStorage\"):FindFirstChild(%q, true)", gather.Name))
					fn8("        if rem then")

					if gather.Class:find("Function") then
						fn8("            pcall(function() rem:InvokeServer(\"Cast\") end)")
						fn8("            task.wait(0.4)")
						fn8("            pcall(function() rem:InvokeServer(\"Reel\") end)")
					else
						fn8("            pcall(function() rem:FireServer(\"Cast\") end)")
						fn8("            task.wait(0.4)")
						fn8("            pcall(function() rem:FireServer(\"Reel\") end)")
					end

					fn8("        end")
				end

				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(fishLoop)")
			elseif str == "MINING" then
				local gather = arg:FindMatchingRemote("GATHER", tbl8)
				fn8("-- [[ SUB-SYSTEM: AUTONOMOUS ORE MINING & RESOURCE HARVESTER ]]")
				fn8("local function getNearestOre()")
				fn8("    local closest, dist = nil, 300")
				fn8("    local targets = { \"Ores\", \"Rocks\", \"Minerals\", \"Nodes\", \"Crystals\" }")
				fn8("    for _, tName in ipairs(targets) do")
				fn8("        local f = workspace:FindFirstChild(tName)")
				fn8("        if f then")
				fn8("            for _, o in ipairs(f:GetChildren()) do")
				fn8("                local p = o:IsA(\"BasePart\") and o or o:FindFirstChildWhichIsA(\"BasePart\")")
				fn8("                if p and RootPart then")
				fn8("                    local d = (RootPart.Position - p.Position).Magnitude")
				fn8("                    if d < dist then dist = d; closest = p end")
				fn8("                end")
				fn8("            end")
				fn8("        end")
				fn8("    end")
				fn8("    return closest")
				fn8("end")
				fn8("")
				fn8("local mineLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.15)")
				fn8("        local ore = getNearestOre()")
				fn8("        if ore and RootPart then")
				fn8("            RootPart.CFrame = ore.CFrame * CFrame.new(0, 3, 0)")
				fn8("            local tool = Character:FindFirstChildOfClass(\"Tool\") or LocalPlayer.Backpack:FindFirstChildOfClass(\"Tool\")")
				fn8("            if tool and tool.Parent ~= Character then Humanoid:EquipTool(tool) end")
				fn8("            if tool then tool:Activate() end")

				if gather then
					fn8(string.format("            local mRem = game:GetService(\"ReplicatedStorage\"):FindFirstChild(%q, true)", gather.Name))
					fn8("            if mRem then pcall(function() mRem:FireServer(ore) end) end")
				end

				fn8("        end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(mineLoop)")
			elseif str == "MOB_PULL" then
				fn8("-- [[ SUB-SYSTEM: QUANTUM MOB MAGNET & BATCH PULL ENGINE ]]")
				fn8("local pullLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.1)")
				fn8("        if RootPart and RootPart.Parent then")
				fn8("            local gatherCF = RootPart.CFrame * CFrame.new(0, 0, -5)")
				fn8("            for _, m in ipairs(workspace:GetDescendants()) do")
				fn8("                if m:IsA(\"Model\") and m ~= Character and not Players:GetPlayerFromCharacter(m) then")
				fn8("                    local h = m:FindFirstChildOfClass(\"Humanoid\")")
				fn8("                    local hrp = m:FindFirstChild(\"HumanoidRootPart\") or m:FindFirstChildWhichIsA(\"BasePart\")")
				fn8("                    if h and h.Health > 0 and hrp then")
				fn8("                        if (RootPart.Position - hrp.Position).Magnitude < 300 then")
				fn8("                            pcall(function()")
				fn8("                                hrp.CFrame = gatherCF")
				fn8("                                hrp.AssemblyLinearVelocity = Vector3.zero")
				fn8("                            end)")
				fn8("                        end")
				fn8("                    end")
				fn8("                end")
				fn8("            end")
				fn8("        end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(pullLoop)")
			elseif str == "REMOTE_CALL" and name then
				fn8(string.format("-- [[ SUB-SYSTEM: TARGETED REMOTE EXECUTOR [%s] ]]", name))
				fn8("local rep = game:GetService(\"ReplicatedStorage\")")
				fn8(string.format("local targetRemote = rep:FindFirstChild(%q, true)", name))
				fn8("local callLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.2)")
				fn8("        if targetRemote then")

				if str2:find("Function") then
					fn8("            pcall(function() targetRemote:InvokeServer() end)")
				else
					fn8("            pcall(function() targetRemote:FireServer() end)")
				end

				fn8("        end")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(callLoop)")
			else
				fn8("-- [[ SUB-SYSTEM: GENERAL GAME AUTOMATION & UTILITY ]]")
				fn8("local utilLoop = task.spawn(function()")
				fn8("    while ScriptActive do")
				fn8("        task.wait(0.5)")
				fn8("        -- Automated game cycle heartbeat")
				fn8("    end")
				fn8("end)")
				fn8("ScriptMaid:GiveTask(utilLoop)")
			end

			fn8("")
			fn8("-- [[ CONTROL PANEL & DEACTIVATION HUD ]]")
			fn8("local parentGui = (typeof(gethui) == \"function\" and gethui()) or game:GetService(\"CoreGui\")")
			fn8("local hud = Instance.new(\"ScreenGui\")")
			fn8("hud.Name = \"PayomboyZ_MiniHUD_\" .. tostring(tick())")
			fn8("hud.ResetOnSpawn = false")
			fn8("hud.Parent = parentGui")
			fn8("ScriptMaid:GiveTask(hud)")
			fn8("")
			fn8("local stopBtn = Instance.new(\"TextButton\")")
			fn8("stopBtn.Size = UDim2.new(0, 160, 0, 36)")
			fn8("stopBtn.Position = UDim2.new(0.5, -80, 0, 18)")
			fn8("stopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 45)")
			fn8("stopBtn.Text = \"🛑 Stop Script (Clean Up)\"")
			fn8("stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)")
			fn8("stopBtn.Font = Enum.Font.GothamBold")
			fn8("stopBtn.TextSize = 12")
			fn8("stopBtn.Parent = hud")
			fn8("local bc = Instance.new(\"UICorner\"); bc.CornerRadius = UDim.new(0, 8); bc.Parent = stopBtn")
			fn8("")
			fn8("stopBtn.MouseButton1Click:Connect(function()")
			fn8("    ScriptActive = false")
			fn8("    ScriptMaid:DoCleaning()")
			fn8("    game:GetService(\"StarterGui\"):SetCore(\"SendNotification\", {")
			fn8("        Title = \"PayomboyZ AI System\",")
			fn8("        Text = \"Synthesized script stopped & memory cleaned.\",")
			fn8("        Duration = 3")
			fn8("    })")
			fn8("end)")
			fn8("")
			fn8("game:GetService(\"StarterGui\"):SetCore(\"SendNotification\", {")
			fn8("    Title = \"PayomboyZ AI V8 Ready\",")
			fn8("    Text = \"Script initialized with Maid cleanup support!\",")
			fn8("    Duration = 4")
			fn8("})")
			local lastGeneratedCode = table.concat(tbl9, "\n")
			arg.LastGeneratedCode = lastGeneratedCode
			return lastGeneratedCode, str
		end,
	}

	tbl5 = { Serialize = function(arg)
		local kind = typeof(arg)
		if kind == "string" then
			return string.format("%q", arg)
		end

		if kind == "number" or kind == "boolean" then
			return tostring(arg)
		end

		if kind == "nil" then
			return "nil"
		end

		if kind == "Vector3" then
			return string.format("Vector3.new(%.3f, %.3f, %.3f)", arg.X, arg.Y, arg.Z)
		end

		if kind == "Vector2" then
			return string.format("Vector2.new(%.3f, %.3f)", arg.X, arg.Y)
		end

		if kind == "Color3" then
			local floor = math.floor
			local n = arg.B * 255
			return string.format("Color3.fromRGB(%d, %d, %d)", math.floor(arg.R * 255), math.floor(arg.G * 255), floor(n))
		end

		if kind == "CFrame" then
			local tbl8 = { arg:GetComponents() }

			for i, v in ipairs(tbl8) do
				tbl8[i] = string.format("%.3f", v)
			end

			return "CFrame.new(" .. table.concat(tbl8, ", ") .. ")"
		end

		if kind == "EnumItem" then
			return tostring(arg)
		end

		if kind == "UDim" then
			return string.format("UDim.new(%.3f, %d)", arg.Scale, arg.Offset)
		end

		if kind == "UDim2" then
			return string.format("UDim2.new(%.3f, %d, %.3f, %d)", arg.X.Scale, arg.X.Offset, arg.Y.Scale, arg.Y.Offset)
		end

		if kind == "BrickColor" then
			return string.format("BrickColor.new(%q)", arg.Name)
		end

		if kind == "Instance" then
			local ok, result = pcall(function()
				return arg:GetFullName()
			end)

			return ok and string.format("%q", result) or "<Instance>"
		end

		if kind == "table" then
			local tbl8 = {}
			local n = 0

			for k, v in pairs(arg) do
				n += 1

				if n > 20 then
					table.insert(tbl8, "...")
					break
				else
					local serialize = tbl5.Serialize
					table.insert(tbl8, string.format("[%s] = %s", tbl5.Serialize(k), serialize(v)))
				end
			end

			return "{" .. table.concat(tbl8, ", ") .. "}"
		end

		return string.format("%q", tostring(arg))
	end }

	tbl6 = {
		backdrop = Color3.fromRGB(7, 12, 21),
		shell = Color3.fromRGB(9, 15, 26),
		glass = Color3.fromRGB(14, 23, 39),
		glassDeep = Color3.fromRGB(11, 19, 33),
		glassRaised = Color3.fromRGB(23, 36, 58),
		glassBorder = Color3.fromRGB(32, 48, 72),
		glassBorderHighlight = Color3.fromRGB(109, 161, 255),
		userPanel = Color3.fromRGB(12, 20, 35),
		surface = Color3.fromRGB(21, 33, 53),
		surfaceRaised = Color3.fromRGB(27, 42, 65),
		surfaceHover = Color3.fromRGB(35, 53, 80),
		surfacePressed = Color3.fromRGB(15, 24, 41),
		input = Color3.fromRGB(7, 14, 25),
		inputFocus = Color3.fromRGB(18, 30, 50),
		divider = Color3.fromRGB(46, 66, 95),
		primary = Color3.fromRGB(109, 161, 255),
		primaryHover = Color3.fromRGB(143, 185, 255),
		primaryPressed = Color3.fromRGB(77, 128, 216),
		secondary = Color3.fromRGB(18, 30, 48),
		text = Color3.fromRGB(232, 239, 251),
		textMuted = Color3.fromRGB(152, 170, 197),
		textFaint = Color3.fromRGB(100, 120, 148),
		cyan = Color3.fromRGB(130, 174, 255),
		success = Color3.fromRGB(109, 161, 255),
		warning = Color3.fromRGB(240, 200, 50),
		danger = Color3.fromRGB(255, 65, 80),
		disabled = Color3.fromRGB(25, 35, 53),
		btnRed = Color3.fromRGB(80, 18, 24),
		btnRedHover = Color3.fromRGB(130, 28, 38),
		btnRedPressed = Color3.fromRGB(55, 12, 16),
		btnRedStroke = Color3.fromRGB(255, 65, 80),
		accent = Color3.fromRGB(109, 161, 255),
		background = Color3.fromRGB(7, 12, 21),
		textDim = Color3.fromRGB(145, 162, 188),
	}

	setmetatable(tbl6, { __index = function()
		return Color3.fromRGB(109, 161, 255)
	end })

	switchedLanguageTo = "TH"
	local tbl8 = {}

	local tbl9 = {
		TH = {
			TAB_HOME = "หน้าแรก",
			WINDOW_TITLE = "DEVIL HUB",
			WINDOW_SUBTITLE = "AI • สำรวจเกม • Remote • Dump",
			NAV_HEADER = "เครื่องมือ / TOOLS",
			STATUS_ACTIVE = "DEVIL HUB • พร้อมใช้งาน",
			ACTIVE_SERVICE = "สถานะเซิร์ฟเวอร์",
			SYSTEM_VERIFIED = "🛡️ ผ่านการตรวจสอบแล้ว",
			SERVICE_SUB = "ระบบสคริปต์พรีเมียม • ทำงานเต็มประสิทธิภาพ",
			TAB_AI = "สร้างโค้ด AI",
			TAB_MACRO = "มาโคร",
			TAB_EXPLORER = "สำรวจเกม",
			TAB_SPY = "Remote Spy",
			TAB_HTTP = "HTTP Spy",
			TAB_AC = "สแกนระบบเกม",
			TAB_DUMP = "บันทึก Dump",
			TAB_PREVIEW = "ดูไฟล์ Dump",
			TAB_DEBUG = "บันทึก Debug",
			TAB_MATRIX = "คลังโค้ด",
			TAB_DEOBF = "เครื่องมืออ่านโค้ด",
			TAB_SETTINGS = "ตั้งค่า",
			AI_TITLE = "DEVIL AI • สร้างโค้ด Luau",
			AI_DESC = "พิมพ์ความต้องการของคุณ (เช่น 'ระบบฟาร์มเวลอัตโนมัติ' หรือ 'ระบบวาปไปเกาะ') ระบบ AI จะรวมโหนดคำสั่งและผูกข้อมูล Instance ในเกมให้อัตโนมัติ",
			AI_PLACEHOLDER = "พิมพ์คำสั่งสร้างสคริปต์ที่นี่...",
			AI_SYNTHESIZE_BTN = "⚡ ประมวลผลสร้างโค้ดด้วย AI",
			AI_COPY_BTN = "📋 คัดลอกโค้ดทั้งหมด",
			AI_CLEAR_BTN = "🧹 ล้างหน้าจอโค้ด",
			AI_SAVE_MATRIX_BTN = "💾 บันทึกลงคลังคำสั่ง",
			EXPLORER_SEARCH_LABEL = "🔎 ค้นหา Instance ข้าม Services ในเกม:",
			EXPLORER_SEARCH_PLACEHOLDER = "พิมพ์ชื่อวัตถุ Script, Remote, Module...",
			EXPLORER_REFRESH_BTN = "🔄 รีเฟรชการค้นหา",
			EXPLORER_BIND_CONTEXT_BTN = "🧠 ผูก Instance ที่เลือกเข้าสมอง AI",
			SPY_FILTER_LABEL = "🚫 คำสั่ง/รีโมทที่จะข้าม (เว้นด้วยเครื่องหมายจุลภาค ,):",
			SPY_CLEAR_BTN = "🧹 ล้างประวัติ Remote",
			SPY_COPY_LOG_BTN = "📋 คัดลอก Log ทั้งหมด",
			SPY_BIND_AI_BTN = "🧠 ผูก Remote ทั้งหมดเข้าสมอง AI",
			AC_SECTION = "🛡️ ระบบควบคุมเอนจินสแกน",
			AC_RUN_SCAN_BTN = "🔍 เริ่มสแกน Anti-Cheat ทั่วทั้งเกม",
			AC_SAVE_LOG_BTN = "💾 บันทึก Log สแกนลงไฟล์",
			AC_CLEAR_LOG_BTN = "🧹 ล้างหน้าจอ Log",
			DUMP_SECTION = "📦 ตั้งค่าการส่งออกไฟล์และ DUMP DATA",
			DUMP_TARGET_LABEL = "🎯 เลือก Service เป้าหมาย:",
			DUMP_FOLDER_LABEL = "📁 ชื่อโฟลเดอร์สำหรับบันทึก:",
			DUMP_OPT_TERRAIN = "🌐 รวม Terrain",
			DUMP_OPT_SCRIPTS = "📜 รวม Script (Decompile)",
			DUMP_OPT_CHARS = "👤 รวมตัวละครผู้เล่น (Character)",
			DUMP_START_BTN = "🚀 เริ่มกระบวนการ Dump Instance",
			DUMP_WORKSPACE_BTN = "🏢 Dump ทั้งหมดใน Workspace",
			DUMP_REPLICATED_BTN = "📦 Dump ทั้งหมดใน ReplicatedStorage",
			PREVIEW_CLEAR_BTN = "🧹 ล้างหน้าจอ Preview",
			PREVIEW_COPY_BTN = "📋 คัดลอกเนื้อหา Preview",
			PREVIEW_SAVE_BTN = "💾 บันทึกเป็นไฟล์ .txt",
			DEBUG_CLEAR_BTN = "🧹 ล้าง Debug Log",
			DEBUG_COPY_BTN = "📋 คัดลอก Log ทั้งหมด",
			DEBUG_SAVE_BTN = "💾 บันทึก Log ลงไฟล์",
			MATRIX_SECTION = "📁 คลังไมโครโมดูลและสคริปต์สำเร็จรูป",
			LANG_SECTION = "🌐 เลือกภาษาใช้งาน (LANGUAGE / สลับภาษา)",
			LANG_SWITCH_TH = "🇹🇭 ภาษาไทย (Thai - ใช้งานอยู่)",
			LANG_SWITCH_EN = "🇬🇧 Switch to English",
			SCALE_SECTION = "🖥️ ปรับขนาดหน้าจอ UI",
			SCALE_STD = "🖥️ ขนาดมาตรฐาน (1.0x Scale)",
			SCALE_MOBILE = "📱 ขนาดพกพาสำหรับมือถือ (0.75x Scale)",
			EXT_SECTION = "🛠️ สคริปต์ภายนอกและเครื่องมือพรีเมียม",
			EXT_ANIME_CARD = "🎴 เปิดสคริปต์ PayomboyZ Script HUB",
			EXT_DEX = "🛠️ เปิด Dex++ Debug Explorer",
			EXT_IY = "⚡ เปิด Infinite Yield Admin Tools",
			CONFIG_SECTION = "💾 จัดการโปรไฟล์การตั้งค่า",
			CONFIG_SAVE_BTN = "💾 บันทึกโปรไฟล์ปัจจุบัน",
			CONFIG_LOAD_BTN = "📂 โหลดโปรไฟล์ที่บันทึกไว้",
			DIAG_SECTION = "📊 ติดตามประสิทธิภาพและสถานะระบบ",
			CONTROL_SECTION = "❌ ควบคุมระบบ",
			NOTIF_TEST_BTN = "🔔 ทดสอบระบบแจ้งเตือน",
			UNLOAD_HUB_BTN = "ปิด DEVIL HUB และหยุดการเชื่อมต่อ",
			NOTIF_TITLE = "DEVIL HUB",
			NOTIF_LOADED = "โหลดระบบประมวลผล Obsidian Glassmorphic 2 เรียบร้อยแล้ว!",
			NOTIF_LANG_CHANGED = "เปลี่ยนภาษาเป็นภาษาไทยเรียบร้อยแล้ว!",
		},
		EN = {
			TAB_HOME = "Home",
			WINDOW_TITLE = "DEVIL HUB",
			WINDOW_SUBTITLE = "AI • Explorer • Remotes • Dump",
			NAV_HEADER = "SYSTEM MODULES / CATEGORIES",
			STATUS_ACTIVE = "DEVIL HUB • Ready",
			ACTIVE_SERVICE = "ACTIVE SERVICE",
			SYSTEM_VERIFIED = "🛡️ SYSTEM VERIFIED",
			SERVICE_SUB = "Verified client delivery • Premium Automation",
			TAB_AI = "AI Builder",
			TAB_MACRO = "Macros",
			TAB_EXPLORER = "Game Explorer",
			TAB_SPY = "Remote Spy",
			TAB_HTTP = "HTTP Spy",
			TAB_AC = "Game Scanner",
			TAB_DUMP = "Dump Files",
			TAB_PREVIEW = "File Preview",
			TAB_DEBUG = "Debug Logs",
			TAB_MATRIX = "Code Library",
			TAB_DEOBF = "Code Tools",
			TAB_SETTINGS = "Settings",
			AI_TITLE = "DEVIL AI • Luau Code Builder",
			AI_DESC = "Enter your requirements (e.g. 'Auto farm level' or 'Teleport system'). The AI engine will assemble composite code modules and bind bound game context instances automatically.",
			AI_PLACEHOLDER = "Type code generation prompt here...",
			AI_SYNTHESIZE_BTN = "⚡ Synthesize Luau Code with AI",
			AI_COPY_BTN = "📋 Copy Full Compiled Code",
			AI_CLEAR_BTN = "🧹 Clear Terminal Window",
			AI_SAVE_MATRIX_BTN = "💾 Save to Command Matrix",
			EXPLORER_SEARCH_LABEL = "🔎 Search Instances Across Game Services:",
			EXPLORER_SEARCH_PLACEHOLDER = "Type Script, Remote, or Module name...",
			EXPLORER_REFRESH_BTN = "🔄 Refresh Search Results",
			EXPLORER_BIND_CONTEXT_BTN = "🧠 Bind Selected Instance to AI Context",
			SPY_FILTER_LABEL = "🚫 Skip Remotes/Keywords (Comma separated ,):",
			SPY_CLEAR_BTN = "🧹 Clear Remote Logs",
			SPY_COPY_LOG_BTN = "📋 Copy All Remote Logs",
			SPY_BIND_AI_BTN = "🧠 Bind Captured Remotes to AI Context",
			AC_SECTION = "🛡️ SCAN ENGINE CONTROLS",
			AC_RUN_SCAN_BTN = "🔍 RUN UNIVERSAL ANTI-CHEAT SCAN",
			AC_SAVE_LOG_BTN = "💾 SAVE SCAN LOG TO FILE",
			AC_CLEAR_LOG_BTN = "🧹 CLEAR SCAN TERMINAL",
			DUMP_SECTION = "📦 DUMP DATA & EXPORT SETTINGS",
			DUMP_TARGET_LABEL = "🎯 Select Target Service:",
			DUMP_FOLDER_LABEL = "📁 Export Folder Name:",
			DUMP_OPT_TERRAIN = "🌐 Include Terrain",
			DUMP_OPT_SCRIPTS = "📜 Include Scripts (Decompile)",
			DUMP_OPT_CHARS = "👤 Include Player Characters",
			DUMP_START_BTN = "🚀 Start Instance Dumping Process",
			DUMP_WORKSPACE_BTN = "🏢 Dump Workspace Completely",
			DUMP_REPLICATED_BTN = "📦 Dump ReplicatedStorage Completely",
			PREVIEW_CLEAR_BTN = "🧹 Clear Preview Terminal",
			PREVIEW_COPY_BTN = "📋 Copy Preview Content",
			PREVIEW_SAVE_BTN = "💾 Save Preview to .txt File",
			DEBUG_CLEAR_BTN = "🧹 Clear Debug Terminal",
			DEBUG_COPY_BTN = "📋 Copy Full System Logs",
			DEBUG_SAVE_BTN = "💾 Save Debug Log to File",
			MATRIX_SECTION = "📁 MOUNTED MICRO MODULES LIBRARY",
			LANG_SECTION = "🌐 LANGUAGE SWITCHER / เลือกภาษา",
			LANG_SWITCH_TH = "🇹🇭 Switch to Thai Language",
			LANG_SWITCH_EN = "🇬🇧 English Language (Active)",
			SCALE_SECTION = "🖥️ UI DISPLAY SCALING",
			SCALE_STD = "🖥️ Standard Profile (1.0x Scale)",
			SCALE_MOBILE = "📱 Compact Mobile Profile (0.75x Scale)",
			EXT_SECTION = "🛠️ EXTERNAL UTILITIES & GAME SCRIPTS",
			EXT_ANIME_CARD = "🎴 Launch PayomboyZ Script HUB",
			EXT_DEX = "🛠️ Launch Dex++ Debug Explorer",
			EXT_IY = "⚡ Launch Infinite Yield Admin Tools",
			CONFIG_SECTION = "💾 HUB CONFIGURATION & PROFILE MANAGER",
			CONFIG_SAVE_BTN = "💾 Save Current Profile Config",
			CONFIG_LOAD_BTN = "📂 Load Saved Profile Config",
			DIAG_SECTION = "📊 SYSTEM DIAGNOSTICS & PERFORMANCE",
			CONTROL_SECTION = "❌ SYSTEM CONTROL",
			NOTIF_TEST_BTN = "🔔 Test Toast Notification",
			UNLOAD_HUB_BTN = "❌ Unload DEVIL HUB & Cleanup Connections",
			NOTIF_TITLE = "DEVIL HUB",
			NOTIF_LOADED = "Obsidian Glassmorphic 2 UI Engine Loaded Successfully!",
			NOTIF_LANG_CHANGED = "Language switched to English successfully!",
		},
	}

	fn3 = function(arg)
		return (tbl9[switchedLanguageTo] or tbl9.TH)[arg] or tbl9.TH[arg] or arg
	end

	local function fn7(arg, arg2, arg3, arg4, arg5)
		arg3 = arg3 or "Text"
		arg4 = arg4 or ""
		arg5 = arg5 or ""

		if arg then
			table.insert(tbl8, { element = arg, key = arg2, property = arg3, prefix = arg4, suffix = arg5 })

			pcall(function()
				arg[arg3] = arg4 .. fn3(arg2) .. arg5
			end)
		end
	end

	fn4 = function(arg)
		if arg ~= "TH" and arg ~= "EN" then
			return
		end
		switchedLanguageTo = arg

		for _, v in ipairs(tbl8) do
			if v.element and v.element.Parent then
				pcall(function()
					local suffix = v.suffix
					v.element[v.property] = v.prefix .. fn3(v.key) .. suffix
				end)
			end
		end

		fn2("INFO", "I18N", "Switched language to: " .. switchedLanguageTo)
		ObsidianGlassEngine:Notify({ Title = fn3("NOTIF_TITLE"), Content = fn3("NOTIF_LANG_CHANGED"), Duration = 3 })
	end

	fn5 = function()
		pcall(function()
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://6895079853"
			sound.Volume = 0.3
			sound.Parent = SoundService
			sound:Play()

			sound.Ended:Connect(function()
				sound:Destroy()
			end)
		end)
	end

	local jpg = nil

	local function fn8()
		if jpg then
			return jpg
		end

		pcall(function()
			if typeof(writefile) == "function" and (typeof(getcustomasset) == "function" or typeof(getsynasset) == "function") then
				local v = getcustomasset or getsynasset

				if not (typeof(isfile) == "function" and isfile("DevilHub_AI_Logo.png")) then
					local response = game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png")

					if response and response:sub(1, 8) == "\137PNG\r\n\26\n" then
						writefile("DevilHub_AI_Logo.png", response)
					end
				end

				if typeof(isfile) == "function" and isfile("DevilHub_AI_Logo.png") then
					jpg = v("DevilHub_AI_Logo.png")
				end
			end
		end)

		if not jpg then
			jpg = "rbxthumb://type=AvatarHeadShot&id=" .. localPlayer.UserId .. "&w=150&h=150"
		end

		return jpg
	end

	tbl7 = {
		Options = {},
		Notify = function(arg, arg2)
			pcall(function()
				local title = arg2.Title or "System"
				local content = arg2.Content or ""
				local duration = arg2.Duration or 4
				local hui2 = typeof(gethui) == "function" and gethui() or CoreGui
				local obsidianGlassNotifHolder = hui2:FindFirstChild("DevilHub_AI_Notifications")

				if not obsidianGlassNotifHolder then
					obsidianGlassNotifHolder = Instance.new("ScreenGui")
					obsidianGlassNotifHolder.Name = "DevilHub_AI_Notifications"
					obsidianGlassNotifHolder.ResetOnSpawn = false
					obsidianGlassNotifHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					obsidianGlassNotifHolder.Parent = hui2
				end

				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 300, 0, 65)
				frame.Position = UDim2.new(1, 20, 1, -85)
				frame.BackgroundColor3 = tbl6.glass
				frame.BackgroundTransparency = 0.15
				frame.BorderSizePixel = 0
				frame.Parent = obsidianGlassNotifHolder
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(0, 10)
				uiCorner.Parent = frame
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = tbl6.cyan
				uiStroke.Thickness = 1.5
				uiStroke.Parent = frame
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.new(1, -20, 0, 22)
				textLabel.Position = UDim2.new(0, 10, 0, 6)
				textLabel.BackgroundTransparency = 1
				textLabel.Text = title
				textLabel.TextColor3 = tbl6.cyan
				textLabel.Font = Enum.Font.GothamBold
				textLabel.TextSize = 13
				textLabel.TextXAlignment = Enum.TextXAlignment.Left
				textLabel.Parent = frame
				local textLabel2 = Instance.new("TextLabel")
				textLabel2.Size = UDim2.new(1, -20, 0, 32)
				textLabel2.Position = UDim2.new(0, 10, 0, 26)
				textLabel2.BackgroundTransparency = 1
				textLabel2.Text = content
				textLabel2.TextColor3 = tbl6.text
				textLabel2.Font = Enum.Font.Gotham
				textLabel2.TextSize = 11
				textLabel2.TextWrapped = true
				textLabel2.TextXAlignment = Enum.TextXAlignment.Left
				textLabel2.Parent = frame
				fn5()
				TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -320, 1, -85) }):Play()

				task.delay(duration, function()
					if frame and frame.Parent then
						local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(1, 20, 1, -85) })
						tween:Play()

						tween.Completed:Connect(function()
							frame:Destroy()
						end)
					end
				end)
			end)
		end,
		CreateWindow = function()
			local hui2 = typeof(gethui) == "function" and gethui() or CoreGui

			if hui2:FindFirstChild("DevilHub_AI_UI") then
				hui2.DevilHub_AI_UI:Destroy()
			end

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "DevilHub_AI_UI"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.DisplayOrder = 99999
			screenGui.Parent = hui2
			local uiScale = Instance.new("UIScale")
			local currentCamera = workspace.CurrentCamera
			local n = 1

			local function fn9()
				if currentCamera and currentCamera.ViewportSize then
					local viewportSize = currentCamera.ViewportSize
					uiScale.Scale = math.clamp(math.min((viewportSize.X - 24) / 920, (viewportSize.Y - 24) / 600) * n, 0.1, 1)
				end
			end

			fn9()

			if currentCamera then
				currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn9)
			end

			uiScale.Parent = screenGui
			local frame = Instance.new("Frame")
			frame.Name = "MainShell"
			frame.Size = UDim2.fromOffset(920, 600)
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Position = UDim2.new(0.5, 0, 0.5, 0)
			frame.BackgroundColor3 = tbl6.shell
			frame.BackgroundTransparency = 0
			frame.BorderSizePixel = 0
			frame.ClipsDescendants = true
			frame.Parent = screenGui
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = UDim.new(0, 18)
			uiCorner.Parent = frame
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Color = tbl6.cyan
			uiStroke.Thickness = 1.5
			uiStroke.Transparency = 0.3
			uiStroke.Parent = frame
			local frame2 = Instance.new("Frame")
			frame2.Name = "CyberDataLayer"
			frame2.Size = UDim2.fromScale(1, 1)
			frame2.BackgroundTransparency = 1
			frame2.ClipsDescendants = true
			frame2.ZIndex = 2
			frame2.Parent = frame
			local tbl10 = {}
			local tbl11 = { "0", "1", "0x4F", "PBG", "AI", "101", "0101", "7F", "FF", "EXEC", "SYS", "LUA", "PAYOM" }

			for i = 1, 0 do
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.fromOffset(38, 20)
				textLabel.Position = UDim2.new(math.random(), 0, math.random(), 0)
				textLabel.BackgroundTransparency = 1
				textLabel.Text = tbl11[math.random(1, #tbl11)]
				local random = math.random
				textLabel.TextColor3 = Color3.fromRGB(0, math.random(180, 255), random(80, 160))
				textLabel.Font = Enum.Font.Code
				textLabel.TextSize = math.random(10, 12)
				textLabel.TextTransparency = math.random(35, 75) / 100
				textLabel.ZIndex = 2
				textLabel.Parent = frame2

				table.insert(tbl10, {
					label = textLabel,
					speed = math.random(15, 38) / 10000,
					pos = textLabel.Position.Y.Scale,
					posX = textLabel.Position.X.Scale,
				})
			end

			local frame3 = Instance.new("Frame")
			frame3.Name = "ObsidianToggleCapsule"
			frame3.Size = UDim2.fromOffset(58, 58)
			frame3.Position = UDim2.new(0, 15, 0.5, -29)
			frame3.BackgroundColor3 = tbl6.shell
			frame3.BackgroundTransparency = 0.18
			frame3.BorderSizePixel = 0
			frame3.ClipsDescendants = true
			frame3.ZIndex = 99999
			frame3.Parent = screenGui
			local uiCorner2 = Instance.new("UICorner")
			uiCorner2.CornerRadius = UDim.new(0, 16)
			uiCorner2.Parent = frame3
			local uiStroke2 = Instance.new("UIStroke")
			uiStroke2.Color = tbl6.primary
			uiStroke2.Thickness = 1.5
			uiStroke2.Transparency = 0.2
			uiStroke2.Parent = frame3
			local frame4 = Instance.new("Frame")
			frame4.Name = "CapsuleCyberDataLayer"
			frame4.Size = UDim2.fromScale(1, 1)
			frame4.BackgroundTransparency = 1
			frame4.ClipsDescendants = true
			frame4.ZIndex = 1
			frame4.Parent = frame3

			for i = 1, 0 do
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.fromOffset(28, 16)
				textLabel.Position = UDim2.new(math.random(), 0, math.random(), 0)
				textLabel.BackgroundTransparency = 1
				textLabel.Text = tbl11[math.random(1, #tbl11)]
				local random = math.random
				textLabel.TextColor3 = Color3.fromRGB(0, math.random(190, 255), random(90, 160))
				textLabel.Font = Enum.Font.Code
				textLabel.TextSize = 9
				textLabel.TextTransparency = math.random(40, 80) / 100
				textLabel.ZIndex = 1
				textLabel.Parent = frame4

				table.insert(tbl10, {
					label = textLabel,
					speed = math.random(10, 28) / 10000,
					pos = textLabel.Position.Y.Scale,
					posX = textLabel.Position.X.Scale,
				})
			end

			fn6(RunService.RenderStepped:Connect(function()
				if not screenGui or not screenGui.Parent then
					return
				end

				for _, v in ipairs(tbl10) do
					if v.label and v.label.Parent then
						v.pos = v.pos + v.speed

						if v.pos > 1.05 then
							v.pos = -0.05
							v.posX = math.random()
							v.label.Text = tbl11[math.random(1, #tbl11)]
							local random = math.random
							v.label.TextColor3 = Color3.fromRGB(0, math.random(180, 255), random(80, 160))
						end

						v.label.Position = UDim2.new(v.posX, 0, v.pos, 0)
					end
				end
			end))

			local frame5 = Instance.new("Frame")
			frame5.Size = UDim2.fromOffset(42, 42)
			frame5.Position = UDim2.new(0, 8, 0.5, -21)
			frame5.BackgroundColor3 = tbl6.glassDeep
			frame5.BorderSizePixel = 0
			frame5.ZIndex = 3
			frame5.Parent = frame3
			local uiCorner3 = Instance.new("UICorner")
			uiCorner3.CornerRadius = UDim.new(1, 0)
			uiCorner3.Parent = frame5
			local uiStroke3 = Instance.new("UIStroke")
			uiStroke3.Color = tbl6.primary
			uiStroke3.Thickness = 1.5
			uiStroke3.Parent = frame5
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.Size = UDim2.fromScale(1, 1)
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = fn8()
			imageLabel.ZIndex = 4
			imageLabel.Parent = frame5
			local uiCorner4 = Instance.new("UICorner")
			uiCorner4.CornerRadius = UDim.new(1, 0)
			uiCorner4.Parent = imageLabel
			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, -58, 0, 18)
			textLabel.Position = UDim2.new(0, 56, 0, 10)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "@" .. localPlayer.Name
			textLabel.TextColor3 = tbl6.text
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 12
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.ZIndex = 3
			textLabel.Visible = false
			textLabel.Parent = frame3
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.Size = UDim2.new(1, -58, 0, 16)
			textLabel2.Position = UDim2.new(0, 56, 0, 28)
			textLabel2.BackgroundTransparency = 1
			textLabel2.Text = "⚡ 60 FPS  •  📡 0 ms"
			textLabel2.TextColor3 = tbl6.cyan
			textLabel2.Font = Enum.Font.GothamBold
			textLabel2.TextSize = 10
			textLabel2.TextXAlignment = Enum.TextXAlignment.Left
			textLabel2.ZIndex = 3
			textLabel2.Visible = false
			textLabel2.Parent = frame3

			task.spawn(function()
				local n2 = 0
				local now = tick()
				local n3 = 60

				local connection = RunService.RenderStepped:Connect(function()
					n2 += 1
					local now2 = tick()

					if now2 - now >= 1 then
						n3 = n2
						n2 = 0
						now = now2
					end
				end)

				while task.wait(0.8) do
					if not screenGui or not screenGui.Parent or not frame3 or not frame3.Parent then
						if connection then
							connection:Disconnect()
						end

						break
					else
						local n4 = 0

						pcall(function()
							n4 = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
						end)

						textLabel2.Text = string.format("⚡ %d FPS  •  📡 %d ms", n3, n4)
					end
				end
			end)

			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.fromScale(1, 1)
			textButton.BackgroundTransparency = 1
			textButton.Text = ""
			textButton.ZIndex = 10
			textButton.Parent = frame3
			local flag = nil
			local v = nil
			local position = nil
			local position2 = nil
			local flag2 = false

			textButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					flag = true
					flag2 = false
					position = input.Position
					position2 = frame3.Position

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							flag = false
						end
					end)
				end
			end)

			textButton.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					v = input
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input == v and flag then
					local n2 = input.Position - position

					if math.abs(n2.X) > 3 or math.abs(n2.Y) > 3 then
						flag2 = true
					end

					frame3.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n2.X, position2.Y.Scale, position2.Y.Offset + n2.Y)
				end
			end)

			textButton.MouseButton1Click:Connect(function()
				if not flag2 then
					fn5()
					frame.Visible = not frame.Visible
				end
			end)

			local frame6 = Instance.new("Frame")
			frame6.Name = "UserPanel"
			frame6.Size = UDim2.new(0, 240, 1, 0)
			frame6.BackgroundColor3 = tbl6.userPanel
			frame6.BackgroundTransparency = 0
			frame6.BorderSizePixel = 0
			frame6.ZIndex = 5
			frame6.Parent = frame
			local frame7 = Instance.new("Frame")
			frame7.Size = UDim2.new(0, 1, 1, 0)
			frame7.Position = UDim2.new(1, -1, 0, 0)
			frame7.BackgroundColor3 = tbl6.glassRaised
			frame7.BorderSizePixel = 0
			frame7.ZIndex = 10
			frame7.Parent = frame6
			local frame8 = Instance.new("Frame")
			frame8.Size = UDim2.fromOffset(44, 44)
			frame8.Position = UDim2.new(0, 14, 0, 14)
			frame8.BackgroundColor3 = tbl6.glassDeep
			frame8.BorderSizePixel = 0
			frame8.ZIndex = 10
			frame8.Parent = frame6
			local uiCorner5 = Instance.new("UICorner")
			uiCorner5.CornerRadius = UDim.new(1, 0)
			uiCorner5.Parent = frame8
			local uiStroke4 = Instance.new("UIStroke")
			uiStroke4.Color = tbl6.cyan
			uiStroke4.Thickness = 1.5
			uiStroke4.Parent = frame8
			local imageLabel2 = Instance.new("ImageLabel")
			imageLabel2.Size = UDim2.fromScale(1, 1)
			imageLabel2.BackgroundTransparency = 1
			imageLabel2.Image = fn8()
			imageLabel2.ZIndex = 11
			imageLabel2.Parent = frame8
			local uiCorner6 = Instance.new("UICorner")
			uiCorner6.CornerRadius = UDim.new(1, 0)
			uiCorner6.Parent = imageLabel2
			local frame9 = Instance.new("Frame")
			frame9.Size = UDim2.fromOffset(10, 10)
			frame9.Position = UDim2.new(1, -8, 1, -8)
			frame9.BackgroundColor3 = tbl6.success
			frame9.BorderSizePixel = 0
			frame9.ZIndex = 12
			frame9.Parent = frame8
			local uiCorner7 = Instance.new("UICorner")
			uiCorner7.CornerRadius = UDim.new(1, 0)
			uiCorner7.Parent = frame9
			local textLabel3 = Instance.new("TextLabel")
			textLabel3.Size = UDim2.new(1, -75, 0, 18)
			textLabel3.Position = UDim2.new(0, 66, 0, 15)
			textLabel3.BackgroundTransparency = 1
			textLabel3.Text = "DEVIL HUB"
			textLabel3.TextColor3 = tbl6.text
			textLabel3.Font = Enum.Font.GothamBold
			textLabel3.TextSize = 13
			textLabel3.TextXAlignment = Enum.TextXAlignment.Left
			textLabel3.ZIndex = 10
			textLabel3.Parent = frame6
			local textLabel4 = Instance.new("TextLabel")
			textLabel4.Size = UDim2.new(1, -75, 0, 14)
			textLabel4.Position = UDim2.new(0, 66, 0, 33)
			textLabel4.BackgroundTransparency = 1
			textLabel4.Text = "AI & MAP TOOLS"
			textLabel4.TextColor3 = tbl6.textMuted
			textLabel4.Font = Enum.Font.Gotham
			textLabel4.TextSize = 10
			textLabel4.TextXAlignment = Enum.TextXAlignment.Left
			textLabel4.ZIndex = 10
			textLabel4.Parent = frame6
			local frame10 = Instance.new("Frame")
			frame10.Size = UDim2.new(1, -28, 0, 24)
			frame10.Position = UDim2.new(0, 14, 0, 64)
			frame10.BackgroundColor3 = tbl6.glassDeep
			frame10.BorderSizePixel = 0
			frame10.ZIndex = 10
			frame10.Parent = frame6
			local uiCorner8 = Instance.new("UICorner")
			uiCorner8.CornerRadius = UDim.new(0, 6)
			uiCorner8.Parent = frame10
			local textLabel5 = Instance.new("TextLabel")
			textLabel5.Size = UDim2.fromScale(1, 1)
			textLabel5.BackgroundTransparency = 1
			textLabel5.Text = "⏱️ 00:00  •  📡 0 ms"
			textLabel5.TextColor3 = tbl6.cyan
			textLabel5.Font = Enum.Font.GothamBold
			textLabel5.TextSize = 10
			textLabel5.ZIndex = 11
			textLabel5.Parent = frame10

			task.spawn(function()
				local now = os.time()

				while task.wait(1) do
					if not (not screenGui or not screenGui.Parent) then
						local n2 = os.time() - now
						local n3 = math.floor(n2 / 60)
						local n4 = 0

						pcall(function()
							n4 = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
						end)

						textLabel5.Text = string.format("⏱️ %02d:%02d  •  📡 %d ms", n3, n2 % 60, n4)
						continue
					end

					break
				end
			end)

			local frame11 = Instance.new("Frame")
			frame11.Size = UDim2.new(1, -28, 0, 1)
			frame11.Position = UDim2.new(0, 14, 0, 96)
			frame11.BackgroundColor3 = tbl6.glassRaised
			frame11.BorderSizePixel = 0
			frame11.ZIndex = 10
			frame11.Parent = frame6
			local textLabel6 = Instance.new("TextLabel")
			textLabel6.Size = UDim2.new(1, -28, 0, 18)
			textLabel6.Position = UDim2.new(0, 16, 0, 104)
			textLabel6.BackgroundTransparency = 1
			textLabel6.Text = fn3("NAV_HEADER")
			textLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel6.Font = Enum.Font.GothamBold
			textLabel6.TextSize = 11
			textLabel6.TextXAlignment = Enum.TextXAlignment.Left
			textLabel6.ZIndex = 10
			textLabel6.Parent = frame6
			fn7(textLabel6, "NAV_HEADER")
			local scrollingFrame = Instance.new("ScrollingFrame")
			scrollingFrame.Name = "VerticalTabScroll"
			scrollingFrame.Size = UDim2.new(1, -20, 1, -216)
			scrollingFrame.Position = UDim2.new(0, 10, 0, 164)
			scrollingFrame.BackgroundTransparency = 1
			scrollingFrame.ScrollBarThickness = 5
			scrollingFrame.ScrollBarImageColor3 = tbl6.cyan
			scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
			scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
			scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			scrollingFrame.ZIndex = 10
			scrollingFrame.Parent = frame6
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Vertical
			uiListLayout.Padding = UDim.new(0, 5)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Parent = scrollingFrame

			local function refreshNavigationCanvas()
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y / math.max(uiScale.Scale, 0.1) + 40)
			end
			uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshNavigationCanvas)
			uiScale:GetPropertyChangedSignal("Scale"):Connect(refreshNavigationCanvas)

			local frame12 = Instance.new("Frame")
			frame12.Size = UDim2.new(1, -24, 0, 36)
			frame12.Position = UDim2.new(0, 12, 1, -44)
			frame12.BackgroundColor3 = tbl6.glassDeep
			frame12.BorderSizePixel = 0
			frame12.ZIndex = 10
			frame12.Parent = frame6
			local uiCorner9 = Instance.new("UICorner")
			uiCorner9.CornerRadius = UDim.new(0, 8)
			uiCorner9.Parent = frame12
			local textLabel7 = Instance.new("TextLabel")
			textLabel7.Size = UDim2.fromScale(1, 1)
			textLabel7.BackgroundTransparency = 1
			textLabel7.Text = fn3("STATUS_ACTIVE")
			textLabel7.TextColor3 = tbl6.success
			textLabel7.Font = Enum.Font.GothamBold
			textLabel7.TextSize = 12
			textLabel7.Parent = frame12
			fn7(textLabel7, "STATUS_ACTIVE")
			local frame13 = Instance.new("Frame")
			frame13.Name = "MainPanel"
			frame13.Size = UDim2.new(1, -240, 1, 0)
			frame13.Position = UDim2.new(0, 240, 0, 0)
			frame13.BackgroundTransparency = 1
			frame13.ZIndex = 5
			frame13.Parent = frame
			local frame14 = Instance.new("Frame")
			frame14.Size = UDim2.new(1, 0, 0, 48)
			frame14.BackgroundTransparency = 1
			frame14.Parent = frame13
			local textLabel8 = Instance.new("TextLabel")
			textLabel8.Size = UDim2.new(1, -180, 0, 22)
			textLabel8.Position = UDim2.new(0, 20, 0, 8)
			textLabel8.BackgroundTransparency = 1
			textLabel8.Text = fn3("WINDOW_TITLE")
			textLabel8.TextColor3 = tbl6.text
			textLabel8.Font = Enum.Font.GothamBold
			textLabel8.TextSize = 18
			textLabel8.TextXAlignment = Enum.TextXAlignment.Left
			textLabel8.Parent = frame14
			fn7(textLabel8, "WINDOW_TITLE")
			local textLabel9 = Instance.new("TextLabel")
			textLabel9.Size = UDim2.new(1, -180, 0, 16)
			textLabel9.Position = UDim2.new(0, 20, 0, 28)
			textLabel9.BackgroundTransparency = 1
			textLabel9.Text = fn3("WINDOW_SUBTITLE")
			textLabel9.TextColor3 = tbl6.textMuted
			textLabel9.Font = Enum.Font.Gotham
			textLabel9.TextSize = 11
			textLabel9.TextXAlignment = Enum.TextXAlignment.Left
			textLabel9.Parent = frame14
			fn7(textLabel9, "WINDOW_SUBTITLE")
			local textButton2 = Instance.new("TextButton")
			textButton2.Size = UDim2.fromOffset(28, 28)
			textButton2.Position = UDim2.new(1, -38, 0, 10)
			textButton2.BackgroundColor3 = tbl6.glass
			textButton2.BackgroundTransparency = 0.2
			textButton2.Text = "X"
			textButton2.TextColor3 = tbl6.textMuted
			textButton2.Font = Enum.Font.GothamBold
			textButton2.TextSize = 14
			textButton2.Parent = frame14
			local uiCorner10 = Instance.new("UICorner")
			uiCorner10.CornerRadius = UDim.new(0, 8)
			uiCorner10.Parent = textButton2

			textButton2.MouseButton1Click:Connect(function()
				fn5()
				frame.Visible = not frame.Visible
			end)

			local textButton3 = Instance.new("TextButton")
			textButton3.Size = UDim2.fromOffset(28, 28)
			textButton3.Position = UDim2.new(1, -72, 0, 10)
			textButton3.BackgroundColor3 = tbl6.glass
			textButton3.BackgroundTransparency = 0.2
			textButton3.Text = "─"
			textButton3.TextColor3 = tbl6.textMuted
			textButton3.Font = Enum.Font.GothamBold
			textButton3.TextSize = 13
			textButton3.Parent = frame14
			local uiCorner11 = Instance.new("UICorner")
			uiCorner11.CornerRadius = UDim.new(0, 8)
			uiCorner11.Parent = textButton3

			textButton3.MouseButton1Click:Connect(function()
				fn5()
				frame.Visible = not frame.Visible
			end)

			local textButton4 = Instance.new("TextButton")
			textButton4.Size = UDim2.fromOffset(68, 28)
			textButton4.Position = UDim2.new(1, -146, 0, 10)
			textButton4.BackgroundColor3 = tbl6.glass
			textButton4.BackgroundTransparency = 0.2
			textButton4.Text = "📱 Scale"
			textButton4.TextColor3 = tbl6.cyan
			textButton4.Font = Enum.Font.GothamBold
			textButton4.TextSize = 11
			textButton4.Parent = frame14
			local uiCorner12 = Instance.new("UICorner")
			uiCorner12.CornerRadius = UDim.new(0, 8)
			uiCorner12.Parent = textButton4
			local tbl12 = { 1, 0.85, 0.7, 0.55 }
			local n2 = 1

			textButton4.MouseButton1Click:Connect(function()
				fn5()
				n2 = n2 % #tbl12 + 1
				n = tbl12[n2]
				textButton4.Text = string.format("📱 %d%%", math.floor(n * 100))
				fn9()

				tbl7:Notify({
					Title = "📱 Mobile Scale",
					Content = string.format("ปรับขนาดหน้าจอ UI เป็น %d%%", math.floor(n * 100)),
					Duration = 2,
				})
			end)

			local flag3 = nil
			local v2 = nil
			local position3 = nil
			local position4 = nil

			frame14.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					flag3 = true
					position3 = input.Position
					position4 = frame.Position

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							flag3 = false
						end
					end)
				end
			end)

			frame14.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					v2 = input
				end
			end)

			fn6(UserInputService.InputChanged:Connect(function(input)
				if input == v2 and flag3 and position4 then
					local n3 = (input.Position - position3) / (uiScale and uiScale.Scale > 0 and uiScale.Scale or 1)
					frame.Position = UDim2.new(position4.X.Scale, position4.X.Offset + n3.X, position4.Y.Scale, position4.Y.Offset + n3.Y)
				end
			end))

			local frame15 = Instance.new("Frame")
			frame15.Size = UDim2.new(1, -40, 0, 65)
			frame15.Position = UDim2.new(0, 20, 0, 48)
			frame15.BackgroundColor3 = tbl6.glassDeep
			frame15.BackgroundTransparency = 0.18
			frame15.BorderSizePixel = 0
			frame15.Parent = frame13
			local uiCorner13 = Instance.new("UICorner")
			uiCorner13.CornerRadius = UDim.new(0, 10)
			uiCorner13.Parent = frame15
			local uiStroke5 = Instance.new("UIStroke")
			uiStroke5.Color = tbl6.glassRaised
			uiStroke5.Thickness = 1
			uiStroke5.Parent = frame15
			local textLabel10 = Instance.new("TextLabel")
			textLabel10.Size = UDim2.new(1, -24, 0, 18)
			textLabel10.Position = UDim2.new(0, 14, 0, 8)
			textLabel10.BackgroundTransparency = 1
			textLabel10.Text = "DEVIL HUB • SESSION STATUS"
			textLabel10.TextColor3 = tbl6.primary
			textLabel10.Font = Enum.Font.GothamBold
			textLabel10.TextSize = 11
			textLabel10.TextXAlignment = Enum.TextXAlignment.Left
			textLabel10.Parent = frame15
			local textLabel11 = Instance.new("TextLabel")
			textLabel11.Size = UDim2.new(1, -28, 0, 34)
			textLabel11.Position = UDim2.new(0, 14, 0, 26)
			textLabel11.BackgroundTransparency = 1
			textLabel11.Font = Enum.Font.Code
			textLabel11.TextSize = 10
			textLabel11.TextColor3 = Color3.fromRGB(161, 184, 218)
			textLabel11.TextXAlignment = Enum.TextXAlignment.Left
			textLabel11.TextYAlignment = Enum.TextYAlignment.Top
			textLabel11.TextWrapped = true
			textLabel11.Parent = frame15

			task.spawn(function()
				while screenGui and screenGui.Parent and textLabel11 and textLabel11.Parent do
					local v3 = gcinfo()
					local n3 = #connections
					local n4 = #tbl
					local n5 = #tbl2.BoundItems
					textLabel11.Text = string.format("• Memory: %s (%d KB)   • Connections: %d tracked\n• Debug Buffer: %d entries   • Bound AI Contexts: %d", string.format("%.2f MB", v3 / 1024), v3, n3, n4, n5)
					task.wait(1)
				end
			end)

			local frame16 = Instance.new("Frame")
			frame16.Name = "PagesFolder"
			frame16.Size = UDim2.new(1, -32, 1, -64)
			frame16.Position = UDim2.new(0, 16, 0, 56)
			frame16.BackgroundTransparency = 1
			frame16.Parent = frame13
			local menuSearch = Instance.new("TextBox")
			menuSearch.Name = "DevilMenuSearch"
			menuSearch.Size = UDim2.new(1, -28, 0, 30)
			menuSearch.Position = UDim2.fromOffset(14, 128)
			menuSearch.BackgroundColor3 = tbl6.input
			menuSearch.BorderSizePixel = 0
			menuSearch.Text = ""
			menuSearch.PlaceholderText = "ค้นหาเมนู / Search tools"
			menuSearch.TextColor3 = tbl6.text
			menuSearch.PlaceholderColor3 = tbl6.textMuted
			menuSearch.ClearTextOnFocus = false
			menuSearch.Font = Enum.Font.Gotham
			menuSearch.TextSize = 12
			menuSearch.ZIndex = 12
			menuSearch.Parent = frame6
			local searchCorner = Instance.new("UICorner")
			searchCorner.CornerRadius = UDim.new(0, 8)
			searchCorner.Parent = menuSearch
			local navSpec = {
				TAB_HOME = {0, "เริ่มต้น / START", 1},
				TAB_AI = {1, "สร้างโค้ด / BUILD", 1}, TAB_MACRO = {1, "สร้างโค้ด / BUILD", 2},
				TAB_MATRIX = {1, "สร้างโค้ด / BUILD", 3},
				TAB_EXPLORER = {2, "สำรวจเกม / INSPECT", 1}, TAB_AC = {2, "สำรวจเกม / INSPECT", 2},
				TAB_SPY = {3, "ดักจับข้อมูล / TRAFFIC", 1}, TAB_HTTP = {3, "ดักจับข้อมูล / TRAFFIC", 2},
				TAB_DUMP = {4, "ไฟล์ / FILES", 1}, TAB_PREVIEW = {4, "ไฟล์ / FILES", 2},
				TAB_DEOBF = {4, "ไฟล์ / FILES", 3},
				TAB_DEBUG = {5, "ระบบ / SYSTEM", 1}, TAB_SETTINGS = {5, "ระบบ / SYSTEM", 2},
			}
			local navGroups = {}
			local tbl13

			tbl13 = {
				Tabs = {},
				CurrentTab = nil,
				MainShell = frame,
				UIScale = uiScale,
				StatusCard = frame15,
				SetScale = function(_, value)
					n = math.clamp(tonumber(value) or 1, 0.55, 1)
					fn9()
				end,
				AddTab = function(arg, arg2)
					local titleKey = arg2.TitleKey
					local title = titleKey and fn3(titleKey) or arg2.Title or "Tab"
					local n3 = #tbl13.Tabs + 1
					local spec = navSpec[titleKey] or {6, "OTHER", n3}
					if not navGroups[spec[1]] then
						local heading = Instance.new("TextLabel")
						heading.Name = "DevilNavGroup"
						heading.Size = UDim2.new(1, -6, 0, 26)
						heading.BackgroundTransparency = 1
						heading.Text = "  " .. spec[2]
						heading.TextColor3 = tbl6.textFaint
						heading.TextSize = 10
						heading.Font = Enum.Font.GothamBold
						heading.TextXAlignment = Enum.TextXAlignment.Left
						heading.LayoutOrder = spec[1] * 100
						heading.ZIndex = 12
						heading.Parent = scrollingFrame
						navGroups[spec[1]] = heading
					end
					local textButton5 = Instance.new("TextButton")
					textButton5.Size = UDim2.new(1, -6, 0, 40)
					textButton5.Position = UDim2.new(0, 3, 0, 0)
					textButton5.BackgroundColor3 = n3 == 1 and tbl6.primary or Color3.fromRGB(15, 25, 42)
					textButton5.BackgroundTransparency = n3 == 1 and 0.15 or 0.22
					textButton5.Text = "    " .. title
					textButton5.TextColor3 = n3 == 1 and Color3.fromRGB(255, 255, 255) or tbl6.textMuted
					textButton5.Font = Enum.Font.GothamBold
					textButton5.TextSize = 14
					textButton5.TextXAlignment = Enum.TextXAlignment.Left
					textButton5.AutoButtonColor = false
					textButton5.ZIndex = 12
					textButton5.LayoutOrder = spec[1] * 100 + spec[3]
					textButton5.Parent = scrollingFrame

					if titleKey then
						fn7(textButton5, titleKey, "Text", "    ", "")
					end

					local uiCorner14 = Instance.new("UICorner")
					uiCorner14.CornerRadius = UDim.new(0, 8)
					uiCorner14.Parent = textButton5
					local uiStroke6 = Instance.new("UIStroke")
					uiStroke6.Color = n3 == 1 and tbl6.primary or Color3.fromRGB(32, 47, 69)
					uiStroke6.Thickness = 1
					uiStroke6.Transparency = n3 == 1 and 0 or 0.3
					uiStroke6.Parent = textButton5
					local frame17 = Instance.new("Frame")
					frame17.Size = UDim2.new(0, 4, 0, 20)
					frame17.Position = UDim2.new(0, 4, 0.5, -10)
					frame17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					frame17.BorderSizePixel = 0
					frame17.Visible = n3 == 1
					frame17.Parent = textButton5
					local uiCorner15 = Instance.new("UICorner")
					uiCorner15.CornerRadius = UDim.new(1, 0)
					uiCorner15.Parent = frame17
					local scrollingFrame2 = Instance.new("ScrollingFrame")
					scrollingFrame2.Name = "Page_" .. title
					scrollingFrame2.Size = UDim2.fromScale(1, 1)
					scrollingFrame2.BackgroundTransparency = 1
					scrollingFrame2.ScrollBarThickness = 10
					scrollingFrame2.Active = true
					scrollingFrame2.VerticalScrollBarInset = Enum.ScrollBarInset.Always
					scrollingFrame2.ScrollBarImageColor3 = tbl6.primary
					scrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
					scrollingFrame2.ElasticBehavior = Enum.ElasticBehavior.Always
					scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
					scrollingFrame2.Visible = n3 == 1
					scrollingFrame2.Parent = frame16
					local uiPadding = Instance.new("UIPadding")
					uiPadding.PaddingRight = UDim.new(0, 10)
					uiPadding.PaddingBottom = UDim.new(0, 100)
					uiPadding.Parent = scrollingFrame2
					local uiListLayout2 = Instance.new("UIListLayout")
					uiListLayout2.Padding = UDim.new(0, 8)
					uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
					uiListLayout2.Parent = scrollingFrame2

					local function refreshPageCanvas()
						scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, uiListLayout2.AbsoluteContentSize.Y / math.max(uiScale.Scale, 0.1) + 120)
					end
					uiListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshPageCanvas)
					uiScale:GetPropertyChangedSignal("Scale"):Connect(refreshPageCanvas)

					local function fn10()
						fn5()

						for _, tab in ipairs(tbl13.Tabs) do
							tab.btn.BackgroundColor3 = Color3.fromRGB(15, 25, 42)
							tab.btn.BackgroundTransparency = 0.22
							tab.btn.TextColor3 = tbl6.textMuted
							tab.stroke.Color = Color3.fromRGB(32, 47, 69)
							tab.stroke.Transparency = 0.3

							if tab.indicator then
								tab.indicator.Visible = false
							end

							tab.page.Visible = false
						end

						textButton5.BackgroundColor3 = tbl6.primary
						textButton5.BackgroundTransparency = 0.15
						textButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
						uiStroke6.Color = tbl6.primary
						uiStroke6.Transparency = 0
						frame17.Visible = true
						scrollingFrame2.Visible = true
						tbl13.CurrentTab = titleKey
					end

					textButton5.MouseButton1Click:Connect(fn10)

					local tbl14 = {
						btn = textButton5,
						stroke = uiStroke6,
						indicator = frame17,
						page = scrollingFrame2,
						Key = titleKey,
						Group = spec[1],
						SearchText = string.lower(title .. " " .. (arg2.Title or "") .. " " .. (tbl9.EN[titleKey] or "")),
						Select = fn10,
						AddToggle = function(arg3, arg4, arg5)
							local title2 = arg5.Title or arg4
							local desc = arg5.Desc or ""
							local default = arg5.Default ~= nil and arg5.Default or false
							local frame18 = Instance.new("Frame")
							frame18.Size = UDim2.new(1, -10, 0, desc ~= "" and 55 or 44)
							frame18.BackgroundColor3 = tbl6.glassDeep
							frame18.BackgroundTransparency = 0.18
							frame18.BorderSizePixel = 0
							frame18.Parent = scrollingFrame2
							local uiCorner16 = Instance.new("UICorner")
							uiCorner16.CornerRadius = UDim.new(0, 8)
							uiCorner16.Parent = frame18
							local uiStroke7 = Instance.new("UIStroke")
							uiStroke7.Color = tbl6.surface
							uiStroke7.Thickness = 1
							uiStroke7.Parent = frame18
							local textLabel12 = Instance.new("TextLabel")
							textLabel12.Size = UDim2.new(1, -70, 0, 22)
							textLabel12.Position = UDim2.new(0, 12, 0, desc ~= "" and 8 or 11)
							textLabel12.BackgroundTransparency = 1
							textLabel12.Text = title2
							textLabel12.TextColor3 = tbl6.text
							textLabel12.Font = Enum.Font.GothamBold
							textLabel12.TextSize = 14
							textLabel12.TextXAlignment = Enum.TextXAlignment.Left
							textLabel12.Parent = frame18

							if desc ~= "" then
								local textLabel13 = Instance.new("TextLabel")
								textLabel13.Size = UDim2.new(1, -70, 0, 18)
								textLabel13.Position = UDim2.new(0, 12, 0, 30)
								textLabel13.BackgroundTransparency = 1
								textLabel13.Text = desc
								textLabel13.TextColor3 = tbl6.textMuted
								textLabel13.Font = Enum.Font.Gotham
								textLabel13.TextSize = 11
								textLabel13.TextXAlignment = Enum.TextXAlignment.Left
								textLabel13.Parent = frame18
							end

							local textButton6 = Instance.new("TextButton")
							textButton6.Size = UDim2.fromOffset(46, 24)
							textButton6.Position = UDim2.new(1, -56, 0.5, -12)
							textButton6.BackgroundColor3 = default and tbl6.cyan or tbl6.surface
							textButton6.Text = ""
							textButton6.Parent = frame18
							local uiCorner17 = Instance.new("UICorner")
							uiCorner17.CornerRadius = UDim.new(1, 0)
							uiCorner17.Parent = textButton6
							local frame19 = Instance.new("Frame")
							frame19.Size = UDim2.fromOffset(20, 20)
							frame19.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
							frame19.BackgroundColor3 = tbl6.text
							frame19.BorderSizePixel = 0
							frame19.Parent = textButton6
							local uiCorner18 = Instance.new("UICorner")
							uiCorner18.CornerRadius = UDim.new(1, 0)
							uiCorner18.Parent = frame19

							local tbl14 = {
								Value = default,
								Callback = arg5.Callback or function()
								end,
								ChangedCallbacks = {},
							}

							local function fn11(value)
								fn5()
								tbl14.Value = value
								textButton6.BackgroundColor3 = value and tbl6.cyan or tbl6.surface
								frame19.Position = value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)

								pcall(function()
									tbl14.Callback(value)
								end)

								for _, changedCallback in ipairs(tbl14.ChangedCallbacks) do
									pcall(function()
										changedCallback(value)
									end)
								end
							end

							tbl14.OnChanged = function(arg6, arg7)
								table.insert(tbl14.ChangedCallbacks, arg7)
							end

							tbl14.SetValue = function(arg6, arg7)
								fn11(arg7 == true)
							end

							textButton6.MouseButton1Click:Connect(function()
								fn11(not tbl14.Value)
							end)

							tbl7.Options[arg4] = tbl14
							return tbl14
						end,
						AddSlider = function(arg3, arg4, arg5)
							local title2 = arg5.Title or arg4
							local min = arg5.Min or 0
							local max = arg5.Max or 100
							local default = arg5.Default or min
							local frame18 = Instance.new("Frame")
							frame18.Size = UDim2.new(1, -10, 0, 52)
							frame18.BackgroundColor3 = tbl6.glassDeep
							frame18.BackgroundTransparency = 0.18
							frame18.BorderSizePixel = 0
							frame18.Parent = scrollingFrame2
							local uiCorner16 = Instance.new("UICorner")
							uiCorner16.CornerRadius = UDim.new(0, 8)
							uiCorner16.Parent = frame18
							local uiStroke7 = Instance.new("UIStroke")
							uiStroke7.Color = tbl6.surface
							uiStroke7.Thickness = 1
							uiStroke7.Parent = frame18
							local textLabel12 = Instance.new("TextLabel")
							textLabel12.Size = UDim2.new(0.7, 0, 0, 22)
							textLabel12.Position = UDim2.new(0, 12, 0, 6)
							textLabel12.BackgroundTransparency = 1
							textLabel12.Text = title2
							textLabel12.TextColor3 = tbl6.text
							textLabel12.Font = Enum.Font.GothamBold
							textLabel12.TextSize = 14
							textLabel12.TextXAlignment = Enum.TextXAlignment.Left
							textLabel12.Parent = frame18
							local textLabel13 = Instance.new("TextLabel")
							textLabel13.Size = UDim2.new(0.3, -12, 0, 22)
							textLabel13.Position = UDim2.new(0.7, 0, 0, 6)
							textLabel13.BackgroundTransparency = 1
							textLabel13.Text = tostring(default)
							textLabel13.TextColor3 = tbl6.cyan
							textLabel13.Font = Enum.Font.GothamBold
							textLabel13.TextSize = 14
							textLabel13.TextXAlignment = Enum.TextXAlignment.Right
							textLabel13.Parent = frame18
							local textButton6 = Instance.new("TextButton")
							textButton6.Size = UDim2.new(1, -24, 0, 8)
							textButton6.Position = UDim2.new(0, 12, 0, 34)
							textButton6.BackgroundColor3 = tbl6.surface
							textButton6.Text = ""
							textButton6.Parent = frame18
							local uiCorner17 = Instance.new("UICorner")
							uiCorner17.CornerRadius = UDim.new(1, 0)
							uiCorner17.Parent = textButton6
							local frame19 = Instance.new("Frame")
							frame19.Size = UDim2.new((default - min) / math.max(max - min, 1), 0, 1, 0)
							frame19.BackgroundColor3 = tbl6.cyan
							frame19.BorderSizePixel = 0
							frame19.Parent = textButton6
							local uiCorner18 = Instance.new("UICorner")
							uiCorner18.CornerRadius = UDim.new(1, 0)
							uiCorner18.Parent = frame19

							local tbl14 = {
								Value = default,
								Callback = arg5.Callback or function()
								end,
								ChangedCallbacks = {},
							}

							local function fn11(arg6)
								local n4 = math.clamp(arg6, min, max)
								local value

								if arg5.Rounding then
									local n5 = 10 ^ arg5.Rounding
									value = math.floor(n4 * 10 ^ arg5.Rounding + 0.5) / n5
								else
									value = math.floor(n4 + 0.5)
								end

								tbl14.Value = value
								textLabel13.Text = tostring(value)
								frame19.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)

								pcall(function()
									tbl14.Callback(value)
								end)

								for _, changedCallback in ipairs(tbl14.ChangedCallbacks) do
									pcall(function()
										changedCallback(value)
									end)
								end
							end

							tbl14.OnChanged = function(arg6, arg7)
								table.insert(tbl14.ChangedCallbacks, arg7)
							end

							tbl14.SetValue = function(arg6, arg7)
								fn11(arg7)
							end

							local flag4 = false

							textButton6.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									flag4 = true
									fn11(min + (input.Position.X - textButton6.AbsolutePosition.X) / textButton6.AbsoluteSize.X * (max - min))
								end
							end)

							UserInputService.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									flag4 = false
								end
							end)

							UserInputService.InputChanged:Connect(function(input)
								if flag4 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
									fn11(min + (input.Position.X - textButton6.AbsolutePosition.X) / textButton6.AbsoluteSize.X * (max - min))
								end
							end)

							tbl7.Options[arg4] = tbl14
							return tbl14
						end,
						AddButton = function(arg3, arg4)
							local titleKey2 = arg4.TitleKey
							local title2 = titleKey2 and fn3(titleKey2) or arg4.Title or "Button"

							local callback = arg4.Callback or function()
							end

							local flag4 = string.find(title2, "⚡") or string.find(title2, "🚀") or string.find(title2, "🔍") or arg4.Style == "primary"
							local color = flag4 and Color3.fromRGB(46, 86, 153) or Color3.fromRGB(22, 35, 56)
							local color2 = flag4 and Color3.fromRGB(64, 113, 188) or Color3.fromRGB(33, 51, 80)
							local color3 = flag4 and Color3.fromRGB(31, 64, 117) or Color3.fromRGB(15, 25, 42)
							local textButton6 = Instance.new("TextButton")
							textButton6.Size = UDim2.new(1, -10, 0, 40)
							textButton6.BackgroundColor3 = color
							textButton6.BackgroundTransparency = 0.15
							textButton6.Text = title2
							textButton6.TextColor3 = Color3.fromRGB(232, 239, 251)
							textButton6.Font = Enum.Font.GothamBold
							textButton6.TextSize = 13
							textButton6.Parent = scrollingFrame2

							if titleKey2 then
								fn7(textButton6, titleKey2)
							end

							local uiCorner16 = Instance.new("UICorner")
							uiCorner16.CornerRadius = UDim.new(0, 8)
							uiCorner16.Parent = textButton6
							local uiStroke7 = Instance.new("UIStroke")
							uiStroke7.Color = flag4 and tbl6.primary or Color3.fromRGB(43, 65, 96)
							uiStroke7.Thickness = 1
							uiStroke7.Parent = textButton6

							textButton6.MouseEnter:Connect(function()
								local tbl14 = { BackgroundColor3 = color2 }
								TweenService:Create(textButton6, TweenInfo.new(0.18), tbl14):Play()
							end)

							textButton6.MouseLeave:Connect(function()
								local tbl14 = { BackgroundColor3 = color }
								TweenService:Create(textButton6, TweenInfo.new(0.18), tbl14):Play()
							end)

							textButton6.MouseButton1Down:Connect(function()
								local tbl14 = { BackgroundColor3 = color3 }
								TweenService:Create(textButton6, TweenInfo.new(0.08), tbl14):Play()
							end)

							textButton6.MouseButton1Up:Connect(function()
								local tbl14 = { BackgroundColor3 = color2 }
								TweenService:Create(textButton6, TweenInfo.new(0.08), tbl14):Play()
							end)

							textButton6.MouseButton1Click:Connect(function()
								fn5()
								pcall(callback)
							end)

							return textButton6
						end,
						AddInput = function(arg3, arg4, arg5)
							local title2 = arg5.Title or arg4
							local default = arg5.Default or ""
							local frame18 = Instance.new("Frame")
							frame18.Size = UDim2.new(1, -10, 0, 48)
							frame18.BackgroundColor3 = tbl6.glassDeep
							frame18.BackgroundTransparency = 0.18
							frame18.BorderSizePixel = 0
							frame18.Parent = scrollingFrame2
							local uiCorner16 = Instance.new("UICorner")
							uiCorner16.CornerRadius = UDim.new(0, 8)
							uiCorner16.Parent = frame18
							local textLabel12 = Instance.new("TextLabel")
							textLabel12.Size = UDim2.new(0.5, 0, 1, 0)
							textLabel12.Position = UDim2.new(0, 12, 0, 0)
							textLabel12.BackgroundTransparency = 1
							textLabel12.Text = title2
							textLabel12.TextColor3 = tbl6.text
							textLabel12.Font = Enum.Font.GothamBold
							textLabel12.TextSize = 14
							textLabel12.TextXAlignment = Enum.TextXAlignment.Left
							textLabel12.Parent = frame18
							local textBox2 = Instance.new("TextBox")
							textBox2.Size = UDim2.new(0.45, 0, 0, 30)
							textBox2.Position = UDim2.new(0.52, 0, 0.5, -15)
							textBox2.BackgroundColor3 = tbl6.input
							textBox2.BackgroundTransparency = 0.2
							textBox2.Text = tostring(default)
							textBox2.TextColor3 = tbl6.cyan
							textBox2.Font = Enum.Font.Gotham
							textBox2.TextSize = 13
							textBox2.Parent = frame18
							local uiCorner17 = Instance.new("UICorner")
							uiCorner17.CornerRadius = UDim.new(0, 6)
							uiCorner17.Parent = textBox2

							local tbl14 = {
								Value = default,
								Callback = arg5.Callback or function()
								end,
								ChangedCallbacks = {},
							}

							textBox2.FocusLost:Connect(function()
								tbl14.Value = textBox2.Text

								pcall(function()
									tbl14.Callback(textBox2.Text)
								end)

								for _, changedCallback in ipairs(tbl14.ChangedCallbacks) do
									pcall(function()
										changedCallback(textBox2.Text)
									end)
								end
							end)

							tbl14.OnChanged = function(arg6, arg7)
								table.insert(tbl14.ChangedCallbacks, arg7)
							end

							tbl14.SetValue = function(arg6, arg7)
								textBox2.Text = tostring(arg7)
								tbl14.Value = tostring(arg7)
							end

							tbl7.Options[arg4] = tbl14
							return tbl14
						end,
						AddSection = function(arg3, arg4, arg5)
							local textLabel12 = Instance.new("TextLabel")
							textLabel12.Size = UDim2.new(1, -10, 0, 30)
							textLabel12.BackgroundTransparency = 1
							textLabel12.TextColor3 = tbl6.cyan
							textLabel12.Font = Enum.Font.GothamBold
							textLabel12.TextSize = 14
							textLabel12.Parent = scrollingFrame2

							if tbl9.TH[arg4] or tbl9.EN[arg4] then
								fn7(textLabel12, arg4, "Text", "──  ", "  ──")
							else
								textLabel12.Text = "──  " .. (arg5 or arg4) .. "  ──"
							end

							return textLabel12
						end,
						AddParagraph = function(arg3, arg4)
							local title2 = arg4.Title or ""
							local desc = arg4.Desc or ""
							local frame18 = Instance.new("Frame")
							frame18.Size = UDim2.new(1, -10, 0, 54)
							frame18.BackgroundColor3 = tbl6.glassDeep
							frame18.BackgroundTransparency = 0.18
							frame18.BorderSizePixel = 0
							frame18.Parent = scrollingFrame2
							local uiCorner16 = Instance.new("UICorner")
							uiCorner16.CornerRadius = UDim.new(0, 8)
							uiCorner16.Parent = frame18
							local textLabel12 = Instance.new("TextLabel")
							textLabel12.Size = UDim2.new(1, -20, 0, 22)
							textLabel12.Position = UDim2.new(0, 10, 0, 6)
							textLabel12.BackgroundTransparency = 1
							textLabel12.Text = title2
							textLabel12.TextColor3 = tbl6.text
							textLabel12.Font = Enum.Font.GothamBold
							textLabel12.TextSize = 13
							textLabel12.TextXAlignment = Enum.TextXAlignment.Left
							textLabel12.Parent = frame18
							local textLabel13 = Instance.new("TextLabel")
							textLabel13.Size = UDim2.new(1, -20, 0, 24)
							textLabel13.Position = UDim2.new(0, 10, 0, 26)
							textLabel13.BackgroundTransparency = 1
							textLabel13.Text = desc
							textLabel13.TextColor3 = tbl6.textMuted
							textLabel13.Font = Enum.Font.Gotham
							textLabel13.TextSize = 11
							textLabel13.TextWrapped = true
							textLabel13.TextXAlignment = Enum.TextXAlignment.Left
							textLabel13.Parent = frame18
							return frame18
						end,
					}

					table.insert(tbl13.Tabs, tbl14)
					return tbl14
				end,
			}

			menuSearch:GetPropertyChangedSignal("Text"):Connect(function()
				local query = string.lower(menuSearch.Text)
				local visibleGroups = {}
				for _, tab in ipairs(tbl13.Tabs) do
					local matches = query == "" or string.find(tab.SearchText, query, 1, true) ~= nil
					tab.btn.Visible = matches
					if matches then visibleGroups[tab.Group] = true end
				end
				for id, heading in pairs(navGroups) do heading.Visible = visibleGroups[id] == true end
				scrollingFrame.CanvasPosition = Vector2.new(0, 0)
			end)
			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then
					return
				end

				if input.KeyCode == Enum.KeyCode.K then
					fn5()
					frame.Visible = not frame.Visible
				elseif input.KeyCode == Enum.KeyCode.F then
					fn5()
					n = n == 1 and 0.85 or 1
					fn9()
				end
			end)

			return tbl13
		end,
	}
end

local v
v = tbl7:CreateWindow({ Title = "DEVIL HUB", SubTitle = "AI • Explorer • Remotes • Dump" })
local devilHome = v:AddTab({ TitleKey = "TAB_HOME", Title = "Home" })
v.StatusCard.Parent = devilHome.page
v.StatusCard.Size = UDim2.new(1, -10, 0, 65)
v.StatusCard.LayoutOrder = -20
devilHome:AddParagraph({Title = "DEVIL HUB • AI & MAP TOOLS", Desc = "เริ่มจากสำรวจเกม → เลือกข้อมูล → สร้างโค้ด หรือบันทึก Dump เพื่ออ่านต่อ"})
devilHome:AddParagraph({Title = "CURRENT MAP", Desc = "Place: " .. tostring(game.PlaceId) .. " • Universe: " .. tostring(game.GameId)})
local function devilRoute(key)
	for _, tab in ipairs(v.Tabs) do
		if tab.Key == key then tab:Select(); return end
	end
end
for _, item in ipairs({
	{"สำรวจเกม / Game Explorer", "TAB_EXPLORER"},
	{"ดู Remote / Remote Spy", "TAB_SPY"},
	{"บันทึกข้อมูล / Dump Files", "TAB_DUMP"},
	{"สร้างโค้ด / AI Builder", "TAB_AI"},
	{"ดูไฟล์ที่บันทึก / File Preview", "TAB_PREVIEW"},
}) do
	local route = item[2]
	devilHome:AddButton({Title = item[1], Callback = function() devilRoute(route) end})
end
devilHome:AddButton({Title = "Discord • DEVIL HUB", Callback = function()
	local invite = "https://discord.gg/ZY7PRcVJe2"
	if typeof(setclipboard) == "function" then
		setclipboard(invite)
		tbl7:Notify({Title = "DEVIL HUB", Content = "คัดลอก Discord แล้ว / Invite copied", Duration = 3})
	else
		tbl7:Notify({Title = "DEVIL HUB", Content = invite, Duration = 8})
	end
end})
devilHome:Select()
local v2
v2 = v:AddTab({ TitleKey = "TAB_AI", Title = "✨ สร้างโค้ด AI" })
local v3
v3 = v:AddTab({ TitleKey = "TAB_MACRO", Title = "⚡ มาโครอัจฉริยะ (Smart Macros)" })
local v4
v4 = v:AddTab({ TitleKey = "TAB_EXPLORER", Title = "🔎 สำรวจโครงสร้างเกม" })
local v5
v5 = v:AddTab({ TitleKey = "TAB_SPY", Title = "📡 ดักจับ Remote Spy" })
local v6
v6 = v:AddTab({ TitleKey = "TAB_HTTP", Title = "🌐 ดักจับ HTTP (Traffic)" })
local v7, v8, v9, v10, v11, v12, textBox2, textBox3, fn6, fn7

do
	local v13 = v:AddTab({ TitleKey = "TAB_AC", Title = "🛡️ สแกน Anti-Cheat" })
	v7 = v:AddTab({ TitleKey = "TAB_DUMP", Title = "📦 เครื่องมือ Dump" })
	v8 = v:AddTab({ TitleKey = "TAB_PREVIEW", Title = "👁️ ตัวอย่างไฟล์ Dump" })
	v9 = v:AddTab({ TitleKey = "TAB_DEBUG", Title = "🐛 เทอร์มินัลระบบ (Debug)" })
	v10 = v:AddTab({ TitleKey = "TAB_MATRIX", Title = "📁 คลังคำสั่ง (Matrix)" })
	v11 = v:AddTab({ TitleKey = "TAB_DEOBF", Title = "🔓 ถอดรหัส (Deobfuscator)" })
	v12 = v:AddTab({ TitleKey = "TAB_SETTINGS", Title = "⚙️ ตั้งค่าระบบ" })
	textBox2 = nil
	textBox3 = nil
	local str = ""

	local function fn8(arg, arg2, arg3)
		if not arg then
			return
		end
		arg3 = arg3 or 185000
		local text = tostring(arg2 or "")

		if arg3 < #text then
			local str2 = "\n\n-- [⚠️ TRUNCATED FOR UI DISPLAY: Content length (" .. #text .. ") exceeded Roblox 200k char limit. Full data saved to file & clipboard] --"
			arg.Text = text:sub(1, arg3 - #str2) .. str2
		else
			arg.Text = text
		end
	end

	fn6 = function(arg, arg2, arg3)
		local str2 = arg3 or "File"
		local str3 = tostring(arg2 or "")
		local v14 = arg

		if typeof(makefolder) == "function" and typeof(isfolder) == "function" then
			pcall(function()
				local v15 = string.split(arg, "/")

				if #v15 > 1 then
					local str4 = ""

					for i = 1, #v15 - 1 do
						local str5 = str4 == "" and v15[i] or str4 .. "/" .. v15[i]

						if not isfolder(str5) then
							makefolder(str5)
							str4 = str5
						else
							str4 = str5
						end
					end
				end
			end)
		end

		local flag = false

		if typeof(writefile) == "function" then
			if pcall(function()
				writefile(arg, str3)
			end) then
				flag = true
			else
				local match = arg:match("([^/]+)$") or arg

				if pcall(function()
					writefile(match, str3)
				end) then
					v14 = match
					flag = true
				end
			end
		end

		local ok

		if typeof(setclipboard) == "function" then
			ok = pcall(function()
				setclipboard(str3)
			end)
		else
			ok = false

			if typeof(toclipboard) == "function" then
				ok = pcall(function()
					toclipboard(str3)
				end)
			end
		end

		if flag and ok then
			tbl7:Notify({
				Title = "💾 " .. str2 .. " Saved!",
				Content = "บันทึก: " .. v14 .. "\n📋 คัดลอกข้อมูลลง Clipboard ให้แล้ว!",
				Duration = 4,
			})
		elseif flag then
			tbl7:Notify({ Title = "💾 " .. str2 .. " Saved!", Content = "บันทึกไฟล์สำเร็จ: " .. v14, Duration = 3 })
		elseif ok then
			tbl7:Notify({
				Title = "📋 Copied to Clipboard!",
				Content = "มือถือไม่รองรับ writefile\nแต่คัดลอกข้อมูลลง Clipboard ให้แล้ว!",
				Duration = 4,
			})
		else
			tbl7:Notify({ Title = "❌ Save Failed", Content = "อุปกรณ์ไม่รองรับการเขียนไฟล์หรือคลิปบอร์ด", Duration = 3 })
		end

		return flag or ok
	end

	fn7 = function(text, arg)
		if textBox2 then
			textBox2.Text = text
		end

		if v2 and v2.Select then
			pcall(function()
				v2:Select()
			end)
		end

		local payomboyZSubport = getgenv().PayomboyZ_Subport or _G.PayomboyZ_Subport

		if payomboyZSubport and payomboyZSubport.Bridge and typeof(payomboyZSubport.Bridge.GenerateAIAsync) == "function" then
			if textBox3 then
				textBox3.Text = string.format([[-- ⏳ กำลังติดต่อ Gemini 3.6 Flash AI Engine (รองรับทั้ง Mobile & PC)...
-- คำสั่ง: %s
-- รอสักครู่ ระบบกำลังวิเคราะห์ Telemetry และสังเคราะห์สคริปต์...]], tostring(text))
			end

			tbl7:Notify({
				Title = "🤖 Contacting Gemini AI Engine",
				Content = "กำลังสังเคราะห์โค้ดและคำแนะนำผ่าน Gemini 3.6 Flash (Mobile Direct Ready)...",
				Duration = 3,
			})

			payomboyZSubport.Bridge.GenerateAIAsync(text, arg, function(arg2)
				if arg2 and arg2.Success and arg2.Code and #arg2.Code > 0 then
					if textBox3 then
						textBox3.Text = arg2.Code
					end

					tbl7:Notify({
						Title = "⚡ AI Co-Pilot Ready",
						Content = string.format("สร้างสคริปต์สำเร็จผ่าน %s (%.2fs)!", arg2.Model or "Gemini 3.6 Flash", arg2.Elapsed or 0),
						Duration = 4,
					})
				else
					local v14 = tbl4:SynthesizeScript(text, arg)

					if textBox3 then
						textBox3.Text = v14
					end

					tbl7:Notify({
						Title = "🟡 Local AI Brain (Offline Fallback)",
						Content = "เครือข่ายออฟไลน์ ใช้ระบบสังเคราะห์โค้ดอัตโนมัติในเครื่องสำเร็จ!",
						Duration = 3,
					})
				end
			end)

			return
		end

		local v14 = tbl4:SynthesizeScript(text, arg)

		if textBox3 then
			textBox3.Text = v14
		end

		tbl7:Notify({
			Title = "⚡ Cyber-AI Brain V8 Ready",
			Content = "สร้างสคริปต์อัตโนมัติจากโมดูลสำเร็จ (พร้อมคำแนะนำและระบบ Maid Cleanup)!",
			Duration = 3,
		})

		return v14
	end

	local tbl8 = {}
	local textBox4 = nil

	local function fn9(arg)
		local tbl9 = {}
		local str2 = ""

		if typeof(getscriptbytecode) == "function" then
			pcall(function()
				str2 = getscriptbytecode(arg) or ""
			end)
		end

		if str2 == "" and typeof(decompile) == "function" then
			pcall(function()
				str2 = decompile(arg) or ""
			end)
		end

		local v14 = string.lower(str2)

		if v14 ~= "" then
			if v14:find("httpget") or v14:find("httpservice") or v14:find("postasync") or v14:find("requestasync") then
				table.insert(tbl9, "🚨 Exfiltration (HttpService/PostAsync)")
			end

			if v14:find("getgenv") or v14:find("is_sirhurt_closure") or v14:find("identifyexecutor") or v14:find("checkcaller") then
				table.insert(tbl9, "🚨 Environment Sniffer (getgenv/identifyexecutor)")
			end

			if v14:find("walkspeed") or v14:find("jumppower") or v14:find("assemblylinearvelocity") or v14:find("cframe") then
				table.insert(tbl9, "⚡ Physics Tripwire (Speed/Velocity/CFrame Loop)")
			end

			if v14:find("fireclickdetector") or v14:find("fireproximityprompt") then
				table.insert(tbl9, "⚠️ Automation Tripwire (fireproximityprompt scan)")
			end

			if v14:find(":kick") or v14:find("punish") or v14:find("ban") then
				table.insert(tbl9, "🛑 Kick/Ban Vector Dispatch")
			end
		end

		return tbl9
	end

	local function fn10(arg, arg2)
		local str2 = arg.Name:lower()
		local str3 = arg:GetFullName():lower()

		for _, v14 in ipairs({
			"banner",
			"bandana",
			"camera",
			"vr",
			"headband",
			"tutorial",
			"objective",
			"onboarding",
			"cosmetic",
			"particle",
			"sound",
			"music",
			"anim",
		}) do
			if str2:find(v14) then
				return 0, "⚪ NONE", {}
			end
		end

		local tbl9 = {}
		local isLocalScript = arg:IsA("LocalScript") or arg:IsA("ModuleScript")
		local n = 0

		if isLocalScript then
			local v14 = fn9(arg)

			if #v14 > 0 then
				n = 0 + #v14 * 35

				for _, v15 in ipairs(v14) do
					table.insert(tbl9, v15)
				end
			end
		end

		local isRemoteEvent = arg:IsA("RemoteEvent") or arg:IsA("RemoteFunction")

		if isRemoteEvent then
			isRemoteEvent = str2:find("ban") or str2:find("kick") or str2:find("punish") or str2:find("report") or str2:find("security") or str2:find("flag") or str2:find("detection") or str2:find("cheat")
		end

		if isRemoteEvent then
			n += 65
			table.insert(tbl9, "🚨 Critical Ban/Security Remote (" .. arg.Name .. ")")
		end

		if str2:find("anticheat") or str2:find("anti_cheat") or str2:find("exploit") or str2:find("anti") and (str2:find("fly") or str2:find("speed") or str2:find("teleport") or str2:find("god")) then
			n += 50
			table.insert(tbl9, "✓ Critical Anti-Cheat Match (" .. arg.Name .. ")")
		elseif str2:find("warden") or str2:find("vulcan") or str2:find("adonis") or str2:find("byfron") or str2:find("integrity") then
			n += 45
			table.insert(tbl9, "✓ Known AC Framework Match (" .. arg.Name .. ")")
		else
			for _, v14 in ipairs(arg2) do
				if str2:find(v14, 1, true) then
					n += 20
					table.insert(tbl9, "✓ Suspicious Pattern ('" .. v14 .. "')")
					break
				end
			end
		end

		if n > 0 then
			if arg:IsA("LocalScript") then
				n += 15
				table.insert(tbl9, "✓ Client LocalScript")
			elseif arg:IsA("ModuleScript") then
				n += 10
				table.insert(tbl9, "✓ Client Module")
			elseif arg:IsA("RemoteEvent") or arg:IsA("RemoteFunction") then
				n += 15
				table.insert(tbl9, "✓ AC Remote Hook")
			end

			if str3:find("starterplayer") or str3:find("playerscripts") then
				n += 15
				table.insert(tbl9, "✓ PlayerScripts Path")
			elseif str3:find("replicatedfirst") then
				n += 20
				table.insert(tbl9, "✓ Early Bootloader Path")
			end
		end

		local n2 = math.min(100, n)
		local str4

		if n2 >= 70 then
			str4 = "🔴 HIGH"
		else
			str4 = "🟢 LOW"

			if n2 >= 40 then
				str4 = "🟡 MEDIUM"
			end
		end

		return n2, str4, tbl9
	end

	local function fn11(arg, arg2)
		local tbl9 = {}

		local ok, result = pcall(function()
			return arg:GetDescendants()
		end)

		if not ok or not result then
			return tbl9
		end

		for _, v14 in ipairs(result) do
			if v14:IsA("LocalScript") or v14:IsA("ModuleScript") or v14:IsA("RemoteEvent") or v14:IsA("RemoteFunction") or v14:IsA("Script") then
				local v15, v16, v17 = fn10(v14, arg2)

				if v15 >= 35 and #v17 > 0 then
					table.insert(tbl9, {
						Path = v14:GetFullName(),
						Class = v14.ClassName,
						Name = v14.Name,
						Confidence = v15,
						Tag = v16,
						Reasons = table.concat(v17, " | "),
					})
				end
			end
		end

		return tbl9
	end

	local function fn12()
		local tbl9 = {}
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local StarterPlayer = game:GetService("StarterPlayer")
		local StarterGui = game:GetService("StarterGui")
		local StarterPack = game:GetService("StarterPack")
		local Players2 = game:GetService("Players")
		local v14 = game
		local getService = v14.GetService
		tbl9[1] = ReplicatedStorage
		tbl9[2] = StarterPlayer
		tbl9[3] = StarterGui
		tbl9[4] = StarterPack
		tbl9[5] = Players2

		do
			local values = table.pack(getService(v14, "Workspace"))
			table.move(values, 1, values.n, 6, tbl9)
		end

		local tbl10 = {
			"anti",
			"cheat",
			"valid",
			"integrity",
			"check",
			"exploit",
			"detection",
			"protection",
			"secure",
			"verify",
			"auth",
			"guard",
			"monitor",
			"track",
			"prevent",
			"block",
		}

		local tbl11 = {}
		local tbl12 = {}
		local str2 = "Game PlaceId: " .. tostring(game.PlaceId)
		local str3 = "Scan Time: " .. os.date("%Y-%m-%d %H:%M:%S")
		tbl12[1] = "═══════════════════════════════════════════════════════"
		tbl12[2] = "[HEURISTIC SUSPICION SCANNER v2.0 - CONFIDENCE ENGINE]"
		tbl12[3] = str2
		tbl12[4] = str3
		tbl12[5] = "═══════════════════════════════════════════════════════"
		fn2("INFO", "AC_SCAN", "Starting universal anti-cheat scan across game services...")

		for _, v15 in ipairs(tbl9) do
			if v15 then
				table.insert(tbl12, "\n[SCAN] " .. v15.Name .. ":")
				local v16 = fn11(v15, tbl10)

				if #v16 > 0 then
					for _, v17 in ipairs(v16) do
						local str4 = string.format("  %s [%d%% CONFIDENCE] %s (%s) | Patterns: %s", v17.Tag, v17.Confidence, v17.Path, v17.Class, v17.Reasons)
						table.insert(tbl12, str4)
						table.insert(tbl11, v17)
						fn2("WARN", "AC_DETECTION", string.format("Found %s (%d%%): %s", v17.Tag, v17.Confidence, v17.Path))
					end
				else
					table.insert(tbl12, "  (No suspect scripts detected in " .. v15.Name .. ")")
				end
			end
		end

		table.insert(tbl12, "\n═══════════════════════════════════════════════════════")
		table.insert(tbl12, "[SUMMARY] DETECTED ANTI-CHEAT INSTANCES: " .. tostring(#tbl11))
		table.insert(tbl12, "═══════════════════════════════════════════════════════")

		for i, v15 in ipairs(tbl11) do
			table.insert(tbl12, string.format("  %d. %s [%d%% CONFIDENCE] %s (%s)", i, v15.Tag, v15.Confidence, v15.Path, v15.Class))
		end

		table.insert(tbl12, "═══════════════════════════════════════════════════════")
		tbl8 = tbl11

		if tbl4 then
			tbl4:RegisterACDetection(tbl11)
		end

		return tbl11, table.concat(tbl12, "\n")
	end

	local flag = false

	local function fn13()
		if flag then
			tbl7:Notify({
				Title = "Shield Alert",
				Content = "Anti-Cheat Bypass Matrix is ALREADY active!",
				Duration = 3,
			})

			return
		end

		flag = true

		if type(hookmetamethod) == "function" then
			local v14 = nil

			local function fn14(arg, ...)
				local v15 = getnamecallmethod()
				if flag and (v15 == "Kick" or v15 == "kick") then
					fn2("WARN", "AC_BYPASS", "Prevented client kick call!")
					return nil
				end

				if flag and (v15 == "FireServer" or v15 == "InvokeServer") then
					local str2 = tostring(arg.Name):lower()
					if str2:find("ban") or str2:find("kick") or str2:find("exploit") or str2:find("security") or str2:find("punish") or str2:find("detection") or str2:find("report") then
						fn2("WARN", "AC_BYPASS", "Silently dropped security report remote: " .. arg.Name)
						return nil
					end
				end

				return v14(arg, ...)
			end

			v14 = hookmetamethod
			v14 = v14(game, "__namecall", newcclosure(fn14))
		end

		pcall(function()
			if type(hookfunction) == "function" and Players.LocalPlayer then
				hookfunction(Players.LocalPlayer.Kick, newcclosure(function()
					fn2("WARN", "AC_BYPASS", "Direct Kick() intercepted and neutralised.")
					return nil
				end))
			end
		end)

		pcall(function()
			local localPlayer = Players.LocalPlayer

			if localPlayer and localPlayer.Character then
				local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
						if not flag then
							return
						end

						if humanoid.WalkSpeed == 0 then
							humanoid.WalkSpeed = 16
						end
					end)
				end
			end
		end)

		tbl7:Notify({
			Title = "🛡️ Bypass Matrix Armed",
			Content = "เกราะป้องกันทำงาน: บล็อกการ Kick, ดักรีโมทแบน, ป้องกันกับดักฟิสิกส์แล้ว!",
			Duration = 5,
		})

		fn2("INFO", "AC_BYPASS", "Universal Behavioral Anti-Cheat Bypass Matrix fully armed.")
	end

	v13:AddSection("SCAN ENGINE CONTROLS")

	v13:AddButton({
		Title = "🛡️ ARM BEHAVIORAL BYPASS MATRIX (เปิดใช้งานเกราะป้องกัน & Bypass ทันที)",
		Style = "primary",
		Callback = function()
			fn13()
		end,
	})

	v13:AddButton({
		Title = "🔍 RUN BEHAVIORAL & HEURISTIC DEEP SCAN",
		Callback = function()
			if textBox4 then
				textBox4.Text = "[Scan Engine] Initiating Heuristic & Behavioral Deep Scan...\n"
			end

			task.spawn(function()
				local v14, v15 = fn12()
				str = v15

				if textBox4 then
					fn8(textBox4, v15)
				end

				fn6("PAYOMBOYDumps/AntiCheatLogs/ACScan_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", v15, "AC Scan")
			end)
		end,
	})

	v13:AddSection("ANTI-CHEAT SCAN LOG OUTPUT")
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 180)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v13.page
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame.BackgroundColor3 = tbl6.input
	scrollingFrame.BackgroundTransparency = 0.3
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 6
	scrollingFrame.ScrollBarImageColor3 = tbl6.primary
	scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.Parent = frame
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 6)
	uiCorner2.Parent = scrollingFrame
	textBox4 = Instance.new("TextBox")
	textBox4.Size = UDim2.new(1, -10, 1, 0)
	textBox4.Position = UDim2.new(0, 5, 0, 0)
	textBox4.BackgroundTransparency = 1
	textBox4.PlaceholderText = "-- Press 'RUN UNIVERSAL ANTI-CHEAT SCAN' to start scanning..."
	textBox4.Text = ""
	textBox4.Font = Enum.Font.Code
	textBox4.TextSize = 11
	textBox4.TextColor3 = Color3.fromRGB(255, 200, 100)
	textBox4.MultiLine = true
	textBox4.ClearTextOnFocus = false
	textBox4.TextXAlignment = Enum.TextXAlignment.Left
	textBox4.TextYAlignment = Enum.TextYAlignment.Top
	textBox4.AutomaticSize = Enum.AutomaticSize.Y
	textBox4.Parent = scrollingFrame
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 4)
	uiPadding.PaddingTop = UDim.new(0, 4)
	uiPadding.Parent = textBox4
	v13:AddSection("LOG EXPORT & UTILITIES")

	v13:AddButton({
		Title = "💾 Save Scan Log to File Manually",
		Callback = function()
			local text = str and #str > 0 and str or textBox4 and textBox4.Text or ""

			if text ~= "" then
				fn6("PAYOMBOYDumps/AntiCheatLogs/ACScan_Manual_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", text, "AC Scan Log")
			else
				tbl7:Notify({ Title = "Warning", Content = "Scan log is empty!", Duration = 3 })
			end
		end,
	})

	v13:AddButton({
		Title = "📋 Copy Scan Log to Clipboard",
		Callback = function()
			local text = str and #str > 0 and str or textBox4 and textBox4.Text or ""

			if text ~= "" then
				if typeof(setclipboard) == "function" then
					setclipboard(text)

					tbl7:Notify({
						Title = "Copied",
						Content = "Copied full scan log (" .. #text .. " chars) to clipboard!",
						Duration = 3,
					})
				end
			else
				tbl7:Notify({ Title = "Warning", Content = "Scan log is empty!", Duration = 3 })
			end
		end,
	})

	v13:AddButton({
		Title = "⚡ SYNTHESIZE SAFE BYPASS SCRIPT (สร้างสคริปต์บายพาสปลอดภัย)",
		Style = "primary",
		Callback = function()
			fn7("สร้างระบบบายพาสป้องกันการตรวจจับ Anti-Cheat Bypass")
		end,
	})
end

do
	local tbl8 = {}
	local str = "ALL"
	v4:AddSection("GAME INTELLIGENCE SEARCH & SCOPE CONTROLLER")
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 114)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v4.page
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.cyan
	uiStroke.Thickness = 1.2
	uiStroke.Parent = frame
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -24, 0, 18)
	textLabel.Position = UDim2.new(0, 12, 0, 6)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "🎯 CYBER INTELLIGENCE QUERY & LIVE GAME OBJECT PROBER"
	textLabel.TextColor3 = tbl6.cyan
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = frame
	local textBox4 = Instance.new("TextBox")
	textBox4.Size = UDim2.new(1, -24, 0, 30)
	textBox4.Position = UDim2.new(0, 12, 0, 26)
	textBox4.BackgroundColor3 = tbl6.input
	textBox4.BackgroundTransparency = 0.2
	textBox4.PlaceholderText = "e.g. 'Portal', 'Remote', 'Dungeon', 'Egg', 'Forge', 'Mob', 'Shop', 'Reward'"
	textBox4.Text = "Portal"
	textBox4.Font = Enum.Font.GothamSemibold
	textBox4.TextSize = 12
	textBox4.TextColor3 = tbl6.primary
	textBox4.ClearTextOnFocus = false
	textBox4.TextXAlignment = Enum.TextXAlignment.Left
	textBox4.Parent = frame
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 6)
	uiCorner2.Parent = textBox4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 10)
	uiPadding.Parent = textBox4
	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(1, -24, 0, 26)
	scrollingFrame.Position = UDim2.new(0, 12, 0, 60)
	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.ScrollBarThickness = 3
	scrollingFrame.ScrollBarImageColor3 = tbl6.primary
	scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
	scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame.CanvasSize = UDim2.new(0, 720, 0, 0)
	scrollingFrame.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = scrollingFrame
	local tbl9 = {}
	local tbl10 = { Id = "ALL", Label = "🔍 ALL", Color = tbl6.primary }
	local tbl11 = { Id = "REMOTES", Label = "📡 REMOTES", Color = Color3.fromRGB(0, 210, 255) }
	local tbl12 = { Id = "MODULES", Label = "📦 MODULES", Color = Color3.fromRGB(180, 110, 255) }
	local tbl13 = { Id = "PARTS", Label = "🧱 PARTS/MODELS", Color = Color3.fromRGB(255, 160, 40) }
	local tbl14 = { Id = "SCRIPTS", Label = "📜 SCRIPTS", Color = Color3.fromRGB(40, 230, 140) }
	local tbl15 = { Id = "VALUES", Label = "💎 VALUES", Color = Color3.fromRGB(255, 220, 60) }
	local tbl16 = { Id = "DUNGEON", Label = "⚔️ DUNGEON/PORTAL", Color = Color3.fromRGB(255, 60, 100) }
	tbl9[1] = tbl10
	tbl9[2] = tbl11
	tbl9[3] = tbl12
	tbl9[4] = tbl13
	tbl9[5] = tbl14
	tbl9[6] = tbl15
	tbl9[7] = tbl16
	local tbl17 = {}

	local function fn8()
		for k, v13 in pairs(tbl17) do
			local flag = k == str
			v13.BackgroundTransparency = flag and 0.15 or 0.65
			v13.TextColor3 = flag and Color3.fromRGB(255, 255, 255) or tbl6.textMuted
		end
	end

	for i, v13 in ipairs(tbl9) do
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0, 92, 0, 22)
		textButton.BackgroundColor3 = v13.Color
		textButton.BackgroundTransparency = 0.65
		textButton.Text = v13.Label
		textButton.TextColor3 = tbl6.textMuted
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 10
		textButton.LayoutOrder = i
		textButton.Parent = scrollingFrame
		local uiCorner3 = Instance.new("UICorner")
		uiCorner3.CornerRadius = UDim.new(0, 4)
		uiCorner3.Parent = textButton
		tbl17[v13.Id] = textButton

		textButton.MouseButton1Click:Connect(function()
			fn5()
			str = v13.Id
			fn8()
			tbl7:Notify({ Title = "Filter Selected", Content = "Filter mode: " .. v13.Label, Duration = 2 })
		end)
	end

	fn8()
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -24, 0, 16)
	textLabel2.Position = UDim2.new(0, 12, 0, 90)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = "Scope: Workspace, ReplicatedStorage, Players, StarterGui, Lighting  •  Results: Real-Time Stream"
	textLabel2.TextColor3 = tbl6.textDim
	textLabel2.Font = Enum.Font.Code
	textLabel2.TextSize = 10
	textLabel2.TextXAlignment = Enum.TextXAlignment.Left
	textLabel2.Parent = frame
	v4:AddSection("DISCOVERED OBJECTS & CYBER INSPECTION")
	local scrollingFrame2 = Instance.new("ScrollingFrame")
	scrollingFrame2.Size = UDim2.new(1, -10, 0, 240)
	scrollingFrame2.BackgroundColor3 = tbl6.glassDeep
	scrollingFrame2.BackgroundTransparency = 0.18
	scrollingFrame2.BorderSizePixel = 0
	scrollingFrame2.ScrollBarThickness = 6
	scrollingFrame2.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame2.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame2.Parent = v4.page
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 8)
	uiCorner3.Parent = scrollingFrame2
	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Padding = UDim.new(0, 6)
	uiListLayout2.Parent = scrollingFrame2
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 6)
	uiPadding2.PaddingRight = UDim.new(0, 6)
	uiPadding2.PaddingTop = UDim.new(0, 6)
	uiPadding2.PaddingBottom = UDim.new(0, 6)
	uiPadding2.Parent = scrollingFrame2

	local function fn9()
		for _, child in ipairs(scrollingFrame2:GetChildren()) do
			if child:IsA("Frame") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end
	end

	local function fn10(arg)
		if not arg then
			return "nil"
		end
		local tbl18 = {}

		while arg and arg ~= game do
			table.insert(tbl18, 1, arg.Name)
			arg = arg.Parent
		end

		if #tbl18 == 0 then
			return "game"
		end
		local str2 = string.format("game:GetService(%q)", tbl18[1])

		for i = 2, #tbl18 do
			str2 ..= string.format(":WaitForChild(%q)", tbl18[i])
		end

		return str2
	end

	local function fn11(arg)
		fn9()
		if not arg or arg == "" then
			return
		end
		local str2 = arg:lower()
		local tbl18 = {}
		local Workspace_ = game:GetService("Workspace")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Players2 = game:GetService("Players")
		local StarterGui = game:GetService("StarterGui")
		local StarterPlayer = game:GetService("StarterPlayer")
		local v13 = game
		local getService = v13.GetService
		tbl18[1] = Workspace_
		tbl18[2] = ReplicatedStorage
		tbl18[3] = Players2
		tbl18[4] = StarterGui
		tbl18[5] = StarterPlayer

		do
			local values = table.pack(getService(v13, "Lighting"))
			table.move(values, 1, values.n, 6, tbl18)
		end

		fn2("INFO", "EXPLORER", string.format("Query: '%s' | Category: %s", arg, str))
		local n = 0

		for _, v14 in ipairs(tbl18) do
			if v14 and n < 50 then
				local ok, result = pcall(function()
					return v14:GetDescendants()
				end)

				if ok and result then
					for _, v15 in ipairs(result) do
						local name = v15.Name
						local str3 = name:lower()
						local className = v15.ClassName
						local str4 = className:lower()
						local flag

						if str == "ALL" then
							flag = true
						elseif str == "REMOTES" then
							flag = v15:IsA("RemoteEvent") or v15:IsA("RemoteFunction") or v15:IsA("UnreliableRemoteEvent") or str4:find("remote")
						elseif str == "MODULES" then
							flag = v15:IsA("ModuleScript")
						elseif str == "PARTS" then
							flag = v15:IsA("BasePart") or v15:IsA("Model")
						elseif str == "SCRIPTS" then
							flag = v15:IsA("LocalScript") or v15:IsA("Script")
						elseif str == "VALUES" then
							flag = v15:IsA("ValueBase")
						else
							flag = false

							if str == "DUNGEON" then
								flag = str3:find("portal") or str3:find("dungeon") or str3:find("door") or str3:find("mob") or str3:find("boss") or str3:find("forge") or str3:find("gate") or str3:find("reward")
							end
						end

						flag = flag and (str3:find(str2, 1, true) or str4:find(str2, 1, true))

						if flag then
							n += 1
							local fullName = v15:GetFullName()
							local v16 = fn10(v15)
							local textMuted = tbl6.textMuted
							local text

							if v15:IsA("RemoteEvent") or v15:IsA("RemoteFunction") or v15:IsA("UnreliableRemoteEvent") then
								textMuted = Color3.fromRGB(0, 210, 255)
								text = "[REM]"
							elseif v15:IsA("ModuleScript") then
								textMuted = Color3.fromRGB(180, 110, 255)
								text = "[MOD]"
							elseif v15:IsA("BasePart") or v15:IsA("Model") then
								textMuted = Color3.fromRGB(255, 160, 40)
								text = "[PRT]"
							elseif v15:IsA("LocalScript") or v15:IsA("Script") then
								textMuted = Color3.fromRGB(40, 230, 140)
								text = "[SCR]"
							else
								text = "[OBJ]"

								if v15:IsA("ValueBase") then
									textMuted = Color3.fromRGB(255, 220, 60)
									text = "[VAL]"
								end
							end

							local frame2 = Instance.new("Frame")
							frame2.Size = UDim2.new(1, 0, 0, 64)
							frame2.BackgroundColor3 = tbl6.surface
							frame2.BackgroundTransparency = 0.2
							frame2.BorderSizePixel = 0
							frame2.Parent = scrollingFrame2
							local uiCorner4 = Instance.new("UICorner")
							uiCorner4.CornerRadius = UDim.new(0, 6)
							uiCorner4.Parent = frame2
							local uiStroke2 = Instance.new("UIStroke")
							uiStroke2.Color = textMuted
							uiStroke2.Thickness = 1
							uiStroke2.Transparency = 0.75
							uiStroke2.Parent = frame2
							local textLabel3 = Instance.new("TextLabel")
							textLabel3.Size = UDim2.fromOffset(40, 16)
							textLabel3.Position = UDim2.new(0, 8, 0, 4)
							textLabel3.BackgroundColor3 = textMuted
							textLabel3.Text = text
							textLabel3.TextColor3 = tbl6.background
							textLabel3.Font = Enum.Font.GothamBold
							textLabel3.TextSize = 9
							textLabel3.Parent = frame2
							local uiCorner5 = Instance.new("UICorner")
							uiCorner5.CornerRadius = UDim.new(0, 3)
							uiCorner5.Parent = textLabel3
							local textLabel4 = Instance.new("TextLabel")
							textLabel4.Size = UDim2.new(1, -60, 0, 16)
							textLabel4.Position = UDim2.new(0, 52, 0, 4)
							textLabel4.BackgroundTransparency = 1
							textLabel4.Text = string.format("[%d] %s (%s)", n, name, className)
							textLabel4.TextColor3 = tbl6.text
							textLabel4.Font = Enum.Font.GothamBold
							textLabel4.TextSize = 11
							textLabel4.TextXAlignment = Enum.TextXAlignment.Left
							textLabel4.Parent = frame2
							local text2 = fullName

							if v15:IsA("BasePart") then
								text2 = string.format("Pos: (%.1f, %.1f, %.1f)  •  Path: %s", v15.Position.X, v15.Position.Y, v15.Position.Z, fullName)
							elseif v15:IsA("Model") and v15.PrimaryPart then
								text2 = string.format("PrimaryPos: (%.1f, %.1f, %.1f)  •  Children: %d", v15.PrimaryPart.Position.X, v15.PrimaryPart.Position.Y, v15.PrimaryPart.Position.Z, #v15:GetChildren())
							elseif v15:IsA("ValueBase") then
								local ok2, result2 = pcall(function()
									return v15.Value
								end)

								text2 = string.format("Value = %s  •  Path: %s", tostring(result2), fullName)
							end

							local textLabel5 = Instance.new("TextLabel")
							textLabel5.Size = UDim2.new(1, -12, 0, 14)
							textLabel5.Position = UDim2.new(0, 8, 0, 22)
							textLabel5.BackgroundTransparency = 1
							textLabel5.Text = text2
							textLabel5.TextColor3 = tbl6.textMuted
							textLabel5.Font = Enum.Font.Code
							textLabel5.TextSize = 9
							textLabel5.TextXAlignment = Enum.TextXAlignment.Left
							textLabel5.Parent = frame2
							local frame3 = Instance.new("Frame")
							frame3.Size = UDim2.new(1, -12, 0, 18)
							frame3.Position = UDim2.new(0, 8, 0, 40)
							frame3.BackgroundTransparency = 1
							frame3.Parent = frame2
							local uiListLayout3 = Instance.new("UIListLayout")
							uiListLayout3.FillDirection = Enum.FillDirection.Horizontal
							uiListLayout3.Padding = UDim.new(0, 5)
							uiListLayout3.Parent = frame3

							local function fn12(text3, backgroundColor3, arg2)
								local textButton = Instance.new("TextButton")
								textButton.Size = UDim2.new(0, 72, 1, 0)
								textButton.BackgroundColor3 = backgroundColor3
								textButton.BackgroundTransparency = 0.2
								textButton.Text = text3
								textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
								textButton.Font = Enum.Font.GothamBold
								textButton.TextSize = 9
								textButton.Parent = frame3
								local uiCorner6 = Instance.new("UICorner")
								uiCorner6.CornerRadius = UDim.new(0, 4)
								uiCorner6.Parent = textButton

								textButton.MouseButton1Click:Connect(function()
									fn5()
									arg2()
								end)
							end

							fn12("📋 Copy Lua", tbl6.secondary, function()
								if typeof(setclipboard) == "function" then
									setclipboard(v16)
									tbl7:Notify({ Title = "Copied Lua Code", Content = v16, Duration = 3 })
								end
							end)

							if v15:IsA("BasePart") or v15:IsA("Model") then
								fn12("👁️ 3D ESP", Color3.fromRGB(0, 200, 180), function()
									local v17 = tbl8[v15]

									if v17 and v17.Parent then
										v17:Destroy()
										tbl8[v15] = nil
										tbl7:Notify({ Title = "ESP Disabled", Content = "Removed 3D Highlight for " .. name, Duration = 2 })
									else
										local highlight = Instance.new("Highlight")
										highlight.Name = "PayomboyZ_ESP_" .. name
										highlight.FillColor = Color3.fromRGB(0, 255, 200)
										highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
										highlight.FillTransparency = 0.4
										highlight.OutlineTransparency = 0.1
										highlight.Adornee = v15
										highlight.Parent = v15
										tbl8[v15] = highlight

										tbl7:Notify({
											Title = "👁️ 3D ESP Enabled",
											Content = "Highlighting " .. name .. " through walls!",
											Duration = 3,
										})
									end
								end)
							end

							local isBasePart = v15:IsA("BasePart")
							local primaryPart

							if isBasePart then
								primaryPart = isBasePart
							else
								local isModel = v15:IsA("Model")

								if isModel then
									primaryPart = v15.PrimaryPart or v15:FindFirstChildWhichIsA("BasePart")
								else
									primaryPart = isModel
								end
							end

							if primaryPart then
								fn12("🚀 Teleport", Color3.fromRGB(140, 60, 240), function()
									local isBasePart2 = v15:IsA("BasePart") and v15 or v15.PrimaryPart or v15:FindFirstChildWhichIsA("BasePart")
									local localPlayer = Players.LocalPlayer

									if localPlayer and localPlayer.Character and isBasePart2 then
										local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart") or localPlayer.Character:FindFirstChild("Torso")

										if humanoidRootPart then
											humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
											humanoidRootPart.CFrame = isBasePart2.CFrame + Vector3.new(0, 3, 0)
											tbl7:Notify({ Title = "Teleported", Content = "Warped directly to " .. name, Duration = 2 })
										end
									end
								end)
							end

							if v15:IsA("RemoteEvent") then
								fn12("🔥 Fire Event", Color3.fromRGB(255, 60, 60), function()
									pcall(function()
										v15:FireServer()
									end)

									tbl7:Notify({ Title = "Remote Fired", Content = "Fired " .. name .. ":FireServer()", Duration = 2 })
								end)
							elseif v15:IsA("RemoteFunction") then
								fn12("📞 Invoke", Color3.fromRGB(255, 140, 0), function()
									task.spawn(function()
										local ok2, result2 = pcall(function()
											return v15:InvokeServer()
										end)

										tbl7:Notify({ Title = "Remote Invoked", Content = "Result: " .. tostring(result2), Duration = 3 })
									end)
								end)
							end

							fn12("🗑️ Nil/Del", tbl6.danger, function()
								pcall(function()
									v15:Destroy()
								end)

								tbl7:Notify({ Title = "Object Destroyed", Content = "Client-side deleted " .. name, Duration = 2 })
							end)

							fn12("🧠 To AI", tbl6.primary, function()
								if tbl2:AddContext(name, className, fullName, "Explorer") then
									tbl7:Notify({
										Title = "Context Bound",
										Content = "Bound " .. name .. " to AI Generator Context!",
										Duration = 3,
									})
								else
									tbl7:Notify({ Title = "Already Bound", Content = "Instance is already in AI Context.", Duration = 2 })
								end
							end)

							fn12("📦 Deep Dump", tbl6.glassRaised, function()
								task.spawn(function()
									setPreviewData(dumpObject(v15), name)
									tbl7:Notify({ Title = "Object Dumped", Content = "Dumped " .. name .. " to Preview tab!", Duration = 3 })
								end)
							end)

							if not (n >= 50) then
								continue
							end
						else
							continue
						end

						break
					end
				end
			end

			if not (n >= 50) then
				continue
			end
			break
		end

		if n == 0 then
			local textLabel3 = Instance.new("TextLabel")
			textLabel3.Size = UDim2.new(1, 0, 0, 50)
			textLabel3.BackgroundTransparency = 1
			textLabel3.Text = string.format("-- No matching game instances found for query: '%s' (Category: %s) --", arg, str)
			textLabel3.TextColor3 = tbl6.textFaint
			textLabel3.Font = Enum.Font.GothamSemibold
			textLabel3.TextSize = 11
			textLabel3.Parent = scrollingFrame2
		end
	end

	v4:AddButton({
		Title = "🔎 SEARCH GAME INTELLIGENCE (LIVE HIERARCHY SCAN)",
		Style = "primary",
		Callback = function()
			fn11(textBox4.Text)
		end,
	})

	v4:AddButton({
		Title = "🚪 1-CLICK WARP TO NEAREST DUNGEON PORTAL / DOOR",
		Callback = function()
			local humanoidRootPart = Players.LocalPlayer and Players.LocalPlayer.Character and (Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or Players.LocalPlayer.Character:FindFirstChild("Torso"))
			if not humanoidRootPart then
				tbl7:Notify({ Title = "Error", Content = "HumanoidRootPart not found!", Duration = 2 })
				return
			end
			local huge = math.huge
			local v13 = nil

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant:IsA("BasePart") then
					local str2 = descendant.Name:lower()

					if (str2:find("portal") or str2:find("door") or str2:find("gate") or str2:find("dungeon")) and not descendant:IsDescendantOf(Players.LocalPlayer.Character) then
						local magnitude = (humanoidRootPart.Position - descendant.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v13 = descendant
						end
					end
				end
			end

			if v13 then
				humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				humanoidRootPart.CFrame = v13.CFrame + Vector3.new(0, 3, 0)

				tbl7:Notify({
					Title = "Portal Warp",
					Content = string.format("Warped to %s (%.1f studs away)", v13.Name, huge),
					Duration = 3,
				})
			else
				tbl7:Notify({ Title = "Notice", Content = "No dungeon portal found in Workspace!", Duration = 3 })
			end
		end,
	})

	v4:AddButton({
		Title = "👁️ CLEAR ALL ACTIVE 3D ESP HIGHLIGHTS",
		Callback = function()
			local n = 0

			for _, v13 in pairs(tbl8) do
				if v13 and v13.Parent then
					v13:Destroy()
					n += 1
				end
			end

			tbl8 = {}
			tbl7:Notify({ Title = "ESP Cleared", Content = "Removed " .. n .. " active 3D ESP highlights.", Duration = 2 })
		end,
	})
end

v4:AddButton({
	Title = "⚡ INITIALIZE / RELOAD SUBPORT EXTENSION ENGINE (GitHub Online)",
	Callback = function()
		task.spawn(function()
			local ok, result = pcall(function()
				return game:HttpGet("https://raw.githubusercontent.com/aslamdunk21/AIPayomboyG/refs/heads/main/PayomboyZKnowledge-main/Subport")
			end)

			local flag = ok and result and #result > 20
			local flag2 = false

			if flag then
				local chunk = loadstring(result)

				if chunk then
					chunk()
					flag2 = true
				end
			end

			if flag2 then
				tbl7:Notify({
					Title = "Subport Connected",
					Content = "PayomboyZ Subport Extension Engine loaded from GitHub!",
					Duration = 4,
				})
			else
				tbl7:Notify({ Title = "Notice", Content = "Failed to fetch Subport from GitHub.", Duration = 3 })
			end
		end)
	end,
})

v4:AddButton({
	Title = "🧹 CLEAR BOUND AI CONTEXT",
	Callback = function()
		tbl2:ClearContext()
		tbl7:Notify({ Title = "Context Cleared", Content = "Cleared all bound game contexts.", Duration = 2 })
	end,
})

local tbl8, text, scrollingFrame, textLabel, v13, fn8

do
	local payomboyZRemoteSpyEnabled = false
	tbl8 = {}
	text = "ping,heartbeat"
	local payomboyZOldNamecall = nil
	scrollingFrame = nil
	textLabel = nil
	local flag = false
	local tbl9 = {}
	local remote = nil
	local str = "FireServer"
	local tbl10 = {}
	local textLabel2 = nil
	local textBox4 = nil
	v13 = nil

	local function fn9(arg)
		local str2 = tostring(arg or ""):lower()

		for match in text:gmatch("[^,%s]+") do
			if match ~= "" and str2:find(match:lower(), 1, true) then
				return true
			end
		end

		return false
	end

	local function fn10(arg, arg2, arg3)
		local tbl11 = {}
		local n = arg3.n or #arg3

		for i = 1, n do
			tbl11[#tbl11 + 1] = tbl5.Serialize(arg3[i])
		end

		local concat = table.concat
		return string.format("%s:%s(%s)", arg:GetFullName(), arg2, concat(tbl11, ", "))
	end

	fn8 = function()
		if not scrollingFrame then
			return
		end
		scrollingFrame:ClearAllChildren()
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.Parent = scrollingFrame
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, 4)
		uiPadding.PaddingLeft = UDim.new(0, 4)
		uiPadding.PaddingRight = UDim.new(0, 4)
		uiPadding.PaddingBottom = UDim.new(0, 4)
		uiPadding.Parent = scrollingFrame

		if textLabel then
			textLabel.Text = string.format("📊 CAPTURED LOGS: %d Calls  •  Status: %s", #tbl8, payomboyZRemoteSpyEnabled and "🟢 LOGGING" or "🔴 PAUSED")
		end

		if #tbl8 == 0 then
			local textLabel3 = Instance.new("TextLabel")
			textLabel3.Size = UDim2.new(1, 0, 0, 60)
			textLabel3.BackgroundTransparency = 1
			textLabel3.Text = "-- No remote calls captured yet. Turn ON Remote Spy and trigger in-game actions --"
			textLabel3.TextColor3 = tbl6.textFaint
			textLabel3.Font = Enum.Font.GothamSemibold
			textLabel3.TextSize = 11
			textLabel3.Parent = scrollingFrame
			return
		end

		for i, v14 in ipairs(tbl8) do
			if not (i > 60) then
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, -6, 0, 68)
				frame.BackgroundColor3 = tbl6.surface
				frame.BackgroundTransparency = 0.2
				frame.BorderSizePixel = 0
				frame.LayoutOrder = i
				frame.Parent = scrollingFrame
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(0, 6)
				uiCorner.Parent = frame
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = tbl6.glassBorder
				uiStroke.Thickness = 1
				uiStroke.Parent = frame
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.Size = UDim2.new(1, -12, 0, 16)
				textLabel3.Position = UDim2.new(0, 8, 0, 4)
				textLabel3.BackgroundTransparency = 1
				textLabel3.Text = string.format("[%d] 📡 %s (%s)  •  %s  •  %s", i, v14.Name or "Remote", v14.Class or "RemoteEvent", v14.Method or "FireServer", v14.Time or "")
				textLabel3.TextColor3 = tbl6.cyan
				textLabel3.Font = Enum.Font.GothamBold
				textLabel3.TextSize = 10
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.Parent = frame
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.Size = UDim2.new(1, -12, 0, 18)
				textLabel4.Position = UDim2.new(0, 8, 0, 20)
				textLabel4.BackgroundTransparency = 1
				textLabel4.Text = v14.Source
				textLabel4.TextColor3 = Color3.fromRGB(150, 240, 200)
				textLabel4.Font = Enum.Font.Code
				textLabel4.TextSize = 10
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				textLabel4.Parent = frame
				local frame2 = Instance.new("Frame")
				frame2.Size = UDim2.new(1, -16, 0, 20)
				frame2.Position = UDim2.new(0, 8, 0, 42)
				frame2.BackgroundTransparency = 1
				frame2.Parent = frame
				local uiListLayout2 = Instance.new("UIListLayout")
				uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
				uiListLayout2.Padding = UDim.new(0, 4)
				uiListLayout2.Parent = frame2

				local function createTextButton(text2, backgroundColor3, arg)
					local textButton = Instance.new("TextButton")
					textButton.Size = UDim2.new(0, 84, 1, 0)
					textButton.BackgroundColor3 = backgroundColor3
					textButton.BackgroundTransparency = 0.2
					textButton.Text = text2
					textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					textButton.Font = Enum.Font.GothamBold
					textButton.TextSize = 9
					textButton.Parent = frame2
					local uiCorner2 = Instance.new("UICorner")
					uiCorner2.CornerRadius = UDim.new(0, 4)
					uiCorner2.Parent = textButton

					textButton.MouseButton1Click:Connect(function()
						fn5()

						if arg then
							arg()
						end
					end)

					return textButton
				end

				createTextButton("⚡ Replay", Color3.fromRGB(180, 100, 0), function()
					task.spawn(function()
						if v14.Remote and v14.Remote.Parent then
							if v14.Method == "FireServer" then
								v14.Remote:FireServer(unpack(v14.Args))
								tbl7:Notify({ Title = "⚡ Replayed", Content = "Fired " .. v14.Name, Duration = 2 })
							elseif v14.Method == "InvokeServer" then
								v14.Remote:InvokeServer(unpack(v14.Args))
								tbl7:Notify({ Title = "⚡ Replayed", Content = "Invoked " .. v14.Name, Duration = 2 })
							end
						else
							tbl7:Notify({ Title = "Error", Content = "Remote instance no longer exists!", Duration = 3 })
						end
					end)
				end)

				local v15 = createTextButton(tbl9[v14] and "⏹️ Stop Spam" or "🔁 Loop Spam", tbl9[v14] and Color3.fromRGB(220, 40, 60) or Color3.fromRGB(200, 120, 0), nil)

				v15.MouseButton1Click:Connect(function()
					if tbl9[v14] then
						tbl9[v14] = false
						v15.Text = "🔁 Loop Spam"
						v15.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
						tbl7:Notify({ Title = "Spam Stopped", Content = "Stopped spamming " .. v14.Name, Duration = 2 })
					else
						tbl9[v14] = true
						v15.Text = "⏹️ Stop Spam"
						v15.BackgroundColor3 = Color3.fromRGB(220, 40, 60)
						tbl7:Notify({ Title = "🔁 Spam Started", Content = "Spamming " .. v14.Name .. " (0.1s)", Duration = 3 })

						task.spawn(function()
							while tbl9[v14] and v14.Remote and v14.Remote.Parent do
								task.wait(0.1)

								pcall(function()
									if v14.Method == "FireServer" then
										v14.Remote:FireServer(unpack(v14.Args))
									else
										v14.Remote:InvokeServer(unpack(v14.Args))
									end
								end)
							end

							tbl9[v14] = false

							if v15 and v15.Parent then
								v15.Text = "🔁 Loop Spam"
								v15.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
							end
						end)
					end
				end)

				createTextButton("🎯 Edit Args", Color3.fromRGB(80, 120, 240), function()
					remote = v14.Remote
					str = v14.Method
					tbl10 = v14.Args
					local tbl11 = {}

					for _, arg in ipairs(v14.Args) do
						table.insert(tbl11, tbl5.Serialize(arg))
					end

					local text2 = table.concat(tbl11, ", ")

					if textBox4 then
						textBox4.Text = text2
					end

					if textLabel2 then
						textLabel2.Text = string.format("🎯 Target: %s (%s)  •  Method: %s", v14.Name, v14.Class, v14.Method)
					end

					tbl7:Notify({
						Title = "Loaded into Replayer",
						Content = "Remote and arguments set in controller above!",
						Duration = 3,
					})
				end)

				createTextButton("📋 Copy Code", tbl6.primary, function()
					if typeof(setclipboard) == "function" then
						setclipboard(v14.Source)
						tbl7:Notify({ Title = "Copied Code", Content = "Copied executable remote call!", Duration = 2 })
					end
				end)

				createTextButton("⚡ Auto-Farm", Color3.fromRGB(0, 160, 110), function()
					tbl2:AddContext(v14.Name, v14.Class, v14.Path, "RemoteSpy")
					fn7("ออโต้ฟาร์มด้วยรีโมท " .. v14.Name, { Name = v14.Name, Class = v14.Class, Path = v14.Path, Remote = v14.Remote })
				end)

				continue
			end

			break
		end
	end

	local str2 = ""
	local n = 0

	local function fn11(arg, arg2, arg3)
		if not payomboyZRemoteSpyEnabled or not getgenv()._PayomboyZ_RemoteSpyEnabled then
			return
		end

		if not arg or typeof(arg) ~= "Instance" then
			return
		end
		local name = arg.Name
		local fullName = arg:GetFullName()
		if fn9(name) or fn9(fullName) then
			return
		end
		local n2 = arg3.n or #arg3
		local tbl11 = {n = n2}

		for i = 1, n2 do
			tbl11[i] = arg3[i]
		end

		local str3 = fullName .. ":" .. tostring(arg2) .. "(" .. tostring(tbl11[1]) .. ")"
		local now = os.clock()
		if str3 == str2 and now - n < 0.015 then
			return
		end
		str2 = str3
		n = now

		table.insert(tbl8, 1, {
			Remote = arg,
			Name = name,
			Class = arg.ClassName,
			Path = fullName,
			Method = arg2,
			Args = tbl11,
			Time = os.date("%H:%M:%S"),
			Source = fn10(arg, arg2, tbl11),
		})

		while #tbl8 > 2000 do
			table.remove(tbl8)
		end

		task.defer(fn8)
	end

	local function fn12()
		getgenv()._PayomboyZ_RemoteSpyEnabled = true
		if flag then
			return
		end
		flag = true

		if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" then
			if not getgenv()._PayomboyZ_OldNamecall then
				getgenv()._PayomboyZ_OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(arg, ...)
					local v14 = table.pack(...)
					local v15 = getnamecallmethod()
					local payomboyZRemoteSpyEnabled2 = getgenv()._PayomboyZ_RemoteSpyEnabled

					if payomboyZRemoteSpyEnabled2 then
						payomboyZRemoteSpyEnabled2 = v15 == "FireServer" or v15 == "fireServer" or v15 == "InvokeServer" or v15 == "invokeServer"
					end

					if payomboyZRemoteSpyEnabled2 then
						local ok, result = pcall(function()
							local flag2 = typeof(arg) == "Instance"

							if flag2 then
								flag2 = arg:IsA("RemoteEvent") or arg:IsA("RemoteFunction") or arg:IsA("UnreliableRemoteEvent")
							end

							return flag2
						end)

						if ok and result then
							fn11(arg, v15, table.pack(...))
							return getgenv()._PayomboyZ_OldNamecall(arg, table.unpack(v14, 1, v14.n))
						end
					end

					return getgenv()._PayomboyZ_OldNamecall(arg, ...)
				end))

				payomboyZOldNamecall = getgenv()._PayomboyZ_OldNamecall
			end
		end

		if type(hookfunction) == "function" then
			pcall(function()
				local remoteEvent = Instance.new("RemoteEvent")
				local remoteFunction = Instance.new("RemoteFunction")

				if not getgenv()._PayomboyZ_OldFireServer then
					getgenv()._PayomboyZ_OldFireServer = hookfunction(remoteEvent.FireServer, newcclosure(function(arg, ...)
						local v14 = table.pack(...)
						if getgenv()._PayomboyZ_RemoteSpyEnabled and typeof(arg) == "Instance" then
							fn11(arg, "FireServer", table.pack(...))
							return getgenv()._PayomboyZ_OldFireServer(arg, table.unpack(v14, 1, v14.n))
						end
						return getgenv()._PayomboyZ_OldFireServer(arg, ...)
					end))
				end

				if not getgenv()._PayomboyZ_OldInvokeServer then
					getgenv()._PayomboyZ_OldInvokeServer = hookfunction(remoteFunction.InvokeServer, newcclosure(function(arg, ...)
						local v14 = table.pack(...)
						if getgenv()._PayomboyZ_RemoteSpyEnabled and typeof(arg) == "Instance" then
							fn11(arg, "InvokeServer", table.pack(...))
							return getgenv()._PayomboyZ_OldInvokeServer(arg, table.unpack(v14, 1, v14.n))
						end
						return getgenv()._PayomboyZ_OldInvokeServer(arg, ...)
					end))
				end

				remoteEvent:Destroy()
				remoteFunction:Destroy()
			end)
		end
	end

	v5:AddSection("REMOTE SPY MONITORING & HOOKING")

	local v14 = v5:AddButton({
		Title = "🔴 [OFF] Remote Spy Status (Click to Enable)",
		Style = "primary",
		Callback = function()
		end,
	})

	v14.MouseButton1Click:Connect(function()
		fn5()
		payomboyZRemoteSpyEnabled = not payomboyZRemoteSpyEnabled
		getgenv()._PayomboyZ_RemoteSpyEnabled = payomboyZRemoteSpyEnabled

		if payomboyZRemoteSpyEnabled then
			fn12()
			v14.Text = "🟢 [ON] Remote Spy Logging Active"
			fn8()

			tbl7:Notify({
				Title = "Remote Spy",
				Content = "Logging active! FireServer/InvokeServer monitored.",
				Duration = 4,
			})
		else
			v14.Text = "🔴 [OFF] Remote Spy Status (Click to Enable)"
			fn8()
			tbl7:Notify({ Title = "Remote Spy", Content = "Logging paused.", Duration = 3 })
		end
	end)

	v5:AddSection("🎯 ARGUMENT AUTO-REPLAYER & SPAM CONTROLLER")
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 118)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v5.page
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.cyan
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -20, 0, 20)
	textLabel2.Position = UDim2.new(0, 10, 0, 8)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = "🎯 Selected Target: None (Click '🎯 Edit Args' on any captured log below)"
	textLabel2.TextColor3 = tbl6.cyan
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextSize = 11
	textLabel2.TextXAlignment = Enum.TextXAlignment.Left
	textLabel2.Parent = frame
	textBox4 = Instance.new("TextBox")
	textBox4.Size = UDim2.new(1, -20, 0, 30)
	textBox4.Position = UDim2.new(0, 10, 0, 34)
	textBox4.BackgroundColor3 = tbl6.input
	textBox4.BackgroundTransparency = 0.2
	textBox4.PlaceholderText = "-- Argument expressions (e.g. 1, \"Common\", Vector3.new(0, 10, 0))"
	textBox4.Text = ""
	textBox4.Font = Enum.Font.Code
	textBox4.TextSize = 11
	textBox4.TextColor3 = Color3.fromRGB(255, 230, 150)
	textBox4.ClearTextOnFocus = false
	textBox4.TextXAlignment = Enum.TextXAlignment.Left
	textBox4.Parent = frame
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 6)
	uiCorner2.Parent = textBox4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 8)
	uiPadding.Parent = textBox4
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(1, -20, 0, 32)
	frame2.Position = UDim2.new(0, 10, 0, 72)
	frame2.BackgroundTransparency = 1
	frame2.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Padding = UDim.new(0, 8)
	uiListLayout.Parent = frame2

	local function createTextButton(text2, backgroundColor3, arg)
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0, 140, 1, 0)
		textButton.BackgroundColor3 = backgroundColor3
		textButton.Text = text2
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 10
		textButton.Parent = frame2
		local uiCorner3 = Instance.new("UICorner")
		uiCorner3.CornerRadius = UDim.new(0, 6)
		uiCorner3.Parent = textButton

		textButton.MouseButton1Click:Connect(function()
			fn5()

			if arg then
				arg()
			end
		end)

		return textButton
	end

	createTextButton("⚡ Fire Once (1x)", tbl6.primary, function()
		if not remote then
			tbl7:Notify({ Title = "Warning", Content = "Please select a remote from logs below first!", Duration = 3 })
			return
		end
		local text2 = textBox4.Text

		local ok, result = pcall(function()
			if text2 == "" then
				return {}
			end
			return loadstring("return {" .. text2 .. "}")()
		end)

		if not ok or type(result) ~= "table" then
			local v15 = tbl10

			if tbl10 then
				result = v15
			else
				result = {}
			end
		end

		pcall(function()
			if str == "FireServer" then
				remote:FireServer(unpack(result))
			else
				remote:InvokeServer(unpack(result))
			end
		end)

		tbl7:Notify({
			Title = "Fired Remote",
			Content = "Fired " .. remote.Name .. " with custom arguments!",
			Duration = 2,
		})
	end)

	local flag2 = false
	local v15 = createTextButton("🔁 Start Loop Spam", Color3.fromRGB(200, 120, 0), nil)

	v15.MouseButton1Click:Connect(function()
		if not remote then
			tbl7:Notify({ Title = "Warning", Content = "Please select a remote from logs below first!", Duration = 3 })
			return
		end
		flag2 = not flag2

		if flag2 then
			v15.Text = "⏹️ Stop Loop Spam"
			v15.BackgroundColor3 = Color3.fromRGB(220, 40, 60)

			task.spawn(function()
				while flag2 and remote and remote.Parent do
					task.wait(0.1)
					local text2 = textBox4.Text

					local ok, result = pcall(function()
						if text2 == "" then
							return {}
						end
						return loadstring("return {" .. text2 .. "}")()
					end)

					if not ok or type(result) ~= "table" then
						local v16 = tbl10

						if tbl10 then
							result = v16
						else
							result = {}
						end
					end

					pcall(function()
						if str == "FireServer" then
							remote:FireServer(unpack(result))
						else
							remote:InvokeServer(unpack(result))
						end
					end)
				end

				flag2 = false

				if v15 and v15.Parent then
					v15.Text = "🔁 Start Loop Spam"
					v15.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
				end
			end)
		else
			v15.Text = "🔁 Start Loop Spam"
			v15.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
		end
	end)

	createTextButton("🛑 Stop All Spams", Color3.fromRGB(150, 40, 40), function()
		table.clear(tbl9)
		flag2 = false
		v15.Text = "🔁 Start Loop Spam"
		v15.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
		fn8()
		tbl7:Notify({ Title = "All Spams Stopped", Content = "Cancelled all background spam loops.", Duration = 2 })
	end)
end

v5:AddSection("BLACKLIST FILTER KEYWORDS")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 60)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v5.page
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -24, 0, 18)
	textLabel2.Position = UDim2.new(0, 12, 0, 6)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = "SKIP REMOTES CONTAINING (COMMA SEPARATED)"
	textLabel2.TextColor3 = tbl6.textMuted
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextSize = 10
	textLabel2.TextXAlignment = Enum.TextXAlignment.Left
	textLabel2.Parent = frame
	local textBox4 = Instance.new("TextBox")
	textBox4.Size = UDim2.new(1, -24, 0, 26)
	textBox4.Position = UDim2.new(0, 12, 0, 26)
	textBox4.BackgroundColor3 = tbl6.input
	textBox4.BackgroundTransparency = 0.2
	textBox4.Text = text
	textBox4.Font = Enum.Font.GothamSemibold
	textBox4.TextSize = 11
	textBox4.TextColor3 = tbl6.cyan
	textBox4.ClearTextOnFocus = false
	textBox4.TextXAlignment = Enum.TextXAlignment.Left
	textBox4.Parent = frame

	textBox4.FocusLost:Connect(function()
		text = textBox4.Text
		fn8()
		tbl7:Notify({ Title = "Filter Updated", Content = "Remote Spy blacklist keywords updated.", Duration = 2 })
	end)

	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 6)
	uiCorner2.Parent = textBox4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 8)
	uiPadding.Parent = textBox4
end

v5:AddSection("CAPTURED REMOTE CALL LOGS")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 28)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v5.page
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 6)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -20, 1, 0)
	textLabel.Position = UDim2.new(0, 10, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "📊 CAPTURED LOGS: 0 Calls  •  Status: 🔴 PAUSED"
	textLabel.TextColor3 = tbl6.cyan
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 10
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = frame
end

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 240)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v5.page
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame.BackgroundColor3 = tbl6.input
	scrollingFrame.BackgroundTransparency = 0.3
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 6
	scrollingFrame.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.Parent = frame
end

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = scrollingFrame
fn8()
v5:AddSection("REMOTE LOG CONTROLS & EXPORT")

v5:AddButton({
	Title = "📋 Copy All Remote Logs to Clipboard",
	Style = "primary",
	Callback = function()
		if #tbl8 == 0 then
			tbl7:Notify({ Title = "Warning", Content = "Log buffer is empty!", Duration = 2 })
			return
		end
		local tbl9 = {}

		for _, v14 in ipairs(tbl8) do
			tbl9[#tbl9 + 1] = v14.Source
		end

		local str = table.concat(tbl9, "\n")

		if typeof(setclipboard) == "function" then
			pcall(function()
				setclipboard(str)
			end)

			tbl7:Notify({
				Title = "Copied",
				Content = "Copied " .. #tbl8 .. " logged remote calls to clipboard!",
				Duration = 3,
			})
		end
	end,
})

v5:AddButton({
	Title = "🧠 Bind Captured Remotes to AI Context",
	Callback = function()
		if #tbl8 == 0 then
			tbl7:Notify({ Title = "Warning", Content = "No remotes captured yet!", Duration = 3 })
			return
		end
		local tbl9 = {}
		local n = 0

		for _, v14 in ipairs(tbl8) do
			if v14.Path and not tbl9[v14.Path] then
				tbl9[v14.Path] = true

				if tbl2:AddContext(v14.Name or "Remote", v14.Class or "RemoteEvent", v14.Path, "RemoteSpy") then
					n += 1
				end
			end
		end

		tbl7:Notify({
			Title = "Remotes Bound",
			Content = "Bound " .. n .. " captured remotes to AI Context!",
			Duration = 4,
		})
	end,
})

v5:AddButton({
	Title = "💾 Save Remote Logs to File",
	Callback = function()
		if #tbl8 == 0 then
			tbl7:Notify({ Title = "Warning", Content = "No remote calls captured yet!", Duration = 3 })
			return
		end

		if typeof(makefolder) == "function" then
			pcall(function()
				makefolder("PAYOMBOYDumps")
			end)

			pcall(function()
				makefolder("PAYOMBOYDumps/RemoteSpy")
			end)
		end

		local str = "PAYOMBOYDumps/RemoteSpy" .. "/RemoteSpy_" .. os.date("%Y%m%d_%H%M%S") .. ".lua"
		local tbl9 = {}
		local str2 = "-- Game PlaceId: " .. tostring(game.PlaceId)
		local str3 = "-- Time: " .. os.date("%Y-%m-%d %H:%M:%S")
		local str4 = "-- Captured Calls Count: " .. tostring(#tbl8)
		tbl9[1] = "-- [[ PayomboyZ Remote Spy Export Log ]]"
		tbl9[2] = str2
		tbl9[3] = str3
		tbl9[4] = str4
		tbl9[5] = ""

		for _, v14 in ipairs(tbl8) do
			tbl9[#tbl9 + 1] = v14.Source
		end

		fn6(str, table.concat(tbl9, "\n"), "RemoteSpy Log")
	end,
})

v5:AddButton({
	Title = "🗑️ Clear Remote Log Buffer",
	Callback = function()
		tbl8 = {}
		fn8()
		tbl7:Notify({ Title = "Cleared", Content = "Remote Spy log buffer cleared.", Duration = 2 })
	end,
})


do
	local factory = (function()
-- Read-only remote inventory and captured-call exporter. Never invokes remotes.
return function(env)
    local api = {}
    local game = env.game
    local encode = env.encode
    local kindOf = env.typeof or typeof
    local date = env.date or os.date
    local serial = 0

    local function describe(value, seen, depth)
        local kind = kindOf(value)
        if kind == "nil" then return {type = "nil"} end
        if kind == "boolean" or kind == "string" then return {type = kind, value = value} end
        if kind == "number" then
            return {type = kind, value = (value == value and math.abs(value) < math.huge) and value or tostring(value)}
        end
        if kind == "Instance" then
            local ok, path = pcall(function() return value:GetFullName() end)
            return {type = kind, path = ok and path or "<unavailable>", class = value.ClassName}
        end
        if kind == "table" then
            if seen[value] then return {type = "table", cycle = true} end
            if depth >= 8 then return {type = "table", truncated = "depth limit"} end
            seen[value] = true
            local entries = {}
            local result = {type = "table", entries = entries}
            for key, item in pairs(value) do
                if #entries >= 200 then result.truncated = "entry limit"; break end
                entries[#entries + 1] = {key = describe(key, seen, depth + 1), value = describe(item, seen, depth + 1)}
            end
            seen[value] = nil
            return result
        end
        return {type = kind, value = tostring(value)}
    end

    function api.Calls()
        local source = env.getCalls()
        local calls = {}
        -- The recorder keeps newest first; export chronological order.
        for i = #source, 1, -1 do
            local call = source[i]
            local args = call.Args or {}
            local count = args.n or #args
            local values = {}
            for index = 1, count do values[index] = describe(args[index], {}, 0) end
            calls[#calls + 1] = {
                index = #calls + 1, name = call.Name, class = call.Class,
                path = call.Path, method = call.Method, time = call.Time,
                argumentCount = count, arguments = values, source = call.Source,
            }
        end
        return calls
    end

    function api.Inventory()
        local found = {}
        local ok, descendants = pcall(function() return game:GetDescendants() end)
        if not ok then return nil, tostring(descendants) end
        for index, item in ipairs(descendants) do
            local success, record = pcall(function()
                if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") or item:IsA("UnreliableRemoteEvent") then
                    return {name = item.Name, class = item.ClassName, path = item:GetFullName()}
                end
                return nil
            end)
            if success and record then found[#found + 1] = record end
            if env.yield and index % 250 == 0 then env.yield() end
        end
        table.sort(found, function(a, b) return a.path < b.path end)
        return found
    end

    function api.Export()
        if type(env.writefile) ~= "function" then
            return false, "ตัวรันไม่รองรับ writefile จึงยังไม่ได้สร้างไฟล์ / writefile unavailable"
        end
        local inventory, errorText = api.Inventory()
        if not inventory then return false, "อ่านรายการ Remote ไม่สำเร็จ: " .. errorText end
        local calls = api.Calls()
        serial += 1
        local stem = date("%Y%m%d_%H%M%S") .. "_" .. tostring(serial)
        local directory = "DevilHub_Dumps/Place_" .. tostring(game.PlaceId)
        local metadata = {
            schema = "devil-ai-remotes-1", placeId = game.PlaceId, universeId = game.GameId,
            exportedAt = date("%Y-%m-%d %H:%M:%S"), retainedCallCount = #calls,
            callBufferLimit = 2000, inventoryCount = #inventory,
            note = "Client-visible remote inventory; captured calls only. No server source or acceptance verification.",
        }
        local payloads = {}
        local ok, result = pcall(function()
            payloads[1] = {name = "Remotes_" .. stem .. ".json", content = encode({metadata = metadata, remotes = inventory})}
            payloads[2] = {name = "RemoteCalls_" .. stem .. ".json", content = encode({metadata = metadata, calls = calls})}
            local text = {"DEVIL HUB REMOTE EXPORT", "Place: " .. tostring(game.PlaceId), "Universe: " .. tostring(game.GameId),
                "Visible remotes: " .. #inventory, "Captured calls retained: " .. #calls .. " / 2000", "", "REMOTE INVENTORY"}
            for _, remote in ipairs(inventory) do text[#text + 1] = remote.class .. " | " .. remote.path end
            text[#text + 1] = "\nCAPTURED CALLS (oldest first; text for inspection only)"
            for _, call in ipairs(calls) do
                text[#text + 1] = string.format("[%d] %s | %s | %s | %d args\n%s", call.index, call.time or "", call.path or "", call.method or "", call.argumentCount, call.source or "")
            end
            payloads[3] = {name = "RemoteSummary_" .. stem .. ".txt", content = table.concat(text, "\n")}
        end)
        if not ok then return false, "แปลงข้อมูลไม่สำเร็จ: " .. tostring(result) end

        if type(env.makefolder) == "function" then
            for _, folder in ipairs({"DevilHub_Dumps", directory}) do
                local exists = false
                if type(env.isfolder) == "function" then
                    local checked, present = pcall(env.isfolder, folder)
                    exists = checked and present
                end
                if not exists then pcall(env.makefolder, folder) end
            end
        end
        local written, failures = {}, {}
        for _, payload in ipairs(payloads) do
            local path = directory .. "/" .. payload.name
            local saved, reason = pcall(env.writefile, path, payload.content)
            if not saved then
                -- Some executors support writes only at workspace root.
                path = "DevilHub_Place_" .. tostring(game.PlaceId) .. "_" .. payload.name
                saved, reason = pcall(env.writefile, path, payload.content)
            end
            if saved and type(env.readfile) == "function" then
                local readOk, contents = pcall(env.readfile, path)
                saved = readOk and contents == payload.content
                if not saved then reason = "readback did not match" end
            end
            if saved then written[#written + 1] = path else failures[#failures + 1] = payload.name .. ": " .. tostring(reason) end
        end
        local message = "บันทึก " .. #written .. "/3 ไฟล์ • " .. #inventory .. " Remotes • " .. #calls .. " Calls\n" .. table.concat(written, "\n")
        if #calls == 0 then message ..= "\nยังไม่มี Calls: เปิด Remote Spy แล้วกดปุ่มในเกม จากนั้นบันทึกอีกครั้ง" end
        if #failures > 0 then message ..= "\nเขียนไม่สำเร็จ: " .. table.concat(failures, "\n") end
        return #written == 3, message, {paths = written, failures = failures, inventoryCount = #inventory, callCount = #calls}
    end
    return api
end

	end)()
	local exporter = factory({
		game = game,
		getCalls = function() return tbl8 end,
		encode = function(value) return game:GetService("HttpService"):JSONEncode(value) end,
		writefile = writefile, readfile = readfile, makefolder = makefolder, isfolder = isfolder,
		yield = function() task.wait() end,
	})
	local busy = false
	local function saveAll()
		if busy then return end
		busy = true
		task.spawn(function()
			local executed, saved, message = pcall(exporter.Export)
			busy = false
			if not executed then message = tostring(saved); saved = false end
			tbl7:Notify({Title = saved and "DEVIL HUB • Files Saved" or "DEVIL HUB • Export Status", Content = message, Duration = 12})
			fn2(saved and "INFO" or "WARN", "REMOTE_EXPORT", message)
		end)
	end
	for _, page in ipairs({v5, v4, v7}) do
		local button = page:AddButton({Title = "บันทึก Remote ทั้งหมด + Calls ลงไฟล์ / Save All Remotes", Style = "primary", Callback = saveAll})
		button.LayoutOrder = -100
	end
end

local str
str = ""
local tbl9
tbl9 = {}
local str2
str2 = ""
local tbl10
tbl10 = {}
local n, scrollingFrame2, textLabel2, textBox4, fn9, fn10

do
	local flag = false
	local flag2 = false
	n = 1
	local str3 = ""
	scrollingFrame2 = nil
	local scrollingFrame3 = nil
	local textLabel3 = nil
	local textBox5 = nil
	textLabel2 = nil
	textBox4 = nil
	local v14 = nil

	local function fn11(arg)
		local str4 = tostring(arg or "")

		if #str4 > 4000 then
			str4 = str4:sub(1, 4000) .. "\n…(truncated)"
		end

		local tbl11 = {}
		local n2 = 0

		for i = 1, #str4 do
			local str5 = str4:sub(i, i)

			if str5 == "{" or str5 == "[" then
				n2 += 1
				tbl11[#tbl11 + 1] = str5 .. "\n" .. string.rep("  ", n2)
			elseif str5 == "}" or str5 == "]" then
				n2 = math.max(0, n2 - 1)
				tbl11[#tbl11 + 1] = "\n" .. string.rep("  ", n2) .. str5
			elseif str5 == "," then
				tbl11[#tbl11 + 1] = str5 .. "\n" .. string.rep("  ", n2)
			else
				tbl11[#tbl11 + 1] = str5
			end
		end

		return table.concat(tbl11)
	end

	local function fn12(arg)
		if not arg or typeof(arg) ~= "string" then
			return ""
		end

		return (arg:gsub("\\(%d%d%d)", function(arg2)
			local num = tonumber(arg2)
			if num and num >= 32 and num <= 126 then
				return string.char(num)
			end
			return "\\" .. arg2
		end):gsub("\\x(%x%x)", function(arg2)
			local num = tonumber(arg2, 16)
			if num and num >= 32 and num <= 126 then
				return string.char(num)
			end
			return "\\x" .. arg2
		end))
	end

	fn9 = function(arg)
		local tbl11 = {}
		local tbl12 = {}

		for match in arg:gmatch("https?://[^%s\"'%)%]]+") do
			if not tbl12[match] then
				tbl12[match] = true
				table.insert(tbl11, match)
			end
		end

		for match in fn12(arg):gmatch("https?://[^%s\"'%)%]]+") do
			if not tbl12[match] then
				tbl12[match] = true
				table.insert(tbl11, match)
			end
		end

		return tbl11
	end

	fn10 = function(arg)
		if not arg or arg == "" then
			return nil, nil, "กรุณากรอก URL หรือ Loadstring ที่ถูกต้อง"
		end
		local match = arg:match("https?://[^%s\"'%)]+")

		if match then
			local ok, result = pcall(function()
				return game:HttpGet(match)
			end)

			if ok and typeof(result) == "string" and #result > 0 then
				return result, match, nil
			end
			return nil, match, "game:HttpGet ล้มเหลว: " .. tostring(result)
		end

		local str4 = arg:gsub("loadstring%s*%(", ""):gsub("%)%s*$", ""):gsub("^%s*", ""):gsub("%s*$", "")

		if str4:match("^[\"'].-[\"']$") then
			str4 = str4:sub(2, -2)
		end

		local match2 = str4:match("https?://[^%s\"'%)]+")

		if match2 then
			local ok, result = pcall(function()
				return game:HttpGet(match2)
			end)

			if ok and typeof(result) == "string" and #result > 0 then
				return result, match2, nil
			end
			return nil, match2, "ไม่สามารถดึง URL จาก loadstring: " .. tostring(result)
		end

		return str4, "RAW_CODE", nil
	end

	local function fn13(arg)
		local str4 = (arg or ""):upper()
		if str4 == "GET" then
			return Color3.fromRGB(0, 210, 120)
		end

		if str4 == "POST" then
			return Color3.fromRGB(255, 150, 40)
		end

		if str4 == "PUT" then
			return Color3.fromRGB(50, 160, 255)
		end

		if str4 == "DELETE" then
			return Color3.fromRGB(255, 60, 70)
		end

		if str4 == "PATCH" then
			return Color3.fromRGB(190, 100, 255)
		end
		return Color3.fromRGB(150, 150, 160)
	end

	local function fn14(arg)
		if not arg or arg == 0 then
			return Color3.fromRGB(255, 65, 80)
		end

		if arg >= 200 and arg < 300 then
			return Color3.fromRGB(0, 220, 120)
		end

		if arg >= 300 and arg < 400 then
			return Color3.fromRGB(240, 200, 50)
		end
		return Color3.fromRGB(255, 65, 80)
	end

	local function fn15(arg)
		if not arg then
			return
		end

		if textBox5 then
			textBox5.Text = arg.Url or ""
		end

		if textLabel2 then
			textLabel2.Text = string.format("Method: %s  •  Status: %s  •  Latency: %s  •  Time: %s  •  Caller: %s", tostring(arg.Method), tostring(arg.StatusCode or 200), tostring(arg.Latency or "-"), tostring(arg.Time), tostring(arg.Caller or "-"))
		end

		if v14 then
			local tbl11 = {}

			if arg.Headers and type(arg.Headers) == "table" then
				for k, header in pairs(arg.Headers) do
					local v15 = tostring
					table.insert(tbl11, string.format("%s: %s", tostring(k), v15(header)))
				end
			end

			if #tbl11 == 0 then
				v14.Text = "-- No custom headers captured --"
			else
				v14.Text = table.concat(tbl11, "\n")
			end
		end

		if textBox4 then
			local responseBody = arg.ResponseBody or arg.Body or ""

			if responseBody == "" then
				textBox4.Text = "-- Empty Body / No Content --"
			else
				textBox4.Text = fn11(responseBody)
			end
		end
	end

	local fn16 = nil

	fn16 = function()
		if not scrollingFrame3 then
			return
		end
		scrollingFrame3:ClearAllChildren()
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 4)
		uiListLayout.Parent = scrollingFrame3
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, 4)
		uiPadding.PaddingLeft = UDim.new(0, 4)
		uiPadding.PaddingRight = UDim.new(0, 4)
		uiPadding.PaddingBottom = UDim.new(0, 4)
		uiPadding.Parent = scrollingFrame3

		if textLabel3 then
			textLabel3.Text = string.format("📡 LIVE HTTP CALLS: %d Packets  •  Status: %s", #tbl10, flag and "🟢 MONITORING" or "🔴 PAUSED")
		end

		local tbl11 = {}

		for i, v15 in ipairs(tbl10) do
			if str3 == "" or v15.Url:lower():find(str3:lower(), 1, true) or v15.Method:lower():find(str3:lower(), 1, true) then
				table.insert(tbl11, { idx = i, data = v15 })
			end
		end

		if #tbl11 == 0 then
			local textLabel4 = Instance.new("TextLabel")
			textLabel4.Size = UDim2.new(1, 0, 0, 45)
			textLabel4.BackgroundTransparency = 1
			textLabel4.Text = str3 ~= "" and "-- ไม่พบ Packet ที่ตรงกับคำค้นหา --" or "-- เปิด HTTP Sniffer เพื่อดักจับการเรียก Request / HttpGet ทั้งหมดในเกม --"
			textLabel4.TextColor3 = tbl6.textFaint
			textLabel4.Font = Enum.Font.GothamSemibold
			textLabel4.TextSize = 11
			textLabel4.Parent = scrollingFrame3
			return
		end

		for _, v15 in ipairs(tbl11) do
			if not (v15.idx > 100) then
				local data = v15.data
				local textButton = Instance.new("TextButton")
				textButton.Size = UDim2.new(1, -6, 0, 36)
				textButton.BackgroundColor3 = n == v15.idx and Color3.fromRGB(16, 48, 28) or tbl6.surface
				textButton.BackgroundTransparency = 0.2
				textButton.Text = ""
				textButton.LayoutOrder = v15.idx
				textButton.Parent = scrollingFrame3
				local uiCorner2 = Instance.new("UICorner")
				uiCorner2.CornerRadius = UDim.new(0, 6)
				uiCorner2.Parent = textButton
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = n == v15.idx and tbl6.primary or tbl6.surfaceRaised
				uiStroke.Thickness = 1
				uiStroke.Parent = textButton
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.Size = UDim2.new(0, 52, 0, 20)
				textLabel4.Position = UDim2.new(0, 6, 0.5, -10)
				textLabel4.BackgroundColor3 = fn13(data.Method)
				textLabel4.Text = data.Method
				textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel4.Font = Enum.Font.GothamBold
				textLabel4.TextSize = 9
				textLabel4.Parent = textButton
				local uiCorner3 = Instance.new("UICorner")
				uiCorner3.CornerRadius = UDim.new(0, 4)
				uiCorner3.Parent = textLabel4
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.Size = UDim2.new(0, 42, 0, 20)
				textLabel5.Position = UDim2.new(0, 62, 0.5, -10)
				textLabel5.BackgroundColor3 = fn14(data.StatusCode)
				textLabel5.Text = tostring(data.StatusCode or 200)
				textLabel5.TextColor3 = Color3.fromRGB(15, 25, 18)
				textLabel5.Font = Enum.Font.GothamBold
				textLabel5.TextSize = 9
				textLabel5.Parent = textButton
				local uiCorner4 = Instance.new("UICorner")
				uiCorner4.CornerRadius = UDim.new(0, 4)
				uiCorner4.Parent = textLabel5
				local textLabel6 = Instance.new("TextLabel")
				textLabel6.Size = UDim2.new(1, -195, 1, 0)
				textLabel6.Position = UDim2.new(0, 110, 0, 0)
				textLabel6.BackgroundTransparency = 1
				textLabel6.Text = string.format("[%s] %s", data.Time, data.Url)
				textLabel6.TextColor3 = tbl6.text
				textLabel6.Font = Enum.Font.Code
				textLabel6.TextSize = 10
				textLabel6.TextXAlignment = Enum.TextXAlignment.Left
				textLabel6.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel6.Parent = textButton
				local textButton2 = Instance.new("TextButton")
				textButton2.Size = UDim2.new(0, 55, 0, 22)
				textButton2.Position = UDim2.new(1, -62, 0.5, -11)
				textButton2.BackgroundColor3 = tbl6.surfaceRaised
				textButton2.Text = "📋 Copy"
				textButton2.TextColor3 = tbl6.cyan
				textButton2.Font = Enum.Font.GothamBold
				textButton2.TextSize = 9
				textButton2.Parent = textButton
				local uiCorner5 = Instance.new("UICorner")
				uiCorner5.CornerRadius = UDim.new(0, 4)
				uiCorner5.Parent = textButton2

				textButton2.MouseButton1Click:Connect(function()
					fn5()

					if typeof(setclipboard) == "function" then
						setclipboard(data.Url)
						tbl7:Notify({ Title = "Copied URL", Content = data.Url, Duration = 2 })
					end
				end)

				textButton.MouseButton1Click:Connect(function()
					fn5()
					n = v15.idx
					fn16()
					fn15(data)
				end)

				continue
			end

			break
		end
	end

	local function fn17()
		if flag2 then
			return
		end

		if typeof(hookfunction) ~= "function" then
			tbl7:Notify({
				Title = "Hooking Unavailable",
				Content = "Executor lacks hookfunction capability.",
				Duration = 3,
			})

			return
		end

		flag2 = true

		pcall(function()
			local v15 = nil

			local function fn18(arg, arg2, ...)
				local now = tick()
				local v16 = v15
				local v17 = table.pack(...)
				v17.n = 3 + v17.n - 1
				table.move(v17, 1, v17.n, 3, v17)
				v17[1] = arg
				v17[2] = arg2
				local v18 = v16(table.unpack(v17, 1, v17.n))

				if flag and typeof(arg2) == "string" then
					local n2 = math.floor((tick() - now) * 1000)

					table.insert(tbl10, 1, {
						Time = os.date("%H:%M:%S"),
						Method = "GET",
						Url = arg2,
						Headers = {},
						Body = "",
						ResponseBody = tostring(v18 or ""),
						StatusCode = 200,
						Latency = n2 .. "ms",
						Caller = "game:HttpGet",
					})

					if #tbl10 > 150 then
						table.remove(tbl10)
					end

					task.spawn(fn16)
				end

				return v18
			end

			v15 = hookfunction
			v15 = v15(game.HttpGet, newcclosure(fn18))
		end)

		local request_ = typeof(request) == "function" and request or typeof(http_request) == "function" and http_request or syn and typeof(syn.request) == "function" and syn.request or fluxus and typeof(fluxus.request) == "function" and fluxus.request

		if request_ then
			pcall(function()
				local v15 = nil

				local function fn18(arg, ...)
					local now = tick()
					local v16 = v15
					local v17 = table.pack(...)
					v17.n = 2 + v17.n - 1
					table.move(v17, 1, v17.n, 2, v17)
					v17[1] = arg
					local v18 = v16(table.unpack(v17, 1, v17.n))

					if flag and typeof(arg) == "table" and arg.Url then
						local n2 = math.floor((tick() - now) * 1000)
						local statusCode = typeof(v18) == "table" and v18.StatusCode or 200
						local body = typeof(v18) == "table" and v18.Body or ""
						local headers = typeof(v18) == "table" and v18.Headers or {}

						table.insert(tbl10, 1, {
							Time = os.date("%H:%M:%S"),
							Method = tostring(arg.Method or "GET"):upper(),
							Url = tostring(arg.Url),
							Headers = arg.Headers or {},
							Body = arg.Body and tostring(arg.Body) or "",
							ResponseHeaders = headers,
							ResponseBody = tostring(body),
							StatusCode = statusCode,
							Latency = n2 .. "ms",
							Caller = "request()",
						})

						if #tbl10 > 150 then
							table.remove(tbl10)
						end

						task.spawn(fn16)
					end

					return v18
				end

				v15 = hookfunction
				v15 = v15(request_, newcclosure(fn18))
			end)
		end
	end

	v6:AddSection("🌐 LIVE HTTP TRAFFIC INSPECTOR (SEMPSHARK ENGINE)")

	local v15 = v6:AddButton({
		Title = "🔴 [OFF] HTTP Traffic Sniffer (คลิกเพื่อเริ่มดักจับสด)",
		Style = "primary",
		Callback = function()
		end,
	})

	v15.MouseButton1Click:Connect(function()
		fn5()
		flag = not flag

		if flag then
			fn17()
			v15.Text = "🟢 [ON] HTTP Traffic Sniffer กำลังดักจับ..."
			fn16()

			tbl7:Notify({
				Title = "HTTP Sniffer Active",
				Content = "กำลังดักจับทุกการเรียก HttpGet / Request สด!",
				Duration = 4,
			})
		else
			v15.Text = "🔴 [OFF] HTTP Traffic Sniffer (คลิกเพื่อเริ่มดักจับสด)"
			fn16()
			tbl7:Notify({ Title = "HTTP Sniffer Paused", Content = "หยุดการดักจับ HTTP ชั่วคราว", Duration = 3 })
		end
	end)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 36)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v6.page
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 6)
	uiCorner2.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textBox6 = Instance.new("TextBox")
	textBox6.Size = UDim2.new(0.55, -12, 0, 26)
	textBox6.Position = UDim2.new(0, 8, 0.5, -13)
	textBox6.BackgroundColor3 = tbl6.input
	textBox6.BackgroundTransparency = 0.2
	textBox6.PlaceholderText = "🔍 ค้นหา URL, Domain หรือ Method..."
	textBox6.PlaceholderColor3 = tbl6.textMuted
	textBox6.TextColor3 = tbl6.cyan
	textBox6.Font = Enum.Font.Gotham
	textBox6.TextSize = 11
	textBox6.ClearTextOnFocus = false
	textBox6.Parent = frame
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 5)
	uiCorner3.Parent = textBox6
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 6)
	uiPadding.Parent = textBox6

	textBox6:GetPropertyChangedSignal("Text"):Connect(function()
		str3 = textBox6.Text
		fn16()
	end)

	textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(0.45, -12, 1, 0)
	textLabel3.Position = UDim2.new(0.55, 6, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = "📡 LIVE HTTP CALLS: 0 Packets  •  Status: 🔴 PAUSED"
	textLabel3.TextColor3 = tbl6.cyan
	textLabel3.Font = Enum.Font.GothamBold
	textLabel3.TextSize = 10
	textLabel3.TextXAlignment = Enum.TextXAlignment.Right
	textLabel3.Parent = frame
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(1, -10, 0, 150)
	frame2.BackgroundColor3 = tbl6.glassDeep
	frame2.BackgroundTransparency = 0.18
	frame2.BorderSizePixel = 0
	frame2.Parent = v6.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame2
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = tbl6.surface
	uiStroke2.Thickness = 1
	uiStroke2.Parent = frame2
	scrollingFrame3 = Instance.new("ScrollingFrame")
	scrollingFrame3.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame3.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame3.BackgroundColor3 = tbl6.input
	scrollingFrame3.BackgroundTransparency = 0.3
	scrollingFrame3.BorderSizePixel = 0
	scrollingFrame3.ScrollBarThickness = 6
	scrollingFrame3.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame3.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame3.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame3.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame3.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame3.Parent = frame2
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 6)
	uiCorner5.Parent = scrollingFrame3
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(1, -10, 0, 32)
	frame3.BackgroundTransparency = 1
	frame3.Parent = v6.page
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.Parent = frame3

	local function createTextButton(text2, backgroundColor3, arg)
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0.24, -4, 1, 0)
		textButton.BackgroundColor3 = backgroundColor3
		textButton.BackgroundTransparency = 0.2
		textButton.Text = text2
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 10
		textButton.Parent = frame3
		local uiCorner6 = Instance.new("UICorner")
		uiCorner6.CornerRadius = UDim.new(0, 5)
		uiCorner6.Parent = textButton

		textButton.MouseButton1Click:Connect(function()
			fn5()
			arg()
		end)

		return textButton
	end

	createTextButton("📋 คัดลอก URLs ทั้งหมด", tbl6.primary, function()
		if #tbl10 == 0 then
			tbl7:Notify({ Title = "Warning", Content = "ยังไม่มีประวัติ HTTP ที่ดักจับได้!", Duration = 2 })
			return
		end
		local tbl11 = {}

		for _, v16 in ipairs(tbl10) do
			table.insert(tbl11, string.format("[%s] [%s] %s", v16.Time, v16.Method, v16.Url))
		end

		if typeof(setclipboard) == "function" then
			setclipboard(table.concat(tbl11, "\n"))

			tbl7:Notify({
				Title = "Copied All",
				Content = "คัดลอก " .. #tbl10 .. " รายการลงคลิปบอร์ดแล้ว!",
				Duration = 3,
			})
		end
	end)

	createTextButton("🗑️ ล้างประวัติ Packets", tbl6.danger, function()
		tbl10 = {}
		n = nil
		fn16()

		if textBox5 then
			textBox5.Text = ""
		end

		if textBox4 then
			textBox4.Text = "-- Cleared --"
		end

		tbl7:Notify({ Title = "Cleared", Content = "ล้างประวัติ Live HTTP เรียบร้อย", Duration = 2 })
	end)

	createTextButton("⚡ Replay Packet ที่เลือก", Color3.fromRGB(40, 160, 240), function()
		local v16 = tbl10[n or 1]
		if not v16 then
			tbl7:Notify({ Title = "Warning", Content = "กรุณาคลิกเลือก Packet จากตารางก่อน Replay!", Duration = 2 })
			return
		end

		task.spawn(function()
			tbl7:Notify({ Title = "Replaying...", Content = "กำลังส่ง Request ไปยัง: " .. v16.Url, Duration = 2 })
			local flag3 = typeof(request) == "function" and request or typeof(http_request) == "function" and http_request
			local request_

			if flag3 then
				request_ = flag3
			else
				request_ = syn and typeof(syn.request) == "function" and syn.request
			end

			if request_ then
				local ok, result = pcall(function()
					return request_({ Url = v16.Url, Method = v16.Method, Headers = v16.Headers, Body = v16.Body })
				end)

				if ok and result then
					tbl7:Notify({
						Title = "Replay Success",
						Content = "Response Status: " .. tostring(result.StatusCode or 200),
						Duration = 3,
					})
				else
					tbl7:Notify({ Title = "Replay Error", Content = tostring(result), Duration = 3 })
				end
			else
				local ok, result = pcall(function()
					return game:HttpGet(v16.Url)
				end)

				if ok then
					tbl7:Notify({
						Title = "Replay Success",
						Content = "game:HttpGet OK (" .. #tostring(result) .. " bytes)",
						Duration = 3,
					})
				else
					tbl7:Notify({ Title = "Replay Error", Content = tostring(result), Duration = 3 })
				end
			end
		end)
	end)

	createTextButton("💾 บันทึก JSON Session", tbl6.secondary, function()
		if #tbl10 == 0 then
			tbl7:Notify({ Title = "Warning", Content = "ไม่มีข้อมูล Packet สำหรับบันทึก!", Duration = 2 })
			return
		end
		local HttpService = game:GetService("HttpService")

		local ok, result = pcall(function()
			return HttpService:JSONEncode(tbl10)
		end)

		if ok and result then
			if typeof(makefolder) == "function" then
				pcall(function()
					makefolder("PAYOMBOYDumps")
				end)

				pcall(function()
					makefolder("PAYOMBOYDumps/HttpTraffic")
				end)
			end

			fn6("PAYOMBOYDumps/HttpTraffic/Session_" .. os.date("%Y%m%d_%H%M%S") .. ".json", result, "HTTP Traffic Session")
		end
	end)

	v6:AddSection("🔍 PACKET DEEP INSPECTION (HEADERS & RESPONSE BODY)")
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(1, -10, 0, 180)
	frame4.BackgroundColor3 = tbl6.glassDeep
	frame4.BackgroundTransparency = 0.18
	frame4.BorderSizePixel = 0
	frame4.Parent = v6.page
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0, 8)
	uiCorner6.Parent = frame4
	local uiStroke3 = Instance.new("UIStroke")
	uiStroke3.Color = tbl6.surface
	uiStroke3.Thickness = 1
	uiStroke3.Parent = frame4
	textBox5 = Instance.new("TextBox")
	textBox5.Size = UDim2.new(1, -20, 0, 24)
	textBox5.Position = UDim2.new(0, 10, 0, 8)
	textBox5.BackgroundColor3 = tbl6.input
	textBox5.BackgroundTransparency = 0.2
	textBox5.Text = "-- คลิกเลือก Packet ด้านบนเพื่อดูรายละเอียด --"
	textBox5.TextColor3 = tbl6.cyan
	textBox5.Font = Enum.Font.Code
	textBox5.TextSize = 10
	textBox5.ClearTextOnFocus = false
	textBox5.TextXAlignment = Enum.TextXAlignment.Left
	textBox5.Parent = frame4
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, 5)
	uiCorner7.Parent = textBox5
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 6)
	uiPadding2.Parent = textBox5
	textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -20, 0, 16)
	textLabel2.Position = UDim2.new(0, 10, 0, 36)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = "Method: -  •  Status: -  •  Latency: -  •  Time: -"
	textLabel2.TextColor3 = tbl6.textMuted
	textLabel2.Font = Enum.Font.GothamMedium
	textLabel2.TextSize = 10
	textLabel2.TextXAlignment = Enum.TextXAlignment.Left
	textLabel2.Parent = frame4
	local scrollingFrame4 = Instance.new("ScrollingFrame")
	scrollingFrame4.Size = UDim2.new(1, -20, 0, 115)
	scrollingFrame4.Position = UDim2.new(0, 10, 0, 56)
	scrollingFrame4.BackgroundColor3 = tbl6.input
	scrollingFrame4.BackgroundTransparency = 0.3
	scrollingFrame4.BorderSizePixel = 0
	scrollingFrame4.ScrollBarThickness = 6
	scrollingFrame4.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame4.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame4.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame4.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame4.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame4.Parent = frame4
	local uiCorner8 = Instance.new("UICorner")
	uiCorner8.CornerRadius = UDim.new(0, 6)
	uiCorner8.Parent = scrollingFrame4
	textBox4 = Instance.new("TextBox")
	textBox4.Size = UDim2.new(1, -12, 1, 0)
	textBox4.Position = UDim2.new(0, 6, 0, 4)
	textBox4.BackgroundTransparency = 1
	textBox4.Text = "-- Response Body / Payload JSON will format here --"
	textBox4.TextColor3 = Color3.fromRGB(220, 245, 230)
	textBox4.Font = Enum.Font.Code
	textBox4.TextSize = 10
	textBox4.MultiLine = true
	textBox4.ClearTextOnFocus = false
	textBox4.TextXAlignment = Enum.TextXAlignment.Left
	textBox4.TextYAlignment = Enum.TextYAlignment.Top
	textBox4.AutomaticSize = Enum.AutomaticSize.Y
	textBox4.Parent = scrollingFrame4
end

v6:AddButton({
	Title = "📋 คัดลอก Response Body ของ Packet ที่เลือก",
	Callback = function()
		local v14 = tbl10[n or 1]

		if v14 and v14.ResponseBody and v14.ResponseBody ~= "" then
			if typeof(setclipboard) == "function" then
				setclipboard(v14.ResponseBody)
				tbl7:Notify({ Title = "Copied Body", Content = "คัดลอก Response Body ลงคลิปบอร์ดแล้ว!", Duration = 3 })
			end
		else
			tbl7:Notify({ Title = "Warning", Content = "ไม่มีเนื้อหา Body สำหรับคัดลอก", Duration = 2 })
		end
	end,
})

v6:AddButton({
	Title = "⚡ สร้าง Luau Code เรียก Request นี้ (Copy Code)",
	Callback = function()
		local v14 = tbl10[n or 1]
		if not v14 then
			tbl7:Notify({ Title = "Warning", Content = "กรุณาเลือก Packet ก่อนสร้างโค้ด!", Duration = 2 })
			return
		end
		local flag = v14.Method == "GET" and (not v14.Headers or next(v14.Headers) == nil)
		local flag2

		if flag then
			flag2 = not v14.Body or v14.Body == ""
		else
			flag2 = flag
		end

		local str3

		if flag2 then
			str3 = string.format("local response = game:HttpGet(%q)\nprint(response)", v14.Url)
		else
			local HttpService = game:GetService("HttpService")

			str3 = string.format([[local req = (typeof(request) == "function" and request) or (typeof(http_request) == "function" and http_request) or (syn and syn.request)
local res = req({
    Url = %q,
    Method = %q,
    Headers = game:GetService("HttpService"):JSONDecode(%q),
    Body = %q
})
print("Status:", res.StatusCode)
print("Response:", res.Body)]], v14.Url, v14.Method, v14.Headers and next(v14.Headers) and HttpService:JSONEncode(v14.Headers) or "{}", v14.Body or "")
		end

		if typeof(setclipboard) == "function" then
			setclipboard(str3)
			tbl7:Notify({ Title = "Code Generated", Content = "คัดลอกโค้ด Luau Request ลงคลิปบอร์ดแล้ว!", Duration = 3 })
		end
	end,
})

v6:AddSection("🕷️ SPYHTTP: SCRIPT SRC & WEBHOOK EXTRACTOR (ถอดสคริปต์ & แยกแยะ URL)")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 142)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v6.page
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 8)
	uiCorner2.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, -24, 0, 18)
	textLabel3.Position = UDim2.new(0, 12, 0, 8)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = "TARGET LOADSTRING / SCRIPT URL DECOMPILER"
	textLabel3.TextColor3 = tbl6.cyan
	textLabel3.Font = Enum.Font.GothamBold
	textLabel3.TextSize = 10
	textLabel3.TextXAlignment = Enum.TextXAlignment.Left
	textLabel3.Parent = frame
	local textBox5 = Instance.new("TextBox")
	textBox5.Size = UDim2.new(1, -24, 0, 30)
	textBox5.Position = UDim2.new(0, 12, 0, 28)
	textBox5.BackgroundColor3 = tbl6.input
	textBox5.BackgroundTransparency = 0.2
	textBox5.Text = ""
	textBox5.PlaceholderText = "วาง loadstring(game:HttpGet(\"https://...\"))() หรือ URL ที่ต้องการเจาะระบบ..."
	textBox5.PlaceholderColor3 = tbl6.textMuted
	textBox5.Font = Enum.Font.GothamSemibold
	textBox5.TextSize = 11
	textBox5.TextColor3 = tbl6.text
	textBox5.ClearTextOnFocus = false
	textBox5.TextXAlignment = Enum.TextXAlignment.Left
	textBox5.Parent = frame
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 6)
	uiCorner3.Parent = textBox5
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 8)
	uiPadding.PaddingRight = UDim.new(0, 8)
	uiPadding.Parent = textBox5
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(1, -24, 0, 16)
	textLabel4.Position = UDim2.new(0, 12, 0, 64)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "📊 สถานะ: รอการดักจับ  •  พบ URLs: 0 ลิ้งค์  •  ขนาด SRC: 0 bytes"
	textLabel4.TextColor3 = tbl6.textMuted
	textLabel4.Font = Enum.Font.GothamMedium
	textLabel4.TextSize = 10
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.Parent = frame

	local function fn11()
		if not scrollingFrame2 then
			return
		end
		scrollingFrame2:ClearAllChildren()
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 4)
		uiListLayout.Parent = scrollingFrame2
		local uiPadding2 = Instance.new("UIPadding")
		uiPadding2.PaddingTop = UDim.new(0, 4)
		uiPadding2.PaddingLeft = UDim.new(0, 4)
		uiPadding2.PaddingRight = UDim.new(0, 4)
		uiPadding2.PaddingBottom = UDim.new(0, 4)
		uiPadding2.Parent = scrollingFrame2

		if #tbl9 == 0 then
			local textLabel5 = Instance.new("TextLabel")
			textLabel5.Size = UDim2.new(1, 0, 0, 50)
			textLabel5.BackgroundTransparency = 1
			textLabel5.Text = "-- ยังไม่พบ HTTP URLs ในสคริปต์เป้าหมาย --"
			textLabel5.TextColor3 = tbl6.textFaint
			textLabel5.Font = Enum.Font.GothamSemibold
			textLabel5.TextSize = 11
			textLabel5.Parent = scrollingFrame2
			return
		end

		for _, v14 in ipairs(tbl9) do
			local frame2 = Instance.new("Frame")
			frame2.Size = UDim2.new(1, -6, 0, 36)
			frame2.BackgroundColor3 = tbl6.surface
			frame2.BackgroundTransparency = 0.2
			frame2.Parent = scrollingFrame2
			local uiCorner4 = Instance.new("UICorner")
			uiCorner4.CornerRadius = UDim.new(0, 6)
			uiCorner4.Parent = frame2
			local color = Color3.fromRGB(0, 160, 220)
			local text2

			if v14:find("discord.com/api/webhooks") or v14:find("discordapp.com/api/webhooks") then
				color = Color3.fromRGB(240, 60, 80)
				text2 = "WEBHOOK"
			elseif v14:find("github") or v14:find("raw.githubusercontent") then
				color = Color3.fromRGB(130, 80, 220)
				text2 = "GITHUB"
			else
				text2 = "WEB"

				if v14:find("pastebin") then
					color = Color3.fromRGB(64, 113, 188)
					text2 = "PASTEBIN"
				end
			end

			local textLabel5 = Instance.new("TextLabel")
			textLabel5.Size = UDim2.new(0, 65, 0, 20)
			textLabel5.Position = UDim2.new(0, 6, 0.5, -10)
			textLabel5.BackgroundColor3 = color
			textLabel5.Text = text2
			textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel5.Font = Enum.Font.GothamBold
			textLabel5.TextSize = 9
			textLabel5.Parent = frame2
			local uiCorner5 = Instance.new("UICorner")
			uiCorner5.CornerRadius = UDim.new(0, 4)
			uiCorner5.Parent = textLabel5
			local textLabel6 = Instance.new("TextLabel")
			textLabel6.Size = UDim2.new(1, -210, 1, 0)
			textLabel6.Position = UDim2.new(0, 78, 0, 0)
			textLabel6.BackgroundTransparency = 1
			textLabel6.Text = v14
			textLabel6.TextColor3 = tbl6.text
			textLabel6.Font = Enum.Font.Code
			textLabel6.TextSize = 10
			textLabel6.TextXAlignment = Enum.TextXAlignment.Left
			textLabel6.TextTruncate = Enum.TextTruncate.AtEnd
			textLabel6.Parent = frame2
			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.new(0, 55, 0, 22)
			textButton.Position = UDim2.new(1, -125, 0.5, -11)
			textButton.BackgroundColor3 = tbl6.primary
			textButton.Text = "📋 Copy"
			textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			textButton.Font = Enum.Font.GothamBold
			textButton.TextSize = 9
			textButton.Parent = frame2
			local uiCorner6 = Instance.new("UICorner")
			uiCorner6.CornerRadius = UDim.new(0, 4)
			uiCorner6.Parent = textButton

			textButton.MouseButton1Click:Connect(function()
				fn5()

				if typeof(setclipboard) == "function" then
					setclipboard(v14)
					tbl7:Notify({ Title = "Copied", Content = v14, Duration = 2 })
				end
			end)

			local textButton2 = Instance.new("TextButton")
			textButton2.Size = UDim2.new(0, 58, 0, 22)
			textButton2.Position = UDim2.new(1, -64, 0.5, -11)
			textButton2.BackgroundColor3 = tbl6.surfaceRaised
			textButton2.Text = "🌐 Test GET"
			textButton2.TextColor3 = tbl6.cyan
			textButton2.Font = Enum.Font.GothamBold
			textButton2.TextSize = 9
			textButton2.Parent = frame2
			local uiCorner7 = Instance.new("UICorner")
			uiCorner7.CornerRadius = UDim.new(0, 4)
			uiCorner7.Parent = textButton2

			textButton2.MouseButton1Click:Connect(function()
				fn5()

				task.spawn(function()
					tbl7:Notify({ Title = "Testing GET", Content = "กำลังดึงข้อมูลจาก " .. v14, Duration = 2 })

					local ok, result = pcall(function()
						return game:HttpGet(v14)
					end)

					if ok then
						tbl7:Notify({
							Title = "GET Success",
							Content = "ดึงข้อมูลสำเร็จ (" .. #tostring(result) .. " bytes)",
							Duration = 3,
						})
					else
						tbl7:Notify({ Title = "GET Failed", Content = tostring(result), Duration = 3 })
					end
				end)
			end)
		end
	end

	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(1, -24, 0, 32)
	frame2.Position = UDim2.new(0, 12, 0, 94)
	frame2.BackgroundTransparency = 1
	frame2.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.Parent = frame2

	local function createTextButton(text2, backgroundColor3, arg)
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0.24, -4, 1, 0)
		textButton.BackgroundColor3 = backgroundColor3
		textButton.BackgroundTransparency = 0.2
		textButton.Text = text2
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 10
		textButton.Parent = frame2
		local uiCorner4 = Instance.new("UICorner")
		uiCorner4.CornerRadius = UDim.new(0, 5)
		uiCorner4.Parent = textButton

		textButton.MouseButton1Click:Connect(function()
			fn5()
			arg()
		end)

		return textButton
	end

	createTextButton("🕷️ ดักจับ & ถอด SRC", Color3.fromRGB(64, 113, 188), function()
		local text2 = textBox5.Text
		if not text2 or text2:gsub("%s+", "") == "" then
			tbl7:Notify({ Title = "Warning", Content = "กรุณาใส่ Loadstring หรือ URL สคริปต์เป้าหมาย!", Duration = 3 })
			return
		end
		tbl7:Notify({ Title = "กำลังดักจับ...", Content = "กำลังดาวน์โหลด SRC และแยกแยะ URL/Webhooks...", Duration = 3 })

		task.spawn(function()
			local v14, v15, v16 = fn10(text2)

			if not v14 then
				tbl7:Notify({ Title = "❌ ดักจับล้มเหลว", Content = v16 or "ไม่สามารถดึงข้อมูลได้", Duration = 4 })

				if textLabel4 then
					textLabel4.Text = "📊 สถานะ: ❌ ดักจับล้มเหลว: " .. tostring(v16)
				end

				return
			end

			str = v14
			str2 = v15 or "RAW_INPUT"
			tbl9 = fn9(v14)

			if textLabel4 then
				textLabel4.Text = string.format("📊 สถานะ: ✅ แกะสำเร็จ  •  พบ URLs: %d ลิ้งค์  •  ขนาด SRC: %d bytes", #tbl9, #str)
			end

			fn11()

			if typeof(setclipboard) == "function" then
				setclipboard(v14)
			end

			tbl7:Notify({
				Title = "✅ ดักจับสำเร็จ",
				Content = string.format("ดึง SRC เรียบร้อย (%d bytes) พบ HTTP %d รายการ (Copy ลงคลิปบอร์ดแล้ว)", #str, #tbl9),
				Duration = 4,
			})
		end)
	end)

	createTextButton("📋 คัดลอก SRC", tbl6.primary, function()
		if not str or str == "" then
			tbl7:Notify({ Title = "Warning", Content = "ยังไม่มีเนื้อหา SRC กรุณาดักจับก่อน!", Duration = 3 })
			return
		end

		if typeof(setclipboard) == "function" then
			setclipboard(str)
			tbl7:Notify({ Title = "คัดลอกเรียบร้อย", Content = "SRC ถูกคัดลอกลง Clipboard แล้ว!", Duration = 2 })
		end
	end)

	createTextButton("🧠 ส่งเข้า AI Central", Color3.fromRGB(130, 80, 220), function()
		if not str or str == "" then
			tbl7:Notify({ Title = "Warning", Content = "กรุณาดักจับสคริปต์ก่อนส่งเข้า AI!", Duration = 3 })
			return
		end
		local n2 = 0

		for i, v14 in ipairs(tbl9) do
			if tbl2:AddContext("ExtractedEndpoint_" .. i, "HttpEndpoint", v14, "SpyHttp") then
				n2 += 1
			end
		end

		local tbl11 = { Name = "DecompiledScript", Class = "LuaSourceContainer", Path = str2, Source = str }
		fn7(string.format("วิเคราะห์และทำความเข้าใจสคริปต์จาก: %s (พบ %d URLs) พร้อมสร้างฟังก์ชันช่วยเล่น/แก้ทาง", str2, #tbl9), tbl11)
		tbl7:Notify({ Title = "AI Synthesis", Content = "ส่งข้อมูลสคริปต์เข้า Cyber-AI เรียบร้อย!", Duration = 3 })
	end)

	createTextButton("💾 เซฟลงไฟล์", tbl6.secondary, function()
		if not str or str == "" then
			tbl7:Notify({ Title = "Warning", Content = "ไม่มีเนื้อหา SRC สำหรับบันทึก!", Duration = 3 })
			return
		end

		if typeof(makefolder) == "function" then
			pcall(function()
				makefolder("PAYOMBOYDumps")
			end)

			pcall(function()
				makefolder("PAYOMBOYDumps/SpyHttp")
			end)
		end

		fn6("PAYOMBOYDumps/SpyHttp" .. "/Extracted_" .. os.date("%Y%m%d_%H%M%S") .. ".lua", str, "HTTP Script SRC")
	end)

	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(1, -10, 0, 140)
	frame3.BackgroundColor3 = tbl6.glassDeep
	frame3.BackgroundTransparency = 0.18
	frame3.BorderSizePixel = 0
	frame3.Parent = v6.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame3
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = tbl6.surface
	uiStroke2.Thickness = 1
	uiStroke2.Parent = frame3
	scrollingFrame2 = Instance.new("ScrollingFrame")
	scrollingFrame2.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame2.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame2.BackgroundColor3 = tbl6.input
	scrollingFrame2.BackgroundTransparency = 0.3
	scrollingFrame2.BorderSizePixel = 0
	scrollingFrame2.ScrollBarThickness = 6
	scrollingFrame2.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame2.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame2.Parent = frame3
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 6)
	uiCorner5.Parent = scrollingFrame2
	fn11()
end

local str3, tbl11, fn11, str4, text2, str5, v14, str6, textBox5, scrollingFrame3
local textLabel3, fn12, fn13

do
	local tbl12 = {
		"Anchored",
		"CanCollide",
		"CanTouch",
		"CanQuery",
		"Transparency",
		"Reflectance",
		"Color",
		"Material",
		"Size",
		"CFrame",
		"Position",
		"Orientation",
		"Value",
		"Visible",
		"Enabled",
		"Text",
		"Image",
		"Texture",
		"TextureID",
		"TextureId",
		"MeshId",
		"MeshType",
		"Scale",
		"Offset",
		"SecondaryAxis",
		"Axis",
		"Rate",
		"Speed",
		"Lifetime",
		"LightEmission",
		"Brightness",
		"Range",
		"Shadows",
		"Volume",
		"PlaybackSpeed",
		"RollOffMaxDistance",
		"RollOffMinDistance",
		"RollOffMode",
		"Neutral",
		"TeamColor",
		"AllowTeamChangeOnTouch",
		"Duration",
		"Face",
		"Locked",
		"MaxSpeed",
		"Torque",
		"TurnSpeed",
		"Shape",
		"StudsPerTileU",
		"StudsPerTileV",
	}

	local function fn14(arg, arg2)
		local ok, result = pcall(function()
			return arg[arg2]
		end)

		return ok, result
	end

	str3 = "NORMAL"
	tbl11 = { Children = true, Attributes = true, Properties = false, SourceFormat = false }

	fn11 = function(arg)
		str3 = arg

		if arg == "FAST" then
			tbl11.Children = true
			tbl11.Attributes = false
			tbl11.Properties = false
			tbl11.SourceFormat = false
		elseif arg == "NORMAL" then
			tbl11.Children = true
			tbl11.Attributes = true
			tbl11.Properties = false
			tbl11.SourceFormat = false
		elseif arg == "DEEP" then
			tbl11.Children = true
			tbl11.Attributes = true
			tbl11.Properties = true
			tbl11.SourceFormat = false
		end
	end

	str4 = ""
	text2 = ""
	str5 = "ReplicatedStorage"
	v14 = nil
	str6 = nil
	textBox5 = nil
	scrollingFrame3 = nil
	textLabel3 = nil

	fn12 = function(text3, arg)
		if not text3 or text3 == "" then
			return
		end
		v14 = text3
		arg = arg or str5 or "Target"
		local n2 = #text3
		local n3 = 1

		for match in string.gmatch(text3, "\n") do
			n3 += 1
		end

		local str7 = string.format("%.2f KB", n2 / 1024)

		if textLabel3 then
			textLabel3.Text = string.format("📊 STATUS: LOADED  •  Target: %s  •  Lines: %d  •  Size: %s", arg, n3, str7)
		end

		if textBox5 then
			if n2 > 25000 then
				textBox5.Text = string.sub(text3, 1, 25000) .. string.format([[


-- [⚠️ PREVIEW TRUNCATED FOR UI DISPLAY PERFORMANCE]
-- Full Dump Size: %s (%d lines, %d characters).
-- The complete untruncated content is ready to be saved to file or copied to clipboard!]], str7, n3, n2)
			else
				textBox5.Text = text3
			end

			task.defer(function()
				if textBox5 and scrollingFrame3 then
					local n4 = math.max(260, textBox5.TextBounds.Y + 30)
					textBox5.Size = UDim2.new(1, -10, 0, n4)
					scrollingFrame3.CanvasSize = UDim2.new(0, 0, 0, n4 + 20)
				end
			end)
		end
	end

	local function fn15()
		local v15 = str5
		local str7

		if str5 then
			str7 = v15
		else
			str7 = "ReplicatedStorage"
		end

		local str8 = str7:gsub("^%s+", ""):gsub("%s+$", "")

		if str8 == "" then
			str8 = "ReplicatedStorage"
		end

		local v16 = nil

		if str8:lower() == "workspace" then
			v16 = workspace
		else
			local ok, result = pcall(function()
				return game:GetService(str8)
			end)

			if ok and result then
				v16 = result
			else
				pcall(function()
					v16 = game:FindFirstChild(str8)
				end)
			end
		end

		if not v16 then
			return nil, str8
		end

		if str4 and str4 ~= "" then
			local str9 = str4:gsub("^%s+", ""):gsub("%s+$", "")

			if str9 ~= "" then
				for match in str9:gmatch("[^/]+") do
					local str10 = match:gsub("^%s+", ""):gsub("%s+$", "")

					if str10 == "" then
						continue
					else
						v16 = v16 and v16:FindFirstChild(str10)
						if v16 then
							continue
						end
					end

					break
				end
			end
		end

		return v16, str8
	end

	local function fn16(arg)
		local tbl13 = {}
		tbl13[#tbl13 + 1] = "-- [[ PayomboyZ Valen Hub Service Dump ]]"
		tbl13[#tbl13 + 1] = "-- Root: " .. arg:GetFullName()
		tbl13[#tbl13 + 1] = "-- Class: " .. arg.ClassName
		tbl13[#tbl13 + 1] = "-- Preset: " .. tostring(str3)
		tbl13[#tbl13 + 1] = "-- Time: " .. os.date("%Y-%m-%d %H:%M:%S")
		local tbl14 = { arg }

		if tbl11.Children then
			local ok, result = pcall(function()
				return arg:GetDescendants()
			end)

			if ok and result then
				for _, v15 in ipairs(result) do
					tbl14[#tbl14 + 1] = v15
				end
			end
		end

		for i, v15 in ipairs(tbl14) do
			if i % 250 == 0 then
				task.wait()
			end

			tbl13[#tbl13 + 1] = ""
			tbl13[#tbl13 + 1] = "[" .. v15.ClassName .. "] " .. v15:GetFullName()

			if tbl11.Attributes then
				local ok, result = pcall(function()
					return v15:GetAttributes()
				end)

				if ok and result then
					for k, v16 in pairs(result) do
						tbl13[#tbl13 + 1] = "  @" .. tostring(k) .. " = " .. tbl5.Serialize(v16)
					end
				end
			end

			local properties = tbl11.Properties
			local properties2

			if properties then
				properties2 = str3 == "DEEP" or tbl11.Properties
			else
				properties2 = properties
			end

			if properties2 then
				for _, v16 in ipairs(tbl12) do
					local v17, v18 = fn14(v15, v16)

					if v17 and v18 ~= nil then
						tbl13[#tbl13 + 1] = "  ." .. v16 .. " = " .. tbl5.Serialize(v18)
					end
				end
			end
		end

		if tbl11.SourceFormat then
			local tbl15 = { "-- PayomboyZ Hub source-format dump", "local dump = {}" }

			for i, v15 in ipairs(tbl14) do
				if i % 500 == 0 then
					task.wait()
				end

				local n2 = #tbl15 + 1
				local className = v15.ClassName
				local name = v15.Name
				tbl15[n2] = string.format("dump[%q] = {ClassName=%q, Name=%q}", v15:GetFullName(), className, name)
			end

			tbl15[#tbl15 + 1] = "return dump"
			return table.concat(tbl15, "\n")
		end

		return table.concat(tbl13, "\n")
	end

	fn13 = function(arg, arg2)
		tbl7:Notify({ Title = "Dump Initiated", Content = "Processing target service... Please wait.", Duration = 2 })
		local v15, v16 = fn15()

		if not v15 then
			tbl7:Notify({
				Title = "Dump Error",
				Content = "Target service/subpath not found: " .. tostring(v16),
				Duration = 3,
			})

			return
		end

		local ok, result = pcall(fn16, v15)
		if not ok then
			tbl7:Notify({ Title = "Dump Error", Content = "Dump failed: " .. tostring(result), Duration = 3 })
			return
		end
		fn12(result, v16)

		if arg2 then
			if v8 and v8.Select then
				pcall(function()
					v8:Select()
				end)
			end

			tbl7:Notify({
				Title = "Preview Loaded",
				Content = "Dumped " .. v16 .. " (" .. #result .. " chars)! Navigated to Preview tab.",
				Duration = 4,
			})
		end

		if arg then
			if typeof(makefolder) == "function" then
				pcall(function()
					makefolder("PAYOMBOYDumps")
				end)

				pcall(function()
					makefolder("PAYOMBOYDumps/Dump")
				end)
			end

			str6 = "PAYOMBOYDumps/Dump/" .. (text2 and text2 ~= "" and text2 or v16 .. "_" .. os.date("%Y%m%d_%H%M%S")):gsub("[^%w_%- ]", "_") .. (tbl11.SourceFormat and ".lua" or ".txt")
			fn6(str6, result, "Service Dump")

			if v8 and v8.Select then
				pcall(function()
					v8:Select()
				end)
			end
		end
	end
end

local fn14

local function fn15(arg, arg2, arg3, arg4, arg5)
	local v15 = arg5 or workspace
	local tbl12 = {}
	local str7 = "-- [[ PayomboyZ Dump Engine: " .. tostring(arg) .. " ]]"
	local str8 = "-- Generated At: " .. os.date("%Y-%m-%d %H:%M:%S")
	local localTargetParent = v15 == workspace and "workspace" or "game:GetService(\"ReplicatedStorage\")"
	local str9 = "dumpFolder.Name = " .. string.format("%q", arg)
	tbl12[1] = str7
	tbl12[2] = str8
	tbl12[3] = "local targetParent = " .. localTargetParent
	tbl12[4] = "local dumpFolder = Instance.new(\"Folder\")"
	tbl12[5] = str9
	tbl12[6] = "dumpFolder.Parent = targetParent"
	tbl12[7] = ""
	tbl12[8] = "local refMap = { [0] = dumpFolder }"
	local n2 = 0
	local n3 = 1

	local function fn16(arg6)
		local v16 = ipairs
		local Players2 = game:GetService("Players")

		for _, player in v16(Players2:GetPlayers()) do
			if player.Character and (arg6 == player.Character or arg6:IsDescendantOf(player.Character)) then
				return true
			end
		end

		return false
	end

	local function fn17(arg6)
		if not arg2 and arg6:IsA("Terrain") then
			return false
		end

		if not arg4 and fn16(arg6) then
			return false
		end

		if not arg3 and (arg6:IsA("LuaSourceContainer") or arg6:IsA("Script") or arg6:IsA("LocalScript") or arg6:IsA("ModuleScript")) then
			return false
		end
		return true
	end

	local fn18 = nil

	fn18 = function(arg6, arg7)
		if not fn17(arg6) then
			return
		end
		local v16 = n3
		n3 += 1
		n2 += 1
		table.insert(tbl12, string.format("local obj%d = Instance.new(%q)", v16, arg6.ClassName))
		table.insert(tbl12, string.format("obj%d.Name = %q", v16, arg6.Name))
		table.insert(tbl12, string.format("obj%d.Parent = refMap[%d]", v16, arg7))
		table.insert(tbl12, string.format("refMap[%d] = obj%d", v16, v16))

		if arg6:IsA("BasePart") then
			pcall(function()
				table.insert(tbl12, string.format("obj%d.Size = %s", v16, tbl5.Serialize(arg6.Size)))
				table.insert(tbl12, string.format("obj%d.CFrame = %s", v16, tbl5.Serialize(arg6.CFrame)))
				table.insert(tbl12, string.format("obj%d.Color = %s", v16, tbl5.Serialize(arg6.Color)))
				table.insert(tbl12, string.format("obj%d.Material = %s", v16, tbl5.Serialize(arg6.Material)))
				table.insert(tbl12, string.format("obj%d.Anchored = %s", v16, tostring(arg6.Anchored)))
				table.insert(tbl12, string.format("obj%d.CanCollide = %s", v16, tostring(arg6.CanCollide)))
			end)
		elseif arg6:IsA("ValueBase") then
			pcall(function()
				local v17 = tbl5.Serialize(arg6.Value)

				if v17 then
					table.insert(tbl12, string.format("obj%d.Value = %s", v16, v17))
				end
			end)
		elseif arg6:IsA("LuaSourceContainer") and arg3 then
			pcall(function()
				local source = arg6.Source

				if source and #source > 0 then
					table.insert(tbl12, string.format("obj%d.Source = %q", v16, source))
				end
			end)
		end

		for _, child in ipairs(arg6:GetChildren()) do
			fn18(child, v16)
		end
	end

	for _, child in ipairs(v15:GetChildren()) do
		fn18(child, 0)
	end

	table.insert(tbl12, "")
	table.insert(tbl12, string.format("print('[Dump Restore] Created %d instances in folder %s')", n2, arg))
	return table.concat(tbl12, "\n"), n2
end

fn14 = function(arg, arg2, arg3, arg4, arg5)
	return fn15(arg2, arg3, arg4, arg5, arg)
end

v7:AddSection("EXPORT FILENAME & SAVE CONFIGURATION")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 85)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v7.page
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 8)
	uiCorner2.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(1, -24, 0, 16)
	textLabel4.Position = UDim2.new(0, 12, 0, 6)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "CUSTOM EXPORT FILE NAME (OPTIONAL)"
	textLabel4.TextColor3 = tbl6.textMuted
	textLabel4.Font = Enum.Font.GothamBold
	textLabel4.TextSize = 10
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.Parent = frame
	local textBox6 = Instance.new("TextBox")
	textBox6.Size = UDim2.new(1, -24, 0, 26)
	textBox6.Position = UDim2.new(0, 12, 0, 24)
	textBox6.BackgroundColor3 = tbl6.input
	textBox6.BackgroundTransparency = 0.2
	textBox6.Text = text2
	textBox6.PlaceholderText = "Leave empty for auto-generated timestamp name..."
	textBox6.Font = Enum.Font.GothamSemibold
	textBox6.TextSize = 11
	textBox6.TextColor3 = tbl6.cyan
	textBox6.ClearTextOnFocus = false
	textBox6.TextXAlignment = Enum.TextXAlignment.Left
	textBox6.Parent = frame
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 5)
	uiCorner3.Parent = textBox6
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 6)
	uiPadding.Parent = textBox6
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(1, -24, 0, 24)
	textLabel5.Position = UDim2.new(0, 12, 0, 54)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "📁 Output Path: workspace/PAYOMBOYDumps/Dump/" .. (text2 ~= "" and text2 or "<AutoName>") .. ".txt"
	textLabel5.TextColor3 = Color3.fromRGB(0, 220, 160)
	textLabel5.Font = Enum.Font.Code
	textLabel5.TextSize = 10
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.Parent = frame

	local function fn16()
		text2 = textBox6.Text:gsub("^%s+", ""):gsub("%s+$", "")
		textLabel5.Text = "📁 Output Path: workspace/PAYOMBOYDumps/Dump/" .. (text2 ~= "" and text2 or str5 .. "_<Timestamp>") .. ".txt"
	end

	textBox6:GetPropertyChangedSignal("Text"):Connect(fn16)
	textBox6.FocusLost:Connect(fn16)
	v7:AddSection("QUICK SELECT TARGET SERVICE")
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(1, -10, 0, 80)
	frame2.BackgroundColor3 = tbl6.glassDeep
	frame2.BackgroundTransparency = 0.18
	frame2.BorderSizePixel = 0
	frame2.Parent = v7.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame2
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = tbl6.surface
	uiStroke2.Thickness = 1
	uiStroke2.Parent = frame2
	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.CellSize = UDim2.new(0.24, -4, 0, 22)
	uiGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
	uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiGridLayout.Parent = frame2
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingTop = UDim.new(0, 6)
	uiPadding2.PaddingLeft = UDim.new(0, 6)
	uiPadding2.PaddingRight = UDim.new(0, 6)
	uiPadding2.PaddingBottom = UDim.new(0, 6)
	uiPadding2.Parent = frame2
	local textBox7 = nil

	for i, v15 in ipairs({
		"ReplicatedStorage",
		"Workspace",
		"Players",
		"Lighting",
		"StarterGui",
		"StarterPack",
		"StarterPlayer",
		"SoundService",
		"ReplicatedFirst",
		"ServerStorage",
		"TextChatService",
		"HttpService",
	}) do
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundColor3 = Color3.fromRGB(22, 35, 56)
		textButton.BackgroundTransparency = 0.15
		textButton.Text = v15
		textButton.TextColor3 = Color3.fromRGB(232, 239, 251)
		textButton.Font = Enum.Font.GothamSemibold
		textButton.TextSize = 9
		textButton.LayoutOrder = i
		textButton.Parent = frame2
		local uiCorner5 = Instance.new("UICorner")
		uiCorner5.CornerRadius = UDim.new(0, 4)
		uiCorner5.Parent = textButton
		local uiStroke3 = Instance.new("UIStroke")
		uiStroke3.Color = Color3.fromRGB(43, 65, 96)
		uiStroke3.Thickness = 1
		uiStroke3.Parent = textButton

		textButton.MouseEnter:Connect(function()
			textButton.BackgroundColor3 = Color3.fromRGB(33, 51, 80)
		end)

		textButton.MouseLeave:Connect(function()
			textButton.BackgroundColor3 = Color3.fromRGB(22, 35, 56)
		end)

		textButton.MouseButton1Click:Connect(function()
			fn5()
			str5 = v15

			if textBox7 then
				textBox7.Text = v15
			end

			fn16()
			tbl7:Notify({ Title = "Target Selected", Content = "Service set to: " .. v15, Duration = 2 })
		end)
	end

	v7:AddSection("CUSTOM TARGET SERVICE & SUB PATH INPUT")
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(1, -10, 0, 95)
	frame3.BackgroundColor3 = tbl6.glassDeep
	frame3.BackgroundTransparency = 0.18
	frame3.BorderSizePixel = 0
	frame3.Parent = v7.page
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 8)
	uiCorner5.Parent = frame3
	local uiStroke3 = Instance.new("UIStroke")
	uiStroke3.Color = tbl6.surface
	uiStroke3.Thickness = 1
	uiStroke3.Parent = frame3
	local textLabel6 = Instance.new("TextLabel")
	textLabel6.Size = UDim2.new(1, -24, 0, 16)
	textLabel6.Position = UDim2.new(0, 12, 0, 6)
	textLabel6.BackgroundTransparency = 1
	textLabel6.Text = "TARGET SERVICE NAME (e.g. ReplicatedStorage, Workspace, Players)"
	textLabel6.TextColor3 = tbl6.textMuted
	textLabel6.Font = Enum.Font.GothamBold
	textLabel6.TextSize = 10
	textLabel6.TextXAlignment = Enum.TextXAlignment.Left
	textLabel6.Parent = frame3
	textBox7 = Instance.new("TextBox")
	textBox7.Size = UDim2.new(1, -24, 0, 24)
	textBox7.Position = UDim2.new(0, 12, 0, 22)
	textBox7.BackgroundColor3 = tbl6.input
	textBox7.BackgroundTransparency = 0.2
	textBox7.Text = "ReplicatedStorage"
	textBox7.Font = Enum.Font.GothamSemibold
	textBox7.TextSize = 11
	textBox7.TextColor3 = tbl6.cyan
	textBox7.ClearTextOnFocus = false
	textBox7.TextXAlignment = Enum.TextXAlignment.Left
	textBox7.Parent = frame3
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0, 5)
	uiCorner6.Parent = textBox7
	local uiPadding3 = Instance.new("UIPadding")
	uiPadding3.PaddingLeft = UDim.new(0, 6)
	uiPadding3.Parent = textBox7

	textBox7:GetPropertyChangedSignal("Text"):Connect(function()
		str5 = textBox7.Text
		fn16()
	end)

	textBox7.FocusLost:Connect(function()
		str5 = textBox7.Text
		fn16()
	end)

	local textLabel7 = Instance.new("TextLabel")
	textLabel7.Size = UDim2.new(1, -24, 0, 16)
	textLabel7.Position = UDim2.new(0, 12, 0, 48)
	textLabel7.BackgroundTransparency = 1
	textLabel7.Text = "SUB PATH (OPTIONAL, e.g. TS/data/plants)"
	textLabel7.TextColor3 = tbl6.textMuted
	textLabel7.Font = Enum.Font.GothamBold
	textLabel7.TextSize = 10
	textLabel7.TextXAlignment = Enum.TextXAlignment.Left
	textLabel7.Parent = frame3
	local textBox8 = Instance.new("TextBox")
	textBox8.Size = UDim2.new(1, -24, 0, 24)
	textBox8.Position = UDim2.new(0, 12, 0, 64)
	textBox8.BackgroundColor3 = tbl6.input
	textBox8.BackgroundTransparency = 0.2
	textBox8.Text = ""
	textBox8.PlaceholderText = "Leave empty for root service..."
	textBox8.Font = Enum.Font.GothamSemibold
	textBox8.TextSize = 11
	textBox8.TextColor3 = tbl6.text
	textBox8.ClearTextOnFocus = false
	textBox8.TextXAlignment = Enum.TextXAlignment.Left
	textBox8.Parent = frame3
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, 5)
	uiCorner7.Parent = textBox8
	local uiPadding4 = Instance.new("UIPadding")
	uiPadding4.PaddingLeft = UDim.new(0, 6)
	uiPadding4.Parent = textBox8

	textBox8:GetPropertyChangedSignal("Text"):Connect(function()
		str4 = textBox8.Text
	end)

	textBox8.FocusLost:Connect(function()
		str4 = textBox8.Text
	end)
end

v7:AddSection("DUMP PRESET ENGINE (PERFORMANCE OPTIMIZATION)")

do
	local v15 = nil
	local v16 = nil
	local v17 = nil

	local function fn16()
		if v15 then
			v15.Text = str3 == "FAST" and "⚡ [ACTIVE] FAST (Tree Only)" or "⚡ FAST (Tree Only)"
		end

		if v16 then
			v16.Text = str3 == "NORMAL" and "🔍 [ACTIVE] NORMAL (Tree + Attributes)" or "🔍 NORMAL (Tree + Attributes)"
		end

		if v17 then
			v17.Text = str3 == "DEEP" and "🧬 [ACTIVE] DEEP (Everything + Props)" or "🧬 DEEP (Everything + Props)"
		end
	end

	v15 = v7:AddButton({
		Title = "⚡ FAST (Tree Only)",
		Callback = function()
			fn5()
			fn11("FAST")
			fn16()
			tbl7:Notify({ Title = "Preset Changed", Content = "Set Dump Preset to FAST!", Duration = 2 })
		end,
	})

	v16 = v7:AddButton({
		Title = "🔍 [ACTIVE] NORMAL (Tree + Attributes)",
		Callback = function()
			fn5()
			fn11("NORMAL")
			fn16()
			tbl7:Notify({ Title = "Preset Changed", Content = "Set Dump Preset to NORMAL!", Duration = 2 })
		end,
	})

	v17 = v7:AddButton({
		Title = "🧬 DEEP (Everything + Props)",
		Callback = function()
			fn5()
			fn11("DEEP")
			fn16()
			tbl7:Notify({ Title = "Preset Changed", Content = "Set Dump Preset to DEEP!", Duration = 2 })
		end,
	})
end

v7:AddSection("ADVANCED CUSTOM DUMP CONFIGURATION")

local function fn16(arg, arg2, arg3)
	local v15 = v7:AddButton({
		Title = (arg2 and "🟢 [ON] " or "🔴 [OFF] ") .. arg,
		Callback = function()
		end,
	})

	v15.MouseButton1Click:Connect(function()
		arg2 = not arg2
		v15.Text = (arg2 and "🟢 [ON] " or "🔴 [OFF] ") .. arg
		arg3(arg2)
	end)

	return v15
end

fn16("Dump Children Tree", tbl11.Children, function(children)
	tbl11.Children = children
end)

fn16("Dump Attributes", tbl11.Attributes, function(attributes)
	tbl11.Attributes = attributes
end)

fn16("Dump Part / Humanoid Properties", tbl11.Properties, function(properties)
	tbl11.Properties = properties
end)

fn16("Source Code Format", tbl11.SourceFormat, function(sourceFormat)
	tbl11.SourceFormat = sourceFormat
end)

v7:AddSection("SERVICE DUMP ACTIONS")

v7:AddButton({
	Title = "💾 Dump Service to File",
	Style = "primary",
	Callback = function()
		task.spawn(function()
			fn13(true, false)
		end)
	end,
})

v7:AddButton({
	Title = "👁️ Dump Service & Send to Preview Tab",
	Style = "primary",
	Callback = function()
		task.spawn(function()
			fn13(false, true)
		end)
	end,
})

v7:AddSection("r101 RECONSTRUCTION DUMPER (FULL WORKSPACE / REPLICATED)")
local str7 = "Workspace"

v7:AddButton({
	Title = "🚀 RUN r101 INSTANCE RECONSTRUCTION DUMP",
	Style = "primary",
	Callback = function()
		local ReplicatedStorage = str7 == "Workspace" and workspace or game:GetService("ReplicatedStorage")
		local str8 = text2 and text2 ~= "" and text2 or str7 .. "Dump_" .. os.date("%Y%m%d_%H%M%S")

		task.spawn(function()
			local v15, v16 = fn14(ReplicatedStorage, str8, true, true, false)

			if v15 and v16 > 0 then
				fn12(v15, str8)

				if v8 and v8.Select then
					pcall(function()
						v8:Select()
					end)
				end

				if typeof(makefolder) == "function" then
					pcall(function()
						makefolder("PAYOMBOYDumps")
					end)

					pcall(function()
						makefolder("PAYOMBOYDumps/Dump")
					end)
				end

				local str9 = "PAYOMBOYDumps/Dump/" .. str8 .. ".lua"
				str6 = str9
				fn6(str9, v15, "r101 Dump")
			end
		end)
	end,
})

v8:AddSection("SERVICE DUMP PREVIEW TERMINAL")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 32)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v8.page
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 8)
	uiCorner2.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, -20, 1, 0)
	textLabel3.Position = UDim2.new(0, 10, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = "📊 STATUS: WAITING  •  No dump data loaded yet. Perform a dump to view content."
	textLabel3.TextColor3 = tbl6.cyan
	textLabel3.Font = Enum.Font.GothamBold
	textLabel3.TextSize = 10
	textLabel3.TextXAlignment = Enum.TextXAlignment.Left
	textLabel3.Parent = frame
end

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 260)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v8.page
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 8)
	uiCorner2.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	scrollingFrame3 = Instance.new("ScrollingFrame")
	scrollingFrame3.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame3.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame3.BackgroundColor3 = tbl6.input
	scrollingFrame3.BackgroundTransparency = 0.3
	scrollingFrame3.BorderSizePixel = 0
	scrollingFrame3.ScrollBarThickness = 6
	scrollingFrame3.ScrollBarImageColor3 = tbl6.primary
	scrollingFrame3.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame3.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame3.CanvasSize = UDim2.new(0, 0, 0, 240)
	scrollingFrame3.Parent = frame
end

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 6)
uiCorner2.Parent = scrollingFrame3
textBox5 = Instance.new("TextBox")
textBox5.Size = UDim2.new(1, -10, 0, 240)
textBox5.Position = UDim2.new(0, 5, 0, 0)
textBox5.BackgroundTransparency = 1
textBox5.PlaceholderText = "-- Dumped data preview will appear here live. Select a service in 'Instance Dumper' and click Dump & Send to Preview."
textBox5.Text = ""
textBox5.Font = Enum.Font.Code
textBox5.TextSize = 11
textBox5.TextColor3 = Color3.fromRGB(150, 240, 200)
textBox5.MultiLine = true
textBox5.ClearTextOnFocus = false
textBox5.TextEditable = false
textBox5.TextXAlignment = Enum.TextXAlignment.Left
textBox5.TextYAlignment = Enum.TextYAlignment.Top
textBox5.Parent = scrollingFrame3
local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingLeft = UDim.new(0, 4)
uiPadding.PaddingTop = UDim.new(0, 4)
uiPadding.Parent = textBox5

textBox5:GetPropertyChangedSignal("Text"):Connect(function()
	task.defer(function()
		if textBox5 and scrollingFrame3 then
			local n2 = math.max(240, textBox5.TextBounds.Y + 30)
			textBox5.Size = UDim2.new(1, -10, 0, n2)
			scrollingFrame3.CanvasSize = UDim2.new(0, 0, 0, n2 + 20)
		end
	end)
end)

if v14 then
	fn12(v14, str5)
end

v8:AddSection("PREVIEW ACTIONS & EXPORT")

v8:AddButton({
	Title = "💾 Save Full Preview Data to File",
	Style = "primary",
	Callback = function()
		if v14 and v14 ~= "" then
			if typeof(makefolder) == "function" then
				pcall(function()
					makefolder("PAYOMBOYDumps")
				end)

				pcall(function()
					makefolder("PAYOMBOYDumps/Dump")
				end)
			end

			str6 = "PAYOMBOYDumps/Dump/" .. (text2 and text2 ~= "" and text2 or str5 .. "_Preview_" .. os.date("%Y%m%d_%H%M%S")):gsub("[^%w_%- ]", "_") .. ((tbl11.SourceFormat or v14:sub(1, 50):find("local")) and ".lua" or ".txt")
			fn6(str6, v14, "Dump Preview")
		else
			tbl7:Notify({ Title = "Warning", Content = "No preview dump data available!", Duration = 3 })
		end
	end,
})

v8:AddButton({
	Title = "🔄 Refresh Dump Preview Data",
	Callback = function()
		if v14 then
			fn12(v14, str5)
			tbl7:Notify({ Title = "Refreshed", Content = "Dump preview refreshed!", Duration = 2 })
		else
			tbl7:Notify({ Title = "Warning", Content = "No dump data available yet.", Duration = 3 })
		end
	end,
})

v8:AddButton({
	Title = "📋 Copy Full Preview Code to Clipboard",
	Callback = function()
		if v14 and v14 ~= "" then
			if typeof(setclipboard) == "function" then
				pcall(function()
					setclipboard(v14)
				end)

				tbl7:Notify({
					Title = "Copied",
					Content = "Copied full untruncated preview text to clipboard!",
					Duration = 3,
				})
			end
		else
			tbl7:Notify({ Title = "Warning", Content = "Preview buffer is empty!", Duration = 3 })
		end
	end,
})

v8:AddButton({
	Title = "📁 Copy Last Saved File Path",
	Callback = function()
		if str6 then
			if typeof(setclipboard) == "function" then
				pcall(function()
					setclipboard(str6)
				end)

				tbl7:Notify({ Title = "Copied Path", Content = str6, Duration = 4 })
			end
		else
			tbl7:Notify({ Title = "Warning", Content = "No dump file saved yet.", Duration = 3 })
		end
	end,
})

v9:AddSection("SYSTEM REAL-TIME DEBUG CONSOLE")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 200)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v9.page
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 8)
	uiCorner3.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local scrollingFrame4 = Instance.new("ScrollingFrame")
	scrollingFrame4.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame4.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame4.BackgroundColor3 = tbl6.input
	scrollingFrame4.BackgroundTransparency = 0.3
	scrollingFrame4.BorderSizePixel = 0
	scrollingFrame4.ScrollBarThickness = 6
	scrollingFrame4.ScrollBarImageColor3 = tbl6.primary
	scrollingFrame4.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame4.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame4.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame4.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame4.Parent = frame
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 6)
	uiCorner4.Parent = scrollingFrame4
	textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -10, 1, 0)
	textBox.Position = UDim2.new(0, 5, 0, 0)
	textBox.BackgroundTransparency = 1
	textBox.PlaceholderText = "-- System logs (INFO, WARN, ERROR, NETWORK) will stream live here..."
	textBox.Text = ""
	textBox.Font = Enum.Font.Code
	textBox.TextSize = 11
	textBox.TextColor3 = Color3.fromRGB(180, 255, 180)
	textBox.MultiLine = true
	textBox.ClearTextOnFocus = false
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.TextYAlignment = Enum.TextYAlignment.Top
	textBox.AutomaticSize = Enum.AutomaticSize.Y
	textBox.Parent = scrollingFrame4
end

local uiPadding2 = Instance.new("UIPadding")
uiPadding2.PaddingLeft = UDim.new(0, 4)
uiPadding2.PaddingTop = UDim.new(0, 4)
uiPadding2.Parent = textBox
local tbl12 = {}

for _, v15 in ipairs(tbl) do
	table.insert(tbl12, v15.Raw)
end

textBox.Text = table.concat(tbl12, "\n")
v9:AddSection("DEBUG CONSOLE UTILITIES")

v9:AddButton({
	Title = "🧹 Clear Debug Logs",
	Callback = function()
		table.clear(tbl)

		if textBox then
			textBox.Text = ""
		end

		fn2("INFO", "CONSOLE", "Debug console buffer cleared")
		tbl7:Notify({ Title = "Cleared", Content = "Debug log buffer cleared.", Duration = 2 })
	end,
})

v9:AddButton({
	Title = "📋 Copy Debug Logs to Clipboard",
	Callback = function()
		if textBox and textBox.Text ~= "" then
			if typeof(setclipboard) == "function" then
				pcall(function()
					setclipboard(textBox.Text)
				end)

				tbl7:Notify({ Title = "Copied", Content = "Copied debug console log to clipboard!", Duration = 3 })
			end
		else
			tbl7:Notify({ Title = "Warning", Content = "Debug log is empty!", Duration = 2 })
		end
	end,
})

v9:AddButton({
	Title = "💾 Save Debug Log to File",
	Callback = function()
		if #tbl > 0 then
			if typeof(makefolder) == "function" then
				pcall(function()
					makefolder("PAYOMBOYDumps")
				end)

				pcall(function()
					makefolder("PAYOMBOYDumps/DebugLogs")
				end)
			end

			local text3 = textBox.Text
			fn6("PAYOMBOYDumps/DebugLogs/SystemDebug_" .. os.date("%Y%m%d_%H%M%S") .. ".log", text3, "Debug Log")
		else
			tbl7:Notify({ Title = "Warning", Content = "No debug logs to save.", Duration = 2 })
		end
	end,
})

v2:AddSection("📚 GITHUB KNOWLEDGE ENGINE (DECISION SUPPORT)")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 75)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v2.page
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 8)
	uiCorner3.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(1, -16, 1, -12)
	textLabel4.Position = UDim2.new(0, 8, 0, 6)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Font = Enum.Font.Code
	textLabel4.TextSize = 11
	textLabel4.TextColor3 = Color3.fromRGB(0, 230, 180)
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.TextYAlignment = Enum.TextYAlignment.Top
	textLabel4.Parent = frame

	local function fn17()
		if textLabel4 and textLabel4.Parent then
			local str8 = tbl3.IsLoaded and "🟢 ONLINE" or "🟡 INITIALIZING / OFFLINE"
			local n2 = 0

			for k in pairs(tbl3.DocCache) do
				n2 += 1
			end

			textLabel4.Text = string.format([[GITHUB KNOWLEDGE RETRIEVAL LAYER:
• Status: %s
• Indexed Documents: %d entries (manifest.txt)
• Active Cache: %d loaded files
• Last Sync: %s]], str8, #tbl3.ManifestEntries, n2, tbl3.LastSyncTime)
		end
	end

	task.spawn(function()
		while task.wait(2) do
			if not (not textLabel4 or not textLabel4.Parent) then
				fn17()
				continue
			end
			break
		end
	end)

	v2:AddButton({
		Title = "🔄 Sync & Update GitHub Knowledge Base",
		Callback = function()
			tbl7:Notify({
				Title = "Knowledge Base",
				Content = "Fetching latest manifest and updating knowledge cache...",
				Duration = 3,
			})

			task.spawn(function()
				tbl3:Refresh()
				fn17()

				tbl7:Notify({
					Title = "Knowledge Base Updated",
					Content = string.format("Synced %d knowledge documents from GitHub!", #tbl3.ManifestEntries),
					Duration = 4,
				})
			end)
		end,
	})
end

v2:AddSection("AI CODE SYNTHESIZER")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 72)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v2.page
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 8)
	uiCorner3.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(1, -24, 0, 20)
	textLabel4.Position = UDim2.new(0, 12, 0, 8)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "ENTER SEMANTIC INTENT PROMPT (THAI / ENGLISH SUPPORTED)"
	textLabel4.TextColor3 = tbl6.textMuted
	textLabel4.Font = Enum.Font.GothamBold
	textLabel4.TextSize = 11
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.Parent = frame
	textBox2 = Instance.new("TextBox")
	textBox2.Size = UDim2.new(1, -24, 0, 34)
	textBox2.Position = UDim2.new(0, 12, 0, 30)
	textBox2.BackgroundColor3 = tbl6.input
	textBox2.BackgroundTransparency = 0.2
	textBox2.PlaceholderText = "เช่น 'อยากเขียนสคริปสั่งให้บิน', 'มองทะลุคน', 'อมตะ', 'ฟาร์ม', ' katana'"
	textBox2.Text = ""
	textBox2.Font = Enum.Font.GothamSemibold
	textBox2.TextSize = 12
	textBox2.TextColor3 = tbl6.cyan
	textBox2.ClearTextOnFocus = false
	textBox2.TextXAlignment = Enum.TextXAlignment.Left
	textBox2.Parent = frame
end

local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(0, 6)
uiCorner3.Parent = textBox2
local uiPadding3 = Instance.new("UIPadding")
uiPadding3.PaddingLeft = UDim.new(0, 10)
uiPadding3.Parent = textBox2
v2:AddSection("💡 QUICK THAI AI COMMANDS (กดสั่งงานทันที)")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 70)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v2.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.CellSize = UDim2.new(0.19, -3, 0, 26)
	uiGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
	uiGridLayout.Parent = frame
	local uiPadding4 = Instance.new("UIPadding")
	uiPadding4.PaddingTop = UDim.new(0, 6)
	uiPadding4.PaddingLeft = UDim.new(0, 6)
	uiPadding4.PaddingRight = UDim.new(0, 6)
	uiPadding4.PaddingBottom = UDim.new(0, 6)
	uiPadding4.Parent = frame

	for i, v15 in ipairs({
		{ Label = "✈️ สคริปต์บิน", Prompt = "อยากเขียนสคริปสั่งให้บิน" },
		{ Label = "👁️ มองทะลุคน", Prompt = "มองทะลุคน ESP" },
		{ Label = "⚡ วิ่งเร็ว/สปีด", Prompt = "วิ่งเร็ว สปีด speed" },
		{ Label = "🛡️ โหมดอมตะ", Prompt = "โหมดอมตะ godmode" },
		{ Label = "🤖 ออโต้ฟาร์ม", Prompt = "ออโต้ฟาร์ม ตีมอน เก็บของ" },
		{ Label = "🎯 ล็อกเป้าหัว", Prompt = "ล็อกเป้า ยิงหัว aimbot" },
		{ Label = "📦 ขยาย Hitbox", Prompt = "ขยายหัว hitbox ขยายเป้า" },
		{ Label = "🦘 โดดไม่จำกัด", Prompt = "กระโดดรัวๆ infinite jump" },
		{ Label = "⚔️ เสกดาบ", Prompt = "เสกดาบ katana" },
		{ Label = "🌐 ดักจับรีโมท", Prompt = "ดักจับรีโมท spy remote" },
	}) do
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundColor3 = Color3.fromRGB(14, 38, 24)
		textButton.Text = v15.Label
		textButton.TextColor3 = Color3.fromRGB(0, 230, 150)
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 9
		textButton.LayoutOrder = i
		textButton.Parent = frame
		local uiCorner5 = Instance.new("UICorner")
		uiCorner5.CornerRadius = UDim.new(0, 5)
		uiCorner5.Parent = textButton
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = tbl6.surfaceHover
		uiStroke.Thickness = 1
		uiStroke.Parent = textButton

		textButton.MouseButton1Click:Connect(function()
			fn5()
			textBox2.Text = v15.Prompt
			tbl7:Notify({ Title = "AI Command Selected", Content = "เลือกคำสั่ง: " .. v15.Label, Duration = 2 })
			fn7(v15.Prompt)
		end)
	end
end

do
	local v15 = v2:AddButton({
		Title = "⚡ Formulate Lexical Output Code (ประมวลผลคำสั่งไทย/อังกฤษ)",
		Callback = function()
			local text3 = textBox2.Text
			if not text3 or text3:gsub("%s+", "") == "" then
				tbl7:Notify({ Title = "Warning", Content = "กรุณากรอกคำสั่งหรือความต้องการก่อน!", Duration = 3 })
				return
			end
			fn7(text3)
		end,
	})

	v2:AddSection("COMPILED OUTPUT SOURCE CODE TERMINAL")
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 180)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v2.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local scrollingFrame4 = Instance.new("ScrollingFrame")
	scrollingFrame4.Size = UDim2.new(1, -12, 1, -12)
	scrollingFrame4.Position = UDim2.new(0, 6, 0, 6)
	scrollingFrame4.BackgroundColor3 = tbl6.input
	scrollingFrame4.BackgroundTransparency = 0.3
	scrollingFrame4.BorderSizePixel = 0
	scrollingFrame4.ScrollBarThickness = 6
	scrollingFrame4.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame4.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame4.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame4.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame4.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame4.Parent = frame
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 6)
	uiCorner5.Parent = scrollingFrame4
	textBox3 = Instance.new("TextBox")
	textBox3.Size = UDim2.new(1, -10, 1, 0)
	textBox3.Position = UDim2.new(0, 5, 0, 0)
	textBox3.BackgroundTransparency = 1
	textBox3.PlaceholderText = "-- Generated Luau semantic source output will display here..."
	textBox3.Text = ""
	textBox3.Font = Enum.Font.Code
	textBox3.TextSize = 11
	textBox3.TextColor3 = Color3.fromRGB(100, 230, 255)
	textBox3.MultiLine = true
	textBox3.ClearTextOnFocus = false
	textBox3.TextXAlignment = Enum.TextXAlignment.Left
	textBox3.TextYAlignment = Enum.TextYAlignment.Top
	textBox3.AutomaticSize = Enum.AutomaticSize.Y
	textBox3.Parent = scrollingFrame4
	local uiPadding4 = Instance.new("UIPadding")
	uiPadding4.PaddingLeft = UDim.new(0, 6)
	uiPadding4.PaddingTop = UDim.new(0, 6)
	uiPadding4.Parent = textBox3

	v2:AddButton({
		Title = "▶️ Execute Synthesized AI Script Now (รันโค้ด AI ทันที)",
		Style = "primary",
		Callback = function()
			fn5()
			local text3 = textBox3 and textBox3.Text or ""

			if text3:gsub("%s+", "") ~= "" then
				local match = text3:match("```(?:luau|lua)?%s*\n?(.-)\n?```")
				local chunk, v16 = loadstring(match or text3)

				if chunk then
					task.spawn(function()
						local ok, result = pcall(chunk)

						if not ok then
							fn2("ERROR", "AI_RUNTIME", tostring(result))
							tbl7:Notify({ Title = "Runtime Error", Content = "เกิดข้อผิดพลาดขณะรัน: " .. tostring(result), Duration = 5 })
						else
							fn2("INFO", "AI_RUNTIME", "AI script executed successfully.")
						end
					end)

					tbl7:Notify({
						Title = "AI Execution Success",
						Content = "เริ่มรันสคริปต์ AI ในแมพสำเร็จ!",
						Duration = 3,
					})
				elseif not match and not text3:find("game:") and not text3:find("local ") then
					tbl7:Notify({
						Title = "💬 AI Conversation",
						Content = "ข้อความนี้เป็นการสนทนา/คำแนะนำ ไม่ใช่โค้ดที่รันได้",
						Duration = 4,
					})
				else
					fn2("ERROR", "AI_SYNTAX", tostring(v16))
					tbl7:Notify({ Title = "Syntax Error", Content = "โค้ดมีข้อผิดพลาด: " .. tostring(v16), Duration = 5 })
				end
			else
				tbl7:Notify({ Title = "Warning", Content = "ยังไม่มีโค้ดในเทอร์มินัล! กรุณาประมวลผลก่อน", Duration = 3 })
			end
		end,
	})

	v2:AddButton({
		Title = "💾 Save Compiled Assets to Scroll Library & Preview (บันทึกข้ามระบบ)",
		Callback = function()
			fn5()
			local text3 = textBox3 and textBox3.Text or ""

			if text3 ~= "" then
				table.insert(SessionRegistry.Macros, {
					Name = "AI Compiled: " .. (textBox2 and textBox2.Text ~= "" and textBox2.Text or "Script_" .. os.date("%H%M%S")),
					Code = text3,
				})

				if populateLibraryScroll then
					pcall(populateLibraryScroll)
				end

				if fn12 then
					pcall(function()
						fn12(text3, "AI_Synthesized_Script")
					end)
				end

				tbl7:Notify({
					Title = "Asset Saved",
					Content = "บันทึกสคริปต์ลง Library และ Instance Dumper Preview เรียบร้อย!",
					Duration = 4,
				})
			else
				tbl7:Notify({ Title = "Warning", Content = "ไม่มีโค้ดให้บันทึก!", Duration = 3 })
			end
		end,
	})

	v15.MouseButton1Click:Connect(function()
		fn5()
		local text3 = textBox2 and textBox2.Text or ""
		if not text3 or text3:gsub("%s+", "") == "" then
			tbl7:Notify({ Title = "Warning", Content = "กรุณากรอกคำสั่งหรือความต้องการก่อน!", Duration = 3 })
			return
		end
		fn7(text3)
	end)
end

do
	local tbl13 = {
		SmartFarmActive = false,
		SmartFarmCleanup = nil,
		KillAuraActive = false,
		KillAuraThread = nil,
		AutoLootActive = false,
		AutoLootThread = nil,
		AutoClaimActive = false,
		AutoClaimThread = nil,
		AntiRagdollActive = false,
		AntiRagdollConn = nil,
		HitboxActive = false,
		HitboxOriginals = {},
	}

	v3:AddSection("🎮 GAME ARCHETYPE TELEMETRY & PRESET LOADER (โครงสร้างเกม)")
	local v15, v16 = tbl4:DetectGameArchetype()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 85)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v3.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.cyan
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(1, -20, 0, 22)
	textLabel4.Position = UDim2.new(0, 10, 0, 8)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "ตรวจพบโครงสร้างเกม: " .. v16
	textLabel4.TextColor3 = tbl6.cyan
	textLabel4.Font = Enum.Font.GothamBold
	textLabel4.TextSize = 13
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.Parent = frame
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(1, -20, 0, 18)
	textLabel5.Position = UDim2.new(0, 10, 0, 30)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "AI ตรวจสอบ PlaceId, ชื่อเกม, และ Remotes แล้ว — กดปุ่มด้านล่างเพื่อโหลดชุดสูตรสำเร็จ"
	textLabel5.TextColor3 = tbl6.textMuted
	textLabel5.Font = Enum.Font.Gotham
	textLabel5.TextSize = 10
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.Parent = frame
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(1, -20, 0, 26)
	textButton.Position = UDim2.new(0, 10, 0, 52)
	textButton.BackgroundColor3 = tbl6.primary
	textButton.Text = "🚀 โหลดและติดตั้ง Preset สำหรับเกมนี้ทันที (1-Click Apply)"
	textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 11
	textButton.Parent = frame
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 6)
	uiCorner5.Parent = textButton

	textButton.MouseButton1Click:Connect(function()
		fn5()
		local v17, v18 = tbl4:DetectGameArchetype()
		local str8

		if v17 == "PET_SIMULATOR" then
			str8 = "สุ่มเปิดไข่ออโต้และดูดเหรียญทั้งหมดในเกม"
		elseif v17 == "ANIME_ACTION_RPG" then
			str8 = "ออโต้ฟาร์มม็อบตีมอนสเตอร์รอบตัวลอยเหนือหัว"
		elseif v17 == "CLICKER_SIMULATOR" then
			str8 = "กดคลิกออโต้รัวๆและออโต้เกิดใหม่จุติ"
		elseif v17 == "RESOURCE_GATHERER" then
			str8 = "ออโต้ขุดแร่และตกปลาเก็บเกี่ยวทรัพยากร"
		else
			str8 = "ออโต้ฟาร์ม"

			if v17 == "OBBY_PLATFORMER" then
				str8 = "เดินทะลุกำแพงและกระโดดไม่จำกัด"
			end
		end

		fn7(str8)

		tbl7:Notify({
			Title = "🎯 Preset Applied",
			Content = "โหลดโครงสร้างสำเร็จสำหรับ: " .. v18 .. "\nสร้างและติดตั้งสคริปต์เรียบร้อย!",
			Duration = 5,
		})
	end)

	v3:AddSection("⚡ AUTONOMOUS SMART MACROS (ระบบมาโครอัจฉริยะ 1-CLICK)")

	local function createFrame(text3, text4, arg)
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, -10, 0, 56)
		frame2.BackgroundColor3 = tbl6.glassDeep
		frame2.BackgroundTransparency = 0.2
		frame2.BorderSizePixel = 0
		frame2.Parent = v3.page
		local uiCorner6 = Instance.new("UICorner")
		uiCorner6.CornerRadius = UDim.new(0, 8)
		uiCorner6.Parent = frame2
		local uiStroke2 = Instance.new("UIStroke")
		uiStroke2.Color = tbl6.glassBorder or Color3.fromRGB(32, 48, 72)
		uiStroke2.Thickness = 1
		uiStroke2.Parent = frame2
		local textLabel6 = Instance.new("TextLabel")
		textLabel6.Size = UDim2.new(1, -110, 0, 18)
		textLabel6.Position = UDim2.new(0, 12, 0, 8)
		textLabel6.BackgroundTransparency = 1
		textLabel6.Text = text3
		textLabel6.TextColor3 = tbl6.text
		textLabel6.Font = Enum.Font.GothamBold
		textLabel6.TextSize = 12
		textLabel6.TextXAlignment = Enum.TextXAlignment.Left
		textLabel6.Parent = frame2
		local textLabel7 = Instance.new("TextLabel")
		textLabel7.Size = UDim2.new(1, -110, 0, 16)
		textLabel7.Position = UDim2.new(0, 12, 0, 28)
		textLabel7.BackgroundTransparency = 1
		textLabel7.Text = text4
		textLabel7.TextColor3 = tbl6.textMuted
		textLabel7.Font = Enum.Font.Gotham
		textLabel7.TextSize = 10
		textLabel7.TextXAlignment = Enum.TextXAlignment.Left
		textLabel7.Parent = frame2
		local textButton2 = Instance.new("TextButton")
		textButton2.Size = UDim2.new(0, 80, 0, 28)
		textButton2.Position = UDim2.new(1, -92, 0.5, -14)
		textButton2.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		textButton2.Text = "🔴 OFF"
		textButton2.TextColor3 = Color3.fromRGB(200, 200, 210)
		textButton2.Font = Enum.Font.GothamBold
		textButton2.TextSize = 11
		textButton2.Parent = frame2
		local uiCorner7 = Instance.new("UICorner")
		uiCorner7.CornerRadius = UDim.new(0, 6)
		uiCorner7.Parent = textButton2
		local flag = false

		textButton2.MouseButton1Click:Connect(function()
			fn5()
			flag = not flag

			if flag then
				textButton2.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
				textButton2.Text = "🟢 ON"
				textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				textButton2.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
				textButton2.Text = "🔴 OFF"
				textButton2.TextColor3 = Color3.fromRGB(200, 200, 210)
			end

			arg(flag)
		end)

		return frame2
	end

	createFrame("🤖 Adaptive Smart Farm (ฟาร์มอัจฉริยะตามแมพ)", "เชื่อมต่อ Remotes และระบบเคลื่อนไหวอัตโนมัติตามประเภทเกมปัจจุบัน", function(smartFarmActive)
		tbl13.SmartFarmActive = smartFarmActive

		if smartFarmActive then
			local v17 = tbl4:SynthesizeScript("ออโต้ฟาร์ม")
			local chunk, v18 = loadstring(v17)

			if chunk then
				local ok, smartFarmCleanup = pcall(chunk)
				tbl13.SmartFarmCleanup = smartFarmCleanup

				tbl7:Notify({
					Title = "Smart Farm Active",
					Content = "Adaptive Auto-Farm is running in background!",
					Duration = 3,
				})
			else
				tbl7:Notify({ Title = "Error", Content = "Compilation error: " .. tostring(v18), Duration = 3 })
			end
		else
			if typeof(tbl13.SmartFarmCleanup) == "function" then
				pcall(tbl13.SmartFarmCleanup)
			end

			tbl7:Notify({ Title = "Smart Farm Stopped", Content = "Auto-farm stopped.", Duration = 2 })
		end
	end)

	createFrame("⚔️ 45-Stud Combat Kill-Aura (ออร่าโจมตีมอนสเตอร์)", "สแกนเป้าหมายระยะ 45 สตัด ถืออาวุธและยิงคำสั่งโจมตี/คลิกอัตโนมัติ", function(killAuraActive)
		tbl13.KillAuraActive = killAuraActive

		if killAuraActive then
			tbl13.KillAuraThread = task.spawn(function()
				local VirtualUser = game:GetService("VirtualUser")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")

				while tbl13.KillAuraActive do
					task.wait(0.1)
					local localPlayer = Players.LocalPlayer
					local character = localPlayer and localPlayer.Character
					local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")

					if humanoidRootPart and humanoid and humanoid.Health > 0 then
						local n2 = 45
						local v17 = nil

						for _, descendant in ipairs(workspace:GetDescendants()) do
							if descendant:IsA("Model") and descendant ~= character and not Players:GetPlayerFromCharacter(descendant) then
								local humanoid2 = descendant:FindFirstChildOfClass("Humanoid")
								local humanoidRootPart2 = descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")

								if humanoid2 and humanoid2.Health > 0 and humanoidRootPart2 then
									local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

									if magnitude < n2 then
										n2 = magnitude
										v17 = descendant
									end
								end
							end
						end

						if v17 then
							local tool = character:FindFirstChildOfClass("Tool") or localPlayer.Backpack and localPlayer.Backpack:FindFirstChildOfClass("Tool")

							if tool and tool.Parent ~= character then
								humanoid:EquipTool(tool)
							end

							if tool then
								tool:Activate()
							end

							pcall(function()
								VirtualUser:CaptureController()
								VirtualUser:Button1Down(Vector2.new(0, 0))
							end)

							pcall(function()
								local net = ReplicatedStorage:FindFirstChild("Net", true) or ReplicatedStorage
								local reRegisterAttack = net:FindFirstChild("RE/RegisterAttack", true) or net:FindFirstChild("RegisterAttack", true) or net:FindFirstChild("Attack", true)

								if reRegisterAttack and reRegisterAttack:IsA("RemoteEvent") then
									reRegisterAttack:FireServer(0)
								end
							end)
						end
					end
				end
			end)

			tbl7:Notify({ Title = "Kill-Aura Active", Content = "45-Stud Combat Kill-Aura enabled!", Duration = 3 })
		else
			if tbl13.KillAuraThread then
				pcall(function()
					task.cancel(tbl13.KillAuraThread)
				end)
			end

			tbl7:Notify({ Title = "Kill-Aura Stopped", Content = "Combat Kill-Aura paused.", Duration = 2 })
		end
	end)

	createFrame("🧲 Auto-Loot Drops & Prompts (ดูดเหรียญ & กด E ทุกจุด)", "เปิด ProximityPrompt และเก็บเหรียญ/กล่องดรอปรัศมี 300 สตัดอัตโนมัติ", function(autoLootActive)
		tbl13.AutoLootActive = autoLootActive

		if autoLootActive then
			tbl13.AutoLootThread = task.spawn(function()
				while tbl13.AutoLootActive do
					task.wait(0.2)
					local localPlayer = Players.LocalPlayer
					local humanoidRootPart = localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						for _, descendant in ipairs(workspace:GetDescendants()) do
							if descendant:IsA("ProximityPrompt") and descendant.Enabled then
								local basePart = descendant:FindFirstAncestorWhichIsA("BasePart") or descendant.Parent

								if basePart and basePart:IsA("BasePart") and (humanoidRootPart.Position - basePart.Position).Magnitude < 30 then
									pcall(fireproximityprompt, descendant, 0)
								end
							end
						end

						for _, v17 in ipairs({ "Coins", "Drops", "Chests", "Diamonds", "Gems", "RecyclerCoins" }) do
							local v18 = workspace:FindFirstChild(v17)

							if v18 then
								for _, child in ipairs(v18:GetChildren()) do
									local isBasePart = child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart")

									if isBasePart and (humanoidRootPart.Position - isBasePart.Position).Magnitude < 250 then
										pcall(function()
											firetouchinterest(humanoidRootPart, isBasePart, 0)
											firetouchinterest(humanoidRootPart, isBasePart, 1)
										end)
									end
								end
							end
						end
					end
				end
			end)

			tbl7:Notify({
				Title = "Auto-Loot Active",
				Content = "Auto prompt trigger & item magnet enabled!",
				Duration = 3,
			})
		else
			if tbl13.AutoLootThread then
				pcall(function()
					task.cancel(tbl13.AutoLootThread)
				end)
			end

			tbl7:Notify({ Title = "Auto-Loot Stopped", Content = "Auto-loot paused.", Duration = 2 })
		end
	end)

	createFrame("🎁 Auto-Claim All Rewards & Quests (รับรางวัล & เควสทั้งหมด)", "สแกน Remotes ใน ReplicatedStorage และกดรับรางวัลประจำวัน/เควสทุก 20 วินาที", function(autoClaimActive)
		tbl13.AutoClaimActive = autoClaimActive

		if autoClaimActive then
			tbl13.AutoClaimThread = task.spawn(function()
				while tbl13.AutoClaimActive do
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local tbl14 = { "claim", "reward", "gift", "daily", "chest", "quest", "spin", "free" }

					for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
						local str8 = descendant.Name:lower()

						for _, v17 in ipairs(tbl14) do
							if str8:find(v17, 1, true) then
								if descendant:IsA("RemoteEvent") then
									pcall(function()
										descendant:FireServer()
									end)

									pcall(function()
										descendant:FireServer(1)
									end)
								elseif descendant:IsA("RemoteFunction") then
									pcall(function()
										descendant:InvokeServer()
									end)
								end

								break
							end
						end
					end

					task.wait(20)
				end
			end)

			tbl7:Notify({
				Title = "Auto-Claim Active",
				Content = "Auto-claim loop running every 20 seconds.",
				Duration = 3,
			})
		else
			if tbl13.AutoClaimThread then
				pcall(function()
					task.cancel(tbl13.AutoClaimThread)
				end)
			end

			tbl7:Notify({ Title = "Auto-Claim Stopped", Content = "Auto-claim stopped.", Duration = 2 })
		end
	end)

	createFrame("🛡️ Anti-Ragdoll & Stun Shield (กันล้ม / สตั๊น / สลบ)", "ตัดสถานะ Ragdoll, FallingDown, PlatformStanding ป้องกันการถูกสตั๊นหรือผลักล้ม", function(antiRagdollActive)
		tbl13.AntiRagdollActive = antiRagdollActive

		if antiRagdollActive then
			local localPlayer = Players.LocalPlayer
			localPlayer = localPlayer and localPlayer.Character
			local humanoid = localPlayer and localPlayer:FindFirstChildOfClass("Humanoid")

			if humanoid then
				tbl13.AntiRagdollConn = humanoid.StateChanged:Connect(function(old, new)
					if not tbl13.AntiRagdollActive then
						return
					end

					if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.PlatformStanding then
						humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end
				end)
			end

			tbl7:Notify({ Title = "Shield Active", Content = "Anti-Ragdoll & Stun Shield armed!", Duration = 3 })
		else
			if tbl13.AntiRagdollConn then
				pcall(function()
					tbl13.AntiRagdollConn:Disconnect()
				end)
			end

			tbl7:Notify({ Title = "Shield Disabled", Content = "Anti-Ragdoll shield disabled.", Duration = 2 })
		end
	end)

	createFrame("📦 Universal Hitbox Expander (ขยายเป้าศัตรู 22 สตัด)", "ขยายขนาด HumanoidRootPart ของศัตรู/ผู้เล่นอื่นเป็น 22 สตัดเพื่อตีโดนง่ายขึ้น", function(hitboxActive)
		tbl13.HitboxActive = hitboxActive

		if hitboxActive then
			if Players.LocalPlayer then
			end

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= Players.LocalPlayer and player.Character then
					local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart and not tbl13.HitboxOriginals[humanoidRootPart] then
						tbl13.HitboxOriginals[humanoidRootPart] = { Size = humanoidRootPart.Size, Transparency = humanoidRootPart.Transparency, CanCollide = humanoidRootPart.CanCollide }
						humanoidRootPart.Size = Vector3.new(22, 22, 22)
						humanoidRootPart.Transparency = 0.65
						humanoidRootPart.BrickColor = BrickColor.new("Really blue")
						humanoidRootPart.Material = Enum.Material.Neon
						humanoidRootPart.CanCollide = false
					end
				end
			end

			tbl7:Notify({ Title = "Hitbox Expanded", Content = "Hitboxes expanded to 22 studs!", Duration = 3 })
		else
			for k, hitboxOriginal in pairs(tbl13.HitboxOriginals) do
				if k and k.Parent then
					pcall(function()
						k.Size = hitboxOriginal.Size
						k.Transparency = hitboxOriginal.Transparency
						k.CanCollide = hitboxOriginal.CanCollide
					end)
				end
			end

			table.clear(tbl13.HitboxOriginals)
			tbl7:Notify({ Title = "Hitbox Restored", Content = "Original hitboxes restored.", Duration = 2 })
		end
	end)
end

do
	local tbl13 = {
		Macros = {
			{
				Name = "Sempshark Open HTTP Traffic Inspector",
				Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Sempiller/SempShark/refs/heads/main/main.lua'))()",
			},
			{
				Name = "AXIOS Multiply By Delta",
				Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/UI_LimbExtender.lua'))()",
			},
			{
				Name = "PayomboyZ Anime Card Farm",
				Code = "loadstring(game:HttpGet('https://payomboyz333.github.io/Anime-Card-Farm/'))()",
			},
			{
				Name = "Dex++ Debug Explorer",
				Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Payomboyz0028/Yaranikaaaa/refs/heads/main/AI/Dex%2B%2B%20Debug'))()",
			},
			{
				Name = "Infinite Yield Admin Tools",
				Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()",
			},
		},
	}

	local fn17 = nil
	v10:AddSection("MOUNTED MICRO MODULES LIBRARY")
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 320)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v10.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local scrollingFrame4 = Instance.new("ScrollingFrame")
	scrollingFrame4.Size = UDim2.new(1, -16, 1, -16)
	scrollingFrame4.Position = UDim2.new(0, 8, 0, 8)
	scrollingFrame4.BackgroundTransparency = 1
	scrollingFrame4.BorderSizePixel = 0
	scrollingFrame4.ScrollBarThickness = 4
	scrollingFrame4.ScrollBarImageColor3 = tbl6.cyan
	scrollingFrame4.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.Parent = scrollingFrame4

	uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollingFrame4.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y / math.max(v.UIScale.Scale, 0.1) + 10)
	end)

	fn17 = function()
		for _, child in ipairs(scrollingFrame4:GetChildren()) do
			if child:IsA("Frame") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end

		if #tbl13.Macros == 0 then
			local textLabel4 = Instance.new("TextLabel")
			textLabel4.Size = UDim2.new(1, 0, 0, 40)
			textLabel4.BackgroundTransparency = 1
			textLabel4.Text = "No saved modules in library yet."
			textLabel4.TextColor3 = tbl6.textMuted
			textLabel4.Font = Enum.Font.Gotham
			textLabel4.TextSize = 12
			textLabel4.Parent = scrollingFrame4
			return
		end

		for i, macro in ipairs(tbl13.Macros) do
			local frame2 = Instance.new("Frame")
			frame2.Size = UDim2.new(1, -6, 0, 42)
			frame2.BackgroundColor3 = tbl6.surface
			frame2.BackgroundTransparency = 0.2
			frame2.Parent = scrollingFrame4
			local uiCorner5 = Instance.new("UICorner")
			uiCorner5.CornerRadius = UDim.new(0, 6)
			uiCorner5.Parent = frame2
			local textLabel4 = Instance.new("TextLabel")
			textLabel4.Size = UDim2.new(1, -140, 1, 0)
			textLabel4.Position = UDim2.new(0, 12, 0, 0)
			textLabel4.BackgroundTransparency = 1
			textLabel4.Text = "⚡ " .. macro.Name
			textLabel4.TextColor3 = tbl6.text
			textLabel4.Font = Enum.Font.GothamBold
			textLabel4.TextSize = 12
			textLabel4.TextXAlignment = Enum.TextXAlignment.Left
			textLabel4.Parent = frame2
			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.fromOffset(60, 26)
			textButton.Position = UDim2.new(1, -130, 0.5, -13)
			textButton.BackgroundColor3 = tbl6.primary
			textButton.Text = "▶ Run"
			textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			textButton.Font = Enum.Font.GothamBold
			textButton.TextSize = 11
			textButton.Parent = frame2
			local uiCorner6 = Instance.new("UICorner")
			uiCorner6.CornerRadius = UDim.new(0, 4)
			uiCorner6.Parent = textButton

			textButton.MouseButton1Click:Connect(function()
				fn5()
				local chunk = loadstring(macro.Code)

				if chunk then
					task.spawn(chunk)
					tbl7:Notify({ Title = "Execution Success", Content = "Module executed: " .. macro.Name, Duration = 3 })
				else
					local localScript = Instance.new("LocalScript")
					localScript.Source = macro.Code
					localScript.Disabled = false
					localScript.Parent = game.Players.LocalPlayer.Character or game.Workspace
					task.wait(0.1)
					localScript:Destroy()
					tbl7:Notify({ Title = "Executed", Content = "Module attached to character.", Duration = 3 })
				end
			end)

			local textButton2 = Instance.new("TextButton")
			textButton2.Size = UDim2.fromOffset(60, 26)
			textButton2.Position = UDim2.new(1, -65, 0.5, -13)
			textButton2.BackgroundColor3 = tbl6.surfacePressed
			textButton2.Text = "🗑 Del"
			textButton2.TextColor3 = tbl6.danger
			textButton2.Font = Enum.Font.GothamBold
			textButton2.TextSize = 11
			textButton2.Parent = frame2
			local uiCorner7 = Instance.new("UICorner")
			uiCorner7.CornerRadius = UDim.new(0, 4)
			uiCorner7.Parent = textButton2

			textButton2.MouseButton1Click:Connect(function()
				fn5()
				table.remove(tbl13.Macros, i)
				fn17()
				tbl7:Notify({ Title = "Removed", Content = "Deleted module: " .. macro.Name, Duration = 3 })
			end)
		end
	end

	fn17()

	v10.btn.MouseButton1Click:Connect(function()
		fn17()
	end)
end

local v15, scrollingFrame4, textBox6, textLabel4, str8, str9, flag, fn17, fn18, fn19
local fn20, fn21, fn22

do
	local flag2 = false
	local flag3 = false
	v15 = nil
	local v16 = nil
	local tbl13 = {}
	local n2 = 1
	scrollingFrame4 = nil
	textBox6 = nil
	textLabel4 = nil
	str8 = ""
	str9 = ""
	flag = false

	fn17 = function(arg)
		local ok, result = pcall(function()
			if typeof(game.HttpGet) == "function" then
				return game:HttpGet(arg)
			end

			if typeof(http_request or request or syn and syn.request) == "function" then
				local v17 = (http_request or request or syn.request)({ Url = arg, Method = "GET" })
				return v17.Body or v17.body
			end
			return nil
		end)

		if ok and result and typeof(result) == "string" and #result > 0 then
			return result
		end
		return nil, "Failed to fetch from URL"
	end

	fn18 = function(arg, arg2)
		if not arg then
			return
		end
		local str10 = tostring(arg2 or "")
		local text3

		if #str10 > 185000 then
			text3 = str10:sub(1, 185000) .. "\n-- [Truncated: Code exceeds 185KB Roblox TextBox limit]"
		else
			text3 = str10
		end

		arg.Text = text3
	end

	fn19 = function(arg)
		if not arg or #arg == 0 then
			return "Empty"
		end
		local v17 = string.lower(arg)
		if string.find(arg, "LPH_") or string.find(arg, "Luraph") or string.find(arg, "Luraph") then
			return "Luraph (LPH) Virtual Machine"
		end

		if string.find(arg, "}:K%(") or string.find(arg, "a%.F%[") or string.find(arg, "a%:G%(") or string.find(arg, "a%:H%(") then
			return "Topsniper Virtual Machine (Custom Control Flow VM)"
		end

		if string.find(v17, "moonsec") or string.find(arg, "LUA_ENVIRONMENT") then
			return "Moonsec Virtual Machine"
		end

		if string.find(arg, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ") then
			return "Topsniper / Base85 Custom VM"
		end

		if string.find(v17, "bit32") and (string.find(v17, "stk") or string.find(v17, "inst")) then
			return "PSU / IronBrew Virtual Machine"
		end

		if string.find(v17, "prometheus") or string.find(arg, "__PROMETHEUS__") then
			return "Prometheus Obfuscator"
		end

		if string.find(v17, "xen") or string.find(arg, "XenVM") then
			return "Xen Virtual Machine"
		end

		if string.find(arg, "string.char") then
			return "Byte Array / Char Encoded"
		end

		if string.find(arg, "\\%d%d%d\\%d%d%d") or string.find(arg, "\\x%x%x\\x%x%x") then
			return "Hex/Decimal Escaped Stream"
		end
		return "Custom / Generic Luau Script"
	end

	local function fn23(arg)
		local tbl14 = {}
		local tbl15 = {}
		local tbl16 = {}
		local tbl17 = {}
		local tbl18 = {}

		local function fn24(arg2)
			if not arg2 or typeof(arg2) ~= "string" then
				return
			end
			local str10 = arg2:gsub("^%s*(.-)%s*$", "%1")
			if #str10 < 2 or #str10 > 1000 or tbl18[str10] then
				return
			end
			tbl18[str10] = true
			table.insert(tbl17, str10)

			if str10:find("^https?://") or str10:find("discord%.com/api/webhooks") or str10:find("pastebin%.com") or str10:find("githubusercontent%.com") then
				table.insert(tbl14, str10)
			elseif str10:find("Remote") or str10:find("Event") or str10:find("Function") or str10:find("Attack") or str10:find("Hit") or str10:find("Combat") or str10:find("Damage") or str10:find("Coin") then
				table.insert(tbl15, str10)
			elseif str10 == "Players" or str10 == "Workspace" or str10 == "ReplicatedStorage" or str10 == "HttpService" or str10 == "TweenService" or str10 == "RunService" or str10 == "UserInputService" or str10 == "CoreGui" then
				table.insert(tbl16, str10)
			end
		end

		for match in string.gmatch(arg, "\"([^\"\\]+)\"") do
			fn24(match)
		end

		for match in string.gmatch(arg, "'([^'\\]+)'") do
			fn24(match)
		end

		local v17 = loadstring or load

		if v17 then
			local v18 = v17(arg) or v17("return (" .. arg .. ")")

			if v18 and typeof(v18) == "function" then
				local tbl19 = {}
				local fn25 = nil

				fn25 = function(arg2, arg3)
					if arg3 > 5 or tbl19[arg2] then
						return
					end
					tbl19[arg2] = true
					local getconstants_ = debug and debug.getconstants or getconstants

					if typeof(getconstants_) == "function" then
						pcall(function()
							for _, v19 in ipairs(getconstants_(arg2)) do
								if typeof(v19) == "string" then
									fn24(v19)
								end
							end
						end)
					end

					local getupvalues_ = debug and debug.getupvalues or getupvalues

					if typeof(getupvalues_) == "function" then
						pcall(function()
							for _, v19 in pairs(getupvalues_(arg2)) do
								if typeof(v19) == "string" then
									fn24(v19)
								elseif typeof(v19) == "table" then
									local n3 = 0

									for k, v20 in pairs(v19) do
										n3 += 1

										if not (n3 > 300) then
											if typeof(k) == "string" then
												fn24(k)
											end

											if typeof(v20) == "string" then
												fn24(v20)
											end

											continue
										end

										break
									end
								elseif typeof(v19) == "function" then
									fn25(v19, arg3 + 1)
								end
							end
						end)
					end

					local getprotos_ = debug and debug.getprotos or getprotos

					if typeof(getprotos_) == "function" then
						pcall(function()
							for _, v19 in ipairs(getprotos_(arg2)) do
								fn25(v19, arg3 + 1)
							end
						end)
					end
				end

				pcall(function()
					fn25(v18, 1)
				end)
			end
		end

		return tbl14, tbl15, tbl16, tbl17
	end

	fn20 = function(arg, arg2)
		local n3 = arg2 or 3500
		local tbl14 = {}
		local tbl15 = {}
		local tbl16 = {}
		local tbl17 = {}
		local n4 = 0

		local function fn24(arg3)
			n4 += 1

			if n4 <= n3 then
				table.insert(tbl14, arg3)
			elseif n4 == n3 + 1 then
				table.insert(tbl14, string.format("[TRUNCATED] Reached maximum event buffer limit (%d events)", n3))
			end
		end

		local function fn25(arg3)
			if typeof(arg3) == "string" and #arg3 >= 2 and not tbl17[arg3] then
				tbl17[arg3] = true
				table.insert(tbl15, arg3)
			end
		end

		local bit32_ = bit32

		if not bit32_ and typeof(bit) == "table" then
			bit32_ = {
				band = bit.band,
				bor = bit.bor,
				bxor = bit.bxor,
				bnot = bit.bnot,
				lshift = bit.lshift,
				rshift = bit.rshift,
				arshift = bit.arshift,
				rol = bit.rol,
				ror = bit.ror,
				btest = bit.btest,
				extract = bit.extract,
				replace = bit.replace,
			}
		end

		local sub = string.sub
		local char = string.char
		local byte = string.byte
		local gsub = string.gsub
		local concat = table.concat
		local string_ = {}

		for k, v17 in pairs(string) do
			string_[k] = v17
		end

		string_.sub = function(arg3, arg4, arg5)
			local v17 = sub(arg3, arg4, arg5)

			if typeof(arg3) == "string" and #arg3 > 20 and #v17 > 1 then
				fn24("[STR] sub: " .. tostring(v17))
				fn25(v17)
			end

			return v17
		end

		string_.char = function(...)
			local v17 = table.pack(...)
			local tbl18 = { ... }
			local v18 = char(table.unpack(v17, 1, v17.n))

			if #tbl18 > 0 then
				fn24("[STR] char: " .. tostring(v18))
				fn25(v18)
			end

			return v18
		end

		string_.byte = function(arg3, arg4, arg5)
			local v17 = byte(arg3, arg4, arg5)

			if typeof(arg3) == "string" and #arg3 > 20 then
				fn24("[BYTE] from: " .. sub(arg3, 1, 30) .. " = " .. tostring(v17))
			end

			return v17
		end

		string_.gsub = function(arg3, arg4, arg5, arg6)
			local v17 = gsub(arg3, arg4, arg5, arg6)

			if typeof(arg3) == "string" and #arg3 > 15 then
				fn24("[GSUB] " .. sub(arg3, 1, 40) .. " -> " .. sub(v17, 1, 40))
				fn25(v17)
			end

			return v17
		end

		local table_ = {}

		for k, v17 in pairs(table) do
			table_[k] = v17
		end

		table_.concat = function(arg3, arg4, arg5, arg6)
			local v17 = concat(arg3, arg4, arg5, arg6)

			if typeof(v17) == "string" and #v17 > 5 then
				fn24("[CONCAT] " .. tostring(v17))
				fn25(v17)
			end

			return v17
		end

		local tbl18 = {}

		for k, v17 in pairs(_G) do
			tbl18[k] = v17
		end

		if typeof(getgenv) == "function" then
			for k, v17 in pairs(getgenv()) do
				tbl18[k] = v17
			end
		end

		tbl18.string = string_
		tbl18.table = table_

		if bit32_ then
			tbl18.bit32 = bit32_
		end

		tbl18.load = function(arg3, arg4, arg5, arg6)
			if typeof(arg3) == "string" and #arg3 > 50 then
				fn24("\n[LOAD] Chunk detected (" .. #arg3 .. " bytes):")
				fn24(sub(arg3, 1, 350))
				fn24("")
				table.insert(tbl16, arg3)
			end

			return (loadstring or load)(arg3, arg4, arg5, arg6)
		end

		tbl18.loadstring = tbl18.load

		tbl18.pcall = function(arg3, ...)
			local v17 = pcall
			local v18 = table.pack(...)
			v18.n = 2 + v18.n - 1
			table.move(v18, 1, v18.n, 2, v18)
			v18[1] = arg3
			local v19, v20 = v17(table.unpack(v18, 1, v18.n))

			if not v19 then
				fn24("[ERROR] " .. tostring(v20))
			end

			return v19, v20
		end

		fn24("=== Hook installed. Loading target script... ===")
		fn24("Running: Target VM Payload (" .. string.format("%.2f KB", #arg / 1024) .. ")")
		fn24("")
		local v17 = loadstring or load
		local v18, v19 = v17(arg)

		if not v18 then
			v18, v19 = v17("return (" .. arg .. ")")
		end

		if v18 and typeof(v18) == "function" then
			if typeof(setfenv) == "function" then
				pcall(function()
					setfenv(v18, tbl18)
				end)
			end

			local ok, result = pcall(v18)

			if ok then
				fn24("\n=== Script evaluation completed ===")

				if result ~= nil then
					fn24("Result type: " .. typeof(result))

					if typeof(result) == "table" then
						local tbl19 = {}

						for k in pairs(result) do
							table.insert(tbl19, tostring(k))
							if not (#tbl19 > 25) then
								continue
							end
							break
						end

						fn24("Exported Table Keys: " .. table.concat(tbl19, ", "))
					elseif typeof(result) == "string" then
						fn24("Evaluated String: " .. result:sub(1, 120))
						fn25(result)
					end
				end
			else
				fn24("\n=== Script error (trapped): " .. tostring(result) .. " ===")
			end
		else
			fn24("Failed to load: " .. tostring(v19))
		end

		fn24("")
		fn24("=== Deobfuscation trace finished. Total strings captured: " .. #tbl15 .. " ===")
		return tbl14, tbl15, tbl16
	end

	local function fn24(arg, arg2)
		local n3 = arg2 or 1500
		local tbl14 = {}
		local tbl15 = {}
		local n4 = 0

		local function fn25()
			n4 += 1
			return "v" .. n4
		end

		local index = {}
		index.__index = index

		local function fn26(arg3)
			return setmetatable({ _repr = arg3 }, index)
		end

		index.__tostring = function(arg3)
			return arg3._repr
		end

		index.__index = function(arg3, arg4)
			local str10 = tostring(arg4)
			if str10:match("^[%a_][%w_]*$") then
				return fn26(arg3._repr .. "." .. str10)
			end
			return fn26(string.format("%s[%q]", arg3._repr, str10))
		end

		index.__newindex = function(arg3, arg4, arg5)
			local repr = typeof(arg5) == "table" and arg5._repr or typeof(arg5) == "string" and string.format("%q", arg5) or tostring(arg5)
			local str10 = tostring(arg4)
			table.insert(tbl14, string.format("%s = %s", str10:match("^[%a_][%w_]*$") and arg3._repr .. "." .. str10 or string.format("%s[%q]", arg3._repr, str10), repr))
		end

		index.__call = function(arg3, ...)
			local tbl16 = {}

			for _, v17 in ipairs({ ... }) do
				if typeof(v17) == "table" and v17._repr then
					table.insert(tbl16, v17._repr)
				elseif typeof(v17) == "string" then
					table.insert(tbl16, string.format("%q", v17))
				else
					table.insert(tbl16, tostring(v17))
				end
			end

			local str10 = string.format("%s(%s)", arg3._repr, table.concat(tbl16, ", "))
			local v17 = fn25()
			table.insert(tbl14, string.format("local %s = %s", v17, str10))
			return fn26(v17)
		end

		local n5 = 0

		local obj = setmetatable({}, {
			__index = function(arg3, arg4)
				n5 += 1

				if n3 < n5 then
					error("[Tracer] Max execution trace limit reached")
				end

				if arg4 == "game" then
					return fn26("game")
				end

				if arg4 == "workspace" then
					return fn26("workspace")
				end

				if arg4 == "script" then
					return fn26("script")
				end

				if arg4 == "print" or arg4 == "warn" or arg4 == "error" then
					return function(...)
						local tbl16 = {}

						for _, v17 in ipairs({ ... }) do
							table.insert(tbl16, typeof(v17) == "table" and v17._repr or tostring(v17))
						end

						table.insert(tbl14, string.format("%s(%s)", arg4, table.concat(tbl16, ", ")))
					end
				end

				if arg4 == "loadstring" or arg4 == "load" then
					return function(arg5)
						table.insert(tbl14, "-- [[ DYNAMIC LOADSTRING PAYLOAD INTERCEPTED ]]")
						table.insert(tbl15, tostring(arg5))

						return function()
						end
					end
				end

				local v17 = _G[arg4] or getgenv and getgenv()[arg4]
				if v17 ~= nil then
					return v17
				end
				return fn26(tostring(arg4))
			end,
			__newindex = function(arg3, arg4, arg5)
				local repr = typeof(arg5) == "table" and arg5._repr or typeof(arg5) == "string" and string.format("%q", arg5) or tostring(arg5)
				table.insert(tbl14, string.format("%s = %s", tostring(arg4), repr))
			end,
		})

		local v17 = loadstring or load

		if v17 then
			local v18 = v17(arg) or v17("return (" .. arg .. ")")

			if v18 and typeof(v18) == "function" then
				pcall(function()
					if typeof(setfenv) == "function" then
						setfenv(v18, obj)
					end

					local v19 = v18()

					if typeof(v19) == "string" then
						table.insert(tbl14, "-- Evaluated String: " .. v19:sub(1, 100))
					end
				end)
			end
		end

		return tbl14, tbl15
	end

	fn21 = function(arg)
		if not arg or arg == "" then
			return "-- [Deobfuscator] Empty payload", ""
		end
		local v17 = fn19(arg)
		local payomboyZSubport = getgenv().PayomboyZ_Subport or _G.PayomboyZ_Subport

		if payomboyZSubport and payomboyZSubport.Deobfuscator and payomboyZSubport.Deobfuscator.AnalyzeBytecodeConstants then
			local v18 = payomboyZSubport.Deobfuscator.AnalyzeBytecodeConstants(arg)
			local v19, v20, v21 = payomboyZSubport.Deobfuscator.SafeDynamicTrace(arg, { MaxSteps = 3000, MaxLogs = 1200 })
			local urls = v18.Urls
			local remotes = v18.Remotes
			local services = v18.Services
			local constants = v18.Constants
			local tbl14 = {}

			for _, constant in ipairs(constants) do
				tbl14[constant] = true
			end

			for _, v22 in ipairs(v20) do
				if not tbl14[v22] then
					tbl14[v22] = true
					table.insert(constants, v22)
					local str10 = v22:lower()

					if v22:find("^https?://") or str10:find("discord%.com/api/webhooks") then
						table.insert(urls, v22)
					elseif str10:find("remote") or str10:find("event") or str10:find("attack") or str10:find("combat") then
						table.insert(remotes, v22)
					end
				end
			end

			local tbl15 = {}

			local function fn25(arg2)
				table.insert(tbl15, arg2 or "")
			end

			fn25("-- ======================================================================================")
			fn25("-- [[ 🔓 PAYOMBOYZ DEOBFUSCATOR V9.0: DECOMPILED & RECONSTRUCTED SOURCE ]]--")
			fn25(string.format("-- Obfuscator Classification: %s", v17))
			fn25("-- Analysis Engine: PayomboyZ Subport V9.0 (Dex++ Architecture Integrated)")
			fn25(string.format("-- Telemetry: %d Decrypted Constants | %d Payloads | %d Endpoints | %d Remotes", #constants, #v21, #urls, #remotes))
			fn25("-- ======================================================================================\n")

			if #urls > 0 then
				fn25("-- [[ 🌐 DETECTED NETWORK ENDPOINTS & WEBHOOKS ]]")

				for i, url in ipairs(urls) do
					fn25(string.format("local URL_%d = %q", i, url))
				end

				fn25("")
			end

			if #services > 0 or #remotes > 0 then
				fn25("-- [[ 📡 TARGETED ROBLOX SERVICES & REMOTES ]]")

				for _, service in ipairs(services) do
					fn25(string.format("local %s = game:GetService(%q)", service, service))
				end

				for i, remote in ipairs(remotes) do
					fn25(string.format("local Remote_%d = %q", i, remote))
				end

				fn25("")
			end

			if #v21 > 0 then
				fn25("-- [[ 🚀 EXTRACTED INNER DYNAMIC CHUNKS (FROM LOADSTRING) ]]")

				for i, v22 in ipairs(v21) do
					fn25(string.format("-- --- SUB-PAYLOAD CHUNK [%d] (%d bytes) ---", i, #v22))
					fn25(v22)
					fn25("")
				end
			end

			if #constants > 0 then
				fn25("-- [[ 📦 DECRYPTED CONSTANT POOL (FIRST 150) ]]")
				fn25("local Constants = {")

				for i = 1, math.min(150, #constants) do
					fn25(string.format("    [%d] = %q,", i, constants[i]))
				end

				if #constants > 150 then
					fn25(string.format("    -- ... (%d more string constants omitted)", #constants - 150))
				end

				fn25("}\n")
			end

			local concat = table.concat
			return table.concat(tbl15, "\n"), concat(v19, "\n")
		end

		local v18, v19, v20, v21 = fn23(arg)
		local v22, v23 = fn24(arg)
		local v24, v25, v26 = fn20(arg)

		for _, v27 in ipairs(v25) do
			if v27:find("^https?://") or v27:find("discord%.com/api/webhooks") then
				table.insert(v18, v27)
			elseif v27:find("Remote") or v27:find("Event") or v27:find("Function") or v27:find("Attack") or v27:find("Hit") or v27:find("Combat") then
				table.insert(v19, v27)
			end

			table.insert(v21, v27)
		end

		for _, v27 in ipairs(v26) do
			table.insert(v23, v27)
		end

		local function fn25(arg2)
			local tbl14 = {}
			local tbl15 = {}

			for _, v27 in ipairs(arg2) do
				if not tbl15[v27] then
					tbl15[v27] = true
					table.insert(tbl14, v27)
				end
			end

			return tbl14
		end

		local v27 = fn25(v18)
		local v28 = fn25(v19)
		local v29 = fn25(v20)
		local v30 = fn25(v21)
		local tbl14 = {}

		local function fn26(arg2)
			table.insert(tbl14, arg2 or "")
		end

		fn26("-- ======================================================================================")
		fn26("-- [[ 🔓 PAYOMBOYZ DEOBFUSCATOR V9.0: RECONSTRUCTED LUAU SOURCE CODE ]]--")
		fn26(string.format("-- Obfuscator Classification: %s", v17))
		fn26("-- Analysis Engine: Safe Dynamic Sandboxed VM Devirtualizer (Anti-Hang Active)")
		fn26(string.format("-- Telemetry: %d Traced Statements | %d Hooked Strings | %d Intercepted Chunks", #v22, #v25, #v23))
		fn26("-- ======================================================================================\n")

		if #v27 > 0 then
			fn26("-- [[ 🌐 DETECTED NETWORK ENDPOINTS & WEBHOOKS ]]")

			for i, v31 in ipairs(v27) do
				fn26(string.format("local URL_%d = %q", i, v31))
			end

			fn26("")
		end

		if #v28 > 0 or #v29 > 0 then
			fn26("-- [[ 📡 TARGETED ROBLOX SERVICES & REMOTES ]]")

			for _, v31 in ipairs(v29) do
				fn26(string.format("local %s = game:GetService(%q)", v31, v31))
			end

			for i, v31 in ipairs(v28) do
				fn26(string.format("local Remote_%d = %q", i, v31))
			end

			fn26("")
		end

		if #v22 > 0 then
			fn26("-- [[ ⚡ RECONSTRUCTED STATEMENTS ]]")

			for _, v31 in ipairs(v22) do
				fn26(v31)
			end

			fn26("")
		end

		if #v23 > 0 then
			fn26("-- [[ 🚀 DYNAMIC SUB-PAYLOADS EXTRACTED FROM VM LOADSTRING ]]")

			for i, v31 in ipairs(v23) do
				fn26(string.format("-- --- SUB-PAYLOAD CHUNK [%d] (%d bytes) ---", i, #v31))
				fn26(v31)
				fn26("")
			end
		end

		if #v30 > 0 then
			fn26("-- [[ 📦 DECRYPTED CONSTANT POOL (FIRST 150) ]]")
			fn26("local Constants = {")

			for i = 1, math.min(150, #v30) do
				fn26(string.format("    [%d] = %q,", i, v30[i]))
			end

			if #v30 > 150 then
				fn26(string.format("    -- ... (%d more string constants omitted)", #v30 - 150))
			end

			fn26("}\n")
		end

		local concat = table.concat
		return table.concat(tbl14, "\n"), concat(v24, "\n")
	end

	fn22 = nil

	fn22 = function()
		if not scrollingFrame4 then
			return
		end

		for _, child in ipairs(scrollingFrame4:GetChildren()) do
			if child:IsA("Frame") or child:IsA("TextButton") then
				child:Destroy()
			end
		end

		if #tbl13 == 0 then
			local textLabel5 = Instance.new("TextLabel")
			textLabel5.Size = UDim2.new(1, 0, 0, 60)
			textLabel5.BackgroundTransparency = 1
			textLabel5.Text = "⚪ No chunks captured yet.\nEnable hook or paste code below to deobfuscate."
			textLabel5.TextColor3 = tbl6.textDim
			textLabel5.Font = Enum.Font.Gotham
			textLabel5.TextSize = 12
			textLabel5.TextWrapped = true
			textLabel5.Parent = scrollingFrame4
			return
		end

		for i, v17 in ipairs(tbl13) do
			local flag4 = i == n2
			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.new(1, -6, 0, 48)
			textButton.BackgroundColor3 = flag4 and tbl6.surfacePressed or tbl6.glassDeep
			textButton.BackgroundTransparency = flag4 and 0.1 or 0.35
			textButton.BorderSizePixel = 0
			textButton.Text = ""
			textButton.AutoButtonColor = false
			textButton.Parent = scrollingFrame4
			local uiCorner4 = Instance.new("UICorner")
			uiCorner4.CornerRadius = UDim.new(0, 6)
			uiCorner4.Parent = textButton
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Color = flag4 and tbl6.accent or tbl6.surface
			uiStroke.Thickness = flag4 and 1.5 or 1
			uiStroke.Parent = textButton
			local textLabel5 = Instance.new("TextLabel")
			textLabel5.Size = UDim2.fromOffset(64, 18)
			textLabel5.Position = UDim2.new(0, 8, 0, 6)
			textLabel5.BackgroundColor3 = v17.Signature:find("Luraph") and tbl6.accent or v17.Signature:find("Topsniper") and tbl6.cyan or v17.Signature:find("Moonsec") and tbl6.warning or tbl6.accent
			textLabel5.Text = v17.Signature:sub(1, 10)
			textLabel5.TextColor3 = tbl6.background
			textLabel5.Font = Enum.Font.GothamBold
			textLabel5.TextSize = 10
			textLabel5.Parent = textButton
			local uiCorner5 = Instance.new("UICorner")
			uiCorner5.CornerRadius = UDim.new(0, 4)
			uiCorner5.Parent = textLabel5
			local textLabel6 = Instance.new("TextLabel")
			textLabel6.Size = UDim2.new(1, -82, 0, 18)
			textLabel6.Position = UDim2.new(0, 78, 0, 6)
			textLabel6.BackgroundTransparency = 1
			textLabel6.Text = string.format("[%d] %s (%s)", i, v17.Caller or "External", v17.SizeStr or "0 B")
			textLabel6.TextColor3 = flag4 and tbl6.accent or tbl6.text
			textLabel6.Font = Enum.Font.GothamBold
			textLabel6.TextSize = 11
			textLabel6.TextXAlignment = Enum.TextXAlignment.Left
			textLabel6.Parent = textButton
			local textLabel7 = Instance.new("TextLabel")
			textLabel7.Size = UDim2.new(1, -16, 0, 16)
			textLabel7.Position = UDim2.new(0, 8, 0, 26)
			textLabel7.BackgroundTransparency = 1
			textLabel7.Text = string.format("Time: %s | Blocked: %s | Stmts: %d", v17.Time, v17.Blocked and "YES (BLOCKED)" or "NO (PASSED)", v17.StmtCount or 0)
			textLabel7.TextColor3 = v17.Blocked and tbl6.danger or tbl6.textDim
			textLabel7.Font = Enum.Font.Code
			textLabel7.TextSize = 10
			textLabel7.TextXAlignment = Enum.TextXAlignment.Left
			textLabel7.Parent = textButton

			textButton.MouseButton1Click:Connect(function()
				fn5()
				n2 = i
				fn22()
				str9 = v17.Deobfuscated
				str8 = v17.DumpLog or ""
				flag = false

				if textBox6 then
					fn18(textBox6, v17.Deobfuscated)
				end

				if textLabel4 then
					textLabel4.Text = string.format("CHUNK [%d]: %s | Obfuscator: %s | Size: %s | Caller: %s", i, v17.Time, v17.Signature, v17.SizeStr, v17.Caller)
				end
			end)
		end
	end

	local function fn25()
		if v15 then
			return
		end
		local genv = typeof(getgenv) == "function" and getgenv() or _G
		local loadstring_ = genv.loadstring or loadstring
		local load_ = genv.load or load
		local flag4 = false

		local function loadstring_2(arg, arg2)
			if typeof(arg) == "string" and flag2 and not flag4 then
				if arg:find("DevilHub_AI_UI") or arg:find("PAYOMBOYZ AI GENERATE") then
					if v15 then
						return v15(arg, arg2)
					end

					return function()
					end
				end

				flag4 = true
				local str10 = "Unknown"

				pcall(function()
					if typeof(getcallingscript) == "function" then
						local v17 = getcallingscript()

						if v17 then
							str10 = v17:GetFullName()
						end
					end
				end)

				local v17 = fn19(arg)
				local str11 = string.format("%.2f KB", #arg / 1024)
				local v18, v19 = fn21(arg)
				str9 = v18
				str8 = v19
				local v20 = os.date("%H:%M:%S")
				local v21 = flag3

				table.insert(tbl13, 1, {
					Raw = arg,
					Deobfuscated = v18,
					DumpLog = v19,
					Signature = v17,
					Caller = str10,
					ChunkName = tostring(arg2 or "unnamed"),
					SizeStr = str11,
					Time = v20,
					Blocked = v21,
					StmtCount = select(2, v18:gsub("\n", "\n")) + 1,
					Hash = string.format("%08X", #arg * 31 + string.byte(arg, 1)),
				})

				if #tbl13 > 60 then
					table.remove(tbl13)
				end

				fn2("INFO", "UNPACKER", string.format("Dynamically devirtualized %s (%s) from %s", v17, str11, str10))

				task.defer(function()
					fn22()

					if textBox6 and n2 == 1 then
						fn18(textBox6, v18)
					end

					if textLabel4 then
						textLabel4.Text = string.format("DEOBFUSCATED [%s]: %s (%s) from %s", v20, v17, str11, str10)
					end
				end)

				if v21 then
					flag4 = false
					fn2("WARN", "UNPACKER", "Execution blocked by Isolation Policy")

					return function()
						return nil, "[PayomboyZ Unpacker] Execution Blocked & Source Reconstructed"
					end
				end

				flag4 = false
			end

			if v15 then
				return v15(arg, arg2)
			end

			return function()
			end
		end

		if typeof(hookfunction) == "function" and loadstring_ then
			local ok, result = pcall(function()
				return hookfunction(loadstring_, loadstring_2)
			end)

			if ok and result then
				v15 = result
			else
				v15 = loadstring_
				genv.loadstring = loadstring_2
			end
		else
			v15 = loadstring_
			genv.loadstring = loadstring_2
		end

		if load_ then
			if typeof(hookfunction) == "function" then
				local ok, result = pcall(function()
					return hookfunction(load_, loadstring_2)
				end)

				if ok and result then
					v16 = result
				else
					v16 = load_
					genv.load = loadstring_2
				end
			else
				v16 = load_
				genv.load = loadstring_2
			end
		end

		fn2("INFO", "UNPACKER", "Dynamic Hooking Unpacker Engine armed (Topsniper Hook Engine active)")
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 76)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.Parent = v11.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.accent
	uiStroke.Thickness = 1.2
	uiStroke.Parent = frame
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(1, -20, 0, 22)
	textLabel5.Position = UDim2.new(0, 12, 0, 8)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "🔓 IN-GAME DYNAMIC HOOKING UNPACKER & TOPSNIPER DEOBFUSCATOR V8"
	textLabel5.TextColor3 = tbl6.accent
	textLabel5.Font = Enum.Font.GothamBold
	textLabel5.TextSize = 13
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.Parent = frame
	local textLabel6 = Instance.new("TextLabel")
	textLabel6.Size = UDim2.new(1, -20, 0, 16)
	textLabel6.Position = UDim2.new(0, 12, 0, 30)
	textLabel6.BackgroundTransparency = 1
	textLabel6.Text = "● STATUS: IDLE (HOOK DISABLED) | Policy: PASS-THROUGH (ALLOW EXEC)"
	textLabel6.TextColor3 = tbl6.textDim
	textLabel6.Font = Enum.Font.Code
	textLabel6.TextSize = 11
	textLabel6.TextXAlignment = Enum.TextXAlignment.Left
	textLabel6.Parent = frame
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.fromOffset(130, 22)
	textButton.Position = UDim2.new(0, 12, 0, 48)
	textButton.BackgroundColor3 = tbl6.surfacePressed
	textButton.Text = "🟢 เปิด Hook ดักจับ"
	textButton.TextColor3 = tbl6.accent
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 11
	textButton.Parent = frame
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 4)
	uiCorner5.Parent = textButton

	textButton.MouseButton1Click:Connect(function()
		fn5()
		flag2 = not flag2

		if flag2 then
			fn25()
			textButton.Text = "🔴 ปิด Hook ดักจับ"
			textButton.TextColor3 = tbl6.danger
			textLabel6.Text = string.format("● STATUS: LISTENING & UNPACKING | Policy: %s", flag3 and "ISOLATE (BLOCK)" or "PASS-THROUGH")
			textLabel6.TextColor3 = tbl6.accent

			tbl7:Notify({
				Title = "Unpacker Active",
				Content = "Dynamic hook installed. Capturing all script loads.",
				Duration = 3,
			})
		else
			textButton.Text = "🟢 เปิด Hook ดักจับ"
			textButton.TextColor3 = tbl6.accent
			textLabel6.Text = string.format("● STATUS: IDLE (HOOK DISABLED) | Policy: %s", flag3 and "ISOLATE (BLOCK)" or "PASS-THROUGH")
			textLabel6.TextColor3 = tbl6.textDim
			tbl7:Notify({ Title = "Unpacker Idle", Content = "Dynamic script interception paused.", Duration = 3 })
		end
	end)

	local textButton2 = Instance.new("TextButton")
	textButton2.Size = UDim2.fromOffset(140, 22)
	textButton2.Position = UDim2.new(0, 148, 0, 48)
	textButton2.BackgroundColor3 = tbl6.surface
	textButton2.Text = "⚡ Mode: Pass-Through"
	textButton2.TextColor3 = tbl6.cyan
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 11
	textButton2.Parent = frame
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0, 4)
	uiCorner6.Parent = textButton2

	textButton2.MouseButton1Click:Connect(function()
		fn5()
		flag3 = not flag3

		if flag3 then
			textButton2.Text = "🛡️ Mode: Intercept & Block"
			textButton2.TextColor3 = tbl6.warning

			tbl7:Notify({
				Title = "Security Policy",
				Content = "Isolation mode enabled. Intercepted scripts will NOT execute.",
				Duration = 3,
			})
		else
			textButton2.Text = "⚡ Mode: Pass-Through"
			textButton2.TextColor3 = tbl6.cyan

			tbl7:Notify({
				Title = "Security Policy",
				Content = "Pass-Through enabled. Scripts will unpack and execute normally.",
				Duration = 3,
			})
		end

		if flag2 then
			textLabel6.Text = string.format("● STATUS: LISTENING & UNPACKING | Policy: %s", flag3 and "ISOLATE (BLOCK)" or "PASS-THROUGH")
		end
	end)

	local textButton3 = Instance.new("TextButton")
	textButton3.Size = UDim2.fromOffset(80, 22)
	textButton3.Position = UDim2.new(0, 294, 0, 48)
	textButton3.BackgroundColor3 = tbl6.surface
	textButton3.Text = "🧹 Clear"
	textButton3.TextColor3 = tbl6.textDim
	textButton3.Font = Enum.Font.GothamBold
	textButton3.TextSize = 11
	textButton3.Parent = frame
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, 4)
	uiCorner7.Parent = textButton3

	textButton3.MouseButton1Click:Connect(function()
		fn5()
		table.clear(tbl13)
		n2 = 1
		str9 = ""
		str8 = ""
		flag = false
		fn22()

		if textBox6 then
			textBox6.Text = "-- [Deobfuscator Output cleared]"
		end

		if textLabel4 then
			textLabel4.Text = "Ready. Select a captured chunk or use manual deobfuscator below."
		end
	end)
end

local textButton

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 250)
	frame.BackgroundTransparency = 1
	frame.Parent = v11.page
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0.36, -4, 1, 0)
	frame2.BackgroundColor3 = tbl6.glassDeep
	frame2.BackgroundTransparency = 0.2
	frame2.BorderSizePixel = 0
	frame2.Parent = frame
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame2
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame2
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(1, -12, 0, 24)
	textLabel5.Position = UDim2.new(0, 6, 0, 4)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "📦 CAPTURED CHUNKS"
	textLabel5.TextColor3 = tbl6.text
	textLabel5.Font = Enum.Font.GothamBold
	textLabel5.TextSize = 11
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.Parent = frame2
	scrollingFrame4 = Instance.new("ScrollingFrame")
	scrollingFrame4.Size = UDim2.new(1, -12, 1, -34)
	scrollingFrame4.Position = UDim2.new(0, 6, 0, 28)
	scrollingFrame4.BackgroundColor3 = tbl6.input
	scrollingFrame4.BackgroundTransparency = 0.35
	scrollingFrame4.BorderSizePixel = 0
	scrollingFrame4.ScrollBarThickness = 6
	scrollingFrame4.ScrollBarImageColor3 = tbl6.accent
	scrollingFrame4.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame4.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame4.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame4.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame4.Parent = frame2
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 6)
	uiCorner5.Parent = scrollingFrame4
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 4)
	uiListLayout.Parent = scrollingFrame4
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.64, -4, 1, 0)
	frame3.Position = UDim2.new(0.36, 4, 0, 0)
	frame3.BackgroundColor3 = tbl6.glassDeep
	frame3.BackgroundTransparency = 0.2
	frame3.BorderSizePixel = 0
	frame3.Parent = frame
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0, 8)
	uiCorner6.Parent = frame3
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = tbl6.surface
	uiStroke2.Thickness = 1
	uiStroke2.Parent = frame3
	textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(1, -12, 0, 20)
	textLabel4.Position = UDim2.new(0, 6, 0, 4)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "READY | Select a captured chunk or paste script below"
	textLabel4.TextColor3 = tbl6.cyan
	textLabel4.Font = Enum.Font.Code
	textLabel4.TextSize = 10
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.Parent = frame3
	local scrollingFrame5 = Instance.new("ScrollingFrame")
	scrollingFrame5.Size = UDim2.new(1, -12, 1, -56)
	scrollingFrame5.Position = UDim2.new(0, 6, 0, 24)
	scrollingFrame5.BackgroundColor3 = tbl6.input
	scrollingFrame5.BackgroundTransparency = 0.2
	scrollingFrame5.BorderSizePixel = 0
	scrollingFrame5.ScrollBarThickness = 6
	scrollingFrame5.ScrollBarImageColor3 = tbl6.accent
	scrollingFrame5.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame5.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame5.AutomaticCanvasSize = Enum.AutomaticSize.XY
	scrollingFrame5.Parent = frame3
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, 6)
	uiCorner7.Parent = scrollingFrame5
	textBox6 = Instance.new("TextBox")
	textBox6.Size = UDim2.new(1, -10, 1, -10)
	textBox6.Position = UDim2.new(0, 5, 0, 5)
	textBox6.BackgroundTransparency = 1
	textBox6.Text = "-- [[ PayomboyZ Dynamic Unpacker & Deobfuscator Code Inspector ]]\n-- Deobfuscated and devirtualized Luau source code will render here live."
	textBox6.TextColor3 = tbl6.text
	textBox6.Font = Enum.Font.Code
	textBox6.TextSize = 11
	textBox6.TextXAlignment = Enum.TextXAlignment.Left
	textBox6.TextYAlignment = Enum.TextYAlignment.Top
	textBox6.ClearTextOnFocus = false
	textBox6.MultiLine = true
	textBox6.Parent = scrollingFrame5
	local textButton2 = Instance.new("TextButton")
	textButton2.Size = UDim2.fromOffset(68, 24)
	textButton2.Position = UDim2.new(0, 6, 1, -28)
	textButton2.BackgroundColor3 = tbl6.accent
	textButton2.Text = "📋 Copy"
	textButton2.TextColor3 = tbl6.background
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 10
	textButton2.Parent = frame3
	local uiCorner8 = Instance.new("UICorner")
	uiCorner8.CornerRadius = UDim.new(0, 4)
	uiCorner8.Parent = textButton2

	textButton2.MouseButton1Click:Connect(function()
		fn5()

		if typeof(setclipboard) == "function" then
			setclipboard(textBox6.Text)
			tbl7:Notify({ Title = "Copied", Content = "Deobfuscated code copied to clipboard!", Duration = 3 })
		else
			tbl7:Notify({ Title = "Notice", Content = "Clipboard not supported on this executor", Duration = 3 })
		end
	end)

	local textButton3 = Instance.new("TextButton")
	textButton3.Size = UDim2.fromOffset(68, 24)
	textButton3.Position = UDim2.new(0, 78, 1, -28)
	textButton3.BackgroundColor3 = tbl6.surfacePressed
	textButton3.Text = "▶ Run"
	textButton3.TextColor3 = tbl6.accent
	textButton3.Font = Enum.Font.GothamBold
	textButton3.TextSize = 10
	textButton3.Parent = frame3
	local uiCorner9 = Instance.new("UICorner")
	uiCorner9.CornerRadius = UDim.new(0, 4)
	uiCorner9.Parent = textButton3

	textButton3.MouseButton1Click:Connect(function()
		fn5()
		local text3 = textBox6.Text

		if text3 and #text3 > 0 then
			local v16 = v15
			local v17

			if v15 then
				v17 = v16
			else
				v17 = loadstring
			end

			local v18, v19 = v17(text3)

			if v18 then
				task.spawn(v18)

				tbl7:Notify({
					Title = "Executed",
					Content = "Running deobfuscated payload in game thread",
					Duration = 3,
				})
			else
				tbl7:Notify({ Title = "Execution Error", Content = tostring(v19), Duration = 5 })
			end
		end
	end)

	local textBox7 = Instance.new("TextBox")
	textBox7.Size = UDim2.fromOffset(130, 24)
	textBox7.Position = UDim2.new(0, 150, 1, -28)
	textBox7.BackgroundColor3 = tbl6.input
	textBox7.Text = ""
	textBox7.PlaceholderText = "Deobf_Name.lua"
	textBox7.PlaceholderColor3 = tbl6.textDim
	textBox7.TextColor3 = tbl6.accent
	textBox7.Font = Enum.Font.Code
	textBox7.TextSize = 10
	textBox7.ClearTextOnFocus = false
	textBox7.Parent = frame3
	local uiCorner10 = Instance.new("UICorner")
	uiCorner10.CornerRadius = UDim.new(0, 4)
	uiCorner10.Parent = textBox7
	local textButton4 = Instance.new("TextButton")
	textButton4.Size = UDim2.fromOffset(68, 24)
	textButton4.Position = UDim2.new(0, 286, 1, -28)
	textButton4.BackgroundColor3 = tbl6.surface
	textButton4.Text = "💾 Save"
	textButton4.TextColor3 = tbl6.cyan
	textButton4.Font = Enum.Font.GothamBold
	textButton4.TextSize = 10
	textButton4.Parent = frame3
	local uiCorner11 = Instance.new("UICorner")
	uiCorner11.CornerRadius = UDim.new(0, 4)
	uiCorner11.Parent = textButton4

	textButton4.MouseButton1Click:Connect(function()
		fn5()
		local text3 = textBox7.Text

		if not text3 or text3 == "" or text3:find("^%s*$") then
			text3 = string.format("PayomboyZ_Deobf_%s.lua", os.date("%Y%m%d_%H%M%S"))
		end

		if not text3:match("%.[a-zA-Z0-9]+$") then
			text3 ..= ".lua"
		end

		fn6(text3, textBox6.Text, "Deobfuscated Code")
	end)

	textButton = Instance.new("TextButton")
	textButton.Size = UDim2.fromOffset(104, 24)
	textButton.Position = UDim2.new(0, 360, 1, -28)
	textButton.BackgroundColor3 = tbl6.surface
	textButton.Text = "📑 สลับ Dump/Code"
	textButton.TextColor3 = tbl6.warning
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 10
	textButton.Parent = frame3
	local uiCorner12 = Instance.new("UICorner")
	uiCorner12.CornerRadius = UDim.new(0, 4)
	uiCorner12.Parent = textButton

	textButton.MouseButton1Click:Connect(function()
		fn5()
		flag = not flag

		if flag then
			if str8 and #str8 > 0 then
				fn18(textBox6, str8)
				textButton.Text = "📜 แสดง Source Code"
				textButton.TextColor3 = tbl6.accent

				if textLabel4 then
					textLabel4.Text = "VIEWING RAW DUMP LOG (dumped_output.txt) | Topsniper deobf.lua Hook Output"
				end
			else
				tbl7:Notify({
					Title = "No Dump Log",
					Content = "No raw dump trace available yet. Run Topsniper Hook first.",
					Duration = 3,
				})
			end
		elseif str9 and #str9 > 0 then
			fn18(textBox6, str9)
			textButton.Text = "📑 แสดง Dump Log"
			textButton.TextColor3 = tbl6.warning

			if textLabel4 then
				textLabel4.Text = "VIEWING DEOBFUSCATED SOURCE CODE | Clean Reconstructed Luau"
			end
		end
	end)

	local textButton5 = Instance.new("TextButton")
	textButton5.Size = UDim2.fromOffset(90, 24)
	textButton5.Position = UDim2.new(0, 470, 1, -28)
	textButton5.BackgroundColor3 = tbl6.surface
	textButton5.Text = "💾 Save Dump.txt"
	textButton5.TextColor3 = tbl6.textDim
	textButton5.Font = Enum.Font.GothamBold
	textButton5.TextSize = 10
	textButton5.Parent = frame3
	local uiCorner13 = Instance.new("UICorner")
	uiCorner13.CornerRadius = UDim.new(0, 4)
	uiCorner13.Parent = textButton5

	textButton5.MouseButton1Click:Connect(function()
		fn5()
		fn6("dumped_output.txt", str8 and #str8 > 0 and str8 or textBox6.Text, "Topsniper Dump Log")
	end)
end

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 185)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = v11.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(0, 200, 0, 20)
	textLabel5.Position = UDim2.new(0, 8, 0, 5)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "⚡ TOPSNIPER & VM DEOBFUSCATOR"
	textLabel5.TextColor3 = tbl6.text
	textLabel5.Font = Enum.Font.GothamBold
	textLabel5.TextSize = 10
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.Parent = frame
	local textLabel6 = Instance.new("TextLabel")
	textLabel6.Size = UDim2.new(1, -220, 0, 20)
	textLabel6.Position = UDim2.new(0, 214, 0, 5)
	textLabel6.BackgroundTransparency = 1
	textLabel6.Text = "⚪ Checking Bridge..."
	textLabel6.TextColor3 = tbl6.textDim
	textLabel6.Font = Enum.Font.GothamBold
	textLabel6.TextSize = 9
	textLabel6.TextXAlignment = Enum.TextXAlignment.Left
	textLabel6.Parent = frame
	local scrollingFrame5 = Instance.new("ScrollingFrame")
	scrollingFrame5.Size = UDim2.new(1, -16, 0, 24)
	scrollingFrame5.Position = UDim2.new(0, 8, 0, 27)
	scrollingFrame5.BackgroundTransparency = 1
	scrollingFrame5.BorderSizePixel = 0
	scrollingFrame5.ScrollBarThickness = 2
	scrollingFrame5.ScrollBarImageColor3 = tbl6.accent
	scrollingFrame5.ScrollingDirection = Enum.ScrollingDirection.X
	scrollingFrame5.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame5.AutomaticCanvasSize = Enum.AutomaticSize.X
	scrollingFrame5.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.Padding = UDim.new(0, 5)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = scrollingFrame5

	local tbl13 = {
		{ id = "auto", name = "⚙️ Auto-Detect" },
		{ id = "wearedevs", name = "🛠️ WeAreDevs" },
		{ id = "moonveil", name = "🌙 Moonveil" },
		{ id = "moonsec_ironbrew", name = "☕ IronBrew" },
		{ id = "luraph", name = "🔒 Luraph" },
		{ id = "twok", name = "🛡️ 2K Sec" },
		{ id = "luast", name = "🌪️ Luast" },
	}

	local n2 = 1
	local textButton2 = Instance.new("TextButton")
	textButton2.Size = UDim2.fromOffset(108, 22)
	textButton2.LayoutOrder = 1
	textButton2.BackgroundColor3 = tbl6.surface
	textButton2.Text = tbl13[n2].name
	textButton2.TextColor3 = tbl6.cyan
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 10
	textButton2.Parent = scrollingFrame5
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 4)
	uiCorner5.Parent = textButton2

	textButton2.MouseButton1Click:Connect(function()
		fn5()
		n2 = n2 % #tbl13 + 1
		textButton2.Text = tbl13[n2].name
		tbl7:Notify({ Title = "Engine Selected", Content = "Target: " .. tbl13[n2].name, Duration = 2 })
	end)

	local textButton3 = Instance.new("TextButton")
	textButton3.Size = UDim2.fromOffset(118, 22)
	textButton3.LayoutOrder = 2
	textButton3.BackgroundColor3 = tbl6.accent
	textButton3.Text = "⚡ Full Deobfuscate"
	textButton3.TextColor3 = tbl6.background
	textButton3.Font = Enum.Font.GothamBold
	textButton3.TextSize = 10
	textButton3.Parent = scrollingFrame5
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0, 4)
	uiCorner6.Parent = textButton3
	local textButton4 = Instance.new("TextButton")
	textButton4.Size = UDim2.fromOffset(108, 22)
	textButton4.LayoutOrder = 3
	textButton4.BackgroundColor3 = tbl6.surfacePressed
	textButton4.Text = "🎯 Topsniper Hook"
	textButton4.TextColor3 = tbl6.cyan
	textButton4.Font = Enum.Font.GothamBold
	textButton4.TextSize = 10
	textButton4.Parent = scrollingFrame5
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, 4)
	uiCorner7.Parent = textButton4
	local textButton5 = Instance.new("TextButton")
	textButton5.Size = UDim2.fromOffset(112, 22)
	textButton5.LayoutOrder = 4
	textButton5.BackgroundColor3 = tbl6.surface
	textButton5.Text = "🌐 Load Remote Obf"
	textButton5.TextColor3 = tbl6.warning
	textButton5.Font = Enum.Font.GothamBold
	textButton5.TextSize = 10
	textButton5.Parent = scrollingFrame5
	local uiCorner8 = Instance.new("UICorner")
	uiCorner8.CornerRadius = UDim.new(0, 4)
	uiCorner8.Parent = textButton5
	local textButton6 = Instance.new("TextButton")
	textButton6.Size = UDim2.fromOffset(112, 22)
	textButton6.LayoutOrder = 5
	textButton6.BackgroundColor3 = tbl6.surface
	textButton6.Text = "📂 Load AutoExec"
	textButton6.TextColor3 = tbl6.accent
	textButton6.Font = Enum.Font.GothamBold
	textButton6.TextSize = 10
	textButton6.Parent = scrollingFrame5
	local uiCorner9 = Instance.new("UICorner")
	uiCorner9.CornerRadius = UDim.new(0, 4)
	uiCorner9.Parent = textButton6
	local scrollingFrame6 = Instance.new("ScrollingFrame")
	scrollingFrame6.Size = UDim2.new(1, -16, 1, -60)
	scrollingFrame6.Position = UDim2.new(0, 8, 0, 54)
	scrollingFrame6.BackgroundColor3 = tbl6.input
	scrollingFrame6.BackgroundTransparency = 0.35
	scrollingFrame6.BorderSizePixel = 0
	scrollingFrame6.ScrollBarThickness = 5
	scrollingFrame6.ScrollBarImageColor3 = tbl6.accent
	scrollingFrame6.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingFrame6.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame6.AutomaticCanvasSize = Enum.AutomaticSize.XY
	scrollingFrame6.Parent = frame
	local uiCorner10 = Instance.new("UICorner")
	uiCorner10.CornerRadius = UDim.new(0, 6)
	uiCorner10.Parent = scrollingFrame6
	local textBox7 = Instance.new("TextBox")
	textBox7.Size = UDim2.new(1, -8, 1, -8)
	textBox7.Position = UDim2.new(0, 4, 0, 4)
	textBox7.BackgroundTransparency = 1
	textBox7.Text = "-- Paste obfuscated Lua VM script (Topsniper, Moonsec, PSU, Luraph, IronBrew) here..."
	textBox7.TextColor3 = tbl6.textDim
	textBox7.Font = Enum.Font.Code
	textBox7.TextSize = 11
	textBox7.TextXAlignment = Enum.TextXAlignment.Left
	textBox7.TextYAlignment = Enum.TextYAlignment.Top
	textBox7.ClearTextOnFocus = false
	textBox7.MultiLine = true
	textBox7.Parent = scrollingFrame6

	textButton3.MouseButton1Click:Connect(function()
		fn5()
		local text3 = textBox7.Text
		if not text3 or text3 == "" or text3:find("^%s*%-%- Paste") then
			tbl7:Notify({ Title = "Input Required", Content = "Please paste obfuscated code first", Duration = 3 })
			return
		end
		local id = tbl13[n2].id

		tbl7:Notify({
			Title = "Analyzing VM",
			Content = "Running deobfuscator via " .. tbl13[n2].name .. "...",
			Duration = 3,
		})

		if textLabel4 then
			textLabel4.Text = "⏳ ANALYZING & DEOBFUSCATING: Processing via " .. tbl13[n2].name .. "..."
		end

		task.spawn(function()
			local v16 = fn19(text3)
			local payomboyZSubport = getgenv().PayomboyZ_Subport or _G.PayomboyZ_Subport

			local function fn23(arg)
				str9 = arg.CleanSource
				str8 = arg.DumpLog
				flag = false
				fn18(textBox6, arg.CleanSource)
				textButton.Text = "📑 แสดง Dump Log"
				textButton.TextColor3 = tbl6.warning

				if arg.IsBridge then
					textLabel4.Text = string.format("DEOBFUSCATED [PYTHON BRIDGE]: %s | %d Lines | %.2fs", arg.Engine or id, arg.Lines or #arg.CleanSource:split("\n"), arg.Elapsed or 0)

					tbl7:Notify({
						Title = "Deobfuscation Complete (Bridge)",
						Content = string.format("Recovered code with %s in %.2fs!", arg.Engine or id, arg.Elapsed or 0),
						Duration = 4,
					})
				else
					textLabel4.Text = string.format("DEOBFUSCATED [LOCAL SANDBOX]: %s | %d Constants | %.2fs", v16, #(arg.Constants or {}), arg.Elapsed or 0)

					tbl7:Notify({
						Title = "Deobfuscation Complete (Local)",
						Content = string.format("Processed locally in %.2fs!", arg.Elapsed or 0),
						Duration = 4,
					})
				end
			end

			if payomboyZSubport and payomboyZSubport.Bridge and payomboyZSubport.Bridge.DeobfuscateAsync then
				payomboyZSubport.Bridge.DeobfuscateAsync(text3, { Engine = id, MaxSteps = 3000 }, fn23)
			elseif payomboyZSubport and payomboyZSubport.Deobfuscator and payomboyZSubport.Deobfuscator.DeobfuscateAsync then
				payomboyZSubport.Deobfuscator.DeobfuscateAsync(text3, { MaxSteps = 3000 }, fn23)
			else
				task.wait(0.02)
				local v17, v18 = fn21(text3)
				str9 = v17
				str8 = v18
				flag = false
				fn18(textBox6, v17)
				textButton.Text = "📑 แสดง Dump Log"
				textButton.TextColor3 = tbl6.warning
				textLabel4.Text = string.format("DEOBFUSCATED: %s | Original: %.2f KB | Stmts: %d", v16, #text3 / 1024, select(2, v17:gsub("\n", "\n")) + 1)

				tbl7:Notify({
					Title = "Deobfuscation Complete",
					Content = "VM devirtualized and constants extracted!",
					Duration = 4,
				})
			end
		end)
	end)

	textButton4.MouseButton1Click:Connect(function()
		fn5()
		local text3 = textBox7.Text
		if not text3 or text3 == "" or text3:find("^%s*%-%- Paste") then
			tbl7:Notify({ Title = "Input Required", Content = "Please paste obfuscated code first", Duration = 3 })
			return
		end
		tbl7:Notify({ Title = "Topsniper Hook", Content = "Tracing VM execution safely in sandbox...", Duration = 3 })

		if textLabel4 then
			textLabel4.Text = "⏳ TRACING: Running safe instrumented VM sandbox..."
		end

		task.spawn(function()
			task.wait(0.02)
			local v16, v17, v18 = fn20(text3)
			local str10 = table.concat(v16, "\n")
			str8 = str10
			flag = true
			fn18(textBox6, str10)
			textButton.Text = "📜 แสดง Source Code"
			textButton.TextColor3 = tbl6.accent
			textLabel4.Text = string.format("TOPSNIPER HOOK TRACE: %d Events Dumped | %d Decrypted Strings | %d Chunks", #v16, #v17, #v18)

			tbl7:Notify({
				Title = "Hook Trace Complete",
				Content = string.format("Captured %d strings and %d chunks!", #v17, #v18),
				Duration = 4,
			})
		end)
	end)

	textButton5.MouseButton1Click:Connect(function()
		fn5()
		tbl7:Notify({ Title = "Fetching", Content = "Downloading remote Topsniper obf script...", Duration = 3 })

		task.spawn(function()
			local obf, v16 = fn17("https://raw.githubusercontent.com/aslamdunk21/AIPayomboyG/refs/heads/main/PayomboyZKnowledge-main/examples/obf")

			if obf and #obf > 0 then
				fn18(textBox7, obf)

				tbl7:Notify({
					Title = "Loaded",
					Content = string.format("Topsniper obf loaded (%.2f KB)!", #obf / 1024),
					Duration = 3,
				})
			else
				tbl7:Notify({ Title = "Fetch Error", Content = tostring(v16), Duration = 4 })
			end
		end)
	end)

	local n3 = 1

	textButton6.MouseButton1Click:Connect(function()
		fn5()

		tbl7:Notify({
			Title = "Scanning AutoExec",
			Content = "Searching autoexecute and workspace scripts...",
			Duration = 3,
		})

		task.spawn(function()
			local tbl14 = {}

			local function fn23(arg)
				if typeof(listfiles) == "function" then
					local ok, result = pcall(listfiles, arg)

					if ok and type(result) == "table" then
						for _, v16 in ipairs(result) do
							local match = v16:match("%.([a-zA-Z0-9]+)$")

							if match then
								match = match:lower() == "lua" or match:lower() == "luau" or match:lower() == "txt"
							end

							if match then
								table.insert(tbl14, v16)
							end
						end
					end
				end
			end

			fn23("autoexecute")
			fn23("AutoExecute")
			fn23("autoexec")
			fn23("")

			if #tbl14 > 0 and typeof(readfile) == "function" then
				n3 = (n3 - 1) % #tbl14 + 1
				local v16 = tbl14[n3]
				n3 += 1
				local ok, result = pcall(readfile, v16)

				if ok and result and #result > 0 then
					fn18(textBox7, result)

					tbl7:Notify({
						Title = "AutoExec Loaded",
						Content = string.format("[%d/%d] Loaded %s (%.2f KB)!", n3 - 1, #tbl14, v16, #result / 1024),
						Duration = 4,
					})

					if textLabel4 then
						textLabel4.Text = string.format("LOADED [%d/%d]: %s (%.2f KB) - Ready to Deobfuscate", n3 - 1, #tbl14, v16, #result / 1024)
					end
				else
					tbl7:Notify({ Title = "Read Error", Content = "Could not read file: " .. tostring(v16), Duration = 3 })
				end
			else
				tbl7:Notify({
					Title = "No Files Found",
					Content = "No .lua/.txt files found in autoexecute or workspace folder",
					Duration = 4,
				})
			end
		end)
	end)

	getgenv().PayomboyZ_SaveDeobf = function(arg, arg2)
		local text3 = arg2 or str9 or textBox6 and textBox6.Text
		if not text3 or text3 == "" then
			return false, "No deobfuscated code"
		end
		local str10 = arg or string.format("PayomboyZ_Deobf_%s.lua", os.date("%Y%m%d_%H%M%S"))

		if not str10:match("%.[a-zA-Z0-9]+$") then
			str10 ..= ".lua"
		end

		fn6(str10, text3, "Deobfuscated Code")
		return true, str10
	end

	getgenv().PayomboyZ_LoadAndDeobf = function(arg, arg2)
		if typeof(readfile) ~= "function" then
			return false, "readfile not supported"
		end
		local ok, result = pcall(readfile, arg)
		if not ok or not result then
			return false, "Could not read file"
		end
		fn18(textBox7, result)
		local payomboyZSubport = getgenv().PayomboyZ_Subport or _G.PayomboyZ_Subport

		if payomboyZSubport and payomboyZSubport.Bridge and payomboyZSubport.Bridge.DeobfuscateAsync then
			payomboyZSubport.Bridge.DeobfuscateAsync(result, { Engine = arg2 or "auto" }, function(arg3)
				str9 = arg3.CleanSource
				fn18(textBox6, arg3.CleanSource)
				print("[PayomboyZ] Deobfuscated " .. arg .. " via " .. tostring(arg3.Engine))
			end)
		end

		return true
	end

	fn22()

	task.spawn(function()
		task.wait(0.5)

		local function fn23()
			local payomboyZSubport = getgenv().PayomboyZ_Subport or _G.PayomboyZ_Subport

			if payomboyZSubport and payomboyZSubport.Bridge and payomboyZSubport.Bridge.CheckHealthAsync then
				payomboyZSubport.Bridge.CheckHealthAsync(function(arg)
					if arg and textLabel6 and textLabel6.Parent then
						textLabel6.Text = "🟢 Bridge Online (6 Engines)"
						textLabel6.TextColor3 = tbl6.accent
					elseif textLabel6 and textLabel6.Parent then
						textLabel6.Text = "🟡 Offline Mode (Local Sandbox)"
						textLabel6.TextColor3 = tbl6.warning
					end
				end)
			elseif textLabel6 and textLabel6.Parent then
				textLabel6.Text = "🟡 Local Lua Mode"
				textLabel6.TextColor3 = tbl6.textDim
			end
		end

		fn23()
	end)
end

v12:AddSection("LANG_SECTION", "🌐 เลือกภาษาใช้งาน (LANGUAGE / สลับภาษา)")

v12:AddButton({
	TitleKey = "LANG_SWITCH_TH",
	Title = "🇹🇭 ภาษาไทย (Thai - ใช้งานอยู่)",
	Callback = function()
		fn4("TH")
	end,
})

v12:AddButton({
	TitleKey = "LANG_SWITCH_EN",
	Title = "🇬🇧 Switch to English",
	Callback = function()
		fn4("EN")
	end,
})

v12:AddSection("SCALE_SECTION", "🖥️ UI DISPLAY SCALING")

v12:AddButton({
	TitleKey = "SCALE_STD",
	Title = "🖥️ Standard Profile (1.0x Scale)",
	Callback = function()
		v:SetScale(1)
		tbl7:Notify({ Title = fn3("NOTIF_TITLE"), Content = "Reset to standard scale (1.0x)", Duration = 2 })
	end,
})

v12:AddButton({
	TitleKey = "SCALE_MOBILE",
	Title = "📱 Compact Mobile Profile (0.75x Scale)",
	Callback = function()
		v:SetScale(0.75)
		tbl7:Notify({ Title = fn3("NOTIF_TITLE"), Content = "Set to compact mobile scale (0.75x)", Duration = 2 })
	end,
})

v12:AddSection("EXT_SECTION", "🛠️ EXTERNAL UTILITIES & GAME SCRIPTS")

v12:AddButton({
	TitleKey = "EXT_ANIME_CARD",
	Title = "🎴 Launch PayomboyZ Anime Card Farm",
	Callback = function()
		tbl7:Notify({
			Title = "Anime Card Farm",
			Content = "Fetching and launching PayomboyZ Anime Card Farm...",
			Duration = 3,
		})

		task.spawn(function()
			local ok, result = pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/payomboyz333/Anime-Card-Farm/refs/heads/main/start.txt"))()
			end)

			if ok then
				tbl7:Notify({
					Title = "Anime Card Farm",
					Content = "PayomboyZ Anime Card Farm loaded successfully!",
					Duration = 4,
				})
			else
				tbl7:Notify({ Title = "Launch Error", Content = "Failed to launch script: " .. tostring(result), Duration = 5 })
			end
		end)
	end,
})

v12:AddButton({
	TitleKey = "EXT_DEX",
	Title = "🛠️ Launch Dex++ Debug Explorer",
	Callback = function()
		tbl7:Notify({ Title = "Dex Debugger", Content = "Fetching and launching Dex++ Debug Explorer...", Duration = 3 })

		task.spawn(function()
			local ok, result = pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/Payomboyz0028/Yaranikaaaa/refs/heads/main/AI/Dex%2B%2B%20Debug"))()
			end)

			if ok then
				tbl7:Notify({ Title = "Dex Debugger", Content = "Dex++ Debug Explorer loaded successfully!", Duration = 4 })
			else
				tbl7:Notify({ Title = "Dex Error", Content = "Failed to launch Dex++: " .. tostring(result), Duration = 5 })
			end
		end)
	end,
})

v12:AddButton({
	TitleKey = "EXT_IY",
	Title = "⚡ Launch Infinite Yield Admin Tools",
	Callback = function()
		tbl7:Notify({ Title = "Infinite Yield", Content = "Fetching and launching Infinite Yield...", Duration = 3 })

		task.spawn(function()
			local ok, result = pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
			end)

			if ok then
				tbl7:Notify({ Title = "Infinite Yield", Content = "Infinite Yield loaded successfully!", Duration = 4 })
			else
				tbl7:Notify({
					Title = "IY Error",
					Content = "Failed to launch Infinite Yield: " .. tostring(result),
					Duration = 5,
				})
			end
		end)
	end,
})

v12:AddSection("CONFIG_SECTION", "💾 HUB CONFIGURATION & PROFILE MANAGER")

v12:AddButton({
	TitleKey = "CONFIG_SAVE_BTN",
	Title = "💾 Save Current Profile Config",
	Callback = function()
		local tbl13 = {
			UIScale = v.UIScale.Scale,
			SpySkipText = text,
			CurrentLanguage = switchedLanguageTo,
			BoundContextCount = #tbl2.BoundItems,
			SavedTime = os.date("%Y-%m-%d %H:%M:%S"),
		}

		fn6("PAYOMBOYDumps/PayomboyZ_Config.json", game:GetService("HttpService"):JSONEncode(tbl13), "Config Profile")
		fn2("INFO", "CONFIG", "Saved profile config successfully")
	end,
})

v12:AddButton({
	TitleKey = "CONFIG_LOAD_BTN",
	Title = "📂 Load Saved Profile Config",
	Callback = function()
		local str10 = nil

		if typeof(isfile) == "function" then
			if isfile("PAYOMBOYDumps/PayomboyZ_Config.json") then
				str10 = "PAYOMBOYDumps/PayomboyZ_Config.json"
			elseif isfile("PayomboyZ_Config.json") then
				str10 = "PayomboyZ_Config.json"
			end
		end

		if typeof(readfile) == "function" and str10 then
			local ok, result = pcall(function()
				return readfile(str10)
			end)

			if ok and result then
				local data = game:GetService("HttpService"):JSONDecode(result)

				if data and data.UIScale then
					v:SetScale(data.UIScale)
				end

				if data and data.CurrentLanguage then
					fn4(data.CurrentLanguage)
				end

				if data and data.SpySkipText and nil then
					text = data.SpySkipText
					v13.Text = text
				end

				tbl7:Notify({ Title = fn3("NOTIF_TITLE"), Content = "Loaded settings profile!", Duration = 3 })
				fn2("INFO", "CONFIG", "Loaded profile config successfully")
			end
		else
			tbl7:Notify({ Title = fn3("NOTIF_TITLE"), Content = "No saved config file found.", Duration = 3 })
		end
	end,
})

v12:AddSection("DIAG_SECTION", "📊 SYSTEM DIAGNOSTICS & PERFORMANCE")

do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 75)
	frame.BackgroundColor3 = tbl6.glassDeep
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Parent = v12.page
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = tbl6.surface
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(1, -16, 1, -12)
	textLabel5.Position = UDim2.new(0, 8, 0, 6)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Font = Enum.Font.Code
	textLabel5.TextSize = 11
	textLabel5.TextColor3 = Color3.fromRGB(150, 230, 255)
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.TextYAlignment = Enum.TextYAlignment.Top
	textLabel5.Parent = frame

	task.spawn(function()
		while frame and frame.Parent and textLabel5 and textLabel5.Parent do
			local v16 = gcinfo()
			local str10 = string.format("%.2f MB", v16 / 1024)
			local n2 = 0

			for k in pairs(tbl3.DocCache) do
				n2 += 1
			end

			textLabel5.Text = string.format([[PERFORMANCE MONITOR V6:
• Memory Usage: %s (%d KB)
• Active Connections Tracked: %d
• Debug Log Buffer: %d entries
• Bound AI Contexts: %d | GitHub Knowledge: %d docs (%d cached)]], str10, v16, #connections, #tbl, #tbl2.BoundItems, #tbl3.ManifestEntries, n2)

			task.wait(1)
		end
	end)
end

v12:AddSection("CONTROL_SECTION", "❌ SYSTEM CONTROL & SESSION")

v12:AddButton({
	Title = "🚪 ออกจากระบบ (Logout & Return to Loader)",
	Callback = function()
		fn()
		local obsidianGlass2Ui = hui:FindFirstChild("DevilHub_AI_UI")

		if obsidianGlass2Ui then
			obsidianGlass2Ui:Destroy()
		end

		RedirectToStartLoader("🚪 ออกจากระบบสำเร็จ! กำลังกลับไปยังหน้า PayomboyZ Loader...")
	end,
})

v12:AddButton({
	TitleKey = "NOTIF_TEST_BTN",
	Title = "🔔 Test Toast Notification",
	Callback = function()
		tbl7:Notify({
			Title = fn3("NOTIF_TITLE"),
			Content = "DEVIL HUB notification is working",
			Duration = 4,
		})
	end,
})

v12:AddButton({
	TitleKey = "UNLOAD_HUB_BTN",
	Title = "❌ Unload PayomboyZ Hub UI & Cleanup Connections",
	Callback = function()
		fn()
		local obsidianGlass2Ui = hui:FindFirstChild("DevilHub_AI_UI")

		if obsidianGlass2Ui then
			obsidianGlass2Ui:Destroy()
		end

		fn2("INFO", "SYSTEM", "Unloaded PayomboyZ AI Engine UI cleanly")
	end,
})

fn2("INFO", "SYSTEM", "PayomboyZ AI Engine V6 Core Architecture Initialized Successfully!")

tbl7:Notify({
	Title = "DEVIL HUB",
	Content = "DEVIL HUB พร้อมแล้ว • เลือกเครื่องมือจากหน้าแรก",
	Duration = 5,
})
