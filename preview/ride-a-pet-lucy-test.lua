-- DEVIL HUB / Ride a Pet: upstream compatibility test, not a devirtualized port.
-- Loads the byte-identical decoded Lucy VM and data without in-game LZMA decompression. Its original frontend and callbacks are retained.
local scope=type(getgenv)=="function"and getgenv()or _G
local report={schema="devil-ride-lucy-test-1",release="lucy-test-2",
    placeId=game.PlaceId,universeId=game.GameId,frontend="Original Lucy",
    devirtualized=false,liveVerified=false,runtimeReturned=false,
    sourceCommit="cafe92b2d7b3c2d29ae55e6958a5325e0a0751c0",
    sourceSHA256="8cad0c9fcec85d264ba8a53d1cca5a073b93a2597151a35527259a75c21babc4"}
report.packaging="Predecoded VM / unchanged VM data"
report.assetsCommit="3f6692d3f01a1061b134e342bcac3ef7d416161c"
local base="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/"..report.assetsCommit.."/preview/"
local started=os.clock()
local phaseStarted=started
report.timings={}
local active=true
local filename="DevilRideLucyTest-report.json"
local function save()
    if type(writefile)~="function"then return end
    local ok,body=pcall(function()return game:GetService("HttpService"):JSONEncode(report)end)
    if ok then pcall(writefile,filename,body)end
end
local function notify(text)
    print("[DEVIL HUB / Ride a Pet test] "..text)
    pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="DEVIL HUB / Ride a Pet Test",Text=text,Duration=6})end)
end
local function fail(message)
    report.failedPhase=report.status;report.status="Failed";report.error=tostring(message);save();notify(report.error)
    error(report.error,0)
end
if game.GameId~=10035204815 and game.PlaceId~=124216119978534 then fail("Open Ride a Pet before running this test.")end
if scope.DevilRideLucyRunning or scope.DevilRideLucyLoading or scope.DevilRideLucyRequiresRejoin then
    notify("This test is already running. Rejoin before testing again.");return
end
if scope.DevilRideDeltaLoading or scope.DevilRideUnpacking or
    (scope.DevilRideLoading and scope.DevilRideLoading.Busy)or
    scope.DevilRideNativeUI or scope.DevilRideFrontend then
    fail("Rejoin and run this test first, before the main DEVIL HUB loader.")
end
report.capabilities={loadstring=type(loadstring)=="function",
    buffer=type(buffer)=="table"and type(buffer.fromstring)=="function",
    pack=type(string.pack)=="function",unpack=type(string.unpack)=="function"}
for name,available in pairs(report.capabilities)do
    if not available then fail("Executor API unavailable: "..name..". Original Lucy requires this API.")end
end
scope.DevilRideLucyLoading=true
local function phase(name)
    local now=os.clock()
    if report.status then report.timings[report.status]=now-phaseStarted end
    phaseStarted=now
    report.status=name;report.elapsed=now-started;report.phaseSeconds=0
    save();notify(name);task.wait()
end
-- This monitor can report a yielding stall; it cannot interrupt a CPU-bound VM.
if type(task.spawn)=="function" then
    task.spawn(function()
        while active do
            task.wait(15)
            if not active then break end
            report.elapsed=os.clock()-started;report.phaseSeconds=os.clock()-phaseStarted
            save()
            if report.phaseSeconds>=30 then
                notify("Still at "..tostring(report.status)..". Report: "..filename)
            end
        end
    end)
end
local function fetch(name,size)
    phase("Downloading "..name)
    local lastError
    for attempt=1,3 do
        local success,body=pcall(game.HttpGet,game,base..name)
        if success and type(body)=="string" and #body==size then return body end
        lastError=success and "Unexpected response / size"or tostring(body)
        if attempt<3 then task.wait(attempt)end
    end
    error("Download failed: "..tostring(lastError),0)
end
local function verify(source,expected)
    local checksum=0
    for first=1,#source,8192 do
        for index=first,math.min(first+8191,#source)do
            checksum=(checksum*33+string.byte(source,index))%4294967296
        end
        task.wait()
    end
    assert(checksum==expected,"Source integrity check failed; the runtime was not launched.")
end
local args=table.pack(...)
local ok,result=xpcall(function()
    local source=fetch("ride-lucy-vm.lua",85896)
    phase("Verifying VM")
    verify(source,2908996447)
    local encoded=fetch("ride-lucy-data.hex",2430460)
    phase("Decoding data")
    local bytes={}
    for i=0,255 do bytes[string.format("%02x",i)]=string.char(i)end
    local pieces={}
    for first=1,#encoded,16384 do
        local chunk=encoded:sub(first,first+16383)
        assert(not chunk:find("[^0-9a-f]"),"Invalid VM data encoding")
        pieces[#pieces+1]=chunk:gsub("..",bytes)
        task.wait()
    end
    encoded=nil
    local data=table.concat(pieces);pieces=nil
    phase("Verifying data")
    verify(data,1537378375)
    report.integrityVerified=true
    phase("Compiling VM")
    local run,problem=loadstring(source,"Luraph ")
    assert(type(run)=="function",problem or "Executor compile failed")
    source=nil
    phase("Initializing VM")
    -- From here original initialization may spawn tasks. Require a rejoin on error.
    scope.DevilRideLucyRequiresRejoin=true
    local root=run(buffer.fromstring(data));data=nil
    assert(type(root)=="function","Original VM did not return a runtime function")
    phase("Launching game runtime")
    local value=root(table.unpack(args,1,args.n))
    report.runtimeReturned=true
    phase("Returned; GUI and gameplay require in-game confirmation")
    return value
end,function(problem)
    return type(debug)=="table"and type(debug.traceback)=="function"and debug.traceback(tostring(problem),2)or tostring(problem)
end)
active=false
report.elapsed=os.clock()-started
scope.DevilRideLucyLoading=false
if not ok then fail(result)end
scope.DevilRideLucyRunning=true
save();notify("Runtime returned. Report: "..filename..". Verify the original GUI and farming in game.")
return result
