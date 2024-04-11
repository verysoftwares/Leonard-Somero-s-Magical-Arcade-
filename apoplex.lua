-- title:  Apoplex
-- author: verysoftwares
-- desc:   snail tactics game
-- script: lua

function apoplex_reset()
spritesheet_data=love.image.newImageData('wares/apoplex-assets/apoplex-sprites.png')
spritesheet=love.graphics.newImage(spritesheet_data)
spritesheet2=love.graphics.newImage('wares/apoplex-assets/apoplex-sprites2.png')
tic_music={
    love.audio.newSource('wares/apoplex-assets/apoplex-overworld.ogg','stream'),
    -1,
    love.audio.newSource('wares/apoplex-assets/apoplex-title.ogg','stream'),
    -1,
    love.audio.newSource('wares/apoplex-assets/apoplex-enemy.ogg','stream')
}
for i,v in ipairs(tic_music) do if v~=-1 then v:setLooping(true) end end
tic_sfx={
    -1,
    -1,
    -1,
    -1,
    -1,
    love.audio.newSource('wares/apoplex-assets/apostart2.wav','static'),
    love.audio.newSource('wares/apoplex-assets/apostart.wav','static'),
}
mt=t; turn_t=t
--x=-3
--y=0
--z=0
plr={sp=96,ix=0,iy=0,iz=0+3-0.1,stack={},circle={{2,2,4,4}}}
--testnmy={sp=105,ix=4,iy=4,iz=0-3-0.1,stack={},circle={{2,4,2,4}}}--{3,2,1,1}
enemies={i=1}
turn=plr
ap=6

for i=1,14 do
  _G['tutor'..tostring(i)]=nil
end
tutor_msg=nil

ins=table.insert
rem=table.remove
fmt=string.format
sub=string.sub
flr=math.floor
pi=math.pi
cos=math.cos
sin=math.sin

function posstr3(x,y,z)
  return fmt('%d:%d:%d',flr(x),flr(y),flr(z))
end

iso={plr,testnmy}

function ins_iso(tb)
  ins(iso,tb)
  iso[posstr3(tb.ix,tb.iy,tb.iz)]=tb
end

--[[local sp=32--32+((t*0.08)%4)//1*2
for mx=0,-3,-1 do
  --local ix,iy=isopos(mx,0)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=mx,iy=0,iz=0})
end
for my=1,3 do
  --local ix,iy=isopos(0,my)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=0,iy=my,iz=0})
end
for my=1,2 do
  --local ix,iy=isopos(-3,my)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=-3,iy=my,iz=0})
end
for mx=-1,-3,-1 do
  --local ix,iy=isopos(mx,3)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=mx,iy=3,iz=0})
end
for mz=1,3 do
  --local ix,iy=isopos(0,0,mz)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=0,iy=0,iz=mz})
  --ix,iy=isopos(-2,0,mz)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=-2,iy=0,iz=mz})
  --ix,iy=isopos(0,2,mz)
  --spr(sp,ix,iy,0,1,0,0,2,2)
  ins_iso({sp=sp,ix=0,iy=2,iz=mz})
end
]]

cls(0)

--[[for i,obj in ipairs(iso) do
  if obj~=plr and obj~=testnmy then
    obj.sp=32+obj.iy*2
  end
end]]

--stack={}

tape={i=1}

seed=17892+love.math.random(0,2222222)
--seed=374345
trace(fmt('seed %d',seed))
local sx,sy=isopos(plr.ix,plr.iy,plr.iz)
cam={x=sx-32+8,y=sy-32+8,dx=0,dy=0,tgt=plr,tgtx=sx-32+8,tgty=sy-32+8,lock=true}

--[[for i,v in ipairs(iso) do
  if v~=plr then v.sp=32+(v.iz*2)%8 end
end]]

ins_iso({sp=34,ix=0,iy=0,iz=0})
ins_iso({sp=34,ix=1,iy=0,iz=0})
ins_iso({sp=34,ix=2,iy=0,iz=0})
ins_iso({sp=34+4,ix=1,iy=1,iz=0})
ins_iso({sp=34+4,ix=1,iy=2,iz=0})
ins_iso({sp=34+4,ix=2,iy=2,iz=0})
ins_iso({sp=34,ix=3,iy=0,iz=0})
ins_iso({sp=34,ix=3,iy=1,iz=0})
ins(enemies,{sp=198,ix=3,iy=1,iz=0+3-0.1})
ins(iso,enemies[#enemies])
ins_iso({sp=34,ix=3,iy=2,iz=0})
ins_iso({sp=34,ix=4,iy=2,iz=0})
ins_iso({sp=34,ix=5,iy=2,iz=0})
ins(enemies,{sp=105,ix=5,iy=2,iz=0+3-0.1})
ins(iso,enemies[#enemies])
ins_iso({sp=34,ix=6,iy=2,iz=0})
ins_iso({sp=34,ix=7,iy=2,iz=0})
ins_iso({sp=34,ix=7,iy=3,iz=0})
ins_iso({sp=34,ix=7,iy=4,iz=0})
ins_iso({sp=34,ix=7,iy=5,iz=0})
ins(enemies,{sp=105,ix=7,iy=5,iz=0+3-0.1})
ins(iso,enemies[#enemies])
ins_iso({sp=34+4,ix=7,iy=1,iz=0})
ins_iso({sp=34+4,ix=7,iy=0,iz=0})
ins_iso({sp=34+4,ix=7,iy=-1,iz=0})
ins_iso({sp=34+4,ix=8,iy=-1,iz=0})
ins(enemies,{sp=105,ix=8,iy=-1,iz=0+3-0.1})
ins(iso,enemies[#enemies])
ins_iso({sp=34+4,ix=9,iy=-1,iz=1})
ins_iso({sp=34+4,ix=10,iy=-1,iz=2})
ins_iso({sp=34+4,ix=11,iy=-1,iz=2})
ins_iso({sp=34+4,ix=11,iy=0,iz=2})
ins_iso({sp=34+4,ix=11,iy=1,iz=2})
ins_iso({sp=34,ix=8,iy=5,iz=1})
ins_iso({sp=34+4,ix=9,iy=5,iz=2})
ins_iso({sp=34+4,ix=9,iy=4,iz=2})
ins(enemies,{sp=200,ix=9+1,iy=4-1,iz=2+3-0.1})
ins(iso,enemies[#enemies])
ins_iso({sp=34+4,ix=9,iy=3,iz=2})
ins_iso({sp=34+4,ix=10,iy=3,iz=2})
ins_iso({sp=34+4,ix=11,iy=3,iz=2})
ins_iso({sp=34+4,ix=11,iy=2,iz=2})
ins_iso({sp=34-2,ix=12,iy=0,iz=2})
ins_iso({sp=34-2,ix=13,iy=0,iz=2})
ins_iso({sp=34-2,ix=14,iy=0,iz=2})
ins(enemies,{sp=200,ix=14,iy=0,iz=2+3-0.1})
ins(iso,enemies[#enemies])

TIC=apoplex_titlescr
gm_t=t+1
apt=0
st_t=nil
title_t=nil

gamewon=nil
end

function apoplex_update()
  --clip(0,0,64,64)

  if turn_i and t-turn_t>=60 and t-turn_t<120+60 and not (peek(0x13FFC)==4 and enemies.i>2 and turn~=plr) then for ch=0,3 do setvol(ch,flr((120-(t-turn_t-60))/120*15)) end end

  if cam.lock then
  cam.x=cam.x+(cam.tgtx-cam.x)*0.1
  cam.y=cam.y+(cam.tgty-cam.y)*0.1
  end
  
  local moved=false
  local dx,dy=0,0
  local input5=input(5)
  if overworld and not enc_t and not tutor_msg then
    if input(0) then turn.iy=turn.iy-1; dy=-1 end
          if input(1) then turn.iy=turn.iy+1; dy= 1 end
          if input(2) then turn.ix=turn.ix-1; dx=-1 end
          if input(3) then turn.ix=turn.ix+1; dx= 1 end
          if dx~=0 or dy~=0 then moved=true; sortneeded=true; turn.lastdx=dx; turn.lastdy=dy end
        end
  if input(7) and not overworld then cross_sec=not cross_sec; --[[if cross_sec then for i,m in ipairs(act_menu) do if act_menu['yt'..i]>=0 then act_menu['oxt'..i]=act_menu['xt'..i]; act_menu['xt'..i]=-28 end end else for i,m in ipairs(act_menu) do if act_menu['yt'..i]>=0 then act_menu['xt'..i]=act_menu['oxt'..i] end end end]] end
  if input(6) and not overworld then cam.lock=not cam.lock; --[[if not cam.lock then for i,m in ipairs(act_menu) do if act_menu['yt'..i]>=0 then act_menu['oxt'..i]=act_menu['xt'..i]; act_menu['xt'..i]=-28 end end else for i,m in ipairs(act_menu) do if act_menu['yt'..i]>=0 then act_menu['xt'..i]=act_menu['oxt'..i] end end end]] end
  if not cam.lock and turn==plr then
  cam.dx=0; cam.dy=0
        if btn(0) then cam.y=cam.y-2; cam.dy=-2 end
  if btn(1) then cam.y=cam.y+2; cam.dy= 2 end
  if btn(2) then cam.x=cam.x-2; cam.dx=-2 end
  if btn(3) then cam.x=cam.x+2; cam.dx= 2 end
  end
        if t-turn_t>120+60 and not overworld and cam.lock and not tutor_msg then
        if input5 then if #moverange>0 then ap=ap-math.abs(turn.ix-orig_x)-math.abs(turn.iy-orig_y); end; moverange={}; spellrange={}; adjacent={}; if spcur then rem(iso,find(iso,spcur)); spcur=nil end end
  if #moverange==0 and (at==nil or #adjacent==0) and (act_menu==menu or (act_menu~=menu and (act_menu['yt'..act_menu.i]==0 or input5))) and act_menu~=menu_spell and not (act_menu[act_menu.i]=='Circle') and not (act_menu[act_menu.i]=='End') then
    local sel=false
    local sel2=false
    local sel3=false
    for i2,m2 in ipairs(menu) do if (menu['xt'..i2]<0 and (t-mt)<18*2-9) or menu['yt'..i2]<0 then sel=true; break end end
    for i2,m2 in ipairs(act_menu) do if (act_menu['xt'..i2]<0 and (t-mt)<18*2-9) or act_menu['yt'..i2]<0 then sel2=true; break end end
    if input(0) and (not (sel) or (act_menu~=menu and not sel2)) then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i-1; if act_menu.i<1 then act_menu.i=#act_menu end; act_menu['xt'..act_menu.i]=10 end
    if input(1) and (not (sel) or (act_menu~=menu and not sel2)) then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i+1; if act_menu.i>#act_menu then act_menu.i=1 end; act_menu['xt'..act_menu.i]=10 end
    if input(4) and ((not sel) or not sel2) then 
    if (tutor3 and not tutor4 and not (act_menu[act_menu.i]=='Tile' or act_menu[act_menu.i]=='Mine')) or (tutor5 and not tutor10 and not (act_menu[act_menu.i]=='Move')) or (tutor8 and not tutor9 and not (act_menu[act_menu.i]=='Spell')) or (tutor9 and not tutor11 and not (act_menu[act_menu.i]=='Spell')) or (tutor11 and not tutor13 and not (act_menu[act_menu.i]=='Spell')) then
    if not block_frame then tutor_msg='What are you doing?' end
    else
    for i,m in ipairs(act_menu) do if i~=act_menu.i then act_menu['xt'..i]=-28 end end; mt=t end
    end
    if input5 and (sel or sel2) then local submenu=false; if act_menu~=menu then for i2,m2 in ipairs(act_menu) do if act_menu['yt'..i2]<0 then submenu=true; break end end end if act_menu==menu then for i,m in ipairs(menu) do menu['yt'..i]=0; if i~=menu.i then menu['xt'..i]=0 else menu['xt'..i]=10 end; end end for i,m in ipairs(act_menu) do act_menu['yt'..i]=0; if i~=act_menu.i then act_menu['xt'..i]=0 else act_menu['xt'..i]=10 end end; if act_menu==menu and menu[menu.i]=='Move' then moverange={} end; if act_menu~=menu then adjacent={} end; for i2,m2 in ipairs(act_menu) do act_menu['yt'..i2]=0; if i2~=act_menu.i then act_menu['xt'..i2]=0 end end; for i2,m2 in ipairs(act_menu) do if i2~=act_menu.i or act_menu~=menu then act_menu['x'..i2]=-(64-(2)*8); act_menu['y'..i2]=0 end; end; if act_menu~=menu then if not submenu then act_menu=menu; for i,m in ipairs(menu) do if i~=menu.i then menu['xt'..i]=0 end end; menu['yt'..menu.i]=0; trace('menu') else menu['xt'..menu.i]=10 end; end end
  elseif act_menu[act_menu.i]=='End' then
    if input(0) then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i-1; if act_menu.i<1 then act_menu.i=#act_menu end; act_menu['xt'..act_menu.i]=10; clear=true end
    if input(1) then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i+1; if act_menu.i>#act_menu then act_menu.i=1 end; act_menu['xt'..act_menu.i]=10; clear=true end
        if input(4) then if turn==plr and tutorial then
    if not block_frame then tutor_msg='What are you doing?' end
    else 
    ap=0; mt=t
    end end
  elseif act_menu[act_menu.i]=='Circle' then
    local full=true
    for i,c in ipairs(turn.circle) do
      for j=1,4 do
        if c[j]==0xdeadc0de then full=false; goto brk end
      end
    end
    ::brk::
    if full then
      ins(turn.circle,{0xdeadc0de,0xdeadc0de,0xdeadc0de,0xdeadc0de})
    end

    local k,j2=1,nil
    for i,c in ipairs(turn.circle) do
      for j=1,4 do
        if c[j]==0xdeadc0de then
          j2=j
          c['f'..j]=true
          goto brk2
        end
      end
      k=k+1
    end 
    ::brk2::
    turn.circle[k]['f'..j2]=true

    local clear=false
    if input(0) then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i-1; if act_menu.i<1 then act_menu.i=#act_menu end; act_menu['xt'..act_menu.i]=10; clear=true end
    if input(1) then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i+1; if act_menu.i>#act_menu then act_menu.i=1 end; act_menu['xt'..act_menu.i]=10; clear=true end
    if input(4) then
            if tutorial then
            if not block_frame then tutor_msg='What are you doing?' end
      elseif #turn.stack>0 then
      mt=t
      turn.circle[k][j2]=get_circ(turn.stack[#turn.stack])
      rem(turn.stack,#turn.stack)
      add_paws(5,'circle expanded')
      for i,c in ipairs(turn.circle) do for j=1,4 do
        c['f'..j]=nil
      end end
      ap=ap-6
      end
    end
    if input5 then
      clear=true
      menu['yt'..menu.i]=0
      for i,m in ipairs(menu) do if i~=menu.i then menu['xt'..i]=0 end end
      for i,a in ipairs(act_menu) do act_menu['x'..i]=-28 end
      act_menu=menu
    end
    if clear or ap<=0 then
      for i,c in ipairs(turn.circle) do
        for j=1,4 do
          c['f'..j]=nil
        end
      end
      local empty=true
      for j=1,4 do if turn.circle[#turn.circle][j]~=0xdeadc0de then empty=false; break end end
      if empty then rem(turn.circle,#turn.circle) end
    end
  elseif act_menu==menu_spell and not spelltgt then
    local sel=false
    for i,m in ipairs(act_menu) do if act_menu['yt'..i]<0 or (t-mt)<18*2-9 then sel=true; break end end
    local input0=input(0)
    local input1=input(1)
    local input2=input(2)
    local input3=input(3)
    local input4=input(4)
    if input0 and not sel then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i-1; if act_menu.i<1 then act_menu.i=#act_menu end; act_menu['xt'..act_menu.i]=10 end
    if input1 and not sel then act_menu['xt'..act_menu.i]=0; act_menu.i=act_menu.i+1; if act_menu.i>#act_menu then act_menu.i=1 end; act_menu['xt'..act_menu.i]=10 end
    local sdx,sdy=0,0
    if input0 and sel and spcur --[[and spellrange[posstr3(spcur.ix,spcur.iy-1,spcur.iz-3+0.1)]] then spcur.iy=spcur.iy-1; sdy=-1; sortneeded=true end
    if input1 and sdy==0 and sel and spcur --[[and spellrange[posstr3(spcur.ix,spcur.iy+1,spcur.iz-3+0.1)]] then spcur.iy=spcur.iy+1; sdy= 1; sortneeded=true end
    if input2 and sel and spcur --[[and spellrange[posstr3(spcur.ix-1,spcur.iy,spcur.iz-3+0.1)]] then spcur.ix=spcur.ix-1; sdx=-1; sortneeded=true end
    if input3 and sdx==0 and sel and spcur --[[and spellrange[posstr3(spcur.ix+1,spcur.iy,spcur.iz-3+0.1)]] then spcur.ix=spcur.ix+1; sdx= 1; sortneeded=true end
    if sel and spcur then
      local tower=spcur.iz+0.1+2
      local old_iz=spcur.iz
      while not iso[posstr3(spcur.ix,spcur.iy,tower)] do
       tower=tower-1
       spcur.iz=tower+3-0.1
       if tower<0 then spcur.ix=spcur.ix-sdx; spcur.iy=spcur.iy-sdy; spcur.iz=old_iz; break end
      end
      if tower>=0 and not spellrange[posstr3(spcur.ix,spcur.iy,tower)] then spcur.ix=spcur.ix-sdx; spcur.iy=spcur.iy-sdy; spcur.iz=old_iz; end
    end
    if input4 and #spellrange==0 then 
    if (tutor9 and not tutor11 and not (act_menu[act_menu.i]==tutor_sp)) then if not block_frame then tutor_msg='What are you doing?' end 
    else local submenu=false; for i,m in ipairs(act_menu) do if act_menu['yt'..i]<0 then submenu=true; break end end if not submenu then for i,m in ipairs(act_menu) do if i~=act_menu.i then act_menu['xt'..i]=-28 end end end; mt=t end 
    elseif input4 and #spellrange>0 then 
    if turn~=plr then spelltgt=plr else for i,e in ipairs(enemies) do if e.ix==spcur.ix and e.iy==spcur.iy and e.iz==spcur.iz then spelltgt=e; break end end end
    if spelltgt then
    cam.tgt=spelltgt
    local stx,sty=isopos(spelltgt.ix,spelltgt.iy,spelltgt.iz)
    local ptx,pty=isopos(turn.ix,turn.iy,turn.iz)
    local a=math.atan2(sty-pty,stx-ptx) 
    local f
    if a%(2*pi)<pi/2 then f=4 
    elseif a%(2*pi)<pi then f=1
    elseif a%(2*pi)<3*pi/2 then f=2
    else f=3 end
    local brk=false
    local i=#spelltgt.circle
    --for i=#spelltgt.circle,1,-1 do
    --if brk then break end
    ::nextcirc::
    local c=spelltgt.circle[i]
    if (not c) or c[f]==0xdeadc0de then
    i=i-1
    if i>=1 then goto nextcirc end
    --elseif spelltgt.circle[i+1] and spelltgt.circle[i+1][j]==0xdeadc0de then
    --i=i-1
    --if i>=1 then goto nextcirc else i=i+1 end
    else
    --brk=true
    end
    if i>0 then
    c['f'..f]=true
    else
    spelltgt.f=true
    end
    for i,c in ipairs(spelltgt.circle) do
      for j,d in ipairs(c) do
        local j2=j+1; if j2>4 then j2=1 end
        local j3=j-1; if j3<1 then j3=4 end
        --[[if c['f'..j] and d==c[(j+1)%4+1] then
          c['f'..((j+1)%4+1)]=true
        end
        if c['f'..j] and d==c[(j-1)%4+1] then
          c['f'..((j-1)%4+1)]=true
        end]]
        if c['f'..j] and d==c[j2] then
          c['f'..j2]=true
        end
        if c['f'..j] and d==c[j3] then
          c['f'..j3]=true
        end
      end
    end
    end
        end
    if input5 or (input(4) and #act_menu==0) then cam.tgt=turn; if spelltgt then for i,c in ipairs(spelltgt.circle) do for j,d in ipairs(c) do c['f'..j]=nil end end spelltgt=nil end; local origmenu=true; for i,m in ipairs(act_menu) do if act_menu['y'..i]<0 then origmenu=false; break end end; act_menu['y'..act_menu.i]=0; act_menu['yt'..act_menu.i]=0; act_menu['x'..act_menu.i]=-28; act_menu['xt'..act_menu.i]=10; for i2,m2 in ipairs(act_menu) do if i2~=act_menu.i then act_menu['x'..i2]=0; act_menu['xt'..i2]=0 end end menu['xt'..menu.i]=10; if origmenu then menu['yt'..menu.i]=0; for i,m in ipairs(menu) do menu['xt'..i]=0 end; menu['xt'..menu.i]=10; act_menu=menu; cam.tgt=turn end end 
  elseif spelltgt and not spellhit then
    if input(4) then 
      spellsucc=false
      for i=#spelltgt.circle,1,-1 do
        local c=spelltgt.circle[i]
        for j=#c,1,-1 do
          if c['f'..j] and c[j]==cur_spell() then
            c[j]=0xdeadc0de
            spellsucc=true
          end
          c['f'..j]=nil
        end
      end
      
      mons_hit=spelltgt.f
      if mons_hit then spellsucc=true; spelltgt.gone=true; add_paws(3,'enemy hit') end
      spelltgt.f=nil
      spellhit=60
      if spellsucc and not mons_hit then sfx(5,'G-4',16,2,8) 
      elseif mons_hit then sfx(11,'D-4',120,2) end
      if spcur then rem(iso,find(iso,spcur)); spcur=nil end 
      ap=ap-5
      
      act_menu['xt'..act_menu.i]=-28; act_menu['yt'..act_menu.i]=0; act_menu['x'..act_menu.i]=-28; act_menu['y'..act_menu.i]=0; 
      rem(act_menu,act_menu.i)
      rem(turn.stack,#turn.stack-(act_menu.i-1))
      if act_menu.i>#act_menu then act_menu.i=#act_menu end
      --act_menu['xt'..act_menu.i]=10
      for i=#menu_spell,1,-1 do rem(menu_spell,i) end; for i=#turn.stack,#turn.stack-2,-1 do if not turn.stack[i] then break end; ins(menu_spell,get_spell(turn.stack[i])) end; menu_spell.i=1
    end
    if input5 then for i,c in ipairs(spelltgt.circle) do for j,d in ipairs(c) do c['f'..j]=nil end end spelltgt=nil; cam.tgt=turn; spellrange={}; if spcur then rem(iso,find(iso,spcur)); spcur=nil; end act_menu['y'..act_menu.i]=0; act_menu['yt'..act_menu.i]=0; for i,m in ipairs(act_menu) do act_menu['x'..i]=-28; act_menu['xt'..i]=0 end; act_menu['xt'..act_menu.i]=10; menu['xt'..menu.i]=10 end
  elseif spellhit then
    if spellhit>0 then
      spellhit=spellhit-1
      if spellhit==0 then
      if mons_hit then rem(iso,find(iso,spelltgt)); if find(enemies,spelltgt) then rem(enemies,find(enemies,spelltgt)); end end
      local empty=true
      for j=1,4 do if spelltgt.circle[#spelltgt.circle][j]~=0xdeadc0de then empty=false; break end end
      if empty then rem(spelltgt.circle,#spelltgt.circle) end
      if tutor9 and not tutor11 then
            tutor_msg='Nice! Now the enemy is exposed, and you still have an Action Point left, so hit it with another spell! Any color will do.'
            tutor11=true
      else
              act_menu['y'..act_menu.i]=0; act_menu['yt'..act_menu.i]=0; if ap>0 then for i,m in ipairs(act_menu) do act_menu['x'..i]=-28; end end; for i,m in ipairs(act_menu) do act_menu['xt'..i]=0 end; act_menu['xt'..act_menu.i]=10; menu['xt'..menu.i]=10
      end
      for i,c in ipairs(spelltgt.circle) do for j=1,4 do spelltgt.circle[#spelltgt.circle]['f'..j]=nil end end spelltgt=nil; cam.tgt=turn; spellrange={}; if spcur then rem(iso,find(iso,spcur)); spcur=nil end; 
      spellhit=nil
      spellsucc=false
      mons_hit=nil
      end
    end
  elseif #moverange>0 then
  if input(0) then turn.iy=turn.iy-1; dy=-1 end
  if input(1) then turn.iy=turn.iy+1; dy= 1 end
  if input(2) then turn.ix=turn.ix-1; dx=-1 end
  if input(3) then turn.ix=turn.ix+1; dx= 1 end
  if dx~=0 or dy~=0 then moved=true; sortneeded=true; turn.lastdx=dx; turn.lastdy=dy end
  if input(4) then 
  if tutor5 and not tutor6 and not in_spellrange() then
        if not block_frame then tutor_msg='That\'s not close enough!' end
  else
  ap=ap-math.abs(turn.ix-orig_x)-math.abs(turn.iy-orig_y); moverange={}; for i,m in ipairs(menu) do if menu.i==i then menu['yt'..i]=0 else menu['xt'..i]=0 end end 
  end
  if tutor5 and not tutor6 then
        if in_spellrange() then
                        tutor_msg='That should do it. But as you can see in the top right corner, you\'re now out of Action Points! This means your turn is over.'
                        for i,m in ipairs(menu) do menu['xt'..i]=-28 end;
                        tutor6=true
                end
  end
  end
  --if btnp(4) and not moved then get_adjacent(); at=t end
  --if btnp(5) and not moved and #stack>0 then get_adjacent2(); sortneeded=true; at=t end
  elseif at and #adjacent>0 then
    if adjacent[1].sp~=64 then
    for i=#adjacent,1,-1 do
            local a=adjacent[i]
      if input(a.dir) then
            sfx(9,'E-5',30,2)
        
            rem(adjacent,i)
        rem(iso,find(iso,a))
        iso[posstr3(a.ix,a.iy,a.iz)]=nil
        add_paws(3,'tile mined')
        
        -- tower collapse
        local iz=a.iz+1
        while iso[posstr3(a.ix,a.iy,iz)] do
          iso[posstr3(a.ix,a.iy,iz-1)]=iso[posstr3(a.ix,a.iy,iz)]
          iso[posstr3(a.ix,a.iy,iz)].iz=iso[posstr3(a.ix,a.iy,iz)].iz-1
          iso[posstr3(a.ix,a.iy,iz)]=nil
          iz=iz+1
        end
        
        ins(turn.stack,a.sp)
        --adjacent={}
        sortneeded=true
        --at=nil
        ap=ap-1
        break
      end
    end
    if tutor4 and not tutor5 and #adjacent==0 then
            tutor_msg='Now you can cast either a Gray or a Green spell. Move closer to the scarecrow so that you\'re in spell casting range. Press X to backtrack in the menu and select \'Move\'.'
      tutor5=true
    end
    if input(4) or input5 or ap<=0 then adjacent={}; at=nil; for i,m in ipairs(menu_tile) do if menu_tile.i==i then menu_tile['y'..i]=0; menu_tile['yt'..i]=0; menu_tile['x'..i]=-28; menu_tile['xt'..i]=10 else menu_tile['xt'..i]=0 end end; menu['xt'..menu.i]=10 end
    else
      for i,a in ipairs(adjacent) do
        if input(a.dir) and #turn.stack>0 then
          for i2,a2 in ipairs(adjacent) do
            rem(iso,find(iso,a2))
          end
          adjacent={} 
          ins_iso({sp=turn.stack[#turn.stack],ix=a.ix,iy=a.iy,iz=a.iz})
          rem(turn.stack,#turn.stack)
          sortneeded=true
          at=nil
                ap=ap-1
          break
        end
      end
      if input5 or input(4) or ap<=0 then 
      for i,a in ipairs(adjacent) do
        rem(iso,find(iso,a))
      end
      adjacent={} 
      at=nil
      for i,m in ipairs(menu_tile) do if menu_tile.i==i then menu_tile['y'..i]=0; menu_tile['yt'..i]=0; menu_tile['x'..i]=-28; menu_tile['xt'..i]=10 else menu_tile['xt'..i]=0 end end; menu['xt'..menu.i]=10
      end
    end
  end
  if #adjacent==0 and input(4) and act_menu~=menu and act_menu~=menu_spell and act_menu['yt'..act_menu.i]<0 then for i,m in ipairs(act_menu) do if act_menu.i==i then act_menu['y'..i]=0; act_menu['yt'..i]=0; act_menu['x'..i]=-28; act_menu['xt'..i]=10 else act_menu['xt'..i]=0 end end; menu['xt'..menu.i]=10 end
  end

  if moved then
  
  local tower=turn.iz+0.1
  local old_iz=turn.iz
  local towerpos=posstr3(turn.ix,turn.iy,tower)
  if iso[towerpos] then turn.ix=turn.ix-dx; turn.iy=turn.iy-dy; turn.iz=old_iz; sortneeded=false end
  while not iso[towerpos] do
    tower=tower-1
    turn.iz=tower+3-0.1
    towerpos=posstr3(turn.ix,turn.iy,tower)
    if tower<=-1 then turn.ix=turn.ix-dx; turn.iy=turn.iy-dy; turn.iz=old_iz; sortneeded=false; break end
  end
  if iso[posstr3(turn.ix,turn.iy,turn.iz-0.1)] or (not overworld and not find(moverange,iso[posstr3(turn.ix,turn.iy,turn.iz-(3-0.1))])) then
     turn.ix=turn.ix-dx; turn.iy=turn.iy-dy; turn.iz=old_iz; sortneeded=false; 
  end

  --[[while 1 do
  local towerpos=posstr3(turn.ix,turn.iy,tower)
  if iso[towerpos] then 
    turn.iz=tower+3-0.1
    tower=tower-1
  else if tower==0 or tower==12 then turn.ix=turn.ix-dx; turn.iy=turn.iy-dy; sortneeded=false; end; break end
  ]]

  --[[local towerfound=false
  for i,obj in ipairs(iso) do
    if obj~=plr and obj~=testnmy then
      if obj.ix==turn.ix and obj.iy==turn.iy and obj.iz==tower then
        turn.iz=tower+3-0.1
        tower=tower+1
        towerfound=true
        break
      end
    end
  end
  if not towerfound then if tower==0 then turn.ix=turn.ix-dx; turn.iy=turn.iy-dy end; break end]]
  
  --end
  end

  if ap<=0 and t-turn_t>120+60 and not spellhit and not tutor_msg then 
        turn_t=t
  end
  if t-turn_t==60 then
    if turn==plr then if #enemies>0 then enemies.i=1; turn=enemies[enemies.i]; enemies.i=enemies.i+1 end 
    else if #enemies>0 then turn=enemies[enemies.i] end; if not turn then turn=plr end; enemies.i=enemies.i+1 end
                cam.tgt=turn
    for j,mn in ipairs({menu,menu_tile,menu_spell}) do for k,l in ipairs(mn) do mn['xt'..k]=-28 end end
    ap=6
  end
  
  if t-turn_t>120+60 and turn~=plr then 
  tape.i=tape.i+1; 
        if not tape[tape.i] then 
                local nxt=tapeproto[tapeproto.i]
                if type(nxt)=='table' then
                        append(tape,nxt)
                elseif type(nxt)=='function' then
                        nxt()
                end
                tapeproto.i=tapeproto.i+1
        end
  --if tape[tape.i] then trace(tape[tape.i],3) end
  end
  
  local sx,sy=isopos(cam.tgt.ix,cam.tgt.iy,cam.tgt.iz)
  cam.tgtx=sx-32+8; cam.tgty=sy-32+8
  --trace(cam.tgt==spcur,7)
  
  cls(13)
  for i=0,8-1 do
    spr(30,i*8,0,13,1,0,0,1,8)
  end
  --if 1 then scale(); return end
 
  --spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
  --print("HELLO WORLD!",84,84)
  
  --[[for i=0,3 do
    spr(32,32-8+i*8,16+i*4,0,1,0,0,2,2)
    spr(32,32-8-i*8,16+i*4,0,1,0,0,2,2)
  end
  spr(32,32-8+1*8-2*8,16+1*4+2*4,0,1,0,0,2,2)
  ]]
  
  if sortneeded or t==st_t then--t==0 then
  table.sort(iso,function(a,b)
    --local ix1,iy1=isopos(a.ix,a.iy,a.iz,a==turn)
    --local ix2,iy2=isopos(b.ix,b.iy,b.iz,b==turn)
    --if ix1==ix2 or iy1==iy2 then return false end
    --if a.sp==1 then return iy1<iy2 end
    --if b.sp==1 then return iy2<iy1 end
    --if a.sp==1 then return ix1+iy1<ix2+iy2 end
    --if b.sp==1 then return ix1+iy1>ix2+iy2 end
    --if a.sp==1 or b.sp==1 then return iy1<iy2 end
    local ix1,iy1,iz1=a.ix,a.iy,a.iz
    local ix2,iy2,iz2=b.ix,b.iy,b.iz
    if iz1<turn.iz then iz1=iz1+0.95 end
    if iz2<turn.iz then iz2=iz2+0.95 end
    if iz1>turn.iz then iz1=iz1-0.25 end
    if iz2>turn.iz then iz2=iz2-0.25 end
    if iz1==a.iz and a~=turn and iz1<turn.iz then iz1=iz1+0.95 end
    if iz2==b.iz and b~=turn and iz2<turn.iz then iz2=iz2+0.95 end
    if iz1==a.iz and a~=turn and iz1>turn.iz then iz1=iz1-0.25 end
    if iz2==b.iz and b~=turn and iz2>turn.iz then iz2=iz2-0.25 end
    --if b==turn and iz1<turn.iz then iz1=iz1+1 end
    --if a==turn and iz2<=3 then iz1=iz1-0.9 end
    --if b==turn and iz1<=3 then iz2=iz2-0.9 end
    --if a==turn and iz2<3 then iz2=iz2+1 end
    --if b==turn and iz1<3 then iz1=iz1+1 end
    --if a==turn and iz2>=3 and iz2>iz1 then iz2=iz1-0.5 end
    --if b==turn and iz1>=3 and iz1>iz2 then iz1=iz2-0.5 end
    return -ix1+iy1+iz1<-ix2+iy2+iz2
    --return ix1+iy1<ix2+iy2
    --if ix1>ix2 then return false end
    --if iy1>iy2 then return false end
    --return true
  end)
  sortneeded=false 
  end
  --[[rem(iso,find(iso,turn))
  local ix2,iy2=isopos(turn.ix,turn.iy,turn.iz,true)
  for i,obj in ipairs(iso) do
    local ix,iy=isopos(obj.ix,obj.iy,obj.iz)
    if iy2>iy then ins(iso,i,turn); break end
  end
  if not find(iso,turn) then ins(iso,#iso,turn) end
  ]]
  
  local offscreen=true
  for i,obj in ipairs(iso) do
    local sx,sy=isopos(obj.ix,obj.iy,obj.iz,obj==turn)
    sx=sx-flr(cam.x+0.5)
    sy=sy-flr(cam.y+0.5)
    if (find(enemies,obj) or obj==plr) or (sx>=-16 and sx<64 and sy>=-11 and sy<64) then
                if (sx>=-16 and sx<64 and sy>=-11 and sy<64) then offscreen=false end

    if cross_sec then
      if obj==plr then
      local sp=96+math.floor(t%60/30*2)
      if obj.lastdx and (obj.lastdy<0 or obj.lastdx<0) then sp=sp+4 end
      --[[for tx=0,2-1 do for ty=0,2-1 do
      for px=0,8-1 do for py=0,8-1 do
      local p=sprpix(sp+tx+ty*16,px,py)
      if p>0 then 
      pix(sx+tx*8+px-1,sy+ty*8+py,12)
      pix(sx+tx*8+px+1,sy+ty*8+py,12)
      pix(sx+tx*8+px,sy+ty*8+py-1,12)
      if not ty==1 and py==7 then pix(sx+tx*8+px,sy+ty*8+py+1,12) end
      end
      end end
      end end]]
      for i=0,15 do pal(i,12) end
      spr(sp,sx+1,sy,0,1,0,0,2,2)
      spr(sp,sx,sy+1,0,1,0,0,2,2)
      spr(sp,sx-1,sy,0,1,0,0,2,2)
      spr(sp,sx,sy-1,0,1,0,0,2,2)
      pal()
      spr(sp,sx,sy,0,1,0,0,2,2)
      end
      if obj.iz>=plr.iz-4-0.1 and obj.iz<=plr.iz-(2-0.1) then
      if obj.sp==64 then
      if find(adjacent,obj) and (find(adjacent,obj)*2+(t-at)*0.5)%16<12 then 
      spr(obj.sp,sx,sy,0,1,0,0,2,2)
      end
      else
      if find(adjacent,obj) and (find(adjacent,obj)*2+(t-at+24)*0.5)%16<4 then for i=0,15 do pal(i,12) end end
      if not (obj.iz>=plr.iz-3-0.1 and obj.iz<=plr.iz-3+0.2) then
        --if iso[posstr3(obj.ix,obj.iy,obj.iz+1)] or iso[posstr3(obj.ix,obj.iy,obj.iz+2)] then
        --spr(68,sx,sy,0,1,0,0,2,2)
        --else
        spr(66,sx,sy,0,1,0,0,2,2)
        --end
      else
      spr(obj.sp,sx,sy,0,1,0,0,2,2)
      end
      --if math.abs(obj.ix-plr.ix)+math.abs(obj.iy-plr.iy)<4 and not iso[posstr3(obj.ix,obj.iy,obj.iz+1)] then spr(128+t*0.4%12//2*2,sx,sy,0,1,0,0,2,1) end
      if find(moverange,obj) and obj.sp~=105 then spr(128--[[+(obj.sp-32)/2*16]]+math.floor(t*0.4%12/2)*2,sx,sy,0,1,0,0,2,1) end
      if find(spellrange,obj) and obj.sp~=105 then spr(160--[[+(obj.sp-32)/2*16]]+math.floor(t*0.4%12/2)*2,sx,sy,0,1,0,0,2,1) end
      pal()
      end
      else
      --spr(64,sx,sy,0,1,0,0,2,2)
      end
    else
      if obj==plr then
      if (obj==spelltgt and spellsucc and spellhit%20<10) then
      for i=0,15 do pal(i,12) end
      end 
      if (obj==spelltgt and obj.f and t%16<8) then
      for i=0,15 do pal(i,12) end
      end
      if obj==spelltgt and mons_hit and spellhit%20<10 then for i=0,15 do pal(i,2) end 
      end
      local sp=96+math.floor(t%60/30)*2
      if obj.lastdx and (obj.lastdy<0 or obj.lastdx<0) then sp=sp+4 end
      --[[for tx=0,2-1 do for ty=0,2-1 do
      for px=0,8-1 do for py=0,8-1 do
      local p=sprpix(sp+tx+ty*16,px,py)
      if p>0 then 
      pix(sx+tx*8+px-1,sy+ty*8+py,12)
      pix(sx+tx*8+px+1,sy+ty*8+py,12)
      pix(sx+tx*8+px,sy+ty*8+py-1,12)
      if not ty==1 and py==7 then pix(sx+tx*8+px,sy+ty*8+py+1,12) end
      end
      end end
      end end]]
      if not overworld then
      for j,c in ipairs(obj.circle) do
        for i=0,360-1 do
          local a=(i+90)*math.pi/180
          line(sx+8+cos(a)*(9+(j-1)*3),sy+5+3+sin(a)*(9+(j-1)*3),sx+8+cos(a)*(12+(j-1)*3),sy+5+3+sin(a)*(12+(j-1)*3),15)
        end
        for i=0,360-1 do
          local a=(i-90)*math.pi/180
          local col=15
          for k=1,4 do
          if i>=90*(k-1)+4 and i<90*k+4 then 
          if c[k]==1 then col=4 
          elseif c[k]==2 then col=6
          elseif c[k]==3 then col=9
          elseif c[k]==4 then col=14 end 
          if c['f'..k] and t%16<8 then col=12 end
          end end
          --if i>=180 then col=1 end
          line(sx+8+cos(a)*(10+(j-1)*3),sy+5+3+sin(a)*(10+(j-1)*3),sx+8+cos(a)*(11+(j-1)*3),sy+5+3+sin(a)*(11+(j-1)*3),col)
        end
      end
      end
      for i=0,15 do pal(i,12) end
      spr(sp,sx+1,sy,0,1,0,0,2,2)
      spr(sp,sx,sy+1,0,1,0,0,2,2)
      spr(sp,sx-1,sy,0,1,0,0,2,2)
      spr(sp,sx,sy-1,0,1,0,0,2,2)
      pal()
      spr(sp,sx,sy,0,1,0,0,2,2)
      if obj==spelltgt and spellhit and not spellsucc then
        local tw=print('Resist!',0,-6,2,false,1,true)
        print('Resist!',sx+8+1-tw/2-1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2+1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7-1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7+1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7,2+t*0.2%3,false,1,true)
      end
      elseif obj.sp==64 then
      if find(adjacent,obj) and (find(adjacent,obj)*2+(t-at)*0.5)%16<12 then 
      spr(obj.sp,sx,sy,0,1,0,0,2,2)
      end
      else
      if find(adjacent,obj) and (find(adjacent,obj)*2+(t-at+24)*0.5)%16<4 then for i=0,15 do pal(i,12) end end
      --if not (obj.iz>=plr.iz-3-0.1 and obj.iz<=plr.iz-3+0.2) then
      --spr(70,sx,sy,0,1,0,0,2,2)
      --else
      if obj.sp==105 then 
      local sp=obj.sp+math.floor(t%60/30)*2
      if obj.lastdx and (obj.lastdy<0 or obj.lastdx<0) then sp=sp+156-105 end
      if (obj==spelltgt and spellsucc and spellhit%20<10) then
      for i=0,15 do pal(i,12) end
      end 
      if (obj==spelltgt and obj.f and t%16<8) then
      for i=0,15 do pal(i,12) end
      end
      if obj==spelltgt and mons_hit and spellhit%20<10 then for i=0,15 do pal(i,2) end 
      end
      --[[for tx=0,2-1 do for ty=0,2-1 do
      for px=0,8-1 do for py=0,8-1 do
      local p=sprpix(sp+tx+ty*16,px,py)
      if p~=4 then 
      pix(sx+tx*8+px-1,sy+ty*8+py+6,12)
      pix(sx+tx*8+px+1,sy+ty*8+py+6,12)
      pix(sx+tx*8+px,sy+ty*8+py-1+6,12)
      if not ty==1 and py==7 then pix(sx+tx*8+px,sy+ty*8+py+1+6,12) end
      end
      end end
      end end]]
      for i=0,15 do pal(i,12) end
      spr(sp,sx+1,sy+6,4,1,0,0,2,2)
      spr(sp,sx,sy+6+1,4,1,0,0,2,2)
      spr(sp,sx-1,sy+6,4,1,0,0,2,2)
      spr(sp,sx,sy+6-1,4,1,0,0,2,2)
      pal()
      spr(sp,sx,sy+6,4,1,0,0,2,2)
      if not overworld then
      for j,c in ipairs(obj.circle) do
        for i=0,360-1 do
          local a=(i+90)*math.pi/180
          line(sx+8+cos(a)*(9+(j-1)*3),sy+8+3+sin(a)*(9+(j-1)*3),sx+8+cos(a)*(12+(j-1)*3),sy+8+3+sin(a)*(12+(j-1)*3),15)
        end
        for i=0,360-1 do
          local a=(i-90)*math.pi/180
          local col=15
          for k=1,4 do
          if i>=90*(k-1)+4 and i<90*k+4 then 
          if c[k]==1 then col=4 
          elseif c[k]==2 then col=6
          elseif c[k]==3 then col=9
          elseif c[k]==4 then col=14 end 
          if c['f'..k] and t%16<8 then col=12 end
          end end
          --if i>=180 then col=1 end
          line(sx+8+cos(a)*(10+(j-1)*3),sy+8+3+sin(a)*(10+(j-1)*3),sx+8+cos(a)*(11+(j-1)*3),sy+8+3+sin(a)*(11+(j-1)*3),col)
        end
      end
      end
      pal()
      if obj==spelltgt and spellhit and not spellsucc then
        local tw=print('Resist!',0,-6,2,false,1,true)
        print('Resist!',sx+8+1-tw/2-1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2+1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7-1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7+1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7,2+t*0.2%3,false,1,true)
      end
      elseif obj.sp==200 then 
      local sp=obj.sp+math.floor(t%60/30)*2
      if obj.lastdx and (obj.lastdy>0 or obj.lastdx>0) then sp=sp+232-200 end
      if (obj==spelltgt and spellsucc and spellhit%20<10) then
      for i=0,15 do pal(i,12) end
      end 
      if (obj==spelltgt and obj.f and t%16<8) then
      for i=0,15 do pal(i,12) end
      end
      if obj==spelltgt and mons_hit and spellhit%20<10 then for i=0,15 do pal(i,2) end 
      end
      --[[for tx=0,2-1 do for ty=0,2-1 do
      for px=0,8-1 do for py=0,8-1 do
      local p=sprpix(sp+tx+ty*16,px,py)
      if p~=0 then 
      pix(sx+tx*8+px-1,sy+ty*8+py+3,12)
      pix(sx+tx*8+px+1,sy+ty*8+py+3,12)
      pix(sx+tx*8+px,sy+ty*8+py-1+3,12)
      if not ty==1 and py==7 then pix(sx+tx*8+px,sy+ty*8+py+1+3,12) end
      end
      end end
      end end]]
      if not overworld then
      for j,c in ipairs(obj.circle) do
        for i=0,360-1 do
          local a=(i+90)*math.pi/180
          line(sx+8+cos(a)*(9+(j-1)*3),sy+8+3+sin(a)*(9+(j-1)*3)-3,sx+8+cos(a)*(12+(j-1)*3),sy+8+3+sin(a)*(12+(j-1)*3)-3,15)
        end
        for i=0,360-1 do
          local a=(i-90)*math.pi/180
          local col=15
          for k=1,4 do
          if i>=90*(k-1)+4 and i<90*k+4 then 
          if c[k]==1 then col=4 
          elseif c[k]==2 then col=6
          elseif c[k]==3 then col=9
          elseif c[k]==4 then col=14 end 
          if c['f'..k] and t%16<8 then col=12 end
          end end
          --if i>=180 then col=1 end
          line(sx+8+cos(a)*(10+(j-1)*3),sy+8+3+sin(a)*(10+(j-1)*3)-3,sx+8+cos(a)*(11+(j-1)*3),sy+8+3+sin(a)*(11+(j-1)*3)-3,col)
        end
      end
      end
      for i=0,15 do pal(i,12) end
      spr(sp,sx,sy+3,0,1,0,0,2,2)
      spr(sp,sx,sy+3,0,1,0,0,2,2)
      spr(sp,sx,sy+3,0,1,0,0,2,2)
      spr(sp,sx,sy+3,0,1,0,0,2,2)
      pal()
      spr(sp,sx,sy+3,0,1,0,0,2,2)
      if obj==spelltgt and spellhit and not spellsucc then
        local tw=print('Resist!',0,-6,2,false,1,true)
        print('Resist!',sx+8+1-tw/2-1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2+1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7-1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7+1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7,2+t*0.2%3,false,1,true)
      end
      elseif obj.sp==198 then 
      local sp=obj.sp
      --if obj.lastdx and (obj.lastdy<0 or obj.lastdx<0) then sp=sp+156-105 end
      if (obj==spelltgt and spellsucc and spellhit%20<10) then
      for i=0,15 do pal(i,12) end
      end 
      if (obj==spelltgt and obj.f and t%16<8) then
      for i=0,15 do pal(i,12) end
      end
      if obj==spelltgt and mons_hit and spellhit%20<10 then for i=0,15 do pal(i,2) end 
      end
      --[[for tx=0,2-1 do for ty=0,3-1 do
      for px=0,8-1 do for py=0,8-1 do
      local p=sprpix(sp+tx+ty*16,px,py)
      if p~=0 then 
      pix(sx+tx*8+px-1,sy+ty*8+py+6-14,12)
      pix(sx+tx*8+px+1,sy+ty*8+py+6-14,12)
      pix(sx+tx*8+px,sy+ty*8+py-1+6-14,12)
      if not ty==2 and py==7 then pix(sx+tx*8+px,sy+ty*8+py+1+6-14,12) end
      end
      end end
      end end]]
      if not overworld then
      for j,c in ipairs(obj.circle) do
        for i=0,360-1 do
          local a=(i+90)*math.pi/180
          line(sx+8+cos(a)*(9+(j-1)*3),sy+8+3+sin(a)*(9+(j-1)*3)-8,sx+8+cos(a)*(12+(j-1)*3),sy+8+3+sin(a)*(12+(j-1)*3)-8,15)
        end
        for i=0,360-1 do
          local a=(i-90)*math.pi/180
          local col=15
          for k=1,4 do
          if i>=90*(k-1)+4 and i<90*k+4 then 
          if c[k]==1 then col=4 
          elseif c[k]==2 then col=6
          elseif c[k]==3 then col=9
          elseif c[k]==4 then col=14 end 
          if c['f'..k] and t%16<8 then col=12 end
          end end
          --if i>=180 then col=1 end
          line(sx+8+cos(a)*(10+(j-1)*3),sy+8+3+sin(a)*(10+(j-1)*3)-8,sx+8+cos(a)*(11+(j-1)*3),sy+8+3+sin(a)*(11+(j-1)*3)-8,col)
        end
      end
      end
      for i=0,15 do pal(i,12) end
      spr(sp,sx+1,sy+6-14,0,1,0,0,2,3)
      spr(sp,sx,sy+6-14+1,0,1,0,0,2,3)
      spr(sp,sx-1,sy+6-14,0,1,0,0,2,3)
      spr(sp,sx,sy+6-14-1,0,1,0,0,2,3)
      pal()
      spr(sp,sx,sy+6-14,0,1,0,0,2,3)
      if obj==spelltgt and spellhit and not spellsucc then
        local tw=print('Resist!',0,-6,2,false,1,true)
        print('Resist!',sx+8+1-tw/2-1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2+1,sy+7,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7-1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7+1,15,false,1,true)
        print('Resist!',sx+8+1-tw/2,sy+7,2+t*0.2%3,false,1,true)
      end
      elseif obj.sp==192 then spr(obj.sp,sx,sy+(t*0.06)%3,0,1,0,0,2,2)
      else spr(obj.sp,sx,sy,0,1,0,0,2,2) end
      if find(moverange,obj) and obj.sp~=105 then spr(128--[[+(obj.sp-32)/2*16]]+math.floor(t*0.4%12/2)*2,sx,sy,0,1,0,0,2,1) end
      if find(spellrange,obj) and obj.sp~=105 then spr(160--[[+(obj.sp-32)/2*16]]+math.floor(t*0.4%12/2)*2,sx,sy,0,1,0,0,2,1) end
      --if math.abs(obj.ix-plr.ix)+math.abs(obj.iy-plr.iy)<4 and not iso[posstr3(obj.ix,obj.iy,obj.iz+1)] then spr(128--[[+(obj.sp-32)/2*16]]+t*0.4%12//2*2,sx,sy,0,1,0,0,2,1) end
      --if obj.sp==34 and not iso[posstr3(obj.ix,obj.iy,obj.iz+1)] then spr(72,sx,sy-16+4,0,1,0,0,2,2) end
      --end
      pal()
      end
    end
    end
  end
    
  if offscreen then cam.x=cam.x-cam.dx; cam.y=cam.y-cam.dy end
  --local ix,iy=isopos(plr.ix,plr.iy,plr.iz)
  --spr(1+t%60//30*2,ix+1,iy-12,14,1,0,0,2,2)
  
  local shade={}
  --[[
  for tx=0,3-1 do for ty=0,2-1 do
  for px=0,8-1 do for py=0,8-1 do
    local p=sprpix(40+tx+ty*16,px,py)
    if p>0 then
      --for lx=-1,1 do for ly=-1,1 do
      for i,d in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
        local sh={x=d[1]+64-16-2-1-4+tx*8+px,y=d[2]+64-16+ty*8+py}
        --if not find2(shade,sh) then 
        local ps=posstr3(sh.x,sh.y,0)
        if not shade[ps] then
          pix(sh.x,sh.y,fade_pal(pix(sh.x,sh.y)))
          --ins(shade,sh) 
          shade[ps]=true
        end
      end
      --end end
      --local p2=pix(lx+64-16-2-1+tx*8+px,ly+64-16+ty*8+py)
      --pix(lx+64-16-2-1+tx*8+px,ly+64-16+ty*8+py,fade_pal(p2))
    end
  end end
  end end
  --for i,s in ipairs(shade) do
  --  pix(s.x,s.y,fade_pal(pix(s.x,s.y)))
  --end]]
  love.graphics.setShader(paletteswap2)
  spr(40,64-16-2-1-4,64-16,0,1,0,0,3,2)
  love.graphics.setShader()
  --print('U',64-16-2-4-1,64-16,12,false,1,true)
  --print('R',64-16+2+4+4+3-1,64-16-3+3,12,false,1,true)
  --print('L',64-16-2-4-1,64-16+10,12,false,1,true)
  --print('D',64-16+2+4+4+3-1,64-16-3+3+10,12,false,1,true)
  
  --[[for rx=1,1+16-1 do
    pix(rx,64-16-1,fade_pal(pix(rx,64-16-1)))
    pix(rx,64-16-1+16-1,fade_pal(pix(rx,64-16-1+16-1)))
  end
  for ry=64-16-1+1,64-16-1+16-1-1 do
    pix(1,ry,fade_pal(pix(1,ry)))
    pix(1+16-1,ry,fade_pal(pix(1+16-1,ry)))
  end]]
  
  --spr(34,1,64-16-1+2,0,1,0,0,2,2)
  
  --rectb(1,64-16-1,16,16,2)
  --if #stack>0 then
  --spr(stack[#stack],1,64-16-1+2,0,1,0,0,2,2)
  --end
  if not overworld then

  local h=0
  local h2=0
  for i,m in ipairs(menu) do if menu['yt'..i]<0 and menu['xt'..i]>=0 then h=8-1 end end
  if act_menu~=menu then for i,m in ipairs(act_menu) do if act_menu['yt'..i]<0 and act_menu['xt'..i]>=0 then h2=8-1 end end end
  love.graphics.setLineWidth(0.5)
  for i=0,3-1 do
  line(32-4-9+1+i*9-1,0+h,32-4-9+1+7+i*9-1+1-1,0+h,12)
  line(32-4-9+i*9-1,1+h,32-4-9+i*9-1,8+h+1-1,12)
  line(32-4-9+1+i*9-1,9+h,32-4-9+1+7+i*9-1+1-1,9+h,12)
  end
  line(32-4-9+3*9-1,1+h,32-4-9+3*9-1,8+h+1-1,12)
  local i2=0
  for i=#turn.stack,#turn.stack-2,-1 do
    local sp=turn.stack[i]; if not sp then break end
    sp=68+(sp-32)/2
    spr(sp,32-4-9+1+(2-i2)*9-1,h+2,0)
    i2=i2+1
  end
  --if t-turn_t>=120 then
  local col=12
  if ap<=0 then col=2 end
  --local tw=print(fmt('AP: %d',ap),0,-6,12,false,1,true)
        --print(fmt('AP: %d',ap),32-tw/2+1,h+11,col,false,1,true)
        spr(194,64-16,1+h2,0,1,0,0,2,2)
        print(ap,64-16+7,1+7+h2,col,false,1,true)

        if not cam.lock then
                if t%24<12 then
                        spr(196,1,1+h,4,1,0,0,2,2)
                end
        end
        --end

  --[[poke(ADDR+15*3+0,0x94)
  poke(ADDR+15*3+1,0xb0)
  poke(ADDR+15*3+2,0xc2)
  apoplex_palette=0]]
  
  if t-turn_t>=60 and t-turn_t<120+60 then
        if turn==plr or enemies.i<=2 then
    rect(0,32-4,64,8,15)
    if plr.gone then local tw=print('Game over',0,-6); print('Game over',32-tw/2+1,32-4+1,2+t*0.12%3) 
            cam.tgt=plr
            turn_t=t-60
    elseif #enemies==0 then local tw=print('You win',0,-6); print('You win',32-tw/2+1,32-4+1,5+t*0.12%3) 
            cam.tgt=plr
            --turn_t=t-60
    else
    if turn==plr then 
        local tw=print('turn',0,-6); 
        print('Player',0,32-4+1,5+t*0.12%3)
        print('turn',64-tw+1,32-4+1,5+t*0.12%3)
    else local tw=print('Enemy turn',0,-6); print('Enemy turn',32-tw/2+1,32-4+1,2+t*0.12%3) end
    end
    end
  elseif t-turn_t==120+60 then  
        if turn_i then if turn==plr then music(2,9)
    else if peek(0x13FFC)~=4 then music(4) end end end
    turn_i=turn_i or 0
    turn_i=turn_i+1
    cam.tgt=turn
    --menu['xt'..menu.i]=10
        if turn==plr and tutor6 and not tutor7 then tutor_msg='And back to you. You\'ll need to hit an enemy\'s health circle with the same color spell from the \'Spell\' menu.'; tutor7=true 
    elseif tutor3 or not tutorial then
    for i,m in ipairs(menu_tile) do menu_tile['y'..i]=0; menu_tile['yt'..i]=0; if i~=1 then menu_tile['xt'..i]=0 else menu_tile['xt'..i]=10 end end; menu_tile.i=1
    for i,m in ipairs(menu_spell) do menu_spell['y'..i]=0; menu_spell['yt'..i]=0; if i~=1 then menu_spell['xt'..i]=0 else menu_spell['xt'..i]=10 end end; menu_spell.i=1
    for i,m in ipairs(menu) do menu['y'..i]=0; menu['yt'..i]=0; if i~=1 then menu['xt'..i]=0 else menu['xt'..i]=10 end end; menu.i=1
                end
                act_menu=menu; 
    tape={i=1}
    tapeproto={i=1}
    append(tape,wait(20))
    
    local function minecount()
            get_adjacent()
      local out=#adjacent
      adjacent={}
      return out
    end
    
    local function damaged()
            for i=1,turn.origcirc do
            local c=turn.circle[i]
        if not c then return true end
        for j,d in ipairs(c) do
                if d==0xdeadc0de then return true end
        end
      end
      return false
    end
    
    if turn.sp==198 then
            append(tape,wait(10))
      append(tape,{0})
      append(tape,wait(60))
      append(tape,{4})
    end
    if turn.sp==105 or turn.sp==200 then
    if #turn.stack==0 then
    -- gather resources
            trace('gather resources',7)
            if minecount()<=1 then
      append(tape,wait(5))
      append(tape,{4})
            append(tape,wait(40))
                        append(tape,{math.random(0,3)})
            append(tape,wait(20))
      append(tape,{4})
      end
      append(tape,wait(10))
            append(tape,{1})
            append(tape,wait(20))
            append(tape,{4})
            append(tape,wait(60))
            append(tape,{4})
            append(tape,wait(60))
            append(tape,{0})
            append(tape,wait(10))
            append(tape,{3})
            append(tape,wait(10))
            append(tape,{1})
            append(tape,wait(10))
            append(tape,{2})
            append(tape,wait(10))
            append(tape,{5})
            append(tape,wait(40))
                        ins(tapeproto,function() 
            if (turn.sp==105 and #turn.stack>3) or (turn.sp==200 and #turn.stack>2) then 
                        append(tape,wait(5))
            append(tape,{1})
            append(tape,wait(20))
            append(tape,{1})
            append(tape,wait(90))
            append(tape,{4})
            append(tape,wait(60))
            append(tape,{5})
            else append(tape,wait(5)); append(tape,{5}) end
            end)
                        ins(tapeproto,function()
                                if #turn.stack>0 and in_spellrange() then
                                        append(tape,wait(5))
                                        append(tape,{1})
                            append(tape,wait(20))
                                        append(tape,{4}) --menu_spell
                            append(tape,wait(50))
                                        append(tape,{4}) --spellrange
                            append(tape,wait(60))
                                        append(tape,{4}) --spcur
                                        append(tape,wait(90))
                                        append(tape,{4}) --spell_hit
                                        append(tape,wait(60))
                                elseif #turn.stack==0 then
                                        append(tape,wait(5))
                      append(tape,{0})
                                        append(tape,wait(20))
                      append(tape,{4})
                            append(tape,wait(40))
                                        append(tape,{math.random(0,3)})
                            append(tape,wait(20))
                      append(tape,{4})
                                        
                                        append(tape,wait(30))
                                        append(tape,{1})
                            append(tape,wait(20))
                            append(tape,{4})
                            append(tape,wait(60))
                            append(tape,{4})
                            append(tape,wait(60))
                            append(tape,{0})
                            append(tape,wait(10))
                            append(tape,{3})
                            append(tape,wait(10))
                            append(tape,{1})
                            append(tape,wait(10))
                            append(tape,{2})
                            append(tape,wait(10))
                            append(tape,{5})
                            append(tape,wait(40))
                                        ins(tapeproto,function()
                                                if #turn.stack==0 then
                                                        append(tape,wait(5))
                                            append(tape,{5})
                                            append(tape,wait(40))
                                                        append(tape,{1})
                                                        append(tape,wait(20))
                                                        append(tape,{1})
                                                        append(tape,wait(20))
                                                        append(tape,{4})
                                                end
                                        end)
                                elseif not in_spellrange() then
                                        append(tape,wait(5))
                                        append(tape,{0})
                            append(tape,wait(40))                           
                                        append(tape,{4})
                                        append(tape,wait(50))
                                        local xd=plr.ix-turn.ix
                                        local yd=plr.iy-turn.iy
                                        local tb={}
                                        if xd~=0 then ins(tb,'x') end
                                        if yd~=0 then ins(tb,'y') end
                                        if #tb>0 then for i=1,3 do
                                        local dir=tb[math.random(#tb)]
                                        if dir=='x' then 
                                        if xd<0 then append(tape,{2})
                                        else append(tape,{3}) end
                                        else
                                        if yd<0 then append(tape,{0})
                                        else append(tape,{1}) end
                                        end
                                        append(tape,wait(20))
                                        end end
                                        append(tape,{4})
                                        append(tape,wait(50))
                                        ins(tapeproto,function()
                                                if in_spellrange() then
                                                        append(tape,wait(5))
                                                        append(tape,{1})
                                                        append(tape,wait(10))
                                                        append(tape,{1})
                                                        append(tape,wait(20))
                                                        append(tape,{4}) --menu_spell
                                            append(tape,wait(50))
                                                        append(tape,{4}) --spellrange
                                            append(tape,wait(60))
                                                        append(tape,{4}) --spcur
                                                        append(tape,wait(90))
                                                        append(tape,{4}) --spell_hit
                                                        append(tape,wait(60))
                                                        append(tape,{5})
                                                        append(tape,wait(30))
                                                        append(tape,{1})
                                                        append(tape,wait(20))
                                                        append(tape,{4})
                                                else
                                                        append(tape,wait(5))
                                                        append(tape,{0})
                                                        append(tape,wait(40))
                                                        append(tape,{4})
                                                end
                                        end)
                                end
                        end)
                        -- End
                        --[[ins(tapeproto,wait(20))
                        ins(tapeproto,{1})
                        ins(tapeproto,wait(10))
                        ins(tapeproto,{1})
                        ins(tapeproto,wait(10))
                        ins(tapeproto,{4})]]
    else
            if #turn.stack>0 and ((damaged() and ((turn.sp==105 and math.random(1,3)==1) or (turn.sp==200 and math.random(1,2)==1))) or (turn.sp==200 and math.random(1,4)==1)) then
            trace('recover',7)
        append(tape,wait(5))
                                append(tape,{1})
                                append(tape,wait(30))
                                append(tape,{4})
                                append(tape,wait(50))
                                append(tape,{0})
                                append(tape,wait(80))
                                append(tape,{4})
            elseif #turn.stack>0 and in_spellrange() then
            trace('instaspell',7)
        append(tape,wait(5))
                                append(tape,{1})
                    append(tape,wait(20))
                                append(tape,{1})
                    append(tape,wait(20))
                                append(tape,{4}) --menu_spell
                    append(tape,wait(50))
                                append(tape,{4}) --spellrange
                    append(tape,wait(60))
                                append(tape,{4}) --spcur
                                append(tape,wait(90))
                                append(tape,{4}) --spell_hit
                                append(tape,wait(60))
                                if turn.sp==200 and #turn.stack>=2 then
        append(tape,wait(5))
                                append(tape,{4}) --spellrange
                    append(tape,wait(60))
                                append(tape,{4}) --spcur
                                append(tape,wait(90))
                                append(tape,{4}) --spell_hit
                                append(tape,wait(90))
                                end
                                append(tape,{5})
                                append(tape,wait(30))
                                append(tape,{1})
                                append(tape,wait(20))
                                append(tape,{4})
                        elseif not in_spellrange() then
        append(tape,wait(5))
                                append(tape,{4})
                                append(tape,wait(50))
                                local xd=plr.ix-turn.ix
                                local yd=plr.iy-turn.iy
                                local tb={}
                                if xd~=0 then ins(tb,'x') end
                                if yd~=0 then ins(tb,'y') end
                                if #tb>0 then for i=1,3 do
                                local dir=tb[math.random(#tb)]
                                if dir=='x' then 
                                if xd<0 then append(tape,{2})
                                else append(tape,{3}) end
                                else
                                if yd<0 then append(tape,{0})
                                else append(tape,{1}) end
                                end
                                append(tape,wait(20))
                                end end
                                append(tape,{4})
                                append(tape,wait(50))
                                ins(tapeproto,function()
                                        if in_spellrange() then
                                                append(tape,{1})
                                                append(tape,wait(10))
                                                append(tape,{1})
                                    append(tape,wait(20))
                                                append(tape,{4}) --menu_spell
                                    append(tape,wait(50))
                                                append(tape,{4}) --spellrange
                                    append(tape,wait(60))
                                                append(tape,{4}) --spcur
                                                append(tape,wait(90))
                                                append(tape,{4}) --spell_hit
                                                append(tape,wait(60))
                                                append(tape,{5})
                                                append(tape,wait(30))
                                                append(tape,{1})
                                                append(tape,wait(20))
                                                append(tape,{4})
                                        else
                                                append(tape,{4})
                                                append(tape,wait(50))
                                                local xd=plr.ix-turn.ix
                                                local yd=plr.iy-turn.iy
                                                local tb={}
                                                if xd~=0 then ins(tb,'x') end
                                                if yd~=0 then ins(tb,'y') end
                                                if #tb>0 then for i=1,3 do
                                                local dir=tb[math.random(#tb)]
                                                if dir=='x' then 
                                                if xd<0 then append(tape,{2})
                                                else append(tape,{3}) end
                                                else
                                                if yd<0 then append(tape,{0})
                                                else append(tape,{1}) end
                                                end
                                                append(tape,wait(20))
                                                end end
                                                append(tape,{4})
                                                append(tape,wait(50))
                                                append(tape,{0})
                                                append(tape,wait(30))
                                                append(tape,{4})
                                        end
                                end)
                        end
    end
                end
  end
  
  if tape then
  --trace(tape.i,7)
  end
    
  local menuswap=nil
  for i,m in ipairs(act_menu) do
    act_menu['x'..i]=act_menu['x'..i]+(act_menu['xt'..i]-act_menu['x'..i])*0.2; if math.abs(act_menu['x'..i]-act_menu['xt'..i])<0.5 then act_menu['x'..i]=act_menu['xt'..i] end
    if t-turn_t>=120+60 and not (tutor6 and not tutor14) then
                act_menu['y'..i]=act_menu['y'..i]+(act_menu['yt'..i]-act_menu['y'..i])*0.2; if --[[menu['yt'..i]<0 and]] math.abs(act_menu['y'..i]-act_menu['yt'..i])<0.5 then act_menu['y'..i]=act_menu['yt'..i]; if act_menu['yt'..i]<0 then if act_menu==menu and menu[menu.i]=='Move' and #moverange==0 then get_moverange(); orig_x=turn.ix; orig_y=turn.iy; if tutor5 and not tutor10 then tutor_msg='Move closer to the scarecrow with the arrow keys, and press Z when done.'; tutor10=true; end end; if act_menu~=menu and act_menu[act_menu.i]=='Mine' and #adjacent==0 and (at==nil or #adjacent==0) then get_adjacent(); at=t; if tutor3 and not tutor4 then tutor4=true; tutor_msg='Good. There are 3 tiles around you that you can mine; simply hit the direction you want to mine.' end end; if act_menu~=menu and act_menu[act_menu.i]=='Place' and #adjacent==0 and #turn.stack>0 and (at==nil or #adjacent==0) then get_adjacent2(); sortneeded=true; at=t end; if act_menu==menu and menu[menu.i]=='Tile' then menuswap=menu_tile; trace('menuswap') end; if act_menu~=menu and (act_menu[act_menu.i]=='Blue' or act_menu[act_menu.i]=='Green' or act_menu[act_menu.i]=='Gold' or act_menu[act_menu.i]=='Gray') and #spellrange==0 then get_spellrange(); local tgt=spellrange[1]; for i,s in ipairs(spellrange) do if turn~=plr then if s.ix==plr.ix and s.iy==plr.iy and s.iz+3-0.1==plr.iz then tgt=s; goto brk end else for i,e in ipairs(enemies) do if s.ix==e.ix and s.iy==e.iy and s.iz+3-0.1==e.iz then tgt=s; goto brk end end end end ::brk:: spcur={sp=192,ix=tgt.ix,iy=tgt.iy,iz=tgt.iz+3-0.1}; cam.tgt=spcur; ins(iso,spcur); sortneeded=true end; if act_menu==menu and menu[menu.i]=='Spell' then menuswap=menu_spell; for i=#menu_spell,1,-1 do rem(menu_spell,i) end; for i=#turn.stack,#turn.stack-2,-1 do if not turn.stack[i] then break end; ins(menu_spell,get_spell(turn.stack[i])) end; for i,m in ipairs(menu_spell) do menu_spell['x'..i]=-28; if i~=menu_spell.i then menu_spell['xt'..i]=0 else menu_spell['xt'..i]=10 end end trace('menuswap') end; end end
    end
    if tutor6 and not tutor14 and menu['x'..menu.i]==-28 then tutor14=true end
    local col=15
    if i==act_menu.i then
    local off=false
    for i2,m2 in ipairs(act_menu) do if i2~=act_menu.i and act_menu['xt'..i2]>=0 then off=false; break end; if (i2~=act_menu.i and act_menu['xt'..i2]<0 and (t-mt)<=18*2-9) or #act_menu==1 then off=true; break end end 
    if (act_menu[act_menu.i]=='Circle' and (t-mt)<=18*2-9) or (act_menu[act_menu.i]=='End' and (t-mt)<=18*2-9) then off=true end
    if off then
      if t-mt<18*2-9 and (t-mt)%18<9 then col=12 
      elseif t-mt==18*2-9 and act_menu[act_menu.i]~='Circle' and act_menu[act_menu.i]~='End' then act_menu['yt'..i]=-(64-(#act_menu)*8+(i-1)*8); if act_menu~=menu then menu['xt'..menu.i]=0; act_menu['xt'..i]=36 end end
    end end
    rect(0,64-(#act_menu)*8+(i-1)*8+act_menu['y'..i],24+act_menu['x'..i],7,col)
    circ(24+act_menu['x'..i],64-(#act_menu)*8+(i-1)*8+3+act_menu['y'..i],3,col)
    spr(104,24+act_menu['x'..i]+1,64-(#act_menu)*8+(i-1)*8+act_menu['y'..i],0)
    local col=4
    if act_menu==menu_spell then
      if m=='Blue' then col=9 end
      if m=='Green' then col=6 end
      if m=='Gold' then col=4 end
      if m=='Gray' then col=14 end
    end
    print(m,2+act_menu['x'..i],64-(#act_menu)*8+(i-1)*8+1+act_menu['y'..i],col,false,1,true)
  end
  if menuswap then
        --if tutor3 and not tutor4 then if menuswap~=menu_tile then tutor_msg='What are you doing?' end  
        --else 
    --if tutor3 and not tutor4 then tutor4=true end
    if tutor8 and not tutor9 and menuswap==menu_spell then
                local stx,sty=isopos(enemies[1].ix,enemies[1].iy,enemies[1].iz)
    local ptx,pty=isopos(turn.ix,turn.iy,turn.iz)
    local a=math.atan2(sty-pty,stx-ptx) 
    local f
    if a%(2*pi)<pi/2 then f=4 
    elseif a%(2*pi)<pi then f=1
    elseif a%(2*pi)<3*pi/2 then f=2
    else f=3 end
    tutor_sp=get_spell(32+(enemies[1].circle[1][f]-1)*2)
    tutor_msg=fmt('Your position determines which quarter of the health circle you will hit. It seems you\'re facing it so that you\'ll hit the %s part. That means you should choose the %s spell.',string.lower(tutor_sp),tutor_sp); tutor9=true
    end
    act_menu=menuswap; trace('menuswap2') 
    --end
  end
  --trace(menu==act_menu,2)
  for i,m in ipairs(menu) do
    if menu['y'..i]<0 then 
    menuswap=act_menu
    act_menu=menu
    act_menu['x'..i]=act_menu['x'..i]+(act_menu['xt'..i]-act_menu['x'..i])*0.2; if math.abs(act_menu['x'..i]-act_menu['xt'..i])<0.5 then act_menu['x'..i]=act_menu['xt'..i] end
    if not (tutor6 and not tutor14) then
    act_menu['y'..i]=act_menu['y'..i]+(act_menu['yt'..i]-act_menu['y'..i])*0.2; if --[[menu['yt'..i]<0 and]] math.abs(act_menu['y'..i]-act_menu['yt'..i])<0.5 then act_menu['y'..i]=act_menu['yt'..i]; end
    end
    local col=15
    rect(0,64-(#act_menu)*8+(i-1)*8+act_menu['y'..i],24+act_menu['x'..i],7,col)
    circ(24+act_menu['x'..i],64-(#act_menu)*8+(i-1)*8+3+act_menu['y'..i],3,col)
    spr(104,24+act_menu['x'..i]+1,64-(#act_menu)*8+(i-1)*8+act_menu['y'..i],0)
    print(m,2+act_menu['x'..i],64-(#act_menu)*8+(i-1)*8+1+act_menu['y'..i],4,false,1,true)
    act_menu=menuswap
    menuswap=nil
    end
  end
  --trace(menu==act_menu,3)

  if sortneeded then 
  table.sort(iso,function(a,b)
    local ix1,iy1,iz1=a.ix,a.iy,a.iz
    local ix2,iy2,iz2=b.ix,b.iy,b.iz
    if iz1<turn.iz then iz1=iz1+0.95 end
    if iz2<turn.iz then iz2=iz2+0.95 end
    if iz1>turn.iz then iz1=iz1-0.25 end
    if iz2>turn.iz then iz2=iz2-0.25 end
    if iz1==a.iz and a~=turn and iz1<turn.iz then iz1=iz1+0.95 end
    if iz2==b.iz and b~=turn and iz2<turn.iz then iz2=iz2+0.95 end
    if iz1==a.iz and a~=turn and iz1>turn.iz then iz1=iz1-0.25 end
    if iz2==b.iz and b~=turn and iz2>turn.iz then iz2=iz2-0.25 end
    return -ix1+iy1+iz1<-ix2+iy2+iz2
  end)
  end

        end
        if overworld and not enc_t then
                for i,e in ipairs(enemies) do
                        if e.ix==plr.ix and e.iy==plr.iy then
                                enc_t=64
                                sfx(10,'A-6',60,2)
                        end
                end
        end
        if enc_t then
                for ch=0,3 do if ch~=2 then setvol(ch,flr((enc_t)/64*15)) end end
                enc_t=enc_t-1
                rect(enc_t,0,64,32,0)
                rect(64-64-enc_t,32,64,32,0)
                if enc_t==0 then music(); enc_t=nil; TIC=loadmap
                        ow_iso=iso
                        ow_enemies=enemies
                        ow_plrx=plr.ix;ow_plry=plr.iy;ow_plrz=plr.iz
                        if plr.ix==3 and plr.iy==1 then
                                enemies={i=1,{sp=198,stack={},circle={{2,2,2,4}}}}
                                iso={plr,enemies[1]}
                                seed=1243681
                                xw=6;yw=6;zw=2
                                tutorial=true
                                tutor_msg='Welcome to Apoplex! This is a little tutorial. Press Z to advance text.'
                        end
                        if plr.ix==5 and plr.iy==2 then
                                enemies={i=1,{sp=105,stack={},circle={{2,4,2,4}}}}
                                iso={plr,enemies[1]}
                                seed=2045209
                                xw=8;yw=8;zw=12-9+1
                        end
                        if plr.ix==8 and plr.iy==-1 then
                                enemies={i=1,{sp=105,stack={},circle={{1,4,1,4}}},{sp=105,stack={},circle={{2,3,2,3}}}}
                                iso={plr,enemies[1],enemies[2]}
                                seed=1944026
                                xw=10;yw=10;zw=12-9+1
                        end
                        if plr.ix==7 and plr.iy==5 then
                                enemies={i=1,{sp=105,stack={},circle={{1,3,1,3},{4,4,2,2}}}}
                                iso={plr,enemies[1]}
                                seed=535809
                                xw=8;yw=8;zw=12-9+1
                        end
                        if plr.ix==9+1 and plr.iy==4-1 then
                                enemies={i=1,{sp=200,stack={},circle={{3,3,3,3},{4,4,1,1}}}}
                                iso={plr,enemies[1]}
                                seed=97102
                                xw=8;yw=8;zw=12-6+1
                        end
                        if plr.ix==14 and plr.iy==0 then
                                enemies={i=1,{sp=200,stack={},circle={{4,4,4,2},{1,1,1,1}}},{sp=200,stack={},circle={{1,1,1,1},{4,4,2,4}}}}
                                iso={plr,enemies[1],enemies[2]}
                                --seed=724001
                                seed=1146635
                                xw=12;yw=12;zw=12-6+1                       
                        end
                        for i,e in ipairs(enemies) do e.origcirc=#e.circle end
                        gx=-xw+1;gy=0;gz=0;prog=0
                end
        end
        if (not overworld and tutorial) or gamewon then
                if block_frame then block_frame=false end
                tx=tx or 1;
                tdx=tdx or 0
                local tw=0
                if tutor_msg then
                tw=print(tutor_msg,tx,-6,4,false,1,true)
                if btn(2) then tdx=tdx-0.2 end
                if btn(3) then tdx=tdx+0.2; if not tutor1 then tutor1=true end; end
                end
                if btnp(4) and tx==64-tw then tdx=0; tx=2; tutor_msg=nil; block_frame=true; if tutor7 and not tutor8 then 
                        for i,m in ipairs(menu_tile) do menu_tile['y'..i]=0; menu_tile['yt'..i]=0; if i~=1 then menu_tile['xt'..i]=0 else menu_tile['xt'..i]=10 end end; menu_tile.i=1
            for i,m in ipairs(menu_spell) do menu_spell['y'..i]=0; menu_spell['yt'..i]=0; if i~=1 then menu_spell['xt'..i]=0 else menu_spell['xt'..i]=10 end end; menu_spell.i=1
            for i,m in ipairs(menu) do menu['y'..i]=0; menu['yt'..i]=0; if i~=1 then menu['xt'..i]=0 else menu['xt'..i]=10 end end; menu.i=1
            tutor8=true; end; 
                --if tutor6 and not tutor14 then menu['yt'..menu.i]=0; menu['y'..menu.i]=0; tutor14=true end
                if tutor11 and not tutor12 then 
                tutor12=true; act_menu['y'..act_menu.i]=0; act_menu['yt'..act_menu.i]=0; if ap>0 then for i,m in ipairs(act_menu) do act_menu['x'..i]=-28; end end; for i,m in ipairs(act_menu) do act_menu['xt'..i]=0 end; act_menu['xt'..act_menu.i]=10; menu['xt'..menu.i]=10 end
                if tutor2 and not tutor3 then tutor3=true; for i,m in ipairs(menu) do if i==menu.i then menu['xt'..i]=10 else menu['xt'..i]=0 end end end if not tutor2 then tutor2=true; tutor_msg='First, we\'ll need to mine some tiles. In the menu that pops up next, select \'Tile\', then \'Mine\'.' end end
                tx=tx-tdx
                if tx>1 then tx=1 end
                --for sy=0,64-1 do for sx=0,64-1 do 
                --      pix(sx,sy,fade_pal(pix(sx,sy)))
                --end end
                if tutor_msg then
                rect(0,32-4,64,8,15)
                if tx+tw<64 then tx=64-tw end
                print(tutor_msg,tx,32-4+1,4,false,1,true)
                if t%24<12 then
                        if tx==1 and tdx>=0 then
                        print('->',64-12+2+1,32-4+1+8,12)
                        end
                        if tx==64-tw then
                        print('Z',64-12+2+1+2,32-4+1+8,12)
                        end
                end
                end
                tdx=tdx*0.85
        end
        if t-turn_t==120+60 and #enemies==0 then
                overworld=true
                if tutorial then tutor13=true; tutorial=false end
                iso=ow_iso
                enemies=ow_enemies
                plr.ix=ow_plrx;plr.iy=ow_plry;plr.iz=ow_plrz
                for i,e in ipairs(enemies) do if e.ix==plr.ix and e.iy==plr.iy then rem(enemies,i); rem(iso,find(iso,e)); break end end
                if #enemies==0 or (#enemies==1 and enemies[1].ix==3 and enemies[1].iy==1) then gamewon=true; tutor_msg='Congratulations, you have won every encounter! Thanks so much for playing!'; add_paws(50,'game clear') end
                if not gamewon then add_paws(15,'encounter won') end
                turn_i=nil; mons_hit=nil; spelltgt=nil
                for i,m in ipairs(menu_tile) do menu_tile['x'..i]=-28; menu_tile['xt'..i]=-28 end
    for i,m in ipairs(menu_spell) do menu_spell['x'..i]=-28; menu_spell['xt'..i]=-28 end
    for i,m in ipairs(menu) do menu['x'..i]=-28; menu['xt'..i]=-28 end
    act_menu=menu
    cross_sec=false
    cam.lock=true
                music(0)
        end
  
  scale()
  
  --t=t+1
end

menu={'Move','Tile','Spell','End',x1=-28,x2=-28,x3=-28,x4=-28,y1=0,y2=0,y3=0,y4=0,xt1=-28,xt2=-28,xt3=-28,xt4=-28,yt1=0,yt2=0,yt3=0,yt4=0,i=1}
menu_tile={'Mine','Place','Circle',x1=-(64-(2)*8),x2=-(64-(2)*8),x3=-(64-(2)*8),y1=0,y2=0,y3=0,xt1=10,xt2=0,xt3=0,yt1=0,yt2=0,yt3=0,i=1}
menu_spell={'Blue','Green','Gold','Gray',x1=0,x2=-(64-(2)*8),x3=-(64-(2)*8),x4=-(64-(2)*8),y1=0,y2=0,y3=0,y4=0,xt1=10,xt2=0,xt3=0,xt4=0,yt1=0,yt2=0,yt3=0,yt4=0,i=1}
act_menu=menu

function apoplex_titlescr()
  --clip(0,0,64,64)
  cls(13)
  for i=0,8-1 do
    spr(30,i*8,0,13,1,0,0,1,8)
  end
  if gm_t-t==0 then trace('gm_t-t=0') sfx(6,'E-3',180,2,8) end
  --spr(256,8,8,0,math.max(1,8-(t*0.02)),0,0,4,4)
  local ofx=6+24+16+16-apt*2
  local ofy=8
  spr(256,8+ofx,8+ofy,0,1,0,0,4,4)
  spr(256+4,8+4*8+1+ofx,8+ofy,0,1,0,0,4,4)
  spr(256+8,8+4*8*2-3+ofx,8+ofy,0,1,0,0,4,4)
  spr(256+4,8+4*8*3-1+ofx,8+ofy,0,1,0,0,4,4)
  spr(324,8+4*8*4-5+ofx,8+ofy,0,1,0,0,4,4)
  spr(324+4,8+4*8*5-9+ofx,8+ofy,0,1,0,0,4,4)
  spr(324+8,8+4*8*6-8+ofx,8+ofy,0,1,0,0,4,4)
  if -apt*2<-8*4*8-8*2-8*2 then
    --update()
    --TIC=update
    if not st_t then st_t=t+1 end
    --[[local a=pi/6
    textri(0,0+2,64,0+2,64,16+2,
           0,0,85*8,0,85*8,16*8,
           true,0)
    textri(0,0+2,64,16+2,0,16+2,
           0,0,85*8,16*8,0,16*8,
           true,0)]]
    local ofx=0
    if title_t then ofx=(t-title_t)*2 end
    local ofy=10
    if t-st_t>0 then
    if t-st_t==0+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t)*0.4) do
    spr(384,1+10+2-ofx,2+ofy,0,i,0,0,2,2)
    end
    end
    if t-st_t>16 then
    if t-st_t==16+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t-16)*0.4) do
    spr(386,1+8*2-4-(i-1)*6+10+2-ofx,2+ofy,0,i,0,0,2,2)
    end
    end
    if t-st_t>16*2 then
    if t-st_t==16*2+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t-16*2)*0.4) do
    spr(388,1+8*4-4-4-(i-1)*12+10+2-ofx,2+ofy,0,i,0,0,2,2)
    end
    end
    if t-st_t>16*3 then
    if t-st_t==16*3+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t-16*3)*0.4) do
    spr(386,1+7+ofx,2+16+ofy-1,0,i,0,0,2,2)
    end
    end
    if t-st_t>16*4 then
    if t-st_t==16*4+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t-16*4)*0.4) do
    spr(390,1+7+16-4-(i-1)*4+ofx,2+16+ofy-1,0,i,0,0,2,2)
    end
    end
    if t-st_t>16*5 then
    if t-st_t==16*5+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t-16*5)*0.4) do
    spr(392,1+7+16-4+16-4-(i-1)*8+ofx,2+16+ofy-1,0,i,0,0,2,2)
    end
    end
    if t-st_t>16*6 then
    if t-st_t==16*6+1 then sfx(5,'G-4',16,2,8) end
    for i=1,math.max(1,9-(t-st_t-16*6)*0.4) do
    spr(394,1+7+16-4+16-4+16-4-(i-1)*12+ofx,2+16+ofy-1,0,i,0,0,2,2)
    end
    end
    if t-st_t>16*7 then
    if t-st_t==16*7+1 then music(2,9) end--music(1) end
    if (not title_t and (t-st_t)%48>24) or (title_t and (t-title_t)%12>6) then
    local tw=print('start',0,-6)
    print('Press',0,64-8-4+4+1,12)
    print('start',64-tw+1,64-8-4+4+1,12)
    end
    if btnp(4) and not title_t then title_t=t; sfx(9,'E-5',30,2) end
    else
    if btnp(4) then st_t=t-16*7 end
    end
  else
    if btnp(4) then t=(8*4*8-8*2-8*2) end
  end
  if title_t then
        for ch=0,3 do setvol(ch,flr((50-(t-title_t))/50*15)) end
        --title_t=title_t-1
    if t-title_t==50 then
            overworld=true; TIC=apoplex_update; st_t=t+1; music(0); turn_t=t-60 
    end
  end
  scale()
  apt=apt+1
  --t=t+1
end

--TIC=update

function loadmap()
        --local prog=gx*gy*gz/(xw*yw*zw)
        --clip(0,0,64,64)
        cls(0)
        generate()
        local tw=print('Loading',0,-6)
        print('Loading',32-tw/2,32-4-8,13)
        rect(2,32-4,64-4,8,13)
        rect(2,32-4,prog/(xw*yw*zw)*(64-4),8,8)
        if prog/(xw*yw*zw)==1 then
                st_t=t+1
                music(2,9)
                turn_t=t-60
                TIC=apoplex_update
                overworld=false
                sortneeded=true
        end
        scale()
        --t=t+1
end

function scale()
  --[[clip()
  for sx=64-1,0,-1 do for sy=64-1,0,-1 do
    rect(240/2-128/2+sx*2,136/2-128/2+sy*2,2,2,pix(sx,sy))
    pix(sx,sy,0)
  end end]]
end

function isopos(x,y,z,pl)
  z=z or 0
  if pl then
  return 32-8+x*8+y*8,16-x*4+y*4-(z-(3))*4-12
  end
  return 32-8+x*8+y*8,16-x*4+y*4-z*4
end

function overlap(px,py,except)
        if except~=plr and px==plr.ix and py==plr.iy then return true end
        for i,e in ipairs(enemies) do
                if except~=e and px==e.ix and py==e.iy then return true end
        end
        return false
end

adjacent={}
function get_adjacent()
  adjacent={}
  for i,dir in ipairs({{0,-1},{0,1},{-1,0},{1,0}}) do
  if iso[posstr3(turn.ix+dir[1],turn.iy+dir[2],turn.iz-(3-0.1)+1)] and not overlap(turn.ix+dir[1],turn.iy+dir[2]) then ins(adjacent,iso[posstr3(turn.ix+dir[1],turn.iy+dir[2],turn.iz-(3-0.1)+1)]); adjacent[#adjacent].dir=i-1
  elseif iso[posstr3(turn.ix+dir[1],turn.iy+dir[2],turn.iz-(3-0.1))] and not overlap(turn.ix+dir[1],turn.iy+dir[2]) then ins(adjacent,iso[posstr3(turn.ix+dir[1],turn.iy+dir[2],turn.iz-(3-0.1))]); adjacent[#adjacent].dir=i-1 end
  end
end

function get_adjacent2()
  adjacent={}
  for i,dir in ipairs({{0,-1},{0,1},{-1,0},{1,0}}) do
  local iz=turn.iz+0.1
  while not iso[posstr3(turn.ix+dir[1],turn.iy+dir[2],iz)] do
    iz=iz-1
    if iz<=turn.iz-(3-0.1) then break end
  end
  if iso[posstr3(turn.ix+dir[1],turn.iy+dir[2],iz)] and iz<turn.iz+0.1 then
  ins(iso,{sp=64,ix=turn.ix+dir[1],iy=turn.iy+dir[2],iz=iz+1,dir=i-1})
  ins(adjacent,iso[#iso])
  elseif iz<=turn.iz-(3-0.1) then
  ins(iso,{sp=64,ix=turn.ix+dir[1],iy=turn.iy+dir[2],iz=turn.iz-(3-0.1),dir=i-1})
  ins(adjacent,iso[#iso])
  end
  end
end

moverange={}
function get_moverange()
  moverange={}
  for i,obj in ipairs(iso) do
    if obj~=plr and not find(enemies,obj) then
    if math.abs(obj.ix-turn.ix)+math.abs(obj.iy-turn.iy)<4 and not iso[posstr3(obj.ix,obj.iy,obj.iz+1)] and not iso[posstr3(obj.ix,obj.iy,obj.iz+2)] and not overlap(obj.ix,obj.iy,turn) then
      ins(moverange,obj)
    end
    end
  end
end

spellrange={}
function get_spellrange()
  spellrange={}
  for i,obj in ipairs(iso) do
    if obj~=plr and not find(enemies,obj) then
    if math.abs(obj.ix-turn.ix)+math.abs(obj.iy-turn.iy)<4 and not iso[posstr3(obj.ix,obj.iy,obj.iz+1)] and not iso[posstr3(obj.ix,obj.iy,obj.iz+2)] then--and not (obj.ix==testnmy.ix and obj.iy==testnmy.iy and obj.iz+3-0.1==testnmy.iz) then
      ins(spellrange,obj)
      spellrange[posstr3(obj.ix,obj.iy,obj.iz)]=obj
    end
    end
  end
end

function cur_spell()
  if act_menu~=menu_spell then return nil end
  if act_menu[act_menu.i]=='Blue' then return 3 end
  if act_menu[act_menu.i]=='Green' then return 2 end
  if act_menu[act_menu.i]=='Gold' then return 1 end
  if act_menu[act_menu.i]=='Gray' then return 4 end
end

function get_spell(sp)
  if sp==32 then return 'Gold' end
  if sp==34 then return 'Green' end
  if sp==36 then return 'Blue' end
  if sp==38 then return 'Gray' end
end

function in_spellrange()
        get_spellrange(); local out=false; for i,s in ipairs(spellrange) do if turn~=plr then if s.ix==plr.ix and s.iy==plr.iy and s.iz+3-0.1==plr.iz then out=true; goto brk end else for i,e in ipairs(enemies) do if s.ix==e.ix and s.iy==e.iy and s.iz+3-0.1==e.iz then out=true; goto brk end end end end
  ::brk::
  spellrange={}
  return out
end

function get_circ(sp)
  return (sp-32)/2+1
end

function input(n)
  if turn==plr then return btnp(n) end
  if not tape[tape.i] then return false end
  return tape[tape.i]==n
end

function wait(n)
  local out={}
  for i=1,n do
    ins(out,-1)
  end
  return out
end

function append(tbl,what)
  for i,v in ipairs(what) do ins(tbl,v) end
end

function find(tbl,what)
  for i,v in ipairs(tbl) do if v==what then return i end end
end

function find2(tbl,what)
  for i,v in ipairs(tbl) do  
    local fnd=true
    for k,w in pairs(what) do
      if what[k]~=v[k] then
        fnd=false; break
      end
    end
    if fnd then return true end
  end
end

ADDR = 0x3FC0
apoplex_palette = 0

function SCN(scanline)
  if TIC==apoplex_titlescr then
  if scanline==0 then 
    poke(ADDR+2*3+0,0xef); poke(ADDR+2*3+1,0x7d); poke(ADDR+2*3+2,0x57); 
    if -t*2>=-8*4*8-8*2-8*2 then apoplex_palette=0
    else apoplex_palette=t*6 end
  end
  if scanline%2==0 then
    poke(ADDR+2*3+1,0x7d-apoplex_palette)
    apoplex_palette=apoplex_palette-12
  end
  else
    if scanline==0 then
    poke(ADDR+2*3+0,0xb1); poke(ADDR+2*3+1,0x3e); poke(ADDR+2*3+2,0x53); 
    end
  end
  
  --[[if (scanline-(136/2-128/2))%16==0 then
  poke(ADDR+15*3+1,0xb0-apoplex_palette)
  apoplex_palette=apoplex_palette+16
  end]]
end

-- palette swapping by BORB
  --function pal(c0,c1)
  --  if(c0==nil and c1==nil) then for i=0,15 do poke4(0x3FF0*2+i,i) end
  --  else poke4(0x3FF0*2+c0,c1) end
  --end

-- from 1THRUSTR.EXE
  function sprpix(sprno,px,py)
    --[[local byte= peek(0x4000 + 32*sprno + py*4 + px/2)
    if px%2==1 then byte=(byte&0xf0)>>4 
    else byte=byte&0x0f end
    return byte]]
    --local r,g,b=spritesheet_data:getPixel(sprno%16*8+px,math.floor(sprno/16)*8+py)
    --for i,v in ipairs(sweetie16) do
    --    if v[1]==r and v[2]==g and v[3]==b then return i-1 end
    --end
    return 0
  end

-- from ROWBYROW
  function fade_pal(c)
    if c==0 then return 0 end
    if c==1 then return 0 end
    if c==2 then return 1 end
    if c==3 then return 2 end
    if c==4 then return 3 end
    if c==5 then return 6 end
    if c==6 then return 7 end
    if c==7 then return 8 end
    if c==8 then return 1 end
    if c==9 then return 8 end
    if c==10 then return 9 end
    if c==11 then return 10 end
    if c==12 then return 13 end
    if c==13 then return 14 end
    if c==14 then return 15 end
    if c==15 then return 1 end
  end

-- from Sunray Valley
        function setvol(ch,vol)
                -- channel `ch` 0..3 
                -- volume `vol` 0..15
                --local val=peek(0xFF9C+18*ch+1)
                --poke(0xFF9C+18*ch+1, val&(0x0f|vol<<4))
        end

function generate()
local i=0
--for x=-xw+1,0 do for y=0,yw-1 do for z=0,zw do
while i<20 do
  local noise=perlin(seed+gx*0.01,seed+gy*0.01,seed+gz*0.01)
  noise=noise+perlin(seed+gx*0.25,seed+gy*0.25,seed+gz*0.25)
  --noise=noise+perlin(seed+x*1,seed+y*1,seed+z*1)
  noise=noise/2
  if noise<0.5 then
    --local sp=32+(noise*10)//2*2
    local sp=34
    if noise<=0.35 then sp=36
    elseif noise<=0.4 then sp=32
    elseif noise<=0.45 then sp=38 end
    ins_iso({sp=sp,ix=gx,iy=gy,iz=gz})
    
    if seed==2045209 then
    if gz==12-9 then plr.ix=iso[#iso].ix; plr.iy=iso[#iso].iy; plr.iz=iso[#iso].iz+3-0.1 end
    if gz==12-9 and gx<-6 and gy<4 then enemies[1].ix=iso[#iso].ix; enemies[1].iy=iso[#iso].iy; enemies[1].iz=iso[#iso].iz+3-0.1 end
    elseif seed==1944026 then
    --if gz==12-9 then plr.ix=iso[#iso].ix; plr.iy=iso[#iso].iy; plr.iz=iso[#iso].iz+3-0.1 end
    if gz==12-9 then enemies[2].ix=iso[#iso].ix-1; enemies[2].iy=iso[#iso].iy-1; enemies[2].iz=iso[#iso].iz+3-0.1; end
    if not enemies[1].ix then
            plr.ix=-3; plr.iy=0; plr.iz=3+3-0.1
            enemies[1].ix=-9; enemies[1].iy=7-1; enemies[1].iz=1+3-0.1
    end
    --if gz==2 and gx<-7 then enemies[1].ix=iso[#iso].ix; enemies[1].iy=iso[#iso].iy; enemies[1].iz=iso[#iso].iz+3-0.1 end
    --if gz==12-9 and gy<3 then enemies[2].ix=iso[#iso].ix; enemies[2].iy=iso[#iso].iy; enemies[2].iz=iso[#iso].iz+3-0.1 end
    elseif seed==535809 then
            if gz==12-9 then plr.ix=iso[#iso].ix; plr.iy=iso[#iso].iy; plr.iz=iso[#iso].iz+3-0.1 end
            if not enemies[1].ix then enemies[1].ix=-xw+1+4-1; enemies[1].iy=2+1; enemies[1].iz=4-1+3-0.1 end
    elseif seed==1243681 then 
            if gz==1 and not iso[posstr3(gx,gy,gz-1)] then ins_iso({sp=34,ix=gx,iy=gy,iz=gz-1}) end
            if gz==1 then plr.ix=iso[#iso].ix-1; plr.iy=iso[#iso].iy-3; plr.iz=iso[#iso].iz+3-0.1 end
      if gx==-xw+1+1 and gy==3 then enemies[1].ix=iso[#iso].ix; enemies[1].iy=iso[#iso].iy; enemies[1].iz=iso[#iso].iz+3-0.1 end
    elseif seed==97102 then
            if gx==-xw+1 and gy==0 and gz==1 then plr.ix=iso[#iso].ix; plr.iy=iso[#iso].iy; plr.iz=iso[#iso].iz+3-0.1 end
            if gz==12-6 then enemies[1].ix=iso[#iso].ix-1; enemies[1].iy=iso[#iso].iy-1; enemies[1].iz=iso[#iso].iz+3-0.1 end
    elseif seed==1146635 then
            if not enemies[1].ix then 
      plr.ix=-3; plr.iy=11; plr.iz=1+3-0.1; 
      enemies[1].ix=-xw+1+2; enemies[1].iy=1; enemies[1].iz=6+3-0.1 
      enemies[2].ix=-2; enemies[2].iy=0; enemies[2].iz=6+3-0.1 
      end
    end
  end
  i=i+1
  gx=gx+1; if gx>0 then gx=-xw+1 
  gy=gy+1; if gy>yw-1 then gy=0
  gz=gz+1; if gz>zw-1 then gz=0; break
  end
  end 
  end
--end end end
end
prog=prog+i
end
--trace(plr.ix,3)
--trace(plr.iy,4)
--trace(plr.iz,5)

--[[
debug cliffs
for i=0,3 do
ins_iso({sp=34,ix=0,iy=0+i,iz=0})
ins_iso({sp=34,ix=2,iy=0+i,iz=0})
ins_iso({sp=34,ix=4,iy=0+i,iz=0})
plr.ix=0;plr.iy=3;plr.iz=0+3-0.1
end
ins_iso({sp=34,ix=1,iy=3,iz=0})
ins_iso({sp=34,ix=3,iy=3,iz=0})

ins_iso({sp=34,ix=0,iy=0,iz=2})
ins_iso({sp=34,ix=2,iy=0,iz=1})
ins_iso({sp=34,ix=2,iy=0,iz=3})

ins_iso({sp=34,ix=4,iy=0,iz=2})
ins_iso({sp=34,ix=4,iy=0,iz=1})
ins_iso({sp=34,ix=4,iy=0,iz=4})
]]

--plr.ix=13;plr.iy=0;plr.iz=2+3-0.1

paletteswap2=love.graphics.newShader([[
    extern vec3 sweetie16[16];
  
  int fade_pal(int c) {
    if (c==0) { return 0; }
    if (c==1) { return 0; }
    if (c==2) { return 1; }
    if (c==3) { return 2; }
    if (c==4) { return 3; }
    if (c==5) { return 6; }
    if (c==6) { return 7; }
    if (c==7) { return 8; }
    if (c==8) { return 1; }
    if (c==9) { return 8; }
    if (c==10) { return 9; }
    if (c==11) { return 10; }
    if (c==12) { return 13; }
    if (c==13) { return 14; }
    if (c==14) { return 15; }
    if (c==15) { return 1; }
    return 0;
    }

    int palette_col(float r,float g,float b) {
        int i;
        for (i=0; i<16; i++) {
            if (sweetie16[i].r==r && sweetie16[i].g==g && sweetie16[i].b==b) {
                return i;
            }
        }
        return 0;
    }

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 origpixel = Texel(texture, texture_coords);
        if (palette_col(origpixel.r,origpixel.g,origpixel.b)==0) { 

        vec4 pixel=Texel(texture, vec2(texture_coords.x+1,texture_coords.y));
        if (pixel.r==sweetie16[12].r && pixel.g==sweetie16[12].g && pixel.b==sweetie16[12].b) {
            vec3 replace=sweetie16[fade_pal(palette_col(origpixel.r,origpixel.g,origpixel.b))];
            return vec4(replace.r,replace.g,replace.b,1);
        }
        pixel=Texel(texture, vec2(texture_coords.x,texture_coords.y+1));
        if (pixel.r==sweetie16[12].r && pixel.g==sweetie16[12].g && pixel.b==sweetie16[12].b) {
            vec3 replace=sweetie16[fade_pal(palette_col(origpixel.r,origpixel.g,origpixel.b))];
            return vec4(replace.r,replace.g,replace.b,1);
        }
        pixel=Texel(texture, vec2(texture_coords.x-1,texture_coords.y));
        if (pixel.r==sweetie16[12].r && pixel.g==sweetie16[12].g && pixel.b==sweetie16[12].b) {
            vec3 replace=sweetie16[fade_pal(palette_col(origpixel.r,origpixel.g,origpixel.b))];
            return vec4(replace.r,replace.g,replace.b,1);
        }
        pixel=Texel(texture, vec2(texture_coords.x,texture_coords.y-1));
        if (pixel.r==sweetie16[12].r && pixel.g==sweetie16[12].g && pixel.b==sweetie16[12].b) {
            vec3 replace=sweetie16[fade_pal(palette_col(origpixel.r,origpixel.g,origpixel.b))];
            return vec4(replace.r,replace.g,replace.b,1);
        }

        return vec4(0,0,0,0);
        }
        return origpixel*color;
    }

]])
paletteswap2:send('sweetie16',unpack(sweetie16))