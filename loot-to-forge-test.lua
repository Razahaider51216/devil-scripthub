-- Loot to Forge test entry. Runs the unmodified public Ouroboros script.
-- The upstream GUI is retained. This is separate from Devil Hub production.
local env=type(getgenv)=="function"and getgenv()or _G
assert(game.PlaceId==118805555015549 or game.GameId==10684750879,"Open Loot to Forge first.")
assert(not env.DevilLootStarting and not env.DevilLootRunning,"Already started. Rejoin before running again.")
assert(type(loadstring)=="function","Executor loadstring support is required.")
local variant=(...)or "latest"
assert(variant=="latest"or variant=="legacy","Unknown test version.")
local versions={
    latest="c8c823473a8440cd1cd426b47d0edb1ec1ec80af",
    legacy="66b31d4f88fd27bf5d0150f9169acf43cbdd1281",
}
env.DevilLootStarting=true
local ok,result=xpcall(function()
    print("[LOOT TO FORGE] Downloading "..variant.." original script...")
    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/"..versions[variant].."/games/3s0ixi.luau")
    assert(type(source)=="string"and #source>10000,"Empty or invalid script download.")
    local run,err=loadstring(source,"Loot to Forge / "..variant)
    assert(run,err)
    print("[LOOT TO FORGE] Starting original GUI and game functions...")
    return run()
end,function(err)return debug.traceback(tostring(err),2)end)
env.DevilLootStarting=false
if not ok then
    env.DevilLootRunning=false
    warn("[LOOT TO FORGE] Startup failed: "..tostring(result))
    error(result,0)
end
env.DevilLootRunning=true
return result
