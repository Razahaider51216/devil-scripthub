-- DEVIL HUB / Climb Steal isolation. No game modules, remote calls or hooks.
assert(game.PlaceId==85738654635245,"Open Climb for Eggs")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilClimbStealIsolation then scope.DevilClimbStealIsolation.Stop()end
local player=game:GetService("Players").LocalPlayer
local http=game:GetService("HttpService")
local prompts=game:GetService("ProximityPromptService")
local started=os.clock()
local report={release="climb-steal-isolation-1",events={},errors={},phase="BeforeHubStopped",
    placeId=game.PlaceId,userId=player.UserId}
local links,stopped={},false
local screen,statusLabel
local api={}
local function position()
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then return{x=root.Position.X,y=root.Position.Y,z=root.Position.Z}end
end
local function value(v)
    if v==nil then return{present=false}end
    return{present=true,kind=typeof(v),value=tostring(v)}
end
local function note(kind,details)
    if stopped then return end
    table.insert(report.events,{t=os.clock()-started,kind=kind,phase=report.phase,
        carrying=value(player:GetAttribute("CarryingEgg")),position=position(),details=details})
    while #report.events>160 do table.remove(report.events,1)end
end
local function status(text)
    report.status=text
    if statusLabel then statusLabel.Text=text end
    print("[DEVIL Steal isolation] "..text)
end
function api.Save(copy)
    report.current={carrying=value(player:GetAttribute("CarryingEgg")),position=position(),
        hubRunning=scope.DevilClimbEggs~=nil,elapsed=os.clock()-started}
    local text=http:JSONEncode(report)
    if type(writefile)=="function"then
        local ok,err=pcall(writefile,"DevilClimbStealIsolation.json",text)
        if not ok then warn(err)end
    end
    if copy and type(setclipboard)=="function"then pcall(setclipboard,text)end
    return text
end
function api.Stop()
    if stopped then return end
    api.Save(false);stopped=true
    for _,link in ipairs(links)do link:Disconnect()end
    if screen then screen:Destroy()end
    if scope.DevilClimbStealIsolation==api then scope.DevilClimbStealIsolation=nil end
end
local function connect(signal,callback)
    table.insert(links,signal:Connect(callback))
end
local function laterSave()
    task.delay(4,function()
        if not stopped then api.Save(false);status("บันทึกผลแล้ว • กดคัดลอกรายงาน")end
    end)
end
connect(player:GetAttributeChangedSignal("CarryingEgg"),function()
    note("CarryingEggChanged")
    status(player:GetAttribute("CarryingEgg")~=nil and"เกมตั้งค่าให้ถือไข่แล้ว"or"เกมล้างสถานะถือไข่")
    laterSave()
end)
for _,name in ipairs({"EggDropSilent","Ragdolled"})do
    connect(player:GetAttributeChangedSignal(name),function()note("AttributeChanged",{name=name,value=value(player:GetAttribute(name))})end)
end
local function interesting(prompt)
    return prompt and(prompt.Name=="StealPrompt"or prompt.ActionText=="Steal")
end
for _,event in ipairs({"PromptButtonHoldBegan","PromptButtonHoldEnded","PromptTriggered","PromptTriggerEnded"})do
    connect(prompts[event],function(prompt,who)
        if interesting(prompt)and(not who or who==player)then
            note(event,{path=prompt:GetFullName(),holdDuration=prompt.HoldDuration,enabled=prompt.Enabled})
            if event=="PromptTriggered"then laterSave()end
        end
    end)
end
local rs=game:GetService("ReplicatedStorage")
local src=rs:FindFirstChild("src")
local packages=src and src:FindFirstChild("Packages")
local index=packages and packages:FindFirstChild("_Index")
local version=index and index:FindFirstChild("sleitnick_knit@1.7.0")
local knit=version and version:FindFirstChild("knit")
local services=knit and knit:FindFirstChild("Services")
local eggService=services and services:FindFirstChild("EggSpawnService")
local re=eggService and eggService:FindFirstChild("RE")
local refused=re and re:FindFirstChild("StealRefused")
if refused then connect(refused.OnClientEvent,function(message)note("StealRefused",{message=tostring(message)});laterSave()end)end
report.refusalListener=refused~=nil
local identify=identifyexecutor or getexecutorname
if type(identify)=="function"then local ok,name=pcall(identify);if ok then report.executor=tostring(name)end end
function api.StopHub()
    note("StopHubRequested")
    local hub=scope.DevilClimbEggs
    if hub and type(hub.Destroy)=="function"then
        local ok,problem=pcall(hub.Destroy)
        if not ok then table.insert(report.errors,tostring(problem));status("หยุด HUB ไม่สำเร็จ ดูรายงาน");return end
    end
    report.phase="AfterHubStopped";note("HubStopped")
    status("หยุด HUB แล้ว • เดินไปกด Steal เองหนึ่งครั้ง")
    api.Save(false)
end
scope.DevilClimbStealIsolation=api
note("IsolationStarted")
-- Small PlayerGui panel, independent of DEVIL HUB's GUI library and VM.
local ok,problem=pcall(function()
    screen=Instance.new("ScreenGui");screen.Name="DevilClimbStealIsolation"
    screen.ResetOnSpawn=false;screen.DisplayOrder=10001
    screen.Parent=player:WaitForChild("PlayerGui")
    local card=Instance.new("Frame");card.Size=UDim2.fromOffset(300,188)
    card.AnchorPoint=Vector2.new(.5,0);card.Position=UDim2.new(.5,0,0,52)
    card.BackgroundColor3=Color3.fromRGB(22,18,22);card.BorderSizePixel=0;card.Parent=screen
    local radius=Instance.new("UICorner");radius.CornerRadius=UDim.new(0,12);radius.Parent=card
    local title=Instance.new("TextLabel");title.BackgroundTransparency=1
    title.Position=UDim2.fromOffset(12,8);title.Size=UDim2.fromOffset(276,24)
    title.Text="DEVIL • Steal isolation";title.Font=Enum.Font.GothamBold
    title.TextSize=16;title.TextColor3=Color3.fromRGB(255,95,105);title.Parent=card
    statusLabel=Instance.new("TextLabel");statusLabel.BackgroundTransparency=1
    statusLabel.Position=UDim2.fromOffset(12,36);statusLabel.Size=UDim2.fromOffset(276,40)
    statusLabel.TextWrapped=true;statusLabel.Font=Enum.Font.Gotham
    statusLabel.TextSize=13;statusLabel.TextColor3=Color3.fromRGB(240,235,240);statusLabel.Parent=card
    local function button(text,y,callback)
        local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(276,28);b.Position=UDim2.fromOffset(12,y)
        b.Text=text;b.Font=Enum.Font.Gotham;b.TextSize=13
        b.TextColor3=Color3.fromRGB(255,255,255);b.BackgroundColor3=Color3.fromRGB(80,35,45);b.Parent=card
        connect(b.Activated,callback)
    end
    button("1 • หยุด HUB แล้วทดสอบ Steal เอง",82,api.StopHub)
    button("2 • คัดลอก / บันทึกรายงาน",116,function()api.Save(true);status("คัดลอกและบันทึกแล้ว")end)
    button("ปิดตัวทดสอบ",150,api.Stop)
end)
if not ok then table.insert(report.errors,tostring(problem))end
status("กด Steal ก่อนหนึ่งครั้ง แล้วกดปุ่ม 1 เพื่อเทียบ")
api.Save(false)
return api
