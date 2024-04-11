--tasty = require 'tasty.tastytext'
flux = require "flux"

loaded={ocr=love.graphics.newFont("wares/dropplet-assets/OCRAEXT.TTF",18*3),
        ocr2=love.graphics.newFont("wares/dropplet-assets/OCRAEXT.TTF",18)}

function collpoint(a,b)
    return a[1]<=b[1] and b[1]<a[1]+a[3]
       and a[2]<=b[2] and b[2]<a[2]+a[4]
end

camera={x=0,y=0,dx=0,dy=0}
function dropplet_coll(a,b)
    return a[1] < b[1]+b[3] and
           b[1] < a[1]+a[3] and
           a[2] < b[2]+b[4] and
           b[2] < a[2]+a[4]
end

function randomchoice(tbl)
    if not #tbl then
        --dprint("Empty table") 
        return nil
    end
    return tbl[love.math.random(1, #tbl)]
end

--voi kiivetä 1x tiilen päälle muttei hypätä
function dropplet_load()
    loaded.ocr:setLineHeight(0.86)
    love.graphics.setFont(loaded.ocr)
    love.graphics.setLineWidth(4)
    --love.graphics.setLineStyle("rough")

    --love.graphics.setBackgroundColor(244/16,144/16,244/16)
    love.graphics.setBackgroundColor(244/2/255,144/2/255,244/2/255)
    assetgen()
    
    debug=false

    score=0

    mw=48;mh=48
    sw=1280;sh=1280
    canvas = love.graphics.newCanvas(sw,sh)
    canvas2 = love.graphics.newCanvas(sw,sh)
    canvas3 = love.graphics.newCanvas(sw,sh)
    d1=canvas
    d2=canvas2
    intro=true
    overspd=0.5
    latestboosth=0
    neverboosted=true

    p={x=600,     y=sh/2,      w=48,        juice=60*60,
        dx=0,      dy=0,       h=48,        done=false,   
        ddx=0,     ddy=0,      dropplet_combo={},                 }
    turtle={}
    chainboost=0
    ojprint=0
    particles={}
    wavet=0
    bosses=0
    wave_i=0
    ptype="bullet"
end

dropplet_images={}
dropplet_sfx={}
function assetgen()
    love.graphics.setDefaultFilter("nearest","nearest")
    local files = love.filesystem.getDirectoryItems("wares/dropplet-assets/sfx")
    for k, file in ipairs(files) do
        if string.find(file, ".wav") ~= nil then
            sname = string.gsub(file, ".wav", "")
            dropplet_sfx[sname] = love.audio.newSource("wares/dropplet-assets/sfx/" .. sname .. ".wav","static")
            dropplet_sfx[sname]:setVolume(0.8)
            if sname=="JELLYFISH" then dropplet_sfx[sname]:setLooping(true) end
            if sname=="clear" then dropplet_sfx[sname]:setVolume(0.15) end
            if sname=="ouch" then dropplet_sfx[sname]:setVolume(0.5) end
        end
    end
    local files = love.filesystem.getDirectoryItems("wares/dropplet-assets/")
    for k, file in ipairs(files) do
        if string.find(file, ".png") ~= nil then
            iname = string.gsub(file, ".png", "")
            dropplet_images[iname] = love.graphics.newImage("wares/dropplet-assets/" .. iname .. ".png")
        end 
    end

end

function dropplet_draw() 
    camera.y=(p.y-480)--*0.02
    --love.graphics.translate(camera.x,-camera.y)
    local mx,my=love.mouse.getPosition()

    love.graphics.setFont(loaded.ocr)
    
    local c1=d1
    local c2=d2
    if t%2==0 then
        local c1=d2
        local c2=d1
    end

    love.graphics.setCanvas(c1)
    love.graphics.setColor((96+60)/255,(96+60)/255,(128+60)/255,8/255)
    love.graphics.rectangle("fill",0,0,sw,sh)

    if press("r") then
        p.top_h=p.y
        p.bot_h=p.y+p.h
    end
    love.graphics.setColor((144/2+60+60+60)/255,(244/2+60+60+60)/255,(244/2+60+60+60)/255,240/255)
    --love.graphics.rectangle("fill",0,0,sw,sh)

    love.graphics.push()

    -- mx=mx-camera.x; my=my-camera.y-(#map-map.i+1)*24
    -- mx=mx-mx%48; my=my-my%48

    -- for i=#map,1,-1 do
    --     --if i>=map.i then
    --     if i<map.i-1 then break end
    --         for pos,obj in pairs(map[i]) do
    --             love.graphics.setColor(192,64,96)
    --             if i>map.i then
    --                 love.graphics.setColor(140/(i-map.i),140/(i-map.i),140/(i-map.i))
    --             end
    --             if obj.hover then
    --                 love.graphics.setColor(64,192,96)
    --                 obj.hover=nil
    --             end
    --             if i>=map.i then
    --                 love.graphics.rectangle("fill",obj[1],obj[2],obj[3],obj[4])
    --             end
    --             love.graphics.setColor(192,192,96)
    --             if i<map.i then
    --                 love.graphics.setColor(180,180,180,80)
    --                 love.graphics.rectangle("fill",obj[1],obj[2],obj[3],obj[4])
    --             end
    --             love.graphics.rectangle("line",obj[1],obj[2],obj[3],obj[4])
    --             if obj.id then
    --                 love.graphics.printf(obj.id,obj[1]+4,obj[2]+4,9999)
    --             end
    --             love.graphics.setColor(180,180,180,80)
    --             local hissebox=givehitbox(Hisse)
    --             if math.abs(hissebox[2]+hissebox[4]-obj[2])<3 then
    --                 love.graphics.rectangle("fill",obj[1],obj[2],obj[3],48)
    --             end
    --         end
    --     --end
    --     if map.i==i then chardraw(Hisse) end

    --     love.graphics.translate(0,48)
    

    -- end
    -- love.graphics.setColor(192,192,96)
    -- love.graphics.rectangle("line",mx,my,mw,mh)



    local base_a=1+math.sin(t*0.2)
    base_a=base_a*2


    --love.graphics.rotate(math.pi/4)

    love.graphics.setColor(255/16/255,255/16/255,224/255,185/255)

    local oldc = love.graphics.getCanvas()
    
    if p.boostt>0 then 
        if p.boostt>40 then
            acidcolor(); 
        end
        if p.boostt<=40 then
            if p.boostt%8<4 then
                acidcolor(); 
            end
        end
        --love.graphics.setCanvas(canvas3)  
    end

    --if not intro then
    if not p.done then
        love.graphics.rectangle("fill",p.x,p.y,p.w,p.h)

        love.graphics.setLineWidth(2)
        for i=1,8 do
            local index = 4+math.sin(math.floor(t/4)*1+i)*8
            index = math.floor(index)
            index = index*12
            love.graphics.setColor((244-index-20)/255,(244-index-20)/255,(244-index-20)/255,255/255)
            if p.boostt>0 then acidcolor() end
            love.graphics.rectangle("line",p.x+i*4-base_a,p.y+i*4-base_a,p.w-i*4*2-base_a,p.h-i*4*2-base_a)
        end
    end
    --end
    
    love.graphics.setCanvas(oldc)

    love.graphics.setLineWidth(4)
    love.graphics.setColor(255/255,255/255,255/255,255/255)

    --love.graphics.rotate(math.pi/4)

    if anyheld then particle(p,1) end
    --[[if held("s") then

        love.graphics.setColor(255/16,255/16,224,255)
        love.graphics.rectangle("fill",p.x,p.y,p.w,p.h)
        
        love.graphics.setLineWidth(2)
        for i=1,8 do
            local index = 4+math.sin(math.floor(t/4)*1+i)*8
            index = math.floor(index)
            index = index*12
            love.graphics.setColor(244-index-20,244-index-20,244-index-20,255)
            love.graphics.rectangle("line",p.x+i*4-base_a,p.y+i*4-base_a,p.w-i*4*2-base_a,p.h-i*4*2-base_a)
        end
    

    end
    ]]--

    for i,r in ipairs(particles) do
        love.graphics.push()
        if not (r.type=="msg") and r.draw then r.draw(r) end
        love.graphics.pop()
    end
    for i,r in ipairs(particles) do
        love.graphics.push()
        if (r.type=="msg") and r.draw then r.draw(r) end
        --if r.type=="itano" then
        --    love.graphics.rectangle("fill",r.x,r.y,r.r,r.r)
        --end
        love.graphics.pop()
    end
    
    love.graphics.pop()
    --[[ UNCOMMENT FOR
         top/bottom markers
    --]]
    if p.top_h and not intro then
        rainbow2()
        local lx=sw-40
        p.top_ht=p.top_ht or 0
        if math.abs(t-p.top_ht)<3 then lx=p.x end
        love.graphics.line(lx,p.top_h,sw,p.top_h)
        love.graphics.printf(tostring(math.floor((640-p.top_h)/3)).."m",sw-140,p.top_h+12,9999)
    end
    if p.bot_h and not intro then
        rainbow2()
        local lx=sw-40
        p.bot_ht=p.bot_ht or 0
        if math.abs(t-p.bot_ht)<3 then lx=p.x end
        love.graphics.line(lx,p.bot_h,sw,p.bot_h)
        love.graphics.printf(tostring(math.floor((640-p.bot_h)/3)).."m",sw-140,p.bot_h+12,9999)
    end
        rainbow2()

        p.watert=p.watert or 0
        if p.watert>50 then
            love.graphics.setColor(255/255,255/255,255/255)
            --love.graphics.setFont(loaded.ocr2)
            love.graphics.printf(p.watert,p.x,p.y+p.h,9999)
            --love.graphics.setFont(loaded.ocr)
        end    
        p.airt=p.airt or 0
        if p.airt>50 then
            love.graphics.setColor(255/255,255/255,255/255)
            --love.graphics.setFont(loaded.ocr2)
            love.graphics.printf(p.airt,p.x,p.y-p.h,9999)
            --love.graphics.setFont(loaded.ocr)
        end    

    if intro then
        local lara=4
        --[[love.graphics.printf("w",p.x-20*lara,p.y-30*lara,9999)
        love.graphics.printf("e",p.x+20*lara,p.y-30*lara,9999)
        love.graphics.printf("a",p.x-40*lara,p.y,9999)
        love.graphics.printf("d",p.x+40*lara,p.y,9999)
        love.graphics.printf("z",p.x-20*lara,p.y+30*lara,9999)
        love.graphics.printf("x",p.x+20*lara,p.y+30*lara,9999)]]
        love.graphics.print('w',p.x,p.y-40*lara)
        love.graphics.print('s',p.x,p.y+40*lara)
        love.graphics.print('a',p.x-40*lara,p.y)
        love.graphics.print('d',p.x+40*lara,p.y)
    end
    love.graphics.setCanvas(c2)
    love.graphics.setColor(255/255,255/255,255/255,255/255)
    love.graphics.setColor((255/2+40)/255,(224/4+40)/255,(255/2+20+40)/255,255/255)
    love.graphics.draw(c1,8,8)

    local scale=0.5
    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(244/2/255,144/2/255,244/2/255)
    love.graphics.setColor(255/255,255/255,255/255,255/255)
    if p.done then love.graphics.setColor(160/255,160/255,160/255,255/255) end
    love.graphics.draw(c2,0,0,0,scale,scale)
    if p.done then love.graphics.printf(losedat.msg,losedat.x,losedat.y*scale,999) end
    if p.done then love.graphics.printf(losedat.msg2,losedat.x2,losedat.y2*scale,999) end
    love.graphics.draw(canvas3,0,0,0,scale,scale)

    rainbow()
    local msec=string.format("%.2d", p.juice%60*100/60)
    love.graphics.setColor(255/255,255/255,255/255,255/255)
    rainbow()
    love.graphics.printf("Juice", 12,scale*sh, 9999)
    love.graphics.printf(tostring(math.floor(p.juice/60))..":" .. msec, 12,scale*sh+48, 9999)
    --love.graphics.rectangle("fill",0,scale*sh+12,p.juice/5000*400,4)

    --love.graphics.printf(string.format("%.5d", score),scale*sw-300+100,scale*sh,9999)
    if wave_i>0 then
        love.graphics.printf("Wave "..tostring(wave_i),scale*sw-300+100,scale*sh,9999)
        local msec=string.format("%.2d", wavet%60*100/60)
        love.graphics.printf(tostring(math.floor(wavet/60))..":" .. msec,scale*sw-300+100,scale*sh+48,9999)

    end
        if not intro and wavet<=2*60 then
            love.graphics.printf(">Preparing next wave...",12,0,9999)
        end

    local d=0
    love.graphics.setColor(255/255,255/255,255/255,255/255)
    for i,v in ipairs(p.dropplet_combo) do
        local info = ""
        if i>1 then info = info.."+" end
        info=info .. v.type.." "..v.lvl
        --if i<#p.dropplet_combo then info=info.."+" end
        love.graphics.printf(info, scale*sw, i*42,9999)
        d=d+1
    end
    d=d+1
    if #p.dropplet_combo>=1 then
        rainbow()
        local sec=boostseconds()
        dom=boostdomtype()  --global
        love.graphics.printf("="..tostring(sec)..":00 boost", scale*sw, d*42,9999)
        love.graphics.printf("("..dom.." type)", scale*sw, (d+1)*42,9999)
        latestboosth=d*42
        if neverboosted then love.graphics.printf("Use with Z.", scale*sw, latestboosth+42*3,9999) end
    end
    if p.boostt>0 then
        if latestboosth>scale*sh then latestboosth=scale*sh end 
        local msec=string.format("%.2d", p.boostt%60*100/60)
        love.graphics.printf(" "..tostring(math.floor(p.boostt/60))..":" .. msec .. " boost", scale*sw, latestboosth,9999)
        love.graphics.printf("("..dom.." type)", scale*sw, latestboosth+42,9999)
    end

    love.graphics.setCanvas(c1)
    love.graphics.setColor(255/255,255/255,255/255,255/255)
    love.graphics.draw(c2,8,8)
    if t%1==0 then
        d3=d1
        d1=d2
        d2=d3
    end
    love.graphics.setCanvas()
end

function boostdomtype()
    local d={["??"]=0}
    for i,v in ipairs(p.dropplet_combo) do
        if not d[v.type] then d[v.type]=0 end

        if v.lvl=="LV.1" then d[v.type]=d[v.type]+1 end
        if v.lvl=="LV.2" then d[v.type]=d[v.type]+2 end
        if v.lvl=="LV.3" then d[v.type]=d[v.type]+3 end
        if v.lvl=="MAX" then d[v.type]=d[v.type]+4 end
    end
    local top="??"
    for k,v in pairs(d) do
        --print(k,d[k])
        if d[k]>=d[top] then 
            top=k
            --print("ok")
        end
    end
    --print("top was",top)
    return top
end
function boostseconds()
    local sec=0
    for i,v in ipairs(p.dropplet_combo) do
        if v.lvl=="LV.1" then sec=sec+1 end
        if v.lvl=="LV.2" then sec=sec+2 end
        if v.lvl=="LV.3" then sec=sec+3 end
        if v.lvl=="MAX" then sec=sec+4 end
    end
    return sec
end

function turtle_init(e)
    turtle.a=e.a
    turtle.points={e.x+e.r/2,e.y+e.r/2}
end
function turtle_walk(n,silent)
    local tx = turtle.points[#turtle.points-1]
    local ty = turtle.points[#turtle.points]

    tx=tx+math.cos(turtle.a)*n
    ty=ty+math.sin(turtle.a)*n

    table.insert(turtle.points, tx)
    table.insert(turtle.points, ty)

end
function turtle_turn(deg)
    turtle.a=turtle.a + deg*math.pi/180
end

function kikipoly(r)
    turtle_init(r)
    local side=96
    turtle.points[1]=turtle.points[1]-math.cos(turtle.a)*28
    turtle.points[2]=turtle.points[2]-math.sin(turtle.a)*28
    turtle_turn(90)
    turtle_turn(180)
    turtle_walk(-side/2)
    turtle_walk(side)
    turtle_turn(120)
    turtle_walk(side)
    turtle_turn(120)
    turtle_walk(side)
    turtle_turn(120)
    --table.remove(turtle.points,1)
    --table.remove(turtle.points,1)
    for i,v in ipairs(turtle.points) do
        turtle.points[i]=turtle.points[i]---r.r/2---side/2
    end
    return turtle.points
end

function acidcolor()
    love.graphics.setColor(244/255,60/255,60/255,255/255)
end

function itanopoly(r)
    turtle_init(r)
    local side=48
    turtle_turn(90)
    turtle_turn(180)
    turtle_walk(side)
    turtle_turn(90+30)
    turtle_walk(side)
    turtle_turn(60)
    turtle_walk(side)
    turtle_turn(90+30)
    turtle_walk(side)

    turtle_turn(-(60))
    turtle_walk(side)
    turtle_turn(-(90+30))
    turtle_walk(side)
    turtle_turn(-(60))
    turtle_walk(side)
    table.remove(turtle.points,1)
    table.remove(turtle.points,1)
    return turtle.points
end

specs={"none","DIVE","AIR",}
function particle(e,n,type_id)
    -- n particles from e with effect matching type_id
    if type_id==nil then
        if (math.sin(t%6)*e.dy+3)<0 then
            return
        end

        table.insert(particles, {})
        local r = particles[#particles]
        local a = t*0.2
        r.x=e.x; r.y=e.y
        r.x=r.x+e.w/2-6; r.y=r.y+e.h/2-6
        r.dx=-math.cos(t%2)*e.dx-e.dx*0.2; r.dy=-math.sin(t%2)*e.dy*0.2

        --r.dx=r.dx*overspd; r.dy=r.dy*overspd;

        r.up=advance_xy2
        r.t=0; r.t_e=60
        r.a=math.atan2(r.dy,r.dx)
        r.draw=function(r) 
                          love.graphics.setColor((224+r.t)/255,(204+r.t)/255,(192+r.t)/255,185/255)
                          --love.graphics.setColor(255/16+t%65+r.t*2,255/16+r.t*1.6,224/8+r.t*1.2,185)
                          love.graphics.line(r.x+math.cos(r.a+math.pi/2)*12,r.y+math.sin(r.a+math.pi/2)*12,r.x+math.cos(r.a)*12,r.y+math.sin(r.a)*12) 
                          love.graphics.line(r.x+math.cos(r.a-math.pi/2)*12,r.y+math.sin(r.a-math.pi/2)*12,r.x+math.cos(r.a)*12,r.y+math.sin(r.a)*12) end
    end
    if type_id=="bullet" then
        table.insert(particles, 1, {})
        local r = particles[1]
        r.x=e.x; r.y=e.y--+count(particles,"msg")*24
        r.type="bullet"
        r.dx=-6;r.dy=0
        r.up=advance_xy2
        r.t=0; r.t_e=60*5
        r.r=48
        r.draw=function(r) rainbow(); love.graphics.circle("fill",r.x+24,r.y+24,48) end        
        return
    end
    if type_id=="juice" then
        --print("pop")
        --for i=1,10 do
            table.insert(particles, {})
            local r = particles[#particles]
            r.x=e.x; r.y=e.y--+count(particles,"msg")*24
            r.type="juice"
            r.dx=math.cos(love.math.random(180)*180/math.pi)*4; r.dy=3+math.sin(love.math.random(180)*180/math.pi)*1
            r.up=function(r) r.dy=r.dy+0.02; advance_xy(r); end
            r.t=0; r.t_e=60*99
            r.r=48
            r.nopuncture=true
            r.draw=function(r) 
                local lum=128+(r.t*4)%128
                lum=lum/255
                love.graphics.setColor(lum,lum,lum,224/255); love.graphics.printf("+",r.x+24,r.y+24,9999); love.graphics.setFont(loaded.ocr) end        
        --end
        return
    end
    if type_id=="ghost" then
        table.insert(particles, {})
        local r = particles[#particles]
        r.x=e.x; r.y=e.y--+count(particles,"msg")*24
        r.type="ghost"
        r.dx=-3;r.dy=0
        r.up=advance_xy2
        r.t=0; r.t_e=60*10
        r.r=48
        r.a=math.atan2(p.y-r.y, p.x-r.x); r.da=0
        r.up=function(r) 
            r.dx=r.dx+math.cos(r.a);
            r.dy=r.dy+math.sin(r.a);
            advance_xy(r)

            local a_acc=(math.atan2(p.y-r.y, p.x-r.x))-- -r.a
            loveprint(a_acc)
            r.a=a_acc--(r.a+(a_acc)*0.1)

            --r.da=r.da+(r.a+(math.atan2(p.y-r.y, p.x-r.x)+2*math.pi-r.a))*0.2
            --r.a=r.a+r.da
        end        
        r.draw=function(r) love.graphics.setColor(224/255,224/255,96/255); love.graphics.circle("fill",r.x+24,r.y+24,48) end        
        return
    end
    if type_id=="itano" then
        loveprint("itano")
        table.insert(particles, {})
        local r = particles[#particles]
        r.x=e.x; r.y=e.y--+count(particles,"msg")*24
        r.type="itano"
        r.dx=-3;r.dy=0
        r.manatee=e
        r.dx=r.dx*overspd; r.dy=r.dy*overspd;

        r.up=advance_xy2
        r.t=0; r.t_e=60*1000
        r.r=48
        r.a=math.atan2(p.y-r.y, p.x-r.x); r.da=0
        r.up=function(r) 
            r.dx=r.dx+math.cos(r.a)*0.3;
            r.dy=r.dy+math.sin(r.a)*0.3;
            r.dx=r.dx; r.dy=r.dy;
            advance_xy(r)
            local a_acc=(math.atan2(p.y-r.y, p.x-r.x))-- -r.a
            --print(a_acc)
            r.a=a_acc--(r.a+(a_acc)*0.1)
            r.mark=false
            for i,v in ipairs(particles) do
                if v.type=="itano" and v~=r and not v.mark then
                    r.dx=r.dx-0.2
                    v.dx=v.dx+0.2
                    r.mark=true
                    v.mark=true
                    return
                end
            end
        end        
        r.draw=function(r) love.graphics.setColor(224/255,224/255,96/255); 
            --love.graphics.circle("fill",r.x+24,r.y+24,48) 
            love.graphics.polygon("fill", unpack(itanopoly(r)))
        end        
        return
    end
    if type_id=="bubble" then
        table.insert(particles, 1, {})
        local r = particles[1]
        r.x=e.x; r.y=e.y--+count(particles,"msg")*24
        r.type=type_id
        r.dx=-6;r.dy=0
        r.up=advance_xy2
        r.t=0; r.t_e=60*5
        r.r=48
        --print(r.x,r.y)
        r.draw=function(r) rainbow(); love.graphics.circle("line",r.x+24,r.y+24,r.r) end        
        return
    end
    if type_id=="kemuri" then
        table.insert(particles, 1, {})
        local r = particles[1]
        r.x=e.x; r.y=e.y--+count(particles,"msg")*24
        r.type="bullet"
        r.dx=0;r.dy=0
        r.type_id="kemuri"
        r.up=advance_xy2
        r.t=0; r.t_e=60*6
        r.r=48
        r.nopuncture=true
        --print(r.x,r.y)
        r.draw=function(r) rainbow(); love.graphics.circle("line",r.x+24,r.y+24,r.r) end        
        return
    end
    if type_id=="kiki" then
        table.insert(particles, {})
        local r = particles[#particles]
        r.x=e.x; r.y=e.y
        r.a=e.a
        r.dx=math.cos(e.a)*6.5; r.dy=math.sin(e.a)*6.5
        r.dx=r.dx*overspd; r.dy=r.dy*overspd;
        r.t=0; r.t_e=60*9
        r.r=48
        r.type="kiki"
        r.up=advance_xy2
        r.draw=function (r)
            love.graphics.setColor((224+t%32)/255,(224+t%32)/255,(96+t%32)/255);
            if r.caught then acidcolor() end
            love.graphics.polygon("fill", unpack(kikipoly(r)))
        end
        return
    end
    if type_id=="gen" then
        table.insert(particles, {})
        local r = particles[#particles]
        r.x=e.x; r.y=e.y
        r.type="gen"
        r.t=0; r.t_e=9999
        r.r=48
        r.a=0
        r.nopuncture=true

        r.spec=randomchoice(specs)
        if wave_i==1 then
            while not (r.spec=="none") do
                r.spec=randomchoice(specs)
            end
        end
        if r.spec=="none" then r.spec=nil end

        r.up = function(r)             
            r.a=(r.a+(math.atan2(p.y-r.y, p.x-r.x)-r.a)*0.1)
            if t%128==0 then particle(r,1,"kiki") end
            if r.follow=="bottom" then
                r.y=r.y-(r.y-p.bot_h)*0.01
            else
                r.y=r.y+(p.top_h-r.y)*0.01
            end
        end
        r.hitbox={-24,-48*2-24,2*48,3*48}
        r.draw=function (r)
            love.graphics.setColor((224+t%32)/255,(224+t%32)/255,(96+t%32)/255);
            if r.caught then acidcolor() end
            love.graphics.draw(dropplet_images.tenta,r.x-2*48+r.r/2,r.y-4*48+r.r/2)
            --love.graphics.rectangle("line",r.x,r.y,r.r,r.r)
            rainbow2()
            local tell="Boost\nto\nhit!"
            if r.spec then tell=r.spec.."\nboost\nto\nhit!" end
            love.graphics.printf(tell,r.x+r.hitbox[3],r.y+r.hitbox[1]-2*48,9999)
            love.graphics.rectangle("line",r.x+r.hitbox[1],r.y+r.hitbox[2],r.hitbox[3],r.hitbox[4])
        end
        return r
    end
    if type_id=="manatee" then
        table.insert(particles, {})
        local r = particles[#particles]
        r.x=e.x; r.y=e.y
        r.type="gen"
        r.t=0; r.t_e=9999
        r.r=48
        r.a=0
        r.nopuncture=true
        r.type_id=type_id
        particle(r,1,"itano")
        r.hitbox={-48,48,5*48,2*48}

        r.spec=randomchoice(specs)
        if wave_i==1 then
            while not (r.spec=="none") do
                r.spec=randomchoice(specs)
            end
        end
        if r.spec=="none" then r.spec=nil end

        r.up = function(r)             
            r.a=(r.a+(math.atan2(p.y-r.y, p.x-r.x)-r.a)*0.1)
            r.y=r.y-(r.y-p.bot_h)*0.01
        end
        r.draw=function (r)
            love.graphics.setColor((224+t%32)/255,(224+t%32)/255,(96+t%32)/255);
            if r.caught then acidcolor() end
            love.graphics.draw(dropplet_images.manatee,r.x-1*48,r.y)
            --love.graphics.rectangle("line",r.x,r.y,r.r,r.r)
            rainbow2()
            local tell="Boost\nto\nhit!"
            if r.spec then tell=r.spec.."\nboost\nto\nhit!" end
            love.graphics.printf(tell,r.x+r.hitbox[3]-3*48,r.y+r.hitbox[1]+4*48,9999)
            love.graphics.rectangle("line",r.x+r.hitbox[1],r.y+r.hitbox[2],r.hitbox[3],r.hitbox[4])
            --print(r.x,r.y)
        end
        return
    end
    --[[if type_id=="recbubble" then
        if e.r<12 then return end
        for i=1,6 do
            table.insert(particles, {})
            local r = particles[#particles]
                r.a=math.pi*2/6*i
            r.x=e.x+math.cos(r.a)*40; r.y=e.y+math.sin(r.a)*40--+count(particles,"msg")*24
            r.type="recbubble"
            r.dx=-6;r.dy=0
            r.up=advance_xy2
            r.t=0; r.t_e=60*5
            r.r=e.r/2
            r.draw=function(r) rainbow(); love.graphics.circle("line",r.x+24,r.y+24,r.r) end        
        end
        return
    end
    ]]--
    if type_id=="recbullet" or type_id=="recbubble" then
        if e.r<12 then return end
        for i=1,6 do
            table.insert(particles, {})
            local r = particles[#particles]
            r.a=math.pi*2/6*i
            r.x=e.x+math.cos(r.a)*40; r.y=e.y+math.sin(r.a)*40--+count(particles,"msg")*24
            r.type=type_id
            r.oldtype_id=e.type_id
            r.dx=-6;r.dy=0
            r.up=advance_xy2
            r.t=0; r.t_e=60*5
            r.r=e.r/2
            r.draw=function(r) rainbow(); 
            local style="fill"
            if r.oldtype_id=="kemuri" then style="line" end
            love.graphics.circle(style,r.x+24,r.y+24,r.r) 
            end        
        end
        return
    end
    if type_id then
        table.insert(particles, {})
        local r = particles[#particles]
        r.x=e.x; r.y=e.y--+count(particles,"msg")*24
        r.type_id=type_id
        r.type="msg"
        loveprint(r.type_id)
        r.nopuncture=true
        r.draw=function(r) rainbow2(); love.graphics.printf(r.type_id,r.x,r.y,9999) end        
        r.t=0; r.t_e=60
    end
end

function rainbow()
    local r,g,b,a=HSL((t)%256,224,180-20,255)
    love.graphics.setColor(r/255,g/255,b/255,a/255)
end
function rainbow2()
    local r,g,b,a=HSL((t)%256,224,224,255)
    love.graphics.setColor(r/255,g/255,b/255,a/255)
end

function valid(e, vars)
    --return whether entity e has all of vars
    for i,v in ipairs(vars) do
        if not e[v] then
            return false
        end
    end
    return true
end

function basemvmt_side(c)
    --c, any character 
    --must have x,dx,y,dy or return
    if not valid(c, {"x","dx","y","dy"}) then
        return 
    end

    if p.juice<=0 and p.boostt==0 then 
        if ojprint<=0 then
            particle(p,1,"Out of juice!")
            loveprint("out of juice!")
            ojprint=30
        end
        if anyheld then ojprint=ojprint-1 end
        return
    end

    local ctrlboost=1*overspd+chainboost
    --print(chainboost)
    if p.boostt>0 then ctrlboost=1.5 end

    if press("w") or press('up') then 
        if p.boostt>0 and p.dy>0 then p.dy=p.dy/2 end
        p.dy=p.dy-0.65*ctrlboost
        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1 end
    end
    if press("s") or press('down') then 
        if p.boostt>0 and p.dy<0 then p.dy=p.dy/2 end
        p.dy=p.dy+0.65*ctrlboost
        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1 end
    end
    if press("a") or press('left') then 
        if p.boostt>0 and p.dx>0 then p.dx=p.dx/2 end
        p.dx=p.dx-0.65*ctrlboost
        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1 end
    end
    if press("d") or press('right') then 
        if p.boostt>0 and p.dx<0 then p.dx=p.dx/2 end
        p.dx=p.dx+0.65*ctrlboost
        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1 end
    end

end

function basemvmt_hex(c)
    --c, any character 
    --must have x,dx,y,dy or return
    if not valid(c, {"x","dx","y","dy"}) then
        return 
    end
    if p.juice<=0 and p.boostt==0 then 
        if ojprint<=0 then
            particle(p,1,"Out of juice!")
            loveprint("out of juice!")
            ojprint=30
        end
        if anyheld then ojprint=ojprint-1 end
        return
    end

    local ctrlboost=1*overspd+chainboost
    --print(chainboost)
    if p.boostt>0 then ctrlboost=1.5 end

    if press("w") then 
        if p.boostt>0 and p.dx>0 then p.dx=p.dx/2 end
        if p.boostt>0 and p.dy>0 then p.dy=p.dy/2 end
        p.dx=p.dx-0.5*ctrlboost; 
        p.dy=p.dy-0.86602540378*ctrlboost 

        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1;  end
    end
    if press("e") then 
        if p.boostt>0 and p.dx<0 then p.dx=p.dx/2 end
        if p.boostt>0 and p.dy>0 then p.dy=p.dy/2 end
        p.dx=p.dx+0.5*ctrlboost; 
        p.dy=p.dy-0.86602540378*ctrlboost 

        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1;  end
    end
    if press("a") then 
        if p.boostt>0 and p.dx>0 then p.dx=p.dx/2 end
        p.dx=p.dx-1*ctrlboost; 

        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1;  end
    end--p.dy=p.dy*0.5 end
    if press("d") then 
        if p.boostt>0 and p.dx<0 then p.dx=p.dx/2 end
        p.dx=p.dx+1*ctrlboost; 

        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1;  end
    end--p.dy=p.dy*0.5 end
    if press("z") then 
        if p.boostt>0 and p.dx>0 then p.dx=p.dx/2 end
        if p.boostt>0 and p.dy<0 then p.dy=p.dy/2 end
        p.dx=p.dx-0.5*ctrlboost; 
        p.dy=p.dy+0.86602540378*ctrlboost 

        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1;  end
    end
    if press("x") then 
        if p.boostt>0 and p.dx<0 then p.dx=p.dx/2 end
        if p.boostt>0 and p.dy<0 then p.dy=p.dy/2 end
        p.dx=p.dx+0.5*ctrlboost; 
        p.dy=p.dy+0.86602540378*ctrlboost 

        if p.boostt==0 and p.juice>0 then p.juice=p.juice-1;  end
    end

end


function advance_xy(c)

    c.x=c.x+c.dx
    c.y=c.y+c.dy

    c.dx=c.dx*0.94   --setting: floaty
    c.dy=c.dy*0.94

end

function advance_xy2(c)

    c.x=c.x+c.dx
    c.y=c.y+c.dy

    --c.dx=c.dx*0.9   --setting: none
    --c.dy=c.dy*0.9

end

function dropplet_action(p)
    if p.boostt>0 then return end
    --particle(p,1,"tööt")

    --dash (if acid left)
    local veclen=math.sqrt(math.pow(p.dx,2)+math.pow(p.dy,2))
    local dashdx=0--p.dx/veclen
    local dashdy=0--p.dy/veclen

    local boostdx=0
    local boostdy=0
    --[[if held("w") then boostdx=boostdx-0.5; boostdy=boostdy-0.86602540378 end
    if held("e") then boostdx=boostdx+0.5; boostdy=boostdy-0.86602540378 end
    if held("a") then boostdx=boostdx-1; end--p.dy=p.dy*0.5 end
    if held("d") then boostdx=boostdx+1; end--p.dy=p.dy*0.5 end
    if held("z") then boostdx=boostdx-0.5; boostdy=boostdy+0.86602540378 end
    if held("x") then boostdx=boostdx+0.5; boostdy=boostdy+0.86602540378 end]]
    if press('w') then boostdy=-0.5 end
    if press('s') then boostdy= 0.5 end
    if press('a') then boostdx=-0.5 end
    if press('d') then boostdx= 0.5 end

    if boostdx==0 and boostdy==0 then
        dashdx=p.dx/veclen
        dashdy=p.dy/veclen
    else    
        dashdx=(dashdx+boostdx)
        dashdy=(dashdy+boostdy)
    end
    dashdx=dashdx*24*2
    dashdy=dashdy*24*2
    --p.dx=dashdx+p.dx*0.5
    --p.dy=dashdy+p.dy*0.5


    --p.ddx=0
    --p.ddy=0

    p.boostt=boostseconds()*60
    p.ddy=0
    dropplet_combobreak()

    neverboosted=false
end

function dropplet_combo(add)
    dropplet_sfx["clear"]:stop()
    dropplet_sfx["clear"]:play()
    if add.type=="DIVE" or add.type=="AIR" then
        if add.amt<200 then add.lvl="LV.1"; add_paws(1,'LV.1 combo')
        elseif add.amt<300 then add.lvl="LV.2"; add_paws(2,'LV.2 combo')
        elseif add.amt<500 then add.lvl="LV.3"; add_paws(3,'LV.3 combo')
        else add.lvl="MAX"; add_paws(5,'LV.MAX combo') end
    end
    table.insert(p.dropplet_combo, add)
end
function dropplet_combobreak(r)
    p.dropplet_combo={}
    p.airt=0; p.watert=0; p.waterd=0
end

function dropplet_lose(msg)
    if p.done then return end
    msg=">"..msg
    local msec=string.format("%.2d", score%60*100/60)
    local sec=tostring(math.floor(score/60))

    msg=msg.."\n\n>"..tostring(wave_i).." waves in "..sec..":" .. msec.."."

    losedat={msg=msg,msg2=">R to reset.",x=-900,y=sh/2-96*4,x2=-900,y2=sh/2}
    flux.to(losedat,1,{x=12,x2=12})
    p.done=true
end

function dropplet_update(dt)
    flux.update(1/60) --thanks rxi

    if not intro then score=score+1 end

    anyheld = press("w") or press("a") or press("d") or press("s") or press('up') or press('down') or press('left') or press('right')
    --if anyheld then end

    p.boostt=p.boostt or 0
    if not intro and not p.done then
        --basemvmt_hex(p)
        basemvmt_side(p)
        if tapped("z") then
            dropplet_action(p)
        end
        advance_xy(p)
        p.dx=p.dx+p.ddx; p.dy=p.dy+p.ddy
        p.ddx=p.ddx; p.ddy=p.ddy--*0.96
        if p.boostt==0 then
            p.ddy=p.ddy+0.08*0.35*overspd
        else
            p.ddy=p.ddy+0.08*0.35*overspd*0.25
        end
    end
    --print(p.dy)
    --p.dy=p.dy+0.2
   
    if not p.top_h then p.top_h=p.y end
    if not p.bot_h then p.bot_h=p.y+p.h end
    
    p.top_h=p.top_h+0.2
    if not anyheld then p.top_h=p.top_h+(p.y-p.top_h)*0.004 end
    if p.y<=p.top_h then
        p.top_h=p.y
        p.top_ht=t
    end
    if p.top_h<0 then p.top_h=0 end
    if p.bot_h<0 then p.bot_h=0 end
    
    p.bot_h=p.bot_h-0.2
    if not anyheld then p.bot_h=p.bot_h-(p.bot_h-p.y+p.h)*0.004 end
    if p.y+p.h>=p.bot_h then
        p.bot_h=p.y+p.h
        p.bot_ht=t
    end
    if p.bot_h>=sh-4 then p.bot_h=sh-4 end
    if p.top_h>=sh-4 then p.top_h=sh-4 end

    if p.y>sh+500 then
        dropplet_lose("You fell into oblivion.")
    end

    if p.boostt>0 then
        p.boostt=p.boostt-1
        if p.boostt==0 then
            p.dropplet_combo.cap=p.dropplet_combo.cap or {}
            for i,v in ipairs(p.dropplet_combo.cap) do
                if v.type=="gen" and not v.done then
                    bosses=bosses-1
                    if bosses==0 and wavet>60*2 then wavet=60*2 end
                end

                if v.type_id=="manatee" and not v.done then
                    for i,v2 in ipairs(particles) do
                        if v2.type=="itano" and v2.manatee==v then
                            v2.done=true
                            loveprint("removing leftover missile")
                            break
                        end
                    end
                end
                v.done=true
                --for 1 to v.value
                for i=1,15 do
                    particle(v,1,"juice")
                end
            end
            p.dropplet_combo.cap={}
        end
    end

    local marker=false

    for i=#particles,1,-1 do
        local r=particles[i]
        if r.type=="itano" and r.t>0 and r.t%16==0 then
            particle({x=r.x,y=r.y},1,"kemuri")
            loveprint("kemuri",i)
        end
    end
    
    for i=#particles,1,-1 do
        local r=particles[i]
        if not p.done then
            if r.up and not r.caught then r.up(r) end
            r.t=r.t+1
            if r.t>r.t_e or r.x<-48 then
                table.remove(particles, i)
                
            end
        end

        r.r=r.r or 48
        local c = dropplet_coll({p.x,p.y,p.w,p.h}, {r.x,r.y,r.r,r.r})
        -- c is result of collision between player p and sequential enemy r-i.
        -- both p and the current r (we know array index i) have to have
        -- x,y,w,h. well, r just has const w,h, so they don't have to be saved in the entity.

        if r.type=="gen" and p.boostt>0 then
            local pc = dropplet_coll({p.x,p.y,p.w,p.h}, {r.x+r.hitbox[1],r.y+r.hitbox[2],r.hitbox[3],r.hitbox[4]})
            if pc and not r.coll then
                loveprint(r.spec, dom, boostdomtype())
                if not r.spec or (r.spec and r.spec==dom) then
                    dropplet_sfx["clear"]:stop()
                    dropplet_sfx["clear"]:play()
                    loveprint("boss hit!")
                    add_paws(2,'enemy hit')
                    r.caught=true
                    p.dropplet_combo.cap=p.dropplet_combo.cap or {}
                    table.insert(p.dropplet_combo.cap,r)
                    r.coll=true
                end
            end
            if not pc then r.coll=false end
        end

        if not c and not marker then
        end

        if r.type=="juice" and p.boostt==0 and c then
            flux.to(r,1,{x=100,y=sh}):oncomplete(function() r.done=true; p.juice=p.juice+10 end)
            dropplet_sfx["fx1"]:stop()
            dropplet_sfx["fx1"]:play()
            --print(p.juice)
        end

        if r.type=="kiki" or r.type=="itano" then
            local pc = dropplet_coll({p.x,p.y,p.w,p.h}, {r.x,r.y,r.r,r.r})
            if pc then
                if p.boostt==0 then  
                    table.remove(particles,i)
                    dropplet_combobreak(r)
                    p.juice=p.juice-60*5
                    dropplet_sfx["ouch"]:stop()
                    dropplet_sfx["ouch"]:play()
                    particle(r,1,"-5:00")
                    if p.juice<0 then 
                        dropplet_lose("You shriveled away.")
                        p.juice=0 
                    end
                else
                    if not r.caught then
                        dropplet_sfx["clear"]:stop()
                        dropplet_sfx["clear"]:play()
                        add_paws(2,'projectile hit')

                        p.dropplet_combo.cap=p.dropplet_combo.cap or {}
                        table.insert(p.dropplet_combo.cap,r)
                    end
                    r.caught=true
                end
            end
        end

        if r.type=="itano" or r.type=="kiki" then
            for i2=#particles,1,-1 do
                local r2=particles[i2]
                if r2~=r and (r2.type~="itano") and (r2.type~="kiki") and (r2.type~="gen") and (r2.type~="kemuri") and not r2.nopuncture then
                    local a3=r2.w or r2.r or 48
                    local a4=r2.h or r2.r or 48
                    local c2 = dropplet_coll({r2.x,r2.y,a3,a4}, {r.x,r.y,r.r,r.r})
                    if c2 then
                        r2.done=true
                    end
                end
            end
        end

        if c then
            if r.type=="itano" then 
                if not r.manatee.caught then
                    particle(r.manatee,1,"itano")
                end
                r.done=true
                if p.boostt==0 then
                    p.dx=p.dx+r.dx*6
                    p.dy=p.dy+r.dy*6
                end
            end
            if r.type=="bubble" or r.type=="recbubble" then 
                --r.type="recbubble" 
                table.remove(particles, i)
                --print(r.r)
                --particle(r,6,"recbubble")
            end
            if r.type=="bullet" or r.type=="recbullet" then 
                r.type="recbullet" 
                table.remove(particles, i)
                --print(r.r)
                particle(r,6,"recbullet")
            end
        end

        if (r.type=="bullet" or r.type=="recbullet") and c then
            if r.r>16 then dropplet_sfx["fx2"]:stop() end
            --if not intro then 
                dropplet_sfx["fx2"]:play() 
            --end
                        --p.ddy=p.ddy-0.12*0.3

            --[[ UNCOMMENT FOR:

                --droplet-sticky
                    --gooey material

                p.dy=p.dy-2
                p.ddy=(t-p.t)*0.02--p.ddy-0.02

            --]]

            --droplet-surf
                --light material
            --if p.dy>0 then p.dy=p.dy-0.001+p.dy*0.01-r.r*0.01 end
            p.ddy=p.ddy*0.98*r.r/48
            p.chaint=p.chaint or 0
            --chainboost=p.chaint--*0.2
            --[[if held("s") and not marker then 
                --p.ddy=p.ddy-(t-p.t)*0.04--p.ddy-0.02
                --if t-p.t<5 then
                --    p.ddy=p.ddy-math.abs(p.dy)*0.002
                --end

                p.dy=p.dy-0.02
                chainbonus=p.chaint*0.002
                p.ddy=p.ddy-chainbonus
                p.chaint=p.chaint+1
                --print(p.chaint, "chaintime")
            end
            ]]--

            if p.boostt>0 and r.r>16 then
                particle(r,1,"juice")
            end

            if not intro then marker=true end
        end
        if (r.type=="bubble" or r.type=="recbubble") and c then
            --p.ddy=p.ddy-0.12*0.3
            local shift=1
            if not press("s") then shift=0 end
            --p.dy=-3.2-p.dy*0.5-shift*14---math.abs(p.dy)*1.6
            if p.dy>0 then p.dy=-p.dy*2 end
            p.ddy=-0.2--math.abs(p.ddy)*0.4
            --table.remove(particles, i)
        end


    end

    p.airt=p.airt or 0
    if p.boostt>0 then p.airt=0 end
    p.watert=p.watert or 0
    p.waterd=p.waterd or 0
    if marker then
        if not press("s") then p.chaint=0 end
        if p.boostt==0 then p.watert=p.watert+1 end
        if anyheld then chainboost=chainboost+0.01 
        else chainboost=chainboost*0.8 end
        if (p.watert)>20 then
            --print(p.watert, "watertime")
        end
        p.waterd=0
        if (p.airt)>=50 then
            dropplet_combo({type="AIR", amt=p.airt})
            particle(p, 1, tostring(p.airt).." AIR")
        end
        p.airt=0
    end
    if not marker and not intro then
        chainboost=chainboost*0.8
        if p.boostt==0 then p.airt=p.airt+1 end
        if p.waterd>=10 then
            p.chaint=0
            if (p.watert)>=100 then
                dropplet_combo({type="DIVE", amt=p.watert})
                particle(p, 1, tostring(p.watert).." DIVE")
            end
            p.watert=0
        end
        p.waterd=p.waterd+1


        p.t=p.t or 0
        --if (t-p.t)>20 then
        --determine how many frames we've been submerged.
        
        --todo: how many frames in air.
        
        --these are variables which can be 
        --calculated into the final score.
        
        --can you break your previous best airtime?
        --or watertime? firetime?? earthtime?!
            p.t=t
        --end
    end

    for i=#particles,1,-1 do
        local r=particles[i]
        if r.done then table.remove(particles,i) end
    end
    --particle({x=960+math.sin(t*0.2)*296, y=500+math.sin(t*0.2)*296},1,"bullet")
    if t%2==0 and not p.done then
        local delta=p.bot_h-p.top_h
        particle({x=960+math.sin(t*0.3)*120, y=p.top_h+delta/2+math.sin(t*0.02)*delta/2+math.sin(t*0.2)*140},1,ptype)
        --particle({x=960+math.sin(t*0.3)*120, y=400+250+math.sin(t*0.02)*250+math.sin(t*0.2)*96},1,ptype)
    end
    --if itano and t%256==0 then
    --    particle({x=sw, y=200+250+math.sin(t*0.02)*250+math.sin(t*0.2)*96},1,"itano")
    --end

    p.ox=p.ox or p.x
    p.oy=p.oy or p.y
    if tapped("r") and p.done then
        p.x=p.ox
        p.y=p.oy
        p.dx=0
        p.dy=0
        p.ddx=0
        p.ddy=0
        intro=true
        wavet=0
        wave_i=0
        dropplet_sfx["JELLYFISH"]:stop()
        p.juice=60*60
        p.done=false
        p.airt=nil; p.watert=nil; p.waterd=nil
        p.dropplet_combo={}
        particles={}
        score=0
        bosses=0
        --t=0
        neverboosted=true
    end

    if debug then
        if tapped("t") then
            if ptype=="bubble" then ptype="bullet" 
            elseif ptype=="bullet" then ptype="bubble" end
        end
        if tapped("m") then
            itano = not itano
            if itano then 
                particle({x=sw, y=200+250+math.sin(t*0.02)*250+math.sin(t*0.2)*96},1,"itano")
            end
        end
        if tapped("g") then
            gen = not gen
            if gen then 
                particle({x=sw-200, y=100},1,"gen")
                particle({x=0+200, y=100},1,"gen")
            end
        end
    end

    if not intro and wavet<=0 then
        wave()
    end
    if wavet>0 and not p.done then wavet=wavet-1 end

    --loveprint(wavet)

    --if not intro then t=t+1 end
    --t=t+1
    --print(#particles)

    if anyheld and intro then intro=false; wavet=60*19; cur_audio=dropplet_sfx["JELLYFISH"]; dropplet_sfx["JELLYFISH"]:play() end

end

opps={"1tenta", "2tenta", "2tenta_diag", "1manatee", "2manatee"}
function wave()
    wavet=60*30
    --particle(p,1,"wave "..tostring(wave_i))
    wave_i=wave_i+1

    local opp=randomchoice(opps)
    while opp==lastchoice do
        opp=randomchoice(opps)
    end
    if wave_i==1 then
        while not (opp=="1tenta" or opp=="1manatee") do
            opp=randomchoice(opps)
        end
    end
    lastchoice=opp

    loveprint("it's", opp,"!")

    if opp=="2tenta" then
        particle({x=sw-300, y=100},1,"gen")
        particle({x=0+200, y=100},1,"gen")
        bosses=bosses+2
    end
    if opp=="2tenta_diag" then
        particle({x=sw-300, y=sh-400},1,"gen").follow="bottom"
        particle({x=0+200, y=sh-400},1,"gen").follow="bottom"
        bosses=bosses+2
    end
    if opp=="1tenta" then
        particle({x=sw/2, y=100},1,"gen")
        bosses=bosses+1
    end
    if opp=="1manatee" then
        particle({x=sw/2, y=sh-400},1,"manatee")
        bosses=bosses+1
    end
    if opp=="2manatee" then
        particle({x=sw-300, y=sh-400},1,"manatee")
        particle({x=200, y=sh-400},1,"manatee")
        bosses=bosses+2
    end
    --itano = true
    --if itano then 
    --    particle({x=sw, y=200+250+math.sin(t*0.02)*250+math.sin(t*0.2)*96},1,"itano")
    --end
--[[    gen=not gen
    if gen then 
        particle({x=sw-200, y=100},1,"gen")
        particle({x=0+200, y=100},1,"gen")
    end
]]--
end
