local core=Instance.new('CoreGui')
local player=Instance.new('Player');local playerGui=Instance.new('PlayerGui');playerGui.Parent=player
local scope={DevilHubSilverLogo='custom://KuydumHubLogo.jpg'}
local getgenv=function()return scope end
local game={GetService=function(_,name)
 if name=='CoreGui'then return core elseif name=='HttpService'then return {}
 elseif name=='Players'then return {LocalPlayer=player}end
 error(name)
end}
local function node(class,name,parent,props)
 local obj=Instance.new(class);obj.Name=name
 for k,v in pairs(props or{})do obj[k]=v end
 obj.Parent=parent;return obj
end
local devil=node('ScreenGui','DevilHubOriginal',core)
devil:SetAttribute('DevilHubPresentation',true)
local old=node('Frame','Window',devil,{Size=UDim2.fromOffset(880,520),AbsoluteSize=Vector2.new(880,520),BackgroundColor3=Color3.fromRGB(8,17,27)})
node('TextLabel','Title',old,{Text='DEVIL HUB'})
local oldColor=old.BackgroundColor3
local gui=node('ScreenGui','KuydumHub',core)
gui:SetAttribute('KuydumHubPresentation',true)
local window=node('Frame','Window',gui,{Size=UDim2.fromOffset(880,520),AbsoluteSize=Vector2.new(880,520)})
local title=node('TextLabel','Title',window,{Text='KUYDUM HUB'})
local action=node('TextButton','Action',window,{Text='Auto Farm'})
local calls=0;action.Activated:Connect(function()calls+=1 end)
local module=(function()
-- THEME
end)()
flush()
assert(module.Version=='kuydum-mono-20261022-1')
assert(old.BackgroundColor3==oldColor,'fork recolored DEVIL HUB')
for _,node in ipairs(gui:GetDescendants())do
 if node:IsA('GuiObject')then
  for _,key in ipairs({'BackgroundColor3','TextColor3','ImageColor3'})do
   local ok,c=pcall(function()return node[key]end)
   if ok and c then assert(math.abs(c.R-c.G)<1e-7 and math.abs(c.G-c.B)<1e-7,'non-monochrome UI '..node.Name..'/'..key)end
  end
 end
end
action.Activated:Fire();assert(calls==1,'theme replaced the native callback')
assert(window:FindFirstChild('DevilLanguageSelector'),'embedded language selector missing')
module.SetLanguage('TH');module.SetLanguage('EN')
assert(title.Text=='KUYDUM HUB','language switch restored original branding')
module.Destroy();assert(old.BackgroundColor3==oldColor)
print('PASS KUYDUM monochrome GUI, embedded language, native callbacks and original-hub isolation')
