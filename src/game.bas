#define DECK_BEGIN $7800
#define BG_PAL_START $7BFF
#define BG_MAIN_START $10000
#define SPRITE_START $30000
REM "Setup Variables and Start Loop"
cls:cursorCol=0:cursorRow=6:isRunning=1:tevent=0:spscreen=1
debugmode=false:cursorVal=0:cardsleft=0:discardptr=0:discardval=0
REM "This structure holds the card field and their x,y positions"
dim tableau(7,5):dim tableaux(7,5):dim tableauy(7,5)
printcenter("Loading backgrounds!", 0)
cls:gameloop()
end
proc initboard()
    for x=1 to 52:?(DECK_BEGIN+x)=x:next
    bload "background.pal", BG_PAL_START
    loadpal($7BFF, 1)
    bload "background.bin", BG_MAIN_START
    bitmap on:bitmaplut(0,1)
    cls: printcenter("Loading Sprites!", 0)
    bload "sprites.bin", SPRITE_START
    sprites on
endproc
proc checkforlose()
    spscreen=1
    if discardptr = 52
        sprites off
        text "You Lose!" dim 2 color 1 to 100,100
        text "Press FIRE or SPACE!" dim 1 color 1 to 90,120
        repeat
            keypress=inkey()
            if (keypress=32)|(joyb(0)&1) then spscreen=0
        until spscreen=0
        cursorCol=0:cursorRow=6
        cls:gameloop()
    endif
endproc
proc checkforwin()
    spscreen=1
    if cardsleft = 0
        sprites on
        text "You Won!" dim 2 color 1 to 100,100
        text "Press FIRE to try again" dim 1 color 1 to 70,120
        repeat
            for x = 0 to 51
                sprite x image x to random(320),random(240)
            next
            if (joyb(0)&1)
                spscreen=0
            endif
        until spscreen = 0
        cursorCol=0:cursorRow=6
        cls:gameloop()
    endif
endproc
proc getcursorval()
    card = tableau(cursorRow,cursorCol)+1
    while card > 13
        card = card - 13
    wend
    cursorVal = card
endproc
proc getdiscardval()
    disc = ?(DECK_BEGIN+discardptr)+1
    while disc > 13
        disc = disc - 13
    wend
    discardval = disc
endproc
proc renderboard()
    spritecounter = 35
    cardx = 32
    cardy = 24
    leftdigit = int(cardsleft / 10)
    rightdigit = cardsleft % 10
    for r=0 to 6
	    cardx = 90
        for c=0 to 4
	        cardno = tableau(r,c)
            tableaux(r,c)=cardx
            tableauy(r,c)=cardy
            if cardno < 255
	            sprite spritecounter image cardno to cardx,cardy
            else
                sprite spritecounter off
            endif
	        cardx = cardx + 36
	        spritecounter = spritecounter  - 1
	    next
	    cardy = cardy + 24
    next
    sprite 52 image 52 to 92, 208
    sprite 54 image 54 + leftdigit to 23,32
    sprite 55 image 54 + rightdigit to 44,32
endproc
proc shuffledeck()
    cls
    printcenter("Shuffling!",0)
    swapidx=0:swapval=0
    for x=0 to 51
        swapidx=random(50)+1
        swapval=?(DECK_BEGIN+swapidx)
        ?(DECK_BEGIN+swapidx)=?(DECK_BEGIN)
        ?(DECK_BEGIN)=swapval
        swapidx=random(50)+1
        swapval=?(DECK_BEGIN+swapidx)
        ?(DECK_BEGIN+swapidx)=?(DECK_BEGIN+51)
        ?(DECK_BEGIN+51)=swapval
    next
    cls
endproc
proc dealtoboard()
    index=0
    for r=0 to 6
        for c=0 to 4
	    tableau(r,c)=?(DECK_BEGIN+index)
	    index=index+1
	next
    next
    cardsleft=index
    discardptr=35
endproc
proc update()
endproc
proc bitmaplut(bitmapno,lutno)
    if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
        add$="53504,53512,53520"
        value=val(itemget$(add$,bitmapno+1,","))
        current=?(value)
        poke value,(1|1<<lutno)
    else
        print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
    endif
endproc
proc loadpal(addr,lutno)
    lutaddr=$D000+(lutno*$400)
    poke 1,1
    for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
endproc
proc printcenter(msg$, yoffset)
    xoffset=len(msg$)\2
    print at 30+yoffset,(40-xoffset)msg$
endproc
proc setup()
    initboard()
    shuffledeck()
    dealtoboard()
    sprite 0 image 53
    renderboard()
    getdiscardval()
endproc
proc printdebugstuff()
    print at 0,0 "";
    print "col: "+str$(cursorCol)+" "
    print "row: "+str$(cursorRow)+" "
    print "val: "+str$(cursorVal)+" "
    print "lef: "+str$(cardsleft)+" "
    print "dis: "+str$(discardptr)+" "
    print "dsv: "+str$(discardval)+" "
endproc
proc moveleft()
    col = cursorCol
    row = 6
    while col > 0
        col = col - 1
        row = 6
        while row >= 0
            if tableau(row, col) < 255
                cursorCol = col
                cursorRow = row
                row = -1
                col = 0
            endif
            row = row - 1
        wend
    wend
    getcursorval()
endproc
proc moveright()
    found = 0
    for x=(cursorCol+1) to 4
        row = 6
        if found = 0
            while row >= 0
                if tableau(row,x) < 255
                    cursorCol=x
                    cursorRow=row
                    row = -1
                    found = 1
                else
                    row = row - 1
                endif
            wend
        endif
    next
    getcursorval()
endproc
proc updatecursorpos()
    sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
endproc
proc updateinput()
    local keypress
    keypress=inkey()
    if (keypress=2)|(joyx(0)=-1)
        if cursorCol > 0
            moveleft()
            updatecursorpos()
        endif
    endif
    if (keypress=6)|(joyx(0)=1)
        if cursorCol < 4
            moveright()
            updatecursorpos()
        endif
    endif
    if (keypress=32)|(joyb(0)&1)
        if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
            sprite 53 image tableau(cursorRow, cursorCol)
            discardval=cursorVal
            tableau(cursorRow, cursorCol) = 255
            cardsleft = cardsleft - 1
            if cursorRow > 0
                cursorRow = cursorRow - 1
                getcursorval()
                updatecursorpos()
            endif
            renderboard()
        endif
    endif
    if (keypress=100)|(joyy(0)=-1)
        if discardptr < 52
            discardptr = discardptr + 1
            sprite 53 image ?(DECK_BEGIN+discardptr) to 126, 206
            getdiscardval()
            renderboard()
        endif
    endif
endproc
proc gameloop()
    frames=0
    setup()
    updatecursorpos()
    getcursorval()
    sprite 53 image ?(DECK_BEGIN+discardptr) to 126, 206
    repeat
        checkforlose()
        checkforwin()
        if event(tevent, 10)
            updateinput()
            if debugmode=true
                printdebugstuff()
            endif
            frames = frames + 1
        endif
    until isRunning=0
endproc
