local V={}
local mt={__add=function(a,b)return V.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end,
    __sub=function(a,b)return V.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end,
    __mul=function(a,b)return V.new(a.X*b,a.Y*b,a.Z*b)end}
mt.__index=function(v,k)if k=="Magnitude"then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)end end
function V.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},mt)end
local Vector3=V
local eggConfig={HitRange=8}
local eggTargeting={}
local function point(m)return m and m.Position end
local function part(center,size,kind)
    local cf={PointToObjectSpace=function(_,p)return p-center end,PointToWorldSpace=function(_,p)return p+center end}
    return {Position=center,CFrame=cf,Size=size,IsA=function(_,name)return name==(kind or "BasePart")end,
        GetBoundingBox=function()return cf,size end}
end
local api={}
-- FUNCTIONS
local root={Position=V.new(100,0,100)}
local giant=part(V.new(0,0,0),V.new(200,200,200))
eggTargeting.SurfaceDistance=function(m,p)return math.max(0,(p-m.Position).Magnitude-100)end
local destination,distance=eggApproach(giant,root,false)
assert(distance>40 and distance<42,"giant mesh must use actual surface, not its bounding box")
assert(eggHitDistance(giant,destination)<=5.00001,"destination must be inside actual hit reach")
assert((destination-root.Position).Magnitude>30,"walk must advance beyond oversized mesh bounds")
local closer=eggApproach(giant,root,true)
assert(eggHitDistance(giant,closer)<eggHitDistance(giant,destination),"recovery must move closer")
local raised=part(V.new(0,100,0),V.new(200,200,200))
root.Position=V.new(90,3,0)
destination,distance=eggApproach(raised,root,false)
assert(destination.Y==3 and eggHitDistance(raised,destination)<=5.00001,"giant raised egg remains reachable at walking height")
root.Position=V.new(102,0,0)
assert(eggApproach(giant,root,false)==root.Position,"already within reach must stay still")
eggTargeting.SurfaceDistance=function()error("missing metric")end
local small=part(V.new(0,0,0),V.new(4,4,4));root.Position=V.new(20,0,0)
destination,distance=eggApproach(small,root,false)
assert(distance==18 and surfaceDistance(small,destination)<=5.00001,"fallback part bounds")
local model=part(V.new(0,0,0),V.new(100,100,100),"Model")
destination,distance=eggApproach(model,root,false)
assert(distance==0,"model bounds and inside case")
for input,expected in pairs({["1k"]=1e3,["10T"]=1e13,["100T"]=1e14,["1.5t"]=1.5e12,["$ 1,000 K/s"]=1e6,["2Qa"]=2e15,["0"]=0})do
    local value=parseIncome(input)
    assert(value==expected,"income input: "..input)
    assert(parseIncome(formatIncome(value))==expected,"display threshold roundtrip: "..input)
end
for _,input in ipairs({"-1T","10TT","1..2k","inf","NaN","1e999",""})do assert(parseIncome(input)==nil,"invalid input: "..input)end
assert(formatIncome(1e13)=="10T"and formatIncome(1e14)=="100T"and formatIncome(1e3)=="1k")
print("PASS giant mesh / raised egg / recovery / close range / fallback / model / suffixes / invalid values / threshold roundtrip")
