--tween
--maybe always/cease
--maybe better locks/flags/when

--debug = true

function make_scene()
    scene = {}
end

function sf(a,b) 
    return a.layer<b.layer
end

function sortlayer()
    table.sort(scene, sf)
end

function clear(tbl)
    for i, obj in ipairs(tbl) do
        tbl[i] = nil
    end
end

function jammer(vals)
    if vals==nil then vals={} end
    obj = {}
    obj.x=0;obj.y=0;obj.layer = 0; obj.dir = 0; obj.w = 12; obj.h = 12; obj.dx=0; obj.dy=0; obj.imgx=0; obj.imgy=0; obj.t=0;
    for k,v in pairs(vals) do
        obj[k]=v
    end
    if not obj.blockadd then table.insert(scene, obj) end
    return obj
end

function has(obj, what)
    return obj[what] ~= nil
end

function allact(tbl, tag, args)
    -- call method 'func' of all possible objects in scene
    for i, obj in ipairs(tbl) do
        if has(obj, tag) then
            obj[tag](obj, args)
        end
    end
end

function allfunc(tbl, func, args)
    -- call function 'func' using all objects in scene
    for i, obj in ipairs(tbl) do
        func(obj, args)
    end
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function slick_coll(a,b)
    return a.sciss.x < b.sciss.x+b.sciss.w and
           b.sciss.x < a.sciss.x+a.sciss.w and
           a.sciss.y < b.sciss.y+b.sciss.h and
           b.sciss.y < a.sciss.y+a.sciss.h
end

function collpoint(a,b)
    return a.x<=b.x and b.x<a.x+a.w
       and a.y<=b.y and b.y<a.y+a.h
end

lastany = nil
function any(tbl, who, func)
    out = nil
    for i, obj in ipairs(tbl) do
        if obj ~= who and func(who, obj) then
            out = obj
            break
        end
    end
    lastany = out
    return out
end

keyboard = {}
function tapped(k)
    if love.keyboard.isDown(k) then
        if not keyboard[k] then
            keyboard[k]=true
            return true
        end
    else 
        keyboard[k]=false
        return false 
    end
end

function dprint(msg)
    if not debug then return end
    print(msg)
end

function drawable(j, img,layer)
    j.img = img
    if img==slick_images.square then j.rain="square" end
    if img==slick_images.edge then j.rain="edge" end
    j.draw = draw
    j.w = j.w==nil and j.img:getWidth() or j.w 
    j.h = j.h==nil and j.img:getHeight() or j.h
    j.layer = layer==nil and 0 or layer
    return j
end

function math.round(x)
  if x%2 ~= 0.5 then
    return math.floor(x+0.5)
  end
  return x-0.5
end

function unlock()
    scene.lock = scene.lock-1
    if scene.lock==0 then scene.unlock_call() end
end

function countdown(me) 
    if me.t<=0 then 
        me.call()
        me.update = wait
        if me.during then die(me.during) end
        die(me)
        return 
    end
    me.t = me.t - 1 
    if me.during then me.during.update(me) end    
end

function delay(t, call)
    j = jammer()
    j.t = t
    j.call = call
    j.update = countdown
    last = j
    return j
end
function minidelay(t, call)
    j = {}
    j.t = t
    j.call = call
    j.update = countdown
    last = j
    return j
end

function during(j, act)
    d = jammer()
    j.during = d
    d.update = act
end

function nextavail()
    for i=1,3 do
        blockt = false
        tx,ty = gui.board.x+gui.board.space*i, gui.board.y
        for j,v in ipairs(scene.board) do
            if v.tx==tx and v.ty==ty then
                blockt = true
                break
            end
        end
        if not blockt then return tx,ty end
    end
end

function movetoboard(card, i)
    card.tx, card.ty = nextavail()
    card.sx = 1
    card.layer = 90-i
    delay(i*12, function() card.update = function(card) 
        card.x = card.x + (card.tx-card.x)*0.15
        card.y = card.y + (card.ty-card.y)*0.15

        if card.tx-card.x<0.5 and card.ty-card.y<0.5 then
            card.update = cardturn
            card.layer = 20
        end
    end end)
end

function topcard(deck, i)
    if #deck==0 then return end
    table.insert(scene.board, deck[#deck])
    movetoboard(deck[#deck], i)
    table.remove(deck, #deck)
end

function carddesc(me)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(94,19,0)
    love.graphics.rectangle("fill",gui.msgbox.x,gui.msgbox.y,gui.msgbox.w,gui.msgbox.h)
    love.graphics.setColor(r,g,b)
    love.graphics.printf(db[me.ctype].title .. '\n\n' .. db[me.ctype].desc, gui.msgbox.x, gui.msgbox.y, gui.msgbox.w, "center", 0)
    love.graphics.setColor(255,255,255)
end

function within(tbl, who)
    for i,v in ipairs(tbl) do
        if v==who then return true end
    end
    return false
end

function wait(me)
end

function randomchoice(tbl)
    if not #tbl then
        dprint("Empty table") 
        return nil
    end
    return tbl[love.math.random(1, #tbl)]
end

function remove(tbl, who)
    for i,v in ipairs(tbl) do
        if v==who then table.remove(tbl, i); return end
    end
end

function die(who)
    if who.dead then return end
    
    table.insert(hospice, who)
    who.update = nil
    --who.dead = true
end

function gfxgen()
    love.graphics.setDefaultFilter("nearest","nearest")
    local files = love.filesystem.getDirectoryItems("wares/slick-slices-assets")
    for k, file in ipairs(files) do
        if string.find(file, ".png") ~= nil then
            iname = string.gsub(file, ".png", "")
            slick_images[iname] = love.graphics.newImage("wares/slick-slices-assets/" .. iname .. ".png")
            origimg[iname] = love.graphics.newImage("wares/slick-slices-assets/" .. iname .. ".png")
        end 
        if string.find(file, ".wav") ~= nil then
            sname = string.gsub(file, ".wav", "")
            slick_sfx[sname] = love.audio.newSource("wares/slick-slices-assets/" .. sname .. ".wav",'static')
            slick_sfx[sname]:setPitch(0.7885)
            slick_sfx[sname]:setVolume(0.6)
        end
    end
    --for k,v in pairs(slick_images) do
    --    origimg[k] = love.graphics.newImage(v:getData())
    --end

end

function justrect()
    love.graphics.setColor(224,220,196)
    love.graphics.rectangle("fill",0,0,gui.sw,gui.sh)
    love.graphics.setColor(255,255,255)
end

function deffind(tbl, who)
    for i,v in ipairs(tbl) do
        if v==who then return i end
    end
    return #tbl+1
end

function basicfind(tbl, who)
    for i,v in ipairs(tbl) do
        if v==who then return i end
    end
    return -1
end

function basicfind2(tbl, cmp)
    for i,v in pairs(tbl) do
        if cmp(v) then return i end
    end
    return nil
end

oncestop = {}
function once(func, fname)
    if fname == nil then fname = deffind(oncestop, func) end
    -- probably don't want to refer to that one again anyway
    -- needs to be non-anonymous tho
    if oncestop[fname] then return end
    func()
    oncestop[fname] = func
end

function again(fname)
    oncestop[fname] = nil
end

tap = false
tint = 160
function strobe()
    if love.keyboard.isDown('c') then
        if not tap then
            r,g,b = tint+love.math.random(255-tint),tint+love.math.random(255-tint),tint+love.math.random(255-tint)
            tap = true
        end
    else
        tap = false
    end
end

function HSL(h, s, l, a)
    if s<=0 then return l,l,l,a end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

function time()
    return scene.t
end

lasth = {r=221,g=190,b=124}
function xyrgba(x, y, r, g, b, a, me)
    if (r==221 and g==190 and b==124) then --or a==254 
        return HSL(254/3.0+(254/2.0)*math.sin((y+x)*0.2+time()*0.05),220,200,a)
    end
    if r==17 and g==17 and b==17 and x+y>=15*16 and x+y<27*16 then
        r = 80+math.sin((y+time())*0.01)*60
        g = g
        b = 120+math.sin((y+time())*0.015)*20
        return r-r%16,g,b-50+math.sin(time()*0.005)*50,a
    end
    if r==150 then
        t = 10+math.sin(time())*20
        return r+t,190+t,b+t,a
    end
    if r==190 then
        t = math.sin(time()*0.05)*80
        --return r+t,g+(80-t),b,a
        --return HSL(255-40+math.sin(time()*0.05)*40,180,130,a)
        return HSL(234,230,95+math.sin(time()*0.05)*20,a)
    end
    if x+y<12*16 or x+y>=30*16 then
        cp = math.abs(21*16-(x+y))*0.18
        r=r+cp-40
        g=g+cp-40
        b=b+cp-40
        return r-r%16,g-g%16,b-b%16,a
    end
    return r,g,b,a
end

function rainbow(mi, ta, me)
    local imgData = mi
    imgData:mapPixel(xyrgba)
    imgyouwant = love.graphics.newImage(imgData)
    return imgyouwant
end

slick_fadeout = {r=1,g=1,b=1}
function slick_draw2(me,ta)
    love.graphics.setColor(1,1,1)
    if me.imgcolor then love.graphics.setColor(me.imgcolor.r,me.imgcolor.g,me.imgcolor.b) end
    local r,g,b,a
    if me.rainbow then 
        r,g,b,a=HSL((scene.t+64)%256,220,220,255)
        love.graphics.setColor(r/255,g/255,b/255,a/255) 
    end
    if me.rainbow2 then 
        r,g,b,a=HSL(((scene.t+64)*8)%256,240,180,255)
        love.graphics.setColor(r/255,g/255,b/255,a/255) 
    end

    -- ox kussee
    -- if  me.x+me.img:getWidth() < -scene.camera.x or 
    --     me.x >= -scene.camera.x+love.graphics.getWidth()/scale or
    --     me.y+me.img:getHeight() < -scene.camera.y or 
    --     me.y >= -scene.camera.y+love.graphics.getHeight()/scale 
    --     then return end
    --sx = me.sx==nil and 1 or me.sx
    --ox = me.ox==nil and 0 or me.ox
    --if me.disconnect~=nil and me.disconnect>0 then 
    --    love.graphics.setColor(64,64,64) 
    --    me.disconnect = me.disconnect - 1
    --    if me.disconnect==0 then
    --        die(me)
    --    end
        -- and probably some text
    --end

    --if me.img==slick_images.bg_form3 or me.img==slick_images.obstacle or me.img==slick_images.square_green or me.img==slick_images.square_blue or me.img==slick_images.square or me.img==slick_images.warn or me.img==slick_images.edge or me.img==slick_images.edge2 then imgyouwant = rainbow(me.img, ta, me)
    --else 
    love.graphics.setScissor()
    if me.sciss then love.graphics.setScissor(me.sciss.x,me.sciss.y+scene.camera.y,me.sciss.w,me.sciss.h) end
    imgyouwant = me.img --end
    --if me.rain=="square" then
    --    imgyouwant = slick_images.square
    --end

    local angle = 0
    if me.angle then angle = me.angle end
    --if me.dir ~= nil then angle=me.dir*math.pi/2 end 
    if me.imgx==nil then me.imgx=0 end
    if me.imgy==nil then me.imgy=0 end
    flip = 1
    xtune=0
    if me.flip then 
        flip=-1 
        xtune = me.w
    end
    love.graphics.draw(imgyouwant, math.round(scene.camera.x+me.x+me.imgx+xtune), math.round(scene.camera.y+me.y+me.imgy), angle, flip, 1)
    love.graphics.setScissor()
    if me.img2 then love.graphics.draw(me.img2, me.x+me.imgx2, me.y+me.imgx2, 0) end

    love.graphics.setColor(255/255,0,255/255,128/255)
    --love.graphics.rectangle("fill",me.x,me.y,me.w,me.h)

    love.graphics.setColor(255/255,255/255,255/255)
end

function groupdraw(me,ta)
    -- first, set the size of the custom "ballpark". this is referenced by later elements to adjust all or some of their polygon's points.
    --me.customh = me.customrender(me)

    ox,oy = me.x+scene.camera.x,me.y+scene.camera.y
    for k,v in pairs(me.imggroup) do
        -- spacing increases on every row according to the tallest element. elements can be stacked (like a bar with a surrounding line).
        hadd = 0

        love.graphics.setColor(255/255,255/255,255/255,255/255)
        if v.x==nil then v.x=0 end
        if v.y==nil then v.y=0 end
        if v.imgcolor then love.graphics.setColor(v.imgcolor.r/255,v.imgcolor.g/255,v.imgcolor.b/255) end
        
        if v.blink and scene.t%v.blink>=v.blink/2 then goto continue end

        if v.custom then
            local custdata = gui.style[me.style].custom
            love.graphics.draw(me.custom,me.x+custdata.x,me.y+custdata.y)
        end
        if v.text then
            v.img = love.graphics.newText(gui.fonts[v.text], me.name)
            v.text = nil
        end
        if v.bar then
            local bardata = gui.style[me.style].bar
            ba = v.bar(me)
            if ba~=nil then
                love.graphics.draw(ba, ox+bardata.x, oy+bardata.y+me.customh+gui.style[me.style].custom.y)
            end
        end
        if v.shape then
            if v.shape=="polygon" then
                love.graphics.polygon(v.drawmode, v.points(ox+v.x,oy+v.y,me))
            elseif v.shape=="line" then
                love.graphics.line(v.points(ox+v.x,oy+v.y,me))
            end
        end
        if v.img then       
            if v.x==nil then v.x=0 end
            if v.y==nil then v.y=0 end
            angle = 0
            if v.dir~=nil then 
                angle=v.dir*math.pi/2 
                if v.dir==0 then vx=0; vy=0 end
                if v.dir==1 then vx=12; vy=0 end
                if v.dir==2 then vx=12; vy=12 end
                if v.dir==3 then vy=12; vx=0 end
                love.graphics.draw(v.img, math.round(scene.camera.x+me.x+v.x+vx), math.round(scene.camera.y+me.y+v.y+vy), angle)
            else
                love.graphics.draw(v.img, math.round(scene.camera.x+me.x+v.x), math.round(scene.camera.y+me.y+v.y), angle)
            end
        end
        --if not v.stack then oy = oy+10 end

        ::continue::
    end
    love.graphics.setColor(255/255,255/255,255/255)
end

-- Updating
function slick_update(dt)
    --[[if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end]]
    if tapped('r') then
        scene.reset()
    end

    sortlayer()
    if not scene.pause then allact(scene, "update")
    else scene.pause.update(scene.pause) end

    for i,v in ipairs(hospice) do
        remove(scene, v)
    end
    hospice = {}

    scene.t = scene.t+1
end

function copyimgdata(img)
    local c = love.graphics.newCanvas(img:getWidth(), img:getHeight())
    love.graphics.draw(img, 0,0, 0, 0,0)
    return c:newImageData()
end

-- Drawing
function slick_draw()    
    love.graphics.setCanvas(ss_canvas)
    love.graphics.clear()
    love.graphics.setColor(255/255,255/255,255/255)

    --slick_images.square = rainbow(love.graphics.newImage(copyimgdata(origimg.square)), ta, me)
    
    --slick_images.square:getData():paste(imgyouwant:getData(),0,0)
    
    if scene.bg then scene.bg.draw(scene.bg) end
    for i, obj in ipairs(scene) do
        if has(obj, "draw") then
            obj["draw"](obj, scene.t)
        end
    end
    if scene.pause then scene.pause.draw(scene.pause) end
    
    
    --love.graphics.setCanvas(canvas2)
    --love.graphics.clear()
    --love.graphics.setColor(255,255,255)

    --trip:send("taimu",scene.t)
    --love.graphics.draw(canvas,0,0)
    -- scaling
    --love.graphics.print(string.format("level %x", walker.g), 0, 0,0,gui.canvas.scale*2,gui.canvas.scale*2)
    --if stop then love.graphics.print(string.format("find %x", maxgen), 12*48-4+12, 0,0,gui.canvas.scale*2,gui.canvas.scale*2)
    --else love.graphics.print(string.format("%x", #tree.gen), 12*54+4, 0,0,gui.canvas.scale*2,gui.canvas.scale*2) end 

    --love.graphics.setColor(fadeout.r,fadeout.g,fadeout.b)
    --love.graphics.draw(rainbow(canvas:newImageData(), ta, nil), gui.canvas.x, gui.canvas.y, 0, gui.canvas.scale, gui.canvas.scale)
    --xorro:send("t", scene.t)
    --love.graphics.setShader(xorro)
    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(gui.bg.r,gui.bg.g,gui.bg.b)

    love.graphics.draw(ss_canvas, gui.canvas.x, gui.canvas.y, 0, gui.scale, gui.scale)
    if scene.rec and scene.t%2==0 then
        local screenshot = love.graphics.newScreenshot();
        screenshot:encode('png', os.time() .. '-' .. scene.t .. '.png');
    end
end

function slick_load(arg)
    scene = {lock={}}
    hospice = {}
    r,g,b=255,250,200

    ss_canvas = nil
    --canvas2 = nil
    --sw,sh = nil,nil

    slick_images = {}  -- auto-fetched at loading time from the assets folder
    origimg = {}
    slick_sfx = {}
    db = {c_unknown = {title="Unknown thingy", desc="I don't know what this thing does."},
         }

    gfxgen()

    gui = {
        scale=2,
        sw=nil,sh=nil,
        bg={r=64/255,g=200/255,b=30/255},
        fg={r=64/255,g=200/255,b=30/255},
        canvas={x=0,y=0},
        canvas2={x=0,y=12*21*2},
        custom={},
        fonts={},        
    }

    love.graphics.setDefaultFilter("nearest", "nearest")
    --love.mouse.setVisible(false)
    gui.fonts.wendy = love.graphics.newFont("wares/slick-slices-assets/wendy.ttf", 10)
    gui.fonts.f1font = love.graphics.newFont("wares/slick-slices-assets/acknowtt.ttf", 13)
    gui.fonts.ledfont = love.graphics.newFont("wares/slick-slices-assets/V5PRC___.TTF", 19)
    gui.fonts.ledfont:setLineHeight(0.8)
    love.graphics.setFont(gui.fonts.ledfont)

    muse = love.audio.newSource("wares/slick-slices-assets/music.ogg", "static")
    muse:setVolume(0.8)
    muse:setLooping(true)
    muse:play()
    cur_audio=muse

    winresize()
    slick_reset()
end

palette = {
    {r=14/255,g=10/255,b=30/255},
    {r=240/255,g=240/255,b=240/255},
    {r=32/255,g=48/255,b=48/255},
}

function winresize()
    gui.sw, gui.sh = 12*26*2,12*21*2
    gui.rw = gui.sw;    gui.rh = gui.sh;
    gui.sw = gui.sw/gui.scale;    gui.sh = gui.sh/gui.scale;
    ss_canvas = love.graphics.newCanvas(gui.sw, gui.sh)
end

function sayer(me)
    me.y = me.y-1
    me.t = me.t+1
    if me.t>=40 then die(me) end
end
function say(words, who)
    txt = love.graphics.newText(gui.fonts.wendy, words)
    sx = who.sciss.x+who.sciss.w+4
    if active.i%2==0 then sx = who.sciss.x-txt:getWidth()-4 end
    j = jammer({x=sx,y=who.y+who.h-8,t=0,layer=88,draw=slick_draw2,img=txt,rainbow=true,update=sayer})
    if words=="Perfect!" then j.rainbow = false; j.rainbow2=true end
end

function stop()
    active.update = fall
    --if active.prev then active.prev.update=nil end
    if active.i==0 then 
        active.update=nil
    end
end
function scroll(me)
    if me.add<0 and scene.camera.y<=0 then scene.camera.y=0; me.add=-me.add end
    if me.add>0 and scene.camera.y>me.op then scene.camera.y=me.op; me.add=-me.add end
    scene.camera.y=scene.camera.y+me.add
end
function lose(me)
    extratext="\n\nR to reset."
    if active.i>5 then jammer({update=scroll,add=-1,op=scene.camera.y}) end
    scene.dj.turnitup = true
end

function cut(me,v)
    oldw = me.sciss.w
    cx=0; cy=me.y; cw=me.w; ch=me.h
    if me.sciss.x<v.sciss.x then cw = me.sciss.x+me.sciss.w-v.sciss.x; cx=me.sciss.w-cw end
    if me.sciss.x>=v.sciss.x then cw = v.sciss.x+v.sciss.w-me.sciss.x end
    if cw<0 then cw=0 end
    if cw>v.sciss.w then cw=v.sciss.w end
    me.sciss={x=me.sciss.x+cx,y=me.y,h=24,w=cw}
    
    info = string.format("%d px", cw-oldw)
    if cw-oldw<0 then add_paws(1,'successful stack') end
    if cw-oldw==0 then info = "Perfect!"; add_paws(2,'perfect stack') end
    say(info, me)
    snd(me, cw-oldw)
    muse:setVolume(muse:getVolume()*0.85)
end
amplaying = nil
function snd(who, loss)
    sndfont = "s"
    if loss==0 then sndfont = "c" end
    if amplaying ~= nil then amplaying:stop() end
    amplaying = slick_sfx[sndfont .. ((who.i)%8+1)]
    amplaying:play()
    --print((who.i)%8+1,love.audio.getSourceCount( ))
end
function fall(me)
    me.y=me.y+1
    me.sciss.y=me.y
    for i,v in ipairs(scene) do
        if v~=me and v.type=="block" and slick_coll(me,v) then
            me.y=me.y-1 
            me.sciss.y=me.y
            me.update=nil
            cut(me,v)
            spawn()
            if me.moved then lose(); return end
            check=true
            score = score+1
            return
        end
    end
    if not me.moved then
        if amplaying ~= nil then amplaying:stop() end
        amplaying = slick_sfx.pew
        amplaying:play()
    end
    me.moved=true
    --if me.y>=-scene.camera.y+gui.sh then 
    me.sciss.h=me.sciss.h-1
    if me.sciss.h==0 then
        lose() 
        me.update=nil
        me.draw=nil
        check = false
    end
    --end
end
spd = 2
function move(me)
    me.x=me.x+me.dx
    if me.x<=boxl then me.dx=spd end
    if me.x>=boxr-me.sciss.w then me.dx=-spd end
    if me.y<120 then scene.camera.y=scene.camera.y+((-me.y+120)-scene.camera.y)*0.1 end
    me.sciss.x=me.x; me.sciss.y=me.y
end
function spawn()
    h = gui.sh-24
    i=0
    if active~=nil then h=active.y-24; i=active.i+1 end
    sciss={x=0,y=0,w=48,h=24}
    if active~=nil then sciss.w=active.sciss.w end
    active = jammer({sciss=sciss,x=boxr-sciss.w,y=h,w=48,h=24,i=i,layer=8,prev=active,type="block",dx=-spd,update=move,img=slick_images.block,draw=slick_draw2})
    if active.prev==nil then active.imggroup={{img=slick_images.block},{img=love.graphics.newText(gui.fonts.ledfont, "< Z"),x=52,blink=40}}; active.draw=groupdraw end
    check=false
end

function tap(me)
    if check and tapped("z") then
        --scene.dj.turnitdown = true
        stop()
        if active.i==0 then 
            if amplaying ~= nil then amplaying:stop() end
            amplaying = slick_sfx.s1
            amplaying:play()
            active.imggroup = {{img=slick_images.block}}
            spawn()
            check = true
        end
    end
end
function scorewrite(me)
    love.graphics.setFont(gui.fonts.ledfont)
    local r,g,b,a=HSL(scene.t%256,40,80,255)
    love.graphics.setColor(r/255,g/255,b/255,a/255)
    love.graphics.rectangle("fill",boxl,0,boxr-boxl,gui.sh)
    r,g,b,a=HSL((scene.t+64)%256,220,240,255)
    love.graphics.setColor(r/255,g/255,b/255,a/255)
    love.graphics.printf(string.format("Score:\n%d" .. extratext, score), boxr, 0, boxl, "right")
    love.graphics.printf(string.format("Slick Slices"), 0, 0, boxl, "right")
    --love.graphics.setFont(gui.fonts.f1font)
    --love.graphics.printf(string.format("soft_wizard"), 0, 40-6-5, boxl, "right")
    love.graphics.setColor(255/255,255/255,255/255)
end

function dj(me)
    if me.turnitup then
        me.turnitdown = false
        muse:setVolume(muse:getVolume()+0.02)
        if muse:getVolume()>=0.8 then 
            muse:setVolume(0.8)
            me.turnitup = false
        end
    end
    if me.turnitdown then
        me.turnitup = false
        muse:setVolume(muse:getVolume()-0.02)
        if muse:getVolume()<=0 then 
            muse:setVolume(0)
            me.turnitdown = false
        end
    end
end

first=true
function slick_reset()
    gui.bg.r = palette[1].r
    gui.bg.g = palette[1].g
    gui.bg.b = palette[1].b
    love.graphics.setBackgroundColor(gui.bg.r, gui.bg.g, gui.bg.b)
    love.graphics.setCanvas(ss_canvas)
    love.graphics.clear()
    love.graphics.setCanvas()

    scene = {reset=slick_reset,t=0,camera={x=0,y=0}}
    scene.dj = jammer({update=dj})
    player1 = jammer({update=tap})
    jammer({draw=scorewrite})
    boxr=gui.sw/2+80
    boxl=gui.sw/2-80
    active = nil
    extratext=""
    inc=false
    spawn()
    score=0
    check=true
    scene.dj.turnitup = true
end