-- BEGIN DEVIL STEAL REJOIN MIGRATION
if selected.File=="devil-steal-an-egg.lua"then
    -- Cancel an already-queued legacy Chilli payload even if this GUI is running.
    pcall(function()
        game:GetService("TeleportService"):SetTeleportSetting("__ChilliAutoLoadScriptEnabled",false)
    end)
end
-- END DEVIL STEAL REJOIN MIGRATION
