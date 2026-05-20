cls
deck=$7800
dim tableau(7,5):cardsleft=0
bitmap on
bitmap clear 10
sprites on
bload "sprites.bin", $30000
gameloop()
end
proc initboard()
    for x=1 to 52:?(deck+x)=x:next
endproc
proc renderboard()
    spritecounter = 35 
    cardx = 32
    cardy = 24 
    for r=0 to 6 
	cardx = 90 
        for c=0 to 4
	    cardno = tableau(r,c)
	    sprite spritecounter image cardno to cardx,cardy
	    cardx = cardx + 32
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
    renderboard()
endproc
proc gameloop()
    setup()
endproc
