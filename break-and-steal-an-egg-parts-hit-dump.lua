-- Run at the stage entrance. Re-run after manual and Auto Egg hits to export/stop.
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilEggPartsDump then scope.DevilEggPartsDump:Stop();return end
local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local RS=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local collector={running=true,connections={},events={},started=os.clock(),watched=setmetatable({},{__mode="k"})}
scope.DevilEggPartsDump=collector
local function safe(value,depth)
    depth=depth or 0
    local kind=typeof(value)
    if kind=="number"then return value==value and math.abs(value)<math.huge and value or tostring(value)end
    if kind=="nil"or kind=="string"or kind=="boolean"then return value end
    if kind=="Vector3"then return {x=value.X,y=value.Y,z=value.Z}end
    if kind=="CFrame"then return {value:GetComponents()}end
    if kind=="Instance"then return value:GetFullName()end
    if kind=="table"and depth<3 then
        local output,count={},0
        for key,item in pairs(value)do
            count+=1;if count>60 then break end
            output[tostring(key)]=safe(item,depth+1)
        end
        return output
    end
    return tostring(value)
end
local function tools()
    local output={}
    for _,container in ipairs({player.Character,player:FindFirstChild("Backpack")})do
        if container then
            for _,item in ipairs(container:GetChildren())do
                if item:IsA("Tool")then
                    output[#output+1]={name=item.Name,path=item:GetFullName(),equipped=container==player.Character,
                        enabled=item.Enabled,requiresHandle=item.RequiresHandle,hasHandle=item:FindFirstChild("Handle")~=nil,
                        attributes=safe(item:GetAttributes())}
                end
            end
        end
    end
    return output
end
local function snapshot()
    local character=player.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    return {position=root and safe(root.Position),health=humanoid and humanoid.Health,
        state=humanoid and tostring(humanoid:GetState()),walkSpeed=humanoid and humanoid.WalkSpeed,
        carrying=safe(player:GetAttribute("Carrying")),pickaxeTier=player:GetAttribute("PickaxeTier"),tools=tools()}
end
local function push(kind,data)
    if not collector.running then return end
    collector.events[#collector.events+1]={t=os.clock()-collector.started,event=kind,data=safe(data)}
    if #collector.events>500 then table.remove(collector.events,1)end
end
collector.report={placeId=game.PlaceId,version=game.PlaceVersion,entranceStandingPoint=snapshot(),
    parts={},zones={},eggs={},scripts={},events=collector.events,partLimit=6000,partsTruncated=false}
function collector:Export()
    self.report.finalSnapshot=snapshot()
    local output=Http:JSONEncode(self.report)
    if type(writefile)=="function"then
        local ok,err=pcall(writefile,"DevilEggEntranceParts.json",output)
        if ok then print("[Egg dump] Saved DevilEggEntranceParts.json ("..#output.." bytes)")else warn(err)end
    elseif type(setclipboard)=="function"then setclipboard(output);print("[Egg dump] JSON copied to clipboard")
    else print(output)end
end
function collector:Stop()
    self:Export();self.running=false
    for _,connection in ipairs(self.connections)do connection:Disconnect()end
    if scope.DevilEggPartsDump==self then scope.DevilEggPartsDump=nil end
end
local function isEgg(instance)
    return instance:IsA("BasePart")and instance.Name=="Egg" and instance:GetAttribute("Health")~=nil
end
local function recordEgg(egg)
    if collector.watched[egg]or not isEgg(egg)then return end
    collector.watched[egg]=true
    local function details()
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        return {path=egg:GetFullName(),position=egg.Position,size=egg.Size,attributes=egg:GetAttributes(),
            rootDistance=root and(root.Position-egg.Position).Magnitude,player=snapshot()}
    end
    collector.report.eggs[#collector.report.eggs+1]=safe(details())
    collector.connections[#collector.connections+1]=egg:GetAttributeChangedSignal("Health"):Connect(function()
        push("egg_health",details())
    end)
end
local function excluded(part)
    if player.Character and part:IsDescendantOf(player.Character)then return true end
    local parent=part
    while parent and parent~=workspace do
        if parent.Name=="Eggs"or parent.Name=="AnimalPickups"or parent.Name=="PlacedAnimals"then return true end
        if parent:IsA("Model")and Players:GetPlayerFromCharacter(parent)then return true end
        parent=parent.Parent
    end
    return false
end
local function watchRemote(instance)
    if collector.watched[instance]or not instance:IsA("RemoteEvent")then return end
    if not ({EggHitRejected=true,EggHitConfirmed=true,EggHitLanded=true,CatchFlingRemote=true,AnimalBankedRemote=true})[instance.Name]then return end
    collector.watched[instance]=true
    collector.connections[#collector.connections+1]=instance.OnClientEvent:Connect(function(...)
        push("client_event",{remote=instance:GetFullName(),args=table.pack(...),player=snapshot()})
    end)
end
for _,instance in ipairs(RS:GetDescendants())do watchRemote(instance)end
collector.connections[#collector.connections+1]=RS.DescendantAdded:Connect(watchRemote)
local descendants=workspace:GetDescendants()
for index,instance in ipairs(descendants)do
    if isEgg(instance)then recordEgg(instance)
    elseif instance:IsA("BasePart")and not excluded(instance)then
        local name=instance.Name:lower()
        if instance.CanCollide or name:find("entr")or name:find("spawn")or name:find("gate")or name:find("door")then
            if #collector.report.parts<collector.report.partLimit then
                collector.report.parts[#collector.report.parts+1]={path=instance:GetFullName(),class=instance.ClassName,
                    position=safe(instance.Position),size=safe(instance.Size),cframe=safe(instance.CFrame),
                    canCollide=instance.CanCollide,canTouch=instance.CanTouch,canQuery=instance.CanQuery,
                    collisionGroup=instance.CollisionGroup,anchored=instance.Anchored,attributes=safe(instance:GetAttributes())}
            else collector.report.partsTruncated=true end
        end
    elseif instance.Name:match("^Zone%d+$")then
        local ok,pivot=pcall(function()return instance:GetPivot()end)
        collector.report.zones[#collector.report.zones+1]={path=instance:GetFullName(),pivot=ok and safe(pivot),attributes=safe(instance:GetAttributes())}
    end
    if index%200==0 then task.wait()end
end
for _,instance in ipairs(game:GetDescendants())do
    if instance:IsA("LocalScript")or instance:IsA("ModuleScript")then
        local name=instance.Name:lower()
        if name:find("egg")or name:find("pickaxe")or name:find("swing")or name:find("zone")then
            collector.report.scripts[#collector.report.scripts+1]={path=instance:GetFullName(),class=instance.ClassName}
        end
    end
end
collector.connections[#collector.connections+1]=workspace.DescendantAdded:Connect(recordEgg)
collector:Export()
task.spawn(function()
    while collector.running do
        push("player",snapshot())
        task.wait(.5)
    end
end)
print("[Egg dump] Geometry saved. Hit manually, test Auto Egg, then re-run to save hit events and stop.")
