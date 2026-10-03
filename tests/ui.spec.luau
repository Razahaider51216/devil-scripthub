
local function signal()
    local s = {listeners={}}
    function s:Connect(fn)
        local c = {Connected=true,fn=fn}
        function c:Disconnect() self.Connected=false end
        table.insert(self.listeners,c)
        return c
    end
    function s:Fire(...)
        for _,c in ipairs(self.listeners) do if c.Connected then c.fn(...) end end
    end
    return s
end
local function enum()
    return setmetatable({}, {__index=function(t,k) local v=enum() rawset(t,k,v) return v end})
end
Enum=enum()
local vectorMT={}
local function vec(x,y,z) return setmetatable({X=x,Y=y,Z=z or 0},vectorMT) end
vectorMT.__add=function(a,b) return vec(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
vectorMT.__sub=function(a,b) return vec(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
vectorMT.__mul=function(a,b) return vec(a.X*b,a.Y*b,a.Z*b) end
vectorMT.__index=function(a,k)
    if k=='Magnitude' then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end
    if k=='Unit' then return a*(1/a.Magnitude) end
    if k=='Dot' then return function(_,b) return a.X*b.X+a.Y*b.Y+a.Z*b.Z end end
    if k=='Lerp' then return function(_,b,t) return a+(b-a)*t end end
end
Vector2={new=vec}
Vector3={new=vec,zero=vec(0,0,0)}
UDim={new=function(s,o) return {Scale=s,Offset=o} end}
UDim2={new=function(x,xo,y,yo) return {X=UDim.new(x,xo),Y=UDim.new(y,yo)} end}
UDim2.fromOffset=function(x,y) return UDim2.new(0,x,0,y) end
UDim2.fromScale=function(x,y) return UDim2.new(x,0,y,0) end
Color3={fromRGB=function(r,g,b) return {r,g,b} end}
ColorSequence={new=function(...) return {...} end}
TweenInfo={new=function(...) return {...} end}
CFrame={lookAt=function(_,direction) return {LookVector=direction} end}
local methods,mt={},{}
local createdObjects={}
Instance={new=function(class)
    local instance = setmetatable({_p={ClassName=class,Name=class,Visible=true,Health=100,
        AutoRotate=true,PlatformStand=false,WalkSpeed=24,MoveDirection=Vector3.zero,
        AbsolutePosition=vec(0,0),AnchorPoint=vec(0,0),Position=UDim2.fromOffset(0,0),Size=UDim2.fromOffset(0,0),
        CFrame={LookVector=vec(0,0,-1),Rotation={}},Scale=1},_children={},_signals={},_attributes={}},mt)
    table.insert(createdObjects,instance)
    return instance
end}
mt.__index=function(t,k)
    if methods[k] then return methods[k] end
    if k=='AbsoluteSize' then
        if t.Name=='Frame' and t.Parent and t.Parent.ClassName=='ScreenGui' then return vec(1000,700) end
        local size=t._p.Size
        return vec(size.X.Offset+size.X.Scale*1000,size.Y.Offset+size.Y.Scale*700)
    end
    if t._p[k]~=nil then return t._p[k] end
    local events={Destroying=true,Activated=true,MouseEnter=true,MouseLeave=true,
        InputBegan=true,InputChanged=true,InputEnded=true,FocusLost=true,Died=true}
    if events[k] then t._signals[k]=t._signals[k] or signal() return t._signals[k] end
    return nil
end
mt.__newindex=function(t,k,v)
    t._p[k]=v
    if k=='Parent' and v then table.insert(v._children,t) end
end
function methods:FindFirstChild(name)
    for _,c in ipairs(self._children) do if c.Parent==self and c.Name==name then return c end end
end
function methods:WaitForChild(name) return assert(self:FindFirstChild(name),name) end
function methods:GetPropertyChangedSignal(name)
    self._signals['prop:'..name]=self._signals['prop:'..name] or signal()
    return self._signals['prop:'..name]
end
function methods:Destroy()
    self.Destroying:Fire()
    self.Parent=nil
end
function methods:ChangeState(state) self.LastState=state end
local playerGui=Instance.new('PlayerGui')
local function makeCharacter()
    local c=Instance.new('Model')
    local h=Instance.new('Humanoid') h.Parent=c
    local r=Instance.new('Part') r.Name='HumanoidRootPart' r.Parent=c
    return c,h,r
end
local character,human,root=makeCharacter()
local player={Character=character,CharacterAdded=signal(),CharacterRemoving=signal()}
function player:WaitForChild() return playerGui end
local ui={InputBegan=signal(),InputChanged=signal(),InputEnded=signal(),WindowFocusReleased=signal(),keys={}}
function ui:GetFocusedTextBox() return self.focused end
function ui:IsKeyDown(code) return self.keys[code] or false end
local run={PreSimulation=signal()}
local tween={Create=function(_,object,_,props)
    return {Play=function() for k,v in pairs(props) do object[k]=v end end}
end}
local services={Players={LocalPlayer=player},TweenService=tween,UserInputService=ui,RunService=run}
game={GetService=function(_,name) return assert(services[name],name) end}
workspace={CurrentCamera={CFrame={LookVector=vec(0,.6,-.8)}}}
task={spawn=function(fn,...) fn(...) end,defer=function(fn) fn() end}
warn=print

function methods:IsA(class) return self.ClassName==class or (class=='GuiObject' and self.ClassName~='UICorner' and self.ClassName~='UIStroke' and self.ClassName~='UIListLayout') end
function methods:GetChildren()
 local out={} for _,c in ipairs(self._children) do if c.Parent==self then table.insert(out,c) end end return out
end
function methods:GetDescendants()
 local out={}
 local function walk(o) for _,c in ipairs(o:GetChildren()) do table.insert(out,c) walk(c) end end
 walk(self) return out
end
function methods:SetAttribute(k,v) self._attributes[k]=v end
function methods:GetAttribute(k) return self._attributes[k] end
function methods:GetAttributeChangedSignal(k) return self:GetPropertyChangedSignal('attribute:'..k) end
function services.Players:GetUserThumbnailAsync() return 'mock-thumbnail' end
player.DisplayName='Boss Man' player.UserId=12345
run.Heartbeat=signal()

local logoFiles,logoFetches,logoWrites = {},0,0
function game:HttpGet(url)
 assert(url:find("/assets/devil-logo.png",1,true),'correct logo URL')
 logoFetches=logoFetches+1
 return "\137PNG\13\10\26\10mock-image"
end
function writefile(path,data) logoFiles[path]=data logoWrites=logoWrites+1 end
function isfile(path) return logoFiles[path]~=nil end
function getcustomasset(path) assert(logoFiles[path],'image cached before registering') return 'rbxasset://mock-logo' end
-- UI_UNDER_TEST
local w=UI:CreateWindow({Title='Devil Hub',Description='Anime Legacy'})
assert(w.Gui.Name=='DevilHub','brand')
assert(logoFetches==1 and logoWrites==1,'original logo fetched and cached once')
for _,image in ipairs(w.LogoImages) do
 assert(image.Visible and image.Image=='rbxasset://mock-logo','logo appears in sidebar and launcher')
 assert(image.ScaleType==Enum.ScaleType.Fit,'logo proportions preserved')
end
assert(UI:GetLogo()=='rbxasset://mock-logo' and logoFetches==1,'reuse cached logo asset')
local main=w:AddTab({Title='Main'})
local page=main:AddPage({Title='World Farm'})
local calls=0
local toggle=page:AddToggle({Title='Auto Quest',Callback=function(v) calls=calls+1 assert(type(v)=='boolean') end})
assert(not toggle:Get()) toggle.Instance.Activated:Fire() assert(toggle:Get() and calls==1)
toggle:Set(false,true) assert(not toggle:Get() and calls==1,'silent config restore')
local value
local dropdown=page:AddDropdown({Title='World',Options={{Title='Alpha',Value='a'},{Title='Beta',Value='b'}},Default='a',Callback=function(v) value=v end})
assert(dropdown:Get()=='a')
dropdown.Selector.Activated:Fire() assert(dropdown.Popup.Visible,'dropdown opens')
local function optionRows(api)
 local out={}
 for _,o in ipairs(api.Popup:GetDescendants()) do if o.Name=='Option' then table.insert(out,o) end end
 return out
end
optionRows(dropdown)[2].Activated:Fire() assert(dropdown:Get()=='b' and value=='b' and not dropdown.Popup.Visible)
local multi=page:AddDropdown({Title='Targets',Multi=true,Options={'One','Two'},Default={'One'}})
optionRows(multi)[2].Activated:Fire() assert(#multi:Get()==2,'multiselect')
optionRows(multi)[1].Activated:Fire() assert(#multi:Get()==1 and multi:Get()[1]=='Two','deselect')
local previous=optionRows(multi)[1]
multi:Reload({'Three'}) assert(not previous.Activated.listeners[1].Connected,'reload disconnects old handlers')
local slider=page:AddSlider({Title='Speed',Min=1,Max=300,Default=60,Increment=1,Callback=function(v) value=v end})
slider:Set(500) assert(slider:Get()==300 and value==300)
slider:Set(-4) assert(slider:Get()==1)
slider:Set('bad') assert(slider:Get()==1)
local input=page:AddInput({Title='Profile',Default='default',Callback=function(v) value=v end})
input:Set('boss',true) assert(input:Get()=='boss')
input.Input.Text='new' input.Input.FocusLost:Fire() assert(value=='new')
local paragraph=page:AddParagraph({Title='Status',Description='Ready',Column=2})
paragraph:SetDescription('Active') assert(paragraph.Description.Text=='Active')
local button=page:AddButton({Title='Teleport',Callback=function() calls=calls+1 end})
button.Instance.Activated:Fire() assert(calls==2)
w:Filter('speed') assert(slider.Instance.Visible and not toggle.Instance.Visible)
w:Filter('') assert(toggle.Instance.Visible)
button.Instance.Visible=false w:Filter('teleport') w:Filter('') assert(not button.Instance.Visible,'preserve favorites visibility')
local nextPage=main:AddPage({Title='Rewards'})
main:SelectPage(nextPage) assert(nextPage.Page.Visible and not page.Page.Visible)
local equipment=w:AddTab({Title='Equipment'})
local equipPage=equipment:AddPage({Title='Equip Best'})
w:SelectTab(equipment) assert(equipPage.Page.Visible and not nextPage.Page.Visible)
w:SetMinimized(true) assert(not w.Frame.Visible and w.Launcher.Visible)
w.Launcher.Activated:Fire() assert(w.Frame.Visible,'launcher reopens')
local press={UserInputType=Enum.UserInputType.MouseButton1,Position=vec(16,315)}
w.Launcher.InputBegan:Fire(press)
ui.InputChanged:Fire({UserInputType=Enum.UserInputType.MouseMovement,Position=vec(116,415)})
ui.InputEnded:Fire(press)
w.Launcher.Activated:Fire() assert(w.Frame.Visible,'drag does not toggle')
assert(w.Launcher.Position.X.Offset>16,'launcher moves')
local header=w.Frame:FindFirstChild('Header')
local press2={UserInputType=Enum.UserInputType.Touch,Position=vec(300,200)}
header.InputBegan:Fire(press2)
ui.InputChanged:Fire({UserInputType=Enum.UserInputType.Touch,Position=vec(450,300)})
assert(w.Frame.Position.X.Offset==500,'other touches ignored')
press2.Position=vec(400,300) ui.InputChanged:Fire(press2) ui.InputEnded:Fire(press2)
assert(w.Frame.Position.X.Offset>500,'window drags with active touch')
ui.focused=true ui.InputBegan:Fire({KeyCode=Enum.KeyCode.RightShift},false) assert(w.Frame.Visible,'typing suppresses shortcut') ui.focused=nil
ui.InputBegan:Fire({KeyCode=Enum.KeyCode.RightShift},false) assert(not w.Frame.Visible,'shortcut hides')
w:SetMinimized(false)
local sectionHeader=page.Cards[1]:FindFirstChild('SectionHeader')
sectionHeader.Activated:Fire() assert(not page.Columns[1].Visible,'collapse card')
sectionHeader.Activated:Fire() assert(page.Columns[1].Visible,'expand card')
w:SetTheme('Devil - Violet') assert(w:GetThemeAccent()[1]==177,'theme')
w:SetTheme('Itachi - Red') assert(w:GetThemeAccent()[1]==247,'old profiles themes')
dropdown.Selector.Activated:Fire()
w:SelectTab(main) assert(not dropdown.Popup.Visible,'tab switch closes popup')
w.Gui:Destroy()
for _,c in ipairs(w._connections) do assert(not c.Connected,'cleanup disconnects input') end
for _,o in ipairs(createdObjects) do
 if o.Name=='Option' then for _,c in ipairs(o.Activated.listeners) do assert(not c.Connected,'cleanup disconnects dropdown') end end
end
print('PASS: UI APIs, callbacks, silent restore, dropdown reload, bounds, themes, search, categories, dragging, shortcuts, collapse, cleanup')
