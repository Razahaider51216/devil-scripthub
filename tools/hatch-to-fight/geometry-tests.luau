local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local V={};local VM={}
VM.__index=function(v,key)
    if key=="Magnitude"then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)end
    if key=="Unit"then local n=math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z);return V.new(v.X/n,v.Y/n,v.Z/n)end
end
function V.new(x,y,z)return setmetatable({X=x or 0,Y=y or 0,Z=z or 0,Class="Vector3"},VM)end
VM.__add=function(a,b)return V.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
VM.__sub=function(a,b)return V.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
VM.__mul=function(a,b)return V.new(a.X*b,a.Y*b,a.Z*b)end
local Vector3=V
local FM={};local F={};FM.__index=function(self,key)if key=="Rotation"then return F.new(0,0,0)end;return FM[key]end
function F.new(x,y,z)
    local pos=type(x)=="table"and x or V.new(x,y,z)
    return setmetatable({Position=pos,Class="CFrame"},FM)
end
function FM:PointToWorldSpace(p)return self.Position+(self.Flip and V.new(-p.X,p.Y,-p.Z)or p)end
function FM:PointToObjectSpace(p)return p-self.Position end
function FM:ToObjectSpace(other)return F.new(other.Position-self.Position)end
FM.__mul=function(a,b)return F.new(a:PointToWorldSpace(b.Position))end
function F.lookAt(pos,target)return F.new(pos)end
local CFrame=F
local RaycastParams={new=function()return {}end}
local Enum={RaycastFilterType={Exclude="Exclude"}}
local typeof=function(v)return type(v)=="table"and v.Class or type(v)end
local part=function(name,pos,size)
    return {Name=name,Position=pos,CFrame=F.new(pos),Size=size,IsA=function(_,kind)return kind=="BasePart"end}
end
local floor=part("Floor",V.new(table.unpack(FLOOR.position)),V.new(table.unpack(FLOOR.size)))
local frame=F.new(0,0,-120);frame.Flip=true;frame.LookVector=V.new(0,0,1)
local marker=part("Stage1",V.new(0,18.6744,-115),V.new(1,1,1))
local spawn=part("EnemySpawn1",V.new(0,.1,-236),V.new(8,.2,8))
local gate={GetAttribute=function(_,key)if key=="GateCFrame"then return frame end end}
local floorAvailable=true
local model={FindFirstChild=function(_,name)
    if name=="Floor"then return floorAvailable and floor or nil elseif name=="EntranceGate"then return gate
    elseif name=="EnemySpawns"then return {FindFirstChild=function()return spawn end}end
end}
local stages={FindFirstChild=function()return model end}
local map={FindFirstChild=function(_,name)if name=="Stages"then return stages end end}
local labels={FindFirstChild=function()return marker end}
local workspace={FindFirstChild=function(_,name)if name=="Map"then return map elseif name=="StageGateLabels"then return labels end end}
local time=10;local queue={};local streamCalls=0
local task={spawn=function(fn)table.insert(queue,fn)end}
local A={Alive=true,Pending={},LastPoll={},LastError={},Now=function()return time end,
    Player={RequestStreamAroundAsync=function(_,point,timeout)check(timeout==2,"stream timeout missing");streamCalls+=1 end}}
local pivot
local root={Position=V.new(0,3,-184),CFrame=F.new(0,3,-184),Size=V.new(2,2,2)}
local character={GetPivot=function()return root.CFrame end,PivotTo=function(_,cf)pivot=cf end}
A.Character=function()return character,{HipHeight=2},root end
A.Attr=function()return 1 end
local position=function(obj)return obj and obj.Position end
-- GEOMETRY
local point,look,ground=A.StagePoint(1)
if OLD then
    check(math.abs(point.Z-floor.Position.Z)>floor.Size.Z/2,"old inverted-gate fixture did not leave floor")
    print("PASS reproduced previous inverted gate offset outside recorded Stage1 floor")
else
    check(point.X==floor.Position.X and point.Z==floor.Position.Z and ground==floor,"entry does not use actual floor")
    check(point.Y==floor.Position.Y+floor.Size.Y/2+3,"entry height not derived from floor")
    check(look.Z==spawn.Position.Z,"enemy direction lost")
    local retry=A.StagePoint(1,1);check(retry.Z<point.Z and math.abs(retry.Z-floor.Position.Z)<floor.Size.Z/2,"retry is outside stage floor")
    floorAvailable=false
    check(A.StagePoint(1)==nil,"falls back to guessed label/gate teleport")
    A.StagePoint(1);check(#queue==1,"duplicate stream requests queued")
    queue[1]();check(streamCalls==1 and not A.Pending.StageStream,"stream lane not released")
    A.StagePoint(1);check(#queue==1,"stream rate limit ignored")
    floorAvailable=true
    check(A.StagePoint(1)~=nil,"stage does not recover after floor streams")
    check(A.Move(V.new(1000,90,-184),V.new(0,3,-236),floor),"actual Move failed")
    check(math.abs(pivot.Position.Y-3.15)<.001 and pivot.Position.X==floor.Size.X/2-2,"actual Move lands on roof or outside floor")
    check(A.Face(V.new(10,3,-220)),"actual Face failed")
    check(pivot.Position.X==root.Position.X and pivot.Position.Z==root.Position.Z,"facing moves character away from target position")
    print("PASS actual floor entry/height/direction, bounded stream loading and recovery: "..checks.." checks")
end
