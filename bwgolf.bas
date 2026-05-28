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
1710 text "Remain" dim 1 color 1 to 10,10
1720 text "   " dim 2 color 2 to 14,20
1730 text str$(cardsLeft) dim 2 color 2 to 14,20
1740 endproc
1750 proc shuffledeck()
1760 cls
1770 printcenter("Shuffling!",0)
1780 swapidx=0:swapval=0
1790 for x=0 to 51
1800 swapidx=random(50)+1
1810 swapval=?($7800+swapidx)
1820 ?($7800+swapidx)=?($7800)
1830 ?($7800)=swapval
1840 swapidx=random(50)+1
1850 swapval=?($7800+swapidx)
1860 ?($7800+swapidx)=?($7800+51)
1870 ?($7800+51)=swapval
1880 next
1890 cls
1900 endproc
1910 proc dealtoboard()
1920 index=0
1930 for r=0 to 6
1940 for c=0 to 4
1950 tableau(r,c)=?($7800+index)
1960 index=index+1
1970 next
1980 next
1990 cardsleft=index
2000 discardptr=35
2010 endproc
2020 proc update()
2030 endproc
2040 proc bitmaplut(bitmapno,lutno)
2050 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
2060 add$="53504,53512,53520"
2070 value=val(itemget$(add$,bitmapno+1,","))
2080 current=?(value)
2090 poke value,(1|1<<lutno)
2100 else
2110 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
2120 endif
2130 endproc
2140 proc loadpal(addr,lutno)
2150 lutaddr=$D000+(lutno*$400)
2160 poke 1,1
2170 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
2180 endproc
2190 proc printcenter(msg$, yoffset)
2200 xoffset=len(msg$)\2
2210 print at 30+yoffset,(40-xoffset)msg$
2220 endproc
2230 proc setup()
2240 initboard()
2250 shuffledeck()
2260 dealtoboard()
2270 sprite 0 image 54
2280 renderboard()
2290 getdiscardval()
2300 endproc
2310 proc printdebugstuff()
2320 print at 0,0 "";
2330 print "col: "+str$(cursorCol)+" "
2340 print "row: "+str$(cursorRow)+" "
2350 print "val: "+str$(cursorVal)+" "
2360 print "lef: "+str$(cardsleft)+" "
2370 print "dis: "+str$(discardptr)+" "
2380 print "dsv: "+str$(discardval)+" "
2390 endproc
2400 proc moveleft()
2410 col = cursorCol
2420 row = 6
2430 while col > 0
2440 col = col - 1
2450 row = 6
2460 while row >= 0
2470 if tableau(row, col) < 255
2480 cursorCol = col
2490 cursorRow = row
2500 row = -1
2510 col = 0
2520 endif
2530 row = row - 1
2540 wend
2550 wend
2560 getcursorval()
2570 endproc
2580 proc moveright()
2590 found = 0
2600 for x=(cursorCol+1) to 4
2610 row = 6
2620 if found = 0
2630 while row >= 0
2640 if tableau(row,x) < 255
2650 cursorCol=x
2660 cursorRow=row
2670 row = -1
2680 found = 1
2690 else
2700 row = row - 1
2710 endif
2720 wend
2730 endif
2740 next
2750 getcursorval()
2760 endproc
2770 proc updatecursorpos()
2780 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2790 endproc
2800 proc updateinput()
2810 local keypress
2820 keypress=inkey()
2830 if (keypress=2)|(joyx(0)=-1)
2840 if cursorCol > 0
2850 moveleft()
2860 updatecursorpos()
2870 endif
2880 endif
2890 if (keypress=6)|(joyx(0)=1)
2900 if cursorCol < 4
2910 moveright()
2920 updatecursorpos()
2930 endif
2940 endif
2950 if (keypress=100)
2960 if discardptr < 52
2970 discardptr = discardptr + 1
2980 sprite 53 image ?($7800+discardptr) to 126, 206
2990 getdiscardval()
3000 renderboard()
3010 endif
3020 endif
3030 if (keypress=32)|(joyb(0)&1)
3040 if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
3050 sprite 53 image tableau(cursorRow, cursorCol)
3060 discardval=cursorVal
3070 tableau(cursorRow, cursorCol) = 255
3080 cardsleft = cardsleft - 1
3090 if cursorRow > 0
3100 cursorRow = cursorRow - 1
3110 getcursorval()
3120 updatecursorpos()
3130 endif
3140 print "Press!"
3150 renderboard()
3160 endif
3170 endif
3180 endproc
3190 proc gameloop()
3200 setup()
3210 updatecursorpos()
3220 getcursorval()
3230 sprite 53 image ?($7800+discardptr) to 126, 206
3240 repeat
3250 checkforlose()
3260 checkforwin()
3270 if event(tevent, 5)
3280 updateinput()
3290 if debugmode=true
3300 printdebugstuff()
3310 endif
3320 endif
3330 until isRunning=0
3340 endproc
ÿÿÿÿ
