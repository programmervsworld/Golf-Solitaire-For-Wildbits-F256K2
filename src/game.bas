cls
deck=$7800
cursolCol=0:cursorRow=6:isRunning=1:tevent=0
debugmode=true
dim tableau(7,5):dim tableaux(7,5):dim tableauy(7,5):cardsleft=0
printcenter("Loading backgrounds!", 0)
bload "background.pal", $7BFF
loadpal($7BFF, 1)
bload "background.bin", $10000
bitmap on:bitmaplut(0,1)
cls: printcenter("Loading Sprites!", 0)
bload "sprites.bin", $30000
sprites on
cls:gameloop()
end
proc initboard()
    for x=1 to 52:?(deck+x)=x:next
endproc
proc renderboard()
    spritecounter = 35
    cardx = 32
    cardy = 24
    for r=0 to 6
	    cardx = 92
        for c=0 to 4
	        cardno = tableau(r,c)
            tableaux(r,c)=cardx
            tableauy(r,c)=cardy
	        sprite spritecounter image cardno to cardx,cardy
	        cardx = cardx + 33
	        spritecounter = spritecounter  - 1
	    next
	    cardy = cardy + 24
    next
    sprite 52 image 52 to 90, 208
    sprite 53 image 53 to 132, 210
endproc
proc shuffledeck()
    cls
    printcenter("Shuffling!",0)
    swapidx=0:swapval=0
    for x=0 to 51
        swapidx=random(50)+1
        swapval=?(deck+swapidx)
        ?(deck+swapidx)=?(deck)
        ?(deck)=swapval
        swapidx=random(50)+1
        swapval=?(deck+swapidx)
        ?(deck+swapidx)=?(deck+51)
        ?(deck+51)=swapval
    next
    cls
endproc
proc dealtoboard()
    index=0
    for r=0 to 7
        for c=0 to 5
	    tableau(r,c)=?(deck+index)
	    index=index+1
	next
    next
    cardsleft=index
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
    sprite 0 image 54
    renderboard()
endproc
proc printdebugstuff()
    print at 0,0 "";
    print "col: "+str$(cursorCol)+" "
    print "row: "+str$(cursorRow)+" "
endproc
proc moveleft()
    col = cursorCol
    row = 6
    while col > 0
        col = col - 1
        row = 6
        while row > 0
            if tableau(row, col) > 0
                cursorCol = col
                cursorRow = row
                row = 0
                col = 0
            endif
            row = row - 1
        wend
    wend
endproc
proc moveright()
    found = 0
    for x=(cursorCol+1) to 4
        row = 6
        if found = 0
            while row > 0
                if tableau(row,x) > 0
                    cursorCol=x
                    cursorRow=row
                    row = 0
                    found = 1
                else
                    row = row - 1
                endif
            wend
        endif
    next
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
endproc
proc gameloop()
    setup()
    updatecursorpos()
    repeat
        if event(tevent, 5)
            updateinput()
            if debugmode=true
                printdebugstuff()
            endif
        endif
    until isRunning=0
endproc
