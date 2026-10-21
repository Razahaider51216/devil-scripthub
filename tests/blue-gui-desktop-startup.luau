-- Presentation startup replay; these are not live game/executor integrations.
local game,getgenv,gethui
local function node(class,name,parent,props)
 local obj=Instance.new(class);obj.Name=name
 for key,value in pairs(props or{})do obj[key]=value end
 obj.Parent=parent;return obj
end
for _,input in ipairs({
 {Name='Desktop',KeyboardEnabled=true,MouseEnabled=true,TouchEnabled=false},
 {Name='TouchLaptop',KeyboardEnabled=true,MouseEnabled=true,TouchEnabled=true},
 {Name='Mobile',KeyboardEnabled=false,MouseEnabled=false,TouchEnabled=true}
})do
for _,route in ipairs(routes)do for _,profile in ipairs({'CoreGui','HiddenFolder','HiddenScreen','PlayerGui','ThrowingHelper'})do
 local core=Instance.new('CoreGui')
 local player=Instance.new('Player');local playerGui=node('PlayerGui','PlayerGui',player)
 local hidden=node(profile=='HiddenScreen'and 'ScreenGui'or 'Folder','ExecutorUI',core)
 local owner=profile=='PlayerGui'and playerGui or(profile=='HiddenFolder'or profile=='HiddenScreen')and hidden or core
 local scope={}
 getgenv=function()return scope end
 gethui=profile=='ThrowingHelper'and function()error('helper unavailable')end
  or(profile=='HiddenFolder'or profile=='HiddenScreen')and function()return hidden end or nil
 game={GameId=route.Universe,PlaceId=route.Place,GetService=function(_,name)
  if name=='CoreGui'then if profile=='PlayerGui'then error('CoreGui denied')end;return core
  elseif name=='HttpService'then return {}
  elseif name=='Players'then return {LocalPlayer=player}
  elseif name=='UserInputService'then return input end
  error('Unexpected service '..name)
 end}
 local hud=node('ScreenGui','GameHUD',playerGui)
 local hudColor=Color3.fromRGB(200,40,10)
 local hudPlane=node('Frame','DesktopDimmer',hud,{Size=UDim2.fromOffset(1888,982),BackgroundColor3=hudColor,BackgroundTransparency=.7})
 local controller=(function()
-- MODULE INSERTED HERE
 end)()
 -- GUI is parented before viewport dimensions are ready (auto-execute on PC).
 local gui=node('ScreenGui','DevilHubDesktop',owner)
 gui:SetAttribute('DevilBreakFrontend',route.File=='break-and-steal-an-egg.lua')
 local plane=Instance.new('Frame');plane.Name='Frame';plane.Size=UDim2.fromOffset(100,100)
 plane.BackgroundColor3=Color3.fromRGB(0,0,0);plane.BackgroundTransparency=.95;plane.Parent=gui
 local tint=node('Frame','Frame',plane,{Size=UDim2.fromScale(1,1),BackgroundTransparency=.6,BackgroundColor3=Color3.fromRGB(50,0,0)})
 local nativeGradient=ColorSequence.new(Color3.fromRGB(255,80,10),Color3.fromRGB(0,0,0))
 local gradient=node('UIGradient','UIGradient',tint,{Color=nativeGradient})
 plane.Size=UDim2.fromOffset(1888,982);plane.AbsoluteSize=Vector2.new(1888,982)
 flush() -- A yielding startup may cache this unnamed frame before Window exists.
 local root=node('Frame','Window',gui,{Size=UDim2.fromOffset(760,510),Visible=false})
 flush() -- Native AbsoluteSize settles after the initial descendant event.
 root.AbsoluteSize=Vector2.new(760,510)
 flush()
 check(root:FindFirstChild('DevilLanguageSelector')~=nil and plane:FindFirstChild('DevilLanguageSelector')==nil,'late real window did not replace the provisional startup root')
 local action=node('TextButton','Action',root,{Size=UDim2.fromOffset(200,30),Text='Auto Farm'})
 local callbacks=0;local connection=action.Activated:Connect(function()callbacks+=1 end)
 local dialog=node('TextButton','Dialog',gui,{Size=UDim2.fromOffset(1888,982),ZIndex=9000,Text='',BackgroundTransparency=.5})
 local bitmap=node('ImageLabel','BackdropImage',gui,{Size=UDim2.fromOffset(1888,982),Image='native-dimmer',ImageColor3=hudColor,BackgroundTransparency=.8})
 gui.AbsoluteSize=Vector2.new(1920,1000);flush()
 check(plane.BackgroundTransparency==.95 and plane.BackgroundColor3==Color3.fromRGB(0,0,0),'desktop pixel screen layer was painted as an opaque menu')
 check(tint.BackgroundTransparency==.6 and tint.BackgroundColor3==Color3.fromRGB(50,0,0)and gradient.Color==nativeGradient,'late viewport sizing did not restore nested native surfaces')
 check(bitmap.ImageColor3==hudColor and bitmap.BackgroundTransparency==.8,'desktop bitmap dimmer was recolored')
 check(root:FindFirstChild('DevilLanguageSelector')~=nil and plane:FindFirstChild('DevilLanguageSelector')==nil,'startup pixel plane retained main window ownership')
 check(root.BackgroundColor3==Color3.fromRGB(7,9,13)and root.BackgroundTransparency==.14,'main window lost dark theme')
 if route.File=='break-and-steal-an-egg.lua'then check(not dialog.Visible,'desktop Break dialog covered the game before intro')end
 root.Visible=true;flush()
 check(dialog.Visible,'startup fix suppressed an intentional open dialog')
 action.Activated:Fire();check(callbacks==1 and connection.Connected,'startup fix changed game callbacks')
 -- Geometry may be assigned after parenting even when viewport is already ready.
 local late=Instance.new('TextButton');late.Size=UDim2.fromOffset(100,100)
 late.Text='';late.BackgroundTransparency=.9;late.Parent=gui
 late.Size=UDim2.new(1,-32,1,-18);flush()
 check(late.BackgroundTransparency==.9,'parent-first desktop input plane stayed opaque')
 -- A normal card promoted to a pixel plane must restore source child styling.
 local promoted=node('Frame','Frame',gui,{Size=UDim2.fromOffset(100,100),AbsoluteSize=Vector2.new(100,100),BackgroundTransparency=.7})
 local child=node('Frame','Frame',promoted,{Size=UDim2.fromScale(1,1),BackgroundTransparency=.65,BackgroundColor3=hudColor})
 promoted.Size=UDim2.fromOffset(1888,982);promoted.AbsoluteSize=Vector2.new(1888,982);flush()
 check(promoted.BackgroundTransparency==.7 and child.BackgroundTransparency==.65 and child.BackgroundColor3==hudColor,'resized pixel plane kept menu opacity')
 promoted.Size=UDim2.fromOffset(100,100);promoted.AbsoluteSize=Vector2.new(100,100);flush()
 check(promoted.BackgroundTransparency==.7 and child.BackgroundColor3~=hudColor,'shrunk card did not return to normal styling')
 -- Resize/fullscreen changes retain transparency without scanning every frame.
 gui.AbsoluteSize=Vector2.new(1280,720)
 plane.Size=UDim2.fromOffset(1248,702);plane.AbsoluteSize=Vector2.new(1248,702);flush()
 check(plane.BackgroundTransparency==.95 and gradient.Color==nativeGradient,'desktop window resize darkened native background')
 gui.AbsoluteSize=Vector2.new(3840,2160)
 plane.Size=UDim2.fromOffset(3808,2142);plane.AbsoluteSize=Vector2.new(3808,2142);flush()
 check(plane.BackgroundTransparency==.95,'4K viewport darkened the desktop pixel plane')
 local scaled=node('Frame','ScaledDimmer',gui,{Size=UDim2.fromOffset(1904,1071),AbsoluteSize=Vector2.new(3808,2142),BackgroundTransparency=.93})
 check(scaled.BackgroundTransparency==.93,'rendered pixel coverage ignored native scaling')
 root.Visible=false;flush()
 if route.File=='break-and-steal-an-egg.lua'then check(not dialog.Visible,'desktop Break dialog survived window hide')end
 check(hudPlane.BackgroundColor3==hudColor and hudPlane.BackgroundTransparency==.7,'desktop startup fix touched game HUD')
 controller.Destroy();flush()
 check(connection.Connected and plane.BackgroundTransparency==.95 and tint.BackgroundColor3==Color3.fromRGB(50,0,0),'startup teardown lost source state')
 check(root:FindFirstChild('DevilLanguageSelector')==nil and dialog.Visible,'startup teardown leaked presentation state')
end end end
print('PASS desktop/touch-laptop/mobile presentation across '..#routes..' routes, 5 GUI access profiles and resize/4K: '..checks..' checks')
