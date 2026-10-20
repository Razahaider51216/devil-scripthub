-- HARNESS
local Vec={}
local vecMT={__index=function(v,key)
    if key=="Magnitude"then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)end
    if key=="Unit"then local m=math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z);return Vec.new(v.X/m,v.Y/m,v.Z/m)end
end,__add=function(a,b)return Vec.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end,__sub=function(a,b)return Vec.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end,__mul=function(a,b)return Vec.new(a.X*b,a.Y*b,a.Z*b)end}
function Vec.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},vecMT)end
local Vector3=Vec;Vector3.zero=Vec.new(0,0,0)
local CFrame={lookAt=function(position)return{Position=position}end}
function Methods:IsDescendantOf(parent)local n=self.Parent;while n do if n==parent then return true end;n=n.Parent end;return false end
local makeAdapter=(function()
-- ADAPTER
end)()
local market=Instance.new("Folder");market.Name="MarketRemotes";market.Parent=rs
local remote=Instance.new("RemoteFunction");remote.Name="LootMarket";remote.Parent=market
local calls=0;local hold=true
function remote:InvokeServer(action)
    calls+=1;while hold do task.wait()end;return{Code="Snapshot",Action=action}
end
local A=makeAdapter(scope);local response,problem
task.spawn(function()response,problem=A.Invoke("Sell","Open")end)
pump();pump();check(calls==1,"Exactly one remote invocation started")
clock+=9;pump();check(response==nil and problem=="Server timeout: Sell","Caller timeout returns without blocking UI")
local again,err=A.Invoke("Sell","Open")
check(again==nil and err:find("previous",1,true)and calls==1,"Hung RPC retains endpoint lane after timeout")
A.Destroy();local replacement=makeAdapter(scope)
again,err=replacement.Invoke("Sell","Open");check(again==nil and calls==1,"Reload cannot duplicate old hung RPC")
hold=false;pump();check(scope.DevilV4Pending.Sell==nil,"Lane releases when actual invocation completes")
task.spawn(function()response,problem=replacement.Invoke("Sell","Snapshot")end);pump();pump()
check(calls==2 and response.Action=="Snapshot","Requests resume after actual completion")
replacement.Destroy()
local A2=makeAdapter(scope)
local map=Instance.new("Folder");map.Name="RuntimeMap";map.Parent=workspace
local mine=Instance.new("Folder");mine.Name="CommunalMine";mine.Parent=map
local root={Position=Vector3.zero,Size=Vec.new(2,2,1)}
local character={PivotTo=function(_,frame)root.Position=frame.Position end}
A2.Character=function()return character,{},root,root end
local function find(x)
    local part=Instance.new("BasePart");part.Name="FindBlock";part.Position=Vec.new(x,0,0);part.Parent=mine
    part:SetAttribute("FindKind","Egg");part:SetAttribute("FindId","Soil");part:SetAttribute("Diggable",true);part:SetAttribute("Health",10)
    return part
end
local one,two=find(5),find(10);A2.Finds={[one]=true,[two]=true}
A2.Modules.EggCatalog={Types={Soil={Name="Soil Egg",Rarity="Common"}}}
local found=A2.Targets("All","All");check(#found==2 and found[1].Instance==one,"Finds ordered by actual current distance")
check(found[1].Serial~=found[2].Serial,"Duplicate names retain unique instance identities")
check(#A2.Targets("Artifact","All")==0 and #A2.Targets("All","Rare")==0,"Type and rarity filters apply")
one.Parent=nil;check(#A2.Targets("All","All")==1,"Streamed out target rejected immediately")
local goal=Vec.new(8,3,0);A2.Stand=function()return goal end
local valid=true;local moved,message
task.spawn(function()moved,message=A2.Move({Instance=two,Position=two.Position},function()return valid end)end)
pump();pump();check(moved==true,"Movement verifies arrival")
character.PivotTo=function()root.Position=Vec.new(100,0,0)end
task.spawn(function()moved,message=A2.Move({Instance=two,Position=two.Position},function()return valid end)end)
pump();pump();check(moved==false and message:find("not confirmed",1,true),"Detect server correction instead of claiming teleport success")
character.PivotTo=function(_,frame)root.Position=frame.Position end
task.spawn(function()moved,message=A2.Move({Instance=two,Position=two.Position},function()return valid end)end)
pump();valid=false;pump();check(moved==false and message=="Cancelled","Stop cancels movement continuation")
two.Parent=nil;valid=true
task.spawn(function()moved,message=A2.Move({Instance=two,Position=two.Position},function()return valid end)end)
pump();check(moved==false and message=="Target disappeared","Refuse stale target before moving")
A2.Destroy();pump()
print("PASS adapter timeout / reload / target / movement checks:",checks)
