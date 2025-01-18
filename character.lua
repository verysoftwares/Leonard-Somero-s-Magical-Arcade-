lg.setDefaultFilter('nearest')
local emblem=lg.newImage('wares/mp-up2.png')
local emblem2=lg.newImage('wares/mp-up3.png')
local emblem3=lg.newImage('wares/mp-up4.png')
local mai=lg.newImage('milkyheart.jpg')
local leo=lg.newImage('wares/he_thincc.png')
local tuo=lg.newImage('tuomas2.png')
local mp_label=lg.newImage('wares/mp-label.png')
local mai_label=lg.newImage('wares/maitreya-label.png')
local leo_label=lg.newImage('wares/leonard-label.png')
local tuo_label=lg.newImage('wares/tuomas-label.png')
local label32=lg.newImage('wares/32-label.png')
local label34=lg.newImage('wares/34-label.png')
local label38=lg.newImage('wares/38-label.png')
local montserrat=lg.newFont('wares/Montserrat-ExtraBold.ttf',32)

local sfx_mpup=love.audio.newSource('wares/mp-up.ogg','static')

function character_draw()
    --if t%128==0 then sfx_mpup:stop(); sfx_mpup:play() end
    for i=0,3 do
    local diagbox={x=i*sw/4,y=0,w=sw/4,h=sh/6}
    lg.setLineWidth(8)
    fg(0.3,0.3,0.3,1)
    lg.rectangle('fill',diagbox.x+32,diagbox.y+32,diagbox.w,diagbox.h)
    fg(0.3,0.3,0.65)
    lg.rectangle('fill',diagbox.x,diagbox.y,diagbox.w,diagbox.h)
    fg(0.8,0.8,0.8)
    lg.rectangle('line',diagbox.x,diagbox.y,diagbox.w,diagbox.h)
    fg(0.3,0.3,0.3)
    lg.rectangle('fill',diagbox.x+4,diagbox.y+4,12,diagbox.h-8)
    lg.rectangle('fill',diagbox.x+4+12,diagbox.y+4,diagbox.w-8-8-4,12)
    local mphas,mphad
    if not (i==3) and not (t%128<64) then
        fg(0,0,0)
        lg.draw(mp_label,diagbox.x+8-1,diagbox.y+diagbox.h-16-2)
        lg.draw(mp_label,diagbox.x+8+1,diagbox.y+diagbox.h-16-2)
        lg.draw(mp_label,diagbox.x+8,diagbox.y+diagbox.h-16-1-2)
        lg.draw(mp_label,diagbox.x+8,diagbox.y+diagbox.h-16+1-2)
        fg(1,1,1)
        lg.draw(mp_label,diagbox.x+8,diagbox.y+diagbox.h-16-2)

        lg.setFont(montserrat)
        if i==0 then mphas=3; mphad=21 end
        if i==1 then mphas=12; mphad=36 end
        if i==2 then mphas=06; mphad=74 end
        local pr=string.format('%.2d/%.2d',mphas,mphad)
        fg(0,0,0)
        lg.print(pr,diagbox.x+diagbox.w-montserrat:getWidth(pr)-4+1,diagbox.y+diagbox.h-32-2) 
        lg.print(pr,diagbox.x+diagbox.w-montserrat:getWidth(pr)-4-1,diagbox.y+diagbox.h-32-2) 
        lg.print(pr,diagbox.x+diagbox.w-montserrat:getWidth(pr)-4,diagbox.y+diagbox.h-32-2+1) 
        lg.print(pr,diagbox.x+diagbox.w-montserrat:getWidth(pr)-4,diagbox.y+diagbox.h-32-2-1)
        fg(1,1,1)
        lg.print(pr,diagbox.x+diagbox.w-montserrat:getWidth(pr)-4,diagbox.y+diagbox.h-32-2)

        local rx,ry,rw,rh
        rx=diagbox.x+mp_label:getWidth()+8
        ry=diagbox.y+diagbox.h-12-4
        rw=diagbox.w-mp_label:getWidth()-montserrat:getWidth(pr)-6*2
        rh=12
        fg(0.8,0.8,0.5)
        lg.rectangle('fill',rx,ry,rw,rh)
        fg(0.2,0.8,0.4)
        lg.rectangle('fill',rx,ry,rw*mphas/mphad,rh)
        end
    if i==2 then
        if t%128<64 then
        fg(0,0,0)
        lg.draw(emblem3,diagbox.x+4+1,diagbox.y+4)
        lg.draw(emblem3,diagbox.x+4-1,diagbox.y+4)
        lg.draw(emblem3,diagbox.x+4,diagbox.y+4+1)
        lg.draw(emblem3,diagbox.x+4,diagbox.y+4-1)
        fg(1,1,1)
        lg.draw(emblem3,diagbox.x+4,diagbox.y+4)
        else
        fg(1,1,1)
        lg.draw(tuo,diagbox.x+16,diagbox.y+16,0,96/tuo:getWidth(),96/tuo:getWidth())
        fg(0,0,0)
        local mx=diagbox.x+16+96+2
        lg.draw(tuo_label,mx-1,diagbox.y+16+4)
        lg.draw(tuo_label,mx+1,diagbox.y+16+4)
        lg.draw(tuo_label,mx,diagbox.y+16+4-1)
        lg.draw(tuo_label,mx,diagbox.y+16+4+1)
        fg(1,1,1)
        lg.draw(tuo_label,mx,diagbox.y+16+4)
        fg(0,0,0)
        local mx=diagbox.x+16+96+2
        lg.draw(label38,mx-1,diagbox.y+16+4+24)
        lg.draw(label38,mx+1,diagbox.y+16+4+24)
        lg.draw(label38,mx,diagbox.y+16+4-1+24)
        lg.draw(label38,mx,diagbox.y+16+4+1+24)
        fg(1,1,1)
        lg.draw(label38,mx,diagbox.y+16+4+24)
        end
    end
    if i==1 then
        if t%128<64 then
        fg(0,0,0)
        lg.draw(emblem2,diagbox.x+4+1,diagbox.y+4)
        lg.draw(emblem2,diagbox.x+4-1,diagbox.y+4)
        lg.draw(emblem2,diagbox.x+4,diagbox.y+4+1)
        lg.draw(emblem2,diagbox.x+4,diagbox.y+4-1)
        fg(1,1,1)
        lg.draw(emblem2,diagbox.x+4,diagbox.y+4)
        else
        fg(1,1,1)
        lg.draw(mai,diagbox.x+16,diagbox.y+16,0,96/mai:getWidth(),96/mai:getWidth())
        fg(0,0,0)
        local mx=diagbox.x+16+96+2
        lg.draw(mai_label,mx-1,diagbox.y+16+4)
        lg.draw(mai_label,mx+1,diagbox.y+16+4)
        lg.draw(mai_label,mx,diagbox.y+16+4-1)
        lg.draw(mai_label,mx,diagbox.y+16+4+1)
        fg(1,1,1)
        lg.draw(mai_label,mx,diagbox.y+16+4)
        fg(0,0,0)
        local mx=diagbox.x+16+96+2
        lg.draw(label34,mx-1,diagbox.y+16+4+24)
        lg.draw(label34,mx+1,diagbox.y+16+4+24)
        lg.draw(label34,mx,diagbox.y+16+4-1+24)
        lg.draw(label34,mx,diagbox.y+16+4+1+24)
        fg(1,1,1)
        lg.draw(label34,mx,diagbox.y+16+4+24)
        end
    end
    if i==0 then
        if t%128<64 then
        fg(0,0,0)
        lg.draw(emblem,diagbox.x+4+1,diagbox.y+4)
        lg.draw(emblem,diagbox.x+4-1,diagbox.y+4)
        lg.draw(emblem,diagbox.x+4,diagbox.y+4+1)
        lg.draw(emblem,diagbox.x+4,diagbox.y+4-1)
        fg(1,1,1)
        lg.draw(emblem,diagbox.x+4,diagbox.y+4)
        else
        fg(1,1,1)
        lg.draw(leo,diagbox.x+16,diagbox.y+16,0,96/leo:getWidth(),96/leo:getWidth())
        fg(0,0,0)
        local mx=diagbox.x+16+96+2
        lg.draw(leo_label,mx-1,diagbox.y+16+4)
        lg.draw(leo_label,mx+1,diagbox.y+16+4)
        lg.draw(leo_label,mx,diagbox.y+16+4-1)
        lg.draw(leo_label,mx,diagbox.y+16+4+1)
        fg(1,1,1)
        lg.draw(leo_label,mx,diagbox.y+16+4)
        fg(0,0,0)
        local mx=diagbox.x+16+96+2
        lg.draw(label32,mx-1,diagbox.y+16+4+24)
        lg.draw(label32,mx+1,diagbox.y+16+4+24)
        lg.draw(label32,mx,diagbox.y+16+4-1+24)
        lg.draw(label32,mx,diagbox.y+16+4+1+24)
        fg(1,1,1)
        lg.draw(label32,mx,diagbox.y+16+4+24)
        end
    end
    end
end