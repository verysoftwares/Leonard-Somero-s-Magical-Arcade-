-- title:  Life of Tree
-- author: verysoftwares
-- desc:   for Global Game Jam 2023
-- script: lua

function life_of_tree_reset()
spritesheet=love.graphics.newImage('wares/life-of-tree-assets/life-of-tree-sprites.png')
tic_music={
    love.audio.newSource('wares/life-of-tree-assets/winter.ogg','stream'),
    love.audio.newSource('wares/life-of-tree-assets/summer.ogg','stream'),
}
for i,v in ipairs(tic_music) do v:setLooping(true) end
tic_sfx={}
--t=0
x=240/2
y=48-1
dx=0; dy=1
g=6 -- grid size
pups=0
level={x=240/2-g*6,y=48,w=g*12,h=g*10}
year=1
for sx=0,30-1 do for sy=0,17-1 do
    mset(sx,sy,0)
end end
--cls(15)
--rect(0,0,240,48,13)
--cls(6)
summer_score=0
winter_score=0
start_summer()
for i=1,3 do
    _G['rx'..tostring(i)]=nil
    _G['rw'..tostring(i)]=nil
end
trx=nil
end

function modal()
    draw()
    if not rx1 then 
        if nextseason==summer then music(1) end
        if nextseason==winter then music(0) end
        for i=1,3 do _G['rx'..tostring(i)]=240+(i-1)*20 end 
    end
    for i=1,3 do _G['rx'..tostring(i)]=_G['rx'..tostring(i)]-8; if _G['rx'..tostring(i)]<0 then _G['rx'..tostring(i)]=0 end end 
    if modal_mode then 
        for i=1,3 do 
            if not _G['rw'..tostring(i)] then 
                _G['rw'..tostring(i)]=240-math.min(240,_G['rx'..tostring(i)])+(i-1)*20 
            end 
            if _G['rx'..tostring(i)]<=0 then 
                _G['rw'..tostring(i)]=_G['rw'..tostring(i)]-8 
            end 
            if _G['rw'..tostring(i)]<=0 then 
                _G['rw'..tostring(i)]=0; 
                if i==3 then 
                    TIC=nextseason 
                    if nextseason==summer and mget((x-level.x)/g,0)~=0 then 
                        start_winter() 
                    end 
                    modal_mode=nil
                    demo_t=nil
                    for i=1,3 do 
                        _G['rx'..tostring(i)]=nil; _G['rw'..tostring(i)]=nil 
                    end
                    return
                end 
            end 
        end 
    end

    local ry=0      
    for i=1,3 do
    clip(_G['rx'..tostring(i)],136/2-16+ry,_G['rw'..tostring(i)] or 240,i==2 and 16 or 6)
    rect(_G['rx'..tostring(i)],136/2-16+ry,_G['rw'..tostring(i)] or 240,i==2 and 16 or 6,0)
    
    if i==1 then 
        local tw=print(string.format('Year %d of 3',year),0,-6)
        print(string.format('Year %d of 3',year),240/2-tw/2,136/2-16+ry,12)
    end
    if i==2 then
        local headline='Summer'
        if nextseason==winter then headline='Winter' end
        local tw=print(headline,0,-12,0,false,2,false)
        print(headline,240/2-tw/2,136/2-16+ry+2,4,false,2,false)
    end
    if i==3 then
        local msg
        if year==1 and nextseason==summer then
            msg='Arrow keys to move your root.'
        end
        if year==1 and nextseason==winter then
            msg='Click on pipes to form a path from the tree.'
        end
        if year==2 and nextseason==summer then
            msg='The area is now larger and the root moves faster.'
        end
        if year==2 and nextseason==winter then
            msg='You\'ll want to minimize the obstacles for summer.'
        end
        if year==3 and nextseason==summer then
            msg='The root moves really fast now, watch out!'
        end
        if year==3 and nextseason==winter then
            msg='You\'ve survived this far. This is the final puzzle.'
        end
        msg=msg or 'Text missing'
        local tw=print(msg,0,-6,0,false,1,true)
        print(msg,240/2-tw/2,136/2-16+ry,12,false,1,true)
    end
    
    ry=ry+8
    if i==2 then ry=ry+10 end
    end
    clip()

    if not modal_mode then
        demo_t=demo_t or 0
        for i=0,5 do if btnp(i) then modal_mode='return' end end
        demo_t=demo_t+1
        --if demo_t>=60*5 then modal_mode='return' end
        local _,_,click=mouse()
        if click then modal_mode='return' end
    end
end

function start_summer()
    pups=0
    x=240/2
    y=48-1
    dx=0; dy=1
    powerup=nil
    TIC=function()
        cls(0)
        trx=trx or 0
        if trx>0 then
            clip(0,0,trx,136)
            draw_summer()
            clip()
        end
        trx=trx+4
        if trx>240 then TIC=modal; draw=draw_summer; nextseason=summer; clip(); trx=nil end
    end
end

function draw_summer()
    cls(1)
    rect(level.x,level.y,level.w,level.h,6)
    rect(0,0,240,48,5)
    for i=0,15 do pal(i,1) end
    spr(5,240/2-2*8+1,48-4*8,0,1,0,0,4,4)
    spr(5,240/2-2*8-1,48-4*8,0,1,0,0,4,4)
    spr(5,240/2-2*8,48-4*8-1,0,1,0,0,4,4)
    pal()
    spr(5,240/2-2*8,48-4*8,0,1,0,0,4,4)
    --spr(13,240-16,8,0)
    circ(240-16,8+4,7,3)
    draw_countdown()
    draw_pipes()
end

function summer()

    if btnp(0) and dy~= 1 then pend_dy=-1; pend_dx=0 end
    if btnp(1) and dy~=-1 then pend_dy= 1; pend_dx=0 end
    if btnp(2) and dx~= 1 then pend_dx=-1; pend_dy=0 end
    if btnp(3) and dx~=-1 then pend_dx= 1; pend_dy=0 end

    if t%(3-(year-1))==0 then

    if not powerup then 
        powerup={x=math.random(level.x/g,(level.x+level.w-g)/g)*g,y=math.random(level.y/g,(level.y+level.h-g)/g)*g} 
        while pix(powerup.x,powerup.y)==4 or mget((powerup.x-level.x)/g,(powerup.y-level.y)/g)~=0 do
        powerup={x=math.random(level.x/g,(level.x+level.w-g)/g)*g,y=math.random(level.y/g,(level.y+level.h-g)/g)*g} 
        end
        for rx=0,g-1 do for ry=0,g-1 do
        local c=2
        if (powerup.x+rx+powerup.y+ry)%g<g/2 then c=12 end
        pix(powerup.x+rx,powerup.y+ry,c)
        end end
    end

    if ((dx~=0 and x%g==0) or (dy~=0 and y%g==0)) then
        if pend_dx and pend_dy then
        dx=pend_dx; dy=pend_dy
        pend_dx=nil; pend_dy=nil
        end
        sfx(2,'E-3',2,2)
    end
  
    x=x+dx; y=y+dy
        
    for rx=0,g-1 do for ry=0,g-1 do
        local hit
        local pup
        if dx<0 and rx==0 then hit=not (pix(x+rx,y+ry)==15 or pix(x+rx,y+ry)==6); pup=pix(x+rx,y+ry)==2 or pix(x+rx,y+ry)==12 end
        if dx>0 and rx==g-1 then hit=not (pix(x+rx,y+ry)==15 or pix(x+rx,y+ry)==6); pup=pix(x+rx,y+ry)==2 or pix(x+rx,y+ry)==12 end
        if dy<0 and ry==0 then hit=not (pix(x+rx,y+ry)==15 or pix(x+rx,y+ry)==6); pup=pix(x+rx,y+ry)==2 or pix(x+rx,y+ry)==12 end
        if dy>0 and ry==g-1 then hit=not (pix(x+rx,y+ry)==15 or pix(x+rx,y+ry)==6); pup=pix(x+rx,y+ry)==2 or pix(x+rx,y+ry)==12 end
        if hit and not pup then sfx(4,'E-4',26,1); start_winter(); music(); loveprint(pix(x+rx,y+ry)); return end
    end end
    for rx=0,g-1 do for ry=0,g-1 do
        local c=3
        if (x+rx+y+ry)%g<g/2 then c=4 end
        pix(x+rx,y+ry,c)
    end end
    
    if x==powerup.x and y==powerup.y then sfx(5,'E-5',32,1); pups=pups+1; powerup=nil; summer_score=summer_score+500; add_paws(5*year,'powerup collected') end
  
    end
    --spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
    --print("HELLO WORLD!",84,84)
    circ(240-16,8+4,7,3)
    draw_countdown()
    
    --t=t+1
end

function random_pipe()
    local r=math.random(1,11)
    local out
    if r==1 or r==2 then out=9+r-1 end
    if r>2 and r<=6 then out=25+r-3 end
    if r>6 and r<=10 then out=41+r-7 end
    if r==11 then out=57 end
    return out
end

function start_winter()
    TIC=function()
    snakefade=snakefade or 0
    local i=0
    local inc=1
    for mx=0,level.w/g-1 do for my=0,level.h/g-1 do
        spr(mget(mx,my),level.x+mx*g,level.y+my*g,0)
    end end
    for ly=level.y,level.y+level.h-g,g do for lx=level.x,level.x+level.w-g,g do
        if i>=snakefade and i<=snakefade+inc then
        if pix(lx,ly)==4 and pix(lx+g-1,ly+g-1)==3 then
            --rect(lx,ly,4,4,t)
            for lx2=-1,1 do for ly2=-1,1 do
            local lx3=lx/g-level.x/g+lx2
            local ly3=ly/g-level.y/g+ly2
            if lx3>=0 and lx3<=level.w/g-1 and ly3>=0 and ly3<=level.h/g-1 and mget(lx3,ly3)==0 then
                mset(lx3,ly3,random_pipe())
            end
            end end
            
            summer_score=summer_score+100
            sfx(3,'E-5',8,2)
        end
        rect(lx,ly,g,g,15)
        end
        i=i+1
        if i==snakefade+inc then snakefade=snakefade+inc; return end
    end end
    if snakefade>=(level.w/g-1)*(level.h/g-1) then
    TIC=function()
        trx=trx or 0
        clip(0,0,trx,136)
        draw_winter()
        clip()
        trx=trx+4
        if trx>240 then TIC=modal; draw=draw_winter; nextseason=winter; clip(); trx=nil; wt=0; snakefade=nil end
    end
    end
    end
end

function draw_winter()
    cls(15)
    rect(level.x,level.y,level.w,level.h,14)
    rect(0,0,240,48,13)
    for i=0,15 do pal(i,15) end
    spr(5,240/2-2*8+1,48-4*8,0,1,0,0,4,4)
    spr(5,240/2-2*8-1,48-4*8,0,1,0,0,4,4)
    spr(5,240/2-2*8,48-4*8-1,0,1,0,0,4,4)
    pal()
    pal(7,14); pal(6,13); pal(5,12)
    spr(5,240/2-2*8,48-4*8,0,1,0,0,4,4)
    pal()
    circ(240-16,8+4,7,12)
    draw_countdown()
    draw_pipes()
end

advance={}
function winter()
    old_mox=mox; old_moy=moy
    mox,moy,click=mouse()
    mox=mox-mox%g; moy=moy-moy%g
        
    if old_mox and old_moy and (old_mox>=level.x and old_mox<level.x+level.w and old_moy>=level.y and old_moy<level.y+level.h) then
        --[[for nx=0,g-1 do for ny=0,g-1 do
            local p=pix(old_mox+nx,old_moy+ny)
            if p~=4 and p~=10 then
                pix(old_mox+nx,old_moy+ny,14)
            end
        end end]]
        rect(old_mox,old_moy,g,g,14)
        spr(mget((old_mox-level.x)/g,(old_moy-level.y)/g),old_mox,old_moy,0)
    end
    for mx=0,level.w/g-1 do for my=0,level.h/g-1 do
        if mox==(level.x+mx*g) and moy==(level.y+my*g) then
            --rect((level.x+mx*g),(level.y+my*g),g,g,2+(t*0.4)%2)
            --[[for nx=0,g-1 do for ny=0,g-1 do
                local p=pix(level.x+mx*g+nx,level.y+my*g+ny)
                if p==14 or p==2 or p==3 then
                    pix(level.x+mx*g+nx,level.y+my*g+ny,2+(t*0.4)%2)
                end
            end end]]
            rect(level.x+mx*g,level.y+my*g,g,g,2+(t*0.4)%2)
            spr(mget(mx,my),level.x+mx*g,level.y+my*g,0)
            if click and not lastclick and not advanced(mx,my) then
                rotate_pipe(mx,my)
                sfx(2,'E-3',2,2)
            end
        end
        --spr(mget(mx,my),level.x+mx*g,level.y+my*g,0)
    end end
    
    if wt>=10*60+pups*5*60 then
        if wt==10*60+pups*5*60 then
            for i=0,level.w-1 do
            table.insert(advance,{x=level.x+i,y=48})
            end
        end
        if t%2==0 then
        if #advance>0 then music(); sfx(6,'A-4',4,2) end
        for i=#advance,1,-1 do
            local a=advance[i]
            if a.y>=48 and pix(a.x,a.y)==4 then
                pix(a.x,a.y,10)
                table.insert(advance,{x=a.x+1,y=a.y})
                table.insert(advance,{x=a.x-1,y=a.y})
                table.insert(advance,{x=a.x,y=a.y+1})
                table.insert(advance,{x=a.x,y=a.y-1})
            end 
            table.remove(advance,i)
        end
        end
        if #advance==0 then
            TIC=function()
            pipefade=pipefade or 0
            inc_paws=inc_paws or 0
            local i=0
            local inc=1
            for my=0,level.h/g-1 do for mx=0,level.w/g-1 do
                if i>=pipefade and i<=pipefade+inc then
                if mget(mx,my)~=0 then
                --trace(advanced(mx,my))
                --trace(mx)
                --trace(my)
                --trace(level.x+mx*g)
                --trace(level.y+my*g)
                if advanced(mx,my) then mset(mx,my,0); sfx(3,'E-5',8,2); winter_score=winter_score+100; inc_paws=inc_paws+1 end
                end
                rect(level.x+mx*g,level.y+my*g,g,g,1)
                spr(mget(mx,my),level.x+mx*g,level.y+my*g,0)
                end
                i=i+1
                if i==pipefade+inc then pipefade=pipefade+inc; return end
            end end
            if pipefade>=(level.w/g-1)*(level.h/g-1) then
            add_paws(inc_paws,'pipes cleared')
            inc_paws=nil
            pipefade=nil
            for mx=64,0,-1 do for my=0,64 do
                mset(mx+2,my,mget(mx,my))
                mset(mx,my,0)
            end end
            level.x=level.x-2*g
            level.w=level.w+4*g
            level.h=level.h+2*g
            year=year+1
            if year>3 then
                --vic_t=0
                --TIC=function() trace('You win'); vic_t=vic_t+1; if vic_t>=60*10 then reset() end end
                music(1)
                TIC=victoryscr
                add_paws(20,'game clear')
                return
            end
            wt=nil; pups=0
            start_summer()
            end
            end
        end
    end

    circ(240-16,8+4,7,12)
    draw_countdown()
    
    lastclick=click

    --t=t+1
    wt=wt+1
end

function advanced(mx,my)
    for nx=0,g-1 do for ny=0,g-1 do
        if pix(level.x+mx*g+nx,level.y+my*g+ny)==10 then
            return true
        end
    end end
    return false
end

function draw_countdown()
    wt=wt or 0
    local countdown=math.floor((10*60+pups*5*60-wt+30)/60)
    if countdown>99 then countdown=99 end
    if countdown>0 then
    local tw=print(countdown,0,-6,2,true,1,false)
    print(countdown,240-16-tw/2+1,4+6,2,true,1,false)
    end
end

function rotate_pipe(mx,my)
    local p=mget(mx,my)
    if p==9 or p==10 then mset(mx,my,9+(p-9+1)%2) end 
    if p>=25 and p<=28 then mset(mx,my,25+(p-25+1)%4) end 
    if p>=41 and p<=44 then mset(mx,my,41+(p-41+1)%4) end 
    if p==57 then end
    rect(level.x+mx*g,level.y+my*g,g,g,2+(t*0.4)%2)
    spr(mget(mx,my),level.x+mx*g,level.y+my*g,0)
end

function draw_pipes()
    for mx=0,level.w/g-1 do for my=0,level.h/g-1 do
        spr(mget(mx,my),level.x+mx*g,level.y+my*g,0)
    end end
end

function victoryscr()
    demo_t2=demo_t2 or 0
    
    local tw
    summer_shown_score=summer_shown_score or 0
    winter_shown_score=winter_shown_score or 0

    circ(240/2-60,136/2,48,12)
    tw=print(string.format('%.9d',math.floor(summer_shown_score+0.5)),0,-6)
    print(string.format('%.9d',math.floor(summer_shown_score+0.5)),240/2-60-tw/2,136/2+24,6)
    tw=print('Summer score:',0,-6,5)
    print('Summer score:',240/2-60-tw/2,136/2+24-8,5)

    for i=0,15 do pal(i,1) end
    spr(5,240/2-60-2*8+1,136/2+8-4*8,0,1,0,0,4,4)
    spr(5,240/2-60-2*8-1,136/2+8-4*8,0,1,0,0,4,4)
    spr(5,240/2-60-2*8,136/2+8-4*8-1,0,1,0,0,4,4)
    pal()
    spr(5,240/2-60-2*8,136/2+8-4*8,0,1,0,0,4,4)
    
    circ(240/2+60,136/2,48,12)
    tw=print(string.format('%.9d',math.floor(winter_shown_score+0.5)),0,-6)
    print(string.format('%.9d',math.floor(winter_shown_score+0.5)),240/2+60-tw/2,136/2+24,14)
    tw=print('Winter score:',0,-6,3)
    print('Winter score:',240/2+60-tw/2,136/2+24-8,13)

    for i=0,15 do pal(i,15) end
    spr(5,240/2+60-2*8+1,136/2+8-4*8,0,1,0,0,4,4)
    spr(5,240/2+60-2*8-1,136/2+8-4*8,0,1,0,0,4,4)
    spr(5,240/2+60-2*8,136/2+8-4*8-1,0,1,0,0,4,4)
    pal()
    pal(7,14); pal(6,13); pal(5,12)
    spr(5,240/2+60-2*8,136/2+8-4*8,0,1,0,0,4,4)
    pal()

    tw=print('The end',0,-12,0,false,2,false)
    print('The end',240/2-tw/2,4,t*0.2,false,2,false)
    tw=print('Thank you for playing!',0,-12,0,false,2,false)
    print('Thank you for playing!',240/2-tw/2,136-12-4,t*0.2,false,2,false)

    summer_shown_score=summer_shown_score+(summer_score-summer_shown_score)*0.1
    if math.abs(summer_score-summer_shown_score)<1 then summer_shown_score=summer_score end
    winter_shown_score=winter_shown_score+(winter_score-winter_shown_score)*0.1
    if math.abs(winter_score-winter_shown_score)<1 then winter_shown_score=winter_score end

    demo_t2=demo_t2+1
    --if demo_t2>=10*60 then reset() end

    --t=t+1
end

--[[
-- palette swapping by BORB
    function pal(c0,c1)
      if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i) end 
      else poke4(0x3FF0*2+c0,c1) end
    end
]]
--start_summer()
--TIC=victoryscr

--life_of_tree_reset()
