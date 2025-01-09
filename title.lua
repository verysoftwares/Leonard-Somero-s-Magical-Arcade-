function title_start()
    love.update=title_update
    love.draw=title_draw
    turn=pi/2+pi/4
    matrotX=mat_rotY(turn)
    camera3d.x=camera3d.x-210
    camera3d.y=camera3d.y-10
    camera3d.z=camera3d.z+20
    title_font1=love.graphics.newFont('wares/Pop Core.ttf',88)
    title_font2=love.graphics.newFont('wares/Pop Core.ttf',42+22)
    title_font3=love.graphics.newFont('wares/Pop Core.ttf',160-12+6)
end

function title_update()
    turn=pi/2+pi/4+sin(t*0.006)
    matrotX=mat_rotY(turn)
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
    local test_tex5=love.graphics.newCanvas(924,926)

function title_draw()
    love.graphics.setCanvas({{canvas},stencil=true,depth=true})
    love.graphics.clear(0.0122*14,0.012*14,0.025*14)

    local ct=texture_stream()

    threed_shader:send('proj',projmat2)
    threed_shader:send('rotX',matrotX)
    --loveprint(camera3d.x,camera3d.y,camera3d.z)
    threed_shader:send('camera3d',{camera3d.x+sin(t*0.02)*25,camera3d.y+sin(t*0.02)*25,camera3d.z+sin(t*0.02)*25,0})
    --local tex={test_tex,test_tex2,test_tex3,test_tex4}
    --local ct=tex[math.floor((t*0.08)%4+1)]    
    --ct=cube_tex[math.floor((t*0.08)%7+1)]
    --threed_shader:send('tex2',ct)
    --threed_shader:send('tex2',test_tex)
    love.graphics.setCanvas(test_tex5)
    love.graphics.draw(ct)
    love.graphics.setCanvas({{canvas},stencil=true,depth=true})
    love.graphics.setShader(threed_shader)
    threed_shader:send('tex3',test_tex5)
    threed_shader:send('drift',(t*0.02*0.2)%1)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(mesh,0,0)
    love.graphics.setShader()
    --love.graphics.print(string.format('(%d,%d,%d,%s)',camera3d.x,camera3d.y,camera3d.z,totime(t)))

    if images then -- love.load has been called
        diag_draw()
    end

    -- VIDEO PREVIEW
        --love.graphics.draw(test_tex4)
        --love.graphics.draw(test_tex5)

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

function texture_stream()
    local tex={test_tex4,test_tex4,test_tex4b,test_tex4,test_tex4c}
    local ct=tex[math.floor((t*0.08)%#tex+1)]
    for i,tx in ipairs(tex) do if not (tx==test_tex6b) then tx:pause() end end
    if ct==test_tex6b then return ct end
    ct:play()
    return ct
end

--loveprint(type(test_tex4))