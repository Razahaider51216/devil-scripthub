local scope={DevilHubLogoV3Version="devil-brand-v3-20261022-1",DevilHubLogoV3="local-v2.png"}
local links={};local b=makeBrand(scope,links)
check(b.Resolve()=="local-v2.png","cached PNG not reused")
local screen=Instance.new("ScreenGui")
local root=Instance.new("Frame");root.Name="Window";root.Parent=screen
local header=Instance.new("ImageLabel");header.Name="Logo";header.Image="old.png";header.ImageTransparency=.2;header.Parent=root
local button=Instance.new("TextButton");button.Name="Launcher";button.Parent=screen
local icon=Instance.new("ImageLabel");icon.Name="Logo";icon.Image="old.png";icon.Parent=button
local function classify(node)return node.Name=="Logo",node.Parent==button end
b.Apply(header,classify);b.Apply(icon,classify)
check(header.Image=="local-v2.png"and header.ImageTransparency==0,"header PNG missing")
check(icon.ImageTransparency==1 and icon:FindFirstChild("DevilCustomD"),"launcher D missing")
local glyph=icon:FindFirstChild("DevilCustomD");local count=#glyph:GetChildren()
check(count>1 and count<150,"vector geometry unbounded")
for _,part in ipairs(glyph:GetChildren())do check(part:GetAttribute("DevilBlueSettings"),"theme can recolor custom D geometry")end
for _=1,8 do icon.Image="";icon.Image="old.png";icon.ImageTransparency=0;b.Apply(icon,classify)end
check(icon.ImageTransparency==1 and #glyph:GetChildren()==count and #icon:GetChildren()==1,"native redraw duplicated or erased D")
header.Image="old-remote.png";check(header.Image=="local-v2.png","late logo write reverted brand")
local oldRootParent=root.Parent
local nativeCalls=0;button.MouseButton1Click:Connect(function()nativeCalls+=1 end)
button.MouseButton1Click:Fire();check(nativeCalls==1 and root.Parent==oldRootParent,"branding changed native callbacks/root")
icon.ZIndex=30;check(glyph.ZIndex==31,"glyph escaped stacking order")
local pet=Instance.new("ImageLabel");pet.Name="PetImage";pet.Image="pet.png";pet.Parent=root
b.Apply(pet,classify);check(pet.Image=="pet.png"and #pet:GetChildren()==0,"pet artwork changed")
local item=Instance.new("ImageLabel");item.Name="ItemIcon";item.Image="item.png";item.Parent=root
b.Apply(item,classify);check(item.Image=="item.png","item icon changed")
check(b.Matches("DevilHub_LogoV3_20261022.png")and b.Matches("local-v2.png")and not b.Matches("pet.png"),"brand classifier wrong")
icon:Destroy();check(glyph.destroyed,"destroy leaked vector nodes")
for _,link in ipairs(links)do link:Disconnect()end
b.Destroy();check(header.Image=="old.png"and header.ImageTransparency==.2,"unload failed to restore logo")
local fallback=makeBrand({},{});local blank=Instance.new("ImageLabel");blank.Name="Logo";blank.Parent=root
fallback.Apply(blank,classify)
check(blank:FindFirstChild("DevilCustomD")~=nil,"executor without assets has blank fallback")
print("PASS v2 brand image, vector D, native redraw/clicks, content isolation, cache and cleanup: "..checks.." checks")
