from pathlib import Path
import re, subprocess

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
def literal(text):
    eq='='
    while ']'+eq+']' in text: eq+='='
    return '['+eq+'['+text+']'+eq+']'

fixture = 'local helperSource='+literal((here/'pinned-source.lua').read_text(encoding='utf-8'))+'\n'
fixture += r'''
local checks=0
local function check(value,message)checks+=1;assert(value,message)end
local source=string.rep('verified-source-',8192)
local sum=0;for i=1,#source do sum=(sum*33+source:byte(i))%4294967296 end
local function setup(files,body,broken)
 local downloads,writes,waits,ticks=0,0,0,0
 local host=setmetatable({game={HttpGet=function(_,url)check(url=='immutable','wrong source URL');downloads+=1;return body or source end},
  os={clock=function()ticks+=.007;return ticks end},task={wait=function()waits+=1 end}},{__index=getfenv(0)})
 if files then
  host.isfile=function(name)return files[name]~=nil end
  host.readfile=function(name)if broken=='read'then error('denied')end;return files[name]end
  host.writefile=function(name,value)if broken=='write'then error('denied')end;writes+=1;files[name]=value end
 end
 local run=assert(loadstring(helperSource));setfenv(run,host)
 return run(),function()return downloads,writes,waits end
end
do
 local files={};local load,counts=setup(files)
 local body,info=load('immutable',#source,sum,'cache')
 check(body==source and not info.CacheHit and counts()==1,'cold cache did not download validated source')
 check(files.cache==source and info.Yields>0,'validated cold source not cached / checksum monopolized CPU')
 body,info=load('immutable',#source,sum,'cache')
 check(body==source and info.CacheHit and counts()==1,'warm cache downloaded source again')
 files.cache='X'..source:sub(2)
 body,info=load('immutable',#source,sum,'cache')
 check(not info.CacheHit and body==source and counts()==2 and files.cache==source,'poisoned same-size cache reached execution / was not replaced')
end
for _,mode in ipairs({'read','write','none'})do
 local load,counts=setup(mode~='none'and{cache=source}or nil,nil,mode)
 local body=load('immutable',#source,sum,'cache')
 check(body==source,'optional file API failure blocked startup: '..mode)
end
for _,body in ipairs({'<html>error</html>','X'..source:sub(2)})do
 local files={};local load=setup(files,body)
 check(not pcall(load,'immutable',#source,sum,'cache')and files.cache==nil,'corrupt download cached / accepted')
end
print('PASS verified startup cache: cold/warm/poisoned files, failed APIs, bad downloads and checksum slicing: '..checks..' checks')
'''
path=here/'startup-cache.generated.luau';path.write_text(fixture,encoding='utf-8',newline='\n')
subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(path)],check=True)

# Execute the actual public decompressor with inert compilation; never run the game VM.
public=(root/'devil-chilli-native-ui-runtime.lua').read_text(encoding='utf-8')
native=(here/'native-layer.generated.luau').read_text(encoding='utf-8')
fixture='local expected='+literal(native)+'\n'
fixture+=r'''
local slices,tick,compiled=0,0,0
local os={clock=function()tick+=.007;return tick end}
local task={wait=function()slices+=1 end}
local function capture(source)
 compiled+=1;assert(source==expected,'cooperative decoder changed native source')
 return function(data)
  assert(buffer.len(data)==368215,'cooperative decoder changed game data size')
  return function()return 'inert' end
 end
end
local function execute(...)
'''+public.replace('[76]=loadstring','[76]=capture',1)+r'''
end
assert(execute()=='inert'and compiled==1 and slices>10,'actual decoder failed to yield / entered game VM')
print('PASS actual cooperative decompressor: exact native output, inert game boundary, '..slices..' budget checkpoints yielded')
'''
path=here/'startup-decode.generated.luau';path.write_text(fixture,encoding='utf-8',newline='\n')
subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(path)],check=True,timeout=30)
