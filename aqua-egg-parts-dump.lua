-- DEVIL HUB / Aqua egg parts recorder. Reads objects/events; sends no remotes.
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilAquaEggDump and scope.DevilAquaEggDump.Stop then
    scope.DevilAquaEggDump.Stop()
    return
end
assert(game.PlaceId==104050046639813,"Open the Aqua map (Place 104050046639813) first.")
local players=game:GetService("Players")
local player=players.LocalPlayer
assert(player,"LocalPlayer is not ready; run again after joining.")
local http=game:GetService("HttpService")
local started=os.clock()
local filename="DevilAquaEggParts.json"
local active=true
local links={}
local eventLimit=300
local nodeLimit=20000
local report={schema="devil-aqua-egg-parts-1",placeId=game.PlaceId,universeId=game.GameId,
    startedUtc=os.date("!%Y-%m-%dT%H:%M:%SZ"),durationSeconds=180,events={},snapshots={},
    droppedEvents=0,errors={},readOnly=true}
local function read(object,key)
    local ok,value=pcall(function()return object[key]end)
    if not ok then return nil end
    return value
end
local function path(object)
    local ok,value=pcall(object.GetFullName,object)
    return ok and value or tostring(object)
end
local function value(v)
    local kind=typeof(v)
    if kind=="nil"or kind=="string"or kind=="boolean"then return v end
    if kind=="number"then
        if v~=v or math.abs(v)==math.huge then return tostring(v)end
        return v
    end
    if kind=="Vector3"then return {kind=kind,x=v.X,y=v.Y,z=v.Z}end
    if kind=="Vector2"then return {kind=kind,x=v.X,y=v.Y}end
    if kind=="CFrame"then return {kind=kind,components={v:GetComponents()}}end
    if kind=="Color3"then return {kind=kind,r=v.R,g=v.G,b=v.B}end
    if kind=="Instance"then return {kind=kind,path=path(v),className=v.ClassName}end
    return {kind=kind,text=tostring(v)}
end
local function attributes(object)
    local ok,list=pcall(object.GetAttributes,object)
    local out={}
    if ok then for key,v in pairs(list)do out[key]=value(v)end end
    return out
end
local function describe(object)
    local out={name=object.Name,className=object.ClassName,path=path(object),attributes=attributes(object)}
    if object:IsA("Model")then
        local ok,pivot=pcall(object.GetPivot,object)
        if ok then out.pivot=value(pivot)end
        local primary=read(object,"PrimaryPart")
        if primary then out.primaryPart=path(primary)end
    elseif object:IsA("BasePart")then
        out.position=value(object.Position);out.cframe=value(object.CFrame);out.size=value(object.Size)
        out.anchored=object.Anchored;out.canCollide=object.CanCollide
    elseif object:IsA("Attachment")then
        out.worldPosition=value(object.WorldPosition);out.worldCFrame=value(object.WorldCFrame)
    elseif object:IsA("ProximityPrompt")then
        for _,key in ipairs({"Enabled","MaxActivationDistance","HoldDuration","RequiresLineOfSight",
            "ActionText","ObjectText","KeyboardKeyCode","GamepadKeyCode","Style"})do out[key]=value(read(object,key))end
        local parent=object.Parent
        if parent then
            out.parentPath=path(parent)
            if parent:IsA("Attachment")then out.position=value(parent.WorldPosition)
            elseif parent:IsA("BasePart")then out.position=value(parent.Position)
            elseif parent:IsA("Model")then
                local ok,pivot=pcall(parent.GetPivot,parent);if ok then out.position=value(pivot.Position)end
            end
        end
    end
    return out
end
local function playerState()
    local character=player.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    return {attributes=attributes(player),carriedEggId=value(player:GetAttribute("CarriedEggId")),
        position=root and value(root.Position)or nil,character=character and path(character)or nil}
end
local function event(kind,detail)
    if not active then return end
    if #report.events>=eventLimit then table.remove(report.events,1);report.droppedEvents+=1 end
    report.events[#report.events+1]={t=os.clock()-started,kind=kind,detail=detail,player=playerState()}
end
local function snapshot(reason)
    local out={reason=reason,t=os.clock()-started,player=playerState(),roots={},nodes={},truncated=false}
    local seen={}
    local function add(object)
        if seen[object]then return end
        seen[object]=true
        if object:IsA("Model")or object:IsA("BasePart")or object:IsA("Attachment")or object:IsA("ProximityPrompt")then
            if #out.nodes>=nodeLimit then out.truncated=true;return end
            out.nodes[#out.nodes+1]=describe(object)
        end
    end
    local function tree(root)
        if not root then return end
        out.roots[#out.roots+1]=path(root);add(root)
        local ok,list=pcall(root.GetDescendants,root)
        if ok then
            for i,node in ipairs(list)do
                add(node)
                if i%1000==0 then task.wait()end
                if out.truncated then break end
            end
        end
    end
    local runtime=workspace:FindFirstChild("EggRuntime")
    if runtime then
        tree(runtime:FindFirstChild("WildEggs"));tree(runtime:FindFirstChild("DroppedEggs"))
    end
    -- Also include deposit/hatch prompts and their containing models, so the
    -- return point and owner's attributes can be inspected alongside pickups.
    local ok,list=pcall(workspace.GetDescendants,workspace)
    if ok then
        for i,node in ipairs(list)do
            if node:IsA("ProximityPrompt")and(node.Name=="TakeSeaEgg"or node.Name=="DepositSeaEgg"or node.Name=="HatchEggPrompt")then
                local model=node:FindFirstAncestorOfClass("Model")
                if model and not seen[model]then tree(model)else add(node);if node.Parent then add(node.Parent)end end
            end
            if i%2000==0 then task.wait()end
            if out.truncated then break end
        end
    end
    if #report.snapshots>=4 then table.remove(report.snapshots,2)end -- Preserve initial state.
    report.snapshots[#report.snapshots+1]=out
end
local lastJson
local function save(printFallback)
    report.elapsedSeconds=os.clock()-started;report.active=active;report.player=playerState()
    local ok,json=pcall(http.JSONEncode,http,report)
    if not ok then warn("[DEVIL DUMP] JSON encoding failed: "..tostring(json));return end
    lastJson=json
    if type(writefile)=="function"then
        local written,err=pcall(writefile,filename,json)
        if not written then warn("[DEVIL DUMP] Save failed: "..tostring(err))end
        if written then return end
    end
    if printFallback then
        print("DEVIL AQUA EGG JSON BEGIN")
        for i=1,#json,12000 do print(json:sub(i,i+11999))end
        print("DEVIL AQUA EGG JSON END")
    end
end
local function watch(signal,fn)
    local ok,link=pcall(function()return signal:Connect(fn)end)
    if ok then links[#links+1]=link else report.errors[#report.errors+1]=tostring(link)end
end
local controller={}
local snapshotBusy=false
local snapshotPending
local function requestSnapshot(reason)
    snapshotPending=reason
    if snapshotBusy then return end
    snapshotBusy=true
    task.spawn(function()
        while snapshotPending do
            local why=snapshotPending;snapshotPending=nil
            local ok,err=pcall(snapshot,why)
            if not ok then report.errors[#report.errors+1]=tostring(err)end
            save(false)
        end
        snapshotBusy=false
        if not active then save(true)end
    end)
end
function controller.Stop()
    if not active then return end
    event("stop",{})
    active=false
    for _,link in ipairs(links)do pcall(link.Disconnect,link)end
    table.clear(links)
    requestSnapshot("final")
    if scope.DevilAquaEggDump==controller then scope.DevilAquaEggDump=nil end
    print("[DEVIL DUMP] Stopped; output: "..filename)
end
function controller.Export()save(true);return lastJson end
scope.DevilAquaEggDump=controller
watch(player:GetAttributeChangedSignal("CarriedEggId"),function()
    event("carriedEggIdChanged",{})
    requestSnapshot("carriedEggIdChanged")
    task.delay(.3,function()if active then requestSnapshot("afterPickupReplication")end end)
end)
local ok,prompts=pcall(game.GetService,game,"ProximityPromptService")
if ok then
    local function relevant(prompt)
        return prompt and(prompt.Name=="TakeSeaEgg"or prompt.Name=="DepositSeaEgg"or prompt.Name=="HatchEggPrompt")
    end
    watch(prompts.PromptShown,function(prompt)
        if active and relevant(prompt)then event("promptShown",describe(prompt));save(false)end
    end)
    watch(prompts.PromptTriggered,function(prompt,who)
        if active and relevant(prompt)and(who==nil or who==player)then
            event("promptTriggered",describe(prompt));requestSnapshot("promptTriggered")
        end
    end)
else report.errors[#report.errors+1]=tostring(prompts)end
event("start",{})
requestSnapshot("initial")
task.spawn(function()
    while active do
        task.wait(10)
        if active then event("sample",{});save(false)end
    end
end)
task.delay(180,function()if active then controller.Stop()end end)
print("[DEVIL DUMP] Recording for 180 seconds. Collect one egg and deposit it. Run again to stop/export.")
print("[DEVIL DUMP] Output: "..filename.." in your executor's files folder.")
return controller
