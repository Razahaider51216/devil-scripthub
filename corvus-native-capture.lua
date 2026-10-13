-- Corvus native decoding capture. Stores local trace, prototype and Path2D answers.
assert(game.PlaceId==114326934417838,"Open Break and Steal an Egg first")
assert(type(loadstring)=="function","loadstring is required")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilCorvusCaptureRunning then return end
local http=game:GetService("HttpService")
local report={release="corvus-native-capture-1",placeId=game.PlaceId,gameId=game.GameId,status="Starting",file="DevilCorvus-native.txt"}
scope.DevilCorvusCaptureReport=report
local screen=Instance.new("ScreenGui");screen.Name="DevilCorvusCapture";screen.ResetOnSpawn=false
screen.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(330,155);panel.Position=UDim2.new(.5,-165,.5,-77)
panel.BackgroundColor3=Color3.fromRGB(20,15,18);panel.Parent=screen
local label=Instance.new("TextLabel");label.Size=UDim2.new(1,-20,0,85);label.Position=UDim2.fromOffset(10,5)
label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(255,230,230);label.TextWrapped=true
label.Font=Enum.Font.Gotham;label.TextSize=16;label.Text="DEVIL HUB / Corvus\nกำลังเก็บผลถอดรหัสจาก Roblox...";label.Parent=panel
local button=Instance.new("TextButton");button.Size=UDim2.new(1,-20,0,40);button.Position=UDim2.fromOffset(10,100)
button.Text="รอผล...";button.Font=Enum.Font.Gotham;button.TextSize=16;button.Parent=panel
local raw
button.Activated:Connect(function()
    if raw and type(setclipboard)=="function"then pcall(setclipboard,raw);button.Text="คัดลอกแล้ว"end
end)
scope.DevilCorvusCaptureRunning=true
task.spawn(function()
    local ok,value=xpcall(function()
        local run,err=loadstring([==========[local __SOURCE = [==[
return({Ri=function(W,W)return W;end,GZ=function(W,W)W=64;return W;end,nZ=function(W,W,R,r)R[W]=(r);end,q=function(W,R,r)r=0x6F__84c143+(((W.Nv(W.l[0X9]+R[0X5F9e]))~=W.l[2]and R[4457]or W.l[0X9])-W.l[0X7]);R[476]=r;return r;end,kZ=function(W,W)if W[0X31]==W[27]then W[52]=0X9e/(0XeE/0B10011111);end;end,pi=function(W,R,r,Z,x)if r<0X051 and r>0x2b then R[46]=function()local A,_;A,_=W:si(R);if A~=-0b10 then else return _;end;end;if not x[21330]then(x)[0X5a89__]=(-4294939299+(W.zv(x[0x1D04]-x[0x71eF]-x[573]+x[0x5F9E],(x[16598]))));r=0x7E+((r<x[13062]and x[24478]or x[17401])-x[0X4265]+x[573]-x[29550]);x[0x5352]=(r);else r=W:ai(x,r);end;else if r<0X7c_ and r>0X3A then(R)[0X2f]=(tostring);if not x[0x2254]then r=(124+(W.Av((W.Nv(x[9834]-x[0X005A89]-W.l[0X6])),(x[9114]))));(x)[8788]=r;else r=W:Ni(x,r);end;elseif r<0B111010 and r>0X7_ then R[0X31]=function()local A,_;A,_=W:zi(R);if A==-0B10 then return _;end;end;return r,27014,Z;elseif r<0B101011 then Z=(function(...)return(...)[...];end);R[0X2D]=W.e;if not x[0X005D_Ff__]then r=(-1610612678+(W.zv((W.Av((W.Av(x[18911],(x[16598]))),(x[0X1e__3_1__])))==x[3959]and x[0X03b3e]or x[0x7682],(x[3360]))));(x)[0X5dFf]=(r);else r=W:ei(r,x);end;else if r>0X51 then(R)[48]=function()local A,_=(0B1111011);while true do if A>101 then _=R[0b10010](R[35],R[0X5]);A=0X1e;else if A<0x65 then(R)[0X5]=(R[0X5]+4);A=101;continue;else if A>0B11110 and A<0X7b then return(W:oi(_));end;end;end;end;end;if not(not x[0X29a3])then r=x[0x29a3];else r=(-0X2__B+((W.ev((W.Rv(r-x[29550],W.l[2]))))+x[0X266A]));(x)[10659]=(r);end;end;end;end;return r,nil,Z;end,PZ=function(W,W,R,r,Z)R[r+0x1]=(Z);(R)[r+0X2]=W;R[r+3]=(0X001);end,ZZ=function(W,W,R)for r=0B1,#R[0B1000],0b11 do(R[0X8][r])[R[0X8][r+0x1]]=W[R[0X8][r+0b10]];end;end,Mv=function(W,R,r,Z)R[0x1][0XD]=(R[48]);if not r[0X52__B3]then Z=(-3489660830+(W.Pv((W.zv((W.Pv((W.Jv(r[0X5DfF],(r[0XF77_]))),r[0X338b],r[3959])),(r[0XD20]))),r[23177],Z)));r[21171]=(Z);else Z=(r[21171]);end;return Z;end,IZ=function(W,W,R,r)if R then for R=64,0b1110011__,0X33_ do if R==64 then r[1][0B111]=(r[0x00a]);else r[0X1][0x4]=W;end;end;end;end,BZ=function(W,R,r,Z,x)if R==0x0d then W:lZ(x,r);else(r)[0x6]=(Z);return 59322;end;return nil;end,Rv=bit32.band,s=string.byte,Di=function(W,R,r)r=(0X27+(W.ev((W.hv((W.Rv((W.Nv(R[9114])),R[16598],R[0x5352__])))))));R[678]=r;return r;end,Wi=function(W,W)local R=W[0B110](W[0X023],W[5]);W[5]=(W[0X5]+0B1);return R;end,_Z=function(W,R,r,Z,x,A,_,X,J,t,z,Q)local o,i,O,N;J=(nil);for B=0B110_000,409,0X39 do if B==333 then J=W:fZ(J);break;elseif B==0X114__ then(Z)[0B1011]=(x);elseif B==0xdB then W:kZ(A);elseif B==162 then N=W:OZ(A,t,N);else if B==105 then O=A[0X9](t);continue;else if B==0X30 then X=A[0X009](t);continue;end;end;end;end;for B=0B1101,0B110_10111,0X7B do i=W:BZ(B,Z,X,O);if i~=59322 then else break;end;end;Z[0B1]=N;Z[0Xa]=(r);_=(nil);local B,g;z=(0X01c);while true do if z==0X35 then g=0xa0;z=0B10000;else if z==0X10 then z=W:bZ(Q,Z,z);continue;else if z==0X2__F then(Z)[2]=R;break;elseif z==0b11100 then _={};z=0x4b;continue;else if z==0X2e then B=(105);z=0B110101;continue;else if z==0x4b__ then z=0B101110;if A[0X2a]~=A[16]then else while A[46]do return _,z,-2,X,J,A[0X1];end;end;end;end;end;end;end;end;for j=0B1,t,0X1 do local t,y,e,s,F;t,F,y,s,e=W:MZ(e,F,t,y,s);local d,w,p,H;y,e,F,p,w,s,t,H,d=W:JZ(p,d,y,w,t,A,e,s,F,H);t=(nil);i,t,o=W:oZ(y,B,O,g,A,X,Z,s,p,R,t,N,r,x,e,j,d,H,w);if i==-0X001 then return _,z,-1,X,J;else if i~=-0X2 then else return _,z,-2,X,J,o;end;end;if H==4 then(R)[j]=(j+t);elseif H==0X7 then if not(A[0x39])then Q[j]=A[10][t];else W:HZ(j,Z,t,A);end;elseif H==2 then W:nZ(j,R,t);elseif H==0X3 then R[j]=j-t;else if H~=0X1 then else W:QZ(t,A,Q,j);end;end;end;return _,z,nil,X,J;end,zv=bit32.lshift,hZ=function(W,R,r,Z,x)if r~=0XBf_ then W:NZ(Z,x,R);end;end,gi=function(W,W,R)R=(0X01);W=0B1101110;return W,R;end,Vi=function(W,R,r,Z)if R~=0b110 then(Z)[0b100__1__01]=W.h;return 53529,R;else Z[0B100100]=W.ov;if not(not r[7468])then R=W:Mi(R,r);else r[30363]=-0X21EdD24+((W.hv(r[30338]>r[24184]and r[25475]or W.l[4]))+r[0X43f9]-r[0x2BB4]);R=-944311542+((W.Rv(r[573]-W.l[0x6],W.l[0X3]))+r[0XF77]+W.l[0B0011]);(r)[0X1D2C]=(R);end;return 34724,R;end;return nil,R;end,ri=function(W,R,r,Z,x,A,_,X)if not(x>0B1_11__11)then X=R/4;else if x~=0x62 then W:Zi(A,_,Z);return A,0X4b7d,X;else A={[3]=R%0B100,[0X2]=X-X%1};r[0B10101][R]=A;end;end;return A,nil,X;end,Wv=function(W,R,r)R=(-4294852726+((W.hv((W.zv(r[9834],(r[13062])))))-W.l[0x1]-r[0X5f9E]));(r)[0X1718]=(R);return R;end,ni=function(W,W,R,r)r=R[0X14](R[0B100011],R[5]);W=(0X7);return r,W;end,Si=function(W,W,R)return W-R[0X2];end,vZ=function(W,W,R,r,Z)R=0b1__00;Z=r[0B101110]();W=r[46]();return R,Z,W;end,lv=function(W,R)R[0b1][0X16]=(W.n.rrotate);end,l={53065,1842874292,910486798,4259390130,1318894386,4242792355,1870971184,3901256231,3429428795},Ov=function(W,R)(R[0B1])[0X18]=W.n.rshift;end,u=getfenv,oi=function(W,W)return W;end,D=function(W,R,r,Z)if Z==0X7b then Z=W:Y(R,Z,r);else if Z==30 then(r)[0B1011]=(2147483648);if not R[25475]then Z=(0X45+(W.Rv(((W.av(R[24478],(Z)))>=Z and W.l[0X9_]or R[16997])>=W.l[0B1]and R[11188]or W.l[0X4],W.l[8],W.l[2])));R[0X6383]=Z;else Z=W:g(R,Z);end;elseif Z==0X65 then W:i(r);return 27662,Z;else if Z~=12 then else(r)[0x9]=W.d;if not R[4224]then R[18911]=(-524032901+(W.l[0B0_1]+W.l[2]-Z+Z-W.l[0X05]));(R)[3506]=0B1111101+(W.zv((W.av((W.ev((W.Pv(W.l[6])))),(Z))),(Z)));Z=(0XCF4c+((W.zv((W.Rv(W.l[4],W.l[0B111],W.l[1])),(Z)))-W.l[0X1]+R[16997]));(R)[0X1__080]=Z;else Z=(R[4224]);end;end;end;end;return nil,Z;end,d=table.create,h=setfenv,pZ=function(W,W,R,r)r[W+1]=(R);end,mi=function(W,R,r,Z,x)R[0X37__]=(nil);(R)[0X38]=(nil);Z=(0X78);repeat if Z==0x78 then Z=W:Ti(R,Z,r);continue;elseif Z==106 then Z=W:Ci(r,Z,R);continue;else if Z==119 then x=(function()return(W:yi(R));end);if not r[2897]then(r)[19580]=(-40+((W.Pv(r[40],W.l[0B1],r[0X5E78_]))+r[24478]+r[13062]-W.l[0X1]));r[0X3dab]=(-0X5E+(r[0X28]-r[17401]+W.l[0B1]+r[16598]~=r[0x1080]and r[0XDb2]or r[4457]));Z=-524182+(W.zv((W.Nv((W.Pv(r[0X2985]-r[25475])))),(r[0x769B])));r[2897]=(Z);else Z=r[0xB_51];end;continue;else if Z~=0X41 then else(R)[0X38]=(function(r,A)local _,X=r[0X007],(r[0X5]);local J,t,z,Q,o,i,O,N=r[0X3],r[0X6],r[0B1010],r[0xB],r[0B1],r[0X2],(r[0X8_]);N=function(...)if not __PID[(r or __PID)] then __PID.n=__PID.n+1;__PID[(r or __PID)]=__PID.n;end;__ENT.n=__ENT.n+1;__ENT[__ENT.n%64]=__PID[(r or __PID)];__PLAST[__PID[(r or __PID)]]=__ENT.n;if __SKIPP[__PID[(r or __PID)]] then return end;local B,g,j,y,e=R[0X9](_),0X1,0,0X1;local _,s=R[0x37](...);local F,d,w,p,H,I=1,(R[0X26]());local h,S,D,G=R[0B101100](function()local C,b,K,M,U,m,n,c,q,k;while true do local Y=O[y];__SPIN.n=__SPIN.n+1;if __SPIN.n>=__SPIN.step then __SPIN.f()end;if not(Y<81)then if Y>=0x79__ then if not(Y>=0B100011_01)then if Y>=0x83 then if not(Y<0X88)then if not(Y<0X8A)then if Y>=0X8b then if Y==0X8C then m=(t[y]);b=(b[m]);M+=b;else F=(n);end;else n=(F);end;else if Y==0x89 then n=(Q[y]);(B)[n]=B[n](B[n+1],B[n+0B10]);F=(n);else n=n[q];q=o[y];end;end;else if Y<0X85 then if Y~=0x84 then n=Q[y];B[n](B[n+0X1],B[n+0B10]);F=n-0B001;else if not(not(B[i[y]]<B[Q[y]]))then else y=(t[y]);end;end;else if Y<134 then n=(B);q=t[y];else if Y==0X8_7 then n=A[Q[y]];(B)[t[y]]=n[0B11][n[0b10]];else if not(e)then else for l,P in e do if not(l>=1)then else P[0X3_]=(P);(P)[0X1]=(B[l]);P[0B10]=0X1;(e)[l]=(nil);end;end;end;n=Q[y];return false,n,n+t[y]-0b10;end;end;end;end;else if Y<0X7e then if Y>=0X7__b then if Y>=0X7c then if Y==0X7D then n=(t[y]);q,M,b=w();if q then B[n+0X001]=(M);(B)[n+0X002]=b;y=i[y];end;else(B)[t[y]]=(A[Q[y]][B[i[y]]]);end;else M=J[y];(n)[q]=(M);end;else if Y==0X007A then(B)[i[y]]=o[y];else F=(n);end;end;else if not(Y<0X80)then if not(Y>=0B100000_01)then n=(i[y]);F=(n+Q[y]-0B01);B[n](R[0X1D](n+0B1,F,B));F=(n-0X1);else if Y~=0B10000010 then b=(J[y]);else n=(t[y]);F=(n);end;end;else if Y==0b11__11_111_ then n=(Q[y]);B[n](B[n+0X1]);F=(n-0B1__);else n=A[t[y]];(B)[i[y]]=(n[0X3__][n[0B10_]][o[y]]);end;end;end;end;else if Y>=0X97 then if not(Y>=0B10011100)then if Y<0X99 then if Y~=0x98 then n=n[q];n();else B[Q[y]]={};end;else if Y>=0X9a then if Y~=0X9b then for l=n,q do M=(B);b=(l);l=nil;(M)[b]=l;end;else n=(Q[y]);(B)[n]=B[n](R[0x1d](n+1,F,B));F=n;end;else n=B;q=t[y];M=B;end;end;else if Y<0B10011111 then if Y>=157 then if Y==158 then(B)[i[y]]=(R[0X2d](B[t[y]],o[y]));else B[Q[y]]=(R[0X1][i[y]]);end;else if e then for l,P in e do if not(l>=0X1__)then else P[0X3]=(P);P[0X1]=(B[l]);(P)[0X2]=0x1;(e)[l]=(nil);end;end;end;return false,Q[y],F;end;else if Y<0Xa0 then B[i[y]]=B[t[y]]>B[Q[y]];else if Y~=0XA__1 then y=t[y];else n=(t[y]);(B)[n]=B[n](B[n+1]);F=(n);end;end;end;end;else if not(Y<0b10010010)then if Y>=0B10010100 then if not(Y>=0X95)then M+=b;else if Y~=0X96 then B[t[y]]=(R[0X27_](B[i[y]],B[Q[y]]));else n=A[Q[y]];(B)[t[y]]=(n[3][n[0B10]][B[i[y]]]);end;end;else if Y~=0X93 then n[q]=(M);else n=Q[y];q=(t[y]);M=(B[n]);(R[0b100100])(B,n+1,F,q+0X1,M);end;end;else if Y>=143 then if Y>=0B10010000 then if Y==145 then b=(i[y]);M=(M[b]);b=o[y];else(B)[Q[y]]=B[i[y]]+B[t[y]];end;else(B)[Q[y]]=(B);end;else if Y==0x8e then n=A[Q[y]];n[0X3][n[0X2]]=J[y];else b=(B);end;end;end;end;end;else if Y>=0X65 then if not(Y<0X6F)then if Y<0x74 then if not(Y<0x71)then if Y<0X72__ then F=(t[y]);B[F]();F-=0B1;else if Y==0B1110011 then H=({[2]=p,[0x004]=H,[1]=w,[0X3]=I});n=t[y];p=(B[n+2]+0B0);I=(B[n+0X1]+0);w=B[n]-p;y=i[y];else if not(o[y]<B[t[y]])then y=(i[y]);end;end;end;else if Y==0X70 then m=Q[y];else q=i[y];end;end;else if Y<0X76 then if Y==0b11_10101 then M=(B);b=t[y];M=(M[b]);else w=H[0X1];I=H[0X3];p=H[0X2];H=(H[0B100]);end;else if Y>=0X77 then if Y~=0B1111000 then M=(R[0B001]);else q=F;n=n[q];n();end;else B[i[y]][o[y]]=B[t[y]];end;end;end;else if Y<0X6__A then if not(Y>=103)then if Y~=0X66 then if B[Q[y]]~=z[y]then else y=i[y];end;else q=Q[y];n=(n[q]);q=z[y];end;else if Y<0X68 then if not(not(o[y]<=B[i[y]]))then else y=(t[y]);end;elseif Y~=0X69 then if B[t[y]]==B[i[y]]then y=Q[y];end;else(B[Q[y]])[B[i[y]]]=B[t[y]];end;end;else if not(Y<0B1101100)then if Y<0X6d then if not(e)then else for l,P in e do if l>=0X1 then P[0B11]=(P);P[0x1]=(B[l]);(P)[2]=(0B1_);(e)[l]=nil;end;end;end;n=i[y];return false,n,n;else if Y~=0X6E__ then n=(B);else M=B;b=i[y];M=M[b];end;end;else if Y==107 then n=F;q=(1);n-=q;else b=(z[y]);M/=b;(n)[q]=(M);end;end;end;end;else if Y>=0x5B then if Y>=96 then if Y>=0B1100010 then if not(Y<99)then if Y==100 then B[i[y]]=(Q);else n=A[i[y]];(n[0x3])[n[0X2]]=B[Q[y]];end;elseif not(B[i[y]])then else y=(t[y]);end;else if Y==0x61 then else n=(A[Q[y]]);n[0X3][n[0B10]][B[t[y]]]=B[i[y]];end;end;else if not(Y>=0B1011101)then if Y~=0X5c then(B)[i[y]]=z[y]*B[Q[y]];else local l=i[y];if not(e)then else for P,a in e do if not(P>=l)then else a[0B11]=a;a[1]=(B[P]);(a)[0X2]=0x1;e[P]=nil;end;end;end;end;else if Y>=0B1_0111__1__0 then if Y==0x5F then H={[2]=p,[0B100]=H,[0x1]=w,[0B1__1]=I};F=t[y];n=R[12](function(...)R[0B1__00]();for H,l in...do R[0X4](true,H,l);end;end);n(B[F],B[F+0x1],B[F+0x2]);w=(n);y=i[y];else B[Q[y]]=(not B[t[y]]);end;else n=(B);q=(i[y]);end;end;end;else if Y>=0B10__10110 then if Y<0b1011000 then if Y==0x57 then B[t[y]]=d[J[y]];else B[t[y]]=B[Q[y]]//J[y];end;else if not(Y>=0X59)then(B)[t[y]]=B[i[y]][o[y]];else if Y==0X5A then B[Q[y]]=B[i[y]]..B[t[y]];else n=(B);q=(i[y]);M=(nil);end;end;end;else if not(Y<0x53)then if Y>=0B10_10100 then if Y==0x5__5_ then(B)[i[y]]=r;else B[t[y]]=i;end;else q=(i[y]);M=o[y];end;else if Y==0B1010010 then B[i[y]]=B[Q[y]]*B[t[y]];else(B)[i[y]]=B[Q[y]]*z[y];end;end;end;end;end;end;else if Y<0X28 then if Y>=0x14 then if Y>=0B11110 then if not(Y<0X23)then if not(Y>=0B100101)then if Y~=0X24 then n=false;w+=p;if not(p<=0B000)then n=w<=I;else n=w>=I;end;if n then(B)[t[y]+0X3__]=w;y=(i[y]);end;else B[t[y]]=(#B[Q[y]]);end;else if not(Y>=0x26)then(B)[t[y]]=(R[0x5]);else if Y==0X27 then if not(B[i[y]]<=B[Q[y]])then y=(t[y]);end;else b=(i[y]);M=(M[b]);end;end;end;else if not(Y>=0X20)then if Y==0X1f then B[i[y]]=B[t[y]]==B[Q[y]];else if B[t[y]]==B[i[y]]then else y=(Q[y]);end;end;else if Y<0X21 then B[t[y]]=(J[y]^B[Q[y]]);elseif Y==34 then for r=0B1,t[y]do B[r]=(s[r]);end;else end;end;end;else if Y<0X19__ then if not(Y<0X16)then if Y<23 then n=z[y];q=n[0X4__];M=(#q);b=M>0X0 and{};m=R[0b111000](n,b);R[0B100101](m,d);B[i[y]]=(m);if not(b)then else for r=0B1,M do m=(q[r]);n=m[0X3];k=m[2];if n==0X000 then(b)[r-0B1]=B[k];elseif n==0X3 then(b)[r-0X1]=(A[k]);else if n~=0B1 then else if not e then e=({});end;U=(e[k]);if not U then U=({[0x3]=B,[2]=k});(e)[k]=(U);end;(b)[r-0X1]=U;end;end;end;end;else if Y==0X18 then B[t[y]]=(t);else M=(not M);n[q]=M;end;end;else if Y~=0X15 then b=t[y];M=(M[b]);b=(J[y]);else n[q]=M;end;end;else if not(Y<0X1b)then if Y<28 then(B)[t[y]]=(B[Q[y]]~=J[y]);else if Y==0b11101 then j=(i[y]);for r=0B1,j do B[r]=(s[r]);end;g=j+1;else n=(Q[y]);B[n](R[0b11101](n+0X1,F,B));F=n-0X1;end;end;else if Y~=0B11010 then n=B;q=(Q[y]);else if not B[i[y]]then y=Q[y];end;end;end;end;end;else if not(Y<0XA)then if Y<0Xf then if Y<0B1100 then if Y~=0XB then n=(i[y]);q=Q[y];else B[i[y]]=R[0B100011];end;else if not(Y>=0XD)then n=t[y];q=Q[y];F=n+q-0B1;if e then for r,w in e do if not(r>=0X1)then else w[0x3]=w;(w)[1]=(B[r]);(w)[2]=0X1;e[r]=nil;end;end;end;return true,n,q;else if Y~=0Xe then B[i[y]]=B[t[y]]-B[Q[y]];else n=(B);end;end;end;else if Y>=0X11 then if not(Y<0B0010010__)then if Y~=19 then(B)[t[y]]=B[Q[y]]%J[y];else(B)[Q[y]]=J[y]+B[t[y]];end;else b=(t[y]);M=M[b];end;else if Y==0B10000 then n=(Q[y]);q=t[y];M=(i[y]);if q==0X0 then else F=(n+q-1);end;b,m=nil;if q~=0b1 then b,m=R[0X37](B[n](R[0X1D](n+0X001,F,B)));else b,m=R[0x37](B[n]());end;if M==0b1_ then F=n-0B1;else if M==0x0 then b=(b+n-1);F=b;else b=n+M-0b10;F=b+1;end;q=0X0;for r=n,b do q+=0X1_;(B)[r]=m[q];end;end;else B[t[y]]=(B[i[y]]==o[y]);end;end;end;else if Y>=0X5 then if not(Y>=7)then if Y==0X6__ then(B)[Q[y]]=B[i[y]]/B[t[y]];else n=nil;q=nil;M=(nil);b=0B101;repeat if b>=0X20__ then M=(4503599627370495);break;else n=(0X3E);q=0X0;b=27+((R[1][0X17]((R[1][20](b))+Y))~=b and Y or b);end;until false;q*=M;m=(nil);b=(0X54);while true do if b~=0x23 then M=R[1];b=0X1e+(R[0X1][0X18]((R[0x01][25](b+b-Y,Y)),(Y)));else m=(0X13);M=(M[m]);break;end;end;m=(R[1]);k=nil;U=(nil);b=(0X40);repeat if b==0x29 then U=(0X15);break;elseif b==0x72 then k=R[0X1];b=(31+((R[1][0X14](b+Y+Y))-b));else if b==0x4_0 then k=(0b10100);b=(0B01011010+((R[0X1][0x19](b-b+Y,b,b))-b));continue;else if b==0b11111 then m=m[k];b=(-4294967145+((R[1][26](Y))+Y-Y-b));end;end;end;until false;K=nil;b=(0x6a);repeat if b<0X4_1 then K=0X13;break;elseif b>0X2c_ and b<0B1101010 then U=R[0X1];b=-4294967058+((R[0X0_01][0B10101](b-Y-b,(Y)))-b);continue;else if b>0B1000001 then k=(k[U]);b=(-46+(R[1][20]((R[0x1][0B10011]((R[0X1][19](Y<b and Y or b,Y)))),b,b)));continue;end;end;until false;c=nil;b=0x14;while true do if b==99 then K=R[0X1];b=(0xD3__+(b-b-Y-b-Y));continue;else if b==20 then U=(U[K]);b=(-4294889392+((R[0X1][0B101_10](Y-Y-b,(b)))+b));continue;else if b~=0X66_ then else c=(0x16);break;end;end;end;end;K=(K[c]);c=O[y];C=O[y];K=K(c,C);U=U(K);b=0x1;while true do if not(b>0B101_1011)then if b>0X1 then k=k(U,K);b=(0B1111110+(R[0X1][19]((R[0x1][0X19](b+b-Y,b)),Y,Y)));else K=(O[y]);b=0X66+((R[0X1][0X18](b>b and b or b,(Y)))+Y+b);continue;end;elseif not(b>=0x7e)then U+=K;K=Y;b=(-0xb+(R[1][0X1A]((Y+b<Y and Y or Y)-b)));continue;else m=m(k);k=Y;break;end;end;b=0X5A;repeat if b~=0x5a then if not(m)then else m=Y;end;break;else m=m~=k;b=0X12+((R[1][0B10011]((R[0x1][0X1_A](Y)),Y))+b+Y);continue;end;until false;if not(not m)then else m=O[y];end;k=O[y];b=0B110_1010;while true do if not(b>65)then m=(O[y]);break;else M=M(m,k);b=(0B1010_0110+((R[0X1][0B10100]((R[0b1][25](Y>=b and b or Y))))-b));continue;end;end;M-=m;q+=M;b=(0B110010_1);while true do if b==0B01011111 then for r=n,q do C=(0x70);while true do if C>0XF then m=(B);k=(r);C=0B111__1;continue;else if C<0x070 then U=(nil);break;end;end;end;(m)[k]=U;end;break;else if b==0B0 then n=i[y];q=Q[y];b=(-4294967200+((R[0X1][0b11010](Y))+Y+Y-Y));continue;else if b==0B1100101 then n+=q;(O)[y]=(n);b=-0X2+(R[1][0X18]((R[0B1][0x19]((R[1][0X15__](Y,(Y))),Y,b))-b,(Y)));end;end;end;end;end;else if not(Y<8)then if Y==0X9 then if B[Q[y]]==J[y]then else y=(t[y]);end;else M=(M[b]);end;else B[t[y]]=B[i[y]]>=B[Q[y]];end;end;else if Y>=0X2 then if not(Y<3)then if Y==0X4 then(B[Q[y]])[z[y]]=(J[y]);else m=(i[y]);end;else n=(i[y]);q=(_-j-0B1_);if not(q<0X0)then else q=-0X1;end;M=0B0;for r=n,n+q do B[r]=s[g+M];M+=0b1;end;F=n+q;end;else if Y~=0X1 then b=b[m];else M^=b;end;end;end;end;end;else if Y<0b111100 then if not(Y<0X32)then if Y<0X37 then if Y<0X0034 then if Y~=0x33 then b=Q[y];M=M[b];b=(B);else b=i[y];M=M[b];(n)[q]=M;end;elseif Y>=0X35 then if Y~=0X36 then B[i[y]]=(R[39](B[Q[y]],z[y]));else if e then for r,_ in e do if not(r>=1)then else(_)[0x3]=(_);(_)[1]=(B[r]);(_)[0X002]=0B1;e[r]=(nil);end;end;end;return true,i[y],0b0;end;else B[i[y]]=(O);end;else if not(Y<0B11100_1)then if Y>=0X3A then if Y==0B111011 then(B)[t[y]]=(B[Q[y]]~=B[i[y]]);else n=B;q=(Q[y]);M=(B);end;else M=J[y];b=B;end;else if Y~=0X38 then q=(0X1);n-=q;F=n;else(B)[Q[y]]=(A[t[y]][J[y]]);end;end;end;else if Y>=0X2D then if Y<0B101111 then if Y==46 then(B)[Q[y]]=B[t[y]]+J[y];else F=(t[y]);B[F]=B[F]();end;else if not(Y>=48)then n=B;q=(i[y]);M=(o[y]);else if Y==0B110001 then B[i[y]]=(B[Q[y]]/z[y]);else B[Q[y]]=(-B[i[y]]);end;end;end;else if Y>=0b00101010 then if not(Y>=43)then n=(t[y]);else if Y==44 then n=(o[y]);q=n[0B100];n=#q;M=(n>0B0 and{});if M then for r=0B1,n do b=q[r];m=(b[0B11]);k=b[0X2];if m==1 then if not(not e)then else e=({});end;b=(e[k]);if not b then b={[0X3]=B,[0X2]=k};e[k]=(b);end;(M)[r-0X001]=(b);elseif m==0X3 then(M)[r-0B1]=A[k];elseif m==0X0 then(M)[r-0X1]=(B[k]);end;end;end;n=W[z[y]](M);R[0X25](n,d);(B)[i[y]]=(n);else if not(B[t[y]]<=J[y])then y=(Q[y]);end;end;end;else if Y~=0X002_9_ then(B)[i[y]]=(A[Q[y]]);else B[i[y]]=(B[t[y]]-o[y]);end;end;end;end;else if not(Y<0X46)then if Y<0b1001011 then if not(Y>=0B10_01000)then if Y==0x47 then B[t[y]]=(B[Q[y]][B[i[y]]]);else M=(B);b=Q[y];end;else if not(Y>=0X49)then(B)[t[y]]=(B[i[y]]);else if Y~=74 then q=t[y];M=(d);else(B)[t[y]]=(B[i[y]]//B[Q[y]]);end;end;end;else if Y>=0X4e then if Y>=0B1001111 then if Y~=0X50_ then(B)[t[y]]=R[0b1001](i[y]);else n=t[y];F=(n+Q[y]-1);(B)[n]=B[n](R[0x1d](n+0X1,F,B));F=(n);end;else n=Q[y];q=B[t[y]];B[n+0X1]=q;(B)[n]=(q[J[y]]);end;else if not(Y>=76)then n=nil;q=nil;M=nil;b=(0X7d_);while true do if b<0X02a then M=R[1];break;elseif b>0B101010 and b<0X38 then M=(4503599627370495);b=-4294967196+(R[0B1][26]((R[1][27](Y))+b-t[y]));elseif b>56 then n=-2415919019;b=(-4294967189+(R[1][0b11010]((R[0B1][0X19]((R[0X1][25](b-Y,b,b)))))));continue;elseif b>0X37 and b<0x7D then q=(0x0);b=(-0x12BfF46+((R[0B1][22]((R[1][0x16_](Y,t[y])),t[y]))-Y-b));elseif b<0B110111 and b>1 then q*=M;b=(-0x16+((R[1][0X1b]((t[y]<t[y]and b or t[y])-Y))<t[y]and t[y]or b));end;end;m=(0X15);k=(nil);b=(0x77);while true do if b<0x6__A then k=(Y);break;elseif b<0B1110111 and b>0X41 then k=(0X13);m=(m[k]);b=-0x46+(R[1][19](Y+b-t[y]-t[y]));continue;elseif not(b>0X6a)then else M=M[m];m=(R[0X1]);b=(83+((R[0x1][0x018](b-b,t[y]))-t[y]<b and t[y]or t[y]));continue;end;end;U=O[y];k-=U;U=(O[y]);m=m(k,U);b=4;while true do if b<19 then k=(t[y]);b=-4294967276+(R[0x1][26]((R[0X1][0X15]((R[0x1][0X13](t[y]+Y,b,Y)),t[y]))));continue;elseif b>0B10011 then if not(not m)then else m=t[y];end;break;elseif not(b>0X4 and b<0X056)then else m=m>=k;if m then m=(t[y]);end;b=43+((R[0B1][0X014](t[y]-b,b,Y))-Y+t[y]);continue;end;end;k=Y;m-=k;b=0B10011;while true do if not(b<=65)then if not(b>106)then if b==0x56 then m-=k;b=(36+(R[1][0B11011](b-b+b>b and b or b)));else k=t[y];b=(0B001__010__00+(R[0B1][0x1b]((R[1][26]((R[0B1][0X17](b))-b)))));end;else if not(b>=120)then m-=k;b=(0X096__+((R[1][0x18](b-t[y],t[y]))-b+Y));else k=t[y];b=(139+((R[1][0X17](Y-Y))-Y+t[y]));continue;end;end;else if not(b>0X13)then k=Y;b=-4294967209+(R[0X1][0B10100__](((R[1][0B10101](b,(b)))==b and Y or b)-t[y],b,b));continue;else if b~=0X41 then k=O[y];m-=k;b=0B11110_00+(R[0x1][0B10111]((R[0B1][0X1B](t[y]<Y and b or b))-b));continue;else M=M(m,k);break;end;end;end;end;b=(45);while true do if b==40 then n+=q;break;elseif b~=0x2d then else q+=M;b=(18+((Y>=t[y]and b or b)-t[y]+Y-Y));continue;end;end;(O)[y]=n;n=B;b=(0x53);while true do if b<0X05__3 then M=(i);b=(0B10110001+((Y==b and Y or t[y])+b-b-Y));elseif b>0X53 then(n)[q]=(M);break;elseif b<125 and b>0X16 then q=t[y];b=(0X14+(R[1][27]((R[0x1][0X15]((R[0B1][0B010100](b==b and b or b,t[y])),t[y])))));continue;end;end;else if Y==0B1001__101 then(B)[t[y]]=(R[0X1e_](B[i[y]],o[y]));else B[i[y]]=(nil);end;end;end;end;else if Y<0B100000__1 then if not(Y<0X3e)then if Y<0X3F__ then for W=i[y],Q[y]do B[W]=(nil);end;else if Y==0X040 then n=nil;q=nil;M=(nil);b=(0X78);repeat if not(b>0X6a_)then if b<=0B100__00__01 then M=R[1];break;else q*=M;b=(-0X2A7_f_43+((R[1][0b1_0110](b+Y,i[y]))-i[y]-b));continue;end;else if not(b>=0B1111000)then q=(0b0);M=(4503599627370495);b=-4280549206+((R[0x1][0X13]((R[0B1][0b111_00](Y-b,i[y]))))-Y);continue;else n=(0B100001__1__0);b=0x9F+((R[1][0x1B]((R[0B1][0X14](b,b,i[y]))+Y))-Y);end;end;until false;m=(nil);k=(nil);U=nil;b=114;while true do if not(b<=0B10__00110)then if b>0B0011_01101 then if b>114 then m=R[0x1];b=-0x0B3+(R[0X001][0x14]((R[0X1][0B11001](b+b))-i[y],i[y],b));else m=(0X1b);b=(-0B10111+((R[0x1][0X1__c](Y~=Y and b or b,i[y]))+Y>i[y]and Y or b));end;else U=0x15;break;end;else if not(b>41)then M=M[m];b=(93+(((R[1][0B10111](b))+Y>b and Y or i[y])-b));continue;else if b~=67 then m=m[k];k=R[0B1];b=0B1001001+(R[0X1][0X18]((R[0x1][0X15](i[y]+i[y],i[y]))+Y,i[y]));continue;else k=(0X13);b=(0B0110100+((R[0X1][25]((R[0b1][0b10011]((R[0X1][0X16](Y,i[y])))),b,b))>Y and i[y]or b));end;end;end;end;b=0B1111;repeat if b==0XF then k=k[U];b=-8388577+((R[0X1][0X13]((R[1][0X16](Y,(b)))))-b+i[y]);else U=(Y);break;end;until false;K=(i[y]);b=(0X6b);repeat if b>0X4E_ and b<107 then U=U>=K;b=(0X29+(R[0X1][27]((R[0B1][21]((R[1][0B11001]((R[0X1][0B10110](b,i[y])),b)),i[y])))));elseif b<0X55 and b>0X30 then K=i[y];b=(0x0_046__+(R[0b1][0X17]((R[1][0X16](b+b+b,i[y])))));continue;else if b<0B1001110 then if U then U=(Y);end;if not(not U)then else U=O[y];end;break;else if b>0X55 then U+=K;b=-0x1D+((R[0X1][0X18]((R[0b1][0X16](b-b,i[y])),i[y]))~=b and b or b);end;end;end;until false;b=0B1110010;while true do if not(b<=0x43)then if not(b>=116)then K=(i[y]);b=-4294164438+(R[0X1][0x16](Y-b-i[y]+i[y],i[y]));else K=(O[y]);b=0B10110111+((R[0B1][0B10011]((R[0X1][0X16](Y+i[y],i[y])),b))-b);continue;end;elseif b==0x43 then U+=K;break;else U+=K;b=(-4294967179+(R[0X1][26]((R[0b1][0b10011](i[y]+Y==i[y]and i[y]or b,b,Y)))));end;end;K=i[y];b=84;while true do if not(b>0B10011__0)then if not(b>7)then q+=M;break;else if b>=0X26 then M=M(m);b=(0x73+((R[0X1][0B11011]((R[0x1__][24]((R[1][0X015](b,i[y])),i[y]))))-Y));else m=m(k);b=-0B100_000+((Y==b and b or i[y])+b+b-i[y]);continue;end;end;else if not(b<=0B1001000_)then if b~=0X4D then k=k(U,K);b=(-31+(((R[1][0X16__](i[y]==Y and i[y]or Y,i[y]))<Y and i[y]or b)-i[y]));else m=(i[y]);b=0X87+((R[0b1][0X17]((R[0X1][0X18](b,i[y]))))-b-i[y]);end;else M-=m;b=(-0X11FFFB9+((R[1][0X1c](b,i[y]))-b-Y+b));end;end;end;n+=q;b=(72);while true do if b==0B111 then n=(B);b=0B1101000+((R[0X1][0X19]((R[0B1][0X13]((R[0B1][0X15](b,(b))),b,b)),i[y]))-Y);continue;elseif b==58 then q=i[y];break;else if b~=0X048 then else(O)[y]=(n);b=0b111+(((R[0X1][0B101_11](b+b))<=b and b or i[y])-b);continue;end;end;end;b=9;while true do if b>0X9 then(n)[q]=(M);break;else if b<84 then M=(o[y]);b=0x14+((R[0X1][0X13]((R[0x1][0B10100](Y))))+b-b);continue;end;end;end;else(R[0X1_])[i[y]]=B[t[y]];end;end;else if Y==61 then n=B;q=F;else if not(not(B[Q[y]]<z[y]))then else y=(i[y]);end;end;end;else if Y<0b1000011 then if Y~=0x42 then n=147;q=(nil);M=(nil);b=nil;m=0b111010;repeat if m==14 then b=(19);break;elseif m==81 then M=(4503599627370495);m=(0X1+((R[0B1][0X17]((R[0X1][0B11001](m,m))))+m+Q[y]));continue;else if m==0X7C then q*=M;m=(0X2B+(R[0x1][0X15__]((R[0X1__][0x15]((R[0B1][0X18](m-m,Q[y])),Q[y])),Q[y])));else if m==0X3A then q=0X0;m=0X92+(Y-Y+m-Y-m);else if m==0b10101__1 then M=(R[1]);m=0X18+(m+m-Q[y]-m-m);continue;end;end;end;end;until false;M=(M[b]);k=nil;m=82;while true do if not(m<=0X9)then if m~=0B1010100__ then b=R[0X1];k=0b10101;m=(-0x2800045+((R[0B1][25]((R[0X1][0X16]((R[0X1][0x13](Q[y])),Q[y])),m,Q[y]))-Q[y]));continue;else k=O[y];break;end;else b=b[k];m=0X1d+(((R[0X1][0X1a](m))-Q[y]>=Y and Y or Y)-Q[y]);continue;end;end;U=Y;m=(0X9);while true do if m<0X54 and m>9 then k=Q[y];break;elseif m>0X23 then U=(Q[y]);b=b(k,U);m=-0B1110010+(((R[0B1][0X19]((R[0X1][0b11100__](Y,Q[y])),Q[y],m))<Y and Y or Y)+m);else if m<0x23 then k+=U;m=0X4a+((R[0X1][23]((R[1][23](Q[y]-Y))))<=Q[y]and m or Q[y]);continue;end;end;end;U=(Q[y]);m=(26);while true do if m==0X5__C then M=M<b;break;elseif m==26 then M=M(b,k,U);m=0X31+(R[1][23](((R[0X001][0B11010](Q[y]))==Q[y]and m or m)+Y));else if m~=0x31 then else b=(Q[y]);m=-0X27a4+(R[0x1][0B11100]((R[1][0B11001](m+m,m))>=m and Q[y]or m,Q[y]));continue;end;end;end;m=(0B101100);repeat if m<0B111110_ and m>0X20 then if M then M=Q[y];end;m=-0X87E5+(R[0x1][21](((m>m and Y or Q[y])~=Q[y]and m or m)-Q[y],Q[y]));continue;elseif m<0B100000_ and m>0B1001 then if not M then M=O[y];end;m=(-0B11110+(R[0B01][0B1010__0]((R[1][25]((R[0X1][20](m+Y)))))));continue;elseif m>27 and m<0X2C then b=(Y);M+=b;b=Y;m=(40+(R[0X1][21]((R[0B1][0B110__01_]((R[0X1][0X19](m))<=Y and Q[y]or m,m)),(m))));continue;elseif m>0X5 and m<27 then b=(Y);m=(84+(R[0X1][0B00101__1__1]((m~=Q[y]and Q[y]or Y)+m>=Y and Q[y]or m)));elseif m<0X52 and m>0X2C then b=O[y];m=(0X43+((R[0x1][23]((R[0x1][0x1b]((R[1][27](m))))))-m));else if m>0X52 then M-=b;break;elseif m<0B1001 then M+=b;m=(0X48+((R[0x1][0X1b]((R[1][0B1_10__01]((R[0X1][0X1b](Y)),Y))))-Y));else if m>0X3e and m<84 then M-=b;m=-10084+((R[0X1][0x13]((R[0B1][21](Q[y],Q[y]))))-m-Y);end;end;end;until false;m=(0X67);repeat if m<49 then n+=q;m=(-109051946+(R[0B1][0B10100]((R[1][0X14]((R[0X1][0B11001_]((R[0x1][0X1__6](m,Q[y])),Y,Q[y])),m,Y)),Q[y],m)));continue;else if m>0X1a and m<0x67 then O[y]=n;break;else if m>49 then q+=M;m=(-4294873061+(R[1][21]((m+Y<=Y and Q[y]or Q[y])-m,Q[y])));end;end;end;until false;n=B;m=0X44;repeat if not(m<=0X16)then if m==0X44__ then q=Q[y];m=(-0X32+((((R[1][0X016](m,Q[y]))~=Y and m or m)<Q[y]and m or Y)+m));else M=R[0B1];m=(0X11+(R[0X1][27]((R[1][0B10100]((R[0B1][22](Q[y]+Q[y],Q[y])))))));continue;end;else b=(i[y]);break;end;until false;M=(M[b]);(n)[q]=M;else B[i[y]]=(B[Q[y]]%B[t[y]]);end;else if Y>=0x4__4 then if Y==69 then M=(M[b]);(n)[q]=(M);else if e then for W,r in e do if W>=0B1 then(r)[3]=r;(r)[0X1]=(B[W]);r[0B10]=(1);e[W]=nil;end;end;end;return;end;else q=(t[y]);M=B;end;end;end;end;end;end;end;y+=0b1;end;end);if h then if S then if G==0X1 then return B[D]();else return B[D](R[0x1d](D+0x1,F,B));end;else if D then return R[29](D,G,B);end;end;else if not(e)then else for W,r in e do if W>=0B1 then(r)[3]=(r);r[1]=(B[W]);(r)[2]=(0X1);e[W]=nil;end;end;end;if R[0X1c](S)=="s\116rin\103"then if not(R[0X22](S,"\58\40\z\%d+\41[:\13\n]"))then(R[0b11001])(S,0);else R[0X19]('\76u\114\u{061}p\u{0068}\ S\z  c\x72\z  ipt\z  \58'..(X[y]or"(i\110te\u{72}n\97\108)")..'\58 '..R[0B1011_11](S),0b0);end;else R[0X19](S,0);end;end;end; __PF[N]=r if __PA and not __PA[r] then __PA[r]={};__PA.n=__PA.n+1;__PA[r].__seq=__PA.n;__PA[r].__maker="147866_2035345713@0,27061";__PK[r]=N;__PA[r].A=A;__PA[r].J=J;__PA[r].O=O;__PA[r].Q=Q;__PA[r].X=X;__PA[r]._=_;__PA[r].i=i;__PA[r].o=o;__PA[r].r=r;__PA[r].t=t;__PA[r].z=z;__PA[r].__venv1=a;__PA[r].__venv2=R;__PA[r].__venv3=B;__PA[r].__venv4=g;__PA[r].__venv5=j;__PA[r].__venv6=y;__PA[r].__venv7=e;__PA[r].__venv8=s;__PA[r].__venv9=F;__PA[r].__venv10=d;__PA[r].__venv11=p;__PA[r].__venv12=I;__PA[r].__venv13=h;__PA[r].__venv14=S;__PA[r].__venv15=D;__PA[r].__venv16=G;__PA[r].__venv17=C;__PA[r].__venv18=b;__PA[r].__venv19=K;__PA[r].__venv20=M;__PA[r].__venv21=U;__PA[r].__venv22=m;__PA[r].__venv23=n;__PA[r].__venv24=c;__PA[r].__venv25=q;__PA[r].__venv26=k;__PA[r].__venv27=Y; end return N;end);break;end;end;end;until false;(R)[0X39]=(nil);return Z,x;end,Pv=bit32.bxor,ii=function(W,W)return W;end,ti=function(W,W,R)R=W[15166];return R;end,R=bit32.rshift,RZ=function(W,R,r,Z,x)local A,_,X=(0b11111);while true do A,_,X=W:LZ(X,r,R,Z,A);if _==59442 then break;end;end;r[0B1000][X+0X3]=(x);end,LZ=function(W,R,r,Z,x,A)if A~=0X7_2 then R,A=W:AZ(r,A,R);else(r[0B1000])[R+1]=(Z);(r[0b10__00_])[R+2]=(x);return A,59442,R;end;return A,nil,R;end,Li=function(W,R,r,Z,x)Z=0B1011001;repeat if Z<=0B10110__01 then x[41]=function()return(W:Wi(x));end;if not(not R[0X3B3e])then Z=W:ti(R,Z);else Z=(4242792481+((R[40]~=R[0X071EF_]and R[0X49Df]or R[1171])-R[0X1169]-R[0X6__EAd]-W.l[6]));R[15166]=(Z);end;continue;else if Z==115 then x[0B101011]=function()local A,_,X;for J=0x5f,0B10101010,0X1B do A,X,_=W:Ai(X,J,x);if A==64532 then continue;else if A~=-0x2 then else return _;end;end;end;end;x[0X2C]=(pcall);break;else x[0X02a]=function()return(W:Ki(x));end;if not(not R[10629])then Z=(R[10629]);else Z=W:Ji(R,Z);end;continue;end;end;until false;r=nil;(x)[45]=(nil);(x)[46]=(nil);return r,Z;end,uv=string.unpack,O=function(W)local R=W[0];return function()local W=513159;local r=R[3][R[2]];W=W*r;r=4230170;W=W+r;r=16777216;W=W%r;R[3][R[2]]=W;W=908053;r=R[3][R[2]];W=W*r;r=1471294;W=W+r;r=16777216;W=W%r;R[3][R[2]]=W;end;end,w=function(W,W,R)W=R[0X4265];return W;end,sZ=function(W,W,R,r,Z)r[R]=Z[0Xa][W];end,Xi=function(W,W,R)R=(W[14797]);return R;end,WZ=function(W,R,r,Z,x)if Z>0X7B then x=W:dZ(R,x);return 21367,x,r;else r=R[0B1100__11]();return 0x5377,x,r;end;return nil,x,r;end,Jv=bit32.rrotate,t=string.sub,Ni=function(W,W,R)R=W[0X2254];return R;end,AZ=function(W,W,R,r)R=(0B1_11_0010);r=(#W[8]);return r,R;end,hi=function(W,W,R,r,Z)if W==0B11111__1 then if R==0X0 then return R,-0X2,Z,Z;else if R>=r[0B1011]then R-=r[0B11011];end;end;else Z,R=r[0X2E](),r[0X2e]();end;return R,nil,Z;end,e=bit32.band,xZ=function(W,R)(R)[0B10__10]=W.V;(R)[0X8]=W.V;end,UZ=function(W,W,R,r)if R<=44 then W=r[0X35]();else W=r[0x2B]();end;return W;end,wi=function(W,R,r,Z)(r)[0x33]=function()local x=r[50]();if not(x>=r[40])then else return(W:Si(x,r));end;return x;end;if not R[0X39CD]then Z=(0XE4+(((R[0X5F9E]~=R[4224]and R[0X1D2C]or R[11188])==R[0X40d6]and R[9205]or R[7428])-R[0X769b]-R[16997]));(R)[0x39cD]=(Z);else Z=W:Xi(R,Z);end;return Z;end,MZ=function(W,W,R,r,Z,x)r=nil;Z=(nil);W=(nil);x=(nil);R=nil;return r,R,Z,x,W;end,p=bit32.bnot,N=string.match,Ei=function(W,R,r,Z,x,A,_,X,J,t,z,Q)t=(nil);x=0X57;while true do if x>87 then x=(0B11110);Z=z[0b1001](J);continue;elseif x<0X7b and x>74 then Q=z[0B1001](X);x=0B1001010__;r[4]=(Q);continue;else if x<0X4a and x>0X1e then x=0B1100;(r)[0X7]=z[50]();elseif x>33 and x<0B1010111 then x=W:xi(x,X,z,Q);elseif x>0XC and x<0B100001 then t=z[0x9](J);break;else if not(x<0b11110)then else J=z[50]()-0X12f1D;x=0X7b;end;end;end;end;A=z[0b1001](J);_=z[0X09](J);R=(nil);return J,Z,Q,R,x,t,A,_;end,mZ=function(W,R,r,Z,x)local A,_;for X=8,0X1F,0B0010111 do A,Z,_=W:yZ(X,R,x,r,Z);if A==0x6__cD1 then continue;else if A==-2 then return-0X002,Z,_;end;end;end;return nil,Z;end,EZ=function(W,R,r,Z)local x,A;Z[57]=(R);local _,X;for J=0x4D,0X230,0x5b do if J<0XA8 then for t=1,r,1 do local r,z,Q;for o=0x15,144,0B10010 do if o>21 and o<57 then z=Z[41]();elseif o>39 then x,Q,r,A=W:cZ(z,Z,Q,r);if x==49108 then break;else if x==-0b10 then return A;end;end;else if not(o<0B100111)then else r=W.V;continue;end;end;end;z=(37);repeat if z>0X25 then if not(R)then(Z[10])[t]=r;else Z[0XA][t]={r,(Z[0X1C](r))};end;break;else if z<64 then z=W:GZ(z);end;end;until false;end;continue;elseif J>259 and J<0X1B9 then W:ZZ(X,Z);continue;else if J<259 and J>0B1001101 then _=W:rZ(Z,_);elseif J>350 then W:IZ(X,R,Z);break;else if not(J>0b010101__000 and J<0X15E)then else X=Z[0X9](_);if Z[0B11100]~=Z[0B1]then local R=(1);while true do if R>0X1 then for r=1,_ do(X)[r]=Z[0X3a]();end;break;else if not(R<0x6C)then else Z[0X8]=Z[9](_*0B11);R=0B1101100;end;end;end;end;continue;end;end;end;end;x=nil;for R=0x43,0B10101011,0X40 do if R==0X43 then x=X[Z[0X32]()];else if R~=0x8__3 then else W:xZ(Z);break;end;end;end;Z[0x15]=nil;return x;end,b='c\u{072}e\97\z  \x74\z \u{065}',I=function(W,W,R)R=W[29167];return R;end,Av=bit32.rshift,ev=bit32.countlz,fZ=function(W,W)W=(0B1);return W;end,uZ=function(W,R,r,Z,x,A)local _,X=(0b101111);while true do if _<=47 then _=(66);X=(#r[8]);else W:hZ(x,A,r,X);break;end;end;r[8][X+0x2]=(R);r[0x8][X+3]=Z;end,Qi=function(W,W,R)(R)[0X5]=R[0X05]+0X4__;return W;end,Q=unpack,j=function(W,R,r,Z,x)repeat if R<0B001111000 and R>61 then r[0B0101]=(0X0);if not(not x[24478])then R=x[24478];else R=-1279316284+((W.Rv((W.Pv(W.l[8]))<R and W.l[0B11]or W.l[0X2],W.l[0X4],W.l[9]))+W.l[1]);x[24478]=R;end;continue;elseif R>0X56 then W:X(r);break;else if R<0X56 then r[0x6]=(Z.readu8);if not(not x[0X4265])then R=W:w(R,x);else R=(-4293884734+(W.sv((W.av(W.l[0X6]+x[0X747b]-W.l[0B11],(31))),W.l[0b100])));x[0X4265]=(R);end;end;end;until false;(r)[8]=W.V;r[9]=nil;r[0Xa]=nil;(r)[11]=nil;return R;end,_i=function(W,W,R)R=(W[0X10C8]);return R;end,Y=function(W,R,r,Z)Z[0xA]=W.V;if not(not R[4457])then r=(R[0X1169]);else(R)[0X2bb__4]=-2436842528+(W.Jv((W.Nv((W.Nv(R[0X49Df]))))+W.l[0B1000],(13)));r=(-0X28+((W.Av((W.hv(R[0XdB2__]))-W.l[0b0011],(W.uv('\x3Ei\u{0038}',"\0\0\0\0\z \0\0\0\u{0013}"))))<R[3506]and R[0X747b]or R[18911]));(R)[4457]=(r);end;return r;end,K="r\x65\97du1\z 6",n=bit32,g=function(W,W,R)R=(W[0X6383]);return R;end,ji=function(W)end,V=nil,XZ=function(W,W,R,r)W[r]=R-R%1;end,v=function(W,R,r,Z,x,A,_)if x==119 then(_)[0X3]=(Z[W.b]);r={};R=({});return 0X2997,x,Z,R,r;else if x==0X007__8 then Z=buffer;if not(not A[29819])then x=A[29819];else x=-2689648582+(W.Jv((W.Av((W.Av(W.l[0x8],(0x17__))),(0)))-W.l[0B111],(0X11)));(A)[29819]=x;end;end;end;return nil,x,Z,R,r;end,YZ=function(W,R,r,Z)(r)[0B11100_1]=(nil);r[0B1_11010]=function()local x,A,_,X,J,t,z;z,X,J,_,t=W:ci(_,X,r,J,t,z);local Q,o,i,O,N;t,z,J,N,o,Q,i,O=W:Ei(N,_,z,o,i,O,X,t,Q,r,J);X,J=nil;J,o,x,N,X,A=W:_Z(z,i,_,O,r,J,N,X,t,o,Q);if x==-0x0_0__2 then return A;else if x==-1 then return;end;end;o=(0B1111);repeat if o>=0x22 then X=W:jZ(J,X,r);break;else(_)[0B101]=J;o=0X22;end;until false;return _;end;if not Z[0X5315_]then R=(0b1110011+(W.ev((W.Pv((W.Jv(Z[30363]==Z[0x4265]and Z[0X2_2c1]or Z[7729],(Z[0x3DAb]))),W.l[0B0010__1])))));Z[0X5315]=R;else R=Z[21269];end;return R;end,m=function(W,R,r)r=(-2223766502+(W.zv((W.sv((W.Rv(W.l[8]~=R[0X2Bb4]and W.l[4]or R[9114])),r,R[0X330__6])),(R[13062]))));(R)[7729]=(r);return r;end,X=function(W,R)R[0B111__]=W.Lv;end,cZ=function(W,R,r,Z,x)local A,_;Z=0B1001111;if R<=0x78 then A,x,_=W:mZ(Z,R,x,r);if A~=-0B10 then else return-0X2,Z,x,_;end;else if R<=0x9b then x=W:qZ(x,R,r);else for A=0X66,0Xd1,0X15 do if A~=0B1111011 then if R>0XC1 then if R<=0xd6 then x=r[0X2A]();else x=W.o;end;else x=r[0X34]();end;else break;end;end;end;end;return 49108,Z,x;end,aZ=function(W,W,R,r)R[W]=(r);end,Hi=function(W,R,r,Z,x)local A;(R)[0x2F]=(nil);(R)[0X30__]=nil;R[0B110001]=nil;Z=7;repeat Z,A,r=W:pi(R,Z,r,x);if A==27014 then break;end;until false;R[0X32]=nil;return Z,r;end,li=function(W,W,R)W=R[0X5E78];return W;end,Vv=function(W,R,r,Z,x,A)if R[0B101010]==x then else for _=0x12,69,7 do if not(_>=0b11__001)then R[0B1][0XC]=(x);else(R[1])[3]=(r);break;end;end;R[1][0x2]=(R[43]);end;if not(not Z[0x3bA4])then A=(Z[15268]);else A=0b10__10000+(W.Nv((W.hv((W.Pv(Z[0X1D2C]-Z[0Xf77],Z[15166]))))));Z[15268]=(A);end;return A;end,Bv=function(W,R,r)local Z=0B1110011;while true do if Z==0X3__6 then W:kv(R);break;else if Z~=0X73 then else R[0X1][0X1A]=W.p;Z=0x36;(R[0x1_])[0x17]=W.Nv;end;end;end;for x=0X2d,0B11101101,0X60 do if x==141 then(R[0X1])[25]=W.z;(R[0B1])[0X1C]=W.zv;elseif x==0x2D then W:Ov(R);continue;else if x==0B11__101101 then R[0X1][21]=(W.n.lrotate);end;end;end;Z=(0X6a);while true do if Z<0X41 then W:lv(R);break;else if Z<0x6a and Z>0x2c then(R[0X1])[0X14]=W.n.bor;Z=(0x2c);continue;else if not(Z>0X41)then else Z=65;(R[1])[0b10_011]=W.n.band;continue;end;end;end;end;(R[0X1])[0X10]=W.B;R[0X1][0XF]=r;end,tZ=function(W,W,R,r)W=((r-R)/0B10__0_0);return W;end,Yi=function(W,W,R,r)r+=((W>0b1111111__ and W-0X80 or W)*R);return r;end,x=function(W,R,r,Z)r[0b11011]=(nil);(r)[0X1c]=nil;Z=0X59;while true do if not(Z<=0B1011001)then(r)[0B11100]=type;break;else r[0x1B]=(4294967296);if not R[0X71EF]then Z=0X5e+((W.zv((W.sv(R[3506],R[24478]))==R[0X23f5]and R[9205]or R[0X5F9e],(R[9114])))<=R[0X23f5]and W.l[0X6]or R[9114]);(R)[0X71eF]=(Z);else Z=W:I(R,Z);end;continue;end;end;(r)[0X1d]=function(W,R,x)W=(W or 0x1);R=R or#x;if(R-W+0X1)>7997 then return r[0b11010](x,R,W);else return r[0B1111](x,W,R);end;end;r[0B11110]=nil;return Z;end,KZ=function(W,R,r,Z,x,A,_)if x~=0B1010_1111 then R=A%0X8;else _=W:tZ(_,r,Z);return 0Xd722,_,R;end;return nil,_,R;end,B=function(...)(...)[...]=nil;end,Mi=function(W,W,R)W=R[0x1d2c];return W;end,bi=function(W,W,R)W=(R[3959]);return W;end,eZ=function(W,W,R,r,Z)Z[R]=(W[0XA][r]);end,z=bit32.bxor,f=function(W)local R,r,Z,x,A={};x,A=W:_(x,A,R);local _,X,J;_,J,A,X=W:S(R,_,A,x,X,J);J=W:j(J,R,A,x);J=W:U(R,A,J,x);J=W:y(R,J,A,x);J=W:G(J,x,A,R);J=W:r(A,J,x,R);J=W:x(x,R,J);local t,z;t,z=W:E(z,t,R);J,t,z=W:di(_,x,z,J,t,R,A);_=nil;_,J=W:Li(x,_,J,R);J,_=W:Hi(R,_,J,x);A=(nil);J,A=W:Ui(J,A,x,R);J,A=W:mi(R,x,J,A);z,A=nil;A,J,z=W:bv(z,R,A,x,J);r,J,Z=W:dv(J,z,R,x,_,X);if r==-2 then return Z;end;r,J=W:Kv(x,J,X,A,R);if r then return W.Q(r);end;end,vi=function(W,W)(W)[0X35]=function()local R=W[0X16](W[0B10__0011],W[5]);W[0B101]=W[0x5]+0X8;return R;end;end,jZ=function(W,R,r,Z)for x=0X1,Z[0B101110]()do r=W:wZ(R,Z,r);end;return r;end,tv=function(W,W,R)W=-0Xe4+((R[10659]<R[15166]and R[9834]or R[0X001080])+R[24184]+R[0X71eF]-R[29550]);R[0xfCc]=(W);return W;end,lZ=function(W,W,R)(R)[8]=(W);end,sv=bit32.bor,NZ=function(W,W,R,r)W[0x8][R+1]=r;end,fi=function(W,R,r,Z,x)R=(function(A)A=x[0B111](A,"\z\x7A","!!!!!");local _,X,J={},#A-4,0B0;local t=x[0B11]((X/5)*4);for z=5,X,0x5 do local X=x[0Xe](A,z,z+4);z=_[X];if not(not z)then else local A,Q,o,i,O=x[0X20](X,0B1,5);local N=(O-0X21)+(i-0X21)*85+(o-0B001000_01_)*7225+(Q-0B0100001)*0X95EeD+(A-0X21)*0x31c84b1;z=N;_[X]=(z);end;x[0B10111](t,J,z);J+=0X4;end;return t;end);if not r[8897]then Z=107+(W.Rv((W.Rv(r[16997]+r[7729],W.l[9]))+r[0x5e78],W.l[7],r[573]));(r)[0X22c1]=(Z);else Z=r[8897];end;return Z,R;end,yZ=function(W,R,r,Z,x,A)local _,X;if R~=31 then if not(x<=0X3d)then local R=(0x70);repeat if R==15 then W:CZ();break;else if R==0X070 then R=0B001111;if x<=0x6A_ then A=Z[0b1__10001]();else local R=75;while true do if R==0x4_B then R=0x2e;if x==120 then if r~=0b10011__11 then else A=Z[0B11__0000]();end;else A=Z[0X2e]();end;continue;else if R~=0B0010_1110 then else break;end;end;end;end;end;end;until false;else for R=0x0073,123,0b1000 do if R==123 then else if R==0X7_3 then if not(x>0X4)then for R=0B00100001,0B1010110,0x35 do if R>=0x56 then A=Z[0X29]();else _,X=W:TZ(r,Z);if _==0X7e81 then continue;else if _==-0x2 then return-2,A,X;end;end;end;end;else A=W:UZ(A,x,Z);end;end;end;end;end;return 27857,A;else end;return nil,A;end,A='r\101\x61d\u{066}3\z 2',iZ=function(W,R,r,Z,x)local A,_;if Z<=109 then x=(R[0X32]()-0X06a6C);R[0XA]=R[0X9](x);return 0x7352,r,x;else A,r,_=W:gZ(Z,r,R);if A==59218 then return 29522,r,x;else if A==16895 then return 31369,r,x;else if A==-0B1 then return-0x1,r,x;else if A==-2 then return-0B10,r,x,_;end;end;end;end;end;return nil,r,x;end,ui=function(W,W,R,r)return r*R[0x1b]+W;end,fv=function(W,R,r)(R)[3599]=(-3429428853+(W.sv((W.sv((W.Pv(R[0X71ef]))))<R[1171]and W.l[0X9]or R[0X64d0],R[14094])));R[9250]=-3221225416+(W.zv((W.sv(R[0x39cD]+R[0x2_9A3]+W.l[0X4])),(R[0X1169])));r=(-2033+((W.av(R[0X40D6],(R[0X40D6])))+R[0X3DAb]+R[0x23f5]-R[30338]));(R)[2416]=(r);return r;end,C=function(W,R,r,Z,x)(x)[0B10001]=(R[W.K]);if not(not r[0x656_7])then Z=r[25959];else r[0X239a]=-3429428799+(((W.Nv(r[0X2_8]))-W.l[0x1__]~=W.l[0B100]and W.l[0X9]or W.l[0X5])+r[0X3_306]);Z=-0X2B+((W.Nv((W.hv(W.l[7]))+r[0X49Df_]))+r[0X747B]);(r)[25959]=Z;end;return Z;end,S=function(W,R,r,Z,x,A,_)local X;R[0x3]=nil;r=nil;A=nil;_=(0b1111000);while true do X,_,Z,A,r=W:v(A,r,Z,_,x,R);if X==10647 then break;end;end;(R)[4]=(W.M.yield);R[0B0101]=(nil);R[0b110]=nil;(R)[0x7]=nil;_=(86);return r,_,Z,A;end,QZ=function(W,W,R,r,Z)local x,A=0B10100;while true do if x==0X63_ then R[0X8][A+0b1]=(r);break;else if x~=0X14 then else A=(#R[8]);x=(0b1_100011);end;end;end;R[0B1000][A+0x2]=(Z);R[0x8][A+3]=(W);end,TZ=function(W,W,R)if W==0X0088 then if not(R[0X33_])then else return-0X02,W;end;end;return 32385;end,xi=function(W,R,r,Z,x)local A;R=(0X21);for _=1,r do local r,X=(13);while true do X,A,r=W:Ii(x,Z,X,_,r);if A~=0xA__6e0 then else break;end;end;end;return R;end,y=function(W,R,r,Z,x)R[15]=nil;(R)[0X1__0]=nil;(R)[0x11]=(nil);(R)[0b100__10__]=nil;r=(0X1__7);while true do if r==0B10__01100 then(R)[18]=(Z.readi32);break;elseif r==0XA then R[16]={};if not(not x[0x28])then r=(x[0B10100_0]);else r=96+(W.Nv((W.Nv(W.l[0B101]))-x[28333]-x[0XDB2]));(x)[0B101000]=r;end;else if r==0x17 then(R)[0b1111]=unpack;if not x[0x3306]then(x)[0x6E__Ad]=-0b11_0110+((W.zv(W.l[0b10]-x[0X5F9e__],(x[4457])))+W.l[0B100]<W.l[0X9]and W.l[0B1__01]or x[16997]);r=(110+((W.Nv(W.l[0X1]+W.l[0X4]+W.l[0X09]))-x[25475]));x[13062]=r;else r=W:T(r,x);end;continue;else if r~=97 then else r=W:C(Z,x,r,R);end;end;end;end;(R)[0X13]=nil;(R)[20]=(nil);return r;end,J='r\101\u{61}d\z u3\x32',T=function(W,W,R)W=(R[13062]);return W;end,Oi=function(W,W,R)R=(W[16598]);return R;end,Kv=function(W,R,r,Z,x,A)repeat if r==0X34 then A[0X1][10]=W.l;if not(not R[0X1718])then r=(R[0X1718]);else r=W:Wv(r,R);end;elseif r==0X69 then(A[1])[18]=W;if not(not R[0X155D])then r=(R[5469]);else r=-0B1111__+((W.Pv((W.Rv(W.l[0X8],R[30838]))-R[0x29A3],R[9250],R[9834]))<=R[15166]and R[2897]or R[0X970]);(R)[0x155d]=r;end;elseif r==0X2__D then return{A[56](x,Z)},r;else if r==3 then(A[1])[0Xb]=(A[0X29]);if not(not R[0x2F97_])then r=R[0X2F97];else(R)[2058]=-4294967101+(W.hv((W.ev((W.Rv(R[25808]))))+R[3506]));R[22497]=-4242792163+((W.sv((W.Pv((W.av(R[2897],(R[15787]))))),W.l[0x6]))-R[9205]);r=-4259390125+((W.Av(R[25475]-R[29819]+W.l[0x7],(R[4457])))+W.l[0x4]);R[0X2F97]=(r);end;continue;else if r~=0B00110 then else A[0x1][0X11]=A[0X38];if not(not R[0Xf__cc])then r=(R[4044]);else r=W:tv(r,R);end;end;end;end;until false;return nil,r;end,SZ=function(W,R,r,Z,x)local A,_=(0X0079__);repeat if A<=0X4 then for X=Z-Z%1,x,0x1 do(R)[X]=(_);end;break;else A,x,_=W:vZ(_,A,r,x);continue;end;until false;return x;end,H=bit32.countlz,qZ=function(W,R,r,Z)local x=(0B0__100);repeat if not(x>=0B10011)then if not(r>0X8__2)then R=W:FZ(R);else for W=0B11011_,0B10011011,0X3 do if W==0B11011__ then if r==147 then R=(-Z[41]());else R=Z[54]();end;else if W==0X1e then break;end;end;end;end;x=(19);else break;end;until false;return R;end,si=function(W,R)local r,Z,x,A=R[0X13](R[0X23],R[5]),(99);repeat x,Z,A=W:Pi(Z,R,r);if x==0Xeb25 then continue;else if x==-0X2 then return-0B0010,A;end;end;until false;return nil;end,c=function(W,R,r,Z,x)if not(R>0B110001)then if R>=49 then x[0X15]=W.V;if not(not Z[13195])then R=(Z[13195]);else Z[29550]=-1870971176+(W.sv((W.Nv((W.Av(W.l[6],(Z[13062])))-Z[0X5F9E])),W.l[7],R));(Z)[0X23F5]=(0X62+(W.ev(((Z[0X3306]<Z[0X1169]and Z[29819]or Z[0Xdb_2])==Z[9114]and Z[0X028]or Z[0X6_567])~=Z[16997]and Z[0X28]or Z[0XdB2])));R=0X2_B+((W.Rv((W.l[0X05]~=Z[0X5f9E]and W.l[0B110_]or Z[11188])-W.l[9]))>Z[0X02bB4]and R or Z[0xdb2]);(Z)[13195]=(R);end;return 0X1__4,R;else x[20]=(r[W.A]);if not(not Z[0x1__dC])then R=(Z[0X01dc]);else R=W:q(Z,R);end;return 20,R;end;else if not(R<0B1100111)then R=W:F(r,R,Z,x);return 0X14,R;else(x)[0X0016]=r.readf64;return 65353,R;end;end;return nil,R;end,Ui=function(W,R,r,Z,x)x[51]=(nil);(x)[0x34]=(nil);x[0b110101]=(nil);R=104;repeat if R<0b1101000 and R>0B100111 then(x)[0b1101_00__]=(function()local A,_=(0X48);repeat if A~=72 then return(W:Qi(_,x));else _,A=W:ni(A,x,_);continue;end;until false;end);if not(not Z[4296])then R=W:_i(Z,R);else R=(0X35+((W.hv((W.av((W.Av(Z[3360],(Z[0X2_39a]))),(Z[17401])))))~=Z[0Xd20]and Z[9834]or W.l[0X9]));(Z)[0x1_0c8__]=R;end;continue;elseif R>104 then W:vi(x);break;else if R<0x5a then R=W:wi(Z,x,R);continue;else if R>90 and R<0B1110001 then x[0B110010]=(function()local A,_,X=0X0,0XB;while true do if _>0XB and _<0B1110101 then repeat local J;for t=61,352,0X4__0 do if t<=125 then if t==0b111110__1 then continue;else W:ji();end;else if t>189 then if t==0B11__111101 then A=W:Yi(J,X,A);else X*=0X80;break;end;else J=x[41]();continue;end;end;end;until J<0B100_0__0000;_=(0X75_);else if _<110 then _,X=W:gi(_,X);else if not(_>0X6e)then else return(W:ii(A));end;end;end;end;end);if not Z[0X2A6]then R=W:Di(Z,R);else R=(Z[0X2a6_]);end;continue;end;end;end;until false;(x)[0b110110]=(nil);r=nil;return R,r;end,o=false,ei=function(W,W,R)W=(R[0X5DFf]);return W;end,Pi=function(W,R,r,Z)if R==0X63 then R=(0X66);r[5]=r[0x5]+0X4;return 0xeb__25,R;else if R~=0X066 then else return-0x2,R,(W:Ri(Z));end;end;return nil,R;end,qi=function(W,R,r,Z,x)if Z==0x88 then x=R[0B110010]();return x,21256,r;else if Z==0X4A then r={W.V,W.V,W.V,nil,nil,W.V,W.V,W.V,nil,W.V,W.V};return x,23239,r;else if Z~=0X69 then else(r)[0X9]=R[0B110010]();return x,23239,r;end;end;end;return x,nil,r;end,dZ=function(W,W,R)R=W[0X33]();return R;end,G=function(W,R,r,Z,x)local A;(x)[21]=nil;(x)[0X16]=(nil);R=(0X67_);repeat A,R=W:c(R,Z,r,x);if A==0x14 then continue;else if A~=0Xff4__9 then else break;end;end;until false;return R;end,kv=function(W,R)R[0B1][0x1__B]=W.H;end,Bi=function(W,R,r)R=-0B111001+(((W.Av(W.l[0B100],(r[0X239A])))<=r[7729]and W.l[0X5]or r[3506])-r[28333]+r[0x071__ef]);(r)[30338]=R;return R;end,M=coroutine,HZ=function(W,R,r,Z,x)local A=(x[0B101_0][Z]);x=(#A);for Z=0X59,0B11100001,0B1011100 do if Z>89 then A[x+0x02]=R;break;else W:pZ(x,r,A);continue;end;end;A[x+0X3]=(0X3__);end,zZ=function(W,W,R,r,Z,x)if x>43 then(R)[Z+0B11]=10;return 0XEa90;elseif x>0X7 and x<0B10011__11 then R[Z+0X002]=(r);else if x<43 then R[Z+1]=(W);return 15535;end;end;return nil;end,Ti=function(W,R,r,Z)(R)[0x36]=(function()local x,A;for _=0X06a,194,0X2C do if not(_>0b1101010)then x=R[0X32]();else if _==0X96 then A=R[0X21](R[0X2_3],R[5],x);continue;else(R)[5]=(R[0X5]+x);end;end;end;return A;end);if not(not Z[32135])then r=Z[32135];else(Z)[0x1d3A]=(-0X39536eb1+(W.Jv((W.Rv(W.l[2]-Z[0X64d0]))-Z[0X28],(Z[0x43F9]))));r=-1318841132+((W.Pv((W.Pv(Z[476],W.l[0X5],Z[0x736E]))-W.l[0x1]))-Z[0x11__69]);Z[0x7d8_7]=r;end;return r;end,VZ=function(W,W,R,r,Z,x)if not(r>0X61)then R=x[0X33]();Z=R%0X8;return W,34664,R,Z;else W=x[0B110011]();end;return W,nil,R,Z;end,ov=table.move,i=function(W,W)(W)[12]=coroutine.wrap;end,U=function(W,R,r,Z,x)local A;(R)[0xC]=nil;Z=0Xc;repeat A,Z=W:D(x,R,Z);if A~=0X6c0e then else break;end;until false;R[0Xd]=r[W.W];R[0XE]=W.t;return Z;end,JZ=function(W,R,r,Z,x,A,_,X,J,t,z)local Q;r=(nil);x=nil;R=(nil);z=(nil);for o=0x61,0xbC,0B1101 do if o<=136 then if o<=110 then X,Q,A,Z=W:VZ(X,A,o,Z,_);if Q~=0X876_8__ then else continue;end;else Q,t,J=W:WZ(_,J,o,t);if Q~=0X5377 then else continue;end;end;else if not(o>0Xa2)then if not(o>0B10_01__0101)then r=(A-Z)/0x8;else x=t%0B01000;continue;end;else Q,R,z=W:KZ(z,x,t,o,J,R);if Q==55074 then continue;end;end;end;end;return Z,X,t,R,x,J,A,z,r;end,gZ=function(W,W,R,r)if W>0Xab then if r[56]~=r[0b10]then else while-r[0X38]do local W=0X3a;repeat if W==0X3A then(r)[0X31]=(r[0b110100]);W=81;continue;else if W~=0X51 then else return-1,R;end;end;until false;end;return-0X2,R,r[0B110010__];end;return 16895,R;else R=r[41]()~=0X0;return 59218,R;end;return nil,R;end,di=function(W,R,r,Z,x,A,_,X)local J;x=99;repeat if not(x<=0B111100)then if not(x<=99)then if not(x>0X66)then _[0X1f]=W.P;if not r[17401]then(r)[0x1_d04]=(-0X6dd8078c+((W.Pv((W.Nv(r[0X1169])),W.l[0B10]))-r[4457]-r[0x3306]));(r)[0X493]=(3429428866+((r[4457]-W.l[0x6]~=x and r[0x28]or r[0X6383])-W.l[0X9]-r[0X1Dc]));x=-53175+(W.Rv((W.sv((W.Rv(r[0x23F5]))))+W.l[0X01]));(r)[17401]=(x);else x=r[17401];end;else if x==0X7A then for t=0X0,0XFf,0X1 do(R)[t]=A(t);end;if not(not r[0XF77])then x=W:bi(x,r);else x=(-0XCFE4+((W.Rv((W.Av(r[29167],(r[7428])))))+W.l[0X1]+x));(r)[0XF77]=x;end;else _[35]=Z([=[LPH)!!1rb,Qn/O9*>b.7K`r!C'5(N#R!j)1'B34"e/s(1N[>?":,,c"@*)p"Bbk@":537"9\jP"Af5H:(!In:3:_lAR]M!"IK=4"F:2E"Hrt/"??T!"=F=8"D\,Q"B#AD"="$O_/]Zc:OiEF!!GCe('Hi)IKXNk*X$Eb"U#eJ-j4&`D$17M3WrdmG6BAu5m.i(.0O2b!<c1$&HjTe-Nn>j"9]eL)$ED3*<ZHI!7i\(">'`WRq`'CEcc@,"D;Ud"BGX^":YKCed_f_6j*Ri!-f4]"9AK&":G>N"Dn8c"C2-3";h7B"EXbi"@rYp"A/f@":>8J"9o!U"D@ot"<.J8">p<)"=41,"DJ!Y"==70"A&_1!A;r5A8)UEBln6(G\)/4FEM))6$REgG7gKWp5EPm$1J+COrnoKs*+MSGUs`M!%JZAJ_$(h!B/L4eJKNU"HEU>(dfk'B^n[N=k5gOgg54+IF\nMk"g4&Sp1@TRi)qfF`'VNGf^)*0K(%pZMTT*!a+#,2qC7t!Ai:0ecf:/"IfPdBQR["f&eSJ^N]tA";ufG!AN)lDdrp>!-id.Ri>F@Ch7,\!Ln@C!=[OTBm;'0ehH2d_?:!!IKWUQ;L#AJGQ9^I$710(ec^?NY]p1./1##=QH`5!5H>0t]?A?Ao<*<O/pKMRGR3o\!'$]TDJ9<EFE1r6_oS!c":*L0o>Tg9")laG"9[6+"L8.GGVK?P)=.*LA;h@M$a=ji<s0=kCdSMu:31Jb"D)FY@gSWPF`2;=ASu4(ie!SCSbdR8k'.Y>GQsjH"0&Rq$YT3YG\.()%/;Kb:3ULWGP;d&JK16"WW]@*@71EkDbXY^G\gr%=I^7DAOHlpDfTr@B5VF/GQB/B0U8][\-/f7XNLlo"?Q`7<)/p4A0>GsB6@Zp@VKX$H#d>6+EM6>F`Cu5A7]dq+Du*?F^]Dd@;Km*Ec5Q3+>._P@:a7OD]iV4+Dtb0F`S[6Ec5o9BlkJ>FCf5t"BO)+!!/:.G]a,i5'K=`"9Cm@Rg0(QFCdrKB5V9SrHN!tGW'Ti!6OIT6raD[GVX,M@<k!@>IA^#;ZrR.G\)28&ho(IN7Lc-"Wu:t"9Ak\G``,74_Us6a5sXP!!%6jSp159P6;)o#CP),P6)TP"Gm8`ZVu*=;g9>sGQ\_U2WH)l^]4AN._g3l5Bp\Aec5p0T[j,Ieh[F1VUbjn7/(p,+*]k("<#M@*Cb9^]%.mHetN9K\9J7$":f6=T9"6)kQE,]RfO&NFCdrJDL$:h!ohd@"9B1e=pK<BbgmNQ7hM3l@8q>[DImHu6Z,\AATi*:AQB&*Ec6&0mO!07/pJhtGTD$#!$tP!ak"c@Bg?nE_$#3mGQH4C#[-]YH"$oGPB^Y\GX('-!!R9!F@Ze/AQ*Pi@qg+,"a8I.Mo"@sGa&=o!1hOQGQ^(Y!:(agOgT7T#?B>)"e.g]@ru-r$%dD8V0Ef.Rl<I\Dg5^o#A2P-GR*We/,";a)&<s3f(fG0q:5Sf_(5]k4c"oNRs<Thec6/9<Hnc'GQ>$(!lmgm"16O%UiUb\<HoBT"@cm:VGh_3hKTMQGR"V".18MRl3+HsRfQR@FCf(iDe<m$ecZQ8?j$[IGQB8E3o^QoRfi]ADfS;RCgg@]!5W5hej!OB<s/OFAOd,tBkTkUATD<tY?#mc\9LFjejhur=4RSh@Kr;)AS,OsG6FCU"E\?defk6.<7V<S"s;D#F!ic5AS-$q+=D>MDJilm@j#l3B5V-kDIjr%DfTQ8DIm[&AoAf6G%kS3D]iq/@qBCaEX&"TD09o2![uW2Ed%eYF_,Z/g"&&9Im/)Y/9h/iRj/j)F`'VRE-YE"F9n@IEccA@en8l7W!!7,f[CmdGbtTd&7[Fr"9U4+T&Y("OT[#sRg)+.E+O%l&-QDEDfc8S@Vp7*!L%P8!!!"D@g8D.FCAa$Eh7MeTEGG#GR")s!"V-F89]poPC\pJZZLBtdWj^RGVeN1*<6HUMc\e\4Tq6'G[3[@*(akRZNN2iDbpb0F$Xnh"Cl=p=BKgA$Nql`K]+hYVhO)giIH^BL#J,HZA.>=iIZaALZ,@hO+cJCiN\*qK]0"eZ%_.tiNS'qL#Ic>Z%h538O_Q^dkH"J/9ibSGR?/[2'G=3=;JPo5h1*7!dGc8RkWn+BQJ1uG][P3!^MUgGQ`oT!9A7eF(kuNDeronATDp7Y86kW!Hls04@R56"C9R\Sp6>"eibA,"F(0dRqn)rFCeA^FDc"a:i(&jFDbf2W=sMtTm.:$eijg#?3CEKrRETH:^ENrFD5f7Rr3.YDfTY!ATV@&M0P'aRi-1K@;p8kW-E3(Rg`s8@;'ifnXt,K)$D$+/Hf8\F`I_VDJ=!+L@0;!MUk2YGguot-#M3Z[>a<oX"/EH44Zhb#$TRZJ,fSc<t(Q]7W`?QBL?fYG[tW)5-N>TWY(kJ!WU_*C3Xe&GSSG.56`o:W"!<_I0t3KaTNMY4A>m%&^4u?s8K?k$_.1rBmFc6@:X1cG\(]##MY&;ec^`Y_fuF:RiecM@g#m7*<_-#6X'Y^B*Oi2@ru-r!TDUCNRg2p(=IF1"IgkoA8YgbF%HY,G&h.m2gB@S"?6>*GRajp+7fUK'a1'1S\dI5:^3C012(c<!h%V-G\-uG"^+$GRfRBW/M/)jF!Y$pEZeXnEclJ8ATJu3DImF%F_3%FBlmj&/gtUU+=SoqF`_28,p7)G/hSPnAKWES+=q&@D00?1FCB9&ASbga>9J8@,',%S+?^iQ+>,9!HQXkfBjY3iG\(E'B-9>[AS-$q-n'7V.5!5*.=E<f.g-tDG6'hWdFEh-4*#CeG[pq54HIPQZdr:_:'d<i@;U%'emq?g#FbtOFE;"]G^44J%K'j+/<CWlS$rMGFC@uY6UW\CEcc2;Dbt7gG][h;%(5q#GQf8A(tK1rRfOS]Ec5"c@;p:'VZ^R@DaOc!@qBOq)&%7:F*Mn6egT3=a4:CgFU4H=A9)7&G[Y]&$*#P&ASqX?6e6@(!`@MOAOdB&F)OlsDeX<-6Z,\;ATi*:/(WqfGQsW?Cgggm\hCm94Tmu_6W$0p+aASBGQ8-[!@2^,Dajr#Eb/ctCHhlFet`Ekp36V(GT3Xp5L`\`83)*C;5JLOiHQNRG\VQs$0;h!e0SdQEiF9dHIb<oXn$]=E<IjrDfZ,PARfb'U"7`s"G?mYek6.#,6S$&?])XD:cEV7<Rrr%GZt:Q+_l(jFc9(?SK2r+ickGiG^aDm-n,HoATJ*GDImF%Ga8JU/,"5r"Io;lD.uC<h+B,@R"fiFK@W3$G_H8(.9V)o9WV6=h_KEo"IfX7ASkjg"9P7ICi4KC#m<<>CdeMsRq?eY@<+g@^'&"a%+c/;GcV#J*kF<X;L$IiGQ=Y-(i]3tmdl3YGh<-K4^,"-20]7f"98ca6NrtFASuF&/KjY0_)DKK58flX#,A,AG`i1S.E$9`rmI<]NU,.S!!!#8Rj\ERAor.u*f>2%hZO?Se4mf)>M=<d("OUk^qFss\TfLTeclEX+P$QErkNaZ.!RsHGU!Ea(gL?m-oqa*.4\pT$4T%#Gch0T0B4\_@oE]'DImC"Rq["8G@>LreoYJE5^3=ueeZ`;h0/q9"HPuMGc:hI4a6lkAQB&*Ec6&0!L)(i!KA%C@Lm\`YBW$lGQ>++)=j!%9PS9d"OYe6#Ff<.Ci=6$Rr2YG@<-Gr@:EeX_ZXabH^W<+4DB')i<1_WFrO_3"$P3>_#k>$547k-F3hCA6O'"hD..HSejKXPMZa*+"2-I7@K`/5"E\R"!_q7qW[<+<"L/(X">9mA!D_3GL$%B>!!%6ICNog["A*fo6YCWrFY#VM?],ZpRm4K6An=X=[Uj]*=OoSnAd"S(q.+AWDd5\T"E">m@2jGn#+KgD@r?3p;q?&!:^3BoDImisKWB?>O9?X]Di,3Qf%pNULNiit_&+F05(EV5k129j!Zfhs0#CJ1!K,G2GR'Mb3sD65IQY5eWiNrW)[&@)F(koL@<,e"?$L"&GTPFW5;p_T\j?gMEs\<mFE2;5@rcWtj*2XKGS$#g!!cutjt&.g#Hps;ej&0]g3<YKed1>4f@C&)=aQV=+EDUC+CTCdBm+B*D/O94+EVL4F(K9#FDl%>E-64EFE2;=@;fs)Ec3(2@;fs)EccA5/8&j7AS?0.De<R$Gp$[=@3B]2FWb79CgpgjDfd+5ATMu:Eck%u-YRI-9ICs(:1$Og:fUju<D5\Z+=C)VEarNp&">1im$PENPO,WcK=1#u"LbQ#"lIm$ecJ1h$C_)aA79CmBl\<:&d2ibGQUgo09>'9P6)-C3f/*6Fk-O%RjnOABjY3PG\(E'rHN)\GXtr2!!FA7jf3TNGWQ$O'NuKh-3PIpS'X<C&r2r<#mgnF5V=/c.PE1r/hSb-/hSb/+<VdL/hS7h.P*,',pOfk/jMZK#mgnF+=\c^0.\4g,paca5X6YC,pklB0/"_%-n$`%,pOW_-mKr].Om)"+>,2r+<VdL-nd5)#mr:3+<Vd5/g)Vs5X7R\5X7S"+=ng(-7CJh-9sg]-71&d5X7R]-9sg]/1N%m/hSb//hSb/5X6VF+>,'-/gDni+:/>]/g)es5X7R]5X7S"-m0W^+<W3]-7C>d5X7R],pklB/hAJ#+<VdL+<VdL+<VdL.P*1p-m^)d-9sgG.Nfi`#mgqi0-Dej5X7S"+=]WA+=JQd0.&"s,;1T#5UIg(-mh2E5X7R]5X7S"5X7S"/1Ml0/hSb/-8-o&5X7S"5X7S",q^;g+<Ust+<VmO5X7RZ0.K4P/g)H*0.nOq/1rJ%0.\S+/hAJ*.OZr$5X7S"5X7S"5X7S"5X7R\5X7S"/gEVH5X7RZ-9sg]$7-fI0-DAD5UITr5X7S"-pU$_+<s,t.OHJl5X7R]-8-T/5X7S"/gVes5X6VH5X7S"5VFEK/1;i1/1_nd/hSb-,q:#[,="LZ#mr.)/g)8]5X7R]5X7S"5X7S",q(/m5X7S"+>+m(/0H&X,="L@.OIDG5UJ*+5X7S",;(Mo5X7S"5X6YL5X6_D0.8/4/1)br$7mhQ+>5,c5U[`t,pjrc5X7R]+=o/m-mLu.5X7S"+<VdX+<VdL5X6P:5UJ$85VF6,5X7S",pO]e5X7S"+<W't.NfiV5X7S",qLB./g)bm+<W<E,:kJm-9sg]0/"^u5X7RZ5U@O+5UJ`]/grtM+<VdL5X6YI0.JS&,p4<[+=]WA5U@Nq5X7S"+<Vsq+<VdL5X6_?/h/7r-7(8s0-CTS5X6tU+<W3^5X6YE+<W3[00h05-7UPh5X7S"5X6Y@-m^)a-9rk*5VF605X7S"+>,!+5X7RZ5X6Y@,pam'5X7S"/1*VI5Un08,mkkM5UJ*0-8$Dc,="LZ5X6tF-7(oB-9sg]+<W9i-nd+o/1N;$0.n@i5X7R]5X7S"/3lHc/gr%r5X6VK5UIs*,:GfB/hSb),:4ro$84Xo-8$T0-8$Df-9sg]+<VdV5UJ-,5X7S"5X7S"5X7S"-9sg]0-`_I5X6VD5X7S"5X7S"+<W3^5X7R_5X7S"5X7S"5V+QR5X7S".OHbm/1)\N/g)Gd+<W-\5VF6&/grtM-nHJ`5X7S"-nco40/"t30-DYf5X7R]5X7S"5X7S"5X7S"/0H&`5X7R]5X7S"+=nj)-9sgE-pTF8,q]NX-pT",5X6tF+=KK?5X7Ra00hcf+<VdL5U@m&5X7S"/g`hK+=9?)+=n`g5X6YK5X7S",;()`0.%tp5X6PF+=]WA5Umm!.PE,6+:9SF/h\P(5X7RZ5X7S"+<VdX5X6YG-7gbq-mh2E+<VdX,q(;e5UIdB5X7S"5X7S"/1N8#5VF6&5X7S"5X7S"+<W3^+<VdL5X7R\$8*qr/g)W/5X7R\5X7S"+<W't+<VdL+<W9Z5X6_?5X7S"+=KK?+<VdL.P;hd5UId*5X7S"5X7S"-9sg]+<W3`.P<A,+<Vsq5X6tF0.n@n5Th0V-8$Dj5X7S"/g`hK+<VdL+<VdL+<VdL-8-to.R66a5X6YK5X7S"+=nj)/1N,#+<VdZ.P*1p/gr%p,="L?.R5:&5V+$#/0H6(-4(#(5VF625X7S"+<W.!+<VdL+<VdL+<VdL+<VdL,;()]5X7S"5X7S"5UA$45X7S"5X6kK5X7S",qL/c+<W9b+<VdL,sWe0$6q)E0-DAD5X6eA,="LZ+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL,p4<Q/1r87+:/B"+=JW\5X6YK+=]WA+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL-9rdu$6q)S+<Vd5+>+un5X6YI+<W4#+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL-m0WT/1r87#mgq`/gDJ]5UA$*0-D`0+>5uF+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL5VF6&-nHtt#mgnF+<W<i/gWb--9rk"/0c\s+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL5VF6&0.ne@#mgnF-n6>^5U.Bo/g)bm5X6_?,sX^\+<W3g+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL5VF6&.P<8;#mgnF+>5AS-9rk"5Umm-5X7S"-pU$_,sWk$+<W9i+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL,9S*O+=ocC#mgqe+<Uss/g)Vg,="L@5U[a--9sg]5X6eO5X7S"/gWbJ/h\[s+<VdL+<VdL+<VdL+<VdL/h.td/h//"/3lHI#mr=.#mgnE/g)W/5X7R\/0HJi5V=045X7S"5X7S",q^`65X7S"/g)H*5X7R]5U.C$-8$nt.P*&75X6V<.Ng>j#mgnF+<Uss+<W<[5X6YG/1!PH.NfiV5X6YE/g`hK5X6P:.R66a5X6P:-m0g$+=]WA+<W9f5X6tF+=]WA#mgqe#mgnE/gEV(5U.m(5X7S"/1;i1+<VdZ+<VdL+<VdL+<VdL+<VdL/g)8Z,q(5o5X7R]/g`hK#mr(5#mgnE-6NU$+<W9b,qgkn5X7S"5X7S"5X7S"5X7S"5X7S"5X7S"5X7S"5X7S"/grtM$7I;F#mgnE#mgnE,:jr[+>,,s+<VdL/hS7h/1`>'/1`>'/hSb/+<VdL+<VdL0.\4gGR=d&.c]"fN<HBeGQMj8!1s?YH3?D7;\ZQ^F9J(k"D`'eeu&X`MKg$HRlePoFCf(iG&Cl'":+kU2/mdY#+GbeBkVR(<7Z/'7iIiu@8q>[DImHu6Z,\AATi*:9Oi*/FD#K&(-6\R)k/0?:ip8=FD5f7:Mt)bEcj`eE^=8[DIlLOG\D23/(_bhOOe+K<#;#/D'3D'FCB9&ASbga+EM6>CL_:!?3FeM"e,i%F_kJe!BAYA!Z?]:"RO\aBE\<Z!?BYjRfdEVE-ZO0G\1l*!A4Z];t%kR2Y)(o6NfM5KhgHKG6FBseo5&<p+-4a2lueP"@'0&eoh0kS^n"&8HYFeG1Js#^hS)p7X->LGR*`0BUB;#GQK>F!0\+TH#s1YGBd\<GW$sM+Vi@kYZV3UGXV`Q)/?5$GQI$Z5$R!udb"gVk`q*^"G6hA0Yhq&k19S4d'n6(%\"V#FEh@lFD5VmFCSl_%0U]iS,Lo$Ec5ChjE@=MmQ<Vj!?]lW@8[<!D/Ws&RWpjrRiUr8@:aHa1,F&`De93CFCB$,_Kc(`"<h-%CB9nI!!!#8GgZ^Z!+p(ZF]&R9Eb/0eARfFt%@ctmEaa&g:i^,hAU.^##KG>8!!!#8![6,Y,M$6*!T)B.JgY_d!@cSUp1aAJEmJtj[<N=.em+<2[KHX?P1FJpGkV=A04ZjBEd%bXF_,Z/"B>RaC_*#lCij`,A7]XmDJ<]ocidljecbaNUY-6(!!%7#^3BYY"?\KeS#HO^FCf(n@<?'tCgpgp!FjVk&8QT:GS(&m(P3-LRfnMtDfTk'ATV@&P6RE*He<S[;Zn'c99]3s":`p5Ao8$HEc5i+Bl%3p"e0(LDfTl0GbtUa"/.>*$t]$SS)OS)EFi#VFE;#9DL$:hg)P?I1FsjB?+k`+"@'<Ddu8O&o)q8tGQ]/?0WH\6g"&LnDprq6Fa#i>GcX?T"7t8:f[/#j@g/>FATMd+qKV</GS^L/!2X1WAPNW&DFnqpAS5Rrer0`PH?]HP";^_@!?ft;"9DZV3V[j<gNY\`"@)Ys#+a>I#+JNoATMp$HId1Y\m]ga37\'4!o2?/KlTh2"Ao:UD?u_tG@bW"Rri(PL]eh$JU$;[egh<G9`tK;7Tkn!r[)ji"Ig*DDe<m$DKQ/QCL^dl.$J^sGU3JK(LJ''WJm0g!!'hh5Wr8#!Vb1-d_ZN>F3f(MZ$6`Zeg%T?5LotVG6jZAATVX,ehT%(iWK=LL>^'rcfB=,K%;jhGTHtj(9Op+;$>/IecT%*#1`pEEX&!7F_"ol#7f<EbTML^#*7=ZD7%9,Gb5*[!(Od(bgOLU"\O"J@!E.-"<@hO1bX*($Ca8%@r-4#F`VJ;X2/@fGWmUW(e%fKmIQoo"Y&"\@<)RAFCf*/G6K>EpE&$,Bg`;tDJs$+FCSm"F^kfKDImj/DJ<p/"BF#aGQA0&.9!BF8-F/?BmBlORq->H@r=RCEccA6@;&#RA7]CkE,GoMD..Hn-3e^9*I')Z"?\7gRhl29@Wc_o<85<8!>sAf":"AHNB2<TW08U_i1U0qehdNe+a4-heq%J3"e,]>D09_b"Jl6Bo:(""2:a/1!gV=;#b-2E@r?F$DJs62>aQsbXV,k=RWnrPegpH>FT_c`GQ[`l,rU5JS+t6Q70oB*8SrTf"Dq^lRlLV3G@bXoecOCQnTY9pGRfeQ#E`KG%IiM)2pQXZY*1_gecB=4bLQiXc%C6A#+H'<FCB94flqL[S#"g\@UX?^!1RP9F\E"/BQ.C#q.Gn9Rj8+F@qKTeD/sQ4H>.2("I'%#,:.Q%Sp5o4ec<I65'R:6"=Qdd"AT(tf+3,$"U%"mj,Q.9;[&XSASbdbc>%;$s"fuRf)PdM5Qh3=b`WukE!;_>Ci!NiQ$It+G"Hp6`rn)M"9CF3Pt6.#Jcl4/DaOi#@qBOq"Cu(cL=1;[L=Qbd".%L=GQ]5A-.OR8*s1#<6_8N.3n>^W594tN0Eb'aJL?.r6/m,XZ$:^F"=:^0XZq'/nH9MI"93+\#.N/,".MseG]R>&-F<W6UXO7.;[8dJAnH1!#b,CAD/XGaASkjNAOd)sEb/0kARfFt!7krhG6s`DF),f7ARf.fK:#J[bg!s2]m)b8eeN<%7sG(d">`<OG`r9g#O%0*Vp%5I!a+#8J-<mqLNiobedeR8HNXM<mMoY[cA$Q__07<3"OL,l"[poq6[5+(edP!2En1C%!!'h9E7V^Q!C>9<eO.f1SE+lK_0F/oecZdfQ?WSmRh(Iu;fbM9Bk2@.":130#Op;d/-3K9_+idS5NHIi"9D6JnUl%6YQWlX@:KM2Ch7*oARkt6G]IA-&M9@d5+<418I1esBl$.X"E\Nm<,Hl4QNRh=nLTNA"npLQjTJ!T?5:;$@&8)h\p,R!efQ,UjEL\."=(=q_!cN+#Fb]!DKTl-RsJmmDJ<npAn>LaA7]XmSf-"%GX;NX+#p0*K[fgBEt"N>ASlO#@<>q"Rq6DFDJX@tNn.fN'8h#8&pQBLeck:A!L!O`GQI!Y/j_>s@86rp3!<f0ARkt6RqHkQF`V0u"'a>cF`%DQEb/]sIQmjXE!2YFG\^et/#H^>Kn(+e*(G/_mW]XK"9>Al#.W5d9>(^X=TP!JDFk,'DIIX./9k`9GWN?822BLX":,"Y#E*fY?$M&0emg9iN7J.9f(fFO#+GVnASbq!!Ln1@NurU6Ib#X^!EI\ObFTr'p,@12RKV'1'IkDRP>DB'">p;e!p8'^RfYY%@;'-Rh`uF,$e?ZFs/C5ECt9B5AJ^g<Ec5u=+Dtm9DfTl0@;$d(Bl%<tmac#goL!j(-0#cl!Vl`r"Q$-_!!/`t!$V[K3Y0R;#S76Vn-&J"PRR$_O:SPrOp$jQ$'5]!!!.il&4doD.!bjnM#\Uc!#P\:VuRZN#ad4cTF)L^!!!!"z'G(BL"Q%''!!/`L0IQo$#Y6od5^ED1!Jpf+O>&?g!%95r>Q?0g!!!%mTFr'.!"+f'6Dleh!!.oV;)Rej-ibYDR5ba3n-b$Q-3<TB+9C[C"i(/%H2n#6!&O(/0E;-1!!/a7#UfZQ&1@MYD$T81=944k"KrY@!Kmr&%@@9ch]R4F-kIL(-n#'$+@n0t!ME$bM#[MUO"^P70JH?--ioD`!MBcJ&(^d]0JG1X-n#+X&25L4!"_[\s$1l1!ME@-zz"Q%?/!MBJK#,_G$1`.',!!!%m!L.U1!e^a/!!!%m-nl)9#VcO];$NpPTGeXa#QOi*f)hI_!ME*i%0uq6$*Yg;3!dlJ#]BnA!UpHc3"";-i!9M=V[]:-#.SCP%1il.#,a.7$9/SO!!!%m!Q9!iTG.R]-ia5J!!"-4-ibZ3#R71>#,`(f0PDjG!MD8Q+qO_SH2mpF!!KJB"kOlC!!/`b&4d',!MC>2O;Irt=s+pg!!!%m!KS,>&ssBc#,`(^.WQpC!oO76+9V*N+DqVO!S@kN\.A\#!K7j'#k/+e!Kml$"ipk'!!/`B!JD?kTR.4U!!!!"z"9Yn;!g!KZ+[oCBTE;fD*<O1]X9@G5!!/_p/cj<!!RMthcnJr0!KI-\co=Xi!!.iUTF$iJk5YJ_#Fo?.TF&85!!!!"!jj?o!!/`l-qJ:W5Y-,"8-+5@"ge8;!!!%m!!.j_TED8de,TIL,DQR3!MDe^E]=%!/=-D(!MBdiH2mpF#/:2C!P!FUH2nA?#_rGrN,o$(3!]Kk#Uff<0E^JtY;gh.!ME?rH2mpF!!_=_"Kt(:!MBXM814H<$,cfT!!!%mNsPs-9EBqR!!!%m!"_[dVu`;W^]o;kkV+=o!Kp7h"/$+]!%:B7!'j(W!MBJ#814H<#daRK!!!%mCa^2%!MB_*#*])f!!!%m!MBPU08BN-3!#1)!MBUT!V??lW!8k#!ME?l!pfmeW%@BD!MDa[+rC:[NW9%Z!",%ncQIN6TE2nu!!!!"hZ8gbD%48_#cJ!\Qr=.GkU4+GYQ9mp!!\Mf[fN.JErh@'!!!7g8,r[I!(]X7Y=Ns>0H'pY!P8E_!!!%m"M>suTE=H[ci=%H!!.iU.07cq5M#q_ci@PU3Y%MX:f%2^^_-;TPR!9[!"\8o!KmoE$.oF>pAp9S!RN530E;-/!!/`"5^ED1"oJS&!!!%m!J#IrF)V>M!!!%PBE/<+j8^l)!!/_nEWN*=8='Ci!MBM#O?`dG!%95r6RYK8!!!%m!!.j?D%(qs"Q0E==AoC]%tF`5#*8kK!UL38!!!%m5U[^&!MBSf!Jg^U!!$\'+E.@3moXl9TE2\10E;(R6i\W+!!!%mQO*`"EWLt"!!!%m!!%*@!MBM;H2mpF0I4t@!!!j,!TPjP!MBJ[F8u:@!r;ls!!!%m!!%*@:ad^lY\aK`^^..Mf2trPOoa2>\-B/<!MCtOH2mpFkQB^EW#0@Y;[^qV\-:J<O9(LFTJ?c[JcGcO3faRJTE4%Se,TIL0#n8!TE3hM-ia5J!!!9q.H`[:!MBIVH2mpF-j6_=#XBd[?j#RO"6VWLE-_LtH2n/1"4M15!!!%mV[3E^b5mD%!!/_p=F'rI!MD2,-ia5I85L-WEDQWh!kSF4!!!%m!!.j'=F's<TE353ci=%H+."S\@fQPV+9BhS+@WId!!/`D#m'VtUKB\*!!/_q!ME?k814H<!S[Sk!!!%m!J^^&!RMqhNrdTV+CbC?%Zg_<cj6:];[:AN&.uBB%%mWa'<hq-n-,a=Frf3;%`esLYUp!6F:c4s!!!%mpB^oU"bTna!!!%m!J^^&"M,]UckFG+#mA-H!QYG:!MBJi(?b_u&'+d(!K[r0!!U4a!MBS5814H<82(#L"KDGM!!!%m!!.j/TE:PnYQ+Y(!,Ee[!MBS=z#QOi)%1<7O(C(lc"Q%?1!MBLQ.6%;-!#;[s!&ssg6`0sF+=SEU#,k,^^^JM+;[e0aQkPN7fE%-9!!S/f5IUZR!KI..3%u6%2uiu7T/\8Z3+Dq#<Y)]"#J_,-!KJ29#H/L7YUp:In/]jj*7-DQBdae%$K)B_!KIlh"je-c!!ksm3);L>O$J.*8:D*P#e1-65QRMq5]-UQNDKtdkQf`@!K9PZ#f$Rn!KmMG#P\A)!!/a?0bpnm!pBmILG4#S!J`WYBJ9DdTQ;YD(]XO:!!!!C&=4Mck9tWV!MDe<NW9%Z(a73+\8;\rW""7eY:*<TOpuq'fE%WG!J`W?TF(Z!2uipZ!!!%n&-!;&3,ARSzi<]Ja"9RZd7:cLb$6`DdX9@DO!!/_nD%2j4!iQHn!pDug%YtOl(_=D;&-Ds#!#Pa(!ltkUO@9M\PQL=Z!!/_p!LY>9#N,s)(a][,!l,)_#fm%0C]Fn=8.YbL!os=e!!!%m!!%*@!!.j'#m&g(67<Mf!!!%m!pjqm!gH6r!!!%m)a$[3!ME@V+p\/KNW9%Z!(j'hcN0%+3"Q??&.es,(^&q\cQIN6.!bk,!Ls@L!!!%m!!.j'-n-PE@fROQ&AT[o&(go=%c@iTL]r<T2@@e;*0:e`QllgQQlPl;&_JT?(T7b0"5!X9(q:ZdfF-UY&f$cS'!N@+!!ksm!!.il!MFNOLF<-&-jTeR')*e'-jX;_!!.j'TE1Q2!!!!"9U@GZf/S'V1ik&M/93uUTO]_-rr<$"5YO9]!!/`L!+$KB!MFHM,:ENlTQ1#@5QCcbmfB/'TE2,=&-)\21CsOm!!!%ms(cX?!ME@4,OYU4dm-Pg!!/_nmk-!g@fRn`.3L#e!'-r"$',+I!KI.6-o_n75QCh?f-i'r5[sdE!J`'O&$R/V-kE7;8@K9]!MBjo%[[9]"MbCq#Ijet@fQi!!V.W]!!!%mU-(9aTF*pbkPtS`'Z`NR!!!8n#ljr*YsAMp<<T]4+`1dZ"Q$ru!!/a/mk,.ONW9V$3#Ul[QN<*HNW:1o5TIfF!L+54aERmP*M>Ct&YKH'a:X5<&-S($%Zh.(W#QH.#SF9Tci^K\<>pB0$EsipQj=7j4:eA)!!!%mf)^m3LBmlB&-r7:&-)`d#QT>Sh["N.!J_3nTKEJ[!!!!"kPtlV%+muWNW:$n-lhs^QN<*H.0qU8!'L8e$g.PN!MBc"LDU!k!#P\:fFS%4$.s(s%u:7Z)nuq_!Kmo="gA<k!!.il!JFr*TR.Le!!!!"zO9)<ehup7dn,nmUliaj$#m6k&>Qiot!!!%mJ6`]<0F!md5QCh?a#JAF-qHTs!J:@P>Q?GX!Q4sT!!!%m!!jSF!!.il#Y6'<!MEBlTIU!B!!!!"!!"t[!$E*iW&QIZ".2+Ti"7(kkQ:M_%DWbjIfKi6TFrpY)uos>!!!%m!!/c1(`EAS!MCZ*!N?&!!!!iO-n$2d%#=qP"Gd8<#ET3<!KmWU"ipo3!#S6\!!/a-#XeXmz$NL/,g]ZKN!!/_n!MBi$6i[2e85K9lJkuG<n-%YM4TWV7"eZCQ!LF(Z"/#h]ct`uea9KuqL]NDES-@OQ!!/_n0R<^!!Jpf+()\4pTL8c.!!!!"J,fRX#5E$>8I,j2%IaDV!J(WW$]kOqi'e!O#R[40'%[Ck"g:u=!MEZt!J(4N&HFL#nGkNa!'h;$8/;<$!MC,,(XN-^L^*Vu!MFH985K9d/PlF<)?9a;TF)<.&-)\2([ho;!"_[Dk9tWV!ME=Nz#QOi)%gs0c#oa<Y"Q%?-!MBM,C]FG8@fQKONW:1%3'<6&!KdWV'#4\'YY5OW\/!p,ciJh)O<*7"*f*Mk6i[b=H2mpN!%#)k.CT><!J_d7$-44h+9d9V6^JK0$(qFR%'Tbs!MBn+%?LUR@fQl"LEI]^+:%rJ+dX<#+:)HW!!/_q!J_ct.3L#=!$:;G!$E\"1Zne!!J_dO.3JTj&e"^^!!!%mLfb^[&-_P."LfM&?RU@7-m/sAO!oGg)$nRnfH:R+^`[M'N<\SPL^<JN!K8E-%.FG!!KmiC#Cm>p5edsT!MBcB+qO_SNW9%Z!(>uN[hsDk!J_d+TEGN#^An67+A-30!MBIWz#64`(#n77I#nn*obQQeI!!/_o!MBPqIL#oR#RAC("lD:g3%tdqQT0F")%44acnGO2pb6ReN=!*%a9njH!K8uB$/bs-!Km`@0G"?E0L!5b!!/`DNWSDE^^ncm!KI-s!"]P48=opC!KI-s$m6G.!!!%m!&/3h!!.j/3XUZC0JElbJ/"%YPR)dIn--#s!KpOp%JU7^0E>S_98>,J!J`?WTEHYC0E;(R0CLSD0IUE2ODP<&kR6S_^E?GU!Ko\g$\/B<T)jrP!U)3D!h]RX)R(=QfFuVF7iV4('?CFJa8cJ/hu^Cp&+Eg=*/F[['S$4J&"!USa99R7#XeY1!$W6[+F4"fH2o/(0F[+m!!!%T+9@.9!MBcRz$NL/,O9:%:TE;e.AHKgP<G`mJ"Q/MZ!MBjS80@m4$a]m^!!!%m"ls];"oL$/!!!%mS0/^MTEhh1A,lT1!!!%m!K_U-TE=1-qu?]t!lkTOTF&P]!!!!"^B'.:!LY>;"3:b`(a]d_"RlSf$`F)hH2nK.3X2KA!!!%mcNsZC]E+*(!!/_r#mQn"!Jh`Q!MBJS,@CKO$(Lun!!!%mY5sX`.53_L!#W1!18b/589t8$H2nMSBGpP@8,r[GpLl!h87MW+!Jb?%#LkF-!!!%m!#d(Y!MB_j#35aaBE[K)!MBP%@fQK/#a?_S!!!%mBM`1=kW9m5kR4$n-io\O&#]ifW!D6C+:.0='p&g5!Ke/E)42;gaBT5En-R_L'tA>f#,hj$fE]2C!MC,A+".*h$,eeO!!!%m2e[L;!MBIW!KmE_O>FWX!MBc#!It.M!!$Ct+D:e+!!.j'!Jb>*LN"pIUc8>T!!/_o(e?%TTE2=u-ia5J]Jq;]!!/_t!-A2@TEVCs!!!!"`rV!BTE1bh=9&=%(]XSl!MBJ!H2mpF!"t>H3!8>'mm)1!TED8!!!!!"BE/$SDu_:WGQ9]ob5bX8!!/_nk;WGAH2q%L!!:2K!,lOs?rq;n!!0BH!!l+D!"_[\!MBJC814H<80@m<"mc4;!!!%mhe7<9!K]8C!hq(k!!!%m!pjuI!+$cJTE:9!BE/#5!Q&eh!MBLQTIKpA!!!!"?m$jG&!-g[$J5iU!jEdo!KmQK#3Z;j!!.j7TE4p<!!!!"mfAMr&4e2OTEDJ"+92BB#QOm\QU#isTE0^+QN.!d!lR2i!TX9;!!!%mT1F8.+@o<S-qIG?3(REWTEM=rU&Y/o+0PtOTG.E_li7"d!N-5*TEDNF@K6B/!!!%mT5])VG^9>jH2o;,"7H8@!MBLX#n-e6lTdAc!!/_oT*ZG:!P:TG!!!%mLi!1fW"#[-Y;fGfOoq'S(^Z9)!MBOhH2mpF!!W+1'p!<[^Nb&)jE"u>,B*VaOoPOK!!/_q+=I3i!MCYK!hoYpBEk(8!MBM"H2mpFYY3kU#iKP(;[<N!^]B3uL]NYF:^"iE!!8=)W&54'OqXc$!!/_oEWLsrg]?#J!!/_oBIRTp@fRg9LM1?T0Mh`MBFiHN9:lo3"/$%s$(q<`$b-5I!QY;)!l>$.!!!%m",Le*#j;`%"KrqH!KmJN#5AJ^!MBJ!!O;\*np#'Z!!/_p#XeXm!MC,,)?9a;Ws#.F!!/_r!-A2@3-kQ)2uj)bb?tG8!!/_o!-A2@:jN*A80Ah;)?9aS"c?e4!!!%m#4Dj,TPFRYBE/#5iW'B3!!/_qNsSJ[_Z>8t!!/_r!JpdV80C_/H2mqAo-rj!!!/_o!$W6[k;WGA2uk''_C,NL!!/_qpBc0HJcUB*!!/_qR/rBLkQAm,-3r04a9KF&a8qG-O9=,>!!%!>!MBRY)?9a;633i0!!!%mz"+^g[]`\Cu`<)\6<Gc:Kl4uf3%#b>H!!!%m!MB\QF8u:@$&eia!!!%m!!%*@!MBYH83d.T814HL!L*RL!!!%m#Uh)$!MBIPNW9%Z:e:<][fMKh.8V]`r"mCM!!/`!#XeXm(e?mlTEsTY!!!!"VuQg>!MF9;$IAk,f)^D#Ooq'Up]@Z#TENIDTE"rm!-h$8L]N#+H2o&gr(d?D!!/`"TF1SsDu]k=!"-Xh!!/`:!MF`="hXg8!!!%m&&0W.!TXKE!!!%m0L-^FA3_%5!MBOZ"4R;NJ3&_tTF%CpT)\il"4TF?$.K!;!!!%mY:t8&TEgti!!!!"&-)]PGQ[+g!J#IrTI^2sTE"rm(U+/`83dZPH2mp^5R+,?UbG%U!!/_pLjB%$!!e8[`rV9JErgdoa8cOB$i"QD"m?/H"Ks4P!KmTL$E+>o!MBXeLN!4nN#2Nq!!/_s!MD1J)?9a;e,tXX!!/_o8-+eP!K[:0+ohU_!!!%m!!.j_KEL9pr*WV-!!/_p#m-:j!IufC!MBJiO>$Y7Zp6kW!!/_t5[sco!JacZ.9K+@!#kl>>$+=*!!!%m"LN2_!eLR$!!!%mh`,o^#Y73589t79H2ou*!!9&p&B@n!!MBMlR6U`PJ.8^`-3g[VQj;g\J,tf>-ir61quAuQ!!/_s-qJR_TEa`_hZ*WW#)kYh!Q+r2!!!%mpB_&2KE6T1!!/_q4<0+V!K[>H!MBS67Ge(F!LO9X!MBLW!LNiers#9>!MEpc)?9a;lN,^)!!/_oD$ehp"o&.LE)R,=%"JKL"/l6`H2n*3!'0LmQN;V_icB&DTG.A,TE"rm!MaZ9"-c:T!!!%m!imPB!MBc"!K[9]T)urOTE<7CL]@DU!'j'U!LWtM#(R#Y0I@=O%tG(M$@i/?!LOD5\c?\?!!/_n!-A2@:jN*ALKI(8o.U.F!!/_p+=SE5LKG%Y=?lie5EAnq!MBPL!V-3j!!!%mVdOfNX)h)@LG/]/!%7gJmf@rbTE<jQ(]XO:!!!!C,QAm4!!.j'&4eJTTEG&k!!!!"QN<J"Erh($-ia>@!!!j,PRJrY!!/_nTE349Du]k=GQ9-_#e0o'%ZgkX$.qKi!KmS9#KQq=0Lu4p!JpdV818EW!o!]o!!!%m!":)s!MBM<)rCVqO93!UTEDb+!!!!"f)^DJ5UZU6TEM;<!!!!"bWm"T!!/_nk;X"QH2qmd!!BELf)^DJLjB%FGQOK<O8s?C"2f-["54^O!!!%mO%:]j3%6g\LKG=Q=?$9]$KkM?=?'dj!K%tL$()Bn!KS8:kSOcM);mFo)i+ffL_&]GS-J0sO:m'E$5T!?O;bV?a8pqqH5;#4!!!%m!!.j?0R<^9H2n)O#1!=+!K_U-"+rVc!!!%mK-LDQTFq5._Z0Z;!!/_pEWM7%43%Pg!MBIF#tb0t!Jihp!MBRI"L8"-J0TgUTEL/Rg&M*R!!/_oTE]uJJ,fQM#,3=CTE12U!!!!"z!s]VJ#nIIQhUr8MTECD]5QCcb!!!%T!!.jGKEI_Mgdj[2!!/_o5[ng8TE<UC!!!!")m9:&3XEe\0JEmmO9jGPPRiQT^^HM1Op@'SQjp8#!KI-c5WC1L#QOm\!!/`d!$WNc.!bjnH2p,&!&4F,8Y7tg!!/`"cP&PDC]H^YIM`&M.KRj\!!!%m5K>BA#\*j"3%6gP$.qMpL`O8A$lPuS(RPd/O<POWJ-2GZTE1Mln/]jc)Lr,1*2jgd)h7sY):/ER%@@0[4r>*7&=<d.!!ksmhb\b=!JpeBIMb<MA-_9g!!!%m)TOfK!LZ2<#LEsB!KdZGGT38?n-+mZOp1%M\-;X.8:DBYTN_Pk\,ZL0!O-;ATM#cf(]XO:U/sU/!!/_n!MF`=+$]f+)?<;n!O=1?!!!%mk5gSCH2mp^!("pZ&GH3c!KI.&3[d,"!!!%mz"GHjV"Q#^Ns8W*!s8W-!!!ii8zhTH0)!$W6_(`EASTL8j?TE"rm$c$*j@OqPiTG.AS!!!!""kP/K!!/`,!MCA3TQC/6!!!!""99id!!!%mY958*!JMX!"1SHK#,aIh$b-Ck+9\W^YQ,'pL^j+f&$Q';"RlWR$.o9A"s=<;.2X05&-T0b"KsL.0IRAY!!/`T.!bjnTHXNB-ia5J+9\k\-n#NI!%;X`+t+?0!!/`bY:_4'+=JW@-n#:t9->?D!!!%mY958*!JMX!#KS#1cj$C.E!_=+n/qtg$`F%2"K2Ooi"+`HOorK/cj?'?!K\E.67=6)#:Kj+!K/'K!!!%mz"f2J)AHW+&73QMJ"Q%'%!MBJk$_RJ"TEp'@!KI-k!#Qi6,-M8umfAFKTEI5:!!!!"41>cILi!L/"0_b+8>d;'!KmcY$0VVE^B'>p(Vg#6!"4<CkQ)I?J.RMO%B'gC*9\9%\.O6eTE1hq&-)\2!#TW6i",m<$Fjp\;[%\jE(#Hm"NUV,H2n8U+=3Ws(]XSl!!/a/!J_ct/g)8:!$F@q+<Ve:-ia:'miX&%-t<6=!KI.&&hk3,!!!%mcNngs!KI.4!!!V/Jd;o9!!/_n#XeXmAIQ<RTGo"p!!!!"z"9eB'AShS>#?;p9*!G-6!!!%m`#r_!!ME*e(8(X-%'TbrH2n<)#RS6O&-@VH&/Zeq!#T)T`t3Os(jZ0OLEIqi$5`aD!!!%m!!/_q#XeXm!J_ct.3L;E!(4LD!$Et*'__WgNZ#VlfE-R(Af/T*a:IJO"lL4;TM#CF!!!!"-cZ7J#Up$-.1e)W@lK/S!!!%mY8A]*!J_dM.3KH-!(GK^"<\Ok!!!%m!!.it+=SEU@fRYGTPGYm!!!!"z$OI7I#7hai"Q%B0!MBMd@fQK/NW:a5-mOcRk5gSC'SnG#J/6LE"UEZa"gAodTK`q5i!$=j*mcYH!RM[NW#;NYI1b*B$A]+@!!ksm!!.j/!J`W7BJ9\lTR7/-+92BB+?&[@!!.j/0I\[]@fSNuLG1CffGFSh%`g[5k7fU(W",11fE%3BTF&sPJ,tfC@fRnbLG1D!0H^>r7/nqi0Haj*!!/`L0Pg^h!ME*d+rC:[H2mpF!)0jE+I=L&!!/`r.!bjnLG1]c0E;(R.`X4l!!/`"N"N8oJ-MYI0RaQ93.;E'%58$JILnIm0EKKZ0K:`qP;$V_!!/_nTE0rN!!!!"zTE<pU]`Q.SAKb%Tc3A,S!PAQl!!!%m!JCNu!e_[5!!!%m+O;YW5[sd2!KI-sp`MWl'(Br^&;Uji"jd:B#1s$6VutCZ!MF60NW9%Z!"AT&Nt<`O!J_L[TGg&q!!!!"(`4Z22uiu7QP_.g3+Dpn!ME(&+p\/KNW9%Z!&^YT#S8Ba!!/a/#XeXm!MD4KLCaFcn/)-+$c"e(Y7qNZi!+u?n,\aTW!Ml%J,tf=@fRVVH2nKn(c@Wk+92Ft!!.it!MBcJTI^'C(]XO:&-)`d!!.itNtNiXJ,fiYK-1^+!!/_nTE1M^p](9p([u>\LDV&9(bbpj53Eb3(bfG"!!.il(b$:MTQ3`@!!!!"z%grUJ(Bb-[hUD]JTE=H_!!!!"!%8s<&-)``!"^OY#T+ri!MBM\H2mpF(^?l\!!!%n&0NA$!!.]P&1@Mi!MD7d-ia5I-ia5YH2n3fTbr8%+92BB2uiu7!!/`d(ao@aD$QF6"K2^<+B&R(%A3ju%-R_TTbn'.!!!!"!$EC4&-)``!"^OY!!/a/!J:@P!WWc3S,`O#!"],2%aQ8D!!/c1+=I3i!J:@`TOJH4:]LIr\.e@\!J:@a-iaeY-ia5YTMl+5!!!!"TElA_fEc=(+B&7I!Up6L&&84/Tbn94$31&,!!!%m!!/_q!+>j-&1@MY(ao@a!MD1RH2mpF(d[m=!!!%n0H_bD!MBI_z"onW']`cl.>Qa$i`t/<&$/>[@!!!%m+=JW<p]6d:n-dSP\.BtoOp@WckRO6d3-kQ6M#[aX&1@MZ>Q?0C!!!%mY<XO-TF$hc+92BB+<UY\+9g@9$6U5e!MBVG,<u5/MuX!^!!/_o!K^sp&h%-q>[R_r!!!%mpE4b^!$irq0R<^)F!(V[TE#1L#OlR9#06l0"Kt?p!Kmtt"c*A]Y>BNF==HK<".TLt!!!%m!.&]O#IG^@TE:>X#QOi*&-)\S"Kr)5V[-BA!MCtJH2mpF!'pQD"SY0-!&-r7Y>BNF!MEp*"4R;N(b!-*!MBPMQiI*d!&srZ"SY0-&-*tH!MBMd*`)h:!N\mY!!!%m!!%*@!'!L\!MBIfBj^o@/k@rm:e1_m:^3gM!MBMl7pl;s#O"-DBEkCr"KrM9!VchS%F>-?"h5$:%H%8M7q`"W>%fm/TOVA;&-)\2U(@<2!!/_n!-A2@!$jf0TEVtfkPtS`("aiL7pm0aBj`ns/k@rm8k9)g!!!%m?icO#@!l?13*K],!Jb&B;CDeN"70E'!!!%m:aZ=.TE1!RF8u:A&-^Yl!MBSnLL:)^BE/#5Du^G?!!$+l?iU4a!!/a>3*6^l!MT_#!!!%mpB^kpTN`7)!!!!""KtXJ!W$k&!-A2@#XeXm&24(aTE1buirB&[!!/_oY6e,-"8!E6!!!%m!MBM+!Q+m;!!!%m!!.j'!LYVA!pBg'&1.pd#NuZ-#Cli<H2n>G!!]>\#,a_4+954d!!.j/0N';)!J`WgO>mdO-nm=U0EmLM&-*t00P:He!oaO4!!!%m!)+U[!MBJB89b+7M#[NXBP7AH-tiXH(he;1!MBLI7p#`kB`LD#TMnr`5QCcbGR-9!8-.p8"KrM!#/CGQ%JTsg%$1Oh"RlGT7n<j2/iX,-:f%@o=9q_n&3s&^=BJ+.HRM^<!!!%m!!.jg)%Nk^J7&VtY[D>Y!KC1l#+u.(O9(;RciL?Q&-7q&&h""KH=-o;!!!%mVdLrU!Jb=mR;`-+\-^4W-47O!TE9o\huSuDP6g@X!!/_oTE9uN5QCcbY6:V@TE2n4BE/#5?oVP.#QOm\?slk\!!.jgTE0o]U&Y/o!!/_n!J_ct814H<H2mpV!!KJZ"Kse2!!/`rzeHu9V"9R6XAK_,CNC@\ai0bJbTEr150E;(Rrrh\/TFR2N!!!!"[fM;2OEpm2!&TH3Y5t#:Erh(,g].`36iRGoTNhN%]Dqp4#.FmH#`JeW!!!%m"6VWTE(g7FJ4oqC"dAuf!!!%m!!%*@!JjWMO9(/NL]N#,OA\UMTN#;""98E&!!!%mOA,bc!P!U[!Or0%Q"Vu2!Ou54!MBpU!K[9](]XSl#Y4u`8-,@`M#[N(!K[9^!MBb[!K[9]!Jgc<&mt`r!JggG"KsF+TF%tR^]4?8\,hZl?idb<\,u+3TFIt'!!!!"&)VVXmfAFKNW;$\5Xh:GTEPMgTE9WN$_Re-'#5+3fGqD1(_6$<(=3-P!Lab5#.P2*i&28<L^;';!oRGf$&enH!!!%m!OrSX0`pfG!Or/\!MBjc%($!7YTj)RE)K4-TF@W0TE"rm)7M*s"H3Q'!!!%m!!%*@!MBIH;Fgcf&m/gdE,YmI=95?0J2%,oVu`gt!!.iUAJ=MTliF%9!!/_tTMe;\!MEg$!LNnL&mta-!LNrW!MBLYNW9%Z+?.=A!J^]S!N7CHW#C^L-t<5X"nVho!!!%m"Q(g[#35f@&-7S7!MBJ##qQ&V!O)Xg!MBP%8FHNYoIpV7!!/_s.fljS$&erK!!/`KE)K4,mh/`9$2e`D!!!%m"6VWTH2mtr#*/e@!K_U-TEk*2&-)\28-A$7"6VWTk;X#L#i&Ma!!!%m`sDnHj8lIf!!/_pTEP/mL]@DU!okL+TE<jJaoDDB!!/_nE)K4,mh/`9#kW';!!!%m"Q(g[TE4p<!!!!"=9&>CE!#J@!LO=8D%!:E%aYWgJ8Yq5^]pG4"n4tk"gA#pQj)[ZC'*i5#ac+3!LQb]O9(_^QiV^<TMe;]!p!_i!!!%m=@`IK8-+ePL)9nu!Jg^VaC-*F!#=E4+3-ouO&1-&TE3dN8cShlTJ=In!MD7M&mt\>!Or4"OA,bcBEb"/\6&csTE;1q=9&=%E!#J@!MB\)"4@/L!!!%m!OrSX0`pfG!Or/\!MBY`+qO_SNW9%Z!&WR6Y5sX`"LJF[!!!%m!J^]S!O,)p%'Tc#%Hn>,"1SU`!KmeO\1duG!%:A=!!.oVQ"U2s!N9*$!MBM\;G[>nLhHh!%Ytu4$MXY3YQ98lN<700L^;?.MugEtTEXfcOppO[J-"!t^f!]1!g6pl!!!%m!OrSX0`pfG!Or/\!MBVO!MBDmNs##p!MEUP!MBDm!LNnL&mta-!LNrWOA,bCQl#c'QiWcZe2,t_!!/_qTEP)kli7"d!!/_q!KI-[TEl21$K,b3%&a5p(Y:WFYQ9nP!!f_8._c"ETE=1.3WK-\YXc//TE4'R!!!!":]LK;BE=JuJ/Jd2Vu`7j!J#%q!UpA^W-A?&Muf:IQj0bqOp79S:^Oo<!MBRQ"JYqs&1@R4!!/`2ScOoQhZ9)F!L7=S8-,)[/80!#!!!%m!!/a=.!bjn"k!S+!!!%mZQfL,TR$S@!!!!"?NHO?W,2mGa:#cm!ME?r%(IM]\9J%;W-SFIQirHN",q:%\5H-'"INj'\,hC'D@!`Q!pBZ8!K@90%Hmqn!K7&h#g`dS!KmSq#FGpM!PhT(O9*.)\,j)?TEV(k&-)\2(^&q\"6VWTk;X"qH2o>q!#)gq,I]XY!MBSlH2mpFL^sNR#)[I&LB4=RVuQeu!N7FJ@fRF^WWB$u!!/_o(e@a/+@ol?TE^8Rnc/XjY[7\?TE^;TYQ+Y(-f6ET!TO3N!!!%m[hsDk+F4#RH2pF\Rf\p1!!/_qk;X"Q3"TI"&821/E!,8_^hj.gn,p`Bf6C3qOq-D%TE:J]TEVV+BE/#5QrjBSR!J`5!!ehkhZ9BrW-SG'QildX!!I?DMB`.h#(cgY!!!%mpB_%uJcW)&!!/_p!MBPq!LNie!!1On!MBY>z$ig8-!N?0\!h]UV]`\DU+[oB4WXirX#da`l!!!%m:]Z(HTE37ZO8o7])OLUCH2nAp!%><9bRbU>!!/_n!JaJO.8Vu(!$Bfh!)PXb+nl"t!KI.FPXmS0!!/_r!LY>9$]ke,#UT]$$/c65"FpN9H2n8=j8lG<!!/_pi#,o&#FH>1"3;<sVu_lK-irfF%Bokl!N61+#H.ZdTJR,9!!!!"#_tBc!!/`L(`EASTE<nZZiC(,!fmWgTE`n::]LIrj8^/E!!/_o#mQ%_F>s_j!!!%mQV;F5TE=1.!!!!"#PUc8f/S'V!MEX#!NZ8$!!!%mcQIN6-qjUr0R<^!!gEc,!!!%mHTXOeTE13h!!!!"!h:)G!MBJ183d.TEBjL@!W2ot!!!%mV[3L]!K0JR!!!%mf*MJrTP?/H=9&=%?iVTG$GZ\1#I"?8%_+bN!Kmt\BEEti$33%V!!!%m!!ksm!!.jO3XN:r:f%UociUrrPR,&,n,qkTOo_3ba9JRD!+Q!>!MDJM",m3[&D&UK!MBJATEG5p!!!!"-l<dL+92Ft"6VWl!MECOF8u:@!kJ@3!!!%mf*MK,!n8nL!!!%m(bfG"!MBJaH2mpFTR.J/!!!!""Ks5"!MBIX3%+b,Ld2(*!jHMC#d=B'#QI=n!KmP@$IAsD!MBJQLDU!k:bVkM!!!%TK4PqhTNb4o:]LIr:]LNO"gC$qh\8m`%$2S<$a9Yr%bLo7!S@F9@fR#6H2pc<:cO4Q=9&AW!!/`<:jN*AH2n3-!!r$q#L?e(!V1;.h_%_*@fT=p)6cq>n/A6$=prt#'YjaBkR[d1n-.GI*/I>p&@`:Ucj88G<$00f"gA$Cpb*/fn.M)mhuTAiHOBN[!!!%m!"_[<a"Vf>TED5"2uipZ5QDWl2uk?t!!!%n!'!Ld!MBMb!TF(Z80-"_!MBM#!eLCP3$$<O!!/`:!J`o?H2oW!:^DhI\c<R<!!/_p!MBi$TJHQJ&-)\2!!!!C/;F7d!J_Kl!l>3C!!!%mz"bdHeble3,]`Q.S[/u0dAQ<RK\914`hY[ib!ME[#LI_CF:`'05+92Ft!!.jW(_@N484X:_TEOT]!!!!""Ku3ZO(`h>!"^7i!L!L[C]I!+NW9&M!)1uF`rV2#H2n3t">PrC!!!%m"6VWTk;X"a3"Qo/!$DC,!k0S(pFpmn3-kQ1F!q(($31-\!!!%m!!.jG81@)3@fSI>LIas<Y[@G3#Ilf#cP/o@Qk-,2huT&H$1J3,$.&^9@fQYYN_i8SQjph3!#Oi7(<@9\i-GG!\.%R4*Jc9OTI^1q?iU0-!!!j,+@lN`!!/`,AKJ#TUHek@!!/_n!LNieLJUMA!,)?5?uT3r%_)P-#I"?($-459!KmtD%JU+B!!/cq!MDIRLI_CF:cJFU!!"-4"Q*=-!MBIO,:ENlTNhJDJ,fQM)OP^].7bAE!%>$A!([B**N&puTE2o+!!!!""kQk&Vu`;on,grIkR]'NOpCI`L^0RR!It.XTPGZ@!!!!"!!!"@8,ro`#QOm\$tUU^TE2,b#QOi*-J&MPT)jrPNW;="!&XEN!!.jG3Xjq;84X3JkQ9?MPRYtAJ-(6%!Kn91!e:f384[4j!!.jGTE3LI(]XO:8,uIW0E;-/i,&S3J-_eTIo'&J!Kmh`%Ian$!!/ca84Xj'!Ja2G85M8G!eUIq!!!%m!MBMSz#ljr*\H0qX!g$Ca7;X2Z"Q-*l!MB^W"T/6"O<:Y4TEMn.!!!!"43oU,mhg?N!Jb>9.;0Ou!(_lY`+Tut!!/_p+@n`t=TZA=TE`b6^]BT,=9Y'"?iW/WBE1:g=9(l_!!N4,NsQ#DTO__&Du]k=PQ2\O!!/_n&4doDTEVCs!!!!"J-4sok;WGB!!.lX`rV9JTEDh/&-)\2!!!!C5bAm>"6VWDTEM>=2uipZ5QE3'!!"-4X8kdb!!/_s!Jb=gKGk[-4A]\l!!!%mciF^)!#<Q]S,`P2!!/_qZm.O1!rN$"!!!%mU-'?t"0?/:!!!%m+D</'^]B%#J.0d8%JW'jQOVS$YRfpuCB`W+$Kqb_!K.3H!VcuR!MBMT.;/\]!&hl2!,+?%6h^VA3W[#]:f%IKpcFNNPQp%Qi!%a6Op8E&O9+hO59BS#*2jhGn8/fbO:Uh#"jd;Y&qC)"ck=,s'be(]([qU4QtZ]EoEC$]!!/_n!KI-[!%8bp)M\?R!Jb>B!L#JC!!!%m7COd\!J1@4!!!%mQq.76H2mpG"9/C`!MBLa!It.M!!%77^B'FB!MC\>LF<-&<!WI)!!!%mr+-@nTHd86$31&,O<!-aTE2D#!!!!"!!!"@!!!9m!!!"@0TT%V!%:At!!/`b!-A2@3'I<BD$b_`$MXka:f@P-!oO0Y$d\p;!iucs!!!%m!g7t6!MFK6LF<-&6jNbn!!!%m"6VWD0R<^IH2pF$!%tH756!lof1:2f_K.[A!Jg^W&-)`d!!/a?]-C,P!OMh.!!!%me3!ruMuf"@!!/_n#Y6'<TE;t1Du]k=GQ9]oYQ+]l-3<<8n-Z*ZTE12ZJ./pg!(]W]!Kpf/OEpm,!!T8$J-4so!MF3/!LNie!!.mH!LWt]J-3k(!IuL*$fD8O#Ijet!LO%H!!!%n!MBP<!It.M&-7T$!MBIV!R^rJ!!!%m!MBMkH2mpF!%mqI%*)b%!TS5tTE4?YO8o7]!TS2$TE1NP!!!!"z!l5!I7;W*f]cgre`<)\6hk(Vb!MDOX83d.TEBjL@!pfme!!!%m!!.ilTE4ZjU]:Aq.E;_t#.+D]!!!%m!!"2S!#SB0LELmCTE=aM:]LIr#4MY]"5!pQ$]l2P!KmK)%%%*H!%:B?!!/ci:e2E'TENI=-ia5JHiOFC!!!%m5U^+BfPL_hTE46[cS/9-Op1%h\..X&!KI-^!&,D]'^l'_+=SEm&F_Te^^Yg!5RkdT)TW&s!MLL#($HM(J1LuqfET\@&Vrg`$*Xlc+2@o6%EJjKW"?0W!MF6D,;9)t49,K%!!!%m!MBPER2>o(a:4dC-38W,n-,a%n,\[[]EXH+!!/_q(`EAS"M=lE!!!%m!!%*@s"Ja!(`EB)TEP0$!!!!"!+.^3#KK)U^IWYNluP,g%.F6!kQJsb#m$M9@Rr>J!!!%mcNs],S,n-E!!/_nk;WGAH2o>q!!/-79?0#<Va,P.gN,%L-ia5J#4N0@O:8pA;[/m"#Y1dP%JTseTE3grTE"rm!+8=uL]N#+THkW\!!!!".Ye%b!J`oW/jLNZN'JnK!!/_pF<bH!!MD7LLKFNV!'gMb"Ku3Z!!/`C(ao@a!J`'oTL2NU!!!!"fDknn$d`_k!Peni"Ks4P!KmoU#bV4F(]f^H5[sd2TE2tJRfEEh+m0.5!jViW!!!%m!MBMZ!TX4\85%hH!MBI^9SWTJP;lf0!!/_o8-+MH!K[9u$d\pB$Le)3#`pG]!KmqS$K);R=@`I[TE:S_!!!!"!!!"@1&qSJJ-GBJTE3dJ5QCcb(]XSlZXkJETF*pc(]XO:5QCh?!MBLp&D$m^:]f?5!MBM*,<,Z'TPFNH!!!!"=9I_G"6VWDBR0YdH2n-;!%Gs-6dL"'!rI%P#m7I5,"M`q!!!%m5TjP:!!.j?O"N[G!NJC1!!!%mO#VFcTE:Sb!!!!"zM$&G=!l5!AAShLJ&lh@DHj&AZ!!!%m!i0j%"KWXD!!!%mV[3]`$fk,H!!!%m"8<*?TEgu`!!!!"!k1F@!!l+D!!/`"Q3E?M\.ar)#mL5DbYU:6!!/_q?q^P#BR0XY#,D<u!!!%m!MB\9EaSkIga\p)!!/`!4<jM"!i03C!!!%mmoXl9!J_d$!W3c7!!!%m"6VWTD%"-]$.oI7?rIN%#+u4Y#,hQcTR7'U!!!!"KE)!o!!/`$k;X"Q+"14n$g^t<!!!%m!,W7f%'U/M^aEMgVu`%iRLS`p!!/_n4>FSN3^<rJ!!!%m[g<GL"e8CY!!!%m!$Fg'!(^o+!p"B0"2mCL!!!%m`sE'rBeW?a#c&Rk!!!%mQO*ej#2FGK!!!%m!!%*@!!.it3-kQI!NZCt!!!%m!NL0B"8kC`!!!%m!$FgG!,-0K!!%*@TQ"a%;[B<.TI.--p]6Ng+:S#P+92FtpHX$)!MBc$TjRj#+92BB!!$Ct!Lt8N!!/a--tt@8TEqVANrT.\!h2;)!MCZ&!Rh#KGQXiM!MBJ[H2mpF!'I/E%^/EL"fuc)!J_ct3"Qo,!%7s4!!"]H"G\s_!MB\))?9a;Op0nh!!/_o2`M?KTEr1aP5kR`!!/_o4><*%qHsBa!!/_n!KI-[cq$.Ba8qS6W!T[C(r-=a*k2?7YSXMo$j#Pn#M:*efL$/DkSq;O)Sd!s%Hmkd%tF\H"HXA6^^\@N#XeY!TECV_!!!!""h.lc!!l+D!MBMRH2mpF>Un>J!!!%mk6V6D"5H^6!!!%mJ8Gh<n,olsQWR/pOpm.,p^*;g&4e2Z+@ol?-qJ"OTECAX^An67"b\u[TE2uE?iU0-!!;I2!MBJY2W"K7=9>O7!!/a.&4e2L-q>B[TE;bK+92BB+92Ft!MBXMLI_CFkV)u;"i*/-h\8UPL]`_hJ,tlCTEht:^]BT.!!BG3!(\eR#j25K3%6gHLI`ur9IKlA!!!%m!!"2SY5sX`NW9%e#WeRY!J`WGTEG'.!!!!"!N0UW!"_[L"6VWTTE4Xl8,rVj82Bol817sJ!!.jG3X2eg84Wp*cpZJ"PR`KX\-[ZdOoqoii!PhP!+Q!2!KI.NMa.^>!!/_q#m.sDA5EDa!!!%m+@lN`J8>2c)?9a<_?.(e!!/_n+<N!3TEDc52uipZg&NTI!!/_p$?AB3!mEC6!!!%mF<DJ%!MBP-R4&%8L]Zc@-48rHfE-j7\,ha$N!H!c!!/_p@!VeQ2`M@UTE1K(!!!!""/fOQmq@"IE-_L0!i-"o!!!%m!qIQqTEUMZ]Dqp4!!/_o!LY>9!MBjg#UTk6%Y+\d%>Y%JTK<S/!!!!"!!!"@"HPNga$=qN89t7:F#XDk8/M>:!W)j>!!!%m9>:d:TE;/jBE/#5cNTMQTE;.s]Dqp4!!/_n#m$e$P>DCC!!/_n5^ED1H2pFD3!%&j!!/=*!#S6L!!.jGV[6<N!n'U\!!!%mh`uJfk;X#=TF*@T=9&=%?iV<?=9'a?!!!%n!*Dc7!!/`DUN9fCLI_CL8-f1r5,Uq#8-i]*!MBVnTEG5p2uipZWrO+a!!/_o=F'rI"1eQ#!!!%m`sDg*!K0bc!!!%mz"47DT<<NESD.Q-Zhl@`>TEG)p&-)\2J-!_#D%>b1$E*umLi3KJL]`/.#k1:m#06hd\-8N2C(Jns#H.k%!J^]sTH"4;ci=%Hp]5mP5R?!RLBIHpTE`mba8c2@$lEXY!MBPMNW9%Z(_4"ULB3D8NW:1<#V3Xj!MB[^#4)<iE';MR!MBPU4/W&Y^]F@ETENI>!!!!"f)Pem!N8j+!K[>T!N6$\&eG)B!N6(g!MBIh.mO(7XAT2Y!!/_s(jZ/^NW9uq3#U$C!J^]s!QY6@rrL1i!+Q!W"ip_c(U*q6)o)XP^`J#@2&=gP'poBMi*.:Za;;>i#cJIA!Sdt=!!!%m"6VWT(jZ/n3"Qqq!$DC,!P^%/O"bk[3-kQJF!q'e8,r[Tli7G=!!/_ok;X"QH2qU\]E[84!!/_r;()AD!It34$(u-S%CcW+NrbVH!Kp7_<+#a2!!!%m"6VWT$J5B03!"h<\,ha8&-BWVO9=Z*TE>#lQN.!d&2QEc!MBJK"5EkV!!!%m!SSbHTE:nhVuQeu!$!3a!MBJ!F8u:@!e^OR!!!%mpF?9[bQ4G&!!/_o!MDLSQiI*d:e1Qe5QCh?!!l+t!!/`D&cmL_CCh$.!!!%m05u4;+CI]Q!MBP5H2mpFfEABcOAKd';\-qPn/.4"a8qG1+9IW5!)NY,8,r[S!(]X'!MBJB%]9:,&.j(`GQR=H!MBMj!Rh#K!!!%maAF>bQiW!D!RO^F%^5ta!MFZTaDM%Rn-,0[a8q8%cj#j?a8q5#TFIP&p]6N\!jlVA!!!%m!!%*@-oFWs-u8kp!L42rH2qUioE4Q$!!/_nk;X"Q&-8.#TEF@:W-SFE!!DZjf)`+%!MC,n5PG-X!Pf%R!MBM#H2mpF#1imcRr\V/#`&H_O9)k.;[g_VYQV.#^]BT#:^O?:!$D7e"KtpR!r?t/!$V[K!KI-[!!#[$6g"K1TE;t9;ucn!E&568!MBPcH2mpFM@Ha#!!/_qLB5Hra=%#h!QZ\j@fR@da8s@1!!.iU.07LD-dMh7a=q*(TE4<YOoPI_%aPF^TE:U%RK*<g!!/_qzjV7aqO9FeN!rW6(!q?A`"/,hl<G`mj"M"U#`<2>nW<))_)?KL3quks8!!/_s===.L872IK88%uoK)bm:r)`q"!!/`$4?q-l!JgfI!MC#%&X37q!!!%m!MBtiTdTm@!!!!"(]XShV\j^[+F4#?#E/b?!!!%mY?6)N@!Ve`XE.3NF8u:O-ia5I(]f.0-jH"t!!.j/82pXCTEG6#&-)\2!&+Ba!$D7](]Xh0O9=Z*k;X:Z!!/GhY5t;BTF'+#(]XO:=9=7;ODP-A6V)/*a8cR'%-TGM=9EdR&%E(I^^cG+71,[o=9R8QQiI/BTFBTVmf3=g"nXoLTFIE)L]@DU#_[4!!K.o[!!!%m!MF`=3#F?Q!K[>;!MB_JEbGFQ7fNY)!!/`c!JbUo4*WFZIfN#9H2qmaS,rY'!!/_r!-A2@:ac;D86>nCLL:*I!Jg^V!MBtYK)blO!K[9^!K\]08-,);"4R<Y!!!%m!!.jo!L\0\$+LGs81"V`%[[Uei+N.S8-+5BK)bmJ!,qo="P7=5!MBeT#M]:Z3!\%A!MBLQ3#DVq(g$n'?j#ROcY.V)TEslh(]XO:Vub4(7ffOhW!EF&+Lb)H#il#b!!!%m&9'#tYQ:/:J.22WJ3YFjOoqWi$2>nL84Wc3!J:@P$N+iC!!!%mcZja9D$Id%$g7cPJ5Za#kQ]oF#Q^(oF)V/i!!!/oY]*EKkQ.7hJ02!4#Num/&@`_D#`&MM&]bpL!RLk?(Dc3o(9eXka:0!-PRm6s!!/`"\0q=W3#H<0!Petr^deF@^]Bf'^]7[ATELbc!!!!"!J!E`!"_[l:a\4>#Z+#f!!.]PTEUiNU]:Aq!!/_r5Y"WNBR0Xa#.+Dl!!!%m#_tAV!O)U/QiXE]?3.82!!0;(!N6!J!MB[n3#DVq!MCn!!!.]P!K[>D5QCh??q:<c8-,@`K)bmR!K[9^!MBMLH2mpF!!r$A"Re$j"GCh=?t00:!JbW5.<#7eN"N74!!/`"4;YI,"Jf]F!!!%m!MBULEbGFQ9()kXJ8cn:!$ldi,QWEdK)e.:8oOb2!!!%mE-Pjm!!.joV_2pb"1rLl!!!%mE*-TM!!.jo3Y%NbE,Z3SQpuiFPR5D<O9q!LOog^Gi",;XTE2q6!!!!"(_CX7GW#L\!J^]+"-ao.!!!%mW(6s!!Pe[9!!/HX\,_!YTEFcdOoPI_!!/_n4<'%U!MBIh!MBMRNW9%Z#U/(+^DM7s!JbVI/oXnm]5Ta]!!/_n1*^`<TE1hg!!!!"!Or,Z!K^OdTE0uO1]RLVBEI?'!MBORK)blO!Or+1!O-kMTEGA;]Dqp4+0PtU!Q+rB!!!%m^Bk&0"N+n6!!!%mZZ6)>l4/RM!!/_qh`)GQ7pp9bH2pKT_?H9F!!/_r4?^.RP\:34!!/_r!-A2@TE12U+92BB!!;4+!MBLX+qO_SNW9%Z!"jte^B'>p-iaMh3#E2D-m/Yj+92Ft!!l+L!!/`j!JbUoLNlVqDu]k=!n2C-!MBP5!Jg^UJ,hi*!!/bo!J:@P"-da)!!!%m!MBI_3#DVq!'gYL!!#P`!P_HW!MBY(!JCFQBL8U'!MBPkTMtmk\GuU1!OrmI!JpdVQiX,cQiWTUL_&t`!N7=S#4N%o#`o(M!UL*M!!!%m.Gm*%E(=#LBR0YLTPF\&!!!!"!J!E`!!.jG85K>K"cNEe!!!%m`sDk.",^bC!!!%m"6VW\H2muE!M9Cs!MBPL"O$iG3#K[B!!/`ZTE349?iU0-=9(TW!!!%nMc^kt!MBc$TEG5p(]XO:5Tf_[#XCmF"6VW\:jN+4TR$ggRfEEh!!/_s#m@g>UGr@2!!/_oW$hWG!K^sq!O)Q1VuV;ILB4=SU+cQJ!!/_t#m0,ej(JeO!!/_qqBJf:"0qn.!!!%m+87`3D$cSK!k8Zk"NWr$"OIG$#RdRdE!$9"&!-kffEUgF70T=c#e1'-!!/`koQ!b.q?5[W!!/_nCN=(g"c=,*!!!%m!KRc\#Ik#[TMQ!2-ib@oQoG,.!*Dbm.Gm*%"53dK!!!%m"i!#65Y"@1k;X:a"NjOC!!!%mW(6s)3#DVr!QY;>!!.]P!Or0?Du]oo!LWu(#e0o.W$Vc%i!eNEVu`%l(]jC>a91TbTEhe(!!!!"!,qpJ6,*G\!JbVb.<'M3Jg.[C!!/`!#m\WR!O)UV!N.mo!N6%/QiX]e\0q=X!Ll%L!!!%m!f&`P=@YVY:jN*ITMu&LBE/#5&-)u,!+5d<]2/JI!!/_t#m9JnX#N_T!!/_q!MN$a3#DVq!)N]g5QCh;!MBYG6N7#c:]l>4!MBIGz&c_n3"Si2n"5$`Z"7-'=7;X2JO^%sL"-@X.(M*]5U]fW%!!/_s4A='$!LO,I!MBqhH2mpFU]HNQ!!/_pLB4%JTJuoP!MCkB@fROYTE1]F!!.iU.06)<6,s#!TMT+u!KI-\!!"A'$)[fa3Yme_+/fXq!KRBA!N6t,YW2d+n.2`/$a<#.$g8G;p_]A%*Wk79$EtS%huaM"e-*Q"!!/_p!-A2@J1(Bt!Jkt$S,bN>!!/_r!J:@PU]I+g!!/_pTI9d?!N:5DYQ,e:!'!LM!MC"23kkXp:^GQ^!MBetLKFNV?l/kE&-)u,BF"Ps!!.oV!%h;TTF'*J^]4?8*q0@F#l"Xln-IrE:jN*\TQC=g!!!!"[fMS:ErgdoBE/*u^]4X2$KsMOY7rC(a9dA"YQ9stcjZ!?fE%-E0Ee<W"L!&!?iU`\!!/Ph=@btb!MFK6!P8=3!!!%m!MB^o.o63G$bSO8!MBJR!NH,"!!!%m`+9U;49:fR!!!%mVa,P.!KI.J!Jh#rk5gSC#D>>O!!!%mQU#is89t7BF#X6949,fF!!!%m-t3R[TEO<U!!!!"8,rX3?j5.7!,,%+"6VWTTFB=hTE"rm!*Dbm!MF6/,6<;pj8]Rp!!/_tf.Im?$&iO$!!!%mYAbpE!)Qc#=@bCo!JabWLL=cqj)=u!!!/_oEWMO-44aRf!MBjs&/YBIR4)/S\-/H*-3oV>Qik];(]fd/82(6u#h/i^!!!%m"6VWTk;X#$H2oW$Rff!:!!/_o!$V[K!KI-[!!#]j-\h__k;X"Y3"QW'&/YN4+9Udd!!/`s8-+ePK)bmB!It.N!jHND;d]g&#_rG2!KmqC%tG%T!Jl%%!nmqK!!!%m(h*TaTEE[D!!!!"GQFHcGXqk68-,ppK)bmZ!MBDn!MB\q-ia5IEEH=F#(usV!!!%mX)\6.g.@V4!!/_nAJ`Ym"8$hR!!!%m!MCh@R/s72QjT2]-4bn5L^NngVu`%hYR[T:!$Ff5!!.]P#cn'"!!!%m&7Pg=TE0ZFNrT.\!Q7)+$2agk!!!%m=BHsO!!%"@!MB\AE_l`9.d$r1!MBUL/g(,oN,SsP!!/_rTF'rb!!!!"=BJZRU]:C7!!/_s.fl";"6'`M!MBLhF8u:@-ia5ILj/rN^]Bi(O9_]gW,O'bOpo,-J.-r/8-+eRK)bmr!It.N!J#IrH2n&.1sZ2Y!MB_J44aH4Qir()TEU2R!!!!"GQFHc?q:<s8-,ppK)bmb!MBDn!MBSn@N#4H#D<(2!!!%m!!.oV=@a!*TE^>T!!!!"=93q#!-&$iTEE%2TE"rm!!.iU3X;$C!MBSRV\B0)p]Za!TE18d\-]qUO9(LQ@fT%/.KQ25!!!%m?s"fW!!l,'"KsF+TEUct?iU0-!!8*(!MBYH#1NVQX8ke#!!/_n=@aP7===.L#Y8>Gs#:Pi"kmVp!!!%m!J^]K&'k4UTEFarTEDM$:]LIr.-F!=!MBP+5PG-XQj!7JTEM=sWrN,#!!/_pf.K#_!MjrD!!!%m!MBMd"T/6"!!!%m$p7+bTEM;lk5YJ_"5H!e!MCr>-ia5IJ62i&\,h0^J-W:Z%.HCb$\/?+$/biN"/#mdcj\QBM[7B/TFJsCTEOTle,TIL!$G_P!MBUcEd.Qa!p9^!!MBX\3"Q&ilkfif!!/_o]5q?[!It.O!!/</!MBPK-ia5I!It3D84Wc[8-,ppK)blg!MBDn!MBLpF8u:@3"Q&i!&t)D7/&rm"6VWT!MF7"#D3!V!!!%m"3Y^]"L:@l!!!%m!MCh@8-,Z6!O)Q+aoHBO!!/_nEWMO-#`f5F!!/`",6<;pS,`b_!!/_n:jN*A"3Lkp!!!%mY>BNFTEE=j!!!!"?nb\2#LEL>$IB$>"5jG3!Kmu7$h+Gc#QHap('<H.!mCX`!!!%mj)P0fWu]Lg!!/_nf.IU7H2q%N!!3+-8%3/Xf5Q$9TE<RFdf9@K!!/_o!-A2@#XeXm_]q,@TF:f'lMpnc!!/_oTE<::!!!!"=93q#!-&$iTEWdE!!!!"!!%7;QN;V_LjB%'!%kY\`rV9JErgeJ!!!,==BJZR)?9bW!!!%mdQC*fRfSl^!!/_r!JabW873hG3"Q&qb@h.\!!/_t!J:@PWWAam!!/_n@KtQe!NQ2[!!!%m!MBS4#4hfp!!!%mbAmWNMCRcp!!/`!OEpm,J-2DE"1*%L!It.M#f7]d!!!%m!MBSlz#64`(AHA&!73PZJ"Q$m%!MBJ[8.Yb$H2mpN'K>2'!!!%m0paC=TJQ\>-ia5J"Qp_E!!/`T+F4"fH2p6l!!^at3gVOH!!/`J!J_KlH2n3NTJAGS-ia5J$3m+QaDD?i(^]sBkQ^fL1((5q^_d93^^pSK!!2Qi%-S(dfL5hf3!,0N!!!j,!!"up"5bMQcoM2X&J,KV!U'pDYSRGp1(USo!!!%mcq=]?#TTcM!!!!C&-M)T"6VWD!MDarz#64`(D(,UmAOTTB"Q%3)!MBM<@fQK/LEI]VQllA0$KsMQpCn_mYR9;=\,hfs^^SQkVu`%l!"4kt"<\gs!!!%mmhdJj!KI-fO=2K;%ENAq"c*Vt/>j%X!KmMg"gA0OVZDeX(k=:W'\EGW#,iHmVucC&)[,pN$LeqS^d/"bTGX=-#H1B"!q7&ji!S*_:(`!c'7^7b!K[c[+/g4L!!/_q#XeXmC'oIk&b$I<!!/`D#^QINH2o#\(_-KV#QOm\!!"Sf!!/`$!ME'c@fQK/H2nc^(eEg,>7;'V!!!%mLBo=7!KI.M+:oXX(]XSlY958:!MBcV!J:@P!!!%mz76q+XD'<Ij"Q$ou!MBIXLDU!k(_?ZJ7\:MH(_C0WODP;[n.4.YmgrD#!KmFK#fm+(rs3oN!KI.>(^N%O(]XSl51_D((h3O_!KI-s>TbGe!!!%m!!ksm$=uQE!MBi<!RLfHTEB^h!MCq`H2mpF&4#+Y!!!%T!!%!MLCeb3!J_L=TMl*r!!!!"*<-&",9H>&#ETGZTI(3=kT6B$kV*;O)'#"O%ZhTbi%,f1a;0:=p]6ru\-.<f'_jKu'rVbdO;acP!MFH>z#64`("LUZ$AKbnj"Q+_<!MBJS#ugm),X;t!!!!%mmiZoV.!bjoH2p:`+:bS/;#i_"p]*i#L^78gL]rSF81uXtQiZu)Oo`?"^^mpU9HtqiTEO<U+92BB!!B#A!MBM\'7^&_$CCj`(0MHHG";U(6O/YX!!!%m!!l+d!(^o+QO*\_"8kCj!!!%mLG4#S3-kQ[F!q3i#i>Vkr&A^Z!!/_pTE=`c5QCcb-ia:'A3af>!MBOr'#+DHUc9V^!!/_o('DAQG!H$mEWNo\!!!%mQZ@++!MF3r#mpY4`'>^5!!/_n#m&NUUd,$;!!/_o&:+<VLHlZZ5SsJ%+88#L5T!u2Qu)l.\-DF-h\]8qOoj8K\-/0"!J`oM.6oQe!'JRm!'i5J)Xd]e!KI-c!$E0:9@!X!/JEX_i*[Ol^]C,@&/CiY\/'Tf!MFHBF8u:@"-<K_#I#=R!KmJ^!&t%A",A:N!MBJ1!K$jW!!!%m!fD"X!g=83!!!%m^Bjr4!MVhN!!!%m!!/Ge!LX3Y$b-Ae5UHN9!oO??"crbJTQ11N!!!!"#Qs6LNt?U;(jZ01TGf_\R/d3f!([k+#[IJX!g!ca%ep'\F[uVL%-RqX!KmQ+&&8Id!!/a%!MFH5"/u8#8,u0r@TNhY!!!%m!!%*@!!ksm!'h;K[g7.B('B*lG!H$m(3'ijG!H$mncI,C!!/_nzW=&\+"9Yb."-<QA+_:`F%n0K8j94A#!!/_q&01`N!KI-[!!"s]19U_=k;X"Y3"R27&1@YD0E^Jt"6VWTTE<%k!!!!"$-*(,!Jac:"7Q9j=:NnD&Dn1(%=eN4$K(rLOsgR6J..M?!+Q!;!KI.^:bXH(:b^KR!!.jW==I?;@fQjs!PDN"!!!%m!!.j'89t7a"QTfC!!!%mY=Ns>!LZad%Zg_d-mf1T%^5u<!r)eZ86?#1IfKI.",p%V!!!%m!!%*@"6VWT89t8$"H3H7!!!%m!!l+TY\aF)i!ZIo^JIi<OpUnG+:"87!!.jW=D1MbTEF7IZiC(,2pVd3TE:'S!!!!"1%t^/!Jab_/m(XEXB70K!!/_o5^ED1H2n)g!"d1A"c#p#!!/a?+@nHlTE2Y)!!!!"Wurf=!!/_n#m77/ZrdIO!!/_o!L[<q%@@9k^`Xt#Op%Eba999Z0M#j[Dup">(_?ZI?q;DJBLjfW!MDOTF$K^*H2mq%5QmEEli8_1!!/_nrs;p1!O>6Z!!!%m!MBJ9,<u5/JcGh@!!/_o!MBc"!Rh#K!!!%m!!.]P!MFgB!Ls,i!!!%m1?Ss2TE2]-KE(uQ43%X.TE0sA!!!!"!*Dd%)UAGEK,*$8^^g,?HlBL/*/G3ZW*gI`p]ur_ciKOE\0$5@#l"KBTG.Wu])Vg3(9\#FTE<;-!!!!"!!!9m&/ZN<-j/Wl!MBJ:+7K71p^!NGh[)X\!UE9F!!!%m!%:B?!'!MW!'j(g!MBJRR4nU@#,j3V&1.XT&%E"g%CcG%!i#kU!!!%mcNs[,"1))r!!!%mz!ODb+quqh8!MBLd$.&YP!hJt(TLc.S!!!!""c"LP!MBS^$CCen!!i!a#ZqG,$D7XEkR*tQ=:1u5!!gOMQiI/>!KilZ!!!%m#m#g7e0m,f!MBLgH2mpF"fD]X#ZqG$$CD'RO:%@FTLnb_-ia5J!QiQ+2=q^b!!!%mUh)jDf;pA8!!/_n8.#%kJ,feH"1Ul//II".$A\Z^f*TN#TP&oZp](9pQK07sb+&G5!!/_npj)o?ZiS2S!MBLn$Fg'9!!i!a#ZqGL$GZbQO:&cn=:3+VU]\(3!MBIgeYE0F'E8@>TTfeF!!/_n=:4Nt#6,%_fN8N3J-M&A$K-(8TPF__cN!qGJ.Dba"9u=<"Fp];#Zq4c"HW`K"6TqlTE4JF!!!!"57,\_TL]CA$/bdf!!B`%!%eN8=:+0k#0.%k!MDuB)i"Cn-rT\K!MD`cK)blO$EsL2#ZqG<$EsbjW!]b!TOc7RQiI*e"P?6OTGBNf$((]!!!!%nQq.MPqm6>0!!/_n=9[mg!!Jo""J7)gTE4b>QiI*e!!/c#=:1]$W!'"(2[ELm!MFP!!It.M"6Tqla!c66LjB%&X?"<%!MBIOY06kG"O@AU.%CX#!!!%maB/cDp]]O]#j?F<$2=Xq!!]AmaB/e"L]uZB"1Ul/!O)+q!!!%mN'%Eue0kBM!MBI\$K(ma!!W-gfLQA5$K(mk!!!%n#ZqGt$K)!+ljDri!PR91!!!%m!!.]PH2n;F!OiDd#ZqG,$D7WZQjTKV;$4iG$D7a![oNj/TF.=r#j?F=C\.i"!!!%mTL]Ca$@i*\!!B`%!%eP.=:0ia#*0)3$BTQ6!It.\llZW0!!/`kAKSYe$1KaH!ME8j"o&&t!LF'oJ//4N(23aQd/XBD#,i:==9bu0X>8rE!MBI`Ru@=I&!mS'!hI7X!!!%mr&c7FX=++3!!/`5=:(>p!!DBie6aVM!MBJ>$BP5f!!])ehbFN/QjT2]!!/c#TR$S<W&M0m2[ELmTE0rBJ,fQMWK_E1S.Cqf!MBLW4@]AO-ioY+!ME>D$2=K#!"%:K!LX:F%tG&?$0W]I%Yt56%ep'f$A\ka*S1R!!!.]P$2=i%!!]AmkXZ&2?M"4$!!!%m!MCgqE[Unf!oItP!ME8ZY.O`7!!/_nn9P'7J,g)d+:6[$$.sP(H2n'!#QG+gTE2mi!!!!"!!!"@V[A6+!ibMf!!!%m$M\oI$KrnIcO/<,TN/?#e,TIL!!/aB!-A2@=:*U["4%:pk]R9bKE_)U!!/`W8-seHL]@_M"K4it!.OtK>-nTd!!!%m#Zq=f#I$2&!!_XXpdbY"W0@8a!!/_n!LTAW!!!%m]Q+>J!S7AFTE0eSVuQeu!O,*#=9u,2!!2NoTE#"F!SGm-!!!%mTE:pB7fWMiL`Q+M!gE6`!!!%m5:CgXTE376YQ+Y(#Ok7k=:2P<$FglXTF/2!^j5tfe,eG6!MBLc$0V?h[gC,Xn9P';!!]n=$.o9/=:*V&]FP=i!!/a2.gge,KR)oS!!/`)8-OeL!!!2LoPZ.(!!/a8!J:@PL^Jq<#k1@l8.(FYQiIHfk6P/s!J:@Se-_!3!MBLk$.o4X!!])e\4?qa$/bdckPtT7$-63TH2n&^#.Fp.TE4JfhuE`X$-63T$0VT&!!B`%!%eN@TEL_ahuE`X"1Ul./IC>8$0V?h*sp"jTE4,DfDkmP\C>R,$,?NA"6Tql$-5d?d!>Zl!!\2bV[;"%i-GAhciTgGc&?]M$Fg':!!])e[n[9\!"-M$QO;)c!Md"[!!!%mTE4]'PQ1[a!MBJbJb/pB!!/_n=:0ia#+#Y;n8/GeO:$dJ$BS0i%G1lo#FGOTJ,f\=+:7fDaB/cDp]\tM#j?F<=Mt9-!!!%mcNtPdZjPG7!!/aAN,g<HS1L"L!MBJ&$1Iop!UR16o8G;_!!/_n*s[T%!r*Ik!!.oV$Esl9Y6_@7O:&2mW!]I(TO`ugVZ6\t?M%eSY+,Nk!!/_nLcte=]EX`-!MBJY$1Iop!Ls"-8CT2W!!!%m$Aa!.TGbC\n,NFh6N8PBRIif+!!/_n/ICV@H2mpF!"TD*$.o9/fQmN?!!8JnV[;:-k^!4kfETA&RZqk"K)blQ#cI_(n43h`#d=:6!!o5g#ZqABT_&Be!!/_n,7:@L!!016TE4$$L]@DU-id'NJ8#@HKF-9<!!/a>=:+a&N!&5K!!/`Ip_j,4!M-S(!MCe;1;!Se!!!%m#ZqD#$'52Np^*<X.!bjqB?UJ@!!!%m!MKkIM#[MU$GZWB$G[P[g]=[M!!/a+^g$j>$,?NI!!e$FfLQ=iQiI*f$.&YQTE4,<p](9p#j?F<:p^?!!!!%mfLQ>D$@i*_!"%j[#ZqFiK)c+b$2=K$TE2:h^]4?8"NYs25-GI3!Qi8kWVd(t!!/_o8.#%kJ,feP$-63U8.(/;oDf!'!!/a:8.'kIe,TiC!!/`-!h-Ir-j7j&TE21m!!!!"[gCE-!iG#Z!!!%ma@HZ"$CCf"#DWReQq%LNTF-J^h[!<k7gbUe$CD0nTE:kKp](9p$,BXLFp[pSj=^f&!MBJ2H2mpF!M9[s!MFJ/#hT+W!!SHTLe%g0IfKHS!!q3W"Rdab!MEcsjkKh9!!/_ncO!bTUU2EZ!!/_oY^-9L!!Us]f*]$6:^WQn$D8dI!!"]Df*\I&!OL8Z!!!%mD"M`r`0:e!!!/_n!Pt!#!!!%mgi<_jS3l*n!MBLl!h0/i-jQ@N!MFq4$IAbQp^6dd!O03C!!!%maB/c$fEV?^#j?F<$.oL/!!]Am\4?qa2Z*OW!!!%m!MBJAJueqP8_47L@I+>g!!!%mn.l&`H2mpKlitca!MBJR'A*9b%@@0VE[UsE9CHT=!MFD-!K[9]".'9q!K]fZ=94L+KEKO+!!/_p,73!&!!3&J!MFn3N9gNE!!/_n8-n\bM#[UE#l#/:!.OtKH2n6?!LF)U!MF,]$D7A!!"$_;#ZqG4$E+!/QjTc^=:28>"k#=8!!!%m#m',Z$2=YdTE:n$!!!!"O8o<6TM:(Frr<$""0=U:h2D].!!/_n=:+0k"4mk#$1N6@!It.\]H@O5!MBJ[K)blO#`o#e#Zq@o#ab_W"6TqlTE27'_uKc<!!/`+.!bjnE23T>!!!%m!MBjjR?R[O!!/_o.!bjn'9iOD!!!%mE+1)W!eJi$!!!%m!!/Ge"OI;@!!Md^^F4C.!Ulfg!!!%mn43i3#hT+^!!A<R#ZqAj>4_p[!!!%m!!.]PH2n8U!!^Il\-]B'TFQV]BE/#5+9@QoY:+\sTQYthfDkmP$-63T$.o<_LC!*efQmN$!!CORmg7ouk^!47bUBq,!MBLaH2mpF%^-4i!!/,\i7&).!!/_n#Zs%dH2nGYU_C3c!!/_q#pG6-$2@!iTE:"@YQ+Y(#k1@k8-ud+!!!9!^]4D&!J:@YbR(KR!MBJ)0rt?T!!!%m`,Z3PN!-=o!MBJ!$1Iop!hAUt6EEGm!!!%m#m-I3S1"Hr!!/`,n9P'7!!]n=$.o9/=:*V&"2>/`TE2n,VuQeu-id'N0LuPT\9\,T!$&HTcO.I6TR#T.p](9p#,"Kn8.'kIJ,f\]!!"SX!MBdQ#j;6g!!;X\#k3-?#l"bQ!!Jrc!!.oVIfKc<#mfGh!!qKu#ZqAr#k.rZ"6Tql!MBVG$CCen!"$_;#ZqG,$D7WZO:%XNTN1ms!!!!"Y6r'k=:3+PcqE7%cNmV[TG-Akp](9p"MdP88.0qJ^]4_7QiW9UO:-jOa8qP6!".'[$MXXPTF[h@-ia5JpD1D^!T92.!!!%m!K%BV$(qph!!.]PH2n90g]Q^f!!/`V7gb=X$A]%N!LX:^$((e0!KdPaTEX3Y"5!kh#J^K3LgU7H7gb=e$BPU^!MD`s$((\m!!r'bLe%iFIfKHM!"#"m#DX^RTE3?f_uKc<8FHj$!N<pb!!!%m$CH,>$D7U4!!]Am$E/7Nah.YX!!/_n('CfAVuQsnk6P/m=9Pi1!!DBi!LG3\TE4Z.`rH)?$D:5u$D7a!TE_l+FpalL#QG(n!ME'7`5DWU!!/_ni-GA'!"dH_f*UYeEs^J(!!#NRQO2;ji-GA*!&`X?QO2l%Es^J"Y5e^dXfOW,hS^fC!!/_n49F[G-iqJ\!MFe`$/bd`O<KBSTR$SF!'KEOO8o<<!M92r!!!%maB/c,kQ/F)"1Ul./ICV@H2mpFS.>qq!MBJUa+OEm(\\4:NmnC)!!/_n!U%B$!!!%m#ZqGl!J:A2bR2\s!!/`OkY(sV#4MTs"6Tql#Zq<+#Clp>"6Tql!ME*8$2=K#^Brh#8.(.mO8oOT$2@$u=:1DqOu12b!!/`$8.14RO8oXW$G]1?!J:@PKF<;1!!/`U!It.MX<7l6!MBJ7#l"B""6Tql^F4C.TEP,ofDkmP$,BXL$.o=*^Bj%Hd!>ZmS-T'#!!/`-=:1DqQiXAr$CF<j$D7`f"lBSfTLT?V`sS1@$CFZm$CD0fQj1$#FpaTD&<@+\!MFepE[Unf"SW2]TE2B`QiI*es/^5Jj<gc*!!/`cOEpm,J,g)e+:7fD!ME?_$@i*V!!B`%!%eP.=:0ia"j[Lj$BTQ6!S-6A!!!%mUa$5^am9!h!!/_nW-SFDQiiZ^Q.0j^VXsii-0GR8!Vhm-!!!%mTE0eKO8o7],Kt08kj/k9!!/_n8-uL#\,Zd'$(sfq=:)bC!!26gYQ+]VTQ-2&fDkmPEnhlG!T*GK!!!%m^fUp<p]ga)#j?F<$2=^c!!]Am\4?sW$@i*YL]@E,$,BXMH2n0Lr!s-r!MBJ%$@i*VT*"q2TLuQrci=%H#.IV?$IB.,[g;2@!Sm$!!!!%m#ZqFi$BPAQ"6Tql$2AfHesld@!!/_nTF%(fL]@DU$,BXMH2n&^!"TEu$2=OO!O8.;!!!%mYZM7Za9K*Za8qn?!".'[X:!#e!S$Hu!!!%m$@mF&$Fg,'#DWRe\46n9^^@:Qh[!<k7gca0$FgGY\5<@KljC60!!/`o!It.M!$DUC^BsCUTF/O;MuWhY!MBJ5"eYhq"6Tql!MCh<D<(Zs!!!%m-KK1q%D"_&!!!%m$.*tu$.o9F!!])e\4?qa$/bdcUAt9G!!/`(=962;!#OMu"Lfe*TE4K)l2Ueb!!/`#i(O+N"R#gg"6TqlY:+\s!T35J!!!%mTE:@rk5YJ__3@%bX9sIY!MBIW$A\Z^f*_@pTO[<pZiC(,!!/`!!$V[K#ZqW<=;V,6+9Ud4"6TqlTE3MpL]@DU!S8h/X9#<e!!/`r.!bjno$dfo!!/_n,7;ct!!8+4TE2gWTE"rm#Ok7k8.)9qYQ,")k6P/s!J:@QN!c3X!MBLHdu48,'#t:Zo=PF_!!/_nTEi=6`rH)?;hR7:TPW++ci=%H'81B4"b[]l!!!%m!MBmdIfKHKQjT2\#k1@l=:1]$TEDY/$D9lrIfKh;QjT2\#,k'":(!'_$D9f%!MBjke"csD!!/_n=:+a&!!DBi!"+6M$Aa!.!lG2>!!!%mcRT?qKM\Hc!MBIL$.o4X!JJ*1TGbZJ!!!!"k6d#k8.(F\!!!?#k6dT&!SFJ<!!!%m$CD_31Sf3$!!!%mD3T&h#FZ^;!!!%m!MDBI!iQ)!!qut&W)s+W!&N4.1:JZX!MFhaK)blO$CCeo!MBhc$K(ma!&k0c$HN6uaEdh/!!K2,[gLK.fQmN(a8u#BKrf>&$@i*Wg]Xf2es$5f!!/_n!-A2@TFgAgL]@DU$K+G^8.(FYhuF,J"2IG7TMs>?huE`Xk6P/j=981UkQ]WE!Vf.c!U5g[!!!%m0LuP<TR$S<!!Us]cO-UsY^-9Ze4-VK!MBI[H%Z.t!!!%mS0J@0KA6G-!!/_o8.)R$oDf6V!MBJ=(XN-^J.oFW)&]Xf(q9k@J3FV0\-oe`'8RqV$'5de"6Tqla!c66TN[Qap](9p$-63T"5j@W5R?RZ!Jgr9#O_hPTQLS9BFgI2%#=qI$2>"?!!])e!MC?qF8u:@iq*3N!!/_n#rJ^`$A^No!MCXtq5aPr!!/_n4A5\S$.'.RTE1Y&hZ*WWjjZC]e+>$h!!/_nTROfZKE(uQNsPigX9m5^!!/a;8-seHL]@_M"5$-N!.OtKP(X-l!!/_nEXD48.A')RTE4'-p](9p#H''YKE?\2!!/a@8-kjgVuR(l!Ph53=9u,2!"b1sTE#"F8-kjoVuR(l"3="==9u,2!!hBeTE#"F8-kjodJsOA!!/`"^j5t\YQ^@#PH8g4$J5=Z0*nda!MKkI$J5=Y^Bh&GO:'VBcjJ,#TaJjJqZ$Ts!!/`"4<U6r$1J.XTE:)=!!!!"ci=*!:'o8S$IBmPciAOqTFq#-J,fQM"1Ul//II".$A\Z^0+#^%$BTQ6!It.\oH4J8!MBIHFgM,K-p-;mTE9top](9p#,"Kn8.'kIJ,f\]!!"SX!MCEc"b6RQ"6Tql#Zq7d9E51XU]:R[!MBIi#d=:/!!i!an43hp#f$E@8,!9k!!.]PH2n5Te0Ck>!MBIJ$A\Z^!"$_;#ZqFq$BP:lp^3*Q=:1E%O9OMI$CF<j$CD0^!&k0cL]@I.TQnZfhuE`X$J8Gf$Kq]'"6Tql#ZqH'H2n'1#_rc^!MCq7!r)`q#2]\gk9tWVTPENimf3=g(<\fr!M%@^!!!%mTE1.-L]@DU$-63UH2n,p!"TEu$2=OOTP<1(QiI*e!!";P$D7b,W-SFD`!+a"!!/_p8-m!2a8c@qk6P/q!J:@r\-TSE#Ok7i8-m!2a8c9lQO$\!!J:@W\-TSE#Ok7iTR=*HJ,fQM*L(ROqQ'h_!!/_nW-SFDYS>[ik6P/j.!bjq!U#\c!!!%mW(76I$/bdf%Hmh\&+C%$O9<!>Ook+ZfEn2O/IC><$0V?hY6i!Hn9P'9J,g)d+:6[$TE2(RKE(uQ.A$nLTG3nEfDkmP$-63T$.o=*LC!*eTG+U8\,ZL0mg*"s.!bjtEl8*Y!!!%m!MD-:$0V?h"6Tql$1N6@$Glh9!!!%mJ4L$OM#[M_$D7A"n43nb$EsL:KJs0=!!/`".!bjnqM\%M!!/_n,73!&oDiRK!!/`S8."2ShuEkh!!"SWaB/c4!!L%C[gDPM!It.S`#oB=!!/`]EXC(m!fo="!ME5q$K(ma!!Jrc!-&A(TQZh*J,fQM$EtrdH2n)O"Kr0Bl>m<2#e0jG!!i!aGXr+U=9utJ!!Vfs\,ZP^!eU%M!!!%mJ4Bs>W!\Un$1LIm=:284J,hM6+:=J:!MCgQ#+kkq!TgsVh5gs^!!/_n7gdTC$IB.4cqsnccjJ,,#.IV?$IB.,`sCmP8.*]FfDl6!LBpuhTR!%4p](9p#,k'!=:0QY#HnHT\4?s_$A\Za!!!!N%gnDEp]5mFn>m`=!!/_n>T9UA*JarN!!%*@$.*tuVo/hL!!/_n$!;i\KIB(b!MBJ<$2=K#!!])e\4?sW$@i*YL]@E,$-63UH2n22#.Fr$p]5mFM8UMC!!/_n!SEV:$K*9<TE9`#O8o7]"JA9mE=.d-",$XS!!!%mN,f9("O@+B!MBh=$2=K#!!r'b#ZqFa$@jMekR)i1!NG\t!!!%mf*N89S-ert!MBIS"-<K_!hTa#h^EdN!M..6!!!%mmg2M&MsMi,!!/_nTK/5:^]4?8k6P/qa@lR9H2mpNA+VE&!!!%m#ZqG\$IB$5a9p9a;$4iG$IB.,[oNj_r!LdT!MBJS$2=K#[g;2@TFo'H]Dqp4!!/`4TKfLXR/d3f#3Zg).!bjn"G?iS!!!%mQq.PQ!R^rT!!!%me3#2K$.&_@!MC+=$2=K#!!]AmaB/e"L]l<9"1Ul//II:6H2mpF#.Fr$p]5mF.AS'm!!!%m#ZqFi$A\r]n-XtA!.OtT$@iJ6"6Tql!MC:)7K3>f!LpGY*Q/;8!!!%mh^EdN!T;H3!!!%m^d8g`p^!N-#,k'!=:0QY#EK2,\4?s_#Q+Q(!!!%m!!.]P9p?!8!!!%mLF@HKTO7U%p](9p\,i!(fF-U=a8qD,a9/mX$Fg?K"6^9*$J5BB$2=_g`sCmPTG3"_li7"d!!/a>!-A2@=:*U[fImQH#j?F<VmHWR!!/_n8.(FYQiIB\k6P/s7gbV2$0V_`TE1).fDkmP#,"Kn8."2ShuEkh!!"SWaB/c4ao]lq!!/`34;P+#e0mZM!MBJk$0V?hp`?&&TaCK#!!!!"X9nY?&*s>U!!!%mJ4Bq@`sMMJ$2@@"$2=i%p]e3.Fp[pM"HNiPTE3oN!!!!"!!DFY#Zq2uH2n'1PQn<>!MBJ[.jtAtmG%ijTObD1!!!!"]DqqR!!/`<!It.MQlla'#,"Ko8.)!iqu@&m!MBJ1$%N!U!!r'b!%eM-8-t(PO8oRM2[ELlp]5mFca4f#!!/_n.!bjn's[k,!!!%mi(+1<$1Iou!!C#-#ZqE.$2=VSkR%#STaC2lp](9p2[ELl!!.]Pd^0>E!!/_n8.#%kJ,feH"1Ul//II".$A\Z^Y6i9POEpm-g]k4p!MBJ%$0V?hcO%Bhn9P'9!!]n=$.o9/d!>[7WsAA*!!/`#TaH;ML]@DU2[ELmn,\%>$1K&D!!])e#ZqE.Yd=V$!!/_n8-kjgVuR(l".2Ub=9u,2!!ft=TE#"F.!bk!M<"\u!!/_n!R%8=!!!%m(:%s/'T,-$!!!%mpdbabH2mpO3k#Hp!MKjnH2mpFPW&rJ!!/`,8-uL#\,Zd'$'7[a=:)bCe,e_<!!/`R,79e<!!26STE1S,!!!!"!!!"@^Br85!Tr_R!!!%ma8g\i8-d3@ci=:6!T6KR!.OtKQiIB4#KQlG#Zq>Y#M:Kg!QPIJ!MCs%$&AQ]!!r'bpdb^QIfKHP!""G]#M1AMTE4?%L]@DU#3\Sb8.(FY!!!?#$A\\3$@mF&[+k].!!/_n8.)j,^]4W/LBpuh7gd$l$BPV1#ZqGTK)doe$Fg':TE4YcL]@DU!!"SX$BTQ6!It.\oH4J8!!/`MD%=Ve%.F\0W)E_ici`/4a8qG*YR.62#,"Ko8.)j,^]4Q5$D9os!T*_S!!!%mW,2U_J-<(_$2@F*%EJ_A$b-5#$@iN:!!]Am#ZqFi$BPCg!!W-gn43nR$BP5o!!!%n#ZqG$!It//oH4Kk!MBJOL?nm?6Dk+jTGj%CLB%;T8]3_&`2j<-!!/_nTQ/`eKE(uQ!!/`RFp`a"6cTP,#ZqG4H2n'1"d]R`!MC[c?CUuq-q3#"TE4SIfDkmP#,k'!=:*mc"4%:p\4?qi&;gGi!!!%m^SGluJd%bI!!/`18.'kIJ,f\]!!"SXaB/e*!!W*'[gJ4C!OBWJ!!!%moPt8b/]RnCTE2LfhuE`X"1Ul./IC>8$0V?h57,,-$1N6@j2;/2!!/_nOEpm,!%Z(sf*[mkTR$ST!!Us]k6e/6:^W!h$BQY9!!"]Df*[mkTR$SA!!Us]f*\I&Y^-9QO9FGJ-id'N!MCHs=BGP'U]S::!!/`>=:1]$Qj)@Q$D9lr"31b9QjT3X<XP3$$CD%,k]R<#qZbp`!!/`:n9P'7!!]n=$.o9/!T;HM!!!%mi)g<\!'l;?T*g*pLjB%'!(NjnpBm".EsdEu!!2&[PWT2KdgET'!!/`==:'KXL]kHu#k1@k8-t@Xg].GD!!/`)!It.MJ052L#Ok7k=:0iaL^3Y[$A_1Z0AHm'!!!%mT*\ufM@+k<!!/`&8-uL#\,Zd'#cL9#=:)bC_?&g*!!/`1/IC>8$0V?hrs?bKn9P'=!!]n=$.o9/fQmN?N!%rD!MBIXH2mpF!KRQ>$/g+0H2oDo#NlEW!MF;R$.f.WLif^\TJN)FX8i5$J4BnfTITR@O8o7]#,"Ko:'uLO$CCkO!MKjfNe@B4!!/_nB48^Y"m65kTE2.L!!!!"\,ZP^:'ohc$FhdF$HRMnla.Da!!/_n=:+a&#*0)+k]R:-U^)qd!MBIM0#%Ad-mnOJTE1@3L]@DU$-63UH2n2Z!"TEu$2=OO=:+aF"8<,C!MD^E$2=K#!!]AmaB/e"$A]3!!!B`%!%eP6TK8kK^]4?8#,"Ko=:3+LckEko"o(Uq!JH++!!!%mN,o<X"jd6S0'<LBcpn8df`BG'"kXRkTFIt&p](9pLQ!G`)>!n0!!!%mi#iN.L]jpk$-63UH2n&N#.Fr$p]5mF$2>VLmg7';Fp[pH#JUQ.TE1DGp](9p"3bcl'&jng!!!%m#ZqE.$@i6A"6Tql$Aa!.H2n-C'pf8h$CH,>$A\bm!#;#F!ME]A$.o4XLC)%(FpZe(!#Gq)h[.YU!S[/s!!!%m!MDHCH2mpF"J6"in43l\$@i*^%$q6%J4Brs!"%ir$2=LM!MD*!,eO*W!!!%mniS2<r!Dj9!!/`K!M'2jJ-_MZ$i"QD!q66c!l$-^!Kmld#2fcKTE1n]])Vg3!!/`*8.)9q$b-0j\,q1t;[7g^1q*gr!KmSA%"JQG$FkB^H2o8+"kO*s$HRMn7be.@!!!%mi]K^1iX12a!!/`=:'ohY$CDG*$E/7NM#\]s$CCeo!ME<.TP=H,T)\ilk4Cb`S-lJ$!!/`X4<;`J-ir:s!MF.[#e0j7^]6nrY6\59!J:@hYR%H5k6P/q.!bjqh>@EU!!/_n8.!oKhuEt[$-63T$0VT.!!B`%TE3H1J,fQM#k1@l8.(.QO8oT;k6P/sTG>'@!!!!"[gLc6i-GARa?,.a+954F#ZqG\!It//U`^#S!MBJIH2mpF"kO*s$HRMn&1@_6!",Y)O8o<N8.(^kTE#:K!&-qN$E/7NP*@f4!!/_n/II:6H2mpF#.Fr$p]5mFKsVs/!!/_nTE4T`p](9p$-63T$2=b/NsOrm!S%#L!!!%m$BTQ6J,fe_+:7fD!MC17K)blO$E*q*W(78o$EsL7!!VRW#ZqGDS)aX+!!/_n8-uL#\,Zg($'7[a=:)bCliZDV!!/`KB7.&dr%mdi!!/`-8-tX`TE#8e!O,*$!.OtKH2n8=S-.@k!!/`(AL,k--io+i!MF+j$2=K#rs?bKFp[pH#58DeTL]Ca$@i*\!!B`%!%eP.!KH.?!!!%mj?,oHl3ab/!!/`%UiIj`RmGX;!!/`@=:3+L"2>,G!MFSB$1Iop!M6rEHFuc2!!!%m!!%*@^fUoi$.'b#[g;2@d!>Zr$3U;7!!!%m$@mF&$Fi%X!"$_;#ZqGL6A,T!!!!%mW(76i$@i*\!!B`%!%eP.=:0ia!P\rV$BTQ6!It.\Wuq`D!!/`149qJYVu_P#TH22_nc/Xj!!/`*!T_H)!!!%mno>(fr#PeB!MBJ%E[Unf!S;G+!MCR@E[Unf#,`3"!MC@rH2mpF!k/Mea@HZb$J5=b!Nuc2fLH;$ljC60!MBIS$^q%q!!!%mJ4BZk9E7$RO8o?<k6P/k!NDjs!!!%mn43kY$)dh0!!U_?TE'HA!MC>;FMn.Z!!!%m!!%*@#ZqGLH2n'1!%/,ppBo8nfQmNfa9B$[6C`*(#re(K$J8"l!MCL@.jtAt%e;p[!MD!F"HWT`^]^<#.!bjp^Pi8]!!/_nTF1#cJ,fQM#Ok7i8-k"OO8oNA0*kYc!!.]P#_322!!i!a!MF\]$2=K#!!])e\4?sW$@i*Y])Vg_!!/`?D$c!u%tFtbJ5Zg5^]O6;YQ9mtcj/20Y6\5;7gdTD$FgGi#ZqGd$IAt6cjJDq;$4iG$IB.,[oNj_cjJ,(#j?F="2d.F!!!%m$.sP(H2n0,!VZoY$0Z[8$.oCL!K4=+49FC?gaF/c!MBIR$HN2IcjIi9a;P$cbA`+A!!/_ri(O+N"m>pi"6Tql#Zq9""o&2_"6Tql#Zq:]H2n'1aop<E!!/`'!MK>jL]uB:TI\Ftn,NFh7uo/,<P0Q?!!!%mL]Do)8-t(YO8oRU"3=">!.OtK$&AnD"6Tql!MD'f$BP5f!!C#-Qkf^b$BP5p!!!%n#ZqG$TO?h>-ia5J!NtL(\V(+3!!/_n.gbD>+7q5<!MF&3"8Dir&XNc*pdYGUliZ/J!!/a@4:R>O$MZuA!MBb1$.&YP!J9ra&%XRc!!!%mTL]FJ$K(meoDel2!!/`ZI1"$q]DsJ:!!/a"8.+8ThuEkh!!%!G!MC^4H2mpF+hn>Fp]5mF#l#MJ!!]Am!MCL'H2mpF)tsWr!MC"!"31BAO:%(H<XOoq$BPJ$k]R;p`j@Z1!!/_n8.+P\n,NZk$F!&.8.,+lJ,fql2[ELnkQ-26;8aRa!!!%mW(78_$D7A'!!W-gO@T_W$D7A+!!!%nTE2%)!!!!"!!qLf!MC+=F8u:@$.o4X[gC,XFpZe*!quuaW(76I%.XB&!!!%mP]@+]N(*bQ!!/`l=:3CTJ,hM6+:>UZTE3<%!!!!"#QH2u!MFV[[DW%Fh^E+<!RS2B!!!%mjDkTX6JhfrTE2n,-ia5J^JW3qTGFjU\c;^2s!VLlTH;NETE"rm#Ok7i8-l-oYQ+]k^BdpI!J:@]_?ce7!!/`A,73!&!!/q?!MC0lSH&WihuS?/.!bjrV7[$4!!/_nTF1PrX8i5$$HQ[<!R[,3!!!%mpJ)%Q&..P8$0WKCS6lTd!gs$_!".'g!%eQ)575a;.'*D6!!!%m#m$^[$A^\!!MD65$E*q)!!"]Df*\a.\9\,YZN\qf!!/`'4<r_`n,^hY!QWt%!!!%m$@mF&T$.<:!!/_n^j5t\oEEhR!!/a*!LU4o^BsCBTHE_M!!!!"#PTWm!MFN#P,&'X%Yk>kTGss\O8o7]#Ok7i8-kR_TE#)HY6\59TGX+ONrT.\&)'-4D#=V/!!!%m#m&M^$2@'[!MCG($Fg'9O<=O""TK)Aah.tj!!/_n4?KG@n,^VkTKeYI\,ZL0!jG3$TP\?Bi!Sr[#f'@H$/cWg"Gd)AK)c5)#d=:0!MD4E$D7A!!Q^KM!PchY!!!%mUa$5&U&Y4d!!/`!aEdgdcjR;i2[ELm\,h*[aLiW&!!/_nQRaHaKJfP9!!/`\TR$S<!!]>.f*\I&Y^-9QO9FGJ-id'N!MCY/0#%Ad-kO!QTE3?.j8]/\!!/`9J9h1q_ZnEo!!/`,,73!&!!0F]!MEtVQ&G\C!!/_n.!bjnO1YM^!!/_n=:0iaL]W>;$A_1Z$BPSXW](2c!!/`?8-k:WQiIB\#LH!I=9tQ"!#:7pO8o<68-k:_li7:[!!/`&=:2P<YQ`ni$FiS5"31bQYR7U3<XQ&<$Es`Dk]R<;YX..Pk6P/sTE2q4!!!!"%gnDEp]5mF0p<^d!!!%m!MC!V#g`PO!!i!aLe%g(#iG[c4JrHe!!.]PH2n5t]E@UN!!/a:TO$maVuQeu"2ID/.!bk)E0LO8!!!%m!MKjn$E*q)2?*qa#ZqG<!It//!$DW92[T8*!MBM3Q*^Mk!!/_n#tM&s$1KmG!MC+s$2=K#[gC,XFp[pK!hTb^!ME5i$.o4X!%Yp-TE2rhf)PdO+Mp5JTMC_"]Dqp4!!/_t=:1DqO9OMI$CF<j$CD0^!&k0cL]@I.!JB/7!!!%m!!%*@hbFL9!"%j2$0VA=#ZqDsH2n'1"NLi<!MEoO$.o4X!!<'C!MD0"$E*q)!&k0c$BP:=D%>JH!ltbZLf4V1a9B$[YQ9mo^[uIH!!/_n8-uL#\,Zg("7Shf!.OtKH2n8U\cKi"!!/`08-kjgVuR(l#-^W(=9u,2!!\JiTE#"F8-kjoVuR(l"2IG5TOahuJ,fQMLBpuf.!bjt5+D\p!!!%m!!%*@W(76I$/bdf!!B`%!%eN8TK(-q!!!!"V[@s#=:3CYciL<U$ID9M"31bicjJ,sTI'.9\,ZL0mg*"r7ffgpbRafb!MBJ##D`?["6TqlQRI.[O?NXF]*G8>!!/`D:'uLO$Fi()$HRMnH2o/H0^f@q!MB_Q9>gf1n,q8KTEL/Z!!!!"1:JZX!ME*@$NC)+n6PZKTH&msVuQeu!N7FJH2n0<a:F=s(<8$.IB3Ij!!!%mrrb1YNsXGn8(Rl&K)c51$-3)IJ4L!f$.&YW!!"uLfDkr>"?6>e$.pPZ!MEHJ$2=K#!T4!H!e:dE$-3.0#VZ@a!U'a_!Km]/p_XJ8#j?F<GiT%;!!!%mggqGf$CCjr!MCUb$(q7u!!r'bTL]Bf$*XC8"6Tql!!.]PDq#)d!!!%ma@HYo$BP5o#DWReO@KY>QjNNph[!<k!ND"]!!!%m!MCe1#H%P%!O/(V-L1ub!!!%mW(76i$@i*\!!B`%!%eP.=:0ia!NugF!MCBi$CCenf*?tLTId]4huE`X[g6(@!LNifq$6*`#OiK1=9nU$X97Vk!MBI`=C;+/BERE'"6Tqlk6P1/#Zu<R"L8-m!!!%m$.*tu$.oBA!!]Am\4?qa8,N>h!!!%m#ZqGL$HNGO!&k0c$EsP]TF%)1J,fQM(SYpW&;q^8!!!%mTE1qVVuQeu#k1@kR0g(tO9VWa-4.a&#M913!Kml$%>YLUVuV;I8-u4$YQ+su!e<fJ!.OtK3W'2^!!!%mTQUZuf1PcE"m6";2jXlETEXK]TPL&)T)\il7*IasTG4FTVuQeuh[!<k7gbmm$D7a)#ZqG4!J:A2b6jU:!!/`8TI#NsVuQeu*L@EHH2n;N"Kr0:luNN,!!!&:!!!"@mg7Wmi-GA,!&LebT*a_-Es^J$p](B^)i#pM0WHAH!!!%ma@HZJ$GZWJ#DWRe^deaIr!KY8!!/a<=:"*jJ,hM6+:-<pcR=)>TI]@hhuE`X!MDsh8-nDZOT5HM#k/T2Ta9i^!!!!"#iG]4TL]@H*3oPF!!!%mfKg(aL_][g!Iu!t)V?('Qj_giA/0n("n2]J%.&!_0oQ7m!!!%mW(76i$@i*\!!B`%!%eP.=:0ia!j;pO$BTQ6TO.O,`rH)?4N'?F15lOd!!!%m$Aa!.H2nEC"kO*C!!/Ge"1no5!!!%mW(76i$@i*\!!B`%!%eP.=:0ia#)<N+!MC[sTEG5p!!!!"i&Cb.=:2PE^]Wa*k6P/sTFHh^fDkmPQh2L/$DRS%!!!%m!MF7n#abSl!!;(L#ZqA*K)c#R#`o#eY:+\sTJOdm!!!!"huEb!NsJho8."J\S+H\7!!/_nR2(5Pn.Fjb!Z@X:*3]O\ckQYUO:o>9(>'Q/2:iJ^!O1oQ.H1]%!!!%m!MBLPF8u:@$.o4X!!]Am\4?qa$/bdckPtT7$-63Tn9P(9!!]n=$.o9/TGdSK!!!!"$BP:=TLkq%!!!!"Ns^D`8.*]HfDl6!Y6\5;7gdlL$HNS,!MC0tTr\4o)7KnQTGN80qu?]t!!/a&!L!'T-m#i(TE2s+bQ%VD!!/`'TFmmu!!!!"`sM6]TF/O<cN!qG@#R2uTP]oAJ,fQM#k1@kR0eZLO:S8jkU%tkL^V9+Vu`%k!!7r[$%N#*n43k9$&AQe!!$+l$%N#*TE1PSkPtS`Y6\54.!bkcZ]#+_!!/_n576$CH2mqaliO(5!MBIV1%YGG!!!%m!MEB`$BP5f!!]AmkXZ&J$D7A&!f%%`TLT?^W!VYp2[ELmO9'k3$BQA;!!i!a#ZqG$R/@2m!!/_nFpZe$"P3qC$.sP(H2n,`&,-Cg$0Z[8&ZYr1!!!%mYZM7RS,of!!MBIl$E*q)!"%:Kpdbar$Fg'B#-S;7!MCctH2mpFZig%N!!/`gEXK#N0]sk]!MCe"$BP5f#PSL+!!.]P$@iJ6!!r'b!MDW."m>pdkX<Hd=:+a/M#^lg$0V?ifLQ><$2=K,!"%j[#ZqFa!J:AZr!Dim!!/`a,73!&g&NFo!!/`@aEdgdcna2[2[ELm\,h*[Z.'m'!!/_nb]5*3"igY(!MCg_$2=K#cO%BhFp[pIpf@ab#,"KnTHj:5oDejl!MBIJ#e0j7!!i!aTL]@(#fluH*leOg!!.]P#e1/M!!i!aTE1.=!!!!"V[:^r=:*U`"MY8Yk]R9b&bHS>!!!%m!!.oV$A]%>"/cE,Ldqf&PR;pJ!MBIa(%2,&k\S1KTF/7:QiI*e([?#J2:O5X!!!%m#ZqDS$,@ke^^8(P.!bjp@*C7,!!!%m[oNjG\-f_M#j?F=/B\(?!!!%mLJA06!".(,rsI\1!JpeBW!^lO$ID<N!Kk;#!!!%m!!.]PH2n8UbV64K!MBJ-H2mpF.[LG)!MD-)K8]d1!!/_n4A5,CoI)8B!!/`9R0gq7cj5^6-4T_U%`em*!KmT,ck"KJ"5l]V!LNieQO2:E%F5/?.&RC(fH@p3":1n3$.p#K!MC'`(5r4nn4*EaTKoOakPtS``s>cRTKrE0!!!!"n,NKATNUUfkPtS`"Lpu0(_@5Y$CD1Y!".XTkXZ&RHgC_>!!!%mn43h8#`&Hc!!CS=#Zq@o!J:@ooE]sI!!/`:8.,+lJ,f_>$D9otO:&c'L^KLM!JpdaN!f=[!!/`@U2hX^oL8d0!MBInRe-R[!!/_n4@9&JlmN;>!!/`E.gb\F*W&?f!MDTu$@i*VV^\rm!JeTO!!!%mW(76I$/bdf*so_b\4?qi*:s45!!!%mh[(t$PR5\p!!/`cEXIU&!fo4V!MDL'$@i*V!"+NQ$1N6@&,HEa!!!%m-G+:H-1h8r!!!%m#ZqG\$IAgWTF0%9;$4iG$IB.,[oNj_`!Xiq!!/a7#moYmS1$#)!!/`a!O)D$!!!%ms!W0n!O0cQ!!!%mfLQ@:$D7A&!!of"#ZqG4!J:A2j9h7S!!/`Q!Kl^Kn0S)@TL%$5bQ%VD!!/`u8.#%kJ,feHJ,u&F#f(Bhp]J#Q!KpOg$IB.<!%eP.=:0ia!"TCO%gnDE!MBY81m.h=-p,HU!ME,n$IAbQ!"$_;#ZqGd$J5T=^^A^a=:3snKB+rs!!/_n=:1DqK)dh9$A\Z_i(+32-bB?^!!!%mk6WAbgBrH8!!/`J!J[ZU!!!%m!!%*@!MCP+"NUQC^]__K=9QtPfE::Bk6P/mTI@ARTE"rmT*SO%7g,2D!l+r3!MCO7$*XC0!!r'bO@T\fIfKHN!"#k00!?[LTE2OOcN!qG#4"B9TM:@nqu?]t5+`-YQHT[)!!/_n8."2S!!!=ef*UYeTaBX#kPtS`$.qcTTE3gJMuWhY!!/`Y8.(^aQiI3/!!"SXJ2J%uiX2%[!!/`LTIf+'ZiC(,!MBID(t8Nc-k+]6!MB\!$/bd`!!]AmkXZ$D$1IouNsEI&=:+aQJ,hM6+:6s,TE1^m-ia5J[g/^LTI%K0!!!!"!!!"@cO-%cTGs=fL]@DULBpuh7gb%W$2=j`#ZqFq$A\lCL^K56!LTqq!!!%mIJe+65GTpH!!!%mi(+1DH2mpO+kI%q!!.]P-A)Wg!!!%m!MCO!$A\Z^O8rBR$2@$u=:1DqZifIs!!/`#OEpm,!!]n>$2=OO=:+aF"d]P:!MDRG$CCen!!"]Df*\0sW-SFIg'-(8!!/`,=9PQ&!&qXu!iIGmTE0lH!!!!"YQ+]V.!bk"Zht'S!!/_nTGi^g\,ZL0$-5XE=:2hD^]CVE$G].=<1F<"!!!%m!!/Ge#j;SF!""0H#k/Tq!Kt(q!!!%m!%eP6OEpm,J,g)e+:7fD!MCpZ$Fg'9!!]AmhbFN/^^@jX!!/c#TI$?5!!!!"$2=OOTM1jupAb0o#gb+Y8-l_N`rHCl#gb+0#f$P)!!pqBT.#!cTG5%'!!!!"!N.>lTE0V>huE`X(n2`VTI-H7!!!!"%gh`OfE$L&$.p@,^Bqt`FpZe%",@0GW(76I+S#L:!!!%m^fUp<p]lid#j?F<&+]h*!!!%m$Aa!.$BPCO!!C#-fLQ@:$D7A$!J^q_O;JNG8.#%uOoPiN!!/`+8.+8TkPtsg$@kYSTaK]XRK*<g!!/`F#s=@Nj<t`*!!/a@8-tphVuR+m!jG3%!.OtK$]57`!!!%mn43h`#d=:6!!f`!#ZqAB&Ag3[!!!%m#ZqGl!J:A2bR2\s!!/a7=:+a&J-4s?k6P/sn9P':q>nVC!!/`'49CQD-io.:!MCP4$/bd`kPtT7QiWT]ci]pNa8qD+p]ZEZ"+UXXOrt"VYQ^s+n9P';!!]n=$.o9/TGQ*#!!!!"!JgcI!ndk#!!ppeBLiE]8-n,RG2rX2!!!%mTE1D/-ia5JLISmrTJ)g!qZ$Ts'!DTu@(Zj!!!!%mk]R:-e1'Pd!!/`APB&&ORNmSJ!!/_nTHM_ahZ*WW.J,_hD4CpZ!!!%m!!/`"$$;sC$.&pL!ME2`$CCen!!])epdbab$E*q.!"+6I!MCg0$BP5f!!]Am[n[9\!",)QpBmjFY^-9tU`?QF!!/`2#mc[o$1Jql!MC;#!oO%Y#k&%$#Zq1b!pC-73!4t,QRI.[TJ=(^TE"rmk6P/r7gYgh"+U]Nn43ka$*XC8!!/``VuV;I.!bk"3W&rN!!!%me0>:p#2B2G!!!%mV[6hfK*p6F!!/`8/dd+/$@i8_!MCjJ$A\Z^h[6$""?;H0$D7Rck6+;Ymg>]k"m6""8cK-jTEXK]TG5TWq>^Kr.IRQaTGkZq!!!!"$BP:==:1-4!!DBirsG->TR$S?!'lSPQO9[;Ese9;!!/SUOurs3GO-^]!!!%m#Zq6!7g/<7!l+s.#Zq6)1>2in!!!%mW(79*$GZWG!!C;5O@T`"$GZWK!!!%n#ZqGT$IB$=!&k0c$Fg+e!N))(!!!%m^g]:!0C&TF!!!%m!MFhi$2=K#!!]AmaB/e"$A]K)!!B`%!MDZP$GZWA6/MrM!!.]PR)B?9!!/_nEseQ?\,\/9#Ok7i8-m!2a8cJ?f*GIa!LiWc!!!%m!!.]PMpr)i!!/_n!-A2@=:*U[!iH@Gk]R9bfE9G*#,"Kn8."2ShuEkh!!"SW!MBqHH2mpF"Kr0J#ZqGT$HO.+f*]T$=:3DGfKn[+#d@D<TL?.g!!!!"f*]TFd!>Zq-q<q<$EsLA!!/Ph$D7`n!""0H!MDi5$*XC0!!i!a0LuM[=:)bC!!26gYQ+]VTLo"eS,`NiaC51?'C5]+!!!%mO!o;S!LCA9!!!%mk6XhHdg>LF!!/`]TI[AL-ia5JpDN"3TP'34QiI*e#,"Ko8.)!iVuR"r$A_4[TaIFmVuQeu[g6(C=:28GJ,hM6+:=J:W(78_3J%58!!!%m!MC@3.jtAt/=I<_TE0SEn,NFh,Fic\-c.@r!!!%mn43hp#f$EF!!D^]#ZqARK)cLM#e0j8#ZqAB4K8MH!!!%mLC"`JX9t=g!MBIK?]4sb!!!%mH'E=t'Ufum!!!%m!!%*@!MDT5$@i*V!!B`%!%eP.=:0ia!*9KB%gnDEp]5mF=PP#*!!!%mW]V?+5Plis!!!%mcR=)>TFd&LVuQeu-id'N0LuPT\9\,T!$&HT`sTV.aEdhT!(O.!pBo8n:^XEr8DGTn!!!%m$1N6@J,fe_+:6[$$.*tuRIiM+!!/_n8-c@!\,Z`s!k:c+!.OtK;PXQ%!!!%m^deaIa9njQQiWT^^]V@[#Q^%t"0_sd8-dKI!KmlT$(q@(a@?TQe-`tu!MBIL*R=]c!M@"eTG*P<fDkmP$,BXL$.o9^*sh(R$.sP(H2pI56*CUQ$0Z[8$.oHk!&0UXf1lY1QjT2j!!/c#8."J[q>^ki!!/`-:'p[q$E+^6W#uW_?OE_=!!"),fDkr>=9@C^kQ-GE2[ELei+W8Vhu_O42[ELeTE0S5-ia5Ja%jQnTGE\AJ,fQM#k1@k8-t(P!!!7[$%N#*!MDL6H2mpFp^[]#$'7[a=:0QYL^(<o$/e>]!JpdVkR%"a$2@$tTJ6!<a8c2@4-CfqTM=JIn,NFh(>oW;'@707^^Jdm;&k*$!JgrYW,risTHCB[+4rFkK)c%q$/bdas!W0nTKqN=k5YJ_cjDl>TGiIi-ia5JP!.,A!K4$0!!!%mn43kY$)dh0!!BGrTE'HA8-tpqVuR+m!+8>(TE'HATK)iUbQ%VD8<4&r!L)"]!!!%m!MDBH$IAbQcNpaW3ss%1$HNS$$HO+cSbrbW!!/_n!J:@P!!q3W#+$`a!MBY'E[Unf7fe:ETE1I>-ia5J`u:.^TKrE:!!!!"rsF:&8.(^dTE#;>Y6\5;7gbmi$BPUf#ZqG4$D7R[TF.Vf=:1u6/@mbG!!!%m!%eN@n9P'7J,g)d+:6[$!MCV%$GZWA!("OJ!MD`iH2mpF!#H!8k6e/6Y^-9sgBZ%3!!/`#EXD487feVI!MDLN'ZpCU-p-;m!MC/(H2mpF27EpCpJ)%Q!".(+Nsafk!Jpe-^^AEg$ID<NTG>*>\,ZL0[g6(=7g-%E!l+rK!MDl7$D7A!b;c+ETO#J>YQ+Y(9]U4$K[`>d!!/_n8.#%kJ,feH"1Ul//II".:l55Q!!!%m$.*tu$.o="Y6i!HFpZe&"MY6+!MCIF0)#>G!JTlO;7$\7!!!%m!MD?O$MXT$cU3n:TE;,6X8i5$!S7W,TI]=Vq#CBq$E+^@TN^CVhuE`X+brf!H2n;>1]If\!!.oV4fSjV!!!%m!!/Ge$2=hr#58C*#ZqFa$2=Up!!!%n!ME?'$2=K#LC)%(Fp[pI"d]MY!MC9gK)blO#d=:0T.#!cTJEN3\,ZL0k6P/o=9cPCa91T2k6P/o.!bjq4oc#3#2f^4!MDQ<H2mpF6dH*ia@HZb$J5=b!Nuc2fLH;$g^:h(!MBIJ$0V?hV[:FHn9P'9!!]n=$.o9/TNJ9<!!!!"!!;X`#Zq0'"+UL:"6Tql!MDZ/8ZMgk!!!%m$@mF&1?/PQ!!!%maB/cDp]B%R#j?F<2qe\<!!!%m!LX;A#_3&6^a9HYJ-hSF:]Z^_$J5Kk!!A<RLe%m2$KqHk6*CPr$Li?AAs=q"!!!%m!!.]PPfsKE!!/_n=:+0k#L<^t$1N6@!It.\Rii$i!!/`a('3Y"p](NfB*_TDJ//15H2mpMWWB"G!!/`YR0_^N^]Bf'OU?mT"6TpjTEkXUn-,HdO9(LL!!K5.h[&FlTNo\C]Dqp4!!/a"=95o3TH;,Z!OtW#.!bk9,hiFA!!!%maB/c$$.p=+?O5k=TL]CA%?^\q!!!%m`sG<%HdjH*!!!%mk6+6JLC0[X"m6"W52Q^?TEXK]"?sj5$D7Rck6*:/T*h4p"m6"1(s`P^TEXK]Fpa$4%AsQ+!ME!+19(<S-k+]6!MC:9$1Iopb!5nVTMiZ3fDkmP$-63T$.o?@h[&Fhd!>[Cg]F)S!!/_qTFIq%a8c2@".XB=-d4uF!!!%mfLQ,>"FpIS!(l'L#Zq4cM#]0s"8DispdbMFH2mpIb6G^0!!/`V.!bjnF/0&e!!!%m::,$i&[P#h!!!%m[jZP&TH_S\huE`X$.qcT8."J[n,NXUf*GIbTF?_]-ia5Js#0._TL4o3-ia5J!K-Mi;lTn[!!!%maB/cDp]ccc#j?F<-%m.s!!!%m`+;:8`!PpK!!/`o8.*E<p](Zr^jct(/dh@\$MXb-!MC1E$@i*VZnmanTJ5^8RK*<g!!/`"=:3+L#.FlBTE0k=^]4?8mg*"s!M'3WJHEo+!mh\aTO.Nr-ia5J]//n+TN'*5YQ+Y(#k1@k8-ud+!!!)i$*XDZ!MC:h$CCen!$D8<f*\0s=:1uLJ,hM6+:=22!MBtgEr5n;a=P@<TI?iJfDkmP7b]-oTKgR!!!!!"QO9sC:^WR'H2o&f5F2_M!MC^V#e0j7!!i!akXYup#fluI%`\iW!!.]P/CXs8!!!%m$@mF&K_.4d!!/_n!-A2@THhkbS,`Ni!!/`F8-u3pYQ+su!glLb!.OtK,a8V6!!!%m!MCG(M#[MU$Fg':\4?t2$Fg'C!Nuc2\46n9^^@:Qh[!<k7gca0$FgGY!MF#*!jM_*!"$^^!MCUJH2mpF!LF.lTL]Eo$Fg'?!!C;5TL]F*$Fg'C!!!%n!MDQE#bV.t(T.O@O!o;STH1*O!!!!"(_?_=LF@HK!K;sC!!!%mn43hp#f$EF!!.U@#ZqARK)d-o#e0j8!MD.</+`fA!!!%m!ME3#$BP5f!Nuc2O@KY>QjSWVh[!<k7gb=]$BPU^OAQ,#O:%'V#.IV?$BPUV[g;2@J9h2N]EQUg!!/a:#u&29$@iAR!MF27&VpDe)2J<Z'9F(+fGia+.!bk+TPqbEa8c2@#d@D<$EsTX!$D8<Y6qdcTF[Indf9@K!!/`&.gb\F)lc'1!MC1%"3:HB#1!QWLF@HKTIuE2!!!!"J,fV&=9sE_p]oCV#_5DM8-j`*g].TK!!/`iI0o*;o)KHR!!/`]=9P8sLchR@"JA6f"J>kT".'9q!MEHi#bV.t!!i!apdb[h#d=:4"RcUu!!.]P-+!rN!!!%m`sFV^Z3g"T!!/`ffQmMt^^m%E+954F$HRMn:l@2d!!!%m!!.]P#cJ$-"6TqlcR=)>TJEN-^]4?8!glLa=9utJ!!Kb:\,ZP^.!bk!'s[r!!!!%mr$)Qi0:Dkm!!!%mX)\NnX?teg!!/`nTKAnK!!!!"#I"2X!MCEbE[Unf/]T-+!MF\]$CCens*CJ]THD)Ze,TIL$F"/3CV27V!!!%mfLH;$i!Qt$h[!<k7gdlP$J5^D!MCUA$2=K#NsWm0Fp[pK#+#VZ!MCs["m>pdW'n[$=:2PF!!]V4VuQjT8.#%ub5_mJ!!/`p4<hfGe0n2K!!/a)jDlXK]H,mX!!/a><XQ&2$Es`Dk]R<;$F!;3!"$_;#ZqGD$Fg,?W!^%)TP:J7Z2ak*!!/`*TR$S<W!':2<sVn8#ZqG<$Fg7p)lEsD#ZqGL$HP6ZcNpaWd!>Zn_unTu!!/a5/II:6H2mpF#.Fr$p]5mF$2>VLY6i9PTG!t"YQ+Y(#Ok7i8-l^*!!!&0NsNOI!J:A9YR%H5#Ok7iTMUOH^An67$2cn?4b=#k!!!%m$HRMn$IC?e!Up,X#Clu^2[BGHi!9[_QjgJ.0EI=CJ,g"F+:>UZ!MBejH`R2IcooDUTPMaXci=%HY6\5;7gdTD$G["qcqsncKF6'5!!/`j8.)9q!!!@VQiI/D=:1].J,hM6+:<o*hbFL9!"+N($A\\3!MD?(J,fQL+:>UZ!MFYt$2=K#T*`S@Fp[pH#PSMf!MCa%$2=K#0+#^%k]R:-p]Q?X#,k'!TJ?9C-ia5JT6948TJ"+cci=%Hf*ZO)TRP)kn,NFhY6\557g/#f!l+s.!MC_($0V?h!!B`%!%eN@n9P'7!!]n=$.o9/TL$14ci=%H[g6(:.!bk`?F0mn!!!%m!MDBY!Pna9!!V9rs!W0nTL#X[VuQeu#Ok7i8-lF"\,ZW0V[-B1!J:@\UBmdu!!/`C8-n\bn,NTa!!%!E!MC""=>0^T3!>9J"6Tqlk<O=nTE1Q-fDkmP=bJ"+TI,TthuE`X!!"SW^fUp,!!L%C[gDPMTKhcIqu?]t$NCDATN1>,ci=%H#NKh27'e&?!!!%m#ZqFa$@i3(kR)i1:'uLX$@ilC$BTQ64Hff\!!!%mJ7fe#P!@8"!!/`^I0unQo)L2^!!/`L#ZsUt=AT+_=9I^l"6Tqlh^EdNTH<q\fDkmP*8GTA4:Ih^$1K7(!MB_h$.o4X!&:8o!MCFV$\/3W%gprkk]R>a!!Us]^C'a^=:9W[#EK5En9,1iJ-FO3!*Dc"i(+63$]k>q!"-M4!MC1?!oEtX-k2t7!ME?W"+U@O0;f(X!MF#2H2mpFi&;!n0S`C0H2n;^'V>`R!MBt8SH&Wi"eZt=aAFhpp^*l+a8qA./.0H*!!!%m$CH,>)k$m'!!!%m?A*>I@B::F!!!%mo5b5r$HN3$a9@V;d!>[!!!Us]h[8"^i-GAZcigNZ.FN8E=:3+Lci`G:k6P/sfQmN"!!U+Ek6g-nk^!48%C0mZ!!!%m!MCaW2>R:Q!!!%m$0XPQ@AF5!!!!%mPWURZe-^^@!!/`I8.(^aTE#1p"o(Uq8.)9qTE#8%!!/c#=:1u,YQVuP2[ELmQiV^;!V7E@!!!%mn43h`#d=:6!!7sI#ZqABK)brP#cI_(!MDdV&%;N=-qTji!MBq@F8u:@'taMH!!!%m#Zq+h!IuDm+9@Qo!MBLqK)blO$A\Z_$0YUoi*66^$/bdi"6Tql^F4C.TE0oTJ,fQM'=;ce!V7c7!!!%m$@mF&$gIc%!!!%mn7Oqc\deB@!!/`54=U")$@lI3!MC%s$Fg'9!!]Am$G^rf$@iMVa>gY(TN%ouO8o7],hd8GTIMRTfDkmP$@kYRR0nHE?jZ<'!KdGf^_c_N%)<,Z"5j<l"b6W:$A\c)!!"]Df*[UcR!J`9!!Us]f*\0sW-SFIq?>IX!!/`(TK(s3\,ZL0#Ok7i8-m!2a8cKrpBXk,!J:ABdg3G`!!/`A=94K`QilLWk6P/j=95&sg&pLD!!/`M,73i>X8kJ;!!/`uJ/0j>H2mpKRfoW;!!/`XJ4oqCH2mpOb5nLh!!/`&8.(FYQiIE]Y6\5;7gbUg$0V_`O8sb1TGZAi!!!!"k6^'mk^!4DfE1dR2qi<ZTHj%.-ia5J^L"QnTH9:=YQ+Y(BC($RTGH8^a8c2@#d@D<TO=6BM#[MV$J6*pTLk%Anc/Xj*8_'"TG#Erp](9p#,"Kn8.'kIL]@b>LBpuh7gb%R$0V_P#ZqFq!It//e0#(m!!/a=#p5*+$.(>d!MEMIH2mpF9:$!9$Aa!.Es_V;p](?C"JA9lE=)C?'Cu2(!!!%mUE^,M5-t;0!!!%maB/cDp]ebF#j?F</&DA>!!!%m`rnNF!"%:&a8c6na?BS1nHmPK$.p!o.!bjn>k/#a!!!%mJ4L"9$2=K*1:INk!!/Ge(uG[NJ2c?g">?)K$@iW\QNRr1gBrHT!!/`\\9\,T-pdS7$CCf)!!/Ph$A]%>!""0H0LuP4R!J`4]+D.Q!!/a",7<''M?!jM!!/`E('2MWQiIJ\!!"SXQq.PYH2mpPo)l`U!!/`V;$4i=$A]%F[oNilL^JqB#j?F=H2nVf!LF.Da@HYoE;T\B!!!%m$1N6@H2n356]VQK$@mF&$1L7<!%s.M$@mF&$ID)r#DWRecpnGifF#+qh[!<kTK0Re-ia5JT*!M_TK]^f?iU0-(p=3I+CI]1QRI.[TH<q2!!!!"P]%sr!!/`H#q=U/r$WNA!!/`B\/$4fH2mpLOp:A'!!/`TZZ7Goq?#O_!!/a$TFm[op](9p$,BXLFp[qFpcf&J#,k'!TJ,m:!!!!"Ns`+;\9\,l!%+<FY6r'k!"^O]RfEeg$A\Z_J4L$/$CCf"!!"]Df*\0sTL5LYQiI*e#k1@k8-tph!!!&`$((^BB./'+!MD^4@>Y$b!!!%m\,['g!"],;P5kr_$2=K$!!.]P$0V]Z"6Tql#ZqE&H2n'1!j;q*!MBXL"Qoab-nCNE!MD!,$2=K#!!]AmaB/e"L]s+O"1Ul//II:6H2mpF!"TEu$2=OOTI[l%kPtS`k6P/rn9P':!!i6)NsYT-J9h1uPQdB\!!/`4k^!4/fE.ZO&^,5%pj)o?Qj1kC`s>cS7gb%\$1J:h!MD03@@@/r!!!%mf*NFe*RcE.!!!%m`sE!.?BciA!!!%mP<9)J6`_[[!!!%mY6e@d.uG_u!!!%m!!%*@n5p"lJ/uZ:h[!<kTKqK?n,NFh@=rS,7>"9h!!!%m!K[Z($E+<1Y:^0DO:%'P$+k3b;M-LG!!!%m#ZqG$$D7La"6Tql#ZqG49E51X\,Zl?k6P/s^j5t_`!3CP!!/`Q(':00aoDXe!!/`9@TM7agAhT%!!/`iY6dl&lO!&%!!/`H4:Rn_$CFTC!MCNl"RlBk,3K56n4*W6H2o&jj9G?,!!/`R49=%6MC;-`!!/`-V[6Q-b6dYB!!/`1TMD!W]Dqp4!!/_p8.!oKhuEt["1Ul./IC>8$0V?hLC)%(n9P';J,g)d+:6[$!MEfD$GZWA$Fg']dl[\mPR>26!!/`p=:1]$!%6q8O8o<6TIu*/fDkmPB\Xg=TO>,,PQ1[a/B8&kTEs7"n,NFh;QFgE-))XA!!!%mn43k9$&AQe!!/HX$'9H5K)c76$%N!Vn43k9$&AQe!!0l+$'9H5K)dsi$%N!V!MEJg#P7urn1"ADTK&tYPQ1[a(Uj\p;!SJ0!!!%m$J66s"elFs!!!%m'^$tp.\d.%!!!%maB/cDp]T1T#j?F<B;,Ls!!!%m#ZqG4!It//Z60L9!!/`A=9u,2!&oZ=TE#"F.!bk!-]A(u!!!%m!MDo_$)dh(!!r'bkXZ#aIfKHM`!N@B!!/`_>n3e5&"j5Z!!.]P=l]s@!!!%m!MD]i$.o4Xh[.)#FpZe)"lBUL$.*tu$.o?@!!])e\4?qa4G3\:!!!%mb<-$%,Q&qs!!!%m!ME/>$2=K#^Bq\XFp[pE"4mhB!MCdg2MV84n0@QfTL8>XTE"rm#k1@l8.)9q!!!?#YQ+]k!J:@ZZjNH+!!/`r$!ksZ$A^C&!MCq7H2mpF5*lP2f-kqFTI?96p](9p6)/K-4<=G%$@l9B!ME9TH2mpF!M9^TTL]EO$@i*\QoMQMW-SFNj"6#n!!/`?7gdlK#d=ZGci=Ug!#ttG*97IB!!!%mqf3%JM_3g/!!/`J8-uL#\,Zg(#_5GP!.OtKH2n8U/:nB\!!!%mW(72M#`o#h!nR][!!.]P#_322"6Tql!ME]IH2mpF9E7""e,Tis!!/`P!It.Mdi\tl!!/`1.!bjn$+g><!!!%m#ZqAj#j;BR"6Tql#ZqB%H2n'1#-S=-$%R=%H2o/H7*c0qnoG*3$EsM+Z3KJBTL$1kY5eP',hb@''r)+t!!!%ma!c66TIbZtci=%H#.IV?$IB.,mg/-#TFo'B!!!!"$CCjE=:*n.!!DBi#Oa'e!MC:AJ,fQL+:=22!MEGg$KqHi!!]Am\4?tr$MXT.!",r$#ZqIbTH^s+o)Jak!!/`E4?h'kqBuX/!!/`S#m8TU$'60_!MEM`$'5,e[pXf.!MCYJ.\?\@-rnJR!MF)S$(q7u!!r'bGXr.>!.OtK7Z.SG!!!%ma@HZ*$D7A*!"%j[#ZqG4!J:A2dL)?A!!/_n,73!&U]=8E!!/`WTIKd=TE"rmQO$\#!J:@\M@,FF!!/`F=9Y&lTEF?_k6P/n.!bjq4odIL"ipkG!MEK2#H%P%-q]+S!MCb9!K[9]"n)_!!K]fr.!bk98G`J?!!!%mNsTOsOpUUY!!/`48-l^*^]4W/!q8_daEdgd!"-IH\,ZP^TL,(Q!!!!"f*(kp.!bjs=2RDO!!!%mb&RgXr&^f2!!/`$49FC?j<tt;!!/`oEXI<s0u%/6!MC=r#J^<>6)Ouj!LX26fFQV"#3[B<Op[")"lN2XpdbY:7B-=h!!!%m$K-41M#[\I$IAbRYZM7bci_#g$IB4h2<5+s!!!%mn43k9$&AQe!!CS=J,k'!TK^7"iW&rZ!!/`.,72]snc3"M!!/`o!-A2@=:0QY!!DBirsFR.TMVus!!!!"<sjJ(a@HZ"$CCf"!Nuc2Qq%LNTF-J^h[!<k7gbUe$CD0n#ZqG,!J:A2O:%'LLBpuhTH9O,P5kR`.A$oL+fYjq!!!%m$D;\F$E-I]!&k0c$BP:=LjB%D:TS19!!!%mO@T_/$A\Zg%Z^lt!MKjN*.n4k!!!%mS8nt8WW_KO!!/`Q!It.M]H@OU!!/a#<s/3t!!#X;J,fV;":"l/"Fp`<!MBM:$.o4X57,,-k]R9bfE0A)#,"KnTLn,Cp](9p#,"Kn8.'kIJ,f\]!!"SX^fUr"!!\Jj[gJ4C!It.Sq]H4?!!/_rFpZe$#HnEs$.*tu>c\&-!!!%m$D;\F$E+71!&k0c$BP:=TIQBQJ,fQM$D;PL.+]0RTEXK]"=Me.$D7Rck6+,T[gJc3"m6""$A]%^mg>_2">6$+$D7Rc!ME,u2N.V9!!!%m#a\V3.!bjn:P/l'!!!%m#ZqGT$GZi&^^A.Q=:3+VK)dh9$Fg':$@mF&>P&$T!!!%maB/e*!!hs!%gnDEp]5mF2hE.Y!!!%ms!W0nTEUJ\U]:Aq!!/`/!-A2@8.!oKhuEt[$-63T$0VKc!!B`%!%eN@TMtF^-ia5Jh^"D+TJ+^pLB%;T#i&u3@'U-t!!!%m!LX;Q"fMI+TI(**#H0lj%-R_T$K)!Dnc/Z0!!/`CTKoOX!!!!"[gJ4C!It.SK-1Kq!!/a'8.)R$\,Zd'V[-B37gcaD$D7a9$G^rf;q*UY!!!%m!MCL@H2mpF289IU$0Z[8$.oL7!#FR8a@HZr$K(mcirB(!!!/`Y!-A2@=:0QYL]cfGk6P/s=:1,l!!DBiV[Af;TLmm.f)PdO?]mN;&,Za\!!!%mkXYr_#Ija<!!@aBYQ0.Q=9l&8YVP)A#I$]'=9l>Iird%%!!/_u8.)j,H2mq!"kO*s$HRMnH2n-#*4H:%$J9Y))7'Lu!!!%mf*PomapIPE!!/`S#p5W:$.(8r!MC,($BP5f!!]AmpdbaZ$D7A&!"%j[!MBRY#bV.t"6TqlQRI.[TGXF/!!!!"fDknn$-63T$.oHKQO)eufQmN&q?",4!!/`7#t<>D$1J/V!MF@o$*XC0!!i!aO@T\f$,?NH!Ts_j!!.]P,jG]?!!!%mTL]Ca$@i*\!!B`%!%eP.TEVY%!!!!"^]4D&a?BS1fEon2k6P/ri-GA*!!iN1`sLsUn9P'URg&Nm!!/`@=:0ia"TJeL$BTQ6!It.\PTU;-!!/`&70SJI%G2_h^hk%Ki"VOt"NYL&7KSZB*l&JOW-\rg!$7L:$2=LM$1N6@AX`nM!!!%m$@mF&$D7Hm!Nuc2TLT?^dL)?K!!/`7!M'2j^]_.qQO$[r7g-UF!l+rS#Zq5N@(QT?!!!%mrs9IiUC$E8!!/`!=:+a&#)<N+k]R:-2qhmM!!!%m=94rm"2G#K"IBBr#Zq2M"4./5"6Tql^F4C.TOdp#n,NFh-*)(nd!>Zl]*7X0!!/`#Y^-9L!#Ub(f*]$6^j5taTHr+r-id'N0LuPLTJPX/_>jQ:/cQ,&TJ(pGa8c2@%d5A^'Bfn`\-pZ'"WjTP!VdA-p](jJ!L!Ki^^9K1$1LIlTFJ4-fDkmP"KNaRTJ,U2pAb0o/Xnje4JE/O!!!%m!!%*@!ME!,&%;N=.!'u&!MF>R$EsL1#d=:S#ZqGD!It//RNMs1!!/`38-t(Po)K-%!!/`N8-tphVuR+m#M;QR!.OtK>N6$_!!!%m!!%*@\/#+MH2mpPr!2sE!!/`b=:3sdfEL.<$K+D]$K)9D!&k0cci=*!TNREbJ,fQM)ROMl@u:J_!!!%m`sFO!'Z)7%!!!%maB/cD$2@R.[g;2@TOQm`!!!!"n,NH1#,k'!=:+a&J2tp]"3="?8.(.Q_>jo+!!/`[XE#]hg&gFJ!!/_s!-A2@8.*E<ci=9C$FiV68.*uLaoDda!!/`D!LNiep^-Ei[g6(B=:0Qf$2>#:!!!%nf1lYI!"&E5[gIq;OEpm2gI\j]!!/_p8."2SkPtqA#J`k:=:+HsJd'I+!!/`6/cjT)!SBc3La`@\i&m>,&_KMg';-$.^`LR"TH);pTEs`^>m[_O']9f&TQV-mn,`:g']<45*2"=F#f$J!'9ip`!!!%mUN-\1gErg$!!/`a.!bjn5eI3n!!!%mn43kY$)dh0!!2R[TE'HATJc'BkPtS`+5]g"IfKh3L^Jq<"kZ?Q=:1,iO911C$BRab$BPSX$BP6o!MF+a5bnA[!!!%m!MEu`$2=K#!!]Am\4?sW$@i*YL]@E,$-63UH2n)?!"TEu$2=OOTI#aDYQ+Y(Ef4rF2r#dQ!!!%m!!%*@!MDBY$HN2I"lBSfa@?TQa9o]i2[ELm!ME2N$A\Z^#DWReY\ai2L]i59%&cN#"h4p7n,nb-!s=>c"h4nqfDlB%L^`2D#(T,Q$BPar"lBSfO@KY6gBr`D!!/`@=980sn433Y!Vf.c=981.p]?cf!Vf.c=9=!anctKe!!/`q#umZ"$BP>H!MB[V$/bd`cnG,gi-GA1!(?8_ci=*'8.*EFRK*]A!!/a'!-A2@=:*U[#/:Jck]R9bl3HJX!!/`k8.+8TkPtsg$BRdcTaK]X\,ZL0$K+G^TN\o,TE"rm:T>WHTP1A+p](9pk6P/r=:0Q\L]cfGk6P/s=:1,l]*%4%!!/`<=9Oukn,qhZ!e>+o;[^Z+p]cd-J,tf=KEA(R!!/`A=:*U[fKT\`#j?F<H2p=Y"fD[Z!MD(:H2mpF!"TD*$.o9/d!>[7gBG=u!!/a$Ese97Z2d=F!!/`R7gca+$2=k;!!.]PAs*M"!!!%m!ME94$IAbQ!"$_;#ZqGd$J5T=TF0=A=:3snK)dh9$IAbR!MD9\F8u:@$E*q)"6Tql#ZqG<*W#s%!!!%m$BTQ6J,fe_+:7fD!MBe[#d=:/!!i!apdb\##f$E@!ga0p!!.]PH2n5T]*"ZR!!/`QTP`Zg_>jQ:!!/`+!-A2@R0hLGkRHGN!Kf>K"4mk#Qj<rl\-0#GciK:<fERuZ#j?F<H2n/a"5aF3!MC"RH2mpF"J6"q#ZqG$$@j5mn-YOQTEq>"J,fQM"6`8_8.(.QJ,fo>!!/c#=:0iaJ,hM6+:7N<#ZqE&H2n'1'=S;C!MD9N%cRHgfESMcTL#(TQN.!d,JlPsTJM6L!!!!"Y6pqKW-SFH!!081Y6qL[EseQCP5ka?!!/`s4<M<<as\*[!!/a!:'p[q$2>.b$0Z4K#e15g[gIpiOo`W.n.4^`OEpm2+A'$L$2=K3!!/8`$-3GB!"&-c!ME#j$IAbQ!!pY:W(79J$K(mk!",r$!MD$W$1IopO$'diTO`pHf)PdO)W(Zb9@jKsck"/""<=$?$.)5H!!.]P$,?k_"6Tql!MF):"31BAkR*\S<XP3#$CD%,k]R<#dK,C7!!/_n$"V`iUF8Ns!!/a;TI'41!!!!"pBf2m8.!oLhuEt[$-63T5I1Uh!!!%mO9(mP!!85_1rh"j!ME3:H2mpF#N#lEW(78W$@i*\QiZ)>TaI.o!!!!"Y6pqK=:1uV+mV&m!!!%m/?Ek?1ueb[!!!%mk]R<[$IC.+!"$_;#ZqGd$J5B_TF0=A=:3snK)dh9$IAbR!MD95$Fg'9!!])ehbFN/^^@jX!!/c#TL4V;huE`X&cYT4$,?n@i!uDs;[:AL-1;2FVu`'+!"SK!TE#"L=:1u6!!DBif*\a.\9\,XMDa8u!!/`In9P'7J,g)d+:6[$$.*tu%[mF-!!!%m!MCh2J,fQL+:6[$!!/`"!It.MiZJR&!!/a%!It.MWuq`D!!/`:Z>q>nKF6=G!!/`\OEpm,QnPoLh[!<b.!bkE"1&$#!!!%mn43hp#f$EFa8f%-pBXk,!J:@SX9c<9!!/`CR0p.uTEY)k-3MTs#-\6'!KmJ6$]#"K!-&@MTM*H.J,fQM9CFA<$.;)n!!!%mfE$L&H2o&o"fD[R!MDXC$2=K#!!])e\4?sW$@i*YU&Y0F!!/`&TK(*pTE"rmk6P/l=9GK(YQO%ok6P/l\4cl)H2mpI_ZT'M!!/`:!It.Mp`Kn<$-63TFp[p[!iH=f!MC4fH2mpFoEY+=!!/`U#n"lV$2?6A!MF7uH2mpF#M0:7$/g+0H2nhL#0.&6ic>FY$2=L0mg7';Fp[pK0!>QE!MF)"/rBW/L^3)LTR,<!^]4?8D9F.2TN\o,YQ+Y(-i7ok54h=Z!!!%mTL]CA$/bdf!!B`%!%eN8=:+0k"-3c0!MBRr$BP5f!!])ehbFN/QjT2]!!/c#TR$S<Z88Bc!!/a.pj)o?o*+jo!!/`F('1rG!!!1i"32g9!MFhH$)dh(!!r'bBLiH6!.OtK<Po-A!!!%mh[(k3iX1JC!!/`eD%;@%!oOL6J5ZN2kQTQFciK:2Op]hH!!/a)('1*/J,fb7#I&%R#,hZd!M:c=!Km_M%Bp)i!MFkAF8u:@#l"B"!!]Amn43k9$%N!]L]@E,#iJ5[TO6[YfDkmP$,BXL$.o@3Y6a?88.!oMhuEtS"1Ul.TG?MfkPtS`7)r%+$A]#`*S1R!!!.oV$0V]j!"&Ek!MF_DM#[MU$@i*WJ4L"9H2mpP!ga5g!MCjZ$.o4X^Bq\XFpZe'"2>-*!ME/]$A\Z^!Nuc2Ldqf.O9t[hh[!<k7gb%U$A]%NLf"8pL^JqF#.IV?$A]%Fk6U9pJ9h2SN!@T8!!/`H8-R??!!!.`k69LaT`re8q>^Kr!!/`#R0n`M\,t"X-48B3%/:'`!KmhP%#>D?$BTQ6$A]Gs!!!%n!MFo5F8u:@$.o4X!!])e\4?qaF2It[!!!%mn7PtZqa[7b!!/`I8-k"O#`o$g!'^`kJ,fV&.!bk!/qO2/!!!%ma@HYo$BP5o!Nuc2O@KY>apIPE!!/a-.gge,:!s@"!MDQt%ZCAf!!!%mT*Z;0U^6/h!!/`C8.(FYO8oEV!!%!G!MD!F!girf"6Tql#Zq/$H2n'1dfZ3j!!/`rR0/6FTF%7lOU0#1"nr9'^^(@!fF"h`p]6N[n-5Nd",KGK.!bkQAV1'a!!!%m!MBap$/,@Z!!!%m!MKj^$@i*V!"+fY!MCg9#G1trJ0(LKTHK1#_Z0Z;,3K7;#fI(+!!!%mT*Z7nM[@`7!!/`#:(!'_$E+]kLe%l_M#[M_$E*q*#ZqG<TJ)3^O8o7]"o(Uq8.(^aO8oW<!!/c#=:1DqO>[%D$CGK64/+pM!!!%m^FKYaZ=L:1!!/`C7gca+$D7a9#ZqGLK)btN$EsL2n43nj$Fg'@f*\0QTQ.jqbQ%VD!!/`&=9HnMfGT_UY6\54=9II`M?E#I!!/`Y8-nDZhuF&0!!/c!k^!4/irlOk!!/a*aEdgd!"mfiT*iqkEsf]I-iaRk$IBV$$IB[k2WI0B!!!%m4o[#\@]F&:!!!%m\,h*[1P?kX!!!%mk6W'\UC$\s!!/`+ZZ7GoJeXPb!!/_u!It.M!$DU#"4nrI!MCh"2"L\ILb$dXTPp;,?iU0-"8<('+CI]9mjNJ^TH<q5a8c2@"e\BncoqF0a9pQ,?b0SO8.!oKhuEtS"1Ul./IC>86^duT!!!%m#m#^C$1J2O!MBST5)0+<-kE[I!ME9L$IAbQcj$s[FpcS'3L:$8!MESY(WudY!!!%mTL]CA$/bdf!!B`%!%eN8=:+0kUFuqh!!/a2!J:@P!".'QD[M#@!MESYF8u:@H2mpF"Kr0"O@T_OH2mpP"Kr02!MC8#=<ISD_[#W9!!/`h=9@+Thui-Jk6P/k=9@[gireHM!!/a(=:3CTcj,=3$ID9M"31bacjJ,s<XR1\$IB!dk]R<[!!_$\V[@s#TNRE\VuQeuV[-B3R0p/$fE6X)OUJAokVibJ!Up@$$`F)V"NUV,J,f]8+:=J:$CH,>H2mu,/+3h<!MC^D$(q7u!!r'bpdb^iIfKHL!"#:u"HOsW!MBUZ(1@1C!!!5=#0/-<!MDQ<$MXT$#/:FG#ZqIb$K)-'kU6F-Y6\5;=:4OHUBBZb!!/_r4:dbYM^V`&!!/`b#n$#!K.%ee!!/`58.(.QO8oKX$0Xne8.(^aTE#;n$/e>]TN1R`!!!!"Y6q4SY^-9P!%Z(sV[Bq[TGt6BQiI*e#Ok7k=:1]$TE2e5$D9lr$E+9p!P\nB!!.]PH_Uq8!!!%mn43nJ$CCeu%$q6%Qq%LNZO,h&!!/`M49hDXb:"'X!!/`b.!bjnB$1F7!!!%mn43nR$D7A(#JUOHTLT?^W!VYp^BdpKTH3A(huE`X!!"SW^fUp,!!V6d%gh`OfE$L&1:&)0!!!%mBLiEER0^k6TE46WOTN$$"4%5RQj=+^fEpaMQiW?[K)d"q#e0j8n43hp21bf5!!!%mRQLrGg'R7&!!/`i8-tX`TE#8e#M;QR!.OtK#HA)t!!!%m!!/Ge$IB.$"h+b>fG4P)$J5=ca9p:.8.*->!!!AI#_sgS!MC`lF8u:@$CCen!!r'b#ZqG,$D9D7O:%XNTIS(kYQ+Y(#Ok7i8-l^*^]4Pbk6P/q!J:A)OpJ8l!!/a14:dbY$@iBP!MFAk$HN2I!!!%n!LX;A$d]$T!Kdi4!m_.VO9c<J\,k4iVu`%aa9CK0$HNY`$IB.,%g]CA!ME_M$Fg'9!!]Am$G^rf$@i`'a>gY(fQmN)N'ZV6!!/`6!-A2@=:284YQ:p5$F!#-$FgGA"lBSf\46n1`sT$X$F!A0?,I#R!!!%m#iJqf.!bjn6,Noq!!!%mO@TZ0#iG[dLeF?Q%1%aq#iH!Hi%[ls!!qKg#hT-,O@TZ0)N4Y"!!!%m#ZqE.H2n'1".'@F!MC7(#bV.t!Ts_jTLT9L!!9Y9"32g9!MC@SDLqign-At"TIGI!`rH)?$Fiq8$FgGQ\-BECFpb_d"K)Oh!ME?M$2=K#cO%ZpFp[pK#KI,6!MF8_.jtAtM44XoTQ7@>ZN't+%Z^p>'q,Kf!!!%m$1N6@H2n-#%GqKe$@mF&H2n-#'u(*3!)O!cBaNuO$.oRB#ZqDk$.&a/fEpJMTI6NA!!!!"Lj/rk.!bjqTK:8/QiI*e$CF<j$D7^h#HnD8!!.]P/rC!t!!!%mn7OB5ZR`3c!MBID$IAbQ"6Tql+?p4[.!bjn&E<eX!!!%m$.*tu$.o<W^Bqt`FpZe("RcW[W(76I2sLAI!!!%m!MC^>H2mpF!K')i!!!%m#Zq/\H2n&f]*#5b!!/a9=:0iaJ04Lk$A`C'H2n98"htB5!MBu"$/bd`kPtT7$,BXLH2n'!!"TD*$.o9/THKC?!!!!"!j="u!MDU1@c@@fn/7Q!TIc95p](9p$,BXL$2=_6rs7h38.#%qJ,feP$,BXM$A\nq!!B`%!%eP6TJhE&o)Jak!!/`M.!bjnTEGGmZiC(,%+be3TI?6W-ia5JO$;$5TF(Gr!!!!"!!!"@V[;"%i-GA*!"u19LC*0jTE4*VL]@DUk6P/r.!bjqM"1WI!!/_n=:3CTci`G:!'!1Mh^EdNTF/jET)\ilLq>bQLnZ9u!!/_n4=%rI$MY:!!MC8$!iQ)!"LeY=W(-oVSH(VN!h]f"!MCWq$BP5fRKD@sTIGKpfDkmP#,"Kn8."2ShuEkh!!"SW!MBh;$)dh("6TqlY:+\sTIb[)huE`X"2IG78.+P\&-*!'$K)a4!MD$5$.o4X!.=WaQq%LFQjSo^2[ELm!!.]P$/c/HL`qOKR!J`>!%%(@L]@I4J9h2&r$]#]!!/`$:'ohY$A]j\$CH,>M#\u[$A\Z_Le%jI)7';M!!!%m!MDf<"igTCJ/7K6TGI)*q>^Kr.d%+_!J[<s!!!%m#m#pQ$.&h$!MD@!7HsjQ!!!%m$2AfHH2n#U9:$!9$Aa!.8*^8\!!!%m6gJb@1%Qle!!!%mJoV1eW^iZl!MBIF$.o4XpBeoCFpZe*"TJbkW(76I$/bdf!!B`%!MCO1H2mpF"kO*c$FkB^H2o8+"kO*s$HRMn)sRR`!!!%mf1l['!"+5k^C$'K!JpdWL^JY4V[-B37gabK$@iJ>^J5,dO:$M+pBXk.TH!b/RK*<g3kktlTFnIXkPtS`LBpu`B`dK!!n[S4fLQ(B!n[JS"G[7bfLH"IK=_Zr!!/_nTO+Ana8c2@$Lgq##l"_)$Le(X$HNSDn-+jcTIJ:re,TIL!S7V^TQ\d4a8c2@#1t.7H2n&?"kO*[$CH,>,LQ\?!!!%m[jZP&TH3;&_>jQ:!MBIH)?9a;/+O%'!MDT^$GZWA"lBSf^deaA^^@RY2[ELm!MBP#4@]AOciJ[/TQuD$k5YJ_=RnQW=m??m!!!%m#ZqD+$(+*+i!H&H.!bjq"LA?J!!!%mTE0tFci=%HLBpuh7gdTJ$D7aQcqsncK*os4!!/`aEXJ`Fq?NX&!!/`h@QU:a!!!?#U'cDhTGi_Mq>^Kr!!/`Ga"&P<!J/-@!ME*&21kl/!!!%m#ZqE.H2n'1"5aH9!ME-'"2Fm:!j;l3^deL2!!1FK!m`9@!MEN+H2mpF8ZrJO$CH,>LXQKp!!/_nTIG`uVuQeuk6P/k=9>]/\-(n"k6P/k=9?8?a91T2k6P/k=9?hO!!DBi27Fu[!MFXp!fm<]co@IVTH`A%p](9pk6P/rR0nHHkQem(OTN#s"6Tpj^^("W\-9YS\,ha%H2mpK!!f\UO:$e-TN_1!`rH)?$A_O]$A]%FL^(=hFpa$4"n)`\!MFB-E[Unf"QrsH!ME6;",HpW"6Tql#Zq1j".02R"6Tql!MCct$IAbQ^Bj%HTG<+`M?!VW!!/`XTL,XY\,ZL0NsJhgD%ER&\6oHLW$"G.1(1l#O:V`>!Or45"4.81QjhmQ71JGd"5jFZ#Zq,CH2n'1'?:-p!MC"Z#+kkqJ5YAhTJak!Z2ak*!MBIEH2mpFOp.a3!!/_rR!J`4YV2m]!LQCb/IJ]^4obQ_$G["YUL+A4E[Uoq$.f?DTE1.TU&Y/o!!/`1=:3+LK)dh9$Fg':!ME?M$IAbQitqb)+0Pu2TP^\Wa8c2@6C/>mH2n;n"Kr0ZU2p[W'USkGQiXEW8.)"3VuR.FLBpuh7gc1"$CD1!#ZqG<TEr1h-ia5JM?2<ZTG!`1J,fQM!W-mE;5,e3!!!%mLe%l_$Fg'<VuQfL$FiV6.!bjnTNSmFQiI*eV[-B37gb=[$1J:h$2AfH.-!8L!!!%m!%eN@n9P'7!!]n=$.o9/fQmN?H2p/9#/:K&$0Z[8Es^K#!!$'[!!!"@.H`+*!MEWm)ufm<Y^D<jTLQL"k5YJ_3.j=I&VCFp!!!%mn43hp#f$EFa8fU=QO$\!!J:@Sap>KW!!/`OTaJ:0^]4?8V[-B3=:3+PJ,hM6+:>=R!MEQc$@i*VI)CFa!MD6\$GZWA!!_p`\4?tJ$GZWK!!!%n^deaIRgPeq!MBIW#d=:/!!i!afLQ:X#f$EF#Nl@p!!.]PEgm?=!!!%m!!.oV$FgGY!!!%nYZM7JMZLQu!!/a;8.)j,J,feP!T-WZ$G["a!!!%n!MFjuE[Unf50kIj!MC-j$CCenTI9e:!&-qN$E/7NH2pF<"Kr0:$FkB^H2n-#9D8e/!)O#qTO[78JcGcO!MBIK3em\8QiscYTQYqpO8o7]#Ok7i8-kR_TE#5TpBXk,TGQ<Gp](9p5Q<5?8&Ai+!!!%m!MDEq$BP5fO:%@F=:1E&K)dh9$A\Z_!MCBp$GZWA!!Alb!-&@]TFC/eRK*<g!VZmD4KAeX!!!%mfGOmla9o-U"0ctY#bV7/"+Xc8T.#!cTO,eB!!!!"YQ+]V8.)R.\,Zd'V[-B3THrh)ci=%H$BRdcTaJj@!!!!"^C&>6THho/fDkmPK'OWf2kp?R!!!%m#ZqGl!J:A2Op]P9!!/`q8.*-4a8cD5rs2^68.*^$fDl*M$FiV6TFolXp](9p';KRT5JdQ\!!!%mn43k9$&AQe!!gkAJ,k'!TFA^EP5kR`50jN\$cEC.!!!%m!!.]PPFDoH!!/_nTK^d(\,ZL0"1Ul/E=02U7=kL>!!!%mZ>p8u4=T_K!!!%mNtM`VL^8ed#iH-t.ZXkni!A6q!.OtSH2n6'!"?mr!!q4N!ME]0!qH<k!!!%mq`IOOE/Q+V!!!%m!!.]P1m89>!!!%mU-'n!%[&4i!!!%miZee\;PO52!!!%m-tc2:30PZO!!!%mTE0i=-ia5JLNA&fTLAZ@!!!!"$.o9/TFCH8Z2ak*#+l2:!J08Z!!!%mW(76i$@i*\mg7';8.(.UL]@Oe!!"SX!MDNT("*'^!!!%ml>d6Ag-M&u!!/`?4;YI,$1Lpc!MESI#k.fo!!RmD^dnb+$%N!X!!/``i(+01M#[M]#l"B#!MKeg)?9a;AZH++!MFT$$CCen!&<4Q!MCan#G1tr-p<`)TE0`+!!!!"`sUaN:^Y8U$IBmqZSr.l!!/a;TM+SN!!!!"YYY@k.!bk!"0;S(!!!%m$Aa!."2"Z4!!!%m!!.]PH2n5\Z3$pP!!/`-TQH=sJ,fQM!*Dc"kXZ);$]k>q!"-M4!!.]P$\/V8RK-G\!!/`:=:*U[#PSPGk]R9b!!B\9NsX0ZTM<T@qZ$Ts!!/a?8.'kIL]@\L$%PPR=:1,i!!26gJ,fV&!K<0K!!!%mWcAGsU'8S$!!/a,=9s]_!!DBi#Ic+-TE0ebWW3#"0p`2&E2*bj!!!%m4POm)&rS9d!!!%m7gTIF!NQOR!!!%mo/nMk2mXo\!!!%m!!%*@$1N6@JD(&(!!/_n8-lF"\,Zd'"0b<%=9u\B!!9>0YQ+]V8-lF*\c<!)!!/`k8-tX`TE#8e"/n`s!.OtK(r?TH!!!%mb</;XdL#DQ!MBIP$HN2Ia>32td!>[!^]^hJPDaJh)nH"M-jA3/!MBPMH2mpF!P\s1!MBu""O[8ML`aA<TFm=oci=%Hk6P/jfQmN"i#\csk6P/j=97Uf!!DBi!!2R_T.#!cTH*PfO8o7]#,"Ko:'uLO$CCkO!MKjf<g*L`!!!%m!MEPi#_2mT!!i!akXYu8#`o#g"-3^iTE0_(a8c2@#d@D<Q@f7b!!/_nHPu;Q&;U@KB_ufu/E6u5!!!%m#ZqGLK)e$[$EsL2!MEQcK)blO$EsL2$E/7N$EsT0!!i!a#ZqGD$Fi4ETF/2!!ME'm$((\m"df=Y%F>Thcj9+fOpI-VL]r;08-tpo!!!8.$((^BQRI.[!Jp:L!!!%mn21=:p^5(L#bX]q8.0qJp](ZB!!/c#BaXV8#KR8A!MC=*$K(ma!!C#-i(+4=&.egEp^5pr$K+G]8.'kIUAtYb!!/`QTQ.gKTE"rm%>uG<TMC[NTE"rm2[ELm!!.]P+OUUY!!!%m!MDF+$.o4X!.3IAa@HZb$J5=b#DWRefLH;$i!RO42[ELm!MD1$$BP5f!!])ehbFN/QjT2]!!/c#TR$S<W%kag2[ELmO9'k3OP1fa!!/_nAJb@Hn,\Q%TE^PcO8o7]LBpuh7gb=_$1J:`#ZqG$%dO;U!!!%m!MF,s9="Tu!!!%mTL]Ca$@i*\!!B`%!%eP.=:0ia"1JTX$BTQ6J,fe_+:7fD!MCs[$@i*V!!])ea@HYo$BP5i!"&-c!MKjV$BP5f,aSd=#ZqG$!It//J052L#,k'"=:0iaO9V$W"6`8_8.(^aO8oUV!!/c#=:1Dq9U[mG!!!%mTL]F"$GZWG#+#TtkXZ'%&$l6<!!!%m!!.oV$G["Y"6Tql#ZqGTH2n'1"MY:o!MESY#(lmU!!!%mq]cH8U&Y4]!!/`\!JH@2cj&Y>TGZ)`-ia5J!LiS"0^Ae$!!!%m!MC@KH2mpF!j;pW!MDE@$/bd`kPtT7$-63TH2n0D#.Fp.fE$L&$.p@,[gC,XFpZe("0W!o!MCX[Q]_=K!!/_nTMjbLhuE`X$'7[a=:+0ki!@X7!!/c"=:+0kfE-g6$0Z(0$/c-JkSiVZ:C6e&$@i+!!""0H0LuP,TLt(A!!!!""6V(Y!MBaO#cI_'$\o!in43hh#e0j>!!2:S#ZqAJR?Ij,!!/_nTP2LKOoPI_+--_R!JHXb!!!%m!MD$U$1IopcZ6@4TKeSUa8c2@#d@D<QHBE@!!/_n8.'kIL]@aCh[!<kTaH;Pci=%H$@kYR!K<0A!!!%mK;*B7o**_H!!/`'!-A2@D$['?%EJjKfM`1)\-K2D^]BT&!"?XO`sL[Mk^!4`au-X7!!/`g=9Foj!(>-=TJ-D;=9H>@WXPd2!!/a,8.+P\n,Nfo$D9osTaKu`^]4?8$Kt"f!M+fB!!!%mZ91VV"8XE\!!!%m>,uZl"/7ik!!!%mg2[MhWY`-'!!/_n8.#%kJ,feP$0YIu$A^3n!f%%`Ldqf.O9t+X2[ELmp]5mFNiF3.!!/_nzfa[u^"9dN`!i,jnD,gYV]k&?Ulic5Ji8#+LTE^nh2uipZ5X5@35ZhLr!MBk69E5%m3"Q'D&3'dT5Qg1/!MBed+--C%5RQ"'!MC%CH2mpF!(6d*#QK$p$hSLR(e?Ud:jN*A$)@Uj!!!%mk6V6l$f#,L!!!%m&Y*l<"3^h-!!!%m"6VWTTE^WO]Dqp4-GKiiTFI])!!!!"!j>FH!!/`[5UZU4TFf%L:]LIrLBtP5TE1QH!!!!"j?#UF!!/_oEWL[j6gkB3!!/`"ZuTOSUa+b)!!/_s!LZIY%^6?)#UT]<"OI:M%#=qIH2muuPQfr@!!/`!3-kQ)!JgrX#QOm\XCWC7e,b@8!!/_rTFg_qj8]/\!!/_u3,(n`#XeYX0M"/':jN*A#D<<U!!!%mQO+.t%b+kh!!!%m[r?Wn`,f;f#*])h:`dph!MBOJ!It.MNre!UTF^Z'8,rVj!'iMX3+,!"QiIso"P@Q"%`f!u!rlA$!Km_u#N,We!MBVg!MBDm!!$+l!Jgc,TEqVAZ2ak*&XNe)TFCa+j8]/\"IBE'TF/nfJ,fQM#K1W`!h08K!!!%m!MBb#!V-3j#H(C2!MBdY;E+XV"5H.,!!!%m!!%*@!MBJ1!Jg^U!!!%TfK'?&L]N;<4c^9X%_r-r%.F:^%`e^%$]kCP@fQt:L]N;3!!.iU/cgbf!JhJg!MBYPH2mpFliado!!/_rKHj"fTR6_B?iU0-!!e`5!MBMZ83d.T!lP'E!!!%m!!"2SVZDeXNW9&'#SHM+!MBM,Ec;!Y/"Zj\!MBb#H2mpF=9GHt?iWG_!!"uLnlPmA!!/_o!-A2@89t79H2o_0!&2Gi3R:fR!MBMD84W^\H2mpF8-])jj?P\=!!/_o3,(n`5UZUt+@nJ"k;X"Q!r>Fi!!!%m!!/`Tr,PU6@kb@u!!!%m!MB^O4jO*.E!hgl!!/`K3,(n`TF(N]&-)\2lps&p!!/`!TELbbqu?]tVdO-ETE:nsDu]k=cNN<LTE3J(8,rVj!!8<.!MBJ3!KmE_!!!%m"6VWT+A;bP.!bjn#fHq6!!!%m!!.j?TEDQ'!!!!"-ia6h-ib)T(]XOf!!"E<..8R1!!/`:#m:)*FAO$f!!!%m!MBJkF%?92U&Y4`0s:lcTEV-!!!!!"-*L^&he7<9KQC6"E_l`A7$dt.!!/a-!-A2@&4f%dk;X"QH2pJ<OopJ9!!/_n:jN*A7lU\HTPQSY5QCcb#WP(Ak\(!b-3Jc$QisWYa8qG7]*.="!!/_olm!nY!eUIR!!!%mQUlE&D$9&*"NUY[:f@IH#CnSM%&a2iH2nGR8-5Dc!!V\0NsPp*!hrL5!!!%m!!%*@82iL>5WEIKBL!sG?oTP7!MBVU!oEtXJ-44^TEM=sLB%;T!lR2bTE2Dr!!!!"!Ji^FQN<*H!Jh"+5QCh?!MBV_,A7&WM?!a;!!/_r(e>bLTEXld\,ZL0+38dM&*O5mfEpb<6?5=)TG/0N_>jQ:36)=.TE1R-!!!!""Krqo!MBRZEc;!Y"kNsq!MBIP#*Jrd,MumA!MBSl!fI$Y:dU3L!MBM4-ia5I%^9>+J.D'c;[S<ea;=SIhuSuNo*Xsl!!/_p=A/\pD%*oS#,h[O?rI*1#f$S0#FGOTH2n/*Z8(NU!!/_p#Y8%tTEUP[T)\il#/WJQTE`SY!!!!"+0RYM!MBVe&H;_1Zqt9q!!/_q:jN*A82pkK!KmF:!!!%m+@%=T!MBXKH2mpFncZ-]!!/_r4A,&BqeuUp!!/_s!K]PH#5TGb!!!%mPWT,A#P([m!!!%mgH6)2dK+k#!!/_q+@nHlTE:V`!!!!"!+8&?#QIVH82iL>!MB\0-ia5IH2q><UB\J0!!/_s!J`W7#(e6'!!!%m!!.j_R/r+GL^8M3-4@TjL^_?iVu`%cO933!!'!LM?q:<cTEL\`L]@DU!!.iU.055Y)V5"GLbN<=TEUbbJcGcO29uR5!MFda%57b^"nEci!!!%mmg0#H!g@"8!!!%mQS<^c3-kQbF!q'mQN.6E#MV@/TE4%K0E;(Rnc0Lt!!/_r!J_Kl#E'E!!!!%m!qRX=TEr^@NrT.\"6)EETEp-GL]@DU0@)6O@fQOcL]N;s!!.iU/cgc!!JhDmLe)"U!KI-\-r<:?!V[uk#iJbi&BG"<W!/hhOrj*7O:QjBPS`g.J/,9h3tV0,%CdLAa@m-.gBN0C!!/_sj)RrrU'7.k!!/_n3-kQ)#iYuj!!!%mJilEhRK7p?!!/`!!-A2@k;X"QH2q=T;?Mtn!!!%mz":G51*!G-&!!!%m"of2@!+Q!7#XeXu!MBPqLBmk[Y5eP'#RFW?';$l_rt5SC@fQc<TEGN##QOi*!!!%T#[7kT3Wm/'#RCXUcn^XrPQU[i\-TSFOpS&oJ.CcD!MBc0)X%/$TFoOb!!!!.":5&."RuPT+`.CR%qS10S-7^G!!/_n#m-%clrXVh!!/_o!J`W7.6'9e!%lMVQoI'8\0u2!;ZtGUa=30(a8qG/!"Z:C0"1kA:D87D#l#&-Y^.:F^]gA8huSQPfGUmoOD%Z,Fq!RM&==6[^gS=@j:9NH!!/_pTEC\a2uipZ!Mh,W!!/`3!$VsS(jZ/^2ul#.!$DC,4mseFs"Ja!3-kQ,!TXrM!!!%m#3RL-!TX?I!!!%m#S9L6!+9UC"6VWD=F'sDTF:k)^]4?8#dA"G"-ajW=<iS-!!/`[!MCA3",m3[!!!%mcN0%+.4?Sqcod(3!JkRt"kX0t/!h)O!KmVZ%d3rO!!.j73%6g0@fSO(!OOg/!!!%mk\Ui\QjBVlf2tr]OpTJ:a8pel!Jb%n88&h?IfKIF!L$mk!!!%mf0FW^P]JM`=AStu+9g@&Hr(AE!!!%m&7Alg!MBJJ-ia5IJku_Lcj%8d4Udte#N,g-!LEtg^ebL0i#le9!K.d#%&aN;!MBI`TKE2S2uipZ0E;-/ml2aU0Ok)B!MC>jTKE2S0E;(R!!1du!MBM"6i[2e#n-e>P=Q"8!!/_n+;t4[TE4mF!!!!"#1lt'+9@d)k;WGQ!RkEY!!!%m,hE>0!MFL9F8u:@#Oh]ncjRX+;ZZ@sQlV5AfE%->3"E.q+92Ft!MBIVz!<<*"hS97%TE3gN#QOi*!!!%T#[7SD3XXdN#RCgjTKKClPR!9\BF<Am!Km]W"5!dU"of2@!+Q!7!MF67@fQK/LBn.cT)\il#RFWeQoYGE'F4sG$G[n$!L+#&#_3!/!Kmu/#[e%E#R15@!!/_q!+Q!/!J^pd3NiD_49u3s!!!%m!!.i\>847@/dM^g#RE'_#R15@!!/`j!MBc"*7+Zc'?C3=/dMa8#RE8J#R15@#QS?7!!/_q#XeXmzq$R0&!g!NdASkEj]`Oiq'*?,SKEU2O!!/_u=F'rIO>m<Ne0#k7!!/_r4>)Zp$<RGt!!!%m-idR%!MBXMF$K^*!!!3#X8i6B!!/_t3-kQ)"8i;*!!!%mpK2_AD$9&(#D`S73)^.)#M90_"P<a<"QTT^!!!%mhuT6j^^B!&J060AOpJ9&"k[2`3(O(#8-+MH!K[:X!!#P\+F!p;!!/_q!-A2@!J_ctH2pJ9KET%l!!/_q!Jb=gBP84_U^!&K!!/_r#8$Y1#fm^q!!/`dk;W_IH2oo,!!0i"2!7DUVbh[>!MDb(82pSL"7uR)!!!%m!"_[D!MBP%F8u:@R4&%8"/m%;Ql%/POo_3V^]WKq5^ED;!q[VU!!!%mKHM05TE:Vg!!!!"#HqfeVf6q^G^9?7"oJJ;!!!%mLC"'qTO_F`?iU0-N%]r:!MCY=872DtR:lRKL]`G6-46CPVut*`TE12XE!jYp!!"uL?iU4a!+8>G!!/`J#m.a>`,I6Q!!/_p(e>bL!MC\<-ia5I872uWEF8bp!g3N`!!!%m!Lk<)TE<=;2uipZ:]LNO!MBJC"bZjU=9@@d!MBJ"@fQK/!e_[e!!!%mJ7er3-o:;m8cTu)!!!%mhuT5ga9n"1kQiLBOp/?%O90q5+@mmeTE3gJ?iU0-nc@>m!METsE``;A+uZ?6!!!%mS1#9UTEEsMBE/#58cX2_!!!%m3$9:c!MBJB.rYIgUKeMr!!/_o/0dC[TE=*Q=9&=%dJtdB!!/_n!JaJOTHcu-=9&=%qZPe,TE;t2!!!!""kP/K!MBM#Ec;!Y"ig\F!MBIV6i[2e7fNGo?icI&!MBOXF8u:@84W^\3!]L4!)Nd\!,#D[8%2lP^M%onUN9NA-ia5J!OG$6!!!%m!!/`kTE2D"0E;(R0Ft'6\8;AiW!&1h[m3k%Oq-,.kR!%G!KI-^BHStc(]XSlkW0$;'PM.g!RN9n!L*uM$LeS!!Kmtt"lKi?BGb4Z!!.jgBIRUC@fSZqNW<`@0Is%%k5gSC%>Ztd(t\kE$CDR4O;b&uJd&@ockN,RQiIC#gE+]T!!/_qZZBd[+rC:^80@m4LF<-.!!!!"6K^%K!MBL_H2mpF!!:bC%DP_cY?6)Nic@Wq)?9a?_?,lK!!/_q(e>bL3-kQ)+!:cc)?;`>U&qqL!!/_pz8Hf(o"GHuL"7QGl"Q,=G!MBPE"fMD$YTC:a!J_4-C]G"H@fQK?LCb".`t/4O&.i%l!MBMd!m(EB+935o+936LU]:C7!!/_pTE2+oLB%;T&.i%oa>sgp'G(fW"dfpp!L*_k$/c2Q!KmqK$a9]*"of2H&7Y\O!J_3t'[I<j&.fCW&.=OO!MBPE/aiZ>&.fCW&1Ekt"of2H!MCVJ-ia5ILDV-F\Hi09!$E$Y!!.oV&7Rs;TE4BZ&-)\2#QOm\YQ9=eTF.%m%*1R4"crn<"LnK!$,?So#k/[H!K.!2!mh.e!!.id>:,[J/eAR*&.g.S&-`(H&.i=O!MBPmLCaFc^CUAG&.i%_TK32M'G(fc!gjJ\J,tloL^huD^]BT"&.\IA&-`(H!MBOr/eA!_&.fPj&-`(H&.i=O!!/a&(dn?(!$V[K!J_3d*XD`G@KFCY!!!%m!MBJCLCaFcpCI<*&.i%kfK'N3'G(fb$%N<%!L*\B%Ccc?!KmeO#j;cF"of2H&7Y\O!J_3t/CtF5&.fCW&5&iQ"of2H&7Y\O!MC&:LCaFc&-)\2"Kr@cM\$p8TE4$Q&-)\2&-`(H&.i=O!!.idTE2n@!!!!"#T++$(^.#p&-.1[!!/a&!J_Kl8C%hIL_pt5#,"![rtH:efE(a_O9(RThuWTWL]NYJ(_2',(^9pP(_C0W!!.il>8$*1!oOn4(^PpY33O#5$]#85%%%'[%_r;4"OI14&f;)9!#Pn>M\m"8!!/_p&7Y\?&4?L0!J_3d+ib,o&.fCW&.@)B"of2H&7Y\O!J_3tTP>#<!!!!"z+U8G].jlP`"Q%*'!MBLITEG5p!!!!"!!!9m$c`:.D%<c]%/:=:(fLU2&',WD%DW"-.1cTc-pZ)i(]XSl!MBJ;-2.B>$7Hg(!!!%mcPUs.+F4#XLF=IH1C*s]!!!%mcN0%+LF<E9J1ps("n4P`T+i\%n-[emhuT&QkQ6hUJ,tf6!"H^H+=JpR-LW'+!Kml4'Bg=LJ-ZRnYR7lS([tH3*0:PikT7eu!MC&4+p\/K@fQK/H2n3N@R]Gk!!!%m!!/`C@fuK+*0:?fV^NuB(h3Ot!KI..!$F#b+/]."TE0Wm!!!!"z73Md=q/'\ChWbRPTEC,U!!!!"OB;cu%d5q\^D%e5J.1p-p]6TcO:'>BDul+&H2n#n3&'5\3&/`3!MBMlE_l`9$.f<=!!l+\O&1-&TEFfhhuE`X$CGN9?5O.8!JD9i!!!%mlo[GO!o-TR!!!%mUc<$i!MD4NH2mpF!&2_Y5Qg1/LIc^k:jN*e"-`hq!!!%mN'%=-TLr#_(]XO:0E;-/TPY5'L^2!0s%lW$Oohii"IL;4!MBML86>ilC]FGPR90GkkR$/J-39bJkQl\UhuSuA?jXUXBE1:g!!"E<=9&AY!*Dc/!!.jWTE12]!!!!""fG1Cn,\q*Qj/WRO:W`HOp6FAi!PhPTE3gY:]LIrJk'Wt!!/_n!$VsS(eao0+F4"f2ulD9!%7s40E3_P!MBIfNW9%Z(eVOD!!.jW==I>p@fSc\TH%&VRfEEh!!/_nb&U;Yg'6^@!!/_n0R<^!NW:F+-m$,(^^:g<p]?6S#Ok4b*9[Xc?k17_!Kn)2%Y,Dc!MBLGNW9%Z&0.#;!!.jW[k:bgTF+dn7fWMi:]]T=!MBLWz!WW3#lj=RLTNhWVY5eP'0K;o43&(TgTE=16f)PdO0K;o5!'"cp!!/`3.!bjn$'5:nhufop;[LeOp]]7dJ,tf:KEL]O!!/_n!MC,,C]FG8+7K7in-e/E#UfZ\!%eHV&1@MY!MBi$!Q4s<!!!%m!!"S^Y8DQc+=I3mTE4Zj!!!!"3!_2d!!!R$1[dST!MBM,.4>/r3#0b!$a9Yc$1JG'O9VUCE!2g>pc&QK$1Ip$!@S,5%c@TE!KmW-3'[bZCbRhH!!!%m+9@Q0-n#'<&4eJ\3-kQ)H2o#4-nND(UEBP5!!/_nf*OJ<TJ@VnPQ1[a"kO%]TE1K0C&e57e,VI;!!/_n0fmndO?apR5X6.e!&ur9-ic5CYQ,5*"5%Gs!h]RM"KsLX!KmfR!#Q3]!fo<e+954\+Ai4/TE34Y2uipZ"kOk-K/abL!MBc#!TF(Z-l0Q(!!/`C!JpdVKeP1\huU%_3=OOG%#>%iaD_BG#IlGua9eL>!<I]R&'tjV!KmYc!ltT@0JG0\!MBJb"kN_Sf.]0]3&iVr!!/a-zW=f12"9X_d"/Q(tq#g7t3<PKH"5F!lD'8tB&nP'3<!;*q!!!%m#^@`t0<[>H!Jgc,#N,WN#,hmu!U(pY!KmZ&r(%-e!!/_uTEDP$!!!!"-t"GOli7$*!!/_tTF%\"!!!!"!'kcWNracW8-+M`K)bm*!-eJE!'kcWf)^DJTEV+p!!!!"=9&>C8,r[GXB6A@TELJ^QN.!d#a@Fc!MBd=/iWh2!&uq+3!"P>!!.j7#KQq%3!JM,/(YIp!oOEI$GZ\,OpTcSi!I1"LgpDgNW;$>E(S(N!MBVW'Y",C?jM8l!MBIWK)blO-n#&r+92Ft8#J<X!J`WgR6W/#^^,Gk#UU)g$d\sZ^aK5H!MD7Q"N19?!!!%m!!.j?KE@rg,="3h!!!%me3!lsTOMjE!!!!"!&-ql-n#+H!!.j'TE1QBA,lT1!!!%mLF@HK!J`Wh.6(u@!)/G53&kS]J,fV*TE319[f?C/!P1B.TEBjd!!!!"&3sVOE+h0i:]LNO!MBJ3-ia5I3"Q?D3%tES(]XSl!!l+\!!/cQTE;+n0E;(R&-)u,3$eM`-o_bT!!/_q=F'rIH2n#M!&EG>#)?l<"N5@`\oM`i3Y[n]!!!%m!!.j73%6h3@fSUb.3LTpM_WO#!!/_o=F'rI"IoP.!!!%m!MBMT89b+7&.egI)uspXH2q=Qlj)]U!!/_p?ml!TBIEjG!L[n/W!;I1L^5=9OpSW-TEUthTE;b1L]@DU!'j'U!!.]PGUNQ:2`M?S!Jgc,&&846#iH$9#.R2NJ,tfe!".p"GQ7bs!MBMD-ia5I!J!F[L]C7B!!l*r!!/`d@KDu!TL&VqbQ%VD!!/_oGUNOlR/qh'Qj*6c-3UOZ%.Gr1#(Q`;!Jh)e]DrL6!!/_n!J:@P!Sho"!!!%mcS0YF:Cl)=)Lqq"kQ2XsQlj*[p]7&mj92Ck!!/_n#Y6WL!MLnA)?9a;\cJ9K!!/_p.!bjn#(TA0ck#&O;[]f4cn+oFkQ-hJ3"*e<BE/'g!MBMbTkFE+&-)\2Duk_R!!.]P!MEA!)?9a;lN3dl!!/_n!J:@P!hso>!!!%m!!.]P!MC-OEc;!YMCljg!!/_p)^AGbTE1J]Du]k=k60O[!MEp*"7lKm=<-3)!MBRI6i[2e+rC:cH2mpF-mPo<!!!%T!MBLPz#64`((Cpf[$k4-h]EI*C!!/_o!Ja2G$2=c+8.V(K*7klq$/c<O&%DY)#*9,;#hT0@@fQeUNW;TU&2`hV!!/`,8:CO=!i,t.!!!%mrrJ,[NW9n1+>U\4!!.jG3XNSM84Wc;YQV]TPR$saTEb/lOpm-KW!W5"-t<5Z!Ja3:.7c,m!'B@7"@t4V!!!%mLF@HKD$648"K2UY0N/L\"5k-E$%N&>H2n6/5R<uA5W$5.\5F@"*Ir)3^_W;W8I*<Q!pC-X!M'jb)"7^u!KmoU(;L9Ua=A!uJ.&:k"b6[l6i\+?IK0?RTR8+XJ,fQM*UmDG+s6rsH2mpF!''^$%c8sdh`,o^5^EE&8A@4c'L3":!!!%m!(^QU!!/a&8:CO=IK0Vf8-\NZ!)Q2k8i'!V!!!%mmneH58.A)oQP2ndC]I!^!!!!iz"Q8_P!MC(<"lB:[&42-TQNSAM#JUg0&3$Ki5ke=sTG3Uj!!!!""6U5=!T+"r"9Qm\`t0?=5kbBaTEg\m^An67,i8_/"9Oo$(_B;p!%+mN[h*^"TEX[;(]XO:!(+.rQOn<W"9t1qY7NCc$f;'g"@eF`(_Ajn!$D5B!MC'a!WW3#2?3^o)4(=7&2gWoBPdj=,GtS;&.b^Of6[_CNspP%$*OI:TEUhs(]XO:2nooIcNF?*#*0<>&2sOkNs#QG"0<%l!!!%m3j2U%&9\lj2hqTm&43i/LBJKm&>Tjn!!!%mcNGZ*<u;K)=;V$^bXg>&!!/_u"9c16Nt<8>,j,:?"?uPkk7Af//AD<2";-t3(_Aa+(]\b]'A"('LCeVGTEgtjVZ6\t(=r[Z"9\Z8(_B?<!"SI!LDX,1TEqVaY5eP'5lUs>T2uj@Fr12p>XIlj!!!%m7,M&_&9\lj"K+P`&0Tj5!!/`"Y?)P@R2>o-^]NEpOUJ)l8`pok#-\@u$@iY;&'t??Fr1GIg]>G,!!/_rY?)P@Fr12cY;+'/3M-F.s&U$KFr13;PVVD5!!/`$!+>j-!LNie<u;JK(]Yf4(Z,dImfWcK"d]c:&1jFV3M0@i&9\lj#F#=o!!!%m&r0O*&9\lj<u;/1li83$!!/`"&9\lj<u;%S(]Z/&!hU$IVZ[1L!hp5K!!!%mf)u8l!k/^M&2hK2T*-"7!O!%T&08domfW[[<u;Jh%BKPR!!!%mLBIdi"4%N2&/O.+LBKoH#P8QL!!!%mf)uYG*S1iI&/+F7Y66`_<u;JPS,af.!!/`![oXCHFr13)QNWol4f8ECTF0`kDZBb<&1rqGn8/Dl4Jt.B&-^]u.*$[J<u;D)Fr14'ar8;3!!/_oVcO]8Fr13P(^TRA!%56W!MBJi"Rc<j&2KRThZO/("fDo&&/O^;VZ[7V!Qkrh!!!%m^CYQ*";o/\57edS&4qW[pB1bW$bR$;!!!%m%,Y,'>m$`"cjRo+p]60S(^KL4"K6!V!KmhX#N,X017)&Z&9\lj<u:t)(]ZA$2s1`qmfYYs"0rJ%!!!%mrrbQY<u;K1=;V$^(c.d$b>/[m!!/_p&9\lj,3K%%&2C'cQNS-!<u;JfPQ1lj!!/_npK&13Fr13,k:`_E*hNQ_hcCX+"N(4%!!!%mhZO@S".'Qh&/_#BNs#Q_"8WQF!!!%m(l)00>n6&uO9*-.L]N;<(`AAD0Fjau!KmS9$.oX4(l&59s%X+:Tb%b:\c;^2!!/_n(g%UTFr3oFY8=)J4-p'^TE0WU(]XO:9A^;(`rlX&"nrR#&.6/T!MBPmFr12ZmfUTA3Sss""9JN6QOkt)5OS_#"9O>iS.I33!!/_o&9\lj<u;($(]ZIT9!8eL)8?:b"=`4>V[su['>FYY"9F8hW=UQ2!#QIQrt'>jY?)PB"+pRW!!!%mLBIX=#QG>G&1<eIpB1`Y<u;K&=;V$^(b*3:#L<s)!MB\Q4O4!-&3.-%aDD?qrsk+k#k2FOHNqP&$_U(P`rlOs!Tt"'&3u!R!MBSe,4>L3&/bEM^B?QP#.G.3&0]X.QNRD_!M9oT&5(7OpB1TM#6,5L&2UcucNH#\"7HdN&4E,n!MBPK%`\PL&4abDi,&e1(^?oH"ir)`!J(Hr#cK)RBLMrP=;V:9(dXc2%CZml!!/`JQNSrA<u;Jb=;V$^(`E>j3S+gcY660O<u;JU(]YJHY@eDi*TmPYLK><(Fr13B-Rn3i&.Hkfrrat;"TK#_&58]!!MBXd<u:o;(]YA=356#JmfWaeTNVmG(]XO:#1!j(aDD.F`sJs[#bYc2HNp,S%`gl4Y64sb"?-l>?P"Bq&2]^V!MBXt=;V#<(dNin$\o::LBK'0#gX&J&0B^3!MBP4Fr12ZkQ/.("o)pE8JhU*!q69L!J(?Gi!mJG#,"Bf=;VD'(cK,G60Af&!MBY>#1ihT&/*RtNs%>$1rg.k&0/Ff!MB\'#Ia[5&0UEE`rljd<u;K%(]Z"O#2]u8^B=e.8,!Qb&3?utcNF9`<u;J\(]Y]I7*cEff*"Cs<u;JpZ2dIO!!/_uT2uj0Fr134(_3_\!&)Aoh[jrJ"<[@h9FseA!!!%m!MBUJ27EPc&5020f)u2b'o*>8&3YdO!MBMZ!nRDP&1=pi[fcc1'=SN@&4uU!!MBRa!VZQo&1Y-l-EgJf(g%UTFr3.3mfrLt5j&7R":+Z4HOqph!!!%mLDX,1&9\mU6dGnM&/Cf?hZNu+0(0?7&.Y$0!MBM3=;V#<(bb%ha&`gq)4q$:TE`RNY5eP'1oCH\":+*$(_B:%!&4.K!MBS=(OuJcO;<pm)\nG;!QYe][h*^"":W=@V[tPs4eDiX":)+AM@`8G!!/_uG?5U](g%UTFr29e(`T@a!"&[,!MBb:z!<<*"ScJtJrr<2Ys8W-!#RCD0!!!!)aU\@OnH7#<"9X_e"-`lc<CHr]AM!r@lNeYN",$g6!!!%m:`q.d!!.j'#Y6XOTE1hg#QOi*!!!!C4SJl:&:+<VTEHI2!!!!"$bl_&D%?=H!lt[u(fLji&#]iE%_r+.LEHi+":tP6!!!%m-idQZ+96lk(a(4,!!/_qa#G1ALG1+Z3%+b-#*8kR$]k_B#d=R]!KmkQ#,h]m!MBJ;9E5%mJ,fR/j<,QG!!/_nQS'B\@fRVeNW:1%8.PY#[fMKhLEKtJ]P%9G!!/_n?l%r+&)[`/!!.it+=SEu@fSBYD."JO$_Rh$&5rn>%_tQc$%N&>(jZ09LEIN0K)blP!!/_n#Y6oT!MM1IK)blOe0"_l!!/_n!MBc"TIKpA0E;(R!!!%n!!.]P+=I44k;XS<LG1+Y@lOGh!!!%m!!ksm*eu?jBO_#b!J_d?.3Jlr!#+N<+<Ur"Du]oofK'J?'HeM+#)G@U!L+#6$]keL!Kmc)"n3#[+E1fj!M9k#%=fGn!Ke/U*r#oScr(akfG!`ZTE1#fL^ViI%`i-"!L!Yj!!!%m!!.it!J`'gBHThGo)b@/!!/_nz*!?6A&f;`*S-7`F!!/_r!"]D9P5kW>G^'2hUaU1r!!/_qlm"1a#.sp<!!!%m!+72T!!"TY!,*b\BE/SL!!/Ph:ha$6!MCnj-ia5I/RSQd-ia5I&-r8LRfI+%=BGP(Hmhg*!!!%m!MBUt"iLB@!!!%mY<[C6oQ)\h-ia5K&-r8DRfHgr!)NXrEX5bq!!!%m(]Y*Q!!kI_-u`mF(iUl'&9oT'!MBM4-ia5I-iaNL/Q`!T-ia5I&-r8DRfHgr!)NXr3XAh9!!!%m!!/a'J1(Bt!It^^!!!!N!!.m(!!/`":jN*A"Gd65p^3[2;ZXB1TJPJ-\,ha&fE?^-$Fjp\#g`sX"Ku33!KmZ^!h]Y*!JGMjGUNOlJ1(C'!It^^U]:BH!!/_qGUNOl!%iF,GT$P^!iuHT!!!%mG[^d1TE2Y)!!!!"!!lCL=9)GOaoDDn!!/_n]-B!0!Mf\r!!!%m!.6"f!!/`T#8Ws4'\F>f!!"Tq!IuQu!"]D9RfEJ>G]3W`WrNE$!!/_o!-A2@!MF3.H2mpF!!KJ2&-*7i!!!!N"KrYg!p"D.E$t\d!%i.$E#J]VTE4Ca!!!!"ZiC)J!!/_n!-A2@D%+Jc\8VK$Y:rlcOp-pMi!\0<3%+b;!%g/1TE2V(WW3#"!!/_nGUNOl!%iF,GXluYTE<Rj!!!!"GS#*JJcGd&!!/_oTE0ZF!!!!"!!!"@!!iiY&.fC$!!!!Nnc0LT!!/_n!LNieH2o>n!!Ut.1Z(0<Y<[C6.W[9HE$t\d!%i-iTE2A!GQ7^E!%;f#Duai*l2Uf9!!/_pLaW6'&-rgJ!!.lUGQ7c6!!/`[M^&K-!O;\+!!!%mz(CpcO#mUh?ed<?*!h9DM!!!%m/a!d,3,ARSf/O<AIMb%)(^$s,!RF;c!!.oV5^jP03$1+]3#Vc^TE:&l(]XO:#5:*+!!/`"3+<3p!MCY;LH#86QnSL@3"S+\3VO4I"jdA0$`F)j%Y+T<"gA#j@fQq9$Fi&Lhug3#;Zu"hfLG$XO9(LG3!A^[2uiu7V`6+b3+DqX!KI.>huGgY%#Aj:$&A`2YQ^tH1'4Bl'AsVX5XYe.*69+Up^ck+NY_BoTF0$HM@mWA^]aE5#XeXr!$W6[+F4"fH2nBR!(+FK7Ahhc!!.j7!J`o?KH(6t)F-7_!!!%m-THPl!!/a-+F4"fLH#^G3$82%!Ok$;3$;]2cts-2L]`/7f-jQ#OpgJGn-dkL!KI-^!!kfm*01,\!MF`e(8q35^`K_'!!!!6h$a8`!Mp5+!KdE1D$0mY+[oCB"Q&MO!MBSVLEHQspeUqk+BUZ/6D"r7$&AqM$((aX&(h!:%#=qI@fQeENW:1u5Y(hThZ8`;NW<023"V\_!MBPE,7jhTC]FLs!!!%m3$;]23%/8:!!/`\k;Y-q!LP8;%tHWB!Km_E"b6pS-id`W3!a!o3"TR"3#H-*!!/`sX<RuN!L*Qd!!!%m!!/`#KE9R&N$'ML!!/_o-l,AS!J2^"!RLtR\318a^^T]<TE1A]TF:Mq#e4XY#J^DF%`e[/4oc).<<,8aH2mpF7f\#E!PAC<!!!%m!%;Oe!!/`r#XeXm!MFc>F8u:@$(q7u^^[5Z#ZD9="P=I0!iQ-_H2nB3!&aK^.]4,0!!.it!J`'_!Rj:6!!!%m!Q&m`!KI-[#Y6bl$E".YY8A]*!MBcOH2mpF!!hBe.*iHNV\j^[!ME'd!NQ2#!!!%m!!/Ge&:+<^,T$ZfH2mpF&-T0Za8fCb^]Bi.!#G>H'$h,8n-]WVJ/>Ek"-@73%)<25^^/Rh<str."5"[)LjU5!p^Q-g&:eX0!h0S=!!!%m!MBIg0UDb>+9@(*!MBLpz#QOi)%4;ZX#;\"`"Q%H1!MBMT6i[2eNW9%b0M7B,T)jrP%G3X&+:5hE'Xnc!"h4Z=$]kCR%d4&j"-<PH#(R#1i!e6G8.2p>'9E?iph:;4TH<S?"7T(m''Kn2!jD]q*0:qli"N&=4UpTU"OJ6p!!/`"2`M'C!+Q!7#^QIVH2o8K"=rXH!!!%mQPb#K+F4"sLF=7RY7L[7-q%W)!!/`$M\Vlb\-nZ)!MBc3LF<-&-m/Kj991JM-m3""Nrb7@TFrXs-ia5J&-)`dYW;r<'IY@1#d>-.!L*rT"0`<O!KmfJ"5j]O-kKkgf+9ABD%5DX#l"mc(fLn=%EKKL!N6$^LF<Lk$lAsF!!!%m!MBIF/gp]"!%8l^!%8[o2tmT(!MBJ"z#64`(%grUO$5X!^U]fQ'!!/_p!$W6[+F4"fH2o"I!$9`?';mO1!MBI`/gp]"!%8>l5MlL%!J`WO%A4gD3!Q<B%#5NV#I"Tg!iQ-a$h+2,$.&^9@fR"#LH%793%+b-(S<Z93%/8:a>sXk'JM3A%*1Gi!L*np!mgt0!Kmf2%&a9D!!.j7h_$ko@fSJ#TN!lV2uipZ!!!%T!!.j?5\N+_TE2\\&-)\2!iJ#,LHp;"3"7hO5^j80TR6jF^]4?8(r/ETLH#<j2uipZ+HJK22umFgQu)rh!gkqR-KcLM!KmKQ%+kXF!!.j73%6g@@fR;=(SE`A$0VD_']9a_\0&e;-m,)p'X/1*k^!8s!"n,u2uj4P3']G43"Y6d!'"cp!MBJ2TF(Z!!!!!"0`V1ROmApYm@f&cmHs88Lk:0CL#KSFNeFatKS>5:Xb>YeiN&g6LVAZ)\q[DBiSh+tLZ*uBiInJpiIp1KVW"8'!!!"J)#sX:z(B=F8#64`($NL/,*WQ0?r;ZftQ2gma$ig8"WW3"t)?9aJ%0-@d$NL/,)uos=qu?]s%KHJ.!WW3#QiI*d9E5%'WrN,N]Dqp?7fWMOg0Fd'%R3??5sG(:Ps7MJl9BL('L%U_X$4nO]K]?#S!RB$fIfrF:8[N[2Dt5p05om8T,$60J#p3+d=jS6\pR3!UuL=bBXfRq7Up/pl7K(MHH_U%TYG^W!R-?JJA3oHIp8`tXhS'Gn+j:4^$;,+V*,0e3CN/DV&1Y^=D$R)RY5A,q6^o[;&QsaC0nt($_laO--_Tadl]ORm0QF):&dq)S]YXWBel9*=uIKIm#T#-8Z_FqZ:Q'WcRSDnD4`FRA%>Sg1)VND3?@CSV.hBa0a`==+q)u80afkI-1C!*W[;lDYB9#]#&ELo042;^Q7/YN2IF'8W\es)R9PZ_D(W;ep3=<_Kd\jJ4BK.AX6b'm2oWKmIO"C+2I7<4X,M1j21rKPW[rBV2t,V8Z7WVV2pf.J)D0O410t-qX6b'^2ugY)W1\B>2IF'8g2qQAVHtJ-3\BTb(g\]'X1W[N7Obr"V'ngO2=%k1W[rBVjoh_`&iBE:2IH!cW\es).9lb_X,D3Ip0JcSTIuq,2kR]$X1!I=3et1+X,MC4Q;tN.W[rFaWIMN1Wc_a=2t"8XJ0]-(37kod>#fcnSl0mDU"":L2lF>&E[&?[]Mq5()C^N3!E(\\WP!9sQ@?8PW[>9>2GmBPWa&8f2FkA83c')2_HmtgW\)nmH!@D_Y:Oo3V-Y@pW\)nmQ<kH@i[fAD2IF%jW[p`F[L`62c$U\!q$4_4Kd!^ira&UZUTA:"^L+ZAqL!RWAe2kGX1Lsj2rME7Jgkuo2uiC%X0d/AXshHQ3\BTbVHta`3dXqs5[GqOXqM<22qPZ(W\)o%Q<jR'W[rFa1tT=mX33,Zkm4<$j?.^VQ<UB=3@oHE2I7<4X,ICT2HRK%W\8Xe2G^orW[rFb2LN*JW]GEp2I<u,WiUK82K$+<W\Sjh2I<u,W[rFb2BKHAWZ?AS2I<u,W_%K*2IO,.W[rFb2Vu$WWaL+A2I<u,!%iJc]=]);break;end;end;else if not(x<0x63)then _[0X1E]=W.R;if not(not r[30338])then x=r[0X76_82];else x=W:Bi(x,r);end;else A=W.a;if not(not r[24184])then x=W:li(x,r);else x=(-3221225350+(W.zv((W.Rv((W.Rv(r[0X1dc],r[4457])),W.l[8],r[0X40d6]))<=W.l[0B11]and W.l[0X9]or r[0X006567],(r[0X01169]))));r[24184]=(x);end;continue;end;end;else if x>13 then if x~=0X03C then _[34]=W.N;if not r[0X00266A]then x=0X04E9CBB64+(((W.av(r[0X71_eF]==r[18911]and W.l[0B110]or r[28333],(r[0X239A])))<W.l[0X4]and r[0X3306]or x)-W.l[0X5]);r[9834]=(x);else x=W:ki(r,x);end;else x,Z=W:fi(Z,r,x,_);continue;end;else if x~=0b0_01101 then(_)[0B100001]=(X.readstring);if not(not r[0x23D])then x=(r[573]);else x=(-7171371362+((W.av(W.l[0x7]+r[0x7682],(r[0X1D04])))+W.l[0b1001]+r[28333]));r[573]=(x);end;else _[32]=W.s;if not r[0X0040D6]then x=(-1842874283+((((W.Rv(r[3506],W.l[0X7]))>W.l[0B1000]and r[18911]or r[24478])==r[29167]and W.l[7]or W.l[2])-r[7428]));(r)[0x40D6]=(x);else x=W:Oi(r,x);end;continue;end;end;end;until false;(_)[0X24]=(nil);(_)[0b00100_101]=nil;x=(0X6__);while true do J,x=W:Vi(x,r,_);if J==34724 then continue;else if J==53529 then break;end;end;end;_[38]=W.u;(_)[0X2_7]=W.z;(_)[0x28]=4503599627370496;(_)[41]=nil;_[0X2a]=(nil);_[0B101011_]=(nil);_[0x2C]=nil;return x,A,Z;end,zi=function(W,R)local r,Z,x,A;for _=10,262,53 do if not(_<=63)then if not(_>116)then else return-0B10,(W:ui(x,R,A));end;else A,r,x,Z=W:hi(_,A,R,x);if r==-2 then return-2,Z;end;end;end;return nil;end,Ai=function(W,W,R,r)if R>0X5f then if R==0X7a then(r)[0B10_1]=(r[0X5]+0X2);return 0XfC14,W;else return-2,W,W;end;else W=r[0xD](r[0B100011],r[0x5]);return 0xfC14,W;end;return nil,W;end,OZ=function(W,W,R,r)r=W[0X9](R);return r;end,k=function(W)local R=W[0];return function()local W=R[3][R[2]];local r=18765;r=r*W;W=5990665;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=158005;W=R[3][R[2]];r=r*W;W=16012894;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=986421;W=R[3][R[2]];r=r*W;W=4447973;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=101657;W=R[3][R[2]];r=r*W;W=6958681;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=690977;W=R[3][R[2]];r=r*W;W=8111548;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=421253;W=R[3][R[2]];r=r*W;W=12241749;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=2873;W=R[3][R[2]];r=r*W;W=8656460;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=400463;W=R[3][R[2]];r=r*W;W=1377287;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=574361;W=R[3][R[2]];r=r*W;W=7471843;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=208317;W=R[3][R[2]];r=r*W;W=10213246;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=998777;W=R[3][R[2]];r=r*W;W=855697;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=405649;W=R[3][R[2]];r=r*W;W=16226926;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=108507;W=R[3][R[2]];r=r*W;W=16666028;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=807251;W=R[3][R[2]];r=r*W;W=8337694;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=625249;W=R[3][R[2]];r=r*W;W=7368013;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=112961;W=R[3][R[2]];r=r*W;W=8712450;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=401481;W=R[3][R[2]];r=r*W;W=8122829;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=203641;W=R[3][R[2]];r=r*W;W=14060647;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=417681;W=R[3][R[2]];r=r*W;W=1203310;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=516303;W=R[3][R[2]];r=r*W;W=14849991;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=1018453;W=R[3][R[2]];r=r*W;W=2238126;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=1000165;W=R[3][R[2]];r=r*W;W=3935122;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=868861;W=R[3][R[2]];r=r*W;W=9752063;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=902927;W=R[3][R[2]];r=r*W;W=10473106;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=454151;W=R[3][R[2]];r=r*W;W=12522706;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=451291;W=R[3][R[2]];r=r*W;W=791611;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=163271;W=R[3][R[2]];r=r*W;W=1390138;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=104743;W=R[3][R[2]];r=r*W;W=4407166;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=184631;W=R[3][R[2]];r=r*W;W=9150348;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=686597;W=R[3][R[2]];r=r*W;W=4353533;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=204223;W=R[3][R[2]];r=r*W;W=13035472;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=261355;W=R[3][R[2]];r=r*W;W=1077421;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=782481;W=R[3][R[2]];r=r*W;W=3194591;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=439429;W=R[3][R[2]];r=r*W;W=5475918;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=827373;W=R[3][R[2]];r=r*W;W=1867383;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=485277;W=R[3][R[2]];r=r*W;W=5982529;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=828733;W=R[3][R[2]];r=r*W;W=8222134;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;r=814919;W=R[3][R[2]];r=r*W;W=349597;r=r+W;W=16777216;r=r%W;R[3][R[2]]=r;end;end,L='\99opy',CZ=function(W)end,dv=function(W,R,r,Z,x,A,_)(Z[0X1_])[0X6]=Z[52];if Z[0x34]==Z[11]then if not(0XAC)then else return-0X002,R,Z[0x2];end;end;R=(117);while true do if R==2 then(Z[0x1])[5]=(r);break;elseif R==0B1010_000 then R=W:Mv(Z,x,R);elseif R==111 then Z[1][0X1]=Z[0X35];if not(not x[30838])then R=(x[30838]);else R=-111+((W.Pv((W.Nv(x[0X970]-x[29167]))))+x[0X10C8]);(x)[30838]=R;end;else if R==0b11__101__01 then R=W:Vv(Z,A,x,_,R);end;end;end;R=(0X69);return nil,R;end,P=select,hv=bit32.bnot,W='\x72\101adi1\u{0036}',Nv=bit32.countrz,Lv=string.gsub,yi=function(W,W)local R=W[0B110010]();local r=W[0b11](R);(W[0X18_])(r,0X0,W[0x23],W[5],R);W[5]=(W[5]+R);return r;end,ki=function(W,W,R)R=(W[0x266A]);return R;end,_=function(W,W,R,r)W={};(r)[0x1]={};(r)[0B10]=(9007199254740992);R=nil;return W,R;end,Zi=function(W,W,R,r)r[R]=W;end,DZ=function(W,R,r,Z)local x,A;R[0B10101]=({});r=nil;Z=nil;for _=109,325,0b11111__0 do x,Z,r,A=W:iZ(R,Z,_,r);if x==31369 then break;elseif x==0X7352__ then continue;elseif x==-0b1 then return r,-0X1,Z;else if x==-0B10 then return r,-0X2,Z,A;end;end;end;return r,nil,Z;end,bZ=function(W,W,R,r)(R)[0X3]=(W);r=0B101111;return r;end,Ci=function(W,R,r,Z)Z[55]=(function(...)local x=Z[31]("#",...);if x==0 then return x,Z[16];end;return x,{...};end);if not R[14094]then r=-4294966951+(W.sv(R[0X6eAd]-R[24184]-R[8788]-R[29167]));(R)[0X370E]=r;else r=(R[0X370E]);end;return r;end,rZ=function(W,W,R)R=W[0X32]()-0x12aB_;return R;end,ai=function(W,W,R)R=(W[21330]);return R;end,Ii=function(W,R,r,Z,x,A)local _;if A>0b1000 then A=0X8;Z=r[0X32]();else if not(r[0X1__5__][Z])then local X,J;for t=0B111_11,258,0x43 do J,_,X=W:ri(Z,r,R,t,J,x,X);if _~=19325 then else break;end;end;else W:Gi(r,R,Z,x);end;return Z,42720,A;end;return Z,nil,A;end,bv=function(W,R,r,Z,x,A)(r)[0x3A]=nil;local _;R=nil;Z=(nil);A=0X29;repeat if A==67 then R=(function(...)return(...)();end);if not(not x[0X05_519])then A=W:Fi(A,x);else A=(-0B1010_0+((W.Pv(x[7482]==x[0X2422]and W.l[0X6]or W.l[0X4],x[21269],x[0X71ef]))-x[9250]>W.l[0x1]and x[14797]or x[30338]));(x)[0X05519]=(A);end;else if A==0X29 then A=W:YZ(A,r,x);continue;elseif A==0X46 then Z=_();break;else if A~=0X74 then else _=(function()local X,J,t,z;t,X,z,J=W:DZ(r,t,z);if X==-0X1 then return;else if X==-0B10 then return J;end;end;return(W:EZ(z,t,r));end);if not x[2416]then A=W:fv(x,A);else A=(x[2416]);end;continue;end;end;end;until false;if r[0X2e_]~=r[0X1B_]then W:Bv(r,_);end;return Z,A,R;end,Z=function(W,W,R)W=R[25808];return W;end,av=bit32.lrotate,FZ=function(W,W)W=true;return W;end,Fi=function(W,W,R)W=R[0X5519];return W;end,Gi=function(W,W,R,r,Z)(R)[Z]=(W[0B10101][r]);end,ci=function(W,R,r,Z,x,A,_)local X;R=nil;r=(nil);for J=0X4_a,0X0F0,0x1F do r,X,R=W:qi(Z,R,J,r);if X==23239 then continue;else if X~=21256 then else break;end;end;end;x=(nil);A=nil;_=(nil);return _,r,x,R,A;end,wZ=function(W,R,r,Z)local x,A;for _=0B1101_110,292,0b1011011 do if not(_>0X6E)then else if _==0X12_4_ then A=(x/0X2);else x=r[46]();continue;end;end;end;for _=0X69,0X117,0B1010111 do if _>0X69 then if _==0X117 then Z+=0B1;else continue;end;else if x%0X2==0x0 then W:XZ(R,A,Z);else Z=W:SZ(R,r,A,Z);end;continue;end;end;return Z;end,oZ=function(W,R,r,Z,x,A,_,X,J,t,z,Q,o,i,O,N,B,g,j,y)local e;O[B]=(t);Q=(nil);local s=(83);repeat if s<0X7D and s>0b111000 then s=0X16;Q=(J-j)/0X8;else if s>83 then _[B]=g;s=0b111000;else if s<0x53 and s>0X16 then if y==0X1 then W:RZ(o,A,B,t);elseif y==0x7 then if not(A[57])then W:sZ(t,B,o,A);else local J=A[10][t];local o=#J;if r~=0b1101001 then else W:PZ(B,J,o,X);end;end;else if y==0X2 then(O)[B]=(t);else if y==0X3 then(O)[B]=(B-t);else if y==0b10__0 then(O)[B]=B+t;end;end;end;end;break;else if not(s<0X38)then else if r==0X6B then return-1,Q;end;if r==0B1101001 then for J=82,0x87,0X35 do if J>0B1010010 then(z)[B]=(Q);else if not(J<0B10000111)then else Z[B]=(N);end;end;end;end;s=0X7D;continue;end;end;end;end;until false;if R==0B11 then _[B]=B-g;elseif R==0X2 then W:aZ(B,_,g);elseif R==0b100 then(_)[B]=(B+g);elseif R==0B1 then W:uZ(B,A,g,i,r);elseif x~=0Xa0 then while x and 92 do return-0X2,Q,A[29];end;elseif R~=0X7 then else if not(A[0x39])then W:eZ(A,B,g,i);else O=A[0xa][g];t=#O;if x==0Xa0 then else j=0X7B;while true do if j==0b1111011 then if not(-(24+135))then else return-2,Q,x;end;j=(0X1e);continue;elseif j==0X1e then return-0X2,Q,x;end;end;end;for R=7,0x58,36 do e=W:zZ(X,O,B,t,R);if e==15535 then continue;elseif e==0xeA90 then break;end;end;end;end;return nil,Q;end,r=function(W,R,r,Z,x)(x)[0x17]=R.writeu32;(x)[0x18]=nil;x[0B11001]=nil;r=0X72;while true do if not(r>0X29)then(x)[0b11001]=(error);break;else x[0x18]=R[W.L];if not Z[25808]then r=3348903379+((W.Pv(Z[0X736e]~=Z[0x3306]and W.l[0B0011]or Z[29819]))-Z[9114]-W.l[4]);Z[25808]=r;else r=W:Z(r,Z);end;end;end;x[26]=function(W,R,Z,A)if Z>R then return;end;A=R-Z+0x1;if A>=0B1000 then return W[Z],W[Z+0x1],W[Z+0x2],W[Z+0X3],W[Z+4],W[Z+0X5],W[Z+0X6],W[Z+0X7],x[0X1A](W,R,Z+8);elseif A>=7 then return W[Z],W[Z+1],W[Z+0B10],W[Z+3],W[Z+0X4],W[Z+0X5],W[Z+0X6],x[0B1__1010](W,R,Z+0x7);else if A>=0B110 then return W[Z],W[Z+0X1],W[Z+0X2],W[Z+3],W[Z+4],W[Z+5],x[26](W,R,Z+0X6);elseif A>=0X5 then return W[Z],W[Z+0X1],W[Z+2],W[Z+0x3],W[Z+0B100],x[0B11010_](W,R,Z+0X5);elseif A>=0X4 then return W[Z],W[Z+0X1],W[Z+0X2],W[Z+0b11],x[0X1a](W,R,Z+0B100);else if A>=0B11 then return W[Z],W[Z+1],W[Z+2],x[26](W,R,Z+0b11);else if not(A>=0X2)then return W[Z],x[0X1a](W,R,Z+0b1);else return W[Z],W[Z+1],x[26](W,R,Z+0X2);end;end;end;end;end;return r;end,E=function(W,W,R,r)r[31]=(nil);(r)[0B100000]=nil;(r)[0X21]=(nil);R=nil;r[0b100010]=(nil);W=(nil);r[0X23]=nil;return R,W;end,Ki=function(W,W)local R=W[17](W[0B100011],W[0X5]);(W)[0B1_01]=W[0X5]+0X2;return R;end,a=string.char,Ji=function(W,R,r)R[3360]=(-0X40+((W.ev((W.zv(W.l[0X7],(R[3959])))-R[24184]))<=R[4224]and R[13195]or R[15166]));r=(-524185+((W.Av((W.hv(R[24478])),(R[0X43f9])))-R[0X43f9]+R[0X1e31]));R[10629]=r;return r;end,F=function(W,R,r,Z,x)(x)[0X1_3]=(R[W.J]);if not(not Z[0X1e31__])then r=(Z[7729]);else r=W:m(Z,r);end;return r;end}):f()(...);
]==]
local __CONFIG = {native=true,time_budget=30,dump_strings=true,executor="roblox",skip_protos={},devirt=true,spin=24,max_stmts=15000,max_block=5000,max_waits=20}
local __P2D = {}
local __CHUNKS = {}
local __UNICODE = (function()
-- generated by gen_unicode.py from Python's unicodedata 14.0.0
return {
	decomp = "c0:41,300;c1:41,301;c2:41,302;c3:41,303;c4:41,308;c5:41,30a;c7:43,327;c8:45,300;c9:45,301;ca:45,302;cb:45,308;cc:49,300;cd:49,301;ce:49,302;cf:49,308;d1:4e,303;d2:4f,300;d3:4f,301;d4:4f,302;d5:4f,303;d6:4f,308;d9:55,300;da:55,301;db:55,302;dc:55,308;dd:59,301;e0:61,300;e1:61,301;e2:61,302;e3:61,303;e4:61,308;e5:61,30a;e7:63,327;e8:65,300;e9:65,301;ea:65,302;eb:65,308;ec:69,300;ed:69,301;ee:69,302;ef:69,308;f1:6e,303;f2:6f,300;f3:6f,301;f4:6f,302;f5:6f,303;f6:6f,308;f9:75,300;fa:75,301;fb:75,302;fc:75,308;fd:79,301;ff:79,308;100:41,304;101:61,304;102:41,306;103:61,306;104:41,328;105:61,328;106:43,301;107:63,301;108:43,302;109:63,302;10a:43,307;10b:63,307;10c:43,30c;10d:63,30c;10e:44,30c;10f:64,30c;112:45,304;113:65,304;114:45,306;115:65,306;116:45,307;117:65,307;118:45,328;119:65,328;11a:45,30c;11b:65,30c;11c:47,302;11d:67,302;11e:47,306;11f:67,306;120:47,307;121:67,307;122:47,327;123:67,327;124:48,302;125:68,302;128:49,303;129:69,303;12a:49,304;12b:69,304;12c:49,306;12d:69,306;12e:49,328;12f:69,328;130:49,307;134:4a,302;135:6a,302;136:4b,327;137:6b,327;139:4c,301;13a:6c,301;13b:4c,327;13c:6c,327;13d:4c,30c;13e:6c,30c;143:4e,301;144:6e,301;145:4e,327;146:6e,327;147:4e,30c;148:6e,30c;14c:4f,304;14d:6f,304;14e:4f,306;14f:6f,306;150:4f,30b;151:6f,30b;154:52,301;155:72,301;156:52,327;157:72,327;158:52,30c;159:72,30c;15a:53,301;15b:73,301;15c:53,302;15d:73,302;15e:53,327;15f:73,327;160:53,30c;161:73,30c;162:54,327;163:74,327;164:54,30c;165:74,30c;168:55,303;169:75,303;16a:55,304;16b:75,304;16c:55,306;16d:75,306;16e:55,30a;16f:75,30a;170:55,30b;171:75,30b;172:55,328;173:75,328;174:57,302;175:77,302;176:59,302;177:79,302;178:59,308;179:5a,301;17a:7a,301;17b:5a,307;17c:7a,307;17d:5a,30c;17e:7a,30c;1a0:4f,31b;1a1:6f,31b;1af:55,31b;1b0:75,31b;1cd:41,30c;1ce:61,30c;1cf:49,30c;1d0:69,30c;1d1:4f,30c;1d2:6f,30c;1d3:55,30c;1d4:75,30c;1d5:55,308,304;1d6:75,308,304;1d7:55,308,301;1d8:75,308,301;1d9:55,308,30c;1da:75,308,30c;1db:55,308,300;1dc:75,308,300;1de:41,308,304;1df:61,308,304;1e0:41,307,304;1e1:61,307,304;1e2:c6,304;1e3:e6,304;1e6:47,30c;1e7:67,30c;1e8:4b,30c;1e9:6b,30c;1ea:4f,328;1eb:6f,328;1ec:4f,328,304;1ed:6f,328,304;1ee:1b7,30c;1ef:292,30c;1f0:6a,30c;1f4:47,301;1f5:67,301;1f8:4e,300;1f9:6e,300;1fa:41,30a,301;1fb:61,30a,301;1fc:c6,301;1fd:e6,301;1fe:d8,301;1ff:f8,301;200:41,30f;201:61,30f;202:41,311;203:61,311;204:45,30f;205:65,30f;206:45,311;207:65,311;208:49,30f;209:69,30f;20a:49,311;20b:69,311;20c:4f,30f;20d:6f,30f;20e:4f,311;20f:6f,311;210:52,30f;211:72,30f;212:52,311;213:72,311;214:55,30f;215:75,30f;216:55,311;217:75,311;218:53,326;219:73,326;21a:54,326;21b:74,326;21e:48,30c;21f:68,30c;226:41,307;227:61,307;228:45,327;229:65,327;22a:4f,308,304;22b:6f,308,304;22c:4f,303,304;22d:6f,303,304;22e:4f,307;22f:6f,307;230:4f,307,304;231:6f,307,304;232:59,304;233:79,304;340:300;341:301;343:313;344:308,301;374:2b9;37e:3b;385:a8,301;386:391,301;387:b7;388:395,301;389:397,301;38a:399,301;38c:39f,301;38e:3a5,301;38f:3a9,301;390:3b9,308,301;3aa:399,308;3ab:3a5,308;3ac:3b1,301;3ad:3b5,301;3ae:3b7,301;3af:3b9,301;3b0:3c5,308,301;3ca:3b9,308;3cb:3c5,308;3cc:3bf,301;3cd:3c5,301;3ce:3c9,301;3d3:3d2,301;3d4:3d2,308;400:415,300;401:415,308;403:413,301;407:406,308;40c:41a,301;40d:418,300;40e:423,306;419:418,306;439:438,306;450:435,300;451:435,308;453:433,301;457:456,308;45c:43a,301;45d:438,300;45e:443,306;476:474,30f;477:475,30f;4c1:416,306;4c2:436,306;4d0:410,306;4d1:430,306;4d2:410,308;4d3:430,308;4d6:415,306;4d7:435,306;4da:4d8,308;4db:4d9,308;4dc:416,308;4dd:436,308;4de:417,308;4df:437,308;4e2:418,304;4e3:438,304;4e4:418,308;4e5:438,308;4e6:41e,308;4e7:43e,308;4ea:4e8,308;4eb:4e9,308;4ec:42d,308;4ed:44d,308;4ee:423,304;4ef:443,304;4f0:423,308;4f1:443,308;4f2:423,30b;4f3:443,30b;4f4:427,308;4f5:447,308;4f8:42b,308;4f9:44b,308;622:627,653;623:627,654;624:648,654;625:627,655;626:64a,654;6c0:6d5,654;6c2:6c1,654;6d3:6d2,654;929:928,93c;931:930,93c;934:933,93c;958:915,93c;959:916,93c;95a:917,93c;95b:91c,93c;95c:921,93c;95d:922,93c;95e:92b,93c;95f:92f,93c;9cb:9c7,9be;9cc:9c7,9d7;9dc:9a1,9bc;9dd:9a2,9bc;9df:9af,9bc;a33:a32,a3c;a36:a38,a3c;a59:a16,a3c;a5a:a17,a3c;a5b:a1c,a3c;a5e:a2b,a3c;b48:b47,b56;b4b:b47,b3e;b4c:b47,b57;b5c:b21,b3c;b5d:b22,b3c;b94:b92,bd7;bca:bc6,bbe;bcb:bc7,bbe;bcc:bc6,bd7;c48:c46,c56;cc0:cbf,cd5;cc7:cc6,cd5;cc8:cc6,cd6;cca:cc6,cc2;ccb:cc6,cc2,cd5;d4a:d46,d3e;d4b:d47,d3e;d4c:d46,d57;dda:dd9,dca;ddc:dd9,dcf;ddd:dd9,dcf,dca;dde:dd9,ddf;f43:f42,fb7;f4d:f4c,fb7;f52:f51,fb7;f57:f56,fb7;f5c:f5b,fb7;f69:f40,fb5;f73:f71,f72;f75:f71,f74;f76:fb2,f80;f78:fb3,f80;f81:f71,f80;f93:f92,fb7;f9d:f9c,fb7;fa2:fa1,fb7;fa7:fa6,fb7;fac:fab,fb7;fb9:f90,fb5;1026:1025,102e;1b06:1b05,1b35;1b08:1b07,1b35;1b0a:1b09,1b35;1b0c:1b0b,1b35;1b0e:1b0d,1b35;1b12:1b11,1b35;1b3b:1b3a,1b35;1b3d:1b3c,1b35;1b40:1b3e,1b35;1b41:1b3f,1b35;1b43:1b42,1b35;1e00:41,325;1e01:61,325;1e02:42,307;1e03:62,307;1e04:42,323;1e05:62,323;1e06:42,331;1e07:62,331;1e08:43,327,301;1e09:63,327,301;1e0a:44,307;1e0b:64,307;1e0c:44,323;1e0d:64,323;1e0e:44,331;1e0f:64,331;1e10:44,327;1e11:64,327;1e12:44,32d;1e13:64,32d;1e14:45,304,300;1e15:65,304,300;1e16:45,304,301;1e17:65,304,301;1e18:45,32d;1e19:65,32d;1e1a:45,330;1e1b:65,330;1e1c:45,327,306;1e1d:65,327,306;1e1e:46,307;1e1f:66,307;1e20:47,304;1e21:67,304;1e22:48,307;1e23:68,307;1e24:48,323;1e25:68,323;1e26:48,308;1e27:68,308;1e28:48,327;1e29:68,327;1e2a:48,32e;1e2b:68,32e;1e2c:49,330;1e2d:69,330;1e2e:49,308,301;1e2f:69,308,301;1e30:4b,301;1e31:6b,301;1e32:4b,323;1e33:6b,323;1e34:4b,331;1e35:6b,331;1e36:4c,323;1e37:6c,323;1e38:4c,323,304;1e39:6c,323,304;1e3a:4c,331;1e3b:6c,331;1e3c:4c,32d;1e3d:6c,32d;1e3e:4d,301;1e3f:6d,301;1e40:4d,307;1e41:6d,307;1e42:4d,323;1e43:6d,323;1e44:4e,307;1e45:6e,307;1e46:4e,323;1e47:6e,323;1e48:4e,331;1e49:6e,331;1e4a:4e,32d;1e4b:6e,32d;1e4c:4f,303,301;1e4d:6f,303,301;1e4e:4f,303,308;1e4f:6f,303,308;1e50:4f,304,300;1e51:6f,304,300;1e52:4f,304,301;1e53:6f,304,301;1e54:50,301;1e55:70,301;1e56:50,307;1e57:70,307;1e58:52,307;1e59:72,307;1e5a:52,323;1e5b:72,323;1e5c:52,323,304;1e5d:72,323,304;1e5e:52,331;1e5f:72,331;1e60:53,307;1e61:73,307;1e62:53,323;1e63:73,323;1e64:53,301,307;1e65:73,301,307;1e66:53,30c,307;1e67:73,30c,307;1e68:53,323,307;1e69:73,323,307;1e6a:54,307;1e6b:74,307;1e6c:54,323;1e6d:74,323;1e6e:54,331;1e6f:74,331;1e70:54,32d;1e71:74,32d;1e72:55,324;1e73:75,324;1e74:55,330;1e75:75,330;1e76:55,32d;1e77:75,32d;1e78:55,303,301;1e79:75,303,301;1e7a:55,304,308;1e7b:75,304,308;1e7c:56,303;1e7d:76,303;1e7e:56,323;1e7f:76,323;1e80:57,300;1e81:77,300;1e82:57,301;1e83:77,301;1e84:57,308;1e85:77,308;1e86:57,307;1e87:77,307;1e88:57,323;1e89:77,323;1e8a:58,307;1e8b:78,307;1e8c:58,308;1e8d:78,308;1e8e:59,307;1e8f:79,307;1e90:5a,302;1e91:7a,302;1e92:5a,323;1e93:7a,323;1e94:5a,331;1e95:7a,331;1e96:68,331;1e97:74,308;1e98:77,30a;1e99:79,30a;1e9b:17f,307;1ea0:41,323;1ea1:61,323;1ea2:41,309;1ea3:61,309;1ea4:41,302,301;1ea5:61,302,301;1ea6:41,302,300;1ea7:61,302,300;1ea8:41,302,309;1ea9:61,302,309;1eaa:41,302,303;1eab:61,302,303;1eac:41,323,302;1ead:61,323,302;1eae:41,306,301;1eaf:61,306,301;1eb0:41,306,300;1eb1:61,306,300;1eb2:41,306,309;1eb3:61,306,309;1eb4:41,306,303;1eb5:61,306,303;1eb6:41,323,306;1eb7:61,323,306;1eb8:45,323;1eb9:65,323;1eba:45,309;1ebb:65,309;1ebc:45,303;1ebd:65,303;1ebe:45,302,301;1ebf:65,302,301;1ec0:45,302,300;1ec1:65,302,300;1ec2:45,302,309;1ec3:65,302,309;1ec4:45,302,303;1ec5:65,302,303;1ec6:45,323,302;1ec7:65,323,302;1ec8:49,309;1ec9:69,309;1eca:49,323;1ecb:69,323;1ecc:4f,323;1ecd:6f,323;1ece:4f,309;1ecf:6f,309;1ed0:4f,302,301;1ed1:6f,302,301;1ed2:4f,302,300;1ed3:6f,302,300;1ed4:4f,302,309;1ed5:6f,302,309;1ed6:4f,302,303;1ed7:6f,302,303;1ed8:4f,323,302;1ed9:6f,323,302;1eda:4f,31b,301;1edb:6f,31b,301;1edc:4f,31b,300;1edd:6f,31b,300;1ede:4f,31b,309;1edf:6f,31b,309;1ee0:4f,31b,303;1ee1:6f,31b,303;1ee2:4f,31b,323;1ee3:6f,31b,323;1ee4:55,323;1ee5:75,323;1ee6:55,309;1ee7:75,309;1ee8:55,31b,301;1ee9:75,31b,301;1eea:55,31b,300;1eeb:75,31b,300;1eec:55,31b,309;1eed:75,31b,309;1eee:55,31b,303;1eef:75,31b,303;1ef0:55,31b,323;1ef1:75,31b,323;1ef2:59,300;1ef3:79,300;1ef4:59,323;1ef5:79,323;1ef6:59,309;1ef7:79,309;1ef8:59,303;1ef9:79,303;1f00:3b1,313;1f01:3b1,314;1f02:3b1,313,300;1f03:3b1,314,300;1f04:3b1,313,301;1f05:3b1,314,301;1f06:3b1,313,342;1f07:3b1,314,342;1f08:391,313;1f09:391,314;1f0a:391,313,300;1f0b:391,314,300;1f0c:391,313,301;1f0d:391,314,301;1f0e:391,313,342;1f0f:391,314,342;1f10:3b5,313;1f11:3b5,314;1f12:3b5,313,300;1f13:3b5,314,300;1f14:3b5,313,301;1f15:3b5,314,301;1f18:395,313;1f19:395,314;1f1a:395,313,300;1f1b:395,314,300;1f1c:395,313,301;1f1d:395,314,301;1f20:3b7,313;1f21:3b7,314;1f22:3b7,313,300;1f23:3b7,314,300;1f24:3b7,313,301;1f25:3b7,314,301;1f26:3b7,313,342;1f27:3b7,314,342;1f28:397,313;1f29:397,314;1f2a:397,313,300;1f2b:397,314,300;1f2c:397,313,301;1f2d:397,314,301;1f2e:397,313,342;1f2f:397,314,342;1f30:3b9,313;1f31:3b9,314;1f32:3b9,313,300;1f33:3b9,314,300;1f34:3b9,313,301;1f35:3b9,314,301;1f36:3b9,313,342;1f37:3b9,314,342;1f38:399,313;1f39:399,314;1f3a:399,313,300;1f3b:399,314,300;1f3c:399,313,301;1f3d:399,314,301;1f3e:399,313,342;1f3f:399,314,342;1f40:3bf,313;1f41:3bf,314;1f42:3bf,313,300;1f43:3bf,314,300;1f44:3bf,313,301;1f45:3bf,314,301;1f48:39f,313;1f49:39f,314;1f4a:39f,313,300;1f4b:39f,314,300;1f4c:39f,313,301;1f4d:39f,314,301;1f50:3c5,313;1f51:3c5,314;1f52:3c5,313,300;1f53:3c5,314,300;1f54:3c5,313,301;1f55:3c5,314,301;1f56:3c5,313,342;1f57:3c5,314,342;1f59:3a5,314;1f5b:3a5,314,300;1f5d:3a5,314,301;1f5f:3a5,314,342;1f60:3c9,313;1f61:3c9,314;1f62:3c9,313,300;1f63:3c9,314,300;1f64:3c9,313,301;1f65:3c9,314,301;1f66:3c9,313,342;1f67:3c9,314,342;1f68:3a9,313;1f69:3a9,314;1f6a:3a9,313,300;1f6b:3a9,314,300;1f6c:3a9,313,301;1f6d:3a9,314,301;1f6e:3a9,313,342;1f6f:3a9,314,342;1f70:3b1,300;1f71:3b1,301;1f72:3b5,300;1f73:3b5,301;1f74:3b7,300;1f75:3b7,301;1f76:3b9,300;1f77:3b9,301;1f78:3bf,300;1f79:3bf,301;1f7a:3c5,300;1f7b:3c5,301;1f7c:3c9,300;1f7d:3c9,301;1f80:3b1,313,345;1f81:3b1,314,345;1f82:3b1,313,300,345;1f83:3b1,314,300,345;1f84:3b1,313,301,345;1f85:3b1,314,301,345;1f86:3b1,313,342,345;1f87:3b1,314,342,345;1f88:391,313,345;1f89:391,314,345;1f8a:391,313,300,345;1f8b:391,314,300,345;1f8c:391,313,301,345;1f8d:391,314,301,345;1f8e:391,313,342,345;1f8f:391,314,342,345;1f90:3b7,313,345;1f91:3b7,314,345;1f92:3b7,313,300,345;1f93:3b7,314,300,345;1f94:3b7,313,301,345;1f95:3b7,314,301,345;1f96:3b7,313,342,345;1f97:3b7,314,342,345;1f98:397,313,345;1f99:397,314,345;1f9a:397,313,300,345;1f9b:397,314,300,345;1f9c:397,313,301,345;1f9d:397,314,301,345;1f9e:397,313,342,345;1f9f:397,314,342,345;1fa0:3c9,313,345;1fa1:3c9,314,345;1fa2:3c9,313,300,345;1fa3:3c9,314,300,345;1fa4:3c9,313,301,345;1fa5:3c9,314,301,345;1fa6:3c9,313,342,345;1fa7:3c9,314,342,345;1fa8:3a9,313,345;1fa9:3a9,314,345;1faa:3a9,313,300,345;1fab:3a9,314,300,345;1fac:3a9,313,301,345;1fad:3a9,314,301,345;1fae:3a9,313,342,345;1faf:3a9,314,342,345;1fb0:3b1,306;1fb1:3b1,304;1fb2:3b1,300,345;1fb3:3b1,345;1fb4:3b1,301,345;1fb6:3b1,342;1fb7:3b1,342,345;1fb8:391,306;1fb9:391,304;1fba:391,300;1fbb:391,301;1fbc:391,345;1fbe:3b9;1fc1:a8,342;1fc2:3b7,300,345;1fc3:3b7,345;1fc4:3b7,301,345;1fc6:3b7,342;1fc7:3b7,342,345;1fc8:395,300;1fc9:395,301;1fca:397,300;1fcb:397,301;1fcc:397,345;1fcd:1fbf,300;1fce:1fbf,301;1fcf:1fbf,342;1fd0:3b9,306;1fd1:3b9,304;1fd2:3b9,308,300;1fd3:3b9,308,301;1fd6:3b9,342;1fd7:3b9,308,342;1fd8:399,306;1fd9:399,304;1fda:399,300;1fdb:399,301;1fdd:1ffe,300;1fde:1ffe,301;1fdf:1ffe,342;1fe0:3c5,306;1fe1:3c5,304;1fe2:3c5,308,300;1fe3:3c5,308,301;1fe4:3c1,313;1fe5:3c1,314;1fe6:3c5,342;1fe7:3c5,308,342;1fe8:3a5,306;1fe9:3a5,304;1fea:3a5,300;1feb:3a5,301;1fec:3a1,314;1fed:a8,300;1fee:a8,301;1fef:60;1ff2:3c9,300,345;1ff3:3c9,345;1ff4:3c9,301,345;1ff6:3c9,342;1ff7:3c9,342,345;1ff8:39f,300;1ff9:39f,301;1ffa:3a9,300;1ffb:3a9,301;1ffc:3a9,345;1ffd:b4;2000:2002;2001:2003;2126:3a9;212a:4b;212b:41,30a;219a:2190,338;219b:2192,338;21ae:2194,338;21cd:21d0,338;21ce:21d4,338;21cf:21d2,338;2204:2203,338;2209:2208,338;220c:220b,338;2224:2223,338;2226:2225,338;2241:223c,338;2244:2243,338;2247:2245,338;2249:2248,338;2260:3d,338;2262:2261,338;226d:224d,338;226e:3c,338;226f:3e,338;2270:2264,338;2271:2265,338;2274:2272,338;2275:2273,338;2278:2276,338;2279:2277,338;2280:227a,338;2281:227b,338;2284:2282,338;2285:2283,338;2288:2286,338;2289:2287,338;22ac:22a2,338;22ad:22a8,338;22ae:22a9,338;22af:22ab,338;22e0:227c,338;22e1:227d,338;22e2:2291,338;22e3:2292,338;22ea:22b2,338;22eb:22b3,338;22ec:22b4,338;22ed:22b5,338;2329:3008;232a:3009;2adc:2add,338;304c:304b,3099;304e:304d,3099;3050:304f,3099;3052:3051,3099;3054:3053,3099;3056:3055,3099;3058:3057,3099;305a:3059,3099;305c:305b,3099;305e:305d,3099;3060:305f,3099;3062:3061,3099;3065:3064,3099;3067:3066,3099;3069:3068,3099;3070:306f,3099;3071:306f,309a;3073:3072,3099;3074:3072,309a;3076:3075,3099;3077:3075,309a;3079:3078,3099;307a:3078,309a;307c:307b,3099;307d:307b,309a;3094:3046,3099;309e:309d,3099;30ac:30ab,3099;30ae:30ad,3099;30b0:30af,3099;30b2:30b1,3099;30b4:30b3,3099;30b6:30b5,3099;30b8:30b7,3099;30ba:30b9,3099;30bc:30bb,3099;30be:30bd,3099;30c0:30bf,3099;30c2:30c1,3099;30c5:30c4,3099;30c7:30c6,3099;30c9:30c8,3099;30d0:30cf,3099;30d1:30cf,309a;30d3:30d2,3099;30d4:30d2,309a;30d6:30d5,3099;30d7:30d5,309a;30d9:30d8,3099;30da:30d8,309a;30dc:30db,3099;30dd:30db,309a;30f4:30a6,3099;30f7:30ef,3099;30f8:30f0,3099;30f9:30f1,3099;30fa:30f2,3099;30fe:30fd,3099;f900:8c48;f901:66f4;f902:8eca;f903:8cc8;f904:6ed1;f905:4e32;f906:53e5;f907:9f9c;f908:9f9c;f909:5951;f90a:91d1;f90b:5587;f90c:5948;f90d:61f6;f90e:7669;f90f:7f85;f910:863f;f911:87ba;f912:88f8;f913:908f;f914:6a02;f915:6d1b;f916:70d9;f917:73de;f918:843d;f919:916a;f91a:99f1;f91b:4e82;f91c:5375;f91d:6b04;f91e:721b;f91f:862d;f920:9e1e;f921:5d50;f922:6feb;f923:85cd;f924:8964;f925:62c9;f926:81d8;f927:881f;f928:5eca;f929:6717;f92a:6d6a;f92b:72fc;f92c:90ce;f92d:4f86;f92e:51b7;f92f:52de;f930:64c4;f931:6ad3;f932:7210;f933:76e7;f934:8001;f935:8606;f936:865c;f937:8def;f938:9732;f939:9b6f;f93a:9dfa;f93b:788c;f93c:797f;f93d:7da0;f93e:83c9;f93f:9304;f940:9e7f;f941:8ad6;f942:58df;f943:5f04;f944:7c60;f945:807e;f946:7262;f947:78ca;f948:8cc2;f949:96f7;f94a:58d8;f94b:5c62;f94c:6a13;f94d:6dda;f94e:6f0f;f94f:7d2f;f950:7e37;f951:964b;f952:52d2;f953:808b;f954:51dc;f955:51cc;f956:7a1c;f957:7dbe;f958:83f1;f959:9675;f95a:8b80;f95b:62cf;f95c:6a02;f95d:8afe;f95e:4e39;f95f:5be7;f960:6012;f961:7387;f962:7570;f963:5317;f964:78fb;f965:4fbf;f966:5fa9;f967:4e0d;f968:6ccc;f969:6578;f96a:7d22;f96b:53c3;f96c:585e;f96d:7701;f96e:8449;f96f:8aaa;f970:6bba;f971:8fb0;f972:6c88;f973:62fe;f974:82e5;f975:63a0;f976:7565;f977:4eae;f978:5169;f979:51c9;f97a:6881;f97b:7ce7;f97c:826f;f97d:8ad2;f97e:91cf;f97f:52f5;f980:5442;f981:5973;f982:5eec;f983:65c5;f984:6ffe;f985:792a;f986:95ad;f987:9a6a;f988:9e97;f989:9ece;f98a:529b;f98b:66c6;f98c:6b77;f98d:8f62;f98e:5e74;f98f:6190;f990:6200;f991:649a;f992:6f23;f993:7149;f994:7489;f995:79ca;f996:7df4;f997:806f;f998:8f26;f999:84ee;f99a:9023;f99b:934a;f99c:5217;f99d:52a3;f99e:54bd;f99f:70c8;f9a0:88c2;f9a1:8aaa;f9a2:5ec9;f9a3:5ff5;f9a4:637b;f9a5:6bae;f9a6:7c3e;f9a7:7375;f9a8:4ee4;f9a9:56f9;f9aa:5be7;f9ab:5dba;f9ac:601c;f9ad:73b2;f9ae:7469;f9af:7f9a;f9b0:8046;f9b1:9234;f9b2:96f6;f9b3:9748;f9b4:9818;f9b5:4f8b;f9b6:79ae;f9b7:91b4;f9b8:96b8;f9b9:60e1;f9ba:4e86;f9bb:50da;f9bc:5bee;f9bd:5c3f;f9be:6599;f9bf:6a02;f9c0:71ce;f9c1:7642;f9c2:84fc;f9c3:907c;f9c4:9f8d;f9c5:6688;f9c6:962e;f9c7:5289;f9c8:677b;f9c9:67f3;f9ca:6d41;f9cb:6e9c;f9cc:7409;f9cd:7559;f9ce:786b;f9cf:7d10;f9d0:985e;f9d1:516d;f9d2:622e;f9d3:9678;f9d4:502b;f9d5:5d19;f9d6:6dea;f9d7:8f2a;f9d8:5f8b;f9d9:6144;f9da:6817;f9db:7387;f9dc:9686;f9dd:5229;f9de:540f;f9df:5c65;f9e0:6613;f9e1:674e;f9e2:68a8;f9e3:6ce5;f9e4:7406;f9e5:75e2;f9e6:7f79;f9e7:88cf;f9e8:88e1;f9e9:91cc;f9ea:96e2;f9eb:533f;f9ec:6eba;f9ed:541d;f9ee:71d0;f9ef:7498;f9f0:85fa;f9f1:96a3;f9f2:9c57;f9f3:9e9f;f9f4:6797;f9f5:6dcb;f9f6:81e8;f9f7:7acb;f9f8:7b20;f9f9:7c92;f9fa:72c0;f9fb:7099;f9fc:8b58;f9fd:4ec0;f9fe:8336;f9ff:523a;fa00:5207;fa01:5ea6;fa02:62d3;fa03:7cd6;fa04:5b85;fa05:6d1e;fa06:66b4;fa07:8f3b;fa08:884c;fa09:964d;fa0a:898b;fa0b:5ed3;fa0c:5140;fa0d:55c0;fa10:585a;fa12:6674;fa15:51de;fa16:732a;fa17:76ca;fa18:793c;fa19:795e;fa1a:7965;fa1b:798f;fa1c:9756;fa1d:7cbe;fa1e:7fbd;fa20:8612;fa22:8af8;fa25:9038;fa26:90fd;fa2a:98ef;fa2b:98fc;fa2c:9928;fa2d:9db4;fa2e:90de;fa2f:96b7;fa30:4fae;fa31:50e7;fa32:514d;fa33:52c9;fa34:52e4;fa35:5351;fa36:559d;fa37:5606;fa38:5668;fa39:5840;fa3a:58a8;fa3b:5c64;fa3c:5c6e;fa3d:6094;fa3e:6168;fa3f:618e;fa40:61f2;fa41:654f;fa42:65e2;fa43:6691;fa44:6885;fa45:6d77;fa46:6e1a;fa47:6f22;fa48:716e;fa49:722b;fa4a:7422;fa4b:7891;fa4c:793e;fa4d:7949;fa4e:7948;fa4f:7950;fa50:7956;fa51:795d;fa52:798d;fa53:798e;fa54:7a40;fa55:7a81;fa56:7bc0;fa57:7df4;fa58:7e09;fa59:7e41;fa5a:7f72;fa5b:8005;fa5c:81ed;fa5d:8279;fa5e:8279;fa5f:8457;fa60:8910;fa61:8996;fa62:8b01;fa63:8b39;fa64:8cd3;fa65:8d08;fa66:8fb6;fa67:9038;fa68:96e3;fa69:97ff;fa6a:983b;fa6b:6075;fa6c:242ee;fa6d:8218;fa70:4e26;fa71:51b5;fa72:5168;fa73:4f80;fa74:5145;fa75:5180;fa76:52c7;fa77:52fa;fa78:559d;fa79:5555;fa7a:5599;fa7b:55e2;fa7c:585a;fa7d:58b3;fa7e:5944;fa7f:5954;fa80:5a62;fa81:5b28;fa82:5ed2;fa83:5ed9;fa84:5f69;fa85:5fad;fa86:60d8;fa87:614e;fa88:6108;fa89:618e;fa8a:6160;fa8b:61f2;fa8c:6234;fa8d:63c4;fa8e:641c;fa8f:6452;fa90:6556;fa91:6674;fa92:6717;fa93:671b;fa94:6756;fa95:6b79;fa96:6bba;fa97:6d41;fa98:6edb;fa99:6ecb;fa9a:6f22;fa9b:701e;fa9c:716e;fa9d:77a7;fa9e:7235;fa9f:72af;faa0:732a;faa1:7471;faa2:7506;faa3:753b;faa4:761d;faa5:761f;faa6:76ca;faa7:76db;faa8:76f4;faa9:774a;faaa:7740;faab:78cc;faac:7ab1;faad:7bc0;faae:7c7b;faaf:7d5b;fab0:7df4;fab1:7f3e;fab2:8005;fab3:8352;fab4:83ef;fab5:8779;fab6:8941;fab7:8986;fab8:8996;fab9:8abf;faba:8af8;fabb:8acb;fabc:8b01;fabd:8afe;fabe:8aed;fabf:8b39;fac0:8b8a;fac1:8d08;fac2:8f38;fac3:9072;fac4:9199;fac5:9276;fac6:967c;fac7:96e3;fac8:9756;fac9:97db;faca:97ff;facb:980b;facc:983b;facd:9b12;face:9f9c;facf:2284a;fad0:22844;fad1:233d5;fad2:3b9d;fad3:4018;fad4:4039;fad5:25249;fad6:25cd0;fad7:27ed3;fad8:9f43;fad9:9f8e;fb1d:5d9,5b4;fb1f:5f2,5b7;fb2a:5e9,5c1;fb2b:5e9,5c2;fb2c:5e9,5bc,5c1;fb2d:5e9,5bc,5c2;fb2e:5d0,5b7;fb2f:5d0,5b8;fb30:5d0,5bc;fb31:5d1,5bc;fb32:5d2,5bc;fb33:5d3,5bc;fb34:5d4,5bc;fb35:5d5,5bc;fb36:5d6,5bc;fb38:5d8,5bc;fb39:5d9,5bc;fb3a:5da,5bc;fb3b:5db,5bc;fb3c:5dc,5bc;fb3e:5de,5bc;fb40:5e0,5bc;fb41:5e1,5bc;fb43:5e3,5bc;fb44:5e4,5bc;fb46:5e6,5bc;fb47:5e7,5bc;fb48:5e8,5bc;fb49:5e9,5bc;fb4a:5ea,5bc;fb4b:5d5,5b9;fb4c:5d1,5bf;fb4d:5db,5bf;fb4e:5e4,5bf;1109a:11099,110ba;1109c:1109b,110ba;110ab:110a5,110ba;1112e:11131,11127;1112f:11132,11127;1134b:11347,1133e;1134c:11347,11357;114bb:114b9,114ba;114bc:114b9,114b0;114be:114b9,114bd;115ba:115b8,115af;115bb:115b9,115af;11938:11935,11930;1d15e:1d157,1d165;1d15f:1d158,1d165;1d160:1d158,1d165,1d16e;1d161:1d158,1d165,1d16f;1d162:1d158,1d165,1d170;1d163:1d158,1d165,1d171;1d164:1d158,1d165,1d172;1d1bb:1d1b9,1d165;1d1bc:1d1ba,1d165;1d1bd:1d1b9,1d165,1d16e;1d1be:1d1ba,1d165,1d16e;1d1bf:1d1b9,1d165,1d16f;1d1c0:1d1ba,1d165,1d16f;2f800:4e3d;2f801:4e38;2f802:4e41;2f803:20122;2f804:4f60;2f805:4fae;2f806:4fbb;2f807:5002;2f808:507a;2f809:5099;2f80a:50e7;2f80b:50cf;2f80c:349e;2f80d:2063a;2f80e:514d;2f80f:5154;2f810:5164;2f811:5177;2f812:2051c;2f813:34b9;2f814:5167;2f815:518d;2f816:2054b;2f817:5197;2f818:51a4;2f819:4ecc;2f81a:51ac;2f81b:51b5;2f81c:291df;2f81d:51f5;2f81e:5203;2f81f:34df;2f820:523b;2f821:5246;2f822:5272;2f823:5277;2f824:3515;2f825:52c7;2f826:52c9;2f827:52e4;2f828:52fa;2f829:5305;2f82a:5306;2f82b:5317;2f82c:5349;2f82d:5351;2f82e:535a;2f82f:5373;2f830:537d;2f831:537f;2f832:537f;2f833:537f;2f834:20a2c;2f835:7070;2f836:53ca;2f837:53df;2f838:20b63;2f839:53eb;2f83a:53f1;2f83b:5406;2f83c:549e;2f83d:5438;2f83e:5448;2f83f:5468;2f840:54a2;2f841:54f6;2f842:5510;2f843:5553;2f844:5563;2f845:5584;2f846:5584;2f847:5599;2f848:55ab;2f849:55b3;2f84a:55c2;2f84b:5716;2f84c:5606;2f84d:5717;2f84e:5651;2f84f:5674;2f850:5207;2f851:58ee;2f852:57ce;2f853:57f4;2f854:580d;2f855:578b;2f856:5832;2f857:5831;2f858:58ac;2f859:214e4;2f85a:58f2;2f85b:58f7;2f85c:5906;2f85d:591a;2f85e:5922;2f85f:5962;2f860:216a8;2f861:216ea;2f862:59ec;2f863:5a1b;2f864:5a27;2f865:59d8;2f866:5a66;2f867:36ee;2f868:36fc;2f869:5b08;2f86a:5b3e;2f86b:5b3e;2f86c:219c8;2f86d:5bc3;2f86e:5bd8;2f86f:5be7;2f870:5bf3;2f871:21b18;2f872:5bff;2f873:5c06;2f874:5f53;2f875:5c22;2f876:3781;2f877:5c60;2f878:5c6e;2f879:5cc0;2f87a:5c8d;2f87b:21de4;2f87c:5d43;2f87d:21de6;2f87e:5d6e;2f87f:5d6b;2f880:5d7c;2f881:5de1;2f882:5de2;2f883:382f;2f884:5dfd;2f885:5e28;2f886:5e3d;2f887:5e69;2f888:3862;2f889:22183;2f88a:387c;2f88b:5eb0;2f88c:5eb3;2f88d:5eb6;2f88e:5eca;2f88f:2a392;2f890:5efe;2f891:22331;2f892:22331;2f893:8201;2f894:5f22;2f895:5f22;2f896:38c7;2f897:232b8;2f898:261da;2f899:5f62;2f89a:5f6b;2f89b:38e3;2f89c:5f9a;2f89d:5fcd;2f89e:5fd7;2f89f:5ff9;2f8a0:6081;2f8a1:393a;2f8a2:391c;2f8a3:6094;2f8a4:226d4;2f8a5:60c7;2f8a6:6148;2f8a7:614c;2f8a8:614e;2f8a9:614c;2f8aa:617a;2f8ab:618e;2f8ac:61b2;2f8ad:61a4;2f8ae:61af;2f8af:61de;2f8b0:61f2;2f8b1:61f6;2f8b2:6210;2f8b3:621b;2f8b4:625d;2f8b5:62b1;2f8b6:62d4;2f8b7:6350;2f8b8:22b0c;2f8b9:633d;2f8ba:62fc;2f8bb:6368;2f8bc:6383;2f8bd:63e4;2f8be:22bf1;2f8bf:6422;2f8c0:63c5;2f8c1:63a9;2f8c2:3a2e;2f8c3:6469;2f8c4:647e;2f8c5:649d;2f8c6:6477;2f8c7:3a6c;2f8c8:654f;2f8c9:656c;2f8ca:2300a;2f8cb:65e3;2f8cc:66f8;2f8cd:6649;2f8ce:3b19;2f8cf:6691;2f8d0:3b08;2f8d1:3ae4;2f8d2:5192;2f8d3:5195;2f8d4:6700;2f8d5:669c;2f8d6:80ad;2f8d7:43d9;2f8d8:6717;2f8d9:671b;2f8da:6721;2f8db:675e;2f8dc:6753;2f8dd:233c3;2f8de:3b49;2f8df:67fa;2f8e0:6785;2f8e1:6852;2f8e2:6885;2f8e3:2346d;2f8e4:688e;2f8e5:681f;2f8e6:6914;2f8e7:3b9d;2f8e8:6942;2f8e9:69a3;2f8ea:69ea;2f8eb:6aa8;2f8ec:236a3;2f8ed:6adb;2f8ee:3c18;2f8ef:6b21;2f8f0:238a7;2f8f1:6b54;2f8f2:3c4e;2f8f3:6b72;2f8f4:6b9f;2f8f5:6bba;2f8f6:6bbb;2f8f7:23a8d;2f8f8:21d0b;2f8f9:23afa;2f8fa:6c4e;2f8fb:23cbc;2f8fc:6cbf;2f8fd:6ccd;2f8fe:6c67;2f8ff:6d16;2f900:6d3e;2f901:6d77;2f902:6d41;2f903:6d69;2f904:6d78;2f905:6d85;2f906:23d1e;2f907:6d34;2f908:6e2f;2f909:6e6e;2f90a:3d33;2f90b:6ecb;2f90c:6ec7;2f90d:23ed1;2f90e:6df9;2f90f:6f6e;2f910:23f5e;2f911:23f8e;2f912:6fc6;2f913:7039;2f914:701e;2f915:701b;2f916:3d96;2f917:704a;2f918:707d;2f919:7077;2f91a:70ad;2f91b:20525;2f91c:7145;2f91d:24263;2f91e:719c;2f91f:243ab;2f920:7228;2f921:7235;2f922:7250;2f923:24608;2f924:7280;2f925:7295;2f926:24735;2f927:24814;2f928:737a;2f929:738b;2f92a:3eac;2f92b:73a5;2f92c:3eb8;2f92d:3eb8;2f92e:7447;2f92f:745c;2f930:7471;2f931:7485;2f932:74ca;2f933:3f1b;2f934:7524;2f935:24c36;2f936:753e;2f937:24c92;2f938:7570;2f939:2219f;2f93a:7610;2f93b:24fa1;2f93c:24fb8;2f93d:25044;2f93e:3ffc;2f93f:4008;2f940:76f4;2f941:250f3;2f942:250f2;2f943:25119;2f944:25133;2f945:771e;2f946:771f;2f947:771f;2f948:774a;2f949:4039;2f94a:778b;2f94b:4046;2f94c:4096;2f94d:2541d;2f94e:784e;2f94f:788c;2f950:78cc;2f951:40e3;2f952:25626;2f953:7956;2f954:2569a;2f955:256c5;2f956:798f;2f957:79eb;2f958:412f;2f959:7a40;2f95a:7a4a;2f95b:7a4f;2f95c:2597c;2f95d:25aa7;2f95e:25aa7;2f95f:7aee;2f960:4202;2f961:25bab;2f962:7bc6;2f963:7bc9;2f964:4227;2f965:25c80;2f966:7cd2;2f967:42a0;2f968:7ce8;2f969:7ce3;2f96a:7d00;2f96b:25f86;2f96c:7d63;2f96d:4301;2f96e:7dc7;2f96f:7e02;2f970:7e45;2f971:4334;2f972:26228;2f973:26247;2f974:4359;2f975:262d9;2f976:7f7a;2f977:2633e;2f978:7f95;2f979:7ffa;2f97a:8005;2f97b:264da;2f97c:26523;2f97d:8060;2f97e:265a8;2f97f:8070;2f980:2335f;2f981:43d5;2f982:80b2;2f983:8103;2f984:440b;2f985:813e;2f986:5ab5;2f987:267a7;2f988:267b5;2f989:23393;2f98a:2339c;2f98b:8201;2f98c:8204;2f98d:8f9e;2f98e:446b;2f98f:8291;2f990:828b;2f991:829d;2f992:52b3;2f993:82b1;2f994:82b3;2f995:82bd;2f996:82e6;2f997:26b3c;2f998:82e5;2f999:831d;2f99a:8363;2f99b:83ad;2f99c:8323;2f99d:83bd;2f99e:83e7;2f99f:8457;2f9a0:8353;2f9a1:83ca;2f9a2:83cc;2f9a3:83dc;2f9a4:26c36;2f9a5:26d6b;2f9a6:26cd5;2f9a7:452b;2f9a8:84f1;2f9a9:84f3;2f9aa:8516;2f9ab:273ca;2f9ac:8564;2f9ad:26f2c;2f9ae:455d;2f9af:4561;2f9b0:26fb1;2f9b1:270d2;2f9b2:456b;2f9b3:8650;2f9b4:865c;2f9b5:8667;2f9b6:8669;2f9b7:86a9;2f9b8:8688;2f9b9:870e;2f9ba:86e2;2f9bb:8779;2f9bc:8728;2f9bd:876b;2f9be:8786;2f9bf:45d7;2f9c0:87e1;2f9c1:8801;2f9c2:45f9;2f9c3:8860;2f9c4:8863;2f9c5:27667;2f9c6:88d7;2f9c7:88de;2f9c8:4635;2f9c9:88fa;2f9ca:34bb;2f9cb:278ae;2f9cc:27966;2f9cd:46be;2f9ce:46c7;2f9cf:8aa0;2f9d0:8aed;2f9d1:8b8a;2f9d2:8c55;2f9d3:27ca8;2f9d4:8cab;2f9d5:8cc1;2f9d6:8d1b;2f9d7:8d77;2f9d8:27f2f;2f9d9:20804;2f9da:8dcb;2f9db:8dbc;2f9dc:8df0;2f9dd:208de;2f9de:8ed4;2f9df:8f38;2f9e0:285d2;2f9e1:285ed;2f9e2:9094;2f9e3:90f1;2f9e4:9111;2f9e5:2872e;2f9e6:911b;2f9e7:9238;2f9e8:92d7;2f9e9:92d8;2f9ea:927c;2f9eb:93f9;2f9ec:9415;2f9ed:28bfa;2f9ee:958b;2f9ef:4995;2f9f0:95b7;2f9f1:28d77;2f9f2:49e6;2f9f3:96c3;2f9f4:5db2;2f9f5:9723;2f9f6:29145;2f9f7:2921a;2f9f8:4a6e;2f9f9:4a76;2f9fa:97e0;2f9fb:2940a;2f9fc:4ab2;2f9fd:29496;2f9fe:980b;2f9ff:980b;2fa00:9829;2fa01:295b6;2fa02:98e2;2fa03:4b33;2fa04:9929;2fa05:99a7;2fa06:99c2;2fa07:99fe;2fa08:4bce;2fa09:29b30;2fa0a:9b12;2fa0b:9c40;2fa0c:9cfd;2fa0d:4cce;2fa0e:4ced;2fa0f:9d67;2fa10:2a0ce;2fa11:4cf8;2fa12:2a105;2fa13:2a20e;2fa14:2a291;2fa15:9ebb;2fa16:4d56;2fa17:9ef9;2fa18:9efe;2fa19:9f05;2fa1a:9f0f;2fa1b:9f16;2fa1c:9f3b;2fa1d:2a600",
	ccc = "300:e6;301:e6;302:e6;303:e6;304:e6;305:e6;306:e6;307:e6;308:e6;309:e6;30a:e6;30b:e6;30c:e6;30d:e6;30e:e6;30f:e6;310:e6;311:e6;312:e6;313:e6;314:e6;315:e8;316:dc;317:dc;318:dc;319:dc;31a:e8;31b:d8;31c:dc;31d:dc;31e:dc;31f:dc;320:dc;321:ca;322:ca;323:dc;324:dc;325:dc;326:dc;327:ca;328:ca;329:dc;32a:dc;32b:dc;32c:dc;32d:dc;32e:dc;32f:dc;330:dc;331:dc;332:dc;333:dc;334:1;335:1;336:1;337:1;338:1;339:dc;33a:dc;33b:dc;33c:dc;33d:e6;33e:e6;33f:e6;340:e6;341:e6;342:e6;343:e6;344:e6;345:f0;346:e6;347:dc;348:dc;349:dc;34a:e6;34b:e6;34c:e6;34d:dc;34e:dc;350:e6;351:e6;352:e6;353:dc;354:dc;355:dc;356:dc;357:e6;358:e8;359:dc;35a:dc;35b:e6;35c:e9;35d:ea;35e:ea;35f:e9;360:ea;361:ea;362:e9;363:e6;364:e6;365:e6;366:e6;367:e6;368:e6;369:e6;36a:e6;36b:e6;36c:e6;36d:e6;36e:e6;36f:e6;483:e6;484:e6;485:e6;486:e6;487:e6;591:dc;592:e6;593:e6;594:e6;595:e6;596:dc;597:e6;598:e6;599:e6;59a:de;59b:dc;59c:e6;59d:e6;59e:e6;59f:e6;5a0:e6;5a1:e6;5a2:dc;5a3:dc;5a4:dc;5a5:dc;5a6:dc;5a7:dc;5a8:e6;5a9:e6;5aa:dc;5ab:e6;5ac:e6;5ad:de;5ae:e4;5af:e6;5b0:a;5b1:b;5b2:c;5b3:d;5b4:e;5b5:f;5b6:10;5b7:11;5b8:12;5b9:13;5ba:13;5bb:14;5bc:15;5bd:16;5bf:17;5c1:18;5c2:19;5c4:e6;5c5:dc;5c7:12;610:e6;611:e6;612:e6;613:e6;614:e6;615:e6;616:e6;617:e6;618:1e;619:1f;61a:20;64b:1b;64c:1c;64d:1d;64e:1e;64f:1f;650:20;651:21;652:22;653:e6;654:e6;655:dc;656:dc;657:e6;658:e6;659:e6;65a:e6;65b:e6;65c:dc;65d:e6;65e:e6;65f:dc;670:23;6d6:e6;6d7:e6;6d8:e6;6d9:e6;6da:e6;6db:e6;6dc:e6;6df:e6;6e0:e6;6e1:e6;6e2:e6;6e3:dc;6e4:e6;6e7:e6;6e8:e6;6ea:dc;6eb:e6;6ec:e6;6ed:dc;711:24;730:e6;731:dc;732:e6;733:e6;734:dc;735:e6;736:e6;737:dc;738:dc;739:dc;73a:e6;73b:dc;73c:dc;73d:e6;73e:dc;73f:e6;740:e6;741:e6;742:dc;743:e6;744:dc;745:e6;746:dc;747:e6;748:dc;749:e6;74a:e6;7eb:e6;7ec:e6;7ed:e6;7ee:e6;7ef:e6;7f0:e6;7f1:e6;7f2:dc;7f3:e6;7fd:dc;816:e6;817:e6;818:e6;819:e6;81b:e6;81c:e6;81d:e6;81e:e6;81f:e6;820:e6;821:e6;822:e6;823:e6;825:e6;826:e6;827:e6;829:e6;82a:e6;82b:e6;82c:e6;82d:e6;859:dc;85a:dc;85b:dc;898:e6;899:dc;89a:dc;89b:dc;89c:e6;89d:e6;89e:e6;89f:e6;8ca:e6;8cb:e6;8cc:e6;8cd:e6;8ce:e6;8cf:dc;8d0:dc;8d1:dc;8d2:dc;8d3:dc;8d4:e6;8d5:e6;8d6:e6;8d7:e6;8d8:e6;8d9:e6;8da:e6;8db:e6;8dc:e6;8dd:e6;8de:e6;8df:e6;8e0:e6;8e1:e6;8e3:dc;8e4:e6;8e5:e6;8e6:dc;8e7:e6;8e8:e6;8e9:dc;8ea:e6;8eb:e6;8ec:e6;8ed:dc;8ee:dc;8ef:dc;8f0:1b;8f1:1c;8f2:1d;8f3:e6;8f4:e6;8f5:e6;8f6:dc;8f7:e6;8f8:e6;8f9:dc;8fa:dc;8fb:e6;8fc:e6;8fd:e6;8fe:e6;8ff:e6;93c:7;94d:9;951:e6;952:dc;953:e6;954:e6;9bc:7;9cd:9;9fe:e6;a3c:7;a4d:9;abc:7;acd:9;b3c:7;b4d:9;bcd:9;c3c:7;c4d:9;c55:54;c56:5b;cbc:7;ccd:9;d3b:9;d3c:9;d4d:9;dca:9;e38:67;e39:67;e3a:9;e48:6b;e49:6b;e4a:6b;e4b:6b;eb8:76;eb9:76;eba:9;ec8:7a;ec9:7a;eca:7a;ecb:7a;f18:dc;f19:dc;f35:dc;f37:dc;f39:d8;f71:81;f72:82;f74:84;f7a:82;f7b:82;f7c:82;f7d:82;f80:82;f82:e6;f83:e6;f84:9;f86:e6;f87:e6;fc6:dc;1037:7;1039:9;103a:9;108d:dc;135d:e6;135e:e6;135f:e6;1714:9;1715:9;1734:9;17d2:9;17dd:e6;18a9:e4;1939:de;193a:e6;193b:dc;1a17:e6;1a18:dc;1a60:9;1a75:e6;1a76:e6;1a77:e6;1a78:e6;1a79:e6;1a7a:e6;1a7b:e6;1a7c:e6;1a7f:dc;1ab0:e6;1ab1:e6;1ab2:e6;1ab3:e6;1ab4:e6;1ab5:dc;1ab6:dc;1ab7:dc;1ab8:dc;1ab9:dc;1aba:dc;1abb:e6;1abc:e6;1abd:dc;1abf:dc;1ac0:dc;1ac1:e6;1ac2:e6;1ac3:dc;1ac4:dc;1ac5:e6;1ac6:e6;1ac7:e6;1ac8:e6;1ac9:e6;1aca:dc;1acb:e6;1acc:e6;1acd:e6;1ace:e6;1b34:7;1b44:9;1b6b:e6;1b6c:dc;1b6d:e6;1b6e:e6;1b6f:e6;1b70:e6;1b71:e6;1b72:e6;1b73:e6;1baa:9;1bab:9;1be6:7;1bf2:9;1bf3:9;1c37:7;1cd0:e6;1cd1:e6;1cd2:e6;1cd4:1;1cd5:dc;1cd6:dc;1cd7:dc;1cd8:dc;1cd9:dc;1cda:e6;1cdb:e6;1cdc:dc;1cdd:dc;1cde:dc;1cdf:dc;1ce0:e6;1ce2:1;1ce3:1;1ce4:1;1ce5:1;1ce6:1;1ce7:1;1ce8:1;1ced:dc;1cf4:e6;1cf8:e6;1cf9:e6;1dc0:e6;1dc1:e6;1dc2:dc;1dc3:e6;1dc4:e6;1dc5:e6;1dc6:e6;1dc7:e6;1dc8:e6;1dc9:e6;1dca:dc;1dcb:e6;1dcc:e6;1dcd:ea;1dce:d6;1dcf:dc;1dd0:ca;1dd1:e6;1dd2:e6;1dd3:e6;1dd4:e6;1dd5:e6;1dd6:e6;1dd7:e6;1dd8:e6;1dd9:e6;1dda:e6;1ddb:e6;1ddc:e6;1ddd:e6;1dde:e6;1ddf:e6;1de0:e6;1de1:e6;1de2:e6;1de3:e6;1de4:e6;1de5:e6;1de6:e6;1de7:e6;1de8:e6;1de9:e6;1dea:e6;1deb:e6;1dec:e6;1ded:e6;1dee:e6;1def:e6;1df0:e6;1df1:e6;1df2:e6;1df3:e6;1df4:e6;1df5:e6;1df6:e8;1df7:e4;1df8:e4;1df9:dc;1dfa:da;1dfb:e6;1dfc:e9;1dfd:dc;1dfe:e6;1dff:dc;20d0:e6;20d1:e6;20d2:1;20d3:1;20d4:e6;20d5:e6;20d6:e6;20d7:e6;20d8:1;20d9:1;20da:1;20db:e6;20dc:e6;20e1:e6;20e5:1;20e6:1;20e7:e6;20e8:dc;20e9:e6;20ea:1;20eb:1;20ec:dc;20ed:dc;20ee:dc;20ef:dc;20f0:e6;2cef:e6;2cf0:e6;2cf1:e6;2d7f:9;2de0:e6;2de1:e6;2de2:e6;2de3:e6;2de4:e6;2de5:e6;2de6:e6;2de7:e6;2de8:e6;2de9:e6;2dea:e6;2deb:e6;2dec:e6;2ded:e6;2dee:e6;2def:e6;2df0:e6;2df1:e6;2df2:e6;2df3:e6;2df4:e6;2df5:e6;2df6:e6;2df7:e6;2df8:e6;2df9:e6;2dfa:e6;2dfb:e6;2dfc:e6;2dfd:e6;2dfe:e6;2dff:e6;302a:da;302b:e4;302c:e8;302d:de;302e:e0;302f:e0;3099:8;309a:8;a66f:e6;a674:e6;a675:e6;a676:e6;a677:e6;a678:e6;a679:e6;a67a:e6;a67b:e6;a67c:e6;a67d:e6;a69e:e6;a69f:e6;a6f0:e6;a6f1:e6;a806:9;a82c:9;a8c4:9;a8e0:e6;a8e1:e6;a8e2:e6;a8e3:e6;a8e4:e6;a8e5:e6;a8e6:e6;a8e7:e6;a8e8:e6;a8e9:e6;a8ea:e6;a8eb:e6;a8ec:e6;a8ed:e6;a8ee:e6;a8ef:e6;a8f0:e6;a8f1:e6;a92b:dc;a92c:dc;a92d:dc;a953:9;a9b3:7;a9c0:9;aab0:e6;aab2:e6;aab3:e6;aab4:dc;aab7:e6;aab8:e6;aabe:e6;aabf:e6;aac1:e6;aaf6:9;abed:9;fb1e:1a;fe20:e6;fe21:e6;fe22:e6;fe23:e6;fe24:e6;fe25:e6;fe26:e6;fe27:dc;fe28:dc;fe29:dc;fe2a:dc;fe2b:dc;fe2c:dc;fe2d:dc;fe2e:e6;fe2f:e6;101fd:dc;102e0:dc;10376:e6;10377:e6;10378:e6;10379:e6;1037a:e6;10a0d:dc;10a0f:e6;10a38:e6;10a39:1;10a3a:dc;10a3f:9;10ae5:e6;10ae6:dc;10d24:e6;10d25:e6;10d26:e6;10d27:e6;10eab:e6;10eac:e6;10f46:dc;10f47:dc;10f48:e6;10f49:e6;10f4a:e6;10f4b:dc;10f4c:e6;10f4d:dc;10f4e:dc;10f4f:dc;10f50:dc;10f82:e6;10f83:dc;10f84:e6;10f85:dc;11046:9;11070:9;1107f:9;110b9:9;110ba:7;11100:e6;11101:e6;11102:e6;11133:9;11134:9;11173:7;111c0:9;111ca:7;11235:9;11236:7;112e9:7;112ea:9;1133b:7;1133c:7;1134d:9;11366:e6;11367:e6;11368:e6;11369:e6;1136a:e6;1136b:e6;1136c:e6;11370:e6;11371:e6;11372:e6;11373:e6;11374:e6;11442:9;11446:7;1145e:e6;114c2:9;114c3:7;115bf:9;115c0:7;1163f:9;116b6:9;116b7:7;1172b:9;11839:9;1183a:7;1193d:9;1193e:9;11943:7;119e0:9;11a34:9;11a47:9;11a99:9;11c3f:9;11d42:7;11d44:9;11d45:9;11d97:9;16af0:1;16af1:1;16af2:1;16af3:1;16af4:1;16b30:e6;16b31:e6;16b32:e6;16b33:e6;16b34:e6;16b35:e6;16b36:e6;16ff0:6;16ff1:6;1bc9e:1;1d165:d8;1d166:d8;1d167:1;1d168:1;1d169:1;1d16d:e2;1d16e:d8;1d16f:d8;1d170:d8;1d171:d8;1d172:d8;1d17b:dc;1d17c:dc;1d17d:dc;1d17e:dc;1d17f:dc;1d180:dc;1d181:dc;1d182:dc;1d185:e6;1d186:e6;1d187:e6;1d188:e6;1d189:e6;1d18a:dc;1d18b:dc;1d1aa:e6;1d1ab:e6;1d1ac:e6;1d1ad:e6;1d242:e6;1d243:e6;1d244:e6;1e000:e6;1e001:e6;1e002:e6;1e003:e6;1e004:e6;1e005:e6;1e006:e6;1e008:e6;1e009:e6;1e00a:e6;1e00b:e6;1e00c:e6;1e00d:e6;1e00e:e6;1e00f:e6;1e010:e6;1e011:e6;1e012:e6;1e013:e6;1e014:e6;1e015:e6;1e016:e6;1e017:e6;1e018:e6;1e01b:e6;1e01c:e6;1e01d:e6;1e01e:e6;1e01f:e6;1e020:e6;1e021:e6;1e023:e6;1e024:e6;1e026:e6;1e027:e6;1e028:e6;1e029:e6;1e02a:e6;1e130:e6;1e131:e6;1e132:e6;1e133:e6;1e134:e6;1e135:e6;1e136:e6;1e2ae:e6;1e2ec:e6;1e2ed:e6;1e2ee:e6;1e2ef:e6;1e8d0:dc;1e8d1:dc;1e8d2:dc;1e8d3:dc;1e8d4:dc;1e8d5:dc;1e8d6:dc;1e944:e6;1e945:e6;1e946:e6;1e947:e6;1e948:e6;1e949:e6;1e94a:7",
	comp = "3c,338:226e;3d,338:2260;3e,338:226f;41,300:c0;41,301:c1;41,302:c2;41,303:c3;41,304:100;41,306:102;41,307:226;41,308:c4;41,309:1ea2;41,30a:c5;41,30c:1cd;41,30f:200;41,311:202;41,323:1ea0;41,325:1e00;41,328:104;42,307:1e02;42,323:1e04;42,331:1e06;43,301:106;43,302:108;43,307:10a;43,30c:10c;43,327:c7;44,307:1e0a;44,30c:10e;44,323:1e0c;44,327:1e10;44,32d:1e12;44,331:1e0e;45,300:c8;45,301:c9;45,302:ca;45,303:1ebc;45,304:112;45,306:114;45,307:116;45,308:cb;45,309:1eba;45,30c:11a;45,30f:204;45,311:206;45,323:1eb8;45,327:228;45,328:118;45,32d:1e18;45,330:1e1a;46,307:1e1e;47,301:1f4;47,302:11c;47,304:1e20;47,306:11e;47,307:120;47,30c:1e6;47,327:122;48,302:124;48,307:1e22;48,308:1e26;48,30c:21e;48,323:1e24;48,327:1e28;48,32e:1e2a;49,300:cc;49,301:cd;49,302:ce;49,303:128;49,304:12a;49,306:12c;49,307:130;49,308:cf;49,309:1ec8;49,30c:1cf;49,30f:208;49,311:20a;49,323:1eca;49,328:12e;49,330:1e2c;4a,302:134;4b,301:1e30;4b,30c:1e8;4b,323:1e32;4b,327:136;4b,331:1e34;4c,301:139;4c,30c:13d;4c,323:1e36;4c,327:13b;4c,32d:1e3c;4c,331:1e3a;4d,301:1e3e;4d,307:1e40;4d,323:1e42;4e,300:1f8;4e,301:143;4e,303:d1;4e,307:1e44;4e,30c:147;4e,323:1e46;4e,327:145;4e,32d:1e4a;4e,331:1e48;4f,300:d2;4f,301:d3;4f,302:d4;4f,303:d5;4f,304:14c;4f,306:14e;4f,307:22e;4f,308:d6;4f,309:1ece;4f,30b:150;4f,30c:1d1;4f,30f:20c;4f,311:20e;4f,31b:1a0;4f,323:1ecc;4f,328:1ea;50,301:1e54;50,307:1e56;52,301:154;52,307:1e58;52,30c:158;52,30f:210;52,311:212;52,323:1e5a;52,327:156;52,331:1e5e;53,301:15a;53,302:15c;53,307:1e60;53,30c:160;53,323:1e62;53,326:218;53,327:15e;54,307:1e6a;54,30c:164;54,323:1e6c;54,326:21a;54,327:162;54,32d:1e70;54,331:1e6e;55,300:d9;55,301:da;55,302:db;55,303:168;55,304:16a;55,306:16c;55,308:dc;55,309:1ee6;55,30a:16e;55,30b:170;55,30c:1d3;55,30f:214;55,311:216;55,31b:1af;55,323:1ee4;55,324:1e72;55,328:172;55,32d:1e76;55,330:1e74;56,303:1e7c;56,323:1e7e;57,300:1e80;57,301:1e82;57,302:174;57,307:1e86;57,308:1e84;57,323:1e88;58,307:1e8a;58,308:1e8c;59,300:1ef2;59,301:dd;59,302:176;59,303:1ef8;59,304:232;59,307:1e8e;59,308:178;59,309:1ef6;59,323:1ef4;5a,301:179;5a,302:1e90;5a,307:17b;5a,30c:17d;5a,323:1e92;5a,331:1e94;61,300:e0;61,301:e1;61,302:e2;61,303:e3;61,304:101;61,306:103;61,307:227;61,308:e4;61,309:1ea3;61,30a:e5;61,30c:1ce;61,30f:201;61,311:203;61,323:1ea1;61,325:1e01;61,328:105;62,307:1e03;62,323:1e05;62,331:1e07;63,301:107;63,302:109;63,307:10b;63,30c:10d;63,327:e7;64,307:1e0b;64,30c:10f;64,323:1e0d;64,327:1e11;64,32d:1e13;64,331:1e0f;65,300:e8;65,301:e9;65,302:ea;65,303:1ebd;65,304:113;65,306:115;65,307:117;65,308:eb;65,309:1ebb;65,30c:11b;65,30f:205;65,311:207;65,323:1eb9;65,327:229;65,328:119;65,32d:1e19;65,330:1e1b;66,307:1e1f;67,301:1f5;67,302:11d;67,304:1e21;67,306:11f;67,307:121;67,30c:1e7;67,327:123;68,302:125;68,307:1e23;68,308:1e27;68,30c:21f;68,323:1e25;68,327:1e29;68,32e:1e2b;68,331:1e96;69,300:ec;69,301:ed;69,302:ee;69,303:129;69,304:12b;69,306:12d;69,308:ef;69,309:1ec9;69,30c:1d0;69,30f:209;69,311:20b;69,323:1ecb;69,328:12f;69,330:1e2d;6a,302:135;6a,30c:1f0;6b,301:1e31;6b,30c:1e9;6b,323:1e33;6b,327:137;6b,331:1e35;6c,301:13a;6c,30c:13e;6c,323:1e37;6c,327:13c;6c,32d:1e3d;6c,331:1e3b;6d,301:1e3f;6d,307:1e41;6d,323:1e43;6e,300:1f9;6e,301:144;6e,303:f1;6e,307:1e45;6e,30c:148;6e,323:1e47;6e,327:146;6e,32d:1e4b;6e,331:1e49;6f,300:f2;6f,301:f3;6f,302:f4;6f,303:f5;6f,304:14d;6f,306:14f;6f,307:22f;6f,308:f6;6f,309:1ecf;6f,30b:151;6f,30c:1d2;6f,30f:20d;6f,311:20f;6f,31b:1a1;6f,323:1ecd;6f,328:1eb;70,301:1e55;70,307:1e57;72,301:155;72,307:1e59;72,30c:159;72,30f:211;72,311:213;72,323:1e5b;72,327:157;72,331:1e5f;73,301:15b;73,302:15d;73,307:1e61;73,30c:161;73,323:1e63;73,326:219;73,327:15f;74,307:1e6b;74,308:1e97;74,30c:165;74,323:1e6d;74,326:21b;74,327:163;74,32d:1e71;74,331:1e6f;75,300:f9;75,301:fa;75,302:fb;75,303:169;75,304:16b;75,306:16d;75,308:fc;75,309:1ee7;75,30a:16f;75,30b:171;75,30c:1d4;75,30f:215;75,311:217;75,31b:1b0;75,323:1ee5;75,324:1e73;75,328:173;75,32d:1e77;75,330:1e75;76,303:1e7d;76,323:1e7f;77,300:1e81;77,301:1e83;77,302:175;77,307:1e87;77,308:1e85;77,30a:1e98;77,323:1e89;78,307:1e8b;78,308:1e8d;79,300:1ef3;79,301:fd;79,302:177;79,303:1ef9;79,304:233;79,307:1e8f;79,308:ff;79,309:1ef7;79,30a:1e99;79,323:1ef5;7a,301:17a;7a,302:1e91;7a,307:17c;7a,30c:17e;7a,323:1e93;7a,331:1e95;a8,300:1fed;a8,301:385;a8,342:1fc1;c2,300:1ea6;c2,301:1ea4;c2,303:1eaa;c2,309:1ea8;c4,304:1de;c5,301:1fa;c6,301:1fc;c6,304:1e2;c7,301:1e08;ca,300:1ec0;ca,301:1ebe;ca,303:1ec4;ca,309:1ec2;cf,301:1e2e;d4,300:1ed2;d4,301:1ed0;d4,303:1ed6;d4,309:1ed4;d5,301:1e4c;d5,304:22c;d5,308:1e4e;d6,304:22a;d8,301:1fe;dc,300:1db;dc,301:1d7;dc,304:1d5;dc,30c:1d9;e2,300:1ea7;e2,301:1ea5;e2,303:1eab;e2,309:1ea9;e4,304:1df;e5,301:1fb;e6,301:1fd;e6,304:1e3;e7,301:1e09;ea,300:1ec1;ea,301:1ebf;ea,303:1ec5;ea,309:1ec3;ef,301:1e2f;f4,300:1ed3;f4,301:1ed1;f4,303:1ed7;f4,309:1ed5;f5,301:1e4d;f5,304:22d;f5,308:1e4f;f6,304:22b;f8,301:1ff;fc,300:1dc;fc,301:1d8;fc,304:1d6;fc,30c:1da;102,300:1eb0;102,301:1eae;102,303:1eb4;102,309:1eb2;103,300:1eb1;103,301:1eaf;103,303:1eb5;103,309:1eb3;112,300:1e14;112,301:1e16;113,300:1e15;113,301:1e17;14c,300:1e50;14c,301:1e52;14d,300:1e51;14d,301:1e53;15a,307:1e64;15b,307:1e65;160,307:1e66;161,307:1e67;168,301:1e78;169,301:1e79;16a,308:1e7a;16b,308:1e7b;17f,307:1e9b;1a0,300:1edc;1a0,301:1eda;1a0,303:1ee0;1a0,309:1ede;1a0,323:1ee2;1a1,300:1edd;1a1,301:1edb;1a1,303:1ee1;1a1,309:1edf;1a1,323:1ee3;1af,300:1eea;1af,301:1ee8;1af,303:1eee;1af,309:1eec;1af,323:1ef0;1b0,300:1eeb;1b0,301:1ee9;1b0,303:1eef;1b0,309:1eed;1b0,323:1ef1;1b7,30c:1ee;1ea,304:1ec;1eb,304:1ed;226,304:1e0;227,304:1e1;228,306:1e1c;229,306:1e1d;22e,304:230;22f,304:231;292,30c:1ef;391,300:1fba;391,301:386;391,304:1fb9;391,306:1fb8;391,313:1f08;391,314:1f09;391,345:1fbc;395,300:1fc8;395,301:388;395,313:1f18;395,314:1f19;397,300:1fca;397,301:389;397,313:1f28;397,314:1f29;397,345:1fcc;399,300:1fda;399,301:38a;399,304:1fd9;399,306:1fd8;399,308:3aa;399,313:1f38;399,314:1f39;39f,300:1ff8;39f,301:38c;39f,313:1f48;39f,314:1f49;3a1,314:1fec;3a5,300:1fea;3a5,301:38e;3a5,304:1fe9;3a5,306:1fe8;3a5,308:3ab;3a5,314:1f59;3a9,300:1ffa;3a9,301:38f;3a9,313:1f68;3a9,314:1f69;3a9,345:1ffc;3ac,345:1fb4;3ae,345:1fc4;3b1,300:1f70;3b1,301:3ac;3b1,304:1fb1;3b1,306:1fb0;3b1,313:1f00;3b1,314:1f01;3b1,342:1fb6;3b1,345:1fb3;3b5,300:1f72;3b5,301:3ad;3b5,313:1f10;3b5,314:1f11;3b7,300:1f74;3b7,301:3ae;3b7,313:1f20;3b7,314:1f21;3b7,342:1fc6;3b7,345:1fc3;3b9,300:1f76;3b9,301:3af;3b9,304:1fd1;3b9,306:1fd0;3b9,308:3ca;3b9,313:1f30;3b9,314:1f31;3b9,342:1fd6;3bf,300:1f78;3bf,301:3cc;3bf,313:1f40;3bf,314:1f41;3c1,313:1fe4;3c1,314:1fe5;3c5,300:1f7a;3c5,301:3cd;3c5,304:1fe1;3c5,306:1fe0;3c5,308:3cb;3c5,313:1f50;3c5,314:1f51;3c5,342:1fe6;3c9,300:1f7c;3c9,301:3ce;3c9,313:1f60;3c9,314:1f61;3c9,342:1ff6;3c9,345:1ff3;3ca,300:1fd2;3ca,301:390;3ca,342:1fd7;3cb,300:1fe2;3cb,301:3b0;3cb,342:1fe7;3ce,345:1ff4;3d2,301:3d3;3d2,308:3d4;406,308:407;410,306:4d0;410,308:4d2;413,301:403;415,300:400;415,306:4d6;415,308:401;416,306:4c1;416,308:4dc;417,308:4de;418,300:40d;418,304:4e2;418,306:419;418,308:4e4;41a,301:40c;41e,308:4e6;423,304:4ee;423,306:40e;423,308:4f0;423,30b:4f2;427,308:4f4;42b,308:4f8;42d,308:4ec;430,306:4d1;430,308:4d3;433,301:453;435,300:450;435,306:4d7;435,308:451;436,306:4c2;436,308:4dd;437,308:4df;438,300:45d;438,304:4e3;438,306:439;438,308:4e5;43a,301:45c;43e,308:4e7;443,304:4ef;443,306:45e;443,308:4f1;443,30b:4f3;447,308:4f5;44b,308:4f9;44d,308:4ed;456,308:457;474,30f:476;475,30f:477;4d8,308:4da;4d9,308:4db;4e8,308:4ea;4e9,308:4eb;627,653:622;627,654:623;627,655:625;648,654:624;64a,654:626;6c1,654:6c2;6d2,654:6d3;6d5,654:6c0;928,93c:929;930,93c:931;933,93c:934;9c7,9be:9cb;9c7,9d7:9cc;b47,b3e:b4b;b47,b56:b48;b47,b57:b4c;b92,bd7:b94;bc6,bbe:bca;bc6,bd7:bcc;bc7,bbe:bcb;c46,c56:c48;cbf,cd5:cc0;cc6,cc2:cca;cc6,cd5:cc7;cc6,cd6:cc8;cca,cd5:ccb;d46,d3e:d4a;d46,d57:d4c;d47,d3e:d4b;dd9,dca:dda;dd9,dcf:ddc;dd9,ddf:dde;ddc,dca:ddd;1025,102e:1026;1b05,1b35:1b06;1b07,1b35:1b08;1b09,1b35:1b0a;1b0b,1b35:1b0c;1b0d,1b35:1b0e;1b11,1b35:1b12;1b3a,1b35:1b3b;1b3c,1b35:1b3d;1b3e,1b35:1b40;1b3f,1b35:1b41;1b42,1b35:1b43;1e36,304:1e38;1e37,304:1e39;1e5a,304:1e5c;1e5b,304:1e5d;1e62,307:1e68;1e63,307:1e69;1ea0,302:1eac;1ea0,306:1eb6;1ea1,302:1ead;1ea1,306:1eb7;1eb8,302:1ec6;1eb9,302:1ec7;1ecc,302:1ed8;1ecd,302:1ed9;1f00,300:1f02;1f00,301:1f04;1f00,342:1f06;1f00,345:1f80;1f01,300:1f03;1f01,301:1f05;1f01,342:1f07;1f01,345:1f81;1f02,345:1f82;1f03,345:1f83;1f04,345:1f84;1f05,345:1f85;1f06,345:1f86;1f07,345:1f87;1f08,300:1f0a;1f08,301:1f0c;1f08,342:1f0e;1f08,345:1f88;1f09,300:1f0b;1f09,301:1f0d;1f09,342:1f0f;1f09,345:1f89;1f0a,345:1f8a;1f0b,345:1f8b;1f0c,345:1f8c;1f0d,345:1f8d;1f0e,345:1f8e;1f0f,345:1f8f;1f10,300:1f12;1f10,301:1f14;1f11,300:1f13;1f11,301:1f15;1f18,300:1f1a;1f18,301:1f1c;1f19,300:1f1b;1f19,301:1f1d;1f20,300:1f22;1f20,301:1f24;1f20,342:1f26;1f20,345:1f90;1f21,300:1f23;1f21,301:1f25;1f21,342:1f27;1f21,345:1f91;1f22,345:1f92;1f23,345:1f93;1f24,345:1f94;1f25,345:1f95;1f26,345:1f96;1f27,345:1f97;1f28,300:1f2a;1f28,301:1f2c;1f28,342:1f2e;1f28,345:1f98;1f29,300:1f2b;1f29,301:1f2d;1f29,342:1f2f;1f29,345:1f99;1f2a,345:1f9a;1f2b,345:1f9b;1f2c,345:1f9c;1f2d,345:1f9d;1f2e,345:1f9e;1f2f,345:1f9f;1f30,300:1f32;1f30,301:1f34;1f30,342:1f36;1f31,300:1f33;1f31,301:1f35;1f31,342:1f37;1f38,300:1f3a;1f38,301:1f3c;1f38,342:1f3e;1f39,300:1f3b;1f39,301:1f3d;1f39,342:1f3f;1f40,300:1f42;1f40,301:1f44;1f41,300:1f43;1f41,301:1f45;1f48,300:1f4a;1f48,301:1f4c;1f49,300:1f4b;1f49,301:1f4d;1f50,300:1f52;1f50,301:1f54;1f50,342:1f56;1f51,300:1f53;1f51,301:1f55;1f51,342:1f57;1f59,300:1f5b;1f59,301:1f5d;1f59,342:1f5f;1f60,300:1f62;1f60,301:1f64;1f60,342:1f66;1f60,345:1fa0;1f61,300:1f63;1f61,301:1f65;1f61,342:1f67;1f61,345:1fa1;1f62,345:1fa2;1f63,345:1fa3;1f64,345:1fa4;1f65,345:1fa5;1f66,345:1fa6;1f67,345:1fa7;1f68,300:1f6a;1f68,301:1f6c;1f68,342:1f6e;1f68,345:1fa8;1f69,300:1f6b;1f69,301:1f6d;1f69,342:1f6f;1f69,345:1fa9;1f6a,345:1faa;1f6b,345:1fab;1f6c,345:1fac;1f6d,345:1fad;1f6e,345:1fae;1f6f,345:1faf;1f70,345:1fb2;1f74,345:1fc2;1f7c,345:1ff2;1fb6,345:1fb7;1fbf,300:1fcd;1fbf,301:1fce;1fbf,342:1fcf;1fc6,345:1fc7;1ff6,345:1ff7;1ffe,300:1fdd;1ffe,301:1fde;1ffe,342:1fdf;2190,338:219a;2192,338:219b;2194,338:21ae;21d0,338:21cd;21d2,338:21cf;21d4,338:21ce;2203,338:2204;2208,338:2209;220b,338:220c;2223,338:2224;2225,338:2226;223c,338:2241;2243,338:2244;2245,338:2247;2248,338:2249;224d,338:226d;2261,338:2262;2264,338:2270;2265,338:2271;2272,338:2274;2273,338:2275;2276,338:2278;2277,338:2279;227a,338:2280;227b,338:2281;227c,338:22e0;227d,338:22e1;2282,338:2284;2283,338:2285;2286,338:2288;2287,338:2289;2291,338:22e2;2292,338:22e3;22a2,338:22ac;22a8,338:22ad;22a9,338:22ae;22ab,338:22af;22b2,338:22ea;22b3,338:22eb;22b4,338:22ec;22b5,338:22ed;3046,3099:3094;304b,3099:304c;304d,3099:304e;304f,3099:3050;3051,3099:3052;3053,3099:3054;3055,3099:3056;3057,3099:3058;3059,3099:305a;305b,3099:305c;305d,3099:305e;305f,3099:3060;3061,3099:3062;3064,3099:3065;3066,3099:3067;3068,3099:3069;306f,3099:3070;306f,309a:3071;3072,3099:3073;3072,309a:3074;3075,3099:3076;3075,309a:3077;3078,3099:3079;3078,309a:307a;307b,3099:307c;307b,309a:307d;309d,3099:309e;30a6,3099:30f4;30ab,3099:30ac;30ad,3099:30ae;30af,3099:30b0;30b1,3099:30b2;30b3,3099:30b4;30b5,3099:30b6;30b7,3099:30b8;30b9,3099:30ba;30bb,3099:30bc;30bd,3099:30be;30bf,3099:30c0;30c1,3099:30c2;30c4,3099:30c5;30c6,3099:30c7;30c8,3099:30c9;30cf,3099:30d0;30cf,309a:30d1;30d2,3099:30d3;30d2,309a:30d4;30d5,3099:30d6;30d5,309a:30d7;30d8,3099:30d9;30d8,309a:30da;30db,3099:30dc;30db,309a:30dd;30ef,3099:30f7;30f0,3099:30f8;30f1,3099:30f9;30f2,3099:30fa;30fd,3099:30fe;11099,110ba:1109a;1109b,110ba:1109c;110a5,110ba:110ab;11131,11127:1112e;11132,11127:1112f;11347,1133e:1134b;11347,11357:1134c;114b9,114b0:114bc;114b9,114ba:114bb;114b9,114bd:114be;115b8,115af:115ba;115b9,115af:115bb;11935,11930:11938",
}

end)()
local __ROBLOX = (function()
-- generated by gen_roblox.py from the Roblox API dump (1)
return {
	enums = "AccessModifierType:Allow=0,Deny=1;AccessoryType:Unknown=0,Hat=1,Hair=2,Face=3,Neck=4,Shoulder=5,Front=6,Back=7,Waist=8,TShirt=9,Shirt=10,Pants=11,Jacket=12,Sweater=13,Shorts=14,LeftShoe=15,RightShoe=16,DressSkirt=17,Eyebrow=18,Eyelash=19;ActionOnAutoResumeSync:DontResume=0,KeepStudio=1,KeepLocal=2;ActionOnStopSync:AlwaysAsk=0,KeepLocalFiles=1,DeleteLocalFiles=2;ActionType:Nothing=0,Pause=1,Lose=2,Draw=3,Win=4;ActivePayerStatus:Unknown=0,Never=1,Lapsed=2,Casual50Percent=3,Intermediate35Percent=4,Top15Percent=5;ActuatorRelativeTo:Attachment0=0,Attachment1=1,World=2;ActuatorType:None=0,Motor=1,Servo=2;AdAvailabilityResult:IsAvailable=1,DeviceIneligible=2,ExperienceIneligible=3,InternalError=4,NoFill=5,PlayerIneligible=6,PublisherIneligible=7;AdEventType:VideoLoaded=0,VideoRemoved=1,UserCompletedVideo=2,RewardedAdLoaded=3,RewardedAdGrant=4,RewardedAdUnloaded=5;AdFormat:RewardedVideo=0;AdShape:HorizontalRectangle=1;AdTeleportMethod:Undefined=0,PortalForward=1,InGameMenuBackButton=2,UIBackButton=3;AdUIEventType:AdLabelClicked=0,VolumeButtonClicked=1,FullscreenButtonClicked=2,PlayButtonClicked=3,PauseButtonClicked=4,CloseButtonClicked=5,WhyThisAdClicked=6,PlayEventTriggered=7,PauseEventTriggered=8;AdUIType:None=0,Image=1,Video=2;AdUnitStatus:Inactive=0,Active=1;AdornCullingMode:Automatic=0,Never=1;AdornShading:Default=0,Shaded=1,XRay=2,XRayShaded=3,AlwaysOnTop=4;AgeCheckStatus:Unchecked=0,Checked=1;AlignType:Parallel=0,Perpendicular=1,PrimaryAxisParallel=2,PrimaryAxisPerpendicular=3,PrimaryAxisLookAt=4,AllAxes=5;AlphaMode:Overlay=0,Transparency=1,TintMask=2,Opaque=3;AnalyticsCustomFieldKeys:CustomField01=0,CustomField02=1,CustomField03=2;AnalyticsEconomyAction:Default=0,Acquire=1,Spend=2;AnalyticsEconomyFlowType:Sink=0,Source=1;AnalyticsEconomyTransactionType:IAP=0,Shop=1,Gameplay=2,ContextualPurchase=3,TimedReward=4,Onboarding=5;AnalyticsLogLevel:Trace=0,Debug=1,Information=2,Warning=3,Error=4,Fatal=5;AnalyticsProgressionStatus:Default=0,Begin=1,Complete=2,Abandon=3,Fail=4;AnalyticsProgressionType:Custom=0,Start=1,Fail=2,Complete=3;AnimatedImagePlaybackState:Begin=0,Playing=1,Paused=2,Completed=3,Canceled=4;AnimatedImageScaleType:Stretch=0,Tile=1,Fit=2,Crop=3;AnimationClipFromVideoStatus:Initializing=0,Pending=1,Processing=2,ErrorGeneric=4,Success=6,ErrorVideoTooLong=7,ErrorNoPersonDetected=8,ErrorVideoUnstable=9,Timeout=10,Cancelled=11,ErrorMultiplePeople=12,ErrorUploadingVideo=2001;AnimationNodeBlend2DInputMode:Cartesian=0,Polar=1;AnimationNodeBlendMode:Over=0,Add=1,Subtract=2;AnimationNodeInterruptible:Always=0,Finished=1,Trigger=2;AnimationNodePhaseSync:Synced=0,Unsynced=1;AnimationNodePlayMode:Loop=0,PingPong=1,OnceAndHold=2,OnceAndReset=3;AnimationNodeTransitionType:CrossFade=0,InertialBlend=1,DeadBlend=2;AnimationNodeTransitionWhen:Finished=0,BeforeFinished=1;AnimationNodeType:InvalidNode=0,AddNode=1,OverNode=2,Blend1DNode=3,Blend2DNode=4,ClipNode=5,GraphOutput=6,MaskNode=7,PrioritySelectNode=8,RandomSequenceNode=9,SelectNode=10,SequenceNode=11,SpeedNode=12,SubtractNode=13,OneShotNode=14,StateMachineNode=16;AnimationNodeWaitFor:Finished=0,Trigger=1;AnimationPriority:Idle=0,Movement=1,Action=2,Action2=3,Action3=4,Action4=5,Core=1000;AnimationValueNodeType:Invalid=0,Expression=1;AnimatorRetargetingMode:Default=0,Disabled=1,Enabled=2;AnnotationChannelContentPreference:None=0,All=1,Unknown=2;AnnotationEditingMode:None=0,PlacingNew=1,WritingNew=2;AnnotationPlaceContentPreference:None=0,All=1,MentionsAndReplies=2,Unknown=3;AnnotationRequestStatus:Success=0,Loading=1,ErrorInternalFailure=2,ErrorNotFound=3,ErrorModerated=4;AnnotationRequestType:Unknown=0,Create=1,Resolve=2,Delete=3,Edit=4;AntiAliasing:Disabled=0,Enabled=1;AppLifecycleManagerState:Detached=0,Active=1,Inactive=2,Hidden=3;AppShellActionType:None=0,OpenApp=1,TapChatTab=2,TapConversationEntry=3,TapAvatarTab=4,ReadConversation=5,TapGamePageTab=6,TapHomePageTab=7,GamePageLoaded=8,HomePageLoaded=9,AvatarEditorPageLoaded=10,HomePageInteractive=11;AppShellFeature:None=0,Chat=1,AvatarEditor=2,GamePage=3,HomePage=4,More=5,Landing=6,WatchPage=7;AppUpdateStatus:Unknown=0,NotSupported=1,Failed=2,NotAvailable=3,Available=4,AvailableBoundChannel=5,AvailableBetaProgram=6;ApplyShadowMode:Shape=0,Text=1;ApplyStrokeMode:Contextual=0,Border=1;AspectType:FitWithinMaxSize=0,ScaleWithParentSize=1;AssetCreatorType:User=0,Group=1;AssetFetchStatus:Success=0,Failure=1,None=2,Loading=3,TimedOut=4;AssetRepresentation:FullLength=0,ShortPreview=1;AssetType:Image=1,TShirt=2,Audio=3,Mesh=4,Lua=5,Hat=8,Place=9,Model=10,Shirt=11,Pants=12,Decal=13,Head=17,Face=18,Gear=19,Badge=21,Animation=24,Torso=27,RightArm=28,LeftArm=29,LeftLeg=30,RightLeg=31,Package=32,GamePass=34,Plugin=38,MeshPart=40,HairAccessory=41,FaceAccessory=42,NeckAccessory=43,ShoulderAccessory=44,FrontAccessory=45,BackAccessory=46,WaistAccessory=47,ClimbAnimation=48,DeathAnimation=49,FallAnimation=50,IdleAnimation=51,JumpAnimation=52,RunAnimation=53,SwimAnimation=54,WalkAnimation=55,PoseAnimation=56,EarAccessory=57,EyeAccessory=58,EmoteAnimation=61,Video=62,TShirtAccessory=64,ShirtAccessory=65,PantsAccessory=66,JacketAccessory=67,SweaterAccessory=68,ShortsAccessory=69,LeftShoeAccessory=70,RightShoeAccessory=71,DressSkirtAccessory=72,FontFamily=73,EyebrowAccessory=76,EyelashAccessory=77,MoodAnimation=78,DynamicHead=79,FaceMakeup=88,LipMakeup=89,EyeMakeup=90,AvatarBackground=92,TextDocument=93;AssetTypeVerification:Default=1,ClientOnly=2,Always=3;AudioApiRollout:Disabled=0,Automatic=1,Enabled=2;AudioCaptureMode:;AudioChannelLayout:Mono=0,Stereo=1,Quad=2,Surround_5=3,Surround_5_1=4,Surround_7_1=5,Surround_7_1_4=6;AudioFilterType:Peak=0,LowShelf=1,HighShelf=2,Lowpass12dB=3,Lowpass24dB=4,Lowpass48dB=5,Highpass12dB=6,Highpass24dB=7,Highpass48dB=8,Bandpass=9,Notch=10,Lowpass6dB=11;AudioPositionType:Parent=0,Instance=1;AudioSampleFormat:Int16=0,Float32=1;AudioSimulationFidelity:None=0,Automatic=1;AudioSubType:Music=1,SoundEffect=2;AudioWindowSize:Small=0,Medium=1,Large=2;AuthorityMode:Server=0,Automatic=1;AutoIndentRule:Off=0,Absolute=1,Relative=2;AutomaticSize:None=0,X=1,Y=2,XY=3;AvatarAssetType:TShirt=2,Hat=8,Shirt=11,Pants=12,Head=17,Face=18,Gear=19,Torso=27,RightArm=28,LeftArm=29,LeftLeg=30,RightLeg=31,HairAccessory=41,FaceAccessory=42,NeckAccessory=43,ShoulderAccessory=44,FrontAccessory=45,BackAccessory=46,WaistAccessory=47,ClimbAnimation=48,FallAnimation=50,IdleAnimation=51,JumpAnimation=52,RunAnimation=53,SwimAnimation=54,WalkAnimation=55,EmoteAnimation=61,TShirtAccessory=64,ShirtAccessory=65,PantsAccessory=66,JacketAccessory=67,SweaterAccessory=68,ShortsAccessory=69,LeftShoeAccessory=70,RightShoeAccessory=71,DressSkirtAccessory=72,EyebrowAccessory=76,EyelashAccessory=77,MoodAnimation=78,DynamicHead=79,FaceMakeup=88,LipMakeup=89,EyeMakeup=90,AvatarBackground=92;AvatarChatServiceFeature:None=0,UniverseAudio=1,UniverseVideo=2,PlaceAudio=4,PlaceVideo=8,UserAudioEligible=16,UserAudio=32,UserVideoEligible=64,UserVideo=128,UserBanned=256,UserVerifiedForVoice=512;AvatarContextMenuOption:Friend=0,Chat=1,Emote=2,InspectMenu=3;AvatarGenerationError:None=0,Unknown=1,DownloadFailed=2,Canceled=3,Offensive=4,Timeout=5,JobNotFound=6;AvatarItemType:Asset=1,Bundle=2;AvatarPromptResult:Success=1,PermissionDenied=2,Failed=3;AvatarSettingsAccessoryLimitMethod:Scale=0,Remove=1,PreviewScale=2,PreviewRemove=3;AvatarSettingsAccessoryMode:PlayerChoice=0,CustomLimit=1;AvatarSettingsAnimationClipsMode:PlayerChoice=0,CustomClips=1;AvatarSettingsAnimationPacksMode:PlayerChoice=0,StandardR15=1,StandardR6=2;AvatarSettingsAppearanceMode:PlayerChoice=0,CustomParts=1,CustomBody=2;AvatarSettingsBuildMode:PlayerChoice=0,CustomBuild=1;AvatarSettingsCharacterControllerMode:LegacyHumanoid=0,LuaCharacterController=1;AvatarSettingsClothingMode:PlayerChoice=0,CustomLimit=1;AvatarSettingsCollisionMode:Default=0,SingleCollider=1,Legacy=2;AvatarSettingsCustomAccessoryMode:PlayerChoice=0,CustomAccessories=1;AvatarSettingsCustomBodyType:AvatarReference=0,BundleId=1;AvatarSettingsCustomClothingMode:PlayerChoice=0,CustomClothing=1;AvatarSettingsHitAndTouchDetectionMode:UseParts=0,UseCollider=1;AvatarSettingsJumpMode:JumpHeight=0,JumpPower=1;AvatarSettingsLegacyCollisionMode:R6Colliders=0,InnerBoxColliders=1;AvatarSettingsScaleMode:PlayerChoice=0,CustomScale=1;AvatarThumbnailCustomizationType:Closeup=1,FullBody=2;AvatarUnificationMode:Default=0,Disabled=1,Enabled=2;Axis:X=0,Y=1,Z=2;BasicMeshPartShape:Capsule=5,Cone=6,RoundedBox=7;BenefitType:DeveloperProduct=0,AvatarAsset=1,AvatarBundle=2;BinType:Script=0,GameTool=1,Grab=2,Clone=3,Hammer=4;BodyPart:Head=0,Torso=1,LeftArm=2,RightArm=3,LeftLeg=4,RightLeg=5;BodyPartR15:Head=0,UpperTorso=1,LowerTorso=2,LeftFoot=3,LeftLowerLeg=4,LeftUpperLeg=5,RightFoot=6,RightLowerLeg=7,RightUpperLeg=8,LeftHand=9,LeftLowerArm=10,LeftUpperArm=11,RightHand=12,RightLowerArm=13,RightUpperArm=14,RootPart=15,Unknown=17;BorderMode:Outline=0,Middle=1,Inset=2;BorderStrokePosition:Outer=0,Center=1,Inner=2;BranchStatus:Draft=0,ReadyToMerge=1,Merged=2,Archived=3;BreakReason:Other=0,Error=1,SpecialBreakpoint=2,UserBreakpoint=3;BreakpointRemoveReason:Requested=0,ScriptChanged=1,ScriptRemoved=2;BulkMoveMode:FireAllEvents=0,FireCFrameChanged=1;BundleType:BodyParts=1,Animations=2,Shoes=3,DynamicHead=4,DynamicHeadAvatar=5;Button:Dismount=8,Jump=32;ButtonStyle:Custom=0,RobloxButtonDefault=1,RobloxButton=2,RobloxRoundButton=3,RobloxRoundDefaultButton=4,RobloxRoundDropdownButton=5;CageType:Inner=0,Outer=1;CameraMode:Classic=0,LockFirstPerson=1;CameraNavigationModel:Roblox=0,IndustryCompatible=1;CameraPanMode:Classic=0,EdgeBump=1;CameraSpeedAdjustBinding:None=0,RmbScroll=1,AltScroll=2;CameraType:Fixed=0,Attach=1,Watch=2,Track=3,Follow=4,Custom=5,Scriptable=6,Orbital=7;CanCollaborateError:Invalid=0,None=1,NotAgeVerified=2,OutsideAgeBucket=3,TooManyCollaborators=4,PCBlock=5,NotFound=6,OutsideOwnerAgeBucket=7,NotAuthorized=8,OutsideAgeBucketTcPc=9,OtherCollaboratorSettingsPreventTrust=10,AgeVerificationCountryBlocked=11,OtherUserCannotCollaborate=12;CaptureGalleryPermission:ReadAndUpload=0;CaptureType:Screenshot=1,Video=2;CatalogCategoryFilter:None=1,Featured=2,Collectibles=3,CommunityCreations=4,Premium=5,Recommended=6;CatalogSortAggregation:Past12Hours=1,PastDay=2,Past3Days=3,PastWeek=4,PastMonth=5,AllTime=6;CatalogSortType:Relevance=1,PriceHighToLow=2,PriceLowToHigh=3,MostFavorited=5,RecentlyCreated=6,Bestselling=7;CellBlock:Solid=0,VerticalWedge=1,CornerWedge=2,InverseCornerWedge=3,HorizontalWedge=4;CellMaterial:Empty=0,Grass=1,Sand=2,Brick=3,Granite=4,Asphalt=5,Iron=6,Aluminum=7,Gold=8,WoodPlank=9,WoodLog=10,Gravel=11,CinderBlock=12,MossyStone=13,Cement=14,RedPlastic=15,BluePlastic=16,Water=17;CellOrientation:NegZ=0,X=1,Z=2,NegX=3;CenterDialogType:UnsolicitedDialog=1,PlayerInitiatedDialog=2,ModalDialog=3,QuitDialog=4;CharacterControlMode:Default=0,Legacy=1,NoCharacterController=2,LuaCharacterController=3;ChatCallbackType:OnCreatingChatWindow=1,OnClientSendingMessage=2,OnClientFormattingMessage=3,OnServerReceivingMessage=17;ChatColor:Blue=0,Green=1,Red=2,White=3;ChatMode:Menu=0,TextAndMenu=1;ChatPrivacyMode:AllUsers=0,NoOne=1,Friends=2;ChatRestrictionStatus:Unknown=0,NotRestricted=1,Restricted=2;ChatStyle:Classic=0,Bubble=1,ClassicAndBubble=2;ChatVersion:LegacyChatService=0,TextChatService=1;ClientAnimatorThrottlingMode:Default=0,Disabled=1,Enabled=2;CloseReason:Unknown=0,RobloxMaintenance=1,DeveloperShutdown=2,DeveloperUpdate=3,ServerEmpty=4,OutOfMemory=5,Moderation=6;CollaboratorStatus:None=0,Editing3D=1,Scripting=2,PrivateScripting=3;CollisionFidelity:Default=0,Hull=1,Box=2,PreciseConvexDecomposition=3,Tunable=4;CommandPermission:Plugin=0,LocalUser=1;CompileTarget:Client=0,CoreScript=1,Studio=2,CoreScriptRaw=3;CompletionAcceptanceBehavior:Insert=0,Replace=1,ReplaceOnEnterInsertOnTab=2,InsertOnEnterReplaceOnTab=3;CompletionItemKind:Text=1,Method=2,Function=3,Constructor=4,Field=5,Variable=6,Class=7,Interface=8,Module=9,Property=10,Unit=11,Value=12,Enum=13,Keyword=14,Snippet=15,Color=16,File=17,Reference=18,Folder=19,EnumMember=20,Constant=21,Struct=22,Event=23,Operator=24,TypeParameter=25;CompletionItemTag:Deprecated=1,IncorrectIndexType=2,PluginPermissions=3,CommandLinePermissions=4,RobloxPermissions=5,AddParens=6,PutCursorInParens=7,TypeCorrect=8,ClientServerBoundaryViolation=9,Invalidated=10,PutCursorBeforeEnd=11;CompletionTriggerKind:Invoked=1,TriggerCharacter=2,TriggerForIncompleteCompletions=3;CompositeValueCurveType:ColorRGB=0,ColorHSV=1,NumberRange=2,Rect=3,UDim=4,UDim2=5,Vector2=6,Vector3=7;CompressionAlgorithm:Zstd=0;ComputerCameraMovementMode:Default=0,Classic=1,Follow=2,Orbital=3,CameraToggle=4;ComputerMovementMode:Default=0,KeyboardMouse=1,ClickToMove=2;ConfigSnapshotErrorState:None=0,LoadFailed=1;ConnectionError:OK=0,Unknown=1,ConnectErrors=2,AlreadyConnected=3,NoFreeIncomingConnections=4,ConnectionBanned=5,InvalidPassword=6,IncompatibleProtocolVersion=7,IPRecentlyConnected=8,OurSystemRequiresSecurity=9,SecurityKeyMismatch=10,DisconnectErrors=256,DisconnectBadhash=257,DisconnectSecurityKeyMismatch=258,DisconnectProtocolMismatch=259,DisconnectReceivePacketError=260,DisconnectReceivePacketStreamError=261,DisconnectSendPacketError=262,DisconnectIllegalTeleport=263,DisconnectDuplicatePlayer=264,DisconnectDuplicateTicket=265,DisconnectTimeout=266,DisconnectLuaKick=267,DisconnectOnRemoteSysStats=268,DisconnectHashTimeout=269,DisconnectCloudEditKick=270,DisconnectPlayerless=271,DisconnectNewSecurityKeyMismatch=272,DisconnectEvicted=273,DisconnectDevMaintenance=274,DisconnectRobloxMaintenance=275,DisconnectRejoin=276,DisconnectConnectionLost=277,DisconnectIdle=278,DisconnectRaknetErrors=279,DisconnectWrongVersion=280,DisconnectBySecurityPolicy=281,DisconnectBlockedIP=282,DisconnectClientFailure=284,DisconnectClientRequest=285,DisconnectPrivateServerKickout=286,DisconnectModeratedGame=287,ServerShutdown=288,ReplicatorTimeout=290,PlayerRemoved=291,DisconnectOutOfMemoryKeepPlayingLeave=292,DisconnectRomarkEndOfTest=293,DisconnectCollaboratorPermissionRevoked=294,DisconnectCollaboratorUnderage=295,NetworkInternal=296,NetworkSend=297,NetworkTimeout=298,NetworkMisbehavior=299,NetworkSecurity=300,ReplacementReady=301,ServerEmpty=302,PhantomFreeze=303,AndroidAnticheatKick=304,AndroidEmulatorKick=305,AndroidRootedKick=306,ScreentimeLockoutKick=307,DisconnectionNotification=308,DisconnectVerboselyModeratedGame=309,DisconnectCollaboratorNotAgeVerified=310,DisconnectCollaboratorTrustedConnectionsRequired=311,DisconnectCollaboratorOwnerActionRequired=312,DisconnectCollaboratorTooManyCollaborators=313,DisconnectCollaboratorUnknownError=314,DisconnectCollaboratorRequestedEviction=315,DisconnectCollaboratorTrustedConnectionsRequiredPC=316,DisconnectRemoteAttestationUnsupported=317,DisconnectRemoteAttestationGeneralFailure=318,DisconnectRemoteAttestationTimeout=319,DisconnectRemoteAttestationOSOutOfDate=320,DisconnectRemoteAttestationBootValidationFailure=321,PlacelaunchErrors=512,PlacelaunchDisabled=515,PlacelaunchError=516,PlacelaunchGameEnded=517,PlacelaunchGameFull=518,PlacelaunchUserLeft=522,PlacelaunchRestricted=523,PlacelaunchUnauthorized=524,PlacelaunchFlooded=525,PlacelaunchHashExpired=526,PlacelaunchHashException=527,PlacelaunchPartyCannotFit=528,PlacelaunchHttpError=529,PlacelaunchUserPrivacyUnauthorized=533,PlacelaunchVipOwnerNotPresent=541,PlacelaunchAgeVerificationRequired=542,PlacelaunchParentalApprovalRequired=543,PlacelaunchCoreGated=544,PlacelaunchCollaborationCoreGated=545,PlacelaunchCreatorBan=600,PlacelaunchDeviceBlock=601,PlacelaunchCustomMessage=610,PlacelaunchOtherError=611,TeleportErrors=768,TeleportFailure=769,TeleportGameNotFound=770,TeleportGameEnded=771,TeleportGameFull=772,TeleportUnauthorized=773,TeleportFlooded=774,TeleportIsTeleporting=775,TransportErrors=1024,DisconnectTransportIoError=1025,DisconnectTransportIoInternetError=1026,DisconnectTransportProtocolError=1027,DisconnectTransportNgtcp2Error=1028,DisconnectTransportQuicError=1029,DisconnectTransportRnaError=1030;ConnectionState:Connected=0,Disconnected=1;ContentSourceType:None=0,Uri=1,Object=2,Opaque=3;ContextActionPriority:Low=1000,Medium=2000,High=3000;ContextActionResult:Sink=0,Pass=1;ControlMode:Classic=0,MouseLockSwitch=1;CoreGuiType:PlayerList=0,Health=1,Backpack=2,Chat=3,All=4,EmotesMenu=5,SelfView=6,Captures=7,AvatarSwitcher=8,ExperienceShop=9;CreateAssetResult:Success=1,PermissionDenied=2,UploadFailed=3,Unknown=4;CreateContentResult:Success=1,PermissionDenied=2,UploadFailed=3,StorageLimitExceeded=4,Unknown=5;CreateOutfitFailure:InvalidName=1,OutfitLimitReached=2,Other=3;CreatorType:User=0,Group=1;CreatorTypeFilter:User=0,Group=1,All=2;CurrencyType:Default=0,Robux=1,Tix=2;CustomCameraMode:Default=0,Classic=1,Follow=2;DataModelChangeType:Add=0,Remove=1,Modify=2,AddPackage=3;DataModelExtractorFileType:PlaceFile=0,FirstSlice=1,NonFirstSlice=2;DataStoreRequestType:GetAsync=0,SetIncrementAsync=1,UpdateAsync=2,GetSortedAsync=3,SetIncrementSortedAsync=4,OnUpdate=5,ListAsync=6,GetVersionAsync=7,RemoveVersionAsync=8,StandardRead=9,StandardWrite=10,StandardList=11,StandardRemove=12,OrderedRead=13,OrderedWrite=14,OrderedList=15,OrderedRemove=16;DebugBreakModeType:Never=0,Always=1,Unhandled=2;DebuggerEndReason:ClientRequest=0,Timeout=1,InvalidHost=2,Disconnected=3,ServerShutdown=4,ServerProtocolMismatch=5,ConfigurationFailed=6,RpcError=7;DebuggerExceptionBreakMode:Never=0,Always=1,Unhandled=2;DebuggerFrameType:C=0,Lua=1;DebuggerPauseReason:Unknown=0,Requested=1,Breakpoint=2,Exception=3,SingleStep=4,Entrypoint=5;DebuggerResumeType:StepInto=0,StepOut=1,StepOver=2,Resume=3;DebuggerStatus:Success=0,Timeout=1,ConnectionLost=2,InvalidResponse=3,InternalError=4,InvalidState=5,RpcError=6,InvalidArgument=7,ConnectionClosed=8;DefaultScriptSyncFileType:Lua=0,Luau=1;DevCameraOcclusionMode:Zoom=0,Invisicam=1;DevComputerCameraMovementMode:UserChoice=0,Classic=1,Follow=2,Orbital=3,CameraToggle=4;DevComputerMovementMode:UserChoice=0,KeyboardMouse=1,ClickToMove=2,Scriptable=3;DevTouchCameraMovementMode:UserChoice=0,Classic=1,Follow=2,Orbital=3;DevTouchMovementMode:UserChoice=0,Thumbstick=1,DPad=2,Thumbpad=3,ClickToMove=4,Scriptable=5,DynamicThumbstick=6;DeveloperMemoryTag:Internal=0,HttpCache=1,Instances=2,Signals=3,LuaHeap=4,Script=5,PhysicsCollision=6,BaseParts=7,GraphicsSolidModels=8,GraphicsMeshParts=10,GraphicsParticles=11,GraphicsParts=12,GraphicsSpatialHash=13,GraphicsTerrain=14,GraphicsTexture=15,GraphicsTextureCharacter=16,Sounds=17,StreamingSounds=18,TerrainVoxels=19,Gui=21,Animation=22,Navigation=23,GeometryCSG=24,GraphicsSlimModels=25;DeviceFeatureType:DeviceCapture=0,InExperienceFAE=1;DeviceForm:Console=0,Phone=1,Tablet=2,Desktop=3,VR=4;DeviceLevel:Low=0,Medium=1,High=2;DeviceSimulatorScalingMode:ScaleToPhysicalSize=0,ActualResolution=1,FitToWindow=2;DeviceType:Unknown=0,Desktop=1,Tablet=2,Phone=3,TV=4;DialogBehaviorType:SinglePlayer=0,MultiplePlayers=1;DialogPurpose:Quest=0,Help=1,Shop=2;DialogTone:Neutral=0,Friendly=1,Enemy=2;DigitsRigDescriptionSide:None=0,Left=1,Right=2;DiscountType:Uncategorized=0;DisplayScalingMode:Default=0,Legacy=1,Responsive=2;DisplaySize:Small=0,Medium=1,Large=2;DistanceAttenuationMode:Custom=0,InverseTapered=1,Linear=2,LinearSquared=3,Inverse=4;DomainType:EXPERIENCE=1,OAUTH=3;DominantAxis:Width=0,Height=1;DraftStatusCode:OK=0,DraftOutdated=1,ScriptRemoved=2,DraftCommitted=3;DragDetectorDragStyle:TranslateLine=0,TranslatePlane=1,TranslatePlaneOrLine=2,TranslateLineOrPlane=3,TranslateViewPlane=4,RotateAxis=5,RotateTrackball=6,Scriptable=7,BestForDevice=8;DragDetectorPermissionPolicy:Nobody=0,Everybody=1,Scriptable=2;DragDetectorResponseStyle:Geometric=0,Physical=1,Custom=2;DraggerCoordinateSpace:Object=0,World=1;DraggerMovementMode:Geometric=0,Physical=1;DraggingScrollBar:None=0,Horizontal=1,Vertical=2;EasingDirection:In=0,Out=1,InOut=2;EasingStyle:Linear=0,Sine=1,Back=2,Quad=3,Quart=4,Quint=5,Bounce=6,Elastic=7,Exponential=8,Circular=9,Cubic=10;EditableStatus:Unknown=0,Allowed=1,Disallowed=2;ElasticBehavior:WhenScrollable=0,Always=1,Never=2;EmitterPositionType:Parent=0,Instance=1;EngagementLevel:Unknown=0,Inactive=1,Low=2,Medium=3,High=4;EngineFolder:Screenshots=0,Videos=1,Logs=2;EnviromentalPhysicsThrottle:DefaultAuto=0,Disabled=1,Always=2,Skip2=3,Skip4=4,Skip8=5,Skip16=6;ExperienceActivationStatus:Unknown=0,New=1,Active=2,Lapsed=3,Reactivated=4;ExperienceAuthScope:DefaultScope=0,CreatorAssetsCreate=1;ExperienceEventStatus:Active=0,Cancelled=1,Moderated=2,Unpublished=3,Unknown=4;ExperienceStateCaptureSelectionMode:Default=0,SafetyHighlightMode=1;ExperienceStateRecordingLoadMode:NewReplay=0,ContiguousSlice=1,NoncontiguousSlice=2;ExperienceStateRecordingLoadSourceType:S3Url=0,File=1;ExperienceStateRecordingPlaybackMode:Undefined=0,Stopped=1,Playing=2,Rewinding=3;ExplosionType:NoCraters=0,Craters=1;ExternalEditorMode:SystemDefault=0,UserSelectedEditor=1;FACSDataLod:LOD0=0,LOD1=1,LODCount=2;FacialAgeEstimationResultType:Complete=0,Cancel=1,Error=2;FacialAnimationStreamingState:None=0,Audio=1,Video=2,Place=4,Server=8;FacsActionUnit:ChinRaiserUpperLip=0,ChinRaiser=1,FlatPucker=2,Funneler=3,LowerLipSuck=4,LipPresser=5,LipsTogether=6,MouthLeft=7,MouthRight=8,Pucker=9,UpperLipSuck=10,LeftCheekPuff=11,LeftDimpler=12,LeftLipCornerDown=13,LeftLowerLipDepressor=14,LeftLipCornerPuller=15,LeftLipStretcher=16,LeftUpperLipRaiser=17,RightCheekPuff=18,RightDimpler=19,RightLipCornerDown=20,RightLowerLipDepressor=21,RightLipCornerPuller=22,RightLipStretcher=23,RightUpperLipRaiser=24,JawDrop=25,JawLeft=26,JawRight=27,Corrugator=28,LeftBrowLowerer=29,LeftOuterBrowRaiser=30,LeftNoseWrinkler=31,LeftInnerBrowRaiser=32,RightBrowLowerer=33,RightOuterBrowRaiser=34,RightInnerBrowRaiser=35,RightNoseWrinkler=36,EyesLookDown=37,EyesLookLeft=38,EyesLookUp=39,EyesLookRight=40,LeftCheekRaiser=41,LeftEyeUpperLidRaiser=42,LeftEyeClosed=43,RightCheekRaiser=44,RightEyeUpperLidRaiser=45,RightEyeClosed=46,TongueDown=47,TongueOut=48,TongueUp=49;FeatureRestrictionAbuseVector:ExperienceChat=0,Communication=1;FeedbackType:Feedback=0,PlayerSupport=1;FieldOfViewMode:Vertical=0,Diagonal=1,MaxAxis=2;FillDirection:Horizontal=0,Vertical=1;FilterErrorType:BackslashNotEscapingAnything=0,BadBespokeFilter=1,BadName=2,IncompleteOr=3,IncompleteParenthesis=4,InvalidDoubleStar=5,InvalidTilde=6,PropertyBadOperator=7,PropertyDoesNotExist=8,PropertyInvalidField=9,PropertyInvalidValue=10,PropertyUnsupportedFields=11,PropertyUnsupportedProperty=12,UnexpectedNameIndex=13,UnexpectedToken=14,UnfinishedBinaryOperator=15,UnfinishedQuote=16,UnknownBespokeFilter=17,WildcardInProperty=18;FilterResult:Accepted=0,Rejected=1;FilterType:Exclude=0,Include=1;FinishRecordingOperation:Cancel=0,Commit=1,Append=2;FluidFidelity:Automatic=0,UseCollisionGeometry=1,UsePreciseGeometry=2;FluidForces:Default=0,Experimental=1;Font:Legacy=0,Arial=1,ArialBold=2,SourceSans=3,SourceSansBold=4,SourceSansLight=5,SourceSansItalic=6,Bodoni=7,Garamond=8,Cartoon=9,Code=10,Highway=11,SciFi=12,Arcade=13,Fantasy=14,Antique=15,SourceSansSemibold=16,Gotham=17,GothamMedium=18,GothamBold=19,GothamBlack=20,AmaticSC=21,Bangers=22,Creepster=23,DenkOne=24,Fondamento=25,FredokaOne=26,GrenzeGotisch=27,IndieFlower=28,JosefinSans=29,Jura=30,Kalam=31,LuckiestGuy=32,Merriweather=33,Michroma=34,Nunito=35,Oswald=36,PatrickHand=37,PermanentMarker=38,Roboto=39,RobotoCondensed=40,RobotoMono=41,Sarpanch=42,SpecialElite=43,TitilliumWeb=44,Ubuntu=45,BuilderSans=46,BuilderSansMedium=47,BuilderSansBold=48,BuilderSansExtraBold=49,Arimo=50,ArimoBold=51,Unknown=100;FontSize:Size8=0,Size9=1,Size10=2,Size11=3,Size12=4,Size14=5,Size18=6,Size24=7,Size36=8,Size48=9,Size28=10,Size32=11,Size42=12,Size60=13,Size96=14;FontStyle:Normal=0,Italic=1;FontWeight:Thin=100,ExtraLight=200,Light=300,Regular=400,Medium=500,SemiBold=600,Bold=700,ExtraBold=800,Heavy=900;ForceLimitMode:Magnitude=0,PerAxis=1;FormFactor:Symmetric=0,Brick=1,Plate=2,Custom=3;FrameStyle:Custom=0,ChatBlue=1,RobloxSquare=2,RobloxRound=3,ChatGreen=4,ChatRed=5,DropShadow=6;FramerateManagerMode:Automatic=0,On=1,Off=2;FriendRequestEvent:Issue=0,Revoke=1,Accept=2,Deny=3;FriendStatus:Unknown=0,NotFriend=1,Friend=2,FriendRequestSent=3,FriendRequestReceived=4;FrustumStreamingMode:Default=0,Enabled=1,Disabled=2,Automatic=3;FunctionalTestResult:Passed=0,Warning=1,Error=2;GameAvatarType:R6=0,R15=1,PlayerChoice=2;GamepadType:Unknown=0,PS4=1,PS5=2,XboxOne=3;GearGenreSetting:AllGenres=0,MatchingGenreOnly=1;GearType:MeleeWeapons=0,RangedWeapons=1,Explosives=2,PowerUps=3,NavigationEnhancers=4,MusicalInstruments=5,SocialItems=6,BuildingTools=7,Transport=8;GenerateMomentTextResult:Success=0,Pending=1,Failed=2,Filtered=3;Genre:All=0,TownAndCity=1,Fantasy=2,SciFi=3,Ninja=4,Scary=5,Pirate=6,Adventure=7,Sports=8,Funny=9,WildWest=10,War=11,SkatePark=12,Tutorial=13;GradientTileMode:Clamp=0,Repeat=1,Mirror=2;GradientType:Linear=0,Radial=1,Conical=2;GraphicsMode:Automatic=1,Direct3D11=2,OpenGL=4,Metal=5,Vulkan=6,NoGraphics=9;GraphicsOptimizationMode:Performance=0,Balanced=1,Quality=2;GroupMembershipStatus:None=0,Joined=1,JoinRequestPending=2,AlreadyMember=3;GuiState:Idle=0,Hover=1,Press=2,NonInteractable=3;GuiType:Core=0,Custom=1,PlayerNameplates=2,CustomBillboards=3,CoreBillboards=4;HandlesStyle:Resize=0,Movement=1;HapticEffectType:Custom=0,UIHover=1,UIClick=2,UINotification=3,GameplayExplosion=4,GameplayCollision=5;HashAlgorithm:Blake2b=0,Blake3=1,Md5=2,Sha1=3,Sha256=4;HighlightDepthMode:AlwaysOnTop=0,Occluded=1;HorizontalAlignment:Center=0,Left=1,Right=2;HoverAnimateSpeed:VerySlow=0,Slow=1,Medium=2,Fast=3,VeryFast=4;HttpCachePolicy:None=0,Full=1,DataOnly=2,Default=3,InternalRedirectRefresh=4;HttpCompression:None=0,Gzip=1;HttpContentType:ApplicationJson=0,ApplicationXml=1,ApplicationUrlEncoded=2,TextPlain=3,TextXml=4;HttpError:OK=0,InvalidUrl=1,DnsResolve=2,ConnectFail=3,OutOfMemory=4,TimedOut=5,TooManyRedirects=6,InvalidRedirect=7,NetFail=8,Aborted=9,SslConnectFail=10,SslVerificationFail=11,Unknown=12,ConnectionClosed=13,ServerProtocolError=14,CreatorEnvironmentsNotSupportedByService=15,InactivityTimeout=16,TooManyOutstandingRequests=17,InvalidRangeResponse=18;HttpRequestType:Default=0,MarketplaceService=2,Players=7,Chat=15,Avatar=16,Analytics=23,Localization=25;HumanoidCollisionType:OuterBox=0,InnerBox=1;HumanoidDisplayDistanceType:Viewer=0,Subject=1,None=2;HumanoidHealthDisplayType:DisplayWhenDamaged=0,AlwaysOn=1,AlwaysOff=2;HumanoidRigType:R6=0,R15=1;HumanoidStateType:FallingDown=0,Ragdoll=1,GettingUp=2,Jumping=3,Swimming=4,Freefall=5,Flying=6,Landed=7,Running=8,RunningNoPhysics=10,StrafingNoPhysics=11,Climbing=12,Seated=13,PlatformStanding=14,Dead=15,Physics=16,None=18;IKCollisionsMode:NoCollisions=0,OtherMechanismsAnchored=1,IncludeContactedMechanisms=2;IKControlConstraintSupport:Default=0,Disabled=1,Enabled=2;IKControlType:Transform=0,Position=1,Rotation=2,LookAt=3;IXPLoadingStatus:None=0,Pending=1,Initialized=2,ErrorInvalidUser=3,ErrorConnection=4,ErrorJsonParse=5,ErrorTimedOut=6;ImageAlphaType:Default=1,LockCanvasAlpha=2,LockCanvasColor=3;ImageCombineType:BlendSourceOver=1,Overwrite=2,Add=3,Multiply=4,AlphaBlend=5,NormalMapBlend=6,Subtract=7;InOut:Edge=0,Inset=1,Center=2;InfoType:Asset=0,Product=1,GamePass=2,Subscription=3,Bundle=4;InitialDockState:Top=0,Bottom=1,Left=2,Right=3,Float=4;InputActionType:Bool=0,Direction1D=1,Direction2D=2,Direction3D=3,ViewportPosition=4;InputBindingType:Automatic=0,Scriptable=1;InputSink:None=0,Activate=1,All=100;InputType:NoInput=0,Constant=12,Sin=13;InstanceFileSyncStatus:NotSynced=0,Errored=1,SyncedAsRoot=2,SyncedAsDescendant=3,AncestorErrored=4;IntentReplicability:;IntermediateMeshGenerationResult:HighQualityMesh=0;InternalVideoUsage:Default=0,WatchPage=1,HomeCarousel=2,FeatureTileAd=3;InterpolationThrottlingMode:Default=0,Disabled=1,Enabled=2;InviteState:Placed=0,Accepted=1,Declined=2,Missed=3;ItemLineAlignment:Automatic=0,Start=1,Center=2,End=3,Stretch=4;JoinSource:CreatedItemAttribution=1;JointCreationMode:All=0,Surface=1,None=2;KeyCode:None=0,Backspace=8,Tab=9,Clear=12,Return=13,Pause=19,Escape=27,Space=32,QuotedDouble=34,Hash=35,Dollar=36,Percent=37,Ampersand=38,Quote=39,LeftParenthesis=40,RightParenthesis=41,Asterisk=42,Plus=43,Comma=44,Minus=45,Period=46,Slash=47,Zero=48,One=49,Two=50,Three=51,Four=52,Five=53,Six=54,Seven=55,Eight=56,Nine=57,Colon=58,Semicolon=59,LessThan=60,Equals=61,GreaterThan=62,Question=63,At=64,LeftBracket=91,BackSlash=92,RightBracket=93,Caret=94,Underscore=95,Backquote=96,A=97,B=98,C=99,D=100,E=101,F=102,G=103,H=104,I=105,J=106,K=107,L=108,M=109,N=110,O=111,P=112,Q=113,R=114,S=115,T=116,U=117,V=118,W=119,X=120,Y=121,Z=122,LeftCurly=123,Pipe=124,RightCurly=125,Tilde=126,Delete=127,World0=160,World1=161,World2=162,World3=163,World4=164,World5=165,World6=166,World7=167,World8=168,World9=169,World10=170,World11=171,World12=172,World13=173,World14=174,World15=175,World16=176,World17=177,World18=178,World19=179,World20=180,World21=181,World22=182,World23=183,World24=184,World25=185,World26=186,World27=187,World28=188,World29=189,World30=190,World31=191,World32=192,World33=193,World34=194,World35=195,World36=196,World37=197,World38=198,World39=199,World40=200,World41=201,World42=202,World43=203,World44=204,World45=205,World46=206,World47=207,World48=208,World49=209,World50=210,World51=211,World52=212,World53=213,World54=214,World55=215,World56=216,World57=217,World58=218,World59=219,World60=220,World61=221,World62=222,World63=223,World64=224,World65=225,World66=226,World67=227,World68=228,World69=229,World70=230,World71=231,World72=232,World73=233,World74=234,World75=235,World76=236,World77=237,World78=238,World79=239,World80=240,World81=241,World82=242,World83=243,World84=244,World85=245,World86=246,World87=247,World88=248,World89=249,World90=250,World91=251,World92=252,World93=253,World94=254,World95=255,KeypadZero=256,KeypadOne=257,KeypadTwo=258,KeypadThree=259,KeypadFour=260,KeypadFive=261,KeypadSix=262,KeypadSeven=263,KeypadEight=264,KeypadNine=265,KeypadPeriod=266,KeypadDivide=267,KeypadMultiply=268,KeypadMinus=269,KeypadPlus=270,KeypadEnter=271,KeypadEquals=272,Up=273,Down=274,Right=275,Left=276,Insert=277,Home=278,End=279,PageUp=280,PageDown=281,F1=282,F2=283,F3=284,F4=285,F5=286,F6=287,F7=288,F8=289,F9=290,F10=291,F11=292,F12=293,F13=294,F14=295,F15=296,NumLock=300,CapsLock=301,ScrollLock=302,RightShift=303,LeftShift=304,RightControl=305,LeftControl=306,RightAlt=307,LeftAlt=308,RightMeta=309,LeftMeta=310,LeftSuper=311,RightSuper=312,Mode=313,Compose=314,Help=315,Print=316,SysReq=317,Break=318,Menu=319,Power=320,Euro=321,Undo=322,ButtonX=1000,ButtonY=1001,ButtonA=1002,ButtonB=1003,ButtonR1=1004,ButtonL1=1005,ButtonR2=1006,ButtonL2=1007,ButtonR3=1008,ButtonL3=1009,ButtonStart=1010,ButtonSelect=1011,DPadLeft=1012,DPadRight=1013,DPadUp=1014,DPadDown=1015,Thumbstick1=1016,Thumbstick2=1017,Thumbstick1Up=1018,Thumbstick1Down=1019,Thumbstick1Left=1020,Thumbstick1Right=1021,Thumbstick2Up=1022,Thumbstick2Down=1023,Thumbstick2Left=1024,Thumbstick2Right=1025,MouseLeftButton=1026,MouseRightButton=1027,MouseMiddleButton=1028,MouseBackButton=1029,MouseNoButton=1030,MouseX=1031,MouseY=1032,MousePosition=1033,TouchPosition=1034,MouseWheel=1035,TrackpadPan=1040,TrackpadPinch=1045,MouseDelta=1048,TouchDelta=1049,TouchPinch=1050,ButtonCenter=1051,ButtonBack=1052,ButtonUp=1053,ButtonDown=1054,ButtonLeft=1055,ButtonRight=1056;KeyCodeStringFormat:Default=0,Abbreviated=1;KeyInterpolationMode:Constant=0,Linear=1,Cubic=2;KeywordFilterType:Include=0,Exclude=1;KnownWindow:Main=0;Language:Default=0;LeftRight:Left=0,Center=1,Right=2;LexemeType:Eof=0,Name=1,QuotedString=2,Number=3,And=4,Or=5,Equal=6,TildeEqual=7,GreaterThan=8,GreaterThanEqual=9,LessThan=10,LessThanEqual=11,Colon=12,Dot=13,LeftParenthesis=14,RightParenthesis=15,Star=16,DoubleStar=17,ReservedSpecial=18;LightingStyle:Realistic=0,Soft=1;Limb:Head=0,Torso=1,LeftArm=2,RightArm=3,LeftLeg=4,RightLeg=5,Unknown=6;LineJoinMode:Round=0,Bevel=1,Miter=2;ListDisplayMode:Horizontal=0,Vertical=1;ListenerLocation:Default=0,None=1,Character=2,Camera=3;ListenerPositionType:Parent=0,Instance=1;ListenerType:Camera=0,CFrame=1,ObjectPosition=2,ObjectCFrame=3;LiveEditingAtomicUpdateResponse:Success=0,FailureGuidNotFound=1,FailureHashMismatch=2,FailureOperationIllegal=3;LiveEditingBroadcastMessageType:Normal=0,Warning=1,Error=2;LoadCharacterLayeredClothing:Default=0,Disabled=1,Enabled=2;LoadDynamicHeads:Default=0,Disabled=1,Enabled=2;LocationType:Character=0,Camera=1,ObjectPosition=2;LuauTypeCheckMode:Default=0,NoCheck=1,Nonstrict=2,Strict=3;MakeupType:Face=0,Lip=1,Eye=2;MarketplaceBulkPurchasePromptStatus:Completed=1,Aborted=2,Error=3;MarketplaceItemPurchaseStatus:Success=1,SystemError=2,AlreadyOwned=3,InsufficientRobux=4,QuantityLimitExceeded=5,QuotaExceeded=6,NotForSale=7,NotAvailableForPurchaser=8,PriceMismatch=9,SoldOut=10,PurchaserIsSeller=11,InsufficientMembership=12,PlaceInvalid=13;MarketplaceProductType:AvatarAsset=1,AvatarBundle=2;MarkupKind:PlainText=0,Markdown=1;MatchmakingType:Default=1,XboxOnly=2,PlayStationOnly=3;Material:Plastic=256,SmoothPlastic=272,Neon=288,Wood=512,WoodPlanks=528,Marble=784,Basalt=788,Slate=800,CrackedLava=804,Concrete=816,Limestone=820,Granite=832,Pavement=836,Brick=848,Pebble=864,Cobblestone=880,Rock=896,Sandstone=912,CorrodedMetal=1040,DiamondPlate=1056,Foil=1072,Metal=1088,Grass=1280,LeafyGrass=1284,Sand=1296,Fabric=1312,Snow=1328,Mud=1344,Ground=1360,Asphalt=1376,Salt=1392,Ice=1536,Glacier=1552,Glass=1568,ForceField=1584,Air=1792,Water=2048,Cardboard=2304,Carpet=2305,CeramicTiles=2306,ClayRoofTiles=2307,RoofShingles=2308,Leather=2309,Plaster=2310,Rubber=2311;MaterialPattern:Regular=0,Organic=1;MembershipType:None=0,BuildersClub=1,TurboBuildersClub=2,OutrageousBuildersClub=3,Premium=4;MergeResolution:None=0,UseSource=1,UseTarget=2,Manual=3;MergeStatus:None=0,Loading=1,Merging=2;MeshAttribute:Vertex=0,Normal=1,Color=2,UV=3,Face=4;MeshPartDetailLevel:DistanceBased=0,Level00=1,Level01=2,Level02=3,Level03=4,Level04=5,Level05=6,Level06=7,Level07=8,Level08=9,Level09=10;MeshPartHeadsAndAccessories:Default=0,Disabled=1,Enabled=2;MeshScaleUnit:Stud=0,Meter=1,CM=2,MM=3,Foot=4,Inch=5;MeshType:Head=0,Torso=1,Wedge=2,Sphere=3,Cylinder=4,FileMesh=5,Brick=6,Prism=7,Pyramid=8,ParallelRamp=9,RightAngleRamp=10,CornerWedge=11;MessageType:MessageOutput=0,MessageInfo=1,MessageWarning=2,MessageError=3;ModelLevelOfDetail:Automatic=0,StreamingMesh=1,Disabled=2,SLIM=4;ModelStreamingBehavior:Default=0,Legacy=1,Improved=2;ModelStreamingMode:Default=0,Atomic=1,Persistent=2,PersistentPerPlayer=3,Nonatomic=4;ModerationResultCategory:ViolationDetected=0,Borderline=1,NoViolationDetected=2;ModerationResultLabel:ChildExploitation=0,SuicideSelfInjuryAndHarmfulBehavior=1,ThreatsBullyingAndHarassment=2,TerrorismAndViolentExtremism=3,DiscriminationSlursAndHateSpeech=4,RealWorldSensitiveEvents=5,ViolentContentAndGore=6,RomanticAndSexualContent=7,IllegalAndRegulatedGoodsAndActivities=8,Profanity=9,Other=100;ModerationStatus:ReviewedApproved=1,ReviewedRejected=2,NotReviewed=3,NotApplicable=4,Invalid=5;ModifierKey:Shift=0,Ctrl=1,Alt=2,Meta=3;MouseBehavior:Default=0,LockCenter=1,LockCurrentPosition=2;MoveState:Stopped=0,Coasting=1,Pushing=2,Stopping=3,AirFree=4;MuteState:Unmuted=0,Muted=1;NameOcclusion:NoOcclusion=0,EnemyOcclusion=1,OccludeAll=2;NegateOperationHiddenHistory:None=0,NegatedUnion=1,NegatedIntersection=2;NetworkOwnership:Automatic=0,Manual=1,OnContact=2;NetworkStatus:Unknown=0,Connected=1,Disconnected=2;NoiseType:SimplexGabor=0;NormalId:Right=0,Top=1,Back=2,Left=3,Bottom=4,Front=5;NotificationButtonType:Primary=0,Secondary=1;OperationType:Null=0,Union=1,Subtraction=2,Intersection=3,Primitive=4;OrientationAlignmentMode:OneAttachment=0,TwoAttachment=1;OutfitSource:All=1,Created=2,Purchased=3;OutfitType:All=1,Avatar=2,DynamicHead=3,Shoes=4,Makeup=5;OutputLayoutMode:Horizontal=0,Vertical=1;OverrideMouseIconBehavior:None=0,ForceShow=1,ForceHide=2;PackagePermission:None=0,NoAccess=1,Revoked=2,UseView=3,Edit=4,Own=5;PageMilestoneType:Interactive=0,SurfaceMounted=1,FunctionallyReady=2,SurfaceReady=3;PageType:AvatarEditor=0,Party=1,ExperienceDetail=2,AvatarMarketplace=3;PartType:Ball=0,Block=1,Cylinder=2,Wedge=3,CornerWedge=4;ParticleEmitterShape:Box=0,Sphere=1,Cylinder=2,Disc=3;ParticleEmitterShapeInOut:Outward=0,Inward=1,InAndOut=2;ParticleEmitterShapeStyle:Volume=0,Surface=1;ParticleFlipbookLayout:None=0,Grid2x2=1,Grid4x4=2,Grid8x8=3,Custom=4;ParticleFlipbookMode:Loop=0,OneShot=1,PingPong=2,Random=3;ParticleFlipbookTextureCompatible:NotCompatible=0,Compatible=1,Unknown=2;ParticleOrientation:FacingCamera=0,FacingCameraWorldUp=1,VelocityParallel=2,VelocityPerpendicular=3;PathStatus:Success=0,ClosestNoPath=1,ClosestOutOfRange=2,FailStartNotEmpty=3,FailFinishNotEmpty=4,NoPath=5;PathWaypointAction:Walk=0,Jump=1,Custom=2;PathfindingUseImprovedSearch:Default=0,Disabled=1,Enabled=2;PeoplePageLayout:Card=0,List=1;PerformanceOverlayMode:Overdraw=0,Transparent=1,Decals=2,Lights=3;PermissionLevelShown:Game=0,RobloxGame=1,RobloxScript=2,Studio=3,Roblox=4;PhysicalConstraintType:AnimationConstraint=0,Motor6D=1;PhysicsSimulationRate:Fixed240Hz=0,Fixed120Hz=1,Fixed60Hz=2;PhysicsSteppingMethod:Default=0,Fixed=1,Adaptive=2;PinExperienceStatus:Success=0,Failure=1,AlreadyExists=2;PioneerSource:Roblox=0,DaveyBazooka=1,Oof=2;PlaceContentPreference:None=0,All=1,MentionsAndReplies=2,Unknown=3;PlacePublishType:None=0,Publish=1,Save=2;Platform:Windows=0,OSX=1,IOS=2,Android=3,XBoxOne=4,PS4=5,PS3=6,XBox360=7,WiiU=8,NX=9,Ouya=10,AndroidTV=11,Chromecast=12,Linux=13,SteamOS=14,WebOS=15,DOS=16,BeOS=17,UWP=18,PS5=19,MetaOS=20,Web=21,None=22;PlaybackState:Begin=0,Delayed=1,Playing=2,Paused=3,Completed=4,Cancelled=5;PlayerActions:CharacterForward=0,CharacterBackward=1,CharacterLeft=2,CharacterRight=3,CharacterJump=4;PlayerCharacterDestroyBehavior:Default=0,Disabled=1,Enabled=2;PlayerChatType:All=0,Team=1,Whisper=2;PlayerDataErrorState:LoadFailed=0,FlushFailed=1,ReleaseFailed=2,None=3;PlayerDataLoadFailureBehavior:Failure=0,FallbackToDefault=1,Kick=2;PlayerExitReason:Unknown=0,PlatformKick=1,CreatorKick=2;PlayerPlatformActivationStatus:Unknown=0,New=1,Active=2,Lapsed=3,Reactivated=4;PlayerPlatformSpenderStatus:Unknown=0,Active=1,OtherPayer=2;PluginConnectionTargetType:Edit=0,Test=1;PoseEasingDirection:In=0,Out=1,InOut=2;PoseEasingStyle:Linear=0,Constant=1,Elastic=2,Cubic=3,Bounce=4,CubicV2=5;PositionAlignmentMode:OneAttachment=0,TwoAttachment=1;PredictionMode:Automatic=0,On=1,Off=2;PredictionStatus:Authoritative=0,Predicted=1,None=2;PredictiveStreamingMode:Default=0,Enabled=1,Disabled=2;PreferredInput:KeyboardAndMouse=0,Gamepad=1,Touch=2,MicroGamepad=3;PreferredTextSize:Medium=1,Large=2,Larger=3,Largest=4;PrefetchDownloadStatus:NotStarted=0,InProgress=1,Completed=2,Failed=3;PrimalPhysicsSolver:Default=0,Experimental=1,Disabled=2;PrimitiveType:Null=0,Ball=1,Cylinder=2,Block=3,Wedge=4,CornerWedge=5;PrivilegeType:Banned=0,Visitor=10,Member=128,Admin=240,Owner=255;ProductLocationRestriction:AvatarShop=0,AllowedGames=1,AllGames=2;ProductPurchaseChannel:InExperience=1,ExperienceDetailsPage=2,AdReward=3,CommerceProduct=4;ProductPurchaseDecision:NotProcessedYet=0,PurchaseGranted=1;PromptCreateAssetResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,UnknownFailure=6,UGCValidationFailed=7,ModeratedName=8,PurchaseFailure=9,TokenInvalid=10;PromptCreateAvatarResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,InvalidHumanoidDescription=6,UGCValidationFailed=7,ModeratedName=8,MaxOutfits=9,PurchaseFailure=10,UnknownFailure=11,TokenInvalid=12;PromptCreateOutfitResult:Success=1,PartialSuccess=2,CreationFailure=3,PermissionDenied=4,Timeout=5,NoUserInput=6,UnknownFailure=7,UGCValidationFailed=8;PromptCreatePlatformContentResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,UnknownFailure=6,UGCValidationFailed=7,ModeratedName=8,PurchaseFailure=9,TokenInvalid=10;PromptExperienceDetailsResult:PromptClosed=0,TeleportAttempted=1;PromptLinkSharingResult:Success=1,PlayerLeft=2,InvalidLaunchData=3;PromptPublishAssetResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,UnknownFailure=6;PropertyStatus:Ok=0,Warning=1,Error=2;ProximityPromptExclusivity:OnePerButton=0,OneGlobally=1,AlwaysShow=2;ProximityPromptInputType:Keyboard=0,Gamepad=1,Touch=2;ProximityPromptStyle:Default=0,Custom=1;PurchaseOption:TimedOption=1,Permanent=2;QualityLevel:Automatic=0,Level01=1,Level02=2,Level03=3,Level04=4,Level05=5,Level06=6,Level07=7,Level08=8,Level09=9,Level10=10,Level11=11,Level12=12,Level13=13,Level14=14,Level15=15,Level16=16,Level17=17,Level18=18,Level19=19,Level20=20,Level21=21;QueueDecision:Commit=0,Defer=1;R15CollisionType:OuterBox=0,InnerBox=1;RaycastFilterType:Exclude=0,Include=1;ReadCapturesFromGalleryResult:Success=0,NeedPermission=1;ReceiptDecision:NotProcessedYet=0,Processed=1;ReceiptType:DeveloperProduct=0,RobuxTransferSender=1,RobuxTransferReceiver=2;RecommendationActionType:AddReaction=0,RemoveReaction=1,Share=2,Report=3,Comment=4,Play=5,Purchase=6;RecommendationDepartureIntent:Neutral=0,Positive=1,Negative=2;RecommendationImpressionType:View=0,NotViewable=1;RecommendationItemContentType:Static=0,Dynamic=1,Interactive=2;RecommendationItemVisibility:Private=0,Public=1;RecommendationPreferenceTargetType:User=0,Universe=1,CustomTag=2;RecommendationPreferenceType:AddFollow=0,RemoveFollow=1,AddMute=2,RemoveMute=3;RejectCharacterDeletions:Default=0,Disabled=1,Enabled=2;RenderFidelity:Automatic=0,Precise=1,Performance=2;RenderPriority:First=0,Input=100,Camera=200,Character=300,Last=2000;RenderingCacheOptimizationMode:Default=0,Disabled=1,Enabled=2;RenderingTestComparisonMethod:psnr=0,diff=1;ReplicateInstanceDestroySetting:Default=0,Disabled=1,Enabled=2;ResamplerMode:Default=0,Pixelated=1;ReservedHighlightId:Standard=0,Active=131072,Hover=262144,Selection=524288,NegatedPart=1048576;RestPose:Default=0,RotationsReset=1,Custom=2;RestPoseModel:FromRigInACE=0,FromRigInFile=1,FromRigInFileZeroedRotations=2,FromCustomClip=3;ReturnKeyType:Default=0,Done=1,Go=2,Next=3,Search=4,Send=5;ReverbType:NoReverb=0,GenericReverb=1,PaddedCell=2,Room=3,Bathroom=4,LivingRoom=5,StoneRoom=6,Auditorium=7,ConcertHall=8,Cave=9,Arena=10,Hangar=11,CarpettedHallway=12,Hallway=13,StoneCorridor=14,Alley=15,Forest=16,City=17,Mountains=18,Quarry=19,Plain=20,ParkingLot=21,SewerPipe=22,UnderWater=23;ReviewableContentState:Pending=0,Completed=1,Failed=2;RibbonTool:Select=0,Scale=1,Rotate=2,Move=3,Transform=4,ColorPicker=5,MaterialPicker=6,Group=7,Ungroup=8,None=9,PivotEditor=10;RigLabel:Invalid=0,Root=2,LeftHip=3,LeftKnee=4,LeftAnkle=5,RightHip=7,RightKnee=8,RightAnkle=9,Waist=11,LeftShoulder=12,LeftElbow=13,LeftWrist=14,RightShoulder=16,RightElbow=17,RightWrist=18,Neck=20,Spine=23,Chest=24,HeadBase=25,LeftClavicle=26,RightClavicle=27,LeftToeBase=28,RightToeBase=29,Thumb1=30,Thumb2=31,Thumb3=32,Index1=33,Index2=34,Index3=35,Middle1=36,Middle2=37,Middle3=38,Ring1=39,Ring2=40,Ring3=41,Pinky1=42,Pinky2=43,Pinky3=44;RigScale:Default=0,Rthro=1,RthroNarrow=2;RigType:R15=0,CustomHumanoid=1,Custom=2,None=3;RollOffMode:Inverse=0,Linear=1,LinearSquare=2,InverseTapered=3;RolloutState:Default=0,Disabled=1,Enabled=2;RotationOrder:XYZ=0,XZY=1,YZX=2,YXZ=3,ZXY=4,ZYX=5;RotationType:MovementRelative=0,CameraRelative=1;RsvpStatus:None=0,Going=1,NotGoing=2;RtlTextSupport:Default=0,Disabled=1,Enabled=2;RunContext:Legacy=0,Server=1,Client=2,Plugin=3;RunState:Stopped=0,Running=1,Paused=2;RuntimeUndoBehavior:Aggregate=0,Snapshot=1,Hybrid=2;SafeAreaCompatibility:None=0,FullscreenExtension=1;SalesTypeFilter:All=1,Collectibles=2,Premium=3,TimedOptions=4;SandboxedInstanceMode:Default=0,Experimental=1;SaveAvatarThumbnailCustomizationFailure:BadThumbnailType=1,BadYRotDeg=2,BadFieldOfViewDeg=3,BadDistanceScale=4,Other=5,Throttled=6;SaveFilter:SaveWorld=0,SaveGame=1,SaveAll=2;SavedQualitySetting:Automatic=0,QualityLevel1=1,QualityLevel2=2,QualityLevel3=3,QualityLevel4=4,QualityLevel5=5,QualityLevel6=6,QualityLevel7=7,QualityLevel8=8,QualityLevel9=9,QualityLevel10=10;ScaleType:Stretch=0,Slice=1,Tile=2,Fit=3,Crop=4;ScopeCheckResult:ConsentAccepted=0,InvalidScopes=1,Timeout=2,NoUserInput=3,BackendError=4,UnexpectedError=5,InvalidArgument=6,ConsentDenied=7;ScreenInsets:None=0,DeviceSafeInsets=1,CoreUISafeInsets=2,TopbarSafeInsets=3;ScreenOrientation:LandscapeLeft=0,LandscapeRight=1,LandscapeSensor=2,Portrait=3,Sensor=4;ScreenshotCaptureResult:Success=0,OtherError=1,NoDeviceSupport=2,NoSpaceOnDevice=3;ScriptScannerUpdateType:Init=0,Added=1,Removed=2;ScriptStoppedReason:Breakpoint=0,Exception=1,Pause=2,Step=3,Entry=4;ScriptVariableScope:Local=0,Upvalue=1,Global=2;ScrollBarInset:None=0,ScrollBar=1,Always=2;ScrollState:Idle=0,Scrolling=1;ScrollingDirection:X=1,Y=2,XY=4;SecurityCapability:RunClientScript=0,RunServerScript=1,AccessOutsideWrite=2,AssetRequire=3,LoadString=4,ScriptGlobals=5,CreateInstances=6,Basic=7,Audio=8,DataStore=9,Network=10,Physics=11,UI=12,CSG=13,Chat=14,Animation=15,Avatar=16,Input=17,Environment=18,RemoteEvent=19,LegacySound=20,Players=21,CapabilityControl=22,Plugin=23,LocalUser=24,WritePlayer=25,RobloxScript=26,RobloxEngine=27,Unassigned=28,InternalTest=29,PluginOrOpenCloud=30,Assistant=31,RemoteCommand=32,AssetRead=33,AssetManagement=34,DynamicGeneration=35,PlatformAvatarEditing=36,AssetCreateUpdate=37,Capture=38,SensitiveInput=39,Monetization=40,LoadOwnedAsset=41,Social=42,ServerCommunication=43,Logging=44,PromptExternalPurchase=45,Groups=46,Teleport=47,Consequences=48,Material=49,AvatarBehavior=50,AvatarAppearance=51,LoadUnownedAsset=52;SelectionBehavior:Escape=0,Stop=1;SelectionRenderMode:Outlines=0,BoundingBoxes=1,Both=2;SelfViewPosition:LastPosition=0,TopLeft=1,TopRight=2,BottomLeft=3,BottomRight=4;SensorMode:Floor=0,Ladder=1,ClassicFloor=2,ClassicLadder=3;SensorUpdateType:OnRead=0,Manual=1;ServerLiveEditingMode:Uninitialized=0,Enabled=1,Disabled=2;ServiceVisibility:Always=0,Off=1,WithChildren=2;Severity:Error=1,Warning=2,Information=3,Hint=4;ShowAdResult:ShowCompleted=1,AdNotReady=2,AdAlreadyShowing=3,InternalError=4,ShowInterrupted=5,InsufficientMemory=6;SignalBehavior:Default=0,Immediate=1,Deferred=2,AncestryDeferred=3;SimulationMode:Default=0,Enabled=1,Disabled=2;SizeConstraint:RelativeXY=0,RelativeXX=1,RelativeYY=2;SlimTintMode:None=0,LevelOfDetail=1,Meshes=2,MeshResourcePtr=3,ContentId=4,DataModelState=5,TranscoderStatus=6;SlimTranscoderStatus:Unknown=0,Transcoding=1,Succeeded=2,Failed=3;SlimViewContext:Player=0,Editor=1,ImGui=2;SolverConvergenceMetricType:IterationBased=0,AlgorithmAgnostic=1;SolverConvergenceVisualizationMode:Disabled=0,PerIsland=1,PerEdge=2;SortDirection:Ascending=0,Descending=1;SortOrder:Name=0,Custom=1,LayoutOrder=2;SpecialKey:Insert=0,Home=1,End=2,PageUp=3,PageDown=4,ChatHotkey=5;StartCorner:TopLeft=0,TopRight=1,BottomLeft=2,BottomRight=3;StateObjectFieldType:Boolean=0,CFrame=1,Color3=2,Float=3,Instance=4,Random=5,Vector2=6,Vector3=7,INVALID=8;StateReferenceFrame:CurrentState=0,PreviousState=1,LastObservedState=2;Status:Poison=0,Confusion=1;StepFrequency:Hz60=0,Hz30=1,Hz15=2,Hz10=3,Hz5=4,Hz1=5;StreamOutBehavior:Default=0,LowMemory=1,Opportunistic=2;StreamingIntegrityMode:Default=0,Disabled=1,MinimumRadiusPause=2,PauseOutsideLoadedArea=3;StreamingPauseMode:Default=0,Disabled=1,ClientPhysicsPause=2;StrokeSizingMode:FixedSize=0,ScaledSize=1;StudioAction:Undo=0,Redo=1,SelectAll=2,DeleteSelected=3,DuplicateSelection=4,ClearSelection=5,ZoomExtents=6,Copy=61,Cut=62,Paste=63;StudioCaptureBufferStatus:NotStarted=0,Pending=1,Ready=2,Error=3;StudioCaptureScreenshotFormat:RGBA8=0,PNG=1;StudioCloseMode:None=0,CloseStudio=1,CloseDoc=2,LogOut=3;StudioDataModelType:Edit=0,PlayClient=1,PlayServer=2,Standalone=3,None=4;StudioPlaceUpdateFailureReason:Other=0,TeamCreateConflict=1;StudioScriptEditorColorCategories:Default=0,Operator=1,Number=2,String=3,Comment=4,Keyword=5,Builtin=6,Method=7,Property=8,Nil=9,Bool=10,Function=11,Local=12,Self=13,LuauKeyword=14,FunctionName=15,TODO=16,Background=17,SelectionText=18,SelectionBackground=19,FindSelectionBackground=20,MatchingWordBackground=21,Warning=22,Error=23,Info=24,Hint=25,Whitespace=26,ActiveLine=27,DebuggerCurrentLine=28,DebuggerErrorLine=29,Ruler=30,Bracket=31,Type=32,MenuPrimaryText=33,MenuSecondaryText=34,MenuSelectedText=35,MenuBackground=36,MenuSelectedBackground=37,MenuScrollbarBackground=38,MenuScrollbarHandle=39,MenuBorder=40,DocViewCodeBackground=41,AICOOverlayText=42,AICOOverlayButtonBackground=43,AICOOverlayButtonBackgroundHover=44,AICOOverlayButtonBackgroundPressed=45,IndentationRuler=46,ReviewableChangeAddedText=47,ReviewableChangeRemovedText=48;StudioScriptEditorColorPresets:RobloxDefault=0,Extra1=1,Extra2=2,Custom=3;StudioStyleGuideColor:MainBackground=0,Titlebar=1,Dropdown=2,Tooltip=3,Notification=4,ScrollBar=5,ScrollBarBackground=6,TabBar=7,Tab=8,FilterButtonDefault=9,FilterButtonHover=10,FilterButtonChecked=11,FilterButtonAccent=12,FilterButtonBorder=13,FilterButtonBorderAlt=14,RibbonTab=15,RibbonTabTopBar=16,Button=17,MainButton=18,RibbonButton=19,ViewPortBackground=20,InputFieldBackground=21,Item=22,TableItem=23,CategoryItem=24,GameSettingsTableItem=25,GameSettingsTooltip=26,EmulatorBar=27,EmulatorDropDown=28,ColorPickerFrame=29,CurrentMarker=30,Border=31,DropShadow=32,Shadow=33,Light=34,Dark=35,Mid=36,MainText=37,SubText=38,TitlebarText=39,BrightText=40,DimmedText=41,LinkText=42,WarningText=43,ErrorText=44,InfoText=45,SensitiveText=46,ScriptSideWidget=47,ScriptBackground=48,ScriptText=49,ScriptSelectionText=50,ScriptSelectionBackground=51,ScriptFindSelectionBackground=52,ScriptMatchingWordSelectionBackground=53,ScriptOperator=54,ScriptNumber=55,ScriptString=56,ScriptComment=57,ScriptKeyword=58,ScriptBuiltInFunction=59,ScriptWarning=60,ScriptError=61,ScriptInformation=62,ScriptHint=63,ScriptWhitespace=64,ScriptRuler=65,DocViewCodeBackground=66,DebuggerCurrentLine=67,DebuggerErrorLine=68,DiffFilePathText=69,DiffTextHunkInfo=70,DiffTextNoChange=71,DiffTextAddition=72,DiffTextDeletion=73,DiffTextSeparatorBackground=74,DiffTextNoChangeBackground=75,DiffTextAdditionBackground=76,DiffTextDeletionBackground=77,DiffLineNum=78,DiffLineNumSeparatorBackground=79,DiffLineNumNoChangeBackground=80,DiffLineNumAdditionBackground=81,DiffLineNumDeletionBackground=82,DiffFilePathBackground=83,DiffFilePathBorder=84,ChatIncomingBgColor=85,ChatIncomingTextColor=86,ChatOutgoingBgColor=87,ChatOutgoingTextColor=88,ChatModeratedMessageColor=89,Separator=90,ButtonBorder=91,ButtonText=92,InputFieldBorder=93,CheckedFieldBackground=94,CheckedFieldBorder=95,CheckedFieldIndicator=96,HeaderSection=97,Midlight=98,StatusBar=99,DialogButton=100,DialogButtonText=101,DialogButtonBorder=102,DialogMainButton=103,DialogMainButtonText=104,InfoBarWarningBackground=105,InfoBarWarningText=106,ScriptEditorCurrentLine=107,ScriptMethod=108,ScriptProperty=109,ScriptNil=110,ScriptBool=111,ScriptFunction=112,ScriptLocal=113,ScriptSelf=114,ScriptLuauKeyword=115,ScriptFunctionName=116,ScriptTodo=117,ScriptBracket=118,AttributeCog=119,AICOOverlayText=128,AICOOverlayButtonBackground=129,AICOOverlayButtonBackgroundHover=130,AICOOverlayButtonBackgroundPressed=131,OnboardingCover=132,OnboardingHighlight=133,OnboardingShadow=134,BreakpointMarker=136,DiffLineNumHover=137,DiffLineNumSeparatorBackgroundHover=138;StudioStyleGuideModifier:Default=0,Selected=1,Pressed=2,Disabled=3,Hover=4;Style:AlternatingSupports=0,BridgeStyleSupports=1,NoSupports=2;SubscriptionExpirationReason:ProductInactive=0,ProductDeleted=1,SubscriberCancelled=2,SubscriberRefunded=3,Lapsed=4;SubscriptionPaymentStatus:Paid=0,Refunded=1;SubscriptionPeriod:Month=0;SubscriptionState:NeverSubscribed=0,SubscribedWillRenew=1,SubscribedWillNotRenew=2,SubscribedRenewalPaymentPending=3,Expired=4;SurfaceConstraint:None=0,Hinge=1,SteppingMotor=2,Motor=3;SurfaceGuiShape:Flat=0,CurvedHorizontally=1;SurfaceGuiSizingMode:FixedSize=0,PixelsPerStud=1;SurfaceType:Smooth=0,Glue=1,Weld=2,Studs=3,Inlet=4,Universal=5,Hinge=6,Motor=7,SteppingMotor=8,SmoothNoOutlines=10;SwipeDirection:Right=0,Left=1,Up=2,Down=3,None=4;SystemThemeValue:error=0,light=1,dark=2,systemLight=3,systemDark=4;TableMajorAxis:RowMajor=0,ColumnMajor=1;TeamCreateErrorState:PlaceSizeTooLarge=0,PlaceSizeApproachingLimit=1,PlaceUploadFailing=2,NoError=3;Technology:Legacy=0,Voxel=1,Compatibility=2,ShadowMap=3,Future=4,Unified=5;TelemetryBackend:UNSPECIFIED=0,EventIngest=1,Points=2,Teletune=3,EphemeralCounter=4,EphemeralStat=5,Counter=6,Stat=7;TelemetryStandardizedField:AddDatacenterId=0,AddPlaceId=1,AddUniverseId=2,AddPlaceInstanceId=3,AddPlaySessionId=4,AddCurrentContextName=5,AddOsInfo=6,AddArchitectureInfo=7,AddCpuInfo=8,AddMemoryInfo=9,AddSessionInfo=10;TeleportMethod:TeleportToSpawnByName=0,TeleportToPlaceInstance=1,TeleportToPrivateServer=2,TeleportPartyAsync=3,TeleportToVIPServer=4,TeleportToInstanceBack=5,TeleportUnknown=6,Teleport=7;TeleportResult:Success=0,Failure=1,GameNotFound=2,GameEnded=3,GameFull=4,Unauthorized=5,Flooded=6,IsTeleporting=7;TeleportState:RequestedFromServer=0,Started=1,WaitingForServer=2,Failed=3,InProgress=4;TeleportType:ToPlace=0,ToInstance=1,ToReservedServer=2,ToVIPServer=3,ToInstanceBack=4;TerrainAcquisitionMethod:None=0,Legacy=1,Template=2,Generate=3,Import=4,Convert=5,EditAddTool=6,EditSeaLevelTool=7,EditReplaceTool=8,RegionFillTool=9,RegionPasteTool=10,Other=11;TerrainFace:Top=0,Side=1,Bottom=2;TerrainLiquidMergeOperation:None=0,Source=1,Union=2,Difference=3,Intersect=4;TerrainSolidMergeOperation:None=0,Paint=1,Source=2,Union=3,Dig=4,Difference=5,Intersect=6,Cut=7,Place=8;TextChannelDisplayMode:AllTextChannels=0,DefaultTextChannels=1;TextChatMessageStatus:Unknown=1,Success=2,Sending=3,TextFilterFailed=4,Floodchecked=5,InvalidPrivacySettings=6,InvalidTextChannelPermissions=7,MessageTooLong=8,ModerationTimeout=9;TextDirection:Auto=0,LeftToRight=1,RightToLeft=2;TextFilterContext:PublicChat=1,PrivateChat=2;TextInputType:Default=0,NoSuggestions=1,Number=2,Email=3,Phone=4,Password=5,PasswordShown=6,Username=7,OneTimePassword=8,NewPassword=9,NewPasswordShown=10;TextTruncate:None=0,AtEnd=1,SplitWord=2;TextXAlignment:Left=0,Right=1,Center=2;TextYAlignment:Top=0,Center=1,Bottom=2;TextureMode:Stretch=0,Wrap=1,Static=2;TextureQueryType:NonHumanoid=0,NonHumanoidOrphaned=1,Humanoid=2,HumanoidOrphaned=3;ThreadPoolConfig:Auto=0,Threads1=1,Threads2=2,Threads3=3,Threads4=4,Threads8=8,Threads16=16,PerCore1=101,PerCore2=102,PerCore3=103,PerCore4=104;ThrottlingPriority:Default=0,ElevatedOnServer=1,Extreme=2;ThumbnailSize:Size48x48=0,Size180x180=1,Size420x420=2,Size60x60=3,Size100x100=4,Size150x150=5,Size352x352=6;ThumbnailType:HeadShot=0,AvatarBust=1,AvatarThumbnail=2;TickCountSampleMethod:Fast=0,Benchmark=1,Precise=2;TitleBarControlsPosition:Unknown=0,Left=1,Right=2;TitleBarMode:Native=0,Custom=1;TonemapperPreset:Default=0,Retro=1;TopBottom:Top=0,Center=1,Bottom=2;TouchCameraMovementMode:Default=0,Classic=1,Follow=2,Orbital=3;TouchMovementMode:Default=0,Thumbstick=1,DPad=2,Thumbpad=3,ClickToMove=4,DynamicThumbstick=5;TrackerError:Ok=0,NoService=1,InitFailed=2,NoVideo=3,VideoError=4,VideoNoPermission=5,VideoUnsupported=6,NoAudio=7,AudioError=8,AudioNoPermission=9,UnsupportedDevice=10;TrackerExtrapolationFlagMode:ForceDisabled=0,ExtrapolateFacsAndPose=1,ExtrapolateFacsOnly=2,Auto=3;TrackerFaceTrackingStatus:FaceTrackingSuccess=0,FaceTrackingNoFaceFound=1,FaceTrackingUnknown=2,FaceTrackingLost=3,FaceTrackingHasTrackingError=4,FaceTrackingIsOccluded=5,FaceTrackingUninitialized=6;TrackerLodFlagMode:ForceFalse=0,ForceTrue=1,Auto=2;TrackerLodValueMode:Force0=0,Force1=1,Auto=2;TrackerMode:None=0,Audio=1,Video=2,AudioVideo=3;TrackerPromptEvent:LODCameraRecommendDisable=0;TrackerType:None=0,Face=1,UpperBody=2;TriStateBoolean:Unknown=0,True=1,False=2;TweenStatus:Canceled=0,Completed=1;UICaptureMode:All=0,None=1;UIDragDetectorBoundingBehavior:Automatic=0,EntireObject=1,HitPoint=2;UIDragDetectorDragRelativity:Absolute=0,Relative=1;UIDragDetectorDragSpace:Parent=0,LayerCollector=1,Reference=2;UIDragDetectorDragStyle:TranslatePlane=0,TranslateLine=1,Rotate=2,Scriptable=3;UIDragDetectorResponseStyle:Offset=0,Scale=1,CustomOffset=2,CustomScale=3;UIDragSpeedAxisMapping:XY=0,XX=1,YY=2;UIFlexAlignment:None=0,Fill=1,SpaceAround=2,SpaceBetween=3,SpaceEvenly=4;UIFlexMode:None=0,Grow=1,Shrink=2,Fill=3,Custom=4;UITheme:Light=0,Dark=1;UiMessageType:UiMessageError=0,UiMessageInfo=1;UpdateState:UpdateNotAvailable=0,UpdateAvailable=1,UpdateInProgress=2,UpdateReady=3,UpdateFailed=4;UploadCaptureResult:Success=0,NeedPermission=1,CaptureModerated=2,CaptureNotInGallery=3,IneligibleCapture=4,UploadQuotaReached=5,UploadPending=6,UploadFailed=7;UsageContext:Default=0,Preview=1;UserAcquisitionSource:Unknown=0,PendingAttribution=1,HomeRecommendation=2,ContinueToPlay=3,Curation=4,Friends=5,Search=6,Teleport=7,Ads=8,HomeOther=9,Other=10;UserCFrame:Head=0,LeftHand=1,RightHand=2,Floor=3;UserIdMode:Invalid=0,Global=1,Domain=2;UserInputState:Begin=0,Change=1,End=2,Cancel=3,None=4;UserInputType:MouseButton1=0,MouseButton2=1,MouseButton3=2,MouseWheel=3,MouseMovement=4,Touch=7,Keyboard=8,Focus=9,Accelerometer=10,Gyro=11,Gamepad1=12,Gamepad2=13,Gamepad3=14,Gamepad4=15,Gamepad5=16,Gamepad6=17,Gamepad7=18,Gamepad8=19,TextInput=20,InputMethod=21,None=22;UserNewReturningStatus:Unknown=0,New=1,Returning=2;UserReturnStatus:Unknown=0,New=1,Returning=2;VRComfortSetting:Comfort=0,Normal=1,Expert=2,Custom=3;VRControllerModelMode:Disabled=0,Transparent=1;VRDeviceType:Unknown=0,OculusRift=1,HTCVive=2,ValveIndex=3,OculusQuest=4;VRLaserPointerMode:Disabled=0,Pointer=1,DualPointer=2;VRSafetyBubbleMode:NoOne=0,OnlyFriends=1,Anyone=2;VRScaling:World=0,Off=1;VRSessionState:Undefined=0,Idle=1,Visible=2,Focused=3,Stopping=4;VRTouchpad:Left=0,Right=1;VRTouchpadMode:Touch=0,VirtualThumbstick=1,ABXY=2;VelocityConstraintMode:Line=0,Plane=1,Vector=2;VerifiedLevel:Low=0,High=1;VerticalAlignment:Center=0,Top=1,Bottom=2;VerticalScrollBarPosition:Right=0,Left=1;VibrationMotor:Large=0,Small=1,LeftTrigger=2,RightTrigger=3,LeftHand=4,RightHand=5;VideoCaptureResult:Success=0,OtherError=1,ScreenSizeChanged=2,TimeLimitReached=3;VideoCaptureStartedResult:Success=0,OtherError=1,CapturingAlready=2,NoDeviceSupport=3,NoSpaceOnDevice=4;VideoDeviceCaptureQuality:Default=0,Low=1,Medium=2,High=3;VideoError:Ok=0,Eof=1,EAgain=2,BadParameter=3,AllocFailed=4,CodecInitFailed=5,CodecCloseFailed=6,DecodeFailed=7,ParsingFailed=8,Unsupported=9,Generic=10,DownloadFailed=11,StreamNotFound=12,EncodeFailed=13,CreateFailed=14,NoPermission=15,NoService=16,ReleaseFailed=17,Unknown=18;VideoSampleSize:Small=0,Medium=1,Large=2,Full=3;ViewMode:None=0,GeometryComplexity=1,Transparent=2,Decal=3;VirtualCursorMode:Default=0,Disabled=1,Enabled=2;VirtualInputMode:None=0,Recording=1,Playing=2;VoiceChatDistanceAttenuationType:Inverse=0,Legacy=1;VoiceChatState:Idle=0,Joining=1,JoiningRetry=2,Joined=3,Leaving=4,Ended=5,Failed=6;VoiceClientLeaveReasons:Unknown=0,ClientNetworkDisconnected=1,PlayerLeft=2,ClientShutdown=3,PublishFailed=4,RejoinReceived=5,VoiceReboot=6,ImguiDebugLeave=7,LuaInitiated=8;VoiceControlPath:Publish=0,Subscribe=1,Join=2;VoiceRccReconnectReason:Unknown=0,Migration=1,CloseRoom=2,FAEUpdate=3,BlockListChanged=4;VolumetricAudio:Disabled=0,Automatic=1,Enabled=2;WaterDirection:NegX=0,X=1,NegY=2,Y=3,NegZ=4,Z=5;WaterForce:None=0,Small=1,Medium=2,Strong=3,Max=4;WebSocketState:Connecting=0,Open=1,Closing=2,Closed=3;WebStreamClientState:Connecting=0,Open=1,Error=2,Closed=3;WebStreamClientType:SSE=0,RawStream=1,WebSocket=2;WeldConstraintPreserve:All=0,None=1,Touching=2;WhenUserFirstPlayed:Unknown=0,Days0To30=1,Days31To90=2,Days91To180=3,Days181To365=4,Days366Plus=5;WhisperChatPrivacyMode:AllUsers=0,NoOne=1;WindSoundProfile:Turbulence=0,Whistle=1,Foliage=2;WindowState:Normal=0,Minimized=1,Maximized=2;WrapLayerAutoSkin:Disabled=0,EnabledPreserve=1,EnabledOverride=2;WrapLayerDebugMode:None=0,BoundCage=1,LayerCage=2,BoundCageAndLinks=3,Reference=4,Rbf=5,OuterCage=6,ReferenceMeshAfterMorph=7,HSROuterDetail=8,HSROuter=9,HSRInner=10,HSRInnerReverse=11,LayerCageFittedToBase=12,LayerCageFittedToPrev=13,PreWrapDeformerOuterCage=14,SkinningTransfer=15;WrapTargetDebugMode:None=0,TargetCageOriginal=1,TargetCageCompressed=2,TargetCageInterface=3,TargetLayerCageOriginal=4,TargetLayerCageCompressed=5,TargetLayerInterface=6,Rbf=7,OuterCageDetail=8,PreWrapDeformerCage=9;ZIndexBehavior:Global=0,Sibling=1",
	classes = "Object<|GetPropertyChangedSignal,IsA,isA|Changed|ClassName:string,className:string;AnimatedImageTrack<Object|GetContent,GetFrameNames||Duration:float,FrameCount:int,TrackName:string;AnimationNode<Object|||;Capture<Object|||CaptureTime:DateTime,CaptureType:CaptureType,FilePathString:string,LocalId:string,SourcePlaceId:int64,SourceUniverseId:int64;ScreenshotCapture<Capture|||;VideoCapture<Capture|||FilePath:string,TimeLength:double;ConfigSnapshot<Object|GetValue,GetValueChangedSignal,Refresh|UpdateAvailable|Error:ConfigSnapshotErrorState,Outdated:bool;DataModelDiff<Object|GetChangeType,GetIdentities,GetPropertyNames||;EditableImage<Object|Destroy,DrawCircle,DrawImage,DrawImageProjected,DrawImageTransformed,DrawLine,DrawRectangle,DrawTriangle,ReadPixelsBuffer,SampleImageProjected,WritePixelsBuffer||ImageData:BinaryString,ImageHolder:NetAssetRef,IsReplicatedCopy:bool,Size:Vector2;EditableMesh<Object|AddBone,AddColor,AddFace,AddNormal,AddTriangle,AddUV,AddVertex,BatchAdd,BatchGetFaceAttributes,BatchGetValues,BatchGetVertexAttributes,BatchGetVertexFaceAttributes,BatchRemove,BatchSetFaceAttributes,BatchSetValues,BatchSetVertexFaceAttributes,Clear,Destroy,FindClosestPointOnSurface,FindClosestVertex,FindVerticesWithinSphere,GetAdjacentFaces,GetAdjacentVertices,GetBoneByName,GetBoneCFrame,GetBoneIsVirtual,GetBoneName,GetBoneParent,GetBones,GetCenter,GetColor,GetColorAlpha,GetColors,GetFaceColors,GetFaceNormals,GetFaceUVs,GetFaceVertices,GetFaces,GetFacesWithAttribute,GetFacesWithColor,GetFacesWithNormal,GetFacesWithUV,GetFacsCorrectivePose,GetFacsCorrectivePoses,GetFacsPose,GetFacsPoses,GetNormal,GetNormals,GetPosition,GetSize,GetUV,GetUVs,GetVertexBoneWeights,GetVertexBones,GetVertexColors,GetVertexFaceColor,GetVertexFaceNormal,GetVertexFaceUV,GetVertexFaces,GetVertexNormals,GetVertexUVs,GetVertices,GetVerticesWithAttribute,GetVerticesWithColor,GetVerticesWithNormal,GetVerticesWithUV,IdDebugString,MergeVertices,RaycastLocal,RemoveBone,RemoveFace,RemoveUnused,ResetNormal,SetBoneCFrame,SetBoneIsVirtual,SetBoneName,SetBoneParent,SetColor,SetColorAlpha,SetFaceColors,SetFaceNormals,SetFaceUVs,SetFaceVertices,SetFacsBonePose,SetFacsCorrectivePose,SetFacsPose,SetNormal,SetPosition,SetUV,SetVertexBoneWeights,SetVertexBones,SetVertexFaceColor,SetVertexFaceNormal,SetVertexFaceUV,Triangulate||EditableMeshDataHolder:NetAssetRef,FixedSize:bool,IsReplicatedCopy:bool,MeshData:SharedString;ExecutedRemoteCommand<Object|RunMoreCode,SendUpdate,Stop|ReceivedUpdate|;Instance<Object|AddTag,ClearAllChildren,Clone,Destroy,FindFirstAncestor,FindFirstAncestorOfClass,FindFirstAncestorWhichIsA,FindFirstChild,FindFirstChildOfClass,FindFirstChildWhichIsA,FindFirstDescendant,GetActor,GetAttribute,GetAttributeChangedSignal,GetAttributes,GetChildren,GetDebugId,GetDescendants,GetFullName,GetStyled,GetStyledPropertyChangedSignal,GetTags,HasTag,IsAncestorOf,IsDescendantOf,IsPropertyModified,QueryDescendants,Remove,RemoveTag,ResetPropertyToDefault,SetAttribute,WaitForChild,children,clone,destroy,findFirstChild,getChildren,isDescendantOf,remove|AncestryChanged,AttributeChanged,ChildAdded,ChildRemoved,DescendantAdded,DescendantRemoving,Destroying,StyledPropertiesChanged,childAdded|Archivable:bool,Attributes:string,AttributesReplicate:string,AttributesSerialize:BinaryString,Capabilities:SecurityCapabilities,DataCost:int,DefinesCapabilities:bool,HistoryId:UniqueId,IsInSandbox:bool,Name:string,Parent:Instance,PredictionMode:PredictionMode,PropertyStatusStudio:PropertyStatus,RobloxLocked:bool,Sandboxed:bool,SerializedOverrides:BinaryString,SourceAssetId:int64,Tags:SharedString,UniqueId:UniqueId,archivable:bool,numExpectedDirectChildren:int;AccessoryDescription<Instance|GetAppliedInstance||AccessoryType:AccessoryType,AssetId:int64,Instance:Instance,IsLayered:bool,Order:int,Position:Vector3,Puffiness:float,Rotation:Vector3,Scale:Vector3;AccountService<Instance|DeviceAccessTokenAvailable,DeviceIntegrityAvailable,GetDeviceIntegrityToken,MagicLogin,GetCredentialsHeaders,GetDeviceAccessToken,GetDeviceIntegrityTokenYield|MagicLoginEvent|;Accoutrement<Instance|||AttachmentForward:Vector3,AttachmentPoint:CFrame,AttachmentPos:Vector3,AttachmentRight:Vector3,AttachmentUp:Vector3,BackendAccoutrementState:int;Accessory<Accoutrement|||AccessoryType:AccessoryType;Hat<Accoutrement|||;AchievementService<Instance|IsAvailable,GrantAchievement,HasAchieved||;ActivityHistoryEventService<Instance||WriteActivityHistoryEventFromStudio|;AdPlacement<Instance|||ActivationInstance:Instance,AdFormat:AdFormat,PlacementId:int64,RewardId:string,RewardImageContent:Content,RewardName:string,Visible:bool;AdPortal<Instance|||PortalInvalidReason:string,PortalVersion:int64,Status:AdUnitStatus;AdService<Instance|CreateAdRewardFromDevProductId,GetAdTeleportInfo,GetReportAdInfo,GetUniversalAppAdsEligibility,HandleWhyThisAdClicked,HideEudsaDisclosure,IsAdLoaded,OnDemandVideoCompleteFromUI,RegisterDisclosureButton,RegisterImpressionSource,ReturnToPublisherExperience,SetAdGuiInteractivityHandlerInitialized,ShowVideoAd,SubmitAdNotification,UnregisterAdOpportunity,GetAdAvailabilityNowAsync,GetAdAvailabilityNowForUniverseAsync,GetCampaignEligibilityAsync,RegisterAdOpportunityAsync,ShowRewardedVideoAdAsync,ShowRewardedVideoAdAtClientAsync|AdTeleportEnded,AdTeleportInitiated,CampaignEligibilityResponseFailureSignalFromClient,CampaignEligibilityResponseSuccessSignalFromClient,GetCampaignEligibilitySignalFromServer,ReportImpressionSignal,ReportTeleportSignal,RewardedVideoAdEnded,RewardedVideoAdStarted,ServeAdResponseSignal,ServeAdSignal,ShowDynamicEudsaDisclosure,ShowReportAdPopup,VideoAdClosed,adGuiRegisterUI,rewardedVideoAdPlayServerToClient,rewardedVideoAdPlayServerToClientWithPlacement,rewardedVideoAdResultClientToServer|OnImmersiveBrandedAdDisclosureButtonActivated,onDemandVideoPlayInUI;AdvancedDragger<Instance|||;AnalyticsService<Instance|FireCustomEvent,FireEvent,FireInGameEconomyEvent,FireLogEvent,FirePlayerProgressionEvent,GetDurationLoggerTimestamp,LogCustomEvent,LogEconomyEvent,LogFunnelStepEvent,LogJourneyEvent,LogOnboardingFunnelStepEvent,LogProgressionCompleteEvent,LogProgressionEvent,LogProgressionFailEvent,LogProgressionStartEvent,GetPlayerSegmentsAsync||ApiKey:string;AnimatedImageService<Instance|GetFrameNames,GetTrack,GetTracksChanged,Prewarm,UnloadTracks||;Animation<Instance|||AnimationContent:Content,AnimationId:ContentId;AnimationClip<Instance|||Guid:string,GuidBinaryString:BinaryString,Length:float,Loop:bool,Priority:AnimationPriority;AnimationGraphDefinition<AnimationClip|||;CurveAnimation<AnimationClip|||;KeyframeSequence<AnimationClip|AddKeyframe,GetKeyframes,RemoveKeyframe||AuthoredHipHeight:float;AnimationClipProvider<Instance|GetAnimationClip,GetAnimationClipById,GetAnimationNodeDefinition,GetAnimationNodeTypes,GetMemStats,RegisterActiveAnimationClip,RegisterAnimationClip,GetAnimationClipAsync,GetAnimations,GetAnimationsAsync,GetClipEvaluatorAsync||;AnimationController<Instance|GetPlayingAnimationTracks,LoadAnimation|AnimationPlayed|;AnimationFromVideoCreatorService<Instance|CreateJob,DownloadJobResult,FullProcess,GetJobStatus||;AnimationFromVideoCreatorStudioService<Instance|IsAgeRestricted,CreateAnimationByUploadingVideo,ImportVideoWithPrompt||;AnimationNodeDefinition<Instance|AddInputPin,GetOrderedInputPinNames,RemoveInputPin,SetOrderedInputPinNames|InputPinsChanged|InputPinData:BinaryString,NodeId:string,NodeType:AnimationNodeType;AnimationRigData<Instance|Dump,GetLabels,GetNames,GetParents,GetPostTransforms,GetPreTransforms,GetTransforms,IsValidR15,IsValidR15Plus,LoadFromHumanoid,LoadFromModel||Generic:BinaryString,label:BinaryString,name:BinaryString,parent:BinaryString,postTransform:BinaryString,preTransform:BinaryString,transform:BinaryString;AnimationStreamTrack<Instance|AdjustWeight,GetActive,GetTrackerData,Play,Stop,TogglePause|Stopped|Animation:TrackerStreamAnimation,FACSDataLod:FACSDataLod,IsPlaying:bool,Priority:AnimationPriority,WeightCurrent:float,WeightTarget:float;AnimationTrack<Instance|AdjustSpeed,AdjustWeight,GetDebugData,GetMarkerReachedSignal,GetParameter,GetParameterDefaults,GetTargetInstance,GetTargetNames,GetTimeOfKeyframe,Play,ResetGraph,SetParameter,SetTargetInstance,Stop,UpdateGraphNodeProperty|DidLoop,Ended,KeyframeReached,ParameterChanged,Stopped|Animation:Animation,IsPlaying:bool,Length:float,Looped:bool,Priority:AnimationPriority,Speed:float,TimePosition:float,WeightCurrent:float,WeightTarget:float;AnimationValueNodeDefinition<Instance|||NodeId:string,NodeType:AnimationValueNodeType;AnimationValueOutputDefinition<Instance|||;Animator<Instance|ApplyJointVelocities,GetPlayingAnimationTracks,GetPlayingAnimationTracksCoreScript,GetTrackByAnimationId,LoadAnimation,LoadAnimationCoreScript,LoadStreamAnimation,LoadStreamAnimationForSelfieView_deprecated,LoadStreamAnimationV2,RegisterEvaluationParallelCallback,StepAnimations,StepAnimationsInternal,SynchronizeWith|AnimationPlayed,AnimationPlayedCoreScript,AnimationStreamTrackPlayed,OnCombinedUpdate,OnGraphParameterUpdate,OnStreamingUpdated2,StreamSyncRequest|AnimTrackMetadata0:AnimTrackMetadata,AnimTrackMetadata1:AnimTrackMetadata,AnimTrackMetadata10:AnimTrackMetadata,AnimTrackMetadata11:AnimTrackMetadata,AnimTrackMetadata12:AnimTrackMetadata,AnimTrackMetadata13:AnimTrackMetadata,AnimTrackMetadata14:AnimTrackMetadata,AnimTrackMetadata15:AnimTrackMetadata,AnimTrackMetadata2:AnimTrackMetadata,AnimTrackMetadata3:AnimTrackMetadata,AnimTrackMetadata4:AnimTrackMetadata,AnimTrackMetadata5:AnimTrackMetadata,AnimTrackMetadata6:AnimTrackMetadata,AnimTrackMetadata7:AnimTrackMetadata,AnimTrackMetadata8:AnimTrackMetadata,AnimTrackMetadata9:AnimTrackMetadata,AnimTrackPlayState0:AnimTrackPlayState,AnimTrackPlayState1:AnimTrackPlayState,AnimTrackPlayState10:AnimTrackPlayState,AnimTrackPlayState11:AnimTrackPlayState,AnimTrackPlayState12:AnimTrackPlayState,AnimTrackPlayState13:AnimTrackPlayState,AnimTrackPlayState14:AnimTrackPlayState,AnimTrackPlayState15:AnimTrackPlayState,AnimTrackPlayState2:AnimTrackPlayState,AnimTrackPlayState3:AnimTrackPlayState,AnimTrackPlayState4:AnimTrackPlayState,AnimTrackPlayState5:AnimTrackPlayState,AnimTrackPlayState6:AnimTrackPlayState,AnimTrackPlayState7:AnimTrackPlayState,AnimTrackPlayState8:AnimTrackPlayState,AnimTrackPlayState9:AnimTrackPlayState,AnimTrackWeight0:AnimTrackWeight,AnimTrackWeight1:AnimTrackWeight,AnimTrackWeight10:AnimTrackWeight,AnimTrackWeight11:AnimTrackWeight,AnimTrackWeight12:AnimTrackWeight,AnimTrackWeight13:AnimTrackWeight,AnimTrackWeight14:AnimTrackWeight,AnimTrackWeight15:AnimTrackWeight,AnimTrackWeight2:AnimTrackWeight,AnimTrackWeight3:AnimTrackWeight,AnimTrackWeight4:AnimTrackWeight,AnimTrackWeight5:AnimTrackWeight,AnimTrackWeight6:AnimTrackWeight,AnimTrackWeight7:AnimTrackWeight,AnimTrackWeight8:AnimTrackWeight,AnimTrackWeight9:AnimTrackWeight,AnimationId0:int64,AnimationId1:int64,AnimationId10:int64,AnimationId11:int64,AnimationId12:int64,AnimationId13:int64,AnimationId14:int64,AnimationId15:int64,AnimationId2:int64,AnimationId3:int64,AnimationId4:int64,AnimationId5:int64,AnimationId6:int64,AnimationId7:int64,AnimationId8:int64,AnimationId9:int64,EvaluationThrottled:bool,FacsReplicationData:FacsReplicationData,PreferLodEnabled:bool,RootMotion:CFrame,RootMotionWeight:float;Annotation<Instance|GetRequests,GetStringUniqueId,IsThreadParent|RequestCompleted,RequestInitiated|AuthorColor3:Color3,AuthorId:int64,ChannelId:string,Contents:string,CreationTimeUnix:int64,LastModifiedTimeUnix:int64,LoadingReplies:bool,MessageId:string,ReplyCount:int64,Resolved:bool,TaggedUsers:string;WorkspaceAnnotation<Annotation|GetAbsolutePosition,SetAdorneeOffsetFromAbsolutePosition||Adornee:PVInstance,AdorneeOffset:Vector3;AnnotationsService<Instance|CreateAnnotation,CreateOrUpdatePlacePreference,DeleteAnnotation,EditAnnotation,GetAnnotationThreads,GetPlacePreference,LoadAnnotationReplies,LoadAnnotations,LoadResolvedAnnotations,ResolveAnnotation,CreateOrUpdateChannelPreferenceAsync,CreateOrUpdatePlacePreferenceAsync,GetChannelPreferenceAsync,GetPlacePreferenceAsync|AnnotationAdded,AnnotationDeleted,AnnotationEdited,AnnotationResolved,ServerLoadAnnotationReplies,ServerLoadAnnotations,ServerLoadResolvedAnnotations|AnnotationsLoadingStatus:AnnotationRequestStatus,AnnotationsVisible:bool,Hovered:Annotation,Mode:AnnotationEditingMode,ResolvedLoadingStatus:AnnotationRequestStatus,Selected:Annotation;AppAgeSignalsService<Instance|IsAvailable,GetAppAgeSignalsAsync||;AppLifecycleObserverService<Instance|GetCurrentState,IsDidDetachSupported,TriggerOnLandingPageMount,TriggerOnLuaAppInteractive,TriggerOnLuaAppReadyToRender,TriggerOnPageMilestone|OnBecomeActive,OnDetach,OnHide,OnResignActive,OnStart,OnUnhide|;AppRatingPromptService<Instance|isAppRatingPromptAvailable,showAppRatingPrompt|OnGameLeft|;AppUpdateService<Instance|CanPerformBinaryUpdate,CheckForUpdate,GetProtocolLaunchUpdateName,GetProtocolLaunchUpdateType,PerformManagedUpdate||;AssetCounterService<Instance|||;AssetDeliveryProxy<Instance|||Interface:string,Port:int,StartServer:bool;AssetImportService<Instance|GetAllPresets,GetPreset,RemovePreset,SavePreset,StartSessionWithPath,StartSingleFileWatch,StopSingleFileWatch,GetFilesInDirAsync,PickFileWithPromptAsync,PickImageFileWithPrompt,PickMeshFileWithPrompt,PickMultipleFilesWithPrompt,StartSessionWithPathAsync,UploadAssetFromContentAsync,UploadAssetFromPathAsync,UploadVersionedAssetFromContentAsync,UploadVersionedAssetFromPathAsync|SingleFileChanged,StartSingleMeshImport|;AssetManagerService<Instance|GetMeshIdFromAliasName,GetMeshIdFromAssetId,GetTextureIdFromAliasName,GetTextureIdFromAssetId,InsertAudio,InsertImage,InsertImages,InsertMesh,InsertMeshesWithLocation,InsertModel,InsertPackage,InsertVideo,OpenPlace,ShowPackageDetails,UpdateAllPackages,ViewPackageOnWebsite,AddNewPlace,CreateAlias,DeleteAlias,RemovePlace,RenameAlias,RenameModel,RenamePlace|AssetImportedSignal,ImportSessionFinished,ImportSessionStarted|;AssetPatchSettings<Instance|||ContentId:string,OutputPath:string,PatchId:string;AssetQualityService<Instance|FetchAssetQualitySummaryFromGltfAsync,FetchAssetQualitySummaryFromJobIdAsync,FetchAssetQualityValidationEntriesFromModelsAsync,FetchAssetQualityValidationRawFromModelsAsync,FetchAssetQualityVisualizationDataFromUrlAsync,GenerateAssetQualityGltfFromInstanceAsync||;AssetService<Instance|CreateEditableImage,CreateEditableMesh,DeserializeInstance,GetOpaqueContentMetadataMap,CachePartOperationsAsync,CanEditAssetAsync,ComposeDecalAsync,CreateAssetAsync,CreateAssetVersionAsync,CreateDataModelContentAsync,CreateDecalAsync,CreateEditableImageAsync,CreateEditableImageFromDownloadAsync,CreateEditableMeshAsync,CreateMeshPartAsync,CreatePlaceAsync,CreatePlaceInPlayerInventoryAsync,CreateSurfaceAppearanceAsync,CreateTextureAsync,GetAssetIdsForPackage,GetAssetIdsForPackageAsync,GetAudioMetadataAsync,GetBundleDetailsAsync,GetCreatorAssetID,GetGamePlacesAsync,LoadAssetAsync,PromptCreatePlatformContentAsync,PromptImportAnimationClipFromVideoAsync,SavePlaceAsync,SearchAudio,SearchAudioAsync|AudioMetadataFailedResponse,AudioMetadataRequest,AudioMetadataResponse,OpenPublishResultModal|AllowInsertFreeAssets:bool;Atmosphere<Instance|||Color:Color3,Decay:Color3,Density:float,Glare:float,Haze:float,Offset:float;Attachment<Instance|GetAxis,GetConstraints,GetSecondaryAxis,SetAxis,SetSecondaryAxis||Axis:Vector3,CFrame:CFrame,Orientation:Vector3,Position:Vector3,Rotation:Vector3,SecondaryAxis:Vector3,Visible:bool,WorldAxis:Vector3,WorldCFrame:CFrame,WorldOrientation:Vector3,WorldPosition:Vector3,WorldRotation:Vector3,WorldSecondaryAxis:Vector3;Bone<Attachment|||Transform:CFrame,TransformedCFrame:CFrame,TransformedWorldCFrame:CFrame;AudioAnalyzer<Instance|GetConnectedWires,GetInputPins,GetOutputPins,GetSpectrum|WiringChanged|PeakLevel:float,RmsLevel:float,SpectrumEnabled:bool,WindowSize:AudioWindowSize;AudioChannelMixer<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Layout:AudioChannelLayout;AudioChannelSplitter<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Layout:AudioChannelLayout;AudioChorus<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Depth:float,Mix:float,Rate:float;AudioCompressor<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Attack:float,Bypass:bool,Editor:bool,MakeupGain:float,Ratio:float,Release:float,Threshold:float;AudioDeviceInput<Instance|GetConnectedWires,GetInputPins,GetOutputPins,GetUserIdAccessList,SetUserIdAccessList|WiringChanged|AccessList:BinaryString,AccessType:AccessModifierType,Active:bool,DictationEnabled:bool,EchoCancellation:bool,GainControl:bool,IsReady:bool,Muted:bool,MutedByLocalUser:bool,NoiseSuppression:bool,Player:Player,Volume:float;AudioDeviceOutput<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Player:Player;AudioDistortion<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Level:float;AudioEcho<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Reset|WiringChanged|Bypass:bool,DelayTime:float,DryLevel:float,Feedback:float,RampTime:float,WetLevel:float;AudioEmitter<Instance|GetAngleAttenuation,GetAudibilityFor,GetConnectedWires,GetDistanceAttenuation,GetInputPins,GetInteractingListeners,GetOutputPins,SetAngleAttenuation,SetDistanceAttenuation|WiringChanged|AcousticSimulationEnabled:bool,AngleAttenuation:BinaryString,AudioInteractionGroup:string,DiffractionEnabled:SimulationMode,DistanceAttenuation:BinaryString,DistanceAttenuationBounds:NumberRange,DistanceAttenuationMode:DistanceAttenuationMode,OcclusionEnabled:SimulationMode,PositionInstance:Instance,PositionType:EmitterPositionType,ReverbEnabled:SimulationMode,SimulationFidelity:AudioSimulationFidelity;AudioEqualizer<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Editor:bool,HighGain:float,LowGain:float,MidGain:float,MidRange:NumberRange;AudioFader<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Volume:float;AudioFilter<Instance|GetConnectedWires,GetGainAt,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Editor:bool,FilterType:AudioFilterType,Frequency:float,Gain:float,Q:float;AudioFlanger<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Depth:float,Mix:float,Rate:float;AudioFocusService<Instance|AcquireFocus,GetFocusedContextId,GetRegisteredContexts,RegisterContextIdFromLua,RequestFocus|OnContextRegistered,OnContextUnregistered,OnDeafenVoiceAudio,OnUndeafenVoiceAudio|;AudioGate<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Reset|WiringChanged|Attack:float,Bypass:bool,Release:float,Threshold:NumberRange;AudioLimiter<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Editor:bool,MaxLevel:float,Release:float;AudioListener<Instance|GetAngleAttenuation,GetAudibilityFor,GetConnectedWires,GetDistanceAttenuation,GetInputPins,GetInteractingEmitters,GetOutputPins,Reset,SetAngleAttenuation,SetDistanceAttenuation|WiringChanged|AcousticSimulationEnabled:bool,AngleAttenuation:BinaryString,AudioInteractionGroup:string,DiffractionEnabled:SimulationMode,DistanceAttenuation:BinaryString,OcclusionEnabled:SimulationMode,PositionInstance:Instance,PositionType:ListenerPositionType,ReverbEnabled:SimulationMode,SimulationFidelity:AudioSimulationFidelity;AudioPitchShifter<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Pitch:float,WindowSize:AudioWindowSize;AudioPlayer<Instance|Cancel,GetConnectedWires,GetInputPins,GetOutputPins,Play,Stop,GetWaveformAsync|Ended,Looped,WiringChanged|Asset:ContentId,AssetId:string,AssetRepresentation:AssetRepresentation,AudioContent:Content,AutoLoad:bool,AutoPlay:bool,IsPlaying:bool,IsReady:bool,LoopRegion:NumberRange,Looping:bool,PlaybackRegion:NumberRange,PlaybackSpeed:double,TimeLength:double,TimePosition:double,Volume:float;AudioRecorder<Instance|Clear,GetConnectedWires,GetInputPins,GetOutputPins,GetTemporaryContent,Stop,CanRecordAsync,GetUnrecordableInstancesAsync,RecordAsync|WiringChanged|IsRecording:bool,TimeLength:double;AudioReverb<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Reset|WiringChanged|Bypass:bool,DecayRatio:float,DecayTime:float,Density:float,Diffusion:float,DryLevel:float,EarlyDelayTime:float,HighCutFrequency:float,LateDelayTime:float,LowShelfFrequency:float,LowShelfGain:float,ReferenceFrequency:float,WetLevel:float;AudioSearchParams<Instance|||Album:string,Artist:string,AudioSubType:AudioSubType,AudioSubtype:AudioSubType,MaxDuration:int,MinDuration:int,SearchKeyword:string,Tag:string,Title:string;AudioSpeechToText<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|DictationEnabled:bool,DisableVoiceDetection:bool,EnableVolumeCheck:bool,Enabled:bool,Text:string,VoiceDetected:bool,VoiceDetectedOverride:bool;AudioTextToSpeech<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Pause,Play,Unload,GetWaveformAsync,LoadAsync,LoadPlatformAsync|Ended,Looped,WiringChanged|IsLoaded:bool,IsPlaying:bool,Looping:bool,Pitch:float,PlaybackSpeed:float,Speed:float,Text:string,TimeLength:double,TimePosition:double,VoiceId:string,Volume:float;AudioTremolo<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Depth:float,Duty:float,Frequency:float,Shape:float,Skew:float,Square:float;AudioWindSynthesizer<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Enabled:bool,PositionInstance:Instance,PositionType:AudioPositionType,Profile:WindSoundProfile,Volume:float;AuroraScriptObject<Instance|GetCurrentState,SetStateFieldValue||BehaviorWeak:AuroraScript,BoundInstanceWeak:Instance,FrameId:int,LODLevel:int,MaxFrequency:int,PriorFrameInvoked:int;AuroraScriptService<Instance|FindBinding,FindBindings,GetAllCollections,GetLocalFrameId,SendMessage,getBehaviorObjects,getBehaviors,getBehaviorsForInstance,getInstancesForBehavior||;AuroraService<Instance|GetPredictedInstances,GetRemoteWorldStepId,GetServerView,GetWorldStepId,IsInstancePredicted,PlayInputRecording,SetReplicationLag,ShowDebugVisualizer,StartInputRecording,StartPrediction,StepPhysics,StopInputRecording,StopPrediction,UpdateProperties|FixedRateTick,Step|BufferFullInputCount:int,HashRoundingPoint:double,IgnoreRotation:bool,InputDropRate:float,LockStepIdOffset:bool,OutOfOrderInputCount:int,RCCHeartbeatFPS:double,RollbackOffset:int,TooOldInputCount:int;AvatarAbilityRules<Instance|||CharacterControllerMode:AvatarSettingsCharacterControllerMode,EnableClimbing:bool,EnableCrouching:bool,EnableFallingDown:bool,EnableGettingUp:bool,EnableHolding:bool,EnableJumping:bool,EnableReaching:bool,EnableRunning:bool,EnableSitting:bool,EnableSprinting:bool,EnableSwimming:bool,EnableTurning:bool;AvatarAccessoryRules<Instance|willRemoveAccessory||AccessoryMode:AvatarSettingsAccessoryMode,CustomAccessoryMode:AvatarSettingsCustomAccessoryMode,CustomBackAccessoryEnabled:bool,CustomBackAccessoryId:int64,CustomFaceAccessoryEnabled:bool,CustomFaceAccessoryId:int64,CustomFrontAccessoryEnabled:bool,CustomFrontAccessoryId:int64,CustomHairAccessoryEnabled:bool,CustomHairAccessoryId:int64,CustomHeadAccessoryEnabled:bool,CustomHeadAccessoryId:int64,CustomNeckAccessoryEnabled:bool,CustomNeckAccessoryId:int64,CustomShoulderAccessoryEnabled:bool,CustomShoulderAccessoryId:int64,CustomWaistAccessoryEnabled:bool,CustomWaistAccessoryId:int64,EnableEmissives:bool,EnableSound:bool,EnableVFX:bool,LimitBounds:Vector3,LimitMethod:AvatarSettingsAccessoryLimitMethod;AvatarAnimationRules<Instance|||AnimationClipsMode:AvatarSettingsAnimationClipsMode,AnimationPacksMode:AvatarSettingsAnimationPacksMode,CustomClimbAnimationEnabled:bool,CustomClimbAnimationId:int64,CustomFallAnimationEnabled:bool,CustomFallAnimationId:int64,CustomIdleAlt1AnimationEnabled:bool,CustomIdleAlt1AnimationId:int64,CustomIdleAlt2AnimationEnabled:bool,CustomIdleAlt2AnimationId:int64,CustomIdleAnimationEnabled:bool,CustomIdleAnimationId:int64,CustomJumpAnimationEnabled:bool,CustomJumpAnimationId:int64,CustomRunAnimationEnabled:bool,CustomRunAnimationId:int64,CustomSwimAnimationEnabled:bool,CustomSwimAnimationId:int64,CustomSwimIdleAnimationEnabled:bool,CustomSwimIdleAnimationId:int64,CustomWalkAnimationEnabled:bool,CustomWalkAnimationId:int64;AvatarBodyRules<Instance|||AppearanceMode:AvatarSettingsAppearanceMode,BuildMode:AvatarSettingsBuildMode,CustomBodyBundleId:int64,CustomBodyType:AvatarSettingsCustomBodyType,CustomBodyTypeScale:NumberRange,CustomEyebrowEnabled:bool,CustomEyebrowId:int64,CustomEyelashEnabled:bool,CustomEyelashId:int64,CustomFaceEnabled:bool,CustomFaceId:int64,CustomHeadEnabled:bool,CustomHeadId:int64,CustomHeadScale:NumberRange,CustomHeight:NumberRange,CustomHeightScale:NumberRange,CustomLeftArmEnabled:bool,CustomLeftArmId:int64,CustomLeftLegEnabled:bool,CustomLeftLegId:int64,CustomMoodEnabled:bool,CustomMoodId:int64,CustomProportionsScale:NumberRange,CustomRightArmEnabled:bool,CustomRightArmId:int64,CustomRightLegEnabled:bool,CustomRightLegId:int64,CustomTorsoEnabled:bool,CustomTorsoId:int64,CustomWidthScale:NumberRange,KeepPlayerHead:bool,ScaleMode:AvatarSettingsScaleMode;AvatarChatService<Instance|DebugCounterGet,EnableVoice,IsEnabled,IsPlaceEnabled,IsUniverseEnabled,PollClientFeatures,PollServerFeatures,deviceMeetsRequirementsForFeature,GetClientFeaturesAsync,GetServerFeaturesAsync|OnClientFeatures,RefreshClientFeatures|ClientFeatures:int,ClientFeaturesInitialized:bool,ServerFeatures:int;AvatarClothingRules<Instance|||ClothingMode:AvatarSettingsClothingMode,CustomClassicPantsAccessoryEnabled:bool,CustomClassicPantsAccessoryId:int64,CustomClassicShirtsAccessoryEnabled:bool,CustomClassicShirtsAccessoryId:int64,CustomClassicTShirtsAccessoryEnabled:bool,CustomClassicTShirtsAccessoryId:int64,CustomClothingMode:AvatarSettingsCustomClothingMode,CustomDressSkirtAccessoryEnabled:bool,CustomDressSkirtAccessoryId:int64,CustomJacketAccessoryEnabled:bool,CustomJacketAccessoryId:int64,CustomLeftShoesAccessoryEnabled:bool,CustomLeftShoesAccessoryId:int64,CustomPantsAccessoryEnabled:bool,CustomPantsAccessoryId:int64,CustomRightShoesAccessoryEnabled:bool,CustomRightShoesAccessoryId:int64,CustomShirtAccessoryEnabled:bool,CustomShirtAccessoryId:int64,CustomShortsAccessoryEnabled:bool,CustomShortsAccessoryId:int64,CustomSweaterAccessoryEnabled:bool,CustomSweaterAccessoryId:int64,CustomTShirtAccessoryEnabled:bool,CustomTShirtAccessoryId:int64,LimitBounds:Vector3;AvatarCollisionRules<Instance|||CollisionMode:AvatarSettingsCollisionMode,HitAndTouchDetectionMode:AvatarSettingsHitAndTouchDetectionMode,LegacyCollisionMode:AvatarSettingsLegacyCollisionMode,SingleColliderSize:Vector3;AvatarCreationService<Instance|DeserializeAvatarModel,GetValidationRules,HandleSelfieConsentResult,HandleSelfieQRResult,AutoSetupAvatarAsync,CreateCageMeshPartsWithScaleForExportAsync,GenerateAvatar2DPreviewAsync,GenerateAvatarAsync,GetBatchTokenDetailsAsync,LoadAvatar2DPreviewAsync,LoadGeneratedAvatarAsync,PrepareAvatarForPreviewAsync,PromptCreateAvatarAssetAsync,PromptCreateAvatarAsync,PromptCreateMakeupAsync,PromptSelectAvatarGenerationImageAsync,RequestAvatarGenerationSessionAsync,ValidateUGCAccessoryAsync,ValidateUGCBodyPartAsync,ValidateUGCFullBodyAsync|AvatarAssetModerationCompleted,AvatarModerationCompleted,AvatarOutfitModerationCompleted,OpenSelfieConsent,OpenSelfieQRCode,ReplicateAvatarGenerationImageIdWithErrorType,ReplicateAvatarModel,ReplicateAvatarPreviewUrl,RequestAvatarGenerationImage,RequestAvatarModel,RequestAvatarPreviewUrl,UgcValidationFailure,UgcValidationSuccess|;AvatarEditorService<Instance|BustAvatarFetchCache,GetAccessoryType,NoPromptApplyProfileConfiguration,NoPromptCreateOutfit,NoPromptDeleteOutfit,NoPromptRenameOutfit,NoPromptSaveAvatar,NoPromptSaveAvatarThumbnailCustomization,NoPromptSetFavorite,NoPromptUpdateOutfit,PerformCreateOutfitWithDescription,PerformDeleteOutfit,PerformRenameOutfit,PerformSaveAvatarWithDescription,PerformSetFavorite,PerformUpdateOutfit,PromptAllowInventoryReadAccess,PromptCreateOutfit,PromptDeleteOutfit,PromptRenameOutfit,PromptSaveAvatar,PromptSetFavorite,PromptUpdateOutfit,SetAllowInventoryReadAccess,SignalCreateOutfitFailed,SignalCreateOutfitPermissionDenied,SignalDeleteOutfitFailed,SignalDeleteOutfitPermissionDenied,SignalRenameOutfitFailed,SignalRenameOutfitPermissionDenied,SignalSaveAvatarFailed,SignalSaveAvatarPermissionDenied,SignalSetFavoriteFailed,SignalSetFavoritePermissionDenied,SignalUpdateOutfitFailed,SignalUpdateOutfitPermissionDenied,refreshAvatarThumbnails,CheckApplyDefaultClothing,CheckApplyDefaultClothingAsync,ConformToAvatarRules,ConformToAvatarRulesAsync,GetAvatarRules,GetAvatarRulesAsync,GetBatchItemDetails,GetBatchItemDetailsAsync,GetBundlesByAssetIdAsync,GetFavorite,GetFavoriteAsync,GetHeadShapesAsync,GetInventory,GetInventoryAsync,GetItemDetails,GetItemDetailsAsync,GetOutfitDetails,GetOutfitDetailsAsync,GetOutfits,GetOutfitsAsync,GetRecommendedAssets,GetRecommendedAssetsAsync,GetRecommendedBundles,GetRecommendedBundlesAsync,SearchCatalog,SearchCatalogAsync|NotifyBustAvatarFetchCache,OpenAllowInventoryReadAccess,OpenPromptCreateOufit,OpenPromptDeleteOutfit,OpenPromptRenameOutfit,OpenPromptSaveAvatar,OpenPromptSetFavorite,OpenPromptUpdateOutfit,PromptAllowInventoryReadAccessCompleted,PromptApplyProfileConfigurationCompleted,PromptCreateOutfitCompleted,PromptDeleteOutfitCompleted,PromptRenameOutfitCompleted,PromptSaveAvatarCompleted,PromptSaveAvatarThumbnailCustomizationCompleted,PromptSetFavoriteCompleted,PromptUpdateOutfitCompleted|;AvatarImportService<Instance|ImportFBXAnimationFromFilePathUserMayChooseModel,ImportFBXAnimationUserMayChooseModel,ImportFbxRigWithoutSceneLoad,ImportLoadedFBXAnimation,LoadRigAndDetectType||;AvatarRules<Instance|||AvatarType:GameAvatarType;AvatarSettings<Instance|Discard,Publish|DiscardRequested,RefreshPluginState|Loaded:bool;Backpack<Instance|||;BadgeService<Instance|AwardBadge,AwardBadgeAsync,CheckUserBadgesAsync,GetBadgeInfoAsync,GetUserBadgesAsync,IsDisabled,IsLegal,UserHasBadge,UserHasBadgeAsync|BadgeAwarded,OnBadgeAwarded|;BaseCoreGuiConfiguration<Instance|||Enabled:bool;CapturesViewConfiguration<BaseCoreGuiConfiguration|||Open:bool;PlayerListConfiguration<BaseCoreGuiConfiguration|||Open:bool;SelfViewConfiguration<BaseCoreGuiConfiguration|||Open:bool;BaseImportData<Instance|CreatePresetFromData,GetPreview,GetStatuses|StatusRemoved,StatusReported|Id:string,ImportName:string,ShouldImport:bool;AnimationImportData<BaseImportData|||ForceNewVersion:bool,VersionedAssetId:int64;FacsImportData<BaseImportData|||;GroupImportData<BaseImportData|||Anchored:bool,ImportAsModelAsset:bool,InsertInWorkspace:bool;JointImportData<BaseImportData|||;MaterialImportData<BaseImportData|||DiffuseFilePath:string,DiffuseVersionedAssetId:int64,EmissiveFilePath:string,EmissiveVersionedAssetId:int64,IsPbr:bool,MetalnessFilePath:string,MetalnessVersionedAssetId:int64,NormalFilePath:string,NormalVersionedAssetId:int64,RoughnessFilePath:string,RoughnessVersionedAssetId:int64;MeshImportData<BaseImportData|||Anchored:bool,CageManifold:bool,CageMeshIntersectedPreview:bool,CageMeshNotIntersected:bool,CageNoOverlappingVertices:bool,CageNonManifoldPreview:bool,CageOverlappingVerticesPreview:bool,CageUVMatched:bool,CageUVMisMatchedPreview:bool,Dimensions:Vector3,DoubleSided:bool,IgnoreVertexColors:bool,IrrelevantCageModifiedPreview:bool,MeshHoleDetectedPreview:bool,MeshNoHoleDetected:bool,NoIrrelevantCageModified:bool,NoOuterCageFarExtendedFromMesh:bool,OuterCageFarExtendedFromMeshPreview:bool,PolygonCount:float,UseImportedPivot:bool,VersionedAssetId:int64;RootImportData<BaseImportData|||AddModelToInventory:bool,Anchored:bool,AnimationIdForRestPose:float,ExistingPackageId:string,FileDimensions:Vector3,ImportAsModelAsset:bool,ImportAsPackage:bool,InsertInWorkspace:bool,InsertWithScenePosition:bool,InvertNegativeFaces:bool,KeepZeroInfluenceBones:bool,MergeMeshes:bool,PhysicalConstraintType:PhysicalConstraintType,PolygonCount:float,PreferredUploadId:int64,RestPose:RestPose,RigScale:RigScale,RigType:RigType,RigVisualization:bool,ScaleFactor:float,ScaleUnit:MeshScaleUnit,UseSceneOriginAsPivot:bool,UsesCages:bool,VersionedAssetId:int64,WorldForward:NormalId,WorldUp:NormalId;BasePlayerGui<Instance|GetGuiObjectsAtPosition,GetGuiObjectsInCircle||;CoreGui<BasePlayerGui|SetUserGuiRendering,TakeScreenshot,ToggleRecording|UserGuiRenderingChanged|SelectionImageObject:GuiObject,Version:int;PlayerGui<BasePlayerGui|GetTopbarTransparency,SetTopbarTransparency|TopbarTransparencyChangedSignal|CurrentScreenOrientation:ScreenOrientation,InputBindingMappingsRaw:BinaryString,ScreenOrientation:ScreenOrientation,SelectionImageObject:GuiObject;StarterGui<BasePlayerGui|GetCoreGuiEnabled,RegisterGetCore,RegisterSetCore,SetCore,SetCoreGuiEnabled,GetCore|CoreGuiChangedSignal|ClipsDescendantsSupportsRotation:RolloutState,ProcessUserInput:bool,ResetPlayerGuiOnSpawn:bool,RtlTextSupport:RtlTextSupport,ScreenOrientation:ScreenOrientation,ShowDevelopmentGui:bool,StudioDefaultStyleSheet:StyleSheet,StudioInsertWidgetLayerCollectorAutoLinkStyleSheet:StyleSheet,VirtualCursorMode:VirtualCursorMode;BaseRemoteEvent<Instance|||;RemoteEvent<BaseRemoteEvent|FireAllClients,FireClient,FireServer|OnClientEvent,OnRemoteServerEvent,OnServerEvent|;UnreliableRemoteEvent<BaseRemoteEvent|FireAllClients,FireClient,FireServer|OnClientEvent,OnRemoteServerEvent,OnServerEvent|;BaseWrap<Instance|GetCageOffset,GetFaces,GetUVs,GetVertices,IsHSRReady,ModifyVertices|VerticesModified|CageMeshContent:Content,CageMeshId:ContentId,CageOrigin:CFrame,CageOriginWorld:CFrame,HSRAssetId:ContentId,HSRContent:Content,HSRData:SharedString,HSRMeshIdData:SharedString,ImportInProcess:bool,ImportOrigin:CFrame,ImportOriginWorld:CFrame,TemporaryCageMeshContent:Content,TemporaryCageMeshId:ContentId;WrapDeformer<BaseWrap|SetCageMeshContent,CreateEditableMeshAsync,GetDeformedCFrameAsync||;WrapLayer<BaseWrap|||AutoSkin:WrapLayerAutoSkin,BindOffset:CFrame,Color:Color3,DebugMode:WrapLayerDebugMode,Enabled:bool,MaxSize:Vector3,Offset:Vector3,Order:int,Puffiness:float,ReferenceMeshContent:Content,ReferenceMeshId:ContentId,ReferenceOrigin:CFrame,ReferenceOriginWorld:CFrame,ShrinkFactor:float,TemporaryReferenceId:ContentId,TemporaryReferenceMeshContent:Content;WrapTarget<BaseWrap|CreateTextureInCageSpaceAsync,CreateTextureInTargetSpaceAsync||Color:Color3,DebugMode:WrapTargetDebugMode,Stiffness:float;Beam<Instance|SetTextureOffset||Attachment0:Attachment,Attachment1:Attachment,Brightness:float,Color:ColorSequence,CurveSize0:float,CurveSize1:float,Enabled:bool,FaceCamera:bool,LightEmission:float,LightInfluence:float,LocalTransparencyModifier:float,Segments:int,Texture:ContentId,TextureContent:Content,TextureLength:float,TextureMode:TextureMode,TextureSpeed:float,Transparency:NumberSequence,Width0:float,Width1:float,ZOffset:float;BindableEvent<Instance|Fire|Event|;BindableFunction<Instance|Invoke||OnInvoke;BodyMover<Instance|||;BodyAngularVelocity<BodyMover|||AngularVelocity:Vector3,MaxTorque:Vector3,P:float,angularvelocity:Vector3,maxTorque:Vector3;BodyForce<BodyMover|||Force:Vector3,force:Vector3;BodyGyro<BodyMover|||CFrame:CFrame,D:float,MaxTorque:Vector3,P:float,cframe:CFrame,maxTorque:Vector3;BodyPosition<BodyMover|GetLastForce,lastForce|ReachedTarget|D:float,MaxForce:Vector3,P:float,Position:Vector3,maxForce:Vector3,position:Vector3;BodyThrust<BodyMover|||Force:Vector3,Location:Vector3,force:Vector3,location:Vector3;BodyVelocity<BodyMover|GetLastForce,lastForce||MaxForce:Vector3,P:float,Velocity:Vector3,maxForce:Vector3,velocity:Vector3;RocketPropulsion<BodyMover|Abort,Fire,fire|ReachedTarget|Active:bool,CartoonFactor:float,MaxSpeed:float,MaxThrust:float,MaxTorque:Vector3,Target:BasePart,TargetOffset:Vector3,TargetRadius:float,ThrustD:float,ThrustP:float,TurnD:float,TurnP:float;BodyPartDescription<Instance|||AssetId:int64,BodyPart:BodyPart,Color:Color3,HeadShape:string,Instance:Instance;BranchService<Instance|CompleteMerge,GetInstanceConflicts,GetMergeChanges,GetMergeResolution,GetMergeStatus,SetMergeResolution,ArchiveBranchAsync,CreateBranchAsync,GetBranchesAsync,GetDiffAsync,RestoreBranchAsync,StartMergeAsync,UpdateBranchAsync|MergeStateChanged,MergeStateCleared,MergeStatusChanged|;Breakpoint<Instance|||Condition:string,ContinueExecution:bool,Enabled:bool,Id:int,Line:int,LogMessage:string,MetaBreakpointId:int,RemoveOnHit:bool,Script:string,Valid:bool,Verified:bool;BrowserService<Instance|CloseBrowserWindow,CopyAuthCookieFromBrowserToEngine,EmitHybridEvent,ExecuteJavaScript,OpenBrowserWindow,OpenNativeOverlay,OpenWeChatAuthWindow,ReturnToJavaScript,SendCommand|AuthCookieCopiedToEngine,BrowserWindowClosed,BrowserWindowWillNavigate,JavaScriptCallback|;BugReporterService<Instance|IsAvailable|BugReportRequested|;BulkImportService<Instance|LaunchBulkImport,ShowBulkImportView|AssetImported,BulkImportFinished,BulkImportStarted|;CacheableContentProvider<Instance|||;HSRDataContentProvider<CacheableContentProvider|||;MeshContentProvider<CacheableContentProvider|GetContentMemoryData||;SlimContentProvider<CacheableContentProvider|GetContentMemoryData||;SolidModelContentProvider<CacheableContentProvider|||;WrapContentProvider<CacheableContentProvider|||;CallingService<Instance|AnswerIncomingCall,EndCall,GetCallingState,CreateCallAsync|OnCallingRemoved,OnCallingStateChange|;CalloutService<Instance|AttachCallout,DefineCallout,DetachCalloutsByDefinitionId||;CaptureService<Instance|CanCaptureVideo,CaptureScreenshot,DeleteCapture,DeleteVideoCapture,GetDeviceInfo,GetScreenshotCaptureObject,IsCapturingVideo,OnCaptureBegan,OnCaptureEnded,OnCaptureObjectShared,OnCapturePermissionsPromptFinished,OnCaptureShared,OnSavePromptFinished,OnSharePromptFinished,OnVideoCaptureShared,PreCaptureShared,PreVideoCaptureShared,PromptSaveCapturesToGallery,PromptShareCapture,RetrieveCaptures,SaveCaptureObjectToExternalStorage,SaveCaptureToExternalStorage,SaveScreenshotCapture,SaveVideoCaptureToExternalStorage,StopVideoCapture,StopVideoCaptureInternal,TakeScreenshotCaptureAsync,UploadCaptureAndPostMoment,CheckMomentTextStatusAsync,CheckUploadCaptureStatusAsync,CheckUploadCaptureStatusForSupportTicketAsync,CreatePostAsync,DeleteCapturesAsync,DeleteVideoCaptureAsync,GenerateMomentTextAsync,GetCaptureFilePathAsync,GetCaptureSizeAsync,GetCaptureStorageSizeAsync,GetCaptureUploadDataAsync,InternalCheckPlayabilityAsync,InternalGetStartPlaceIdAsync,PromptCaptureGalleryPermissionAsync,ReadCapturesFromGalleryAsync,SaveCapturesToExternalStorageAsync,StartUploadCaptureAsync,StartUploadCaptureForSupportTicketAsync,StartVideoCaptureAsync,StartVideoCaptureInternalAsync,UploadCaptureAsync,UploadPostAsync|CaptureBegan,CaptureEnded,CaptureObjectSavedInternal,CaptureSaved,CaptureSavedInternal,OnCaptureAndMetadataSignatureResult,OpenCapturePermissionsPrompt,OpenSaveCapturesPrompt,OpenShareCapturePrompt,RequestCaptureAndMetadataSignature,UserCaptureSaved,UserVideoCaptureFailed,UserVideoCaptureStartFailed,VideoCaptureInProgress|;ChangeHistoryService<Instance|FinishRecording,GetCanRedo,GetCanUndo,IsRecordingInProgress,Redo,ResetWaypoints,SetEnabled,SetWaypoint,TryBeginRecording,Undo|OnRecordingFinished,OnRecordingStarted,OnRedo,OnUndo|;ChangeHistoryStreamingService<Instance||SendCreateInstanceFromStudio,SendDeleteInstanceFromStudio,SendReparentInstanceFromStudio,SendTerrainChangeFromStudio|;CharacterAppearance<Instance|||;BodyColors<CharacterAppearance|||HeadColor:BrickColor,HeadColor3:Color3,LeftArmColor:BrickColor,LeftArmColor3:Color3,LeftLegColor:BrickColor,LeftLegColor3:Color3,RightArmColor:BrickColor,RightArmColor3:Color3,RightLegColor:BrickColor,RightLegColor3:Color3,TorsoColor:BrickColor,TorsoColor3:Color3;CharacterMesh<CharacterAppearance|||BaseTextureContent:Content,BaseTextureId:int64,BodyPart:BodyPart,MeshContent:Content,MeshId:int64,OverlayTextureContent:Content,OverlayTextureId:int64;Clothing<CharacterAppearance|||Color3:Color3,Outfit1:ContentId,Outfit1Content:Content,Outfit2:ContentId,Outfit2Content:Content;Pants<Clothing|||PantsTemplate:ContentId,PantsTemplateContent:Content;Shirt<Clothing|||ShirtTemplate:ContentId,ShirtTemplateContent:Content;ShirtGraphic<CharacterAppearance|||Color3:Color3,Graphic:ContentId,TextureContent:Content;Skin<CharacterAppearance|||SkinColor:BrickColor;Chat<Instance|Chat,ChatLocal,GetShouldUseLuaChat,InvokeChatCallback,ReconcileCommunicationAccess,RegisterChatCallback,RequestModerationModeEnabled,SetBubbleChatSettings,CanUserChatAsync,CanUsersChatAsync,FilterStringAsync,FilterStringForBroadcast,FilterStringForPlayerAsync|BubbleChatSettingsChanged,Chatted,ClientToServerFilterMessageSignalV2,ClientToServerReportUnfilteredSignal,ModerationModeEnabledChanged,PlayerChatAvailabilityStatusChanged,ReconcileCommunicationAccessCompleted,ReconcileCommunicationAccessSignal,ServerToClientUnderOver13FilteredResponseSignal,TimeoutChatAttempt|BubbleChatEnabled:bool,IsAutoMigrated:bool,LoadDefaultChat:bool,ModerationMode:string;ClickDetector<Instance||MouseActionReplicated,MouseClick,MouseHoverEnter,MouseHoverLeave,RightMouseClick,mouseClick|CursorIcon:ContentId,CursorIconContent:Content,MaxActivationDistance:float;DragDetector<ClickDetector|AddConstraintFunction,GetReferenceFrame,RestartDrag,SetDragStyleFunction,SetPermissionPolicyFunction|DragContinue,DragContinueReplicate,DragEnd,DragEndReplicate,DragStart,DragStartReplicate,RestartPhysicalDragReplicate|ActivatedCursorIcon:ContentId,ActivatedCursorIconContent:Content,ApplyAtCenterOfMass:bool,Axis:Vector3,DragFrame:CFrame,DragStyle:DragDetectorDragStyle,Enabled:bool,GamepadModeSwitchKeyCode:KeyCode,KeyboardModeSwitchKeyCode:KeyCode,MaxDragAngle:float,MaxDragTranslation:Vector3,MaxForce:float,MaxTorque:float,MinDragAngle:float,MinDragTranslation:Vector3,Orientation:Vector3,PermissionPolicy:DragDetectorPermissionPolicy,PhysicalDragClickedPart:Instance,PhysicalDragHitPoint:Vector3,PhysicalDragIsInVR:bool,PhysicalDragTargetFrame:CFrame,ReferenceInstance:Instance,ResponseStyle:DragDetectorResponseStyle,Responsiveness:float,RunLocally:bool,SecondaryAxis:Vector3,TrackballRadialPullFactor:float,TrackballRollFactor:float,VRSwitchKeyCode:KeyCode,WorldAxis:Vector3,WorldSecondaryAxis:Vector3;ClientStorageService<Instance|Clear,GetItem,RemoveItem,SetItem||;CloudCRUDService<Instance|||;CloudExecutionService<Instance|||;Clouds<Instance|||Color:Color3,Cover:float,Density:float,Enabled:bool;ClusterPacketCache<Instance|||;Collaborator<Instance|||CFrame:CFrame,CollaboratorColor:int,CollaboratorColor3:Color3,CurDocGUID:string,CurScriptLineNumber:int,IsIdle:bool,Status:CollaboratorStatus,UserId:int64,Username:string;CollaboratorsService<Instance|GetCollaboratorsList,GetSelectionHighlightsEnabled,MultiGetCanCollaborate,RequestFlyToCollaborator,ToggleSelectionHighlights,ToggleTeamCreate|CollaboratorIdleUpdate,CollaboratorInstanceCreatedSignal,CollaboratorInstanceDestroyedSignal,CollaboratorStatusUpdateRequestedSignal,CollaboratorStatusUpdatedSignal,MultiGetCanCollaborateRetrieved,ServerMultiGetCanCollaborateRequested,ToggleSelectionHighlightsSignal|;CollectionService<Instance|AddTag,CreateCollection,GetAllTags,GetCollection,GetInstanceAddedSignal,GetInstanceRemovedSignal,GetTagAddedSignal,GetTagRemovedSignal,GetTagged,GetTags,HasTag,RemoveTag|ItemAdded,ItemRemoved,TagAdded,TagRemoved|;CommerceService<Instance|PromptCommerceProductPurchase,PromptRealWorldCommerceBrowser,SignalPromptCommerceProductPurchaseFinished,GetCommerceProductInfoAsync,PrepareCommerceProductPurchase,UserEligibleForRealWorldCommerceAsync|BenefitStatusReceived,FetchReceipt,InExperienceBrowserRequested,PromptCommerceProductPurchaseFinished,PromptCommerceProductPurchaseRequested,PurchaseBrowserClosed|;CompositeValueCurve<Instance|GetComponentCurves,GetValueAtTime||CurveType:CompositeValueCurveType;ConfigService<Instance|ClearTestingValue,SetTestingValue,GetConfigAsync,GetConfigForPlayerAsync||;Configuration<Instance|||;ConfigureServerService<Instance|||;ConnectivityService<Instance|IsNetworkStateAvailable||NetworkStatus:NetworkStatus;Constraint<Instance|GetDebugAppliedForce,GetDebugAppliedTorque||Active:bool,Attachment0:Attachment,Attachment1:Attachment,Color:BrickColor,Enabled:bool,Visible:bool;AlignOrientation<Constraint|||AlignType:AlignType,CFrame:CFrame,LookAtPosition:Vector3,MaxAngularVelocity:float,MaxTorque:float,Mode:OrientationAlignmentMode,PrimaryAxis:Vector3,PrimaryAxisOnly:bool,ReactionTorqueEnabled:bool,Responsiveness:float,RigidityEnabled:bool,SecondaryAxis:Vector3;AlignPosition<Constraint|||ApplyAtCenterOfMass:bool,ForceLimitMode:ForceLimitMode,ForceRelativeTo:ActuatorRelativeTo,MaxAxesForce:Vector3,MaxForce:float,MaxVelocity:float,Mode:PositionAlignmentMode,Position:Vector3,ReactionForceEnabled:bool,Responsiveness:float,RigidityEnabled:bool;AngularVelocity<Constraint|||AngularVelocity:Vector3,MaxTorque:float,ReactionTorqueEnabled:bool,RelativeTo:ActuatorRelativeTo;AnimationConstraint<Constraint|||AngularDamping:float,AngularStrength:float,C0:CFrame,C1:CFrame,EnableSkinning:bool,IsKinematic:bool,LinearDamping:float,LinearStrength:float,MaxForce:float,MaxTorque:float,Part0:BasePart,Part1:BasePart,Transform:CFrame;BallSocketConstraint<Constraint|||EnableSkinning:bool,LimitsEnabled:bool,MaxFrictionTorque:float,MaxFrictionTorqueXml:float,Radius:float,Restitution:float,TwistLimitsEnabled:bool,TwistLowerAngle:float,TwistUpperAngle:float,UpperAngle:float;HingeConstraint<Constraint|||ActuatorType:ActuatorType,AngularResponsiveness:float,AngularSpeed:float,AngularVelocity:float,CurrentAngle:float,LimitsEnabled:bool,LowerAngle:float,MotorMaxAcceleration:float,MotorMaxTorque:float,Radius:float,Restitution:float,ServoMaxTorque:float,SoftlockServoUponReachingTarget:bool,TargetAngle:float,UpperAngle:float;LineForce<Constraint|||ApplyAtCenterOfMass:bool,InverseSquareLaw:bool,Magnitude:float,MaxForce:float,ReactionForceEnabled:bool;LinearVelocity<Constraint|||ForceLimitMode:ForceLimitMode,ForceLimitsEnabled:bool,LineDirection:Vector3,LineVelocity:float,MaxAxesForce:Vector3,MaxForce:float,MaxPlanarAxesForce:Vector2,PlaneVelocity:Vector2,PrimaryTangentAxis:Vector3,ReactionForceEnabled:bool,RelativeTo:ActuatorRelativeTo,SecondaryTangentAxis:Vector3,VectorVelocity:Vector3,VelocityConstraintMode:VelocityConstraintMode;PlaneConstraint<Constraint|||;Plane<PlaneConstraint|||;RigidConstraint<Constraint|||EnableSkinning:bool;RodConstraint<Constraint|||CurrentDistance:float,Length:float,LimitAngle0:float,LimitAngle1:float,LimitsEnabled:bool,Thickness:float;RopeConstraint<Constraint|||CurrentDistance:float,Length:float,Restitution:float,Thickness:float,WinchEnabled:bool,WinchForce:float,WinchResponsiveness:float,WinchSpeed:float,WinchTarget:float;SlidingBallConstraint<Constraint|||ActuatorType:ActuatorType,CurrentPosition:float,LimitsEnabled:bool,LinearResponsiveness:float,LowerLimit:float,MotorMaxAcceleration:float,MotorMaxForce:float,Restitution:float,ServoMaxForce:float,Size:float,SoftlockServoUponReachingTarget:bool,Speed:float,TargetPosition:float,UpperLimit:float,Velocity:float;CylindricalConstraint<SlidingBallConstraint|||AngularActuatorType:ActuatorType,AngularLimitsEnabled:bool,AngularResponsiveness:float,AngularRestitution:float,AngularSpeed:float,AngularVelocity:float,CurrentAngle:float,InclinationAngle:float,LowerAngle:float,MotorMaxAngularAcceleration:float,MotorMaxTorque:float,RotationAxisVisible:bool,ServoMaxTorque:float,SoftlockAngularServoUponReachingTarget:bool,TargetAngle:float,UpperAngle:float,WorldRotationAxis:Vector3;PrismaticConstraint<SlidingBallConstraint|||;SpringConstraint<Constraint|||Coils:float,CurrentLength:float,Damping:float,FreeLength:float,LimitsEnabled:bool,MaxForce:float,MaxLength:float,MinLength:float,Radius:float,Stiffness:float,Thickness:float;Torque<Constraint|||RelativeTo:ActuatorRelativeTo,Torque:Vector3;TorsionSpringConstraint<Constraint|||Coils:float,CurrentAngle:float,Damping:float,LimitEnabled:bool,LimitsEnabled:bool,MaxAngle:float,MaxTorque:float,Radius:float,Restitution:float,Stiffness:float;UniversalConstraint<Constraint|||LimitsEnabled:bool,MaxAngle:float,Radius:float,Restitution:float;VectorForce<Constraint|||ApplyAtCenterOfMass:bool,Force:Vector3,RelativeTo:ActuatorRelativeTo;ContentProvider<Instance|GetAssetFetchStatus,GetAssetFetchStatusChangedSignal,GetDependencyContentIds,GetDetailedFailedRequests,GetFailedRequests,ListEncryptedAssets,Preload,RegisterDefaultEncryptionKey,RegisterDefaultSessionKey,RegisterEncryptedAsset,RegisterSessionEncryptedAsset,SetBaseUrl,UnregisterDefaultEncryptionKey,UnregisterEncryptedAsset,PreloadAsync|AssetFetchFailed|BaseUrl:string,RequestQueueSize:int;ContextActionService<Instance|BindAction,BindActionAtPriority,BindActionToInputTypes,BindActivate,BindCoreAction,BindCoreActionAtPriority,BindCoreActivate,CallFunction,FireActionButtonFoundSignal,GetAllBoundActionInfo,GetAllBoundCoreActionInfo,GetBoundActionInfo,GetBoundCoreActionInfo,GetCurrentLocalToolIcon,GetInputContexts,GetInputSchemaKeyCodeTree,SetDescription,SetImage,SetPosition,SetTitle,UnbindAction,UnbindActivate,UnbindAllActions,UnbindCoreAction,UnbindCoreActivate,GetButton|BoundActionAdded,BoundActionChanged,BoundActionRemoved,GetActionButtonEvent,InputContextsChanged,LocalToolEquipped,LocalToolUnequipped|;ControlState<Instance|AddBoolField,AddCFrameField,AddInstanceField,AddIntField,AddNumberField,AddUnitVector3Field,AddVector2Field,AddVector3Field,GetChangedState,GetReplicationWeight,GetState,SetField,UpdateFields|OnStateChanged|Owner:Player,StateSchema:BinaryString;Controller<Instance|BindButton,GetButton,UnbindButton,bindButton,getButton|ButtonChanged|;HumanoidController<Controller|||;SkateboardController<Controller||AxisChanged|Steer:float,Throttle:float;VehicleController<Controller|||;ControllerBase<Instance|||Active:bool,BalanceRigidityEnabled:bool,MoveSpeedFactor:float;AirController<ControllerBase|||BalanceMaxTorque:float,BalanceSpeed:float,LinearImpulse:Vector3,MaintainAngularMomentum:bool,MaintainLinearMomentum:bool,MoveMaxForce:float,TurnMaxTorque:float,TurnSpeedFactor:float;ClimbController<ControllerBase|||AccelerationTime:float,BalanceMaxTorque:float,BalanceSpeed:float,MoveMaxForce:float;GroundController<ControllerBase|||AccelerationLean:float,AccelerationTime:float,BalanceMaxTorque:float,BalanceSpeed:float,DecelerationTime:float,Friction:float,FrictionWeight:float,GroundOffset:float,StandForce:float,StandSpeed:float,TurnSpeedFactor:float;SwimController<ControllerBase|||AccelerationTime:float,PitchMaxTorque:float,PitchSpeedFactor:float,RollMaxTorque:float,RollSpeedFactor:float;ControllerManager<Instance|||ActiveController:ControllerBase,BaseMoveSpeed:float,BaseTurnSpeed:float,ClimbSensor:ControllerSensor,FacingDirection:Vector3,GroundSensor:ControllerSensor,MovingDirection:Vector3,RootPart:BasePart,UpDirection:Vector3;ControllerService<Instance|||;CookiesService<Instance|||;CoreGuiConfiguration<Instance|||CapturesViewConfiguration:CapturesViewConfiguration,PlayerListConfiguration:PlayerListConfiguration,SelfViewConfiguration:SelfViewConfiguration;CorePackages<Instance|||;CoreScriptDebuggingManagerHelper<Instance|||;CoreScriptSyncService<Instance|GetScriptFilePath||;CreationDBService<Instance|||;CreatorStoreService<Instance|GetAssetInfoAsync,GetCreatorStoreProductInfoAsync,PerformCreatorStorePurchase||;CrossDMScriptChangeListener<Instance|IsWatchingScriptLine,StartWatchingScriptLine|GuidLineContentsChanged,GuidNameChanged|;CustomEvent<Instance|GetAttachedReceivers,SetValue|ReceiverConnected,ReceiverDisconnected|PersistedCurrentValue:float;CustomEventReceiver<Instance|GetCurrentValue|EventConnected,EventDisconnected,SourceValueChanged|Source:Instance;CustomLog<Instance|Close,GetLogPath,Open,WriteAppend||;DataModelMesh<Instance|||Offset:Vector3,Scale:Vector3,VertexColor:Vector3;BevelMesh<DataModelMesh|||Bevel:float,Bulge:float;BlockMesh<BevelMesh|||;CylinderMesh<BevelMesh|||;FileMesh<DataModelMesh|||MeshContent:Content,MeshId:ContentId,TextureContent:Content,TextureId:ContentId;SpecialMesh<FileMesh|||MeshType:MeshType;DataModelSession<Instance||CurrentDataModelTypeAboutToChange,CurrentDataModelTypeChanged|CurrentDataModelType:StudioDataModelType,SessionId:string;DataStoreGetOptions<Instance|||UseCache:bool;DataStoreIncrementOptions<Instance|GetMetadata,SetMetadata||;DataStoreInfo<Instance|||CreatedTime:int64,DataStoreName:string,UpdatedTime:int64;DataStoreKey<Instance|||KeyName:string;DataStoreKeyInfo<Instance|GetMetadata,GetUserIds||CreatedTime:int64,UpdatedTime:int64,Version:string;DataStoreObjectVersionInfo<Instance|||CreatedTime:int64,IsDeleted:bool,Version:string;DataStoreOptions<Instance|SetExperimentalFeatures||AllScopes:bool;DataStoreService<Instance|GetDataStore,GetGlobalDataStore,GetOrderedDataStore,GetRequestBudgetForRequestType,SetRateLimitForRequestType,ListDataStoresAsync||AutomaticRetry:bool,LegacyNamingScheme:bool;DataStoreSetOptions<Instance|GetMetadata,SetMetadata||;Debris<Instance|AddItem,SetLegacyMaxItems,addItem||MaxItems:int;DebugSettings<Instance|||DataModel:int,InstanceCount:int,IsScriptStackTracingEnabled:bool,JobCount:int,PlayerCount:int,ReportSoundWarnings:bool,RobloxVersion:string,TickCountPreciseOverride:TickCountSampleMethod;DebuggablePluginWatcher<Instance|||;DebuggerBreakpoint<Instance|||Condition:string,ContinueExecution:bool,IsEnabled:bool,Line:int,LogExpression:string,isContextDependentBreakpoint:bool,line:int;DebuggerConnection<Instance|AddBreakpoint,Close,EvaluateWatch,GetFrameById,GetSource,GetThreadById,GetThreads,GetVariableById,Pause,Populate,RemoveBreakpoint,Resume,SetExceptionBreakMode,SetVariable,Step,StepIn,StepOut,UpdateSelectedFrame|BreakpointAdded,BreakpointChanged,BreakpointRemoved,Paused,Resumed|ErrorMessage:string,HasError:bool,Id:int,IsPaused:bool;LocalDebuggerConnection<DebuggerConnection|||;DebuggerConnectionManager<Instance|ConnectLocal,FocusConnection,GetAvailableConnection,GetConnectionById|ConnectionEnded,ConnectionStarted,FocusChanged|Timeout:double;DebuggerLuaResponse<Instance|GetArg||IsError:bool,IsSuccess:bool,Message:string,RequestId:int,Status:DebuggerStatus;DebuggerManager<Instance|AddDebugger,EnableDebugging,GetDebuggers,Resume,StepIn,StepOut,StepOver|DebuggerAdded,DebuggerRemoved|DebuggingEnabled:bool;DebuggerUIService<Instance|EditBreakpoint,EditWatch,IsConnectionForPlayDataModel,OpenExceptionMessagePopup,OpenScriptAtLine,Pause,RemoveScriptLineMarkers,Resume,SetCurrentThreadId,SetScriptLineMarker,SetWatchExpressions|ExpressionAdded,ExpressionsCleared|;DebuggerVariable<Instance|GetVariableByIndex,GetVariableByName||Name:string,Populated:bool,Type:string,Value:string,VariableId:int,VariablesCount:int;DebuggerWatch<Instance|||Expression:string;DeferredAssetManagerService<Instance|CancelPrefetch,GetPrefetchDownloadStatus|PrefetchDownloadStatusChanged|JoiningPlaceId:int64,JoiningUniverseId:int64,PregameLoadingScreenOnly:bool;DesignFoundationsService<Instance|ClearTokens,SetTokens||;DeviceDisplayService<Instance|AcquireWakeLock||;DeviceIdService<Instance|GetDeviceId||;Dialog<Instance|GetCurrentPlayers,SetGuiObject,SetPlayerIsUsing,SignalDialogChoiceSelected|DialogChoiceSelected|BehaviorType:DialogBehaviorType,ConversationDistance:float,GoodbyeChoiceActive:bool,GoodbyeDialog:string,InUse:bool,InitialPrompt:string,Purpose:DialogPurpose,Tone:DialogTone,TriggerDistance:float,TriggerOffset:Vector3;DialogChoice<Instance|||GoodbyeChoiceActive:bool,GoodbyeDialog:string,ResponseDialog:string,UserDialog:string;DigitsRigDescription<Instance|GetFingerControl,GetFingerTip,GetJoint,GetJointLabels,GetTposeAdjustment,SetFingerControl,SetFingerTip,SetJoint,SetTposeAdjustment||Index1:Instance,Index1TposeAdjustment:CFrame,Index2:Instance,Index2TposeAdjustment:CFrame,Index3:Instance,Index3TposeAdjustment:CFrame,IndexRange:Vector3,IndexSize:float,Middle1:Instance,Middle1TposeAdjustment:CFrame,Middle2:Instance,Middle2TposeAdjustment:CFrame,Middle3:Instance,Middle3TposeAdjustment:CFrame,MiddleRange:Vector3,MiddleSize:float,Pinky1:Instance,Pinky1TposeAdjustment:CFrame,Pinky2:Instance,Pinky2TposeAdjustment:CFrame,Pinky3:Instance,Pinky3TposeAdjustment:CFrame,PinkyRange:Vector3,PinkySize:float,Ring1:Instance,Ring1TposeAdjustment:CFrame,Ring2:Instance,Ring2TposeAdjustment:CFrame,Ring3:Instance,Ring3TposeAdjustment:CFrame,RingRange:Vector3,RingSize:float,Side:DigitsRigDescriptionSide,Thumb1:Instance,Thumb1TposeAdjustment:CFrame,Thumb2:Instance,Thumb2TposeAdjustment:CFrame,Thumb3:Instance,Thumb3TposeAdjustment:CFrame,ThumbRange:Vector3,ThumbSize:float;DisplayWakeLock<Instance|||;DraftsService<Instance|DiscardEdits,GetDraftStatus,GetEditors,RestoreScripts,ShowDiffsAgainstBase,ShowDiffsAgainstServer,ShowSourceDiffsAgainstCurrent,CommitEdits,GetDrafts,UpdateToLatestVersion|CommitStatusChanged,DraftAdded,DraftRemoved,DraftStatusChanged,EditorsListChanged,UpdateStatusChanged|;Dragger<Instance|AxisRotate,MouseDown,MouseMove,MouseUp||;DraggerService<Instance|||AlignDraggedObjects:bool,AngleSnapEnabled:bool,AngleSnapIncrement:float,AnimateHover:bool,CollisionsEnabled:bool,DraggerCoordinateSpace:DraggerCoordinateSpace,DraggerMovementMode:DraggerMovementMode,GeometrySnapColor:Color3,HoverAnimateFrequency:float,HoverLineThickness:int,HoverThickness:float,JointsEnabled:bool,LinearSnapEnabled:bool,LinearSnapIncrement:float,PartSnapEnabled:bool,PivotSnapToGeometry:bool,ShowHover:bool,ShowPivotIndicator:bool,UseBoundingBoxes:bool;EditableService<Instance|||EditableStatus:EditableStatus;EditorSourceService<Instance|||;EncodingService<Instance|Base64Decode,Base64Encode,CompressBuffer,ComputeBufferHash,ComputeStringHash,DecompressBuffer,GetDecompressedBufferSize||;EulerRotationCurve<Instance|GetAnglesAtTime,GetRotationAtTime,X,Y,Z||RotationOrder:RotationOrder;EventIngestService<Instance|SendEventDeferred,SendEventImmediately,SetRBXEvent,SetRBXEventStream||;ExampleV2Service<Instance|PrintHello|OnPolo|;ExperienceAuthService<Instance|ScopeCheckUIComplete|OpenAuthPrompt,ScopeCheckResult|;ExperienceInviteOptions<Instance|||InviteMessageId:string,InviteUser:int64,LaunchData:string,PromptMessage:string;ExperienceNotificationService<Instance|InvokeOptInPromptClosed,PromptOptIn,CanPromptOptInAsync|OptInPromptClosed,PromptOptInRequested|;ExperienceService<Instance|ExecuteCrossExperienceCall,GetFollowUserId,GetPendingJoinAttempt,GetPlaceJoinState,GetQueuePosition,LaunchExperience,LaunchExperienceFromSource,LaunchExperienceFromSourceWithCallback,RegisterForExperienceJoin,RegisterForExperienceLeave,StartCrossExperience,StopCrossExperience|OnCrossExperienceStarted,OnCrossExperienceStopped,OnNewJoinAttempt,PlaceJoinStateChanged,QueuePositionChanged|;ExperienceStateCaptureService<Instance|CanEnterCaptureMode,ResetHighlight,ToggleCaptureMode|ItemSelectedInCaptureMode|HiddenSelectionEnabled:bool,IsInBackground:bool,IsInCaptureMode:bool,SelectionMode:ExperienceStateCaptureSelectionMode;ExperienceStateRecordingService<Instance|ExitPlayback,GetCurrentPlaybackRestartFrames,GetPlaybackCurrentFrame,GetPlaybackMode,SetPlaybackFrame,SetPlaybackMode,SetPlaybackPercentage,LoadPlaybackAsync|PlaybackStatusUpdated|IsServerDataModelRecorderActive:bool;ExplorerFilter<Instance|BeginSearch,GetAutocompleter,GetErrors,GetLexemes,GetSearchResults,HasMoreResults,InstancePassesFilter,SetFilter||;ExplorerFilterAutocompleter<Instance|GetSuggestions||ReplaceRange:Vector2,RequiresOutsideContext:bool;ExplorerServiceVisibilityService<Instance|GetServiceVisibility||;Explosion<Instance||Hit|BlastPressure:float,BlastRadius:float,DestroyJointRadiusPercent:float,ExplosionType:ExplosionType,LocalTransparencyModifier:float,Position:Vector3,TimeScale:float,Visible:bool;ExternalIdentityService<Instance|CancelActiveOperation,AcquireProofAsync,GetCapabilitiesAsync||;FaceAnimatorService<Instance|GetTrackerLodController,Init,IsStarted,Start,Step,Stop|TrackerError,TrackerPrompt|AudioAnimationEnabled:bool,FaceTrackingStatusEnum:TrackerFaceTrackingStatus,FlipHeadOrientation:bool,VideoAnimationEnabled:bool;FaceControls<Instance|HasOverrideFACSData|InternalFacsOverrideChanged|ChinRaiser:float,ChinRaiserUpperLip:float,Corrugator:float,EyesLookDown:float,EyesLookLeft:float,EyesLookRight:float,EyesLookUp:float,FlatPucker:float,Funneler:float,InternalOverrideFACSData:BinaryString,JawDrop:float,JawLeft:float,JawRight:float,LeftBrowLowerer:float,LeftCheekPuff:float,LeftCheekRaiser:float,LeftDimpler:float,LeftEyeClosed:float,LeftEyeUpperLidRaiser:float,LeftInnerBrowRaiser:float,LeftLipCornerDown:float,LeftLipCornerPuller:float,LeftLipStretcher:float,LeftLowerLipDepressor:float,LeftNoseWrinkler:float,LeftOuterBrowRaiser:float,LeftUpperLipRaiser:float,LipPresser:float,LipsTogether:float,LowerLipSuck:float,MouthLeft:float,MouthRight:float,Pucker:float,RightBrowLowerer:float,RightCheekPuff:float,RightCheekRaiser:float,RightDimpler:float,RightEyeClosed:float,RightEyeUpperLidRaiser:float,RightInnerBrowRaiser:float,RightLipCornerDown:float,RightLipCornerPuller:float,RightLipStretcher:float,RightLowerLipDepressor:float,RightNoseWrinkler:float,RightOuterBrowRaiser:float,RightUpperLipRaiser:float,TongueDown:float,TongueOut:float,TongueUp:float,UpperLipSuck:float;FaceInstance<Instance|||Face:NormalId;Decal<FaceInstance|||AutoLocalize:bool,Color3:Color3,ColorMap:ContentId,ColorMapContent:Content,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,LocalTransparencyModifier:float,LocalizedTextureContent:Content,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,Rotation:float,RoughnessMap:ContentId,RoughnessMapContent:Content,Shiny:float,Specular:float,Texture:ContentId,TextureContent:Content,TexturePack:ContentId,TexturePackContent:Content,TexturePackMetadata:string,Transparency:float,UVOffset:Vector2,UVScale:Vector2,ZIndex:int;Texture<Decal|||OffsetStudsU:float,OffsetStudsV:float,StudsPerTileU:float,StudsPerTileV:float;FacialAgeEstimationService<Instance|IsAvailable,InquiryAsync||;FacialAnimationRecordingService<Instance|IsAgeRestricted,CheckOrRequestCameraPermission||BiometricDataConsent:bool;FacialAnimationStreamingServiceStats<Instance|Get,GetWithPlayerId||;FacialAnimationStreamingServiceV2<Instance|GetStats,IsAudioEnabled,IsPlaceEnabled,IsServerEnabled,IsVideoEnabled,ResolveStateForUser||ServiceState:int;FacialAnimationStreamingSubsessionStats<Instance|||;Feature<Instance|||FaceId:NormalId,InOut:InOut,LeftRight:LeftRight,TopBottom:TopBottom;Hole<Feature|||;MotorFeature<Feature|||;FeatureRestrictionManager<Instance||FeatureTimeoutAttempt,FeatureTimeoutRestored,RefreshFeatureRestrictions,ShowFeatureInterventionDetails,ShowFeatureInterventionDetailsV2,TimeoutChatAttempt,UpdateClientFeatureTimeout|;File<Instance|GetBinaryContents,GetTemporaryId||Size:int64;FileManagerService<Instance|OpenFileInWebBrowser,OpenFolder,RevealFileInFolder,ListFilesInFolderAsync||;FileSyncReplicationService<Instance||BroadcastPlayerSyncState,UpdateSyncInstances|;Fire<Instance|FastForward||Color:Color3,Enabled:bool,Heat:float,LocalTransparencyModifier:float,SecondaryColor:Color3,Size:float,TimeScale:float,heat_xml:float,size:float,size_xml:float;FlagStandService<Instance|||;FloatCurve<Instance|GetKeyAtIndex,GetKeyIndicesAtTime,GetKeys,GetValueAtTime,InsertKey,RemoveKeyAtIndex,SetKeys||Length:int,ValuesAndTimes:BinaryString;FlyweightService<Instance|||;CSGDictionaryService<FlyweightService|||;NonReplicatedCSGDictionaryService<FlyweightService|||;Folder<Instance|||IconTint:Color3,ReplicatedGuiInsertionOrder:int;GeneratedFolder<Folder|SetPrimaryPart||;ForceField<Instance|||Visible:bool;FriendService<Instance|GetPlatformFriends|FriendsUpdated,RemoteFriendEventSignal,RemoteFriendStatusSignal|;FunctionalTest<Instance|Error,Failed,Pass,Passed,Warn||AllowSleep:bool,Description:string,HasMigratedSettingsToTestService:bool,Is30FpsThrottleEnabled:bool,PhysicsEnvironmentalThrottle:bool,Timeout:double;GamePassService<Instance|PlayerHasPass||;GameSettings<Instance||VideoRecordingChangeRequest|VideoCaptureEnabled:bool;GamepadService<Instance|AutoSelectGui,DisableGamepadCursor,EnableGamepadCursor,GetGamepadCursorPosition,SetGamepadCursorPosition|GamepadThumbstick1Changed|GamepadCursorEnabled:bool;GenerationService<Instance|ConnectAsync,DisconnectAsync,ExportInstanceToGlbAsync,ExportMeshToGlbAsync,GenerateMeshAsync,GenerateModelAsync,GetVideoGenSessionAsync,GetVideoGenTriggersAsync,InternalGenerateMeshAsync,LoadGeneratedMeshAsync,LoadModelFromGlbAsync,LoadModelFromUrlAsync,SegmentMeshAsync,StartVideoGenSessionAsync,UpdateVideoGenSessionPromptAsync,UpdateVideoGenSessionTriggersAsync|ReplicateGeneration,RequestGenerationReplication|;GenericChallengeService<Instance|SignalChallengeAbandoned,SignalChallengeCompleted,SignalChallengeInvalidated,SignalChallengeLoaded,SignalChallengeRequired|ChallengeAbandonedEvent,ChallengeCompletedEvent,ChallengeInvalidatedEvent,ChallengeLoadedEvent,ChallengeRequiredEvent|;Geometry<Instance|||;GeometryService<Instance|CalculateConstraintsToPreserve,CreateBasicMeshPart,GenerateFragmentSites,TranscodeMesh,TranscodeModel,FragmentAsync,HashMeshAsync,IntersectAsync,SubtractAsync,SweepPartAsync,UnionAsync||;GetTextBoundsParams<Instance|||Font:Font,RichText:bool,Size:float,Text:string,Width:float;GlobalDataStore<Instance|OnUpdate,BatchGetAsync,GetAsync,IncrementAsync,RemoveAsync,SetAsync,UpdateAsync||;DataStore<GlobalDataStore|GetVersionAsync,GetVersionAtTimeAsync,ListKeysAsync,ListVersionsAsync,RemoveVersionAsync||;OrderedDataStore<GlobalDataStore|GetSortedAsync||;GongService<Instance|||;GroupService<Instance|PromptJoinCompleted,GetAlliesAsync,GetEnemiesAsync,GetGroupInfoAsync,GetGroupsAsync,GetRolesInGroupAsync,PromptJoinAsync|ShowJoinPrompt|;GuiBase<Instance|||;AnimatedImage<GuiBase|GetBoundTracks,Pause,Resume||Content:Content,PlaybackSpeed:float;GuiBase2d<GuiBase||SelectionChanged|AbsolutePosition:Vector2,AbsoluteRotation:float,AbsoluteSize:Vector2,ActiveQueryNames:string,AutoLocalize:bool,ClippedRect:Rect,IsNotOccluded:bool,Localize:bool,RawRect2D:Rect,ReplicatedInsertionOrder:int,RootLocalizationTable:LocalizationTable,SelectionBehaviorDown:SelectionBehavior,SelectionBehaviorLeft:SelectionBehavior,SelectionBehaviorRight:SelectionBehavior,SelectionBehaviorUp:SelectionBehavior,SelectionGroup:bool,TotalGroupScale:float;GuiObject<GuiBase2d|TweenPosition,TweenPositionInternal,TweenSize,TweenSizeAndPosition,TweenSizeAndPositionInternal,TweenSizeInternal|DragBegin,DragStopped,InputBegan,InputChanged,InputEnded,MouseEnter,MouseLeave,MouseMoved,MouseWheelBackward,MouseWheelForward,SelectionGained,SelectionLost,TouchLongPress,TouchPan,TouchPinch,TouchRotate,TouchSwipe,TouchTap|Active:bool,AnchorPoint:Vector2,AutomaticSize:AutomaticSize,BackgroundColor:BrickColor,BackgroundColor3:Color3,BackgroundTransparency:float,BorderColor:BrickColor,BorderColor3:Color3,BorderMode:BorderMode,BorderSizePixel:int,ClipsDescendants:bool,DragBeginConnectionCount:int,DragStoppedConnectionCount:int,Draggable:bool,GuiState:GuiState,InputSink:InputSink,Interactable:bool,LayoutOrder:int,MouseEnterConnectionCount:int,MouseLeaveConnectionCount:int,MouseMovedConnectionCount:int,MouseWheelBackwardConnectionCount:int,MouseWheelForwardConnectionCount:int,NextSelectionDown:GuiObject,NextSelectionLeft:GuiObject,NextSelectionRight:GuiObject,NextSelectionUp:GuiObject,Position:UDim2,Rotation:float,Selectable:bool,SelectionImageObject:GuiObject,SelectionOrder:int,SelectionRect2D:Rect,Sink:InputSink,Size:UDim2,SizeConstraint:SizeConstraint,Transparency:float,Visible:bool,ZIndex:int;CanvasGroup<GuiObject|||GroupColor3:Color3,GroupTransparency:float,ResolutionScale:float;Frame<GuiObject|||Style:FrameStyle;GuiButton<GuiObject||Activated,MouseButton1Click,MouseButton1Down,MouseButton1Up,MouseButton2Click,MouseButton2Down,MouseButton2Up,SecondaryActivated|AutoButtonColor:bool,HoverHapticEffect:HapticEffect,Modal:bool,MouseButton1ClickConnectionCount:int,MouseButton1DownConnectionCount:int,MouseButton1UpConnectionCount:int,MouseButton2ClickConnectionCount:int,MouseButton2DownConnectionCount:int,MouseButton2UpConnectionCount:int,PressHapticEffect:HapticEffect,Selected:bool,Style:ButtonStyle;ImageButton<GuiButton|SetEnableContentImageSizeChangedEvents||ContentImageSize:Vector2,HoverImage:ContentId,HoverImageContent:Content,Image:ContentId,ImageColor3:Color3,ImageContent:Content,ImageRectOffset:Vector2,ImageRectSize:Vector2,ImageTransparency:float,IsLoaded:bool,LocalizedImageContent:Content,PressedImage:ContentId,PressedImageContent:Content,ResampleMode:ResamplerMode,ScaleType:ScaleType,SliceCenter:Rect,SliceScale:float,TileSize:UDim2;TextButton<GuiButton|SetTextFromInput||Confidential:bool,ContentText:string,Font:Font,FontFace:Font,FontSize:FontSize,LineHeight:float,LocalizationMatchIdentifier:string,LocalizationMatchedSourceText:string,LocalizedText:string,MaxVisibleGraphemes:int,OpenTypeFeatures:string,OpenTypeFeaturesError:string,RichText:bool,Text:string,TextBounds:Vector2,TextColor:BrickColor,TextColor3:Color3,TextDirection:TextDirection,TextFits:bool,TextScaled:bool,TextSize:float,TextStrokeColor3:Color3,TextStrokeTransparency:float,TextTransparency:float,TextTruncate:TextTruncate,TextWrap:bool,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;GuiLabel<GuiObject|||;ImageLabel<GuiLabel|SetEnableContentImageSizeChangedEvents||ContentImageSize:Vector2,Image:ContentId,ImageColor3:Color3,ImageContent:Content,ImageRectOffset:Vector2,ImageRectSize:Vector2,ImageTransparency:float,IsLoaded:bool,LocalizedImageContent:Content,ResampleMode:ResamplerMode,ScaleType:ScaleType,SliceCenter:Rect,SliceScale:float,TileSize:UDim2;TextLabel<GuiLabel|SetTextFromInput||Confidential:bool,ContentText:string,Font:Font,FontFace:Font,FontSize:FontSize,LineHeight:float,LocalizationMatchIdentifier:string,LocalizationMatchedSourceText:string,LocalizedText:string,MaxVisibleGraphemes:int,OpenTypeFeatures:string,OpenTypeFeaturesError:string,RichText:bool,Text:string,TextBounds:Vector2,TextColor:BrickColor,TextColor3:Color3,TextDirection:TextDirection,TextFits:bool,TextScaled:bool,TextSize:float,TextStrokeColor3:Color3,TextStrokeTransparency:float,TextTransparency:float,TextTruncate:TextTruncate,TextWrap:bool,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;InputActionLabel<GuiObject|||FontFace:Font,ImageColor3:Color3,ImageTransparency:float,InputAction:InputAction,ResolvedImageContent:Content,ResolvedText:string,TextColor3:Color3,TextSize:float,TextTransparency:float,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;RelativeGui<GuiObject|||;ScrollingFrame<GuiObject|ClearInertialScrolling,GetSampledInertialVelocity,GetScrollVelocity,ResetScrollVelocity,ScrollToTop||AbsoluteCanvasSize:Vector2,AbsoluteWindowSize:Vector2,AutomaticCanvasSize:AutomaticSize,BottomImage:ContentId,BottomImageContent:Content,CanvasPosition:Vector2,CanvasSize:UDim2,DraggingScrollBar:DraggingScrollBar,ElasticBehavior:ElasticBehavior,HorizontalBarRect:Rect,HorizontalScrollBarInset:ScrollBarInset,MaxCanvasPosition:Vector2,MidImage:ContentId,MidImageContent:Content,ScrollBarImageColor3:Color3,ScrollBarImageTransparency:float,ScrollBarThickness:int,ScrollRate:float,ScrollVelocity:Vector2,ScrollingDirection:ScrollingDirection,ScrollingEnabled:bool,SmoothScroll:bool,TopImage:ContentId,TopImageContent:Content,VerticalBarRect:Rect,VerticalScrollBarInset:ScrollBarInset,VerticalScrollBarPosition:VerticalScrollBarPosition;TextBox<GuiObject|CaptureFocus,IsFocused,ReleaseFocus,ResetKeyboardMode,SetTextFromInput|FocusLost,Focused,ReturnPressedFromOnScreenKeyboard|ClearTextOnFocus:bool,Confidential:bool,ContentText:string,CursorPosition:int,Font:Font,FontFace:Font,FontSize:FontSize,HasFocus:bool,LineHeight:float,LocalizationMatchIdentifier:string,LocalizationMatchedSourceText:string,LocalizedPlaceholderText:string,ManualFocusRelease:bool,MaxVisibleGraphemes:int,MultiLine:bool,OpenTypeFeatures:string,OpenTypeFeaturesError:string,OverlayNativeInput:bool,PlaceholderColor3:Color3,PlaceholderText:string,ReturnKeyType:ReturnKeyType,RichText:bool,SelectionStart:int,ShouldEmitReturnEvents:bool,ShouldEmitTabEvents:bool,ShouldEmitUpAndDownArrowEvents:bool,ShowNativeInput:bool,Text:string,TextBounds:Vector2,TextColor:BrickColor,TextColor3:Color3,TextDirection:TextDirection,TextEditable:bool,TextFits:bool,TextInputType:TextInputType,TextScaled:bool,TextSize:float,TextStrokeColor3:Color3,TextStrokeTransparency:float,TextTransparency:float,TextTruncate:TextTruncate,TextWrap:bool,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;TextChannelWindow<GuiObject|||FontFace:Font,IsRendering:bool,Target:TextChannel,UseDefaultFont:bool;VideoDisplay<GuiObject|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|ResampleMode:ResamplerMode,ScaleType:ScaleType,TileSize:UDim2,VideoColor3:Color3,VideoRectOffset:Vector2,VideoRectSize:Vector2,VideoTransparency:float;VideoFrame<GuiObject|Pause,Play,SetStudioPreview|DidLoop,Ended,Loaded,Paused,Played,PlayingUpdatedFromServer,TimePositionUpdatedFromServer|InternalVideoUsage:InternalVideoUsage,IsLoaded:bool,Looped:bool,MaximumResolution:VideoSampleSize,Playing:bool,PlayingReplicating:bool,Resolution:Vector2,RollOffMaxDistance:float,RollOffMinDistance:float,RollOffMode:RollOffMode,TimeLength:double,TimePosition:double,TimePositionReplicating:double,Video:ContentId,VideoContent:Content,Volume:float;ViewportFrame<GuiObject|CaptureSnapshotAsync||Ambient:Color3,CameraCFrame:CFrame,CameraFieldOfView:float,CurrentCamera:Camera,ImageColor3:Color3,ImageTransparency:float,IsMirrored:bool,LightColor:Color3,LightDirection:Vector3;LayerCollector<GuiBase2d|GetGuiObjectsAtPosition,GetLayoutNodeTree||Enabled:bool,ResetOnSpawn:bool,TabKeyboardNavigation:bool,ZIndexBehavior:ZIndexBehavior;BillboardGui<LayerCollector|GetScreenSpaceBounds||Active:bool,Adornee:Instance,AlwaysOnTop:bool,Brightness:float,ClipsDescendants:bool,CurrentDistance:float,DistanceLowerLimit:float,DistanceStep:float,DistanceUpperLimit:float,ExtentsOffset:Vector3,ExtentsOffsetWorldSpace:Vector3,LightInfluence:float,MaxDistance:float,PlayerToHideFrom:Instance,Size:UDim2,SizeOffset:Vector2,StudsOffset:Vector3,StudsOffsetWorldSpace:Vector3;PluginGui<LayerCollector|BindToClose,GetRelativeMousePosition,OverrideStudioAction|InputBegan,InputChanged,InputEnded,MouseEnter,MouseLeave,PluginDragDropped,PluginDragEntered,PluginDragLeft,PluginDragMoved,PointerAction,WindowFocusReleased,WindowFocused|Plugin:Plugin,Title:string;DockWidgetPluginGui<PluginGui|RequestRaise||HostWidgetWasRestored:bool;QWidgetPluginGui<PluginGui|||;ScreenGui<LayerCollector|||ClipToDeviceSafeArea:bool,DisplayOrder:int,IgnoreGuiInset:bool,IgnoresTitleBarReservation:bool,OnTopOfCoreBlur:bool,SafeAreaCompatibility:SafeAreaCompatibility,ScreenInsets:ScreenInsets;GuiMain<ScreenGui|||;SurfaceGuiBase<LayerCollector|||Active:bool,Adornee:Instance,Face:NormalId;AdGui<SurfaceGuiBase|GetSingleReportAdInfo,HandleLuaUIEvent,forwardStateToLuaUI|AdEvent,ReportIsSubscribedToVideoCompletion,adGuiStateChanged|AdShape:AdShape,EnableVideoAds:bool,FallbackImage:ContentId,FallbackImageContent:Content,Status:AdUnitStatus,OnAdEvent;SurfaceGui<SurfaceGuiBase|||AlwaysOnTop:bool,Brightness:float,CanvasSize:Vector2,ClipsDescendants:bool,HorizontalCurvature:float,LightInfluence:float,MaxDistance:float,PixelsPerStud:float,Shape:SurfaceGuiShape,SizingMode:SurfaceGuiSizingMode,ToolPunchThroughDistance:float,ZOffset:float;GuiBase3d<GuiBase|||Color:BrickColor,Color3:Color3,Transparency:float,Visible:bool;FloorWire<GuiBase3d|||CycleOffset:float,From:BasePart,StudsBetweenTextures:float,Texture:ContentId,TextureSize:Vector2,To:BasePart,Velocity:float,WireRadius:float;InstanceAdornment<GuiBase3d|||Adornee:Instance;SelectionBox<InstanceAdornment|||LineThickness:float,StudioSelectionBox:bool,SurfaceColor:BrickColor,SurfaceColor3:Color3,SurfaceTransparency:float;PVAdornment<GuiBase3d|||Adornee:PVInstance;HandleAdornment<PVAdornment||MouseButton1Down,MouseButton1Up,MouseEnter,MouseLeave|AdornCullingMode:AdornCullingMode,AlwaysOnTop:bool,CFrame:CFrame,GizmoReference:Instance,SizeRelativeOffset:Vector3,ZIndex:int;BoxHandleAdornment<HandleAdornment|||Shading:AdornShading,Size:Vector3;ConeHandleAdornment<HandleAdornment|||Height:float,Hollow:bool,Radius:float,Shading:AdornShading;CylinderHandleAdornment<HandleAdornment|||Angle:float,Height:float,InnerRadius:float,Radius:float,Shading:AdornShading;ImageHandleAdornment<HandleAdornment|||Image:ContentId,ImageContent:Content,Size:Vector2;LineHandleAdornment<HandleAdornment|||Length:float,Thickness:float;PyramidHandleAdornment<HandleAdornment|||Height:float,Shading:AdornShading,Sides:int,Size:float;SphereHandleAdornment<HandleAdornment|||Radius:float,Shading:AdornShading;WireframeHandleAdornment<HandleAdornment|AddLine,AddLines,AddPath,AddText,Clear||Scale:Vector3,Thickness:float;ParabolaAdornment<PVAdornment|FindPartOnParabola||A:float,B:float,C:float,Range:float,Thickness:float;SelectionSphere<PVAdornment|||SurfaceColor:BrickColor,SurfaceColor3:Color3,SurfaceTransparency:float;PartAdornment<GuiBase3d|||Adornee:BasePart;HandlesBase<PartAdornment|||;ArcHandles<HandlesBase||MouseButton1Down,MouseButton1Up,MouseDrag,MouseEnter,MouseLeave|Axes:Axes,MouseButton1DownConnectionCount:int,MouseButton1UpConnectionCount:int,MouseDragConnectionCount:int,MouseEnterConnectionCount:int,MouseLeaveConnectionCount:int;Handles<HandlesBase||MouseButton1Down,MouseButton1Up,MouseDrag,MouseEnter,MouseLeave|Faces:Faces,MouseButton1DownConnectionCount:int,MouseButton1UpConnectionCount:int,MouseDragConnectionCount:int,MouseEnterConnectionCount:int,MouseLeaveConnectionCount:int,Style:HandlesStyle;SurfaceSelection<PartAdornment|||TargetSurface:NormalId;SelectionLasso<GuiBase3d|||Humanoid:Humanoid;SelectionPartLasso<SelectionLasso|||Part:BasePart;SelectionPointLasso<SelectionLasso|||Point:Vector3;Path2D<GuiBase|GetBoundingRect,GetControlPoint,GetControlPoints,GetLength,GetMaxControlPoints,GetPositionOnCurve,GetPositionOnCurveArcLength,GetSegmentCount,GetTangentOnCurve,GetTangentOnCurveArcLength,InsertControlPoint,RemoveControlPoint,SetControlPoints,UpdateControlPoint|ControlPointChanged|Closed:bool,Color3:Color3,PropertiesSerialize:BinaryString,SelectedControlPoint:int,SelectedControlPointData:Path2DControlPoint,Thickness:float,Transparency:float,Visible:bool,ZIndex:int;GuiService<Instance|AddCenterDialog,AddKey,AddSelectionParent,AddSelectionTuple,AddSpecialKey,BroadcastNotification,ClearError,CloseInspectMenu,CloseStatsBasedOnInputString,DismissNotification,ForceTenFootInterface,GetAutoUIScaleHundredths,GetBrickCount,GetClosestDialogToPosition,GetClosestVisibleDialogToPosition,GetEffectiveUIScaleHundredths,GetEmotesMenuOpen,GetErrorCode,GetErrorDetails,GetErrorMessage,GetErrorType,GetGameplayPausedNotificationEnabled,GetGuiInset,GetGuiIsVisible,GetHardwareSafeViewport,GetInsetArea,GetInspectMenuEnabled,GetNotificationTypeList,GetRawScreenScale,GetResolutionScale,GetSafeZoneOffsets,GetUiMessage,InspectPlayerFromHumanoidDescription,InspectPlayerFromUserId,InspectPlayerFromUserIdWithCtx,IsMemoryTrackerEnabled,IsTenFootInterface,OnNotificationDisplayed,OnNotificationInteraction,OpenBrowserWindow,OpenNativeOverlay,RemoveCenterDialog,RemoveKey,RemoveSelectionGroup,RemoveSpecialKey,Select,SendNotification,SendUIOcclusionMetricsForQueryRegion,SetEmotesMenuOpen,SetGameplayPausedNotificationEnabled,SetGlobalGuiInset,SetHardwareSafeAreaInsets,SetInspectMenuEnabled,SetMenuIsOpen,SetPurchasePromptIsShown,SetSafeZoneOffsets,SetTopbarInset,SetUIScaleMultiplier,SetUiMessage,ShowStatsBasedOnInputString,ToggleFullscreen,ToggleGuiIsVisibleForCaptures,ToggleGuiIsVisibleIfAllowed,GetScreenResolution|BrowserWindowClosed,CloseInspectMenuRequest,CoreGuiRenderOverflowed,EmotesMenuOpenChanged,ErrorMessageChanged,GuiVisibilityChangedSignal,InspectMenuEnabledChangedSignal,InspectPlayerFromHumanoidDescriptionRequest,InspectPlayerFromUserIdWithCtxRequest,KeyPressed,MenuClosed,MenuOpened,NativeClose,NetworkPausedEnabledChanged,Open9SliceEditor,OpenStyleEditor,PurchasePromptShown,SafeZoneOffsetsChanged,ScrollStateChanged,ShowLeaveConfirmation,SpecialKeyPressed,UiMessageChanged|AutoSelectGuiEnabled:bool,CoreEffectFolder:Folder,CoreGuiFolder:Folder,CoreGuiNavigationEnabled:bool,DisplayScalingMode:DisplayScalingMode,GuiNavigationEnabled:bool,IsModalDialog:bool,IsWindows:bool,MenuIsOpen:bool,PreferredTextSize:PreferredTextSize,PreferredTransparency:float,ReducedMotionEnabled:bool,SelectedCoreObject:GuiObject,SelectedObject:GuiObject,TopbarInset:Rect,TouchControlsEnabled:bool,ViewportDisplaySize:DisplaySize,ViewportSizeInMM:Vector2,SendCoreUiNotification;GuidRegistryService<Instance|||;HapticEffect<Instance|Play,SetWaveformKeys,Stop|Ended|Looped:bool,Position:Vector3,Radius:float,Type:HapticEffectType,WaveformData:BinaryString;HapticService<Instance|GetMotor,IsMotorSupported,IsVibrationSupported,SetMotor||;HarmonyService<Instance|||;HeapProfilerService<Instance|ClientRequestDataAsync,ServerRequestDataAsync|OnNewData,RequestData|;HeatmapQueryService<Instance|||;HeatmapService<Instance|||;HeightmapImporterService<Instance|CancelImportHeightmap,IsValidColormap,IsValidHeightmap,SetImportHeightmapPaused,GetHeightmapPreviewAsync,ImportHeightmap|ColormapHasUnknownPixels,ProgressUpdate|;HiddenSurfaceRemovalAsset<Instance|||HSRData:BinaryString,HSRMeshIdData:BinaryString;Highlight<Instance|||Adornee:Instance,DepthMode:HighlightDepthMode,Enabled:bool,FillColor:Color3,FillTransparency:float,LineThickness:int,OutlineColor:Color3,OutlineTransparency:float,ReservedId:ReservedHighlightId;Hopper<Instance|||;HttpRbxApiService<Instance|GetDocumentationUrl,GetAsync,GetAsyncFullUrl,PostAsync,PostAsyncFullUrl,RequestAsync,RequestLimitedAsync||;HttpRequest<Instance|Cancel,Start||;HttpService<Instance|CreateWebStreamClient,CreateWebStreamClientInternal,GenerateGUID,GetHttpEnabled,GetSecret,GetUserAgent,JSONDecode,JSONEncode,RequestInternal,SetHttpEnabled,UrlEncode,GetAsync,JSONDecodeAsync,JSONEncodeAsync,PostAsync,RequestAccessTokenScopesAsync,RequestAsync||HttpEnabled:bool;Humanoid<Instance|AddAccessory,AddCustomStatus,AddStatus,BuildRigFromAttachments,ChangeState,ComputeOriginalSizeForPart,ComputeR15BodyBoundingBox,EquipTool,GetAccessories,GetAccessoryHandleScale,GetAppliedDescription,GetBodyPartR15,GetLimb,GetMoveVelocity,GetPlayingAnimationTracks,GetRelativeVelocityAtFloor,GetState,GetStateEnabled,GetStatuses,HasCustomStatus,HasStatus,LoadAnimation,Move,MoveTo,RemoveAccessories,RemoveCustomStatus,RemoveStatus,ReplaceBodyPartR15,SetClickToWalkEnabled,SetStateEnabled,TakeDamage,UnequipTools,loadAnimation,takeDamage,CacheDefaults,ApplyAvatarRules,ApplyDescription,ApplyDescriptionAsync,ApplyDescriptionReset,ApplyDescriptionResetAsync,PlayEmote,PlayEmoteAndGetAnimTrackById,PlayEmoteAsync|AnimationPlayed,ApplyDescriptionFinished,Climbing,ClusterCompositionFinished,CustomStatusAdded,CustomStatusRemoved,Died,EmoteTriggered,FallingDown,FreeFalling,GettingUp,HealthChanged,Jumping,MoveToFinished,PlatformStanding,Ragdoll,Running,Seated,ServerApplyDescription,ServerBreakJoints,ServerEquipTool,ServerResetCharacter,StateChanged,StateEnabledChanged,StatusAdded,StatusRemoved,Strafing,Swimming,Touched|AutoJumpEnabled:bool,AutoRotate:bool,AutomaticScalingEnabled:bool,BreakJointsOnDeath:bool,CameraMaxDistance:float,CameraMinDistance:float,CameraMode:CameraMode,CameraOffset:Vector3,CollisionType:HumanoidCollisionType,DisplayDistanceType:HumanoidDisplayDistanceType,DisplayName:string,EvaluateStateMachine:bool,FinishedState:bool,FloorMaterial:Material,Health:float,HealthDisplayDistance:float,HealthDisplayType:HumanoidHealthDisplayType,Health_XML:float,HipHeight:float,InternalBodyScale:Vector3,InternalDisplayName:string,InternalHeadScale:float,InternalOriginalHipHeight:float,Jump:bool,JumpHeight:float,JumpPower:float,JumpReplicate:bool,LeftLeg:BasePart,MaxHealth:float,MaxSlopeAngle:float,MoveDirection:Vector3,MoveDirectionInternal:Vector3,NameDisplayDistance:float,NameOcclusion:NameOcclusion,NetworkHumanoidState:HumanoidStateType,NoFloorTimerState:float,OverrideDefaultCollisions:bool,PlatformStand:bool,RequiresNeck:bool,RigType:HumanoidRigType,RightLeg:BasePart,RootPart:BasePart,RotationType:RotationType,SeatPart:BasePart,Sit:bool,Strafe:bool,TargetPoint:Vector3,TimerState:float,Torso:BasePart,UseJumpPower:bool,WalkAngleError:float,WalkDirection:Vector3,WalkSpeed:float,WalkToPart:BasePart,WalkToPoint:Vector3,maxHealth:float;HumanoidDescription<Instance|AddEmote,GetAccessories,GetEmotes,GetEquippedEmotes,RemoveEmote,SetAccessories,SetEmotes,SetEquippedEmotes|EmotesChanged,EquippedEmotesChanged|AccessoryBlob:string,BackAccessory:string,BodyTypeScale:float,ClimbAnimation:int64,DepthScale:float,EmotesDataInternal:string,EquippedEmotesDataInternal:string,Face:int64,FaceAccessory:string,FallAnimation:int64,FrontAccessory:string,GraphicTShirt:int64,HairAccessory:string,HatAccessory:string,Head:int64,HeadColor:Color3,HeadScale:float,HeightScale:float,IdleAnimation:int64,JumpAnimation:int64,LeftArm:int64,LeftArmColor:Color3,LeftLeg:int64,LeftLegColor:Color3,MoodAnimation:int64,NeckAccessory:string,NumberEmotesLoaded:int,Pants:int64,ProportionScale:float,ResetIncludesBodyParts:bool,RightArm:int64,RightArmColor:Color3,RightLeg:int64,RightLegColor:Color3,RunAnimation:int64,Shirt:int64,ShouldersAccessory:string,StaticFacialAnimation:bool,SwimAnimation:int64,Torso:int64,TorsoColor:Color3,UseAvatarSettings:bool,WaistAccessory:string,WalkAnimation:int64,WidthScale:float;HumanoidRigDescription<Instance|AutoRig,GetContainedJointLabels,GetJoint,GetJointFromName,GetJointLabels,GetJointNames,GetJointRangeMax,GetJointRangeMin,GetJointSize,GetR15JointLabels,GetR15JointNames,GetR6JointLabels,GetR6JointNames,GetTposeAdjustment,SetJoint,SetJointRangeMax,SetJointRangeMin,SetJointSize,SetTposeAdjustment,ShowVolumes||Chest:Instance,ChestRangeMax:Vector3,ChestRangeMin:Vector3,ChestSize:float,ChestTposeAdjustment:CFrame,HeadBase:Instance,HeadBaseRangeMax:Vector3,HeadBaseRangeMin:Vector3,HeadBaseSize:float,HeadBaseTposeAdjustment:CFrame,LeftAnkle:Instance,LeftAnkleRangeMax:Vector3,LeftAnkleRangeMin:Vector3,LeftAnkleSize:float,LeftAnkleTposeAdjustment:CFrame,LeftClavicle:Instance,LeftClavicleRangeMax:Vector3,LeftClavicleRangeMin:Vector3,LeftClavicleSize:float,LeftClavicleTposeAdjustment:CFrame,LeftElbow:Instance,LeftElbowRangeMax:Vector3,LeftElbowRangeMin:Vector3,LeftElbowSize:float,LeftElbowTposeAdjustment:CFrame,LeftHip:Instance,LeftHipRangeMax:Vector3,LeftHipRangeMin:Vector3,LeftHipSize:float,LeftHipTposeAdjustment:CFrame,LeftKnee:Instance,LeftKneeRangeMax:Vector3,LeftKneeRangeMin:Vector3,LeftKneeSize:float,LeftKneeTposeAdjustment:CFrame,LeftShoulder:Instance,LeftShoulderRangeMax:Vector3,LeftShoulderRangeMin:Vector3,LeftShoulderSize:float,LeftShoulderTposeAdjustment:CFrame,LeftToeBase:Instance,LeftToeBaseRangeMax:Vector3,LeftToeBaseRangeMin:Vector3,LeftToeBaseSize:float,LeftToeBaseTposeAdjustment:CFrame,LeftWrist:Instance,LeftWristRangeMax:Vector3,LeftWristRangeMin:Vector3,LeftWristSize:float,LeftWristTposeAdjustment:CFrame,Neck:Instance,NeckRangeMax:Vector3,NeckRangeMin:Vector3,NeckSize:float,NeckTposeAdjustment:CFrame,OriginOffset:CFrame,RightAnkle:Instance,RightAnkleRangeMax:Vector3,RightAnkleRangeMin:Vector3,RightAnkleSize:float,RightAnkleTposeAdjustment:CFrame,RightClavicle:Instance,RightClavicleRangeMax:Vector3,RightClavicleRangeMin:Vector3,RightClavicleSize:float,RightClavicleTposeAdjustment:CFrame,RightElbow:Instance,RightElbowRangeMax:Vector3,RightElbowRangeMin:Vector3,RightElbowSize:float,RightElbowTposeAdjustment:CFrame,RightHip:Instance,RightHipRangeMax:Vector3,RightHipRangeMin:Vector3,RightHipSize:float,RightHipTposeAdjustment:CFrame,RightKnee:Instance,RightKneeRangeMax:Vector3,RightKneeRangeMin:Vector3,RightKneeSize:float,RightKneeTposeAdjustment:CFrame,RightShoulder:Instance,RightShoulderRangeMax:Vector3,RightShoulderRangeMin:Vector3,RightShoulderSize:float,RightShoulderTposeAdjustment:CFrame,RightToeBase:Instance,RightToeBaseRangeMax:Vector3,RightToeBaseRangeMin:Vector3,RightToeBaseSize:float,RightToeBaseTposeAdjustment:CFrame,RightWrist:Instance,RightWristRangeMax:Vector3,RightWristRangeMin:Vector3,RightWristSize:float,RightWristTposeAdjustment:CFrame,Root:Instance,RootRangeMax:Vector3,RootRangeMin:Vector3,RootSize:float,RootTposeAdjustment:CFrame,Spine:Instance,SpineRangeMax:Vector3,SpineRangeMin:Vector3,SpineSize:float,SpineTposeAdjustment:CFrame,Waist:Instance,WaistRangeMax:Vector3,WaistRangeMin:Vector3,WaistSize:float,WaistTposeAdjustment:CFrame;IKControl<Instance|GetChainCount,GetChainLength,GetNodeLocalCFrame,GetNodeWorldCFrame,GetRawFinalTarget,GetSmoothedFinalTarget,Solve||ChainRoot:Instance,Enabled:bool,EndEffector:Instance,EndEffectorOffset:CFrame,Offset:CFrame,Pole:Instance,Priority:int,SmoothTime:float,Target:Instance,Type:IKControlType,Weight:float;ILegacyStudioBridge<Instance|||;LegacyStudioBridge<ILegacyStudioBridge|||;IXPService<Instance|ClearCreatorLayers,ClearUserLayers,GetBrowserTrackerLayerLoadingStatus,GetBrowserTrackerLayerVariables,GetBrowserTrackerStatusForLayer,GetCreatorLayerLoadingStatus,GetCreatorLayerVariables,GetCreatorStatusForLayer,GetRegisteredCreatorLayersToStatus,GetRegisteredUserLayersToStatus,GetUserLayerLoadingStatus,GetUserLayerVariables,GetUserStatusForLayer,InitializeCreatorLayers,InitializeUserLayers,LogBrowserTrackerLayerExposure,LogCreatorLayerExposure,LogFlagLinkedUserLayerExposure,LogUserLayerExposure,RegisterCreatorLayers,RegisterUserLayers|OnBrowserTrackerLayerLoadingStatusChanged,OnCreatorLayerLoadingStatusChanged,OnUserLayerLoadingStatusChanged|;ImageScreenCaptureService<Instance|||;ImportSession<Instance|Cancel,GetFilename,GetStatuses,Upload|UploadComplete,UploadProgress|UploadSource:string;AssetImportSession<ImportSession|ApplyPreset,CreatePresetFromData,GetImportTree,GetKeyframeSequences,GetKeyframeSequencesForSelectedRestPose,GetKeyframeSequencesForSelectedRestPoseWithClip,GetPlaceholderInstanceTree,GetRigVisualization,GetUploadStatus,HasAnimation,IsAvatar,IsGltf,IsR15,Reset,usesCustomRestPoseLua||;IncrementalPatchBuilder<Instance|||AddPathsToBundle:bool,BuildDebouncePeriod:double,HighCompression:bool,SerializePatch:bool,UseFileLevelCompressionInsteadOfChunk:bool,ZstdCompression:bool;InputAction<Instance|Fire,GetInputBindings,GetPreferredBindingList,GetState|InputBindingsChanged,Pressed,Released,StateChanged|BoolState:bool,Direction1DState:float,Direction2DState:Vector2,Direction3DState:Vector3,Enabled:bool,PreferredBinding:InputBinding,Type:InputActionType,ViewportPositionState:Vector2;InputBinding<Instance|Fire||Backward:KeyCode,ClampMagnitudeToOne:bool,DisplayImage:Content,DisplayName:string,Down:KeyCode,Forward:KeyCode,KeyCode:KeyCode,Left:KeyCode,PointerIndex:int,PressedThreshold:float,PrimaryModifier:KeyCode,ReleasedThreshold:float,ResponseCurve:float,Right:KeyCode,Scale:float,SecondaryModifier:KeyCode,Type:InputBindingType,UIButton:GuiButton,UIModifier:GuiButton,Up:KeyCode,Vector2Scale:Vector2,Vector3Scale:Vector3;InputContext<Instance|GetInputActions|InputActionsChanged|Enabled:bool,Priority:int,Sink:bool;InputObject<Instance|IsModifierKeyDown||Delta:Vector3,KeyCode:KeyCode,Position:Vector3,UserInputState:UserInputState,UserInputType:UserInputType;InsertService<Instance|ApproveAssetId,ApproveAssetVersionId,GetLocalFileContents,Insert,LoadLocalAsset,CreateMeshPartAsync,GetBaseCategories,GetBaseSets,GetCollection,GetFreeDecals,GetFreeDecalsAsync,GetFreeModels,GetFreeModelsAsync,GetLatestAssetVersionAsync,GetUserCategories,GetUserSets,LoadAsset,LoadAssetVersion,LoadAssetWithBytecodeAsync,LoadAssetWithFormat,loadAsset,LoadPackageAssetAsync|InternalDelete|AllowInsertFreeModels:bool;InstanceExtensionsService<Instance|CountChildren||;InstanceFileSyncService<Instance|GetAllInstances,GetStatus,GetSyncedInstance,GetSyncingCollaborators,GetTooltip|StatusChanged,SyncingCollaboratorsChanged|;IntentService<Instance|||;InternalMessagingService<Instance|||;InternalMessagingServiceVerifier<Instance|||;InternalSyncItem<Instance|||AutoSync:bool,Enabled:bool,Path:string,Target:Instance;InternalSyncService<Instance|||;JointInstance<Instance|||Active:bool,C0:CFrame,C1:CFrame,Enabled:bool,Part0:BasePart,Part1:BasePart,part1:BasePart;DynamicRotate<JointInstance|||BaseAngle:float;RotateP<DynamicRotate|||;RotateV<DynamicRotate|||;Glue<JointInstance|||F0:Vector3,F1:Vector3,F2:Vector3,F3:Vector3;ManualSurfaceJointInstance<JointInstance|||;ManualGlue<ManualSurfaceJointInstance|||;ManualWeld<ManualSurfaceJointInstance|||;Motor<JointInstance|SetDesiredAngle||CurrentAngle:float,DesiredAngle:float,MaxVelocity:float,ReplicateCurrentAngle:float;Motor6D<Motor|||ChildName:string,EnableSkinning:bool,ParentName:string,ReplicateCurrentAngle6D:Vector3,ReplicateCurrentOffset6D:Vector3,Transform:CFrame;Rotate<JointInstance|||;Snap<JointInstance|||;VelocityMotor<JointInstance|||CurrentAngle:float,DesiredAngle:float,Hole:Hole,MaxVelocity:float;Weld<JointInstance|||EnableSkinning:bool;JointsService<Instance|ClearJoinAfterMoveJoints,CreateJoinAfterMoveJoints,SetJoinAfterMoveInstance,SetJoinAfterMoveTarget,ShowPermissibleJoints||;KeyboardService<Instance|||;Keyframe<Instance|AddMarker,AddPose,GetMarkers,GetPoses,RemoveMarker,RemovePose||Time:float;KeyframeMarker<Instance|||Value:string;KeyframeSequenceProvider<Instance|GetKeyframeSequence,GetKeyframeSequenceById,GetMemStats,RegisterActiveKeyframeSequence,RegisterKeyframeSequence,GetAnimations,GetAnimationsAsync,GetKeyframeSequenceAsync||;LanguageService<Instance|GetCapabilitiesUsedInPackageAsync||;Light<Instance|||Brightness:float,Color:Color3,Enabled:bool,Shadows:bool;PointLight<Light|||Range:float;SpotLight<Light|||Angle:float,Face:NormalId,Range:float;SurfaceLight<Light|||Angle:float,Face:NormalId,Range:float;Lighting<Instance|GetMinutesAfterMidnight,GetMoonDirection,GetMoonPhase,GetSunDirection,SetMinutesAfterMidnight,getMinutesAfterMidnight,setMinutesAfterMidnight|LightingChanged|Ambient:Color3,Brightness:float,ClockTime:float,ColorShift_Bottom:Color3,ColorShift_Top:Color3,EnvironmentDiffuseScale:float,EnvironmentSpecularScale:float,ExposureCompensation:float,ExtendLightRangeTo120:RolloutState,FogColor:Color3,FogEnd:float,FogStart:float,GeographicLatitude:float,GlobalShadows:bool,LightingStyle:LightingStyle,OutdoorAmbient:Color3,Outlines:bool,PrioritizeLightingQuality:bool,ShadowColor:Color3,ShadowSoftness:float,Technology:Technology,TimeOfDay:string;LinkingService<Instance|DetectUrl,GetAndClearLastPendingUrl,GetLastLuaUrl,IsUrlRegistered,RegisterLuaUrl,StartLuaUrlDelivery,StopLuaUrlDelivery,OpenUrl,SupportsSwitchToSettingsApp,SwitchToSettingsApp|OnLuaUrl|;LiveScriptingService<Instance||BeginEdit,BeginEditWithUri,BroadcastMessage,EndEdit,FailedToOpen,KickFromEdit,LiveEditingClientConfiguration,OpenedWithSource,SendAtomicOperation,SendAtomicOperationWithUri,SendAtomicUpdateResponse,SendOperation|ServerLiveEditingMode:ServerLiveEditingMode;LiveSyncService<Instance|GetSyncState|SyncStatusChanged|HasSyncedInstances:bool;LocalStorageService<Instance|Flush,GetItem,SetItem,WhenLoaded|ItemWasSet,StoreWasCleared|;AppStorageService<LocalStorageService|||;UserStorageService<LocalStorageService|||;LocalizationService<Instance|GetCorescriptLocalizations,GetIsLoadingInternalTranslations,GetTableEntries,GetTranslatorForPlayer,IsLoadingInternalTranslationsSettingChanged,SetRobloxLocaleId,StartTextScraper,StopTextScraper,GetCountryRegionForPlayerAsync,GetTranslatorForLocaleAsync,GetTranslatorForPlayerAsync,PromptDownloadGameTableToCSV,PromptExportToCSVs,PromptImportFromCSVs,PromptUploadCSVToGameTable|AutoTranslateWillRun,DynamicTranslationServerToClientResponse,TextScraperClientMessageWithPlayerSignal|ForcePlayModeGameLocaleId:string,ForcePlayModeRobloxLocaleId:string,GameSourceLanguageId:string,IsImageCaptureEnabled:bool,IsTextScraperRunning:bool,LocaleManifest:string,RobloxForcePlayModeGameLocaleId:string,RobloxForcePlayModeRobloxLocaleId:string,RobloxLocaleId:string,ShouldUseCloudTable:bool,ShouldUseImageLocalizationTable:bool,SystemLocaleId:string;LocalizationTable<Instance|GetContents,GetEntries,GetString,GetTranslator,RemoveEntry,RemoveEntryValue,RemoveKey,RemoveTargetLocale,SetContents,SetEntries,SetEntry,SetEntryContext,SetEntryExample,SetEntryKey,SetEntrySource,SetEntryValue,SetIsExemptFromUGCAnalytics||Contents:string,DevelopmentLanguage:string,IsExemptFromUGCAnalytics:bool,Root:Instance,SourceLocaleId:string;CloudLocalizationTable<LocalizationTable|||;LodDataEntity<Instance|||EntityData:SharedString,EntityLodEnabled:bool,EntityModelSize:Vector3,EntityPosition:CFrame,EntityScale:Vector3,EntitySource:Instance,EntityVisible:bool,IsSlimEnabled:bool,SlimAnimationSource:SlimAnimationDataEntity,SlimReplicationTimestampSec:double,TranscoderFailureReason:string,TranscoderStatus:SlimTranscoderStatus;LodDataService<Instance||RequestTranscoderStatusTracking|;LogReporterService<Instance|ReportLog,ReportMultipleLogs,SubmitStratusBugReport||;LogService<Instance|ClearOutput,Error,ExecuteScript,GetHttpResultHistory,GetLogHistory,GetLogger,Info,Log,Output,RequestHttpResultApproved,RequestServerHttpResult,RequestServerOutput,Warn,GetLogHistoryAsync|HttpResultOut,MessageOut,OnHttpResultApproved,RequestHttpResultApprovedSignal,RequestScriptExecutionSignal,RequestServerHttpResultSignal,RequestServerOutputSignal,RequestSettingsChange,ServerContextOut,ServerHttpResultOut,ServerMessageOut,ServerVariantMessageOut|;LoginService<Instance|Logout,PromptLogin|LoginFailed,LoginSucceeded|;LuaSettings<Instance|||;LuaSourceContainer<Instance|||CachedRemoteSource:ProtectedString,CachedRemoteSourceLoadState:int,HasAssociatedDrafts:bool,IsDifferentFromFileSystem:bool,SandboxedSource:ProtectedString,ScriptGuid:string,isPlayerScript:bool;AuroraScript<LuaSourceContainer|AddTo,GetSchema,IsOnInstance,RemoveFrom,SignalFired|ChangedThisFrame,SynchronizeState|AuroraScriptBindingsSerialize:BinaryString,EnableCulling:bool,EnableLOD:bool,LODCriticality:int,Priority:int,Source:ProtectedString;BaseScript<LuaSourceContainer|||Disabled:bool,Enabled:bool,LinkedSource:ContentId,RunContext:RunContext;CoreScript<BaseScript|||;Script<BaseScript|GetHash||Source:ProtectedString;LocalScript<Script|||;ModuleScript<LuaSourceContainer|||Confidential:bool,LinkedSource:ContentId,Source:ProtectedString,UnrestrictedRequireAllowed:bool;LuaWebService<Instance|||;LuauExpressionService<Instance|CreateExpression||;LuauScriptAnalyzerService<Instance|||;MLModelDeliveryService<Instance|||;MLService<Instance|IsPostProcessReady,SetPostProcessEnabled,CreateSessionAsync,LoadPostProcessModelAsync||;MakeupDescription<Instance|GetAppliedInstance||AssetId:int64,Instance:Instance,MakeupType:MakeupType,Order:int;MarkerCurve<Instance|GetMarkerAtIndex,GetMarkers,InsertMarkerAtTime,RemoveMarkerAtIndex||Length:int,ValuesAndTimes:BinaryString;MarketplaceService<Instance|BindReceiptHandler,ClearProductInfoCaches,IsPurchaseSimulated,OpenShop,PlayerCanMakePurchases,PrepareCollectiblesPurchase,PromptBulkPurchase,PromptBundlePurchase,PromptCancelSubscription,PromptCollectiblesPurchase,PromptGamePassPurchase,PromptNativePurchase,PromptNativePurchaseWithLocalPlayer,PromptNativePurchaseWithLocalPlayerWithPaymentSessionId,PromptNativePurchaseWithPaymentSessionId,PromptPremiumPurchase,PromptProductPurchase,PromptPurchase,PromptRobloxPurchase,PromptRobloxSubscriptionPurchase,PromptSubscriptionPurchase,PromptThirdPartyPurchase,ReportAssetSale,ReportRobuxUpsellStarted,SignalAssetTypePurchased,SignalCheckPlayerHasRobloxSubscription,SignalClientPurchaseSuccess,SignalMockPurchasePremium,SignalMockPurchaseRobloxSubscription,SignalPromptBulkPurchaseFinished,SignalPromptBundlePurchaseFinished,SignalPromptGamePassPurchaseFinished,SignalPromptPremiumPurchaseFinished,SignalPromptProductPurchaseFinished,SignalPromptPurchaseFinished,SignalPromptRobloxSubscriptionPurchaseFinished,SignalPromptSubscriptionPurchaseFinished,SignalRobuxTransferCompleted,SignalServerLuaDialogClosed,SignalUserSubscriptionStatusChanged,GetAvailableSubscriptionProductsAsync,GetDeveloperProductsAsync,GetProductInfo,GetProductInfoAsync,GetRobloxSubscriptionDetailsAsync,GetRobuxBalance,GetSubscriptionProductInfoAsync,GetSubscriptionPurchaseInfoAsync,GetUserSubscriptionDetailsAsync,GetUserSubscriptionDetailsInternalAsync,GetUserSubscriptionPaymentHistoryAsync,GetUserSubscriptionStatusAsync,GetUsersPriceLevelsAsync,PerformBulkPurchase,PerformCancelSubscription,PerformPurchase,PerformPurchaseV2,PerformSubscriptionPurchase,PerformSubscriptionPurchaseV2,PerformSubscriptionPurchaseV3Async,PerformSubscriptionPurchaseWithRobuxAsync,PlayerOwnsAsset,PlayerOwnsAssetAsync,PlayerOwnsBundle,PlayerOwnsBundleAsync,PromptRobuxTransferAsync,RankProductsAsync,RecommendTopProductsAsync,UserOwnsGamePassAsync|AssetTypePurchased,ClientLuaDialogRequested,ClientPurchaseSuccess,ConfirmPlayerHasRobloxSubscription,ConfirmPlayerMembership,ConfirmUserSubscriptionPurchase,LuaDialogCallbackSignal,MockConfirmUserSubscriptionPurchase,MockPurchasePremium,MockPurchaseRobloxSubscription,NativePurchaseFinished,NativePurchaseFinishedV2,NativePurchaseFinishedWithLocalPlayer,NativePurchaseFinishedWithLocalPlayerV2,OpenShopRequested,PrepareCollectiblesPurchaseRequested,PromptBulkPurchaseFinished,PromptBulkPurchaseRequested,PromptBulkPurchaseRequestedV2,PromptBundlePurchaseFinished,PromptBundlePurchaseRequested,PromptCancelSubscriptionRequested,PromptCollectibleBundlePurchaseRequested,PromptCollectiblesPurchaseRequested,PromptGamePassPurchaseFinished,PromptGamePassPurchaseRequested,PromptNativePurchaseRequested,PromptNativePurchaseRequestedWithLocalPlayer,PromptNativePurchaseRequestedWithLocalPlayerWithPaymentSessionId,PromptNativePurchaseRequestedWithPaymentSessionId,PromptPremiumPurchaseFinished,PromptPremiumPurchaseRequested,PromptProductPurchaseFinished,PromptProductPurchaseRequested,PromptPurchaseFinished,PromptPurchaseRequested,PromptPurchaseRequestedV2,PromptRobloxPurchaseRequested,PromptRobloxSubscriptionPurchaseFinished,PromptRobloxSubscriptionPurchaseRequested,PromptRobuxTransferRequested,PromptRobuxTransferSubscriptionUpsellRequested,PromptSubscriptionPurchaseFinished,PromptSubscriptionPurchaseRequested,PromptThirdPartyPurchaseRequested,RobuxTransferCompleted,ServerPurchaseVerification,ThirdPartyPurchaseFinished,UserSubscriptionStatusChanged|ProcessReceipt;MatchmakingService<Instance|GetServerAttribute,InitializeServerAttributesForStudio,SetServerAttribute||;MaterialGenerationService<Instance|GenerateMaterialVariantsAsync||;MaterialService<Instance|GetBaseMaterialOverride,GetIsMaterialActionAsToolEnabled,GetMaterialOverrideChanged,GetMaterialVariant,GetOverrideStatus,SetBaseMaterialOverride,SetCurrentMaterial,ToggleMaterialFillToolEnabled|MaterialFillToolEnabledChanged,OverrideStatusChanged|AsphaltName:string,BasaltName:string,BrickName:string,CardboardName:string,CarpetName:string,CeramicTilesName:string,ClayRoofTilesName:string,CobblestoneName:string,ConcreteName:string,CorrodedMetalName:string,CrackedLavaName:string,DiamondPlateName:string,FabricName:string,FoilName:string,GlacierName:string,GraniteName:string,GrassName:string,GroundName:string,IceName:string,LeafyGrassName:string,LeatherName:string,LimestoneName:string,MarbleName:string,MetalName:string,MudName:string,PavementName:string,PebbleName:string,PlasterName:string,PlasticName:string,RockName:string,RoofShinglesName:string,RubberName:string,SaltName:string,SandName:string,SandstoneName:string,SlateName:string,SmoothPlasticName:string,SnowName:string,Use2022Materials:bool,Use2022MaterialsXml:bool,WoodName:string,WoodPlanksName:string;MaterialVariant<Instance|||AlphaMode:AlphaMode,AvgMetalness:int,AvgRoughness:int,BaseMaterial:Material,ColorMap:ContentId,ColorMapContent:Content,CustomPhysicalProperties:PhysicalProperties,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,MaterialPattern:MaterialPattern,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,RoughnessMap:ContentId,RoughnessMapContent:Content,StudsPerTile:float,TexturePack:ContentId,TexturePackContent:Content;MemStorageConnection<Instance|Disconnect||;MemStorageService<Instance|Bind,BindAndFire,Call,Fire,GetItem,HasItem,RemoveItem,SetItem||;MemoryStoreDistributedCounter<Instance|GetAsync,IncrementAsync||;MemoryStoreHashMap<Instance|GetAsync,ListItemsAsync,RemoveAsync,SetAsync,UpdateAsync||;MemoryStoreQueue<Instance|AddAsync,GetSizeAsync,ReadAsync,RemoveAsync||;MemoryStoreService<Instance|GetDistributedCounter,GetHashMap,GetQueue,GetSortedMap||;MemoryStoreSortedMap<Instance|GetAsync,GetRangeAsync,GetSizeAsync,RemoveAsync,SetAsync,UpdateAsync||;Message<Instance|||Text:string;Hint<Message|||;MessageBusConnection<Instance|Disconnect||;MessageBusService<Instance|Call,GetLast,GetMessageId,GetProtocolMethodRequestMessageId,GetProtocolMethodResponseMessageId,MakeRequest,Publish,PublishProtocolMethodRequest,PublishProtocolMethodResponse,SetRequestHandler,Subscribe,SubscribeToProtocolMethodRequest,SubscribeToProtocolMethodResponse||;MessagingService<Instance|PublishAsync,SubscribeAsync||;MetaBreakpoint<Instance|GetContextBreakpoints,Remove,SetChildBreakpointEnabledByScriptAndContext,SetContextEnabled,SetContinueExecution,SetEnabled,SetLine,SetRemoveOnHit||Condition:string,ContinueExecution:bool,Enabled:bool,Id:int,IsLogpoint:bool,Line:int,LogMessage:string,RemoveOnHit:bool,Script:string,Valid:bool;MetaBreakpointContext<Instance|||ContextDataInternal:string;MetaBreakpointManager<Instance|AddBreakpoint,GetBreakpointById,RemoveBreakpointById|MetaBreakpointAdded,MetaBreakpointChanged,MetaBreakpointRemoved,MetaBreakpointSetChanged|;MicroProfilerService<Instance|GetDataInRange,GetDataSize,ProcessCommand,DumpToFileAsync|DataChanged|ContextLabel:string;ModerationService<Instance|BindReviewableContentEventProcessor,CreateReviewableContentKey,CreateReviewableContentAsync,InternalRequestReviewableContentReviewAsync|TriggeredCaptureUpload|;MomentsService<Instance|CheckMomentTextStatusAsync,CreatePostAsync,GenerateMomentTextAsync||;Mouse<Instance||Button1Down,Button1Up,Button2Down,Button2Up,Idle,KeyDown,KeyUp,Move,WheelBackward,WheelForward,keyDown|Hit:CFrame,Icon:ContentId,IconContent:Content,Origin:CFrame,Target:BasePart,TargetFilter:Instance,TargetSurface:NormalId,UnitRay:Ray,ViewSizeX:int,ViewSizeY:int,X:int,Y:int,hit:CFrame,target:BasePart;PlayerMouse<Mouse|||;PluginMouse<Mouse||DragEnter|;MouseService<Instance||MouseEnterStudioViewport,MouseLeaveStudioViewport|;MultipleDocumentInterfaceInstance<Instance||DataModelSessionEnded,DataModelSessionStarted|FocusedDataModelSession:DataModelSession;NetworkMarker<Instance||Received|;NetworkPeer<Instance|InitializeRemoteAllowList,SetOutgoingKBPSLimit||;NetworkClient<NetworkPeer||ConnectionAccepted,ConnectionFailed|;NetworkServer<NetworkPeer|EncryptStringForPlayerId||;NetworkReplicator<Instance|GetPlayer||;ClientReplicator<NetworkReplicator|IsStreamedOut,RequestRCCProfilerData,RequestServerStats|RCCProfilerDataComplete,StatsReceived|;ServerReplicator<NetworkReplicator|||;NetworkSettings<Instance|||EmulatedTotalMemoryInMB:int,FreeMemoryMBytes:float,HttpProxyEnabled:bool,HttpProxyURL:string,InboundNetworkJitterMs:float,InboundNetworkLossPercent:float,InboundNetworkMinDelayMs:float,IncomingReplicationLag:double,OpenCertManagerDialog:int,OutboundNetworkJitterMs:float,OutboundNetworkLossPercent:float,OutboundNetworkMinDelayMs:float,PrintJoinSizeBreakdown:bool,PrintPhysicsErrors:bool,PrintStreamInstanceQuota:bool,RandomizeJoinInstanceOrder:bool,RenderStreamedRegions:bool,ShowActiveAnimationAsset:bool;NoCollisionConstraint<Instance|||Enabled:bool,Part0:BasePart,Part1:BasePart;Noise<Instance|SampleDirectional,SampleUniform||NoiseType:NoiseType,Seed:int;NotificationService<Instance|ActionEnabled,ActionTaken,CancelAllNotification,CancelNotification,ScheduleNotification,SubscribeToRccEventNamespace,SwitchedToAppShellFeature,GetScheduledNotifications|RccConnectionChanged,RccEventReceived,Roblox17sConnectionChanged,Roblox17sEventReceived,RobloxConnectionChanged,RobloxEventReceived|IsConnected:bool,IsLuaChatEnabled:bool,IsLuaGameDetailsEnabled:bool,SelectedTheme:string;OmniRecommendationsService<Instance|ClearSessionId,GetSessionId,MakeRequest||;OpenCloudApiV1<Instance|CreateModel,CreateUserNotificationAsync||;OpenCloudService<Instance|GetApiV1,RegisterOpenCloud,RegistrationComplete,HttpRequestAsync,InvokeAsync||;OperationGraph<Instance|||;PVInstance<Instance|GetPivot,PivotTo||Origin:CFrame;BasePart<PVInstance|AngularAccelerationToTorque,ApplyAngularImpulse,ApplyImpulse,ApplyImpulseAtPosition,BindToCollisionSummaries,BreakJoints,CanCollideWith,CanSetNetworkOwnership,GetClosestPointOnSurface,GetConnectedParts,GetJoints,GetMass,GetNetworkOwner,GetNetworkOwnershipAuto,GetNoCollisionConstraints,GetPhysicsCost,GetRenderCFrame,GetRootPart,GetTouchingParts,GetVelocityAtPosition,IsGrounded,MakeJoints,Resize,SetNetworkOwner,SetNetworkOwnershipAuto,TorqueToAngularAcceleration,breakJoints,getMass,makeJoints,resize,IntersectAsync,SubtractAsync,UnionAsync|LocalSimulationTouched,NetworkOwnerChanged,OutfitChanged,StoppedTouching,TouchEnded,Touched|Anchored:bool,AssemblyAngularVelocity:Vector3,AssemblyCenterOfMass:Vector3,AssemblyLinearVelocity:Vector3,AssemblyMass:float,AssemblyRootPart:BasePart,AudioCanCollide:bool,BackParamA:float,BackParamB:float,BackSurface:SurfaceType,BackSurfaceInput:InputType,BottomParamA:float,BottomParamB:float,BottomSurface:SurfaceType,BottomSurfaceInput:InputType,BrickColor:BrickColor,CFrame:CFrame,CanCollide:bool,CanQuery:bool,CanTouch:bool,CastShadow:bool,CenterOfMass:Vector3,CollisionGroup:string,CollisionGroupId:int,CollisionGroupReplicate:string,Color:Color3,Color3uint8:Color3uint8,CurrentPhysicalProperties:PhysicalProperties,CustomPhysicalProperties:PhysicalProperties,DraggingV1:bool,Elasticity:float,EnableFluidForces:bool,ExtentsCFrame:CFrame,ExtentsSize:Vector3,Friction:float,FrontParamA:float,FrontParamB:float,FrontSurface:SurfaceType,FrontSurfaceInput:InputType,LeftParamA:float,LeftParamB:float,LeftSurface:SurfaceType,LeftSurfaceInput:InputType,LocalTransparencyModifier:float,Locked:bool,Mass:float,Massless:bool,Material:Material,MaterialVariant:string,MaterialVariantSerialized:string,NetworkIsSleeping:bool,NetworkOwnerV3:SystemAddress,NetworkOwnershipRule:NetworkOwnership,Orientation:Vector3,PhysicsRepRootPart:BasePart,PhysicsRepRootRef:InstanceRef,PivotOffset:CFrame,Position:Vector3,ReceiveAge:float,Reflectance:float,ReplicationPV:ReplicationPV,ResizeIncrement:int,ResizeableFaces:Faces,RightParamA:float,RightParamB:float,RightSurface:SurfaceType,RightSurfaceInput:InputType,RootPriority:int,RotVelocity:Vector3,Rotation:Vector3,Size:Vector3,SpecificGravity:float,TopParamA:float,TopParamB:float,TopSurface:SurfaceType,TopSurfaceInput:InputType,Transparency:float,Velocity:Vector3,brickColor:BrickColor,siz:Vector3,size:Vector3;CornerWedgePart<BasePart|||;FormFactorPart<BasePart|||FormFactor:FormFactor,formFactor:FormFactor,formFactorRaw:FormFactor;Part<FormFactorPart|||Shape:PartType,shap:PartType,shape:PartType;FlagStand<Part||FlagCaptured|TeamColor:BrickColor;Platform<Part||RemoteCreateMotor6D,RemoteDestroyMotor6D|;Seat<Part|Sit|RemoteCreateSeatWeld,RemoteDestroySeatWeld|Disabled:bool,Occupant:Humanoid;SkateboardPlatform<Part|ApplySpecificImpulse|Equipped,MoveStateChanged,RemoteCreateMotor6D,RemoteDestroyMotor6D,Unequipped,equipped,unequipped|Controller:SkateboardController,ControllingHumanoid:Humanoid,MoveState:MoveState,Steer:int,StickyWheels:bool,Throttle:int;SpawnLocation<Part|||AllowTeamChangeOnTouch:bool,Duration:int,Enabled:bool,Neutral:bool,TeamColor:BrickColor;WedgePart<FormFactorPart|||;Terrain<BasePart|AutowedgeCell,AutowedgeCells,CanSmoothVoxelsBeUpgraded,CellCenterToWorld,CellCornerToWorld,Clear,ClearVoxelsAsync_beta,ConvertToSmooth,CopyRegion,CountCells,CreateVoxelBuffer_beta,FillBall,FillBallSlot,FillBlock,FillBlockSlot,FillCylinder,FillCylinderSlot,FillRegion,FillRegionSlot,FillWedge,FillWedgeSlot,GenerateWaterFlowMap,GetCell,GetMaterialColor,GetMaterialSlot,GetTerrainWireframe,GetWaterCell,IterateVoxelsAsync_beta,ModifyVoxelsAsync_beta,PasteRegion,ReadVoxelChannels,ReadVoxels,ReadVoxelsAsync_beta,ReplaceMaterial,ReplaceMaterialInTransform,ReplaceMaterialInTransformSubregion,ReplaceMaterialInTransformSubregionSlot,ResetMaterialSlot,ResetWaterFlowMap,SetCell,SetCells,SetMaterialColor,SetMaterialInTransform,SetMaterialInTransformSubregion,SetMaterialInTransformSubregionSlot,SetMaterialSlot,SetWaterCell,SmoothRegion,SmoothRegionMaterialSlots,WorldToCell,WorldToCellPreferEmpty,WorldToCellPreferSolid,WriteVoxelChannels,WriteVoxels,WriteVoxelsAsync_beta,DrawBufferAsync,ReadBufferAsync|GridBackendReloadRequired|AcquisitionMethod:TerrainAcquisitionMethod,ClusterGrid:string,ClusterGridV2:string,ClusterGridV3:BinaryString,Decoration:bool,ExpandedTerrainResolved:bool,GrassLength:float,IsSmooth:bool,LastUsedModificationMethod:TerrainAcquisitionMethod,MaterialColors:BinaryString,Materials:SharedString,MaxExtents:Region3int16,PhysicsGrid:BinaryString,SmoothGrid:BinaryString,SmoothVoxelsUpgraded:bool,VoxelGridAssetContentMap:AssetContentMap,WaterColor:Color3,WaterReflectance:float,WaterTransparency:float,WaterWaveSize:float,WaterWaveSpeed:float;TriangleMeshPart<BasePart|||AeroMeshData:SharedString,CollisionFidelity:CollisionFidelity,CollisionPrecision:float,ConvexDecompHolder:NetAssetRef,FluidFidelity:FluidFidelity,FluidFidelityInternal:FluidFidelity,InertiaMigrated:bool,MeshSize:Vector3,PCDRequestId:int,PhysicalConfigData:SharedString,UnscaledCofm:Vector3,UnscaledVolInertiaDiags:Vector3,UnscaledVolInertiaOffDiags:Vector3,UnscaledVolume:float;MeshPart<TriangleMeshPart|ApplyMesh||AlternateMeshHash:int64,DoubleSided:bool,HasJointOffset:bool,HasSkinnedMesh:bool,InitialSize:Vector3,JointOffset:Vector3,MeshContent:Content,MeshID:ContentId,MeshId:ContentId,PhysicsData:BinaryString,RenderFidelity:RenderFidelity,RenderFidelityReplicate:RenderFidelity,SolidMeshHolder:NetAssetRef,TextureContent:Content,TextureID:ContentId,VertexCount:int;PartOperation<TriangleMeshPart|SubstituteGeometry||AssetId:ContentId,ChildData:BinaryString,ChildData2:SharedString,ComponentIndex:int,Content:Content,DCDPropertyData:CSGPropertyData,FormFactor:FormFactor,InitialSize:Vector3,ManifoldMesh_DEPRECATED:SharedString,MeshData:BinaryString,MeshData2:SharedString,OffCentered:bool,PhysicsData:BinaryString,RenderFidelity:RenderFidelity,SmoothingAngle:float,SolidMeshHolder:NetAssetRef,TriangleCount:int,UsePartColor:bool;IntersectOperation<PartOperation|||;NegateOperation<PartOperation|||PreviousOperation:NegateOperationHiddenHistory;UnionOperation<PartOperation|||;TrussPart<BasePart|||Style:Style,style:Style;VehicleSeat<BasePart|Sit|RemoteCreateSeatWeld,RemoteDestroySeatWeld|AreHingesDetected:int,Disabled:bool,HeadsUpDisplay:bool,MaxSpeed:float,Occupant:Humanoid,Steer:int,SteerFloat:float,Throttle:int,ThrottleFloat:float,Torque:float,TurnSpeed:float;Camera<PVInstance|GetLargestCutoffDistance,GetPanSpeed,GetPartsObscuringTarget,GetRenderCFrame,GetRoll,GetTiltSpeed,Interpolate,PanUnits,ScreenPointToRay,SetCameraPanMode,SetImageServerView,SetRoll,TiltUnits,ViewportPointToRay,WorldToScreenPoint,WorldToViewportPoint,Zoom,ZoomToExtents|FirstPersonTransition,InterpolationFinished|CFrame:CFrame,CameraSubject:Instance,CameraType:CameraType,CoordinateFrame:CFrame,DiagonalFieldOfView:float,FieldOfView:float,FieldOfViewMode:FieldOfViewMode,Focus:CFrame,HeadLocked:bool,HeadScale:float,MaxAxisFieldOfView:float,NearPlaneZ:float,VRTiltAndRollEnabled:bool,ViewportSize:Vector2,focus:CFrame;ViewportCamera<Camera|||;Model<PVInstance|AddPersistentPlayer,BreakJoints,GetBoundingBox,GetExtentsSize,GetModelCFrame,GetModelSize,GetPersistentPlayers,GetPrimaryPartCFrame,GetScale,MakeJoints,MoveTo,RemovePersistentPlayer,ResetOrientationToIdentity,ScaleTo,SetIdentityOrientation,SetPrimaryPartCFrame,TranslateBy,breakJoints,makeJoints,move,moveTo||LevelOfDetail:ModelLevelOfDetail,LodEntity:LodDataEntity,ModelMeshCFrame:CFrame,ModelMeshData:SharedString,ModelMeshSize:Vector3,ModelStreamingMode:ModelStreamingMode,NeedsPivotMigration:bool,PrimaryPart:BasePart,Scale:float,ScaleFactor:float,SlimAnimationTarget:SlimAnimationDataEntity,SlimHash:SharedString,WorldPivot:CFrame,WorldPivotData:OptionalCoordinateFrame;Actor<Model|BindToMessage,BindToMessageParallel,SendMessage||;BackpackItem<Model|||TextureContent:Content,TextureId:ContentId;HopperBin<BackpackItem|Disable,ToggleSelect|Deselected,ReplicatedSelected,Selected|Active:bool,BinType:BinType,Command:string,TextureName:string;Tool<BackpackItem|Activate,Deactivate|Activated,Deactivated,Equipped,Unequipped,VRLaserPointerClicked|CanBeDropped:bool,Enabled:bool,Grip:CFrame,GripForward:Vector3,GripPos:Vector3,GripRight:Vector3,GripUp:Vector3,ManualActivationOnly:bool,RequiresHandle:bool,ToolTip:string;Flag<Tool|||TeamColor:BrickColor;ProceduralModel<Model|ForceGeneration,WaitForGenerationAsync||Dirty:bool,GenerationError:string,Generator:ModuleScript,Size:Vector3;Status<Model|||;WorldRoot<Model|ArePartsTouchingOthers,Blockcast,BulkMoveTo,CacheCurrentTerrain,ClearCachedTerrain,CollisionGroupSetCollidable,CollisionGroupsAreCollidable,FindPartOnRay,FindPartOnRayWithIgnoreList,FindPartOnRayWithWhitelist,FindPartsInRegion3,FindPartsInRegion3WithIgnoreList,FindPartsInRegion3WithWhiteList,GetAwakeContactNormals,GetAwakeContactParts,GetAwakeContactPositions,GetAwakeRootParts,GetMaxCollisionGroups,GetPartBoundsInBox,GetPartBoundsInRadius,GetPartsInPart,GetRegisteredCollisionGroups,IKMoveTo,IsCollisionGroupRegistered,IsRegion3Empty,IsRegion3EmptyWithIgnoreList,Raycast,RaycastCachedTerrain,RegisterCollisionGroup,RenameCollisionGroup,SetInsertPoint,Shapecast,Simulate,Spherecast,StepPhysics,UnregisterCollisionGroup,findPartOnRay,findPartsInRegion3|CollisionGroupCollidableChanged|AutoSimulate:bool,CollisionGroupData:BinaryString,GravityDirection:Vector3,PhysicsStepTime:float,SimulationRate:float,Wind:float,WindDirection:Vector3;Workspace<WorldRoot|ApplyRecommendedStreamingSettings,BreakJoints,CalculateJumpDistance,CalculateJumpHeight,CalculateJumpPower,ExperimentalSolverIsEnabled,GetNumAwakeParts,GetPhysicsThrottling,GetRealPhysicsFPS,GetServerTimeNow,JoinToOutsiders,MakeJoints,PGSIsEnabled,SetAvatarUnificationMode,SetMeshPartHeadsAndAccessories,SetPhysicsThrottleEnabled,UnjoinFromOutsiders,ZoomToExtents|PersistentLoaded,SendServerTime|AirDensity:float,AirTurbulenceIntensity:float,AllowThirdPartySales:bool,AuthorityMode:AuthorityMode,AvatarUnificationMode:AvatarUnificationMode,ClientAnimatorThrottling:ClientAnimatorThrottlingMode,CollisionGroups:string,CurrentCamera:Camera,DataModelPlaceVersion:int,DistributedGameTime:double,EnableSLIMAvatars:RolloutState,ExpandedTerrain:RolloutState,ExplicitAutoJoints:bool,FallHeightEnabled:bool,FallenPartsDestroyHeight:float,FilteringEnabled:bool,FluidForces:FluidForces,GlobalWind:Vector3,Gravity:float,IKControlConstraintSupport:IKControlConstraintSupport,ImprovedAnimationConstraint:RolloutState,ImprovedPhysicsReplication:RolloutState,InsertPoint:Vector3,InterpolationThrottling:InterpolationThrottlingMode,LayeredClothingCacheOptimizations:RolloutState,LuauTypeCheckMode:LuauTypeCheckMode,MapTVRemoteToGamepadKeycodes:RolloutState,MeshPartHeadsAndAccessories:MeshPartHeadsAndAccessories,MeshStreamingAndImprovedLods:RolloutState,ModelStreamingBehavior:ModelStreamingBehavior,NextGenerationReplication:RolloutState,NextGenerationReplicationAlias:RolloutState,PathfindingUseImprovedSearch:PathfindingUseImprovedSearch,PhysicsSteppingMethod:PhysicsSteppingMethod,PlayerCharacterDestroyBehavior:PlayerCharacterDestroyBehavior,PlayerScriptsUseInputActionSystem:RolloutState,PlayerScriptsUseInputActionSystemAlias:RolloutState,PredictiveStreamingMode:PredictiveStreamingMode,PrimalPhysicsSolver:PrimalPhysicsSolver,RejectCharacterDeletions:RejectCharacterDeletions,RenderingCacheOptimizations:RenderingCacheOptimizationMode,ReplicateInstanceDestroySetting:ReplicateInstanceDestroySetting,Retargeting:AnimatorRetargetingMode,SandboxedInstanceMode:SandboxedInstanceMode,SignalBehavior:SignalBehavior,SignalBehavior2:SignalBehavior,SignalBehaviorAlias:SignalBehavior,StreamOutBehavior:StreamOutBehavior,StreamingAdaptiveRadius:bool,StreamingEnabled:bool,StreamingEnabledAlias:bool,StreamingIntegrityMode:StreamingIntegrityMode,StreamingMinRadius:int,StreamingPauseMode:StreamingPauseMode,StreamingTargetRadius:int,Terrain:Terrain,TerrainWeldsFixed:bool,ThrottleLevel:int,TouchEventsUseCollisionGroups:RolloutState,TouchesUseCollisionGroups:bool,UseFixedSimulation:RolloutState,UseFixedSimulationAlias:RolloutState,UseInputSink:RolloutState,UseNewLuauTypeSolver:RolloutState,ValidateEnabledProximityPrompt:RolloutState,WatermarkHash:string;WorldModel<WorldRoot|||UseWorkspaceCollisionGroups:bool;PackageLink<Instance|getOverrides||AutoUpdate:bool,CanAutoUpdate:bool,Creator:string,DefaultName:string,HasNewVersion:bool,ModifiedState:int,PackageAssetName:string,PackageContent:Content,PackageContentSerialize:Content,PackageGuid:int64,PackageId:ContentId,PackageIdSerialize:ContentId,SerializedDefaultAttributes:BinaryString,VersionIdSerialize:int64,VersionNumber:int64,PermissionLevel:PackagePermission,Status:string;PackageService<Instance|GetOverrides,UpdateAsync|OverrideStateChanged,OverridesCleared|;PackageUIService<Instance|ConvertToMockPackage,ConvertToPackageClosedCallback,ConvertToPackageUpload,ConvertToPackageAsync,GetPackageInfo,PublishPackage,SetPackageVersion|OnConvertToPackageResult,OnOpenConvertToPackagePlugin|;Packages<Instance|||IsDehydrated:bool,ShellPackagesCount:int,SkippedInstancesCount:int;Pages<Instance|GetCurrentPage,AdvanceToNextPageAsync||IsFinished:bool;AudioPages<Pages|||;BanHistoryPages<Pages|||;CapturesPages<Pages|||;CatalogPages<Pages|||;DataStoreKeyPages<Pages|||Cursor:string;DataStoreListingPages<Pages|||Cursor:string;DataStorePages<Pages|||;DataStoreVersionPages<Pages|||;FriendPages<Pages|||;InventoryPages<Pages|||;MemoryStoreHashMapPages<Pages|||;OutfitPages<Pages|||;RecommendationPages<Pages|||;StandardPages<Pages|||;PartOperationAsset<Instance|||ChildData:BinaryString,MeshData:BinaryString;ParticleEmitter<Instance|Clear,Emit,FastForward|OnClearRequested,OnEmitRequested|Acceleration:Vector3,Brightness:float,Color:ColorSequence,Drag:float,EmissionDirection:NormalId,Enabled:bool,FlipbookBlendFrames:bool,FlipbookFramerate:NumberRange,FlipbookIncompatible:string,FlipbookLayout:ParticleFlipbookLayout,FlipbookMode:ParticleFlipbookMode,FlipbookSizeX:int,FlipbookSizeY:int,FlipbookStartRandom:bool,Lifetime:NumberRange,LightEmission:float,LightInfluence:float,LocalTransparencyModifier:float,LockedToPart:bool,Orientation:ParticleOrientation,Rate:float,RotSpeed:NumberRange,Rotation:NumberRange,Shape:ParticleEmitterShape,ShapeInOut:ParticleEmitterShapeInOut,ShapePartial:float,ShapeStyle:ParticleEmitterShapeStyle,Size:NumberSequence,Speed:NumberRange,SpreadAngle:Vector2,Squash:NumberSequence,Texture:ContentId,TextureContent:Content,TimeScale:float,Transparency:NumberSequence,VelocityInheritance:float,VelocitySpread:float,WindAffectsDrag:bool,ZOffset:float;PartyEmulatorService<Instance|CreateNewParty,DeleteParty,GetEmulatedPartyConfiguration,GetIsEmulationEnabled,OnTestPlayerCountChanged,SetIsEmulationEnabled,SetPlayerPartyId,applyPartyIdToPlayer,GetEmulatedPartyAsync|ConfigurationChanged|;PatchBundlerFileWatch<Instance|||;PatchMapping<Instance|||FlattenTree:bool,PatchId:string,TargetPath:string;Path<Instance|GetPointCoordinates,GetWaypoints,CheckOcclusionAsync,ComputeAsync|Blocked,Unblocked|Status:PathStatus;Path3D<Instance|GetControlPoint,GetControlPoints,GetLength,GetMaxControlPoints,GetPositionOnCurve,GetPositionOnCurveArcLength,GetSegmentCount,GetTangentOnCurve,GetTangentOnCurveArcLength,InsertControlPoint,RemoveControlPoint,SetControlPoints,UpdateControlPoint|ControlPointChanged|;PathfindingLink<Instance|||Attachment0:Attachment,Attachment1:Attachment,IsBidirectional:bool,Label:string;PathfindingModifier<Instance|||Label:string,PassThrough:bool;PathfindingService<Instance|CreatePath,ComputeRawPathAsync,ComputeSmoothPathAsync,FindPathAsync||EmptyCutoff:float;PausedState<Instance|||AllThreadsPaused:bool,Reason:DebuggerPauseReason,ThreadId:int;PausedStateBreakpoint<PausedState|||Breakpoint:Breakpoint;PausedStateException<PausedState|||ExceptionText:string;PerformanceControlService<Instance|IsCrossExperienceLaunchFeasible||;PermissionsService<Instance|GetIsThirdPartyAssetAllowed,GetIsThirdPartyPurchaseAllowed,GetIsThirdPartyTeleportAllowed,GetPermissions,SetPermissions||;PhysicsService<Instance|CollisionGroupContainsPart,CollisionGroupSetCollidable,CollisionGroupsAreCollidable,CreateCollisionGroup,GetCollisionGroupId,GetCollisionGroupName,GetCollisionGroups,GetMaxCollisionGroups,GetRegisteredCollisionGroups,IkSolve,IsCollisionGroupRegistered,LocalIkSolve,RegisterCollisionGroup,RemoveCollisionGroup,RenameCollisionGroup,SetPartCollisionGroup,UnregisterCollisionGroup|CollisionGroupCollidableChanged|;PhysicsSettings<Instance|||AllowSleep:bool,AreAnchorsShown:bool,AreAssembliesShown:bool,AreAssemblyCentersOfMassShown:bool,AreAwakePartsHighlighted:bool,AreBodyTypesShown:bool,AreCollisionCostsShown:bool,AreConstraintForcesShownForSelectedOrHoveredInstances:bool,AreConstraintTorquesShownForSelectedOrHoveredInstances:bool,AreContactForcesShownForSelectedOrHoveredAssemblies:bool,AreContactIslandsShown:bool,AreContactPointsShown:bool,AreGravityForcesShownForSelectedOrHoveredAssemblies:bool,AreJointCoordinatesShown:bool,AreMagnitudesShownForDrawnForcesAndTorques:bool,AreMechanismsShown:bool,AreModelCoordsShown:bool,AreNonAnchorsShown:bool,AreOwnersShown:bool,ArePartCoordsShown:bool,AreRegionsShown:bool,AreSolverIslandsShown:bool,AreTerrainReplicationRegionsShown:bool,AreTimestepsShown:bool,AreUnalignedPartsShown:bool,AreWorldCoordsShown:bool,CollisionGeomDrawOriginalParts:bool,CollisionGeomMatchPartTransparency:bool,CollisionGeomOverlayTransparency:float,CollisionGeomShowCollidableParts:bool,CollisionGeomShowCollisionGroup:string,CollisionGeomShowQueryableParts:bool,CollisionGeomShowTouchableParts:bool,DisableCSGv2:bool,DisableCSGv3ForPlugins:bool,DrawConstraintsNetForce:bool,DrawContactsNetForce:bool,DrawTotalNetForce:bool,EnableForceVisualizationSmoothing:bool,FluidForceDrawScale:float,ForceCSGv2:bool,ForceDrawScale:float,ForceVisualizationSmoothingSteps:int,IsInterpolationThrottleShown:bool,IsReceiveAgeShown:bool,IsTreeShown:bool,PhysicsEnvironmentalThrottle:EnviromentalPhysicsThrottle,ShowDecompositionGeometry:bool,ShowFluidForcesForSelectedOrHoveredMechanisms:bool,ShowInstanceNamesForDrawnForcesAndTorques:bool,SolverConvergenceMetricType:SolverConvergenceMetricType,SolverConvergenceVisualizationMode:SolverConvergenceVisualizationMode,ThrottleAdjustTime:double,TorqueDrawScale:float,UseCSGv2:bool;PinShortcutService<Instance|IsAvailable,IsRevealPinnedExperienceAvailable,PinExperience,RevealPinnedExperience,ShouldShowLuaNotificationOnPinExperienceCompleted|OnPinExperienceCompleted|;PlaceAssetIdsService<Instance|||;PlaceStatsService<Instance|||;PlacesService<Instance|StartPlaySolo,StopPlaySolo||;PlatformCloudStorageService<Instance|IsUserDataAvailable,GetUserDataAsync,SetUserDataAsync||;PlatformFriendsService<Instance|IsInviteFriendsEnabled,IsProfileEnabled,ShowInviteFriendsUI,ShowProfile,GetPartyMembers||;PlatformLibraries<Instance||RemoteRequireRequest,RemoteRequireResponse|;Player<Instance|AddReplicationFocus,AddReplicationFocusPosition,AddToBlockList,ClearCachedAvatarAppearance,ClearCharacterAppearance,DistanceFromCharacter,GetBlockListInitialized,GetCameraState,GetData,GetFriendStatus,GetGameSessionID,GetGlobalUserId,GetJoinData,GetMouse,GetNetworkPing,GetSeatRequested,GetToolRequested,GetUnder13,HasAppearanceLoaded,HasBlockedPlayer,IsVerified,Kick,LoadBoolean,LoadCharacterAppearance,LoadData,LoadInstance,LoadNumber,LoadString,Move,NotifyAgeCheckPassed,OverrideStreamingRadii,PinStreamingForInstance,PinStreamingForInstanceByUniqueId,PromptAgeCheck,RemoveCharacter,RemoveReplicationFocus,RemoveReplicationFocusPosition,RequestFriendship,RequestSeat,RequestTool,RevokeFriendship,SaveBoolean,SaveData,SaveInstance,SaveNumber,SaveString,SetAccountAge,SetBlockListInitialized,SetCharacterAppearanceJson,SetChatTranslationSettingsLocaleId,SetExperienceSettingsLocaleId,SetHasRobloxSubscription,SetMembershipType,SetModerationAccessKey,SetSuperSafeChat,SetUnder13,UnpinStreamingForInstance,UpdatePlayerBlocked,loadBoolean,loadInstance,loadNumber,loadString,saveBoolean,saveInstance,saveNumber,saveString,GetCanManageAsync,GetFriendsInUniverseAsync,GetFriendsOnline,GetFriendsOnlineAsync,GetFriendsWhoPlayedAsync,GetRankInGroup,GetRankInGroupAsync,GetRoleInGroup,GetRoleInGroupAsync,IsBestFriendsWith,IsFriendsWith,IsFriendsWithAsync,IsInGroup,IsInGroupAsync,LoadCharacter,LoadCharacterAsync,LoadCharacterBlocking,LoadCharacterWithAvatarRules,LoadCharacterWithHumanoidDescription,LoadCharacterWithHumanoidDescriptionAsync,PromptSecurityChallengeAsync,RequestStreamAroundAsync,WaitForDataReady,isFriendsWith,waitForDataReady|BlockListChanged,CharacterAdded,CharacterAppearanceLoaded,CharacterRemoving,Chatted,CloudEditSelectionChanged,FriendStatusChanged,Idled,InstancePinned,InstanceUnpinned,Kill,NotifyAgeCheckPassedReplicated,NotifyStreamingUnpinned,OnTeleport,OnTeleportInternal,OverrideStreamRadii,PauseTeleports,PlayerCharacterLoaded,PlayerChatTranslationSettingsLocaleSetFromLua,PlayerExperienceSettingsLocaleSetFromLua,RemoteFriendRequestSignal,RemoteInsert,RequestStreamingPin,RequestStreamingPinByUniqueId,ScopeCheckInitiated,ScriptSecurityError,SendCameraFrustum,SendMaxClientBandwidthBps,ServerToClientUnfilteredChatReplicate,ServerUpdatedHead,SetShutdownMessage,SimulationRadiusChanged,StatsAvailable,StreamingPinComplete,UnpinStreaming,iradDebugServerReceivedIradRequest|AccountAge:int,AccountAgeReplicate:int,AgeChecked:AgeCheckStatus,AppearanceDidLoad:bool,AutoJumpEnabled:bool,CameraFieldOfView:float,CameraFrustumRequested:bool,CameraMaxZoomDistance:float,CameraMinZoomDistance:float,CameraMode:CameraMode,CameraViewportSize:Vector2,CanLoadCharacterAppearance:bool,Character:Model,CharacterAppearance:string,CharacterAppearanceId:int64,ChararacterRegionId:Vector3,ChatAvailabilityStatus:string,ChatMode:ChatMode,ChatPrivacyMode:ChatPrivacyMode,CloudEditCameraCoordinateFrame:CFrame,CloudEditPlayerActive:bool,CountryRegionCodeReplicate:string,DataComplexity:int,DataComplexityLimit:int,DataReady:bool,DevCameraOcclusionMode:DevCameraOcclusionMode,DevComputerCameraMode:DevComputerCameraMovementMode,DevComputerMovementMode:DevComputerMovementMode,DevEnableMouseLock:bool,DevTouchCameraMode:DevTouchCameraMovementMode,DevTouchMovementMode:DevTouchMovementMode,DisplayName:string,FollowUserId:int64,FollowUserIdReplicated:int64,FrustumStreaming:FrustumStreamingMode,GameplayPaused:bool,Guest:bool,HasRobloxSubscription:bool,HasVerifiedBadge:bool,HealthDisplayDistance:float,InputLatency:int,InternalCharacterAppearanceLoaded:bool,LocaleId:string,MaxSimulationRadius:float,MaximumSimulationRadius:float,MembershipType:MembershipType,MembershipTypeReplicate:MembershipType,NameDisplayDistance:float,NeedRegionalFallback:bool,Neutral:bool,OsPlatform:string,PartyId:string,PendingRequestedTool:Instance,PlatformName:string,RawJoinData:BinaryString,ReplicationFocus:Instance,RespawnLocation:SpawnLocation,SimulationRadius:float,StepIdOffset:int,SuperSafeChatReplicate:bool,Team:Team,TeamColor:BrickColor,Teleported:bool,TeleportedIn:bool,ThirdPartyTextChatRestrictionStatus:ChatRestrictionStatus,UnfilteredChat:bool,User:User,UserId:int64,UserIdModeReplicate:UserIdMode,VRDevice:string,VREnabled:bool,VoiceChatVolume:float,userId:int64;PlayerData<Instance|GetPlayer,GetRecordAsync||;PlayerDataRecord<Instance|GetPlayer,GetValue,GetValueChangedSignal,RemoveValue,SetValue,ReleaseAsync,RequestFlushAsync|Changed,Flushed,Loaded|CreatedTime:int64,DefaultRecordName:bool,Dirty:bool,Error:PlayerDataErrorState,FlushedTime:int64,LoadedTime:int64,ModifiedTime:int64,NewRecord:bool,Readable:bool,RecordName:string,Writable:bool;PlayerDataRecordConfig<Instance|GetDefaultValue,SetDefaultValue||RecordName:string;PlayerDataService<Instance|GetRecordConfig||LoadFailureBehavior:PlayerDataLoadFailureBehavior;PlayerEmulatorService<Instance|GetEmulatedPolicyInfo,RegionCodeWillHaveAutomaticNonCustomPolicies,SetEmulatedPolicyInfo||CustomPoliciesEnabled:bool,EmulatedCountryCode:string,EmulatedGameLocale:string,PlayerEmulationEnabled:bool,PseudolocalizationEnabled:bool,SerializedEmulatedPolicyInfo:BinaryString,TextElongationFactor:int;PlayerHydrationService<Instance||PlayerHydration|;PlayerScripts<Instance|ClearComputerCameraMovementModes,ClearComputerMovementModes,ClearTouchCameraMovementModes,ClearTouchMovementModes,GetRegisteredComputerCameraMovementModes,GetRegisteredComputerMovementModes,GetRegisteredTouchCameraMovementModes,GetRegisteredTouchMovementModes,RegisterComputerCameraMovementMode,RegisterComputerMovementMode,RegisterTouchCameraMovementMode,RegisterTouchMovementMode|ComputerCameraMovementModeRegistered,ComputerMovementModeRegistered,TouchCameraMovementModeRegistered,TouchMovementModeRegistered|;PlayerViewService<Instance|GetDeviceCameraCFrame,GetDeviceCameraCFrameForSelfView,OnCameraCFrameReplicationRequest,UpdateDeviceCFrame||;Players<Instance|Chat,CreateLocalPlayer,CreateThumbnailPlayer,GetPlayerByUserId,GetPlayerFromCharacter,GetPlayers,ReportAbuse,ReportAbuseV3,ReportAvatarAbuse,ReportChatAbuse,ResetLocalPlayer,SetChatStyle,SetLocalPlayerInfo,TeamChat,WhisperChat,getPlayers,playerFromCharacter,players,BanAsync,CreateHumanoidModelFromDescription,CreateHumanoidModelFromDescriptionAsync,CreateHumanoidModelFromUserId,CreateHumanoidModelFromUserIdAsync,GetBanHistoryAsync,GetCharacterAppearanceAsync,GetCharacterAppearanceInfoAsync,GetFriendsAsync,GetHumanoidDescriptionFromOutfitId,GetHumanoidDescriptionFromOutfitIdAsync,GetHumanoidDescriptionFromUserId,GetHumanoidDescriptionFromUserIdAsync,GetNameFromUserIdAsync,GetProfileConfigurationFromUserIdAsync,GetUserIdFromNameAsync,GetUserThumbnailAsync,UnbanAsync|CloudEditApplyEditsMessage,FriendRequestEvent,PlayerAdded,PlayerChatted,PlayerConnecting,PlayerDisconnecting,PlayerMembershipChanged,PlayerRejoining,PlayerRemoving,PromptAgeCheckRequested,PromptGameServerAvatarReportEnrichment,PromptGameServerReportEnrichment,PromptGameServerTargetedChatReportEnrichment,PromptReportServerEnrichmentAndScan,RequestCloudEditKick,RequestCloudEditShutdown,TeamCreateServerMessage,UserSubscriptionStatusChanged|BanningEnabled:bool,BubbleChat:bool,CharacterAutoLoads:bool,ClassicChat:bool,LocalPlayer:Player,MaxPlayers:int,MaxPlayersInternal:int,NumPlayers:int,PreferredPlayers:int,PreferredPlayersInternal:int,RespawnTime:float,ServerGitHash:string,ServerLogPrefix:string,UseStrafingAnimations:bool,localPlayer:Player,numPlayers:int;Plugin<Instance|Activate,CreatePluginAction,CreatePluginMenu,CreateToolbar,Deactivate,FinishFullLoading,GetItem,GetJoinMode,GetMouse,GetPluginComponent,GetSelectedRibbonTool,GetSetting,GetStudioUserId,GetUri,Intersect,Invoke,IsActivated,IsActivatedWithExclusiveMouse,IsLoadedFromProject,Negate,OnInvoke,OnInvokeSuspendOverride,OnSetItem,OpenScript,OpenWikiPage,PauseSound,PlaySound,ResumeSound,SaveSelectedToRoblox,SelectRibbonTool,Separate,SetItem,SetReady,SetSetting,StartDecalDrag,StartDrag,StopAllSounds,Union,CreateDockWidgetPluginGui,CreateDockWidgetPluginGuiAsync,CreateQWidgetPluginGui,ImportFbxAnimation,ImportFbxAnimationAsync,ImportFbxRig,ImportFbxRigAsync,PromptForExistingAssetId,PromptForExistingAssetIdAsync,PromptSaveSelection,PromptSaveSelectionAsync|Deactivation,Ready,Unloading,ViewportDragDropped,ViewportDragEntered,ViewportDragLeft|CollisionEnabled:bool,DisableUIDragDetectorDrags:bool,GridSize:float,HostDataModelType:StudioDataModelType,HostDataModelTypeIsCurrent:bool,IsDebuggable:bool,MultipleDocumentInterfaceInstance:MultipleDocumentInterfaceInstance,UsesAssetInsertionDrag:bool,ProcessAssetInsertionDrag,ProcessAssetInsertionDrop;PluginAction<Instance||Triggered|ActionId:string,AllowBinding:bool,Checked:bool,DefaultShortcut:string,Enabled:bool,StatusTip:string,Text:string,Visible:bool;PluginCapabilities<Instance|||Manifest:string;PluginConnectionService<Instance|CanHaveConnectionType,GetPluginConnectionsOfType|Connected|;PluginDebugService<Instance|||;PluginDragEvent<Instance|||Data:string,MimeType:string,Position:Vector2,Sender:string;PluginGuiService<Instance|||;PluginManagementService<Instance|SetAutoUpdate,GetOTAPluginVersion,ListPluginGuisAsync||;PluginManager<Instance|CreatePlugin,ExportPlace,ExportSelection||;PluginManagerInterface<Instance|CreatePlugin,ExportPlace,ExportSelection||;PluginMenu<Instance|AddAction,AddMenu,AddNewAction,AddSeparator,Clear,ShowAsync||Icon:string,Title:string,Visible:bool;PluginPolicyService<Instance|GetPluginPolicy||;PluginToolbar<Instance|CreateButton,CreatePopupButton||;PluginToolbarButton<Instance|SetActive,SetDropdownActive|Click,DropdownClick|ClickableWhenViewportHidden:bool,Enabled:bool,Icon:ContentId,IconContent:Content;PointsService<Instance|GetAwardablePoints,AwardPoints,GetGamePointBalance,GetPointBalance|PointsAwarded|;PolicyService<Instance|CanViewBrandProjectAsync,GetPolicyInfoForPlayerAsync,GetPolicyInfoForServerRobloxOnlyAsync||IsLuobuServer:TriStateBoolean,LuobuWhitelisted:TriStateBoolean;PopLatencyService<Instance|GetSnapshot,IsEnabled||;PoseBase<Instance|||EasingDirection:PoseEasingDirection,EasingStyle:PoseEasingStyle,Weight:float;NumberPose<PoseBase|||Value:double;Pose<PoseBase|AddSubPose,GetSubPoses,RemoveSubPose||CFrame:CFrame,MaskWeight:float;PostEffect<Instance|||Enabled:bool;BloomEffect<PostEffect|||Intensity:float,Size:float,Threshold:float;BlurEffect<PostEffect|||Size:float;ColorCorrectionEffect<PostEffect|||Brightness:float,Contrast:float,Saturation:float,TintColor:Color3;ColorGradingEffect<PostEffect|||TonemapperPreset:TonemapperPreset;DepthOfFieldEffect<PostEffect|||FarIntensity:float,FocusDistance:float,InFocusRadius:float,NearIntensity:float;SunRaysEffect<PostEffect|||Intensity:float,Spread:float;Preloaded<Instance|||;ProceduralBehaviorSchedulerService<Instance|||;ProcessInstancePhysicsService<Instance|||;ProximityPrompt<Instance|InputHoldBegin,InputHoldEnd|ButtonHoldBeganActionReplicated,ButtonHoldEndedActionReplicated,IndicatorHidden,IndicatorShown,PromptButtonHoldBegan,PromptButtonHoldEnded,PromptHidden,PromptShown,TriggerEnded,TriggerEndedActionReplicated,Triggered,TriggeredActionReplicated|ActionText:string,AutoLocalize:bool,ClickablePrompt:bool,Enabled:bool,Exclusivity:ProximityPromptExclusivity,GamepadKeyCode:KeyCode,HoldDuration:float,KeyboardKeyCode:KeyCode,MaxActivationDistance:float,MaxIndicatorDistance:float,ObjectText:string,RequiresLineOfSight:bool,RootLocalizationTable:LocalizationTable,Style:ProximityPromptStyle,UIOffset:Vector2;ProximityPromptService<Instance||IndicatorHidden,IndicatorShown,PromptButtonHoldBegan,PromptButtonHoldEnded,PromptHidden,PromptShown,PromptTriggerEnded,PromptTriggered|Enabled:bool,MaxIndicatorsVisible:int,MaxPromptsVisible:int;PublishService<Instance|PublishDescendantAssets,TagEmoteAnimation,CreateAssetAndWaitForAssetId,CreateAssetOrAssetVersionAndPollAssetWithTelemetryAsync,CreateAssetOrAssetVersionAndPollAssetWithTelemetryAsyncWithAddParam,CreateAssetOrAssetVersionAndPollAssetWithTelemetryAsyncWithAddParamErrorJson,PublishCageMeshAsync,PublishDescendantAssetsAsync||;QueueService<Instance|GetStandardQueue||;RTAnimationTracker<Instance|Step|TrackerError,TrackerPrompt|Active:bool,EnableFallbackAudioInput:bool,SessionName:string,TrackerMode:TrackerMode,TrackerType:TrackerType;RbxAnalyticsService<Instance|AddGlobalPointsField,AddGlobalPointsTag,DEPRECATED_TrackEvent,DEPRECATED_TrackEventWithArgs,GetClientId,GetPlaySessionId,GetSessionId,ReleaseRBXEventStream,RemoveGlobalPointsField,RemoveGlobalPointsTag,ReportCounter,ReportInfluxSeries,ReportStats,ReportToDiagByCountryCode,SendEventDeferred,SendEventImmediately,SetRBXEvent,SetRBXEventStream,TrackEvent,TrackEventWithArgs,UpdateHeartbeatObject||;RealtimeMedia<Instance|Disconnect,GetConnectedWires,GetInputPins,GetOutputPins,SendMessage,ConnectAsync|AudioInputRequested,OnMessage,WiringChanged|AudioInputActive:bool,ForwardInput:bool,IsConnected:bool;RecommendationService<Instance|LogActionEvent,LogImpressionEvent,LogPreferenceEvent,GenerateItemListAsync,GetRecommendationItemAsync,RegisterItemAsync,RemoveItemAsync,UpdateItemAsync||;ReflectionMetadata<Instance|||;ReflectionMetadataCallbacks<Instance|||;ReflectionMetadataClasses<Instance|||;ReflectionMetadataEnums<Instance|||;ReflectionMetadataEvents<Instance|||;ReflectionMetadataFunctions<Instance|||;ReflectionMetadataItem<Instance|||Browsable:bool,ClassCategory:string,ClientOnly:bool,Constraint:string,Deprecated:bool,EditingDisabled:bool,EditorType:string,FFlag:string,IsBackend:bool,PropertyOrder:int,ScriptContext:string,ServerOnly:bool,SliderScaling:string,UIMaximum:double,UIMinimum:double,UINumTicks:double;ReflectionMetadataClass<ReflectionMetadataItem|||ExplorerImageIndex:int,ExplorerOrder:int,Insertable:bool,PreferredParent:string,ServiceVisibility:ServiceVisibility;ReflectionMetadataEnum<ReflectionMetadataItem|||;ReflectionMetadataEnumItem<ReflectionMetadataItem|||;ReflectionMetadataMember<ReflectionMetadataItem|||;ReflectionMetadataProperties<Instance|||;ReflectionMetadataYieldFunctions<Instance|||;ReflectionService<Instance|GetClass,GetClasses,GetEventsOfClass,GetMethodsOfClass,GetPropertiesOfClass,GetPropertyNames,GetStyledPropertyNames||;RemoteCommandService<Instance|ExecuteCommand,GetExecutingPlayer,GetReceivedUpdateSignal,GetStoppingSignal,SendUpdate,ExecuteCommandAsync|CommandSentFromStudio,OneshotCommandErrorFromRcc,OneshotCommandResultFromRcc,OneshotCommandSentFromStudio,StandardOutMessageFromRcc,StopSentFromStudio,UpdateSentFromRcc,UpdateSentFromStudio|;RemoteCursorService<Instance||BroadcastRemoteCursorPositions,BroadcastRemoteCursorPositionsWithConnectionId,RequestAllRemoteCursorPositionForScript,RequestAllRemoteCursorPositionForScriptWithUri,UpdateClientRemoteCursorPosition,UpdateClientRemoteCursorPositionWithUri|;RemoteDebuggerServer<Instance|||;RemoteFunction<Instance|InvokeClient,InvokeServer|RemoteOnInvokeClient,RemoteOnInvokeError,RemoteOnInvokeServer,RemoteOnInvokeSuccess|OnClientInvoke,OnServerInvoke;RenderSettings<Instance|GetMaxQualityLevel||AutoFRMLevel:int,EagerBulkExecution:bool,EditQualityLevel:QualityLevel,EnableFRM:bool,ExportMergeByMaterial:bool,FrameRateManager:FramerateManagerMode,GraphicsMode:GraphicsMode,MeshCacheSize:int,MeshPartDetailLevel:MeshPartDetailLevel,QualityLevel:QualityLevel,ReloadAssets:bool,RenderCSGTrianglesDebug:bool,ShowBoundingBoxes:bool,ViewMode:ViewMode;RenderingTest<Instance|RenderdocTriggerCapture|TestFramesCountdownAboutToStart|CFrame:CFrame,ComparisonDiffThreshold:int,ComparisonMethod:RenderingTestComparisonMethod,ComparisonPsnrThreshold:float,Description:string,FieldOfView:float,Orientation:Vector3,PerfTest:bool,Position:Vector3,QualityAuto:bool,QualityLevel:int,RenderingTestFrameCount:int,ShouldSkip:bool,Ticket:string,Timeout:int;ReplicatedFirst<Instance|IsDefaultLoadingGuiRemoved,IsFinishedReplicating,RemoveDefaultLoadingScreen,SetDefaultLoadingGuiRemoved|DefaultLoadingGuiRemoved,FinishedReplicating,RemoveDefaultLoadingGuiSignal|;ReplicatedStorage<Instance|||;RequestOrchestratorService<Instance|ClearCache,GetBatchWindowDelayMax,GetBatchWindowDelayMin,GetRegisteredOrchestrators,GetResponseDelayMax,GetResponseDelayMin,SetBatchWindowDelay,SetResponseDelay|BatchCreated,BatchExhausted,BatchResponseReceived,BatchRetrying,BatchSent,CacheHit,CacheItemAdded,JitterStarted,OperationCoalesced,OperationEnqueued|;RibbonNotificationService<Instance|OnNotificationUpdateFromPlugin|AllNotificationsReadFromRibbon,NewNotificationFromRibbon,NotificationReadFromRibbon,ToggleNotificationTray|;RobloxPluginGuiService<Instance|||;RobloxReplicatedStorage<Instance|||;RobloxSerializableInstance<Instance|||Data:BinaryString;RobloxServerStorage<Instance|||;RolloutValidation<Instance|||AdditionalFluffOne:int,AdditionalFluffThree:float,AdditionalFluffTwo:bool,CreationVersion:int,FirstBinaryExpectedValue:string,FirstBinaryString:BinaryString,FirstSharedExpectedValue:string,FirstSharedString:SharedString,GenerationStrategy:int,SecondBinaryExpectedValue:string,SecondBinaryString:BinaryString,SecondSharedExpectedValue:string,SecondSharedString:SharedString,ThirdBinaryExpectedValue:string,ThirdBinaryString:BinaryString,ThirdSharedExpectedValue:string,ThirdSharedString:SharedString;RolloutValidationService<Instance|||;RomarkRbxAnalyticsService<Instance|||;RomarkService<Instance|EndRemoteRomarkTest|RomarkEndOfTest|;RotationCurve<Instance|GetKeyAtIndex,GetKeyIndicesAtTime,GetKeys,GetValueAtTime,InsertKey,RemoveKeyAtIndex,SetKeys||Length:int,ValuesAndTimes:BinaryString;RtMessagingService<Instance|||;RunService<Instance|BindToAnimation,BindToRenderStep,BindToSimulation,GetControlAndVariantRolloutFlags,GetCoreScriptVersion,GetPhysicsStepId,GetPredictionStatus,GetRobloxClientChannel,GetRobloxGuiFocused,GetRobloxVersion,GetTotalScriptPlusExecutionTime,IsClient,IsEdit,IsResimulating,IsRunMode,IsRunning,IsServer,IsStudio,IsTeamTest,Pause,Reset,Run,Set3dRenderingEnabled,SetPredictionMode,SetRobloxGuiFocused,Stop,UnbindFromRenderStep,getThrottleFramerateEnabled,setThrottleFramerateEnabled|Heartbeat,Misprediction,PostSimulation,PreAnimation,PreRender,PreSimulation,RenderStepped,RobloxGuiFocusedChanged,Rollback,Stepped|ClientGitHash:string,FrameNumber:int64,RunState:RunState;RuntimeContentService<Instance||RuntimeContentFail,RuntimeContentQuery,RuntimeContentShare|;RuntimeScriptService<Instance|||;SafetyService<Instance|DecodeAvatarMovementProto,ReportBuildUIClose,ReportBuildUIOpen,ReportCapturesUIClose,ReportCapturesUIOpen,ReportChatLineReportingClose,ReportChatLineReportingOpen,ReportChatSuspensionDialogClose,ReportChatSuspensionDialogOpen,ReportMenuTabClose,ReportMenuTabOpen,ReportPartyChatWindowClose,ReportPartyChatWindowOpen,TakeScreenshot|FSTriggeredSignal,ScreenshotContentReady,ScreenshotUploaded|IsCaptureModeForReport:bool;SceneAnalysisService<Instance|GetAnimationMemoryAsync,GetAudioMemoryAsync,GetInstanceCompositionAsync,GetScriptMemoryAsync,GetTriangleCompositionAsync,GetUnparentedInstancesAsync||;ScreenshotHud<Instance|||CameraButtonIcon:ContentId,CameraButtonIconContent:Content,CameraButtonPosition:UDim2,CloseButtonPosition:UDim2,CloseWhenScreenshotTaken:bool,ExperienceNameOverlayEnabled:bool,HideCoreGuiForCaptures:bool,HidePlayerGuiForCaptures:bool,OverlayFont:Font,UsernameOverlayEnabled:bool,Visible:bool;ScriptBuilder<Instance|||;SyncScriptBuilder<ScriptBuilder|||CompileTarget:CompileTarget,CoverageInfo:bool,DebugInfo:bool,PackAsSource:bool,RawBytecode:bool;ScriptChangeService<Instance||ScriptAdded,ScriptBeingRemoved,ScriptChanged,ScriptFullNameChanged,ScriptSourceChanged|;ScriptCloneWatcher<Instance|||;ScriptCloneWatcherHelper<Instance|||;ScriptCommitService<Instance|||;ScriptContext<Instance|AddCoreScriptLocal,CompressLuaApp,EnableCoverage,GetCoverageStats,GetLuauHeapInstanceReferenceReport,GetLuauHeapMemoryReport,ReportLuaRequireCount,SetTimeout|Error,ErrorDetailed|ScriptsDisabled:bool;ScriptDebugger<Instance|AddWatch,GetBreakpoints,GetGlobals,GetLocals,GetStack,GetUpvalues,GetWatchValue,GetWatches,SetBreakpoint,SetGlobal,SetLocal,SetUpvalue|BreakpointAdded,BreakpointRemoved,EncounteredBreak,Resuming,WatchAdded,WatchRemoved|CoreScriptIdentifier:string,CurrentLine:int,IsDebugging:bool,IsPaused:bool,Script:Instance,ScriptGuid:string;ScriptDebuggerService<Instance|AddBreakpoint,ClearBreakpoints,Evaluate,GetRootVariables,GetStackTrace,GetThreads,GetVariables,Pause,RemoveBreakpoint,SetExceptionBreakMode|Resumed|OnStopped;ScriptDocument<Instance|GetInternalUri,GetLine,GetLineCount,GetScript,GetSelectedText,GetSelection,GetSelectionEnd,GetSelectionStart,GetText,GetViewport,HasSelectedText,IsCommandBar,CloseAsync,EditTextAsync,ForceSetSelectionAsync,MultiEditTextAsync,RequestSetSelectionAsync,ReviewableTextEditsAsync|SelectionChanged,ViewportChanged|;ScriptEditorService<Instance|ClearUriScript,DeregisterAutocompleteCallback,DeregisterScriptAnalysisCallback,FindScriptDocument,ForceReloadSource,GetEditorSource,GetScriptDocuments,IsAutocompleteCallbackRegistered,IsScriptAnalysisCallbackRegistered,RegisterAutocompleteCallback,RegisterScriptAnalysisCallback,SetUriScript,StripComments,EditSourceAsyncWithRanges,OpenScriptDocumentAsync,OpenTemporaryDocumentAsync,UpdateSourceAsync|TextDocumentDidChange,TextDocumentDidClose,TextDocumentDidOpen|;ScriptProfilerService<Instance|ClientRequestData,ClientStart,ClientStop,DeserializeJSON,SaveScriptProfilingData,ServerRequestData,ServerStart,ServerStop|OnNewData,RequestData,SetProfilingState|;ScriptRegistrationService<Instance|GetSourceContainerByScriptGuid||;ScriptRuntime<Instance|||;ScriptScannerService<Instance||MoveScriptsCompleted,RequestKnownScriptGuids,RequestMoveSuspiciousScripts,SendKnownScriptGuids|;ScriptService<Instance|ResolveModulePath||;Selection<Instance|Add,AddFocusCallback,ClearTerrainSelectionHack,Get,Remove,Set,SetTerrainSelectionHack|SelectionChanged,SelectionChangedThisFrame|ActiveInstance:Instance,RenderMode:SelectionRenderMode,SelectionBoxThickness:float,SelectionLineThickness:int,SelectionThickness:float,ShowActiveInstanceHighlight:bool;SelectionHighlightManager<Instance|||;SensorBase<Instance|Sense|OnSensorOutputChanged|UpdateType:SensorUpdateType;AtmosphereSensor<SensorBase|||AirDensity:float,RelativeWindVelocity:Vector3;BuoyancySensor<SensorBase|||FullySubmerged:bool,TouchingSurface:bool;ControllerSensor<SensorBase|||;ControllerPartSensor<ControllerSensor|||HitFrame:CFrame,HitNormal:Vector3,LadderSearchHeight:float,LadderSearchOffset:float,SearchDistance:float,SensedMaterial:Material,SensedPart:BasePart,SensorMode:SensorMode;FluidForceSensor<SensorBase|EvaluateAsync||CenterOfPressure:Vector3,Force:Vector3,Torque:Vector3;SerializationService<Instance|DeserializeInstancesAsync,SerializeInstancesAsync||;ServerScriptService<Instance|||LoadStringEnabled:bool;ServerStorage<Instance|||;ServiceProvider<Instance|FindService,GetService,getService,service|Close,CloseLate,ServiceAdded,ServiceRemoving|;DataModel<ServiceProvider|getGameTime,SetPlaceId,SetUniverseId,BindToClose,DefineFastFlag,DefineFastInt,DefineFastString,GetEngineFeature,GetFastFlag,GetFastInt,GetFastString,GetJobsInfo,GetMessage,GetPioneerRootPlaceId,GetPioneerSource,GetPlaySessionId,GetRemoteBuildMode,IsContentLoaded,IsGearTypeAllowed,IsLoaded,IsPioneerApp,IsUniverseMetadataLoaded,Load,OpenLogsFolder,OpenScreenshotsFolder,OpenVideosFolder,SetFlagVersion,SetIsLoaded,Shutdown,SetFastFlagForTesting,SetFastIntForTesting,SetFastStringForTesting,GetObjects,GetObjectsAllOrNone,GetObjectsList,HttpGetAsync,HttpPostAsync,SavePlace,GetObjectsAsync,InsertObjectsAndJoinIfLegacyAsync|AllowedGearTypeChanged,GraphicsQualityChangeRequest,ItemChanged,Loaded,ScreenshotReady,ScreenshotSavedToAlbum,ServerLifecycleChanged,ServerLowMemoryWarning,ServerRestartScheduled,UniverseMetadataLoaded|CreatorId:int64,CreatorType:CreatorType,Environment:string,ForceR15:bool,GameId:int64,GearGenreSetting:GearGenreSetting,Genre:Genre,IsPioneerBuild:bool,IsSFFlagsLoaded:bool,JobId:string,MatchmakingType:MatchmakingType,PioneerSource:PioneerSource,PlaceId:int64,PlaceVersion:int,PrivateServerId:string,PrivateServerOwnerId:int64,VIPServerId:string,VIPServerOwnerId:int64,GameAvatarType:GameAvatarType,R15CollisionType:R15CollisionType,lighting:Instance,RunService:RunService,Workspace:Workspace,workspace:Workspace,OnClose;GenericSettings<ServiceProvider|||;GlobalSettings<GenericSettings|GetFFlag,GetFFlagOverrides,GetFFlags,GetFVariable,SetFFlagOverrides||;UserSettings<GenericSettings|IsUserFeatureEnabled,Reset,SaveState||;ServiceVisibilityService<Instance|SetServiceVisibilityPreference|ServiceVisibilityChanged|HiddenServices:BinaryString,VisibleServices:BinaryString;SessionCheckService<Instance|||;SessionService<Instance|AcquireContextFocus,GenerateSessionInfoString,GetBreadcrumbs,GetCreatedTimestampUtcMs,GetHistory,GetMetadata,GetRootSID,GetSessionID,GetSessionTag,IsContextFocused,ReleaseContextFocus,RemoveMetadata,RemoveSession,RemoveSessionsWithMetadataKey,ReplaceSession,SessionExists,SetMetadata,SetSession|SessionChanged|;SharedTableRegistry<Instance|GetSharedTable,SetSharedTable||;Sky<Instance|||CelestialBodiesShown:bool,MoonAngularSize:float,MoonTextureContent:Content,MoonTextureId:ContentId,SkyboxBackContent:Content,SkyboxBk:ContentId,SkyboxDn:ContentId,SkyboxDownContent:Content,SkyboxFrontContent:Content,SkyboxFt:ContentId,SkyboxLeftContent:Content,SkyboxLf:ContentId,SkyboxOrientation:Vector3,SkyboxRightContent:Content,SkyboxRt:ContentId,SkyboxUp:ContentId,SkyboxUpContent:Content,StarCount:int,SunAngularSize:float,SunTextureContent:Content,SunTextureId:ContentId;SlimAnimationDataEntity<Instance|||BoneParentIndices:BinaryString,EntityScale:double,EntitySource:Instance,Handle:int,IsSlimEnabled:bool,NumBones:int,RootIndex:int,SlimInstanceHashes:BinaryString,SlimReplicationTimestampSec:double;SlimAnimationReplicationService<Instance|||;SlimDebugSettings<Instance|GetAvailableTintModes,GetTintMode,SetTintMode||;SlimReplicationService<Instance||ServerUpdateEntities|;SlimService<Instance|||;Smoke<Instance|FastForward||Color:Color3,Enabled:bool,LocalTransparencyModifier:float,Opacity:float,RiseVelocity:float,Size:float,TimeScale:float,opacity_xml:float,riseVelocity_xml:float,size_xml:float;SmoothVoxelsUpgraderService<Instance|Cancel,Start|Status|;SnippetService<Instance|||;SocialService<Instance|GetPlayersByPartyId,HideSelfView,InvokeGameInvitePromptClosed,InvokeIrisInvite,InvokeIrisInvitePromptClosed,InvokeShareSheetClosed,PromptGameInvite,PromptPhoneBook,PromptRsvpToEventCompleted,ShowSelfView,SignalFeedbackSubmissionCompleted,SignalFeedbackSubmissionPermissionDenied,UpdatePlayerPartyData,CanSendCallInviteAsync,CanSendGameInviteAsync,GetEventRsvpStatusAsync,GetExperienceEventAsync,GetPartyAsync,GetUpcomingExperienceEventsAsync,PromptFeedbackSubmissionAsync,PromptLinkSharing,PromptLinkSharingAsync,PromptRsvpToEventAsync|CallInviteStateChanged,GameInvitePromptClosed,IrisInviteInitiated,OpenShareSheetWithLink,PhoneBookPromptClosed,PlayerPartyDataChanged,PromptInviteRequested,PromptIrisInviteRequested,SelfViewHidden,SelfViewVisible,ShareSheetClosed,ShowPromptFeedbackSubmission,ShowPromptFeedbackUnavailable,ShowPromptRsvpToEvent|OnCallInviteInvoked;Sound<Instance|GetUnderlyingAudioPlayer,Pause,Play,Resume,Stop,pause,play,stop|DidLoop,Ended,Loaded,Paused,Played,PlayingUpdatedFromClient,PlayingUpdatedFromServer,Resumed,Stopped,TimePositionUpdatedFromClient,TimePositionUpdatedFromServer,playbackActionSync|AcousticSimulationEnabled:bool,AssetRepresentation:AssetRepresentation,AudioContent:Content,ChannelCount:int,EmitterSize:float,IsLoaded:bool,IsPaused:bool,IsPlaying:bool,IsSpatial:bool,LoopRegion:NumberRange,Looped:bool,MaxDistance:float,MinDistance:float,Pitch:float,PlayOnRemove:bool,PlaybackLoudness:double,PlaybackRegion:NumberRange,PlaybackRegionsEnabled:bool,PlaybackSpeed:float,Playing:bool,PlayingReplicator:bool,RollOffGain:float,RollOffMaxDistance:float,RollOffMinDistance:float,RollOffMode:RollOffMode,SoundGroup:SoundGroup,SoundId:ContentId,TimeLength:double,TimePosition:double,TimePositionReplicator:double,UsageContextPermission:UsageContext,Volume:float,isPlaying:bool,xmlRead_MaxDistance_3:float,xmlRead_MinDistance_3:float;SoundEffect<Instance|||Enabled:bool,Priority:int;ChorusSoundEffect<SoundEffect|||Depth:float,Mix:float,Rate:float;CompressorSoundEffect<SoundEffect|||Attack:float,GainMakeup:float,Ratio:float,Release:float,SideChain:Instance,Threshold:float;CustomSoundEffect<SoundEffect|||;AssetSoundEffect<CustomSoundEffect|||;ChannelSelectorSoundEffect<CustomSoundEffect|||Channel:int;DistortionSoundEffect<SoundEffect|||Level:float;EchoSoundEffect<SoundEffect|||Delay:float,DryLevel:float,Feedback:float,WetLevel:float;EqualizerSoundEffect<SoundEffect|||HighGain:float,LowGain:float,MidGain:float;FlangeSoundEffect<SoundEffect|||Depth:float,Mix:float,Rate:float;PitchShiftSoundEffect<SoundEffect|||Octave:float;ReverbSoundEffect<SoundEffect|||DecayTime:float,Density:float,Diffusion:float,DryLevel:float,WetLevel:float;TremoloSoundEffect<SoundEffect|||Depth:float,Duty:float,Frequency:float;SoundGroup<Instance|||Volume:float;SoundService<Instance|BeginRecording,GetAudioApiByDefault,GetAudioInstances,GetInputDevice,GetInputDevices,GetListener,GetMixerTime,GetOutputDevice,GetOutputDevices,GetSoundMemoryData,InsertAsset,OpenAttenuationCurveEditor,OpenDirectionalCurveEditor,PlayLocalSound,SetAudioApiByDefault,SetInputDevice,SetListener,SetOutputDevice,SetRecordingDevice,SetSoundEnabled,EndRecording,GetRecordingDevices|AudioInstanceAdded,ClientLoggedEvent,DeviceListChanged,OpenAttenuationCurveEditorSignal,OpenAudioCompressorEditorSignal,OpenAudioEqualizerEditorSignal,OpenDirectionalCurveEditorSignal,RequestSttPlatformToken,SttPlatformToken|AcousticSimulationEnabled:bool,AmbientReverb:ReverbType,AudioApiByDefault:RolloutState,CharacterSoundsUseNewApi:RolloutState,DefaultListenerLocation:ListenerLocation,DiffractionEnabled:bool,DistanceFactor:float,DopplerScale:float,IsNewExpForAudioApiByDefault:bool,ListenerCFrame:CFrame,ListenerObject:Instance,ListenerType:ListenerType,OcclusionEnabled:bool,RespectFilteringEnabled:bool,ReverbEnabled:bool,RolloffScale:float,VolumetricAudio:VolumetricAudio;SoundShimService<Instance|||;Sparkles<Instance|FastForward||Color:Color3,Enabled:bool,LocalTransparencyModifier:float,SparkleColor:Color3,TimeScale:float;SpawnerService<Instance|||;StackFrame<Instance|||FrameId:int,FrameName:string,FrameType:DebuggerFrameType,Globals:DebuggerVariable,Line:int,Locals:DebuggerVariable,Populated:bool,Script:string,Upvalues:DebuggerVariable;StandalonePluginScripts<Instance|||;StandardQueue<Instance|BatchCommitAsync,PublishAsync,SubscribeAsync||;StartPageService<Instance|generateTempUrlInContentProvider,getDaysSinceFirstUserLogin,getLocalGamesFromRegistry,getRecentAPIGamesFromRegistry,getTempUrlInContentProvider,isTutorialBannerClosed,isTutorialPopupClosed,openLink,openLocalFile,openPlace,removeAPIGameFromRegistry,removeLocalFileFromRegistry,setTutorialBannerClosed,setTutorialPopupClosed,shouldShowMacOSDeprecationWarning,shouldShowWinOSDeprecationWarning,startTutorial|ImageImportedSignal,LocalGamesFromRegistryUpdatedSignal,RecentApiGamesFromRegistryUpdatedSignal|;StarterGear<Instance|||;StarterPack<Instance|||;StarterPlayer<Instance|ClearDefaults||AllowCustomAnimations:bool,AutoJumpEnabled:bool,AvatarJointUpgrade:RolloutState,AvatarJointUpgrade_SerializedRollout:RolloutState,CameraMaxZoomDistance:float,CameraMinZoomDistance:float,CameraMode:CameraMode,CharacterBreakJointsOnDeath:bool,CharacterJumpHeight:float,CharacterJumpPower:float,CharacterMaxSlopeAngle:float,CharacterUseJumpPower:bool,CharacterWalkSpeed:float,ClassicDeath:bool,CreateDefaultPlayerModule:bool,DevCameraOcclusionMode:DevCameraOcclusionMode,DevComputerCameraMovementMode:DevComputerCameraMovementMode,DevComputerMovementMode:DevComputerMovementMode,DevTouchCameraMovementMode:DevTouchCameraMovementMode,DevTouchMovementMode:DevTouchMovementMode,EnableDynamicHeads:LoadDynamicHeads,EnableMouseLockOption:bool,GameSettingsAssetIDFace:int64,GameSettingsAssetIDHead:int64,GameSettingsAssetIDLeftArm:int64,GameSettingsAssetIDLeftLeg:int64,GameSettingsAssetIDPants:int64,GameSettingsAssetIDRightArm:int64,GameSettingsAssetIDRightLeg:int64,GameSettingsAssetIDShirt:int64,GameSettingsAssetIDTeeShirt:int64,GameSettingsAssetIDTorso:int64,GameSettingsAvatar:GameAvatarType,GameSettingsR15Collision:R15CollisionType,GameSettingsScaleRangeBodyType:NumberRange,GameSettingsScaleRangeHead:NumberRange,GameSettingsScaleRangeHeight:NumberRange,GameSettingsScaleRangeProportion:NumberRange,GameSettingsScaleRangeWidth:NumberRange,HealthDisplayDistance:float,LoadCharacterAppearance:bool,LoadCharacterLayeredClothing:LoadCharacterLayeredClothing,LuaCharacterController:CharacterControlMode,NameDisplayDistance:float,PlaceAvatarRules:Instance,PlayerModuleStatus:int,UserEmotesEnabled:bool;StarterPlayerScripts<Instance|||;StarterCharacterScripts<StarterPlayerScripts|||;StartupMessageService<Instance|ExecuteActionButton,GetStartupMessage||;StateMachineDefinition<Instance|||NodeId:string;StateMachineTransitionDefinition<Instance|||From:Instance,Priority:int,To:Instance,TransitionId:string;Stats<Instance|GetBrowserTrackerId,GetHarmonyQualityLevel,GetMemoryCategoryNames,GetMemoryUsageMbAllCategories,GetMemoryUsageMbForTag,GetTotalMemoryUsageMb,ResetHarmonyMemoryTarget,SetHarmonyMemoryTarget,GetPaginatedMemoryByTexture||ContactsCount:int,DataReceiveKbps:float,DataSendKbps:float,FrameTime:float,HeartbeatTime:float,HeartbeatTimeMs:float,InstanceCount:int,MemoryTrackingEnabled:bool,MovingPrimitivesCount:int,PhysicsReceiveKbps:float,PhysicsSendKbps:float,PhysicsStepTime:float,PhysicsStepTimeMs:float,PrimitivesCount:int,RenderCPUFrameTime:float,RenderGPUFrameTime:float,SceneDrawcallCount:int,SceneTriangleCount:int,ShadowsDrawcallCount:int,ShadowsTriangleCount:int,UI2DDrawcallCount:int,UI2DTriangleCount:int,UI3DDrawcallCount:int,UI3DTriangleCount:int;StatsItem<Instance|GetValue,GetValueString||DisplayName:string;RunningAverageItemDouble<StatsItem|||;RunningAverageItemInt<StatsItem|||;RunningAverageTimeIntervalItem<StatsItem|||;TotalCountTimeIntervalItem<StatsItem|||;StopWatchReporter<Instance|FinishTask,SendReport,StartTask||;Studio<Instance|GetAvailableThemes|ThemeChanged|ActionOnAutoResumeSync:ActionOnAutoResumeSync,ActionOnStopSync:ActionOnStopSync,AutoResumeSyncOnPlaceOpen:bool,AutoUpdateEnabled:bool,AutocompleteAcceptanceBehavior:CompletionAcceptanceBehavior,CameraAltLeftMouseToRotate:bool,CameraKeyMoveSmoothing:bool,CameraMouseMultiplier:float,CameraNavigationModel:CameraNavigationModel,CameraRotateShiftFactor:float,CameraShiftFactor:float,CameraTweenFocus:bool,CameraZoomToMousePosition:bool,CommandBarEnterExec:bool,CommandBarFont:QFont,CommandBarHistoryLen:int,CommandBarLocalState:bool,DefaultInstancesDir:QDir,DefaultScriptSyncFileType:DefaultScriptSyncFileType,DeprecatedObjectsShown:bool,DisplayLanguage:string,DraggerActiveColor:Color3,DraggerLengthFactor:float,DraggerMajorGridIncrement:int,DraggerMaxSoftSnaps:int,DraggerPassiveColor:Color3,DraggerScaleFactor:float,DraggerShowAxisTicks:bool,DraggerShowDraggedPoint:bool,DraggerShowHoverRuler:bool,DraggerShowMeasurement:bool,DraggerShowNegativeAxes:bool,DraggerShowPlanes:bool,DraggerShowTargetSnap:bool,DraggerShowTrackball:bool,DraggerShowWhileDragging:bool,DraggerSoftSnapMarginFactor:float,DraggerSummonMarginFactor:float,DraggerTiltRotateDuration:float,EnableCodeAssist:bool,EnableFindOnType:bool,EnableIndentationRulers:bool,EnableOnTypeAutocomplete:bool,EnableOvertypeMode:bool,EnableSelectionTooltips:bool,EnableStudioStreaming:bool,ExternalEditorMode:ExternalEditorMode,ExternalEditorSelection:QDir,Font:QFont,HintColor:Color3,IconOverrideDir:QDir,IndentationRulerColor:Color3,InformationColor:Color3,LargeFileLineCountThreshold:int,LargeFileThreshold:int,LoadAllBuiltinPluginsInRunModes:bool,LoadInternalPlugins:bool,LoadUserPluginsInRunModes:bool,LocalAssetsFolder:QDir,LuaDebuggerEnabled:bool,LuaDebuggerEnabledAtStartup:bool,MaxFindReplaceAllResults:int,PermissionLevelShown:PermissionLevelShown,PluginDebuggingEnabled:bool,PluginsDir:QDir,PreferredTextSize:PreferredTextSize,ReloadBuiltinPluginsOnChange:bool,ReloadLocalPluginsOnChange:bool,ReviewableChangeAddedTextColor:Color3,ReviewableChangeRemovedTextColor:Color3,Rulers:string,RuntimeUndoBehavior:RuntimeUndoBehavior,ScriptEditorMenuBorderColor:Color3,ScriptEditorShouldShowPluginMethods:bool,ScriptTimeoutLength:int,ShowCorePackagesInExplorer:bool,Theme:Instance,TypeColor:Color3,UseDefaultExternalEditor:bool,VAxisColor:Color3,XAxisColor:Color3,YAxisColor:Color3,ZAxisColor:Color3;StudioAssetService<Instance|ConvertToPackageUpload,FireOnUGCSubmitCompleted,PublishPackage,ResolveSaveInstanceToRoblox,ShowSaveToRoblox,UpdatePublishedPackage,AutoSetupAvatarAsync,AutoSetupSerializedAvatarAsync,CancelAutoSetupAvatarAsync,DEPRECATED_SerializeInstances,PromptSaveInstanceToRobloxAsync,RequestAvatarAutosetupAsync,SerializeInstances|OnConvertToPackageResult,OnPromptSaveInstanceToRobloxAsync,OnPublishPackageResult,OnSaveToRoblox,OnUGCSubmitCompleted|;StudioAttachment<Instance|||AutoHideParent:bool,IsArrowVisible:bool,Offset:Vector2,SourceAnchorPoint:Vector2,TargetAnchorPoint:Vector2;StudioCallout<Instance|SetOnNextClicked||AnchorPoint:Vector2,IsArrowVisible:bool,IsNextVisible:bool,RowName:string,Text:string,Title:string;StudioCameraService<Instance|InFocusMode,InterpolateView,SetFocusLock|FocusStateChanged,OnMouseCaptureBegin,OnMouseCaptureEnd,PointFocused,ShowCameraSpeed,UpdateUI|FocusDistance:float,LockCameraSpeed:bool,LoggingEnabled:bool;StudioCaptureService<Instance|CanCaptureScreenshot,CapturePluginGui,CaptureScreenshot,RequestScreenshotPermissionAsync||;StudioData<Instance|||EnableScriptCollabByDefaultOnLoad:bool;StudioDeviceEmulatorService<Instance|EmulatePCDeviceWithResolution,GetCurrentDeviceId,GetCurrentOrientation,HasDeviceWithId,SetCurrentDeviceId,SetCurrentOrientation|CurrentDeviceIdChanged,OrientationChanged|;StudioDeviceSimulatorService<Instance|CreateDeviceAsync,GetDeviceAsync,GetDeviceInfoAsync,GetDeviceListAsync,GetOrientationAsync,GetPixelDensityAsync,GetResolutionAsync,GetScalingModeAsync,RemoveDeviceAsync,SetDeviceAsync,SetOrientationAsync,SetPixelDensityAsync,SetResolutionAsync,SetScalingModeAsync,StopSimulationAsync,UpdateDeviceAsync|ConfigurationChanged|;StudioObjectBase<Instance|||;StudioWidget<StudioObjectBase|Resize,SetFixedSize,SetMinSize||;StudioPublishService<Instance|ClearUploadNames,CloseAfterPublish,PublishAs,PublishThenTurnOnTeamCreate,RefreshDocumentDisplayName,RegisterPublishHold,SaveOrPublishPlaceToRobloxIsCanceled,SetTeamCreateOnPublishInfo,SetUniverseDisplayName,SetUploadNames,ShowSaveOrPublishPlaceToRoblox|GameNameUpdated,GamePublishCancelled,GamePublishFinished,OnPublishAttempt,OnSaveOrPublishPlaceToRoblox|PublishLocked:bool;StudioScreenshotCapture<Instance|GetBuffer,GetErrors,ScaleAsync||BufferFormat:StudioCaptureScreenshotFormat,BufferStatus:StudioCaptureBufferStatus,OriginalSize:Vector2,Position:Vector2,Resolution:Vector2,UICaptureMode:UICaptureMode;StudioScriptDebugEventListener<Instance|||;StudioSdkService<Instance|GetSdk,SetSdk||;StudioService<Instance|AnimationIdSelected,CopyToClipboard,GetBadgeConfigureUrl,GetBadgeUploadUrl,GetClassIcon,GetPlaceIsPersistedToCloud,GetResourceByCategory,GetStartupAssetId,GetStartupPluginId,GetTermsOfUseUrl,GetUserId,GizmoRaycast,HasInternalPermission,IsPluginInstalled,IsPluginUpToDate,OpenInBrowser_DONOTUSE,SetPluginEnabled,ShowPublishToRoblox,UninstallPlugin,UpdatePluginManagement,PromptImportFile,PromptImportFileAsync,PromptImportFiles,PromptImportFilesAsync,TryInstallPlugin|OnImportFromRoblox,OnOpenGameSettings,OnOpenManagePackagePlugin,OnPluginInstalledFromToolbox,OnPluginInstalledFromWeb,OnPublishAsPlugin,OnSaveToRoblox,PromptTransformPluginCheckEnable,SaveLocallyAsComplete|ActiveScript:Instance,AlignDraggedObjects:bool,DraggerSolveConstraints:bool,DrawConstraintsOnTop:bool,GridSize:float,HoverInstance:Instance,InstalledPluginData:string,PivotSnapToGeometry:bool,RotateIncrement:float,Secrets:string,ShowConstraintDetails:bool,ShowWeldDetails:bool,StudioLocaleId:string,UseLocalSpace:bool;StudioTestService<Instance|AddPlayers,CanLeaveTest,EndTest,GetTestArgs,LeaveTest,ExecuteMultiplayerTestAsync,ExecutePlayModeAsync,ExecuteRunModeAsync||EditModeActive:bool;StudioTheme<Instance|GetColor||;StudioUserService<Instance|||IsLoggedIn:bool;StudioWidgetsService<Instance|ApplyFillInBox,ApplyHighlight,ApplyShadows,ApplySpotlight,GetWidgetFromLabel,GetWidgetFromPluginGui,HideSpotlight||;StyleBase<Instance|GetStyleRules,InsertStyleRule,SetStyleRules|StyleRulesChanged|;StyleRule<StyleBase|GetDefaultPropertyTransition,GetProperties,GetPropertiesResolved,GetProperty,GetPropertyResolved,GetPropertyTransitions,SetDefaultPropertyTransition,SetProperties,SetProperty,SetPropertyTransition,SetPropertyTransitions|StyleRulePropertyChanged|Index:int,Priority:int,PropertiesSerialize:BinaryString,PropertyTransitionsSerialize:BinaryString,Selector:string,SelectorError:string;StyleSheet<StyleBase|GetDerives,SetDerives||;StyleDerive<Instance|||Index:int,Priority:int,StyleSheet:StyleSheet;StyleLink<Instance|||StyleSheet:StyleSheet;StyleQuery<Instance|GetCondition,GetConditions,SetCondition,SetConditions||AspectRatioRange:NumberRange,ConditionsSerialize:BinaryString,IsActive:bool,MaxSize:Vector2,MinSize:Vector2,PreferredInput:PreferredInput,PreferredTextSize:PreferredTextSize,ReducedMotionEnabled:bool,ViewportDisplaySize:DisplaySize;StylingService<Instance|GetAppliedStyles,GetStyleInfo,GetStyleSheetDerivesChain,GetStyleSheetInfo,UpdateUnitTestOnly||;SurfaceAppearance<Instance|||AlphaMode:AlphaMode,Color:Color3,ColorMap:ContentId,ColorMapContent:Content,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,ResampleMode:ResamplerMode,RoughnessMap:ContentId,RoughnessMapContent:Content,TexturePack:ContentId,TexturePackContent:Content;SystemThemeService<Instance|getSystemTheme,isSystemThemeAvailable,setClassicThemeActive,setTheme,getSystemThemeAsync|OnLuaThemeUpdated|;TaskScheduler<Instance|||SchedulerDutyCycle:double,SchedulerRate:double,ThreadPoolConfig:ThreadPoolConfig,ThreadPoolSize:int;Team<Instance|GetPlayers|PlayerAdded,PlayerRemoved|AutoAssignable:bool,AutoColorCharacters:bool,ChildOrder:int,Score:int,TeamColor:BrickColor;TeamCreateData<Instance|||InitialCameraCFrame:CFrame;TeamCreatePublishService<Instance||TeamCreateErrorStatus,TeamCreatePlaceUploadRequest,TeamCreatePlaceUploadResponse|;TeamCreateService<Instance|CloseGameIfUserDoesntHavePerms||;Teams<Instance|GetTeams,RebalanceTeams||;TelemetryService<Instance|LogCounter,LogDurationEvent,LogDurationEventWithTimestamp,LogEvent,LogStat||;TeleportAsyncResult<Instance|||PrivateServerId:string,ReservedServerAccessCode:string;TeleportOptions<Instance|GetTeleportData,SetTeleportData||ReservedServerAccessCode:string,ServerInstanceId:string,ShouldReserveServer:bool;TeleportService<Instance|Block,GetArrivingTeleportGui,GetLocalPlayerTeleportData,GetTeleportSetting,GetThirdPartyTeleportInfo,PromptExperienceDetailsCompleted,SetTeleportGui,SetTeleportSetting,Teleport,TeleportCancel,TeleportReconnect,TeleportToPlaceInstance,TeleportToPrivateServer,TeleportToSpawnByName,TeleportTrustedBackForth,TeleportTrustedBackHistory,TeleportedPlacesBackHistory,TeleportedUniversesBackHistory,GetPlayerPlaceInstanceAsync,PromptExperienceDetailsAsync,ReserveServer,ReserveServerAsync,TeleportAsync,TeleportPartyAsync,UnblockAsync|LocalPlayerArrivedFromTeleport,MenuTeleportAttempt,OpenExperienceDetailsPrompt,ReconnectTeleportInitFailed,SendVIPData,TeleportInProgress,TeleportInitFailed,TeleportInitFailedInternal|CustomizedTeleportUI:bool;TemporaryCageMeshProvider<Instance|||;TemporaryScriptService<Instance|||;TerrainDetail<Instance|||ColorMap:ContentId,ColorMapContent:Content,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,Face:TerrainFace,MaterialPattern:MaterialPattern,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,RoughnessMap:ContentId,RoughnessMapContent:Content,StudsPerTile:float,TexturePack:ContentId,TexturePackContent:Content;TerrainRegion<Instance|ApplyTransform,ApplyTransformSubregion,ConvertToSmooth,GetRegionWireframe||ExtentsMax:Vector3int16,ExtentsMin:Vector3int16,GridV3:BinaryString,IsSmooth:bool,SizeInCells:Vector3,SmoothGrid:BinaryString;TestCase<Instance|Assert,AssertLegacy,EndTest,Message,Require,RequireLegacy||;TestService<Instance|Check,Checkpoint,ConvertSlimAcrToObj,CreateAndSavePropertySet,CreateExtraAssetsFileFromPropertySet,Done,Error,Fail,FetchExtraAssets,GetTestControlSchema,GetTestControls,Message,RegisterTest,RegisterTestLegacy,Require,ResetTestControl,ScopeTime,SetTestControl,SignalProfilingCapture,SignalProfilingStart,SignalProfilingStop,StartTestSession,StopTestSession,TakeSnapshot,TranscodePropertySet,Warn,getTestSessionProviderStats,isFeatureEnabled,CaptureScreenshotAsync,FetchTestControlsAsync,RequestValidationAsync,Run,RunAsync,StartVideoCaptureAsync,StopVideoCaptureAsync|ServerCollectConditionalResult,ServerCollectResult|AutoRuns:bool,Description:string,ErrorCount:int,ExecuteWithStudioRun:bool,Is30FpsThrottleEnabled:bool,IsPhysicsEnvironmentalThrottled:bool,IsSleepAllowed:bool,NumberOfPlayers:int,SimulateSecondsLag:double,TestCount:int,ThrottlePhysicsToRealtime:bool,Timeout:double,WarnCount:int;TextBoxService<Instance|||;TextChannel<Instance|DisplaySystemMessage,SetDirectChatRequester,AddUserAsync,SendAsync,SendDictatedSpeechAsync,SendInternalAsync,SendPresetAsync|MessageReceived|AddPlayersOnJoin:bool,DirectChatRequester:Player,IsDefaultTextChannel:bool,OnIncomingMessage,ShouldDeliverCallback;TextChatCommand<Instance||Triggered|AutocompleteVisible:bool,Enabled:bool,PrimaryAlias:string,SecondaryAlias:string;TextChatConfigurations<Instance|||;BubbleChatConfiguration<TextChatConfigurations|||AdorneeName:string,BackgroundColor3:Color3,BackgroundTransparency:double,BubbleDuration:float,BubblesSpacing:float,Enabled:bool,Font:Font,FontFace:Font,LocalPlayerStudsOffset:Vector3,MaxBubbles:float,MaxDistance:float,MinimizeDistance:float,TailVisible:bool,TextColor3:Color3,TextSize:int64,VerticalStudsOffset:float;ChannelTabsConfiguration<TextChatConfigurations|SetAbsolutePosition,SetAbsoluteSize||AbsolutePosition:Vector2,AbsoluteSize:Vector2,BackgroundColor3:Color3,BackgroundTransparency:double,Enabled:bool,FontFace:Font,HoverBackgroundColor3:Color3,SelectedTabTextColor3:Color3,TextColor3:Color3,TextSize:int64,TextStrokeColor3:Color3,TextStrokeTransparency:double;ChatInputBarConfiguration<TextChatConfigurations|||AbsolutePosition:Vector2,AbsolutePositionWrite:Vector2,AbsoluteSize:Vector2,AbsoluteSizeWrite:Vector2,AutocompleteEnabled:bool,BackgroundColor3:Color3,BackgroundTransparency:double,Enabled:bool,FontFace:Font,IsFocused:bool,IsFocusedWrite:bool,KeyboardKeyCode:KeyCode,PlaceholderColor3:Color3,TargetTextChannel:TextChannel,TextBox:TextBox,TextColor3:Color3,TextSize:int64,TextStrokeColor3:Color3,TextStrokeTransparency:double;ChatWindowConfiguration<TextChatConfigurations|DeriveNewMessageProperties||AbsolutePosition:Vector2,AbsolutePositionWrite:Vector2,AbsoluteSize:Vector2,AbsoluteSizeWrite:Vector2,BackgroundColor3:Color3,BackgroundTransparency:double,Enabled:bool,FontFace:Font,HeightScale:float,HorizontalAlignment:HorizontalAlignment,TextChannelDisplayMode:TextChannelDisplayMode,TextColor3:Color3,TextSize:int64,TextStrokeColor3:Color3,TextStrokeTransparency:double,VerticalAlignment:VerticalAlignment,WidthScale:float;TextChatMessage<Instance|||BubbleChatMessageProperties:BubbleChatMessageProperties,ChatActionType:string,ChatWindowMessageProperties:ChatWindowMessageProperties,ForModeration:bool,IsHiddenMessage:bool,MessageId:string,Metadata:string,OriginalText:string,PrefixText:string,PrefixTextInternal:string,PresetChatVersion:string,PresetId:string,RewrittenText:string,RewrittenTranslation:string,Status:TextChatMessageStatus,Text:string,TextChannel:TextChannel,TextInternal:string,TextSource:TextSource,Timestamp:DateTime,Translation:string,TranslationInternal:string,Verified:bool,WasRewritten:bool;TextChatMessageProperties<Instance|||PrefixText:string,Text:string,Translation:string;BubbleChatMessageProperties<TextChatMessageProperties|||BackgroundColor3:Color3,BackgroundTransparency:double,FontFace:Font,TailVisible:bool,TextColor3:Color3,TextSize:int64;ChatWindowMessageProperties<TextChatMessageProperties|||FontFace:Font,PrefixTextProperties:ChatWindowMessageProperties,TextColor3:Color3,TextSize:int,TextStrokeColor3:Color3,TextStrokeTransparency:double;TextChatService<Instance|DisplayBubble,GetTextChannelWindows,HasAllocatedUniverseChatContext,IsProtectedChatEnabled,SendEnableChatButtonClicked,SendEnableChatButtonShown,SendExpChatLoadSuccess,SendExpChatMessageClientRendered,SendExpChatWindowScroll,SendExpChatWindowStatusChange,SendTextChatCommandClientSent,setModerationModeEnabled,CanUserChatAsync,CanUsersChatAsync,CanUsersDirectChatAsync,CanUsersWhisperAsync,GetChatGroupsAsync,GetChatableUserCountAsync,GetPresetsAsync,OnUserChatSettingUpdateAsync,SendDictatedSpeechUniverseChatAsync,SendUniverseChatMessageAsync,SendUniverseChatPresetAsync|BubbleDisplayed,ChatActionReceived,ClientToServerChatableUserCountRequestSignal,ClientToServerMessageReplicateSignalV2,ClientToServerMessageReplicateSignalV3,ClientToServerMessageReplicateSignalV4,ClientToServerUniverseChatMessageSignalV1,ClientToServerUniverseChatMessageSignalV2,ExpChatFeatureValueChanged,MessageReceived,OnIncomingMessageEvent,OnUserChatSettingUpdateServer,SendingMessage,SendingUniverseChatMessage,ServerToClientChatActionReplicateSignal,ServerToClientChatableUserCountResponseSignal,ServerToClientMessageReplicateSignal,ServerToClientMessageReplicateSignalV2,ServerToClientPresetChatConfigChangedSignal,ServerToClientPresetChatUserAccessChangedSignal,ServerToClientUniverseChatChannelAllocatedSignalV1,ServerToClientUniverseChatMessageSignalV1,TextChannelWindowAdded,TextChannelWindowRemoved,UniverseChatChannelAllocated,UniverseChatMessageReceived,UserMessageIntentSent,UserMessageIntentSentRemote|ChatTranslationEnabled:bool,ChatTranslationFTUXShown:bool,ChatTranslationToggleEnabled:bool,ChatVersion:ChatVersion,CreateDefaultCommands:bool,CreateDefaultTextChannels:bool,HasSeenDeprecationDialog:bool,IsLegacyChatDisabled:bool,PlatformIntegratedChat:RolloutState,OnBubbleAdded,OnChatWindowAdded,OnIncomingMessage;TextFilterResult<Instance|GetChatForUserAsync,GetNonChatStringForBroadcastAsync,GetNonChatStringForUserAsync||;TextFilterTranslatedResult<Instance|GetTranslationForLocale,GetTranslations||SourceLanguage:string,SourceText:TextFilterResult;TextGenerator<Instance|GenerateTextAsync||Seed:int,SystemPrompt:string,Temperature:float,TopP:float;TextService<Instance|GetFontMemoryData,GetTextSize,SetResolutionScale,FilterAndTranslateStringAsync,FilterStringAsync,GetFamilyInfoAsync,GetTextBoundsAsync,GetTextSizeOffsetAsync||;TextSource<Instance|||CanSend:bool,DisplayName:string,UserId:int64,UserIdReplicated:int64,Username:string;TextureGenerationPartGroup<Instance|GetInstances,GetMeshIdsHash||;TextureGenerationService<Instance|CancelGenerationRequest,CreatePartGroup,GenerateTexture,PreviewTexture,GetQuotasAsync|GenerationNotificationSignal,PreviewNotificationSignal|;TextureGenerationUnwrappingRequest<Instance|ApplyToDataModel,GetPartGroup||;ThirdPartyUserService<Instance|GetUserPlatformName,GetVoiceChatRestrictionStatus,HaveActiveUser,IsAccountSwitchingSupported,IsChatRestrictionSupported,IsSingleSignOnSupported,ShowAccountPicker|ActiveUserSignedOut|FriendCommunicationRestrictionStatus:ChatRestrictionStatus,HasActiveUser:bool,VoiceChatRestrictionStatus:ChatRestrictionStatus;ThreadState<Instance|GetFrame||FrameCount:int,Populated:bool,ThreadId:int,ThreadName:string;TimerService<Instance|||;ToastNotificationService<Instance|HideNotification,ShowNotification||;TouchInputService<Instance|||;TouchTransmitter<Instance|||;TraceRouteService<Instance|||;TracerService<Instance|FinishSpan,StartSpan||;TrackerLodController<Instance|getExtrapolation,getVideoLod,isAudioEnabled,isVideoEnabled|UpdateState|AudioMode:TrackerLodFlagMode,VideoExtrapolationMode:TrackerExtrapolationFlagMode,VideoLodMode:TrackerLodValueMode,VideoMode:TrackerLodFlagMode;TrackerStreamAnimation<Instance|||;Trail<Instance|Clear|OnClearRequested|Attachment0:Attachment,Attachment1:Attachment,Brightness:float,Color:ColorSequence,Enabled:bool,FaceCamera:bool,Lifetime:float,LightEmission:float,LightInfluence:float,LocalTransparencyModifier:float,MaxLength:float,MinLength:float,Texture:ContentId,TextureContent:Content,TextureLength:float,TextureMode:TextureMode,Transparency:NumberSequence,WidthScale:NumberSequence;Translator<Instance|FormatByKey,RobloxOnlyTranslate,Translate||LocaleId:string;TutorialService<Instance|GetMainViewSessionId,HasUserCompletedTutorial,HideWidgets,PromptClosePlace,SetTutorialCompletionStatus,ShouldLaunchTutorial,ShowWidgets||;TweenBase<Instance|Cancel,Pause,Play|Completed|PlaybackState:PlaybackState;Tween<TweenBase|||Instance:Instance,TweenInfo:TweenInfo;TweenService<Instance|Create,GetValue,SmoothDamp||;UGCAvatarService<Instance|||;UGCValidationService<Instance|AreInstanceTreesEquivalent,CalculateAverageEditableCageMeshDistance,CalculateEditableMeshInsideMeshPercentage,CalculateEditableMeshModifiedCageBoundingBox,CalculateEditableMeshNumModifiedCageUVsInSet,CalculateEditableMeshTotalSurfaceArea,CalculateEditableMeshUniqueUVCount,CheckEditableMeshInCameraFrustum,CreateEditableImageFromBinaryStringRobloxOnly,CreateEditableMeshFromBinaryStringRobloxOnly,GetBoundingBoxManipulationData,GetDynamicHeadEditableMeshInactiveControls,GetEditableCagingRelevancyMetrics,GetEditableImageSize,GetEditableMeshMaxNearbyVerticesCollisions,GetEditableMeshSkinningTransferJointsInfo,GetEditableMeshTriCount,GetEditableMeshVertColors,GetEditableMeshVerticesSimilarityRate,GetEditableMeshVerts,GetExpectedTposeRotation,GetFacsDrivenJointNamesFromEditableMesh,GetLayeredClothingPostDeformationSize,GetMaximalJointDistancesWithinFacs,GetMinAndMaxMeshSizeAcrossAllFacs,GetPropertyValue,GetSkinnedJointNamesFromEditableMesh,IsEditableMeshNumCoplanarIntersectionsOverLimit,RegisterAlternateMesh,RegisterUGCValidationFunction,ReportUGCValidationCounter,ReportUGCValidationFailureTelemetry,ReportUGCValidationTelemetry,ResetCollisionFidelity,ResetCollisionFidelityWithEditableMeshDataLua,SetMeshIdBlocking,ValidateDynamicHeadEditableMesh,ValidateEditableMeshCageMeshIntersection,ValidateEditableMeshCageNonManifoldAndHoles,ValidateEditableMeshCageUVCoincident,ValidateEditableMeshCageUVTriangleArea,ValidateEditableMeshFacialBounds,ValidateEditableMeshFacialExpressiveness,ValidateEditableMeshFullBodyCageDeletion,ValidateEditableMeshMisMatchUV,ValidateEditableMeshOverlappingVertices,ValidateEditableMeshTriangleArea,ValidateEditableMeshTriangles,ValidateEditableMeshUVDuplicates,ValidateEditableMeshUVSpace,ValidateEditableMeshUVValuesInReference,ValidateEditableMeshUniqueUVCount,ValidateEditableMeshVertColors,ValidateHSRMeshIds,ValidateLeaderSkinnedVertsNearCageIslands,ValidatePartBBoxAfterFullFacs,ValidatePropertiesSensible,ValidateSkinnedEditableMesh,CalculateBodyMaxCageDistance,CanLoadAsset,CreateEditableImageOriginalSizeAsync,DoesMeshHaveSkinningData,DoesSurfaceAppearanceMatchTexturePackAsync,FetchAssetWithFormat,GetLayeredClothingPostDeformationSizeAsync,GetMeshDataBinaryString,GetMeshVerts,GetSerializedSizeExcludingCollisionAsync,IsDeformedLayeredClothingOutOfRenderBounds||;UIBase<Instance|||;UIComponent<UIBase|||;UIConstraint<UIComponent|||;UIAspectRatioConstraint<UIConstraint|||AspectRatio:float,AspectType:AspectType,DominantAxis:DominantAxis;UISizeConstraint<UIConstraint|||MaxSize:Vector2,MinSize:Vector2;UITextSizeConstraint<UIConstraint|||MaxTextSize:int,MinTextSize:int;UICorner<UIComponent|||BottomLeftRadius:UDim,BottomRightRadius:UDim,CornerRadius:UDim,TopLeftRadius:UDim,TopRightRadius:UDim;UIDragDetector<UIComponent|AddConstraintFunction,GetReferencePosition,GetReferenceRotation,SetDragStyleFunction|DragContinue,DragEnd,DragStart|ActivatedCursorIcon:ContentId,ActivatedCursorIconContent:Content,BoundingBehavior:UIDragDetectorBoundingBehavior,BoundingUI:GuiBase2d,CursorIcon:ContentId,CursorIconContent:Content,DragAxis:Vector2,DragRelativity:UIDragDetectorDragRelativity,DragRotation:float,DragSpace:UIDragDetectorDragSpace,DragStyle:UIDragDetectorDragStyle,DragUDim2:UDim2,Enabled:bool,MaxDragAngle:float,MaxDragTranslation:UDim2,MinDragAngle:float,MinDragTranslation:UDim2,ReferenceUIInstance:GuiObject,ResponseStyle:UIDragDetectorResponseStyle,SelectionModeDragSpeed:UDim2,SelectionModeRotateSpeed:float,UIDragSpeedAxisMapping:UIDragSpeedAxisMapping;UIFlexItem<UIComponent|||FlexMode:UIFlexMode,GrowRatio:float,ItemLineAlignment:ItemLineAlignment,ShrinkRatio:float;UIGradient<UIComponent|||Color:ColorSequence,Enabled:bool,Offset:Vector2,Rotation:float,Scale:float,TileMode:GradientTileMode,Transparency:NumberSequence,Type:GradientType;UILayout<UIComponent|||;UIGridStyleLayout<UILayout|ApplyLayout,SetCustomSortFunction||AbsoluteContentSize:Vector2,FillDirection:FillDirection,HorizontalAlignment:HorizontalAlignment,SortOrder:SortOrder,VerticalAlignment:VerticalAlignment;UIGridLayout<UIGridStyleLayout|||AbsoluteCellCount:Vector2,AbsoluteCellSize:Vector2,CellPadding:UDim2,CellSize:UDim2,FillDirectionMaxCells:int,StartCorner:StartCorner;UIListLayout<UIGridStyleLayout|||HorizontalFlex:UIFlexAlignment,HorizontalPadding:UDim,ItemLineAlignment:ItemLineAlignment,Padding:UDim,VerticalFlex:UIFlexAlignment,VerticalPadding:UDim,Wraps:bool;UIPageLayout<UIGridStyleLayout|JumpTo,JumpToIndex,Next,Previous|PageEnter,PageLeave,Stopped|Animated:bool,Circular:bool,CurrentPage:GuiObject,EasingDirection:EasingDirection,EasingStyle:EasingStyle,GamepadInputEnabled:bool,Padding:UDim,ScrollWheelInputEnabled:bool,TouchInputEnabled:bool,TweenTime:float;UITableLayout<UIGridStyleLayout|||FillEmptySpaceColumns:bool,FillEmptySpaceRows:bool,MajorAxis:TableMajorAxis,Padding:UDim2;UIPadding<UIComponent|||PaddingBottom:UDim,PaddingLeft:UDim,PaddingRight:UDim,PaddingTop:UDim;UIScale<UIComponent|||Scale:float;UIShadow<UIComponent|||BlurRadius:UDim,Color:Color3,Enabled:bool,Inset:bool,Mode:ApplyShadowMode,Offset:UDim2,ShowBehindParent:bool,Spread:UDim2,Transparency:float,ZIndex:int;UIStroke<UIComponent|||ApplyStrokeMode:ApplyStrokeMode,BorderOffset:UDim,BorderStrokePosition:BorderStrokePosition,Color:Color3,Enabled:bool,LineJoinMode:LineJoinMode,StrokeSizingMode:StrokeSizingMode,Thickness:float,Transparency:float,ZIndex:int;UIDragDetectorService<Instance|||;UniqueIdLookupService<Instance|GetInstanceByRfc4122String,GetOrCreateUniqueId,GetOrCreateUniqueIdRemoteCommand||;UnvalidatedAssetService<Instance|AppendTempAssetId,AppendVantagePoint,UpgradeTempAssetId||CachedData:string;UserGameSettings<Instance|GetCameraYInvertValue,GetDefaultFramerateCap,GetOnboardingCompleted,GetTutorialState,InFullScreen,InStudioMode,ResetOnboardingCompleted,SetCameraYInvertVisible,SetGamepadCameraSensitivityVisible,SetOnboardingCompleted,SetTutorialState|FullscreenChanged,PerformanceStatsVisibleChanged,StudioModeChanged|AllTutorialsDisabled:bool,BadgeVisible:bool,CameraMode:CustomCameraMode,CameraYInverted:bool,ChatTranslationEnabled:bool,ChatTranslationFTUXShown:bool,ChatTranslationLocale:string,ChatTranslationToggleEnabled:bool,ChatVisible:bool,CompletedTutorials:string,ComputerCameraMovementChanged:bool,ComputerCameraMovementMode:ComputerCameraMovementMode,ComputerMovementChanged:bool,ComputerMovementMode:ComputerMovementMode,ControlMode:ControlMode,DefaultCameraID:string,FramerateCap:int,Fullscreen:bool,GamepadCameraSensitivity:float,GraphicsOptimizationMode:GraphicsOptimizationMode,GraphicsQualityLevel:int,HapticStrength:float,HasEverUsedVR:bool,IsUsingCameraYInverted:bool,IsUsingGamepadCameraSensitivity:bool,MasterVolume:float,MasterVolumeStudio:float,MaxQualityEnabled:bool,MicroProfilerWebServerEnabled:bool,MicroProfilerWebServerIP:string,MicroProfilerWebServerPort:int,MouseSensitivity:float,MouseSensitivityFirstPerson:Vector2,MouseSensitivityThirdPerson:Vector2,OnScreenProfilerEnabled:bool,OnboardingsCompleted:string,PartyVoiceVolume:float,PeoplePageLayout:PeoplePageLayout,PerformanceStatsVisible:bool,PlayerHeight:float,PlayerListVisible:bool,PlayerNamesEnabled:bool,PreferredTextSize:PreferredTextSize,PreferredTransparency:float,QualityResetLevel:int,RCCProfilerRecordFrameRate:int,RCCProfilerRecordTimeFrame:int,ReadAloud:bool,ReducedMotion:bool,RotationType:RotationType,SavedQualityLevel:SavedQualitySetting,StartMaximized:bool,StartScreenPosition:Vector2,StartScreenSize:Vector2,StudioPreferredTextSize:PreferredTextSize,TouchCameraMovementChanged:bool,TouchCameraMovementMode:TouchCameraMovementMode,TouchMovementChanged:bool,TouchMovementMode:TouchMovementMode,UIScaleMultiplierHundredths:int,UiNavigationKeyBindEnabled:bool,UsedCoreGuiIsVisibleToggle:bool,UsedCustomGuiIsVisibleToggle:bool,UsedHideHudShortcut:bool,VRComfortSetting:VRComfortSetting,VREnabled:bool,VRRotationIntensity:int,VRSafetyBubbleMode:VRSafetyBubbleMode,VRSmoothRotationEnabled:bool,VRSmoothRotationEnabledCustomOption:bool,VRThirdPersonFollowCamEnabled:bool,VRThirdPersonFollowCamEnabledCustomOption:bool,VignetteEnabled:bool,VignetteEnabledCustomOption:bool,VoiceChatVolume:float,gaID:string;UserInputService<Instance|CreateVirtualInput,GamepadSupports,GetConnectedGamepads,GetDeviceAcceleration,GetDeviceGravity,GetDeviceLevel,GetDeviceRotation,GetDeviceType,GetFocusedTextBox,GetGamepadConnected,GetGamepadState,GetImageForKeyCode,GetKeysPressed,GetLastInputType,GetMouseButtonsPressed,GetMouseDelta,GetMouseLocation,GetNavigationGamepads,GetPasteText,GetPlatform,GetStringForKeyCode,GetSupportedGamepadKeyCodes,GetUserCFrame,IsGamepadButtonDown,IsKeyDown,IsMouseButtonPressed,IsNavigationGamepad,RecenterUserHeadCFrame,SendAppUISizes,SetNavigationGamepad|DeviceAccelerationChanged,DeviceGravityChanged,DeviceRotationChanged,GamepadConnected,GamepadDisconnected,InputBegan,InputChanged,InputEnded,JumpRequest,LastInputTypeChanged,PointerAction,StatusBarTapped,TextBoxFocusReleased,TextBoxFocused,TouchDrag,TouchEnded,TouchLongPress,TouchMoved,TouchPan,TouchPinch,TouchRotate,TouchStarted,TouchSwipe,TouchTap,TouchTapInWorld,UserCFrameChanged,WindowFocusReleased,WindowFocused|AccelerometerEnabled:bool,BottomBarSize:Vector2,GamepadEnabled:bool,GyroscopeEnabled:bool,KeyboardEnabled:bool,LegacyInputEventsEnabled:bool,ModalEnabled:bool,MouseBehavior:MouseBehavior,MouseDeltaSensitivity:float,MouseEnabled:bool,MouseIcon:ContentId,MouseIconContent:Content,MouseIconEnabled:bool,NavBarSize:Vector2,OnScreenKeyboardAnimationDuration:double,OnScreenKeyboardPosition:Vector2,OnScreenKeyboardSize:Vector2,OnScreenKeyboardVisible:bool,OverrideMouseIconBehavior:OverrideMouseIconBehavior,PreferredInput:PreferredInput,RightBarSize:Vector2,StatusBarSize:Vector2,TouchEnabled:bool,TouchScreenEnabled:bool,UserHeadCFrame:CFrame,VREnabled:bool;UserService<Instance|GetUserFromGlobalUserIdAsync,GetUserInfosByUserIdsAsync||;VRService<Instance|GetTouchpadMode,GetUserCFrame,GetUserCFrameEnabled,IsMaquettes,IsVRAppBuild,RecenterUserHeadCFrame,RequestNavigation,SetTouchpadMode|LaserPointerTriggered,NavigationRequested,TouchpadModeChanged,UserCFrameChanged,UserCFrameEnabled|AutomaticScaling:VRScaling,AvatarGestures:bool,ControllerModels:VRControllerModelMode,DidPointerHit:bool,FadeOutViewOnCollision:bool,GuiInputUserCFrame:UserCFrame,LaserDistance:float,LaserPointer:VRLaserPointerMode,PointerHitCFrame:CFrame,QuestASWState:bool,QuestDisplayRefreshRate:float,ThirdPersonFollowCamEnabled:bool,VRDeviceAvailable:bool,VRDeviceName:string,VREnabled:bool,VRSessionState:VRSessionState;VRStatusService<Instance|||;ValueBase<Instance|||;BinaryStringValue<ValueBase||Changed|Value:BinaryString;BoolValue<ValueBase||Changed,changed|Value:bool;BrickColorValue<ValueBase||Changed,changed|Value:BrickColor;CFrameValue<ValueBase||Changed,changed|Value:CFrame;Color3Value<ValueBase||Changed,changed|Value:Color3;DoubleConstrainedValue<ValueBase||Changed,changed|ConstrainedValue:double,MaxValue:double,MinValue:double,Value:double,value:double;IntConstrainedValue<ValueBase||Changed,changed|ConstrainedValue:int64,MaxValue:int64,MinValue:int64,Value:int64,value:int64;IntValue<ValueBase||Changed,changed|Value:int64;NumberValue<ValueBase||Changed,changed|Value:double;ObjectValue<ValueBase||Changed,changed|Value:Instance;RayValue<ValueBase||Changed,changed|Value:Ray;StringValue<ValueBase||Changed,changed|Value:string;Vector3Value<ValueBase||Changed,changed|Value:Vector3;ValueCurve<Instance|GetKeyAtIndex,GetKeyIndicesAtTime,GetKeys,GetValueAtTime,InsertKey,InsertKeyValue,RemoveKeyAtIndex,SetKeys||Length:int,ValueType:string,ValuesAndTimes:BinaryString;Vector3Curve<Instance|GetValueAtTime,X,Y,Z||;VersionControlService<Instance||BroadcastScriptChangesSubmitted,CommitRejectedInfo,LockedScriptBatchCommit,RequestAllEditorsSignal,ScriptBatchCommit,ScriptChangesSubmitted,ScriptEditorAdded,ScriptEditorRemoved,ScriptStartEdit,ScriptStopEdit|ScriptCollabEnabled:bool,ScriptCollabVersionHistoryEnabled:bool;VideoCaptureService<Instance|GetCameraDevices|DevicesChanged,Error,Started,Stopped|Active:bool,CameraID:string;VideoDeviceInput<Instance|||Active:bool,CameraId:string,CaptureQuality:VideoDeviceCaptureQuality,IsReady:bool;VideoPlayer<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Pause,Play,SetStudioPreview,Unload,LoadAsync|DidEnd,DidLoop,PlayFailed,WiringChanged|AutoLoadInStudio:bool,AutoPlayInStudio:bool,InternalVideoUsage:InternalVideoUsage,IsLoaded:bool,IsPlaying:bool,Looping:bool,MaximumResolution:VideoSampleSize,PlaybackSpeed:float,PlayingReplicating:bool,Resolution:Vector2,TimeLength:double,TimePosition:double,VideoContent:Content,Volume:float;VideoScreenCaptureService<Instance|||;VideoService<Instance|GameStreamingEnabled,CreateVideoSamplerAsync|GameStreamingResolutionReady,PlaybackReport|;VirtualInputManager<Instance|Dump,HandleGamepadAxisInput,HandleGamepadButtonInput,HandleGamepadConnect,HandleGamepadDisconnect,SendAccelerometerEvent,SendGravityEvent,SendGyroscopeEvent,SendKeyEvent,SendMouseButtonEvent,SendMouseMoveDeltaEvent,SendMouseMoveEvent,SendMouseWheelEvent,SendScroll,SendTextInputCharacterEvent,SendTouchEvent,SetInputTypesToIgnore,StartPlaying,StartPlayingJSON,StartRecording,StopPlaying,StopRecording,sendRobloxEvent,sendThemeChangeEvent,WaitForInputEventsProcessed|PlaybackCompleted,RecordingCompleted|AdditionalLuaState:string;VirtualUser<Instance|Button1Down,Button1Up,Button2Down,Button2Up,CaptureController,ClickButton1,ClickButton2,MoveMouse,SetKeyDown,SetKeyUp,StartRecording,StopRecording,TypeKey||;VisibilityCheckDispatcher<Instance|||;Visit<Instance|||;VisualizationMode<Instance|||Enabled:bool,Title:string,ToolTip:string;VisualizationModeCategory<Instance|||Enabled:bool,Title:string;VisualizationModeService<Instance|||;VoiceChatInternal<Instance|GetAndClearCallFailureMessage,GetAudioProcessingSettings,GetChannelId,GetGroupId,GetMicDevices,GetParticipants,GetSessionId,GetVoiceChatApiVersion,GetVoiceChatAvailable,GetVoiceExperienceId,IsContextVoiceEnabled,IsPublishPaused,IsSubscribePaused,JoinByGroupId,JoinByGroupIdToken,Leave,LogPublisherWebRTCStats,LogSubscriptionWebRTCStats,PublishPause,SetMicDevice,SubscribeBlock,SubscribePause,SubscribePauseAll,SubscribeRetry,SubscribeUnblock,IsVoiceEnabledForUserIdAsync|LocalPlayerModerated,ParticipantsStateChanged,PlayerMicActivitySignalChange,StateChanged,TempSetMicMutedToggleMic|VoiceChatState:VoiceChatState;VoiceChatService<Instance|getInternalChannelId,getInternalGroupId,getInternalPublishPause,getInternalSessionId,getInternalSubscribePause,getInternalSubscribePauseAll,getInternalVoiceChatApiVersion,isInternalPublishPaused,joinVoice,lastVoiceChatStats,leaveVoice,notifyServerACSCleanup,rejoinVoice,GetChatGroupsAsync,IsVoiceEnabledForUserIdAsync|ACSCleanup,ClientRetryJoin,ClientRetryJoinWithConfig,ClientStreamSwitchAck,FetchUserTurnAuthOperationFailed,JoinedVoice,JoinedVoiceV2,PublishStateChange,PublishingHandshakeAcked,PublishingHandshakeAckedWithBothSdp,PublishingHandshakeAckedWithCompressedSdp,PublishingHandshakeCompleted,PublishingHandshakeInitiated,PublishingHandshakeInitiatedWithBothSdp,PublishingHandshakeInitiatedWithCompressedSdp,ReJoinedVoice,ReJoinedVoiceV2,RelayCandidatesGathered,SsrcUserIdMappingUpdate,SubscribeStateChange,SubscriberAudioQualitySample,SubscriptionFeedStarted,SubscriptionHandshakeAcked,SubscriptionHandshakeAckedWithBothSdp,SubscriptionHandshakeAckedWithCompressedSdp,SubscriptionHandshakeCompleted,SubscriptionHandshakeInitiated,SubscriptionHandshakeInitiatedWithBothSdp,SubscriptionHandshakeInitiatedWithCompressedSdp,SubscriptionReset,UpdateTurnAuthInfoRequest,UserTurnAuth,UserTurnAuthV2,VoiceChatClientVoiceCapability,VoiceChatClientVoiceCapabilityWithConfig,VoiceChatPlayerMuteStateChangedClientToServer,VoiceChatPlayerMuteStateChangedServerToClient,VoiceChatSampleTaggedEventClientToServer,VoiceChatSampleTaggedEventServerToClient,VoiceChatStatsCollected,VoiceChatSubscriptionInitialBatchEmpty,VoiceChatplayerMuteStatusChangedEvent,VoiceMigration,VoiceSetupFailed|DefaultDistanceAttenuation:VoiceChatDistanceAttenuationType,EnableDefaultVoice:bool,EnableVoiceVolumeControls:RolloutState,UseAudioApi:AudioApiRollout,UseNewAudioApi:bool,UseNewControlPaths:bool,UseNewJoinFlow:bool,UseStreamSwitching:bool,VoiceChatEnabledForPlaceOnRcc:bool,VoiceChatEnabledForUniverseOnRcc:bool;WebSocketClient<Instance|Close,Send|Closed,MessageReceived,Opened|ConnectionState:WebSocketState;WebSocketService<Instance|CreateClient||;WebViewService<Instance|CloseWindow,MutateWindow,OpenWindow,OpenWindowV2,IsAvailable|OnJavaScriptCall,OnWindowClosed|;WeldConstraint<Instance|||Active:bool,CFrame0:CFrame,CFrame1:CFrame,Enabled:bool,Part0:BasePart,Part0Internal:BasePart,Part1:BasePart,Part1Internal:BasePart,State:int;WindowProtocolService<Instance|BeginDrag,Close,EndDrag,GetLogicalCaptionButtonsBounds,GetNativeTitleBarControlsPosition,GetTitleBarMode,GetWindowState,IsAvailable,Maximize,Minimize,OnDragAreaDoubleClicked,OnDragAreaRightClicked,Restore,SetCustomTitleBarHeight,SetTitleBarMode,ShouldRenderTitleBarControlsNatively|OnWindowStateChanged|;Wire<Instance|RenameToDefault||Connected:bool,SourceInstance:Instance,SourceName:string,TargetInstance:Instance,TargetName:string;WrapDeformMeshProvider<Instance|||;WrapTextureTransfer<Instance|||ReferenceCageMeshContent:Content,UVMaxBound:Vector2,UVMinBound:Vector2;Logger<Object|Error,GetLogger,Info,Log,Output,Warn|MessageOut|FullPath:string,Name:string;LuauExpression<Object|Evaluate,References||;MLSession<Object|ForwardAsync||;OutputLink<Object|Print||;PluginConnection<Object|BindToMessage,SendMessage||Connected:bool,GroupId:string,TargetId:string,Type:PluginConnectionTargetType;StudioActionOverride<Object|Release|Triggered|Enabled:bool,Released:bool,StudioAction:StudioAction;TerrainIterateOperation<Object|CommitBlock|Ready|;TerrainModifyOperation<Object|CommitBlock|Ready|;TerrainReadOperation<Object||Ready|;TerrainWriteOperation<Object|CommitBlock,GetBlock||;VideoSampler<Object|GetSamplesAtTimesAsync||TimeLength:double,VideoContent:Content;VirtualInput<Object|SendKey,SendMouseButton,SendMouseDelta,SendMousePosition,SendPointerAction,SendTextInput||;VoxelBuffer<Object|GetSizeInVoxels,ReadVoxels,WriteVoxels,ClearAsync,DrawBufferAsync,FromHeightmapAsync,NormalizeAsync,UnclampAsync||;WebStreamClient<Object|Close,Send|Closed,Error,MessageReceived,Opened|ConnectionState:WebStreamClientState",
}

end)()
__ROBLOX.datatypes = (function()

-- Offline models of Roblox datatypes that are pure math (bundled into the
-- harness as __ROBLOX.datatypes). envlog.luau attaches a model value as the
-- "real twin" (REALV) of a datatype proxy built from constant arguments, so
-- members, methods and operators give the engine's numbers instead of
-- symbolic expressions (scripts and obfuscators derive values from them).
--
-- Anything a model doesn't implement, or arguments it can't take, raise
-- UNSUPPORTED: envlog then falls back to the symbolic proxy. Real Roblox
-- errors are only raised where Studio was checked.
--
-- CFrame: position + 3x3 rotation, float32 like the engine (stored as native
-- vectors, so the math is float32 per component). Verified against Studio:
-- constructors, tostring, GetComponents, * / + / -, Inverse, the space
-- conversions, Euler/axis-angle getters, Lerp.
local UNSUPPORTED = setmetatable({}, { __tostring = function() return "<datatypes: unsupported>" end })
local function unsupported() error(UNSUPPORTED, 0) end

local vec = vector.create
local vdot, vcross, vnorm, vmag = vector.dot, vector.cross, vector.normalize, vector.magnitude
local fbuf = buffer.create(4)
local function f32(x)
	buffer.writef32(fbuf, 0, x)
	return buffer.readf32(fbuf, 0)
end
local function isVec(v) return type(v) == "vector" end
local function num(v)
	if type(v) == "number" then return v end
	if type(v) == "string" and tonumber(v) then return tonumber(v) end
	return unsupported()
end

-- CFrame values: userdata -> { p = pos, x = col0, y = col1, z = col2 }
local CF = setmetatable({}, { __mode = "k" })
local CFMT = {}
local function make(p, cx, cy, cz)
	local u = newproxy(true)
	local mt = getmetatable(u)
	for k, v in CFMT do mt[k] = v end
	CF[u] = { p = p, x = cx, y = cy, z = cz }
	return u
end
local function get(v)
	local c = CF[v]
	if not c then unsupported() end
	return c
end
local X, Y, Z, O = vec(1, 0, 0), vec(0, 1, 0), vec(0, 0, 1), vec(0, 0, 0)
local IDENTITY = { p = O, x = X, y = Y, z = Z }

-- rotation from rows (row-major components as in GetComponents)
local function fromRows(p, r00, r01, r02, r10, r11, r12, r20, r21, r22)
	return make(p, vec(r00, r10, r20), vec(r01, r11, r21), vec(r02, r12, r22))
end
local function rot(c, v) return c.x * v.x + c.y * v.y + c.z * v.z end
local function rotT(c, v) return vec(vdot(c.x, v), vdot(c.y, v), vdot(c.z, v)) end
local function mul(a, b) return { p = rot(a, b.p) + a.p, x = rot(a, b.x), y = rot(a, b.y), z = rot(a, b.z) } end
local function inverse(c)
	local x = vec(c.x.x, c.y.x, c.z.x)
	local y = vec(c.x.y, c.y.y, c.z.y)
	local z = vec(c.x.z, c.y.z, c.z.z)
	local r = { p = O, x = x, y = y, z = z }
	r.p = -rot(r, c.p)
	return r
end
local function wrap(c) return make(c.p, c.x, c.y, c.z) end

-- rotation matrices (double math, rounded once per component)
local function rx(a)
	local s, c = math.sin(a), math.cos(a)
	return { 1, 0, 0, 0, c, -s, 0, s, c }
end
local function ry(a)
	local s, c = math.sin(a), math.cos(a)
	return { c, 0, s, 0, 1, 0, -s, 0, c }
end
local function rz(a)
	local s, c = math.sin(a), math.cos(a)
	return { c, -s, 0, s, c, 0, 0, 0, 1 }
end
local function mm(a, b)
	local r = {}
	for i = 0, 2 do
		for j = 0, 2 do
			r[i * 3 + j + 1] = a[i * 3 + 1] * b[j + 1] + a[i * 3 + 2] * b[j + 4] + a[i * 3 + 3] * b[j + 7]
		end
	end
	return r
end
local function fromMat(p, m)
	return fromRows(p, m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9])
end
local function fromQuat(p, qx, qy, qz, qw)
	local n = qx * qx + qy * qy + qz * qz + qw * qw
	if n == 0 then unsupported() end
	local s = 2 / n
	return fromRows(p,
		1 - s * (qy * qy + qz * qz), s * (qx * qy - qz * qw), s * (qx * qz + qy * qw),
		s * (qx * qy + qz * qw), 1 - s * (qx * qx + qz * qz), s * (qy * qz - qx * qw),
		s * (qx * qz - qy * qw), s * (qy * qz + qx * qw), 1 - s * (qx * qx + qy * qy))
end
local function toQuat(c)
	local m00, m01, m02 = c.x.x, c.y.x, c.z.x
	local m10, m11, m12 = c.x.y, c.y.y, c.z.y
	local m20, m21, m22 = c.x.z, c.y.z, c.z.z
	local tr = m00 + m11 + m22
	if tr > 0 then
		local s = math.sqrt(tr + 1) * 2
		return (m21 - m12) / s, (m02 - m20) / s, (m10 - m01) / s, s / 4
	elseif m00 > m11 and m00 > m22 then
		local s = math.sqrt(1 + m00 - m11 - m22) * 2
		return s / 4, (m01 + m10) / s, (m02 + m20) / s, (m21 - m12) / s
	elseif m11 > m22 then
		local s = math.sqrt(1 + m11 - m00 - m22) * 2
		return (m01 + m10) / s, s / 4, (m12 + m21) / s, (m02 - m20) / s
	end
	local s = math.sqrt(1 + m22 - m00 - m11) * 2
	return (m02 + m20) / s, (m12 + m21) / s, s / 4, (m10 - m01) / s
end
local function lookAt(at, target, up)
	local look = vnorm(target - at)
	local right = vcross(look, up)
	if vmag(right) < 1e-6 then unsupported() end -- the engine's degenerate case isn't modelled
	right = vnorm(right)
	local up2 = vcross(right, look)
	return make(at, right, up2, -look)
end

local lib = {}
function lib.new(...)
	local n = select("#", ...)
	local a = { ... }
	if n == 0 then return wrap(IDENTITY) end
	if n == 1 and isVec(a[1]) then return make(a[1], X, Y, Z) end
	if n == 2 and isVec(a[1]) and isVec(a[2]) then return lookAt(a[1], a[2], Y) end
	if n == 3 then return make(vec(num(a[1]), num(a[2]), num(a[3])), X, Y, Z) end
	if n == 7 then
		return fromQuat(vec(num(a[1]), num(a[2]), num(a[3])), num(a[4]), num(a[5]), num(a[6]), num(a[7]))
	end
	if n == 12 then
		for i = 1, 12 do a[i] = num(a[i]) end
		return fromRows(vec(a[1], a[2], a[3]), a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12])
	end
	return unsupported()
end
function lib.Angles(a, b, c)
	return fromMat(O, mm(mm(rx(num(a or 0)), ry(num(b or 0))), rz(num(c or 0))))
end
lib.fromEulerAnglesXYZ = lib.Angles
function lib.fromEulerAnglesYXZ(a, b, c)
	return fromMat(O, mm(mm(ry(num(b or 0)), rx(num(a or 0))), rz(num(c or 0))))
end
lib.fromOrientation = lib.fromEulerAnglesYXZ
function lib.fromAxisAngle(axis, angle)
	if not isVec(axis) then unsupported() end
	local u = vnorm(axis)
	local h = num(angle) / 2
	local s = math.sin(h)
	return fromQuat(O, u.x * s, u.y * s, u.z * s, math.cos(h))
end
function lib.lookAt(at, target, up)
	if not isVec(at) or not isVec(target) or (up ~= nil and not isVec(up)) then unsupported() end
	return lookAt(at, target, up or Y)
end
function lib.fromMatrix(p, vx, vy, vz)
	if not isVec(p) or not isVec(vx) or not isVec(vy) or (vz ~= nil and not isVec(vz)) then unsupported() end
	return make(p, vx, vy, vz or vnorm(vcross(vx, vy)))
end
lib.identity = wrap(IDENTITY)

local function components(c)
	return c.p.x, c.p.y, c.p.z, c.x.x, c.y.x, c.z.x, c.x.y, c.y.y, c.z.y, c.x.z, c.y.z, c.z.z
end
local function eulerXYZ(c)
	local r02 = math.clamp(c.z.x, -1, 1)
	return f32(math.atan2(-c.z.y, c.z.z)), f32(math.asin(r02)), f32(math.atan2(-c.y.x, c.x.x))
end
local function eulerYXZ(c)
	local r12 = math.clamp(c.z.y, -1, 1)
	return f32(math.asin(-r12)), f32(math.atan2(c.z.x, c.z.z)), f32(math.atan2(c.x.y, c.y.y))
end
local function each(f)
	-- methods taking one or more values and returning one result each
	return function(self, ...)
		local c = get(self)
		local n = select("#", ...)
		if n == 0 then unsupported() end
		local out = { ... }
		for i = 1, n do out[i] = f(c, out[i]) end
		return table.unpack(out, 1, n)
	end
end
local function vecArg(v)
	if not isVec(v) then unsupported() end
	return v
end
local METHODS = {
	Inverse = function(self) return wrap(inverse(get(self))) end,
	GetComponents = function(self) return components(get(self)) end,
	ToWorldSpace = each(function(c, o) return wrap(mul(c, get(o))) end),
	ToObjectSpace = each(function(c, o) return wrap(mul(inverse(c), get(o))) end),
	PointToWorldSpace = each(function(c, v) return rot(c, vecArg(v)) + c.p end),
	PointToObjectSpace = each(function(c, v) return rotT(c, vecArg(v) - c.p) end),
	VectorToWorldSpace = each(function(c, v) return rot(c, vecArg(v)) end),
	VectorToObjectSpace = each(function(c, v) return rotT(c, vecArg(v)) end),
	ToEulerAnglesXYZ = function(self) return eulerXYZ(get(self)) end,
	ToEulerAnglesYXZ = function(self) return eulerYXZ(get(self)) end,
	ToOrientation = function(self) return eulerYXZ(get(self)) end,
	ToAxisAngle = function(self)
		local qx, qy, qz, qw = toQuat(get(self))
		if qw < 0 then qx, qy, qz, qw = -qx, -qy, -qz, -qw end
		local s = math.sqrt(math.max(0, 1 - qw * qw))
		if s < 1e-9 then return X, 0 end
		return vec(qx / s, qy / s, qz / s), f32(2 * math.acos(math.clamp(qw, -1, 1)))
	end,
	Lerp = function(self, other, t)
		local a, b = get(self), get(other)
		t = num(t)
		local ax, ay, az, aw = toQuat(a)
		local bx, by, bz, bw = toQuat(b)
		local d = ax * bx + ay * by + az * bz + aw * bw
		if d < 0 then bx, by, bz, bw, d = -bx, -by, -bz, -bw, -d end
		local wa, wb
		if d > 0.9995 then
			wa, wb = 1 - t, t
		else
			local th = math.acos(d)
			local s = math.sin(th)
			wa, wb = math.sin((1 - t) * th) / s, math.sin(t * th) / s
		end
		local p = a.p + (b.p - a.p) * t
		return fromQuat(p, ax * wa + bx * wb, ay * wa + by * wb, az * wa + bz * wb, aw * wa + bw * wb)
	end,
}
METHODS.components = METHODS.GetComponents
METHODS.inverse = METHODS.Inverse
METHODS.lerp = METHODS.Lerp
METHODS.toWorldSpace = METHODS.ToWorldSpace
METHODS.toObjectSpace = METHODS.ToObjectSpace
METHODS.pointToWorldSpace = METHODS.PointToWorldSpace
METHODS.pointToObjectSpace = METHODS.PointToObjectSpace
METHODS.vectorToWorldSpace = METHODS.VectorToWorldSpace
METHODS.vectorToObjectSpace = METHODS.VectorToObjectSpace
METHODS.toEulerAnglesXYZ = METHODS.ToEulerAnglesXYZ
METHODS.toAxisAngle = METHODS.ToAxisAngle

local PROPS = {
	Position = function(c) return c.p end,
	X = function(c) return c.p.x end,
	Y = function(c) return c.p.y end,
	Z = function(c) return c.p.z end,
	LookVector = function(c) return -c.z end,
	RightVector = function(c) return c.x end,
	UpVector = function(c) return c.y end,
	XVector = function(c) return c.x end,
	YVector = function(c) return c.y end,
	ZVector = function(c) return c.z end,
	Rotation = function(c) return make(O, c.x, c.y, c.z) end,
}
PROPS.p, PROPS.x, PROPS.y, PROPS.z = PROPS.Position, PROPS.X, PROPS.Y, PROPS.Z
PROPS.lookVector, PROPS.rightVector, PROPS.upVector = PROPS.LookVector, PROPS.RightVector, PROPS.UpVector

CFMT.__index = function(self, k)
	local c = get(self)
	local prop = PROPS[k]
	if prop then return prop(c) end
	local m = METHODS[k]
	if m then return m end
	if type(k) == "string" then error(k .. " is not a valid member of CFrame", 0) end
	return unsupported()
end
CFMT.__newindex = function() unsupported() end
CFMT.__mul = function(a, b)
	local c = get(a)
	if isVec(b) then return rot(c, b) + c.p end
	return wrap(mul(c, get(b)))
end
CFMT.__add = function(a, b)
	if not isVec(b) then unsupported() end
	local c = get(a)
	return make(c.p + b, c.x, c.y, c.z)
end
CFMT.__sub = function(a, b)
	if not isVec(b) then unsupported() end
	local c = get(a)
	return make(c.p - b, c.x, c.y, c.z)
end
CFMT.__eq = function(a, b)
	local x, y = CF[a], CF[b]
	return x ~= nil and y ~= nil and x.p == y.p and x.x == y.x and x.y == y.y and x.z == y.z
end
CFMT.__tostring = function(self)
	local t = { components(get(self)) }
	for i = 1, 12 do t[i] = string.format("%.9g", t[i]) end
	return table.concat(t, ", ")
end
CFMT.__metatable = "The metatable is locked"

-- UDim / UDim2 / Path2DControlPoint (verified against Studio: tostring,
-- int32 offsets truncated toward zero, float32 scales, + - unary -, ==,
-- Lerp rounding offsets, the control point's 0/1/3-argument constructor)
local TYPE = setmetatable({}, { __mode = "k" }) -- value -> type name
local VAL = setmetatable({}, { __mode = "k" }) -- value -> fields
local function valueType(name, index, ops)
	local mt = { __metatable = "The metatable is locked" }
	for k, v in ops do mt[k] = v end
	mt.__index = function(self, k)
		local r = index(VAL[self], k)
		if r ~= nil then return r end
		if type(k) == "string" then error(k .. " is not a valid member of " .. name, 0) end
		return unsupported()
	end
	mt.__newindex = function() unsupported() end
	return function(fields)
		local u = newproxy(true)
		local m = getmetatable(u)
		for k, v in mt do m[k] = v end
		TYPE[u], VAL[u] = name, fields
		return u
	end
end
local function field(v, name)
	if TYPE[v] ~= name then unsupported() end
	return VAL[v]
end
local function int32(x)
	x = num(x)
	if x ~= x or x >= 2147483648 or x < -2147483648 then return -2147483648 end
	return x < 0 and math.ceil(x) or math.floor(x)
end

local newUDim
newUDim = valueType("UDim", function(f, k)
	if k == "Scale" then return f.s end
	if k == "Offset" then return f.o end
	return nil
end, {
	__add = function(a, b) local x, y = field(a, "UDim"), field(b, "UDim") return newUDim({ s = f32(x.s + y.s), o = int32(x.o + y.o) }) end,
	__sub = function(a, b) local x, y = field(a, "UDim"), field(b, "UDim") return newUDim({ s = f32(x.s - y.s), o = int32(x.o - y.o) }) end,
	__unm = function(a) local x = field(a, "UDim") return newUDim({ s = -x.s, o = int32(-x.o) }) end,
	__eq = function(a, b) local x, y = VAL[a], VAL[b] return TYPE[a] == TYPE[b] and x.s == y.s and x.o == y.o end,
	__tostring = function(a) local x = VAL[a] return string.format("%.9g, %d", x.s, x.o) end,
})
local function udim(s, o) return newUDim({ s = f32(num(s or 0)), o = int32(o or 0) }) end

local newUDim2
local function udim2Str(f)
	local x, y = VAL[f.x], VAL[f.y]
	return string.format("{%.9g, %d}, {%.9g, %d}", x.s, x.o, y.s, y.o)
end
local function lerpUDim(a, b, t)
	local x, y = VAL[a], VAL[b]
	return newUDim({ s = f32(x.s + (y.s - x.s) * t), o = int32(math.floor(x.o + (y.o - x.o) * t + 0.5)) })
end
newUDim2 = valueType("UDim2", function(f, k)
	if k == "X" or k == "Width" then return f.x end
	if k == "Y" or k == "Height" then return f.y end
	if k == "Lerp" or k == "lerp" then
		return function(self, other, t)
			local a, b = field(self, "UDim2"), field(other, "UDim2")
			t = num(t)
			return newUDim2({ x = lerpUDim(a.x, b.x, t), y = lerpUDim(a.y, b.y, t) })
		end
	end
	return nil
end, {
	__add = function(a, b) local x, y = field(a, "UDim2"), field(b, "UDim2") return newUDim2({ x = x.x + y.x, y = x.y + y.y }) end,
	__sub = function(a, b) local x, y = field(a, "UDim2"), field(b, "UDim2") return newUDim2({ x = x.x - y.x, y = x.y - y.y }) end,
	__unm = function(a) local x = field(a, "UDim2") return newUDim2({ x = -x.x, y = -x.y }) end,
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].x == VAL[b].x and VAL[a].y == VAL[b].y end,
	__tostring = function(a) return udim2Str(VAL[a]) end,
})
local UDimLib = { new = function(s, o) return udim(s, o) end }
local UDim2Lib = {}
function UDim2Lib.new(...)
	local n = select("#", ...)
	local a, b, c, d = ...
	if n == 2 and TYPE[a] == "UDim" and TYPE[b] == "UDim" then return newUDim2({ x = a, y = b }) end
	for i = 1, n do
		local v = select(i, ...)
		if v ~= nil and type(v) ~= "number" and not (type(v) == "string" and tonumber(v)) then unsupported() end
	end
	return newUDim2({ x = udim(a, b), y = udim(c, d) })
end
function UDim2Lib.fromScale(x, y) return newUDim2({ x = udim(x, 0), y = udim(y, 0) }) end
function UDim2Lib.fromOffset(x, y) return newUDim2({ x = udim(0, x), y = udim(0, y) }) end

local newCP = valueType("Path2DControlPoint", function(f, k)
	if k == "Position" then return f.p end
	if k == "LeftTangent" then return f.l end
	if k == "RightTangent" then return f.r end
	return nil
end, {
	__eq = function(a, b)
		local x, y = VAL[a], VAL[b]
		return TYPE[a] == TYPE[b] and x.p == y.p and x.l == y.l and x.r == y.r
	end,
	__tostring = function(a)
		local f = VAL[a]
		return string.format("Path2DControlPoint { Position = %s, LeftTangent = %s, RightTangent = %s }",
			udim2Str(VAL[f.p]), udim2Str(VAL[f.l]), udim2Str(VAL[f.r]))
	end,
})
local CPLib = {}
function CPLib.new(...)
	local n = select("#", ...)
	local p, l, r = ...
	local zero = UDim2Lib.new()
	if n == 0 then return newCP({ p = zero, l = zero, r = zero }) end
	if n ~= 1 and n ~= 3 then error("Trying to create a Path2DControlPoint with wrong number of arguments", 0) end
	for i = 1, n do
		if TYPE[(select(i, ...))] ~= "UDim2" then unsupported() end
	end
	return newCP({ p = p, l = l or zero, r = r or zero })
end

-- Vector2 (userdata in Roblox, float32 components: kept as a native vector
-- with z = 0 so the arithmetic is float32), Rect (corners sorted), Ray.
-- Verified against Studio: tostring, operators, members, the methods below.
local newV2
local function v2(v) return newV2({ v = v }) end
local function v2val(v)
	if TYPE[v] ~= "Vector2" then unsupported() end
	return VAL[v].v
end
local function v2arith(op)
	return function(a, b)
		local x = TYPE[a] == "Vector2" and VAL[a].v or (type(a) == "number" and vec(a, a, 0)) or unsupported()
		local y = TYPE[b] == "Vector2" and VAL[b].v or (type(b) == "number" and vec(b, b, 0)) or unsupported()
		local r = op(x, y)
		return v2(vec(r.x, r.y, 0))
	end
end
local V2METHODS = {
	Dot = function(a, b) return vdot(v2val(a), v2val(b)) end,
	Cross = function(a, b) local x, y = v2val(a), v2val(b) return f32(f32(x.x * y.y) - f32(x.y * y.x)) end,
	Lerp = function(a, b, t) local x, y = v2val(a), v2val(b) return v2(x + (y - x) * num(t)) end,
	Abs = function(a) return v2(vector.abs(v2val(a))) end,
	Floor = function(a) return v2(vector.floor(v2val(a))) end,
	Ceil = function(a) return v2(vector.ceil(v2val(a))) end,
	Sign = function(a) return v2(vector.sign(v2val(a))) end,
	Max = function(a, b) return v2(vector.max(v2val(a), v2val(b))) end,
	Min = function(a, b) return v2(vector.min(v2val(a), v2val(b))) end,
	Angle = function(a, b, signed)
		local x, y = v2val(a), v2val(b)
		local ang = math.atan2(math.abs(x.x * y.y - x.y * y.x), x.x * y.x + x.y * y.y)
		if signed and x.x * y.y - x.y * y.x < 0 then ang = -ang end
		return f32(ang)
	end,
}
V2METHODS.lerp = V2METHODS.Lerp
newV2 = valueType("Vector2", function(f, k)
	local v = f.v
	if k == "X" or k == "x" then return v.x end
	if k == "Y" or k == "y" then return v.y end
	if k == "Magnitude" or k == "magnitude" then return vmag(v) end
	if k == "Unit" or k == "unit" then return v2(vnorm(v)) end
	return V2METHODS[k]
end, {
	__add = v2arith(function(a, b) return a + b end),
	__sub = v2arith(function(a, b) return a - b end),
	__mul = v2arith(function(a, b) return a * b end),
	__div = v2arith(function(a, b) return a / b end),
	__idiv = v2arith(function(a, b) return a // b end),
	__unm = function(a) return v2(-v2val(a)) end,
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].v == VAL[b].v end,
	__tostring = function(a) local v = VAL[a].v return string.format("%.9g, %.9g", v.x, v.y) end,
})
local V2Lib = {
	new = function(x, y) return v2(vec(num(x or 0), num(y or 0), 0)) end,
	zero = v2(vec(0, 0, 0)),
	one = v2(vec(1, 1, 0)),
	xAxis = v2(vec(1, 0, 0)),
	yAxis = v2(vec(0, 1, 0)),
}

local newRect = valueType("Rect", function(f, k)
	if k == "Min" then return v2(f.lo) end
	if k == "Max" then return v2(f.hi) end
	if k == "Width" then return f.hi.x - f.lo.x end
	if k == "Height" then return f.hi.y - f.lo.y end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].lo == VAL[b].lo and VAL[a].hi == VAL[b].hi end,
	__tostring = function(a)
		local f = VAL[a]
		return string.format("%.9g, %.9g, %.9g, %.9g", f.lo.x, f.lo.y, f.hi.x, f.hi.y)
	end,
})
local RectLib = {}
function RectLib.new(...)
	local n = select("#", ...)
	local a, b, c, d = ...
	local p, q
	if n == 2 then
		p, q = v2val(a), v2val(b)
	elseif n == 0 or n == 4 then
		p, q = vec(num(a or 0), num(b or 0), 0), vec(num(c or 0), num(d or 0), 0)
	else
		return unsupported()
	end
	return newRect({ lo = vector.min(p, q), hi = vector.max(p, q) })
end

local newRay
local function closest(f, p)
	if not isVec(p) then unsupported() end
	local u = vnorm(f.d)
	local t = math.max(0, vdot(p - f.o, u))
	return f.o + u * t
end
newRay = valueType("Ray", function(f, k)
	if k == "Origin" then return f.o end
	if k == "Direction" then return f.d end
	if k == "Unit" then return newRay({ o = f.o, d = vnorm(f.d) }) end
	if k == "ClosestPoint" then return function(self, p) return closest(field(self, "Ray"), p) end end
	if k == "Distance" then return function(self, p) return vmag(p - closest(field(self, "Ray"), p)) end end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].o == VAL[b].o and VAL[a].d == VAL[b].d end,
	__tostring = function(a)
		local f = VAL[a]
		return string.format("{%s}, {%s}", tostring(f.o), tostring(f.d))
	end,
})
local RayLib = {
	new = function(o, d)
		if (o ~= nil and not isVec(o)) or (d ~= nil and not isVec(d)) then unsupported() end
		return newRay({ o = o or O, d = d or O })
	end,
}

-- NumberRange, Color3, Vector3int16/Vector2int16, Number/ColorSequence(Keypoint).
-- tostring uses C++ stream formatting (%g, 6 digits), keypoints and ranges
-- end in a space; float32 fields; int16 wraps around (all as in Studio).
local function g(x) return string.format("%g", x) end
local newNR = valueType("NumberRange", function(f, k)
	if k == "Min" then return f.lo end
	if k == "Max" then return f.hi end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].lo == VAL[b].lo and VAL[a].hi == VAL[b].hi end,
	__tostring = function(a) return g(VAL[a].lo) .. " " .. g(VAL[a].hi) .. " " end,
})
local NRLib = {
	new = function(lo, hi)
		lo = f32(num(lo))
		hi = hi == nil and lo or f32(num(hi))
		if lo > hi then error("NumberRange: invalid range", 0) end
		return newNR({ lo = lo, hi = hi })
	end,
}

local newC3
local function c3(r, g_, b) return newC3({ v = vec(r, g_, b) }) end
local function c3val(c)
	if TYPE[c] ~= "Color3" then unsupported() end
	return VAL[c].v
end
local function toHSV(v)
	local r, gg, b = math.clamp(v.x, 0, 1), math.clamp(v.y, 0, 1), math.clamp(v.z, 0, 1) -- the engine clamps first
	local mx, mn = math.max(r, gg, b), math.min(r, gg, b)
	local d = mx - mn
	local h = 0
	if d ~= 0 then
		if mx == r then
			h = ((gg - b) / d) % 6
		elseif mx == gg then
			h = (b - r) / d + 2
		else
			h = (r - gg) / d + 4
		end
		h /= 6
	end
	return f32(h), f32(mx == 0 and 0 or d / mx), f32(mx)
end
local function byte(x) return math.clamp(math.floor(x * 255 + 0.5), 0, 255) end
local C3METHODS = {
	Lerp = function(a, b, t) local x, y = c3val(a), c3val(b) return newC3({ v = x + (y - x) * num(t) }) end,
	ToHSV = function(a) return toHSV(c3val(a)) end,
	ToHex = function(a) local v = c3val(a) return string.format("%02x%02x%02x", byte(v.x), byte(v.y), byte(v.z)) end,
}
C3METHODS.lerp = C3METHODS.Lerp
newC3 = valueType("Color3", function(f, k)
	if k == "R" or k == "r" then return f.v.x end
	if k == "G" or k == "g" then return f.v.y end
	if k == "B" or k == "b" then return f.v.z end
	return C3METHODS[k]
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].v == VAL[b].v end,
	__tostring = function(a) local v = VAL[a].v return g(v.x) .. ", " .. g(v.y) .. ", " .. g(v.z) end,
})
local function hsv(h, s, v)
	h, s, v = num(h), num(s), num(v)
	h = (h % 1) * 6
	local i = math.floor(h)
	local f = h - i
	local p, q, t = v * (1 - s), v * (1 - s * f), v * (1 - s * (1 - f))
	if i == 0 then return c3(v, t, p) elseif i == 1 then return c3(q, v, p) elseif i == 2 then return c3(p, v, t)
	elseif i == 3 then return c3(p, q, v) elseif i == 4 then return c3(t, p, v) end
	return c3(v, p, q)
end
local C3Lib = {
	new = function(r, g_, b) return c3(num(r or 0), num(g_ or 0), num(b or 0)) end,
	fromRGB = function(r, g_, b) return c3(num(r or 0) / 255, num(g_ or 0) / 255, num(b or 0) / 255) end,
	fromHSV = hsv,
	fromHex = function(s)
		if type(s) ~= "string" then unsupported() end
		local h = string.match(s, "^#?(%x%x%x%x%x%x)$")
		if not h then
			local r, g_, b = string.match(s, "^#?(%x)(%x)(%x)$")
			if not r then unsupported() end
			h = r .. r .. g_ .. g_ .. b .. b
		end
		return c3(tonumber(string.sub(h, 1, 2), 16) / 255, tonumber(string.sub(h, 3, 4), 16) / 255,
			tonumber(string.sub(h, 5, 6), 16) / 255)
	end,
	toHSV = function(c) return toHSV(c3val(c)) end,
}

local function int16(x)
	x = num(x or 0)
	x = x < 0 and math.ceil(x) or math.floor(x)
	return (x + 32768) % 65536 - 32768
end
local function intVector(name, n)
	local new
	local function make(...)
		local t = { ... }
		for i = 1, n do t[i] = int16(t[i]) end
		return new({ c = t })
	end
	local function arith(op)
		return function(a, b)
			if TYPE[a] ~= name or TYPE[b] ~= name then unsupported() end
			local x, y, r = VAL[a].c, VAL[b].c, {}
			for i = 1, n do r[i] = op(x[i], y[i]) end
			return make(table.unpack(r, 1, n))
		end
	end
	local KEYS = { X = 1, Y = 2, Z = n == 3 and 3 or nil, x = 1, y = 2, z = n == 3 and 3 or nil }
	new = valueType(name, function(f, k)
		local i = KEYS[k]
		return i and f.c[i] or nil
	end, {
		__add = arith(function(a, b) return a + b end),
		__sub = arith(function(a, b) return a - b end),
		__mul = arith(function(a, b) return a * b end),
		__div = arith(function(a, b) return a / b end),
		__unm = function(a) local c = VAL[a].c return make(-c[1], -c[2], -(c[3] or 0)) end,
		__eq = function(a, b)
			if TYPE[a] ~= TYPE[b] then return false end
			for i = 1, n do if VAL[a].c[i] ~= VAL[b].c[i] then return false end end
			return true
		end,
		__tostring = function(a) return table.concat(VAL[a].c, ", ", 1, n) end,
	})
	return { new = make }
end

local newNSK = valueType("NumberSequenceKeypoint", function(f, k)
	if k == "Time" then return f.t end
	if k == "Value" then return f.v end
	if k == "Envelope" then return f.e end
	return nil
end, {
	__eq = function(a, b) local x, y = VAL[a], VAL[b] return TYPE[a] == TYPE[b] and x.t == y.t and x.v == y.v and x.e == y.e end,
	__tostring = function(a) local f = VAL[a] return g(f.t) .. " " .. g(f.v) .. " " .. g(f.e) .. " " end,
})
local NSKLib = {
	new = function(t, v, e) return newNSK({ t = f32(num(t)), v = f32(num(v)), e = f32(num(e or 0)) }) end,
}
local newCSK = valueType("ColorSequenceKeypoint", function(f, k)
	if k == "Time" then return f.t end
	if k == "Value" then return f.c end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].t == VAL[b].t and VAL[a].c == VAL[b].c end,
	__tostring = function(a)
		local f = VAL[a]
		local v = VAL[f.c].v
		return g(f.t) .. " " .. g(v.x) .. " " .. g(v.y) .. " " .. g(v.z) .. " 0 "
	end,
})
local CSKLib = {
	new = function(t, c)
		c3val(c)
		return newCSK({ t = f32(num(t)), c = c })
	end,
}
local function sequence(name, kpType, fromValues)
	local new
	new = valueType(name, function(f, k)
		if k == "Keypoints" then return table.clone(f.k) end
		return nil
	end, {
		__eq = function(a, b)
			if TYPE[a] ~= TYPE[b] or #VAL[a].k ~= #VAL[b].k then return false end
			for i, kp in VAL[a].k do if not (kp == VAL[b].k[i]) then return false end end
			return true
		end,
		__tostring = function(a)
			local parts = {}
			for i, kp in VAL[a].k do parts[i] = tostring(kp) end
			return table.concat(parts)
		end,
	})
	return {
		new = function(...)
			local a = ...
			if type(a) == "table" then
				for _, kp in a do if TYPE[kp] ~= kpType then unsupported() end end
				if #a < 2 then unsupported() end
				return new({ k = table.clone(a) })
			end
			return new({ k = fromValues(...) })
		end,
	}
end
local NSLib = sequence("NumberSequence", "NumberSequenceKeypoint", function(a, b)
	b = b == nil and a or b
	return { NSKLib.new(0, a), NSKLib.new(1, b) }
end)
local CSLib = sequence("ColorSequence", "ColorSequenceKeypoint", function(a, b)
	b = b == nil and a or b
	return { CSKLib.new(0, a), CSKLib.new(1, b) }
end)

-- typeof() ignores __type on newproxy userdata: envlog asks here instead
local function typeOf(v)
	if CF[v] then return "CFrame" end
	return TYPE[v]
end

return {
	UNSUPPORTED = UNSUPPORTED,
	typeOf = typeOf,
	CFrame = lib,
	UDim = UDimLib,
	UDim2 = UDim2Lib,
	Path2DControlPoint = CPLib,
	Vector2 = V2Lib,
	Rect = RectLib,
	Ray = RayLib,
	NumberRange = NRLib,
	Color3 = C3Lib,
	Vector3int16 = intVector("Vector3int16", 3),
	Vector2int16 = intVector("Vector2int16", 2),
	NumberSequenceKeypoint = NSKLib,
	ColorSequenceKeypoint = CSKLib,
	NumberSequence = NSLib,
	ColorSequence = CSLib,
}

end)()

--[[
	envlog.luau - dynamic deobfuscation runtime (fake Roblox/executor environment).

	The Luraph VM cannot be read statically in any useful way (its bytecode is
	encrypted and its interpreter is split into hundreds of flattened state
	machine fragments), but everything the protected script *does* has to go
	through the environment it runs in. This runtime executes the script against
	a fake Roblox environment made of logging proxies and reconstructs readable
	Luau from the observed operations.

	harness.build_harness prepends locals before this file, e.g.:
		__SOURCE  : string  - the protected script
		__CONFIG  : table   - options (see CFG below)
]]

local CFG = __CONFIG or {}
local MAX_STMTS = CFG.max_stmts or 250000
local MAX_BLOCK = CFG.max_block or 25000
local MAX_WAITS = CFG.max_waits or 50
local MAX_DEPTH = CFG.max_depth or 24
local TIME_BUDGET = CFG.time_budget or 30

-- untouched references to the real globals
local R = {
	type = type, typeof = typeof, tostring = tostring, tonumber = tonumber,
	pairs = pairs, ipairs = ipairs, next = next, select = select,
	rawget = rawget, rawset = rawset, rawequal = rawequal, rawlen = rawlen,
	setmetatable = setmetatable, getmetatable = getmetatable,
	pcall = pcall, xpcall = xpcall, error = error,
	getfenv = getfenv, setfenv = setfenv, loadstring = loadstring,
	newproxy = newproxy, print = print, clock = os.clock,
	unpack = table.unpack, insert = table.insert, concat = table.concat,
	remove = table.remove, fmt = string.format, rep = string.rep,
	gsub = string.gsub, gmatch = string.gmatch, match = string.match, byte = string.byte, lower = string.lower,
	sub = string.sub, find = string.find, sort = table.sort,
	floor = math.floor, huge = math.huge, max = math.max,
}
local REAL_G = R.getfenv(0)
local HARNESS_SRC0 = debug.info(1, "s")

-- native mode: the harness runs inside Roblox itself (Studio). Pure engine
-- objects then get a real twin, so values the engine computes (Path2D curve
-- math, datatype arithmetic, ...) are bit-exact. Output is collected and
-- returned by the chunk instead of printed.
local NATIVE = CFG.native and R.typeof(REAL_G.game) == "Instance"
local OUTBUF = {}
if NATIVE then
	R.print = function(...)
		local t = table.pack(...)
		for i = 1, t.n do t[i] = R.tostring(t[i]) end
		R.insert(OUTBUF, R.concat(t, "\t", 1, t.n))
		-- debug traces can be huge: keep only the tail (print_tail lines)
		if CFG.print_tail and #OUTBUF > 2 * CFG.print_tail then
			OUTBUF = table.move(OUTBUF, #OUTBUF - CFG.print_tail + 1, #OUTBUF, 1, {})
		end
	end
end
local START = R.clock()

-- sentinels used to unwind the script
local LOOP = R.setmetatable({}, { __tostring = function() return "<envlog: loop truncated>" end })
local ABORT = R.setmetatable({}, { __tostring = function() return "<envlog: budget exhausted>" end })
local TAMPER = R.setmetatable({}, { __tostring = function() return "<envlog: anti-tamper suppressed>" end })
local ABORT_REASON = nil
local tamperCount = 0
local TRIGGER, noteTrigger = nil, nil
local ALLOC_TRIGGER = nil

---------------------------------------------------------------------------
-- output model
--   block = { lines = { stmt... }, waits = {...} }
--   stmt  = { text = "tokenised text" }
--         | { call = "tokenised call", res = proxy }
--         | { header = "tokenised", block = block }
--   Proxies are embedded in text as \1<id>\2, captured functions as \3<id>\4
--   so names can be decided after the run (only values that are actually used
--   get a local).
---------------------------------------------------------------------------
local ROOT = { lines = {}, waits = {} }
local STACK = { ROOT }
local stmtCount = 0

-- proto attribution (for folding repeated helpers, see fold.py): every
-- statement records which script functions (Luraph protos) were on the Lua
-- stack when it was emitted, outermost first, as "pid:invocation,...".
-- pf: closure -> proto (filled where Luraph makes closures), pid: proto -> id,
-- plast: id -> number of its latest entry (tells invocations apart)
local CHAIN = { pf = nil, pid = nil, plast = nil }
function CHAIN.get()
	local pf, pid, plast = CHAIN.pf, CHAIN.pid, CHAIN.plast
	if not pf or not pid or not plast then return "" end
	local parts = {}
	local lvl = 3
	while true do
		local f = debug.info(lvl, "f")
		if f == nil then break end
		local proto = pf[f]
		local id = proto and pid[proto]
		if id then
			R.insert(parts, 1, id .. ":" .. R.tostring(plast[id]))
		end
		lvl += 1
	end
	-- v15 normally enters the bootstrap root as proto #1, but v14.x can
	-- create/enter helper protos before that root.  The invariant we actually
	-- need is the runtime stack shape: the outermost instrumented proto calls
	-- the payload root immediately below it.  Track that observed edge instead
	-- of hardcoding pid 1.  If the outer proto later emits by itself, the child
	-- was a probe/helper; a later nested statement can establish a new child.
	CHAIN.seen = CHAIN.seen or {}
	if #parts >= 2 then
		local p = R.tonumber(R.match(parts[1], "^(%d+):"))
		local c = R.tonumber(R.match(parts[2], "^(%d+):"))
		if p and c then
			CHAIN.rootParent = p
			CHAIN.rootCallee = c
			CHAIN.seen[c] = "ok"
		end
	elseif #parts == 1 then
		local p = R.tonumber(R.match(parts[1], "^(%d+):"))
		if p and CHAIN.rootParent == p and CHAIN.rootCallee then
			CHAIN.seen[CHAIN.rootCallee] = "probe"
		end
	end
	return R.concat(parts, ",")
end

local function curBlock()
	return STACK[#STACK]
end

local abortHits = 0
local function checkBudget()
	-- a plugin's end hook running script code after the run (ironbrew1's
	-- capture pushes never-run protos through the VM's closure maker)
	if CHAIN.unlimited then return end
	if ABORT_REASON then
		-- the script's pcall swallowed the abort and it kept going (a loop
		-- around pcall): leave its thread by yielding (runInBlock / the main
		-- runner treat an ABORT yield as the abort)
		abortHits += 1
		if abortHits > 1 and coroutine.isyieldable() then coroutine.yield(ABORT) end
		R.error(ABORT, 0)
	end
	if stmtCount > MAX_STMTS then
		ABORT_REASON = "statement limit reached"
		R.error(ABORT, 0)
	end
	local now = R.clock()
	if now - START > TIME_BUDGET then
		ABORT_REASON = "time budget exhausted"
		R.error(ABORT, 0)
	end
	-- heartbeat (harness.run_once): the pipe is block-buffered, so the padding
	-- pushes it out; a run without one for a while is stuck in pure script code
	if CFG.heartbeat and now - (CFG._hb or START) > CFG.heartbeat then
		CFG._hb = now
		R.print("\0HB\n" .. R.rep(" ", 16384))
	end
end

local function emit(stmt)
	checkBudget()
	if CHAIN.syncGenv and not CHAIN.syncing then CHAIN.syncGenv() end
	local b = curBlock()
	if b.stopped then
		b.stopped += 1
		if b.stopped > 200 then
			ABORT_REASON = "a stopped loop kept running (its error was caught by the script)"
			R.error(ABORT, 0)
		end
		R.error(LOOP, 0)
	end
	stmtCount += 1
	if CHAIN.pf then stmt.chain = CHAIN.get() end
	R.insert(b.lines, stmt)
	-- flat per-thread tape (see onWait): the loop detector must see through
	-- blocks that never closed (a `for` over a stand-in object left by `break`)
	for i = #STACK, 1, -1 do
		local rb = STACK[i]
		if rb.isRoot or i == 1 then
			rb.tape = rb.tape or {}
			R.insert(rb.tape, { stmt = stmt, block = b })
			break
		end
	end
	if #b.lines > MAX_BLOCK then
		R.insert(b.lines, { text = "-- [envlog] block truncated after " .. MAX_BLOCK .. " statements" })
		b.stopped = 0
		R.error(LOOP, 0)
	end
	return stmt
end

local function comment(s)
	return emit({ text = "-- " .. s })
end

---------------------------------------------------------------------------
-- proxies
---------------------------------------------------------------------------
local INFO = R.setmetatable({}, { __mode = "k" })
local BYID = {}
local nextId = 0
local PMT = {} -- shared metamethods, copied into each proxy's own metatable
local isMethodName, methodFn
local METHODP_REF

local function isP(v)
	return R.type(v) == "userdata" and INFO[v] ~= nil
end

local function newP(info)
	nextId += 1
	info.id = nextId
	info.children = {}
	info.props = {}
	local p = R.newproxy(true)
	local mt = R.getmetatable(p)
	for k, f in PMT do
		mt[k] = f
	end
	INFO[p] = info
	BYID[nextId] = p
	return p
end

local function tok(p)
	return "\1" .. INFO[p].id .. "\2"
end

local function isIdent(s)
	return R.type(s) == "string" and R.match(s, "^[%a_][%w_]*$") ~= nil and not ({
		["and"] = 1, ["break"] = 1, ["do"] = 1, ["else"] = 1, ["elseif"] = 1, ["end"] = 1,
		["false"] = 1, ["for"] = 1, ["function"] = 1, ["if"] = 1, ["in"] = 1, ["local"] = 1,
		["nil"] = 1, ["not"] = 1, ["or"] = 1, ["repeat"] = 1, ["return"] = 1, ["then"] = 1,
		["true"] = 1, ["until"] = 1, ["while"] = 1, ["continue"] = 1,
	})[s]
end

local function quote(s)
	local out = R.gsub(s, '[%c"\\\128-\255]', function(c)
		if c == "\n" then return "\\n" end
		if c == "\t" then return "\\t" end
		if c == "\r" then return "\\r" end
		if c == '"' then return '\\"' end
		if c == "\\" then return "\\\\" end
		local b = R.byte(c)
		if b >= 128 then return c end -- keep UTF-8 as-is
		return "\\" .. b
	end)
	return '"' .. out .. '"'
end

local function fmtNumber(n)
	if n ~= n then return "0/0" end
	if n == R.huge then return "math.huge" end
	if n == -R.huge then return "-math.huge" end
	if n == R.floor(n) and n > -1e15 and n < 1e15 then
		return R.fmt("%d", n)
	end
	local s = R.fmt("%.14g", n)
	if R.tonumber(s) ~= n then s = R.fmt("%.17g", n) end
	return s
end

local fmt -- forward
local genvTable -- forward
local GENVNAME = R.setmetatable({}, { __mode = "k" }) -- getgenv()-style table -> label
local captureFunction -- forward
local FNAME = R.setmetatable({}, { __mode = "k" }) -- native-looking function -> source text
local CFUNCS = R.setmetatable({}, { __mode = "k" }) -- functions that must pass as C closures
local CNAME = R.setmetatable({}, { __mode = "k" }) -- their debug.info "n" names
local THREADP = R.setmetatable({}, { __mode = "k" }) -- spawned thread -> proxy used when printing it

-- getfenv(cfunction) returns the calling thread's globals in Roblox, but our
-- stand-ins for C functions are Lua closures whose environment is the harness.
-- So each one is handed out as a trampoline without globals whose environment
-- is set to the script's globals once they exist (same source as the harness,
-- so stack views still collapse it).
local MKTRAMP = R.loadstring("local impl = ... return function(...) return impl(...) end", "=" .. HARNESS_SRC0)
local TRAMPS = {}
local TRAMP_ENV = nil
local function tramp(impl)
	local t = MKTRAMP(impl)
	if TRAMP_ENV then R.setfenv(t, TRAMP_ENV) else R.insert(TRAMPS, t) end
	return t
end

local function keySuffix(k)
	if isIdent(k) then
		return "." .. k
	end
	return "[" .. fmt(k) .. "]"
end

local ENV -- forward

function fmt(v, depth, seen)
	local t = R.type(v)
	if t == "nil" then return "nil" end
	if t == "boolean" then return R.tostring(v) end
	if t == "number" then return fmtNumber(v) end
	if t == "string" then return quote(v) end
	if t == "userdata" then
		if INFO[v] then return tok(v) end
		return "nil --[[userdata]]"
	end
	if t == "function" then
		if FNAME[v] then return FNAME[v] end
		if METHODP_REF and METHODP_REF[v] then return tok(METHODP_REF[v]) end
		return captureFunction(v)
	end
	if t == "table" then
		if v == ENV then return "getfenv()" end
		if GENVNAME[v] then return GENVNAME[v] end
		depth = depth or 0
		seen = seen or {}
		if seen[v] then return "{ --[[cycle]] }" end
		if depth > 6 then return "{ --[[...]] }" end
		seen[v] = true
		local parts = {}
		local n = 0
		for i = 1, 1e9 do
			local x = R.rawget(v, i)
			if x == nil then break end
			n = i
			R.insert(parts, fmt(x, depth + 1, seen))
		end
		local keys = {}
		for k in R.next, v do
			if not (R.type(k) == "number" and k >= 1 and k <= n and k % 1 == 0) then
				R.insert(keys, k)
			end
		end
		-- hash order is lost; use the order people write: title first, callbacks last
		local function rank(k)
			local x = R.rawget(v, k)
			if R.type(x) == "function" then return 4 end
			if k == "Title" or k == "Name" or k == "Text" then return 1 end
			if k == "Desc" or k == "Description" or k == "Content" then return 2 end
			return 3
		end
		R.sort(keys, function(a, b)
			local ta, tb = R.type(a), R.type(b)
			if ta ~= tb then return ta < tb end
			if ta == "string" then
				local ra, rb = rank(a), rank(b)
				if ra ~= rb then return ra < rb end
				return a < b
			end
			if ta == "number" then return a < b end
			return false
		end)
		for _, k in keys do
			local key = isIdent(k) and k or ("[" .. fmt(k, depth + 1, seen) .. "]")
			local x = R.rawget(v, k)
			-- UI library callbacks also get a run with `false` (see captureFunction)
			if k == "Callback" and R.type(x) == "function" then CFG._cbtry = true end
			R.insert(parts, key .. " = " .. fmt(x, depth + 1, seen))
			CFG._cbtry = nil
		end
		seen[v] = nil
		if #parts == 0 then return "{}" end
		local flat = "{ " .. R.concat(parts, ", ") .. " }"
		if #flat <= 100 and not R.find(flat, "\3", 1, true) then return flat end
		local ind = R.rep("\t", depth + 1)
		return "{\n" .. ind .. R.concat(parts, ",\n" .. ind) .. "\n" .. R.rep("\t", depth) .. "}"
	end
	if t == "vector" then
		return "Vector3.new(" .. fmtNumber(v.x) .. ", " .. fmtNumber(v.y) .. ", " .. fmtNumber(v.z) .. ")"
	end
	if t == "buffer" then return "buffer.create(" .. buffer.len(v) .. ")" end
	if t == "thread" and THREADP[v] then return tok(THREADP[v]) end
	return "nil --[[" .. t .. "]]"
end

local function fmtArgs(...)
	local n = R.select("#", ...)
	local parts = {}
	for i = 1, n do
		parts[i] = fmt((R.select(i, ...)))
	end
	return R.concat(parts, ", ")
end

-- proxy constructors ------------------------------------------------------
local function globalP(name, tname)
	return newP({ kind = "name", name = name, tname = tname or "Instance" })
end

local function exprP(text, tname, hint)
	return newP({ kind = "expr", text = text, tname = tname or "Instance", hint = hint })
end

---------------------------------------------------------------------------
-- Roblox API data (gen_roblox.py): enums with values and, per class, which
-- names are methods, events and properties
---------------------------------------------------------------------------
local API = { enums = {}, classes = {} }
do
	local src = __ROBLOX or { enums = "", classes = "" }
	for ename, items in string.gmatch(src.enums, "([%w_]+):([^;]*)") do
		local e = { name = ename, items = {}, byName = {}, byValue = {} }
		for iname, v in string.gmatch(items, "([%w_]+)=(%-?%d+)") do
			local item = { Name = iname, Value = R.tonumber(v) }
			R.insert(e.items, item)
			e.byName[iname] = item
			if e.byValue[item.Value] == nil then e.byValue[item.Value] = item end
		end
		API.enums[ename] = e
	end
	for cname, super, fns, evs, props in string.gmatch(src.classes, "([%w_]+)<([%w_]*)|([^|]*)|([^|]*)|([^;]*)") do
		local c = { super = super ~= "" and super or nil, m = {}, e = {}, p = {} }
		for x in string.gmatch(fns, "[^,]+") do c.m[x] = true end
		for x in string.gmatch(evs, "[^,]+") do c.e[x] = true end
		for x in string.gmatch(props, "[^,]+") do
			local name, vt = R.match(x, "^([^:]+):?(.*)$")
			c.p[name] = vt ~= "" and vt or true
		end
		API.classes[cname] = c
	end
end

local function memberKind(cls, k)
	local guard = 0
	while cls and guard < 32 do
		guard += 1
		local c = API.classes[cls]
		if not c then return nil end
		if c.m[k] then return "method" end
		if c.e[k] then return "event" end
		if c.p[k] then return "prop" end
		cls = c.super
	end
	return nil
end

-- value type of a property ("float", "Vector3", ...) or nil
local function propType(cls, k)
	local guard = 0
	while cls and guard < 32 do
		guard += 1
		local c = API.classes[cls]
		if not c then return nil end
		local v = c.p[k]
		if v then return v ~= true and v or nil end
		cls = c.super
	end
	return nil
end

-- Unknown values must still behave like their type: Luau refuses to compare
-- a userdata with a number before looking at metamethods, so numeric
-- properties and datatype components are plain numbers (plausible defaults).
local NUMERIC_T = { float = true, double = true, int = true, int64 = true, int32 = true, int16 = true, number = true }
local NUM_DEFAULT = { Health = 100, MaxHealth = 100, WalkSpeed = 16, JumpPower = 50, JumpHeight = 7.2,
	HipHeight = 2, Gravity = 196.2, FieldOfView = 70, MaxSlopeAngle = 89, TimePosition = 0, Volume = 0.5,
	TimeLength = 1, Speed = 1, Brightness = 1, Range = 16, Size = 1 }
local DT_MEMBERS = {
	Vector3 = { X = "n", Y = "n", Z = "n", Magnitude = "n", Unit = "Vector3" },
	Vector2 = { X = "n", Y = "n", Magnitude = "n", Unit = "Vector2" },
	CFrame = { X = "n", Y = "n", Z = "n", Position = "Vector3", p = "Vector3", LookVector = "Vector3",
		RightVector = "Vector3", UpVector = "Vector3", XVector = "Vector3", YVector = "Vector3", ZVector = "Vector3",
		Rotation = "CFrame" },
	UDim2 = { X = "UDim", Y = "UDim", Width = "UDim", Height = "UDim" },
	UDim = { Scale = "n", Offset = "n" },
	Color3 = { R = "n", G = "n", B = "n" },
	NumberRange = { Min = "n", Max = "n" },
	Rect = { Width = "n", Height = "n", Min = "Vector2", Max = "Vector2" },
}

-- class of well-known properties / child names
local PROP_CLASS = {
	LocalPlayer = "Player", Character = "Model", CurrentCamera = "Camera", PlayerGui = "PlayerGui",
	Backpack = "Backpack", PrimaryPart = "Part", HumanoidRootPart = "Part", Head = "Part", Torso = "Part",
	UpperTorso = "MeshPart", LowerTorso = "MeshPart", PlayerScripts = "PlayerScripts", Terrain = "Terrain",
	leaderstats = "Folder", Animator = "Animator",
}

local function childClass(pi, key)
	if R.type(key) ~= "string" then return nil end
	if PROP_CLASS[key] then return PROP_CLASS[key] end
	if pi.className and memberKind(pi.className, key) == "prop" then return nil end
	if API.classes[key] and not API.enums[key] then return key end
	return nil
end

local function indexP(parent, key)
	local pi = INFO[parent]
	local c = pi.children[key]
	if c then return c end
	c = newP({ kind = "index", parent = parent, key = key,
		tname = pi.childT or "Instance",
		hint = R.type(key) == "string" and key or nil, ns = pi.ns,
		className = pi.tname == "Instance" and childClass(pi, key) or nil })
	pi.children[key] = c
	return c
end

-- Enum / EnumType / EnumItem objects with the real names and values
local enumRoot -- set once E.Enum exists
local function enumType(name)
	local c = INFO[enumRoot].children[name]
	if c then return c end
	c = indexP(enumRoot, name)
	INFO[c].tname = "Enum"
	INFO[c].enumName = name
	INFO[c].className = nil
	return c
end
local function enumItem(ename, iname)
	local et = enumType(ename)
	local c = INFO[et].children[iname]
	if c then return c end
	local item = API.enums[ename].byName[iname]
	c = indexP(et, iname)
	local info = INFO[c]
	info.tname = "EnumItem"
	info.enumName = ename
	info.className = nil
	info.props.Name = iname
	info.props.Value = item.Value
	info.props.EnumType = et
	return c
end

---------------------------------------------------------------------------
-- native twins (NATIVE only): proxy -> real engine value. Only pure objects
-- get one (datatypes, GUI instances, Path2D); services, remotes and the rest
-- of the game stay fake, so the script cannot reach the real place.
---------------------------------------------------------------------------
local REALV = R.setmetatable({}, { __mode = "k" })
-- raised by a datatypes.luau model for what it doesn't cover (stay symbolic)
CHAIN.DT_UNSUPPORTED = __ROBLOX and __ROBLOX.datatypes and __ROBLOX.datatypes.UNSUPPORTED
local NOREAL = R.setmetatable({}, { __tostring = function() return "<envlog: no native twin>" end })

local function unwrap(v, depth)
	if isP(v) then
		local r = REALV[v]
		if r == nil then R.error(NOREAL, 0) end
		return r
	elseif R.type(v) == "table" and depth < 3 then
		local t = {}
		for k, x in R.pairs(v) do t[unwrap(k, depth + 1)] = unwrap(x, depth + 1) end
		return t
	elseif R.type(v) == "function" or R.type(v) == "thread" then
		R.error(NOREAL, 0) -- never hand script functions to the engine
	end
	return v
end
-- packed args -> packed real args, or nil if something has no twin
local function unwrapArgs(args)
	local ok, out = R.pcall(function()
		local o = { n = args.n }
		for i = 1, args.n do o[i] = unwrap(args[i], 0) end
		return o
	end)
	if ok then return out end
	if out ~= NOREAL then R.error(out, 0) end
	return nil
end
-- is `v` (proxy or plain value) available as a real value?
local function realOf(v)
	if isP(v) then return REALV[v], REALV[v] ~= nil end
	if R.type(v) == "table" or R.type(v) == "function" then return nil, false end
	return v, true
end

local PLAIN_T = { number = true, string = true, boolean = true, ["nil"] = true, vector = true }
local function nativeClass(inst)
	return inst:IsA("GuiBase") or inst:IsA("UIBase")
end
-- turn a real engine value into what the script should see; `text` is the
-- source expression that produced it. Returns (value, true) or (nil, false)
-- when the value cannot be represented (the caller falls back to a proxy).
local function wrapReal(r, text, hint, depth)
	local t = R.type(r)
	if PLAIN_T[t] then return r, true end
	local tt = R.typeof(r)
	if tt == "userdata" and not NATIVE then tt = __ROBLOX.datatypes.typeOf(r) or tt end
	if tt == "EnumItem" then
		local ename = R.tostring(r.EnumType)
		if API.enums[ename] and API.enums[ename].byName[r.Name] then return enumItem(ename, r.Name), true end
		return nil, false
	end
	if tt == "Instance" or tt == "RBXScriptSignal" or tt == "RBXScriptConnection" or t == "function" or t == "thread" then
		return nil, false
	end
	if t == "table" then
		if (depth or 0) > 2 then return nil, false end
		local out = {}
		for k, x in R.pairs(r) do
			local w, ok = wrapReal(x, text .. "[" .. fmt(k) .. "]", hint, (depth or 0) + 1)
			if not ok then return nil, false end
			out[k] = w
		end
		return out, true
	end
	local p = exprP(text, tt, hint)
	REALV[p] = r
	return p, true
end
-- give a freshly made datatype proxy its twin: lib[k](...) or lib[k]
-- (offline: a datatypes.luau model value, when that type has a model)
local function attachReal(p, libName, k, call, ...)
	local lib
	if NATIVE then
		lib = REAL_G[libName]
	else
		lib = __ROBLOX and __ROBLOX.datatypes and __ROBLOX.datatypes[libName]
		if R.type(lib) ~= "table" then return end
	end
	if lib == nil then return end
	local u = unwrapArgs(table.pack(...))
	if not u then return end
	local ok, r = R.pcall(function()
		local f = lib[k]
		if call then return f(R.unpack(u, 1, u.n)) end
		return f
	end)
	if ok and r ~= nil and R.type(r) ~= "table" then REALV[p] = r end
end

---------------------------------------------------------------------------
-- Path2D replay cache: a Studio run records what the engine answered for
-- every Path2D method call; offline runs replay those answers (__P2D).
---------------------------------------------------------------------------
local P2D_LOG = {}
local P2D_MISS = false -- offline run needed a Path2D answer nobody recorded
local function p2dKey(name, args)
	local parts = { name }
	for i = 1, args.n do
		local a = args[i]
		parts[#parts + 1] = R.type(a) == "number" and R.fmt("%.17g", a) or R.tostring(R.typeof(a))
	end
	return R.concat(parts, "|")
end
local function p2dEncode(v)
	local t = R.typeof(v)
	if t == "number" then return R.fmt("n:%.17g", v) end
	if t == "UDim2" then return R.fmt("u:%.17g,%.17g,%.17g,%.17g", v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset) end
	if t == "Vector2" then return R.fmt("v:%.17g,%.17g", v.X, v.Y) end
	if t == "nil" then return "z:" end
	return nil
end
local function p2dDecode(str, text)
	local kind, rest = R.match(str, "^(%a):(.*)$")
	if kind == "n" then return R.tonumber(rest) end
	if kind == "z" then return nil end
	local nums = {}
	for x in string.gmatch(rest, "[^,]+") do nums[#nums + 1] = R.tonumber(x) end
	if kind == "u" then
		local p = exprP(text, "UDim2", "position")
		local xs = exprP(text .. ".X", "UDim", "X")
		INFO[xs].props.Scale, INFO[xs].props.Offset = nums[1], nums[2]
		local ys = exprP(text .. ".Y", "UDim", "Y")
		INFO[ys].props.Scale, INFO[ys].props.Offset = nums[3], nums[4]
		INFO[p].props.X, INFO[p].props.Y = xs, ys
		INFO[p].props.Width, INFO[p].props.Height = xs, ys
		return p
	end
	if kind == "v" then
		local p = exprP(text, "Vector2", "vector")
		INFO[p].props.X, INFO[p].props.Y = nums[1], nums[2]
		INFO[p].props.Magnitude = math.sqrt(nums[1] * nums[1] + nums[2] * nums[2])
		return p
	end
	return nil
end

-- a call whose result gets a local only if the result is used later
local function callP(text, hint, tname, force)
	local p = newP({ kind = "call", tname = tname or "Instance", hint = hint })
	local st = emit({ call = text, res = p })
	INFO[p].stmt = st
	if force then INFO[p].forceVar = true end
	return p
end

---------------------------------------------------------------------------
-- callback capture
---------------------------------------------------------------------------
local FUNCS = {} -- function -> fid
local FREC = {} -- fid -> { params, block }
local nextFid = 0
local captureDepth = 0
local paramCounter = {}

local function paramName(base)
	paramCounter[base] = (paramCounter[base] or 0) + 1
	local n = paramCounter[base]
	return n == 1 and base or (base .. n)
end

local popTo -- forward

local lastThread = nil

-- Callbacks (task.spawn, event handlers, ...) run in a thread of their own, as
-- they do in Roblox; Luraph checks this by closing a thread it captured with
-- coroutine.running() inside a spawned function.
local function runInBlock(block, fn, ...)
	block.isRoot = true
	R.insert(STACK, block)
	local level = #STACK
	captureDepth += 1
	local th = R.type(fn) == "thread" and fn or coroutine.create(fn)
	lastThread = th
	local res = table.pack(coroutine.resume(th, ...))
	if res[1] and res[2] == ABORT and coroutine.status(th) == "suspended" then res = { false, ABORT, n = 2 } end
	captureDepth -= 1
	popTo(level - 1)
	if not res[1] then
		local err = res[2]
		if err == ABORT then
			R.insert(block.lines, { text = "-- [envlog] trace budget ran out here: " .. R.tostring(ABORT_REASON) })
			R.error(ABORT, 0)
		elseif err == TAMPER then
			if CFG.debug_tamper then R.print("[tamper-in-block]", debug.traceback()) end
			R.insert(block.lines, { text = "-- [envlog] Luraph integrity-check thread (anti-tamper) suppressed here" })
		elseif err ~= LOOP then
			R.insert(block.lines, { text = "-- [envlog] error: " .. R.gsub(R.tostring(err), "\n", " ") })
		end
	end
	return res
end

-- Runs `fn` with fresh parameter proxies and returns a token standing for
-- `function(params) <recorded body> end`.
local DEFERRED = {}
-- event handlers: recorded after the main script, never while it runs (Luraph
-- connects tamper responses to signals that must not fire, e.g.
-- game.DescendantRemoving; running those early looks like tampering)
local HANDLERS = {}

function captureFunction(fn, names, args, defer)
	local fid = FUNCS[fn]
	if fid and not defer then return "\3" .. fid .. "\4" end
	nextFid += 1
	fid = nextFid
	FUNCS[fn] = fid
	local rec = { params = {}, block = { lines = {}, waits = {} } }
	FREC[fid] = rec
	if captureDepth >= MAX_DEPTH then
		R.insert(rec.block.lines, { text = "-- [envlog] nesting too deep" })
		return "\3" .. fid .. "\4"
	end
	local callArgs = {}
	if args then
		callArgs = args
		rec.params = { "..." }
	else
		names = names or { "...", "..." }
		local vararg = names[1] == "..."
		for i, nm in names do
			local pn = vararg and paramName("arg") or paramName(nm)
			rec.params[i] = pn
			callArgs[i] = newP({ kind = "name", gen = true, name = pn, tname = "Instance" })
		end
	end
	if defer == "handler" then
		R.insert(HANDLERS, { rec = rec, fn = fn, args = callArgs, n = args and args.n or #callArgs })
		return "\3" .. fid .. "\4"
	end
	if defer then
		-- task.delay / task.defer: the thread exists now but only runs after the
		-- main script, and only if nothing cancelled it in the meantime
		local th = coroutine.create(fn)
		lastThread = th
		R.insert(DEFERRED, { rec = rec, thread = th, args = callArgs, n = args and args.n or #callArgs, due = defer })
		return "\3" .. fid .. "\4"
	end
	local tryAlt = CFG._cbtry and not args
	CFG._cbtry = nil
	local res = runInBlock(rec.block, fn, R.unpack(callArgs, 1, args and args.n or #callArgs))
	-- a UI callback (Toggle etc.) ran with a truthy stand-in; run it again with
	-- `false` so the "off" path is recorded too. Kept only if that run finishes
	-- cleanly (sliders, dropdowns ... fail on a boolean and are left as they were).
	if tryAlt and res[1] and #callArgs >= 1 then
		local alt = { lines = {}, waits = {} }
		local r2 = runInBlock(alt, fn, false, R.unpack(callArgs, 2, #callArgs))
		local clean = r2[1]
		for _, s in alt.lines do
			if s.text and R.find(s.text, "-- [envlog]", 1, true) then clean = false end
		end
		if clean then
			rec.alt = alt
			local pn = "state" -- each callback is its own scope
			INFO[callArgs[1]].name = pn
			rec.params[1] = pn
		end
	end
	return "\3" .. fid .. "\4"
end

local function runHandlers()
	local i = 1
	while i <= #HANDLERS do
		local h = HANDLERS[i]
		i += 1
		popTo(1)
		local ok, err = R.pcall(runInBlock, h.rec.block, h.fn, R.unpack(h.args, 1, h.n))
		if not ok and err == ABORT then return end
	end
end

local function runDeferred()
	while #DEFERRED > 0 do
		table.sort(DEFERRED, function(a, b) return a.due < b.due end)
		local d = R.remove(DEFERRED, 1)
		if coroutine.status(d.thread) == "suspended" then
			local ok, err = R.pcall(runInBlock, d.rec.block, d.thread, R.unpack(d.args, 1, d.n))
			if not ok and err == ABORT then return end
		else
			R.insert(d.rec.block.lines, { text = "-- [envlog] cancelled before it ran" })
		end
	end
end

---------------------------------------------------------------------------
-- open-ended blocks (for ... in pairs(proxy) do)
---------------------------------------------------------------------------
function popTo(level)
	while #STACK > level do
		local b = STACK[#STACK]
		STACK[#STACK] = nil
		if b.onClose then b.onClose() end
	end
end

local function iterProxy(p, how)
	local state = 0
	local kp, vp
	return function()
		state += 1
		if state == 1 then
			local b = { lines = {}, waits = {} }
			kp = newP({ kind = "name", gen = true, name = paramName(how == "ipairs" and "i" or "k"), tname = "number" })
			vp = newP({ kind = "name", gen = true, name = paramName("v"), tname = "Instance" })
			local header = "for " .. tok(kp) .. ", " .. tok(vp) .. " in " ..
				(how and (how .. "(" .. tok(p) .. ")") or tok(p)) .. " do"
			emit({ header = header, block = b })
			R.insert(STACK, b)
			b.level = #STACK
			return kp, vp
		end
		-- second call: the loop body ran once, close the block
		for i = #STACK, 1, -1 do
			if STACK[i].level == i and STACK[i].header == nil then
				-- find our block
			end
		end
		popTo(#STACK - 1)
		return nil
	end
end

---------------------------------------------------------------------------
-- loop detection for wait()
---------------------------------------------------------------------------
local function normalize(block, from, to, baseId, baseFid)
	local parts = {}
	for i = from, to do
		local s = block.lines[i]
		local text = s.text or s.call or s.header or ""
		text = R.gsub(text, "\1(%d+)\2", function(id)
			id = R.tonumber(id)
			return id >= baseId and ("\1r" .. (id - baseId) .. "\2") or nil
		end)
		text = R.gsub(text, "\3(%d+)\4", function(id)
			id = R.tonumber(id)
			return id >= baseFid and ("\3r" .. (id - baseFid) .. "\4") or nil
		end)
		parts[#parts + 1] = text
	end
	return R.concat(parts, "\n")
end

local function onWait()
	local b = curBlock()
	local w = b.waits
	R.insert(w, { line = #b.lines, id = nextId, fid = nextFid })
	local n = #w
	if n >= 3 then
		local a, m, c = w[n - 2], w[n - 1], w[n]
		if c.line - m.line == m.line - a.line then
			local s1 = normalize(b, a.line + 1, m.line, a.id, a.fid)
			local s2 = normalize(b, m.line + 1, c.line, m.id, m.fid)
			if s1 == s2 then
				for _ = m.line + 1, c.line do
					R.remove(b.lines)
				end
				R.insert(b.lines, { text = "-- [envlog] the statements above repeat forever (loop)" })
				b.stopped = 0
				R.error(LOOP, 0)
			end
		end
	end
	-- the same, on the thread's flat statement tape: catches loops whose
	-- repetitions end up nested in blocks that were never closed
	local root, rootLevel = nil, 1
	for i = #STACK, 1, -1 do
		if STACK[i].isRoot or i == 1 then root, rootLevel = STACK[i], i; break end
	end
	root.tape = root.tape or {}
	root.marks = root.marks or {}
	local marks = root.marks
	R.insert(marks, { pos = #root.tape, id = nextId, fid = nextFid, depth = #STACK, block = b })
	local nm = #marks
	if nm >= 3 then
		local m1, m2, m3 = marks[nm - 2], marks[nm - 1], marks[nm]
		local k = m2.pos - m1.pos
		if CFG.debug_loops then R.print("[loop marks]", m1.pos, m2.pos, m3.pos, m1.depth, m2.depth, m3.depth) end
		if k > 0 and m3.pos - m2.pos == k and m3.depth > m2.depth then
			local function seg(from, to, baseId, baseFid)
				-- proxies: named/indexed ones by their path (stable across
				-- repetitions even when first created in the first one), call
				-- results by order of appearance
				local order, n = {}, 0
				local function path(q, d)
					local qi = q and INFO[q]
					if not qi or d > 12 then return "?" end
					if qi.kind == "name" and not qi.gen then return qi.name or "?" end
					if qi.kind == "index" and qi.parent then return path(qi.parent, d + 1) .. "." .. R.tostring(qi.key) end
					if not order[q] then n += 1; order[q] = n end
					return "#" .. order[q]
				end
				local parts = {}
				for i = from, to do
					local st = root.tape[i].stmt
					local text = st.text or st.call or st.header or ""
					if st.res and isP(st.res) then text = text .. " ->" .. path(st.res, 0) end
					text = R.gsub(text, "\1(%d+)\2", function(id)
						return "\1" .. path(BYID[R.tonumber(id)], 0) .. "\2"
					end)
					text = R.gsub(text, "\3(%d+)\4", function(id)
						id = R.tonumber(id)
						return id >= baseFid and ("\3r" .. (id - baseFid) .. "\4") or nil
					end)
					parts[#parts + 1] = text
				end
				return R.concat(parts, "\n")
			end
			local sA, sB = seg(m1.pos + 1, m2.pos, m1.id, m1.fid), seg(m2.pos + 1, m3.pos, m2.id, m2.fid)
			if CFG.debug_loops and sA ~= sB then R.print("[loop A]\n" .. sA .. "\n[loop B]\n" .. sB) end
			if sA == sB then
				-- drop the second repetition (newest first: each is the last line of its block)
				for i = m3.pos, m2.pos + 1, -1 do
					local e = root.tape[i]
					if e.block.lines[#e.block.lines] == e.stmt then R.remove(e.block.lines) end
					root.tape[i] = nil
				end
				-- close whatever the first repetition left open
				popTo(m1.depth)
				local home = curBlock()
				-- the wait that ended the first repetition belongs after those blocks
				local w = root.tape[m2.pos]
				if w and w.block ~= home and w.block.lines[#w.block.lines] == w.stmt then
					R.remove(w.block.lines)
					R.insert(home.lines, w.stmt)
				end
				R.insert(home.lines, { text = "-- [envlog] the statements above repeat forever (loop)" })
				home.stopped = 0
				R.error(LOOP, 0)
			end
		end
	end
	if n > MAX_WAITS then
		R.insert(b.lines, { text = "-- [envlog] stopped after " .. MAX_WAITS .. " waits" })
		b.stopped = 0
		R.error(LOOP, 0)
	end
end

---------------------------------------------------------------------------
-- known API behaviour
---------------------------------------------------------------------------
local DATATYPES = {
	Vector3 = 1, Vector2 = 1, Vector3int16 = 1, Vector2int16 = 1, CFrame = 1, Color3 = 1,
	UDim = 1, UDim2 = 1, BrickColor = 1, TweenInfo = 1, NumberRange = 1, NumberSequence = 1,
	NumberSequenceKeypoint = 1, ColorSequence = 1, ColorSequenceKeypoint = 1, Ray = 1,
	Rect = 1, Region3 = 1, Region3int16 = 1, PhysicalProperties = 1, Font = 1,
	DateTime = 1, Axes = 1, Faces = 1, PathWaypoint = 1, SharedTable = 1, OverlapParams = 1,
	RaycastParams = 1, CatalogSearchParams = 1, DockWidgetPluginGuiInfo = 1, Path2DControlPoint = 1,
	Content = 1, SecurityCapabilities = 1, FloatCurveKey = 1, RotationCurveKey = 1, ValueCurveKey = 1,
	CFrameCurveKey = 1, UniqueId = 1,
}

local SIGNAL_PARAMS = {
	PlayerAdded = { "player" }, PlayerRemoving = { "player" },
	CharacterAdded = { "character" }, CharacterRemoving = { "character" }, CharacterAppearanceLoaded = { "character" },
	Touched = { "hit" }, TouchEnded = { "hit" },
	InputBegan = { "input", "gameProcessed" }, InputEnded = { "input", "gameProcessed" },
	InputChanged = { "input", "gameProcessed" },
	Heartbeat = { "deltaTime" }, RenderStepped = { "deltaTime" }, PreSimulation = { "deltaTime" },
	PostSimulation = { "deltaTime" }, PreRender = { "deltaTime" }, Stepped = { "time", "deltaTime" },
	ChildAdded = { "child" }, ChildRemoved = { "child" },
	DescendantAdded = { "descendant" }, DescendantRemoving = { "descendant" },
	Changed = { "value" }, HealthChanged = { "health" }, Chatted = { "message" },
	FocusLost = { "enterPressed", "inputObject" }, Triggered = { "player" },
	PromptTriggered = { "prompt", "player" }, PromptButtonHoldBegan = { "prompt", "player" },
	Idled = { "idleTime" }, MouseButton1Click = {}, MouseButton1Down = { "x", "y" },
	Activated = { "inputObject", "clickCount" }, Died = {}, Event = { "..." },
	OnClientEvent = { "..." }, OnClientInvoke = { "..." }, OnInvoke = { "..." },
	AncestryChanged = { "child", "parent" }, AttributeChanged = { "attribute" },
	StateChanged = { "old", "new" }, MoveToFinished = { "reached" }, Completed = { "playbackState" },
}

local CLASS_HINT = {
	GetChildren = "children", GetDescendants = "descendants", GetPlayers = "players",
	GetTouchingParts = "parts", GetPartsInPart = "parts", GetPartBoundsInBox = "parts",
	GetPartBoundsInRadius = "parts", GetTagged = "tagged", GetAttributes = "attributes",
	GetPlayingAnimationTracks = "tracks", GetConnectedParts = "parts", GetJoints = "joints",
	GetChildrenOfClass = "children",
}
-- names for results of other well-known methods (rendering only)
for k, v in {
	JSONEncode = "json", JSONDecode = "data", HttpGet = "response", HttpGetAsync = "response",
	GetAsync = "response", PostAsync = "response", RequestAsync = "response",
	Inverse = "inverse", ToWorldSpace = "cframe", ToObjectSpace = "cframe",
	Raycast = "raycastResult", GetMouse = "mouse", LoadAnimation = "track",
	InvokeServer = "response", Clone = "clone",
	GetPropertyChangedSignal = "changedSignal", GetAttribute = "attribute",
	GenerateGUID = "guid", UrlEncode = "encoded", Notify = "notification",
} do
	CLASS_HINT[k] = v
end
-- UI library objects: Window:Tab() -> Tab, Tab:Toggle() -> Toggle
for _, n in { "Window", "Tab", "Section", "Toggle", "Button", "Slider", "Dropdown", "Input",
	"Keybind", "Colorpicker", "Paragraph", "Dialog", "Label", "Textbox", "Divider", "Popup",
	"Code", "Group", "Page", "Category", "Checkbox", "ColorPicker", "TextBox" } do
	CLASS_HINT[n] = n
end

local serviceCache = {}
local GAMEP -- the game proxy (set once it exists)
local WORKSPACEP -- the workspace proxy
local urls = {}
local remotes = {}

local function methodName(info)
	if info.kind == "index" and R.type(info.key) == "string" then return info.key end
	return nil
end

local function remember(list, v)
	if not list[v] then
		list[v] = true
		R.insert(list, v)
	end
end

-- invoked for every call of a proxy
-- A small model of the instance tree for objects the script creates itself,
-- so FindFirstChild/GetChildren/Destroy behave like Roblox for them.
local function instName(p)
	local v = INFO[p].props.Name
	if R.type(v) == "string" then return v end
	return INFO[p].className or "Instance"
end
local function kidsOf(p)
	local info = INFO[p]
	info.kids = info.kids or {}
	return info.kids
end
local function setParent(child, parent)
	local ci = INFO[child]
	local old = ci.props.Parent
	if isP(old) then
		local list = kidsOf(old)
		for i = #list, 1, -1 do
			if list[i] == child then R.remove(list, i) end
		end
	end
	if isP(parent) then R.insert(kidsOf(parent), child) end
	ci.props.Parent = parent
	local rc = REALV[child]
	if rc ~= nil and R.typeof(rc) == "Instance" then
		local rp = isP(parent) and REALV[parent] or nil
		R.pcall(function() rc.Parent = (R.typeof(rp) == "Instance") and rp or nil end)
	end
end
local function findKid(p, name, recursive)
	for _, c in kidsOf(p) do
		if instName(c) == name then return c end
	end
	if recursive then
		for _, c in kidsOf(p) do
			local r = findKid(c, name, true)
			if r then return r end
		end
	end
	return nil
end
local function descendants(p, out)
	for _, c in kidsOf(p) do
		R.insert(out, c)
		descendants(c, out)
	end
	return out
end
local function destroyInst(p)
	local info = INFO[p]
	if info.destroyed then return end
	for _, c in table.clone(kidsOf(p)) do destroyInst(c) end
	if isP(info.props.Parent) then setParent(p, nil) end
	info.props.Parent = nil
	info.destroyed = true
	local r = REALV[p]
	if r ~= nil and R.typeof(r) == "Instance" then R.pcall(r.Destroy, r) end
end
local RUNSERVICE_BOOL = { IsStudio = false, IsServer = false, IsClient = true, IsRunning = true,
	IsRunMode = false, IsEdit = false }

local NO_NATIVE_METHOD = { Clone = 1, Destroy = 1, Remove = 1, GetChildren = 1, GetDescendants = 1,
	FindFirstChild = 1, WaitForChild = 1, FindFirstChildOfClass = 1, FindFirstChildWhichIsA = 1,
	FindFirstAncestor = 1, FindFirstAncestorOfClass = 1, FindFirstAncestorWhichIsA = 1, FindFirstDescendant = 1,
	ClearAllChildren = 1, IsA = 1, Connect = 1, Once = 1, Wait = 1, GetPropertyChangedSignal = 1,
	GetAttributeChangedSignal = 1, IsDescendantOf = 1, IsAncestorOf = 1, GetFullName = 1 }
---------------------------------------------------------------------------
-- Offline Path2D model (bit-exact float32 reproduction of the engine; see
-- research/path2d/README.md). Used when no recorded answer exists.
--   points: pixel = f32(f32(scale*W) + offset) in the parent Frame's size;
--   segment i: P0, [P0+right_i], [P3+left_{i+1}], P3 (handles that are 0 px
--   are left out: cubic / quadratic / linear); power basis, Horner in f32.
--   GetLength: per segment, adaptive bisection in t: chord a, half chords
--   b = |p0-pm| + |pm-p1|; b - a < 1e-5 -> b, else recurse; summed as a
--   tree; segment lengths summed in order.
--   ArcLength variants: s = f32(t*L), segment by cumulative lengths (first
--   with s <= end), local u = s'/len for lines. Curves: CHAIN.p2d.arcU.
---------------------------------------------------------------------------
do
	local FB = buffer.create(4)
	local function f32(x)
		buffer.writef32(FB, 0, x)
		return buffer.readf32(FB, 0)
	end
	local M = {}
	CHAIN.p2d = M
	M.f32 = f32

	local function num(x)
		if R.type(x) == "number" then return x end
		return 0
	end
	-- UDim2 proxy -> {sx, ox, sy, oy}
	function M.udim2(p)
		if not isP(p) then return nil end
		local inf = INFO[p]
		local c = inf.ctor
		if c and c.ns == "UDim2" then
			local a = c.args
			if c.fn == "new" then
				if isP(a[1]) or isP(a[2]) then
					local x, y = INFO[a[1]] and INFO[a[1]].ctor, INFO[a[2]] and INFO[a[2]].ctor
					return { x and num(x.args[1]) or 0, x and num(x.args[2]) or 0, y and num(y.args[1]) or 0,
						y and num(y.args[2]) or 0 }
				end
				return { num(a[1]), num(a[2]), num(a[3]), num(a[4]) }
			elseif c.fn == "fromScale" then
				return { num(a[1]), 0, num(a[2]), 0 }
			elseif c.fn == "fromOffset" then
				return { 0, num(a[1]), 0, num(a[2]) }
			end
			return nil
		end
		local X, Y = inf.props and inf.props.X, inf.props and inf.props.Y
		if isP(X) and isP(Y) then
			local xp, yp = INFO[X].props, INFO[Y].props
			return { num(xp.Scale), num(xp.Offset), num(yp.Scale), num(yp.Offset) }
		end
		return nil
	end
	-- the Frame a Path2D sits in: absolute size from offset-only sizes
	function M.frameSize(path)
		local parent = INFO[path].props and INFO[path].props.Parent
		if not isP(parent) then return nil end
		local sz = INFO[parent].props and INFO[parent].props.Size
		local u = sz and M.udim2(sz)
		if not u then return nil end
		if u[1] ~= 0 or u[3] ~= 0 then return nil end -- would need the viewport size
		return u[2], u[4]
	end
	local function resolve(u, W, H)
		return f32(f32(u[1] * W) + u[2]), f32(f32(u[3] * H) + u[4])
	end
	-- control point proxies -> list of segments {x0,y0, x1,y1, ...} (pixels)
	function M.segments(cps, W, H)
		local pts = {}
		for i, cp in R.ipairs(cps) do
			local c = isP(cp) and INFO[cp].ctor
			if not c or c.ns ~= "Path2DControlPoint" then return nil end
			local zero = { 0, 0, 0, 0 }
			local pos = c.args.n >= 1 and M.udim2(c.args[1]) or zero
			local left = c.args.n >= 2 and M.udim2(c.args[2]) or zero
			local right = c.args.n >= 3 and M.udim2(c.args[3]) or zero
			if not pos or not left or not right then return nil end
			local px, py = resolve(pos, W, H)
			local lx, ly = resolve(left, W, H)
			local rx, ry = resolve(right, W, H)
			pts[i] = { px, py, lx, ly, rx, ry }
		end
		local segs = {}
		for i = 1, #pts - 1 do
			local a, b = pts[i], pts[i + 1]
			local s = { a[1], a[2] }
			if a[5] ~= 0 or a[6] ~= 0 then
				R.insert(s, f32(a[1] + a[5])); R.insert(s, f32(a[2] + a[6]))
			end
			if b[3] ~= 0 or b[4] ~= 0 then
				R.insert(s, f32(b[1] + b[3])); R.insert(s, f32(b[2] + b[4]))
			end
			R.insert(s, b[1]); R.insert(s, b[2])
			segs[i] = M.coeffs(s)
		end
		return segs
	end
	-- power basis coefficients (f32, same association as the engine)
	function M.coeffs(s)
		local n = #s // 2
		local x0, y0 = s[1], s[2]
		local c = { n = n, x0 = x0, y0 = y0 }
		if n == 2 then
			c.c1x, c.c1y = f32(s[3] - x0), f32(s[4] - y0)
		elseif n == 3 then
			local x1, y1, x2, y2 = s[3], s[4], s[5], s[6]
			c.c1x, c.c1y = f32(f32(x1 - x0) * 2), f32(f32(y1 - y0) * 2)
			c.c2x, c.c2y = f32(f32(x0 - f32(x1 * 2)) + x2), f32(f32(y0 - f32(y1 * 2)) + y2)
		else
			local x1, y1, x2, y2, x3, y3 = s[3], s[4], s[5], s[6], s[7], s[8]
			c.c1x, c.c1y = f32(f32(x1 - x0) * 3), f32(f32(y1 - y0) * 3)
			c.c2x = f32(f32(f32(x0 - f32(x1 * 2)) + x2) * 3)
			c.c2y = f32(f32(f32(y0 - f32(y1 * 2)) + y2) * 3)
			c.c3x = f32(f32(f32(x3 - x0) + f32(x1 * 3)) - f32(x2 * 3))
			c.c3y = f32(f32(f32(y3 - y0) + f32(y1 * 3)) - f32(y2 * 3))
		end
		return c
	end
	function M.eval(c, u)
		if c.n == 2 then
			return f32(c.x0 + f32(c.c1x * u)), f32(c.y0 + f32(c.c1y * u))
		elseif c.n == 3 then
			return f32(c.x0 + f32(f32(c.c1x + f32(c.c2x * u)) * u)), f32(c.y0 + f32(f32(c.c1y + f32(c.c2y * u)) * u))
		end
		local ix, iy = f32(c.c2x + f32(c.c3x * u)), f32(c.c2y + f32(c.c3y * u))
		return f32(c.x0 + f32(f32(c.c1x + f32(ix * u)) * u)), f32(c.y0 + f32(f32(c.c1y + f32(iy * u)) * u))
	end
	function M.tangent(c, u)
		if c.n == 2 then return c.c1x, c.c1y end
		if c.n == 3 then
			local k = f32(u * 2)
			return f32(c.c1x + f32(c.c2x * k)), f32(c.c1y + f32(c.c2y * k))
		end
		local k = f32(3 * u)
		return f32(c.c1x + f32(u * f32(f32(c.c2x * 2) + f32(c.c3x * k)))),
			f32(c.c1y + f32(u * f32(f32(c.c2y * 2) + f32(c.c3y * k))))
	end
	local function dist(ax, ay, bx, by)
		local dx, dy = f32(bx - ax), f32(by - ay)
		return f32(math.sqrt(f32(f32(dx * dx) + f32(dy * dy))))
	end
	M.dist = dist
	local TOL = f32(1e-5)
	-- B(u) - P0 (the length routine leaves out the P0 term: other rounding)
	function M.eval0(c, u)
		if c.n == 2 then
			return f32(c.c1x * u), f32(c.c1y * u)
		elseif c.n == 3 then
			return f32(f32(c.c1x + f32(c.c2x * u)) * u), f32(f32(c.c1y + f32(c.c2y * u)) * u)
		end
		local ix, iy = f32(c.c2x + f32(c.c3x * u)), f32(c.c2y + f32(c.c3y * u))
		return f32(f32(c.c1x + f32(ix * u)) * u), f32(f32(c.c1y + f32(iy * u)) * u)
	end
	function M.seglen(c)
		local function rec(t0, t1, x0, y0, x1, y1, depth)
			local tm = f32(f32(t0 + t1) * 0.5)
			local xm, ym = M.eval0(c, tm)
			local a = dist(x0, y0, x1, y1)
			local b = f32(dist(x0, y0, xm, ym) + dist(xm, ym, x1, y1))
			if depth >= 30 or f32(b - a) < TOL then return b end
			return f32(rec(t0, tm, x0, y0, xm, ym, depth + 1) + rec(tm, t1, xm, ym, x1, y1, depth + 1))
		end
		local x0, y0 = M.eval0(c, 0)
		local x1, y1 = M.eval0(c, 1)
		return rec(0, 1, x0, y0, x1, y1, 0)
	end
	-- arc length s (pixels, from the segment start) -> u: the engine integrates
	-- du/ds = 1/|B'(u)| with 32 classic RK4 steps (k = h/|B'|), in f32, with
	-- its own derivative form (2*c2 and 3*c3 precomputed)
	local SIXTH = f32(1 / 6)
	function M.arcU(c, s)
		local d2x, d2y = f32(c.c2x * 2), f32(c.c2y * 2)
		local d3x, d3y
		if c.n == 4 then d3x, d3y = f32(c.c3x * 3), f32(c.c3y * 3) end
		local function inv(u)
			local dx, dy
			if c.n == 3 then
				dx, dy = f32(c.c1x + f32(d2x * u)), f32(c.c1y + f32(d2y * u))
			else
				dx = f32(c.c1x + f32(u * f32(d2x + f32(u * d3x))))
				dy = f32(c.c1y + f32(u * f32(d2y + f32(u * d3y))))
			end
			return math.sqrt(f32(f32(dx * dx) + f32(dy * dy)))
		end
		local h = f32(s / 32)
		local u = 0
		for _ = 1, 32 do
			local k1 = f32(h / f32(inv(u)))
			local k2 = f32(h / f32(inv(f32(u + f32(k1 * 0.5)))))
			local k3 = f32(h / f32(inv(f32(u + f32(k2 * 0.5)))))
			local k4 = f32(h / f32(inv(f32(u + k3))))
			u = f32(u + f32(f32(f32(k1 + f32(2 * f32(k2 + k3))) + k4) * SIXTH))
		end
		return u
	end
	function M.length(segs)
		local t = 0
		for _, c in R.ipairs(segs) do
			c.len = c.len or M.seglen(c)
			t = f32(t + c.len)
		end
		return t
	end
	-- t in [0,1] -> segment, local u (GetPositionOnCurve / GetTangentOnCurve)
	function M.locate(segs, t)
		t = f32(t)
		if t < 0 then t = 0 elseif t > 1 then t = 1 end
		local n = #segs
		local x = f32(t * n)
		local k = math.min(math.floor(x), n - 1)
		return segs[k + 1], f32(x - k)
	end
	-- arc-length fraction -> segment, local u (nil when the curve model is unknown)
	function M.locateArc(segs, t)
		t = f32(t)
		if t < 0 then t = 0 elseif t > 1 then t = 1 end
		local L = M.length(segs)
		local s = f32(t * L)
		-- the engine walks the segments subtracting each length from s
		for _, c in R.ipairs(segs) do
			if s <= c.len then
				if c.n == 2 then return c, f32(s / c.len) end
				return c, M.arcU(c, s)
			end
			s = f32(s - c.len)
		end
		return segs[1], 0
	end
	-- the engine's answer as a replay-cache record (p2dEncode format), or nil
	function M.answer(path, name, t)
		local inf = INFO[path]
		local segs = inf.p2dSegs
		if not segs then return nil end
		local W, H = inf.p2dW, inf.p2dH
		if name == "GetLength" then
			return R.fmt("n:%.17g", M.length(segs))
		end
		if R.type(t) ~= "number" then return nil end
		local c, u
		if name == "GetPositionOnCurve" or name == "GetTangentOnCurve" then
			c, u = M.locate(segs, t)
		elseif name == "GetPositionOnCurveArcLength" or name == "GetTangentOnCurveArcLength" then
			c, u = M.locateArc(segs, t)
		end
		if not c then return nil end
		if R.find(name, "Position", 1, true) then
			local x, y = M.eval(c, u)
			return R.fmt("u:%.17g,0,%.17g,0", f32(x / W), f32(y / H))
		end
		local x, y = M.tangent(c, u)
		return R.fmt("v:%.17g,%.17g", x, y)
	end
end

local function onCall(p, ...)
	checkBudget()
	local info = INFO[p]
	if CFG.ptrace then
		local a2 = R.select(2, ...)
		R.print("[call]", info.name or info.hint or info.key, R.select("#", ...), R.type(a2) == "string" and a2 or "")
	end
	local n = R.select("#", ...)
	local first = ...
	local name = methodName(info)
	local isMethod = info.kind == "index" and n >= 1 and first == info.parent and isP(first)
	local calleeText
	local args
	if isMethod then
		calleeText = tok(info.parent) .. ":" .. (isIdent(name) and name or "__call")
		args = table.pack(R.select(2, ...))
	else
		calleeText = tok(p)
		args = table.pack(...)
	end
	local a1 = args[1]

	-- --cfg falsy=a,b: calls of these names return false (explore other branches)
	if CFG.falsy and R.type(name) == "string" and R.find("," .. CFG.falsy .. ",", "," .. name .. ",", 1, true) then
		emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ") --> false" })
		return false
	end

	-- datatype constructors are pure: keep them inline
	if info.ns and DATATYPES[info.ns] then
		local dp = exprP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", info.ns)
		-- constructor arguments (the offline Path2D model reads UDim2 / control points)
		INFO[dp].ctor = { ns = info.ns, fn = name, args = args }
		return dp
	end

	-- event connections: record the handler body
	if name == "Connect" or name == "Once" or name == "ConnectParallel" then
		local sig = INFO[info.parent]
		local sigName = sig and methodName(sig)
		if CFG.input_text ~= nil then
			-- simulate user input: text boxes hold this text when handlers run
			for _, bp in R.pairs(BYID) do
				local bi = INFO[bp]
				if bi.created and bi.className == "TextBox" and bi.props.Text ~= CFG.input_text then
					bi.props.Text = CFG.input_text
					local rb = REALV[bp]
					if rb ~= nil then R.pcall(function() rb.Text = CFG.input_text end) end
				end
			end
		end
		local fnTok = R.type(a1) == "function" and captureFunction(a1, SIGNAL_PARAMS[sigName] or { "..." }, nil, "handler") or fmt(a1)
		local conn = callP(calleeText .. "(" .. fnTok .. ")", "connection", "RBXScriptConnection")
		INFO[conn].props.Connected = true
		return conn
	end
	if name == "Wait" and isMethod then
		-- frame signals return numbers (Script42 checks typeof(Heartbeat:Wait()))
		local sp = SIGNAL_PARAMS[methodName(INFO[info.parent])]
		if sp and (sp[1] == "deltaTime" or sp[2] == "deltaTime") then
			emit({ text = calleeText .. "()" })
			onWait()
			if sp[2] == "deltaTime" then return 1, 1 / 60 end
			return 1 / 60
		end
		callP(calleeText .. "()", "result")
		local r = BYID[nextId]
		onWait() -- a yield: lets the loop detector see signal-driven loops
		return r
	end

	if name == "GetService" or name == "FindService" then
		local svc = a1
		if R.type(svc) == "string" and serviceCache[svc] then
			return serviceCache[svc]
		end
		-- unknown names: Roblox errors (GetService) / returns nil (FindService);
		-- Script42 checks GetService("RunsServices") and spins if it succeeds
		if R.type(svc) == "string" and not API.classes[svc] then
			if name == "FindService" then return nil end
			R.error(R.fmt("'%s' is not a valid Service name", svc), 0)
		end
		local r = callP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", R.type(svc) == "string" and svc or "service", "Instance", true)
		if R.type(svc) == "string" and API.classes[svc] then
			INFO[r].className = svc
			INFO[r].props.Name = svc
			INFO[r].props.ClassName = svc
			INFO[r].props.Parent = GAMEP
		end
		if R.type(svc) == "string" then serviceCache[svc] = r end
		return r
	end

	-- secrets don't exist on a client (Script42's key system matches this message)
	if name == "GetSecret" and isMethod then
		emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ") -- errors" })
		R.error("Can't find secret with given key", 0)
	end

	-- teleport settings are a real key/value store (Script42 reads back what it set)
	if (name == "SetTeleportSetting" or name == "GetTeleportSetting") and isMethod then
		local store = INFO[info.parent].tpSettings or {}
		INFO[info.parent].tpSettings = store
		if name == "SetTeleportSetting" then
			emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")" })
			if args[1] ~= nil then store[args[1]] = args[2] end
			return
		end
		return args[1] ~= nil and store[args[1]] or nil
	end

	local self = isMethod and info.parent or nil
	local sinfo = self and INFO[self]
	if sinfo and sinfo.tname == "RBXScriptConnection" and name == "Disconnect" then
		emit({ text = calleeText .. "()" })
		sinfo.props.Connected = false
		return
	end
	if sinfo and sinfo.tname == "Enum" and sinfo.enumName then
		local e = API.enums[sinfo.enumName]
		if name == "GetEnumItems" then
			local list = {}
			for _, it in e.items do R.insert(list, enumItem(sinfo.enumName, it.Name)) end
			return list
		elseif name == "FromName" then
			return (R.type(a1) == "string" and e.byName[a1]) and enumItem(sinfo.enumName, a1) or nil
		elseif name == "FromValue" then
			local it = e.byValue[a1]
			return it and enumItem(sinfo.enumName, it.Name) or nil
		end
	end
	if sinfo and sinfo.tname == "EnumItem" and name == "IsA" then
		return a1 == sinfo.enumName
	end
	if self and RUNSERVICE_BOOL[name] ~= nil then
		return RUNSERVICE_BOOL[name]
	end
	if sinfo and (sinfo.created or sinfo.kids) then
		if name == "GetChildren" then
			emit({ text = calleeText .. "()" })
			return table.clone(kidsOf(self))
		elseif name == "GetDescendants" then
			emit({ text = calleeText .. "()" })
			return descendants(self, {})
		elseif (name == "FindFirstChild" or name == "WaitForChild") and R.type(a1) == "string" then
			local found = findKid(self, a1, name == "FindFirstChild" and args[2] == true)
			if found or sinfo.created then
				emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")" })
				return found
			end
		elseif name == "Destroy" then
			emit({ text = calleeText .. "()" })
			destroyInst(self)
			return
		elseif name == "ClearAllChildren" then
			emit({ text = calleeText .. "()" })
			for _, c in table.clone(kidsOf(self)) do destroyInst(c) end
			return
		elseif name == "IsA" and sinfo.created then
			return a1 == sinfo.className or a1 == "Instance" or (a1 == "GuiObject" and sinfo.className == "Frame")
				or (a1 == "BasePart" and (sinfo.className == "Part" or sinfo.className == "MeshPart"))
		end
	end
	if name == "IsA" or name == "IsDescendantOf" or name == "IsAncestorOf" then
		return true
	end
	if name == "GetLogHistory" then
		-- nothing was printed: a stand-in entry makes HTTP-spy checks
		-- (`entry.message:lower():find("http")`) fire
		return {}
	end

	if name == "HttpGet" or name == "HttpGetAsync" or name == "HttpPost" or name == "HttpPostAsync"
		or name == "GetAsync" or name == "PostAsync" or name == "RequestAsync" then
		if R.type(a1) == "string" then remember(urls, a1) end
		return callP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", "response", "string")
	end

	if name == "FireServer" or name == "InvokeServer" or name == "Fire" or name == "Invoke" then
		remember(remotes, info.parent)
	end

	-- offline: replay recorded Path2D answers
	if not NATIVE and sinfo and sinfo.className == "Path2D" and name == "SetControlPoints" then
		-- the offline model needs the curve (and the parent Frame's size now)
		sinfo.p2dSegs = nil
		sinfo.p2dPoints = R.type(a1) == "table" and not isP(a1) and table.clone(a1) or nil
		sinfo.p2dSet = true
		local W, H = CHAIN.p2d.frameSize(self)
		if CFG.p2d_debug then
			local par = sinfo.props and sinfo.props.Parent
			local sz = isP(par) and INFO[par].props and INFO[par].props.Size
			R.print("P2DDBG W,H", W, H, "a1", R.type(a1), isP(a1), "parent", isP(par), "size", isP(sz),
				isP(sz) and R.tostring(INFO[sz].ctor and INFO[sz].ctor.fn), isP(sz) and INFO[sz].text)
		end
		if W and R.type(a1) == "table" and not isP(a1) then
			local ok, segs = R.pcall(CHAIN.p2d.segments, a1, W, H)
			if CFG.p2d_debug then R.print("P2DDBG segments", ok, R.tostring(segs)) end
			if ok and segs and #segs > 0 then
				sinfo.p2dSegs, sinfo.p2dW, sinfo.p2dH = segs, W, H
			end
		end
	end
	-- engine answers that need no curve (Studio): the point list (a fresh
	-- table each call), the fixed maximum, and curve queries on a Path2D
	-- without a parent raise an error
	if not NATIVE and sinfo and sinfo.className == "Path2D" and sinfo.created then
		if name == "GetMaxControlPoints" then
			emit({ text = calleeText .. "()" })
			return 100
		elseif name == "GetControlPoints" and (sinfo.p2dPoints or not sinfo.p2dSet) then
			emit({ text = calleeText .. "()" })
			return table.clone(sinfo.p2dPoints or {})
		elseif (name == "GetLength" or name == "GetBoundingRect" or (R.type(name) == "string"
			and R.find(name, "OnCurve", 1, true))) and not isP(sinfo.props.Parent) then
			emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")" })
			R.error("Attempting to use Path2D with invalid parent", 0)
		end
	end
	if not NATIVE and sinfo and sinfo.className == "Path2D" and R.type(name) == "string" and name ~= "SetControlPoints" then
		local rec = __P2D and __P2D[p2dKey(name, args)]
		if rec and CFG.p2d_check then
			-- --cfg p2d_check=true: compare the offline model with recorded answers
			local ok, r = R.pcall(CHAIN.p2d.answer, self, name, args[1])
			R.print("\0P2DCHECK " .. p2dKey(name, args) .. "\t" .. R.tostring(rec) .. "\t" .. R.tostring(ok and r)
				.. "\t" .. ((ok and r == rec) and "same" or "DIFF"))
		end
		if not rec and not CFG.p2d_nomodel then
			local ok, r = R.pcall(CHAIN.p2d.answer, self, name, args[1])
			if ok and r then
				rec = r
				R.insert(P2D_LOG, p2dKey(name, args) .. "\t" .. r .. "\tmodel")
			end
		end
		if not rec then P2D_MISS = true end
		if rec then
			local text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")"
			local vals = {}
			local n = 0
			for field in string.gmatch(rec, "[^\t]+") do
				n += 1
				vals[n] = p2dDecode(field, text)
			end
			if n == 1 and isP(vals[1]) then
				local cp = callP(text, R.match(name, "^Get(%u%w*)$") or "result", INFO[vals[1]].tname)
				INFO[cp].props = INFO[vals[1]].props
				return cp
			end
			emit({ text = text })
			return R.unpack(vals, 1, n)
		end
	end

	-- engine objects with a native twin (offline: a datatype model): run the real method
	if self and REALV[self] ~= nil and R.type(name) == "string" and not NO_NATIVE_METHOD[name] then
		local r = REALV[self]
		local isInst = R.typeof(r) == "Instance"
		local u = unwrapArgs(args)
		if u then
			local res = table.pack(R.pcall(function() return r[name](r, R.unpack(u, 1, u.n)) end))
			if not res[1] then
				if not isInst and res[2] ~= CHAIN.DT_UNSUPPORTED then R.error(res[2], 0) end
			else
				local text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")"
				local hint0 = R.match(name, "^Get(%u%w*)$") or "result"
				hint0 = R.gsub(hint0, "^%u", string.lower)
				if isInst and r.ClassName == "Path2D" then
					local enc = {}
					for i = 2, res.n do enc[#enc + 1] = p2dEncode(res[i]) or "?" end
					R.insert(P2D_LOG, p2dKey(name, args) .. "\t" .. R.concat(enc, "\t"))
				end
				local outv, good = {}, true
				for i = 2, res.n do
					local w, ok = wrapReal(res[i], text, hint0)
					if not ok then good = false break end
					outv[i - 1] = w
				end
				if good then
					-- datatype methods are pure: the result is an expression, no statement
					if not isInst then return R.unpack(outv, 1, res.n - 1) end
					if res.n == 2 and isP(outv[1]) then
						-- keep a local for datatype results
						local cp = callP(text, hint0, INFO[outv[1]].tname)
						REALV[cp] = res[2]
						return cp
					end
					emit({ text = text })
					return R.unpack(outv, 1, res.n - 1)
				end
			end
		end
	end

	local hint
	if name == "FindFirstChild" or name == "WaitForChild" or name == "FindFirstChildOfClass"
		or name == "FindFirstChildWhichIsA" or name == "FindFirstAncestor" or name == "FindFirstAncestorOfClass"
		or name == "FindFirstAncestorWhichIsA" or name == "FindFirstDescendant" then
		hint = R.type(a1) == "string" and a1 or "child"
	elseif name == "new" and info.parent and INFO[info.parent].kind == "name" and INFO[info.parent].name == "Instance" then
		hint = R.type(a1) == "string" and a1 or "instance"
	elseif name and CLASS_HINT[name] then
		hint = CLASS_HINT[name]
	elseif name == "Clone" then
		hint = "clone"
	elseif name == "Create" and isMethod and INFO[info.parent].className == "TweenService" then
		hint = "tween"
	elseif name then
		hint = R.match(name, "^Get(%u%w*)$") or R.match(name, "^Find(%u%w*)$")
		local made = R.match(name, "^Create(%u%w*)$") or R.match(name, "^New(%u%w*)$")
			or R.match(name, "^Add(%u%w*)$") or R.match(name, "^Make(%u%w*)$")
		if hint then
			hint = R.gsub(hint, "^%u", string.lower)
		else
			hint = made or "result" -- CreateWindow -> Window
		end
	else
		hint = "result"
	end
	return callP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", hint)
end

-- values that are certainly not numbers/strings in Roblox: arithmetic on
-- them raises the same error the engine would (Luraph relies on that)
local OPAQUE = { EnumItem = 1, Enum = 1, Enums = 1, RBXScriptSignal = 1, RBXScriptConnection = 1 }
local function opaqueType(v)
	if not isP(v) then return nil end
	local info = INFO[v]
	if OPAQUE[info.tname] then return info.tname end
	if info.created or (info.className and info.kind ~= "call" or info.kind == "name" and info.className) then
		return "Instance"
	end
	return nil
end
local function luaTypeName(v)
	return opaqueType(v) or R.typeof(v)
end
local function arithError(opname, a, b)
	if opaqueType(a) or opaqueType(b) then
		R.error(R.fmt("attempt to perform arithmetic (%s) on %s and %s", opname, luaTypeName(a), luaTypeName(b)), 3)
	end
end
local ARITH = {
	["+"] = function(a, b) return a + b end, ["-"] = function(a, b) return a - b end,
	["*"] = function(a, b) return a * b end, ["/"] = function(a, b) return a / b end,
	["//"] = function(a, b) return a // b end, ["%"] = function(a, b) return a % b end,
	["^"] = function(a, b) return a ^ b end,
}
local OPNAMES = { ["+"] = "add", ["-"] = "sub", ["*"] = "mul", ["/"] = "div", ["//"] = "idiv", ["%"] = "mod", ["^"] = "pow" }
local function binop(op, tname)
	return function(a, b)
		arithError(OPNAMES[op], a, b)
		local ra, oka = realOf(a)
		local rb, okb = realOf(b)
		if oka and okb then
			-- (offline both twins are models: anything they refuse stays symbolic)
			local ok, r = R.pcall(ARITH[op], ra, rb)
			if not ok and NATIVE then R.error(r, 2) end
			if ok then
				local w, good = wrapReal(r, "(" .. fmt(a) .. " " .. op .. " " .. fmt(b) .. ")", nil)
				if good then return w end
			end
		end
		return exprP("(" .. fmt(a) .. " " .. op .. " " .. fmt(b) .. ")", tname or (isP(a) and INFO[a].tname) or (isP(b) and INFO[b].tname) or "number")
	end
end

-- Methods (inst:FindFirstChild, signal:Connect, ...) are real functions in
-- Roblox; Luraph inspects some with debug.info, so hand out native-looking
-- functions that route to the call logger.
local METHOD_PREFIX = { "Get", "Find", "Wait", "Is", "Clone", "Destroy", "Connect", "Once", "Fire", "Invoke",
	"Set", "Clear", "Remove", "Add", "Load", "Play", "Stop", "Pause", "Resume", "Adjust", "Move", "Pivot",
	"Apply", "Take", "Kick", "Teleport", "Emit", "Create", "Raycast", "Blockcast", "Spherecast", "Shapecast",
	"Http", "Request", "JSON", "Generate", "Compute", "Change", "Equip", "Unequip", "Preload", "Bind", "Unbind",
	"Disconnect", "Activate", "Deactivate", "Update", "Serialize", "Break", "Reset", "Scale", "To", "Lerp",
	"Navigate", "Render", "Open", "Close", "Enable", "Disable", "Insert", "Show", "Hide", "Tween", "Capture",
	"Post", "Publish", "Subscribe", "Increment", "Decrement", "Save", "Read", "Write", "Check", "Can", "Has",
	"Prompt", "Send", "Kill", "Spawn", "Transform", "Invert", "Reverse", "Clamp", "Sample", "Evaluate",
	"Batch", "Sync", "Query", "Register", "Unregister", "Rebuild", "Refresh", "Cancel", "Dump", "Test", "From" }
local METHOD_EXACT = { connect = 1, wait = 1, disconnect = 1, Wait = 1, Connect = 1, Once = 1, ConnectParallel = 1,
	Disconnect = 1, Destroy = 1, Clone = 1, Remove = 1, ClearAllChildren = 1, Kick = 1, Play = 1, Stop = 1,
	findFirstChild = 1, children = 1, getChildren = 1, clone = 1, destroy = 1, remove = 1, isA = 1 }
local methodCache = R.setmetatable({}, { __mode = "k" })
local METHODP = R.setmetatable({}, { __mode = "k" }) -- method function -> index proxy
METHODP_REF = METHODP
function isMethodName(k)
	if R.type(k) ~= "string" then return false end
	if METHOD_EXACT[k] then return true end
	for _, pre in METHOD_PREFIX do
		if R.sub(k, 1, #pre) == pre and R.match(R.sub(k, #pre + 1, #pre + 1), "^%u$") then
			return true
		end
	end
	return false
end
-- In Roblox a method is one C function shared by every object of a type
-- (workspace.FindFirstChild == game.FindFirstChild); Luraph compares them.
local SHARED_METHODS = {}
local SIGNAL_T = { RBXScriptSignal = true, RBXScriptConnection = true }
function methodFn(p, k)
	local want = INFO[p].tname
	if SIGNAL_T[want] then
		-- Roblox builds a new closure on every index of a signal/connection
		-- method (s.Connect ~= s.Connect) and checks self like a C function
		local ip = indexP(p, k)
		local f = function(...)
			local self = ...
			if R.select("#", ...) == 0 then
				R.error(R.fmt("missing argument #1 to '%s' (%s expected)", k, want), 0)
			end
			if not (isP(self) and INFO[self].tname == want) then
				R.error(R.fmt("invalid argument #1 to '%s' (%s expected, got %s)", k, want, luaTypeName(self)), 0)
			end
			return PMT.__call(indexP(self, k), ...)
		end
		CFUNCS[f] = true
		CNAME[f] = k
		METHODP[f] = ip
		return f
	end
	local ck = R.tostring(INFO[p].tname) .. "|" .. R.tostring(k)
	local f = SHARED_METHODS[ck]
	if f then return f end
	local ip = indexP(p, k)
	f = function(...)
		local self = ...
		if not isP(self) then
			R.error("Expected ':' not '.' calling member function " .. k, 0)
		end
		return PMT.__call(indexP(self, k), ...)
	end
	CFUNCS[f] = true
	CNAME[f] = k
	METHODP[f] = ip
	SHARED_METHODS[ck] = f
	return f
end

local SIGNAL_MEMBERS = {
	RBXScriptSignal = { Connect = "method", ConnectParallel = "method", Once = "method", Wait = "method" },
	RBXScriptConnection = { Connected = "prop", Disconnect = "method" },
}

-- Luraph v14.x fingerprints sometimes derive the spelling of signal methods
-- dynamically.  In the standalone tracer those decoded names may arrive in
-- lower-case even though Roblox exposes the canonical capitalized members.
-- Canonicalize only while collecting devirtualization state: normal tracing
-- keeps Roblox's case-sensitive member behavior.
local DEVT_SIGNAL_ALIAS = {
	wait = "Wait", connect = "Connect", once = "Once", connectparallel = "ConnectParallel",
	disconnect = "Disconnect",
}

PMT.__index = function(p, k)
	local info = INFO[p]
	if CFG.trace or CFG.ptrace then R.print("[index]", info.name or info.hint, k) end
	if k == "Parent" and (info.nilParent or info.created) then return info.props.Parent end
	-- unknown objects: a Parent chain ends at workspace -> game -> nil after a
	-- few levels, like a real hierarchy (scripts walk up until workspace/nil)
	if k == "Parent" and info.props.Parent == nil and info.tname == "Instance" and p ~= WORKSPACEP then
		local depth, q = 0, p
		while q and INFO[q] and INFO[q].key == "Parent" do
			depth += 1
			q = INFO[q].parent
		end
		if depth >= 3 then return WORKSPACEP end
	end
	if SIGNAL_MEMBERS[info.tname] then
		local memberKey = k
		if CFG.devirt and R.type(k) == "string" then
			local alias = DEVT_SIGNAL_ALIAS[R.lower(k)]
			if alias and SIGNAL_MEMBERS[info.tname][alias] then
				memberKey = alias
			end
		end
		local m = SIGNAL_MEMBERS[info.tname][memberKey]
		if m == "method" then return methodFn(p, memberKey) end
		if m == nil then
			R.error(R.fmt("%s is not a valid member of %s", R.tostring(k), info.tname), 0)
		end
	end
	local v = info.props[k]
	if v ~= nil then return v end
	local rv = REALV[p]
	if rv ~= nil and R.type(k) == "string" then
		local isInst = R.typeof(rv) == "Instance"
		local ok, x = R.pcall(function() return rv[k] end)
		if not ok then
			if not isInst and x ~= CHAIN.DT_UNSUPPORTED then R.error(x, 2) end
		elseif R.type(x) ~= "function" then
			local w, good = wrapReal(x, tok(p) .. keySuffix(k), k)
			if good then return w end
		end
	end
	if info.genv then
		return nil
	end
	if info.tname == "Enums" and R.type(k) == "string" and API.enums[k] then
		return enumType(k)
	end
	if info.tname == "Enum" and info.enumName then
		local e = API.enums[info.enumName]
		if e and e.byName[k] then return enumItem(info.enumName, k) end
		if k == "GetEnumItems" or k == "FromName" or k == "FromValue" then return methodFn(p, k) end
	end
	if info.tname == "EnumItem" and k == "IsA" then
		return methodFn(p, k)
	end
	-- Faces / Axes: boolean members from the constructor's NormalId / Axis items
	-- (Script42 checks Faces.new(Front, Left).Front and spins on a wrong answer)
	if (info.tname == "Faces" or info.tname == "Axes") and info.ctor and R.type(k) == "string" then
		local axisOf = { Right = "X", Left = "X", Top = "Y", Bottom = "Y", Back = "Z", Front = "Z" }
		local isFaces = info.tname == "Faces"
		local want = isFaces and (axisOf[k] and k) or (axisOf[k] or ((k == "X" or k == "Y" or k == "Z") and k))
		if want then
			local a = info.ctor.args
			for i = 1, a.n do
				local ai = isP(a[i]) and INFO[a[i]]
				if ai and ai.tname == "EnumItem" then
					local n = ai.props.Name
					if isFaces then
						if ai.enumName == "NormalId" and n == want then return true end
					elseif (ai.enumName == "NormalId" and axisOf[n] == want) or (ai.enumName == "Axis" and n == want) then
						return true
					end
				end
			end
			return false
		end
	end
	local dm = DT_MEMBERS[info.tname]
	if dm and R.type(k) == "string" and dm[k] and REALV[p] == nil then
		if dm[k] == "n" then return 0 end
		local c = indexP(p, k)
		INFO[c].tname = dm[k]
		INFO[c].className = nil
		return c
	end
	local cls = info.className
	if cls and API.classes[cls] and R.type(k) == "string" then
		local kind = memberKind(cls, k)
		if kind == "method" then return methodFn(p, k) end
		if kind == "event" then
			-- like Roblox: a new signal object per index, equal under ==
			local c = newP({ kind = "index", parent = p, key = k, tname = "RBXScriptSignal", hint = k,
				sigKey = info.id .. "." .. k })
			return c
		end
		if kind == "prop" then
			local vt = propType(cls, k)
			if vt and NUMERIC_T[vt] then return NUM_DEFAULT[k] or 0 end
			local c = indexP(p, k)
			if vt and DT_MEMBERS[vt] then
				INFO[c].tname = vt
				INFO[c].className = nil
			elseif vt == "bool" then
				INFO[c].tname = "boolean"
				INFO[c].className = nil
			elseif vt == "string" then
				INFO[c].tname = "string"
				INFO[c].className = nil
			end
			return c
		end
	end
	if isMethodName(k) and info.tname ~= "table" then
		return methodFn(p, k)
	end
	return indexP(p, k)
end
PMT.__newindex = function(p, k, v)
	local info = INFO[p]
	if CFG.ptrace then R.print("[newindex]", info.name or info.hint, k, R.typeof(v)) end
	if k == "Parent" and info.destroyed then
		R.error(R.fmt("The Parent property of %s is locked, current parent: NULL, new parent %s",
			instName(p), isP(v) and instName(v) or "NULL"), 0)
	end
	emit({ text = tok(p) .. keySuffix(k) .. " = " .. fmt(v) })
	local rv = REALV[p]
	-- (offline twins are datatype models: an assignment is only recorded, as before)
	if NATIVE and rv ~= nil and k ~= "Parent" and R.type(k) == "string" then
		local u = unwrapArgs(table.pack(v))
		if u then
			local ok, err = R.pcall(function() rv[k] = u[1] end)
			if not ok then R.error(err, 2) end
		end
	end
	if k == "Parent" and (v == nil or isP(v)) then
		setParent(p, v)
	else
		info.props[k] = v
	end
end
PMT.__call = onCall
PMT.__tostring = function(p)
	if REALV[p] ~= nil then return R.tostring(REALV[p]) end
	return "<" .. (INFO[p].hint or "proxy") .. ">"
end
PMT.__concat = function(a, b)
	if opaqueType(a) or opaqueType(b) then
		R.error(R.fmt("attempt to concatenate %s with %s", luaTypeName(a), luaTypeName(b)), 2)
	end
	return exprP(fmt(a) .. " .. " .. fmt(b), "string")
end
PMT.__add = binop("+")
PMT.__sub = binop("-")
PMT.__mul = binop("*")
PMT.__div = binop("/")
PMT.__idiv = binop("//")
PMT.__mod = binop("%")
PMT.__pow = binop("^")
PMT.__unm = function(a)
	if opaqueType(a) then
		R.error(R.fmt("attempt to perform arithmetic (unm) on %s", luaTypeName(a)), 2)
	end
	if REALV[a] ~= nil then
		local ok, r = R.pcall(function() return -REALV[a] end)
		if not ok and NATIVE then R.error(r, 2) end
		if ok then
			local w, good = wrapReal(r, "(-" .. fmt(a) .. ")", nil)
			if good then return w end
		end
	end
	return exprP("(-" .. fmt(a) .. ")", INFO[a].tname)
end
PMT.__len = function(p)
	return 1
end
PMT.__eq = function(a, b)
	if CFG.ptrace then R.print("[eq]", INFO[a] and (INFO[a].name or INFO[a].hint), INFO[b] and (INFO[b].name or INFO[b].hint)) end
	local ra, rb = REALV[a], REALV[b]
	if ra ~= nil and rb ~= nil then return ra == rb end
	local ia, ib = INFO[a], INFO[b]
	if ia and ib and ia.sigKey and ia.sigKey == ib.sigKey then return true end
	return R.rawequal(a, b)
end
PMT.__lt = function(a, b)
	comment("condition: " .. fmt(a) .. " < " .. fmt(b) .. "  (assumed true)")
	return true
end
PMT.__le = function(a, b)
	comment("condition: " .. fmt(a) .. " <= " .. fmt(b) .. "  (assumed false)")
	return false
end
PMT.__iter = function(p)
	return iterProxy(p, nil)
end
PMT.__metatable = "The metatable is locked"

---------------------------------------------------------------------------
-- the fake environment
---------------------------------------------------------------------------
local function anyProxy(...)
	for i = 1, R.select("#", ...) do
		if isP((R.select(i, ...))) then return true end
	end
	return false
end

-- wraps a library so calls involving proxies become expressions
local function wrapLib(libName, lib, tname)
	local out = {}
	for k, f in R.pairs(lib) do
		if R.type(f) == "function" then
			local label = libName .. "." .. k
			out[k] = function(...)
				if anyProxy(...) then
					return exprP(label .. "(" .. fmtArgs(...) .. ")", tname)
				end
				return f(...)
			end
		else
			out[k] = f
		end
	end
	return out
end

-- getgenv()/_G/shared are plain tables in executors (scripts rawget/rawset
-- and iterate them), so they are real tables here too. First assignments of
-- a key are logged through a metatable that getmetatable() does not reveal.
function genvTable(label)
	local t = {}
	GENVNAME[t] = label
	local shadow = {}
	CHAIN.genvShadow = CHAIN.genvShadow or {}
	CHAIN.genvShadow[t] = shadow
	return R.setmetatable(t, {
		__newindex = function(self, k, v)
			emit({ text = label .. keySuffix(k) .. " = " .. fmt(v) })
			R.rawset(self, k, v)
			shadow[k] = v
		end,
	})
end
-- writes to keys that already exist bypass __newindex: before the next
-- statement is emitted, log every value that changed since (nothing
-- observable happened in between, so the order is kept)
CHAIN.syncGenv = function()
	CHAIN.syncing = true
	for t, shadow in R.next, CHAIN.genvShadow do
		local label = GENVNAME[t]
		for k, v in R.next, t do
			if not R.rawequal(shadow[k], v) then
				shadow[k] = v
				emit({ text = label .. keySuffix(k) .. " = " .. fmt(v) })
			end
		end
		for k in R.next, shadow do
			if R.rawget(t, k) == nil then
				shadow[k] = nil
				emit({ text = label .. keySuffix(k) .. " = nil" })
			end
		end
	end
	CHAIN.syncing = false
end

ENV = {}
local E = ENV

-- v14.9 can derive an invalid allocation size when one standalone-runtime
-- fingerprint differs from Roblox.  Do not fabricate a table/buffer: identify
-- the currently executing instrumented proto so the Python driver can rerun
-- with just that fingerprint helper disabled.
local function noteAllocTrigger(kind, n)
	if ALLOC_TRIGGER then return end
	local chain = CHAIN.get and CHAIN.get() or ""
	local pid = nil
	for part in R.gmatch(chain, "[^,]+") do
		local q = R.match(part, "^(%d+):")
		if q then pid = R.tonumber(q) end
	end
	if not pid and E.__ENT and E.__ENT.n and E.__ENT.n > 0 then
		pid = E.__ENT[E.__ENT.n % 64]
	end
	if pid then ALLOC_TRIGGER = { pid = pid, kind = kind, n = n } end
end

local RandomMT = {}
local RANDOM_STATE -- Random object -> generator state (set below)
local GENV = genvTable("getgenv()")
local collected = {}

-- plain Lua libraries
E.string = wrapLib("string", string, "string")
E.math = wrapLib("math", math, "number")
E.table = (function()
	local t = {}
	for k, v in R.pairs(table) do t[k] = v end
	if CFG.v14_lenient_create or CFG.v14_alloc_trap then
		local nativeCreate = table.create
		t.create = function(n, value)
			local ok, out = R.pcall(nativeCreate, n, value)
			if ok then return out end
			local msg = R.tostring(out)
			if R.find(msg, "size out of range", 1, true)
				or R.find(msg, "invalid argument #1 to 'create'", 1, true) then
				if CFG.v14_alloc_trap then noteAllocTrigger("table", n) end
				if CFG.v14_lenient_create then return {} end
			end
			R.error(out, 0)
		end
	end
	return t
end)()
E.bit32 = bit32
E.coroutine = coroutine
-- Unicode NFC/NFD (tables generated by gen_unicode.py). Luraph feeds random
-- Hangul/Latin strings to utf8.nfcnormalize/nfdnormalize and checks results.
local UNorm = (function()
	local U = __UNICODE or { decomp = "", ccc = "", comp = "" }
	local decomp, ccc, comp = {}, {}, {}
	for k, v in string.gmatch(U.decomp, "(%x+):([%x,]+)") do
		local list = {}
		for x in string.gmatch(v, "%x+") do R.insert(list, R.tonumber(x, 16)) end
		decomp[R.tonumber(k, 16)] = list
	end
	for k, v in string.gmatch(U.ccc, "(%x+):(%x+)") do
		ccc[R.tonumber(k, 16)] = R.tonumber(v, 16)
	end
	for a, b, c in string.gmatch(U.comp, "(%x+),(%x+):(%x+)") do
		comp[R.tonumber(a, 16) * 0x110000 + R.tonumber(b, 16)] = R.tonumber(c, 16)
	end
	local SBase, LBase, VBase, TBase = 0xAC00, 0x1100, 0x1161, 0x11A7
	local LCount, VCount, TCount = 19, 21, 28
	local NCount = VCount * TCount
	local SCount = LCount * NCount

	local function decompose(s)
		local out = {}
		for _, cp in utf8.codes(s) do
			local si = cp - SBase
			if si >= 0 and si < SCount then
				R.insert(out, LBase + si // NCount)
				R.insert(out, VBase + (si % NCount) // TCount)
				local t = si % TCount
				if t ~= 0 then R.insert(out, TBase + t) end
			elseif decomp[cp] then
				for _, x in decomp[cp] do R.insert(out, x) end
			else
				R.insert(out, cp)
			end
		end
		-- canonical ordering: stable sort of each run of combining marks
		local i = 1
		while i <= #out do
			if (ccc[out[i]] or 0) > 0 then
				local j = i
				while j + 1 <= #out and (ccc[out[j + 1]] or 0) > 0 do j += 1 end
				for a = i + 1, j do
					local x = out[a]
					local cx = ccc[x]
					local b = a - 1
					while b >= i and ccc[out[b]] > cx do
						out[b + 1] = out[b]
						b -= 1
					end
					out[b + 1] = x
				end
				i = j + 1
			else
				i += 1
			end
		end
		return out
	end

	local function compose(cps)
		local out = {}
		local starter = nil -- index into out
		local lastClass = -1
		for _, cp in cps do
			local c = ccc[cp] or 0
			local done = false
			if starter then
				local s = out[starter]
				-- Hangul L+V and LV+T
				local li, vi = s - LBase, cp - VBase
				if li >= 0 and li < LCount and vi >= 0 and vi < VCount and starter == #out then
					out[starter] = SBase + (li * VCount + vi) * TCount
					done = true
				else
					local si, ti = s - SBase, cp - TBase
					if si >= 0 and si < SCount and si % TCount == 0 and ti > 0 and ti < TCount and starter == #out then
						out[starter] = s + ti
						done = true
					end
				end
				if not done and (lastClass < c or (lastClass == 0 and starter == #out)) then
					local p = comp[s * 0x110000 + cp]
					if p and (starter == #out or lastClass < c) then
						out[starter] = p
						done = true
					end
				end
			end
			if not done then
				R.insert(out, cp)
				if c == 0 then
					starter = #out
					lastClass = 0
				else
					lastClass = c
				end
			end
		end
		return out
	end

	local function pack(cps)
		local parts = {}
		for i, cp in cps do parts[i] = utf8.char(cp) end
		return R.concat(parts)
	end
	return {
		nfd = function(s) return pack(decompose(s)) end,
		nfc = function(s) return pack(compose(decompose(s))) end,
	}
end)()

-- Roblox's utf8 library has three functions the standalone runtime lacks;
-- Luraph fingerprints the key set of this table
E.utf8 = (function()
	local t = {}
	for k, v in R.pairs(utf8) do t[k] = v end
	t.graphemes = function(s, i, j)
		local list = {}
		for p, c in utf8.codes(s) do R.insert(list, { p, p + #utf8.char(c) - 1 }) end
		local n = 0
		return function()
			n += 1
			local g = list[n]
			if g then return g[1], g[2] end
		end
	end
	t.nfcnormalize = function(s) return UNorm.nfc(s) end
	t.nfdnormalize = function(s) return UNorm.nfd(s) end
	return t
end)()
E.vector = vector
E.os = { clock = os.clock, time = os.time, date = os.date, difftime = os.difftime }
E.debug = debug
E.buffer = (function()
	local b = {}
	-- exactly Roblox's buffer library (a newer local Luau has extra functions,
	-- and Luraph fingerprints library contents)
	local ROBLOX_BUFFER = {}
	for n in string.gmatch("copy,create,fill,fromstring,len,readbits,readf32,readf64,readi16,readi32,readi8,"
		.. "readstring,readu16,readu32,readu8,tostring,writebits,writef32,writef64,writei16,writei32,writei8,"
		.. "writestring,writeu16,writeu32,writeu8", "[^,]+") do ROBLOX_BUFFER[n] = true end
	for k, f in R.pairs(buffer) do
		if ROBLOX_BUFFER[k] then b[k] = f end
	end
	if CFG.v14_lenient_create or CFG.v14_alloc_trap then
		local nativeCreate = buffer.create
		b.create = function(n)
			local ok, out = R.pcall(nativeCreate, n)
			if ok then return out end
			local msg = R.tostring(out)
			if R.find(msg, "size out of range", 1, true)
				or R.find(msg, "invalid argument #1 to 'create'", 1, true) then
				if CFG.v14_alloc_trap then noteAllocTrigger("buffer", n) end
				if CFG.v14_lenient_create then return nativeCreate(0) end
			end
			R.error(out, 0)
		end
	end
	-- Luraph's tamper response scribbles single bytes (value & 255) over its
	-- bytecode buffer at random offsets and then spins forever. The legitimate
	-- decoder writes full 32-bit words sequentially, so small scattered writes
	-- are logged together with the bytes they overwrite. Once the pattern is
	-- certain, every logged write is undone and the thread running the routine
	-- is killed, leaving the bytecode intact for the rest of the script.
	local lastOff = -1
	local undo = {}
	for _, nm in { "writei32", "writeu32" } do
		local orig = buffer[nm]
		b[nm] = function(buf, off, v)
			if tamperCount > 0 and v >= 0 and v < 256 and off ~= lastOff + 4 and buffer.len(buf) > 4096 then
				-- the routine survived our error (caught by the script): keep it harmless
				R.error(TAMPER, 0)
			end
			if v >= 0 and v < 256 and off ~= lastOff + 4 and buffer.len(buf) > 4096 and off + 4 <= buffer.len(buf) then
				R.insert(undo, { buf, off, buffer.readu32(buf, off) })
				if #undo >= (CFG.tamper_limit or 64) then
					for i = #undo, 1, -1 do
						local u = undo[i]
						buffer.writeu32(u[1], u[2], u[3])
					end
					table.clear(undo)
					tamperCount += 1
					if not TRIGGER then noteTrigger() end
					if (CFG.oplog or CFG.inline_probe) and E.__OPDUMP then E.__OPDUMP() end
					R.error(TAMPER, 0)
				end
			elseif #undo > 0 and off == lastOff + 4 then
				table.clear(undo)
			end
			lastOff = off
			return orig(buf, off, v)
		end
	end
	if not CFG.dump_strings then return b end
	b.readstring = function(buf, off, len)
		local s = buffer.readstring(buf, off, len)
		R.insert(collected, s)
		return s
	end
	b.tostring = function(buf)
		local s = buffer.tostring(buf)
		R.insert(collected, s)
		return s
	end
	return b
end)()

for _, k in { "assert", "error", "next", "rawget", "rawset", "rawequal", "rawlen", "select", "setmetatable",
	"getmetatable", "unpack", "newproxy", "gcinfo", "_VERSION" } do
	E[k] = REAL_G[k]
end

-- Wrappers forward `...` untouched: Luraph calls them with missing or bad
-- arguments and compares the resulting errors with the real functions'.
E.type = function(...)
	local v = ...
	if isP(v) then
		local t = INFO[v].tname
		if t == "string" or t == "number" or t == "table" or t == "boolean" then return t end
		return "userdata"
	end
	return R.type(...)
end
E.typeof = function(...)
	local v = ...
	if CFG.ptrace then R.print("[typeof]", isP(v) and (INFO[v].name or INFO[v].hint) or R.typeof(v)) end
	if isP(v) then
		local t = INFO[v].tname
		if t == "table" then return "table" end
		return t or "Instance"
	end
	if RANDOM_STATE and RANDOM_STATE[v] then return "Random" end
	local t = R.typeof(...)
	if t == "vector" then return "Vector3" end -- Vector3 is the native vector type
	return t
end
E.tostring = function(...)
	local v = ...
	if CFG.ptrace then R.print("[tostring]", isP(v) and (INFO[v].name or INFO[v].hint) or R.typeof(v)) end
	if isP(v) then
		local info = INFO[v]
		if info.tname == "EnumItem" then return "Enum." .. info.enumName .. "." .. info.props.Name end
		if info.tname == "Enum" then return info.enumName end
		if info.tname == "Enums" then return "Enums" end
		if REALV[v] ~= nil then return R.tostring(REALV[v]) end
		-- tostring(instance) is its Name
		if R.type(info.props.Name) == "string" and (info.className or opaqueType(v) == "Instance") then return info.props.Name end
		return exprP("tostring(" .. tok(v) .. ")", "string")
	end
	return R.tostring(...)
end
E.tonumber = function(...)
	local v = ...
	if isP(v) then return exprP("tonumber(" .. tok(v) .. ")", "number") end
	return R.tonumber(...)
end
-- next() called directly on a stand-in object: it behaves as an empty table
E.next = function(...)
	local t = ...
	if isP(t) then
		if R.select("#", ...) < 1 then R.error("missing argument #1 to 'next' (table expected)", 0) end
		return nil
	end
	return R.next(...)
end
E.pairs = function(...)
	local t = ...
	if isP(t) then return iterProxy(t, "pairs"), t, nil end
	local f, s0, c0 = R.pairs(...)
	if f == R.next then f = E.next end
	return f, s0, c0
end
E.ipairs = function(...)
	local t = ...
	if isP(t) then return iterProxy(t, "ipairs"), t, 0 end
	return R.ipairs(...)
end
-- The real pcall/xpcall: Luraph looks at the call stack from inside a
-- protected call (debug.info(3, "f") must be the xpcall it holds), so these
-- cannot be wrapped. Our stop signals may therefore be swallowed by a script
-- pcall; they are re-raised on the next opportunity instead (see STICKY).
E.pcall = R.pcall
E.ypcall = R.pcall -- Roblox's deprecated alias (same function)
E.xpcall = R.xpcall
-- the real getfenv: the script runs in a thread whose globals are ENV (see the
-- runner below), so getfenv(0)/getfenv() already return ENV. A Lua wrapper here
-- would add a stack frame on every VM call, which Luraph notices through the
-- position in its stack-overflow probe's error message.
E.getfenv = R.getfenv
E.setfenv = function(x, env)
	if R.type(x) == "number" then
		return R.setfenv(x == 0 and 0 or x + 1, env)
	end
	-- a C function's environment cannot be changed; Luraph tests exactly this
	if CFUNCS[x] or isP(x) or (R.type(x) == "function" and debug.info(x, "s") == HARNESS_SRC0) then
		R.error("'setfenv' cannot change environment of given object", 0)
	end
	return R.setfenv(x, env)
end
E.print = function(...)
	emit({ text = "print(" .. fmtArgs(...) .. ")" })
end
E.warn = function(...)
	emit({ text = "warn(" .. fmtArgs(...) .. ")" })
end
-- Layered scripts loadstring further VM chunks. Big ones are reported to the
-- driver, which instruments them like the main script and passes the result
-- back in __CHUNKS for the next run (keyed by length and a cheap hash).
local NEWCHUNKS = {}
local function srcKey(src)
	local h = 0
	for i = 1, #src, 4096 do
		local bytes = { R.byte(src, i, math.min(i + 4095, #src)) }
		for _, b in bytes do h = (h * 31 + b) % 2147483648 end
	end
	return #src .. "_" .. h
end
E.loadstring = function(src, chunkname)
	if isP(src) then
		return exprP("loadstring(" .. tok(src) .. ")", "function")
	end
	local patched = nil
	if R.type(src) == "string" and #src >= 4096 then
		local key = srcKey(src)
		patched = __CHUNKS and __CHUNKS[key]
		if not patched and not NEWCHUNKS[key] then
			NEWCHUNKS[key] = src
			R.insert(NEWCHUNKS, key)
		end
		-- spin watchdog (see E.__SPIN): a chunk the driver never saw (the run
		-- that would report it hung) gets its dispatch heads patched here
		if CFG.spin and not (patched and R.find(patched, "__SPIN.n", 1, true)) then
			patched = R.gsub(patched or src, "while true do [%w_, ]-=[%a_][%w_]*%[[%a_][%w_]*%];",
				"%0__SPIN.n=__SPIN.n+1;if __SPIN.n>=__SPIN.step then __SPIN.f()end;")
		end
	end
	local f, err = R.loadstring(patched or src, chunkname)
	if not f then return nil, err end
	R.setfenv(f, ENV)
	comment("loadstring() of " .. #src .. " bytes: " .. quote(R.sub(src, 1, 200)))
	return f
end
E.require = function(m)
	return callP("require(" .. fmt(m) .. ")", "module")
end

-- task scheduling: run everything immediately, recording the body
local function spawnLike(label, fn, ...)
	if R.type(fn) == "function" then
		local args = table.pack(...)
		lastThread = nil
		local okc, tokf = R.pcall(captureFunction, fn, nil, args)
		if not okc then
			-- the budget ran out inside the new thread: keep what it recorded
			local fid = FUNCS[fn]
			if fid then
				local p = newP({ kind = "call", tname = "thread", hint = "thread" })
				local st = { call = label .. "(" .. fid .. ")", res = p }
				INFO[p].stmt = st
				R.insert(curBlock().lines, st)
			end
			R.error(tokf, 0)
		end
		local th = lastThread
		local p = callP(label .. "(" .. tokf .. (args.n > 0 and (", " .. fmtArgs(...)) or "") .. ")", "thread", "thread")
		if th then
			THREADP[th] = p
			return th
		end
		return p
	end
	return callP(label .. "(" .. fmtArgs(fn, ...) .. ")", "thread", "thread")
end
local function doWait(label, t)
	emit({ text = label .. "(" .. (t ~= nil and fmt(t) or "") .. ")" })
	onWait()
	return (R.type(t) == "number" and t) or 0.03, R.clock()
end
-- Errors are raised exactly like luaL_typeerror in a C function would
-- (no position prefix); Luraph calls these with bad arguments on purpose.
local function typeName(n, ...)
	if R.select("#", ...) < n then return "no value" end
	return R.typeof((R.select(n, ...)))
end
local function argError(n, fname, expected, ...)
	R.error(R.fmt("invalid argument #%d to '%s' (%s expected, got %s)", n, fname, expected, typeName(n, ...)), 0)
end
local function checkRoutine(n, fname, ...)
	local v = R.select(n, ...)
	local t = R.type(v)
	if R.select("#", ...) < n or (t ~= "function" and t ~= "thread") then
		argError(n, fname, "function or thread", ...)
	end
	return v
end
local function checkNumber(n, fname, ...)
	local v = R.select(n, ...)
	if R.select("#", ...) >= n and v ~= nil and R.type(v) ~= "number" then
		if R.tonumber(v) then return R.tonumber(v) end
		argError(n, fname, "number", ...)
	end
	return v
end

local function scheduleLater(label, delayArg, due, fn, ...)
	if R.type(fn) == "thread" then
		-- resuming an existing thread later: record it and resume it at the end
		local th = fn
		local args = table.pack(...)
		R.insert(DEFERRED, { rec = { params = {}, block = { lines = {}, waits = {} } }, thread = th,
			args = args, n = args.n, due = due })
		emit({ text = label .. "(" .. (delayArg and (fmt(delayArg) .. ", ") or "") .. fmt(th) .. ")" })
		return th
	end
	local args = table.pack(...)
	lastThread = nil
	local tokf = captureFunction(fn, nil, args, due)
	local th = lastThread
	local p = callP(label .. "(" .. (delayArg ~= nil and (fmt(delayArg) .. ", ") or "") .. tokf
		.. (args.n > 0 and (", " .. fmtArgs(...)) or "") .. ")", "thread", "thread")
	if th then THREADP[th] = p; return th end
	return p
end

E.task = {
	spawn = function(...)
		local fn = checkRoutine(1, "spawn", ...)
		if R.type(fn) == "thread" then
			emit({ text = "task.spawn(" .. fmt(fn) .. ")" })
			coroutine.resume(fn, R.select(2, ...))
			return fn
		end
		return spawnLike("task.spawn", ...)
	end,
	defer = function(...)
		checkRoutine(1, "defer", ...)
		return scheduleLater("task.defer", nil, 0.5, ...)
	end,
	delay = function(...)
		local t = checkNumber(1, "delay", ...)
		checkRoutine(2, "delay", ...)
		return scheduleLater("task.delay", t or 0, 1 + (t or 0), R.select(2, ...))
	end,
	wait = function(...)
		local t = checkNumber(1, "wait", ...)
		return doWait("task.wait", t)
	end,
	cancel = function(...)
		local th = R.select(1, ...)
		if R.select("#", ...) < 1 or R.type(th) ~= "thread" then
			argError(1, "cancel", "thread", ...)
		end
		emit({ text = "task.cancel(" .. fmt(th) .. ")" })
		if coroutine.status(th) == "suspended" then coroutine.close(th) end
	end,
	synchronize = function() end,
	desynchronize = function() end,
}
E.wait = function(t) return doWait("wait", t) end
E.spawn = function(fn) return spawnLike("spawn", fn) end
E.delay = function(t, fn)
	return E.task.delay(t, fn)
end
E.tick = function() return os.clock() + 1.7e9 end
E.time = os.clock
E.elapsedTime = os.clock
E.getgenv = function() return GENV end
-- getrenv(): Roblox's own globals (libraries, game, datatypes), no executor
-- functions; one table, built on first use (Script42 reads getrenv().math.random)
do
	local renv
	E.getrenv = function()
		if renv then return renv end
		renv = {}
		for n in string.gmatch("assert,error,getmetatable,setmetatable,ipairs,pairs,next,pcall,xpcall,print,"
			.. "select,tonumber,tostring,type,typeof,unpack,rawequal,rawget,rawset,rawlen,gcinfo,newproxy,"
			.. "collectgarbage,getfenv,setfenv,require,_G,_VERSION,string,math,table,os,debug,bit32,coroutine,"
			.. "utf8,buffer,vector,game,Game,workspace,Workspace,script,plugin,shared,settings,UserSettings,"
			.. "tick,time,wait,delay,spawn,elapsedTime,ElapsedTime,warn,task,Enum,Instance,stats,Stats,version,"
			.. "Random,Vector3", "[^,]+") do
			renv[n] = R.rawget(E, n)
		end
		for n in DATATYPES do renv[n] = R.rawget(E, n) end
		return renv
	end
end
E._G = genvTable("_G")
E.shared = genvTable("shared")
E.game = globalP("game")
INFO[E.game].className = "DataModel"
E.Game = E.game
E.workspace = globalP("workspace")
INFO[E.workspace].className = "Workspace"
E.Workspace = E.workspace
-- identity properties Luraph checks (game.Parent == nil, type(game.Name), ...)
INFO[E.game].nilParent = true
INFO[E.game].props.Name = CFG.place_name or "Game"
INFO[E.game].props.ClassName = "DataModel"
INFO[E.workspace].props.Name = "Workspace"
INFO[E.workspace].props.ClassName = "Workspace"
INFO[E.workspace].props.Parent = E.game
serviceCache.Workspace = E.workspace
GAMEP = E.game
WORKSPACEP = E.workspace
E.script = globalP("script")
INFO[E.script].className = "LocalScript"
E.plugin = nil

-- Roblox library globals are frozen tables of C functions, not userdata
local NS_CONSTANTS = { zero = 1, one = 1, xAxis = 1, yAxis = 1, zAxis = 1, identity = 1 }
local NS_MEMBERS = {
	Vector3 = { "new", "zero", "one", "xAxis", "yAxis", "zAxis", "FromNormalId", "FromAxis", "fromNormalId", "fromAxis" },
	Vector2 = { "new", "zero", "one", "xAxis", "yAxis" },
	CFrame = { "new", "fromEulerAnglesXYZ", "fromEulerAnglesYXZ", "Angles", "fromOrientation", "fromAxisAngle",
		"fromMatrix", "lookAt", "lookAlong", "identity", "fromEulerAngles" },
	Color3 = { "new", "fromRGB", "fromHSV", "fromHex", "toHSV" },
	UDim2 = { "new", "fromScale", "fromOffset" },
	Font = { "new", "fromEnum", "fromName", "fromId" },
	DateTime = { "now", "fromUnixTimestamp", "fromUnixTimestampMillis", "fromUniversalTime", "fromLocalTime", "fromIsoDate" },
	BrickColor = { "new", "random", "palette", "White", "Gray", "DarkGray", "Black", "Red", "Yellow", "Green", "Blue" },
	SharedTable = { "new", "clone", "cloneAndFreeze", "increment", "isFrozen", "size", "update" },
}
local function nativeFn(label, f)
	f = tramp(f)
	CFUNCS[f] = true
	CNAME[f] = R.match(label, "([%w_]+)$")
	FNAME[f] = label
	return f
end
local function namespace(name, fields)
	local t = fields or {}
	for k, v in R.pairs(t) do
		if R.type(v) == "function" then nativeFn(name .. "." .. k, v) end
	end
	local function member(k)
		if NS_CONSTANTS[k] or R.match(k, "^%u") and name == "BrickColor" and k ~= "new" then
			local p = exprP(name .. "." .. k .. (NS_CONSTANTS[k] and "" or "()"), name)
			attachReal(p, name, k, not NS_CONSTANTS[k])
			return p
		end
		return nativeFn(name .. "." .. k, function(...)
			local p = exprP(name .. "." .. k .. "(" .. fmtArgs(...) .. ")", name)
			if CFG.ptrace then R.print("[ctor]", INFO[p].text) end
			INFO[p].ctor = { ns = name, fn = k, args = table.pack(...) }
			attachReal(p, name, k, true, ...)
			return p
		end)
	end
	for _, k in NS_MEMBERS[name] or { "new" } do
		if R.rawget(t, k) == nil then t[k] = member(k) end
	end
	return table.freeze(t)
end
-- constructors that reject a call without arguments in Roblox: {arg type}
local REQUIRED_ARG = {
	Path2DControlPoint = "UDim2", NumberSequenceKeypoint = "number", ColorSequenceKeypoint = "number",
	NumberSequence = "number", ColorSequence = "Color3", Ray = "Vector3", Region3 = "Vector3",
	PathWaypoint = "Vector3", Font = "string",
}
for name in DATATYPES do
	if name ~= "Vector3" then
		local fields = nil
		if REQUIRED_ARG[name] then
			local want = REQUIRED_ARG[name]
			fields = {
				new = function(...)
					if R.select("#", ...) < 1 or (...) == nil then
						R.error(R.fmt("invalid argument #1 to 'new' (%s expected, got %s)", want,
							R.select("#", ...) < 1 and "no value" or "nil"), 0)
					end
					local p = exprP(name .. ".new(" .. fmtArgs(...) .. ")", name)
					if CFG.ptrace then R.print("[ctor]", INFO[p].text) end
					INFO[p].ctor = { ns = name, fn = "new", args = table.pack(...) }
					attachReal(p, name, "new", true, ...)
					return p
				end,
			}
		end
		E[name] = namespace(name, fields)
	end
end
-- In Roblox, Vector3 *is* the native Luau vector type; Luraph checks this.
local function vec(x, y, z)
	return vector.create(R.tonumber(x) or 0, R.tonumber(y) or 0, R.tonumber(z) or 0)
end
E.Vector3 = namespace("Vector3", {
	new = function(x, y, z)
		if isP(x) or isP(y) or isP(z) then
			return exprP("Vector3.new(" .. fmtArgs(x, y, z) .. ")", "Vector3")
		end
		return vec(x, y, z)
	end,
	zero = vector.zero or vec(0, 0, 0),
	one = vector.one or vec(1, 1, 1),
	xAxis = vec(1, 0, 0),
	yAxis = vec(0, 1, 0),
	zAxis = vec(0, 0, 1),
})
E.Instance = namespace("Instance", {
	new = function(...)
		local className, parent = ...
		if R.type(className) ~= "string" then
			R.error(R.fmt("invalid argument #1 to 'new' (string expected, got %s)",
				R.select("#", ...) < 1 and "no value" or R.typeof(className)), 0)
		end
		local p
		if R.select("#", ...) >= 2 then
			p = callP("Instance.new(" .. fmtArgs(className, parent) .. ")", className)
		else
			p = callP("Instance.new(" .. fmt(className) .. ")", className)
		end
		local info = INFO[p]
		info.created = true
		info.className = className
		info.kids = {}
		info.props.Name = className
		info.props.ClassName = className
		if NATIVE then
			local ok, inst = R.pcall(REAL_G.Instance.new, className)
			if ok then
				if nativeClass(inst) then REALV[p] = inst else inst:Destroy() end
			end
		end
		if isP(parent) then setParent(p, parent) end
		return p
	end,
	fromExisting = function(obj)
		return callP("Instance.fromExisting(" .. fmt(obj) .. ")", "clone")
	end,
})

-- Random must actually work: the VM itself may draw numbers from it
RandomMT.__index = RandomMT
RandomMT.__metatable = "The metatable is locked"
RandomMT.__type = "Random"
do
-- Roblox's Random, bit-exact (verified against Studio): PCG32 XSH-RR with
-- stream increment 105, pcg32_srandom-style seeding. The 64-bit state is kept
-- as two 32-bit halves and multiplied in 16-bit limbs (exact in doubles).
local band, bor, bxor, lsh, rsh, rrot = bit32.band, bit32.bor, bit32.bxor, bit32.lshift, bit32.rshift, bit32.rrotate
local MUL = { 0x7F2D, 0x4C95, 0xF42D, 0x5851 } -- 6364136223846793005, low limb first
local function pcgStep(st)
	local h, l = st.h, st.l
	local a = { band(l, 0xFFFF), rsh(l, 16), band(h, 0xFFFF), rsh(h, 16) }
	local r0 = a[1] * MUL[1]
	local r1 = a[1] * MUL[2] + a[2] * MUL[1] + R.floor(r0 / 65536)
	local r2 = a[1] * MUL[3] + a[2] * MUL[2] + a[3] * MUL[1] + R.floor(r1 / 65536)
	local r3 = a[1] * MUL[4] + a[2] * MUL[3] + a[3] * MUL[2] + a[4] * MUL[1] + R.floor(r2 / 65536)
	local nl = (r0 % 65536) + (r1 % 65536) * 65536 + 105
	local carry = nl >= 4294967296 and 1 or 0
	st.l = nl % 4294967296
	st.h = ((r2 % 65536) + (r3 % 65536) * 65536 + carry) % 4294967296
end
local function nextWord(st)
	local h, l = st.h, st.l
	pcgStep(st)
	local xh = bxor(h, rsh(h, 18))
	local xl = bxor(l, bor(rsh(l, 18), lsh(h, 14)))
	return rrot(bor(rsh(xl, 27), lsh(xh, 5)), rsh(h, 27))
end
local function seedState(st, seed)
	local hi, lo = 0, 0
	if seed ~= seed then
		hi = 0x80000000 -- NaN converts to INT64_MIN
	elseif R.type(seed) == "number" and seed > -9007199254740992 and seed < 9007199254740992 then
		local v = R.floor(seed)
		local m = v < 0 and -v or v
		hi, lo = R.floor(m / 4294967296), m % 4294967296
		if v < 0 then -- two's complement
			lo = (4294967296 - lo) % 4294967296
			hi = (4294967295 - hi + (lo == 0 and 1 or 0)) % 4294967296
		end
	end
	st.h, st.l = 0, 0
	pcgStep(st)
	local nl = st.l + lo
	st.l = nl % 4294967296
	st.h = (st.h + hi + (nl >= 4294967296 and 1 or 0)) % 4294967296
	pcgStep(st)
end
local f32buf = buffer.create(4)
local function f32(x)
	buffer.writef32(f32buf, 0, x)
	return buffer.readf32(f32buf, 0)
end
-- Random objects are userdata like in Roblox: typeof "Random", tostring
-- "Random", locked metatable, == compares state, a fresh method closure per
-- index, and the engine's exact argument errors. (Error levels count the
-- trampoline: impl -> trampoline -> caller.)
local RSTATE = R.setmetatable({}, { __mode = "k" })
-- (w * range) >> 32 without losing bits
local function scaleWord(w, range)
	local a = R.floor(w / 65536) * range
	local b = (w % 65536) * range
	return R.floor((a + R.floor(b / 65536)) / 65536)
end
local function rtype(v)
	if RSTATE[v] then return "Random" end
	if isP(v) then return INFO[v].tname end
	return R.typeof(v)
end
local function numArg(v, i, fname)
	if v == nil then
		R.error(R.fmt("missing argument #%d%s (number expected)", i, fname and (" to '" .. fname .. "'") or ""), 5)
	end
	local n = R.tonumber(v)
	if R.type(v) ~= "number" and not (R.type(v) == "string" and n) then
		R.error(R.fmt("invalid argument #%d%s (number expected, got %s)", i, fname and (" to '" .. fname .. "'") or "", rtype(v)), 5)
	end
	return n
end
local RMETHODS = {}
local makeRandom
function RMETHODS.NextNumber(st, n, a, b)
	if n ~= 0 and n ~= 2 then R.error("Random:NextNumber requires 0 or 2 arguments", 4) end
	if n == 2 then a, b = numArg(a, 2), numArg(b, 3) end
	local lo = nextWord(st)
	local hi = nextWord(st)
	local u = hi * 2 ^ -32 + lo * 2 ^ -64
	if n == 0 then return u end
	if a > b then a, b = b, a end
	return a + (b - a) * u
end
function RMETHODS.NextInteger(st, n, a, b)
	a, b = numArg(a, 2), numArg(b, 3)
	a, b = R.floor(a), R.floor(b)
	if a > b then a, b = b, a end
	local range = b - a + 1
	if range <= 4294967294 then
		return a + scaleWord(nextWord(st), range)
	end
	-- wide ranges: exact high 64 bits of u64 * range (16-bit limbs)
	local lo = nextWord(st)
	local hi = nextWord(st)
	local x = { lo % 65536, R.floor(lo / 65536), hi % 65536, R.floor(hi / 65536) }
	local y, rr = {}, range % 18446744073709551616
	for i = 1, 4 do y[i] = rr % 65536; rr = R.floor(rr / 65536) end
	local limbs = {}
	for k = 1, 8 do limbs[k] = 0 end
	for i = 1, 4 do
		for j = 1, 4 do limbs[i + j - 1] += x[i] * y[j] end
	end
	for k = 1, 7 do
		limbs[k + 1] += R.floor(limbs[k] / 65536)
		limbs[k] %= 65536
	end
	return a + ((limbs[8] * 65536 + limbs[7]) * 65536 + limbs[6]) * 65536 + limbs[5]
end
function RMETHODS.NextUnitVector(st)
	local lo = nextWord(st)
	local hi = nextWord(st)
	local z = f32(f32(2 * f32(hi * 2 ^ -32)) - 1)
	local r = f32(math.sqrt(f32(1 - f32(z * z))))
	local th = f32(f32(2 * math.pi) * f32(lo * 2 ^ -32))
	return E.Vector3.new(f32(r * f32(math.cos(th))), f32(r * f32(math.sin(th))), z)
end
function RMETHODS.Shuffle(st, n, t)
	if R.type(t) ~= "table" then
		R.error(R.fmt("invalid argument #2 (table expected, got %s)", t == nil and "nil" or rtype(t)), 4)
	end
	if table.isfrozen(t) then R.error("attempt to modify a readonly table", 0) end
	for i = #t, 2, -1 do
		local j = 1 + scaleWord(nextWord(st), i)
		t[i], t[j] = t[j], t[i]
	end
end
function RMETHODS.Clone(st)
	return makeRandom({ h = st.h, l = st.l })
end
local R_INDEX, R_EQ, R_TOSTRING, R_NEWINDEX
R_INDEX = function(self, k)
	if R.type(k) ~= "string" then
		R.error(R.fmt("invalid argument #2 (string expected, got %s)", rtype(k)), 2)
	end
	local m = RMETHODS[k]
	if not m then R.error(k .. " is not a valid member of Random", 0) end
	local f = tramp(function(...)
		local nargs = R.select("#", ...)
		local obj = ...
		if nargs == 0 then R.error(R.fmt("missing argument #1 to '%s' (Random expected)", k), 3) end
		local st = RSTATE[obj]
		if not st then R.error(R.fmt("invalid argument #1 to '%s' (Random expected, got %s)", k, rtype(obj)), 3) end
		return m(st, nargs - 1, R.select(2, ...))
	end)
	CFUNCS[f] = true
	CNAME[f] = k
	return f
end
R_NEWINDEX = function(_, k) R.error(R.tostring(k) .. " is not a valid member of Random", 0) end
R_EQ = function(a, b)
	local x, y = RSTATE[a], RSTATE[b]
	return x ~= nil and y ~= nil and x.h == y.h and x.l == y.l
end
R_TOSTRING = function() return "Random" end
function makeRandom(st)
	local p = R.newproxy(true)
	local mt = R.getmetatable(p)
	mt.__index = R_INDEX
	mt.__newindex = R_NEWINDEX
	mt.__eq = R_EQ
	mt.__tostring = R_TOSTRING
	mt.__type = "Random"
	mt.__metatable = "The metatable is locked"
	RSTATE[p] = st
	return p
end
RANDOM_STATE = RSTATE
local function newRandom(...)
	local seed = ...
	if seed == nil then
		seed = R.floor(os.clock() * 1e6)
	else
		local n = R.tonumber(seed)
		if R.type(seed) ~= "number" and not (R.type(seed) == "string" and n) then
			R.error(R.fmt("invalid argument #1 to 'new' (number expected, got %s)", rtype(seed)), 3)
		end
		seed = n
	end
	local st = { h = 0, l = 0 }
	seedState(st, seed)
	return makeRandom(st)
end
E.Random = table.freeze({ new = nativeFn("Random.new", newRandom) })
if NATIVE and not CFG.fake_random then E.Random = REAL_G.Random end
if CFG.random_probe then
	local inner = E.Random
	E.Random = R.setmetatable({}, { __index = function(_, k) R.print("[Random.index]", R.tostring(k)); return inner[k] end,
		__iter = function() R.print("[Random.iter]"); return R.next, inner end })
end
end
-- Vector3 members on the native vector type. Roblox's engine gives vectors a
-- metatable with Magnitude, Unit, Dot, Cross, ...; stock luau.exe freezes an
-- x/y/z-only one, so bin/luau.exe is built by build_luau.py with it writable
-- (on a stock build this is skipped and `v:Dot(w)` fails). Messages and
-- behaviour match Studio: "Foo is not a valid member of Vector3", a fresh
-- [C] closure per method index, locked metatable, float32 results.
-- (X/Y/Z/x/y/z never get here: the VM reads them before the metatable.)
do
	local VMT = R.getmetatable(vector.create(0, 0, 0))
	if not NATIVE and R.type(VMT) == "table" and not table.isfrozen(VMT) then
		local vdot, vcross, vmag, vnorm, vlerp, vangle = vector.dot, vector.cross, vector.magnitude,
			vector.normalize, vector.lerp, vector.angle
		local fbuf = buffer.create(4)
		local function f32(x)
			buffer.writef32(fbuf, 0, x)
			return buffer.readf32(fbuf, 0)
		end
		local function vtype(v)
			if R.type(v) == "vector" then return "Vector3" end
			if v == nil then return "nil" end
			if isP(v) then return INFO[v].tname end
			return R.typeof(v)
		end
		local function isVec(v) return R.type(v) == "vector" end
		local function isVecP(v) return isP(v) and INFO[v].tname == "Vector3" end
		-- method k: arity check + impl(self, n, ...); errors are raised at
		-- level 5 (check -> method -> impl -> trampoline -> caller)
		local function vecArg(v, i, n)
			if isVec(v) then return v end
			if i > n then R.error(R.fmt("missing argument #%d (Vector3 expected)", i), 5) end
			R.error(R.fmt("invalid argument #%d (Vector3 expected, got %s)", i, vtype(v)), 5)
		end
		local function numArg(v, i, n)
			local x = R.tonumber(v)
			if R.type(v) == "number" or (R.type(v) == "string" and x) then return x end
			if i > n then R.error(R.fmt("missing argument #%d (number expected)", i), 5) end
			R.error(R.fmt("invalid argument #%d (number expected, got %s)", i, vtype(v)), 5)
		end
		local function fuzzy(a, n, b, eps)
			b = vecArg(b, 2, n)
			eps = R.type(eps) == "number" and eps or 1e-5
			for _, c in { "x", "y", "z" } do
				local x, y = a[c], b[c]
				local m = math.max(1, math.abs(x), math.abs(y))
				if not (math.abs(x - y) <= eps * m) then return false end
			end
			return true
		end
		local function minmax(f)
			return function(a, n, ...)
				local args = { ... }
				if n < 2 then vecArg(nil, 2, n) end
				for i = 1, n - 1 do vecArg(args[i], i + 1, n) end
				return f(a, ...)
			end
		end
		local VMETHODS = {
			Dot = function(a, n, b) return vdot(a, vecArg(b, 2, n)) end,
			Cross = function(a, n, b) return vcross(a, vecArg(b, 2, n)) end,
			Lerp = function(a, n, b, t) return vlerp(a, vecArg(b, 2, n), numArg(t, 3, n)) end,
			FuzzyEq = fuzzy,
			Angle = function(a, n, b, axis)
				b = vecArg(b, 2, n)
				if axis ~= nil then return f32(vangle(a, b, vecArg(axis, 3, n))) end
				return f32(vangle(a, b))
			end,
			Abs = function(a) return vector.abs(a) end,
			Floor = function(a) return vector.floor(a) end,
			Ceil = function(a) return vector.ceil(a) end,
			Sign = function(a) return vector.sign(a) end,
			Max = minmax(vector.max),
			Min = minmax(vector.min),
		}
		VMETHODS.lerp = VMETHODS.Lerp
		VMETHODS.isClose = fuzzy
		local VPROPS = {
			Magnitude = vmag, magnitude = vmag, Unit = vnorm, unit = vnorm,
			X = function(v) return v.x end, Y = function(v) return v.y end, Z = function(v) return v.z end,
		}
		VPROPS.x, VPROPS.y, VPROPS.z = VPROPS.X, VPROPS.Y, VPROPS.Z
		VMT.__index = function(self, k)
			if R.type(k) ~= "string" then
				R.error(R.fmt("invalid argument #2 (string expected, got %s)", vtype(k)), 2)
			end
			local prop = VPROPS[k]
			if prop then return prop(self) end
			local m = VMETHODS[k]
			if not m then R.error(k .. " is not a valid member of Vector3", 0) end
			local f = tramp(function(...)
				local n = R.select("#", ...)
				local obj = ...
				if not isVec(obj) then
					if n == 0 then R.error(R.fmt("missing argument #1 to '%s' (Vector3 expected)", k), 3) end
					R.error(R.fmt("invalid argument #1 to '%s' (Vector3 expected, got %s)", k, vtype(obj)), 3)
				end
				-- a symbolic Vector3 argument: let the proxy build the call's expression
				for i = 2, n do
					if isVecP((R.select(i, ...))) then
						local sp = exprP(fmt(obj), "Vector3")
						return sp[k](sp, R.select(2, ...))
					end
				end
				return m(obj, n, R.select(2, ...))
			end)
			CFUNCS[f] = true
			CNAME[f] = k
			return f
		end
		VMT.__newindex = function(_, k)
			if VPROPS[k] then R.error(R.tostring(k) .. " cannot be assigned to", 0) end
			R.error(R.tostring(k) .. " is not a valid member of Vector3", 0)
		end
		VMT.__metatable = "The metatable is locked"
		table.freeze(VMT)
	end
end
E.Enum = newP({ kind = "name", name = "Enum", tname = "Enums" })
enumRoot = E.Enum

---------------------------------------------------------------------------
-- executor API + anti-tamper camouflage
-- Luraph probes the environment (identifyexecutor, iscclosure(print), ...)
-- and silently spins forever when something looks off, so every function we
-- hand out must look like a native C function.
---------------------------------------------------------------------------
local function markC(tbl, seen)
	seen = seen or {}
	if seen[tbl] then return end
	seen[tbl] = true
	for k, v in R.pairs(tbl) do
		if R.type(v) == "function" then
			CFUNCS[v] = true
			if CNAME[v] == nil and R.type(k) == "string" then CNAME[v] = k end
		elseif R.type(v) == "table" and v ~= ENV then
			markC(v, seen)
		end
	end
end
local function isC(f)
	if CFUNCS[f] then return true end
	return R.type(f) == "function" and debug.info(f, "s") == "[C]"
end

local EXECUTOR = CFG.executor or "Wave"
E.identifyexecutor = function()
	comment("identifyexecutor() -> " .. quote(EXECUTOR))
	return EXECUTOR, "1.0.0"
end
E.getexecutorname = function(...) return E.identifyexecutor(...) end
E.iscclosure = function(f)
	if CFG.trace or CFG.ptrace then R.print("[iscclosure]", f, isC(f)) end
	if isP(f) then return true end
	return isC(f)
end
E.islclosure = function(f)
	if CFG.trace or CFG.ptrace then R.print("[islclosure]", f, isC(f)) end
	if isP(f) then return false end
	return R.type(f) == "function" and not isC(f)
end
E.isexecutorclosure = function(f) return false end
E.checkclosure = function(...) return E.isexecutorclosure(...) end
E.newcclosure = function(f)
	CFUNCS[f] = true
	return f
end
E.newlclosure = function(f) return f end
E.clonefunction = function(f) return f end
E.checkcaller = function() return true end
-- hook checks (a truthy stand-in would make scripts run their LPH_CRASH spin)
-- but true for a function the script hooked itself (Script42 hooks print, checks)
do
	local hooked = R.setmetatable({}, { __mode = "k" })
	E.isfunctionhooked = function(f) return hooked[f] == true end
	E.restorefunction = function(f) hooked[f] = nil end
	E.hookfunction = function(target, repl)
		emit({ text = "hookfunction(" .. fmt(target) .. ", " .. fmt(repl) .. ")" })
		if R.type(target) == "function" then hooked[target] = true end
		return target
	end
end
E.ishooked = function(...) return E.isfunctionhooked(...) end
E.replaceclosure = function(...) return E.hookfunction(...) end
E.hookmetamethod = function(obj, method, repl)
	emit({ text = "hookmetamethod(" .. fmt(obj) .. ", " .. fmt(method) .. ", " .. fmt(repl) .. ")" })
	return function(...) return nil end
end
E.getnamecallmethod = function() return "FireServer" end
E.setreadonly = function() end
E.makewritable = function() end
E.makereadonly = function() end
E.isreadonly = function(t) return table.isfrozen(t) end
E.setclipboard = function(s) emit({ text = "setclipboard(" .. fmt(s) .. ")" }) end
E.toclipboard = function(...) return E.setclipboard(...) end
E.fireproximityprompt = function(...) emit({ text = "fireproximityprompt(" .. fmtArgs(...) .. ")" }) end
E.firetouchinterest = function(...) emit({ text = "firetouchinterest(" .. fmtArgs(...) .. ")" }) end
E.fireclickdetector = function(...) emit({ text = "fireclickdetector(" .. fmtArgs(...) .. ")" }) end
E.isfile = function(p) comment("isfile(" .. fmt(p) .. ") -> false"); return false end
E.isfolder = function(p) comment("isfolder(" .. fmt(p) .. ") -> false"); return false end
E.readfile = function(p) return callP("readfile(" .. fmt(p) .. ")", "contents", "string") end
E.writefile = function(p, c) emit({ text = "writefile(" .. fmt(p) .. ", " .. fmt(c) .. ")" }) end
E.appendfile = function(p, c) emit({ text = "appendfile(" .. fmt(p) .. ", " .. fmt(c) .. ")" }) end
E.makefolder = function(p) emit({ text = "makefolder(" .. fmt(p) .. ")" }) end
E.delfile = function(p) emit({ text = "delfile(" .. fmt(p) .. ")" }) end
E.listfiles = function(p) return {} end
E.getconnections = function(sig) return {} end
E.gethui = function() return callP("gethui()", "hui") end
E.cloneref = function(x) return x end
E.compareinstances = function(a, b) return a == b end
E.getcustomasset = function(p) return "rbxasset://" .. R.tostring(p) end
E.queue_on_teleport = function(s) emit({ text = "queue_on_teleport(" .. fmt(s) .. ")" }) end
E.queueonteleport = function(...) return E.queue_on_teleport(...) end
local function httpRequest(label)
	return function(...)
		local opts = ...
		-- a C function: bad arguments raise a typed error (Script42 calls request()
		-- 197 coroutines deep and checks the message for "C stack overflow")
		if R.type(opts) ~= "table" then
			argError(1, R.match(label, "([%w_]+)$"), "table", ...)
		end
		if R.type(opts.Url) == "string" then remember(urls, opts.Url) end
		return callP(label .. "(" .. fmt(opts) .. ")", "response", "table")
	end
end
E.request = httpRequest("request")
E.http_request = httpRequest("http_request")
E.http = { request = httpRequest("http.request") }
E.getrawmetatable = function(x)
	if GENVNAME[x] then return nil end
	if isP(x) then
		return { __index = function() end, __newindex = function() end, __namecall = function() end }
	end
	return R.getmetatable(x)
end
E.setrawmetatable = function(x, mt) return x end
E.getgc = function() return {} end
E.getreg = function() return {} end
E.getloadedmodules = function() return {} end
E.getrunningscripts = function() return {} end
E.getscripts = function() return {} end
E.getinstances = function() return {} end
E.getnilinstances = function() return {} end
E.getscriptclosure = function() return function() end end
E.getsenv = function() return {} end
E.getcallingscript = function() return E.script end
E.getthreadidentity = function() return 8 end
E.getidentity = function(...) return E.getthreadidentity(...) end
E.getthreadcontext = function(...) return E.getthreadidentity(...) end
E.setthreadidentity = function() end
E.setidentity = function() end
E.lz4compress = function(s) return s end
E.lz4decompress = function(s) return s end
E.crypt = { base64encode = function(s) return s end, base64decode = function(s) return s end }
E.base64_encode = E.crypt.base64encode
E.base64_decode = E.crypt.base64decode
E.Drawing = { new = function(kind) return callP("Drawing.new(" .. fmt(kind) .. ")", R.type(kind) == "string" and kind or "drawing") end }
E.isrbxactive = function() return true end
E.isgameactive = function(...) return E.isrbxactive(...) end

-- debug.info must not reveal our Lua wrappers
local realInfo = debug.info
local HARNESS_SRC = realInfo(1, "s")
local fakeDebug = {}
for k, v in R.pairs(debug) do fakeDebug[k] = v end

local function isHarness(f)
	return R.type(f) == "function" and realInfo(f, "s") == HARNESS_SRC
end

-- The stack as the script would see it in Roblox: every run of harness frames
-- (plus the C functions they call) collapses into the one public function the
-- script actually called, which then looks like a C function.
local function visibleStack(th, from)
	local frames = {}
	local lvl = from
	while true do
		local f
		if th then f = realInfo(th, lvl, "f") else f = realInfo(lvl, "f") end
		if f == nil then
			-- level exists but has no function? stop when the level is out of range
			local src
			if th then src = realInfo(th, lvl, "s") else src = realInfo(lvl, "s") end
			if src == nil then break end
		end
		R.insert(frames, { f = f, lvl = lvl })
		lvl += 1
	end
	local out = {}
	local i = 1
	while i <= #frames do
		local fr = frames[i]
		local harness = isHarness(fr.f)
		if not harness and realInfo(fr.f or print, "s") == "[C]" then
			-- a C function called from harness code is an implementation detail
			local j = i
			while j <= #frames and not isHarness(frames[j].f) and realInfo(frames[j].f or print, "s") == "[C]" do
				j += 1
			end
			if j <= #frames and isHarness(frames[j].f) then
				i = j
				harness = true
				fr = frames[i]
			end
		end
		if harness then
			-- skip to the outermost harness frame of this run
			while i + 1 <= #frames and isHarness(frames[i + 1].f) do
				i += 1
			end
			R.insert(out, { f = frames[i].f, fake = true, lvl = frames[i].lvl })
		else
			R.insert(out, { f = fr.f, lvl = fr.lvl })
		end
		i += 1
	end
	return out
end

local function fakeFields(f, opts)
	local out = {}
	for ch in string.gmatch(opts, ".") do
		if ch == "s" then R.insert(out, "[C]")
		elseif ch == "l" then R.insert(out, -1)
		elseif ch == "n" then R.insert(out, CNAME[f] or "")
		elseif ch == "a" then R.insert(out, 0); R.insert(out, true)
		elseif ch == "f" then R.insert(out, f) end
	end
	return R.unpack(out)
end

local info0
fakeDebug.info = function(a, b, c)
	if CFG.ptrace then
		local r = table.pack(info0(a, b, c, 1))
		local t = {}
		for i = 1, r.n do t[i] = R.tostring(r[i]) end
		R.print("[debug.info]", R.type(a) == "function" and (CNAME[a] or FNAME[a] or R.tostring(a)) or R.tostring(a), b, c, "->", R.concat(t, ", ", 1, r.n))
		return R.unpack(r, 1, r.n)
	end
	return info0(a, b, c, 1)
end
CFUNCS[fakeDebug.info] = true
CNAME[fakeDebug.info] = "info"
function info0(a, b, c, extra)
	if R.type(a) == "function" then
		if CFUNCS[a] or isHarness(a) then return fakeFields(a, b) end
		return realInfo(a, b)
	end
	local th, level, opts = nil, a, b
	if R.type(a) == "thread" then th, level, opts = a, b, c end
	if R.type(level) ~= "number" then
		if CFG.debug_stack and isP(a) then R.print("[debug.info on proxy]", INFO[a].kind, INFO[a].key, INFO[a].hint) end
		return realInfo(a, b, c)
	end
	-- level 1 is our caller: real level 2 from here (or 1 for another thread)
	local stack = visibleStack(th, th and 0 or 3 + (extra or 0))
	local fr = stack[th and level + 1 or level]
	if CFG.debug_stack then
		local parts = {}
		for i, x in stack do
			parts[i] = (x.fake and "*" or "") .. R.tostring(CNAME[x.f] or x.f) .. "@" .. R.tostring(realInfo(x.f or print, "s"))
			if i > 6 then break end
		end
		local raw = {}
		for l = 2, 9 do
			local f = realInfo(l, "f")
			raw[#raw + 1] = R.tostring(CNAME[f] or f) .. "@" .. R.tostring(realInfo(l, "s"))
		end
		R.print("[stack] level", level, opts, "->", R.concat(parts, " | "), "\n   raw:", R.concat(raw, " | "))
	end
	if level == 0 and not th then
		return fakeFields(fakeDebug.info, opts)
	end
	if not fr then return nil end
	if fr.fake then return fakeFields(fr.f, opts) end
	if th then return realInfo(th, fr.lvl, opts) end
	-- fr.lvl was counted from inside visibleStack, one frame deeper than here
	return realInfo(fr.lvl - 1, opts)
end

fakeDebug.traceback = function(a, b, c)
	local tb = debug.traceback(a, b, c)
	if R.type(tb) ~= "string" then return tb end
	local keep = {}
	for line in string.gmatch(tb, "[^\n]+") do
		if not R.find(line, HARNESS_SRC, 1, true) then R.insert(keep, line) end
	end
	return R.concat(keep, "\n")
end
-- functions every Roblox script sees in debug (not in the stand-alone Luau)
do
	local memcat = "Default"
	if fakeDebug.profilebegin == nil then fakeDebug.profilebegin = function(label)
		if R.type(label) ~= "string" then R.error("invalid argument #1 to 'profilebegin' (string expected, got " .. R.typeof(label) .. ")", 2) end
	end end
	if fakeDebug.profileend == nil then fakeDebug.profileend = function() end end
	if fakeDebug.setmemorycategory == nil then fakeDebug.setmemorycategory = function(tag)
		if R.type(tag) ~= "string" then R.error("invalid argument #1 to 'setmemorycategory' (string expected, got " .. R.typeof(tag) .. ")", 2) end
		local old = memcat
		memcat = tag
		return old
	end end
	if fakeDebug.resetmemorycategory == nil then fakeDebug.resetmemorycategory = function() memcat = "Default" end end
	if fakeDebug.getmemorycategory == nil then fakeDebug.getmemorycategory = function() return memcat end end
end
E.debug = fakeDebug

E.getmetatable = function(...)
	if GENVNAME[(...)] then return nil end
	return R.getmetatable(...)
end
CFUNCS[E.getmetatable] = true
CNAME[E.getmetatable] = "getmetatable"

if CFG.oplog then
	local ring, pos, N = {}, 0, CFG.oplog
	E.__OPLOG = function(loop, op, pc)
		pos += 1
		ring[pos % N] = loop .. " op=" .. op .. " pc=" .. pc
	end
	E.__SEEN = {}
	do
		local co = {}
		for k, f in R.pairs(coroutine) do
			co[k] = function(...)
				local res = table.pack(f(...))
				local a = {}
				for i = 1, R.select("#", ...) do a[i] = E.__NAME((R.select(i, ...))) end
				local r = {}
				for i = 1, res.n do r[i] = E.__NAME(res[i]) end
				pos += 1
				ring[pos % N] = "CO coroutine." .. k .. "(" .. R.concat(a, ", ") .. ") -> " .. R.concat(r, ", ")
				return R.unpack(res, 1, res.n)
			end
		end
		E.coroutine = co
	end
	local PIDS, npid = {}, 0
	E.__OPL = function(loop, op, pc, proto)
		local id = PIDS[proto]
		if not id then
			npid += 1
			id = npid
			PIDS[proto] = id
			pos += 1
			ring[pos % N] = "NEWPROTO P" .. id .. " " .. R.tostring(proto)
		end
		pos += 1
		ring[pos % N] = "P" .. id .. " L" .. loop .. " op" .. op .. " pc" .. pc
	end
	E.__OPV = function(v, pc)
		pos += 1
		ring[pos % N] = "  = " .. E.__NAME(v)
	end
	local names = nil
	E.__NAME = function(v)
		if not names then
			names = {}
			for k, x in R.pairs(E) do
				if R.type(x) == "function" then names[x] = k
				elseif R.type(x) == "table" and x ~= ENV then
					for k2, y in R.pairs(x) do
						if R.type(y) == "function" then names[y] = k .. "." .. R.tostring(k2) end
					end
				end
			end
		end
		if names[v] then return names[v] end
		local t = R.type(v)
		if t == "string" then return R.fmt("%q", R.sub(v, 1, 80)) end
		if isP(v) then return "<proxy " .. R.tostring(INFO[v].name or INFO[v].hint) .. ">" end
		return R.tostring(v)
	end
	E.__DUMP = function(label, t, depth)
		depth = depth or 0
		local function d(v, lvl)
			if R.type(v) ~= "table" or lvl > 2 then return E.__NAME(v) end
			local parts = {}
			for k, x in R.pairs(v) do
				R.insert(parts, "[" .. E.__NAME(k) .. "]=" .. d(x, lvl + 1))
				if #parts > 80 then break end
			end
			return "{" .. R.concat(parts, ", ") .. "}"
		end
		R.print("[dump]", label, d(t, 0))
	end
	E.__OPDUMP = function()
		for i = R.max(1, pos - N + 1), pos do
			R.print(ring[i % N])
		end
	end
end

if CFG.flip_probe then
	E.__P = { n = 0 }
end

if CFG.inline_probe then
	E.__R = table.create(1e6)
	E.__P = { n = 0 }
	E.__OPDUMP = function()
		local names = {}
		for k, x in R.pairs(E) do
			if R.type(x) == "function" then names[x] = k
			elseif R.type(x) == "table" and x ~= ENV then
				for k2, y in R.pairs(x) do
					if R.type(y) == "function" then names[y] = k .. "." .. R.tostring(k2) end
				end
			end
		end
		local function nm(v)
			if names[v] then return names[v] end
			if R.type(v) == "string" then return R.fmt("%q", R.sub(v, 1, 80)) end
			if isP(v) then
				local chain, q, guard = {}, v, 0
				while q and guard < 12 do
					guard += 1
					local qi = INFO[q]
					R.insert(chain, 1, R.tostring(qi.name or qi.key or qi.hint or qi.kind))
					q = qi.parent
				end
				return "<proxy " .. R.concat(chain, ".") .. ">"
			end
			return R.tostring(v)
		end
		local rr = E.__R
		for i = R.max(1, #rr - (CFG.dump_last or 1500000)), #rr do
			local e = rr[i]
			if R.type(e) == "number" then
				local pc = e % 65536
				local rest = (e - pc) / 65536
				local op = rest % 256
				rest = (rest - op) / 256
				local loop = rest % 16
				local pid = (rest - loop) / 16
				R.print("P" .. pid .. " L" .. loop .. " op" .. op .. " pc" .. pc)
			else
				R.print("  = " .. nm(e[1]))
			end
		end
	end
end

if CFG.co_log then
	local co = {}
	for k, f in R.pairs(coroutine) do co[k] = f end
	co.resume = function(...)
		local res = table.pack(coroutine.resume(...))
		R.print("[co.resume]", R.unpack(res, 1, res.n))
		return R.unpack(res, 1, res.n)
	end
	E.coroutine = co
end

-- entry hooks inserted by deob.py (see patch_entries)
E.__PID = { n = 0 }
E.__ENT = { n = 0 }
E.__SKIPP = {}
E.__PF = R.setmetatable({}, { __mode = "k" })
E.__PLAST = {}
if CFG.fold ~= false then
	CHAIN.pf, CHAIN.pid, CHAIN.plast = E.__PF, E.__PID, E.__PLAST
end
for _, pid in CFG.skip_protos or {} do E.__SKIPP[pid] = true end
-- spin watchdog (--cfg spin=N): a plugin's rerun after a timeout patches its
-- VM dispatch loop heads with table operations only (`__SPIN.n` counts steps,
-- `__SPIN.f()` runs every SPIN_STEP of them). N checks in a row without a new
-- statement or proxy mean pure VM code spinning forever (a tamper response,
-- or a wait for remote code that is never fetched): the run ends like a
-- budget abort and keeps the trace so far.
if CFG.spin then
	local sw = { n = 0, step = 1048576 }
	local idle, lastS, lastId, lastProgress = 0, -1, -1, nil
	sw.f = function()
		sw.n = 0
		-- VM steps are progress for harness.run_once's stall check (this
		-- watchdog decides when they stop being progress)
		if CFG.heartbeat and R.clock() - (CFG._hb or START) > CFG.heartbeat then
			CFG._hb = R.clock()
			R.print("\0HB\n" .. R.rep(" ", 16384))
		end
		if stmtCount ~= lastS or nextId ~= lastId
			or (CFG.spin_progress and R.type(sw.progress) == "number" and sw.progress ~= lastProgress) then
			idle, lastS, lastId, lastProgress = 0, stmtCount, nextId, sw.progress
			return
		end
		if CHAIN.decodeUntil then
			-- a requested constant is being decoded (dumpProtos): time limit only
			if R.clock() > CHAIN.decodeUntil then
				ABORT_REASON = "constant decode took too long"
				R.error(ABORT, 0)
			end
			return
		end
		idle += 1
		if idle >= CFG.spin then
			ABORT_REASON = ABORT_REASON or "endless loop in the script's own code (no environment access)"
			checkBudget()
		end
	end
	E.__SPIN = sw
end
-- devirtualizer capture (deob.py --devirt): __PA[proto] holds the maker-level
-- values each VM closure uses, recorded once per proto (see patch_entries).
-- CHAIN.dumpProtos() serializes everything reachable from them as one JSON
-- line: {"protos": {pid: {name: value}}, "tables": {id: {...}}, ...}
E.__PA = CFG.devirt and { n = 0 } or false
E.__PK = {}     -- proto -> its first closure (maker hook; see CHAIN callPath)
if E.__PA then
	-- Copy of each proto's number arrays (instructions, operands) when its
	-- first closure is made (`__PA[proto]={}` in the maker runs this
	-- __newindex). The script's own LPH_CRASH() scrambles the arrays of the
	-- proto it runs in; the dump puts the copy back (CHAIN.unscramble).
	local orig = R.setmetatable({}, { __mode = "k" })
	CHAIN.paOrig = orig
	-- One level deeper: VM-wide tables a proto's fields point to (Script42:
	-- `n = {..., [5] = byte buffer, [6] = offsets}`, shared by every proto
	-- of the VM, decrypted region by region by an instruction that then
	-- turns itself into a no-op). Copied when first seen, i.e. untouched.
	local nested = R.setmetatable({}, { __mode = "k" })     -- table/buffer -> copy
	local lazyKeys = R.setmetatable({}, { __mode = "k" })   -- lazy constant table -> keys at creation
	local holders = R.setmetatable({}, { __mode = "k" })    -- proto -> {field key = table holding such data}
	local function numCopy(arr)
		local c, n = {}, 0
		for i, x in R.next, arr do
			if R.type(x) == "number" then c[i] = x; n += 1 end
		end
		return n > 0 and c or nil
	end
	local function snapNested(proto, w)
		if nested[w] == nil then
			if R.type(w) == "buffer" then
				local b = buffer.create(buffer.len(w))
				buffer.copy(b, 0, w)
				nested[w] = b
			else
				nested[w] = numCopy(w) or false
			end
		end
		return nested[w]
	end
	R.setmetatable(E.__PA, { __newindex = function(t, proto, v)
		R.rawset(t, proto, v)
		if R.type(proto) ~= "table" then return end
		local copy = {}
		for key, arr in R.next, proto do
			if R.type(arr) == "table" and arr ~= proto and not copy[arr] then
				local c = numCopy(arr)
				if arr ~= E and R.getmetatable(arr) ~= nil and lazyKeys[arr] == nil then
					-- lazy constants (decoded into the table on first use from the
					-- instruction's operand): the keys it had before any ran
					local keys = {}
					for k in R.next, arr do keys[k] = true end
					lazyKeys[arr] = keys
					c = c or {}
				end
				if c then
					copy[arr] = c
				elseif arr ~= E and R.getmetatable(arr) == nil then
					-- no numbers of its own: a VM-wide table (see `nested`)
					for _, w in R.next, arr do
						if (R.type(w) == "table" and w ~= proto and w ~= arr and w ~= E and R.getmetatable(w) == nil)
							or R.type(w) == "buffer" then
							if snapNested(proto, w) then
								holders[proto] = holders[proto] or {}
								holders[proto][key] = arr
							end
						end
					end
				end
			end
		end
		orig[proto] = copy
	end })
	-- Constants decoded after creation belong to the decoded operands the
	-- restore undoes (the scramble garbled the operands, so which values
	-- they were is lost; each instruction decodes once, though): the dump
	-- lists their keys (CHAIN.lazyLate[t] = {key = true}, "late") and the
	-- devirtualizer uses them for the operand it decodes itself.
	CHAIN.lazyLate = R.setmetatable({}, { __mode = "k" })
	local function restore(copy)
		for arr, c in R.next, copy do
			local keys = lazyKeys[arr]
			if keys and not CHAIN.lazyLate[arr] then
				local late = {}
				for k in R.next, arr do
					if not keys[k] then late[k] = true end
				end
				CHAIN.lazyLate[arr] = late
			end
			for i, x in R.next, c do R.rawset(arr, i, x) end
		end
	end
	-- Scrambled = every entry of every number array of the proto changed, or
	-- 90% of them, mostly to random 32-bit words (a scramble leaves a few entries
	-- equal by chance, Script42: 37 of 31792). In-place decryption only
	-- rewrites instructions that ran, to small opcodes and operands.
	CHAIN.unscramble = function()
		local fixed = 0
		local done, ran, size = {}, {}, {}
		for proto, copy in R.next, orig do
			local arrays, all = 0, true
			size[proto] = 0
			for arr, c in R.next, copy do
				if not lazyKeys[arr] then   -- constants: never scrambled
					local n, same, huge = 0, 0, 0
					for i, x in R.next, c do
						n += 1
						local y = R.rawget(arr, i)
						if y == x then
							same += 1
						elseif R.type(y) == "number" and (y >= 16777216 or y <= -16777216) then
							huge += 1
						end
					end
					if same < n then ran[proto] = true end
					if n > size[proto] then size[proto] = n end
					if n >= 2 then arrays += 1 end
					-- random words, not decoded operands (a function that ran to
					-- the end has nearly all of its instructions decoded)
					if same > 0 and (same > n * 0.1 or huge < (n - same) * 0.8) then all = false end
				end
			end
			if all and arrays >= 2 then
				restore(copy)
				fixed += 1
				done[proto] = true
			end
		end
		-- VM-wide data (a table held by a proto field: Script42's buffer and
		-- offsets, decrypted region by region by an op that then turns into a
		-- no-op) that changed at run time no longer matches restored protos.
		-- If the restored protos are most of the VM's code that ran (Script42:
		-- the scramble hit the main function), the whole VM goes back to how
		-- it was before it ran, which the lifter emulates; otherwise each
		-- restored proto gets its own copy with the data as it was, and the live
		-- protos keep the decrypted data they rely on (fetched.lua: a
		-- 20-instruction function scrambled, LPH_JIT code decoded at run time).
		local users = {}
		for proto, hs in R.next, holders do
			for key, arr in R.next, hs do
				users[arr] = users[arr] or {}
				users[arr][proto] = key
			end
		end
		for arr, set in R.next, users do
			local restored, live = 0, 0
			for p in R.next, set do
				if done[p] then restored += size[p] or 0 elseif ran[p] then live += size[p] or 0 end
			end
			if restored > 0 then
				local whole = restored >= live
				local view = nil
				for k, w in R.next, arr do
					local snap = nested[w]
					local changed = false
					if R.type(w) == "buffer" and snap then
						changed = buffer.tostring(w) ~= buffer.tostring(snap)
					elseif R.type(w) == "table" and snap then
						for i, x in R.next, snap do
							if R.rawget(w, i) ~= x then changed = true break end
						end
					end
					if changed and whole then
						if R.type(w) == "buffer" then
							buffer.copy(w, 0, snap)
						else
							for i, x in R.next, snap do R.rawset(w, i, x) end
						end
					elseif changed then
						local pristine
						if R.type(w) == "buffer" then
							pristine = buffer.create(buffer.len(snap))
							buffer.copy(pristine, 0, snap)
						else
							pristine = {}
							for i, x in R.next, w do pristine[i] = x end
							for i, x in R.next, snap do pristine[i] = x end
						end
						if not view then
							view = {}
							for k2, w2 in R.next, arr do view[k2] = w2 end
						end
						view[k] = pristine
					end
				end
				for p, key in R.next, set do
					if whole and ran[p] and not done[p] and orig[p] then
						restore(orig[p])
						done[p] = true
						fixed += 1
					elseif view and done[p] then
						R.rawset(p, key, view)
					end
				end
			end
		end
		return fixed
	end
end
do
	local LIBS = { "string", "table", "math", "bit32", "buffer", "coroutine", "utf8", "os", "debug", "task" }
	CHAIN.dumpProtos = function()
		local PA = E.__PA
		if not PA then return nil end
		CHAIN.unscrambled = CHAIN.unscramble()
		local fname = {}
		for k, v in R.next, E do
			if R.type(v) == "function" and R.type(k) == "string" then fname[v] = fname[v] or k end
		end
		for _, lib in R.ipairs(LIBS) do
			local t = R.rawget(E, lib)
			if R.type(t) == "table" then
				for k, v in R.next, t do
					if R.type(v) == "function" then fname[v] = fname[v] or (lib .. "." .. R.tostring(k)) end
				end
			end
		end
		local stop = { [E] = "ENV" }
		for _, lib in R.ipairs(LIBS) do
			local t = R.rawget(E, lib)
			if R.type(t) == "table" then stop[t] = lib end
		end
		local ids, queue, fids = {}, {}, {}
		local nfid = 0
		local function hex(s)
			return (R.gsub(s, ".", function(c) return R.fmt("%02x", R.byte(c)) end))
		end
		local function num(x)
			if x ~= x then return '{"num":"nan"}' end
			if x == R.huge then return '{"num":"inf"}' end
			if x == -R.huge then return '{"num":"-inf"}' end
			if x == 0 and 1 / x < 0 then return '{"num":"-0"}' end
			if x == R.floor(x) and x > -2 ^ 53 and x < 2 ^ 53 then return R.fmt("%d", x) end
			return R.fmt("%.17g", x)
		end
		local function enc(v)
			local t = R.type(v)
			if v == nil then return "null"
			elseif t == "boolean" then return v and "true" or "false"
			elseif t == "number" then return num(v)
			elseif t == "string" then return '{"s":"' .. hex(v) .. '"}'
			elseif t == "function" then
				if fname[v] then return '{"f":"' .. fname[v] .. '"}' end
				if not fids[v] then nfid += 1; fids[v] = nfid end
				-- a VM closure: its proto (the devirtualizer lifts it as a closure)
				local pf = R.rawget(E.__PF, v)
				if R.type(pf) == "table" then
					return '{"lf":' .. fids[v] .. ',"pf":' .. enc(pf) .. '}'
				end
				if CFG.lf_debug then
					local na, va = debug.info(v, "a")
					R.print("LFDBG", fids[v], debug.info(v, "l"), na, va, debug.info(v, "n"))
				end
				return '{"lf":' .. fids[v] .. '}'
			elseif t == "table" then
				if stop[v] then return '{"g":"' .. stop[v] .. '"}' end
				if not ids[v] then
					R.insert(queue, v)
					ids[v] = #queue
				end
				return '{"t":' .. ids[v] .. "}"
			elseif R.typeof(v) == "buffer" then
				return '{"b":"' .. hex(buffer.tostring(v)) .. '"}'
			elseif t == "vector" then
				return '{"vec":[' .. num(v.x) .. "," .. num(v.y) .. "," .. num(v.z) .. "]}"
			end
			-- engine values (proxies, datatypes): how the trace would write them
			local ok, src = R.pcall(function() return CHAIN.exprOf and CHAIN.exprOf(v) end)
			if not ok or R.type(src) ~= "string" then
				ok, src = R.pcall(R.tostring, v)
			end
			return '{"u":"' .. R.typeof(v) .. '","src":"' .. (ok and R.type(src) == "string" and hex(src) or "") .. '"}'
		end
		-- constants are decoded lazily by an __index metamethod on the proto's
		-- arrays, so code that never ran has none in the raw arrays. The
		-- devirtualizer asks for the slots it needs (CFG.force_req, paths like
		-- "12,U,57" = captured value U of the proto with capture number 12,
		-- index 57; longer paths walk into child protos). Indexing them runs
		-- Luraph's own decoder; this happens after the trace is rendered.
		local forced = {}
		local fstats = { calls = 0, got = 0, t0 = R.clock() }
		CHAIN.forceStats = fstats
		local byseq = {}
		for proto, cap in R.next, PA do
			if R.type(cap) == "table" and cap.__seq then
				byseq[cap.__seq] = R.setmetatable({ self = proto }, { __index = cap })
			end
		end
		-- Decoding on request runs Luraph's own code, which decrypts shared VM
		-- state in place as a side effect (string offsets, bytes). Snapshot
		-- everything reachable from the protos now and restore it before the
		-- dump: only the requested constants may stay (re-inserted below),
		-- or the next lifting round would decrypt those bytes a second time.
		local snapTabs, snapBufs = {}, {}
		if R.type(CFG.force_req) == "string" then
			local q = {}
			for proto, cap in R.next, PA do
				if R.type(cap) == "table" then
					R.insert(q, cap)
					R.insert(q, proto)
				end
			end
			local qi = 1
			while qi <= #q do
				local t = q[qi]
				qi += 1
				if not snapTabs[t] and not stop[t] then
					local copy = {}
					for k, v in R.next, t do
						copy[k] = v
						if R.type(v) == "table" then
							R.insert(q, v)
						elseif R.typeof(v) == "buffer" and not snapBufs[v] then
							snapBufs[v] = buffer.tostring(v)
						end
					end
					snapTabs[t] = copy
				end
			end
		end
		-- string constants the lifter decrypted in place (code that never ran
		-- here): patch the VM buffers while decoding, restore before the dump
		local function applyBufs(bufs)
		local bufRestore = {}
		if R.type(bufs) == "string" then
			for spec in string.gmatch(bufs, "[^;]+") do
				local head = string.match(spec, "^[^/]+")
				local v, si = nil, 0
				for st in string.gmatch(head, "[^,]+") do
					local k = R.tonumber(st) or st
					si += 1
					if si == 1 then v = byseq[k]
					elseif si == 2 and R.type(v) == "table" then v = v[k]
					elseif R.type(v) == "table" then v = R.rawget(v, k)
					else v = nil end
				end
				if R.type(v) == "table" then
					for k, val in string.gmatch(spec, "/=(%-?%d+):([^/]+)") do
						k = R.tonumber(k)
						R.insert(bufRestore, { v, k, R.rawget(v, k), true })
						R.rawset(v, k, R.tonumber(val))
						fstats.bufs = (fstats.bufs or 0) + 1
					end
				elseif R.typeof(v) == "buffer" then
					for off, hx in string.gmatch(spec, "/(%d+):(%x+)") do
						off = R.tonumber(off)
						local n = #hx // 2
						if off + n <= buffer.len(v) then
							R.insert(bufRestore, { v, off, buffer.readstring(v, off, n) })
							fstats.bufs = (fstats.bufs or 0) + 1
							for j = 0, n - 1 do
								buffer.writeu8(v, off + j, R.tonumber(string.sub(hx, 2 * j + 1, 2 * j + 2), 16))
							end
						end
					end
				end
			end
		end
		return bufRestore
		end
		local function revertBufs(bufRestore)
			for i = #bufRestore, 1, -1 do
				local r = bufRestore[i]
				if r[4] then R.rawset(r[1], r[2], r[3]) else buffer.writestring(r[1], r[2], r[3]) end
			end
		end
		local bufRestore = applyBufs(CFG.force_buf)
		-- a path walks from a captured proto: "seq,name,key,...". A step
		-- "slot@v" decodes that lazy slot as if its key-0 operand were v
		-- (the lifter decrypted that instruction; the arrays here are still
		-- encrypted). Such results are not cached in the arrays; a path
		-- through such a step reports its value in fstats.over.
		-- decoding a child proto decrypts its data in place: a second decode
		-- of the same slot would read garbage, so results are shared per prefix
		-- Decoding runs Luraph's decoder, a pure-VM loop: a long constant (a
		-- 200 KB loadstring source) takes more steps than the spin watchdog
		-- allows code without environment access. While decoding, the watchdog
		-- applies a time limit instead (CHAIN.decodeUntil), and an abort
		-- (watchdog, budget) only fails this request, not the later ones.
		local function decodeStart(f, ...)
			CHAIN.decodeUntil = R.clock() + (CFG.decode_limit or 10)
			return f(...)
		end
		local abortBefore
		local function decodeGuard(...)
			CHAIN.decodeUntil = nil
			ABORT_REASON = abortBefore
			return ...
		end
		local function slot(v, k) return v[k] end
		local function decodeSlot(v, k)
			abortBefore = ABORT_REASON
			return decodeGuard(R.pcall(decodeStart, slot, v, k))
		end
		local function decodePath(path, derivedCache, forced)
			local steps, ovs, toks = {}, {}, {}
			for st in string.gmatch(path, "[^,]+") do
				R.insert(toks, st)
				local a, ov = string.match(st, "^(%-?%d+)@(%-?[%d%.e]+)$")
				if a then
					ovs[#steps + 1] = R.tonumber(ov)
					st = a
				end
				R.insert(steps, R.tonumber(st) or st)
			end
			local derived = false
			local v = byseq[steps[1]]
			local prefix = toks[1]
			for si = 2, #steps do
				prefix ..= "," .. toks[si]
				if R.type(v) ~= "table" then v = nil break end
				local k = steps[si]
				local x
				if si == 2 then
					x = v[k]
				elseif ovs[si] ~= nil and derivedCache[prefix] ~= nil then
					derived = true
					x = derivedCache[prefix] or nil
				elseif ovs[si] ~= nil then
					-- Luraph's decoder caches into the array: restore the slot afterwards
					fstats.calls += 1
					derived = true
					local k0 = R.rawget(v, 0)
					local old = R.rawget(v, k)
					local saved
					if R.type(k0) == "table" then
						saved = R.rawget(k0, k)
						R.rawset(k0, k, ovs[si])
					end
					R.rawset(v, k, nil)
					local ok, y = decodeSlot(v, k)
					R.rawset(v, k, old)
					if R.type(k0) == "table" then R.rawset(k0, k, saved) end
					if ok then x = y end
					derivedCache[prefix] = x == nil and false or x
					if CFG.force_debug then
						R.print("FORCEDBG", path, si, R.type(k0), R.tostring(saved), R.tostring(ok), R.tostring(y),
							R.tostring(R.getmetatable(v) ~= nil))
					end
				else
					x = R.rawget(v, k)
					if x == nil and not derived and forced[v] then
						x = forced[v][k]
					end
					if x == nil then
						fstats.calls += 1
						local ok, y = decodeSlot(v, k)
						if CFG.force_debug and not ok then
							R.print("FORCEDBG", path, si, R.tostring(y))
						end
						if ok and y ~= nil then
							x = y
							if not derived then
								forced[v] = forced[v] or {}
								forced[v][k] = y
								fstats.got += 1
							end
						end
					end
				end
				v = x
			end
			return v, derived
		end
		-- "!<proto path, ~ for ,>!<args, / separated>": call a closure of that
		-- proto (it has no upvalues) with constant arguments; "F" is a fresh
		-- table standing for the caller's register frame. -> the entries the
		-- call wrote into it (LPH_ENCSTR-style decryptors store the string in
		-- a caller register). Nil when it fails or returns values.
		local function callPath(path, derivedCache, forced)
			local pp, as = string.match(path, "^!([^!]*)!(.*)$")
			local proto = pp and decodePath((string.gsub(pp, "~", ",")), derivedCache, forced)
			local f = R.type(proto) == "table" and R.rawget(E.__PK, proto)
			if R.type(f) ~= "function" then return nil end
			local args, n, frame = {}, 0, nil
			for a in string.gmatch(as, "[^/]+") do
				n += 1
				local c, rest = string.sub(a, 1, 1), string.sub(a, 2)
				if c == "n" then args[n] = R.tonumber(rest)
				elseif c == "s" then
					args[n] = (R.gsub(rest, "%x%x", function(h) return string.char(R.tonumber(h, 16)) end))
				elseif c == "t" then args[n] = true
				elseif c == "f" then args[n] = false
				elseif c == "F" then frame = frame or {}; args[n] = frame
				end
			end
			if not frame then return nil end
			fstats.calls += 1
			abortBefore = ABORT_REASON
			local res = table.pack(decodeGuard(R.pcall(decodeStart, f, R.unpack(args, 1, n))))
			if not res[1] or res.n > 1 then return nil end
			local out = {}
			for k, v in R.next, frame do
				local t = R.type(v)
				if R.type(k) == "number" and (t == "string" or t == "number" or t == "boolean") then out[k] = v end
			end
			fstats.got += 1
			return out
		end
		local function decodeAny(path, derivedCache, forced)
			if string.sub(path, 1, 1) == "!" then
				return callPath(path, derivedCache, forced), true
			end
			return decodePath(path, derivedCache, forced)
		end
		if R.type(CFG.force_req) == "string" then
			local derivedCache = {}
			for path in string.gmatch(CFG.force_req, "[^;]+") do
				local v, derived = decodeAny(path, derivedCache, forced)
				if derived then
					fstats.over = fstats.over or {}
					R.insert(fstats.over, path .. "=" .. (v ~= nil and enc(v) or "null"))
				end
			end
		end
		revertBufs(bufRestore)
		local function restoreSnap()
			for t, copy in R.next, snapTabs do
				R.pcall(function()      -- (a frozen table cannot have changed)
					local extra = {}
					for k in R.next, t do
						if copy[k] == nil then R.insert(extra, k) end
					end
					for _, k in R.ipairs(extra) do R.rawset(t, k, nil) end
					for k, v in R.next, copy do R.rawset(t, k, v) end
				end)
			end
			for b, s in R.next, snapBufs do
				buffer.writestring(b, 0, s)
			end
		end
		restoreSnap()
		-- the requested constants themselves stay decoded
		for t, kv in R.next, forced do
			for k, v in R.next, kv do R.rawset(t, k, v) end
		end
		local out = {}
		local protos = {}
		for proto, cap in R.next, PA do
			if R.type(proto) ~= "table" then continue end
			local pid = E.__PID[proto]
			local fields = {}
			for k, v in R.next, cap do
				R.insert(fields, '"' .. R.tostring(k) .. '":' .. enc(v))
			end
			local self = enc(proto)
			R.insert(protos, '"' .. (pid and R.tostring(pid) or ("t" .. ids[proto])) .. '":{"self":' .. self .. ","
				.. R.concat(fields, ",") .. "}")
		end
		-- a lazy table's decoder (its __index metamethod, shared by every
		-- table of one constant pool): the devirtualizer reuses a constant
		-- decoded for operand v by any table with the same decoder
		local function mtIndex(t)
			local mt = R.getmetatable(t)
			local f = R.type(mt) == "table" and R.rawget(mt, "__index") or nil
			return R.type(f) == "function" and enc(f) or "null"
		end
		-- every table reachable from the protos (operand arrays, constants, child protos)
		local function tableJson(i, t, forced)
			local view = {}
			for k, v in R.next, t do view[k] = v end
			if forced[t] then
				for k, v in R.next, forced[t] do view[k] = v end
			end
			local maxn, cnt = 0, 0
			for k in R.next, view do
				if R.type(k) == "number" and k >= 1 and k == R.floor(k) and k < 2 ^ 31 then
					cnt += 1
					if k > maxn then maxn = k end
				end
			end
			local dense = maxn > 0 and cnt * 2 >= maxn
			local parts, kv = {}, {}
			if dense then
				for j = 1, maxn do parts[j] = enc(view[j]) end
			end
			for k, v in R.next, view do
				if not (dense and R.type(k) == "number" and k >= 1 and k <= maxn and k == R.floor(k)) then
					R.insert(kv, "[" .. enc(k) .. "," .. enc(v) .. "]")
				end
			end
			local lateKeys = CHAIN.lazyLate and CHAIN.lazyLate[t]
			local late = ""
			if lateKeys then
				local e = {}
				for k in R.next, lateKeys do R.insert(e, enc(k)) end
				late = ',"late":[' .. R.concat(e, ",") .. "]"
			end
			return '"' .. i .. '":{"arr":[' .. R.concat(parts, ",") .. '],"kv":[' .. R.concat(kv, ",") .. "]" .. late
				.. (R.getmetatable(t) ~= nil and (',"mt":true,"mtf":' .. mtIndex(t) .. "}") or "}")
		end
		local tabs = {}
		local i = 1
		while i <= #queue do
			tabs[i] = tableJson(i, queue[i], forced)
			i += 1
		end
		local pidmap = {}
		for proto, pid in R.next, E.__PID do
			if R.type(proto) == "table" and ids[proto] then R.insert(pidmap, '"' .. ids[proto] .. '":' .. pid) end
		end
		local overs = {}
		for _, o in R.ipairs(fstats.over or {}) do
			local path, val = string.match(o, "^([^=]+)=(.*)$")
			R.insert(overs, '["' .. path .. '",' .. val .. "]")
		end
		-- long-lived harness (CHAIN.serve): the next request must start from
		-- the state the script left, like a fresh run, so the re-inserted
		-- constants go too
		if CFG.serve then
			restoreSnap()
			-- live constant requests until the next dump (devirt Dump.fetch):
			-- decoded like force_req, answered with the values and only the
			-- tables this dump does not have (their ids continue its ids). The
			-- decoders' side effects stay until the next dump, which first
			-- restores this snapshot (CHAIN.fetchEnd), as within one dump call.
			-- the patches stay applied for the session: bufs "=" (no change) or
			-- "+<more>" (added to the applied ones), else a full set
			local sessDerived, sessForced, sessBufs = {}, {}, {}
			-- a new reader of the same dump (the final lift after the last
			-- constant round) marks its first request with "*": that answer
			-- carries every table made since the dump (ids are stable), later
			-- ones only the tables made since the previous answer
			local dumpEnd, sentEnd = #queue, #queue
			CHAIN.fetch = function(req, bufs)
				local t0 = R.clock()
				CHAIN.fetchEnd = function()
					revertBufs(sessBufs)
					restoreSnap()
				end
				if string.sub(bufs, 1, 1) == "+" then
					-- more patches: on top of the applied ones (reverted in reverse)
					for _, r in R.ipairs(applyBufs(string.sub(bufs, 2))) do R.insert(sessBufs, r) end
				elseif bufs ~= "=" then
					revertBufs(sessBufs)
					sessBufs = applyBufs(bufs)
				end
				local vals = {}
				local start = sentEnd + 1
				if string.sub(req, 1, 1) == "*" then
					req = string.sub(req, 2)
					start = dumpEnd + 1
				end
				for path in string.gmatch(req, "[^;]+") do
					local ok, v = R.pcall(decodeAny, path, sessDerived, sessForced)
					R.insert(vals, '["' .. path .. '",' .. (ok and v ~= nil and enc(v) or "null") .. "]")
				end
				local parts = {}
				local j = start
				while j <= #queue do
					R.insert(parts, tableJson(j, queue[j], sessForced))
					j += 1
				end
				sentEnd = #queue
				return '{"t":' .. R.fmt("%.4f", R.clock() - t0) .. ',"values":[' .. R.concat(vals, ",") .. '],"tables":{'
					.. R.concat(parts, ",") .. "}}"
			end
		end
		return '{"root_callee":' .. R.tostring(CHAIN.seen and CHAIN.seen[CHAIN.rootCallee] == "ok" and CHAIN.rootCallee or "null") .. ',"overrides":[' .. R.concat(overs, ",") .. '],"protos":{' .. R.concat(protos, ",") .. '},"tables":{' .. R.concat(tabs, ",") ..
			'},"pid_of_table":{' .. R.concat(pidmap, ",") .. "}}"
	end
end
function noteTrigger()
	-- the last entered function is the corruption routine, the one before it
	-- is the trap function that called it
	local ent = E.__ENT
	local routine = ent[ent.n % 64]
	for i = ent.n - 1, R.max(1, ent.n - 63), -1 do
		local q = ent[i % 64]
		if q ~= routine then
			TRIGGER = q
			return
		end
	end
end

markC(E)
CFUNCS[E.debug.info] = true

-- anything else resolves to a named proxy so executor APIs etc. show up
local unknownGlobals = {}
R.setmetatable(ENV, {
	__index = function(_, k)
		if R.type(k) ~= "string" then return nil end
		-- a hash-like name (`_54776ae771af02794d46e80d`) is an obfuscator's
		-- run-once/cache key, never an API: nil, as in a fresh Roblox state
		if #k >= 12 and R.match(k, "^_*%x+$") and R.find(k, "%d") then return nil end
		local p = globalP(k, "function")
		if CFG.ptrace then R.print("[unknown-global]", k) end
		remember(unknownGlobals, k)
		R.rawset(ENV, k, p)
		return p
	end,
})

-- trace mode: log every global read/write the script performs
local traceWrap
local traceCache = {}
local TRACE_NAMES = {}
local function argStr(...)
	local t = {}
	for i = 1, R.select("#", ...) do
		local v = R.select(i, ...)
		t[i] = isP(v) and ("<" .. R.tostring(INFO[v].name or INFO[v].hint) .. ">") or R.tostring(v)
		if TRACE_NAMES[v] then t[i] = "<" .. TRACE_NAMES[v] .. ">" end
		if R.type(v) == "string" then t[i] = R.fmt("%q", R.sub(v, 1, 60)) end
	end
	return R.concat(t, ", ")
end
function traceWrap(label, v)
	if R.type(v) == "function" then
		if traceCache[v] then return traceCache[v] end
		local w = function(...)
			R.print("[call]", label .. "(" .. argStr(...) .. ")")
			local res = table.pack(v(...))
			R.print("   ->", argStr(R.unpack(res, 1, res.n)))
			return R.unpack(res, 1, res.n)
		end
		CFUNCS[w] = CFUNCS[v]
		FNAME[w] = FNAME[v]
		traceCache[v] = w
		return w
	elseif R.type(v) == "table" and v ~= ENV and not traceCache[v] then
		local proxyT = R.setmetatable({}, {
			__index = function(_, k) return traceWrap(label .. "." .. R.tostring(k), v[k]) end,
			__newindex = v,
			__iter = function() return R.next, v end,
		})
		traceCache[v] = proxyT
		return proxyT
	elseif traceCache[v] then
		return traceCache[v]
	end
	return v
end

-- Like a Roblox script environment, what getfenv() hands out is a nearly
-- empty table whose metatable falls through to the globals; Luraph walks it.
if not CFG.flat_env then
	local GLOBALS = ENV
	ENV = R.setmetatable({ script = GLOBALS.script }, { __index = CFG.getlog and function(_, k)
		R.print("[get]", k)
		return GLOBALS[k]
	end or GLOBALS })
end

-- probe mode: log global reads and calls of the non-hot functions only
if CFG.probe then
	local BACK = ENV
	TRACE_NAMES[BACK] = "ENV"
	for k, v in R.pairs(BACK) do
		if R.type(v) == "table" or R.type(v) == "function" then TRACE_NAMES[v] = R.tostring(k) end
	end
	local HOT = { buffer = true, bit32 = true, table = true, string = true, math = true, coroutine = true,
		unpack = true, setmetatable = true, select = true }
	ENV = R.setmetatable({}, {
		__index = function(_, k)
			local v = BACK[k]
			R.print("[get]", k, R.type(v))
			if HOT[k] then return v end
			local w = traceWrap(k, v)
			if w ~= v and R.type(w) ~= "nil" then TRACE_NAMES[w] = R.tostring(k) end
			return w
		end,
		__newindex = function(_, k, v)
			R.print("[set]", k, R.type(v))
			BACK[k] = v
		end,
	})
end

if CFG.trace then
	local BACK = ENV
	TRACE_NAMES[BACK] = "ENV"
	for k, v in R.pairs(BACK) do
		if R.type(v) == "table" or R.type(v) == "function" then TRACE_NAMES[v] = R.tostring(k) end
	end
	ENV = R.setmetatable({}, {
		__metatable = nil,
		__index = function(_, k)
			local v = BACK[k]
			R.print("[get]", k, R.type(v))
			local w = traceWrap(k, v)
			if w ~= v and R.type(w) ~= "nil" then TRACE_NAMES[w] = R.tostring(k) end
			return w
		end,
		__newindex = function(_, k, v)
			R.print("[set]", k, R.type(v))
			BACK[k] = v
		end,
	})
end

---------------------------------------------------------------------------
-- rendering
---------------------------------------------------------------------------
local present = {}
local used = {}
local names = {}
local nameCount = {}

local function sanitize(h)
	h = R.tostring(h or "v")
	h = R.gsub(h, "[^%w_]", "")
	if h == "" or R.match(h, "^%d") then h = "v" .. h end
	if not isIdent(h) then h = h .. "_" end
	return h
end

local function uniqueName(h)
	h = sanitize(h)
	nameCount[h] = (nameCount[h] or 0) + 1
	return nameCount[h] == 1 and h or (h .. nameCount[h])
end

local function scanBlock(block, fn)
	for _, s in block.lines do
		fn(s)
		if s.block then scanBlock(s.block, fn) end
	end
end

local markText
local function markProxy(id)
	local p = BYID[id]
	if not p then return end
	local info = INFO[p]
	if used[id] then return end
	used[id] = true
	if info.parent then markProxy(INFO[info.parent].id) end
	if info.text then markText(info.text) end
	if info.kind == "call" and info.stmt and present[info.stmt] then
		markText(info.stmt.call)
	end
end
function markText(text)
	for id in string.gmatch(text, "\1(%d+)\2") do
		markProxy(R.tonumber(id))
	end
	for fid in string.gmatch(text, "\3(%d+)\4") do
		local rec = FREC[R.tonumber(fid)]
		if rec and not rec.marked then
			rec.marked = true
			local function mark(s)
				if s.text then markText(s.text) end
				if s.call then markText(s.call) end
				if s.header then markText(s.header) end
			end
			scanBlock(rec.block, mark)
			if rec.alt then scanBlock(rec.alt, mark) end
		end
	end
end

local exprOf
local resolve

CHAIN.exprOf = function(p) return exprOf(p) end
function exprOf(p)
	local info = INFO[p]
	if info.kind == "name" then return info.name end
	if info.kind == "index" then return exprOf(info.parent) .. keySuffix(info.key) end
	if info.kind == "expr" then return resolve(info.text, info.indent or 0) end
	if info.kind == "call" then
		if info.var then return info.var end
		return resolve(info.stmt.call, info.indent or 0)
	end
	return "nil"
end

local renderBlock

function resolve(text, ind)
	text = R.gsub(text, "\1(%d+)\2", function(id)
		local p = BYID[R.tonumber(id)]
		if not p then return "nil" end
		INFO[p].indent = ind
		return exprOf(p)
	end)
	local src = text
	text = R.gsub(text, "()\3(%d+)\4", function(pos, fid)
		local rec = FREC[R.tonumber(fid)]
		-- a function inside a multi-line table sits deeper than the statement
		local k = 0
		local ls = 1
		for i = pos - 1, 1, -1 do
			if R.byte(src, i) == 10 then ls = i + 1 break end
		end
		if ls > 1 then
			while R.byte(src, ls + k) == 9 do k += 1 end
		end
		local lines = { "function(" .. R.concat(rec.params, ", ") .. ")" }
		if rec.alt then
			-- two runs (truthy / false): shared lines stay outside the if
			local a, b = {}, {}
			local was = CHAIN.markers
			CHAIN.markers = false
			renderBlock(rec.block, ind + k + 1, a)
			renderBlock(rec.alt, ind + k + 1, b)
			CHAIN.markers = was
			local pad = R.rep("\t", ind + k + 1)
			local function starts(t, i) -- a statement starts on line i (or the block ends)
				local l = t[i]
				return l == nil or (R.sub(l, 1, #pad) == pad and R.byte(l, #pad + 1) ~= 9
					and not R.match(l, "^%s*[%)}]") and not R.match(l, "^%s*end%f[%W]")
					and not R.match(l, "^%s*else"))
			end
			local p = 0
			local common = 0
			while a[common + 1] ~= nil and a[common + 1] == b[common + 1] do
				common += 1
				if starts(a, common + 1) and starts(b, common + 1) then p = common end
			end
			local s = 0
			common = 0
			while common < #a - p and common < #b - p and a[#a - common] == b[#b - common] do
				common += 1
				if starts(a, #a - common + 1) and starts(b, #b - common + 1) then s = common end
			end
			for i = 1, p do R.insert(lines, a[i]) end
			local st = rec.params[1]
			local function shifted(t)
				local out = {}
				for i = p + 1, #t - s do R.insert(out, "\t" .. (R.gsub(t[i], "\n", "\n\t"))) end
				return out
			end
			local sa, sb = shifted(a), shifted(b)
			if #sa > 0 then
				R.insert(lines, pad .. "if " .. st .. " then")
				for _, l in sa do R.insert(lines, l) end
				if #sb > 0 then
					R.insert(lines, pad .. "else")
					for _, l in sb do R.insert(lines, l) end
				end
				R.insert(lines, pad .. "end")
			elseif #sb > 0 then
				R.insert(lines, pad .. "if not " .. st .. " then")
				for _, l in sb do R.insert(lines, l) end
				R.insert(lines, pad .. "end")
			end
			for i = #a - s + 1, #a do R.insert(lines, a[i]) end
		else
			renderBlock(rec.block, ind + k + 1, lines)
		end
		R.insert(lines, R.rep("\t", ind + k) .. "end")
		return R.concat(lines, "\n")
	end)
	return text
end

-- statement markers for fold.py: "--@<lines> <chain>" before each statement
-- (<lines> = how many output lines the statement takes)
function renderBlock(block, ind, out)
	local pad = R.rep("\t", ind)
	for _, s in block.lines do
		local mark = CHAIN.markers and #out + 1
		if mark then R.insert(out, false) end
		if s.header then
			R.insert(out, pad .. resolve(s.header, ind))
			renderBlock(s.block, ind + 1, out)
			R.insert(out, pad .. "end")
		elseif s.call then
			local p = s.res
			local info = p and INFO[p]
			if info and info.var then
				R.insert(out, pad .. "local " .. info.var .. " = " .. resolve(s.call, ind))
			else
				R.insert(out, pad .. resolve(s.call, ind))
			end
		else
			R.insert(out, pad .. resolve(s.text, ind))
		end
		if mark then
			local n = 0
			for i = mark + 1, #out do
				n += 1
				for _ in string.gmatch(out[i], "\n") do n += 1 end
			end
			out[mark] = pad .. "--@" .. n .. " " .. (s.chain or "")
		end
	end
end

local function render()
	CHAIN.markers = CFG.fold ~= false and CHAIN.pf ~= nil
	-- which call statements survived into the output
	local function collect(block)
		for _, s in block.lines do
			if s.call then present[s] = true end
			if s.block then collect(s.block) end
		end
	end
	collect(ROOT)
	for _, rec in FREC do
		collect(rec.block)
		if rec.alt then collect(rec.alt) end
	end
	-- mark everything referenced from the output
	scanBlock(ROOT, function(s)
		if s.text then markText(s.text) end
		if s.call then markText(s.call) end
		if s.header then markText(s.header) end
	end)
	-- give locals to results that are referenced (in creation order)
	for id = 1, nextId do
		local p = BYID[id]
		local info = INFO[p]
		if info.kind == "call" and info.stmt and present[info.stmt] and (used[id] or info.forceVar) then
			info.var = uniqueName(info.hint)
		end
	end
	local out = {}
	renderBlock(ROOT, 0, out)
	return R.concat(out, "\n")
end

---------------------------------------------------------------------------
-- run
---------------------------------------------------------------------------
TRAMP_ENV = ENV
for _, t in TRAMPS do R.setfenv(t, ENV) end
-- the run section is a function so its locals get a fresh register frame:
-- the top-level chunk is at the 200-local limit (Studio enforces it)
local function runMain()
local chunk, cerr = R.loadstring(__SOURCE, "=Script")
local status
if not chunk then
	status = "compile error: " .. R.tostring(cerr)
else
	if CFG.prelude then
		-- --cfg prelude=CODE: runs first (not traced); G = _G, genv = getgenv(),
		-- e.g. "rawset(G, 'webhook', 'x')" for scripts that read settings,
		-- "setprop(game, 'PlaceId', 1)" for properties of engine objects
		local pf = R.loadstring(CFG.prelude, "=prelude")
		R.setfenv(pf, { G = E._G, genv = GENV, rawset = R.rawset, shared = E.shared, game = E.game, env = E,
			setprop = function(p, k, v) INFO[p].props[k] = v end })
		pf()
		-- the prelude's own writes are setup, not script behaviour
		for t, shadow in R.next, CHAIN.genvShadow or {} do
			for k, v in R.next, t do shadow[k] = v end
		end
	end
	if CFG.plugin_rt then
		-- --cfg plugin_rt=CODE (set by a plugin, e.g. ironbrew1's capture.luau):
		-- harness-side code that runs before the script, gets the runtime's
		-- tables and may add CHAIN.endHooks (their output goes into the result block)
		local pf, perr = R.loadstring(CFG.plugin_rt, "=plugin_rt")
		if not pf then R.error("plugin runtime: " .. R.tostring(perr)) end
		pf({ E = E, CHAIN = CHAIN, R = R, CFG = CFG, isP = isP, INFO = INFO })
	end
	-- Roblox's libraries are frozen (Script42 checks isreadonly(math))
	for _, lib in { "string", "math", "table", "os", "debug", "buffer", "utf8", "task", "bit32", "coroutine", "vector" } do
		local t = R.rawget(E, lib)
		if R.type(t) == "table" and not table.isfrozen(t) then table.freeze(t) end
	end
	R.setfenv(chunk, ENV)
	local handler = function(e)
		if e == LOOP or e == ABORT or e == TAMPER then return e end
		return R.tostring(e) .. "\n" .. debug.traceback()
	end
	-- Roblox runs scripts in their own thread; here that thread's globals are ENV
	local runner = coroutine.create(function()
		R.setfenv(0, ENV)
		return R.xpcall(chunk, handler)
	end)
	local rs = table.pack(coroutine.resume(runner))
	if rs[1] and rs[2] == ABORT and coroutine.status(runner) == "suspended" then rs = { false, ABORT, n = 2 } end
	R.pcall(CHAIN.syncGenv)
	local mainOk = rs[1] and rs[2] ~= false or (rs[1] and coroutine.status(runner) == "suspended")
	local r2 = coroutine.create(function()
		R.setfenv(0, ENV)
		if mainOk then runDeferred() end
		runHandlers()
	end)
	coroutine.resume(r2)
	local ok, err
	if not rs[1] then
		ok, err = false, rs[2]
	elseif coroutine.status(runner) == "suspended" then
		ok, err = true, nil
	else
		ok, err = rs[2], rs[3]
	end
	popTo(1)
	if CFG.inline_probe and not ok and err ~= TAMPER and E.__OPDUMP then
		CFG.dump_last = CFG.dump_err or 3000
		E.__OPDUMP()
	end
	if ok then
		status = "finished"
	elseif err == LOOP then
		status = "stopped in an endless loop (truncated)"
	elseif err == ABORT then
		status = "aborted: " .. R.tostring(ABORT_REASON)
	elseif err == TAMPER then
		status = "Luraph anti-tamper triggered in the main thread (run stopped)"
	else
		status = "script error: " .. R.tostring(err)
	end
end

local body = render()
local header = {}
R.insert(header, "-- run status: " .. R.gsub(status, "\n", "\n--   "))
R.insert(header, R.fmt("-- %d statements recorded in %.2fs", stmtCount, R.clock() - START))
if #urls > 0 then
	R.insert(header, "-- URLs requested:")
	for _, u in R.ipairs(urls) do R.insert(header, "--   " .. u) end
end
if #remotes > 0 then
	R.insert(header, "-- remotes fired/invoked:")
	for _, rp in R.ipairs(remotes) do R.insert(header, "--   " .. exprOf(rp)) end
end
if #unknownGlobals > 0 then
	R.insert(header, "-- non-standard globals touched: " .. R.concat(unknownGlobals, ", "))
end

CFG.heartbeat = nil     -- nothing may land inside the output block
R.print("\0ENVLOG-BEGIN")
if R.rawget(E, "__TR") then
	-- research/optrace.py: ring of executed (loop, pc, op) entries
	local tr = E.__TR
	local N = tr.N
	for i = R.max(1, tr.total - N + 1), tr.total do
		R.print("\0TR " .. R.tostring(tr[(i - 1) % N + 1]))
	end
end
if ALLOC_TRIGGER then
	R.print("\0ALLOCTRIGGER " .. R.tostring(ALLOC_TRIGGER.pid) .. " " .. R.tostring(ALLOC_TRIGGER.kind) .. " " .. R.tostring(ALLOC_TRIGGER.n))
end
if TRIGGER then R.print("\0TRIGGER " .. TRIGGER) end
for _, line in R.ipairs(P2D_LOG) do R.print("\0P2D " .. line) end
if P2D_MISS then R.print("\0P2DMISS") end
for _, hook in R.ipairs(CHAIN.endHooks or {}) do
	local ok, text = R.pcall(hook)
	R.print(ok and text or ("\0HOOKERR " .. R.tostring(text)))
end
if CFG.devirt then
	local ok, js = R.pcall(CHAIN.dumpProtos)
	local fs = CHAIN.forceStats
	if fs then
		R.print(R.fmt("\0FORCE calls=%d decoded=%d in %.1fs, %d buffer patches", fs.calls, fs.got,
			R.clock() - fs.t0, fs.bufs or 0))
	end
	if (CHAIN.unscrambled or 0) > 0 then R.print("\0UNSCRAMBLED " .. CHAIN.unscrambled) end
	R.print("\0PROTOS " .. (ok and js or ("error: " .. R.tostring(js))))
end
for _, key in R.ipairs(NEWCHUNKS) do
	R.print("\0CHUNK " .. key)
	R.print((R.gsub(NEWCHUNKS[key], ".", function(c) return R.fmt("%02x", R.byte(c)) end)))
end
R.print(R.concat(header, "\n"))
R.print("")
R.print(body)
if CFG.dump_strings then
	R.print("\0ENVLOG-STRINGS")
	local seen = {}
	for _, s in collected do
		if not seen[s] then
			seen[s] = true
			R.print(quote(s))
		end
	end
end
R.print("\0ENVLOG-END")
if CFG.serve then R.print(SERVE_PAD) end
if NATIVE then
	for _, p in R.pairs(BYID) do
		local r = REALV[p]
		if r ~= nil and R.typeof(r) == "Instance" then R.pcall(r.Destroy, r) end
	end
	return R.concat(OUTBUF, "\n")
end
end
-- --cfg serve (deob.py HarnessServer): a long-lived harness for the constant
-- rounds. The file is require()d from luau.exe's REPL, which reads requests
-- from stdin: it returns CHAIN.serve; `__S("", "", "start")` runs the script
-- once, later calls only repeat the dump for new force_req/force_buf. stdout to a
-- pipe is block-buffered and Luau cannot flush it: SERVE_PAD fills the buffer.
if CFG.serve then
	SERVE_PAD = R.rep(" ", 16384)
	CHAIN.serve = function(req, buf, mode)
		if mode == "start" then
			-- the run itself, from a REPL statement of its own: inside require()
			-- (a C function) the script would start a few C calls deeper than
			-- in a plain run, and a coroutine inherits that depth (Script42
			-- nests 197 coroutine.wrap calls, which then hit "C stack overflow")
			runMain()
			return
		end
		if mode == "fetch" then
			R.print("\0ENVLOG-BEGIN")
			local ok, js = R.pcall(function() return CHAIN.fetch(req, buf) end)
			R.print("\0FETCH " .. (ok and js or ("error: " .. R.tostring(js))))
			R.print("\0ENVLOG-END")
			R.print(SERVE_PAD)
			return
		end
		if CHAIN.fetchEnd then
			CHAIN.fetchEnd()
			CHAIN.fetchEnd = nil
		end
		CHAIN.fetch = nil
		CFG.force_req, CFG.force_buf = req, buf
		R.print("\0ENVLOG-BEGIN")
		local ok, js = R.pcall(CHAIN.dumpProtos)
		local fs = CHAIN.forceStats
		if fs then
			R.print(R.fmt("\0FORCE calls=%d decoded=%d in %.1fs, %d buffer patches", fs.calls, fs.got,
				R.clock() - fs.t0, fs.bufs or 0))
		end
		R.print("\0PROTOS " .. (ok and js or ("error: " .. R.tostring(js))))
		R.print("\0ENVLOG-END")
		R.print(SERVE_PAD)
	end
	return CHAIN.serve
end
return runMain()
]==========],"DEVIL Corvus / native decode")
        assert(run,err);return run()
    end,debug.traceback)
    scope.DevilCorvusCaptureRunning=false
    report.status=ok and"Finished"or"CaptureError"
    raw=type(value)=="string"and value or tostring(value)
    report.bytes=#raw;report.nativeTrace=ok
    if type(writefile)=="function"then
        report.saved=pcall(writefile,report.file,raw)
        pcall(writefile,"DevilCorvus-capture-report.json",http:JSONEncode(report))
    end
    scope.DevilCorvusCaptureText=raw
    label.Text="DEVIL HUB / Corvus\n"..report.status.." · "..report.bytes.." bytes\n"..report.file
    button.Text="คัดลอกผลส่งให้ตรวจ"
    print("DEVIL Corvus capture",report.status,report.file,report.bytes)
end)
return report
