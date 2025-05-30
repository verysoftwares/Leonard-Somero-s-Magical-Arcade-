phrases={
    ['computer']={{'It\'s a Windows 2024 computer with 999 GB of RAM.','Windows 2024',60*4+30}},
    ['faucet']={{'It\'s just free money coming out of my faucet.','free money',60*3}},
    ['fridge']={{'Multiplayer fridge, up to 4 players.','multiplayer fridge',60*3}},
    ['closet']={{'The closets are full but there\'s nothing in them.','closets are full',60*2+30}},
    ['bed']={{'The bed is very, uh, long.','uhh long',60*3}},
    ['screen']={{'Guaranteed to show at least 10 pixels.','10 pixels',60*2+30}},
    ['kitchentable']={{'If I had any food, this is where I\'d prepare it.','any food',60*3+30}},
    -- from a pool of 4 artists per shelf, pick 3 in random order
    -- for the shelves
    -- {'Venetian Snares','The Flashbulb','Nero\'s Day at Disneyland','Milkyheart'},
    -- {'Vibrasphere','Astral Projection','The Infinity Project','Virtual Symmetry'},
    -- {'The Future Sound of London','early Aphex Twin','Gas (Mat Jarvis)','Gas (Wolfgang Voigt)'},
    ['shelffloor0']={{'This shelf houses the printer/scanner.','printer slash scanner',60*3}},
    ['shelffloor1']={shelf1='This shelf houses',shelf2={'The Future Sound of London','early Aphex Twin','Gas (Mat Jarvis)','Gas (Wolfgang Voigt)'},shelf3='type of music.'},
    ['shelffloor2']={shelf1='This shelf houses',shelf2={'Vibrasphere','Astral Projection','The Infinity Project','Virtual Symmetry'},shelf3='type of music.'},
    ['shelffloor3']={shelf1='This shelf houses',shelf2={'Venetian Snares','The Flashbulb','Nero\'s Day at Disneyland','Milkyheart'},shelf3='type of music.'},
    ['shelffloor4']={{'This shelf houses classical music, so anything non-electronic released before 1985.','classical music',60*5+30}},
    ['shelfside']={{'It wouldn\'t be much of a shelf without this.','much of a shelf',60*2+30}},
    ['']={{''}},

    ['desktop']={{'It\'s a Lua table that\'s somehow popped into existence. You see, a common critique of Lua is that \'arrays begin at 1\'. However, what this critique fails to address is that in Lua tables, there\'s no memory pointer arithmetic, so it just makes more intuitive sense to write loops that run from 1 to n rather than 0 to n-1. Besides, the 1-indexing is only for the default iterator \'ipairs\', you can write your own if you really like to begin from 0 (such as when doing modular arithmetic).','Lua table',60*27+30}},
    ['']={{''}},
    -- Segue: Maitreya timer appears, and Leonard communicates with him.

    ['door']={{'How would I know how to open that, I am just a brain in a fish tank.','fish tank',60*3+30}},
    ['certificate']={{'It\'s the document certifying that your game company is a legal entity in Finland!','legal entity',60*4},{'It\'s the document certifying that your game company is a legal entity in Finland!','fanfare',60*4},{'If it wasn\'t documented, then it wouldn\'t be documented.','wouldn\'t be documented',60*3}},
}

bigass_script_table={
    ['Slick Slices']={
        ['Leonard']={
            ['intro']={{'It seems to crave a Z press.','crave Z',60*3.5}},
            ['introfail']={{'Uhh that\'s not exactly Z, but nice try.'}},
            ['intro2']={{'Now it is hungry for more.','hungry Z',60*3.5}},
            ['perfect']={{'The pieces matched perfectly!'},{'I am the king of Z presses.'}},
            ['imperfect']={{'Okay, the pieces were a little misaligned.'},{'Now it gave me a shorter piece.'}},
            ['imperfect2']={{'So the pieces keep getting shorter as I go.'}},
            ['bigimperfect']={{'Whoops, I mispressed.'}},
            ['gameover']={{'And now I don\'t have a piece at all.'},{'Just look at that score...'},{'I think I can do better next time, so I\'ll just press R to retry.'}},
            ['pressRlate']={{'I\'m just gonna press R any moment now.'}}
        },
    },
}

cur_script=bigass_script_table['Slick Slices']['Leonard']
function start_script(id)
    local diag=cur_script[id]
    if diag.seen then return end
    sections={}
    for i,v in ipairs(diag) do
        table.insert(sections,create_section(v[1],v[2],v[3],v[4],v[5]))
    end
    cur_section_i=1; cur_section=sections[cur_section_i]
    diag.seen=true
end