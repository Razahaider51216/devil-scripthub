local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local clock=10;local os={clock=function()return clock end}
local queue={}
local task={spawn=function(fn)local c=coroutine.create(fn);queue[#queue+1]=c;return c end}
task.wait=function(duration)task.LastWait=duration;return coroutine.yield()end
local function pump()
    local batch=queue;queue={}
    for _,co in ipairs(batch)do local ok,e=coroutine.resume(co);assert(ok,e);if coroutine.status(co)~="dead"then queue[#queue+1]=co end end
end
local function signal()
    local s={Callbacks={}}
    function s:Connect(fn)local c={Connected=true,Disconnect=function(self)self.Connected=false end};c.Fn=fn;self.Callbacks[#self.Callbacks+1]=c;return c end
    function s:Fire(...)for _,c in ipairs(self.Callbacks)do if c.Connected then c.Fn(...)end end end
    return s
end
local Methods={}
local mt={__index=function(t,k)return Methods[k]or t.Values[k]end,__newindex=function(t,k,v)
    if k=="Parent"then
        local old=t.Values.Parent
        if old then for i,n in ipairs(old.Children)do if n==t then table.remove(old.Children,i);break end end end
        t.Values.Parent=v;if v then v.Children[#v.Children+1]=t end
    else t.Values[k]=v end
end}
local Instance={}
function Instance.new(class)
    return setmetatable({Values={ClassName=class,Name=class,Visible=true,ZIndex=1,Text="",AbsolutePosition={X=0,Y=0},AbsoluteSize={X=400,Y=400}},Children={},Attributes={},Destroying=signal(),DescendantAdded=signal(),DescendantRemoving=signal()},mt)
end
function Methods:IsA(class)return self.ClassName==class or class=="GuiObject"or class=="GuiButton"and self.ClassName=="TextButton"end
function Methods:GetChildren()return table.clone(self.Children)end
function Methods:GetDescendants()local list={};local function add(n)for _,child in ipairs(n.Children)do list[#list+1]=child;add(child)end end;add(self);return list end
function Methods:FindFirstChild(name,recursive)for _,n in ipairs(recursive and self:GetDescendants()or self.Children)do if n.Name==name then return n end end end
function Methods:FindFirstChildOfClass(class)for _,n in ipairs(self.Children)do if n:IsA(class)then return n end end end
function Methods:FindFirstChildWhichIsA(class,recursive)for _,n in ipairs(recursive and self:GetDescendants()or self.Children)do if n:IsA(class)then return n end end end
function Methods:SetAttribute(key,value)self.Attributes[key]=value end
function Methods:GetAttribute(key)return self.Attributes[key]end
function Methods:IsDescendantOf(parent)local node=self.Parent;while node do if node==parent then return true end;node=node.Parent end;return false end
function Methods:Destroy()if self.Destroyed then return end;self.Destroyed=true;self.Destroying:Fire();for _,n in ipairs(self:GetChildren())do n:Destroy()end;self.Parent=nil end
local Enum=setmetatable({},{__index=function(t,k)local v=setmetatable({},{__index=function(_,key)return key end});rawset(t,k,v);return v end})
local Color3={fromRGB=function(...)return{...}end,new=function(...)return{...}end}
local UDim2={fromOffset=function(...)return{...}end,fromScale=function(...)return{...}end,new=function(...)return{...}end}
local Vector2={new=function(x,y)return{X=x,Y=y}end}
local registry={};local windows={}
local library={}
local function host(parent)
    local h={}
    function h:CreateGroupbox(spec)return host(parent)end
    function h:CreateTab(spec)local n=host(parent);registry[spec.Name]=n;return n end
    local function control(spec)
        local c={Spec=spec,Value=spec.CurrentValue or spec.CurrentOption or spec.Text};registry[spec.Name or spec.Text]=c
        function c:Set(v,silent)self.Value=v;if not silent and self.Spec.Callback then self.Spec.Callback(v)end end
        return c
    end
    for _,name in ipairs({"Toggle","Slider","Input","Button","Label","Paragraph"})do h["Create"..name]=function(_,spec)return control(spec)end end
    function h:CreateDropdown(spec)
        local c=control(spec);local popup=Instance.new("Frame");popup.Name="Popup";popup.Visible=false;popup.Parent=parent;c.Popup=popup
        function c:Refresh(options)
            self.Options=options
            for _,old in ipairs(popup:GetChildren())do old:Destroy()end
            for _,text in ipairs(options)do local button=Instance.new("TextButton");button.Parent=popup;local label=Instance.new("TextLabel");label.Text=text;label.Parent=button end
        end
        c:Refresh(spec.Options);return c
    end
    return h
end
function library:CreateWindow(spec)
    local gui=Instance.new("ScreenGui");gui.Name="DevilTest";local body=Instance.new("Frame");body.Parent=gui
    local w=host(body);w.Gui=gui;w.Body=body;w.Spec=spec;function w:Destroy()gui:Destroy()end
    windows[#windows+1]=w;return w
end
local language="EN"
local blue={Version="devil-blue-20261019-10",Get=function()return{Language=language}end,Set=function(s)if s.Language then language=s.Language end end}
local originalSet=blue.Set
local scope={DevilHubBlueGui=blue,DevilHubSilverLogo="rbxassetid://brand"}
local getgenv=function()return scope end
local tags={GetTagged=function()return{}end,GetInstanceAddedSignal=signal,GetInstanceRemovedSignal=signal}
local player=Instance.new("Player");player.UserId=123;local backpack=Instance.new("Backpack");backpack.Name="Backpack";backpack.Parent=player
local rs=Instance.new("Folder");local shared=Instance.new("Folder");shared.Name="Shared";shared.Parent=rs
local fakeJSON={}
local http={JSONEncode=function(_,value)fakeJSON=value;return"profile-json"end,JSONDecode=function()return fakeJSON end}
local services={Players={LocalPlayer=player},ReplicatedStorage=rs,CollectionService=tags,HttpService=http,UserInputService={GetFocusedTextBox=function()return nil end},GuiService={MenuIsOpen=false},RunService={Stepped=signal()}}
local ouro=__OURO_SOURCE__
local game={PlaceId=121831322352666,GameId=10765013362,GetService=function(_,name)return assert(services[name],name)end,HttpGet=function()return ouro end}
local workspace=Instance.new("Folder");workspace.GetServerTimeNow=function()return clock end
local loadstring=function(source)check(source==ouro,"Only pinned GUI dependency is executed");return function()return library end end
local saved={};local writefile=function(path,data)saved[path]=data end
local readfile=function(path)return assert(saved[path],"No saved file")end
local isfile=function(path)return saved[path]~=nil end
local warn=function()end
local entry=function()
-- ENTRY
end
local app=entry();check(not app.Stopped and app.Window~=nil,"Public entry creates DEVIL HUB window")
check(app.Window.Spec.Backdrop==false and app.Window.Spec.Loading==false,"No fullscreen loading backdrop")
check(app.Window.Spec.Name=="DEVIL HUB","Uses DEVIL HUB branding")
check(registry["Settings"]~=nil and registry["Teleport"]~=nil and registry["Shop"]~=nil,"Expected tabs exist")
pump();check(#queue>=1,"Scheduler yields rather than blocking startup")
local A=app.Adapter
local eggs=registry["Ore / item target"]
check(#eggs.Options==84,"Teleport lists all 84 named egg types before native modules load")
check(table.find(eggs.Options,"Soil Egg")and table.find(eggs.Options,"Titanic Clay Egg"),"Names show regular and sized eggs")
eggs.Spec.Callback("Soil Egg");check(app.Config.TeleportChoice=="Egg:Soil","Teleport stores stable egg type key")
check(app.Report.Errors.Display==nil,"Catalog dropdown layout refresh succeeds")
A.Modules.ShovelCatalog={Tiers={{Id="Basic",Name="Basic Shovel",Cost=0},{Id="Grey",Name="Grey Shovel",Cost=100}},tier=function()return{Id="Basic"}end}
A.Modules.GearConfig={Order={"TNT1"},Types={TNT1={Name="TNT",Cost=600,Kind="TNT"}}}
A.Modules.PotionConfig={Order={"DigSpeed"},Types={DigSpeed={Name="Dig Speed Potion"}}}
A.Snapshots.Shovels={Owned={Basic=true,Grey=true}}
A.Snapshots.Gear={Counts={TNT1=2},Prices={TNT1=720},Stock={Key="live",Remaining={TNT1=4}}}
clock+=3;pump()
check(app.Report.Errors.Display==nil,"Display refresh has no runtime error: "..tostring(app.Report.Errors.Display))
local selector=registry["Shovel / price / ownership"]
check(#selector.Options==3,"Live shovel catalog populates choices")
local images,price,state=0,false,false
for _,n in ipairs(selector.Popup:GetDescendants())do
    if n.ClassName=="ImageLabel"then images+=1;check(n.Image:match("^rbxassetid://"),"Native icon image ID")end
    if n.Name=="DevilItemPrice"and n.Text:find("$100",1,true)then price=true;state=n.Text:find("Owned",1,true)~=nil end
end
check(images==2 and price and state,"Dropdown shows pictures, actual price and ownership")
selector.Spec.Callback("Grey Shovel");check(app.Config.Shovel=="Grey","Friendly labels resolve to stable item IDs")
local gear=registry["Gear / live price / stock"];local detail=""
for _,n in ipairs(gear.Popup:GetDescendants())do if n.Name=="DevilItemPrice"then detail=n.Text end end
check(detail:find("$720",1,true)and detail:find("Stock: 4",1,true),"Gear displays live price and stock")
local map=Instance.new("Folder");map.Name="RuntimeMap";map.Parent=workspace
local mine=Instance.new("Folder");mine.Name="CommunalMine";mine.Parent=map
local part=Instance.new("BasePart");part.Parent=mine;part:SetAttribute("FindKind","Egg");part:SetAttribute("FindId","Soil");part:SetAttribute("Diggable",false);part:SetAttribute("Health",20)
local position=setmetatable({},{__sub=function()return{Magnitude=5}end});part.Position=position;A.Finds[part]=true
local character=Instance.new("Model");local root=Instance.new("BasePart");root.Name="HumanoidRootPart";root.Position=position;root.Parent=character
local humanoid=Instance.new("Humanoid");humanoid.Health=100;humanoid.Parent=character;player.Character=character
local oldMove,oldAim=A.Move,A.Aim;local movements=0;local arrived
A.Move=function(target)movements+=1;arrived=target.Instance;return true,"Arrived"end
A.Aim=function()return nil end
local focused=Instance.new("TextBox");focused.Parent=app.Window.Gui;focused.ReleaseFocus=function()focused=nil end
services.UserInputService.GetFocusedTextBox=function()return focused end
app.Config.FarmFinds=true
registry["Teleport to selected target"].Spec.Callback();pump();pump();pump()
check(focused==nil and arrived==part,"Actual teleport button releases hub search focus and resolves buried selected egg")
check(app.Report.Jobs.Teleport=="Arrived","Manual teleport outcome is reported")
clock+=.2;pump();check(movements==1,"Farm cannot immediately override a manual egg teleport")
app.Core.Set("FarmFinds",false);player.Character=nil;A.Move=oldMove;A.Aim=oldAim;map:Destroy()
services.UserInputService.GetFocusedTextBox=function()return nil end
registry["Save settings"].Spec.Callback();pump();check(fakeJSON.Config.Shovel=="Grey","Save profile stores chosen ID")
check(fakeJSON.PlaceId==game.PlaceId and fakeJSON.UserId==player.UserId,"Settings scoped to account and place")
check(fakeJSON.Config.TeleportChoice=="Egg:Soil","Saved selection retains named egg type")
local old=app.Window;blue.Set({Language="TH"});check(language=="TH"and app.Window~=old and not app.Stopped,"Language change rebuilds GUI without unloading workers")
check(registry["ตั้งค่า"]~=nil,"Thai native tab text updates")
blue.Set({Language="EN"});check(registry["Settings"]~=nil and app.Config.Shovel=="Grey","English switch preserves config")
app.Destroy();check(app.Stopped and not app.Core.Alive and blue.Set==originalSet,"Unload restores language hook and stops jobs")
local second=entry();pump();check(second.Config.Shovel=="Grey","Next run loads saved profile")
check(not second.Config.Dig and not second.Config.BuyShovel,"Saved off switches remain off")
second.Destroy();pump()
check(#queue==0,"All scheduler tasks exit after unloading")
print("PASS public entry / GUI / settings checks:",checks)
