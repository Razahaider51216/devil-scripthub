-- Local, account/map-specific configuration. No remote storage or executable data.
return function(core,ctx)
    local cfg=core.Config
    local function copy(value)
        if type(value)~="table"then return value end
        local out={};for k,v in pairs(value)do out[k]=copy(v)end;return out
    end
    local defaults=copy(cfg);local jobs={}
    for _,name in ipairs(core.Jobs)do jobs[name]=true end
    local userId,placeId=tonumber(ctx.UserId),tonumber(ctx.PlaceId)
    local identity=userId and userId>0 and placeId and placeId>0
    local file=identity and("DevilHub-AnimeDice-"..userId.."-"..placeId..".json")or nil
    local http=game:GetService("HttpService")
    local api={Report={Status="No saved settings loaded yet.",File=file},Restored=false}
    core.Report.SavedSettings=api.Report
    local function report(ok,message,detail)
        api.Report.Status=message;api.Report.Error=detail and tostring(detail)or nil
        return ok,message
    end
    local function values(input)
        assert(type(input)=="table","Invalid settings values")
        local result=copy(defaults)
        for key,default in pairs(defaults)do
            local value=input[key]
            if value~=nil then
                local kind=type(default)
                assert(type(value)==kind,"Invalid setting type: "..key)
                if kind=="number"then
                    assert(value==value and value>=0 and value<math.huge,"Invalid number: "..key)
                elseif kind=="string"then
                    assert(#value<=4096,"Setting too long: "..key)
                elseif kind=="table"then
                    local count=0
                    for k,v in pairs(value)do
                        count+=1;assert(count<=4096,"Too many selections: "..key)
                        if key=="CodeList"then
                            assert(type(k)=="number"and k>=1 and k%1==0 and k<=#value and type(v)=="string"and #v<=4096,"Invalid code list")
                        else
                            assert(type(k)=="string"and #k<=4096 and type(v)=="boolean","Invalid selection: "..key)
                        end
                    end
                    if key=="CodeList"then assert(count==#value,"Invalid code list")end
                end
                result[key]=copy(value)
            end
        end
        return result
    end
    local function write(input)
        if not file then return report(false,"Waiting for player identity.")end
        if type(writefile)~="function"then return report(false,"Saving unavailable on this executor.")end
        local ok,err=pcall(function()
            local text=http:JSONEncode({Schema=1,UserId=userId,PlaceId=placeId,Values=values(input)})
            assert(#text<=1048576,"Settings file too large")
            writefile(file,text)
        end)
        if not ok then return report(false,"Settings could not be saved.",err)end
        return report(true,"Settings saved. They will load next run.")
    end
    local function apply(input,afterValues,reset)
        if not ctx.Ready and not reset then return report(false,"Waiting for game data.")end
        local ok,err=pcall(function()
            core.StopAll()
            for key,value in pairs(input)do if not jobs[key]then cfg[key]=copy(value)end end
            if afterValues then afterValues()end
            for _,name in ipairs(core.Jobs)do core.Set(name,input[name]==true)end
            api.Restored=true
        end)
        if not ok then return report(false,"Settings could not be applied.",err)end
        return report(true,"Saved settings loaded.")
    end
    function api.Save()return write(cfg)end
    function api.Load(afterValues)
        if not ctx.Ready or type(ctx.Snapshot)=="function"and not ctx.Snapshot()then return report(false,"Waiting for game data.")end
        if not file then return report(false,"Waiting for player identity.")end
        if type(readfile)~="function"then return report(false,"Loading unavailable on this executor.")end
        if type(isfile)=="function"then
            local ok,exists=pcall(isfile,file)
            if ok and not exists then return report(false,"No saved settings found.")end
        end
        local ok,input=pcall(function()
            local text=readfile(file)
            assert(type(text)=="string"and #text<=1048576,"Invalid settings file")
            local saved=http:JSONDecode(text)
            assert(type(saved)=="table"and saved.Schema==1,"Unknown settings format")
            assert(saved.UserId==userId and saved.PlaceId==placeId,"Settings belong to another player or map")
            return values(saved.Values)
        end)
        if not ok then return report(false,"Saved settings could not be read.",input)end
        return apply(input,afterValues)
    end
    function api.Reset(afterValues)
        local ok,message=write(defaults)
        if not ok then return ok,message end
        ok,message=apply(copy(defaults),afterValues,true)
        if not ok then return ok,message end
        return report(true,"Saved settings reset.")
    end
    return api
end
