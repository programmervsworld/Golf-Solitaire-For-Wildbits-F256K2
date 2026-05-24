1000 REM "Setup Variables and Start Loop"
1010 cls:cursorCol=0:cursorRow=6:isRunning=1:tevent=0
1020 debugmode=true:cursorVal=0:cardsleft=0:discardptr=0:discardval=0
1030 REM "This structure holds the card field and their x,y positions"
1040 dim tableau(7,5):dim tableaux(7,5):dim tableauy(7,5)
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
1160 for x=1 to 52:?($7800+x)=x:next
1170 endproc
1180 proc getcursorval()
1190 card = tableau(cursorRow,cursorCol)+1
1200 while card > 13
1210 card = card - 13
1220 wend
1230 cursorVal = card
1240 endproc
1250 proc getdiscardval()
1260 disc = ?($7800+discardptr)+1
1270 while disc > 13
1280 disc = disc - 13
1290 wend
1300 discardval = disc
1310 endproc
1320 proc renderboard()
1330 spritecounter = 35
1340 cardx = 32
1350 cardy = 24
1360 for r=0 to 6
1370 cardx = 90
1380 for c=0 to 4
1390 cardno = tableau(r,c)
1400 tableaux(r,c)=cardx
1410 tableauy(r,c)=cardy
1420 if cardno < 255
1430 sprite spritecounter image cardno to cardx,cardy
1440 else
1450 sprite spritecounter off
1460 endif
1470 cardx = cardx + 36
1480 spritecounter = spritecounter  - 1
1490 next
1500 cardy = cardy + 24
1510 next
1520 sprite 52 image 52 to 94, 208
1530 endproc
1540 proc shuffledeck()
1550 cls
1560 printcenter("Shuffling!",0)
1570 swapidx=0:swapval=0
1580 for x=0 to 51
1590 swapidx=random(50)+1
1600 swapval=?($7800+swapidx)
1610 ?($7800+swapidx)=?($7800)
1620 ?($7800)=swapval
1630 swapidx=random(50)+1
1640 swapval=?($7800+swapidx)
1650 ?($7800+swapidx)=?($7800+51)
1660 ?($7800+51)=swapval
1670 next
1680 cls
1690 endproc
1700 proc dealtoboard()
1710 index=0
1720 for r=0 to 6
1730 for c=0 to 4
1740 tableau(r,c)=?($7800+index)
1750 index=index+1
1760 next
1770 next
1780 cardsleft=index
1790 discardptr=35
1800 endproc
1810 proc update()
1820 endproc
1830 proc bitmaplut(bitmapno,lutno)
1840 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1850 add$="53504,53512,53520"
1860 value=val(itemget$(add$,bitmapno+1,","))
1870 current=?(value)
1880 poke value,(1|1<<lutno)
1890 else
1900 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1910 endif
1920 endproc
1930 proc loadpal(addr,lutno)
1940 lutaddr=$D000+(lutno*$400)
1950 poke 1,1
1960 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1970 endproc
1980 proc printcenter(msg$, yoffset)
1990 xoffset=len(msg$)\2
2000 print at 30+yoffset,(40-xoffset)msg$
2010 endproc
2020 proc setup()
2030 initboard()
2040 shuffledeck()
2050 dealtoboard()
2060 sprite 0 image 54
2070 renderboard()
2080 getdiscardval()
2090 endproc
2100 proc printdebugstuff()
2110 print at 0,0 "";
2120 print "col: "+str$(cursorCol)+" "
2130 print "row: "+str$(cursorRow)+" "
2140 print "val: "+str$(cursorVal)+" "
2150 print "lef: "+str$(cardsleft)+" "
2160 print "dis: "+str$(discardptr)+" "
2170 print "dsv: "+str$(discardval)+" "
2180 endproc
2190 proc moveleft()
2200 col = cursorCol
2210 row = 6
2220 while col > 0
2230 col = col - 1
2240 row = 6
2250 while row >= 0
2260 if tableau(row, col) < 255
2270 cursorCol = col
2280 cursorRow = row
2290 row = -1
2300 col = 0
2310 endif
2320 row = row - 1
2330 wend
2340 wend
2350 getcursorval()
2360 endproc
2370 proc moveright()
2380 found = 0
2390 for x=(cursorCol+1) to 4
2400 row = 6
2410 if found = 0
2420 while row >= 0
2430 if tableau(row,x) < 255
2440 cursorCol=x
2450 cursorRow=row
2460 row = -1
2470 found = 1
2480 else
2490 row = row - 1
2500 endif
2510 wend
2520 endif
2530 next
2540 getcursorval()
2550 endproc
2560 proc updatecursorpos()
2570 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2580 endproc
2590 proc updateinput()
2600 local keypress
2610 keypress=inkey()
2620 if (keypress=2)|(joyx(0)=-1)
2630 if cursorCol > 0
2640 moveleft()
2650 updatecursorpos()
2660 endif
2670 endif
2680 if (keypress=6)|(joyx(0)=1)
2690 if cursorCol < 4
2700 moveright()
2710 updatecursorpos()
2720 endif
2730 endif
2740 if (keypress=100)
2750 if discardptr < 52
2760 discardptr = discardptr + 1
2770 sprite 53 image ?($7800+discardptr) to 125, 206
2780 getdiscardval()
2790 renderboard()
2800 endif
2810 endif
2820 if (keypress=32)|(joyb(0)&1)
2830 if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
2840 sprite 53 image tableau(cursorRow, cursorCol)
2850 discardval=cursorVal
2860 tableau(cursorRow, cursorCol) = 255
2870 if cursorRow > 0
2880 cursorRow = cursorRow - 1
2890 getcursorval()
2900 updatecursorpos()
2910 endif
2920 print "Press!"
2930 renderboard()
2940 endif
2950 endif
2960 endproc
2970 proc gameloop()
2980 setup()
2990 updatecursorpos()
3000 getcursorval()
3010 sprite 53 image ?($7800+discardptr) to 125, 206
3020 repeat
3030 if event(tevent, 5)
3040 updateinput()
3050 if debugmode=true
3060 printdebugstuff()
3070 endif
3080 endif
3090 until isRunning=0
3100 endproc
ÿÿÿÿ
