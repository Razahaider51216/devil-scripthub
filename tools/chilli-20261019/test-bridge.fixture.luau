
local checks=0
local function check(v,message) assert(v,message); checks+=1 end
local delayed={}
local task={spawn=function(f)f()end,defer=function(f)f()end,delay=function(_,f)table.insert(delayed,f)end}
local function signal()
    local result={listeners={}}
    function result:Connect(fn)
        local c={Connected=true,fn=fn};function c:Disconnect()self.Connected=false end
        table.insert(self.listeners,c);return c
    end
    function result:Fire(...)
        for _,c in ipairs(table.clone(self.listeners))do if c.Connected then c.fn(...)end end
    end
    return result
end
local function enumGroup(prefix)
    return setmetatable({},{__index=function(t,k)local v=prefix..'.'..k;rawset(t,k,v);return v end})
end
local Enum=setmetatable({},{__index=function(t,k)local v=enumGroup(k);rawset(t,k,v);return v end})
local Color3={}
function Color3.new(r,g,b)return {R=r,G=g,B=b}end
function Color3.fromRGB(r,g,b)return Color3.new(r/255,g/255,b/255)end
local UDim={new=function(s,o)return {Scale=s,Offset=o}end}
local UDim2={}
local dimMeta={__eq=function(a,b)return a.X.Scale==b.X.Scale and a.X.Offset==b.X.Offset and a.Y.Scale==b.Y.Scale and a.Y.Offset==b.Y.Offset end}
function UDim2.new(x,xo,y,yo)return setmetatable({X=UDim.new(x,xo),Y=UDim.new(y,yo)},dimMeta)end
function UDim2.fromScale(x,y)return UDim2.new(x,0,y,0)end
function UDim2.fromOffset(x,y)return UDim2.new(0,x,0,y)end
local Vector2={new=function(x,y)return {X=x,Y=y}end}
local Rect={new=function(...)return {...}end}
local ColorSequenceKeypoint={new=function(t,v)return {Time=t,Value=v}end}
local ColorSequence={new=function(a,b)
    if a.R then return {Keypoints={{Time=0,Value=a},{Time=1,Value=b or a}}}end
    return {Keypoints=a}
end}
local NumberSequenceKeypoint={new=function(...)return {...}end}
local NumberSequence={new=function(...)return {...}end}
local TweenInfo={new=function(...)return {...}end}
local methods={}
local guiClasses={Frame=true,ScrollingFrame=true,TextLabel=true,TextButton=true,TextBox=true,ImageLabel=true,ImageButton=true,ViewportFrame=true}
local Instance={}
local mt={}
function mt.__index(self,key)
    if methods[key] then return methods[key]end
    if self.props[key]~=nil then return self.props[key]end
    for _,child in ipairs(self.children)do if child.Name==key then return child end end
    if key=='Activated' or key=='InputBegan' or key=='MouseEnter' or key=='MouseLeave' or key=='MouseButton1Down' or key=='MouseButton1Up' or key=='DescendantAdded' or key=='Destroying' then
        self.signals[key]=self.signals[key] or signal();return self.signals[key]
    end
end
function mt.__newindex(self,key,value)
    local previous=self.props[key]
    if key=='Parent' and previous~=value then
        if previous then local i=table.find(previous.children,self);if i then table.remove(previous.children,i)end end
        self.props[key]=value
        if value then
            table.insert(value.children,self)
            local p=value
            while p do if p.signals.DescendantAdded then p.signals.DescendantAdded:Fire(self)end;p=p.Parent end
        end
    else self.props[key]=value end
    if previous~=value and self.signals[key] then self.signals[key]:Fire()end
end
function Instance.new(class)
    return setmetatable({props={ClassName=class,Name=class,Size=UDim2.fromScale(1,1),Position=UDim2.fromScale(0,0),
        Visible=true,DisplayOrder=0,BackgroundTransparency=0,BackgroundColor3=Color3.new(1,1,1),
        TextColor3=Color3.new(1,1,1),Color=class=='UIGradient' and ColorSequence.new(Color3.new(1,1,1)) or class=='UIStroke' and Color3.new(1,1,1) or nil,
        Text='',Enabled=true,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Font=Enum.Font.SourceSans},
        signals={},children={},attributes={}},mt)
end
function methods:IsA(class)
    return class==self.ClassName or (class=='GuiObject' and guiClasses[self.ClassName]) or
        (class=='GuiButton' and (self.ClassName=='TextButton' or self.ClassName=='ImageButton'))
end
function methods:SetAttribute(key,value)self.attributes[key]=value end
function methods:GetAttribute(key)return self.attributes[key]end
function methods:GetChildren()return table.clone(self.children)end
function methods:GetDescendants()
    local result={};local function add(p)for _,c in ipairs(p.children)do table.insert(result,c);add(c)end end
    add(self);return result
end
function methods:FindFirstChild(name)for _,c in ipairs(self.children)do if c.Name==name then return c end end end
function methods:FindFirstChildOfClass(class)for _,c in ipairs(self.children)do if c:IsA(class)then return c end end end
methods.FindFirstChildWhichIsA=methods.FindFirstChildOfClass
function methods:IsDescendantOf(parent)local p=self.Parent;while p do if p==parent then return true end;p=p.Parent end;return false end
function methods:GetPropertyChangedSignal(key)self.signals[key]=self.signals[key] or signal();return self.signals[key]end
function methods:Destroy()
    if self.signals.Destroying then self.signals.Destroying:Fire()end
    for _,child in ipairs(table.clone(self.children))do child:Destroy()end
    self.Parent=nil;self.destroyed=true
end
local core=Instance.new('CoreGui')
local uiParent=core
local parent=core
local ROOT_GUI_NAME='Settings'
local OWNER_ATTRIBUTE='ChilliLibraryOwned'
local camera=Instance.new('Camera');camera.ViewportSize=Vector2.new(1280,720)
local workspace={CurrentCamera=camera}
local player=Instance.new('Player');player.Name='RealUser';player.DisplayName='Real Display'
local Players={LocalPlayer=player}
player.UserId=123
function Players:GetUserThumbnailAsync(userId,kind,size)
    assert(userId==123 and kind==Enum.ThumbnailType.HeadShot and size==Enum.ThumbnailSize.Size100x100)
    return 'rbxthumb://real-player-thumbnail',true
end
local input={InputChanged=signal(),InputEnded=signal()}
local tween={Create=function(_,object,_,values)return {Cancel=function()end,Play=function()for k,v in pairs(values)do object[k]=v end end}end}
local files={}
local game={GetService=function(_,name)
    if name=='Players'then return Players elseif name=='CoreGui'then return core elseif name=='UserInputService'then return input
    elseif name=='TweenService'then return tween elseif name=='HttpService'then return {JSONEncode=function(_,r)return r.status end}end
    error('Unexpected service: '..name)
end,HttpGet=function()error('Unexpected gameplay/network call from UI test')end}
local env={};local getgenv=function()return env end
local writefile=function(n,s)files[n]=s end
local isfile=function(name)return name=='DevilHub-UI-silver-logo.png' end
local getcustomasset=function(name)assert(name=='DevilHub-UI-silver-logo.png');return 'cached-devil-silver-logo' end
local typeof=function(v)if getmetatable(v)==mt then return 'Instance' end;return type(v)end
local function chilliSetProperty(instance, key, value)
    instance[key] = value
end
local objects = {}

objects.obj1 = Instance.new("ScreenGui")
pcall(chilliSetProperty, objects.obj1, "Name", ROOT_GUI_NAME)
pcall(chilliSetProperty, objects.obj1, "Archivable", true)
objects.obj1:SetAttribute("MenuSize", UDim2.new(0.44999998807907104,0,0.550000011920929,0))
objects.obj1:SetAttribute(OWNER_ATTRIBUTE, true)
objects.obj1.Parent = parent

objects.obj2 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj2, "Name", "Frame")
pcall(chilliSetProperty, objects.obj2, "Archivable", true)
pcall(chilliSetProperty, objects.obj2, "Visible", true)
pcall(chilliSetProperty, objects.obj2, "Active", false)
pcall(chilliSetProperty, objects.obj2, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj2, "BackgroundColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj2, "BackgroundTransparency", 0.4000000059604645)
pcall(chilliSetProperty, objects.obj2, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj2, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj2, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj2, "Position", UDim2.new(0.5,0,0.4749999940395355,0))
pcall(chilliSetProperty, objects.obj2, "Rotation", 0)
pcall(chilliSetProperty, objects.obj2, "Selectable", false)
pcall(chilliSetProperty, objects.obj2, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj2, "Size", UDim2.new(0.44999998807907104,0,0.550000011920929,0))
pcall(chilliSetProperty, objects.obj2, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj2, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj2, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj2, "LayoutOrder", 0)
objects.obj2.Parent = objects.obj1

objects.obj3 = Instance.new("UIStroke")
pcall(chilliSetProperty, objects.obj3, "Name", "UIStroke")
pcall(chilliSetProperty, objects.obj3, "Archivable", true)
pcall(chilliSetProperty, objects.obj3, "ApplyStrokeMode", Enum.ApplyStrokeMode.Border)
pcall(chilliSetProperty, objects.obj3, "Color", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj3, "Enabled", true)
pcall(chilliSetProperty, objects.obj3, "LineJoinMode", Enum.LineJoinMode.Round)
pcall(chilliSetProperty, objects.obj3, "Thickness", 0.00800000037997961)
pcall(chilliSetProperty, objects.obj3, "Transparency", 0)
objects.obj3.Parent = objects.obj2

objects.obj4 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj4, "Name", "Top")
pcall(chilliSetProperty, objects.obj4, "Archivable", true)
pcall(chilliSetProperty, objects.obj4, "Visible", true)
pcall(chilliSetProperty, objects.obj4, "Active", false)
pcall(chilliSetProperty, objects.obj4, "AnchorPoint", Vector2.new(0.5,0))
pcall(chilliSetProperty, objects.obj4, "BackgroundColor3", Color3.fromRGB(111,0,2))
pcall(chilliSetProperty, objects.obj4, "BackgroundTransparency", 0)
pcall(chilliSetProperty, objects.obj4, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj4, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj4, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj4, "Position", UDim2.new(0.5,0,0,0))
pcall(chilliSetProperty, objects.obj4, "Rotation", 0)
pcall(chilliSetProperty, objects.obj4, "Selectable", false)
pcall(chilliSetProperty, objects.obj4, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj4, "Size", UDim2.new(1,0,0.13500000536441803,0))
pcall(chilliSetProperty, objects.obj4, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj4, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj4, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj4, "LayoutOrder", 0)
objects.obj4.Parent = objects.obj2

objects.obj5 = Instance.new("UIStroke")
pcall(chilliSetProperty, objects.obj5, "Name", "UIStroke")
pcall(chilliSetProperty, objects.obj5, "Archivable", true)
pcall(chilliSetProperty, objects.obj5, "ApplyStrokeMode", Enum.ApplyStrokeMode.Border)
pcall(chilliSetProperty, objects.obj5, "Color", Color3.fromRGB(58,0,0))
pcall(chilliSetProperty, objects.obj5, "Enabled", true)
pcall(chilliSetProperty, objects.obj5, "LineJoinMode", Enum.LineJoinMode.Round)
pcall(chilliSetProperty, objects.obj5, "Thickness", 0.05999999865889549)
pcall(chilliSetProperty, objects.obj5, "Transparency", 0)
objects.obj5.Parent = objects.obj4

objects.obj6 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj6, "Name", "Color")
pcall(chilliSetProperty, objects.obj6, "Archivable", true)
pcall(chilliSetProperty, objects.obj6, "Visible", true)
pcall(chilliSetProperty, objects.obj6, "Active", false)
pcall(chilliSetProperty, objects.obj6, "AnchorPoint", Vector2.new(0.5,0))
pcall(chilliSetProperty, objects.obj6, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj6, "BackgroundTransparency", 0)
pcall(chilliSetProperty, objects.obj6, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj6, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj6, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj6, "Position", UDim2.new(0.5,0,0,0))
pcall(chilliSetProperty, objects.obj6, "Rotation", 0)
pcall(chilliSetProperty, objects.obj6, "Selectable", false)
pcall(chilliSetProperty, objects.obj6, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj6, "Size", UDim2.new(1,0,0.8799999952316284,0))
pcall(chilliSetProperty, objects.obj6, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj6, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj6, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj6, "LayoutOrder", 0)
objects.obj6.Parent = objects.obj4

objects.obj7 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj7, "Name", "Transparent")
pcall(chilliSetProperty, objects.obj7, "Archivable", true)
pcall(chilliSetProperty, objects.obj7, "Visible", true)
pcall(chilliSetProperty, objects.obj7, "Active", false)
pcall(chilliSetProperty, objects.obj7, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj7, "BackgroundColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj7, "BackgroundTransparency", 0.8999999761581421)
pcall(chilliSetProperty, objects.obj7, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj7, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj7, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj7, "Position", UDim2.new(0.5,0,0.5,0))
pcall(chilliSetProperty, objects.obj7, "Rotation", 0)
pcall(chilliSetProperty, objects.obj7, "Selectable", false)
pcall(chilliSetProperty, objects.obj7, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj7, "Size", UDim2.new(0.9879999756813049,0,0.8700000047683716,0))
pcall(chilliSetProperty, objects.obj7, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj7, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj7, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj7, "LayoutOrder", 0)
objects.obj7.Parent = objects.obj6

objects.obj8 = Instance.new("ImageLabel")
pcall(chilliSetProperty, objects.obj8, "Name", "Pattern")
pcall(chilliSetProperty, objects.obj8, "Archivable", true)
pcall(chilliSetProperty, objects.obj8, "Visible", true)
pcall(chilliSetProperty, objects.obj8, "Active", false)
pcall(chilliSetProperty, objects.obj8, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj8, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj8, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj8, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj8, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj8, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj8, "Position", UDim2.new(0.5,0,0.5,0))
pcall(chilliSetProperty, objects.obj8, "Rotation", 0)
pcall(chilliSetProperty, objects.obj8, "Selectable", false)
pcall(chilliSetProperty, objects.obj8, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj8, "Size", UDim2.new(1,0,1,0))
pcall(chilliSetProperty, objects.obj8, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj8, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj8, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj8, "LayoutOrder", 0)
pcall(chilliSetProperty, objects.obj8, "Image", "")
pcall(chilliSetProperty, objects.obj8, "ImageColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj8, "ImageTransparency", 0.5)
pcall(chilliSetProperty, objects.obj8, "ScaleType", Enum.ScaleType.Tile)
pcall(chilliSetProperty, objects.obj8, "SliceCenter", Rect.new(0,0,0,0))
pcall(chilliSetProperty, objects.obj8, "SliceScale", 1)
pcall(chilliSetProperty, objects.obj8, "TileSize", UDim2.new(0.15000000596046448,0,2,0))
pcall(chilliSetProperty, objects.obj8, "ResampleMode", Enum.ResamplerMode.Default)
objects.obj8.Parent = objects.obj7

objects.obj9 = Instance.new("TextLabel")
pcall(chilliSetProperty, objects.obj9, "Name", "Label")
pcall(chilliSetProperty, objects.obj9, "Archivable", true)
pcall(chilliSetProperty, objects.obj9, "Visible", true)
pcall(chilliSetProperty, objects.obj9, "Active", false)
pcall(chilliSetProperty, objects.obj9, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj9, "BackgroundColor3", Color3.fromRGB(239,220,203))
pcall(chilliSetProperty, objects.obj9, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj9, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj9, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj9, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj9, "Position", UDim2.new(0.5687711238861084,0,0.5,0))
pcall(chilliSetProperty, objects.obj9, "Rotation", 0)
pcall(chilliSetProperty, objects.obj9, "Selectable", false)
pcall(chilliSetProperty, objects.obj9, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj9, "Size", UDim2.new(0.8620089292526245,0,0.7499999403953552,0))
pcall(chilliSetProperty, objects.obj9, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj9, "ZIndex", 6)
pcall(chilliSetProperty, objects.obj9, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj9, "LayoutOrder", 0)
pcall(chilliSetProperty, objects.obj9, "Text", "Chilli Hub")
pcall(chilliSetProperty, objects.obj9, "TextColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj9, "TextTransparency", 0)
pcall(chilliSetProperty, objects.obj9, "TextStrokeColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj9, "TextStrokeTransparency", 1)
pcall(chilliSetProperty, objects.obj9, "TextSize", 14)
pcall(chilliSetProperty, objects.obj9, "TextScaled", true)
pcall(chilliSetProperty, objects.obj9, "TextWrapped", true)
pcall(chilliSetProperty, objects.obj9, "TextXAlignment", Enum.TextXAlignment.Left)
pcall(chilliSetProperty, objects.obj9, "TextYAlignment", Enum.TextYAlignment.Center)
pcall(chilliSetProperty, objects.obj9, "Font", Enum.Font.FredokaOne)
pcall(chilliSetProperty, objects.obj9, "RichText", false)
pcall(chilliSetProperty, objects.obj9, "LineHeight", 1)
pcall(chilliSetProperty, objects.obj9, "MaxVisibleGraphemes", -1)
objects.obj9.Parent = objects.obj6

objects.obj10 = Instance.new("UIStroke")
pcall(chilliSetProperty, objects.obj10, "Name", "UIStroke")
pcall(chilliSetProperty, objects.obj10, "Archivable", true)
pcall(chilliSetProperty, objects.obj10, "ApplyStrokeMode", Enum.ApplyStrokeMode.Contextual)
pcall(chilliSetProperty, objects.obj10, "Color", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj10, "Enabled", true)
pcall(chilliSetProperty, objects.obj10, "LineJoinMode", Enum.LineJoinMode.Round)
pcall(chilliSetProperty, objects.obj10, "Thickness", 0.07999999821186066)
pcall(chilliSetProperty, objects.obj10, "Transparency", 0)
objects.obj10.Parent = objects.obj9

objects.obj11 = Instance.new("UIGradient")
pcall(chilliSetProperty, objects.obj11, "Name", "UIGradient")
pcall(chilliSetProperty, objects.obj11, "Archivable", true)
pcall(chilliSetProperty, objects.obj11, "Color", ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(253,86,89)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,11,15))}))
pcall(chilliSetProperty, objects.obj11, "Enabled", true)
pcall(chilliSetProperty, objects.obj11, "Offset", Vector2.new(0,0))
pcall(chilliSetProperty, objects.obj11, "Rotation", 90)
pcall(chilliSetProperty, objects.obj11, "Transparency", NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)}))
objects.obj11.Parent = objects.obj6

objects.obj12 = Instance.new("ImageLabel")
pcall(chilliSetProperty, objects.obj12, "Name", "Icon")
pcall(chilliSetProperty, objects.obj12, "Archivable", true)
pcall(chilliSetProperty, objects.obj12, "Visible", true)
pcall(chilliSetProperty, objects.obj12, "Active", false)
pcall(chilliSetProperty, objects.obj12, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj12, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj12, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj12, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj12, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj12, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj12, "Position", UDim2.new(0.06700000166893005,0,0.44999998807907104,0))
pcall(chilliSetProperty, objects.obj12, "Rotation", 0)
pcall(chilliSetProperty, objects.obj12, "Selectable", false)
pcall(chilliSetProperty, objects.obj12, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj12, "Size", UDim2.new(0.11656716465950012,0,1.1833335161209106,0))
pcall(chilliSetProperty, objects.obj12, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj12, "ZIndex", 4)
pcall(chilliSetProperty, objects.obj12, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj12, "LayoutOrder", 0)
pcall(chilliSetProperty, objects.obj12, "Image", "")
pcall(chilliSetProperty, objects.obj12, "ImageColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj12, "ImageTransparency", 0)
pcall(chilliSetProperty, objects.obj12, "ScaleType", Enum.ScaleType.Fit)
pcall(chilliSetProperty, objects.obj12, "SliceCenter", Rect.new(0,0,0,0))
pcall(chilliSetProperty, objects.obj12, "SliceScale", 1)
pcall(chilliSetProperty, objects.obj12, "TileSize", UDim2.new(0,60,0,60))
pcall(chilliSetProperty, objects.obj12, "ResampleMode", Enum.ResamplerMode.Default)
objects.obj12.Parent = objects.obj4

objects.obj13 = Instance.new("UIAspectRatioConstraint")
pcall(chilliSetProperty, objects.obj13, "Name", "UIAspectRatioConstraint")
pcall(chilliSetProperty, objects.obj13, "Archivable", true)
pcall(chilliSetProperty, objects.obj13, "AspectRatio", 1)
pcall(chilliSetProperty, objects.obj13, "AspectType", Enum.AspectType.FitWithinMaxSize)
pcall(chilliSetProperty, objects.obj13, "DominantAxis", Enum.DominantAxis.Width)
objects.obj13.Parent = objects.obj12

objects.obj14 = Instance.new("TextButton")
pcall(chilliSetProperty, objects.obj14, "Name", "Close")
pcall(chilliSetProperty, objects.obj14, "Archivable", true)
pcall(chilliSetProperty, objects.obj14, "Visible", true)
pcall(chilliSetProperty, objects.obj14, "Active", true)
pcall(chilliSetProperty, objects.obj14, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj14, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj14, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj14, "BorderColor3", Color3.fromRGB(27,42,53))
pcall(chilliSetProperty, objects.obj14, "BorderSizePixel", 1)
pcall(chilliSetProperty, objects.obj14, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj14, "Position", UDim2.new(0.9549999833106995,0,0.4339999854564667,0))
pcall(chilliSetProperty, objects.obj14, "Rotation", 0)
pcall(chilliSetProperty, objects.obj14, "Selectable", true)
pcall(chilliSetProperty, objects.obj14, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj14, "Size", UDim2.new(0.06637302041053772,0,0.6588137149810791,0))
pcall(chilliSetProperty, objects.obj14, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj14, "ZIndex", 99)
pcall(chilliSetProperty, objects.obj14, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj14, "LayoutOrder", 1)
pcall(chilliSetProperty, objects.obj14, "Text", "")
pcall(chilliSetProperty, objects.obj14, "TextColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj14, "TextTransparency", 0)
pcall(chilliSetProperty, objects.obj14, "TextStrokeColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj14, "TextStrokeTransparency", 1)
pcall(chilliSetProperty, objects.obj14, "TextSize", 14)
pcall(chilliSetProperty, objects.obj14, "TextScaled", false)
pcall(chilliSetProperty, objects.obj14, "TextWrapped", false)
pcall(chilliSetProperty, objects.obj14, "TextXAlignment", Enum.TextXAlignment.Center)
pcall(chilliSetProperty, objects.obj14, "TextYAlignment", Enum.TextYAlignment.Center)
pcall(chilliSetProperty, objects.obj14, "Font", Enum.Font.SourceSans)
pcall(chilliSetProperty, objects.obj14, "RichText", false)
pcall(chilliSetProperty, objects.obj14, "LineHeight", 1)
pcall(chilliSetProperty, objects.obj14, "AutoButtonColor", true)
pcall(chilliSetProperty, objects.obj14, "Modal", false)
objects.obj14.Parent = objects.obj4

objects.obj15 = Instance.new("UIAspectRatioConstraint")
pcall(chilliSetProperty, objects.obj15, "Name", "UIAspectRatioConstraint")
pcall(chilliSetProperty, objects.obj15, "Archivable", true)
pcall(chilliSetProperty, objects.obj15, "AspectRatio", 1)
pcall(chilliSetProperty, objects.obj15, "AspectType", Enum.AspectType.FitWithinMaxSize)
pcall(chilliSetProperty, objects.obj15, "DominantAxis", Enum.DominantAxis.Width)
objects.obj15.Parent = objects.obj14

objects.obj16 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj16, "Name", "Main")
pcall(chilliSetProperty, objects.obj16, "Archivable", true)
pcall(chilliSetProperty, objects.obj16, "Visible", true)
pcall(chilliSetProperty, objects.obj16, "Active", false)
pcall(chilliSetProperty, objects.obj16, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj16, "BackgroundColor3", Color3.fromRGB(126,0,0))
pcall(chilliSetProperty, objects.obj16, "BackgroundTransparency", 0)
pcall(chilliSetProperty, objects.obj16, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj16, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj16, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj16, "Position", UDim2.new(0.5,0,0.5,0))
pcall(chilliSetProperty, objects.obj16, "Rotation", 0)
pcall(chilliSetProperty, objects.obj16, "Selectable", false)
pcall(chilliSetProperty, objects.obj16, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj16, "Size", UDim2.new(1,0,1,0))
pcall(chilliSetProperty, objects.obj16, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj16, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj16, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj16, "LayoutOrder", 0)
objects.obj16.Parent = objects.obj14

objects.obj17 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj17, "Name", "Color")
pcall(chilliSetProperty, objects.obj17, "Archivable", true)
pcall(chilliSetProperty, objects.obj17, "Visible", true)
pcall(chilliSetProperty, objects.obj17, "Active", false)
pcall(chilliSetProperty, objects.obj17, "AnchorPoint", Vector2.new(0.5,0))
pcall(chilliSetProperty, objects.obj17, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj17, "BackgroundTransparency", 0)
pcall(chilliSetProperty, objects.obj17, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj17, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj17, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj17, "Position", UDim2.new(0.5,0,0,0))
pcall(chilliSetProperty, objects.obj17, "Rotation", 0)
pcall(chilliSetProperty, objects.obj17, "Selectable", false)
pcall(chilliSetProperty, objects.obj17, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj17, "Size", UDim2.new(1,0,0.8999999761581421,0))
pcall(chilliSetProperty, objects.obj17, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj17, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj17, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj17, "LayoutOrder", 0)
objects.obj17.Parent = objects.obj16

objects.obj18 = Instance.new("Frame")
pcall(chilliSetProperty, objects.obj18, "Name", "Transparent")
pcall(chilliSetProperty, objects.obj18, "Archivable", true)
pcall(chilliSetProperty, objects.obj18, "Visible", true)
pcall(chilliSetProperty, objects.obj18, "Active", false)
pcall(chilliSetProperty, objects.obj18, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj18, "BackgroundColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj18, "BackgroundTransparency", 0.8999999761581421)
pcall(chilliSetProperty, objects.obj18, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj18, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj18, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj18, "Position", UDim2.new(0.5,0,0.5,0))
pcall(chilliSetProperty, objects.obj18, "Rotation", 0)
pcall(chilliSetProperty, objects.obj18, "Selectable", false)
pcall(chilliSetProperty, objects.obj18, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj18, "Size", UDim2.new(0.9599999785423279,0,0.8799999952316284,0))
pcall(chilliSetProperty, objects.obj18, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj18, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj18, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj18, "LayoutOrder", 0)
objects.obj18.Parent = objects.obj17

objects.obj19 = Instance.new("ImageLabel")
pcall(chilliSetProperty, objects.obj19, "Name", "Pattern")
pcall(chilliSetProperty, objects.obj19, "Archivable", true)
pcall(chilliSetProperty, objects.obj19, "Visible", true)
pcall(chilliSetProperty, objects.obj19, "Active", false)
pcall(chilliSetProperty, objects.obj19, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj19, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj19, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj19, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj19, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj19, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj19, "Position", UDim2.new(0.5,0,0.5,0))
pcall(chilliSetProperty, objects.obj19, "Rotation", 0)
pcall(chilliSetProperty, objects.obj19, "Selectable", false)
pcall(chilliSetProperty, objects.obj19, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj19, "Size", UDim2.new(1,0,1,0))
pcall(chilliSetProperty, objects.obj19, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj19, "ZIndex", 1)
pcall(chilliSetProperty, objects.obj19, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj19, "LayoutOrder", 0)
pcall(chilliSetProperty, objects.obj19, "Image", "")
pcall(chilliSetProperty, objects.obj19, "ImageColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj19, "ImageTransparency", 0.5)
pcall(chilliSetProperty, objects.obj19, "ScaleType", Enum.ScaleType.Tile)
pcall(chilliSetProperty, objects.obj19, "SliceCenter", Rect.new(0,0,0,0))
pcall(chilliSetProperty, objects.obj19, "SliceScale", 1)
pcall(chilliSetProperty, objects.obj19, "TileSize", UDim2.new(2,0,2,0))
pcall(chilliSetProperty, objects.obj19, "ResampleMode", Enum.ResamplerMode.Default)
objects.obj19.Parent = objects.obj18

objects.obj20 = Instance.new("TextLabel")
pcall(chilliSetProperty, objects.obj20, "Name", "Label")
pcall(chilliSetProperty, objects.obj20, "Archivable", true)
pcall(chilliSetProperty, objects.obj20, "Visible", true)
pcall(chilliSetProperty, objects.obj20, "Active", false)
pcall(chilliSetProperty, objects.obj20, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj20, "BackgroundColor3", Color3.fromRGB(239,220,203))
pcall(chilliSetProperty, objects.obj20, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj20, "BorderColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj20, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj20, "ClipsDescendants", false)
pcall(chilliSetProperty, objects.obj20, "Position", UDim2.new(0.5,0,0.5,0))
pcall(chilliSetProperty, objects.obj20, "Rotation", 0)
pcall(chilliSetProperty, objects.obj20, "Selectable", false)
pcall(chilliSetProperty, objects.obj20, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj20, "Size", UDim2.new(0.949999988079071,0,0.800000011920929,0))
pcall(chilliSetProperty, objects.obj20, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj20, "ZIndex", 6)
pcall(chilliSetProperty, objects.obj20, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj20, "LayoutOrder", 0)
pcall(chilliSetProperty, objects.obj20, "Text", "X")
pcall(chilliSetProperty, objects.obj20, "TextColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj20, "TextTransparency", 0)
pcall(chilliSetProperty, objects.obj20, "TextStrokeColor3", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj20, "TextStrokeTransparency", 1)
pcall(chilliSetProperty, objects.obj20, "TextSize", 14)
pcall(chilliSetProperty, objects.obj20, "TextScaled", true)
pcall(chilliSetProperty, objects.obj20, "TextWrapped", true)
pcall(chilliSetProperty, objects.obj20, "TextXAlignment", Enum.TextXAlignment.Center)
pcall(chilliSetProperty, objects.obj20, "TextYAlignment", Enum.TextYAlignment.Center)
pcall(chilliSetProperty, objects.obj20, "Font", Enum.Font.FredokaOne)
pcall(chilliSetProperty, objects.obj20, "RichText", false)
pcall(chilliSetProperty, objects.obj20, "LineHeight", 1)
pcall(chilliSetProperty, objects.obj20, "MaxVisibleGraphemes", -1)
objects.obj20.Parent = objects.obj17

objects.obj21 = Instance.new("UIStroke")
pcall(chilliSetProperty, objects.obj21, "Name", "UIStroke")
pcall(chilliSetProperty, objects.obj21, "Archivable", true)
pcall(chilliSetProperty, objects.obj21, "ApplyStrokeMode", Enum.ApplyStrokeMode.Contextual)
pcall(chilliSetProperty, objects.obj21, "Color", Color3.fromRGB(0,0,0))
pcall(chilliSetProperty, objects.obj21, "Enabled", true)
pcall(chilliSetProperty, objects.obj21, "LineJoinMode", Enum.LineJoinMode.Round)
pcall(chilliSetProperty, objects.obj21, "Thickness", 0.10999999940395355)
pcall(chilliSetProperty, objects.obj21, "Transparency", 0)
objects.obj21.Parent = objects.obj20

objects.obj22 = Instance.new("UIGradient")
pcall(chilliSetProperty, objects.obj22, "Name", "UIGradient")
pcall(chilliSetProperty, objects.obj22, "Archivable", true)
pcall(chilliSetProperty, objects.obj22, "Color", ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,130,130)),ColorSequenceKeypoint.new(1,Color3.fromRGB(239,28,28))}))
pcall(chilliSetProperty, objects.obj22, "Enabled", true)
pcall(chilliSetProperty, objects.obj22, "Offset", Vector2.new(0,0))
pcall(chilliSetProperty, objects.obj22, "Rotation", 90)
pcall(chilliSetProperty, objects.obj22, "Transparency", NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)}))
objects.obj22.Parent = objects.obj17

objects.obj23 = Instance.new("UIStroke")
pcall(chilliSetProperty, objects.obj23, "Name", "UIStroke")
pcall(chilliSetProperty, objects.obj23, "Archivable", true)
pcall(chilliSetProperty, objects.obj23, "ApplyStrokeMode", Enum.ApplyStrokeMode.Border)
pcall(chilliSetProperty, objects.obj23, "Color", Color3.fromRGB(76,0,0))
pcall(chilliSetProperty, objects.obj23, "Enabled", true)
pcall(chilliSetProperty, objects.obj23, "LineJoinMode", Enum.LineJoinMode.Round)
pcall(chilliSetProperty, objects.obj23, "Thickness", 0.09000000357627869)
pcall(chilliSetProperty, objects.obj23, "Transparency", 0)
objects.obj23.Parent = objects.obj16

objects.obj24 = Instance.new("UIAspectRatioConstraint")
pcall(chilliSetProperty, objects.obj24, "Name", "UIAspectRatioConstraint")
pcall(chilliSetProperty, objects.obj24, "Archivable", true)
pcall(chilliSetProperty, objects.obj24, "AspectRatio", 1.340000033378601)
pcall(chilliSetProperty, objects.obj24, "AspectType", Enum.AspectType.FitWithinMaxSize)
pcall(chilliSetProperty, objects.obj24, "DominantAxis", Enum.DominantAxis.Width)
objects.obj24.Parent = objects.obj2

objects.obj25 = Instance.new("ScrollingFrame")
pcall(chilliSetProperty, objects.obj25, "Name", "List")
pcall(chilliSetProperty, objects.obj25, "Archivable", true)
pcall(chilliSetProperty, objects.obj25, "Visible", true)
pcall(chilliSetProperty, objects.obj25, "Active", true)
pcall(chilliSetProperty, objects.obj25, "AnchorPoint", Vector2.new(0.5,0.5))
pcall(chilliSetProperty, objects.obj25, "BackgroundColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj25, "BackgroundTransparency", 1)
pcall(chilliSetProperty, objects.obj25, "BorderColor3", Color3.fromRGB(27,42,53))
pcall(chilliSetProperty, objects.obj25, "BorderSizePixel", 0)
pcall(chilliSetProperty, objects.obj25, "ClipsDescendants", true)
pcall(chilliSetProperty, objects.obj25, "Position", UDim2.new(0.5000000596046448,0,0.5701961517333984,0))
pcall(chilliSetProperty, objects.obj25, "Rotation", 0)
pcall(chilliSetProperty, objects.obj25, "Selectable", true)
pcall(chilliSetProperty, objects.obj25, "SelectionOrder", 0)
pcall(chilliSetProperty, objects.obj25, "Size", UDim2.new(0.9900000095367432,0,0.8296076059341431,0))
pcall(chilliSetProperty, objects.obj25, "SizeConstraint", Enum.SizeConstraint.RelativeXY)
pcall(chilliSetProperty, objects.obj25, "ZIndex", 5)
pcall(chilliSetProperty, objects.obj25, "AutomaticSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj25, "LayoutOrder", 1)
pcall(chilliSetProperty, objects.obj25, "CanvasPosition", Vector2.new(0,0))
pcall(chilliSetProperty, objects.obj25, "CanvasSize", UDim2.new(0,0,0,642))
pcall(chilliSetProperty, objects.obj25, "AutomaticCanvasSize", Enum.AutomaticSize.None)
pcall(chilliSetProperty, objects.obj25, "ScrollBarThickness", 6)
pcall(chilliSetProperty, objects.obj25, "ScrollBarImageColor3", Color3.fromRGB(255,255,255))
pcall(chilliSetProperty, objects.obj25, "ScrollBarImageTransparency", 0)
pcall(chilliSetProperty, objects.obj25, "ScrollingDirection", Enum.ScrollingDirection.XY)
pcall(chilliSetProperty, objects.obj25, "ScrollingEnabled", true)
pcall(chilliSetProperty, objects.obj25, "VerticalScrollBarInset", Enum.ScrollBarInset.None)
pcall(chilliSetProperty, objects.obj25, "HorizontalScrollBarInset", Enum.ScrollBarInset.None)
objects.obj25.Parent = objects.obj2









objects.obj24.Parent=nil -- same operation performed by native library responsive setup
local mainFrame=objects.obj2
local TweenService=tween
local ACCENT_GRADIENT=ColorSequence.new(Color3.fromRGB(58,255,55),Color3.fromRGB(20,109,0))
local function addScaledStroke(parent,mode,thickness)
    local s=Instance.new('UIStroke');s.ApplyStrokeMode=mode;s.Thickness=thickness;s.Parent=parent;return s
end
local function buildFixedRow(name,text)
    local row=Instance.new('Frame');row.Name=name;row.AnchorPoint=Vector2.new(.5,.5);row.Position=UDim2.fromScale(.5,.1);row.Size=UDim2.fromScale(.97,.13);row.Parent=objects.obj25
    local main=Instance.new('Frame');main.Name='Main';main.AnchorPoint=Vector2.new(.5,.5);main.Position=UDim2.fromScale(.5,.5);main.Size=UDim2.fromScale(1,.85);main.BackgroundColor3=Color3.new(0,0,0);main.Parent=row
    local label=Instance.new('TextLabel');label.Name='Label';label.Text=text;label.Position=UDim2.fromScale(.025,.5);label.AnchorPoint=Vector2.new(0,.5);label.TextScaled=true;label.Parent=main
    return row,main,label
end
local function connectSafeActivation(button,callback)return button.Activated:Connect(callback)end
local function safeCallback(callback,...)if callback then callback(...)end end
local rebirthOuterGradient=ColorSequence.new(Color3.fromRGB(255,86,89),Color3.fromRGB(255,11,15))
local rebirthInnerGradient=rebirthOuterGradient
local normalTextFont=Enum.Font.GothamMedium
local function addRedGradient(parent,name,color)local gradient=Instance.new('UIGradient');gradient.Name=name;gradient.Color=color;gradient.Parent=parent;return gradient end
local function applyShinyTextStyle(label,font)label.Font=font;label.TextScaled=true end
local function createRebirthStyleButton(parent, text, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Active = true
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.AutoButtonColor = false
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.LayoutOrder = layoutOrder
    button.Size = UDim2.new(1, 0, 0.130, 0)
    button.Text = ""
    button.ZIndex = 99
    button.Parent = parent

    local buttonScale = Instance.new("UIScale")
    buttonScale.Scale = 1
    buttonScale.Parent = button

    local base = Instance.new("Frame")
    base.Name = "Main"
    base.Active = false
    base.AnchorPoint = Vector2.new(0.5, 0.5)
    base.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
    base.BorderSizePixel = 0
    base.Position = UDim2.fromScale(0.5, 0.5)
    base.Size = UDim2.fromScale(1, 0.92)
    base.ZIndex = 1
    base.Parent = button
    addScaledStroke(base, Enum.ApplyStrokeMode.Border, 0.0599999987)

    local colorFrame = Instance.new("Frame")
    colorFrame.Name = "ColorFrame"
    colorFrame.Active = false
    colorFrame.AnchorPoint = Vector2.new(0.5, 0)
    colorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    colorFrame.BorderSizePixel = 0
    colorFrame.Position = UDim2.fromScale(0.5, 0)
    colorFrame.Size = UDim2.fromScale(1, 0.9)
    colorFrame.ZIndex = 1
    colorFrame.Parent = base
    addRedGradient(colorFrame, "RedGradient", rebirthOuterGradient)

    local highlight = Instance.new("Frame")
    highlight.Name = "Transparent"
    highlight.Active = false
    highlight.AnchorPoint = Vector2.new(0.5, 0.5)
    highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    highlight.BorderSizePixel = 0
    highlight.Position = UDim2.fromScale(0.5, 0.5)
    highlight.Size = UDim2.fromScale(0.965, 0.88)
    highlight.ZIndex = 2
    highlight.Parent = colorFrame
    addRedGradient(highlight, "RedGradient", rebirthInnerGradient)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Active = false
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Position = UDim2.fromScale(0.5, 0.5)
    label.Size = UDim2.fromScale(0.94, 0.72)
    label.Text = text
    label.ZIndex = 6
    label.Parent = colorFrame
    applyShinyTextStyle(label, normalTextFont)

    local activeTween
    local hovered = false
    local function tweenScale(value, duration)
        if activeTween then
            activeTween:Cancel()
        end
        activeTween = TweenService:Create(
            buttonScale,
            TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Scale = value }
        )
        activeTween:Play()
    end

    button.MouseEnter:Connect(function()
        hovered = true
        tweenScale(1.035, 0.1)
    end)
    button.MouseLeave:Connect(function()
        hovered = false
        tweenScale(1, 0.1)
    end)
    button.MouseButton1Down:Connect(function()
        tweenScale(0.96, 0.055)
    end)
    button.MouseButton1Up:Connect(function()
        tweenScale(hovered and 1.035 or 1, 0.08)
    end)

    return button
end


for _,name in ipairs({'SideButtons','SideButtonsRight'})do
    local column=Instance.new('Frame');column.Name=name;column.Size=UDim2.fromScale(.2612044513,1);column.Parent=mainFrame
    column.AnchorPoint=Vector2.new(name=='SideButtons' and 1 or 0,.5)
    column.Position=UDim2.fromScale(name=='SideButtons' and -.025 or 1.025,.558)
    local button=createRebirthStyleButton(column,name=='SideButtons' and 'Auto Farm' or 'Settings',1)
end
local function createLibraryToggleRow(config)
    local row, main, label = buildFixedRow(config.Name, config.Name)
    label.Size = UDim2.fromScale(0.72, 0.64)

    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Active = false
    switch.AnchorPoint = Vector2.new(0.5, 0.5)
    switch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switch.BorderSizePixel = 0
    switch.Position = UDim2.fromScale(0.915, 0.5)
    switch.Size = UDim2.fromScale(0.142, 0.75)
    switch.ZIndex = 3
    switch.Parent = main
    addScaledStroke(switch, Enum.ApplyStrokeMode.Border, 0.06)

    local offGradient = Instance.new("UIGradient")
    offGradient.Name = "OFF"
    offGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    offGradient.Rotation = 90
    offGradient.Transparency = NumberSequence.new(0.6)
    offGradient.Parent = switch

    local onGradient = Instance.new("UIGradient")
    onGradient.Name = "ON"
    onGradient.Color = ACCENT_GRADIENT
    onGradient.Rotation = 90
    onGradient.Parent = switch

    local knob = Instance.new("Frame")
    knob.Name = "Hold"
    knob.Active = false
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
    knob.BorderSizePixel = 0
    knob.Size = UDim2.fromScale(0.72, 0.72)
    knob.ZIndex = 5
    knob.Parent = switch
    addScaledStroke(knob, Enum.ApplyStrokeMode.Border, 0.09)

    local knobAspect = Instance.new("UIAspectRatioConstraint")
    knobAspect.AspectRatio = 1
    knobAspect.AspectType = Enum.AspectType.FitWithinMaxSize
    knobAspect.DominantAxis = Enum.DominantAxis.Width
    knobAspect.Parent = knob

    local knobColor = Instance.new("Frame")
    knobColor.Name = "Color"
    knobColor.Active = false
    knobColor.AnchorPoint = Vector2.new(0.5, 0)
    knobColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knobColor.BorderSizePixel = 0
    knobColor.Position = UDim2.fromScale(0.5, 0)
    knobColor.Size = UDim2.fromScale(1, 0.9)
    knobColor.ZIndex = 6
    knobColor.Parent = knob

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Active = true
    button.AutoButtonColor = false
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Position = UDim2.fromScale(0.5, 0.5)
    button.Size = UDim2.fromScale(1, 1)
    button.Text = ""
    button.ZIndex = 99
    button.Parent = switch

    local enabled = config.Default == true

    local function setValue(value, fireCallback, animated)
        enabled = value == true
        offGradient.Enabled = not enabled
        onGradient.Enabled = enabled
        local target = UDim2.fromScale(enabled and 0.72 or 0.28, 0.5)
        if animated == false then
            knob.Position = target
        else
            TweenService:Create(
                knob,
                TweenInfo.new(
                    0.12,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.Out
                ),
                {
                    Position = target,
                }
            ):Play()
        end
        if fireCallback ~= false then
            safeCallback(config.Callback, enabled)
        end
    end

    connectSafeActivation(button, function()
        setValue(not enabled, true, true)
    end)

    setValue(enabled, false, false)

    return row, {
        GetValue = function()
            return enabled
        end,
        SetValue = function(value, fireCallback)
            setValue(value, fireCallback, true)
        end,
    }
end



local DevilReleaseScope={}

local ApiImpl={}
local warn=function()end
local function assertObject(object,kind)assert(object._kind==kind)end
__LATEST_OPTION_METHODS__
local heartbeat=signal()
local oldService=game.GetService
game.GetService=function(self,name)if name=='RunService'then return {Heartbeat=heartbeat}end;return oldService(self,name)end
isfile=function()return true end
getcustomasset=function()return 'main-devil-logo' end
local opened,closed,gameCalls,pressed,applied,minimized=0,0,0,0,0,0
local nativeWindow={_kind='Window',_destroyed=false,Tabs={}}
function nativeWindow:Open()opened+=1 end
function nativeWindow:Close()closed+=1 end
function nativeWindow:SelectTab(tab)self.SelectedTab=tab end
local nativeTab={_kind='Tab',Name='Auto',DisplayName='Auto',Page=objects.obj25,Window=nativeWindow,Sections={}}
local nativeSection={_kind='Section',Name='Eggs',DisplayName='Eggs',Tab=nativeTab,Options={}}
nativeTab.Sections={nativeSection};nativeWindow.Tabs={nativeTab,
 {_kind='Tab',Name='Venyx',Window=nativeWindow,Sections={{Options={{Name='Try Venyx',Type='button'}}}}},
 {_kind='Tab',Name='DEVIL HUB',Window=nativeWindow,Sections={{Options={{Name='Old Mode',Type='button'}}}}},
 {_kind='Tab',Name='Settings',Window=nativeWindow,Sections={{Name='Interface',Options={{Name='UI Size',Type='slider'}}}}}}

local optionMethods={Get=ApiImpl[29],Set=ApiImpl[30],Press=ApiImpl[81],Apply=ApiImpl[82]}
function optionMethods:IsVisible()return self._resolvedVisible~=false end
local function addOption(kind,name,controller,row)
    local result=setmetatable({_kind='Option',_controller=controller,Type=kind,Name=name,Instance=row or Instance.new('Frame'),
        Section=nativeSection,_resolvedVisible=true}, {__index=optionMethods})
    table.insert(nativeSection.Options,result);return result
end
local toggleRow,toggleController=createLibraryToggleRow({Name='Auto Hatch',Default=false,Callback=function(v)gameCalls+=1 end})
local originalSetter=toggleController.SetValue
local toggle=addOption('toggle','Auto Hatch',toggleController,toggleRow)
local number,low,high=2,0,10
local slider=addOption('slider','Delay',{GetValue=function()return number end,SetValue=function(v,fire)number=v;if fire then gameCalls+=1 end end})
function optionMethods:GetRange()return low,high end
function optionMethods:GetDecimals()return true,2 end
local dropdownRow=Instance.new('Frame')
for i,name in ipairs({'Rare','Mythic'})do
    local b=Instance.new('TextButton');b.Name='Option'..i;b.Parent=dropdownRow
    local label=Instance.new('TextLabel');label.Name='Label';label.Text=name;label.Parent=b
end
local selection={'Rare'}
local dropdown=addOption('multidropdown','Rarities',{GetValue=function()return table.clone(selection)end,
    SetValue=function(v,fire)selection=table.clone(v);if fire then gameCalls+=1 end end},dropdownRow)
local actionSelection={'Rare'}
local action=addOption('actionmultidropdown','Fusion picks',{GetValue=function()return actionSelection end,
    SetValue=function(v)actionSelection=v end,Apply=function()applied+=1 end},dropdownRow)
local button=addOption('button','Claim',{Press=function()pressed+=1 end})
local text='Actual status'
local label=addOption('text','Status',{GetValue=function()return text end})
local richRow=Instance.new('Frame');richRow.Name='Inventory';richRow.Parent=objects.obj25
richRow.Size=UDim2.new(.97,0,0,240)
local petImage=Instance.new('ImageLabel');petImage.Name='Pet';petImage.Image='rbxassetid://123';petImage.Parent=richRow
local eggValue=Instance.new('TextLabel');eggValue.Name='EggIncome';eggValue.Text='150/s';eggValue.Parent=richRow
local petButton=Instance.new('TextButton');petButton.Name='SelectPet';petButton.Parent=richRow
local petClicks=0;petButton.Activated:Connect(function()petClicks+=1 end)
local communityImage=Instance.new('ImageLabel');communityImage.Image='rbxassetid://128961717706452';communityImage.Parent=richRow
local rich=addOption('canvas','Discord',{},richRow)
local originalRichParent=richRow.Parent
local nativeLauncher=Instance.new('ScreenGui');nativeLauncher.Name='ChilliLeftCenter';nativeLauncher:SetAttribute('ChilliLibraryOwned',true);nativeLauncher.Parent=core
local gc={nativeWindow,{},function()end}
local getgc=function(tables)assert(tables==true);return gc end
local lastLibrary,configs
local function factory()
    local library={Assets={},Theme={Accent=Color3.fromRGB(0,140,255),Background=Color3.fromRGB(8,13,24)}};function library:SetTheme(value)self.Theme=value end
    local guiWindow={Tabs={},Gui=Instance.new('ScreenGui')}
    library.Windows={guiWindow}
    function guiWindow:SetSize(value)self.TestSize=value end
    function guiWindow:Minimize()minimized+=1 end
    function library:CreateWindow(config)configs=config;return guiWindow end
    function library:Notify()end
    function library:Destroy()self.destroyed=true;guiWindow.Gui:Destroy()end
    function guiWindow:CreateTab(config)
        local t={Config=config,Groups={},_page=Instance.new('Frame')};table.insert(self.Tabs,t)
        function t:CreateGroupbox(config)
            local group={Config=config,Controls={},_items={},List=Instance.new('Frame')};group.List.Parent=guiWindow.Gui;table.insert(self.Groups,group)
            local function create(kind,config)
                local c={kind=kind,Config=config,Current=config.CurrentValue or config.CurrentOption or config.Name,_frame=Instance.new('Frame')}
                c._frame.LayoutOrder=#group.Controls+1
                function c:Set(v,silent)self.Current=v;if not silent and self.Config.Callback then self.Config.Callback(v)end end
                function c:SetVisible(v)self.Visible=v end
                function c:Refresh(opts,keep,silent)self.Config.Options=opts;check(silent==true,'dropdown refresh not silent')end
                function c:Destroy()self.destroyed=true end
                if config.Callback and kind~='button' then config.Callback(c.Current)end -- aggressive constructor callback test
                table.insert(group.Controls,c);return c
            end
            function group:ColorPicker(c)c.CurrentValue=c.Default;return create('color',c)end
            function group:CreateToggle(c)return create('toggle',c)end
            function group:CreateSlider(c)return create('slider',c)end
            function group:CreateDropdown(c)return create('dropdown',c)end
            function group:CreateInput(c)return create('input',c)end
            function group:CreateButton(c)return create('button',c)end
            function group:CreateLabel(c)return create('label',c)end
            return group
        end
        return t
    end
    lastLibrary=library;return library
end
local attach=(function()
__CURRENT_BRIDGE__
end)()
local newControls={}
for _,name in ipairs({'Farm Monsters While Fishing','Rotate Fishing And Treadmill','Teleport To Monsters','Teleport To Pumpkins','Teleport To Ghosts'})do
 local state=false
 newControls[name]=addOption('toggle',name,{GetValue=function()return state end,SetValue=function(v,fire)state=v;if fire then gameCalls+=1 end end})
end
local historyRow=Instance.new('Frame');historyRow.Name='FishingHistory';historyRow.Parent=objects.obj25
historyRow.Size=UDim2.new(.97,0,0,120)
local historyText=Instance.new('TextLabel');historyText.Text='No catches';historyText.Parent=historyRow
local history=addOption('canvas','Fishing History',{},historyRow)
local historyParent=historyRow.Parent
local ui=attach(factory)
check(ui.Report.status=='Mounted DEVIL HUB main GUI on original Chilli handles','native handles not mounted')
check(lastLibrary.Gui==nil and lastLibrary.Windows[1].Gui:GetAttribute('DevilHubPresentation')==true and lastLibrary.Windows[1].Gui.Enabled,'actual WINDOW ScreenGui must be exempt and visible')
check(configs.Theme=='Abyss' and configs.Profile and configs.Search and configs.Density=='Compact','main GUI configuration changed')
check(gameCalls==0 and pressed==0 and applied==0,'GUI creation called backend')
check(toggleController.SetValue==originalSetter,'native setter replaced')
local settingsCount=0;for _,tab in ipairs(lastLibrary.Windows[1].Tabs)do check(tab.Config.Name~='Venyx' and tab.Config.Name~='DEVIL HUB','removed mode still mounted');if tab.Config.Name=='Settings'then settingsCount+=1 end end;check(settingsCount==1,'duplicate or missing Settings tab');
check(ui.Report.boundOptions==11 and ui.Report.originalPanelLinks==0 and ui.Report.embeddedPanels==2,'native rich panel not embedded')
check(not objects.obj1.Enabled and not nativeLauncher.Enabled,'original GUI / floating launcher still overlaps')
objects.obj1.Enabled=true;check(not objects.obj1.Enabled,'original UI re-enabled itself over DEVIL HUB')
check(richRow.Parent.Name=='DevilNativePanel' and petImage.Parent==richRow and petImage.Image=='rbxassetid://123','actual native pet image lost / cloned')
check(communityImage.Image==lastLibrary.Assets.Logo,'embedded community logo was not replaced')
communityImage.Image='rbxassetid://128961717706452'
check(communityImage.Image==lastLibrary.Assets.Logo,'native image redraw restored original brand')
check(table.find(ui.Items[rich].Group._items,ui.Items[rich].Control)~=nil,'rich panel missing from main GUI search / group registry')
richRow.Size=UDim2.new(.97,0,0,360);check(richRow.Parent.Size.Y.Offset==360,'rich panel height did not track native layout')
eggValue.Text='250/s';check(eggValue.Text=='250/s','original values stopped updating')
petButton.Activated:Fire();check(petClicks==1,'embedded original item action lost')
local originalConnection=toggleRow.Main.Switch.Button.Activated.listeners[1]
ui.Items[toggle].Control:Set(true,false)
check(toggleController.GetValue()==true and gameCalls==1,'native toggle setter/callback not used exactly once')
toggleRow.Main.Switch.Button.Activated:Fire()
ui.Sync()
check(toggleController.GetValue()==false and gameCalls==2 and ui.Items[toggle].Control.Current==false,'native state not mirrored silently')
check(originalConnection.Connected,'native event disconnected')
ui.Items[slider].Control:Set(4.25,false)
check(number==4.25 and gameCalls==3,'slider did not use original Set method')
local oldSlider=ui.Items[slider].Control
high=50;ui.Sync()
check(oldSlider.destroyed and ui.Items[slider].Control.Config.Range[2]==50 and gameCalls==3,'native slider range update lost / fired backend')
ui.Items[dropdown].Control:Set({'Mythic'},false)
check(selection[1]=='Mythic' and gameCalls==4,'multi-select lost native callback')
dropdownRow.Option2.Label.Text='Secret';ui.Sync()
check(ui.Items[dropdown].Control.Config.Options[2]=='Secret' and gameCalls==4,'native dropdown options not refreshed silently')
ui.Items[action].Control:Set({'Secret'},false)
check(applied==0,'action dropdown applied before explicit Apply')
ui.Items[action].Apply.Config.Callback();check(applied==1,'original Apply not called')
ui.Items[button].Control.Config.Callback();check(pressed==1,'original Press not called')
text='New status';ui.Sync();check(ui.Items[label].Control.Current=='New status','native label update lost')
toggle._resolvedVisible=false;ui.Sync();check(ui.Items[toggle].Control.Visible==false,'conditional native visibility ignored')
for name,option in pairs(newControls)do
 check(ui.Items[option]~=nil,'latest option missing: '..name)
 local calls=gameCalls;ui.Items[option].Control:Set(true,false)
 check(option:Get()==true and gameCalls==calls+1,'latest callback lost: '..name)
 option:Set(false,false);ui.Sync()
 check(ui.Items[option].Control.Current==false,'latest state not synchronized: '..name)
end
check(historyRow.Parent.Name=='DevilNativePanel','Fishing History not embedded')
historyText.Text='Ghost Fish +1';ui.Sync()
check(historyText.Text=='Ghost Fish +1' and not historyRow.destroyed,'Fishing History live update lost')
local before=gameCalls
ui.Destroy()
check(lastLibrary.destroyed and originalConnection.Connected and gameCalls==before,'UI unload modified native engine/events')
check(opened==1 and objects.obj1.Enabled and nativeLauncher.Enabled,'original menu / launcher was not restored')
check(richRow.Parent==originalRichParent and petImage.Parent==richRow and not richRow.destroyed,'GUI unload destroyed original rich panel')
check(richRow.Size.Y.Offset==240,'native panel geometry not restored')
check(historyRow.Parent==historyParent and not historyRow.destroyed,'Fishing History destroyed on unload')
petButton.Activated:Fire();check(petClicks==2,'native callback lost after rich panel restored')
for _,c in ipairs(heartbeat.listeners)do check(not c.Connected,'UI heartbeat leaked')end
gc={}
local missing=attach(function()error('must not create fake controls')end)
check(missing.Report.status=='Native UI handles unavailable' and not env.DevilChilliMainUI,'missing native handles did not fail safely')
env.DevilChilliNativeWindow=nativeWindow
local direct=attach(factory)
check(direct.Report.status=='Mounted DEVIL HUB main GUI on original Chilli handles' and direct.Report.discovery=='Recovered native UI constructor export (no getgc required)','direct export did not mount without GC tables')
check(direct.Report.boundOptions==11 and direct.Report.embeddedPanels==2,'direct export lost native controls')
check(gameCalls==before,'direct discovery executed gameplay callbacks')
direct.Destroy();env.DevilChilliNativeWindow=nil
print('PASS existing main-GUI bridge: '..checks..' checks; protected gameplay runtime not executed')
