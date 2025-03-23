function title_start()
    love.update=title_update
    love.draw=title_draw
    turn=pi/2+pi/4-pi/8
    matrotX=mat_rotY(turn)
    camera3d.x=camera3d.x-210-20
    camera3d.y=camera3d.y-10-10
    camera3d.z=camera3d.z+20+10
    title_font1=love.graphics.newFont('wares/Pop Core.ttf',88)
    title_font2=love.graphics.newFont('wares/Pop Core.ttf',42+22)
    title_font3=love.graphics.newFont('wares/Pop Core.ttf',160-12+6)
    --musa=love.audio.newSource('promo/lennu-levitates.ogg','stream')
    --musa:setLooping(true)
    --musa:play()
end

function title_update()
    if demomode==1 then turn=pi/2+pi/4+sin(t*0.006) end
    matrotX=mat_rotY(turn)
    if game.update then game.update() end
    t=t+1
end

-- TEXTURE STREAM
    local test_tex4=love.graphics.newVideo('promo/momentum.ogv')
    local test_tex4b=love.graphics.newVideo('promo/multiple-maze.ogv')
    local test_tex4c=love.graphics.newVideo('promo/rowbyrow-1.ogv')
    --local test_tex6=love.graphics.newVideo('promo/2025-01-08_13-43-02.ogv')
    --local test_tex6b=love.graphics.newImage('promo/5.5BF.png')
    local cur_test_tex=test_tex4
    --test_tex4:play()
    --test_tex4b:setVolume(0)
    --test_tex4c:setVolume(0)
    --test_tex4b:play()
    --test_tex4c:play()
    -- intentionally global because it adapts size in texture_stream
        test_tex5=love.graphics.newCanvas(924,926)
    local test_tex7=love.graphics.newVideo('promo/slick-slices.ogv')
    local test_tex8=love.graphics.newVideo('promo/bug-castle.ogv')
    local test_tex9=love.graphics.newVideo('promo/psy-ball.ogv')
    
    local silence=love.audio.newSource('wares/literally just 99 seconds of silence.ogg','static')
    test_tex4:setSource(silence)
    test_tex4b:setSource(silence)
    test_tex7:setSource(silence)
    test_tex8:setSource(silence)
    test_tex9:setSource(silence)

function title_draw()
    love.graphics.setCanvas({{canvas},stencil=true,depth=true})
    love.graphics.clear(0.0122*14,0.012*14,0.025*14)

    local ct=texture_stream()
    if game.draw then game.draw() end

    threed_shader2:send('proj',projmat2)
    threed_shader2:send('rotX',matrotX)
    --loveprint(camera3d.x,camera3d.y,camera3d.z)
    if demomode==1 then
    threed_shader2:send('camera3d',{camera3d.x+sin(t*0.02)*25,camera3d.y+sin(t*0.02)*25,camera3d.z+sin(t*0.02)*25,0})
    else
    threed_shader2:send('camera3d',{camera3d.x+cos(t*0.03),camera3d.y,camera3d.z+sin(t*0.03),0})
    end
    --local tex={test_tex,test_tex2,test_tex3,test_tex4}
    --local ct=tex[math.floor((t*0.08)%4+1)]    
    --ct=cube_tex[math.floor((t*0.08)%7+1)]
    --threed_shader:send('tex2',ct)
    --threed_shader:send('tex2',test_tex)
    if game.canvas then
    if not (test_tex5:getWidth()==game.canvas:getWidth()) then test_tex5=lg.newCanvas(game.canvas:getWidth(),game.canvas:getHeight()) end
    end
    love.graphics.setCanvas(test_tex5)
    if demomode==1 then love.graphics.draw(ct) end
    --love.graphics.draw(test_tex7)
    if demomode==5 then love.graphics.draw(game.canvas) end
    love.graphics.setCanvas({{canvas},stencil=true,depth=true})
    love.graphics.setShader(threed_shader2)
    if demomode==1 then
    threed_shader2:send('tex2',test_tex5)
    else
    threed_shader2:send('tex2',test_tex)
    end
    threed_shader2:send('tex3',test_tex5)
    threed_shader2:send('drift',(t*0.02*0.2)%1)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(mesh,0,0)
    love.graphics.setShader()
    --love.graphics.print(string.format('(%d,%d,%d,%s)',camera3d.x,camera3d.y,camera3d.z,totime(t)))

    lg.setCanvas(canvas)
    if not (demomode==1) then character_draw() end

    --[[
    lg.setColor(0,0,0,1)
    lg.draw(emblem,-1,0)
    lg.draw(emblem,1,0)
    lg.draw(emblem,0,-1)
    lg.draw(emblem,0,1)
    lg.setColor(1,1,1,1)
    lg.draw(emblem)
    ]]

    if images then -- love.load has been called
        diag_draw()
    end

    -- VIDEO PREVIEW
        --love.graphics.draw(test_tex4)
        --love.graphics.draw(test_tex5)

    if not (demomode==1) then 
        love.graphics.setCanvas()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(canvas)
        return
    end

    love.graphics.setCanvas(canvas)
    love.graphics.setFont(title_font2)
    --love.graphics.print('Leonard Somero\'s',0,120)
    local r,g,b=HSL(t*2%256,240,240)
    love.graphics.setColor(r/255,g/255,b/255)
    local j=0
    local msg='Leonard Somero\'s'
    for i=1,#msg do
        if j+i>t*1.2 then break end
        local char=string.sub(msg,i,i)
        local offx=0
        if i==#msg then offx=-42 end
        local spinx,spiny=0,0
        spinx=cos(t*0.02+i)*12
        spiny=sin(t*0.02+i)*12
        love.graphics.print(char,spinx+offx+6+(i-1)*62,spiny+120+sin(i)*32)
        j=j+1
    end
    love.graphics.setFont(title_font3)
    --love.graphics.print('Magical\nArcade!',0,260)
    local msg='Magical'
    for i=1,#msg do
        if j+i>t*1.2 then break end
        local char=string.sub(msg,i,i)
        local offx=0
        if i>4 then offx=-32-12 end
        --if i==#msg then offx=-42 end
        local spinx,spiny=0,0
        spinx=cos(t*0.02+i)*12
        spiny=sin(t*0.02+i)*12
        love.graphics.print(char,spinx+offx+6+(i-1)*(152-8),spiny+260+sin(i)*32)
        j=j+1
    end
    local msg='Arcade'
    for i=1,#msg do
        if j+i>t*1.2 then break end
        local char=string.sub(msg,i,i)
        local offx=0
        --if i>4 then offx=-32 end
        --if i==#msg then offx=-42 end
        local spinx,spiny=0,0
        spinx=cos(t*0.02+i+7)*12
        spiny=sin(t*0.02+i+7)*12
        love.graphics.print(char,spinx+offx+6+(i-1)*(152-8)+80,spiny+260+130+sin(i+7)*32)
        j=j+1
    end
    if j<=t*1.2 then
    local msg='!'
    local spinx,spiny=0,0
    spinx=cos(t*0.02+j)*12
    spiny=sin(t*0.02+j)*12
    love.graphics.print(msg,spinx+sw/2+180-30-60,spiny+260+150+40+30)
    end
    --[[
    local msg='Leonard Somero\'s'
    love.graphics.setFont(title_font1)
    for i=#msg,1,-1 do
        local char=string.sub(msg,i,i)
        love.graphics.print(char,i*48,21+sin(i+t*0.02)*21+i)
    end
    local msg='Magical'
    love.graphics.setFont(title_font2)
    for i=1,#msg do
        local char=string.sub(msg,i,i)
        love.graphics.print(char,i*(48+32+48),21+64+sin(i)*21+i)
    end
    local msg='Arcade!'
    love.graphics.setFont(title_font2)
    for i=1,#msg do
        local char=string.sub(msg,i,i)
        love.graphics.print(char,i*(48+32+48),21+32+64+sin(i)*21+i)
    end
    ]]

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(canvas)
end

local tex={test_tex4,test_tex8,test_tex4b,test_tex9,test_tex7}
function texture_stream()
    local ct=tex[math.floor((t*0.08)%#tex+1)]
    if not (ct:getWidth()==test_tex5:getWidth()) then test_tex5=love.graphics.newCanvas(ct:getWidth(),ct:getHeight()) end
    for i,tx in ipairs(tex) do if tx:typeOf('Video') then tx:pause() end end
    if not ct:typeOf('Video') then return ct end
    --ct:setSource(silence)
    ct:play()
    return ct
end

--loveprint(type(test_tex4))