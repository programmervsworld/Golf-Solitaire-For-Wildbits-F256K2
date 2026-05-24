1000 REM "Setup Variables and Start Loop"
1010 cls:cursorCol=0:cursorRow=6:isRunning=1:tevent=0
1020 debugmode=true:cursorVal=0:cardsleft=0:discardptr=0
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
1250 proc renderboard()
1260 spritecounter = 35
1270 cardx = 32
1280 cardy = 24
1290 for r=0 to 6
1300 cardx = 92
1310 for c=0 to 4
1320 cardno = tableau(r,c)
1330 tableaux(r,c)=cardx
1340 tableauy(r,c)=cardy
1350 if cardno < 255
1360 sprite spritecounter image cardno to cardx,cardy
1370 else
1380 sprite spritecounter off
1390 endif
1400 cardx = cardx + 33
1410 spritecounter = spritecounter  - 1
1420 next
1430 cardy = cardy + 24
1440 next
1450 sprite 52 image 52 to 94, 208
1460 sprite 53 image ?($7800+discardptr) to 125, 206
1470 endproc
1480 proc shuffledeck()
1490 cls
1500 printcenter("Shuffling!",0)
1510 swapidx=0:swapval=0
1520 for x=0 to 51
1530 swapidx=random(50)+1
1540 swapval=?($7800+swapidx)
1550 ?($7800+swapidx)=?($7800)
1560 ?($7800)=swapval
1570 swapidx=random(50)+1
1580 swapval=?($7800+swapidx)
1590 ?($7800+swapidx)=?($7800+51)
1600 ?($7800+51)=swapval
1610 next
1620 cls
1630 endproc
1640 proc dealtoboard()
1650 index=0
1660 for r=0 to 6
1670 for c=0 to 4
1680 tableau(r,c)=?($7800+index)
1690 index=index+1
1700 next
1710 next
1720 cardsleft=index
1730 discardptr=35
1740 endproc
1750 proc update()
1760 endproc
1770 proc bitmaplut(bitmapno,lutno)
1780 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1790 add$="53504,53512,53520"
1800 value=val(itemget$(add$,bitmapno+1,","))
1810 current=?(value)
1820 poke value,(1|1<<lutno)
1830 else
1840 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1850 endif
1860 endproc
1870 proc loadpal(addr,lutno)
1880 lutaddr=$D000+(lutno*$400)
1890 poke 1,1
1900 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1910 endproc
1920 proc printcenter(msg$, yoffset)
1930 xoffset=len(msg$)\2
1940 print at 30+yoffset,(40-xoffset)msg$
1950 endproc
1960 proc setup()
1970 initboard()
1980 shuffledeck()
1990 dealtoboard()
2000 sprite 0 image 54
2010 renderboard()
2020 endproc
2030 proc printdebugstuff()
2040 print at 0,0 "";
2050 print "col: "+str$(cursorCol)+" "
2060 print "row: "+str$(cursorRow)+" "
2070 print "val: "+str$(cursorVal)+" "
2080 print "lef: "+str$(cardsleft)+" "
2090 print "dis: "+str$(discardptr)+" "
2100 endproc
2110 proc moveleft()
2120 col = cursorCol
2130 row = 6
2140 while col > 0
2150 col = col - 1
2160 row = 6
2170 while row >= 0
2180 if tableau(row, col) < 255
2190 cursorCol = col
2200 cursorRow = row
2210 row = -1
2220 col = 0
2230 endif
2240 row = row - 1
2250 wend
2260 wend
2270 getcursorval()
2280 endproc
2290 proc moveright()
2300 found = 0
2310 for x=(cursorCol+1) to 4
2320 row = 6
2330 if found = 0
2340 while row >= 0
2350 if tableau(row,x) < 255
2360 cursorCol=x
2370 cursorRow=row
2380 row = -1
2390 found = 1
2400 else
2410 row = row - 1
2420 endif
2430 wend
2440 endif
2450 next
2460 getcursorval()
2470 endproc
2480 proc updatecursorpos()
2490 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2500 endproc
2510 proc updateinput()
2520 local keypress
2530 keypress=inkey()
2540 if (keypress=2)|(joyx(0)=-1)
2550 if cursorCol > 0
2560 moveleft()
2570 updatecursorpos()
2580 endif
2590 endif
2600 if (keypress=6)|(joyx(0)=1)
2610 if cursorCol < 4
2620 moveright()
2630 updatecursorpos()
2640 endif
2650 endif
2660 if (keypress=100)
2670 if discardptr < 52
2680 discardptr = discardptr + 1
2690 renderboard()
2700 endif
2710 endif
2720 if (keypress=32)|(joyb(0)&1)
2730 tableau(cursorRow, cursorCol) = 255
2740 if cursorRow > 0
2750 cursorRow = cursorRow - 1
2760 updatecursorpos()
2770 endif
2780 print "Press!"
2790 renderboard()
2800 endif
2810 endproc
2820 proc gameloop()
2830 setup()
2840 updatecursorpos()
2850 getcursorval()
2860 repeat
2870 if event(tevent, 5)
2880 updateinput()
2890 if debugmode=true
2900 printdebugstuff()
2910 endif
2920 endif
2930 until isRunning=0
2940 endproc
ÿÿÿÿ
