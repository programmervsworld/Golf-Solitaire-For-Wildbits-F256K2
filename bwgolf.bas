1000 cls
1010 deck=$7800
1020 cursolCol=0:cursorRow=6:isRunning=1:tevent=0
1030 debugmode=true
1040 dim tableau(7,5):dim tableaux(7,5):dim tableauy(7,5):cardsleft=0
1050 printcenter("Loading backgrounds!", 0)
1060 bload "background.pal", $7BFF
1070 loadpal($7BFF, 1)
1080 bload "background.bin", $10000
1090 bitmap on:bitmaplut(0,1)
1100 cls: printcenter("Loading Sprites!", 0)
1110 bload "sprites.bin", $30000
1120 sprites on
1130 cls:gameloop()
1140 end
1150 proc initboard()
1160 for x=1 to 52:?(deck+x)=x:next
1170 endproc
1180 proc renderboard()
1190 spritecounter = 35
1200 cardx = 32
1210 cardy = 24
1220 for r=0 to 6
1230 cardx = 90
1240 for c=0 to 4
1250 cardno = tableau(r,c)
1260 tableaux(r,c)=cardx
1270 tableauy(r,c)=cardy
1280 sprite spritecounter image cardno to cardx,cardy
1290 cardx = cardx + 33
1300 spritecounter = spritecounter  - 1
1310 next
1320 cardy = cardy + 24
1330 next
1340 sprite 52 image 52 to 90, 208
1350 sprite 53 image 53 to 132, 210
1360 endproc
1370 proc shuffledeck()
1380 cls
1390 printcenter("Shuffling!",0)
1400 swapidx=0:swapval=0
1410 for x=0 to 51
1420 swapidx=random(50)+1
1430 swapval=?(deck+swapidx)
1440 ?(deck+swapidx)=?(deck)
1450 ?(deck)=swapval
1460 swapidx=random(50)+1
1470 swapval=?(deck+swapidx)
1480 ?(deck+swapidx)=?(deck+51)
1490 ?(deck+51)=swapval
1500 next
1510 cls
1520 endproc
1530 proc dealtoboard()
1540 index=0
1550 for r=0 to 7
1560 for c=0 to 5
1570 tableau(r,c)=?(deck+index)
1580 index=index+1
1590 next
1600 next
1610 cardsleft=index
1620 endproc
1630 proc update()
1640 endproc
1650 proc bitmaplut(bitmapno,lutno)
1660 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1670 add$="53504,53512,53520"
1680 value=val(itemget$(add$,bitmapno+1,","))
1690 current=?(value)
1700 poke value,(1|1<<lutno)
1710 else
1720 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1730 endif
1740 endproc
1750 proc loadpal(addr,lutno)
1760 lutaddr=$D000+(lutno*$400)
1770 poke 1,1
1780 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1790 endproc
1800 proc printcenter(msg$, yoffset)
1810 xoffset=len(msg$)\2
1820 print at 30+yoffset,(40-xoffset)msg$
1830 endproc
1840 proc setup()
1850 initboard()
1860 shuffledeck()
1870 dealtoboard()
1880 sprite 0 image 54
1890 renderboard()
1900 endproc
1910 proc printdebugstuff()
1920 print at 0,0 "";
1930 print "col: "+str$(cursorCol)+" "
1940 print "row: "+str$(cursorRow)+" "
1950 endproc
1960 proc updatecursorpos()
1970 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
1980 endproc
1990 proc updateinput()
2000 local keypress
2010 keypress=inkey()
2020 if (keypress=2)|(joyx(0)=-1)
2030 if cursorCol > 0
2040 cursorCol=cursorCol-1
2050 updatecursorpos()
2060 endif
2070 endif
2080 if (keypress=6)|(joyx(0)=1)
2090 if cursorCol < 4
2100 cursorCol=cursorCol+1
2110 updatecursorpos()
2120 endif
2130 endif
2140 endproc
2150 proc gameloop()
2160 setup()
2170 updatecursorpos()
2180 repeat
2190 if event(tevent, 5)
2200 updateinput()
2210 if debugmode=true
2220 printdebugstuff()
2230 endif
2240 endif
2250 until isRunning=0
2260 endproc
ÿÿÿÿ
