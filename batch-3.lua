function batch3_load()
    jelloes={}

    leftedge=28*36/2-3*96+2*36-24

    batch3_score=0
    shown_batch3_score=0

    level=1
    hearts=3

    batch3_update= plan
    combos={}
    t2=0
    matched={}

    for x=0,5 do
    for y=0,8 do
        jelloes[posstr(x,y)]={tx=x,ty=y,x=leftedge+x*96,y=y*96,color=({'green','yellow','purple','red'})[love.math.random(4)]}
        while match3(posstr(x,y),true) do
            jelloes[posstr(x,y)].color=({'green','yellow','purple','red'})[love.math.random(4)]
        end
    end
    end

    program={}

    save_sec=0

    particles={}

    cur_combo=0
    longest_combo=0
    combo_ind={}
    pending_combo=0
end

function stamp96(img,x,y)
    local new=lg.newCanvas(96,96)
    lg.setCanvas(new)
        lg.draw(img,-x,-y)
    lg.setCanvas()
    return new
end

arcadef1 = lg.newFont('wares/batch-3-assets/MADE Tommy Soft Bold.otf',34)
arcadef2 = lg.newFont('wares/batch-3-assets/MADE Tommy Soft Bold.otf',34*2)
arcadef3 = lg.newFont('wares/batch-3-assets/MADE Tommy Soft Bold.otf',34*3)
arcadef4 = lg.newFont('wares/batch-3-assets/MADE Tommy Soft Bold.otf',34*5-16)
arcadef5 = lg.newFont('wares/batch-3-assets/MADE Tommy Soft Bold.otf',34+17)
lg.setFont(arcadef2)
batch3_audio={}
batch3_audio.slime=love.audio.newSource('wares/batch-3-assets/433838__archos__slime-23.wav','static')
batch3_audio.sparkle=love.audio.newSource('wares/batch-3-assets/399294__komit-wav__synth-sparkle.wav','static')
batch3_audio.select=love.audio.newSource('wares/batch-3-assets/413310__tieswijnen__select.wav','static')
batch3_audio.match=love.audio.newSource('wares/batch-3-assets/338905__toxemiccarton__combo-clap.wav','static')
batch3_audio.plan=love.audio.newSource('wares/batch-3-assets/jello1.wav','static')
batch3_audio.execute=love.audio.newSource('wares/batch-3-assets/jello2.wav','static')
batch3_audio.cancel=love.audio.newSource('wares/batch-3-assets/176176__eelke__zipper.wav','static')
batch3_audio.rising=love.audio.newSource('wares/batch-3-assets/rising.wav','static')
batch3_audio.sparkle2=love.audio.newSource('wares/batch-3-assets/145459__soughtaftersounds__menu-click-sparkle.wav','static')
batch3_audio.plan:setLooping(true)
batch3_audio.execute:setLooping(true)
lg.setDefaultFilter('nearest')
batch3_images={}
lg.setColor(1,1,1,1)
batch3_images.jelloes=lg.newImage('wares/batch-3-assets/jelloes.png')
batch3_images.yellow=stamp96(batch3_images.jelloes,96,0)
batch3_images.green=stamp96(batch3_images.jelloes,96*2,0)
batch3_images.purple=stamp96(batch3_images.jelloes,96*3,0)
batch3_images.red=stamp96(batch3_images.jelloes,96*4,0)
batch3_images.whiteness=stamp96(batch3_images.jelloes,96*5,0)
batch3_images.face1=stamp96(batch3_images.jelloes,96,96)
batch3_images.face2=stamp96(batch3_images.jelloes,96*2,96)
batch3_images.face3=stamp96(batch3_images.jelloes,96*3,96)
batch3_images.face4=stamp96(batch3_images.jelloes,96*4,96)
batch3_images.yellowstar1=stamp96(batch3_images.jelloes,96,96*2)
batch3_images.yellowstar2=stamp96(batch3_images.jelloes,96*2,96*2)
batch3_images.yellowstar3=stamp96(batch3_images.jelloes,96*3,96*2)
batch3_images.greenstar1=stamp96(batch3_images.jelloes,96*4,96*2)
batch3_images.greenstar2=stamp96(batch3_images.jelloes,96*5,96*2)
batch3_images.greenstar3=stamp96(batch3_images.jelloes,96*6,96*2)
batch3_images.purplestar1=stamp96(batch3_images.jelloes,96,96*3)
batch3_images.purplestar2=stamp96(batch3_images.jelloes,96*2,96*3)
batch3_images.purplestar3=stamp96(batch3_images.jelloes,96*3,96*3)
batch3_images.redstar1=stamp96(batch3_images.jelloes,96*4,96*3)
batch3_images.redstar2=stamp96(batch3_images.jelloes,96*5,96*3)
batch3_images.redstar3=stamp96(batch3_images.jelloes,96*6,96*3)
batch3_images.whitenessstar1=stamp96(batch3_images.jelloes,96,96*4)
batch3_images.whitenessstar2=stamp96(batch3_images.jelloes,96*2,96*4)
batch3_images.whitenessstar3=stamp96(batch3_images.jelloes,96*3,96*4)
batch3_images.heart=stamp96(batch3_images.jelloes,96*4,96*4)
batch3_images.heartwhiteness=stamp96(batch3_images.jelloes,96*6,96*4)
batch3_images.play=stamp96(batch3_images.jelloes,96*5,96*4)
batch3_images.select=stamp96(batch3_images.jelloes,0,96*4)

function match3(k,test)
    local jx,jy=strpos(k)
    local j=jelloes[k]
    local horiz={k}
    i=1
    while jelloes[posstr(jx+i,jy)] and jelloes[posstr(jx+i,jy)].color==j.color do
        ins(horiz,posstr(jx+i,jy))
        i=i+1
    end
    i=-1
    while jelloes[posstr(jx+i,jy)] and jelloes[posstr(jx+i,jy)].color==j.color do
        ins(horiz,posstr(jx+i,jy))
        i=i-1
    end
    local vert={k}
    i=1
    while jelloes[posstr(jx,jy+i)] and jelloes[posstr(jx,jy+i)].color==j.color do
        ins(vert,posstr(jx,jy+i))
        i=i+1
    end
    i=-1
    while jelloes[posstr(jx,jy+i)] and jelloes[posstr(jx,jy+i)].color==j.color do
        ins(vert,posstr(jx,jy+i))
        i=i-1
    end
    local out={}
    if #horiz>=3 then for i,h in ipairs(horiz) do if not find(out,h) then ins(out,h) end end end
    if #vert>=3 then for i,v in ipairs(vert) do if not find(out,v) then ins(out,v) end end end
    if not test and #horiz>=3 and #vert>=3 then combo() end

    if #out>0 then 
        --if not test then batch3_score=batch3_score+#out*10 end
        return out 
    end
    return false
end

function inprogram(k)
    for i,v in ipairs(program) do
    for j,w in ipairs(v) do
        if w==k then return true end
    end
    end
    return false
end

function plan(hw_dt)
    if not batch3_audio.plan:isPlaying() then cur_audio=batch3_audio.plan; batch3_audio.plan:play() end
    leftheld=left
    left=love.mouse.isDown(1)
    if not left then leftheld2=nil end
    rightheld=right
    right=love.mouse.isDown(2)
    mox,moy=love.mouse.getPosition()
    mox=mox-game.x; moy=moy-game.y
    if right and not rightheld then
        if action then action=nil; batch3_audio.cancel:stop(); batch3_audio.cancel:play()
        else
        for i,p in ipairs(program) do
            local sx,sy=strpos(p[1])
            local ex,ey=strpos(p[2])
            if AABB(mox,moy,1,1,leftedge+sx*96,sy*96,96,96) or AABB(mox,moy,1,1,leftedge+ex*96,ey*96,96,96) then rem(program,i); batch3_audio.cancel:stop(); batch3_audio.cancel:play(); for i2,p2 in ipairs(program) do p2.i=i2 end; break end
        end
        end
    end
    for k,j in pairs(jelloes) do
        local jx,jy=strpos(k)
        if left and not leftheld2 and AABB(mox,moy,1,1,leftedge+jx*96,jy*96,96,96) and ((type(level)=='number' and #program<level+2) or (level=='inf' and #program<7)) then
            if not action then
            if not inprogram(k) then
            if not leftheld then batch3_audio.select:stop(); batch3_audio.select:play() end
            action={k}
            end
            else
            local kx,ky=strpos(action[1])
            if k==posstr(kx+1,ky) or k==posstr(kx-1,ky) or k==posstr(kx,ky+1) or k==posstr(kx,ky-1) then
            batch3_audio.select:stop(); batch3_audio.select:play()
            ins(action,k)
            ins(program,action)
            action.i=#program
            action=nil
            end
            end
        end
    end

    if (type(level)=='number' and #program==level+2) or (level=='inf' and #program==7) then
        if love.keyboard.isDown('return') or (left and not leftheld and AABB(mox,moy,1,1,leftedge+6*96+24+12,24*36-128,96,96)) then
        batch3_update=execute
        old_prog=#program
        batch3_audio.plan:stop(); cur_audio=batch3_audio.execute; batch3_audio.execute:play()
        end
    end

    refresh_online(hw_dt)

    --t = t+1
end

function refresh_online(dt)
    --[[save_sec=save_sec+dt
    if save_sec>=1 then
        love.filesystem.write('init.lua','run=true')
        save_sec=0
    end]]
end

function starburst(k,j)
    local kx,ky=strpos(k)
    local sx,sy=leftedge+kx*96,ky*96
    for i=1,12 do
        local new={}
        new.x=sx; new.y=sy
        new.i=({1,2,2,3,3,3})[love.math.random(6)]
        new.img=batch3_images[j.color..'star'..tostring(new.i)]
        new.dx=cos(math.rad(love.math.random(0,180)))
        new.dy=love.math.random(-8,-2)/2
        ins(particles,new)
    end
end

function starburst2(kx,ky,color)
    for i=1,12 do
        local new={}
        new.x=kx; new.y=ky
        new.i=({1,2,2,3,3,3})[love.math.random(6)]
        new.img=batch3_images[color..'star'..tostring(new.i)]
        new.dx=cos(math.rad(love.math.random(0,180)))
        new.dy=love.math.random(-8,-2)/2
        ins(particles,new)
    end
end

function combo()
    cur_combo=cur_combo+1
    if cur_combo>longest_combo then longest_combo=cur_combo end
    if cur_combo>1 then
        pending_combo=pending_combo+40+cur_combo*5
        if combo_ind[#combo_ind] and combo_ind[#combo_ind].t==0 then
        combo_ind[#combo_ind].msg=fmt('%d combo!',cur_combo)
        else
        shout(fmt('%d combo!',cur_combo))
        end
    end
end

function hypotenuse_too_short(c)
    local cx,cy=c.x,c.y
    local dist=0
    while cx>=-8 and cy>=-8 and cx<28*36+8 and cy<24*36+8 do
        cx=cx+cos(c.a-math.pi)*8; cy=cy+sin(c.a-math.pi)*8
        dist=dist+8
    end
    if dist<800 then return true end
    return false
end

function shout(msg)
    local a=love.math.random(0,360)
    ins(combo_ind,{msg=msg,a=math.rad(a),t=0})
    if a<45 or a>=360-45 then combo_ind[#combo_ind].x=28*36; combo_ind[#combo_ind].y=love.math.random(0+6*36,24*36-6*36)  end
    if a>=45+90+90 and a<45+90+90+90 then combo_ind[#combo_ind].x=love.math.random(0+6*36,28*36-6*36); combo_ind[#combo_ind].y=0 end
    if a>=45+90 and a<45+90+90 then combo_ind[#combo_ind].x=0; combo_ind[#combo_ind].y=love.math.random(0+6*36,24*36-6*36) end
    if a>=45 and a<45+90 then combo_ind[#combo_ind].x=love.math.random(0+6*36,28*36-6*36); combo_ind[#combo_ind].y=24*36 end
    if hypotenuse_too_short(combo_ind[#combo_ind]) then rem(combo_ind,#combo_ind); shout(msg) end
end

function gameover()
    --for i=1,3 do
    shout('Game over')
    --end
    batch3_update=function(hw_dt) if t2-t>0 and (t2-t)%90==0 then shout('Game over') end; refresh_online(hw_dt) end
end

function execute(hw_dt)
    local animating=false

    for k,v in pairs(jelloes) do
        if v.flash then animating=true; v.flash=v.flash-1; if v.flash==0 then animating=false; v.flash=nil end end
    end

    local sus_combo=0
    for k,v in pairs(jelloes) do
        if v.tgtx or v.tgty then 
        animating=true 
        v.x=v.x+(v.tgtx-v.x)*0.2
        v.y=v.y+(v.tgty-v.y)*0.2
        if math.abs(v.tgtx-v.x)<1 and math.abs(v.tgty-v.y)<1 then
            if sus_combo~=2 then sus_combo=1 end
            v.tgtx=nil; v.tgty=nil
            local m= match3(k) 
            if m then sus_combo=2; local same=true; for i,w in ipairs(m) do if not find(matched,w) then same=false; ins(matched,w); jelloes[w].flash=30 end end; if not same then combo() end end
        end
        end
        if v.tgty2 then
        animating=true
        v.acc=v.acc or 0
        v.y=v.y+v.acc
        v.acc=v.acc+0.4
        if v.y>=v.tgty2 then 
            local m= match3(k) 
            if m then local same=true; for i,w in ipairs(m) do if not find(matched,w) then same=false; ins(matched,w); jelloes[w].flash=30 end end; if not same then combo() end end
            v.y=v.tgty2; v.tgty2=nil; v.acc=nil end
        end
    end
    if sus_combo==1 then 
        if cur_combo>1 then shout('Combo end'); batch3_audio.cancel:stop(); batch3_audio.cancel:play() end
        cur_combo=0 
    end

    removed={}
    if not animating then
    for i,k in ipairs(matched) do
        starburst(k,jelloes[k])
        jelloes[k]=nil
        ins(removed,k)
    end
    matched={}
    end
    local parsed={}
    if not animating then
    table.sort(removed,function(k1,k2) 
        local k1x,k1y=strpos(k1) 
        local k2x,k2y=strpos(k2) 
        return k1y>k2y
    end)
    if #removed>0 then batch3_score=batch3_score+pending_combo; pending_combo=0 end
    for i,k in ipairs(removed) do
        if i==1 then batch3_audio.match:stop(); batch3_audio.match:play() end
        batch3_score=batch3_score+10
        local kx,ky=strpos(k)
        if not find(parsed,kx) then 
        ins(parsed,kx)
        local j=0
        --while (not jelloes[posstr(kx,ky+j)]) and ky+j>0 do j=j-1 end
        --local sep
        --local step1=0
        --local step2=0
        --while jelloes[posstr(kx,ky+step1)]==nil and ky+step1>0 do step1=step1-1 end
        --while jelloes[posstr(kx,ky+step1+step2+1)]==nil and ky+step1+step2+1<8 do step2=step2+1 end
        --sep=(ky+step2)-(ky+step1)-1
        while ky+j>=0 do
            local h=8
            while jelloes[posstr(kx,h)] do h=h-1 end
            for l,w in ipairs(program) do
                if w[1]==posstr(kx,ky+j) then 
                    w[1]=posstr(kx,h) 
                    local wx,wy=strpos(w[2])
                    w[2]=posstr(wx,h+wy-(ky+j))
                    w.tgty2=h*96+48
                end
            end
            if jelloes[posstr(kx,ky+j)] then
            jelloes[posstr(kx,ky+j)].tgty2=h*96--(ky+j+step2)*96
            jelloes[posstr(kx,h)]=jelloes[posstr(kx,ky+j)]--ky+j+step2
            end
            jelloes[posstr(kx,ky+j)]=nil
            j=j-1
        end
        end
    end
    end

    if #program==0 and #matched==0 and not animating and #removed==0 then
        local lowest
        local skip=false
        for py=9-1,0,-1 do if not skip then
        for px=6-1,0,-1 do if not skip then
        if jelloes[posstr(px,py)]==nil then
            lowest=posstr(px,py)
            skip=true
        end
        end end
        end end
        if lowest then
            animating=true
            local kx,ky=strpos(lowest)
            for py=0,9-1 do
            for px=0,6-1 do
                if jelloes[posstr(px,py)]==nil then
                    jelloes[posstr(px,py)]={tx=px,ty=py,x=leftedge+px*96,y=py*96-(ky+1)*96,tgty2=py*96,color=({'green','yellow','purple','red'})[love.math.random(4)]}
                    while match3(posstr(px,py),true) do
                        jelloes[posstr(px,py)].color=({'green','yellow','purple','red'})[love.math.random(4)]
                    end
                end
            end
            end
        end
    end
    
    if #program>0 and not animating and #matched==0 and #removed==0 then
        local sx,sy=strpos(program[1][1])
        local ex,ey=strpos(program[1][2])
        if jelloes[program[1][1]] and jelloes[program[1][2]] then
        local swap=jelloes[program[1][1]]
        jelloes[program[1][1]]=jelloes[program[1][2]]
        jelloes[program[1][1]].tgtx=swap.x
        jelloes[program[1][1]].tgty=swap.y
        jelloes[program[1][2]]=swap
        jelloes[program[1][2]].tgtx=jelloes[program[1][1]].x
        jelloes[program[1][2]].tgty=jelloes[program[1][1]].y
        batch3_audio.slime:stop(); batch3_audio.slime:play()
        else if cur_combo>1 then shout('Combo end'); batch3_audio.cancel:stop(); batch3_audio.cancel:play() end
        cur_combo=0 end
        rem(program,1)
    elseif #program==0 and not animating and #matched==0 and #removed==0 then
        start_dialogue(1)
        save_combo()
    end

    refresh_online(hw_dt)

    --t=t+1
end

diag_db={
    ['test1']={
        {'Current major jam: Juice Jam! Feel free to talk about any current jam, and post progress updates'},
    },
}
function start_dialogue(id)
    --cur_diag=diag_db[id]
    --cur_diag.i=1
    if id==1 then
    batch3_update=dialogue
    elseif id==2 then
    batch3_update=dialogue2
    end
    sc_t=t+1
    diag_box={x=28*36/2,y=12*36,w=1,h=1,tgtx=4*36,tgth=8*36,tgtw=20*36}
end

function save_combo()
    add_paws(longest_combo,string.format('%d combo',longest_combo))
    --[[ins(combos,longest_combo)
    local out='combos={'
    for i,c in ipairs(combos) do
        out=out..tostring(c)..','
    end
    out=sub(out,1,#out-1) -- get rid of last comma
    out=out..'}'
    love.filesystem.write('combos.lua',out)]]
end

function batch3_end_turn()
    batch3_update=plan
    if level~='inf' then
    hearts=hearts+longest_combo-(level+2)
    else
    hearts=hearts+longest_combo-7
    end
    if hearts<=0 then gameover() end
    cur_combo=0; longest_combo=0
    old_prog=nil
    if level~='inf' and hearts>0 then level=level+1; if level>5 then level='inf' end end
    leftheld2=true
    batch3_audio.execute:stop()
    --if hearts>0 then batch3_audio.plan:play() end
end

function dialogue(hw_dt)
    leftheld=left
    left=love.mouse.isDown(1)
    if t-sc_t<135+30+30+15+30 and ((left and not leftheld) or tapped('return')) then
        sc_t=sc_t-(135+30+30+15+30)
        diag_box.x=diag_box.tgtx; diag_box.w=diag_box.tgtw; diag_box.h=diag_box.tgth
    elseif t-sc_t>=135+30+30+15+30 and ((left and not leftheld) or tapped('return')) then
        if level==5 and hearts+longest_combo-(level+2)>0 then start_dialogue(2)
        else
            batch3_end_turn()
        end
    end

    refresh_online(hw_dt)

    --t=t+1
end

function dialogue2(hw_dt)
    leftheld=left
    left=love.mouse.isDown(1)
    if t-sc_t<60+129 and ((left and not leftheld) or tapped('return')) then
        sc_t=sc_t-(60+129)
        diag_box.x=diag_box.tgtx; diag_box.w=diag_box.tgtw; diag_box.h=diag_box.tgth
    elseif t-sc_t>=60+129 and ((left and not leftheld) or tapped('return')) then
        batch3_end_turn()
    end

    refresh_online(hw_dt)
    
    --t=t+1
end
    
function batch3_draw()
    lg.setLineWidth(8)
    lg.setLineStyle('rough')
    bg(0.4,0.8,0.8)
    fg(0.2,0.4,0.9)
    --lg.rectangle('fill',0,0,leftedge,24*36)
    fg(0.8,0.2,0.4)
    --lg.rectangle('fill',leftedge+6*96,0,28*36-(leftedge+6*96),24*36)
    local r,g,b=HSLtoRGB((t*0.012)%1,0.9,0.9)
    local r2,g2,b2=HSLtoRGB((t2*0.012)%1,0.2,0.2)
    t2=t2+1
    fg(r,g,b)
    lg.setFont(arcadef4)
    lg.push()
    lg.rotate(math.pi*0.4)
    lg.print('Batch-3',60-60,-120-40-20+40)
    lg.pop()
    lg.setFont(arcadef2)
    --lg.print('hello world!')
    lg.push()
    lg.rotate(math.pi*0.1)
    lg.print('score',40+40+140+80,300+300)
    if batch3_score>999999 then batch3_score=999999 end
    shown_batch3_score=shown_batch3_score+(batch3_score-shown_batch3_score)*0.2
    lg.print(fmt('%.6d',math.floor(shown_batch3_score+0.5)),40+40+140+80-64,300+300+64)
    lg.pop()
    lg.push()
    lg.rotate(-math.pi*0.1)
    if level~='inf' then
    lg.print(fmt('Level %d',level),-240+40+30-12,24*36-32-64-140-40-10+10)
    else
    lg.print('Level',-240+40+30-12,24*36-32-64-140-40-10+10)
    lg.rotate(math.pi/2)
    lg.print(8,-20+80+300+300-64+6+10,-20-40-16)
    end
    lg.pop()

    lg.setFont(arcadef1)
    lg.push()
    lg.translate(leftedge+6*96+24-6,12*36+64)
    lg.rotate(-math.pi/4)
    if level~='inf' then
    lg.print(fmt('Swaps: %d/%d',old_prog or #program,level+2),-20-4,0)
    else
    lg.print(fmt('Swaps: %d/%d',old_prog or #program,7),-20-4,0)
    end
    lg.pop()
    lg.push()
    lg.translate(leftedge+6*96+24-6,12*36+34+34+8+64-32)
    lg.rotate(math.pi/4)
    if level~='inf' then
    lg.print(fmt('Combo: %d/%d',longest_combo,level+2),20-4,0)
    else
    lg.print(fmt('Combo: %d/%d',longest_combo,7),20-4,0)
    end
    lg.pop()
    lg.setLineWidth(8)

    if (type(level)=='number' and #program==level+2) or (level=='inf' and #program==7) then
        lg.draw(batch3_images.play,leftedge+6*96+24+12,24*36-128)
    end
    fg(1,1,1)
    for h=1,math.min(hearts,16) do
        local img=batch3_images.heart
        if (h*2-t*0.2)%12<3 then img=batch3_images.heartwhiteness end
        local hx=leftedge+6*96+24+24+8
        if hearts>8 then hx=hx-24 end
        local hy=24+(h-1)*48
        if h>8 then hx=hx+48; hy=24+(h-8-1)*48 end
        lg.draw(img,hx+sin(h+t*0.2)*4,hy)
    end
    for k,j in pairs(jelloes) do
        local jx,jy=strpos(k)
        local jello=batch3_images[j.color]
        if j.flash and j.flash%20<10 then jello=batch3_images.whiteness end
        lg.draw(jello,j.x,j.y,0,1-0.05+cos((t+jx*2+jy*2)*0.2)*0.05,1-0.05+sin((t+jx*2+jy*2)*0.3)*0.05)
        local img=batch3_images.face1
        if j.color=='green' then img=batch3_images.face2 end
        if j.color=='purple' then img=batch3_images.face3 end
        if j.color=='red' then img=batch3_images.face4 end
        if jello~=batch3_images.whiteness then lg.draw(img,j.x+cos((t+jx*2+jy*2)*0.2)*8,j.y+sin((t+jx*2+jy*2)*0.3)*6) end
    end
    --fg(0.9,0.9,0.9)
    
    fg(r,g,b)
    --[[if action then
        local kx,ky=strpos(action[1])
        lg.rectangle('line',leftedge+kx*96-8,ky*96-8,96+2*8,96+2*8)
    end]]
    lg.setFont(arcadef5)
    for i,v in ipairs(program) do
        local sx,sy=strpos(v[1])
        local ex,ey=strpos(v[2])
        v.sx=v.sx or leftedge+sx*96+48; v.sy=v.sy or sy*96+48
        v.ex=v.ex or leftedge+ex*96+48; v.ey=v.ey or ey*96+48
        if v.tgty2 then
            v.acc=v.acc or 0
            v.sy=v.sy+v.acc
            v.ey=v.ey+v.acc
            v.acc=v.acc+0.4
            if v.sy>=v.tgty2 then v.sy=v.tgty2; v.ey=v.tgty2+(ey-sy)*96; v.tgty2=nil; v.acc=nil end
        end
        lg.line(v.sx,v.sy,v.ex,v.ey)
        --lg.print(v.i,v.sx,v.sy)
        local cx,cy=(v.ex+v.sx)/2, (v.ey+v.sy)/2
        fg(0.4,0.8,0.8)
        lg.circle('fill',cx,cy,20+6)
        fg(r,g,b)
        lg.circle('line',cx,cy,20+6)
        lg.print(v.i,cx-arcadef5:getWidth(v.i)/2,cy-arcadef5:getHeight(v.i)/2)
    end

    if batch3_update==plan then
    fg(1,1,1,1)
    if action then
        local jx,jy=strpos(action[1])
        lg.draw(batch3_images.select,leftedge+jx*96-16,jy*96-16)
        lg.draw(batch3_images.select,leftedge+jx*96+96+16,jy*96-16,math.pi/2)
        lg.draw(batch3_images.select,leftedge+jx*96+96+16,jy*96+96+16,math.pi)
        lg.draw(batch3_images.select,leftedge+jx*96-16,jy*96+96+16,math.pi/2*3)
    end
    for k,j in pairs(jelloes) do
        local jx,jy=strpos(k)
        if AABB(mox,moy,1,1,leftedge+jx*96,jy*96,96,96) and ((type(level)=='number' and #program<level+2) or (level=='inf' and #program<7)) then
            if not action then
            lg.draw(batch3_images.select,leftedge+jx*96-16+t%16,jy*96-16+t%16)
            lg.draw(batch3_images.select,leftedge+jx*96+96+16-t%16,jy*96-16+t%16,math.pi/2)
            lg.draw(batch3_images.select,leftedge+jx*96+96+16-t%16,jy*96+96+16-t%16,math.pi)
            lg.draw(batch3_images.select,leftedge+jx*96-16+t%16,jy*96+96+16-t%16,math.pi/2*3)
            else
            local kx,ky=strpos(action[1])
            if k~=action[1] and k==posstr(kx+1,ky) or k==posstr(kx-1,ky) or k==posstr(kx,ky+1) or k==posstr(kx,ky-1) then
            lg.draw(batch3_images.select,leftedge+jx*96-16+t%16,jy*96-16+t%16)
            lg.draw(batch3_images.select,leftedge+jx*96+96+16-t%16,jy*96-16+t%16,math.pi/2)
            lg.draw(batch3_images.select,leftedge+jx*96+96+16-t%16,jy*96+96+16-t%16,math.pi)
            lg.draw(batch3_images.select,leftedge+jx*96-16+t%16,jy*96+96+16-t%16,math.pi/2*3)
            end
            end
        end
    end
    end

    --lg.print(fmt('Combo: %d',cur_combo),0,96)
    for i=#combo_ind,1,-1 do
        local c=combo_ind[i]
        fg(r,g,b)
        if c.msg=='Game over' or c.msg=='Combo end' then fg(r2,b2,g2) end
        if c.t>=30 or c.msg=='Combo end' then --sync with flash time
        if c.t==30 and c.msg~='Combo end' and c.msg~='Game over' then batch3_audio.sparkle:stop(); batch3_audio.sparkle:setPitch(1+(cur_combo-2)*1/12); batch3_audio.sparkle:play() end
        c.l=c.l or 0
        c.l2=c.l2 or 0
        lg.setLineWidth(24)
        lg.line(c.x+cos(c.a-math.pi/2)*64+cos(c.a-math.pi)*c.l2,c.y+sin(c.a-math.pi/2)*64+sin(c.a-math.pi)*c.l2,c.x+cos(c.a-math.pi/2)*64+cos(c.a-math.pi)*c.l,c.y+sin(c.a-math.pi/2)*64+sin(c.a-math.pi)*c.l)
        lg.line(c.x+cos(c.a+math.pi/2)*64+cos(c.a-math.pi)*c.l2,c.y+sin(c.a+math.pi/2)*64+sin(c.a-math.pi)*c.l2,c.x+cos(c.a+math.pi/2)*64+cos(c.a-math.pi)*c.l,c.y+sin(c.a+math.pi/2)*64+sin(c.a-math.pi)*c.l)
        if c.l<1200 then c.l=c.l+16 end
        if c.t>=90 and c.msg~='Game over' then c.l2=c.l2+16 end
        if c.t>50 and (c.t<90+20 or c.msg=='Game over') then
        lg.push()
        local cx,cy=cos(c.a-math.pi)*16*36,sin(c.a-math.pi)*16*36
        if c.a<math.pi/2 or c.a>=3*(math.pi/2) then cx,cy=cos(c.a-math.pi)*22*36,sin(c.a-math.pi)*22*36 end
        lg.translate(c.x+cx+cos(c.a-math.pi/2)*64,c.y+cy+sin(c.a-math.pi/2)*64)
        local rot=c.a
        if c.a>=math.pi/2 and c.a<3*(math.pi/2) then 
            rot=c.a-math.pi; lg.rotate(rot); lg.translate(-300,-100-40+8) --lg.translate(-(c.x+cos(c.a-math.pi)*16*36+cos(c.a-math.pi/2)*64),-(c.y+sin(c.a-math.pi)*16*36+sin(c.a-math.pi/2)*64)); lg.rotate(rot); lg.translate(0,-300)--lg.translate(-(c.x+cos(c.a-math.pi)*16*36+cos(c.a-math.pi/2)*64),-(c.y+sin(c.a-math.pi)*16*36+sin(c.a-math.pi/2)*64)) 
        else
        lg.rotate(rot)
        end
        lg.setFont(arcadef3)
        lg.print(c.msg,0,0)
        lg.pop()
        end
        end
        if c.t>=200 and c.msg~='Game over' then rem(combo_ind,i) end
        c.t=c.t+1
    end

    lg.setLineWidth(12)
    if batch3_update==dialogue or batch3_update==dialogue2 then
        fg(97/255,0,0,0.5)
        if diag_box.w>=30 then lg.rectangle('fill',diag_box.x+30,diag_box.y+30,diag_box.w,diag_box.h) end
        fg(0.4,0.8,0.8,1)
        lg.rectangle('fill',diag_box.x,diag_box.y,diag_box.w,diag_box.h)
        local r,g,b=HSLtoRGB((t2*0.012)%1,0.9,0.9)
        fg(r,g,b)
        lg.rectangle('line',diag_box.x,diag_box.y,diag_box.w,diag_box.h)
        if math.abs(diag_box.tgth-diag_box.h)>1 then diag_box.h=diag_box.h+(diag_box.tgth-diag_box.h)*0.2
        else diag_box.x=diag_box.x+(diag_box.tgtx-diag_box.x)*0.2; diag_box.w=diag_box.w+(diag_box.tgtw-diag_box.w)*0.2 end
        if math.abs(diag_box.tgtw-diag_box.w)<1 then
            if batch3_update==dialogue then
            if t-sc_t==60 then batch3_audio.rising:stop(); batch3_audio.rising:play() end
            if t-sc_t>=60 then
                lg.setFont(arcadef1)
                local tx,ty=0,0
                for i=1,#('Longest\ncombo') do
                if i<t-sc_t-60 then
                local char=sub('Longest\ncombo',i,i)
                if char=='\n' then ty=ty+34; tx=arcadef1:getWidth('Longest')/2-arcadef1:getWidth('combo')/2 
                else
                lg.print(char,diag_box.x+24+tx,diag_box.y+diag_box.h-96+ty+sin(i+t*0.2)*4)
                tx=tx+arcadef1:getWidth(char)
                end
                end
                end
            end
            if t-sc_t==90 then
                batch3_audio.sparkle2:stop(); batch3_audio.sparkle2:play()
                starburst2(diag_box.x+24+48,diag_box.y+64,'yellow')
            end
            if t-sc_t>=90 then
                lg.setFont(arcadef2)
                lg.print(longest_combo,diag_box.x+24+48+14-arcadef2:getWidth(longest_combo)/2,diag_box.y+64)
            end
            if t-sc_t>=120 then
                lg.setFont(arcadef2)
                lg.print('-',diag_box.x+diag_box.w/3-48,diag_box.y+64)
            end
            if t-sc_t==135 then batch3_audio.rising:stop(); batch3_audio.rising:play() end
            if t-sc_t>=135 then
                lg.setFont(arcadef1)
                local tx,ty=0,0
                for i=1,#('Required\ncombo') do
                if i<t-sc_t-135 then
                local char=sub('Required\ncombo',i,i)
                if char=='\n' then ty=ty+34; tx=arcadef1:getWidth('Required')/2-arcadef1:getWidth('combo')/2
                else
                lg.print(char,diag_box.x+diag_box.w/2-80+tx,diag_box.y+diag_box.h-96+ty+sin(i+t*0.2)*4)
                tx=tx+arcadef1:getWidth(char)
                end
                end
                end
            end
            if t-sc_t==135+30 then
                batch3_audio.sparkle2:stop(); batch3_audio.sparkle2:play()
                starburst2(diag_box.x+diag_box.w/2-34,diag_box.y+64,'green')
            end
            if t-sc_t>=135+30 then
                lg.setFont(arcadef2)
                local c
                if type(level)=='number' then c=level+2
                else c=7 end
                lg.print(c,diag_box.x+diag_box.w/2-34,diag_box.y+64)
            end
            if t-sc_t>=135+30+30 then
                lg.setFont(arcadef2)
                lg.print('=',diag_box.x+diag_box.w/3*2-48,diag_box.y+64)
            end
            if t-sc_t==135+30+30+15 then
                batch3_audio.rising:stop(); batch3_audio.rising:play()
            end
            if t-sc_t>=135+30+30+15 then
                lg.setFont(arcadef1)
                local tx,ty=0,0
                for i=1,#('Hearts') do
                if i<t-sc_t-(135+30+30+15) then
                local char=sub('Hearts',i,i)
                if char=='\n' then ty=ty+34; tx=0 
                else
                lg.print(char,diag_box.x+diag_box.w/3*2+48+tx,diag_box.y+diag_box.h-96+ty+sin(i+t*0.2)*4)
                tx=tx+arcadef1:getWidth(char)
                end
                end
                end                
            end
            if t-sc_t==135+30+30+15+30 then
                batch3_audio.sparkle2:stop(); batch3_audio.sparkle2:play()
                local c
                if type(level)=='number' then c=level+2
                else c=7 end
                local msg=longest_combo-c
                if msg>0 then msg='+'..tostring(msg) end
                starburst2(diag_box.x+diag_box.w/3*2+34+34+34-arcadef2:getWidth(msg)/2,diag_box.y+64,'red')
            end
            if t-sc_t>=135+30+30+15+30 then
                lg.setFont(arcadef2)
                local c
                if type(level)=='number' then c=level+2
                else c=7 end
                local msg=longest_combo-c
                if msg>0 then msg='+'..tostring(msg) end
                lg.print(msg,diag_box.x+diag_box.w/3*2+34+34+34-arcadef2:getWidth(msg)/2,diag_box.y+64)
                fg(1,1,1)
                lg.draw(batch3_images.heart,diag_box.x+diag_box.w/3*2+34+34+34-arcadef2:getWidth(msg)/2+arcadef2:getWidth(msg),diag_box.y+64+24)
            end
            elseif batch3_update==dialogue2 then
                if t-sc_t>=60 then
                    local msg='Congratulations for beating all the\npractice levels! Now go for a high score!\n\nThis game was made by verysoftwares\nfor Juice Jam.'
                    lg.setFont(arcadef1)
                    local tx,ty=0,0
                    for i=1,#msg do
                    if i<t-sc_t-60 then
                    local char=sub(msg,i,i)
                    if char=='\n' then ty=ty+34; tx=0
                    else
                    lg.print(char,diag_box.x+24+tx,diag_box.y+80-30+ty+sin(i+t*0.2)*4)
                    tx=tx+arcadef1:getWidth(char)
                    end
                    end
                    end
                end
                if t-sc_t>=60+129 then
                end
            end
        end
    end

    fg(1,1,1)
    for i=#particles,1,-1 do
        local p=particles[i]
        p.j=p.j or i
        p.x=p.x+p.dx; p.y=p.y+p.dy
        local img=p.img
        if (p.j+t*0.2)%16<4 then
            img=batch3_images['whitenessstar'..tostring(p.i)]
        end
        lg.draw(img,p.x,p.y)
        p.dy=p.dy+0.4
        if p.y>24*36 then rem(particles,i) end
    end
    
end

function HSLtoRGB(h, s, l)
    if s == 0 then return l, l, l end
    local function to(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < .16667 then return p + (q - p) * 6 * t end
        if t < .5 then return q end
        if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
        return p
    end
    local q = l < .5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end
