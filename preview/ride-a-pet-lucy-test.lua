-- DEVIL HUB / Ride a Pet: upstream compatibility test, not a devirtualized port.
-- Calls the intact Lucy runtime. Its original frontend and callbacks are retained.
local scope=type(getgenv)=="function"and getgenv()or _G
local report={schema="devil-ride-lucy-test-1",release="lucy-test-1",
    placeId=game.PlaceId,universeId=game.GameId,frontend="Original Lucy",
    devirtualized=false,liveVerified=false,runtimeReturned=false,
    sourceCommit="cafe92b2d7b3c2d29ae55e6958a5325e0a0751c0",
    sourceSHA256="8cad0c9fcec85d264ba8a53d1cca5a073b93a2597151a35527259a75c21babc4"}
local url="https://raw.githubusercontent.com/SilverHub999/Utility/"..report.sourceCommit.."/Crack/Lucy%20Again"
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
    report.status="Failed";report.error=tostring(message);save();notify(report.error)
    error(report.error,0)
end
if game.GameId~=10035204815 and game.PlaceId~=124216119978534 then fail("Open Ride a Pet before running this test.")end
if scope.DevilRideLucyRunning or scope.DevilRideLucyLoading then
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
report.status="Downloading";save();notify("Downloading the latest reviewed Lucy runtime...")
local args=table.pack(...)
local ok,result=xpcall(function()
    local source,lastError
    for attempt=1,3 do
        local success,body=pcall(game.HttpGet,game,url)
        if success and type(body)=="string"and #body==889839 then source=body;break end
        lastError=success and "Unexpected source response / size"or tostring(body)
        if attempt<3 then task.wait(attempt)end
    end
    assert(source,"Download failed: "..tostring(lastError))
    local checksum=0
    for index=1,#source do checksum=(checksum*33+string.byte(source,index))%4294967296 end
    assert(checksum==3230439918,"Source integrity check failed; the runtime was not launched.")
    report.integrityVerified=true
    report.status="Compiling";save()
    local run,problem=loadstring(source,"Ride a Pet / Lucy latest")
    assert(type(run)=="function",problem or "Executor compile failed")
    report.status="Launching";save();notify("Starting Lucy. Check its GUI and game systems.")
    local value=run(table.unpack(args,1,args.n))
    report.runtimeReturned=true;report.status="Returned; GUI and gameplay require in-game confirmation"
    return value
end,function(problem)
    return type(debug)=="table"and type(debug.traceback)=="function"and debug.traceback(tostring(problem),2)or tostring(problem)
end)
scope.DevilRideLucyLoading=false
if not ok then fail(result)end
scope.DevilRideLucyRunning=true
save();notify("Runtime returned. Report: "..filename..". Verify the original GUI and farming in game.")
return result
