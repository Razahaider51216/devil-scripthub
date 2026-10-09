-- DEVIL STAGE FARM • dump-derived build for place 120731410233153
local Core = (function()
local Core = {}
function Core.stages(catalog, world, group)
    local out = {}
    for _, stage in ipairs(catalog) do
        if stage.world == world and (not group or group == "All" or stage.group == group) then
            table.insert(out, stage)
        end
    end
    table.sort(out, function(a,b) return a.id < b.id end)
    return out
end
function Core.route(catalog, world, group, mode, selected, first, last)
    local out = {}
    for _, stage in ipairs(Core.stages(catalog, world, group)) do
        if (mode == "Repeat" and stage.id == selected)
            or (mode == "Range" and stage.id >= first and stage.id <= last) then
            table.insert(out, stage)
        end
    end
    return out
end
function Core.number(value, fallback, minimum, maximum)
    local n = tonumber(value)
    if not n or n ~= n or math.abs(n) == math.huge then return fallback end
    return math.clamp(n, minimum, maximum)
end
-- Snapshot only serializable values and instance references. No function/thread captures.
function Core.copy(value, depth, seen)
    depth, seen = depth or 0, seen or {}
    local kind = typeof(value)
    if kind ~= "table" then
        if kind == "function" or kind == "thread" then error("Unsupported argument type") end
        return value
    end
    if depth > 6 or seen[value] then error("Cyclic or deeply nested arguments") end
    seen[value] = true
    local out, count = {}, 0
    for key,item in pairs(value) do
        count += 1
        if count > 100 then error("Argument table too large") end
        if type(key) ~= "string" and type(key) ~= "number" then error("Unsupported argument key") end
        out[key] = Core.copy(item, depth+1, seen)
    end
    seen[value] = nil
    return out
end
function Core.ready(config, state, now)
    return config.enabled and not state.busy and now >= (state.nextAt or 0)
end
function Core.signature(value)
    if type(value) ~= "table" then return typeof(value)..":"..tostring(value) end
    local items = {}
    for key,item in pairs(value) do
        table.insert(items, Core.signature(key).."="..Core.signature(item))
    end
    table.sort(items)
    local framed={}
    for _,item in ipairs(items) do table.insert(framed,tostring(#item)..":"..item) end
    return "table{"..table.concat(framed).."}"
end
function Core.describe(value,depth)
    depth=depth or 0
    if depth>4 then return "<depth limit>" end
    local kind=typeof(value)
    if kind=="table" then
        local out={}; local count=0
        for key,item in pairs(value) do
            count+=1; if count>30 then out["<truncated>"]=true; break end
            out[tostring(key)]=Core.describe(item,depth+1)
        end
        return out
    end
    if kind=="Instance" then return {class=value.ClassName,path=value:GetFullName()} end
    if kind=="number" then return value==value and math.abs(value)<math.huge and value or tostring(value) end
    if kind=="nil" then return "<nil>" end
    if kind=="string" then return value:sub(1,500) end
    if kind=="boolean" then return value end
    return tostring(value)
end
return Core

end)()
local Catalog = (function()
return {{id=1,world=1,group="01-03 FIELDS",path={"STAGES","01-03 FIELDS","Stage1"},floor=nil,pad=nil},{id=2,world=1,group="01-03 FIELDS",path={"STAGES","01-03 FIELDS","Stage2"},floor=nil,pad=nil},{id=3,world=1,group="01-03 FIELDS",path={"STAGES","01-03 FIELDS","Stage3"},floor=nil,pad=nil},{id=4,world=1,group="04-06 PIRATES",path={"STAGES","04-06 PIRATES","Stage4"},floor=nil,pad=nil},{id=5,world=1,group="04-06 PIRATES",path={"STAGES","04-06 PIRATES","Stage5"},floor=nil,pad=nil},{id=6,world=1,group="04-06 PIRATES",path={"STAGES","04-06 PIRATES","Stage6"},floor=nil,pad=nil},{id=7,world=1,group="07-09 BARBARIANS",path={"STAGES","07-09 BARBARIANS","Stage7"},floor=nil,pad=nil},{id=8,world=1,group="07-09 BARBARIANS",path={"STAGES","07-09 BARBARIANS","Stage8"},floor=nil,pad=nil},{id=9,world=1,group="07-09 BARBARIANS",path={"STAGES","07-09 BARBARIANS","Stage9"},floor=nil,pad=nil},{id=10,world=1,group="10-12 ASSASSINS",path={"STAGES","10-12 ASSASSINS","Stage10"},floor=nil,pad=nil},{id=11,world=1,group="10-12 ASSASSINS",path={"STAGES","10-12 ASSASSINS","Stage11"},floor=nil,pad=nil},{id=12,world=1,group="10-12 ASSASSINS",path={"STAGES","10-12 ASSASSINS","Stage12"},floor=nil,pad=nil},{id=13,world=1,group="13-15 KNIGHTS",path={"STAGES","13-15 KNIGHTS","Stage13"},floor=nil,pad=nil},{id=14,world=1,group="13-15 KNIGHTS",path={"STAGES","13-15 KNIGHTS","Stage14"},floor=nil,pad=nil},{id=15,world=1,group="13-15 KNIGHTS",path={"STAGES","13-15 KNIGHTS","Stage15"},floor=nil,pad=nil},{id=16,world=1,group="16-18 MAGES",path={"STAGES","16-18 MAGES","Stage16"},floor=nil,pad=nil},{id=17,world=1,group="16-18 MAGES",path={"STAGES","16-18 MAGES","Stage17"},floor=nil,pad=nil},{id=18,world=1,group="16-18 MAGES",path={"STAGES","16-18 MAGES","Stage18"},floor=nil,pad=nil},{id=19,world=2,group="01-03 DUNES",path={"MUNDO2","STAGES","01-03 DUNES","Stage19"},floor=nil,pad=nil},{id=20,world=2,group="01-03 DUNES",path={"MUNDO2","STAGES","01-03 DUNES","Stage20"},floor=nil,pad=nil},{id=21,world=2,group="01-03 DUNES",path={"MUNDO2","STAGES","01-03 DUNES","Stage21"},floor=nil,pad=nil},{id=22,world=2,group="04-06 OASIS",path={"MUNDO2","STAGES","04-06 OASIS","Stage22"},floor=nil,pad=nil},{id=23,world=2,group="04-06 OASIS",path={"MUNDO2","STAGES","04-06 OASIS","Stage23"},floor=nil,pad=nil},{id=24,world=2,group="04-06 OASIS",path={"MUNDO2","STAGES","04-06 OASIS","Stage24"},floor=nil,pad=nil},{id=25,world=2,group="07-09 TOMBS",path={"MUNDO2","STAGES","07-09 TOMBS","Stage25"},floor=nil,pad=nil},{id=26,world=2,group="07-09 TOMBS",path={"MUNDO2","STAGES","07-09 TOMBS","Stage26"},floor=nil,pad=nil},{id=27,world=2,group="07-09 TOMBS",path={"MUNDO2","STAGES","07-09 TOMBS","Stage27"},floor=nil,pad=nil},{id=28,world=2,group="10-12 SERPENTS",path={"MUNDO2","STAGES","10-12 SERPENTS","Stage28"},floor=nil,pad=nil},{id=29,world=2,group="10-12 SERPENTS",path={"MUNDO2","STAGES","10-12 SERPENTS","Stage29"},floor=nil,pad=nil},{id=30,world=2,group="10-12 SERPENTS",path={"MUNDO2","STAGES","10-12 SERPENTS","Stage30"},floor=nil,pad=nil},{id=31,world=2,group="13-15 PYRAMID",path={"MUNDO2","STAGES","13-15 PYRAMID","Stage31"},floor=nil,pad=nil},{id=32,world=2,group="13-15 PYRAMID",path={"MUNDO2","STAGES","13-15 PYRAMID","Stage32"},floor=nil,pad=nil},{id=33,world=2,group="13-15 PYRAMID",path={"MUNDO2","STAGES","13-15 PYRAMID","Stage33"},floor=nil,pad=nil},{id=34,world=3,group="01-03 BAMBOO",path={"MUNDO3","STAGES","01-03 BAMBOO","Stage34"},floor={59.20000076293945,2.0,7839.9599609375},pad={107.0245361328125,7.223478317260742,7855.751953125}},{id=35,world=3,group="01-03 BAMBOO",path={"MUNDO3","STAGES","01-03 BAMBOO","Stage35"},floor={156.6999969482422,2.0,7839.9599609375},pad={207.0245361328125,7.223478317260742,7855.751953125}},{id=36,world=3,group="01-03 BAMBOO",path={"MUNDO3","STAGES","01-03 BAMBOO","Stage36"},floor={259.20001220703125,2.0,7839.9599609375},pad={312.024658203125,7.223478317260742,7855.751953125}},{id=37,world=3,group="04-06 VILLAGE",path={"MUNDO3","STAGES","04-06 VILLAGE","Stage37"},floor={359.20001220703125,2.0,7839.9599609375},pad={407.024658203125,7.223478317260742,7855.751953125}},{id=38,world=3,group="04-06 VILLAGE",path={"MUNDO3","STAGES","04-06 VILLAGE","Stage38"},floor={456.70001220703125,2.0,7839.9599609375},pad=nil},{id=39,world=3,group="04-06 VILLAGE",path={"MUNDO3","STAGES","04-06 VILLAGE","Stage39"},floor=nil,pad=nil},{id=40,world=3,group="07-09 NINJA",path={"MUNDO3","STAGES","07-09 NINJA","Stage40"},floor=nil,pad=nil},{id=41,world=3,group="07-09 NINJA",path={"MUNDO3","STAGES","07-09 NINJA","Stage41"},floor=nil,pad=nil},{id=42,world=3,group="07-09 NINJA",path={"MUNDO3","STAGES","07-09 NINJA","Stage42"},floor=nil,pad=nil},{id=43,world=3,group="10-12 TEMPLE",path={"MUNDO3","STAGES","10-12 TEMPLE","Stage43"},floor=nil,pad=nil},{id=44,world=3,group="10-12 TEMPLE",path={"MUNDO3","STAGES","10-12 TEMPLE","Stage44"},floor=nil,pad=nil},{id=45,world=3,group="10-12 TEMPLE",path={"MUNDO3","STAGES","10-12 TEMPLE","Stage45"},floor=nil,pad=nil},{id=46,world=3,group="13-15 ONI",path={"MUNDO3","STAGES","13-15 ONI","Stage46"},floor=nil,pad=nil},{id=47,world=3,group="13-15 ONI",path={"MUNDO3","STAGES","13-15 ONI","Stage47"},floor=nil,pad=nil},{id=48,world=3,group="13-15 ONI",path={"MUNDO3","STAGES","13-15 ONI","Stage48"},floor=nil,pad=nil},{id=49,world=4,group="01-03 GRAVES",path={"MUNDO4","STAGES","01-03 GRAVES","Stage49"},floor=nil,pad=nil},{id=50,world=4,group="01-03 GRAVES",path={"MUNDO4","STAGES","01-03 GRAVES","Stage50"},floor=nil,pad=nil},{id=51,world=4,group="01-03 GRAVES",path={"MUNDO4","STAGES","01-03 GRAVES","Stage51"},floor=nil,pad=nil},{id=52,world=4,group="04-06 SWAMP",path={"MUNDO4","STAGES","04-06 SWAMP","Stage52"},floor=nil,pad=nil},{id=53,world=4,group="04-06 SWAMP",path={"MUNDO4","STAGES","04-06 SWAMP","Stage53"},floor=nil,pad=nil},{id=54,world=4,group="04-06 SWAMP",path={"MUNDO4","STAGES","04-06 SWAMP","Stage54"},floor=nil,pad=nil},{id=55,world=4,group="07-09 CRYPT",path={"MUNDO4","STAGES","07-09 CRYPT","Stage55"},floor=nil,pad=nil},{id=56,world=4,group="07-09 CRYPT",path={"MUNDO4","STAGES","07-09 CRYPT","Stage56"},floor=nil,pad=nil},{id=57,world=4,group="07-09 CRYPT",path={"MUNDO4","STAGES","07-09 CRYPT","Stage57"},floor=nil,pad=nil},{id=58,world=4,group="10-12 MANOR",path={"MUNDO4","STAGES","10-12 MANOR","Stage58"},floor=nil,pad=nil},{id=59,world=4,group="10-12 MANOR",path={"MUNDO4","STAGES","10-12 MANOR","Stage59"},floor=nil,pad=nil},{id=60,world=4,group="10-12 MANOR",path={"MUNDO4","STAGES","10-12 MANOR","Stage60"},floor=nil,pad=nil},{id=61,world=4,group="13-15 REAPER",path={"MUNDO4","STAGES","13-15 REAPER","Stage61"},floor=nil,pad=nil},{id=62,world=4,group="13-15 REAPER",path={"MUNDO4","STAGES","13-15 REAPER","Stage62"},floor=nil,pad=nil},{id=63,world=4,group="13-15 REAPER",path={"MUNDO4","STAGES","13-15 REAPER","Stage63"},floor=nil,pad=nil}}

end)()
local Combat = (function()
local Combat = {}
-- Filter only the game's local mob folder and the selected stage's floor bounds.
function Combat.within(position, floor, margin)
    local localPoint=floor.CFrame:PointToObjectSpace(position)
    margin=margin or 8
    return math.abs(localPoint.X)<=floor.Size.X/2+margin
        and math.abs(localPoint.Z)<=floor.Size.Z/2+margin
        and math.abs(localPoint.Y)<=60
end
function Combat.alive(model)
    local humanoid=model:FindFirstChildOfClass("Humanoid")
    if humanoid then return humanoid.Health>0 end
    for _,key in ipairs({"Health","HP","Vida"}) do
        local value=model:GetAttribute(key)
        if type(value)=="number" then return value>0 end
    end
    return model.Parent~=nil
end
function Combat.pick(folder,floor,origin)
    if not folder or not floor then return nil end
    local chosen,distance=nil,math.huge
    for _,model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and Combat.alive(model) then
            local part=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
            if part and Combat.within(part.Position,floor) then
                local d=(part.Position-origin).Magnitude
                if d<distance then chosen,distance=model,d end
            end
        end
    end
    return chosen,distance
end
return Combat

end)()
-- Combined with core.lua and the dump-derived catalog by build.py.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Http = game:GetService("HttpService")
local player = Players.LocalPlayer
assert(player, "Run Stage Farm from the Roblox client")
assert(game.PlaceId == 120731410233153, "This build targets place 120731410233153")
local env = (getgenv and getgenv()) or _G
if env.DevilStageFarm then env.DevilStageFarm:Destroy() end
local App = {alive=true, connections={}, recipes={}, jobs={}, logs={}, runs=0, gained=0, phase="Idle", capture=false, generation=0}
App.combatProbe=false; App.combatMessages={}
env.DevilStageFarm = App
local CONFIG_FILE = "DevilStageFarm.settings.json"
local config = {world=1,group="All",stage=1,mode="Repeat",first=1,last=18,dwell=15,claimWait=6,clickInterval=0.2,respawn=true,tool=false,autos={}}
local FEATURES = {
    {id="Train",label="Auto Train / Click",names={"Click","Fuerza"},interval=0.2},
    {id="Daily",label="Auto Daily Reward",names={"Daily_Reclamar"},interval=60},
    {id="Gifts",label="Auto Timed Gifts",names={"Regalos_Reclamar","Regalo","RegaloSalida"},interval=30},
    {id="Quests",label="Auto Quest Action",names={"Misiones"},interval=15},
    {id="Rebirth",label="Auto Rebirth (resets progress)",names={"Rebirth"},interval=15},
    {id="Boss",label="Auto Boss Action",names={"Jefe"},interval=3},
    {id="Eggs",label="Auto Hatch (spends currency)",names={"Huevo_Abrir"},interval=5},
    {id="Offline",label="Auto Offline Claim",names={"Offline"},interval=60},
}
local featureFor = {}
for _, f in ipairs(FEATURES) do
    config.autos[f.id] = {enabled=false,interval=f.interval}
    App.jobs[f.id] = {nextAt=0,busy=false,errors=0,successes=0,index=0}
    for _, name in ipairs(f.names) do featureFor[name]=f.id end
end
local function connect(signal,fn)
    local c=signal:Connect(fn); table.insert(App.connections,c); return c
end
local function log(message)
    message=tostring(message)
    if App.logs[#App.logs] ~= message then
        table.insert(App.logs,message)
        if #App.logs>30 then table.remove(App.logs,1) end
    end
end
function App:RecordCombat(direction,remote,args)
    if not self.alive or not self.combatProbe then return end
    local list=self.combatMessages
    table.insert(list,{direction=direction,remote=remote:GetFullName(),method=direction=="incoming" and "OnClientEvent" or "FireServer",args=Core.describe(args),time=os.clock()})
    if #list>30 then table.remove(list,1) end
end
local arena=RS:FindFirstChild("Arena")
local arenaRemotes=arena and arena:FindFirstChild("Remotos")
if arenaRemotes then
    for _,remote in ipairs(arenaRemotes:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            connect(remote.OnClientEvent,function(...) App:RecordCombat("incoming",remote,table.pack(...)) end)
        end
    end
end
local function save()
    if type(writefile)~="function" then return false end
    local ok,err=pcall(function() writefile(CONFIG_FILE,Http:JSONEncode(config)) end)
    if not ok then log("Settings save failed: "..tostring(err)) end
    return ok
end
if type(readfile)=="function" then
    pcall(function()
        local loaded=Http:JSONDecode(readfile(CONFIG_FILE))
        config.world=math.floor(Core.number(loaded.world,1,1,4))
        config.stage=math.floor(Core.number(loaded.stage,1,1,63))
        config.group=type(loaded.group)=="string" and loaded.group or "All"
        config.mode=loaded.mode=="Range" and "Range" or "Repeat"
        config.first=math.floor(Core.number(loaded.first,1,1,63)); config.last=math.floor(Core.number(loaded.last,18,1,63))
        config.dwell=Core.number(loaded.dwell,15,3,180); config.claimWait=Core.number(loaded.claimWait,6,2,60)
        config.clickInterval=Core.number(loaded.clickInterval,0.2,0.1,5)
        config.respawn=loaded.respawn~=false; config.tool=loaded.tool==true
        -- Automation is always off on a fresh run; captured recipes are session-only.
        for _, f in ipairs(FEATURES) do
            local prior=type(loaded.autos)=="table" and loaded.autos[f.id]
            if type(prior)=="table" then config.autos[f.id].interval=Core.number(prior.interval,f.interval,f.interval,300) end
        end
    end)
end
local function character()
    local c=player.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health>0 then return c,h,r end
end
local function wins()
    local stats=player:FindFirstChild("leaderstats")
    local value=stats and stats:FindFirstChild("Wins")
    return value and tonumber(value.Value) or nil
end
local function findPath(path)
    local obj=workspace
    for _, segment in ipairs(path) do
        obj=obj and obj:FindFirstChild(segment)
        if not obj then return end
    end
    return obj
end
local function floorFor(stage)
    local root=findPath(stage.path)
    return root and root:FindFirstChild("FloorS"..stage.id)
end
local function padFor(stage)
    local path=table.clone(stage.path); path[#path]="Tunel"..stage.id
    local tunnel=findPath(path)
    local pads=tunnel and tunnel:FindFirstChild("WinPads")
    local model=pads and pads:FindFirstChild("Stage"..stage.id.."_WinPad")
    return model and model:FindFirstChild("WinPadHitbox",true)
end
local function livePosition(stage,kind)
    local part
    if kind=="floor" then part=floorFor(stage) else part=padFor(stage) end
    if part and part:IsA("BasePart") then return part.Position,part end
    local fallback=stage[kind]
    if fallback then return Vector3.new(unpack(fallback)),nil end
end
local function moveAbove(position,part)
    local c,_,r=character()
    if not c then return false end
    local height=part and part.Size.Y/2 or 0
    c:PivotTo(CFrame.new(position+Vector3.new(0,height+3,0))*r.CFrame.Rotation)
    r.AssemblyLinearVelocity=Vector3.zero; r.AssemblyAngularVelocity=Vector3.zero
    return true
end
local function touchPad(part)
    local _,_,root=character()
    if part and root and type(firetouchinterest)=="function" then
        -- Send a begin followed by an end for the actual pad; server rules still apply.
        pcall(firetouchinterest,root,part,0)
        task.delay(0.15,function()
            if root.Parent and part.Parent then pcall(firetouchinterest,root,part,1) end
        end)
    end
end
local function pauseFarm(message)
    App.farming=false; App.generation+=1; App.phase="Paused"; log(message)
end
local function waitActive(seconds,generation)
    local untilAt=os.clock()+seconds
    repeat
        if not App.alive or not App.farming or App.generation~=generation then return false end
        task.wait(0.1)
    until os.clock()>=untilAt
    return true
end
local function activateButton(button)
    if not button or not button:IsA("GuiButton") or not button.Active then return false end
    if type(firesignal)~="function" then return false end
    -- Choose one existing signal instead of firing two and submitting twice.
    local signal=button.MouseButton1Click
    if type(getconnections)=="function" then
        local ok,connections=pcall(getconnections,button.Activated)
        if ok and #connections>0 then signal=button.Activated end
    end
    local ok=pcall(firesignal,signal)
    return ok
end
local function travelWorld(world)
    local pg=player:FindFirstChildOfClass("PlayerGui")
    local panel=pg and pg:FindFirstChild("PanelMundo")
    local card=panel and panel:FindFirstChild("Mundo"..world,true)
    local btn=card and card:FindFirstChild("Boton")
    if activateButton(btn) then
        log("Requested World "..world.." through the game's button; unlock rules apply")
        return true
    end
    log("Open the game's World menu and travel manually, then press Rescan")
    return false
end
local function runFarm(generation)
    local route=Core.route(Catalog,config.world,config.group,config.mode,config.stage,config.first,config.last)
    if #route==0 then pauseFarm("No stages in the selected range / area"); return end
    local index,failures=1,0
    while App.alive and App.farming and App.generation==generation do
        local stage=route[index]; App.target=stage
        if not character() then
            App.phase="Waiting for respawn"
            if not config.respawn then pauseFarm("Character died; resume after respawn"); return end
            if not waitActive(1,generation) then return end
            continue
        end
        App.phase="Preparing Stage "..stage.id
        local position,part=livePosition(stage,"floor")
        if not position then
            pauseFarm("Stage "..stage.id.." is not streamed. Travel to its World / area, then Rescan and Start")
            return
        end
        if not part and workspace.StreamingEnabled then
            pcall(function() player:RequestStreamAroundAsync(position,3) end)
            if not App.alive or not App.farming or App.generation~=generation then return end
            position,part=livePosition(stage,"floor")
        end
        moveAbove(position,part)
        App.phase="Fighting Stage "..stage.id
        if not waitActive(config.dwell,generation) then return end
        if not character() then continue end
        local rewardPosition,rewardPart=livePosition(stage,"pad")
        if not rewardPosition then
            failures+=1; log("Stage "..stage.id..": normal WinPad is not streamed")
        else
            local before=wins()
            if before==nil then pauseFarm("leaderstats.Wins is missing; reward verification unavailable"); return end
            App.phase="Collecting Stage "..stage.id
            moveAbove(rewardPosition,rewardPart); touchPad(rewardPart)
            local claimed=false; local deadline=os.clock()+config.claimWait
            repeat
                if not waitActive(0.25,generation) then return end
                local after=wins()
                if after and after>before then
                    App.runs+=1; App.gained+=after-before; claimed=true; failures=0
                    log("Wins increased after Stage "..stage.id..": +"..tostring(after-before))
                    break
                end
            until os.clock()>=deadline
            if claimed then index=index%#route+1 else
                failures+=1; log("No Wins increase. Check strength, unlock, combat, or increase fight time")
            end
        end
        if failures>=3 then pauseFarm("Stopped after 3 unconfirmed rewards; check the game requirements"); return end
        App.phase="Returning"
        if not waitActive(0.8,generation) then return end
    end
end
function App:StartFarm()
    if self.farming then return end
    self.farming=true; self.generation+=1
    local generation=self.generation
    task.spawn(function()
        local ok,err=pcall(runFarm,generation)
        if not ok and App.alive and App.generation==generation then pauseFarm("Farm error: "..tostring(err)) end
    end)
end
-- Reuse one transparent namecall observer across reloads. It never changes arguments/results.
local observer=env.DevilStageFarmObserver
if observer and observer.version~=2 then observer.app=nil; observer=nil end
if not observer then
    observer={version=2,owned=setmetatable({},{__mode="k"})}; env.DevilStageFarmObserver=observer
    if type(hookmetamethod)=="function" and type(getnamecallmethod)=="function" then
        local original
        local wrapper=function(remote,...)
            local method=getnamecallmethod()
            local app=observer.app
            if app and app.alive and app.combatProbe and method=="FireServer" and typeof(remote)=="Instance"
                and remote.Parent and remote.Parent.Name=="Remotos" and remote.Parent.Parent==RS:FindFirstChild("Arena") then
                local args=table.pack(...)
                pcall(function() app:RecordCombat("outgoing",remote,args) end)
            end
            if app and app.alive and app.capture and not observer.owned[coroutine.running()]
                and (method=="FireServer" or method=="InvokeServer") and typeof(remote)=="Instance"
                and remote.Parent==RS:FindFirstChild("Remotes") and featureFor[remote.Name] then
                local args=table.pack(...)
                pcall(function()
                    local snapshot=Core.copy(args)
                    local feature=featureFor[remote.Name]
                    local recipes=app.recipes[feature] or {}; app.recipes[feature]=recipes
                    local signature=remote.Name..":"..Core.signature(snapshot)
                    local found=false
                    for _,recipe in ipairs(recipes) do
                        if recipe.signature==signature then recipe.args=snapshot; found=true; break end
                    end
                    if not found then
                        table.insert(recipes,{remote=remote,method=method,args=snapshot,signature=signature})
                        if #recipes>8 then table.remove(recipes,1) end
                    end
                    app.lastCapture=remote.Name.." ("..tostring(args.n).." args)"
                end)
            end
            return original(remote,...)
        end
        local ok,result=pcall(function()
            original=hookmetamethod(game,"__namecall",type(newcclosure)=="function" and newcclosure(wrapper) or wrapper)
            return true
        end)
        observer.available=ok and result==true
    else observer.available=false end
end
observer.app=App
local function replay(recipe)
    if not recipe.remote.Parent then error("The captured remote no longer exists; learn it again") end
    local args=Core.copy(recipe.args)
    local thread=coroutine.running(); observer.owned[thread]=true
    local ok,result=pcall(function()
        if recipe.method=="InvokeServer" then return recipe.remote:InvokeServer(table.unpack(args,1,args.n)) end
        recipe.remote:FireServer(table.unpack(args,1,args.n))
    end)
    observer.owned[thread]=nil
    if not ok then error(result) end
    return result
end
local function jobStep(f,job)
    local recipes=App.recipes[f.id]
    if not recipes or #recipes==0 then return end
    job.busy=true; job.nextAt=os.clock()+config.autos[f.id].interval
    local epoch=App.recipeEpoch or 0
    task.spawn(function()
        job.index=job.index%#recipes+1
        local recipe=recipes[job.index]
        local ok,result=pcall(replay,recipe)
        if not App.alive or epoch~=(App.recipeEpoch or 0) then job.busy=false; return end
        job.busy=false
        -- Sending successfully does not prove the server accepted a reward/purchase.
        if ok then job.successes+=1; job.errors=0 else
            job.errors+=1; log(f.label..": "..tostring(result))
            if job.errors>=3 then config.autos[f.id].enabled=false; log(f.label.." paused after 3 errors") end
        end
    end)
end
-- OuroFlow pinned to the same revision used by the production Devil Hub GUIs.
local UI_URL="https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau"
local LOGO_URL="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"
local attack={enabled=false,follow=false,interval=0.15,distance=5,nextAt=0,target=nil}
local widgets={}
local UI
local syncing=true
function App:Destroy()
    if not self.alive then return end
    self.alive=false; self.farming=false; self.capture=false; self.generation+=1
    self.combatProbe=false
    attack.enabled=false; attack.follow=false
    local _,humanoid,root=character()
    if humanoid and root then pcall(humanoid.MoveTo,humanoid,root.Position) end
    if observer.app==self then observer.app=nil end
    for _,c in ipairs(self.connections) do c:Disconnect() end
    if UI then pcall(UI.Destroy,UI) end
    if env.DevilStageFarm==self then env.DevilStageFarm=nil end
end
local function fetch(url)
    local last
    for attempt=1,3 do
        local ok,body=pcall(game.HttpGet,game,url)
        if ok and type(body)=="string" and #body>0 and not body:match("^%s*<") then return body end
        last=body
        if attempt<3 then task.wait(0.5) end
    end
    error("GUI download failed: "..tostring(last))
end
local function logo()
    local asset=getcustomasset or getsynasset
    if type(asset)~="function" or type(writefile)~="function" then return "flame" end
    local ok,path=pcall(function()
        local file="devil-stage-logo.png"
        if type(isfile)~="function" or not isfile(file) then
            local bytes=fetch(LOGO_URL)
            assert(bytes:sub(1,8)=="\137PNG\13\10\26\10","Invalid logo image")
            writefile(file,bytes)
        end
        return asset(file)
    end)
    return ok and path or "flame"
end
local function selectedStage()
    local id=App.farming and App.target and App.target.id or config.stage
    for _,stage in ipairs(Catalog) do if stage.id==id then return stage end end
end
local function normalize()
    if App.farming then pauseFarm("Selection changed; press Start for the new route") end
    local choices=Core.stages(Catalog,config.world,config.group)
    if #choices==0 then config.group="All"; choices=Core.stages(Catalog,config.world) end
    if #choices==0 then return end
    local found=false
    for _,s in ipairs(choices) do if s.id==config.stage then found=true end end
    if not found then config.stage=choices[1].id end
    config.first=math.max(choices[1].id,math.min(config.first,choices[#choices].id))
    config.last=math.max(config.first,math.min(config.last,choices[#choices].id))
end
local function groupOptions()
    local options={"All"}; local seen={}
    for _,s in ipairs(Core.stages(Catalog,config.world)) do
        if not seen[s.group] then seen[s.group]=true; table.insert(options,s.group) end
    end
    return options
end
local function stageOptions()
    local options={}
    for _,stage in ipairs(Core.stages(Catalog,config.world,config.group)) do table.insert(options,"Stage "..stage.id) end
    return options
end
local function sync()
    syncing=true
    if widgets.world then widgets.world:Set("World "..config.world,true) end
    if widgets.group then widgets.group:Refresh(groupOptions(),false,true); widgets.group:Set(config.group,true) end
    if widgets.stage then widgets.stage:Refresh(stageOptions(),false,true); widgets.stage:Set("Stage "..config.stage,true) end
    if widgets.first then widgets.first:Set(config.first,true) end
    if widgets.last then widgets.last:Set(config.last,true) end
    if widgets.capture then widgets.capture:Set(App.capture,true) end
    if widgets.tool then widgets.tool:Set(attack.enabled,true) end
    if widgets.follow then widgets.follow:Set(attack.follow,true) end
    if widgets.probe then widgets.probe:Set(App.combatProbe,true) end
    for _,f in ipairs(FEATURES) do
        if widgets[f.id] then widgets[f.id]:Set(config.autos[f.id].enabled,true) end
    end
    syncing=false
end
local function stopAll()
    pauseFarm("All automation stopped")
    App.capture=false; config.tool=false; attack.enabled=false; attack.follow=false
    App.combatProbe=false
    for _,f in ipairs(FEATURES) do config.autos[f.id].enabled=false end
    local _,humanoid,root=character()
    if humanoid and root then humanoid:MoveTo(root.Position) end
    sync()
end
local function rescan()
    pauseFarm("Rescanning loaded stages")
    local _,_,root=character(); local nearest,distance=nil,math.huge; local count=0
    for _,stage in ipairs(Catalog) do
        local floor=floorFor(stage)
        if floor and floor:IsA("BasePart") then
            count+=1
            if root then
                local d=(root.Position-floor.Position).Magnitude
                if d<distance then nearest,distance=stage,d end
            end
        end
    end
    if nearest then
        config.world=nearest.world; config.group=nearest.group; config.stage=nearest.id
        config.first=nearest.id; config.last=nearest.id
    end
    normalize(); sync(); save(); log("Loaded stage floors: "..count)
end
local function addToggle(group,name,current,callback)
    return group:CreateToggle({Name=name,CurrentValue=current,Callback=function(value)
        if not syncing and App.alive then callback(value==true) end
    end})
end
local function addSlider(group,name,value,minimum,maximum,increment,callback)
    return group:CreateSlider({Name=name,CurrentValue=value,Range={minimum,maximum},Increment=increment,Callback=function(v)
        if not syncing and App.alive then callback(Core.number(v,value,minimum,maximum)); save() end
    end})
end
local function addButton(group,name,callback)
    return group:CreateButton({Name=name,Callback=function()
        if App.alive then
            local ok,err=pcall(callback)
            if not ok then log(tostring(err)) end
        end
    end})
end
local built,buildError=pcall(function()
    local source=fetch(UI_URL)
    local chunk,err=loadstring(source,"@DevilStageFarm/OuroFlow")
    assert(chunk,err)
    local Library=chunk()
    assert(type(Library)=="table" and type(Library.CreateWindow)=="function","GUI library initialization failed")
    local icon=logo()
    UI=Library:CreateWindow({Name="DEVIL HUB",Icon=icon,LoadingSubtitle="STAGE FARM / COMBAT",
        Theme="Crimson",Density="Compact",Profile=true,Search=true,Home=false,Loading=false,
        Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(760,510),
        ConfigurationSaving={Enabled=false,FolderName="DevilStageFarm"},
        ToggleButton={Platform="Both",Icon=icon},IslandDraggable=true,KeepOnScreen=true})
    App.Window=UI; App.gui=UI.Gui
    UI.Gui:SetAttribute("DevilStageFarmFrontend",true)
    local farm=UI:CreateTab({Name="Farm",Icon="tractor",Backdrop=false})
    local combat=UI:CreateTab({Name="Combat",Icon="swords",Backdrop=false})
    local autos=UI:CreateTab({Name="Auto",Icon="repeat",Backdrop=false})
    local settings=UI:CreateTab({Name="Settings",Icon="settings",Backdrop=false})
    local select=farm:CreateGroupbox({Name="World / Area / Stage",Icon="map",Side="Left"})
    normalize()
    widgets.world=select:CreateDropdown({Name="World",Options={"World 1","World 2","World 3","World 4"},CurrentOption="World "..config.world,Searchable=true,Callback=function(v)
        if syncing then return end
        local id=tonumber(tostring(v):match("(%d+)"))
        if id and id>=1 and id<=4 then
            config.world=id; config.group="All"
            local stages=Core.stages(Catalog,id)
            config.first=stages[1].id; config.last=stages[#stages].id
            normalize(); sync(); save()
        end
    end})
    widgets.group=select:CreateDropdown({Name="Area",Options=groupOptions(),CurrentOption=config.group,Searchable=true,Callback=function(v)
        if syncing then return end
        config.group=tostring(v); normalize(); sync(); save()
    end})
    widgets.stage=select:CreateDropdown({Name="Stage",Options=stageOptions(),CurrentOption="Stage "..config.stage,Searchable=true,Callback=function(v)
        if syncing then return end
        local id=tonumber(tostring(v):match("(%d+)"))
        if id then config.stage=id; normalize(); sync(); save() end
    end})
    select:CreateDropdown({Name="Farm mode",Options={"Repeat","Range"},CurrentOption=config.mode,Callback=function(v)
        if syncing then return end
        config.mode=v=="Range" and "Range" or "Repeat"; normalize(); sync(); save()
    end})
    widgets.first=addSlider(select,"Range start",config.first,1,63,1,function(v) config.first=math.floor(v); normalize(); sync() end)
    widgets.last=addSlider(select,"Range end",config.last,1,63,1,function(v) config.last=math.floor(v); normalize(); sync() end)
    addButton(select,"Travel to World",function() pauseFarm("World travel"); travelWorld(config.world) end)
    addButton(select,"Go to selected Stage",function()
        pauseFarm("Manual stage travel")
        local stage=selectedStage(); local p,part
        if stage then p,part=livePosition(stage,"floor") end
        if p then moveAbove(p,part) else log("Stage is not streamed. Enter its World then Rescan") end
    end)
    addButton(select,"Rescan / Follow my area",rescan)
    local run=farm:CreateGroupbox({Name="Farm Control",Icon="play",Side="Right"})
    addSlider(run,"Fight time (seconds)",config.dwell,3,180,1,function(v) config.dwell=v end)
    addSlider(run,"Reward wait (seconds)",config.claimWait,2,60,1,function(v) config.claimWait=v end)
    addToggle(run,"Resume after respawn",config.respawn,function(v) config.respawn=v; save() end)
    addButton(run,"START FARM",function() App:StartFarm() end)
    addButton(run,"Stop Farm",function() pauseFarm("Farm stopped") end)
    addButton(run,"STOP ALL",stopAll)
    widgets.status=run:CreateLabel({Text="Ready"})
    widgets.geometry=run:CreateLabel({Text="Choose a loaded Stage"})
    local attackBox=combat:CreateGroupbox({Name="Attack / Target",Icon="swords",Side="Left"})
    widgets.tool=addToggle(attackBox,"Auto Attack / Equip Tool",false,function(v) attack.enabled=v; config.tool=v end)
    widgets.follow=addToggle(attackBox,"Follow nearest mob in selected Stage",false,function(v) attack.follow=v end)
    addSlider(attackBox,"Attack interval (seconds)",attack.interval,0.1,2,0.05,function(v) attack.interval=v end)
    addSlider(attackBox,"Distance from target",attack.distance,3,12,1,function(v) attack.distance=v end)
    addButton(attackBox,"Combat training preset",function()
        attack.enabled=true; attack.interval=0.1
        if #(App.recipes.Train or {})>0 then config.autos.Train.enabled=true; config.autos.Train.interval=0.1 end
        sync(); log("Tool attack enabled. Learned training enabled when available; server determines damage")
    end)
    widgets.target=attackBox:CreateLabel({Text="Target: none"})
    local damage=combat:CreateGroupbox({Name="Strength / Damage",Icon="activity",Side="Right"})
    widgets.strength=damage:CreateLabel({Text="Strength: waiting"})
    damage:CreateLabel({Text="Damage is controlled by the game. This dump does not establish a one-hit method."})
    damage:CreateLabel({Text="Training replays your observed Click / Fuerza action. No damage value or mob-health override is sent."})
    widgets.probe=addToggle(damage,"Record combat messages",false,function(v) App.combatProbe=v end)
    addButton(damage,"Clear combat recording",function() App.combatMessages={}; log("Combat recording cleared") end)
    addButton(damage,"Copy combat report",function()
        local stats=player:FindFirstChild("leaderstats")
        local report={place=game.PlaceId,world=config.world,stage=config.stage,stats={},target=attack.target and attack.target.Name or nil,tool=attack.enabled,learnedTrain=#(App.recipes.Train or {}),combatMessages=App.combatMessages}
        if stats then for _,value in ipairs(stats:GetChildren()) do if value:IsA("ValueBase") then report.stats[value.Name]=tostring(value.Value) end end end
        if type(setclipboard)=="function" then setclipboard(Http:JSONEncode(report)); log("Combat report copied") else log("Clipboard unavailable") end
    end)
    local learn=autos:CreateGroupbox({Name="Learn Game Actions",Icon="scan",Side="Left"})
    learn:CreateLabel({Text="Enable Learn, press a real game button once, then disable Learn and enable its auto."})
    widgets.capture=addToggle(learn,"Learn actions",false,function(v)
        if v and not observer.available then log("Learning unavailable in this environment"); sync(); return end
        App.capture=v
    end)
    addButton(learn,"Clear learned actions",function()
        App.recipes={}; App.recipeEpoch=(App.recipeEpoch or 0)+1; App.lastCapture=nil
        for _,f in ipairs(FEATURES) do config.autos[f.id].enabled=false end
        sync(); log("Learned actions cleared; remote autos off")
    end)
    widgets.learned=learn:CreateLabel({Text="No learned actions"})
    local remote=autos:CreateGroupbox({Name="Automation",Icon="repeat",Side="Right"})
    for _,f in ipairs(FEATURES) do
        local feature=f
        widgets[feature.id]=addToggle(remote,feature.label,false,function(value)
            if value and #(App.recipes[feature.id] or {})==0 then log("Learn "..feature.label.." first"); sync(); return end
            config.autos[feature.id].enabled=value; save()
        end)
        addSlider(remote,feature.id.." interval",config.autos[feature.id].interval,feature.id=="Train" and 0.1 or feature.interval,300,feature.id=="Train" and 0.1 or 1,function(v) config.autos[feature.id].interval=v end)
    end
    local utility=settings:CreateGroupbox({Name="Session",Icon="settings",Side="Left"})
    addButton(utility,"Save settings",function() log(save() and "Settings saved" or "File saving unavailable") end)
    addButton(utility,"STOP ALL",stopAll)
    addButton(utility,"Unload",function() App:Destroy() end)
    utility:CreateLabel({Text="Same OuroFlow / Crimson interface as the main Devil Hub. Use the floating logo to toggle the window."})
    local logs=settings:CreateGroupbox({Name="Status",Icon="terminal",Side="Right"})
    widgets.logs=logs:CreateLabel({Text="Starting"})
    logs:CreateLabel({Text="World 1–4 / Stage 1–63. Map streaming and server combat requirements still apply."})
    if UI.Gui.Destroying then connect(UI.Gui.Destroying,function() if App.alive then App:Destroy() end end) end
    sync()
end)
if not built then
    App:Destroy()
    error("DEVIL STAGE FARM GUI: "..tostring(buildError),0)
end
local function combatStep(now)
    if not character() then attack.target=nil; return end
    local c,h,root=character()
    local stage=selectedStage(); local floor=stage and floorFor(stage)
    local folder=workspace:FindFirstChild("_MobsLocal")
    attack.target=Combat.pick(folder,floor,root.Position)
    -- Keep movement off during reward collection or farm travel.
    local mayFollow=not App.farming or App.phase=="Fighting Stage "..(stage and stage.id or 0)
    if attack.follow and mayFollow and attack.target then
        local part=attack.target.PrimaryPart or attack.target:FindFirstChildWhichIsA("BasePart",true)
        if part then
            local offset=root.Position-part.Position
            local horizontal=Vector3.new(offset.X,0,offset.Z)
            local direction=horizontal.Magnitude>0.01 and horizontal.Unit or Vector3.new(0,0,1)
            local destination=part.Position+direction*attack.distance
            if floor and Combat.within(destination,floor,0) and offset.Magnitude>attack.distance+2 then
                h:MoveTo(destination)
            end
        end
    end
    if attack.enabled and now>=attack.nextAt then
        attack.nextAt=now+attack.interval
        local backpack=player:FindFirstChildOfClass("Backpack")
        local tool=c:FindFirstChildOfClass("Tool") or backpack and backpack:FindFirstChildOfClass("Tool")
        if tool then
            if tool.Parent~=c then h:EquipTool(tool) end
            tool:Activate()
        end
    end
end
task.spawn(function()
    local lastUI=0
    while App.alive do
        local now=os.clock()
        for _,f in ipairs(FEATURES) do
            if Core.ready(config.autos[f.id],App.jobs[f.id],now) then jobStep(f,App.jobs[f.id]) end
        end
        local ok,err=pcall(combatStep,now)
        if not ok then attack.enabled=false; attack.follow=false; sync(); log("Combat paused: "..tostring(err)) end
        if now-lastUI>=0.5 then
            lastUI=now
            widgets.status:Set(string.format("%s | Runs %d | Wins +%s",App.phase,App.runs,tostring(App.gained)),true)
            local stage=selectedStage()
            local floor=stage and floorFor(stage); local pad=stage and padFor(stage)
            widgets.geometry:Set("Floor: "..(floor and "loaded" or "not streamed").." | WinPad: "..(pad and "loaded" or "not streamed"),true)
            widgets.target:Set("Target: "..(attack.target and attack.target.Name or "none"),true)
            local stats=player:FindFirstChild("leaderstats"); local strength=stats and stats:FindFirstChild("Strength")
            widgets.strength:Set("Strength: "..(strength and tostring(strength.Value) or "unavailable"),true)
            local entries={}
            for _,f in ipairs(FEATURES) do table.insert(entries,f.id..": "..#(App.recipes[f.id] or {})) end
            widgets.learned:Set(table.concat(entries," | ").."\nLast: "..(App.lastCapture or "none"),true)
            widgets.logs:Set(table.concat(App.logs,"\n",math.max(1,#App.logs-3),#App.logs),true)
            syncing=true
            widgets.capture:Set(App.capture,true)
            widgets.tool:Set(attack.enabled,true); widgets.follow:Set(attack.follow,true)
            if widgets.probe then widgets.probe:Set(App.combatProbe,true) end
            for _,f in ipairs(FEATURES) do widgets[f.id]:Set(config.autos[f.id].enabled,true) end
            syncing=false
        end
        task.wait(0.1)
    end
end)
log("OuroFlow Crimson ready. Select a loaded Stage or Rescan")
if not observer.available then log("Learning unavailable; Tool attack and stage movement remain available") end
return App
