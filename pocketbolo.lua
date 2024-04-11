-- title:   PocketBolo
-- author:  verysoftwares
-- desc:    tribute to BoloBall
-- script:  lua

demo=false

t=0

pocketbolo_active={}
coll={}

turn=1

scores={}

SP_BALLOON=34
SP_PURSE=68
SP_CONV_LEFT1=64
SP_CONV_LEFT2=98
SP_CONV_RIGHT1=96
SP_CONV_RIGHT2=130

function update()

    cls(12)
    
    handle_mouse()

    game_tick()
          
    draw_bg()
    
    draw_scores()

    draw_map()    
  
    if pocketbolo_gameover() then
        view_results()
    end
    
    --t=t+1
end

function handle_mouse()
    local mox,moy=get_mouse()   
    mox,moy=snap_to_grid(mox,moy)
    rect(mox,moy,16,16,0)
    select_active(mox,moy)
end

function game_tick()
    if t%16==0 then
        process_active()

        if (turnstart and #pocketbolo_active==0) 
        or (ai_select(turn)<0 and not pocketbolo_gameover()) then
            end_turn()
        end
    end
end

function draw_bg()
    rect(0,0,240,4,13)
    rect(0,136-4,240,4,13)
    rect(0,4,6*8,136-8,13)
    rect(240-6*8,0,6*8,136,14)
    for i=0,(240-12*8),32 do
        rect(6*8+i,0,16,4,14)
        rect(6*8+16+i,136-4,16,4,14)
    end
end

function draw_scores()
    -- borders
    -- flashing if your turn
        if turn==1 then
            local col=3
            if t%32>=16 then col=1 end
            rectb(0+0.5,4+0.5,6*8-1,136-8-1,col)
            rectb(240-6*8+0.5,4+0.5,6*8-1,136-8-1,6)
        elseif turn==2 then
            local col=6
            if t%32>=16 then col=1 end
            rectb(240-6*8+0.5,4+0.5,6*8-1,136-8-1,col)
            rectb(0+0.5,4+0.5,6*8-1,136-8-1,3)
        end

    -- vertical numbers   
        for j=1,2 do
            local msg=string.format('%.5d',get_score(j))
            local col=3
            if j==2 then col=6 end
            for c=1,#msg do
                print(string.sub(msg,c,c),6*8/2-3+(j-1)*(240-6*8),48+c*6,col)
            end
        end
end

dirs={{-1,0},{1,0},{0,-1},{0,1}}
function draw_map()
    for mx=30-12-1,0,-1 do for my=16-1,0,-1 do
        local id=mget(mx,my)
        local sp1,sp2
        if id==SP_CONV_LEFT1 then
            sp1=32; sp2=128
        end
        if id==SP_CONV_RIGHT1 then
            sp1=32; sp2=160
        end
        if id==SP_CONV_LEFT2 then
            sp1=100; sp2=128
        end
        if id==SP_CONV_RIGHT2 then
            sp1=100; sp2=160
        end
        if fget(id,2) then
            spr(sp1,6*8+mx*8,4+my*8,0,1,0,0,2,2)
            clip(6*8+mx*8+1,4+my*8+2,14,12)
            if sp2==128 then
                spr(sp2,6*8+mx*8-t*0.2%16,4+my*8,0,1,0,0,2,2)
                spr(sp2,6*8+mx*8+16-t*0.2%16,4+my*8,0,1,0,0,2,2)
            elseif sp2==160 then
                spr(sp2,6*8+mx*8+t*0.2%16,4+my*8,0,1,0,0,2,2)
                spr(sp2,6*8+mx*8-16+t*0.2%16,4+my*8,0,1,0,0,2,2)
            end
            clip()
        elseif id==SP_PURSE and mx==tilex and my==tiley then
            spr(70,6*8+mx*8,4+my*8,0,1,0,0,2,2)
        elseif id==SP_BALLOON and mx==tilex and my==tiley then
            spr(38,6*8+mx*8,4+my*8,0,1,0,0,2,2)
        elseif not fget(id,3) then
            spr(id,6*8+mx*8,4+my*8,0)
        end

        -- score labels
            if id==SP_BALLOON or id==SP_PURSE then
                if scores[posstr(mx,my)] then 
                    local tw=print(scores[posstr(mx,my)],0,-6,0,false,1,true)
                    for i,v in ipairs(dirs) do
                        print(scores[posstr(mx,my)],6*8+mx*8+8-tw/2+v[1],4+my*8+6+v[2],1,false,1,true)
                    end
                    print(scores[posstr(mx,my)],6*8+mx*8+8-tw/2,4+my*8+6,4,false,1,true)
                end
                for i,a in ipairs(pocketbolo_active) do
                    if a.x==mx and a.y==my and a.sc>0 then
                        local tw=print(a.sc,0,-6,0,false,1,true)
                        for i,v in ipairs(dirs) do
                            print(a.sc,6*8+mx*8+8-tw/2+v[1],4+my*8+6+v[2],1,false,1,true)
                        end
                        print(a.sc,6*8+mx*8+8-tw/2,4+my*8+6,4,false,1,true)
                    end
                end
            end
    end end
    
    -- explosions for recently destroyed objects
        for k,c in pairs(coll) do
            local cx,cy=strpos(k)
            spr(102,6*8+cx*8,4+cy*8,0,1,0,0,2,2)
            coll[k]=c+1
            if coll[k]>16 then coll[k]=nil end
        end
end

function pocketbolo_gameover()
    return #pocketbolo_active==0 and ai_select(1)<0 and ai_select(2)<0
end

function view_results()
    sc_t=sc_t or t
    if sc_t==t then
        trace('----',4)
        trace(string.format('Orange: %d',get_score(1)),3)
        trace(string.format('Green: %d',get_score(2)),6)
        for i=#pocketbolo_active,1,-1 do
            rem_active(i)
        end
    end
    
    rect(0,16-2,240,32,9)
    
    local tw
    local msg
    local col
    if get_score(1)>get_score(2) then
        if sc_t==t and chars[1][chars[1].i]=='Human' then add_paws(20,'orange wins') end
        msg='Orange wins!'
        col=3
    end
    if get_score(1)==get_score(2) then
        if sc_t==t and (chars[1][chars[1].i]=='Human' or chars[2][chars[2].i]=='Human') then add_paws(10,'tie') end
        msg='It\'s a tie!'
        col=4
    end
    if get_score(2)>get_score(1) then
        if sc_t==t and chars[2][chars[2].i]=='Human' then add_paws(20,'green wins') end
        msg='Green wins!'
        col=6
    end
    draw_logo(msg,3,col)
    
    tw=print('R to reset.',0,-6,0,false,1,false)
    print('R to reset.',240/2-tw/2,136/2-6-3+6*3+4+1-32-10,1,false,1,false)
    print('R to reset.',240/2-tw/2,136/2-6-3+6*3+4-32-10,4,false,1,false)
    if keyp(18) or (demo and t-sc_t>5*60) then 
    reset() 
    end
end

function end_turn()
    turn=turn+1
    if turn>2 then turn=1 end
    turnstart=false
    pers_mox=nil; pers_moy=nil
end

function select_active(mox,moy)
    tilex,tiley=(mox-6*8)/8,(moy-4)/8
    if left and not leftheld and #pocketbolo_active==0 then
        if (turn==1 and mget(tilex,tiley)==SP_BALLOON) or (turn==2 and mget(tilex,tiley)==SP_PURSE) then
            turnstart=true
            local found=false
            for i,a in ipairs(pocketbolo_active) do
                if a.x==tilex and a.y==tiley then found=true; break end
            end
            if not found then
            table.insert(pocketbolo_active,{x=tilex,y=tiley,sc=0})

            -- inherit score from BG to new active
                if scores[posstr(tilex,tiley)] then
                    pocketbolo_active[#pocketbolo_active].sc=scores[posstr(tilex,tiley)]
                    scores[posstr(tilex,tiley)]=nil
                end
            end
        end
    end
end

function get_mouse()
    leftheld=left
    mox,moy,left=mouse()
    
    if chars[turn][chars[turn].i]=='AI' and not turnstart then 
        pers_mox,pers_moy=ai_select(turn) 
        left=true; leftheld=false 
    end

    if pers_mox and pers_moy then
        return pers_mox,pers_moy
    end
    
    return mox,moy
end

function ai_select(j)
    local avail={}
    for tx=0,18-1,2 do for ty=0,16-1,2 do
        if (j==1 and mget(tx,ty)==SP_BALLOON) or (j==2 and mget(tx,ty)==SP_PURSE) then
            if can_move(tx,ty,j) then
                table.insert(avail,{x=tx,y=ty})
            end
        end
    end end
    if #avail==0 then return -16,-16 end
    local sel=avail[math.random(#avail)]
    return 6*8+sel.x*8,4+sel.y*8
end

function can_move(tx,ty,j)
    local dy
    if j==1 then dy=-2 end
    if j==2 then dy= 2 end
    if ty+dy>=0 and ty+dy<16 and fget(mget(tx,ty+dy),1) then
        return true
    end
    return false
end

function snap_to_grid(mox,moy)
    return mox-mox%16,(moy-4)-(moy-4)%16+4
end

function process_active()
    table.sort(pocketbolo_active,function(a,b) 
        if mget(a.x,a.y)==SP_BALLOON then return a.y<b.y end
        if mget(a.x,a.y)==SP_PURSE then return a.y>b.y end
    end)
    for i=#pocketbolo_active,1,-1 do
        local a=pocketbolo_active[i]
        if not a.oldsc then a.oldsc=a.sc or 0 end
    end
    for i=#pocketbolo_active,1,-1 do
        local a=pocketbolo_active[i]
        local id=mget(a.x,a.y)
        if id==SP_BALLOON or id==SP_PURSE then
            local dy
            if id==SP_BALLOON then dy=-2 end
            if id==SP_PURSE   then dy= 2 end
            local id2=mget(a.x,a.y+dy)
            if id2==0 then
                move_vert(i,dy)
            elseif id2==SP_BALLOON or id2==SP_PURSE then
                obj_collide(i,id2,0,dy)
                rem_active(i)
            elseif id2==SP_CONV_LEFT1 or id2==SP_CONV_LEFT2 then
                move_horiz(i,id2,-2,dy)
            elseif id2==SP_CONV_RIGHT1 or id2==SP_CONV_RIGHT2 then
                move_horiz(i,id2, 2,dy)
            end
        end
    end
end

function move_vert(i,dy)
    local a=pocketbolo_active[i]
    if a.y+dy<16 and a.y+dy>=0 then
    for sx=0,2-1 do for sy=0,2-1 do
        mset(a.x+sx,a.y+dy+sy,mget(a.x+sx,a.y+sy))
        mset(a.x+sx,a.y+sy,0)
    end end
    a.y=a.y+dy
    a.sc=a.sc+10
    sfx(19,'C-5',16,2)
    else
    rem_active(i)
    end
end

function move_horiz(i,id,dx,dy)
    local a=pocketbolo_active[i]
    if dx<0 then 
        if id==SP_CONV_LEFT1 then
            local base=SP_CONV_RIGHT2
            for sx=0,2-1 do for sy=0,2-1 do
                mset(a.x+sx,a.y+dy+sy,base+sx+sy*16)
            end end
            sfx(19,'G-5',16,2)
        elseif id==SP_CONV_LEFT2 then
            for sx=0,2-1 do for sy=0,2-1 do
                mset(a.x+sx,a.y+dy+sy,0)
            end end
            coll[posstr(a.x,a.y+dy)]=0
            sfx(20,'A-5',32,2)
        end
    else
        if id==SP_CONV_RIGHT1 then
            local base=SP_CONV_LEFT2
            for sx=0,2-1 do for sy=0,2-1 do
                mset(a.x+sx,a.y+dy+sy,base+sx+sy*16)
            end end
            sfx(19,'G-5',16,2)
        elseif id==SP_CONV_RIGHT2 then
            for sx=0,2-1 do for sy=0,2-1 do
                mset(a.x+sx,a.y+dy+sy,0)
            end end
            coll[posstr(a.x,a.y+dy)]=0
            sfx(20,'A-5',32,2)
        end
    end
        
    a.sc=a.sc+10
    local id3=mget(a.x+dx,a.y)
    if id3==0 then
        if a.x+dx>=0 and a.x+dx<18 then
            for sx=0,2-1 do for sy=0,2-1 do
                mset(a.x+sx+dx,a.y+sy,mget(a.x+sx,a.y+sy))
                mset(a.x+sx,a.y+sy,0)
            end end
            a.x=a.x+dx
        else
            if (dx<0 and id==SP_CONV_LEFT1) or (dx>0 and id==SP_CONV_RIGHT1) then
                rem_active(i)
            end
        end
    else
        if id3==SP_BALLOON or id3==SP_PURSE then
            obj_collide(i,id3,dx,0)
            if mget(a.x,a.y)==0 or mget(a.x,a.y+dy)~=0 then
                rem_active(i)
            end
        else
            if (dx<0 and id==SP_CONV_LEFT1) or (dx>0 and id==SP_CONV_RIGHT1) then
            rem_active(i)
            end
        end
    end   
end

function obj_collide(i,id,dx,dy)
    local a=pocketbolo_active[i]
    if mget(a.x,a.y)~=id then
    for sx=0,2-1 do for sy=0,2-1 do
        mset(a.x+sx,a.y+sy,0)
        mset(a.x+sx+dx,a.y+dy+sy,0)
    end end
    scores[posstr(a.x+dx,a.y+dy)]=nil
    coll[posstr(a.x,a.y)]=0
    coll[posstr(a.x+dx,a.y+dy)]=0
    sfx(20,'A-5',32,2)
    end
end

function rem_active(i)
    local a=pocketbolo_active[i]
    if (mget(a.x,a.y)==SP_BALLOON or mget(a.x,a.y)==SP_PURSE) and a.sc>0 then 
        scores[posstr(a.x,a.y)]=a.sc
        if chars[turn][chars[turn].i]=='Human' then
        add_paws((a.sc-a.oldsc)/10,'successful move')
        end
    end
    table.remove(pocketbolo_active,i)
end

chars={
    {'Human','AI',i=1},
    {'Human','AI',i=2},
}
fade=0
function titlescr()

    cls(12)
    
    leftheld=left
    mox,moy,left=mouse()
    
    select_players()

    start_game()

    draw_bg()

    draw_logo('PocketBolo',2,2)
        
    if fadeout then fade=fade+1
    if fade==60 then TIC=update; music(1) end
    end
end

function select_players()
    rect(6*8+12-fade*3,42+10,120,13,3)
    circ(6*8+12-fade*3,42+10+6,7+1,3)
    circ(6*8+12-fade*3+120,42+10+6,7+1,3)
    print('Orange player is...',6*8+12+4-fade*3,42+10-6,3,false,1,true)
    rect(6*8+12+fade*3,42+10+30,120,13,6)
    circ(6*8+12+fade*3,42+10+6+30,7+1,6)
    circ(6*8+12+fade*3+120,42+10+6+30,7+1,6)
    print('Green player is...',6*8+12+4+fade*3,42+10-6+30,6,false,1,true)

    for i,c in ipairs(chars) do
        for j,d in ipairs(c) do
            local tw=print(d,6*8+12+8+(j-1)*64+20-4,42+10+6-2+(i-1)*30,12,false,1,true)
            if left and not leftheld and not fadeout and AABB(6*8+12+8+(j-1)*64+20-4-2,42+10+6-2+(i-1)*30-2,tw+2+1,8+1,mox,moy,1,1) then
                c.i=j
                sfx(18,'A-6',20,2)
            end
            if j==c.i then
                rectb(6*8+12+8+(j-1)*64+20-4-2+0.5,42+10+6-2+(i-1)*30-2+0.5,tw+2+1-1,8+1-1,12)
            end
        end
    end
end

function start_game()
    rect(6*8+12+40-fade*3,42+10+30+30,120-40*2,13,13)
    circ(6*8+12+40-fade*3,42+10+6+30+30,7+1,13)
    circ(6*8+12+120-40-fade*3,42+10+6+30+30,7+1,13)
    tw=print('Start',0,-6,0)
    print('Start',6*8+12+60-tw/2-fade*3,42+10+6+30+30-2,4)
    if left and not leftheld and not fadeout and AABB(6*8+12+40,42+10+30+30,120-40*2,13,mox,moy,1,1) then
        sfx(16,'A-6',52,2)
        music()
        generate_map()
        fadeout=true
    end
end

function draw_logo(logo,scale,color)
    local tw=print(logo,0,-6*scale,0,false,scale,false)
    print(logo,240/2-tw/2,6*scale+scale,1,false,scale,false)
    print(logo,240/2-tw/2,6*scale,color,false,scale,false)
    rect(240/2-tw/2-2*scale,6*scale-scale,tw+4*scale,scale,color)
    rect(240/2-tw/2-2*scale,6*scale+6*scale,tw+4*scale,scale,1)
end

function get_score(j)
    local out=0 
    local tgt=SP_BALLOON
    if j==2 then tgt=SP_PURSE end
    for i,a in ipairs(pocketbolo_active) do
    if mget(a.x,a.y)==tgt then out=out+a.sc end
    end
    for k,s in pairs(scores) do
    if mget(strpos(k))==tgt then out=out+s end
    end
    return out
end

function generate_map()
    for sx=0,18-1,2 do for sy=0,16-1,2 do
        if love.math.random()<0.4 and mget(sx,sy)==0 then
            local base=96
            if love.math.random()<0.5 then
            base=64
            end
            mset(sx,sy,base); mset(sx+1,sy,base+1)
            mset(sx,sy+1,base+16); mset(sx+1,sy+1,base+16+1)
        end
    end end
end

-- you give this the numbers 0 and 1, it will return a string '0:1'.
-- table keys use this format consistently. 
    function posstr(x,y)
        return string.format('%d:%d',math.floor(x),math.floor(y))
    end

-- you give this the string '0:1', it will return 0 and 1. 
    function strpos(pos)
        local delim=string.find(pos,':')
        local x=string.sub(pos,1,delim-1)
        local y=string.sub(pos,delim+1)
        --important tonumber calls
        --Lua will handle a string+number addition until it doesn't
        return tonumber(x),tonumber(y)
    end

-- basic AABB collision.
    function AABB(x1,y1,w1,h1, x2,y2,w2,h2)
        return (x1 < x2 + w2 and
                x1 + w1 > x2 and
                y1 < y2 + h2 and
                y1 + h1 > y2)
    end

--[[TIC=titlescr
music(0)
if demo then
    TIC=update
    generate_map()
    music(1)
    chars[1].i=2
end]]

function populate()
    for sx=0,18-1,2 do
        mset(sx,0,68); mset(sx+1,0,68+1)
        mset(sx,1,68+16); mset(sx+1,1,68+1+16)
        mset(sx,16-2,34); mset(sx+1,16-2,34+1)
        mset(sx,16-2+1,34+16); mset(sx+1,16-2+1,34+1+16)
    end
end
--populate()

function pocketbolo_reset()
    spritesheet=love.graphics.newImage('wares/pocketbolo-assets/pocketbolo-sprites.png')
    tic_music={
        love.audio.newSource('wares/pocketbolo-assets/title.ogg','stream'),
        love.audio.newSource('wares/pocketbolo-assets/game.ogg','stream'),
    }
    for i,v in ipairs(tic_music) do v:setLooping(true) end
    tic_sfx={}
    TIC=titlescr
    music(0)
    fadeout=nil
    fade=0
    fset(0,1)
    fset(64,1)
    fset(96,1)
    fset(98,1)
    fset(130,1)
    for sx=0,18-1 do for sy=0,16-1 do
        mset(sx,sy,0)
    end end
    scores={}
    populate()
end