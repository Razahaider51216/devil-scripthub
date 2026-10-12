-- DEVIL HUB / Ride native encoded entry; no added startup VM.
local function decode(value)
    local seed,checksum,size,text=value:match("^(%d+):(%d+):(%d+):(.+)$")
    assert(seed,"Invalid DEVIL HUB payload")
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup={}
    for i=1,64 do lookup[alphabet:byte(i)]=i-1 end
    local pieces,chunk={},{}
    local state,previous,actual=tonumber(seed),tonumber(seed)%256,0
    local count=0
    local function emit(byte)
        state=state*48271%2147483647
        local decoded=(byte-state%256-previous)%256
        previous=byte;actual=(actual*33+decoded)%4294967296
        chunk[#chunk+1]=string.char(decoded);count+=1
        if #chunk==4096 then pieces[#pieces+1]=table.concat(chunk);table.clear(chunk)end
    end
    for i=1,#text,4 do
        local a,b,c,d=text:byte(i,i+3)
        assert(lookup[a]~=nil and lookup[b]~=nil,"Invalid payload encoding")
        local number=lookup[a]*262144+lookup[b]*4096+(lookup[c]or 0)*64+(lookup[d]or 0)
        emit(math.floor(number/65536)%256)
        if c~=61 then assert(lookup[c]~=nil);emit(math.floor(number/256)%256)end
        if d~=61 then assert(lookup[d]~=nil);emit(number%256)end
        if i%32768==1 and task and task.wait then task.wait()end
    end
    if #chunk>0 then pieces[#pieces+1]=table.concat(chunk)end
    assert(count==tonumber(size)and actual==tonumber(checksum),"DEVIL HUB payload integrity failed")
    return table.concat(pieces)
end

local run,err=loadstring(decode("1132843801:2470722336:248:85b6BJHOTKPmjo8bDu63CG/sWK39tA0IBOabHUhj6kVyYl191/jubzvQtk63sD9ntQScIDUeGh2kSOKJhvMc6TaHwqdCIw9sn0CJ/U39wuALTbEGlxYISnbuTC8DKnYgAAKlgrmDdbp9zgbamkIDQL0JLvd9jEniBvMgDTW94oLbVJrog4UN3yDe/LBsQFO6BP0Fmt+arZke5q635jTpgf2I65yJe3jUA5mBcAVWvTDAFCCJRmhxlD6OyFkg8yyKbdbn3QZ1fb9eToUOuLepCCsCd0QvqbgpCDEj7K7ZQs1sp7Yn2Wyz0ywT6hYLSHWNUBPt6a6iMcc="),"DEVIL HUB / native ride-a-pet-delta.lua")
assert(run,err)
return run(...)
