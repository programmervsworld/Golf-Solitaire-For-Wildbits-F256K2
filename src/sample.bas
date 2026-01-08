cls 
bload "<yourbackgroundlut>.pal",$7BFF
loadpal($7BFF,1)
bload "<yourbackground>.bin",$10000
bitmap on :bitmaplut(0,1)
end 
proc setup()
    bitmaplut(0,1)
endproc 
proc gameloop()
    tevent=0
    repeat 
        if event(tevent,2) then update()
    until false 
endproc 
proc update()
    print at 60\2,80\2-2 random(255)
    rect solid 140,100 color random(255) to 200,140
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
