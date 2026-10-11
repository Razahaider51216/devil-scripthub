-- Run before Auto Pet Carry Farm. Records client observations only.
-- Re-run to export and stop. Output: DevilCarryDiagnostics.json (executor files).
local scope=type(getgenv)=="function" and getgenv() or _G
if scope.DevilCarryDiagnostics then
    scope.DevilCarryDiagnostics:Stop()
    return
end
local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local RS=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local recorder={events={},connections={},running=true,started=os.clock()}
scope.DevilCarryDiagnostics=recorder
local function safe(value,depth)
    depth=depth or 0
    local kind=typeof(value)
    if kind=="nil" or kind=="boolean" or kind=="string"then return value end
    if kind=="number"then return value==value and math.abs(value)<math.huge and value or tostring(value)end
    if kind=="Vector3"then return {x=value.X,y=value.Y,z=value.Z}end
    if kind=="Instance"then return value:GetFullName()end
    if kind=="table" and depth<2 then
        local output,count={},0
        for key,item in pairs(value)do
            count+=1;if count>30 then break end
            output[tostring(key)]=safe(item,depth+1)
        end
        return output
    end
    return tostring(value)
end
local function push(kind,data)
    if not recorder.running then return end
    recorder.events[#recorder.events+1]={t=os.clock()-recorder.started,event=kind,data=safe(data)}
    if #recorder.events>600 then table.remove(recorder.events,1)end
end
function recorder:Export()
    local output=Http:JSONEncode({placeId=game.PlaceId,version=game.PlaceVersion,events=self.events})
    if type(writefile)=="function"then
        local ok,err=pcall(writefile,"DevilCarryDiagnostics.json",output)
        if ok then print("[Carry diagnostics] Saved DevilCarryDiagnostics.json")else warn(err)end
    else print(output)end
end
function recorder:Stop()
    self:Export();self.running=false
    for _,connection in ipairs(self.connections)do connection:Disconnect()end
    if self.healthConnection then self.healthConnection:Disconnect()end
    scope.DevilCarryDiagnostics=nil
end
local previousPosition,previousTime,previousCharacter
local function characterAdded(character)
    if recorder.healthConnection then recorder.healthConnection:Disconnect();recorder.healthConnection=nil end
    previousPosition=nil;previousTime=nil;previousCharacter=character
    push("character",{name=character.Name})
    task.spawn(function()
        local humanoid=character:WaitForChild("Humanoid",10)
        if not humanoid or not recorder.running or previousCharacter~=character then return end
        local health=humanoid.Health
        recorder.healthConnection=humanoid.HealthChanged:Connect(function(newHealth)
            push("health",{before=health,after=newHealth,damage=newHealth<health,
                state=tostring(humanoid:GetState()),carrying=player:GetAttribute("Carrying")})
            if newHealth<health then
                task.delay(1,function()if recorder.running then recorder:Export()end end)
            end
            health=newHealth
        end)
    end)
end
recorder.connections[#recorder.connections+1]=player.CharacterAdded:Connect(characterAdded)
if player.Character then characterAdded(player.Character)end
recorder.connections[#recorder.connections+1]=player:GetAttributeChangedSignal("Carrying"):Connect(function()
    push("carrying",{value=player:GetAttribute("Carrying")})
end)
local watched=setmetatable({},{__mode="k"})
local function watch(instance)
    if watched[instance] or not instance:IsA("RemoteEvent")then return end
    local name=instance.Name:lower()
    if not(name:find("catch") or name:find("fling") or name:find("reject") or name:find("damage") or name:find("stun"))then return end
    watched[instance]=true
    push("observed_remote",{path=instance:GetFullName()})
    recorder.connections[#recorder.connections+1]=instance.OnClientEvent:Connect(function(...)
        push("client_event",{remote=instance:GetFullName(),args={...}})
    end)
end
for _,instance in ipairs(RS:GetDescendants())do watch(instance)end
recorder.connections[#recorder.connections+1]=RS.DescendantAdded:Connect(watch)
task.spawn(function()
    while recorder.running do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if root and humanoid then
            local now=os.clock()
            local observedSpeed=previousPosition and previousTime and (root.Position-previousPosition).Magnitude/math.max(now-previousTime,.001) or 0
            push("sample",{position=root.Position,observedSpeed=observedSpeed,velocity=root.AssemblyLinearVelocity,
                health=humanoid.Health,walkSpeed=humanoid.WalkSpeed,state=tostring(humanoid:GetState()),
                anchored=root.Anchored,platformStand=humanoid.PlatformStand,sit=humanoid.Sit,
                carrying=player:GetAttribute("Carrying"),playerAttributes=player:GetAttributes(),
                characterAttributes=character:GetAttributes()})
            previousPosition=root.Position;previousTime=now
        end
        task.wait(.25)
    end
end)
print("[Carry diagnostics] Recording. Re-run this script to export and stop.")
