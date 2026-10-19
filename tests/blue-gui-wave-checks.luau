local core=Instance.new('CoreGui')
local env={}
local getgenv=function()return env end
local game={GetService=function(_,name)if name=='CoreGui'then return core elseif name=='HttpService'then return {} end;error(name)end}
local function node(class,name,parent,props)
 local obj=Instance.new(class);obj.Name=name
 for key,value in pairs(props or{})do obj[key]=value end
 obj.Parent=parent;return obj
end
local gui=node('ScreenGui','DevilHubWaveTest',core)
local root=node('Frame','Window',gui,{Size=UDim2.fromOffset(880,520),AbsoluteSize=Vector2.new(880,520)})
local island=node('CanvasGroup','Island',gui,{Size=UDim2.fromOffset(124,32),Visible=false})
local compact=node('CanvasGroup','Compact',island,{BackgroundTransparency=1})
local host=node('Frame','Frame',compact,{BackgroundTransparency=1})
local group=node('Frame','Frame',host,{Size=UDim2.fromOffset(18,16),BackgroundTransparency=1})
local nativeColor=Color3.fromRGB(120,120,130)
local bars={}
local function buildBar(parent,index,earlyParent)
 local bar=Instance.new('Frame');bar.Name='Frame'
 if earlyParent then bar.Parent=parent end
 bar.AnchorPoint=Vector2.new(0,.5);bar.Position=UDim2.new(0,(index-1)*5,.5,0)
 bar.Size=UDim2.fromOffset(3,3);bar.BackgroundColor3=nativeColor;bar.BorderSizePixel=0
 if not earlyParent then bar.Parent=parent end
 node('UICorner','UICorner',bar,{CornerRadius=UDim.new(1,0)})
 return bar
end
for index=1,4 do bars[index]=buildBar(group,index)end
-- Identical geometry in game HUD and a regular menu must not be recognized.
local hud=node('ScreenGui','GameHUD',core)
local fakeIsland=node('CanvasGroup','Island',hud)
local hudGroup=node('Frame','Frame',fakeIsland,{Size=UDim2.fromOffset(18,16)})
local hudBar=buildBar(hudGroup,1)
local regularGroup=node('Frame','Frame',root,{Size=UDim2.fromOffset(18,16)})
local regularBar=buildBar(regularGroup,1)
local controller=(function()
-- MODULE INSERTED HERE
end)()
flush()
local function hasTone(bar)
 local tone=bar:FindFirstChild('DevilWaveTone')
 return tone and tone.Rotation==90 and tone.Color.Keypoints[1].Value==Color3.fromRGB(104,177,255)
  and tone.Color.Keypoints[2].Value==Color3.fromRGB(255,255,255)
  and bar.BackgroundColor3==Color3.fromRGB(255,255,255)and bar.BackgroundTransparency==0
end
for _,bar in ipairs(bars)do check(hasTone(bar),'mini waveform lacks readable blue-white gradient')end
check(hudBar.BackgroundColor3==nativeColor and hudBar:FindFirstChild('DevilWaveTone')==nil,'wave styling touched game HUD')
check(regularBar:FindFirstChild('DevilWaveTone')==nil,'wave styling misidentified an ordinary menu frame')
local geometryWrites=0
for _,bar in ipairs(bars)do bar:GetPropertyChangedSignal('Size'):Connect(function()geometryWrites+=1 end)end
-- The native Render callback changes height each frame; native refresh tweens color.
local latest=Color3.fromRGB(200,30,30)
for frame=1,20 do
 for index,bar in ipairs(bars)do
  bar.Size=UDim2.fromOffset(3,4+(frame+index)%12);bar.BackgroundColor3=latest
 end
 flush()
end
check(geometryWrites==80,'theme rewrote native waveform animation geometry')
for _,bar in ipairs(bars)do check(hasTone(bar),'native status redraw removed waveform colors')end
local bubble=node('TextButton','IslandBubble',gui,{Size=UDim2.fromOffset(40,40),Text=''})
group.Parent=bubble;root.Visible=false;island.Visible=false;bubble.Visible=true;flush()
for _,bar in ipairs(bars)do check(hasTone(bar),'pinned waveform lost its two-tone colors')end
check(not root.Visible and bubble.Visible,'wave styling changed native minimize visibility')
local lateGroup=node('Frame','Frame',bubble,{Size=UDim2.fromOffset(18,16),BackgroundTransparency=1})
local lateBar=buildBar(lateGroup,1,true);flush()
check(hasTone(lateBar),'parent-first late waveform construction not styled')
local lateIsland=node('CanvasGroup','Island',nil)
local detachedGroup=node('Frame','Frame',lateIsland,{Size=UDim2.fromOffset(18,16)})
local detachedBar=buildBar(detachedGroup,1)
lateIsland.Parent=gui;flush()
check(hasTone(detachedBar),'completed mini bar subtree not styled on insertion')
controller.SetLanguage('TH');flush()
check(hasTone(lateBar),'language update recolored waveform gradient')
local same=(function()
-- MODULE INSERTED HERE
end)()
check(same==controller and #bars[1]:GetChildren()==2,'wave gradient duplicated on repeated load')
controller.Destroy();flush()
for _,bar in ipairs(bars)do
 check(bar:FindFirstChild('DevilWaveTone')==nil and bar.BackgroundColor3==latest and bar.BackgroundTransparency==0,'native waveform color not restored on unload')
end
check(lateBar.BackgroundColor3==nativeColor and lateBar:FindFirstChild('DevilWaveTone')==nil,'late waveform gradient leaked after unload')
print('PASS native mini waveform blue-white styling and animation preservation: '..checks..' checks')
