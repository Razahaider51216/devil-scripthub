local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local now=0;local afterWait
local os={clock=function()return now end}
local task={spawn=function()end,wait=function(n)now+=n;if afterWait then afterWait()end end}
local Vector3={};local meta={}
function Vector3.new(x,y,z)return setmetatable({X=x,Y=y,Z=z,_kind='Vector3'},meta)end
Vector3.zero=Vector3.new(0,0,0)
meta.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
meta.__add=function(a,b)return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
meta.__index=function(v,k)if k=='Magnitude'then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)end end
local Enum={RaycastFilterType={Exclude='Exclude'}}
local RaycastParams={new=function()return {}end}
local CFrame={new=function(pos)return setmetatable({Position=pos,_kind='CFrame'},{__mul=function(a)return a end})end}
local function typeof(v)return type(v)=='table'and v._kind or type(v)end
local root={Position=Vector3.new(0,3,0),Parent=true,Size=Vector3.new(2,2,1),CFrame={Rotation={}}}
local hum={Health=100,WalkSpeed=16,HipHeight=2};local moving=0
function hum:MoveTo()moving+=1 end
function hum:Move()end
local char={FindFirstChild=function()return root end,FindFirstChildOfClass=function()return hum end}
local pivots=0
function char:PivotTo(frame)pivots+=1;root.Position=frame.Position end
local readyAttribute;local afterStream
local player={Character=char,GetAttribute=function()return readyAttribute end,RequestStreamAroundAsync=function()if afterStream then afterStream()end end}
local hasFloor=true;local groundY=0;local roofY=9;local normalY=1;local rayOrigin
local workspace={GetServerTimeNow=function()return now end,Raycast=function(_,origin,direction,params)
 rayOrigin=origin
 check(params.FilterDescendantsInstances[1]==char and params.RespectCanCollide,'ray did not exclude character / respect collisions')
 -- High rays hit a roof first; rays below it reach the entrance ground.
 local height=origin.Y>=roofY and roofY or hasFloor and origin.Y>=groundY and groundY or nil
 if height and origin.Y+direction.Y<=height then return {Position=Vector3.new(origin.X,height,origin.Z),Normal=Vector3.new(0,normalY,0)}end
end}
local part={Size=Vector3.new(4,8,1)}
function part:IsA(name)return name=='BasePart'end
function part:IsDescendantOf(value)return value==workspace end
function part:GetAttribute(name)
 if name=='TrickOrTreatHome'then return CFrame.new(Vector3.new(80,4,0))
 elseif name=='TrickOrTreatFront'then return Vector3.new(1,0,0)end
end
function part:FindFirstAncestorWhichIsA()return {GetAttribute=function()return 14 end}end
local game={GetService=function(_,name)
 if name=='ReplicatedStorage'then return {} elseif name=='Players'then return {LocalPlayer=player}
 elseif name=='CollectionService'then return {GetTagged=function()return {part}end}end
 error('Unexpected service '..name)
end}
local make=(function()
-- TEST_ADAPTER
end)()
local ctx=make({});local live=true
local function valid()return live end
local door=ctx.Doors()[1]
check(door and door.groundY==0 and door.position.Y==4,'door sill height was not derived from live door size')
check(ctx.Walk==nil,'walking implementation was not removed')
local firstReady=ctx.DoorInitialReady();now+=35
check(ctx.DoorInitialReady()==firstReady and firstReady<now,'missing ready attribute deferred doors forever')
readyAttribute=now+2;check(ctx.DoorInitialReady()==readyAttribute,'replicated cooldown ignored')
check(ctx.MoveDoor(Vector3.new(80,4,0),valid,door)and root.Position.X==80 and root.Position.Y==3,'teleport landed on the porch roof instead of the ground')
check(rayOrigin.Y<roofY and rayOrigin.Y<=door.position.Y+.5,'ground probe started above the roof / door center')
check(root.AssemblyLinearVelocity==Vector3.zero and root.AssemblyAngularVelocity==Vector3.zero,'teleport retained launch velocity')
local before=pivots;hasFloor=false
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door)and pivots==before,'roof was accepted when door ground was missing')
hasFloor=true;groundY=-25
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door)and pivots==before,'ground outside server door-height range was accepted')
groundY=0;normalY=.2
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door)and pivots==before,'steep ground was accepted')
normalY=1;afterStream=function()live=false end
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door)and pivots==before,'stop during streaming still teleported')
afterStream=nil;live=true;hum.Health=0
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door)and pivots==before,'dead character teleported')
hum.Health=100;player.Character=nil
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door),'missing character reported as arrival')
player.Character=char;afterStream=function()player.Character={}end
check(not ctx.MoveDoor(Vector3.new(90,4,0),valid,door)and pivots==before,'respawn during streaming moved stale character')
afterStream=nil;player.Character=char;groundY=20;roofY=29
door={position=Vector3.new(100,24,0),groundY=20};root.Position=Vector3.new(0,200,0)
check(ctx.MoveDoor(Vector3.new(100,24,0),valid,door)and root.Position.Y==23,'elevated door inherited current roof height')
afterWait=function()root.Position=root.Position+Vector3.new(0,30,0)end
check(not ctx.MoveDoor(Vector3.new(100,24,0),valid,door),'server correction back to roof counted as arrival')
afterWait=nil;ctx.CancelMovement();check(moving==1,'stop did not cancel active movement')
print('PASS Halloween teleport: roof rejection, door sill, elevation, streaming, death and cancellation: '..checks..' checks')
