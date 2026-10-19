local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local now=0
local os={clock=function()return now end}
local task={spawn=function()end,wait=function(n)now+=n end}
local Vector3={}
local meta={}
function Vector3.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},meta)end
Vector3.zero=Vector3.new(0,0,0)
meta.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
meta.__add=function(a,b)return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
meta.__index=function(v,k)if k=='Magnitude'then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)end end
local Enum={PathStatus={Success='Success'},PathWaypointAction={Jump='Jump'},RaycastFilterType={Exclude='Exclude'}}
local RaycastParams={new=function()return {}end}
local CFrame={new=function(pos)return setmetatable({Position=pos},{__mul=function(a)return a end})end}
local root={Position=Vector3.new(0,3,0),Parent=true,Size=Vector3.new(2,2,1),CFrame={Rotation={}}}
local moving,blocked=0,false
local hum={Health=100,WalkSpeed=16,HipHeight=2}
function hum:MoveTo(point)moving+=1;if not blocked then root.Position=point end end
function hum:Move()end
local char={FindFirstChild=function()return root end,FindFirstChildOfClass=function()return hum end}
local pivots=0
function char:PivotTo(frame)pivots+=1;root.Position=frame.Position end
local readyAttribute;local afterStream
local player={Character=char,GetAttribute=function()return readyAttribute end,RequestStreamAroundAsync=function()if afterStream then afterStream()end end}
local hasFloor=true
local workspace={GetServerTimeNow=function()return now end,Raycast=function(_,origin)
 if hasFloor then return {Position=Vector3.new(origin.X,0,origin.Z)}end
end}
local afterCompute
local path={Status='Success'}
function path:ComputeAsync(_,goal)self.goal=goal;if afterCompute then afterCompute()end end
function path:GetWaypoints()return {{Position=Vector3.new(10,3,0)},{Position=self.goal}}end
local game={GetService=function(_,name)
 if name=='ReplicatedStorage'then return {}
 elseif name=='Players'then return {LocalPlayer=player}
 elseif name=='PathfindingService'then return {CreatePath=function()return path end}end
 error(name)
end}
local make=(function()
-- TEST_ADAPTER
end)()
local ctx=make({})
local live=true
local function valid()return live end
check(ctx.Walk(Vector3.new(20,20,0),valid),'normal walkable path failed')
check(root.Position.X==20 and root.Position.Y==3,'door walking changed character elevation to the door center')
check(hum.WalkSpeed==16,'route altered movement speed')
moving=0;afterCompute=function()live=false end
check(not ctx.Walk(Vector3.new(40,3,0),valid)and moving==0,'cancelled path still moved the character')
afterCompute=nil;live=true;path.Status='NoPath'
check(not ctx.Walk(Vector3.new(40,3,0),valid),'failed path was reported as arrival')
path.Status='Success';blocked=true;moving=0
check(not ctx.Walk(Vector3.new(50,3,0),valid)and now>=8,'blocked waypoint did not time out')
blocked=false;hum.Health=0;moving=0
check(not ctx.Walk(Vector3.new(50,3,0),valid)and moving==0,'dead character received movement')
hum.Health=100;player.Character=nil
check(not ctx.Walk(Vector3.new(50,3,0),valid),'missing character was reported as arrival')
player.Character=char;moving=0;ctx.CancelMovement()
check(moving==1,'stop did not clear the active MoveTo target')
local firstReady=ctx.DoorInitialReady();now+=35
check(ctx.DoorInitialReady()==firstReady and ctx.DoorInitialReady()<now,'missing ready attribute deferred doors forever')
readyAttribute=now+2;check(ctx.DoorInitialReady()==readyAttribute,'replicated initial cooldown ignored')
check(ctx.MoveDoor(Vector3.new(80,12,0),valid,'Teleport')and root.Position.X==80 and root.Position.Y==3,'door teleport did not land above ground')
check(root.AssemblyLinearVelocity==Vector3.zero and root.AssemblyAngularVelocity==Vector3.zero,'teleport retained launch velocity')
local before=pivots;hasFloor=false
check(not ctx.MoveDoor(Vector3.new(90,12,0),valid,'Teleport')and pivots==before,'teleported onto unloaded ground')
hasFloor=true;afterStream=function()live=false end
check(not ctx.MoveDoor(Vector3.new(90,12,0),valid,'Teleport')and pivots==before,'stop during stream request still teleported')
afterStream=nil;live=true;hum.Health=0
check(not ctx.MoveDoor(Vector3.new(90,12,0),valid,'Teleport')and pivots==before,'dead character teleported')
hum.Health=100
check(ctx.MoveDoor(Vector3.new(100,3,0),valid,'Walk')and root.Position.X==100,'Walk selection no longer used pathfinding')
print('PASS Halloween movement: valid paths, elevation, blocked paths, death and cancellation: '..checks..' checks')
