require 'alias'
require 'utility'
require 'TIC-boilerplate'
require 'perlin'
require 'slick-slices'
require 'life-of-tree'
require 'pocketbolo'
require 'psy-ball'
require 'batch-3'
require 'apoplex'
require 'dropplet'

cat_paws=0
t=0

function love.load()
    verysoft_font=love.graphics.newFont('wares/monofonto rg.otf',64)
    verysoft_font2=love.graphics.newFont('wares/monofonto rg.otf',24-2)
    handwrite_font=love.graphics.newFont('wares/Bubbly-Regular.otf',18)
    --slick_load()
    images={}
    images.diskette=love.graphics.newImage('wares/diskette.png')
    images.diskette2=love.graphics.newImage('wares/diskette2.png')
    images.diskette3=love.graphics.newImage('wares/diskette3.png')
    images.catpaw=love.graphics.newImage('wares/catpaw.png')
    audio={}
    audio.song1=love.audio.newSource('wares/vsa-music.ogg','stream')
    audio.song1:setLooping(true)
    audio.song2=love.audio.newSource('wares/vsa-music2.ogg','stream')
    audio.song2:setLooping(true)
    audio.song1:play()
    cur_audio=audio.song1
    --setup_game('Slick Slices')
    --setup_game('Batch-3')
    --setup_game('Apoplex')
    --love.draw=game_draw
    --love.update=game_update
end

love.graphics.setDefaultFilter('nearest')
--game_w=12*26*2; game_h=12*21*2
--[[game={}
game.id='PocketBolo'
game.tech='TIC-80'
game.w=240; game.h=136
game.scale=4
game.x=1280/2-(game.w*game.scale)/2
game.y=960/2-(game.h*game.scale)/2
game.canvas=love.graphics.newCanvas(game.w,game.h)
love.graphics.setCanvas(game.canvas)
love.graphics.clear(0,0,0,1)
love.graphics.setCanvas()]]
--game=nil

session_paws={}
function add_paws(paws,reason)
    session_paws[reason]=session_paws[reason] or {paws=0,n=0}
    session_paws[reason].paws=session_paws[reason].paws+paws
    session_paws[reason].n=session_paws[reason].n+1
    cat_paws=cat_paws+paws
end

function game_draw()
    gen_draw()

    if game then
    love.graphics.setCanvas(game.canvas)
    love.graphics.setColor(1,1,1,1)
    if not paused then
    if game.tech=='TIC-80' then TIC() end
    if game.id=='Slick Slices' then slick_draw() end
    if game.id=='psy-ball' then psyball_draw() end
    if game.id=='Batch-3' then batch3_draw() end
    if game.id=='Dropplet' then dropplet_draw() end
    end
    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(game.canvas,game.x,game.y,0,game.scale,game.scale)
    if paused then
    love.graphics.setColor(0.25,0.25,0.25,0.75)
    love.graphics.rectangle('fill',game.x,game.y,game.w*game.scale,game.h*game.scale)
    love.graphics.setColor(0.95,0.95,0.95,1)
    love.graphics.setFont(verysoft_font)
    love.graphics.print('PAUSED',1280/2-verysoft_font:getWidth('PAUSED')/2,game.y+80)
    love.graphics.print('R to return to hub.',1280/2-verysoft_font:getWidth('R to return to hub.')/2,game.y+80+140)
    end
    end
end

function game_update()
    if not paused then
        if game.id=='Slick Slices' then
            slick_update()
        end
        if game.id=='psy-ball' then
            psyball_update()
        end
        if game.id=='Batch-3' then
            batch3_update()
        end
        if game.id=='Dropplet' then
            dropplet_update()
        end
    end
    --TIC()
    if tapped('escape') then 
        paused=not paused 
        if paused then
            if cur_audio then cur_audio:pause() end
        else
            if cur_audio then cur_audio:play() end
        end
    end
    if paused and tapped('r') then
        if pairslength(session_paws)>0 then
        love.update=modal_update
        love.draw=modal_draw
        if cur_audio then
        cur_audio:stop()
        end
        cur_audio=audio.song2
        cur_audio:play()
        game=nil
        else
        love.update=diskettes_update
        love.draw=diskettes_draw
        if cur_audio then
        cur_audio:stop()
        end
        cur_audio=audio.song1
        cur_audio:play()
        game=nil 
        end
    end
    t=t+1
end

function modal_update()
    if tapped('r') or tapped('z') or tapped('return') or tapped('escape') then
        love.update=diskettes_update
        love.draw=diskettes_draw
        cur_audio:stop()
        cur_audio=audio.song1
        cur_audio:play()
        game=nil
    end
    t=t+1
end

function gen_draw()
    love.graphics.setCanvas()
    --if not game then
    love.graphics.clear(0.95,0.95,0.95,1)
    --else
    --love.graphics.clear(unpack(game.color))
    --end
    love.graphics.setColor(0.4,0.3,0.25,1)
    love.graphics.setFont(verysoft_font)
    love.graphics.print('~Å_Å~\n=\'-\'=\nU   U/*\n c  c')
    love.graphics.print(string.format('x%d',cat_paws),1280/2-64+64,800+32+24+24)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(images.catpaw,1280/2-64,800+32+24+24)
end

function modal_draw()
    gen_draw()

    local i=0
    local c=0
    for k,stat in pairs(session_paws) do
        c=c+stat.paws
    end
    for k,stat in pairs(session_paws) do
        love.graphics.setFont(verysoft_font)
        local msg='Session results'
        local tx=0
        for i=1,#msg do
        local char=string.sub(msg,i,i)
        local r,g,b,a=HSL((t+i)%256,255,64)
        love.graphics.setColor(r,g,b,a)
        love.graphics.print(char,64+100+tx,240+100+math.sin(t*0.2+i*0.4)*12)
        tx=tx+verysoft_font:getWidth(char)
        end
        love.graphics.setColor(0.4,0.3,0.25,1)
        love.graphics.print(string.format('%s x%d',k,stat.n),64+100,240+100+100+i*64)
        --love.graphics.print(string.format('x%d',stat.n),64+100+verysoft_font:getWidth(k)+64,240+100+100+i*64)
        love.graphics.print(string.format('+%d',stat.paws),64+100+640+90,240+100+100+i*64)
        --love.graphics.print(string.format('%.2f cat paws/minute',c/(60*60)))
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(images.catpaw,64+100+640+90+verysoft_font:getWidth(string.format('+%d',stat.paws)),240+100+100+i*64)
        i=i+1
    end
end

love.update=game_update
love.draw=game_draw

function setup_game(id)
    cur_audio:stop()
    cur_audio=nil
    game={}
    game.id=id
    if game.id=='Slick Slices' then
        slick_load()
        game.w=12*26*2; game.h=12*21*2
        game.scale=1
        game.tech='LÖVE'
        game.color={12/255,12/255,12/255}
    end
    if game.id=='Life of Tree' then
        life_of_tree_reset()
        game.tech='TIC-80'
    end
    if game.id=='PocketBolo' then
        pocketbolo_reset()
        game.tech='TIC-80'
    end
    if game.id=='psy-ball' then
        psyball_load()
        game.w=12*60; game.h=12*60
        game.scale=1
        game.tech='LÖVE'
    end
    if game.id=='Batch-3' then
        batch3_load()
        game.y=10
        game.w=28*36; game.h=24*36
        game.scale=1
    end
    if game.id=='Apoplex' then
        apoplex_reset()
        game.w=64; game.h=64
        game.tech='TIC-80'
        game.scale=8
    end
    if game.id=='Dropplet' then
        dropplet_load()
        game.w=1280-200-64; game.h=720+48
        --game.y=10
        game.tech='LÖVE'
        game.scale=1
    end

    if game.tech=='TIC-80' then
        if not game.w then game.w=240 end; if not game.h then game.h=136 end
        if not game.scale then game.scale=4 end
        sprite_quads={}
    end
    if not game.x then game.x=1280/2-(game.w*game.scale)/2 end
    if not game.y then game.y=960/2-(game.h*game.scale)/2 end
    game.canvas=love.graphics.newCanvas(game.w,game.h)
    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(0,0,0,1)
    love.graphics.setCanvas()
    love.update=game_update
    love.draw=game_fade
    paused=false
    game_t=t+1
    session_paws={}
end

diskettes={
    {'Slick Slices',{'Life of Tree',{'Dropplet',{'Vase','Panic Percussion'},'psy-ball',{'ZETPACK-99',{'Multiple Maze'},'finding yourself in the forest'}}},{'PocketBolo',{'Batch-3',{'Momentum','decorate castle or go extinct.'},'Apoplex',{'Sunray Valley','Card Grangers DX'}},'ALLBUTTERF.EXE'}}
}

function diskettes_update()
    --if t==60 then cur_audio:play() end
    t=t+1
end

disk_particles={}
function diskettes_draw()
    gen_draw()

    mox,moy=love.mouse.getPosition()
    leftheld=left
    left=love.mouse.isDown(1)
    cur_depths={}
    for i,v in ipairs(diskettes) do
        --love.graphics.draw(images.diskette,96,960/2-64,0,2,2)
        depthdraw(i,v)
    end

    love.graphics.setColor(1,1,1)
    for i=#disk_particles,1,-1 do
        local p=disk_particles[i]
        p.j=p.j or i
        p.x=p.x+p.dx; p.y=p.y+p.dy
        local img=p.img
        if (p.j+t*0.2)%16<4 then
            img=batch3_images['whitenessstar'..tostring(p.i)]
        end
        lg.draw(img,p.x,p.y)
        p.dy=p.dy+0.2
        if p.y>960 then rem(disk_particles,i) end
    end
end

function get_depth(i,w)
    for j,v in ipairs(w) do
    if type(v)=='string' then
        depths[i]=depths[i] or 0
        depths[i]=depths[i]+1
    elseif type(v)=='table' then
        get_depth(i+1,v)
    end
    end
end
depths={}
for i,v in ipairs(diskettes) do
get_depth(i,v)
end

function starburst3(kx,ky)
    batch3_audio.sparkle:stop()
    batch3_audio.sparkle:play()
    for i=1,96 do
        local new={}
        new.x=kx; new.y=ky
        new.i=({1,2,2,3,3,3})[love.math.random(6)]
        new.img=batch3_images[randomchoice({'red','yellow','green','purple'})..'star'..tostring(new.i)]
        --new.dx=cos(math.rad(love.math.random(0,180)))
        --new.dy=love.math.random(-8,-2)/2
        new.dx=(random(0,11)-6)/1.5
        new.dy=(random(0,5)-6)
        ins(disk_particles,new)
    end
end

function depthdraw(i,w,prev)
    love.graphics.setLineWidth(1)
    local prevs
    for j,v in ipairs(w) do
    if type(v)=='string' then
        prevs=v
        cur_depths[i]=cur_depths[i] or 0
        if not depths[i] then trace(i) end
        --depths[i]=depths[i] or 0
        love.graphics.setColor(1,1,1,1)
        local ys=960/2-64-(depths[i]/2)*140
        local ya=cur_depths[i]*140
        if i==1 then ys=960/2-64-64; end
        if i==2 then ys=960/2-64-64-128; ya=cur_depths[i]*240 end
        if i==3 then ys=960/2-64-64-128-128; ya=cur_depths[i]*160 end
        if i==4 then ys=960/2-64-64-128-128-128+64; ya=cur_depths[i]*96 end
        if i==5 then ys=960/2-128-128 end
        if i>1 then
        local ys2=depth_cache[prev].y
        love.graphics.setColor(0.4,0.3,0.25,1)
        love.graphics.line(64+i*180+math.cos((t+i)*0.2)*2,ys+ya+64+32+math.sin((t+i)*0.25)*2,64+(i-1)*180+64+math.cos((t+(i-1))*0.2)*2,ys2+64+32+math.sin((t+(i-1))*0.25)*2)
        end
        local disk_img=images.diskette
        if not find(unlocks,v) then disk_img=images.diskette2 end
        if not available(v) then disk_img=images.diskette3 end
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(disk_img,64+i*180+math.cos((t+i)*0.2)*2,ys+ya+64+math.sin((t+i)*0.25)*2)--,0,2,2)
        love.graphics.setColor(0.4,0.3,0.25,1)
        love.graphics.setFont(verysoft_font2)
        love.graphics.print(game_costs[v],64+i*180+64/2-verysoft_font2:getWidth(game_costs[v])/2,ys+ya+64+64)
        if AABB(64+i*180,ys+ya+64,64,64,mox,moy,1,1) then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(disk_img,64+i*180-64*3/2,ys+ya+64-64*3/2,0,3,3)--,0,2,2)
        love.graphics.setColor(0.4,0.3,0.25,1)
        love.graphics.printf(v,64+i*180-64*3/2+32,ys+ya+64-64*3/2,120+20-12)
        if left and not leftheld and love.draw==diskettes_draw then
            if find(unlocks,v) then
            --cur_audio:stop()
            --cur_audio=nil
            --setup_game(v)
            game_pend=v
            gp_x,gp_y=64+i*180+32,ys+ya+64+32
            gp_t=t+1
            love.draw=game_fade
            else
                if available(v) then
                    if prev_unlocked(diskettes,v) and cat_paws>=game_costs[v] then
                    starburst3(64+i*180-32,ys+ya+64-32)
                    table.insert(unlocks,v)
                    cat_paws=cat_paws-game_costs[v]
                    end
                else
                    trace('Not in demo!')
                end
            end
        end
        end
        love.graphics.setColor(0.4,0.3,0.25,1)
        --love.graphics.printf(v,i*180,ys+ya,90)
        cur_depths[i]=cur_depths[i]+1
        depth_cache[v]={y=ys+ya}
    elseif type(v)=='table' then
        depthdraw(i+1,v,prevs)
    end
    end
end

local game_fade_canvas=love.graphics.newCanvas(1280,960)
function game_fade()
    local w=2280-(t-gp_t)*20
    local a=t*0.2*0.5
    if w>=0 then
    audio.song1:setVolume(audio.song1:getVolume()*0.98)
    diskettes_draw()
    end
    if w<0 then
    game_draw()
    end
    if w<-2280 then love.draw=game_draw end
    love.graphics.setCanvas(game_fade_canvas)
    love.graphics.clear(0.4,0.3,0.25,1)
    love.graphics.setColor(0,1,0,1)
    love.graphics.polygon('fill',gp_x+math.cos(a)*w,gp_y+math.sin(a)*w,
                                 gp_x+math.cos(a+2*math.pi/3)*w,gp_y+math.sin(a+2*math.pi/3)*w,
                                 gp_x+math.cos(a+2*math.pi/3*2)*w,gp_y+math.sin(a+2*math.pi/3*2)*w)
    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setShader(sh_trans)
    love.graphics.draw(game_fade_canvas)
    love.graphics.setShader()
    if w==-20 then setup_game(game_pend); audio.song1:setVolume(1) end
end
sh_trans=love.graphics.newShader([[
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords);
    if (pixel.g==1) { return vec4(0,0,0,0); }
    return pixel * color;
}
]])

function available(v)
    return v=='Slick Slices' or v=='Life of Tree' or v=='PocketBolo' or v=='psy-ball' or v=='Batch-3' or v=='Apoplex' or v=='Dropplet'
end

function prev_unlocked(w,tgt)
    local function getprev(w2,tgt2,prev)
        local prev2
        for j,v in ipairs(w2) do
            if type(v)=='string' then 
                if v==tgt2 then return prev end
                prev2=v
            end
            if type(v)=='table' then 
                local prev3=getprev(v,tgt2,prev2) 
                if prev3 then return prev3 end
            end
        end
    end
    tgt=getprev(w,tgt)
    while tgt do
        if not find(unlocks,tgt) then trace(string.format('Unlock %s first!',tgt)); return false end
        tgt=getprev(w,tgt)
    end
    return true
end

depth_cache={}
game_costs={
    ['Slick Slices']=0,
    ['pudding splash!']=0,
    ['ALLBUTTERF.EXE']=999,
    ['Life of Tree']=20,
    ['PocketBolo']=30,
    ['Dropplet']=150,
    ['psy-ball']=80,
    ['Batch-3']=120,
    ['Apoplex']=180,
    ['Vase']=60,
    ['Panic Percussion']=210,
    ['ZETPACK-99']=140,
    ['finding yourself in the forest']=400,
    ['Momentum']=240,
    ['decorate castle or go extinct.']=360,
    ['Sunray Valley']=300,
    ['Card Grangers DX']=50,
    ['Multiple Maze']=330,
}
unlocks={'Slick Slices'}

diskettes={{a=pi/2,genre='arcade'},{a=pi/2*3,genre='episodic'}}
da=0
function laptop_update()
    for i,d in ipairs(diskettes) do
        d.a=d.a+da
    end
    local tapleft=tapped('left')
    local taprite=tapped('right')
    if tapleft or taprite then
        local dspd=0.06
        if tapleft then da=-dspd end
        if taprite then da= dspd end
    end
end

function laptop_draw()
    love.graphics.clear(0.8,0.8,0.8,1)
    love.graphics.setFont(handwrite_font)
    for i,d in ipairs(diskettes) do        
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(images.diskette,sw/2-cos(d.a)*240,sh/2-sin(d.a)*240*0.6,0,math.abs(d.a-pi))
    love.graphics.setColor(0.2,0.2,0.2,1)
    --love.graphics.print(d.genre,sw/2-cos(d.a)*240,sh/2-sin(d.a)*240*0.6)
    end
end

-- version 1.a
--love.update=diskettes_update
--love.draw=diskettes_draw

-- version 1.b
love.update=laptop_update
love.draw=laptop_draw