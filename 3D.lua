local vertexFormat = {
    {"VertexPosition", "float", 3},
    {"VertexTexCoord", "float", 2},
}
local vertexFormat2 = {
    {'VertexColor','float',3},
}

local textures = {
}

love.graphics.setDepthMode('less',true)

sw,sh=love.graphics.getDimensions()
canvas=love.graphics.newCanvas(sw,sh)

function gpu_render()
    love.graphics.setCanvas({{canvas},stencil=true,depth=true})
    love.graphics.clear(0.0122*14,0.012*14,0.025*14)

    love.graphics.setShader(threed_shader)
    threed_shader:send('proj',projmat2)
    threed_shader:send('rotX',matrotX)
    --loveprint(camera3d.x,camera3d.y,camera3d.z)
    threed_shader:send('camera3d',{camera3d.x,camera3d.y,camera3d.z,0})
    --local tex={test_tex,test_tex2,test_tex3,test_tex4}
    --local ct=tex[math.floor((t*0.08)%4+1)]
    
    --ct=cube_tex[math.floor((t*0.08)%7+1)]
    --threed_shader:send('tex2',ct)
    --threed_shader:send('tex2',test_tex)
    threed_shader:send('tex3',test_tex)
    threed_shader:send('t',t*0.02)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(mesh,0,0)
    love.graphics.setShader()
    love.graphics.print(string.format('(%d,%d,%d,%s)',camera3d.x,camera3d.y,camera3d.z,totime(t)))

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(canvas)

    if (press('up') or press('down') or press('left') or press('right') or press('q') or press('w')) then
    t=t+1
    end
end

function point(x,y,z,u,v)
    return {x,y,z,x=x,y=y,z=z,u,v}
end

function mat4x4()
    return {{0,0,0,0},
            {0,0,0,0},
            {0,0,0,0},
            {0,0,0,0},
          }
end

--aliases
    tan=math.tan
    pi=math.pi
    cos=math.cos
    sin=math.sin
    ins=table.insert
    sqrt=math.sqrt
    fmt=string.format
    rem=table.remove

--projection matrix
    projmat2 = mat4x4()
    --rendering limits
        local near=0.1
        local fov=90
    local aspect=sw/sh
    local fovrad=1/tan((fov * (pi/180)) * 0.5)
    
    projmat2[1][1]=fovrad/aspect
    projmat2[2][2]=fovrad
    projmat2[3][3]=1
    projmat2[3][4]=-2*near
    projmat2[4][3]=1
    projmat2[4][4]=0

camera3d=point(-146,-62,-445)
table.insert(camera3d,0)
lookdir=point(0,0,0)
yaw=0
rot=0
turn=math.pi/2*3
turnchange=math.pi/2*3
dy=0

--arguments: input vector, matrix, output/result vector
function vec_mat_mult(i, m, o)
    o.x = i.x*m[1][1] + i.y*m[2][1] + i.z*m[3][1] + m[4][1]
    o.y = i.x*m[1][2] + i.y*m[2][2] + i.z*m[3][2] + m[4][2]
    o.z = i.x*m[1][3] + i.y*m[2][3] + i.z*m[3][3] + m[4][3]
    local w = i.x*m[1][4] + i.y*m[2][4] + i.z*m[3][4] + m[4][4]

    if not (w==0) then o.x=o.x/w; o.y=o.y/w; o.z=o.z/w end
end

function emptytriangle()
    return {{},{},{}}
end

function wireframe_tri(x1,y1,x2,y2,x3,y3,c)
    --line(x1,y1,x2,y2,c)
    --line(x2,y2,x3,y3,c)
    --line(x3,y3,x1,y1,c)
    love.graphics.setColor(0.6,0.6,0.8)
    love.graphics.polygon('line',x1,y1,x2,y2,x3,y3)
end

function flat_tri(x1,y1,x2,y2,x3,y3,d)
    love.graphics.setColor(0.6-d*0.5,0.6-d,0.8-d)
    love.graphics.polygon('fill',x1,y1,x2,y2,x3,y3)
end

function vec_cross(v1,v2,res)
    --cross-product
    res.x = v1.y*v2.z - v1.z*v2.y
    res.y = v1.z*v2.x - v1.x*v2.z
    res.z = v1.x*v2.y - v1.y*v2.x
end

function vec_cross2(v1,v2)
    local res=point(0,0,0)
    res.x = v1.y*v2.z - v1.z*v2.y
    res.y = v1.z*v2.x - v1.x*v2.z
    res.z = v1.x*v2.y - v1.y*v2.x
    return res
end

function vec_dot(v1,v2)
    -- dot product
    return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end

function vec_norm(v)
    --also, it's the letter l, not the number 1
    local l = sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
    v.x=v.x/l; v.y=v.y/l; v.z=v.z/l
end

function colorize(lum)
    if lum<0 then lum=0 end
    if lum>1 then lum=1 end
    return 1-lum
end

function round(n) return math.floor(n+0.5) end

function mat_rotX(arad)
    local out=mat4x4()
    out[1][1]=1
    out[2][2]=cos(arad)
    out[2][3]=sin(arad)
    out[3][2]=-sin(arad)
    out[3][3]=cos(arad)
    out[4][4]=1
    return out
end

function mat_rotY(arad)
    local out=mat4x4()
    out[1][1]=cos(arad)
    out[1][3]=sin(arad)
    out[3][1]=-sin(arad)
    out[2][2]=1
    out[3][3]=cos(arad)
    out[4][4]=1
    return out
end

function mat_rotZ(arad)
    local out=mat4x4()
    out[1][1]=cos(arad)
    out[1][2]=sin(arad)
    out[2][1]=-sin(arad)
    out[2][2]=cos(arad)
    out[3][3]=1
    out[4][4]=1
    return out
end

function vec_add(v1,v2)
    return point(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z)
end

function vec_sub(v1,v2)
    return point(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z)
end

function vec_mul(v,k)
    return point(v.x*k, v.y*k, v.z*k)
end

function vec_div(v,k)
    return point(v.x/k, v.y/k, v.z/k)
end

function mat_pointat(pos,tgt,up)
    --new forward dir
    local newfwd=vec_sub(tgt,pos)
    vec_norm(newfwd)
    
    --new up dir
    local a=vec_mul(newfwd, vec_dot(up,newfwd)) 
    local newup=vec_sub(up,a)
    vec_norm(newup)
    
    local newright={}
    vec_cross(newup, newfwd, newright)

    local out=mat4x4()
    out[1][1]=newright.x; out[1][2]=newright.y; out[1][3]=newright.z; out[1][4]=0
    out[2][1]=newup.x; out[2][2]=newup.y; out[2][3]=newup.z; out[2][4]=0
    out[3][1]=newfwd.x; out[3][2]=newfwd.y; out[3][3]=newfwd.z; out[3][4]=0
    out[4][1]=pos.x; out[4][2]=pos.y; out[4][3]=pos.z; out[4][4]=1
    return out
end

function mat_qinv(m)
    --inverse that works only for a specific rot/trans matrix
    local out=mat4x4()
    out[1][1]=m[1][1]; out[1][2]=m[2][1]; out[1][3]=m[3][1]; out[1][4]=0
    out[2][1]=m[1][2]; out[2][2]=m[2][2]; out[2][3]=m[3][2]; out[2][4]=0
    out[3][1]=m[1][3]; out[3][2]=m[2][3]; out[3][3]=m[3][3]; out[3][4]=0

    out[4][1]= -(m[4][1]*out[1][1] + m[4][2]*out[2][1] + m[4][3]*out[3][1])
    out[4][2]= -(m[4][1]*out[1][2] + m[4][2]*out[2][2] + m[4][3]*out[3][2])
    out[4][3]= -(m[4][1]*out[1][3] + m[4][2]*out[2][3] + m[4][3]*out[3][3])

    out[4][4]=1
    return out
end

function tri_clipplane(pl_p,pl_n,in_tri,clipped)
    vec_norm(pl_n)
    
    --which points are inside the plane?
    local inside,outside={},{}
    
    if shortdist(pl_p,pl_n,in_tri[1])>=0 then ins(inside,in_tri[1])
    else ins(outside,in_tri[1]) end
    if shortdist(pl_p,pl_n,in_tri[2])>=0 then ins(inside,in_tri[2])
    else ins(outside,in_tri[2]) end
    if shortdist(pl_p,pl_n,in_tri[3])>=0 then ins(inside,in_tri[3])
    else ins(outside,in_tri[3]) end
    
    if #inside==0 then
        --everything's outside the plane, so
        --just ignore the whole thing.
        return
    end
    if #inside==3 then
        --everything's inside the plane, so
        --just accept the whole thing.
        --(tri_viewed)
        ins(clipped, in_tri)
        return
    end
    if #inside==1 then
        --clippity clip
        --two points outside, so we get
        --one smaller triangle.
        local out=emptytriangle()
        
        --the inside point is alright.
        --(from tri_viewed which goes to trash anyway)
        out[1]=inside[1]
        
        --two new points are needed
        --in where the orig tri intersects the plane
        out[2]=vec_intersect(pl_p,pl_n,inside[1],outside[1])
        out[3]=vec_intersect(pl_p,pl_n,inside[1],outside[2])
        
        ins(clipped,out)
        out.d=1
        
        return
    end
    if #inside==2 then
        --clippity clip
        --one point outside, so we get
        --a quad of two triangles.
        local out1=emptytriangle()
        local out2=emptytriangle()        
        
        --first new tri:
        --one new point is needed
        --in where the orig tri intersects the plane
        out1[1]=inside[1]
        out1[2]=inside[2]
        out1[3]=vec_intersect(pl_p,pl_n,inside[1],outside[1])
        
        --second new tri:
        --two new points are needed
        --in where the orig tri intersects the plane
        --let's make copies of identical points just in case..
        out2[1]=point(inside[2].x,inside[2].y,inside[2].z)
        out2[2]=point(out1[3].x,out1[3].y,out1[3].z)
        out2[3]=vec_intersect(pl_p,pl_n,inside[2],outside[1])

        ins(clipped,out1)
        ins(clipped,out2)
        out1.d=2
        out2.d=2

        return        
    end
end

function shortdist(pl_p,pl_n,p)
    --i think OLC's reference code has a mistake here?
    local n=point(p.x,p.y,p.z)
    --vec_norm(n)
    return (vec_dot(pl_n,n) - vec_dot(pl_n, pl_p))
end

function vec_intersect(pl_p,pl_n,linestart,lineend)
    --vector intersection with plane.
    --vec_norm(pl_n) --it's already normalised when we come here..
    local pl_d= -vec_dot(pl_n,pl_p)
    local ad= vec_dot(linestart,pl_n)
    local bd= vec_dot(lineend,pl_n)
    local tt= (-pl_d-ad)/(bd-ad)
    local linestarttoend=vec_sub(lineend,linestart)
    local linetointersect=vec_mul(linestarttoend,tt)
    return vec_add(linestart,linetointersect)
end

function tri_area(tr)
    --Heron's formula
    local a=sqrt((tr[2].x-tr[1].x)^2+(tr[2].y-tr[1].y)^2)
    local b=sqrt((tr[3].x-tr[2].x)^2+(tr[3].y-tr[2].y)^2)
    local c=sqrt((tr[3].x-tr[1].x)^2+(tr[3].y-tr[1].y)^2)

    local s=(a+b+c)/2
    
    return math.floor(sqrt(s*(s-a)*(s-b)*(s-c)))
end

matrotZ=mat_rotZ(0)
matrotX=mat_rotX(0)

function lightmap(tr)
    local up=point(0,1,0)
    local target=point(0,0,1)
    local camera3drot=mat_rotY(yaw)
    vec_mat_mult(target,camera3drot,lookdir)
    local matcamera3d=mat_pointat(camera3d,target,up)
    --to view matrix
    matview=mat_qinv(matcamera3d)

    local tri_rotZ=emptytriangle()
    vec_mat_mult(tr[1],matrotZ,tri_rotZ[1])
    vec_mat_mult(tr[2],matrotZ,tri_rotZ[2])
    vec_mat_mult(tr[3],matrotZ,tri_rotZ[3])

    local tri_rotZX=emptytriangle()
    vec_mat_mult(tri_rotZ[1],matrotX,tri_rotZX[1])
    vec_mat_mult(tri_rotZ[2],matrotX,tri_rotZX[2])
    vec_mat_mult(tri_rotZ[3],matrotX,tri_rotZX[3])

    --useful alias to mark we're done with translations
    local triTranslated=tri_rotZX

    --offset points for visibility
    --triTranslated is just the same as tri_rotZX :sweat_smile:
    triTranslated[1].z=tri_rotZX[1].z+2.5
    triTranslated[2].z=tri_rotZX[2].z+2.5
    triTranslated[3].z=tri_rotZX[3].z+2.5
    
    --cross-product -> surface normal
    --assumes clockwise vertex order in triangles.
    local line1,line2={},{}
    line1.x= triTranslated[2].x-triTranslated[1].x
    line1.y= triTranslated[2].y-triTranslated[1].y
    line1.z= triTranslated[2].z-triTranslated[1].z

    line2.x= triTranslated[3].x-triTranslated[1].x
    line2.y= triTranslated[3].y-triTranslated[1].y
    line2.z= triTranslated[3].z-triTranslated[1].z
    
    local normal={}
    vec_cross(line1,line2,normal)
    
    --"it's normally normal to normalise the normal" t.OneLoneCoder
    vec_norm(normal)

    local camera3dray=point(triTranslated[1].x-camera3d.x, triTranslated[1].y-camera3d.y, triTranslated[1].z-camera3d.z)

    --projecting from world space to view space
    local tri_viewed=emptytriangle()
    vec_mat_mult(tri_rotZX[1],matview,tri_viewed[1])
    vec_mat_mult(tri_rotZX[2],matview,tri_viewed[2])
    vec_mat_mult(tri_rotZX[3],matview,tri_viewed[3])

    --let's shade it a bit
    local lightdir=point(1,1,1)
    vec_norm(lightdir)
    --similarity to lightdir
    local dp = vec_dot(normal,lightdir)
    tri_viewed.c=colorize(dp)
    return {0.6-tri_viewed.c*0.4,0.7-tri_viewed.c*0.75,0.7-tri_viewed.c*0.75,1}
end

triangles = {
}

function cube(x,y,z,w,h,d)
    --amazing cube
    local out={
    --south face
    point(x+w,y+h,z,1,1), point(x,y,z,0,0), point(x,y+h,z,1,0),
    point(x+w,y,z,0,1), point(x,y,z,0,0), point(x+w,y+h,z,1,1),

    --east face
    point(x+w,y,z,0,0), point(x+w,y+h,z,1,0), point(x+w,y+h,z+d,1,1),
    point(x+w,y,z,0,0), point(x+w,y+h,z+d,1,1), point(x+w,y,z+d,0,1),

    --north face
    point(x+w,y,z+d,0,0), point(x+w,y+h,z+d,1,0), point(x,y+h,z+d,1,1),
    point(x+w,y,z+d,0,0), point(x,y+h,z+d,1,1), point(x,y,z+d,0,1),

    --west face
    point(x,y+h,z+d,1,0), point(x,y,z+d,0,0), point(x,y+h,z,1,1),
    point(x,y+h,z,1,1), point(x,y,z+d,0,0), point(x,y,z,0,1),

    --top face
    point(x,y+h,z+d,0,1), point(x,y+h,z,0,0), point(x+w,y+h,z+d,1,1),
    point(x+w,y+h,z+d,1,1), point(x,y+h,z,0,0), point(x+w,y+h,z,1,0),

    --bottom face
    point(x,y,z+d,1,1), point(x+w,y,z+d,1,0), point(x,y,z,0,1),
    point(x,y,z,0,1), point(x+w,y,z+d,1,0), point(x+w,y,z,0,0),
    }

    return out
end
function add(c)
    for i,v in ipairs(c) do table.insert(triangles,v) end
end

local c
--main layout
    c=cube(-30,-50*0.5,-180,60*8,50*4.5,60*11)
    add(c)
--shower room    
    c=cube(60+60,-50*0.5,-180,60*3,50*4.5,60*5)
    add(c)
--fridge
    c=cube(60,0,60,60,50*4,60)
    add(c)
--kitchen table
    c=cube(60,50*2.5,60-60-120,60,50*1.5,60*3)
    add(c)
--faucet
    c=cube(-30,50*2.5,60-60-120-60,60*2+30,50*1.5,60)
    add(c)
--closets
    for j=0,3 do
    c=cube(-30+60*8-40,0,60-60-120+60+j*40,40,50*4,40)
    add(c)
    end
--bed
    c=cube(60,50*3,60*8-60-30,60*3.5,50*0.5,60+30)
    add(c)
    c=cube(60,50*3+50*0.5,60*8-60-30,6,50*0.5,6); add(c)
    c=cube(60+60*3.5-6,50*3+50*0.5,60*8-60-30,6,50*0.5,6); add(c)
    c=cube(60,50*3+50*0.5,60*8-6,6,50*0.5,6); add(c)
    c=cube(60+60*3.5-6,50*3+50*0.5,60*8-6,6,50*0.5,6); add(c)
--desktop
    c=cube(-30+60*8-60,50*2.5,60*8-60*2.5-30,60,6,60*2.5)
    add(c)
    c=cube(60*8-30-60,50*2.5+6,60*8-30-6,60,50*2-6-50*0.5,6)
    add(c)
    c=cube(60*8-30-60,50*2.5+6,60*8-60*2.5-30,60,50*2-6-50*0.5,60)
    add(c)
    c=cube(60*8-30-60-6,50*2.5+30,60*8-30-6-30,60,50*2-30-50*0.5,30)
    add(c)
    c=cube(-30+60*8-60+30,50*2.5-50-20+5,60*8-60*2.5,6,50,60+30)
    add(c)
    c=cube(-30+60*8-60+30+6,50*2.5-50+5,60*8-60*2.5+45-15*0.5,6,50-6-5,15)
    add(c)
    c=cube(-30+60*8-60+30+6-10,50*2.5-6,60*8-60*2.5+45-45*0.5,20,6,45)
    add(c)
--shelf
    for j=0,1 do
    c=cube(60+60+30+15+60*j,50,-180+60*5,4,50*3,30)
    add(c)
    end
    for j=0,5-1 do
    c=cube(60+60+30+15+4,50+50*3/5*j,-180+60*5,60-4,4,30)
    add(c)
    end

textures={}
for i=1,#triangles do table.insert(textures,{0,0,1}) end

mesh = love.graphics.newMesh(vertexFormat, triangles, "triangles", 'static')
tex = love.graphics.newMesh(vertexFormat2, textures, 'triangles', 'static')

-- enable pixel shader
mesh:attachAttribute("VertexColor", tex)
    
-- shader with both a vertex and pixel component
local shader_code=[[
#ifdef VERTEX
uniform mat4 proj;
uniform mat4 rotX;
uniform vec4 camera3d;
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    return proj * (vertex_position * rotX + camera3d * rotX);
}
#endif

#ifdef PIXEL
//uniform Image tex2;
uniform Image tex3;
uniform float t;
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor=color;
    if (color.b<0.1) { 
        texturecolor=vec4(0.8,0.8,0.4,1);
    }
    if (color.b>=1.0-0.1) { 
        texture_coords.x=texture_coords.x*2.0;
        while(texture_coords.x>1.0) {
            texture_coords.x=texture_coords.x-1.0;
        }
        texture_coords.y=texture_coords.y*2.0+t*0.2;
        while(texture_coords.y>1.0) {
            texture_coords.y=texture_coords.y-1.0;
        }
        texturecolor = Texel(tex3, texture_coords); 
    }
    return texturecolor;
}
#endif
]]
threed_shader=love.graphics.newShader(shader_code)

local status, message = love.graphics.validateShader(true, shader_code)

if status then loveprint(string.format('Shader is valid: %s',status))
else loveprint(string.format('Shader has problem: %s',message)) end

function threed(dt)
    t=t or 0
    local fwd=vec_mul(lookdir,0.25*dt*60*4)
    --loveprint(lookdir[1],lookdir[2],lookdir[3])
    local yawchange=0
    local turnchange=0
    if t==0 then turn=math.pi; turnchange=math.pi end
    if press('up') or press('w')  then camera3d=vec_add(camera3d,point(-sin(turn)*0.25*dt*60*4,0,-cos(turn)*0.25*dt*60*4))
        --if mesh_coll() then camera3d=vec_add(camera3d,vec_mul(fwd,0.9)) end
    elseif press('down') or press('s') then camera3d=vec_sub(camera3d,point(-sin(turn)*0.25*dt*60*4,0,-cos(turn)*0.25*dt*60*4))
        --if mesh_coll() then camera3d=vec_sub(camera3d,vec_mul(fwd,0.9)) end
    end
    --if press('a') then yaw=yaw+0.25; yawchange=0.25 end
    --if press('d') then yaw=yaw-0.25; yawchange=-0.25 end
    if press('left') or press('a') then turn=turn-0.08*dt*60; turnchange=-0.08*dt*60 
    elseif press('right') or press('d') then turn=turn+0.08*dt*60; turnchange=0.08*dt*60 end
    if press('e') then camera3d=vec_add(camera3d,point(0,0.2*dt*60*4,0)) 
        --if mesh_coll() then camera3d=vec_sub(camera3d,point(0,0.2*dt*60,0)) end
    elseif press('q') then camera3d=vec_sub(camera3d,point(0,0.2*dt*60*4,0)) 
        --if mesh_coll() then camera3d=vec_add(camera3d,point(0,0.2*dt*60,0)) end
    end

    --local a=t*1.5 / 180*pi
    --rotation matrices
        --matrotZ=mat_rotZ(a)
      
        --matrotX=mat_rotX(a*0.5)
        matrotX=mat_rotY(turn)
        if turnchange~=0 then
            local matrotDX=mat_rotY(-turnchange)
            local lookdir2=point(0,0,0)
            vec_mat_mult(lookdir,matrotDX,lookdir2)
            lookdir=lookdir2
        end

    --creating a point-at matrix for camera3d
    if yawchange~=0 then
        local up=point(0,1,0)
        local target=point(0,0,1)
        local camera3drot=mat_rotY(yaw)
        local lookdir2=point(0,0,0)
        vec_mat_mult(target,camera3drot,lookdir2)
        camera3d=vec_add(camera3d,point(yawchange,0,0))
        local matcamera3d=mat_pointat(camera3d,target,up)
        --to view matrix
        matview=mat_qinv(matcamera3d)
    end

    -- interaction with 3D objects
    mouse_point()
end

function mouse_point()
    for i=1,#textures do textures[i]={0,0,1} end
    tex = love.graphics.newMesh(vertexFormat2, textures, 'triangles', 'static')
    mesh:attachAttribute("VertexColor", tex)

    local mx,my=love.mouse.getPosition()

    local vcl={x=sin(turn),y=0,z=cos(turn)}
    local view=170+20+20
    local vcc={x=-camera3d.x-(mx/sw*view-view/2)*(sin(turn-math.pi/2)),y=-camera3d.y+(my/sh*view-view/2),z=-camera3d.z-(mx/sw*view-view/2)*(cos(turn-math.pi/2))}
    --loveprint(vcc.x,vcc.y,vcc.z)
    for i=0,120 do
        vcc.x=vcc.x+vcl.x
        vcc.y=vcc.y+vcl.y
        vcc.z=vcc.z+vcl.z
        for i=1,#triangles,6*6 do
            local minx,miny,minz={},{},{}
            local maxx,maxy,maxz={},{},{}
            for j=0,6*6-1 do
                table.insert(minx,triangles[i+j].x)
                table.insert(miny,triangles[i+j].y)
                table.insert(minz,triangles[i+j].z)
                table.insert(maxx,triangles[i+j].x)
                table.insert(maxy,triangles[i+j].y)
                table.insert(maxz,triangles[i+j].z)
            end
            local minx2=math.min(unpack(minx))
            local miny2=math.min(unpack(miny))
            local minz2=math.min(unpack(minz))
            local maxx2=math.max(unpack(maxx))
            local maxy2=math.max(unpack(maxy))
            local maxz2=math.max(unpack(maxz))
            --loveprint(vcc.x,minx2,maxx2)
            if i~=1 and i~=1+6*6 and
               vcc.x>minx2 and vcc.x<maxx2 and
               vcc.y>miny2 and vcc.y<maxy2 and
               vcc.z>minz2 and vcc.z<maxz2 then
                --loveprint(string.format('%d,%d,%d,%d',vcc.x,vcc.y,vcc.z,(i-1)/(6*6)))
                for k=0,6*6-1 do
                    textures[i+k]={0,0,0}
                end
                tex = love.graphics.newMesh(vertexFormat2, textures, 'triangles', 'static')
                mesh:attachAttribute("VertexColor", tex)
                return
            end
        end
    end
end

threed(0) -- to initialize matrix rotations