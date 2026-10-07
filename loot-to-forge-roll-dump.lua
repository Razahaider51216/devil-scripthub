-- DEVIL HUB / Loot to Forge: separate observation tool; does not send/replay remotes.
local env=type(getgenv)=="function"and getgenv()or _G
assert(game.PlaceId==118805555015549 or game.GameId==10684750879,"Open Loot to Forge first.")
if env.DevilLootRollDump then env.DevilLootRollDump:Close()end
local storage=game:GetService("ReplicatedStorage")
local http=game:GetService("HttpService")
local player=game:GetService("Players").LocalPlayer
local controller={Active=false,Records={},Remotes={},Limit=500,File="DevilHub_Loot_Roll_Dump.json"}
env.DevilLootRollDump=controller
local connections,observed,inventory={},{},{}
local screen,output,status
local closed=false
local started=os.clock()
local oldNamecall,ourNamecall
local lastTickets,haveTickets
local classData
pcall(function()
    local localData=storage:FindFirstChild("LocalData")
    local module=localData and localData:FindFirstChild("ClassData")
    if module then classData=require(module)end
end)
local function path(instance)
    local ok,name=pcall(instance.GetFullName,instance)
    return ok and name or instance.Name
end
local function relevant(remote)
    local name=path(remote):lower()
    for _,word in ipairs({"class","luck","roll","ticket","gacha","online"})do
        if name:find(word,1,true)then return true end
    end
    return false
end
local function serialize(value,depth,seen)
    local kind=typeof(value)
    if value==nil then return {type="nil"}end
    if kind=="string"then return value:sub(1,2048)end
    if kind=="boolean"then return value end
    if kind=="number"then return value==value and math.abs(value)<math.huge and value or tostring(value)end
    if kind=="Instance"then return {type=kind,path=path(value),class=value.ClassName}end
    if kind~="table"then return {type=kind,value=tostring(value):sub(1,512)}end
    if depth>=4 or seen[value]then return {type="table",truncated=true}end
    seen[value]=true
    local entries,count={},0
    for key,item in pairs(value)do
        count+=1
        if count>32 then entries[#entries+1]={truncated=true}break end
        entries[#entries+1]={key=serialize(key,depth+1,seen),value=serialize(item,depth+1,seen)}
    end
    seen[value]=nil
    return {type="table",entries=entries}
end
local function ticketCount()
    if not classData or type(classData.GetLuckTimes)~="function"then return nil end
    local ok,value=pcall(classData.GetLuckTimes)
    return ok and type(value)=="number"and value or nil
end
local function redraw()
    if closed then return end
    local lines={"Online reward -> receive ticket -> Roll once.","Records: "..#controller.Records.." | Ticket count: "..tostring(ticketCount()or "unavailable"),
        "Outgoing capture: "..(controller.Capabilities and controller.Capabilities.outgoing and "available"or "unsupported by executor")}
    for index=1,#controller.Records do
        local row=controller.Records[index]
        lines[#lines+1]=string.format("%.2fs  %s  %s",row.seconds,row.kind,row.path or row.note or "")
    end
    if output then output.Text=table.concat(lines,"\n")end
    if status then status.Text=controller.Active and "Recording Class / Online traffic"or "Ready / stopped; Start Remote or Save report"end
end
local function record(kind,remote,args,note)
    if not controller.Active or closed then return end
    local row={seconds=math.floor((os.clock()-started)*100)/100,kind=kind,note=note,tickets=ticketCount()}
    if remote then row.path=path(remote)row.class=remote.ClassName end
    if args then
        row.argumentCount=args.n row.arguments={}
        for index=1,math.min(args.n,32)do row.arguments[index]=serialize(args[index],0,{})end
        if args.n>32 then row.argumentsTruncated=true end
    end
    if #controller.Records>=controller.Limit then table.remove(controller.Records,1)controller.Dropped=(controller.Dropped or 0)+1 end
    controller.Records[#controller.Records+1]=row
end
local function discover(remote)
    if not(remote:IsA("RemoteEvent")or remote:IsA("RemoteFunction"))or inventory[remote]then return end
    inventory[remote]=true
    controller.Remotes[#controller.Remotes+1]={path=path(remote),class=remote.ClassName,relevant=relevant(remote)}
    if not relevant(remote)then return end
    observed[remote]=true
    record("Remote discovered",remote)
    if remote:IsA("RemoteEvent")then
        connections[#connections+1]=remote.OnClientEvent:Connect(function(...)
            if controller.Active then pcall(record,"OnClientEvent",remote,table.pack(...))end
        end)
    end
end
for _,remote in ipairs(storage:GetDescendants())do discover(remote)end
connections[#connections+1]=storage.DescendantAdded:Connect(discover)
controller.Capabilities={outgoing=false,incoming=true,ticketCount=classData~=nil,coverage="Class / Luck / Roll / Ticket / Gacha / Online name/path filter"}
if type(hookmetamethod)=="function"and type(getnamecallmethod)=="function"then
    local hook=function(self,...)
        local method=getnamecallmethod()
        if controller.Active and observed[self]and(method=="FireServer"or method=="InvokeServer")then
            pcall(record,method,self,table.pack(...))
        end
        return oldNamecall(self,...)
    end
    ourNamecall=type(newcclosure)=="function"and newcclosure(hook)or hook
    local ok,original=pcall(hookmetamethod,game,"__namecall",ourNamecall)
    if ok then oldNamecall=original controller.Capabilities.outgoing=true
    else record("Capture unavailable",nil,nil,tostring(original))end
else
    record("Capture unavailable",nil,nil,"Executor lacks hookmetamethod/getnamecallmethod; inventory and incoming events only.")
end
function controller:Snapshot()
    record("Ticket snapshot",nil,nil,"Tickets: "..tostring(ticketCount()or "unavailable"))
    redraw()
end
function controller:Start()
    if closed or self.Active then return end
    self.Active=true haveTickets=false
    self:Snapshot()
end
function controller:GetText()
    return http:JSONEncode({tool="DEVIL HUB Loot Roll Dump",version=1,placeId=game.PlaceId,
        capabilities=self.Capabilities,remotes=self.Remotes,records=self.Records,dropped=self.Dropped or 0})
end
function controller:Copy()
    local copy=setclipboard or toclipboard
    if type(copy)~="function"then if status then status.Text="Clipboard unavailable; use Save"end return false end
    copy(self:GetText())if status then status.Text="Report copied"end return true
end
function controller:Save()
    if type(writefile)~="function"then if status then status.Text="File access unavailable; use Copy"end return false end
    self:Stop()
    local ok,err=pcall(writefile,self.File,self:GetText())
    if status then status.Text=ok and("Saved: "..self.File)or("Save failed: "..tostring(err))end
    return ok
end
function controller:Stop()
    if not self.Active then return end
    self:Snapshot()self.Active=false
    redraw()
end
function controller:Close()
    self:Stop()closed=true
    for _,connection in ipairs(connections)do connection:Disconnect()end
    connections={}
    -- Restore only while we still own the top hook; do not remove a later hook.
    if oldNamecall and type(getrawmetatable)=="function"then
        pcall(function()
            if getrawmetatable(game).__namecall==ourNamecall then hookmetamethod(game,"__namecall",oldNamecall)end
        end)
    end
    if screen then screen:Destroy()end
    if env.DevilLootRollDump==self then env.DevilLootRollDump=nil end
end
local function make(kind,parent,properties)
    local object=Instance.new(kind)
    for key,value in pairs(properties)do object[key]=value end
    object.Parent=parent return object
end
screen=make("ScreenGui",player:WaitForChild("PlayerGui"),{Name="DevilLootRollDump",ResetOnSpawn=false,DisplayOrder=11000})
local panel=make("Frame",screen,{Position=UDim2.fromScale(.08,.2),Size=UDim2.fromScale(.84,.6),BackgroundColor3=Color3.fromRGB(17,17,23),BorderSizePixel=0,Active=true})
make("UICorner",panel,{CornerRadius=UDim.new(0,12)})
local title=make("TextLabel",panel,{Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,28),BackgroundTransparency=1,Text="DEVIL HUB / ROLL DUMP",TextColor3=Color3.fromRGB(255,85,95),TextSize=18,Font=Enum.Font.GothamBold,Active=true})
status=make("TextLabel",panel,{Position=UDim2.fromOffset(12,37),Size=UDim2.new(1,-24,0,22),BackgroundTransparency=1,Text="",TextColor3=Color3.fromRGB(210,210,215),TextSize=12,Font=Enum.Font.Gotham})
local scroll=make("ScrollingFrame",panel,{Position=UDim2.fromOffset(12,66),Size=UDim2.new(1,-24,1,-116),BackgroundTransparency=1,BorderSizePixel=0,Active=true,ScrollingEnabled=true,ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=6,ScrollBarImageColor3=Color3.fromRGB(255,85,95),CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
output=make("TextLabel",scroll,{Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,-12,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text="",TextColor3=Color3.fromRGB(235,235,240),TextSize=12,Font=Enum.Font.Code,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
-- Every surface moves the complete window. A short press still activates buttons.
local inputs=game:GetService("UserInputService")
local dragInput,dragStart,dragPosition,dragButton,suppressedButton
local function beginDrag(input,button)
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    if dragInput then
        if input==dragInput and button then dragButton=button end
        return
    end
    suppressedButton=nil dragButton=button
    dragInput=input dragStart=input.Position dragPosition=panel.Position
end
for _,surface in ipairs({panel,title,status,scroll,output})do
    surface.Active=true
    connections[#connections+1]=surface.InputBegan:Connect(function(input)beginDrag(input)end)
end
connections[#connections+1]=inputs.InputEnded:Connect(function(input)
    if input==dragInput then dragInput=nil dragButton=nil scroll.ScrollingEnabled=true end
end)
connections[#connections+1]=inputs.InputChanged:Connect(function(input)
    if not dragInput or closed then return end
    if dragInput.UserInputType==Enum.UserInputType.Touch then
        if input~=dragInput then return end
    elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local delta=input.Position-dragStart
    if delta.Magnitude<6 then return end
    suppressedButton=dragButton
    scroll.ScrollingEnabled=false
    panel.Position=UDim2.new(dragPosition.X.Scale,dragPosition.X.Offset+delta.X,dragPosition.Y.Scale,dragPosition.Y.Offset+delta.Y)
end)
for index,item in ipairs({{"Start Remote",function()controller:Start()end},{"Copy",function()controller:Copy()end},
    {"Save",function()controller:Save()end},{"Stop",function()controller:Stop()end},{"Close",function()controller:Close()end}})do
    local button=make("TextButton",panel,{Position=UDim2.new((index-1)/5,6,1,-39),Size=UDim2.new(.2,-12,0,30),BackgroundColor3=Color3.fromRGB(53,29,36),Text=item[1],TextColor3=Color3.new(1,1,1),TextSize=13,TextScaled=true,Font=Enum.Font.Gotham})
    connections[#connections+1]=button.InputBegan:Connect(function(input)beginDrag(input,button)end)
    button.Activated:Connect(function()
        if suppressedButton==button then suppressedButton=nil return end
        local ok,err=pcall(item[2])if not ok and status then status.Text=tostring(err)end
    end)
end
redraw()
task.spawn(function()
    while not closed do
        if controller.Active then
            local current=ticketCount()
            if not haveTickets or current~=lastTickets then
                record("Ticket count changed",nil,nil,tostring(lastTickets).." -> "..tostring(current))
                lastTickets=current haveTickets=true
            end
            redraw()
        end
        task.wait(.5)
    end
end)
print("[DEVIL HUB / ROLL DUMP] Ready. Press Start Remote, claim an online reward, roll once, then Save.")
