-- Uses the real shared language dropdown and actual native UI source.
local coreGui=Instance.new('CoreGui')
local shared,files,encoded,windows={},{},{},{}
local seq,createdCores,destroyedCores,stoppedCores=0,0,0,0
local function copy(v)
 if type(v)~='table'then return v end
 local result={};for k,value in pairs(v)do result[k]=copy(value)end;return result
end
local http={JSONEncode=function(_,value)seq+=1;local key='json-'..seq;encoded[key]=copy(value);return key end,
 JSONDecode=function(_,key)return assert(encoded[key])end}
local heartbeat=signal()
local player={UserId=123}
local game={GameId=10765490774,PlaceId=85738654635245,GetService=function(_,name)
 if name=='CoreGui'then return coreGui elseif name=='HttpService'then return http
 elseif name=='RunService'then return {Heartbeat=heartbeat} elseif name=='Players'then return {LocalPlayer=player}end
 error('Unexpected service '..name)
end,HttpGet=function()return 'return MOCK_LIB'end}
local function getgenv()return shared end
local function isfile(name)return files[name]~=nil end
local function readfile(name)return files[name]end
local function writefile(name,value)files[name]=value end
local function node(class,name,parent,props)
 local result=Instance.new(class);result.Name=name
 for k,v in pairs(props or{})do result[k]=v end
 result.Parent=parent;return result
end
local owner=(function()
-- SHARED MODULE HERE
end)()
local originalSet,originalDestroy=owner.Set,owner.Destroy
local library={}
local function group(win,name)
 local g={};win.Groups[name]=g
 node('TextLabel','SectionName',win.Root,{Text=name or''})
 function g:CreateGroupbox(config)return group(win,config.Name)end
 for _,kind in ipairs({'Toggle','Dropdown','Slider','Input','Button','Paragraph','Label','Image'})do
  g['Create'..kind]=function(_,opts)
   local label=node('TextLabel',kind..'Name',win.Root,{Text=opts.Name or''})
   local content=node('TextLabel',kind..'Content',win.Root,{Text=opts.Content or''})
   local widget={Config=opts,Label=label,Content=content}
   function widget:Set(value,silent)
    self.Value=value
    if kind=='Paragraph'or kind=='Label'then self.Content.Text=value end
    if not silent and opts.Callback then opts.Callback(value)end
   end
   win.Widgets[opts.Name or'Totals']=widget;return widget
  end
 end
 return g
end
function library:CreateWindow(config)
 local screen=node('ScreenGui','DevilHubClimb',nil)
 local root=node('Frame','Window',screen,{Size=UDim2.fromOffset(790,550),AbsoluteSize=Vector2.new(790,550)})
 local sidebar=node('Frame','Sidebar',root,{AbsoluteSize=Vector2.new(180,500)})
 node('Frame','Tabs',sidebar)
 local win={Gui=screen,Root=root,Widgets={},Groups={}}
 function win:CreateTab(config)return group(self,config.Name)end
 for _,method in ipairs({'SetTransparent','SetHideName','SetHideAvatar','SetToggleButton','SetSize'})do win[method]=function()end end
 function win:Destroy()self.Destroyed=true;self.Gui:Destroy()end
 win.MinimizeButton=node('TextButton','Minimize',root)
 win.MinimizeButton.Position=setmetatable(UDim2.fromOffset(700,0),{__sub=function()return UDim2.fromOffset(400,0)end})
 screen:SetAttribute('DevilHubPresentation',true);screen.Parent=coreGui
 windows[#windows+1]=win;return win
end
local env=setmetatable({game=game,task=task,getgenv=getgenv,Instance=Instance,Enum=Enum,UDim2=UDim2,UDim=UDim,
 Vector2=Vector2,Color3=Color3,isfile=isfile,readfile=readfile,writefile=writefile,MOCK_LIB=library}, {__index=getfenv(0)})
local lastCore,refreshNative
local function factory(config,notify)
 createdCores+=1;refreshNative=notify
 local c={Config=config,Report={status='Ready',phase='Idle',picked=0,stored=0,placed=0,hatched=0,lost=0,jobs={}}}
 function c.Set(key,value)config[key]=value end
 function c.Stop()stoppedCores+=1;for k,v in pairs(config)do if type(v)=='boolean'and(k=='Farm'or k:match('^Auto'))then config[k]=false end end end
 function c.Destroy()destroyedCores+=1 end
 function c.SaveReport()return 'report'end
 lastCore=c;return c
end
env.MOCK_MAKE=factory
env.loadstring=function(source,label)local f,e=loadstring(source,label);if f then setfenv(f,env)end;return f,e end
local run=assert(env.loadstring(UI_SOURCE,'Climb native UI'))
local ui=run();flush()
local function last()return windows[#windows]end
local function nodeCount(name)
 local count=0;for _,item in ipairs(last().Gui:GetDescendants())do if item.Name==name then count+=1 end end;return count
end
local function hasThai(text)
 for _,codepoint in utf8.codes(text)do if codepoint>=0xE00 and codepoint<=0xE7F then return true end end;return false
end
local function visibleText(label)
 local overlay=label:FindFirstChild('DevilTranslatedLabel');return overlay and overlay.Text or label.Text
end
local function select(code)
 local selector=assert(last().Root:FindFirstChild('Sidebar'):FindFirstChild('DevilLanguageSelector'))
 selector:FindFirstChild('LanguageOptions'):FindFirstChild('Language'..code).Activated:Fire();flush()
end
if EXPECT_BASELINE then
 select('EN')
 check(owner.Get().Language=='EN'and ui.Config.Language=='TH','old language split did not reproduce')
 check(last().Widgets['เก็บไข่และกลับฐานอัตโนมัติ']~=nil,'baseline should still construct native Thai labels')
 local visibleThai=false
 for _,widget in pairs(last().Widgets)do if hasThai(visibleText(widget.Label))or hasThai(visibleText(widget.Content))then visibleThai=true;break end end
 check(visibleThai,'baseline did not retain any visible Thai script text')
 print('PASS reproduced Climb bug: English dropdown with Thai native UI')
 ui.Destroy();owner.Destroy();return
end
check(owner.Get().Language=='EN'and ui.Config.Language=='EN','startup did not use shared English selection')
check(last().Widgets['Auto Collect + Return']~=nil,'English native feature text missing')
check(nodeCount('DevilLanguageButton')==0 and nodeCount('DevilLanguageSelector')==1,'duplicate legacy language button created')
local coreAtStart=lastCore
last().Widgets['Auto Collect + Return']:Set(true,false)
last().Widgets['Egg Levels: highest first']:Set({'Divine'},false)
local stopsAtStart=stoppedCores
for _=1,3 do
 select('TH')
 check(ui.Config.Language=='TH'and last().Widgets['เก็บไข่และกลับฐานอัตโนมัติ']~=nil,'Thai selection missed native renderer')
 select('EN')
 check(ui.Config.Language=='EN'and last().Widgets['Auto Collect + Return']~=nil,'English selection left Thai feature labels')
 check(lastCore==coreAtStart and ui.Config.Farm and ui.Config.Tiers.Divine,'language rebuild restarted core or changed automation/filters')
 check(nodeCount('DevilLanguageButton')==0 and nodeCount('DevilLanguageSelector')==1,'duplicate selector after rebuild')
end
check(createdCores==1 and destroyedCores==0 and stoppedCores==stopsAtStart,'switching language stopped automation')
select('TH')
for message,expected in pairs({['Waiting for landing']='รอลงพื้นก่อนกดเก็บไข่',
 ['No safe standing point near egg']='ยังไม่มีจุดยืนปลอดภัยใกล้ไข่',
 ['Waiting for previous prompt activation']='รอการกดครั้งก่อนสิ้นสุด'})do
 coreAtStart.Report.status=message;refreshNative(coreAtStart.Report);flush()
 check(last().Widgets['สถานะ'].Content.Text==expected,'Thai status encoding or translation lost: '..message)
end
select('EN')
for name,widget in pairs(last().Widgets)do
 assert(not hasThai(visibleText(widget.Label))and not hasThai(visibleText(widget.Content)),'English left visible Thai script text: '..name)
end
coreAtStart.Report.status='Waiting for selected eggs';refreshNative(coreAtStart.Report);flush()
local status=last().Widgets['Status']
check(status and status.Content.Text=='Waiting for selected eggs','dynamic status source stayed Thai')
local overlay=status.Content:FindFirstChild('DevilTranslatedLabel')
check(not overlay or overlay.Text=='Waiting for selected eggs','shared overlay rewrote native English status')
select('TH');last().Widgets['คัดลอก / บันทึกรายงาน'].Config.Callback();flush()
select('EN')
check(last().Widgets['Settings status'].Content.Text=='Report copied: DevilClimbEggReport.json','report message remained Thai after English selection')
last().Widgets['Save Current Settings'].Config.Callback()
local document=encoded[files['DevilClimbEggSettings_123.json']]
check(document.config.Language=='EN'and document.config.Farm,'saving did not use current language or preserved automation')
-- A stale per-game TH profile must not undo the shared English selection.
document.config.Language='TH'
last().Widgets['Load Saved Settings'].Config.Callback();flush()
check(owner.Get().Language=='EN'and ui.Config.Language=='EN'and last().Widgets['Auto Collect + Return'],'saved Thai profile overrode visible English selection')
check(ui.SetLanguage('TH')and owner.Get().Language=='TH','native language API did not update the shared selection')
flush();check(ui.SetLanguage('EN')and owner.Get().Language=='EN','native English API failed');flush()
local windowCount=#windows;check(not ui.SetLanguage('invalid')and #windows==windowCount,'invalid language rebuilt UI')
check(http:JSONDecode(files['DevilHub-BlueGUI.json']).Language=='EN','shared selection not persisted')
ui.Destroy();flush()
check(owner.Set==originalSet and owner.Destroy==originalDestroy,'unload leaked shared language wrapper')
ui=run();flush()
check(ui.Config.Language=='EN'and last().Widgets['Auto Collect + Return'],'rejoin/run restored stale native Thai')
select('TH');select('EN')
check(createdCores==2 and lastCore.Config.Language=='EN','rerun stacked bindings or restarted gameplay')
owner.Destroy();flush()
check(owner.Set==originalSet and owner.Destroy==originalDestroy,'shared module teardown left language hook')
ui.Destroy();flush();check(destroyedCores==2,'language rebuild destroyed or leaked core')
print('PASS real shared dropdown + Climb native renderer: '..checks..' checks; startup, EN/TH, dynamic text, profiles, automation and teardown')
