local btns={
    'up','down','left','right','z','x','a','s'
}
sweetie16={
{0x1a,0x1c,0x2c},
{0x5d,0x27,0x5d},
{0xb1,0x3e,0x53},
{0xef,0x7d,0x57},
{0xff,0xcd,0x75},
{0xa7,0xf0,0x70},
{0x38,0xb7,0x64},
{0x25,0x71,0x79},
{0x29,0x36,0x6f},
{0x3b,0x5d,0xc9},
{0x41,0xa6,0xf6},
{0x73,0xef,0xf7},
{0xf4,0xf4,0xf4},
{0x94,0xb0,0xc2},
{0x56,0x6c,0x86},
{0x33,0x3c,0x57},
}
local tic_wide_font=love.graphics.newFont('wares/TIC-80 wide font.ttf',6)
local tic_wide_font2=love.graphics.newFont('wares/TIC-80 wide font.ttf',6*2)
local tic_wide_font3=love.graphics.newFont('wares/TIC-80 wide font.ttf',6*3)
local tic_smallfont=love.graphics.newImageFont('wares/TIC-smallfont.png','abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.?!\'" ',1)
for i,p in ipairs(sweetie16) do
    for j,c in ipairs(p) do
        p[j]=c/255
    end
end

function btn(i)
    for j,b in ipairs(btns) do
        if j-1==i then return press(b) end
    end
end

function btnp(i)
    for j,b in ipairs(btns) do
        if j-1==i then return tapped(b) end
    end
end

loveprint=print
function print(text,x,y,color,fixed,scale,smallfont)
    color=color or 0
    local fn=tic_wide_font
    if scale==2 then fn=tic_wide_font2 end
    if scale==3 then fn=tic_wide_font3 end
    if smallfont then fn=tic_smallfont end
    love.graphics.setFont(fn)
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.print(text,math.floor(x),math.floor(y))
    return fn:getWidth(text)
end

sprite_quads={}
function spr(id,x,y,colorkey,scale,flip,rotate,w,h)
    w=w or 1; h=h or 1
    local sx,sy=id%16,math.floor(id/16)
    local ssheet=spritesheet
    if id>=256 then 
        sx,sy=(id-256)%16,math.floor((id-256)/16) 
        ssheet=spritesheet2
    end
    sx=sx*8; sy=sy*8
    if not sprite_quads[id] then
        sprite_quads[id]=love.graphics.newQuad(sx,sy,w*8,h*8,ssheet)
    end
    love.graphics.setColor(1,1,1,1)
    if love.graphics.getShader()==nil then love.graphics.setShader(paletteswap) 
    end --else loveprint(love.graphics.getShader()) end
    paletteswap:send('colorkey',colorkey)
    love.graphics.draw(ssheet,sprite_quads[id],x,y,0,scale,scale)
    love.graphics.setShader()
end

function pix(x,y,color)
    if not color then
        -- get pixel rather than set it
        if x<0 or x>=game.canvas:getWidth() or y<0 or y>=game.canvas:getHeight() then
            return 0
        end
        -- can't get newImageData from an active canvas
        love.graphics.setCanvas()
        local id=game.canvas:newImageData()
        love.graphics.setCanvas(game.canvas)
        local r,g,b,a=id:getPixel(x,y)
        for i,p in ipairs(sweetie16) do 
            if p[1]==r and p[2]==g and p[3]==b then return i-1 end
        end 
        return 0
    end
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.points(x,y+1)
end

function cls(color)
    love.graphics.clear(sweetie16[math.floor(color+1)])
end

function clip(x,y,w,h)
    if not x then love.graphics.setScissor(); return end
    love.graphics.setScissor(x,y,w,h)
end

love.graphics.setLineWidth(1)
function rect(x,y,w,h,color)
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.rectangle('fill',x,y,w,h)
end
function rectb(x,y,w,h,color)
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.rectangle('line',x,y,w,h)
end

function circ(x,y,r,color)
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.circle('fill',x,y,r)
end
function circb(x,y,r,color)
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.circle('line',x,y,r)
end

function line(x1,y1,x2,y2,color)
    love.graphics.setColor(sweetie16[math.floor(color+1)])
    love.graphics.line(x1+0.5,y1+0.5,x2+0.5,y2+0.5)
end

function peek()
end

function poke4()
end

local map={}
function mget(x,y)
    if not map[posstr(x,y)] then return 0 end
    return map[posstr(x,y)]
end

function mset(x,y,id)
    map[posstr(x,y)]=id
end

function music(id)
    if not id then if cur_audio then cur_audio:stop() end return end
    if cur_audio then cur_audio:stop() end
    cur_audio=tic_music[id+1]
    if cur_audio then cur_audio:play() end
end

function sfx(id)
    if not tic_sfx then return end
    if cur_sfx then cur_sfx:stop() end
    if not tic_sfx[id+1] or tic_sfx[id+1]==-1 then return end
    cur_sfx=tic_sfx[id+1]
    tic_sfx[id+1]:play()
end

function mouse()
    local mox,moy=love.mouse.getPosition()
    return (mox-game.x)/game.scale,(moy-game.y)/game.scale,love.mouse.isDown(1),love.mouse.isDown(3),love.mouse.isDown(2),0,0
end

function key()
end
function keyp(id)
    if id==18 then return tapped('r') end
end

flags={}
function fset(id,f)
    if not flags[id] then flags[id]={} end
    table.insert(flags[id],f)
end

function fget(id,f)
    if not flags[id] then return false end
    if find(flags[id],f) then return true end
    return false
end

function trace(msg)
    loveprint(msg)
end

function reset()
    if game.id=='PocketBolo' then
        pocketbolo_reset()
    end
end

paletteswap = love.graphics.newShader[[
extern int colorkey;
extern vec3 sweetie16[16];
extern int override_pal[16];

int palette_col(float r,float g,float b) {
    int i;
    for (i=0; i<16; i++) {
        if (sweetie16[i].r==r && sweetie16[i].g==g && sweetie16[i].b==b) {
            return i;
        }
    }
    return 0;
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords);
    int col_index=palette_col(pixel.r,pixel.g,pixel.b);
    if (col_index==colorkey) { return vec4(0,0,0,0); }
    if (override_pal[col_index]!=col_index) {
        vec3 replace=sweetie16[override_pal[col_index] ];
        return vec4(replace.r,replace.g,replace.b,1);
    }
    /*if (colorkey>=0 && colorkey<16 && pixel.r==sweetie16[colorkey].r && pixel.g==sweetie16[colorkey].g && pixel.b==sweetie16[colorkey].b) { return vec4(0,0,0,0); }*/
    return pixel * color;
}
]]
--paletteswap:send('colorkey',-1)
--paletteswap:send('p0r',0)
--paletteswap:send('p0g',0)
--paletteswap:send('p0b',0)
paletteswap:send('sweetie16',unpack(sweetie16))

local override_pal={}
for i=0,16-1 do table.insert(override_pal,i) end
paletteswap:send('override_pal',unpack(override_pal))
function pal(c1,c2)
    if not c1 then for i=0,16-1 do override_pal[i+1]=i end; paletteswap:send('override_pal',unpack(override_pal)); return end 
    override_pal[c1+1]=c2
    paletteswap:send('override_pal',unpack(override_pal))
end