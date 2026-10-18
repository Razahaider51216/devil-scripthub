
local checks=0
local function check(v,message) assert(v,message); checks+=1 end
local delayed={}
local queued={}
local task={spawn=function(f)table.insert(queued,f)end,defer=function(f)table.insert(queued,f)end,delay=function(_,f)table.insert(delayed,f)end}
local function flush()for _=1,100 do if #queued==0 then return end;local batch=queued;queued={};for _,fn in ipairs(batch)do fn()end end;error('defer loop')end
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
local colorMeta={__index={Lerp=function(a,b,t)return Color3.new(a.R+(b.R-a.R)*t,a.G+(b.G-a.G)*t,a.B+(b.B-a.B)*t)end},__eq=function(a,b)return math.abs(a.R-b.R)<1e-8 and math.abs(a.G-b.G)<1e-8 and math.abs(a.B-b.B)<1e-8 end}

function Color3.new(r,g,b)return setmetatable({R=r,G=g,B=b},colorMeta)end
function Color3.fromRGB(r,g,b)return Color3.new(r/255,g/255,b/255)end
local UDim={new=function(s,o)return {Scale=s,Offset=o}end}
local UDim2={}
local dimMeta={__eq=function(a,b)return a.X.Scale==b.X.Scale and a.X.Offset==b.X.Offset and a.Y.Scale==b.Y.Scale and a.Y.Offset==b.Y.Offset end}
function UDim2.new(x,xo,y,yo)return setmetatable({X=UDim.new(x,xo),Y=UDim.new(y,yo)},dimMeta)end
function UDim2.fromScale(x,y)return UDim2.new(x,0,y,0)end
function UDim2.fromOffset(x,y)return UDim2.new(0,x,0,y)end
local Vector2={}
local vectorMeta={}
function Vector2.new(x,y)return setmetatable({X=x,Y=y},vectorMeta)end
function vectorMeta.__add(a,b)return Vector2.new(a.X+b.X,a.Y+b.Y)end
function vectorMeta.__sub(a,b)return Vector2.new(a.X-b.X,a.Y-b.Y)end
function vectorMeta.__div(a,b)return Vector2.new(a.X/b,a.Y/b)end
function vectorMeta.__mul(a,b)if type(a)=='number'then return Vector2.new(a*b.X,a*b.Y)end;return Vector2.new(a.X*b,a.Y*b)end
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
local guiClasses={Frame=true,CanvasGroup=true,ScrollingFrame=true,TextLabel=true,TextButton=true,TextBox=true,ImageLabel=true,ImageButton=true,ViewportFrame=true}
local Instance={}
local mt={}
function mt.__index(self,key)
    if methods[key] then return methods[key]end
    if self.props[key]~=nil then return self.props[key]end
    for _,child in ipairs(self.children)do if child.Name==key then return child end end
    if key=='ChildAdded' or key=='Activated' or key=='Focused' or key=='FocusLost' or key=='InputBegan' or key=='MouseEnter' or key=='MouseLeave' or key=='MouseButton1Down' or key=='MouseButton1Up' or key=='DescendantAdded' or key=='Destroying' then
        self.signals[key]=self.signals[key] or signal();return self.signals[key]
    end
end
function mt.__newindex(self,key,value)
    if self.props.MockQuantize and key=='BackgroundTransparency'and type(value)=='number'then
        local storage=buffer.create(4);buffer.writef32(storage,0,value);value=buffer.readf32(storage,0)
    end
    local previous=self.props[key]
    if key=='Parent' and previous~=value then
        if previous then local i=table.find(previous.children,self);if i then table.remove(previous.children,i)end end
        self.props[key]=value
        if value then
            table.insert(value.children,self)
            if value.signals.ChildAdded then value.signals.ChildAdded:Fire(self)end
            local p=value
            while p do if p.signals.DescendantAdded then p.signals.DescendantAdded:Fire(self)end;p=p.Parent end
        end
    else self.props[key]=value end
    if previous~=value and self.signals[key] then self.signals[key]:Fire()end
end
function Instance.new(class)
    return setmetatable({props={ClassName=class,Name=class,Size=UDim2.fromScale(1,1),Position=UDim2.fromScale(0,0),AnchorPoint=Vector2.new(0,0),
        Visible=true,DisplayOrder=0,AbsolutePosition=Vector2.new(0,0),AbsoluteSize=Vector2.new(0,0),Image='',ImageColor3=Color3.new(1,1,1),Scale=1,RichText=false,BackgroundTransparency=0,BackgroundColor3=Color3.new(1,1,1),
        TextColor3=Color3.new(1,1,1),PlaceholderColor3=Color3.fromRGB(178,178,178),TextStrokeColor3=Color3.new(0,0,0),TextTransparency=0,Color=class=='UIGradient' and ColorSequence.new(Color3.new(1,1,1)) or class=='UIStroke' and Color3.new(1,1,1) or nil,
        Text='',Enabled=true,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Font=Enum.Font.SourceSans},
        signals={},children={},attributes={}},mt)
end
function methods:IsA(class)
    return class==self.ClassName or (class=='GuiObject' and guiClasses[self.ClassName]) or
        (class=='GuiButton' and (self.ClassName=='TextButton' or self.ClassName=='ImageButton'))
end
function methods:SetAttribute(key,value)self.attributes[key]=value;if self.signals['Attr:'..key]then self.signals['Attr:'..key]:Fire()end end
function methods:GetAttributeChangedSignal(key)return self:GetPropertyChangedSignal('Attr:'..key)end
function methods:WaitForChild(name)return assert(self:FindFirstChild(name),name)end
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
