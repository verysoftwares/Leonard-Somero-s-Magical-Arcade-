-- 1: title screen
-- 5: Slick Slices

demomode=1

function switch_demomode(n)
    if n==1 then musa=love.audio.newSource('wares/Lennu levitates.ogg','stream'); musa:setLooping(true); musa:play() end
    if demomode==1 and not (n==1) then if musa then musa:stop() end end

    if n==5 then start_game('Slick Slices') end

    demomode=n
end

switch_demomode(5)