-- Language is embedded in the window; no extra settings panel is created.
return function(library,window,tab,panels,env)
    local shared=env.DevilHubBlueGui
    return shared and not shared.Stopped and shared.Get()or{}
end
