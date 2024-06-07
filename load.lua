function love.load()
    lg.setDefaultFilter('nearest')
    verysoft_font=love.graphics.newFont('wares/monofonto rg.otf',64)
    verysoft_font2=love.graphics.newFont('wares/monofonto rg.otf',24-2)
    handwrite_font=love.graphics.newFont('wares/Bubbly-Regular.otf',18)
    -- wait what, it doesn't have numbers?
    handwrite_font2=love.graphics.newFont('wares/Bubbly-Regular.otf',18*4)
    info_font=love.graphics.newFont('wares/Info Story.otf')
    info_font2=love.graphics.newFont('wares/Info Story.otf',18*4)
    --slick_load()
    images={}
    images.diskette=love.graphics.newImage('wares/diskette.png')
    images.diskette2=love.graphics.newImage('wares/diskette2.png')
    images.diskette3=love.graphics.newImage('wares/diskette3.png')
    images.catpaw=love.graphics.newImage('wares/catpaw.png')
    images.he_thincc=lg.newImage('wares/he_thincc.png')
    images.he_talcc=lg.newImage('wares/he_talcc.png')
    fonts={}
    fonts.main2=lg.newFont('wares/FreePixel.ttf',16*2)
    
    audio={}
    audio.song1=love.audio.newSource('wares/vsa-music.ogg','stream')
    audio.song1:setLooping(true)
    audio.song2=love.audio.newSource('wares/vsa-music2.ogg','stream')
    audio.song2:setLooping(true)
    --audio.song1:play()
    cur_audio=audio.song1
    test_tex=love.graphics.newImage('wares/test_tex.png')
    test_tex2=love.graphics.newImage('wares/test_tex2.png')
    test_tex3=love.graphics.newImage('wares/test_tex3.png')
    test_tex4=love.graphics.newImage('wares/test_tex4.png')

    cube_tex={}
    for i=1,7 do table.insert(cube_tex,love.graphics.newImage(string.format('wares/cubetex_%d.png',i))) end
    --setup_game('Slick Slices')
    --setup_game('Batch-3')
    --setup_game('Apoplex')
    --love.draw=game_draw
    --love.update=game_update
end
