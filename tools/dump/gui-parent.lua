-- Keep utility UI out of the game's PlayerGui when an executor UI host exists.
local function dumpGuiParent()
    for _,helper in ipairs({gethui or false,get_hidden_gui or false})do
        if type(helper)=="function"then
            local ok,parent=pcall(helper)
            if ok and typeof(parent)=="Instance"then return parent end
        end
    end
    local ok,parent=pcall(game.GetService,game,"CoreGui")
    if ok and parent then return parent end
    local player=game:GetService("Players").LocalPlayer
    assert(player,"DEVIL DUMP: local player unavailable")
    return player:FindFirstChildOfClass("PlayerGui")or player:WaitForChild("PlayerGui")
end
