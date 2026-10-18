from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent

def literal(text):
    eq = '='
    while ']' + eq + ']' in text:
        eq += '='
    return '[' + eq + '[' + text + ']' + eq + ']'

fixture = r'''
local builtinTypeof=typeof
local typeof=function(v)if type(v)=="table"and v.__type then return v.__type end;return builtinTypeof(v)end
local Color3={fromRGB=function(r,g,b)return {__type="Color3",R=r/255,G=g/255,B=b/255}end}
local Vector2={new=function(x,y)return {X=x,Y=y}end}
local function clone(v)
 if type(v)~="table"then return v end
 local result={};for k,value in pairs(v)do result[k]=clone(value)end;return result
end
local json,serial={},0
local http={}
function http:JSONEncode(value)serial+=1;local token="json-"..serial;json[token]=clone(value);return token end
function http:JSONDecode(value)assert(json[value],"malformed JSON");return clone(json[value])end
local game={GetService=function(_,name)assert(name=="HttpService");return http end}
local files={}
local isfile=function(name)return files[name]~=nil end
local readfile=function(name)return files[name]end
local writefile=function(name,value)files[name]=value end
local configure=assert(loadstring(APPEARANCE))
setfenv(configure,setmetatable({game=game,Color3=Color3,Vector2=Vector2,typeof=typeof,isfile=isfile,readfile=readfile,writefile=writefile},{__index=getfenv(0)}))
configure=configure()
local controls={}
local group={}
local function control(config)
 controls[config.Name]=config
 return {Set=function(_,value)config.Callback(value)end}
end
group.CreateSlider=function(_,config)return control(config)end
group.ColorPicker=function(_,config)return control(config)end
group.CreateButton=function(_,config)controls[config.Name]=config end
local tab={CreateGroupbox=function(_,config)assert(config.Name=="DEVIL HUB Appearance");return group end}
local theme={Accent=Color3.fromRGB(0,140,255),Background=Color3.fromRGB(8,13,24)}
local library={Theme=theme,SetTheme=function(_,value)theme=value end}
local size
local window={SetSize=function(_,value)size=value end}
local styleCalls=0
local panels={{Native={SetStyle=function(_,value)styleCalls+=1;assert(value.StrokeColor)end}}}
local env={}
local options=configure(library,window,tab,panels,env)
assert(size.X==880 and size.Y==520)
controls['GUI Size (%)'].Callback(125)
assert(size.X==1100 and size.Y==650)
local red=Color3.fromRGB(255,0,0)
controls['Accent Color'].Callback(red)
assert(theme.Accent==red and styleCalls>=3)
local black=Color3.fromRGB(0,0,0)
controls['Background Color'].Callback(black)
assert(theme.Background==black and env.DevilChilliAppearance.Accent[1]==255)
options=configure(library,window,tab,{},env)
assert(options.Scale==125 and options.Accent.R==1 and options.Background.R==0)
controls['Reset Appearance'].Callback()
assert(size.X==880 and size.Y==520)
files['DevilHub-StealAnEgg-appearance.json']='broken'
assert(configure(library,window,tab,{},env).Scale==100)
print('PASS appearance: visible window resizing, colors, native panels, save/reload, reset, corrupt-file fallback')

local install=assert(loadstring(WEBHOOK))
setfenv(install,setmetatable({game=game},{__index=getfenv(0)}));install=install()
local received,calls
calls=0
local function transport(options,...)calls+=1;received=options;return 'sent',... end
local host=setmetatable({request=transport,http_request=transport,httprequest=transport,
 syn={request=transport,untouched=true},http={request=transport},fluxus={request=transport}}, {__index=getfenv(0)})
local lookup=install()
local run=lookup('request',host.request)
local originalBody={username='Chilli Hub',avatar_url='old',content='Venyx update',embeds={{title='Chilli Hub Egg Stolen',
 author={name='Venyx'},footer={text='Sent by Chilli Hub'},fields={{name='Chilli Hub',value='Venyx'}}}}}
local original={Url='https://discord.com/api/webhooks/123/fake-token',Method='POST',Body=http:JSONEncode(originalBody),
 Headers={['Content-Length']='1',['Content-Type']='application/json',Authorization='kept'}}
local result,arg=run(original,'sentinel')
assert(result=='sent'and arg=='sentinel'and calls==1 and received~=original)
assert(received.Url==original.Url and received.Method==original.Method and received.Headers.Authorization=='kept')
assert(received.Headers['Content-Length']==nil and original.Headers['Content-Length']=='1')
local body=http:JSONDecode(received.Body)
assert(body.username=='DEVIL HUB' and body.content=='DEVIL HUB update' and body.embeds[1].author.name=='DEVIL HUB')
assert(body.embeds[1].title=='DEVIL HUB Egg Stolen' and body.embeds[1].footer.text=='Sent by DEVIL HUB')
assert(body.embeds[1].fields[1].value=='DEVIL HUB' and originalBody.username=='Chilli Hub')
assert(host.request==transport and host.syn.request==transport)
for _,url in ipairs({'https://example.com/api/webhooks/a/b','https://discord.com.evil.test/api/webhooks/a/b','https://discord.com/api/users/@me'})do
 local options={Url=url,Body=original.Body};run(options);assert(received==options)
end
local malformed={Url=original.Url,Body='broken'};run(malformed);assert(received==malformed)
for _,alias in ipairs({'http_request','httprequest','syn.request','http.request','fluxus.request'})do
 local namespace,method=alias:match('^(%w+)%.(%w+)$')
 local fn=namespace and lookup(namespace,host[namespace])[method]or lookup(alias,host[alias])
 fn(original);assert(http:JSONDecode(received.Body).username=='DEVIL HUB')
end
assert(lookup('getfenv',getfenv)==getfenv and lookup('setfenv',setfenv)==setfenv)
assert(lookup('loadstring',loadstring)==loadstring and lookup('_G',getfenv(0))==getfenv(0))
assert(lookup('request',host.request)==run and lookup('syn',host.syn)==lookup('syn',host.syn))
assert(debug.info(lookup('getfenv',getfenv),'s')==debug.info(getfenv,'s'))
print('PASS webhook: sender/embed branding, unchanged destination, aliases/native compiler identity, headers, returns, non-webhook/malformed passthrough, no executor-global mutation')
'''
fixture = fixture.replace('APPEARANCE', literal((here / 'appearance.lua').read_text(encoding='utf-8')))
fixture = fixture.replace('WEBHOOK', literal((here / 'webhook-branding.lua').read_text(encoding='utf-8')))
path = here / 'test-customization.generated.luau'
path.write_text(fixture, encoding='utf-8')
subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)], check=True)
