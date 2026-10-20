-- Optional immutable-file cache. Every cached/downloaded byte is checked before compilation.
return function(url,size,expected,filename)
    local started=os.clock();local info={CacheHit=false,Yields=0}
    local function valid(source)
        if type(source)~="string"or #source~=size then return false end
        local checksum=0;local slice=os.clock()
        for i=1,#source do
            checksum=(checksum*33+source:byte(i))%4294967296
            if i%8192==0 and task and type(task.wait)=="function"and os.clock()-slice>=.006 then
                info.Yields+=1;task.wait();slice=os.clock()
            end
        end
        return checksum==expected
    end
    if type(readfile)=="function"and type(isfile)=="function"then
        local ok,source=pcall(function()if isfile(filename)then return readfile(filename)end end)
        if ok and valid(source)then info.CacheHit=true;info.Seconds=os.clock()-started;return source,info end
    end
    local source=game:HttpGet(url)
    assert(valid(source),"Pinned script download checksum mismatch or unexpected size")
    if type(writefile)=="function"then pcall(writefile,filename,source)end
    info.Seconds=os.clock()-started
    return source,info
end
