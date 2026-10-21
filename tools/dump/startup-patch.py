"""Narrow startup-only changes; explicit player and profile controls are retained."""
DELAYED_APPLY='''	decoded_local_119[24] = script_env.task
	decoded_local_119[23] = decoded_local_119[24].delay
	decoded_local_119[25] = bind_handler(handlers[60899949], { decoded_local_118[11], decoded_local_118[12] })
	decoded_local_119[23](0.5, decoded_local_119[25])'''
NO_DELAY='    -- Character actions are explicit; do not schedule a startup apply.'
OLD_DEFAULT='\tdecoded_local_119[27] = decoded_local_119[28] ~= false\n\tdecoded_local_119[25].value = decoded_local_119[27]\n\tdecoded_local_119[25].flag = "AntiAFK"'
NEW_DEFAULT=OLD_DEFAULT.replace('~= false','== true')
WINDOW='''        local window=result[1]
        oldWindows[#oldWindows+1]=window'''
PASSIVE_WINDOW='''        local window=result[1]
        -- Rayfield's own Show() has two independent automatic profile loaders.
        -- Keep explicit Load controls, but never replay saved actions on reveal.
        window._autoLoaded=true
        window._autoLoadedNamed=true
        if window.configuration then window.configuration.autoLoad=false end
        oldWindows[#oldWindows+1]=window'''
CHANGES=[(DELAYED_APPLY,NO_DELAY),(OLD_DEFAULT,NEW_DEFAULT),(WINDOW,PASSIVE_WINDOW)]
def apply(source):
    for old,new in CHANGES:
        assert source.count(old)==1,'Startup patch anchor missing or ambiguous'
        source=source.replace(old,new,1)
    return source
def restore(source):
    for old,new in reversed(CHANGES):
        assert source.count(new)==1,'Startup restore anchor missing or ambiguous'
        source=source.replace(new,old,1)
    return source
