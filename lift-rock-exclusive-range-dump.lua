-- Stand still with Auto Egg off. Does not move or collect anything.
assert(game.PlaceId==76731343328034,"Open Lift Rock for Eggs")
local player=game:GetService("Players").LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local http=game:GetService("HttpService")
local scope=type(getgenv)=="function"and getgenv()or _G
scope.DevilExclusiveDumpRun=(scope.DevilExclusiveDumpRun or 0)+1
local run=scope.DevilExclusiveDumpRun
local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
assert(root,"Character not loaded")
local initial=root.Position
local function vec(v)return{x=v.X,y=v.Y,z=v.Z}end
local function read(fn)local ok,v=pcall(fn);if ok then return v end end
local function attrs(obj)
    local out={}
    for k,v in pairs(obj:GetAttributes())do
        if typeof(v)=="Vector3"then out[k]=vec(v)
        elseif type(v)=="string"or type(v)=="number"or type(v)=="boolean"then out[k]=v end
    end
    return out
end
local configs=RS:FindFirstChild("Shared")
configs=configs and configs:FindFirstChild("Configs")
local pets=configs and configs:FindFirstChild("Pets")
pets=pets and read(function()return require(pets)end)
local byName={}
for key,spec in pairs(pets and pets.Specs or{})do
    if type(spec)=="table"and spec.IsEgg then
        byName[spec.ModelName or spec.DisplayName or tostring(key)]={key=key,spec=spec}
        if spec.DisplayName then byName[spec.DisplayName]={key=key,spec=spec}end
    end
end
local ids=setmetatable({},{__mode="k"});local nextId=0
local function snapshot()
    local current=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local position=current and current.Position or initial
    local out={position=vec(position),movedFromStart=(position-initial).Magnitude,models={},exclusive=0,mainRecognized=0,furthest=0}
    local live=workspace:FindFirstChild("Live")
    local friends=live and live:FindFirstChild("Friends")
    out.friendsLoaded=friends~=nil
    if friends then for _,model in ipairs(friends:GetChildren())do
        if model:IsA("Model")then
            nextId+=ids[model]and 0 or 1;ids[model]=ids[model]or nextId
            local key=model:GetAttribute("key")or model:GetAttribute("PetKey")
            local named=byName[model.Name]
            local spec=key and pets and pets.Get and read(function()return pets.Get(tostring(key))end)or named and named.spec
            local prompt=model:FindFirstChild("StealPrompt",true)
            local part=model:FindFirstChild("RootPart")or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
            local p=part and part:IsA("BasePart")and part.Position
            local rarity=spec and spec.Rarity or model:GetAttribute("Rarity")
            local recognized=spec and spec.IsEgg and prompt and prompt:IsA("ProximityPrompt")and part and part:IsA("BasePart")or false
            local distance=p and(position-p).Magnitude
            if recognized then out.mainRecognized+=1 end
            if rarity=="Exclusive"then out.exclusive+=1 end
            out.furthest=math.max(out.furthest,distance or 0)
            if #out.models<250 then
                out.models[#out.models+1]={instanceId=ids[model],name=model.Name,path=model:GetFullName(),key=key or named and named.key,rarity=rarity,
                    attributes=attrs(model),position=p and vec(p),distance=distance,mainRecognized=recognized==true,
                    prompt=prompt and{class=prompt.ClassName,path=prompt:GetFullName(),enabled=read(function()return prompt.Enabled end),range=read(function()return prompt.MaxActivationDistance end),holdDuration=read(function()return prompt.HoldDuration end)}}
            else out.truncated=true end
        end
    end end
    return out
end
local points={
    {name="Prehistoric",point=Vector3.new(198,4,-5835)},
    {name="Space",point=Vector3.new(198,4,-4575)},
    {name="Heaven",point=Vector3.new(198,4,-3444.5)},
    {name="Haunted",point=Vector3.new(198,4,-2571.5)},
    {name="Candy",point=Vector3.new(198,4,-1896.5)},
    {name="Jungle",point=Vector3.new(198,4,-1373.5)},
    {name="Crystal",point=Vector3.new(198,4,-936.5)},
    {name="Snow",point=Vector3.new(198,4,-539.5)},
    {name="Volcano",point=Vector3.new(198,4,-226.5)},
    {name="Desert",point=Vector3.new(198,4,-8.5)},
    {name="Meadow",point=Vector3.new(198,4,153)}
}
local report={release="exclusive-range-dump-1",placeId=game.PlaceId,userId=player.UserId,focus="Exclusive",startedAt=os.time(),
    streaming={enabled=read(function()return workspace.StreamingEnabled end),minRadius=read(function()return workspace.StreamingMinRadius end),targetRadius=read(function()return workspace.StreamingTargetRadius end)},
    initial=snapshot(),zones={},probes={},exclusiveCatalog={}}
local controller=scope.DevilLiftRock
if controller and controller.Config then report.farmEnabled=controller.Config.Farm;report.selectedTiers=controller.Config.Tiers end
if controller and controller.Core then report.mainReportAtStart=read(function()return http:JSONDecode(http:JSONEncode(controller.Core.Report))end)end
for key,spec in pairs(pets and pets.Specs or{})do
    if type(spec)=="table"and spec.IsEgg and spec.Rarity=="Exclusive"then
        report.exclusiveCatalog[#report.exclusiveCatalog+1]={key=tostring(key),name=spec.DisplayName,modelName=spec.ModelName}
    end
end
local map=workspace:FindFirstChild("Map")
local spawns=map and map:FindFirstChild("ZoneSpawns")
if spawns then for _,zone in ipairs(spawns:GetChildren())do
    local row={name=zone.Name,parts={}};report.zones[#report.zones+1]=row
    for _,part in ipairs(zone:GetDescendants())do
        if part:IsA("BasePart")and #row.parts<40 then
            row.parts[#row.parts+1]={name=part.Name,position=vec(part.Position),distance=(part.Position-initial).Magnitude}
            if part.Name:lower():find("egg",1,true)then points[#points+1]={name=zone.Name.."/"..part.Name,point=part.Position}end
        end
    end
end end
-- Bound the diagnostic; static centers plus loaded egg-spawn locations.
local filename="DevilExclusiveRange_"..tostring(os.time()).."_"..run..".json"
local function save()
    local text=http:JSONEncode(report)
    if type(writefile)=="function"then report.saved=pcall(writefile,filename,text)end
    return text
end
save()
for index,target in ipairs(points)do
    if index>24 then report.truncatedProbes=true;break end
    if scope.DevilExclusiveDumpRun~=run then report.cancelled=true;break end
    local before=snapshot();local began=os.clock()
    print("DEVIL HUB Exclusive dump: "..index.."/"..math.min(#points,24).." "..target.name)
    local ok,err=pcall(function()player:RequestStreamAroundAsync(target.point,2)end)
    task.wait(.3)
    local after=snapshot()
    report.probes[#report.probes+1]={zone=target.name,requested=vec(target.point),distanceFromStart=(target.point-initial).Magnitude,
        requestSucceeded=ok,error=not ok and tostring(err)or nil,elapsed=os.clock()-began,before=before,after=after}
    save()
end
report.final=snapshot();report.finishedAt=os.time()
report.stoodStill=report.final.movedFromStart<5
local text=save();local copy=setclipboard or toclipboard
if type(copy)=="function"then pcall(copy,text)end
print("DEVIL HUB Exclusive dump finished: "..filename.." | Exclusive loaded="..report.final.exclusive)
return report
