-- Records actual Ride A Fish requests and server events; sends no requests.
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local player=Players.LocalPlayer
assert(game.PlaceId==104050046639813,"Run in Ride A Fish (104050046639813)")
local env=(getgenv and getgenv()) or _G
if env.DevilFishRemoteDump then env.DevilFishRemoteDump.Destroy() end
local alive,recording=true,true
local links,seen={},{}
local start=os.clock()
local report={release="fish-remote-dump-1",placeId=game.PlaceId,userId=player.UserId,events={},snapshots={},remotes={},dropped=0,errors={}}
local allowed={EggGame=true,AdminRemotes=true,FeedsRemotes=true,GearRemotes=true,FishSellRemotes=true,FreeGiftRemotes=true,DailyRewardRequest=true}
local function relevant(instance)
    if typeof(instance)~="Instance" or not instance:IsDescendantOf(RS) then return false end
    local node=instance
    while node.Parent and node.Parent~=RS do node=node.Parent end
    return allowed[node.Name]==true
end
local function serialize(value,depth,visited)
    depth=depth or 0; visited=visited or {}
    local kind=typeof(value)
    if kind=="Instance" then return {type=kind,path=value:GetFullName()} end
    if kind=="Vector3" then return {type=kind,x=value.X,y=value.Y,z=value.Z} end
    if kind=="CFrame" then return {type=kind,components={value:GetComponents()}} end
    if type(value)=="table" then
        if visited[value] then return "[cycle]" end
        if depth>=7 then return "[depth limit]" end
        visited[value]=true
        local out,count={},0
        for k,v in pairs(value) do
            count+=1
            if count>500 then out.__truncated=true; break end
            out[tostring(k)]=serialize(v,depth+1,visited)
        end
        visited[value]=nil
        return out
    end
    if kind=="string" then return #value>12000 and value:sub(1,12000).."[truncated]" or value end
    if kind=="boolean" then return value end
    if kind=="number" and value==value and math.abs(value)<math.huge then return value end
    return tostring(value)
end
local function log(direction,remote,method,args)
    if not alive or not recording then return end
    -- Progression is frequent and unrelated to inventory grants; count separately.
    if direction=="ServerToClient" and args[1]=="Progression" then
        report.progressionEvents=(report.progressionEvents or 0)+1; return
    end
    local ok,entry=pcall(function()
        return {t=os.clock()-start,direction=direction,remote=remote:GetFullName(),method=method,arguments=serialize(args)}
    end)
    if not ok then return end
    if #report.events>=200 then table.remove(report.events,1); report.dropped+=1 end
    table.insert(report.events,entry)
end
local function snapshot(label)
    local out={label=label,t=os.clock()-start,attributes=serialize(player:GetAttributes()),stats={},tools={}}
    local stats=player:FindFirstChild("leaderstats")
    if stats then
        for _,v in ipairs(stats:GetChildren()) do if v:IsA("ValueBase") then out.stats[v.Name]=serialize(v.Value) end end
    end
    for _,container in ipairs({player:FindFirstChild("Backpack"),player.Character}) do
        if container then
            for _,v in ipairs(container:GetChildren()) do
                if v:IsA("Tool") then table.insert(out.tools,{name=v.Name,attributes=serialize(v:GetAttributes())}) end
            end
        end
    end
    if #report.snapshots>=20 then table.remove(report.snapshots,1) end
    table.insert(report.snapshots,out)
    return out
end
local function bind(remote)
    if seen[remote] or not relevant(remote) then return end
    if not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction") then return end
    seen[remote]=true
    table.insert(report.remotes,{path=remote:GetFullName(),class=remote.ClassName})
    if remote:IsA("RemoteEvent") then
        table.insert(links,remote.OnClientEvent:Connect(function(...) log("ServerToClient",remote,"OnClientEvent",table.pack(...)) end))
    end
end
for _,v in ipairs(RS:GetDescendants()) do bind(v) end
table.insert(links,RS.DescendantAdded:Connect(bind))
-- Optional executor hook. The original call is forwarded exactly once.
-- Disable logging on destroy; do not overwrite hooks another script installed later.
report.outboundCapture=false
if type(hookmetamethod)=="function" and type(getnamecallmethod)=="function" then
    local ok,err=pcall(function()
        local original
        local function intercept(self,...)
            local method=getnamecallmethod()
            if alive and recording and (method=="FireServer" or method=="InvokeServer") and relevant(self) then
                local args=table.pack(...)
                log("ClientToServer",self,method,args)
                if method=="InvokeServer" then
                    local results=table.pack(original(self,...))
                    log("ServerReturn",self,method,results)
                    return table.unpack(results,1,results.n)
                end
            end
            return original(self,...)
        end
        original=hookmetamethod(game,"__namecall",type(newcclosure)=="function" and newcclosure(intercept) or intercept)
    end)
    report.outboundCapture=ok
    if not ok then table.insert(report.errors,"Outbound hook: "..tostring(err)) end
else
    table.insert(report.errors,"Executor has no hookmetamethod/getnamecallmethod; incoming events only")
end
snapshot("Initial")
local gui=Instance.new("ScreenGui")
gui.Name="DevilFishRemoteDump"; gui.ResetOnSpawn=false; gui.Parent=player:WaitForChild("PlayerGui")
local panel=Instance.new("Frame")
panel.AnchorPoint=Vector2.new(.5,.5); panel.Position=UDim2.fromScale(.5,.5)
panel.Size=UDim2.fromOffset(360,260); panel.BackgroundColor3=Color3.fromRGB(25,18,23); panel.Parent=gui
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,12)
local scale=Instance.new("UIScale",panel)
local viewportLink
local function resize()
    local camera=workspace.CurrentCamera
    if camera then local v=camera.ViewportSize; scale.Scale=math.min(1,math.max(1,v.X-24)/360,math.max(1,v.Y-60)/260) end
end
local function cameraChanged()
    if viewportLink then viewportLink:Disconnect() end
    local camera=workspace.CurrentCamera
    viewportLink=camera and camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) or nil
    resize()
end
table.insert(links,workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(cameraChanged)); cameraChanged()
local function item(class,text,y,h)
    local obj=Instance.new(class)
    obj.Position=UDim2.fromOffset(12,y); obj.Size=UDim2.new(1,-24,0,h or 32)
    obj.Text=text; obj.Font=Enum.Font.Gotham; obj.TextSize=13; obj.TextColor3=Color3.new(1,1,1)
    obj.BackgroundColor3=Color3.fromRGB(93,35,46); obj.Parent=panel
    if class=="TextLabel" then obj.BackgroundTransparency=1; obj.TextWrapped=true end
    Instance.new("UICorner",obj).CornerRadius=UDim.new(0,7)
    return obj
end
item("TextLabel","DEVIL HUB · Ride A Fish Remote Dump",8)
local status=item("TextLabel",report.outboundCapture and "กำลังบันทึกคำขอและผลตอบกลับ — ทำรายการในเกม" or "บันทึกได้เฉพาะผลตอบกลับ — executor ไม่รองรับ hook",43,48)
local mark=item("TextButton","บันทึกจุดก่อน/หลังทำรายการ",98)
table.insert(links,mark.Activated:Connect(function()
    snapshot("Manual "..tostring(#report.snapshots+1)); status.Text="บันทึกจุดแล้ว · เหตุการณ์ "..#report.events
end))
local pause=item("TextButton","หยุดบันทึก / บันทึกต่อ",136)
table.insert(links,pause.Activated:Connect(function()
    recording=not recording; status.Text=recording and "กำลังบันทึก" or "หยุดบันทึกแล้ว"
end))
local save=item("TextButton","คัดลอก / บันทึกรายงาน JSON",174)
table.insert(links,save.Activated:Connect(function()
    snapshot("Export")
    local data=Http:JSONEncode(report)
    local copied,written=false,false
    if type(setclipboard)=="function" then copied=pcall(setclipboard,data) end
    if type(writefile)=="function" then written=pcall(writefile,"DevilRideFishRemoteDump.json",data) end
    print(data)
    status.Text=(copied and "คัดลอกแล้ว · " or "")..(written and "DevilRideFishRemoteDump.json" or "รายงานอยู่ใน Console")
end))
local api={Report=report,Snapshot=snapshot}
function api.Destroy()
    alive=false; recording=false
    for _,link in ipairs(links) do link:Disconnect() end
    if viewportLink then viewportLink:Disconnect() end
    gui:Destroy()
    if env.DevilFishRemoteDump==api then env.DevilFishRemoteDump=nil end
end
local close=item("TextButton","ปิดตัว Dump",212)
table.insert(links,close.Activated:Connect(api.Destroy))
env.DevilFishRemoteDump=api
return api
