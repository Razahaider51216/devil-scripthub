local core=Instance.new('CoreGui')
local playerGui=Instance.new('PlayerGui')
local player=Instance.new('Player');playerGui.Parent=player
local function copy(value)
 if type(value)~='table'then return value end
 local out={};for key,item in pairs(value)do out[key]=copy(item)end;return out
end
local encoded,serial={},0
local http={JSONEncode=function(_,value)serial+=1;local token='json'..serial;encoded[token]=copy(value);return token end,
 JSONDecode=function(_,value)assert(encoded[value],'bad JSON');return copy(encoded[value])end}
local game={GetService=function(_,name)
 if name=='CoreGui'then return core elseif name=='Players'then return {LocalPlayer=player}elseif name=='HttpService'then return http end
 error('Unexpected service '..name)
end}
local files={}
local env={}
local getgenv=function()return env end
local isfile=function(name)return files[name]~=nil end
local readfile=function(name)return files[name]end
local writefile=function(name,value)files[name]=value end
local function node(class,name,host,props)
 local result=Instance.new(class);result.Name=name
 for key,value in pairs(props or{})do result[key]=value end
 result.Parent=host;return result
end
local hud=node('ScreenGui','GameHUD',playerGui)
local hudText=node('TextLabel','Coins',hud,{Text='100 coins',TextColor3=Color3.fromRGB(255,0,0)})
local unrelatedColor=hudText.TextColor3
local gui=node('ScreenGui','DevilHubTest',core)
local root=node('Frame','MainWindow',gui,{AbsoluteSize=Vector2.new(880,520),BackgroundColor3=Color3.fromRGB(20,16,20)})
local originalColor=root.BackgroundColor3
local originalSize=root.Size
local heading=node('TextLabel','Title',root,{Text='DEVIL HUB',TextColor3=Color3.fromRGB(180,0,180)})
local gradient=node('UIGradient','TitleGradient',heading,{Color=ColorSequence.new(Color3.fromRGB(255,0,255),Color3.fromRGB(0,255,0))})
local button=node('TextButton','TabAutoFarm',root,{Text='Auto Farm',TextColor3=Color3.fromRGB(180,0,180)})
local clicks=0
local callback=button.Activated:Connect(function()clicks+=1 end)
local toggle=node('Frame','Switch',root,{BackgroundColor3=Color3.fromRGB(20,20,20)})
local text=node('TextLabel','EggValue',root,{Text='150/s'})
local url=node('TextBox','WebhookURL',root,{Text='https://example.test/keep-me',PlaceholderText='Search...'})
local rich=node('TextLabel','Rich',root,{Text='<font color="#ff00ff">Ready</font>',RichText=true})
local pet=node('ImageLabel','PetImage',root,{Image='rbxassetid://123',ImageColor3=Color3.fromRGB(150,100,50)})
local logo=node('ImageLabel','Logo',root,{Image='devil-logo.png',ImageColor3=Color3.fromRGB(200,0,0)})
local inventory=node('Frame','Inventory',root)
local itemIcon=node('ImageLabel','Icon',inventory,{Image='pet-id',ImageColor3=Color3.fromRGB(200,50,90)})
local itemColor=itemIcon.ImageColor3
local petColor=pet.ImageColor3
local controller=(function()
-- MODULE INSERTED HERE
end)()
flush()
check(hudText.TextColor3==unrelatedColor,'game HUD recolored')
check(root.BackgroundColor3==Color3.fromRGB(7,27,52),'background not dark blue')
check(button.TextColor3==Color3.fromRGB(117,206,255),'tab text not light blue')
check(heading.TextColor3==Color3.fromRGB(247,252,255),'title not white')
check(gradient.Color.Keypoints[2].Value==Color3.fromRGB(117,206,255),'title gradient not white/blue')
check(logo.ImageColor3==Color3.fromRGB(247,252,255),'logo not white')
check(pet.Image== 'rbxassetid://123'and pet.ImageColor3==petColor,'pet image altered')
check(itemIcon.ImageColor3==itemColor,'generic inventory icon tinted')
check(text.Text=='150/s'and url.Text=='https://example.test/keep-me','live value or URL altered')
check(rich.Text=='<font color="#75CEFF">Ready</font>','rich text colors not themed')
check(root.Size==originalSize,'window geometry overwritten')
button.Activated:Fire();check(clicks==1 and callback.Connected,'game callback altered')
local off=toggle.BackgroundColor3
toggle.BackgroundColor3=Color3.fromRGB(0,255,0)
check(toggle.BackgroundColor3~=off and toggle.BackgroundColor3==Color3.fromRGB(117,206,255),'on/off colors collapsed')
button.TextColor3=Color3.fromRGB(255,0,255)
check(button.TextColor3==Color3.fromRGB(117,206,255),'native redraw restored old theme')
controller.Set({Accent='#00AAFF',Scale=120})
check(button.TextColor3==Color3.fromRGB(0,170,255),'custom accent not applied')
check(root:FindFirstChildOfClass('UIScale').Scale==1.2,'size setting not applied')
check(files['DevilHub-BlueGUI.json']~=nil,'preferences not saved')
local late=node('TextLabel','NewOption',root,{Text='Auto hatch',TextColor3=Color3.fromRGB(255,0,255)})
flush();check(late.TextColor3==Color3.fromRGB(0,170,255),'new controls not themed')
local dynamic=node('ScreenGui','GeneratedWindow',core)
local dynamicRoot=node('Frame','Window',dynamic,{AbsoluteSize=Vector2.new(700,450)})
local existingScale=node('UIScale','NativeResponsiveScale',dynamicRoot,{Scale=.9})
local dynamicTitle=node('TextLabel','Title',dynamicRoot)
dynamicTitle.Text='DEVIL HUB'
flush();check(dynamicRoot.BackgroundColor3==root.BackgroundColor3,'late title ownership not discovered')
check(math.abs(existingScale.Scale-1.08)<1e-8,'native responsive scale not composed')
existingScale.Scale=.8
check(math.abs(existingScale.Scale-.96)<1e-8,'native resize replaced user scale')
local settingsGui=core:FindFirstChild('DevilBlueAppearance')
settingsGui:FindFirstChild('AppearanceButton').Activated:Fire()
local panel=settingsGui:FindFirstChild('AppearancePanel')
check(panel.Visible,'appearance button did not open controls')
local accentBox,backgroundBox,apply
for _,item in ipairs(panel:GetChildren())do
 if item:IsA('TextBox')then if item.Name=="AccentInput"then accentBox=item else backgroundBox=item end end
 if item:IsA('TextButton')and item.Text=='Apply'then apply=item end
end
accentBox.Text='invalid';apply.Activated:Fire()
check(controller.Get().Accent=='#00AAFF','invalid color changed theme')
accentBox.Text='#00AAFF';backgroundBox.Text='#051122';apply.Activated:Fire()
check(root.BackgroundColor3==Color3.fromRGB(5,17,34),'appearance form did not apply background')
controller.Set({Scale=999});check(controller.Get().Scale==140,'size not clamped')
controller.Set({Scale=120})
local selector=panel:FindFirstChild('LanguageSelect')
local languageOptions=panel:FindFirstChild('LanguageOptions')
selector.Activated:Fire();check(languageOptions.Visible,'language select menu did not open')
languageOptions:FindFirstChild('LanguageTH').Activated:Fire();flush()
check(controller.Get().Language=='TH'and not languageOptions.Visible,'Thai menu selection not applied')
local translated=button:FindFirstChild('DevilTranslatedLabel')
check(translated and translated.Text=='ฟาร์มอัตโนมัติ','Thai feature label not rendered')
check(button.Text=='Auto Farm'and button.TextTransparency==1,'engine button text was rewritten')
check(translated.TextColor3==button.TextColor3,'translated text lost blue theme')
check(url.Text=='https://example.test/keep-me'and url.PlaceholderText=='ค้นหา...','translation altered user input or missed placeholder')
button.Text='Auto Farm Monsters';flush()
check(translated.Text=='ฟาร์มมอนสเตอร์อัตโนมัติ','native label update lost translation')
button.Text='Auto Farm'
local thaiOriginal=node('TextLabel','NativeThai',root,{Text='ตั้งค่า'})
local localizedLate=node('TextLabel','LateSettings',root,{Text='Settings'})
flush();check(localizedLate:FindFirstChild('DevilTranslatedLabel').Text=='ตั้งค่า','late UI did not use selected language')
languageOptions:FindFirstChild('LanguageEN').Activated:Fire();flush()
check(controller.Get().Language=='EN'and button:FindFirstChild('DevilTranslatedLabel')==nil and button.TextTransparency==0,'English did not restore native text rendering')
check(thaiOriginal.Text=='ตั้งค่า'and thaiOriginal:FindFirstChild('DevilTranslatedLabel').Text=='Settings','existing Thai label not rendered in English safely')
check(url.PlaceholderText=='Search...'and url.Text=='https://example.test/keep-me','English reset altered input')
controller.SetLanguage('TH')
local same=(function()
-- MODULE INSERTED HERE
end)()
check(same==controller,'duplicate controller created')
controller.Destroy();flush()
check(root.BackgroundColor3==originalColor,'original colors not restored')
check(root:FindFirstChildOfClass('UIScale')==nil,'injected scale leaked')
check(callback.Connected,'callback disconnected on theme removal')
check(button:FindFirstChild('DevilTranslatedLabel')==nil and button.Text=='Auto Farm'and button.TextTransparency==0,'translation overlay or hidden original leaked')
check(existingScale.Scale==.8,'native scale not restored')
check(core:FindFirstChild('DevilBlueAppearance')==nil,'settings GUI leaked')
check(hudText.TextColor3==unrelatedColor,'HUD affected by cleanup')
local reloaded=(function()
-- MODULE INSERTED HERE
end)()
flush()
check(reloaded.Get().Accent=='#00AAFF'and reloaded.Get().Scale==120,'saved theme not reloaded')
check(reloaded.Get().Language=='TH','language preference not reloaded')
reloaded.Destroy();files['DevilHub-BlueGUI.json']='corrupt'
local clean=(function()
-- MODULE INSERTED HERE
end)()
flush();check(clean.Get().Accent=='#75CEFF','corrupt preference file not ignored')
clean.Destroy();flush()
print('PASS blue GUI: '..checks..' checks; ownership, theme, redraw, new controls, images, callbacks, settings, scaling, cleanup')
