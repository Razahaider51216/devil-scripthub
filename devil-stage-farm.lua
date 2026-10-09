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
return Core

end)()
local Catalog = (function()
return {{id=1,world=1,group="01-03 FIELDS",path={"STAGES","01-03 FIELDS","Stage1"},floor=nil,pad=nil},{id=2,world=1,group="01-03 FIELDS",path={"STAGES","01-03 FIELDS","Stage2"},floor=nil,pad=nil},{id=3,world=1,group="01-03 FIELDS",path={"STAGES","01-03 FIELDS","Stage3"},floor=nil,pad=nil},{id=4,world=1,group="04-06 PIRATES",path={"STAGES","04-06 PIRATES","Stage4"},floor=nil,pad=nil},{id=5,world=1,group="04-06 PIRATES",path={"STAGES","04-06 PIRATES","Stage5"},floor=nil,pad=nil},{id=6,world=1,group="04-06 PIRATES",path={"STAGES","04-06 PIRATES","Stage6"},floor=nil,pad=nil},{id=7,world=1,group="07-09 BARBARIANS",path={"STAGES","07-09 BARBARIANS","Stage7"},floor=nil,pad=nil},{id=8,world=1,group="07-09 BARBARIANS",path={"STAGES","07-09 BARBARIANS","Stage8"},floor=nil,pad=nil},{id=9,world=1,group="07-09 BARBARIANS",path={"STAGES","07-09 BARBARIANS","Stage9"},floor=nil,pad=nil},{id=10,world=1,group="10-12 ASSASSINS",path={"STAGES","10-12 ASSASSINS","Stage10"},floor=nil,pad=nil},{id=11,world=1,group="10-12 ASSASSINS",path={"STAGES","10-12 ASSASSINS","Stage11"},floor=nil,pad=nil},{id=12,world=1,group="10-12 ASSASSINS",path={"STAGES","10-12 ASSASSINS","Stage12"},floor=nil,pad=nil},{id=13,world=1,group="13-15 KNIGHTS",path={"STAGES","13-15 KNIGHTS","Stage13"},floor=nil,pad=nil},{id=14,world=1,group="13-15 KNIGHTS",path={"STAGES","13-15 KNIGHTS","Stage14"},floor=nil,pad=nil},{id=15,world=1,group="13-15 KNIGHTS",path={"STAGES","13-15 KNIGHTS","Stage15"},floor=nil,pad=nil},{id=16,world=1,group="16-18 MAGES",path={"STAGES","16-18 MAGES","Stage16"},floor=nil,pad=nil},{id=17,world=1,group="16-18 MAGES",path={"STAGES","16-18 MAGES","Stage17"},floor=nil,pad=nil},{id=18,world=1,group="16-18 MAGES",path={"STAGES","16-18 MAGES","Stage18"},floor=nil,pad=nil},{id=19,world=2,group="01-03 DUNES",path={"MUNDO2","STAGES","01-03 DUNES","Stage19"},floor=nil,pad=nil},{id=20,world=2,group="01-03 DUNES",path={"MUNDO2","STAGES","01-03 DUNES","Stage20"},floor=nil,pad=nil},{id=21,world=2,group="01-03 DUNES",path={"MUNDO2","STAGES","01-03 DUNES","Stage21"},floor=nil,pad=nil},{id=22,world=2,group="04-06 OASIS",path={"MUNDO2","STAGES","04-06 OASIS","Stage22"},floor=nil,pad=nil},{id=23,world=2,group="04-06 OASIS",path={"MUNDO2","STAGES","04-06 OASIS","Stage23"},floor=nil,pad=nil},{id=24,world=2,group="04-06 OASIS",path={"MUNDO2","STAGES","04-06 OASIS","Stage24"},floor=nil,pad=nil},{id=25,world=2,group="07-09 TOMBS",path={"MUNDO2","STAGES","07-09 TOMBS","Stage25"},floor=nil,pad=nil},{id=26,world=2,group="07-09 TOMBS",path={"MUNDO2","STAGES","07-09 TOMBS","Stage26"},floor=nil,pad=nil},{id=27,world=2,group="07-09 TOMBS",path={"MUNDO2","STAGES","07-09 TOMBS","Stage27"},floor=nil,pad=nil},{id=28,world=2,group="10-12 SERPENTS",path={"MUNDO2","STAGES","10-12 SERPENTS","Stage28"},floor=nil,pad=nil},{id=29,world=2,group="10-12 SERPENTS",path={"MUNDO2","STAGES","10-12 SERPENTS","Stage29"},floor=nil,pad=nil},{id=30,world=2,group="10-12 SERPENTS",path={"MUNDO2","STAGES","10-12 SERPENTS","Stage30"},floor=nil,pad=nil},{id=31,world=2,group="13-15 PYRAMID",path={"MUNDO2","STAGES","13-15 PYRAMID","Stage31"},floor=nil,pad=nil},{id=32,world=2,group="13-15 PYRAMID",path={"MUNDO2","STAGES","13-15 PYRAMID","Stage32"},floor=nil,pad=nil},{id=33,world=2,group="13-15 PYRAMID",path={"MUNDO2","STAGES","13-15 PYRAMID","Stage33"},floor=nil,pad=nil},{id=34,world=3,group="01-03 BAMBOO",path={"MUNDO3","STAGES","01-03 BAMBOO","Stage34"},floor={59.20000076293945,2.0,7839.9599609375},pad={107.0245361328125,7.223478317260742,7855.751953125}},{id=35,world=3,group="01-03 BAMBOO",path={"MUNDO3","STAGES","01-03 BAMBOO","Stage35"},floor={156.6999969482422,2.0,7839.9599609375},pad={207.0245361328125,7.223478317260742,7855.751953125}},{id=36,world=3,group="01-03 BAMBOO",path={"MUNDO3","STAGES","01-03 BAMBOO","Stage36"},floor={259.20001220703125,2.0,7839.9599609375},pad={312.024658203125,7.223478317260742,7855.751953125}},{id=37,world=3,group="04-06 VILLAGE",path={"MUNDO3","STAGES","04-06 VILLAGE","Stage37"},floor={359.20001220703125,2.0,7839.9599609375},pad={407.024658203125,7.223478317260742,7855.751953125}},{id=38,world=3,group="04-06 VILLAGE",path={"MUNDO3","STAGES","04-06 VILLAGE","Stage38"},floor={456.70001220703125,2.0,7839.9599609375},pad=nil},{id=39,world=3,group="04-06 VILLAGE",path={"MUNDO3","STAGES","04-06 VILLAGE","Stage39"},floor=nil,pad=nil},{id=40,world=3,group="07-09 NINJA",path={"MUNDO3","STAGES","07-09 NINJA","Stage40"},floor=nil,pad=nil},{id=41,world=3,group="07-09 NINJA",path={"MUNDO3","STAGES","07-09 NINJA","Stage41"},floor=nil,pad=nil},{id=42,world=3,group="07-09 NINJA",path={"MUNDO3","STAGES","07-09 NINJA","Stage42"},floor=nil,pad=nil},{id=43,world=3,group="10-12 TEMPLE",path={"MUNDO3","STAGES","10-12 TEMPLE","Stage43"},floor=nil,pad=nil},{id=44,world=3,group="10-12 TEMPLE",path={"MUNDO3","STAGES","10-12 TEMPLE","Stage44"},floor=nil,pad=nil},{id=45,world=3,group="10-12 TEMPLE",path={"MUNDO3","STAGES","10-12 TEMPLE","Stage45"},floor=nil,pad=nil},{id=46,world=3,group="13-15 ONI",path={"MUNDO3","STAGES","13-15 ONI","Stage46"},floor=nil,pad=nil},{id=47,world=3,group="13-15 ONI",path={"MUNDO3","STAGES","13-15 ONI","Stage47"},floor=nil,pad=nil},{id=48,world=3,group="13-15 ONI",path={"MUNDO3","STAGES","13-15 ONI","Stage48"},floor=nil,pad=nil},{id=49,world=4,group="01-03 GRAVES",path={"MUNDO4","STAGES","01-03 GRAVES","Stage49"},floor=nil,pad=nil},{id=50,world=4,group="01-03 GRAVES",path={"MUNDO4","STAGES","01-03 GRAVES","Stage50"},floor=nil,pad=nil},{id=51,world=4,group="01-03 GRAVES",path={"MUNDO4","STAGES","01-03 GRAVES","Stage51"},floor=nil,pad=nil},{id=52,world=4,group="04-06 SWAMP",path={"MUNDO4","STAGES","04-06 SWAMP","Stage52"},floor=nil,pad=nil},{id=53,world=4,group="04-06 SWAMP",path={"MUNDO4","STAGES","04-06 SWAMP","Stage53"},floor=nil,pad=nil},{id=54,world=4,group="04-06 SWAMP",path={"MUNDO4","STAGES","04-06 SWAMP","Stage54"},floor=nil,pad=nil},{id=55,world=4,group="07-09 CRYPT",path={"MUNDO4","STAGES","07-09 CRYPT","Stage55"},floor=nil,pad=nil},{id=56,world=4,group="07-09 CRYPT",path={"MUNDO4","STAGES","07-09 CRYPT","Stage56"},floor=nil,pad=nil},{id=57,world=4,group="07-09 CRYPT",path={"MUNDO4","STAGES","07-09 CRYPT","Stage57"},floor=nil,pad=nil},{id=58,world=4,group="10-12 MANOR",path={"MUNDO4","STAGES","10-12 MANOR","Stage58"},floor=nil,pad=nil},{id=59,world=4,group="10-12 MANOR",path={"MUNDO4","STAGES","10-12 MANOR","Stage59"},floor=nil,pad=nil},{id=60,world=4,group="10-12 MANOR",path={"MUNDO4","STAGES","10-12 MANOR","Stage60"},floor=nil,pad=nil},{id=61,world=4,group="13-15 REAPER",path={"MUNDO4","STAGES","13-15 REAPER","Stage61"},floor=nil,pad=nil},{id=62,world=4,group="13-15 REAPER",path={"MUNDO4","STAGES","13-15 REAPER","Stage62"},floor=nil,pad=nil},{id=63,world=4,group="13-15 REAPER",path={"MUNDO4","STAGES","13-15 REAPER","Stage63"},floor=nil,pad=nil}}

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
if not observer then
    observer={owned=setmetatable({},{__mode="k"})}; env.DevilStageFarmObserver=observer
    if type(hookmetamethod)=="function" and type(getnamecallmethod)=="function" then
        local original
        local wrapper=function(remote,...)
            local method=getnamecallmethod()
            local app=observer.app
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
-- Compact, scrollable UI works without a downloaded UI library.
local gui=Instance.new("ScreenGui")
gui.Name="DevilStageFarmUI"; gui.ResetOnSpawn=false; gui.DisplayOrder=100
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.Parent=player:WaitForChild("PlayerGui")
App.gui=gui
local function make(class,props,parent)
    local obj=Instance.new(class)
    for k,v in pairs(props) do obj[k]=v end
    obj.Parent=parent
    return obj
end
local panel=make("Frame",{Size=UDim2.fromOffset(420,570),Position=UDim2.new(0.04,0,0.1,0),BackgroundColor3=Color3.fromRGB(17,20,30),BorderSizePixel=0},gui)
make("UICorner",{CornerRadius=UDim.new(0,12)},panel)
local title=make("TextButton",{Size=UDim2.new(1,-110,0,44),Position=UDim2.fromOffset(12,0),Text="DEVIL • STAGE FARM",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Color3.fromRGB(220,225,255),BackgroundTransparency=1,AutoButtonColor=false},panel)
local close=make("TextButton",{Size=UDim2.fromOffset(34,30),Position=UDim2.new(1,-40,0,7),Text="×",TextSize=22,BackgroundColor3=Color3.fromRGB(55,29,40),TextColor3=Color3.new(1,1,1)},panel)
local minimize=make("TextButton",{Size=UDim2.fromOffset(34,30),Position=UDim2.new(1,-78,0,7),Text="–",TextSize=22,BackgroundColor3=Color3.fromRGB(35,40,60),TextColor3=Color3.new(1,1,1)},panel)
local scroll=make("ScrollingFrame",{Size=UDim2.new(1,-20,1,-54),Position=UDim2.fromOffset(10,44),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollingDirection=Enum.ScrollingDirection.Y},panel)
make("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
make("UIPadding",{PaddingBottom=UDim.new(0,12)},scroll)
local order=0
local function row(height)
    order+=1
    return make("Frame",{Size=UDim2.new(1,-6,0,height or 34),BackgroundTransparency=1,LayoutOrder=order},scroll)
end
local function text(parent,value,width)
    return make("TextLabel",{Size=UDim2.new(width or 1,0,1,0),Text=value,TextColor3=Color3.fromRGB(203,211,230),TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,TextWrapped=true},parent)
end
local function button(parent,value,position,size,fn)
    local b=make("TextButton",{Text=value,Position=position or UDim2.new(),Size=size or UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(38,46,70),TextColor3=Color3.fromRGB(237,239,255),Font=Enum.Font.GothamMedium,TextSize=13,TextWrapped=true},parent)
    make("UICorner",{CornerRadius=UDim.new(0,6)},b)
    connect(b.Activated,fn)
    return b
end
local function heading(value) text(row(25),value) end
local function numberBox(label,get,set,minimum,maximum)
    local r=row(); text(r,label,0.62)
    local box=make("TextBox",{Size=UDim2.new(0.36,0,1,0),Position=UDim2.fromScale(0.64,0),Text=tostring(get()),ClearTextOnFocus=false,BackgroundColor3=Color3.fromRGB(29,34,50),TextColor3=Color3.new(1,1,1),Font=Enum.Font.Gotham,TextSize=13},r)
    connect(box.FocusLost,function()
        set(Core.number(box.Text,get(),minimum,maximum)); box.Text=tostring(get()); save()
    end)
    return box
end
local dropdowns={}
local function dropdown(label,options,get,set)
    local r=row(); text(r,label,0.33)
    local holder=make("Frame",{Size=UDim2.new(0.66,0,1,0),Position=UDim2.fromScale(0.34,0),BackgroundTransparency=1},r)
    local list=make("ScrollingFrame",{Visible=false,Position=UDim2.new(0,0,0,38),Size=UDim2.new(1,0,0,160),BackgroundColor3=Color3.fromRGB(25,30,46),BorderSizePixel=0,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollBarThickness=4,ZIndex=20},holder)
    make("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},list)
    local b
    b=button(holder,get(),nil,nil,function()
        local open=not list.Visible
        for _,d in ipairs(dropdowns) do d.list.Visible=false; d.row.Size=UDim2.new(1,-6,0,34) end
        list.Visible=open; r.Size=UDim2.new(1,-6,0,open and 200 or 34)
        if open then
            for _,child in ipairs(list:GetChildren()) do if child:IsA("GuiButton") then child:Destroy() end end
            for i,option in ipairs(options()) do
                local opt=button(list,option.label,nil,UDim2.new(1,-6,0,30),function()
                    list.Visible=false; r.Size=UDim2.new(1,-6,0,34); set(option.value); save()
                    for _,d in ipairs(dropdowns) do d.button.Text=d.get() end
                end)
                opt.LayoutOrder=i; opt.ZIndex=21
            end
        end
    end)
    table.insert(dropdowns,{row=r,list=list,button=b,get=get})
end
local function changeSelection()
    if App.farming then pauseFarm("Selection changed; press Start to use the new route") end
    local choices=Core.stages(Catalog,config.world,config.group)
    if #choices==0 then config.group="All"; choices=Core.stages(Catalog,config.world) end
    if #choices>0 then
        local found=false
        for _,s in ipairs(choices) do if s.id==config.stage then found=true end end
        if not found then config.stage=choices[1].id end
        config.first=math.max(choices[1].id,math.min(config.first,choices[#choices].id))
        config.last=math.max(config.first,math.min(config.last,choices[#choices].id))
    end
end
changeSelection()
heading("Choose World → Area → Stage")
dropdown("World",function() return {{label="World 1 • 1–18",value=1},{label="World 2 • 19–33",value=2},{label="World 3 • 34–48",value=3},{label="World 4 • 49–63",value=4}} end,function() return "World "..config.world end,function(v) config.world=v; config.group="All"; changeSelection() end)
dropdown("Area",function()
    local options={{label="All areas",value="All"}}; local seen={}
    for _,s in ipairs(Core.stages(Catalog,config.world)) do if not seen[s.group] then seen[s.group]=true; table.insert(options,{label=s.group,value=s.group}) end end
    return options
end,function() return config.group end,function(v) config.group=v; changeSelection() end)
dropdown("Stage",function()
    local options={}
    for _,s in ipairs(Core.stages(Catalog,config.world,config.group)) do
        local position,part=livePosition(s,"floor")
        table.insert(options,{label="Stage "..s.id..(part and " • Loaded" or position and " • Saved position" or " • Not streamed"),value=s.id})
    end
    return options
end,function() return "Stage "..config.stage end,function(v) config.stage=v; changeSelection() end)
dropdown("Farm mode",function() return {{label="Repeat selected Stage",value="Repeat"},{label="Cycle Stage range",value="Range"}} end,function() return config.mode end,function(v) config.mode=v; changeSelection() end)
local firstBox=numberBox("Range start",function() return config.first end,function(v) config.first=math.floor(v); changeSelection() end,1,63)
local lastBox=numberBox("Range end",function() return config.last end,function(v) config.last=math.floor(v); changeSelection() end,1,63)
numberBox("Fight time (seconds)",function() return config.dwell end,function(v) config.dwell=v end,3,180)
numberBox("Reward wait (seconds)",function() return config.claimWait end,function(v) config.claimWait=v end,2,60)
local controls=row(38)
button(controls,"Start Farm",nil,UDim2.new(0.49,0,1,0),function() App:StartFarm() end)
button(controls,"Stop Farm",UDim2.fromScale(0.51,0),UDim2.new(0.49,0,1,0),function() pauseFarm("Stopped") end)
local travel=row()
button(travel,"Travel World",nil,UDim2.new(0.49,0,1,0),function() pauseFarm("World travel"); travelWorld(config.world) end)
button(travel,"Go to Stage",UDim2.fromScale(0.51,0),UDim2.new(0.49,0,1,0),function()
    pauseFarm("Manual stage travel")
    for _,stage in ipairs(Catalog) do if stage.id==config.stage then
        local position,part=livePosition(stage,"floor")
        if position then moveAbove(position,part) else log("Stage geometry not streamed; enter its World first") end
    end end
end)
local scan=row()
button(scan,"Rescan / Follow my area",nil,nil,function()
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
    if nearest then config.world=nearest.world; config.group=nearest.group; config.stage=nearest.id; config.first=nearest.id; config.last=nearest.id end
    changeSelection(); save(); log("Loaded stage floors: "..count)
    for _,d in ipairs(dropdowns) do d.button.Text=d.get() end
end)
heading("Learn actions once, then enable their auto")
text(row(58),"Turn Learn ON, use the game's own buttons once, then turn Learn OFF. Only observed arguments are replayed. Start Farm moves to the floor and normal WinPad; the game still checks combat and unlocks.")
local captureButton
captureButton=button(row(),"Learn actions: OFF",nil,nil,function()
    if not observer.available then log("Remote observation is unavailable in this environment"); return end
    App.capture=not App.capture; captureButton.Text="Learn actions: "..(App.capture and "ON" or "OFF")
end)
button(row(),"Clear learned actions",nil,nil,function()
    App.recipes={}; App.recipeEpoch=(App.recipeEpoch or 0)+1; App.lastCapture=nil
    for _,f in ipairs(FEATURES) do config.autos[f.id].enabled=false end
    log("Learned actions cleared; all remote autos disabled")
end)
local autoButtons={}
for _,f in ipairs(FEATURES) do
    local feature=f
    local b=button(row(),feature.label..": OFF",nil,nil,function()
        local c=config.autos[feature.id]
        if not c.enabled and #(App.recipes[feature.id] or {})==0 then log("Learn "..feature.label.." by using its game button first"); return end
        c.enabled=not c.enabled; save()
    end)
    autoButtons[feature.id]=b
    numberBox(feature.id.." interval (seconds)",function() return config.autos[feature.id].interval end,function(v) config.autos[feature.id].interval=v end,feature.interval,300)
end
local toolButton
toolButton=button(row(),"Auto Equip / Activate Tool: "..(config.tool and "ON" or "OFF"),nil,nil,function()
    config.tool=not config.tool; save()
    toolButton.Text="Auto Equip / Activate Tool: "..(config.tool and "ON" or "OFF")
end)
local respawnButton
respawnButton=button(row(),"Resume Farm after respawn: "..(config.respawn and "ON" or "OFF"),nil,nil,function()
    config.respawn=not config.respawn; save()
    respawnButton.Text="Resume Farm after respawn: "..(config.respawn and "ON" or "OFF")
end)
local status=text(row(70),"")
local notes=text(row(85),"")
button(row(),"STOP ALL",nil,nil,function()
    pauseFarm("All automation stopped")
    App.capture=false; captureButton.Text="Learn actions: OFF"
    config.tool=false; toolButton.Text="Auto Equip / Activate Tool: OFF"
    for _,f in ipairs(FEATURES) do config.autos[f.id].enabled=false end
end)
button(row(),"Save settings",nil,nil,function() log(save() and "Settings saved" or "File saving unavailable") end)
button(row(),"Copy status report",nil,nil,function()
    local summary={placeId=game.PlaceId,phase=App.phase,world=config.world,stage=config.stage,runs=App.runs,winsIncrease=App.gained,observer=observer.available,recipes={},messages=App.logs}
    for _,f in ipairs(FEATURES) do summary.recipes[f.id]=#(App.recipes[f.id] or {}) end
    if type(setclipboard)=="function" then setclipboard(Http:JSONEncode(summary)); log("Status copied") else log("Clipboard unavailable") end
end)
local hidden=false
connect(minimize.Activated,function()
    hidden=not hidden; scroll.Visible=not hidden
    panel.Size=UDim2.fromOffset(420,hidden and 44 or 570)
end)
local dragging,dragInput,dragStart,startPosition
connect(title.InputBegan,function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=input.Position; startPosition=panel.Position
    end
end)
connect(title.InputChanged,function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
connect(UIS.InputChanged,function(input)
    if dragging and input==dragInput then
        local delta=input.Position-dragStart
        panel.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
    end
end)
connect(UIS.InputEnded,function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
connect(UIS.InputBegan,function(input,processed)
    if not processed and input.KeyCode==Enum.KeyCode.RightControl then panel.Visible=not panel.Visible end
end)
local function resize()
    local camera=workspace.CurrentCamera
    if camera then
        local size=camera.ViewportSize
        local scale=math.min(1,(size.X-24)/420,(size.Y-24)/570)
        local s=panel:FindFirstChildOfClass("UIScale") or make("UIScale",{},panel)
        s.Scale=math.max(0.35,scale)
    end
end
resize()
local camera=workspace.CurrentCamera
if camera then connect(camera:GetPropertyChangedSignal("ViewportSize"),resize) end
function App:Destroy()
    if not self.alive then return end
    self.alive=false; self.farming=false; self.capture=false; self.generation+=1
    if observer.app==self then observer.app=nil end
    for _,c in ipairs(self.connections) do c:Disconnect() end
    self.gui:Destroy()
    if env.DevilStageFarm==self then env.DevilStageFarm=nil end
end
connect(close.Activated,function() App:Destroy() end)
task.spawn(function()
    local toolAt=0
    while App.alive do
        local now=os.clock()
        for _,f in ipairs(FEATURES) do
            if Core.ready(config.autos[f.id],App.jobs[f.id],now) then jobStep(f,App.jobs[f.id]) end
        end
        if config.tool and now>=toolAt then
            toolAt=now+0.35
            pcall(function()
                local c,h=character()
                if c then
                    local tool=c:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then if tool.Parent~=c then h:EquipTool(tool) end; tool:Activate() end
                end
            end)
        end
        status.Text=string.format("%s | World %d / Stage %d\nConfirmed Wins increases: %d | Gained: %s\nLast learned: %s",App.phase,config.world,config.stage,App.runs,tostring(App.gained),App.lastCapture or "none")
        notes.Text=table.concat(App.logs,"\n",math.max(1,#App.logs-2),#App.logs)
        for _,f in ipairs(FEATURES) do
            autoButtons[f.id].Text=f.label..": "..(config.autos[f.id].enabled and "ON" or "OFF").." • "..#(App.recipes[f.id] or {}).." learned"
        end
        firstBox.Text=firstBox:IsFocused() and firstBox.Text or tostring(config.first)
        lastBox.Text=lastBox:IsFocused() and lastBox.Text or tostring(config.last)
        task.wait(0.1)
    end
end)
log("Ready. Select a loaded World/Stage or press Rescan. Right Ctrl toggles the window")
if not observer.available then log("Learning unavailable; stage movement and Tool auto still available") end
return App
