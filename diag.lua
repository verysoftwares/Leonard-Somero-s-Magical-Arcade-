diagbox={x=80,y=sh-(24+128+24+32),w=sw-2*80,h=24+128+24}

cur_diag=''
function dialogueprint(diag)
    if diag~=cur_diag then
        cur_diag=diag
        local split={}
        local s=1
        local old_s
        -- for one-liners
        if not string.find(cur_diag,' ',s+1) then ins(split,cur_diag) end
        while string.find(cur_diag,' ',s+1) do
            ins(split,sub(cur_diag,s==1 and s or s+1,string.find(cur_diag,' ',s+1)))
            --print(split[#split])
            old_s=s
            s=string.find(cur_diag,' ',s+1)
            if not string.find(cur_diag,' ',s+1) then
                ins(split,sub(cur_diag,s+1))
                --print(split[split])
            end                        
        end
        diag_split={}
        local testrow=''
        local oldrow=''
        for i,word in ipairs(split) do
            oldrow=testrow
            --if i~=1 then testrow=testrow..' ' end
            testrow=testrow..word
            if fonts.main2:getWidth(testrow)>sw-2*80-3*24-128 then
                ins(diag_split,{oldrow,c=1})
                testrow=word
            end
            if i==#split then
                ins(diag_split,{testrow,c=1})
            end
        end
    end
end

function voiceover(wav)
    if not audio[wav] then
        audio[wav]=love.audio.newSource(fmt('wares/%s.ogg',wav),'stream')
        audio[wav]:play()
        local dur = audio[wav]:getDuration()
        tick_dur=dur/#cur_diag
        au_lastcheck=0
        elapsed=0
    end
    local elapsed2=audio[wav]:tell()
    elapsed=elapsed+(elapsed2-au_lastcheck)
    tick=false
    if elapsed>=tick_dur then elapsed=elapsed-tick_dur; tick=true end
    au_lastcheck=elapsed2
end

function create_section(dg,vo,dur,init,const)
    return {
        dg=dg,
        vo=vo,
        dur=dur,
        maxdur=dur,
        init=init,
        const=const,
    }
end

sections={
    create_section('It\'s a table. It\'s a table. It\'s a table. It\'s a table. It\'s a table. It\'s a table. It\'s a table.',
                   'fun but challenging',
                   60*3,
                   nil,
                   nil)
}

t=0--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+140--15540--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+140--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+60*14+40+140+60*5+60*19+60+60*11--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+60*14+40+140+60*5+60*19+60+60*11+60*4+60*9+30+60*3+60*3+30+60*2-60--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+140--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+60*14+40+140+60*5+60*19+60+60*11+60*4--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+140--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+60*14+40+140+60*5--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20+60*11+30+5*60+50+140--2490+30+260+90+30+80+60*9+20+60*12+380+50--2490+30--+260+90+30+80+60*9+20+60*12+380+50--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40+60*15+20--2490+30+260+90+30+80+60*9+20+60*12+380+50+60*15+60*9+40--2490+30
sc_t=t+1
t2=nil
at=0
cur_section_i=1
cur_section=sections[cur_section_i]

if cur_section_i>1 then diagbox.w=1280-2*120 end

function diag_update()
    if t2 then
        t2=t2-1
        if t2==0 then t2=nil end
        at=at+1
        return
    end

    if cur_section then
    if cur_section.dg~=nil then dialogueprint(cur_section.dg) end
    if cur_section.vo~=nil then voiceover(cur_section.vo) end
    if cur_section.dur==cur_section.maxdur and cur_section.init then cur_section.init() end
    if cur_section.const then cur_section.const() end
    if cur_section.dur>0 then 
        cur_section.dur=cur_section.dur-1
        if cur_section.dur==0 then 
            cur_section_i=cur_section_i+1
            cur_section=sections[cur_section_i]
            sc_t=t+1
        end
    end
    end

    --t=t+1
    at=at+1
end

--diag_canvas=lg.newCanvas(sw,sh)
function diag_draw()
    --lg.setDefaultFilter('nearest')
    lg.setCanvas(canvas)
    --lg.clear(0,0,0,0)

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
    fg(1,1,1)
    local old_font=lg.getFont()
    lg.setFont(fonts.main2)
    fg(0.8,0.8,0.8)
    diag_split=diag_split or {}
    local tgth=24+#diag_split*36+24
    if tgth<24+128+24 then tgth=24+128+24 end
    diagbox.h=diagbox.h+(tgth-diagbox.h)*0.1
    diagbox.y=diagbox.y+(sh-32-diagbox.h-diagbox.y)*0.2
    local th=0
    for i,row in ipairs(diag_split) do
        th=th+fonts.main2:getHeight(row[1])
    end 
    local ty=diagbox.y+24
    for i,row in ipairs(diag_split) do
        local tx=diagbox.x+24+128+24
        lg.print(sub(row[1],1,row.c),tx,ty)
        ty=ty+fonts.main2:getHeight(row[1])
        if row.c<#row[1] then 
            if string.find('aeiouyAEIOUY',sub(row[1],row.c,row.c)) then him=images.he_talcc else him=images.he_thincc end
            if tick then row.c=row.c+1 end
            break
        else him=images.he_thincc end
    end
    him=him or images.he_thincc
    fg(1,1,1)
    lg.draw(him,diagbox.x+24,diagbox.y+24,0,2,2)
    --lg.printf(cur_diag,diagbox.x+24+128+24,diagbox.y+24,1280-2*120-3*24-128)
    lg.setFont(old_font)
    --lg.setCanvas()
    --fg(1,1,1,1)
    --lg.draw(diag_canvas,0,0)
end