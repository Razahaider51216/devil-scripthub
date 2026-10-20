-- Yield only after a CPU budget is spent; avoid one forced frame per block.
local devilSliceClock=os.clock
local devilSliceAt=devilSliceClock()
local function devilStartupSlice()
    if task and type(task.wait)=="function"and devilSliceClock()-devilSliceAt>=.006 then
        task.wait();devilSliceAt=devilSliceClock()
    end
end
