-- Ride A Fish: original developer requests recovered from the client dump.
-- Sending a request is not confirmation that the server accepted it.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local player = Players.LocalPlayer
assert(game.PlaceId == 104050046639813, "This script is for Ride A Fish (104050046639813)")
local env = (getgenv and getgenv()) or _G
if env.DevilFishDevCommands then env.DevilFishDevCommands.Destroy() end
local report = {release="fish-dev-requests-2", placeId=game.PlaceId, attempts={}}
local connections, alive, busy = {}, true, false
local function safe(value, depth)
    depth = depth or 0
    if type(value) == "table" then
        if depth >= 4 then return "[depth limit]" end
        local out, count = {}, 0
        for k,v in pairs(value) do
            count += 1
            if count > 120 then out.truncated=true; break end
            out[tostring(k)] = safe(v, depth+1)
        end
        return out
    end
    if typeof(value)=="Instance" then return value:GetFullName() end
    if type(value)=="string" or type(value)=="boolean" then return value end
    if type(value)=="number" and value==value and math.abs(value)<math.huge then return value end
    return tostring(value)
end
local function snapshot()
    local out = {attributes=safe(player:GetAttributes()), stats={}}
    local stats=player:FindFirstChild("leaderstats")
    if stats then
        for _,v in ipairs(stats:GetChildren()) do
            if v:IsA("ValueBase") then out.stats[v.Name]=safe(v.Value) end
        end
    end
    return out
end
local gui=Instance.new("ScreenGui")
gui.Name="DevilFishDevCommands"; gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local frame=Instance.new("Frame")
frame.Size=UDim2.fromOffset(370,450)
frame.AnchorPoint=Vector2.new(.5,.5); frame.Position=UDim2.fromScale(.5,.5)
frame.BackgroundColor3=Color3.fromRGB(25,18,23); frame.Parent=gui
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14)
local uiScale=Instance.new("UIScale",frame)
local viewportConnection
local function resize()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local viewport=camera.ViewportSize
    uiScale.Scale=math.min(1,math.max(1,viewport.X-24)/370,math.max(1,viewport.Y-60)/450)
end
local function bindCamera()
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection=nil end
    local camera=workspace.CurrentCamera
    if camera then
        viewportConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    end
    resize()
end
table.insert(connections,workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera))
bindCamera()
local function text(class, label, y, height)
    local item=Instance.new(class)
    item.Size=UDim2.new(1,-24,0,height or 32); item.Position=UDim2.fromOffset(12,y)
    item.BackgroundColor3=Color3.fromRGB(51,30,37); item.TextColor3=Color3.fromRGB(245,235,237)
    item.Font=Enum.Font.Gotham; item.TextSize=13; item.Text=label; item.Parent=frame
    if class=="TextLabel" then item.BackgroundTransparency=1; item.TextWrapped=true end
    if class=="TextBox" then item.ClearTextOnFocus=false end
    Instance.new("UICorner",item).CornerRadius=UDim.new(0,7)
    return item
end
text("TextLabel","DEVIL HUB · Ride A Fish / Dev requests",8)
local status=text("TextLabel","ทดสอบทีละคำสั่ง · ส่งสำเร็จไม่ได้หมายถึงได้รับของ",40,52)
local egg=text("TextBox","",98); egg.PlaceholderText="ชื่อไข่ตรงตามเกม (DevGiveEgg / DevSpawnEgg)"
local catalog=RS:FindFirstChild("EggGame")
catalog=catalog and catalog:FindFirstChild("Eggs")
report.eggNames={}
if catalog then
    for _,item in ipairs(catalog:GetChildren()) do table.insert(report.eggNames,item.Name) end
    table.sort(report.eggNames)
    egg.Text=report.eggNames[1] or ""
end
local amount=text("TextBox","1000",136); amount.PlaceholderText="จำนวนเงิน GiftMoney (ส่งให้ตัวเอง)"
local list=Instance.new("ScrollingFrame")
list.Position=UDim2.fromOffset(12,178); list.Size=UDim2.new(1,-24,0,210)
list.BackgroundTransparency=1; list.BorderSizePixel=0; list.ScrollBarThickness=5
list.AutomaticCanvasSize=Enum.AutomaticSize.Y; list.CanvasSize=UDim2.new()
list.Parent=frame
local layout=Instance.new("UIListLayout",list); layout.Padding=UDim.new(0,6)
local function observe(remote, label)
    if not remote or not remote:IsA("RemoteEvent") then return end
    table.insert(connections,remote.OnClientEvent:Connect(function(...)
        if not busy then return end
        local current=report.attempts[#report.attempts]
        if current and #current.events<30 then
            table.insert(current.events,{source=label,arguments=safe(table.pack(...))})
        end
    end))
end
local gameFolder=RS:FindFirstChild("EggGame")
local adminFolder=RS:FindFirstChild("AdminRemotes")
observe(gameFolder and gameFolder:FindFirstChild("Events"),"EggGame.Events")
observe(adminFolder and adminFolder:FindFirstChild("AdminAction"),"AdminRemotes.AdminAction")
local function run(folderName,remoteName,command,args)
    if busy or not alive then return end
    local folder=RS:FindFirstChild(folderName)
    local remote=folder and folder:FindFirstChild(remoteName)
    if not remote or not remote:IsA("RemoteEvent") then status.Text="ไม่พบรีโมท: "..folderName.."."..remoteName; return end
    busy=true
    local entry={command=command,arguments=safe(args),before=snapshot(),events={},status="Pending",started=os.clock()}
    table.insert(report.attempts,entry)
    if #report.attempts>40 then table.remove(report.attempts,1) end
    status.Text="ส่ง "..command.." แล้ว · รอดูผลเซิร์ฟเวอร์ 5 วินาที"
    task.spawn(function()
        local ok,err=pcall(function()
            if command=="DevGiveFood" then remote:FireServer(table.unpack(args))
            else remote:FireServer(command,table.unpack(args)) end
        end)
        entry.sent=ok
        if not ok then entry.error=tostring(err) end
        if ok then task.wait(5) end
        entry.after=snapshot(); entry.status=ok and "Sent; inspect server events and inventory" or "Send failed"
        -- Stat changes can also come from normal income: never label them a confirmed grant.
        busy=false
        if alive then status.Text=ok and (command..": ส่งแล้ว ตรวจของจริง/รายงาน ไม่ยืนยันการเสก") or tostring(err) end
    end)
end
local function button(label,callback)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-8,0,34); b.BackgroundColor3=Color3.fromRGB(93,35,46)
    b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.Gotham; b.TextSize=13; b.Text=label
    b.Parent=list; Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    table.insert(connections,b.Activated:Connect(callback))
end
local function namedEgg(command)
    local name=egg.Text:match("^%s*(.-)%s*$")
    if name=="" then status.Text="กรอกชื่อไข่ก่อน"; return end
    run("EggGame","Requests",command,{name})
end
button("ให้ไข่ตามชื่อ · DevGiveEgg",function() namedEgg("DevGiveEgg") end)
button("สร้างไข่ในแมพ · DevSpawnEgg",function() namedEgg("DevSpawnEgg") end)
button("ให้ปลาตัวเร็วที่สุด",function() run("EggGame","Requests","DevBestFish",{"Fastest"}) end)
button("ให้ปลาตัวใหญ่ที่สุด",function() run("EggGame","Requests","DevBestFish",{"Biggest"}) end)
button("ให้ปลาทั้งหมด · DevGiveAllFish",function() run("EggGame","Requests","DevGiveAllFish",{}) end)
button("ให้ Tokens · DevGiveTokens",function() run("EggGame","Requests","DevGiveTokens",{}) end)
button("ให้อาหาร Abyssal Feast ×100",function() run("FeedsRemotes","DevGiveFood","DevGiveFood",{"Abyssal Feast",100}) end)
button("ให้เงินตัวเอง · GiftMoney",function()
    local value=tonumber(amount.Text)
    if not value or value~=value or value<1 or value>=math.huge then status.Text="กรอกจำนวนเงินเป็นเลขบวก"; return end
    run("AdminRemotes","AdminAction","GiftMoney",{player.Name,math.floor(value)})
end)
local save=text("TextButton","คัดลอก/บันทึกรายงาน JSON",400)
table.insert(connections,save.Activated:Connect(function()
    report.current=snapshot()
    local data=Http:JSONEncode(report)
    local copied,written=false,false
    if type(setclipboard)=="function" then copied=pcall(setclipboard,data) end
    if type(writefile)=="function" then written=pcall(writefile,"DevilFishDevRequests.json",data) end
    print(data)
    status.Text="รายงาน: "..(copied and "คัดลอกแล้ว " or "")..(written and "DevilFishDevRequests.json" or "ดู Console")
end))
local close=Instance.new("TextButton")
close.Size=UDim2.fromOffset(26,26); close.Position=UDim2.new(1,-30,0,3)
close.Text="×"; close.Parent=frame
local api={Report=report}
function api.Destroy()
    alive=false
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection=nil end
    for _,c in ipairs(connections) do c:Disconnect() end
    gui:Destroy()
    if env.DevilFishDevCommands==api then env.DevilFishDevCommands=nil end
end
table.insert(connections,close.Activated:Connect(api.Destroy))
env.DevilFishDevCommands=api
return api
