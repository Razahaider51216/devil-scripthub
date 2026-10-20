-- HARNESS
local Vec={}
local vecMT={__index=function(v,key)
    if key=="Magnitude"then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)end
    if key=="Unit"then local m=math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z);return Vec.new(v.X/m,v.Y/m,v.Z/m)end
end,__add=function(a,b)return Vec.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end,__sub=function(a,b)return Vec.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end,__mul=function(a,b)return Vec.new(a.X*b,a.Y*b,a.Z*b)end}
function Vec.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},vecMT)end
local Vector3=Vec;Vector3.zero=Vec.new(0,0,0)
local CFrame={lookAt=function(position)return{Position=position}end,new=function(position)return{Position=position}end}
local RaycastParams={new=function()return{}end}
local OverlapParams={new=function()return{}end}
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
local character={PivotTo=function(_,frame)root.Position=frame.Position end,GetDescendants=function()return{}end}
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
local realClear=A2.SpaceClear;A2.SpaceClear=function()return true end
local valid=true;local moved,message
task.spawn(function()moved,message=A2.Move({Instance=two,Position=two.Position},function()return valid end)end)
pump();check(task.LastWait and task.LastWait<=.06,"Actual adapter no longer waits 400 ms after teleport");pump();check(moved==true,"Movement verifies arrival")
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
local A3=makeAdapter(scope,{Egg={Soil={Name="Soil Egg",Rarity="Common"},Clay={Name="Clay Egg",Rarity="Common"}}})
A3.Character=function()return character,{},root,root end
local egg=find(8);A3.Finds={[egg]=true}
for i=1,150 do local material=find(i);material:SetAttribute("FindKind",nil);material:SetAttribute("FindId",nil);material:SetAttribute("MaterialName","Stone");A3.Finds[material]=true end
local options=A3.TeleportOptions("Egg")
check(#options==2 and options[1].Name=="Soil Egg"and options[1].Count==1,"Egg names survive missing native catalog and 150 nearby materials")
check(options[2].Name=="Clay Egg"and options[2].Count==0,"Unloaded catalog eggs remain named with unavailable state")
check(A3.Targets("All","All")[1].Kind=="Egg","All-find farming prioritizes loot over surrounding dirt")
local selected=options[1];egg.Parent=nil;local respawned=find(9);A3.Finds[respawned]=true
check(A3.ResolveTarget(selected).Instance==respawned,"Teleport resolves a fresh instance after respawn")
local phaseCharacter=Instance.new("Model");local phaseRoot=Instance.new("BasePart");phaseRoot.Parent=phaseCharacter;phaseRoot.CanCollide=true;phaseRoot.Position=Vector3.zero;phaseRoot.Size=Vec.new(2,2,1)
local otherPart=Instance.new("BasePart");otherPart.Parent=phaseCharacter;otherPart.CanCollide=false
A3.Character=function()return phaseCharacter,{HipHeight=2},phaseRoot,phaseRoot end
local blocked=true;workspace.GetPartBoundsInBox=function()return blocked and{{CanCollide=true}}or{}end
A3.PhaseCharacter(phaseCharacter,phaseRoot,"FarmFinds",true)
check(not phaseRoot.CanCollide and A3.Phase.Hover.Parent==phaseRoot,"Buried teleport disables only character collision and adds vertical support")
A3.UpdatePhase();check(A3.Phase~=nil,"Keep phase lease while standing in solid mine")
local step=A3.Phase.Step;phaseRoot.CanCollide=true;services.RunService.Stepped:Fire()
check(not phaseRoot.CanCollide,"Maintain transit collision state before physics step")
blocked=false;A3.UpdatePhase();check(A3.Phase==nil and phaseRoot.CanCollide and not otherPart.CanCollide,"Clear space restores exact original collisions")
check(not step.Connected,"Phase cleanup disconnects physics callback")
A3.PhaseCharacter(phaseCharacter,phaseRoot,"FarmFinds",true);local hover=A3.Phase.Hover;A3.Destroy()
check(hover.Destroyed and phaseRoot.CanCollide,"Unload removes hover and restores collisions")
local A4=makeAdapter(scope);A4.Character=function()return phaseCharacter,{HipHeight=2},phaseRoot,phaseRoot end
A4.Ground=function()return nil end;respawned.Size=Vec.new(6,6,6)
local stand,buried=A4.Stand({Position=respawned.Position,Instance=respawned})
check(stand~=nil and buried==true,"Fully buried target supplies phase destination rather than rejecting all four floor probes")
respawned.Position=Vec.new(0,-50,0);phaseRoot.Position=Vector3.zero
respawned.GetClosestPointOnSurface=function()return Vec.new(0,-5,0)end
workspace.Raycast=function()return{Instance=respawned}end
local origin,dir,mode,part=A4.Aim({Instance=respawned,Kind="Egg"})
check(origin~=nil and mode=="Find"and part==respawned,"Large egg uses reachable surface instead of rejecting distant center")
workspace.Raycast=function()return{Instance=egg}end
check(A4.Aim({Instance=respawned,Kind="Egg"})==nil,"Mining still respects actual blocking ray result")
A4.Destroy();pump()
print("PASS adapter timeout / reload / target / movement checks:",checks)
