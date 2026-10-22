if selected.File=="break-and-steal-an-egg.lua"then
    if env.DevilBreakUnpacking then return end
    if env.DevilBreakActive then
        if env.DevilBreakRelease==selected.Version then return end
        assert(type(env.DevilBreakCleanup)=="function","Close the previous Break Egg session before updating")
        env.DevilBreakCleanup()
        assert(not env.DevilBreakActive,"Previous Break Egg cleanup did not finish")
    end
end
