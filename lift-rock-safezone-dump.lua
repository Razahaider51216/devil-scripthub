-- Run while standing in the safe zone. Records loaded parts only.
local player=game:GetService("Players").LocalPlayer
local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
assert(root,"Character not loaded")
local function vec(v)return{x=v.X,y=v.Y,z=v.Z}end
local function attrs(obj)
    local out={}
    for key,value in pairs(obj:GetAttributes())do
        if typeof(value)=="Vector3"then out[key]=vec(value)
        elseif type(value)=="string"or type(value)=="number"or type(value)=="boolean"then out[key]=value end
    end
    return out
end
local report={placeId=game.PlaceId,userId=player.UserId,position=vec(root.Position),parts={},models={},truncated=false}
for _,obj in ipairs(workspace:GetDescendants())do
    local path=obj:GetFullName();local lower=path:lower()
    local named=lower:find("safe",1,true)or lower:find("spawn",1,true)or lower:find("plot",1,true)or lower:find("basepos",1,true)
    if obj:IsA("BasePart")and(named or(obj.Position-root.Position).Magnitude<=150)then
        if #report.parts>=3000 then report.truncated=true;break end
        report.parts[#report.parts+1]={path=path,class=obj.ClassName,position=vec(obj.Position),size=vec(obj.Size),orientation=vec(obj.Orientation),distance=(obj.Position-root.Position).Magnitude,canCollide=obj.CanCollide,attributes=attrs(obj)}
    elseif obj:IsA("Model")and named and #report.models<500 then
        report.models[#report.models+1]={path=path,attributes=attrs(obj)}
    elseif obj.Name=="owner"and(obj:IsA("StringValue")or obj:IsA("IntValue"))then
        report.models[#report.models+1]={path=path,owner=obj.Value}
    end
end
local text=game:GetService("HttpService"):JSONEncode(report)
if type(writefile)=="function"then writefile("DevilLiftSafeZoneParts.json",text)end
local copy=setclipboard or toclipboard
if type(copy)=="function"then pcall(copy,text)end
print("DEVIL HUB: DevilLiftSafeZoneParts.json | parts="..#report.parts)
return report
