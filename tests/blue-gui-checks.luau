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
local compositeLaunch=node('TextButton','TextButton',gui,{Size=UDim2.fromOffset(50,50),BackgroundColor3=Color3.fromRGB(255,0,0)})
local compositeLogo=node('ImageLabel','ImageLabel',compositeLaunch,{Image='',ImageColor3=Color3.fromRGB(255,0,0)})
local sidebarGui=node('ScreenGui','DevilHubSidebarTest',core)
sidebarGui:SetAttribute('DevilBreakFrontend',true)
local sidebarRoot=node('Frame','Window',sidebarGui,{AbsoluteSize=Vector2.new(880,520),Size=UDim2.fromOffset(880,520)})
local body=node('Frame','Body',sidebarRoot)
local sidebar=node('Frame','Sidebar',body,{Position=UDim2.fromOffset(8,8),Size=UDim2.new(0,170,1,-16)})
local header=node('Frame','Header',sidebar,{Size=UDim2.new(1,0,0,72)})
local tabs=node('ScrollingFrame','Tabs',sidebar,{Position=UDim2.fromOffset(0,72),Size=UDim2.new(1,0,1,-136)})
local profile=node('Frame','Profile',sidebar,{Position=UDim2.new(0,0,1,-64),Size=UDim2.new(1,0,0,64)})
local nativeTabPosition,nativeTabSize=tabs.Position,tabs.Size
local profilePosition,headerSize=profile.Position,header.Size
local action=node('TextButton','TextButton',body,{Size=UDim2.new(1,-20,0,56)})
local track=node('Frame','Frame',action,{Size=UDim2.fromOffset(36,20),BackgroundColor3=Color3.fromRGB(42,36,43)})
local thumb=node('Frame','Frame',track,{Size=UDim2.fromOffset(14,14),AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,3,.5,0)})
node('UICorner','UICorner',thumb,{CornerRadius=UDim.new(1,0)})
local anonymousIcon=node('ImageLabel','ImageLabel',action,{Size=UDim2.fromOffset(16,16),Image='rbxassetid://glyph',ImageColor3=Color3.fromRGB(255,0,0)})
local iconGradient=node('UIGradient','UIGradient',anonymousIcon,{Color=ColorSequence.new(Color3.fromRGB(255,0,0))})
local iconBackground=node('ImageLabel','ActionIcon',body,{Size=UDim2.fromOffset(16,16),Image='rbxassetid://glyph2',BackgroundColor3=Color3.fromRGB(240,0,0),ImageColor3=Color3.fromRGB(240,0,0)})
local minimize=node('Frame','Frame',action,{Size=UDim2.fromOffset(12,2),BackgroundColor3=Color3.fromRGB(240,0,0)})
local nativeIconColor=anonymousIcon.ImageColor3
local searchHost=node('Frame','Frame',body,{Size=UDim2.fromOffset(220,34),BackgroundColor3=Color3.fromRGB(40,15,20)})
local searchGradient=node('UIGradient','UIGradient',searchHost,{Color=ColorSequence.new(Color3.fromRGB(20,20,20))})
local search=node('TextBox','TextBox',searchHost,{BackgroundTransparency=1,Text='',PlaceholderText='Search',TextColor3=Color3.fromRGB(20,20,20),PlaceholderColor3=Color3.fromRGB(30,30,30)})
local quantizedHost=node('Frame','Input',body,{Size=UDim2.fromOffset(180,34),MockQuantize=true})
node('TextBox','TextBox',quantizedHost,{BackgroundTransparency=1,PlaceholderText='Search'})
local nativeScale=node('UIScale','NativeScale',sidebarRoot,{Scale=.83})
local scaleWrites=0;nativeScale:GetPropertyChangedSignal('Scale'):Connect(function()scaleWrites+=1 end)
local focusCalls=0;search.Focused:Connect(function()focusCalls+=1;searchHost.BackgroundColor3=Color3.fromRGB(255,0,0)end)
local legacyLanguage=node('TextButton','DevilLanguageButton',body,{Text='Thai / EN',BackgroundColor3=Color3.fromRGB(45,23,30)})
local legacyChanges=0
local legacyCallback=legacyLanguage.Activated:Connect(function()legacyChanges+=1 end)
local padding=node('UIPadding','UIPadding',button,{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,16),PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)})
local buttonGradient=node('UIGradient','NativeButtonGradient',button,{Color=ColorSequence.new(Color3.fromRGB(255,0,0))})
local dropdown=node('TextButton','DropdownToggle',body,{Size=UDim2.fromOffset(320,40),BackgroundColor3=Color3.fromRGB(190,220,255),BackgroundTransparency=.6})
local dropdownPlate=node('Frame','ToggleSurface',dropdown,{BackgroundColor3=Color3.fromRGB(150,200,255),BackgroundTransparency=.3})
local chosen=node('TextLabel','Value',dropdown,{Text='Pumpkin Golem (+65 Candy)',BackgroundTransparency=1,TextTransparency=.32})
local chosenStroke=node('UIStroke','TextOutline',chosen,{ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual,Color=Color3.fromRGB(200,0,0)})
local caret=node('Frame','Caret',dropdown,{BackgroundTransparency=1})
local caretArm=node('Frame','Arm',caret,{Size=UDim2.fromScale(.66,.2),BackgroundColor3=Color3.fromRGB(255,255,255)})
local popup=node('Frame','DropdownMenu',body,{BackgroundColor3=Color3.fromRGB(170,200,255),BackgroundTransparency=.35})
local option=node('TextButton','Option1',popup,{Text='Closest',BackgroundColor3=Color3.fromRGB(170,220,255),BackgroundTransparency=.88})
local bitmap=node('ImageLabel','Surface',dropdown,{Image='rounded-rectangle',ImageColor3=Color3.fromRGB(180,210,255)})
local growingBitmap=node('ImageLabel','ImageLabel',dropdown,{Size=UDim2.fromOffset(16,16),Image='rounded-rectangle',ImageColor3=Color3.fromRGB(255,255,255)})
local dropdownClicks=0;local dropdownAction=dropdown.Activated:Connect(function()dropdownClicks+=1 end)
-- Break's bridge reparents Obsidian AddDialog's ZIndex=9000 overlay to ui.Gui.
local dialog=node('TextButton','TextButton',sidebarGui,{Size=UDim2.fromScale(1,1),AbsoluteSize=Vector2.new(1920,1080),
 BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=.5,Text='',ZIndex=9000})
local dialogPanel=node('Frame','DialogPanel',dialog,{Size=UDim2.fromOffset(300,180),BackgroundColor3=Color3.fromRGB(200,0,0)})
local hitPlane=node('TextButton','InputCatcher',sidebarGui,{Size=UDim2.fromScale(1,1),BackgroundTransparency=.95})
local backdrop=node('Frame','Backdrop',sidebarGui,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false})
local tint=node('Frame','Frame',backdrop,{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=.55})
local tintColor=ColorSequence.new(Color3.fromRGB(200,0,0),Color3.fromRGB(0,200,0))
local tintGradient=node('UIGradient','UIGradient',tint,{Color=tintColor})
local otherDialog=node('TextButton','TextButton',gui,{Size=UDim2.fromScale(1,1),BackgroundTransparency=.5,ZIndex=9000})
local nativeChip=node('Frame','Frame',dropdown,{Size=UDim2.fromOffset(60,30),BackgroundColor3=Color3.fromRGB(25,20,25)})
local nativeChevron=node('Frame','Frame',nativeChip,{Size=UDim2.fromOffset(18,18),AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-6,.5,0),BackgroundTransparency=1})
node('ImageLabel','ImageLabel',nativeChevron,{Size=UDim2.fromOffset(16,16),Image='chevron-down',BackgroundTransparency=1})
files['DevilHub-BlueGUI.json']=http:JSONEncode({Accent='#ff0000',Background='#0000ff',Scale=140,Language='EN'})
local controller=(function()
-- MODULE INSERTED HERE
end)()
flush()
check(root.BackgroundColor3==Color3.fromRGB(7,9,13),'main background not black')
check(root.BackgroundTransparency==.14,'main background not slightly transparent')
check(dialog.BackgroundTransparency==.5 and dialog.BackgroundColor3==Color3.fromRGB(0,0,0),'native dialog dimmer painted as an opaque menu card')
check(hitPlane.BackgroundTransparency==.95,'fullscreen hit plane became an opaque black layer')
check(tint.BackgroundTransparency==.55 and tintGradient.Color==tintColor and not backdrop.Visible,'native backdrop/fade settings were overwritten')
check(dialogPanel.BackgroundColor3==Color3.fromRGB(16,19,25),'dialog content panel lost its dark menu styling')
check(dialog:FindFirstChild('DevilLanguageSelector')==nil and not backdrop:FindFirstChild('DevilLanguageSelector'),'fullscreen layer adopted as main GUI')
check(button.TextColor3==Color3.fromRGB(164,221,255),'mode text not soft light blue')
check(heading.TextColor3==Color3.fromRGB(255,255,255),'title not white')
check(searchHost.BackgroundColor3==Color3.fromRGB(24,27,33)and searchHost.BackgroundTransparency==.14,'anonymous search wrapper not soft black')
check(search.BackgroundTransparency==1 and search.BackgroundColor3==Color3.fromRGB(24,27,33),'transparent search lost native wrapper geometry')
check(search.TextColor3==Color3.fromRGB(255,255,255)and search.PlaceholderColor3==Color3.fromRGB(172,184,201),'search text or hint unreadable')
check(searchGradient.Color.Keypoints[1].Value==Color3.fromRGB(255,255,255),'input gradient darkens text or background')
search.Text='rare egg';search.Focused:Fire()
check(search.Text=='rare egg'and focusCalls==1 and searchHost.BackgroundColor3==Color3.fromRGB(24,27,33),'focus restyle changes filtering or reintroduces old color')
check(url.BackgroundColor3==Color3.fromRGB(24,27,33)and url.BackgroundTransparency==.14,'direct text input not soft black')
quantizedHost.BackgroundTransparency=.25
check(math.abs(quantizedHost.BackgroundTransparency-.14)<1e-6,'rounded numeric properties cause theme write feedback')
check(root:FindFirstChildOfClass('UIScale')==nil and nativeScale.Scale==.83 and scaleWrites==0,'theme changes native animation scale')
local headingText=heading:FindFirstChild('DevilTranslatedLabel')
local headingTone=headingText and headingText:FindFirstChild('DevilTextTone')
check(headingTone and headingTone.Color.Keypoints[1].Value==Color3.fromRGB(104,177,255)and headingTone.Color.Keypoints[2].Value==Color3.fromRGB(255,255,255),'title lacks blue/white text gradient')
for _,surface in ipairs({dropdown,dropdownPlate,popup,option})do
 local color=surface.BackgroundColor3
 check(math.max(color.R,color.G,color.B)<.11 and surface.BackgroundTransparency==.14,'dropdown/menu surface still has a pale blue fill')
end
check(bitmap.ImageColor3==Color3.fromRGB(7,9,13),'bitmap menu background still tinted pale blue')
growingBitmap.Size=UDim2.fromScale(1,1)
check(growingBitmap.ImageColor3==Color3.fromRGB(7,9,13),'late-sized bitmap menu background missed')
local chosenText=chosen:FindFirstChild('DevilTranslatedLabel')
check(chosenText and chosenText.TextTransparency<.11 and chosenText.TextStrokeTransparency==1,'selected value remains faded or outlined')
local function luminance(color)
 local function linear(value)return value<=.04045 and value/12.92 or((value+.055)/1.055)^2.4 end
 return .2126*linear(color.R)+.7152*linear(color.G)+.0722*linear(color.B)
end
local textBlue=chosenText:FindFirstChild('DevilTextTone').Color.Keypoints[1].Value
local plate=dropdown.BackgroundColor3
check((luminance(textBlue)+.05)/(luminance(plate)+.05)>8,'blue end of menu text gradient lacks contrast')
local faded=textBlue:Lerp(plate,chosenText.TextTransparency)
check((luminance(faded)+.05)/(luminance(plate)+.05)>6.5,'selected value remains low contrast after its native dimming')
check(chosen.Text=='Pumpkin Golem (+65 Candy)'and chosenStroke.Color==Color3.fromRGB(7,9,13),'selection value changed or text outline still colored')
check(caretArm.BackgroundColor3==Color3.fromRGB(164,221,255),'dropdown caret disappeared on black background')
dropdown.BackgroundColor3=Color3.fromRGB(150,210,255);dropdown.BackgroundTransparency=.4
check(dropdown.BackgroundColor3==Color3.fromRGB(16,19,25)and dropdown.BackgroundTransparency==.14,'dropdown redraw restores pale blue fill')
dropdown.Activated:Fire();check(dropdownClicks==1 and dropdownAction.Connected,'dropdown callback changed')
check(nativeChip.BackgroundColor3==Color3.fromRGB(7,9,13),'native dropdown chevron mistaken for a switch thumb')
nativeChip.Size=UDim2.fromOffset(320,30);nativeChip.BackgroundColor3=Color3.fromRGB(25,20,25)
check(nativeChip.BackgroundColor3==Color3.fromRGB(7,9,13),'grown dropdown retains switch fill from its initial narrow size')
local englishText=button:FindFirstChild('DevilTranslatedLabel')
check(englishText and englishText.Text=='Auto Farm'and englishText.TextColor3==Color3.fromRGB(255,255,255),'English menu text lacks neutral base for two-tone')
check(englishText.BackgroundTransparency==1 and englishText.BorderSizePixel==0,'text effect adds a rectangular background')
check(buttonGradient.Color.Keypoints[1].Value==Color3.fromRGB(7,9,13)and buttonGradient.Color.Keypoints[2].Value~=Color3.fromRGB(255,255,255),'text gradient turned button background into a bright block')
check(englishText:FindFirstChildOfClass('UIPadding').PaddingLeft.Offset==12,'text effect lost native alignment')
padding.PaddingLeft=UDim.new(0,18)
check(englishText:FindFirstChildOfClass('UIPadding').PaddingLeft.Offset==18,'native padding updates not mirrored')
check(not legacyLanguage.Visible and legacyChanges==0 and legacyCallback.Connected,'duplicate language button remains or its callback was triggered')
legacyLanguage.Visible=true
check(not legacyLanguage.Visible,'legacy language button reappeared on redraw')
local lateLegacy=node('TextButton','DevilLanguageButton',body,{Text='Thai / EN'})
flush();check(not lateLegacy.Visible,'late native language button was not deduplicated')
check(logo.ImageColor3==Color3.fromRGB(255,255,255),'logo not white')
check(launch.BackgroundColor3==Color3.fromRGB(0,0,0)and launch.BackgroundTransparency==0,'open/minimize icon background not solid black')
check(launch.ImageColor3==Color3.fromRGB(255,255,255),'open icon logo not white')
compositeLogo.Image='devil-logo.png';flush()
check(compositeLaunch.BackgroundColor3==Color3.fromRGB(0,0,0)and compositeLaunch.BackgroundTransparency==0 and compositeLogo.ImageColor3==Color3.fromRGB(255,255,255),'native composite launcher not black/white')
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
check(selector:FindFirstChild('LanguageSelect').BackgroundTransparency==1,'language button leaves a solid rectangular block')
check(selector:FindFirstChild('LanguageSelect').Text==''and selector:FindFirstChild('LanguageSelect'):FindFirstChild('LanguageChevron1')~=nil,'Unicode dropdown glyph not replaced by geometry')
local docked=sidebar:FindFirstChild('DevilLanguageSelector')
check(docked and docked.Position.Y.Offset==74,'language row not integrated below sidebar header')
check(tabs.Position.Y.Offset==112 and tabs.Size.Y.Offset==-176,'navigation space not reserved for language row')
check(tabs.Position.Y.Offset+tabs.Size.Y.Offset==nativeTabPosition.Y.Offset+nativeTabSize.Y.Offset,'navigation footer moved')
check(profile.Position==profilePosition and header.Size==headerSize,'profile or brand header geometry changed')
check(docked.Position.Y.Offset+docked.Size.Y.Offset<tabs.Position.Y.Offset,'language button overlaps tabs')
check(anonymousIcon.ImageColor3==Color3.fromRGB(164,221,255),'unnamed red control icon missed')
check(iconGradient.Color.Keypoints[1].Value==Color3.fromRGB(255,255,255)and iconGradient.Color.Keypoints[2].Value==Color3.fromRGB(164,221,255),'red icon gradient missed')
check(iconBackground.BackgroundColor3~=Color3.fromRGB(240,0,0)and iconBackground.ImageColor3==Color3.fromRGB(164,221,255),'red image background missed')
check(minimize.BackgroundColor3==Color3.fromRGB(164,221,255),'frame-based minimize glyph invisible')
check(track.BackgroundColor3==Color3.fromRGB(32,39,49),'unnamed disabled toggle not neutral')
thumb.Position=UDim2.new(0,19,.5,0)
check(track.BackgroundColor3==Color3.fromRGB(164,221,255)and thumb.BackgroundColor3==Color3.fromRGB(255,255,255),'unnamed enabled toggle not blue/white')
track.BackgroundColor3=Color3.fromRGB(255,0,0);thumb.BackgroundColor3=Color3.fromRGB(30,0,0)
check(track.BackgroundColor3==Color3.fromRGB(164,221,255)and thumb.BackgroundColor3==Color3.fromRGB(255,255,255),'native toggle redraw restored red')
thumb.Position=UDim2.new(0,3,.5,0)
check(track.BackgroundColor3==Color3.fromRGB(32,39,49),'toggle off retained blue')
tabs.Position=UDim2.fromOffset(0,80);tabs.Size=UDim2.new(1,0,1,-144)
sidebarRoot.AbsoluteSize=Vector2.new(500,360);flush()
check(tabs.Position.Y.Offset==120 and tabs.Size.Y.Offset==-184 and docked.Position.Y.Offset==82,'native resize not respected')
sidebarRoot.AbsoluteSize=Vector2.new(880,520);flush()
check(tabs.Position.Y.Offset==120,'resize accumulated language padding')
local menu=selector:FindFirstChild('LanguageOptions')
selector:FindFirstChild('LanguageSelect').Activated:Fire();check(menu.Visible,'language menu not opened')
menu:FindFirstChild('LanguageTH').Activated:Fire();flush()
check(controller.Get().Language=='TH'and not menu.Visible,'Thai selection failed')
check(menu:FindFirstChild('LanguageTH').BackgroundTransparency==0 and menu:FindFirstChild('LanguageEN').BackgroundTransparency==1,'selected language not highlighted')
local dockMenu=docked:FindFirstChild('LanguageOptions')
docked:FindFirstChild('LanguageSelect').Activated:Fire();sidebarRoot.Visible=false
check(not dockMenu.Visible,'language menu remains open after minimize')
sidebarRoot.Visible=true
check(dialog.Visible,'open native dialog did not return with the main window')
local lateDialog=node('TextButton','TextButton',sidebarGui,{Size=UDim2.fromOffset(100,100),ZIndex=1,BackgroundTransparency=.5})
lateDialog.Size=UDim2.fromScale(1,1);lateDialog.ZIndex=9000
sidebarRoot.Visible=false
check(not dialog.Visible and not lateDialog.Visible,'Break dialog overlay remains visible while main GUI is minimized')
lateDialog:Destroy();sidebarRoot.Visible=true
check(dialog.Visible and lateDialog.destroyed,'closed native dialog came back after restore')
local layers=controller.InspectLayers()
local foundDialog=false
for _,layer in ipairs(layers)do if layer.BreakDialog then foundDialog=true;check(layer.SourceTransparency==.5,'layer report lost native dimmer transparency')end end
check(foundDialog,'layer diagnostics missed the Break dialog overlay')
root.Visible=false
check(otherDialog.Visible and otherDialog.BackgroundTransparency==.5,'Break dialog visibility policy changed another frontend')
root.Visible=true
dialog.Visible=false;sidebarRoot.Visible=false;sidebarRoot.Visible=true
check(not dialog.Visible,'restoring GUI reopened a dialog closed by its native controller')
dialog.Visible=true
anonymousIcon.ImageColor3=Color3.fromRGB(255,0,0)
check(anonymousIcon.ImageColor3==Color3.fromRGB(164,221,255),'icon hover/redraw restored red')
local mobileTrack=node('Frame','Frame',action,{Size=UDim2.fromOffset(44,24)})
local mobileThumb=node('Frame','Frame',mobileTrack,{Size=UDim2.fromOffset(18,18),AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,23,.5,0)})
node('UICorner','UICorner',mobileThumb,{CornerRadius=UDim.new(1,0)})
flush();check(mobileTrack.BackgroundColor3==Color3.fromRGB(164,221,255),'late mobile toggle not recognized')
mobileThumb.Position=UDim2.new(0,3,.5,0)
check(mobileTrack.BackgroundColor3==Color3.fromRGB(32,39,49),'mobile off color incorrect')
local dynamicThumbnail=node('ImageLabel','ImageLabel',action,{Image='',ImageColor3=Color3.fromRGB(255,255,255)})
dynamicThumbnail.Image='rbxthumb://type=Asset&id=123&w=150&h=150';flush()
check(dynamicThumbnail.ImageColor3==Color3.fromRGB(255,255,255),'late thumbnail image tinted')
local lateIcon=node('ImageButton','OpenIcon',root,{Image='old-brand',BackgroundTransparency=1,BackgroundColor3=Color3.fromRGB(255,0,0),ImageColor3=Color3.fromRGB(255,0,0)})
lateIcon.Image='devil-logo.png';flush()
check(lateIcon.BackgroundColor3==Color3.fromRGB(0,0,0)and lateIcon.BackgroundTransparency==0,'late launcher logo did not update its black background')
check(lateIcon.ImageColor3==Color3.fromRGB(255,255,255),'late launcher logo not white')
local translated=button:FindFirstChild('DevilTranslatedLabel')
check(translated and translated.Text==controller.Translate('Auto Farm')and translated.Text~='Auto Farm','Thai label not rendered')
check(button.Text=='Auto Farm'and button.TextTransparency==1,'backend label rewritten')
check(url.Text=='https://example.test/keep-me'and url.PlaceholderText~='Search...','input altered or placeholder missed')
button.Text='Auto Farm Monsters';flush()
check(translated.Text==controller.Translate('Auto Farm Monsters'),'updated feature label not translated')
button.Text='Auto Farm'
local late=node('TextLabel','LateSettings',root,{Text='Settings'});flush()
check(late:FindFirstChild('DevilTranslatedLabel')~=nil,'new controls not translated')
local latePadding=node('UIPadding','UIPadding',late,{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,0),PaddingBottom=UDim.new(0,0)})
check(late:FindFirstChild('DevilTranslatedLabel'):FindFirstChildOfClass('UIPadding').PaddingLeft.Offset==10,'late native padding not preserved')
local layoutText=node('TextButton','LayoutText',root,{Text='Settings'})
node('UIListLayout','UIListLayout',layoutText)
check(layoutText:FindFirstChild('DevilTranslatedLabel')==nil and layoutText.TextTransparency==0,'text effect inserted a rectangular item into a native layout')
menu:FindFirstChild('LanguageEN').Activated:Fire();flush()
check(button:FindFirstChild('DevilTranslatedLabel').Text=='Auto Farm'and button.Text=='Auto Farm','English menu lost original text')
check(button:FindFirstChild('DevilTranslatedLabel'):FindFirstChild('DevilTextTone')~=nil,'English selection removed two-tone text')
check(not rich:FindFirstChild('DevilTranslatedLabel').Text:find('color=',1,true),'inline font color overrides blue/white text')
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
-- Exercise the library's actual transition functions with the shared theme active.
local z={Background=Color3.fromRGB(20,16,20),Stroke=Color3.fromRGB(80,30,30)}
local function ai(class,props)
 local parent=props.Parent;local options=table.clone(props);options.Parent=nil
 if options.Size then options.AbsoluteSize=Vector2.new(options.Size.X.Offset,options.Size.Y.Offset)end
 return node(class,props.Name or class,parent,options)
end
local function aj(parent,radius)return node('UICorner','UICorner',parent,{CornerRadius=radius})end
local function ak(parent,color,alpha)return node('UIStroke','UIStroke',parent,{Color=color,Transparency=alpha or 0})end
local function ah(target,props)
 for key,value in pairs(props)do target[key]=value end
 if props.Size then target.AbsoluteSize=Vector2.new(props.Size.X.Offset,props.Size.Y.Offset)end
end
local nativeTransitions=(function()
-- NATIVE TRANSITIONS INSERTED HERE
end)()
local savedDelay,savedSpawn=task.delay,task.spawn
local now,timers=0,{}
task.delay=function(seconds,fn)table.insert(timers,{At=now+seconds,Run=fn})end
task.spawn=function()end -- The library's separate half-second status loop is not an animation callback.
local function advance(seconds)
 now+=seconds
 for _=1,40 do
  local index
  for i,timer in ipairs(timers)do if timer.At<=now then index=i;break end end
  if not index then flush();return end
  table.remove(timers,index).Run();flush()
 end
 error('transition callbacks did not settle')
end
local app={Gui=sidebarGui,Root=sidebarRoot,Scale=nativeScale,_fitScale=.83,_introDone=true,Open=true,
 Shadow=node('ImageLabel','Shadow',sidebarRoot,{ImageTransparency=.4}),BodyStroke={Transparency=0},_shadowRest=.4}
function app:_closePopups()end
function app:_refreshToggleButton()end
function app:_refreshBackdrop()end
function app:_refreshMini()end
function app:_buildMiniBar()
 if not self.MiniBar then
  self.MiniBar=node('CanvasGroup','Island',sidebarGui,{Size=UDim2.fromOffset(180,40),AbsoluteSize=Vector2.new(180,40),Visible=false})
  self._miniOrb=self.MiniBar
  self._miniScale=node('UIScale','MiniScale',self.MiniBar)
 end
 return self.MiniBar
end
function app:_miniLand()return Vector2.new(300,20),Vector2.new(180,40)end
for cycle=1,8 do
 nativeTransitions.Minimize(app)
 sidebarRoot.AbsoluteSize=Vector2.new(866,512)
 flush()
 local ghost=app._ghost
 check(ghost and not ghost:FindFirstChild('DevilLanguageSelector')and not ghost:FindFirstChildOfClass('UIScale'),'theme adopted a minimize animation frame')
 check(docked.Parent==sidebar and sidebar:FindFirstChild('DevilLanguageSelector')==docked,'minimize rebuilt or moved the language menu')
 for frame=1,20 do
  ghost.Size=UDim2.fromOffset(880-frame*30,520-frame*20)
  ghost.AbsoluteSize=Vector2.new(880-frame*30,520-frame*20)
  flush()
 end
 advance(.11);advance(.31);advance(.25)
 check(not sidebarRoot.Visible and app.MiniBar.Visible,'native minimize did not finish')
 check(not dialog.Visible,'native Break dialog still covers the game after minimize')
 nativeTransitions.Restore(app);advance(.31);advance(.11);advance(.25)
 sidebarRoot.AbsoluteSize=Vector2.new(880,520);flush()
 check(sidebarRoot.Visible and not app.MiniBar.Visible and app._ghost==nil,'native restore did not finish')
 check(dialog.Visible,'native Break dialog did not follow restore')
end
task.delay,task.spawn=savedDelay,savedSpawn
check(nativeScale.Scale==.83 and scaleWrites==16,'theme rewrote the native transition scale')
local lateSidebar=node('Frame','Sidebar',root,{Size=UDim2.new(0,170,1,-16)})
local lateTabs=node('ScrollingFrame','Tabs',lateSidebar,{Position=UDim2.fromOffset(0,72),Size=UDim2.new(1,0,1,-136)})
flush()
check(lateSidebar:FindFirstChild('DevilLanguageSelector')~=nil and root:FindFirstChild('DevilLanguageSelector')==nil,'late sidebar did not replace temporary header row')
check(heading.Position.Y.Offset==0 and lateTabs.Position.Y.Offset==112,'temporary header padding leaked during sidebar migration')
controller.Destroy();flush()
check(root:FindFirstChild('DevilLanguageSelector')==nil,'language selector leaked on unload')
check(root.BackgroundColor3==originalColor and root.BackgroundTransparency==0,'original background not restored')
check(root:FindFirstChildOfClass('UIScale')==nil,'theme scale leaked')
check(button.Text=='Auto Farm'and button.TextTransparency==0,'translation leaked on unload')
check(sidebar:FindFirstChild('DevilLanguageSelector')==nil and tabs.Position.Y.Offset==80 and tabs.Size.Y.Offset==-144,'reserved row geometry leaked on unload')
check(anonymousIcon.ImageColor3==Color3.fromRGB(255,0,0),'native icon color not restored on unload')
check(search.PlaceholderColor3==Color3.fromRGB(30,30,30)and search.Text=='rare egg','input color restoration lost text or native hint')
check(quantizedHost.BackgroundTransparency==.25,'theme recorded its own rounded opacity as native state')
check(nativeScale.Parent==sidebarRoot and scaleWrites==16,'theme removed or rewrote native UIScale')
check(callback.Connected and originalOpen.Connected,'callbacks disconnected on unload')
check(legacyLanguage.Visible and legacyCallback.Connected and legacyChanges==0,'legacy language state not restored on unload')
local reloaded=(function()
-- MODULE INSERTED HERE
end)()
flush();check(reloaded.Get().Language=='TH','language preference lost')
reloaded.Destroy();flush()
print('PASS glass-black GUI, red icons, toggle states and reserved language layout: '..checks..' checks')
