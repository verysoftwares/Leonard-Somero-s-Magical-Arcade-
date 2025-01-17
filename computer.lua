game={
}

function start_game(id)
    game.id=id
    if id=='Slick Slices' then
        game.canvas=lg.newCanvas(12*26*2,12*21*2)
        game.update=slick_update
        game.draw=slick_draw
        slick_load()
    end
end

start_game('Slick Slices')