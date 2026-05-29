1000 REM "Setup Variables and Start Loop"
1010 cls:cursorCol=0:cursorRow=6:isRunning=1:tevent=0
1020 debugmode=true:cursorVal=0:cardsleft=0:discardptr=0:discardval=0
1030 REM "This structure holds the card field and their x,y positions"
1040 dim tableau(7,5):dim tableaux(7,5):dim tableauy(7,5)
1050 printcenter("Loading backgrounds!", 0)
1060 cls:gameloop()
1070 end
1080 proc initboard()
1090 for x=1 to 52:?($7800+x)=x:next
1100 bload "background.pal", $7BFF
1110 loadpal($7BFF, 1)
1120 bload "background.bin", $10000
1130 bitmap on:bitmaplut(0,1)
1140 cls: printcenter("Loading Sprites!", 0)
1150 bload "sprites.bin", $30000
1160 sprites on
1170 endproc
1180 proc checkforlose()
1190 if discardptr = 52
1200 sprites off
1210 bitmap clear 3
1220 printcenter("You Lose! Hit Return Key To Play Again!", 0)
1230 input throwaway$
1240 cls:gameloop()
1250 endif
1260 endproc
1270 proc checkforwin()
1280 if cardsleft = 0
1290 sprites off
1300 bitmap clear 3
1310 printcenter("You Won! Hit Return Key To Play Again!", 0)
1320 input throwaway$
1330 cls:gameloop()
1340 endif
1350 endproc
1360 proc getcursorval()
1370 card = tableau(cursorRow,cursorCol)+1
1380 while card > 13
1390 card = card - 13
1400 wend
1410 cursorVal = card
1420 endproc
1430 proc getdiscardval()
1440 disc = ?($7800+discardptr)+1
1450 while disc > 13
1460 disc = disc - 13
1470 wend
1480 discardval = disc
1490 endproc
1500 proc renderboard()
1510 spritecounter = 35
1520 cardx = 32
1530 cardy = 24
1540 for r=0 to 6
1550 cardx = 90
1560 for c=0 to 4
1570 cardno = tableau(r,c)
1580 tableaux(r,c)=cardx
1590 tableauy(r,c)=cardy
1600 if cardno < 255
1610 sprite spritecounter image cardno to cardx,cardy
1620 else
1630 sprite spritecounter off
1640 endif
1650 cardx = cardx + 36
1660 spritecounter = spritecounter  - 1
1670 next
1680 cardy = cardy + 24
1690 next
1700 sprite 52 image 52 to 92, 208
1710 endproc
1720 proc shuffledeck()
1730 cls
1740 printcenter("Shuffling!",0)
1750 swapidx=0:swapval=0
1760 for x=0 to 51
1770 swapidx=random(50)+1
1780 swapval=?($7800+swapidx)
1790 ?($7800+swapidx)=?($7800)
1800 ?($7800)=swapval
1810 swapidx=random(50)+1
1820 swapval=?($7800+swapidx)
1830 ?($7800+swapidx)=?($7800+51)
1840 ?($7800+51)=swapval
1850 next
1860 cls
1870 endproc
1880 proc dealtoboard()
1890 index=0
1900 for r=0 to 6
1910 for c=0 to 4
1920 tableau(r,c)=?($7800+index)
1930 index=index+1
1940 next
1950 next
1960 cardsleft=index
1970 discardptr=35
1980 endproc
1990 proc update()
2000 endproc
2010 proc bitmaplut(bitmapno,lutno)
2020 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
2030 add$="53504,53512,53520"
2040 value=val(itemget$(add$,bitmapno+1,","))
2050 current=?(value)
2060 poke value,(1|1<<lutno)
2070 else
2080 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
2090 endif
2100 endproc
2110 proc loadpal(addr,lutno)
2120 lutaddr=$D000+(lutno*$400)
2130 poke 1,1
2140 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
2150 endproc
2160 proc printcenter(msg$, yoffset)
2170 xoffset=len(msg$)\2
2180 print at 30+yoffset,(40-xoffset)msg$
2190 endproc
2200 proc setup()
2210 initboard()
2220 shuffledeck()
2230 dealtoboard()
2240 sprite 0 image 54
2250 renderboard()
2260 getdiscardval()
2270 endproc
2280 proc printdebugstuff()
2290 print at 0,0 "";
2300 print "col: "+str$(cursorCol)+" "
2310 print "row: "+str$(cursorRow)+" "
2320 print "val: "+str$(cursorVal)+" "
2330 print "lef: "+str$(cardsleft)+" "
2340 print "dis: "+str$(discardptr)+" "
2350 print "dsv: "+str$(discardval)+" "
2360 endproc
2370 proc moveleft()
2380 col = cursorCol
2390 row = 6
2400 while col > 0
2410 col = col - 1
2420 row = 6
2430 while row >= 0
2440 if tableau(row, col) < 255
2450 cursorCol = col
2460 cursorRow = row
2470 row = -1
2480 col = 0
2490 endif
2500 row = row - 1
2510 wend
2520 wend
2530 getcursorval()
2540 endproc
2550 proc moveright()
2560 found = 0
2570 for x=(cursorCol+1) to 4
2580 row = 6
2590 if found = 0
2600 while row >= 0
2610 if tableau(row,x) < 255
2620 cursorCol=x
2630 cursorRow=row
2640 row = -1
2650 found = 1
2660 else
2670 row = row - 1
2680 endif
2690 wend
2700 endif
2710 next
2720 getcursorval()
2730 endproc
2740 proc updatecursorpos()
2750 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2760 endproc
2770 proc updateinput()
2780 local keypress
2790 keypress=inkey()
2800 if (keypress=2)|(joyx(0)=-1)
2810 if cursorCol > 0
2820 moveleft()
2830 updatecursorpos()
2840 endif
2850 endif
2860 if (keypress=6)|(joyx(0)=1)
2870 if cursorCol < 4
2880 moveright()
2890 updatecursorpos()
2900 endif
2910 endif
2920 if (keypress=100)
2930 if discardptr < 52
2940 discardptr = discardptr + 1
2950 sprite 53 image ?($7800+discardptr) to 126, 206
2960 getdiscardval()
2970 renderboard()
2980 endif
2990 endif
3000 if (keypress=32)|(joyb(0)&1)
3010 if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
3020 sprite 53 image tableau(cursorRow, cursorCol)
3030 discardval=cursorVal
3040 tableau(cursorRow, cursorCol) = 255
3050 cardsleft = cardsleft - 1
3060 if cursorRow > 0
3070 cursorRow = cursorRow - 1
3080 getcursorval()
3090 updatecursorpos()
3100 endif
3110 print "Press!"
3120 renderboard()
3130 endif
3140 endif
3150 endproc
3160 proc gameloop()
3170 setup()
3180 updatecursorpos()
3190 getcursorval()
3200 sprite 53 image ?($7800+discardptr) to 126, 206
3210 repeat
3220 checkforlose()
3230 checkforwin()
3240 if event(tevent, 5)
3250 updateinput()
3260 if debugmode=true
3270 printdebugstuff()
3280 endif
3290 endif
3300 until isRunning=0
3310 endproc
ÿÿÿÿ
