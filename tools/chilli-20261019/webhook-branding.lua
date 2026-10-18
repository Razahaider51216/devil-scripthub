-- Brand only Discord webhook payloads, preserving the configured destination.
-- Request APIs live in this runtime's environment; executor globals are untouched.
return function(run,host)
    local http=game:GetService("HttpService")
    local logo="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"
    local function rebrand(value)
        if type(value)~="string"then return value end
        return (value:gsub("[Cc][Hh][Ii][Ll][Ll][Ii]%s*[Hh][Uu][Bb]","DEVIL HUB"):gsub("%f[%a][Cc][Hh][Ii][Ll][Ll][Ii]%f[%A]","DEVIL HUB"):gsub("[Vv][Ee][Nn][Yy][Xx]","DEVIL HUB"))
    end
    local function discord(url)
        if type(url)~="string"then return false end
        local hostname,path=url:match("^https://([^/]+)(/[^?#]*)")
        if not hostname then return false end
        hostname=hostname:lower()
        return (hostname=="discord.com"or hostname=="discordapp.com"or hostname=="canary.discord.com"or hostname=="ptb.discord.com")
            and (path:match("^/api/webhooks/")~=nil or path:match("^/api/v%d+/webhooks/")~=nil)
    end
    local function wrap(request)
        if type(request)~="function"then return request end
        return function(options,...)
            if type(options)~="table"or not discord(options.Url or options.URL or options.url)then return request(options,...)end
            local bodyKey=options.Body~=nil and "Body"or options.body~=nil and "body"or nil
            if not bodyKey or type(options[bodyKey])~="string"then return request(options,...)end
            local ok,body=pcall(http.JSONDecode,http,options[bodyKey])
            if not ok or type(body)~="table"then return request(options,...)end
            body.username="DEVIL HUB";body.avatar_url=logo
            body.content=rebrand(body.content)
            if type(body.embeds)=="table"then for _,embed in ipairs(body.embeds)do
                if type(embed)=="table"then
                    embed.title=rebrand(embed.title);embed.description=rebrand(embed.description)
                    if type(embed.author)=="table"then embed.author.name="DEVIL HUB";embed.author.icon_url=logo end
                    if type(embed.footer)=="table"then embed.footer.text=rebrand(embed.footer.text);embed.footer.icon_url=logo end
                    if type(embed.fields)=="table"then for _,field in ipairs(embed.fields)do
                        if type(field)=="table"then field.name=rebrand(field.name);field.value=rebrand(field.value)end
                    end end
                end
            end end
            local encoded,result=pcall(http.JSONEncode,http,body)
            if not encoded then return request(options,...)end
            local copy=table.clone(options);copy[bodyKey]=result
            -- Encoded JSON changes byte length; let the executor recompute it.
            for _,key in ipairs({"Headers","headers"})do if type(copy[key])=="table"then
                copy[key]=table.clone(copy[key])
                for name in pairs(copy[key])do if tostring(name):lower()=="content-length"then copy[key][name]=nil end end
            end end
            return request(copy,...)
        end
    end
    local scope=setmetatable({},{__index=host})
    for _,name in ipairs({"request","http_request","httprequest"})do scope[name]=wrap(host[name])end
    for _,name in ipairs({"syn","http","fluxus"})do if type(host[name])=="table"then
        scope[name]=table.clone(host[name]);scope[name].request=wrap(host[name].request)
    end end
    scope._G=scope
    scope.loadstring=function(source,label)
        local fn,err=host.loadstring(source,label)
        if fn then host.setfenv(fn,scope)end
        return fn,err
    end
    scope.getfenv=function(subject)
        if subject==0 then return scope end
        if type(subject)=="function"then return host.getfenv(subject)end
        return host.getfenv((subject or 1)+1)
    end
    host.setfenv(run,scope)
    return run
end
