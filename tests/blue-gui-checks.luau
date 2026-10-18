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
local launcherGui=node('ScreenGui','RandomLauncher',core)
local launch=node('ImageButton','OpenGui',launcherGui,{Image='devil-logo.png',BackgroundTransparency=1,BackgroundColor3=Color3.fromRGB(255,0,0),ImageColor3=Color3.fromRGB(0,255,0)})
local opens=0;local originalOpen=launch.Activated:Connect(function()opens+=1 end)
local gameLogo=node('ImageLabel','Logo',hud,{Image='rbxassetid://coin',ImageColor3=Color3.fromRGB(200,100,0)})
local gameLogoColor=gameLogo.ImageColor3
files['DevilHub-BlueGUI.json']=http:JSONEncode({Accent='#ff0000',Background='#0000ff',Scale=140,Language='EN'})
local controller=(function()
-- MODULE INSERTED HERE
end)()
flush()
check(root.BackgroundColor3==Color3.fromRGB(7,9,13),'main background not black')
check(root.BackgroundTransparency==.14,'main background not slightly transparent')
check(button.TextColor3==Color3.fromRGB(164,221,255),'mode text not soft light blue')
check(heading.TextColor3==Color3.fromRGB(255,255,255),'title not white')
check(gradient.Color.Keypoints[2].Value==Color3.fromRGB(164,221,255),'title not white/blue gradient')
check(logo.ImageColor3==Color3.fromRGB(255,255,255),'logo not white')
check(launch.BackgroundColor3==Color3.fromRGB(7,9,13)and launch.BackgroundTransparency==0,'open/minimize icon background not solid black')
check(launch.ImageColor3==Color3.fromRGB(255,255,255),'open icon logo not white')
launch.Activated:Fire();check(opens==1 and originalOpen.Connected,'open icon callback altered')
check(hudText.TextColor3==unrelatedColor and gameLogo.ImageColor3==gameLogoColor,'game HUD or unrelated logo affected')
check(pet.ImageColor3==petColor and itemIcon.ImageColor3==itemColor,'pet/item icons tinted')
check(text.Text=='150/s'and url.Text=='https://example.test/keep-me','engine values altered')
check(root.Size==originalSize and controller.Get().Scale==100,'native GUI size changed by old preference')
button.Activated:Fire();check(clicks==1 and callback.Connected,'game callback altered')
check(core:FindFirstChild('DevilBlueAppearance')==nil,'floating color GUI still exists')
local selector=root:FindFirstChild('DevilLanguageSelector')
check(selector and selector.Parent==root,'language control not inside original window')
check(selector:FindFirstChild('AccentInput')==nil,'color controls still exist')
local menu=selector:FindFirstChild('LanguageOptions')
selector:FindFirstChild('LanguageSelect').Activated:Fire();check(menu.Visible,'language menu not opened')
menu:FindFirstChild('LanguageTH').Activated:Fire();flush()
check(controller.Get().Language=='TH'and not menu.Visible,'Thai selection failed')
local translated=button:FindFirstChild('DevilTranslatedLabel')
check(translated and translated.Text==controller.Translate('Auto Farm')and translated.Text~='Auto Farm','Thai label not rendered')
check(button.Text=='Auto Farm'and button.TextTransparency==1,'backend label rewritten')
check(url.Text=='https://example.test/keep-me'and url.PlaceholderText~='Search...','input altered or placeholder missed')
button.Text='Auto Farm Monsters';flush()
check(translated.Text==controller.Translate('Auto Farm Monsters'),'updated feature label not translated')
button.Text='Auto Farm'
local late=node('TextLabel','LateSettings',root,{Text='Settings'});flush()
check(late:FindFirstChild('DevilTranslatedLabel')~=nil,'new controls not translated')
menu:FindFirstChild('LanguageEN').Activated:Fire();flush()
check(button:FindFirstChild('DevilTranslatedLabel')==nil and button.TextTransparency==0,'English did not restore original rendering')
button.TextColor3=Color3.fromRGB(255,0,255)
check(button.TextColor3==Color3.fromRGB(164,221,255),'native redraw restored old color')
local off=toggle.BackgroundColor3;toggle.BackgroundColor3=Color3.fromRGB(0,255,0)
check(toggle.BackgroundColor3~=off,'toggle on/off appearance collapsed')
local saved=http:JSONDecode(files['DevilHub-BlueGUI.json'])
check(saved.Language=='EN'and saved.Accent==nil and saved.Scale==nil,'removed preferences still saved')
controller.SetLanguage('TH')
local same=(function()
-- MODULE INSERTED HERE
end)()
check(same==controller,'duplicate theme controller')
controller.Destroy();flush()
check(root:FindFirstChild('DevilLanguageSelector')==nil,'language selector leaked on unload')
check(root.BackgroundColor3==originalColor and root.BackgroundTransparency==0,'original background not restored')
check(root:FindFirstChildOfClass('UIScale')==nil,'theme scale leaked')
check(button.Text=='Auto Farm'and button.TextTransparency==0,'translation leaked on unload')
check(callback.Connected and originalOpen.Connected,'callbacks disconnected on unload')
local reloaded=(function()
-- MODULE INSERTED HERE
end)()
flush();check(reloaded.Get().Language=='TH','language preference lost')
reloaded.Destroy();flush()
print('PASS fixed glass-black GUI and inline language: '..checks..' checks')
