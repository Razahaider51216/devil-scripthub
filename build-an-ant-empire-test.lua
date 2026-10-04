-- Build An Ant Empire test entry: unmodified public Ouroboros revision.
-- Keeps the upstream GUI and gameplay; separate from the three-game Devil Hub.
local env=type(getgenv)=="function"and getgenv()or _G
assert(game.PlaceId==78490532994307 or game.GameId==10436530264,"Open Build An Ant Empire first.")
assert(type(loadstring)=="function","Executor loadstring support is required.")
if env.DevilAntStarting or env.DevilAntRunning then
    warn("[DEVIL HUB / ANT TEST] Already started. Rejoin before running again.")
    return
end
env.DevilAntStarting=true
local args=table.pack(...)
local ok,result=xpcall(function()
    if not game:IsLoaded()then game.Loaded:Wait()end
    local url="https://raw.githubusercontent.com/joustingmatch/Ouroboros/c9624e9671239c7fbe832a480d2773ebfd3b4c5d/games/ea8fxc.luau"
    local source=game:HttpGet(url)
    assert(type(source)=="string"and #source>1000,"Game script download was empty or incomplete.")
    local run,err=loadstring(source,"Ouroboros / Build An Ant Empire test")
    assert(run,err)
    return run(table.unpack(args,1,args.n))
end,function(err)return tostring(err)end)
env.DevilAntStarting=false
if not ok then
    warn("[DEVIL HUB / ANT TEST] "..tostring(result).." Rejoin if the game GUI opened partially.")
    error(result,0)
end
env.DevilAntRunning=true
return result
