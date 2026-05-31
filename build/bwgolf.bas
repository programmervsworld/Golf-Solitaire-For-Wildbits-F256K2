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
1240 cursorCol=0:cursorRow=6
1250 cls:gameloop()
1260 endif
1270 endproc
1280 proc checkforwin()
1290 if cardsleft = 0
1300 sprites off
1310 bitmap clear 3
1320 printcenter("You Won! Hit Return Key To Play Again!", 0)
1330 input throwaway$
1340 cursorCol=0:cursorRow=6
1350 cls:gameloop()
1360 endif
1370 endproc
1380 proc getcursorval()
1390 card = tableau(cursorRow,cursorCol)+1
1400 while card > 13
1410 card = card - 13
1420 wend
1430 cursorVal = card
1440 endproc
1450 proc getdiscardval()
1460 disc = ?($7800+discardptr)+1
1470 while disc > 13
1480 disc = disc - 13
1490 wend
1500 discardval = disc
1510 endproc
1520 proc renderboard()
1530 spritecounter = 35
1540 cardx = 32
1550 cardy = 24
1560 for r=0 to 6
1570 cardx = 90
1580 for c=0 to 4
1590 cardno = tableau(r,c)
1600 tableaux(r,c)=cardx
1610 tableauy(r,c)=cardy
1620 if cardno < 255
1630 sprite spritecounter image cardno to cardx,cardy
1640 else
1650 sprite spritecounter off
1660 endif
1670 cardx = cardx + 36
1680 spritecounter = spritecounter  - 1
1690 next
1700 cardy = cardy + 24
1710 next
1720 sprite 52 image 52 to 92, 208
1730 endproc
1740 proc shuffledeck()
1750 cls
1760 printcenter("Shuffling!",0)
1770 swapidx=0:swapval=0
1780 for x=0 to 51
1790 swapidx=random(50)+1
1800 swapval=?($7800+swapidx)
1810 ?($7800+swapidx)=?($7800)
1820 ?($7800)=swapval
1830 swapidx=random(50)+1
1840 swapval=?($7800+swapidx)
1850 ?($7800+swapidx)=?($7800+51)
1860 ?($7800+51)=swapval
1870 next
1880 cls
1890 endproc
1900 proc dealtoboard()
1910 index=0
1920 for r=0 to 6
1930 for c=0 to 4
1940 tableau(r,c)=?($7800+index)
1950 index=index+1
1960 next
1970 next
1980 cardsleft=index
1990 discardptr=35
2000 endproc
2010 proc update()
2020 endproc
2030 proc bitmaplut(bitmapno,lutno)
2040 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
2050 add$="53504,53512,53520"
2060 value=val(itemget$(add$,bitmapno+1,","))
2070 current=?(value)
2080 poke value,(1|1<<lutno)
2090 else
2100 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
2110 endif
2120 endproc
2130 proc loadpal(addr,lutno)
2140 lutaddr=$D000+(lutno*$400)
2150 poke 1,1
2160 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
2170 endproc
2180 proc printcenter(msg$, yoffset)
2190 xoffset=len(msg$)\2
2200 print at 30+yoffset,(40-xoffset)msg$
2210 endproc
2220 proc setup()
2230 initboard()
2240 shuffledeck()
2250 dealtoboard()
2260 sprite 0 image 54
2270 renderboard()
2280 getdiscardval()
2290 endproc
2300 proc printdebugstuff()
2310 print at 0,0 "";
2320 print "col: "+str$(cursorCol)+" "
2330 print "row: "+str$(cursorRow)+" "
2340 print "val: "+str$(cursorVal)+" "
2350 print "lef: "+str$(cardsleft)+" "
2360 print "dis: "+str$(discardptr)+" "
2370 print "dsv: "+str$(discardval)+" "
2380 endproc
2390 proc moveleft()
2400 col = cursorCol
2410 row = 6
2420 while col > 0
2430 col = col - 1
2440 row = 6
2450 while row >= 0
2460 if tableau(row, col) < 255
2470 cursorCol = col
2480 cursorRow = row
2490 row = -1
2500 col = 0
2510 endif
2520 row = row - 1
2530 wend
2540 wend
2550 getcursorval()
2560 endproc
2570 proc moveright()
2580 found = 0
2590 for x=(cursorCol+1) to 4
2600 row = 6
2610 if found = 0
2620 while row >= 0
2630 if tableau(row,x) < 255
2640 cursorCol=x
2650 cursorRow=row
2660 row = -1
2670 found = 1
2680 else
2690 row = row - 1
2700 endif
2710 wend
2720 endif
2730 next
2740 getcursorval()
2750 endproc
2760 proc updatecursorpos()
2770 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2780 endproc
2790 proc updateinput()
2800 local keypress
2810 keypress=inkey()
2820 if (keypress=2)|(joyx(0)=-1)
2830 if cursorCol > 0
2840 moveleft()
2850 updatecursorpos()
2860 endif
2870 endif
2880 if (keypress=6)|(joyx(0)=1)
2890 if cursorCol < 4
2900 moveright()
2910 updatecursorpos()
2920 endif
2930 endif
2940 endproc
2950 proc slowupdateinput()
2960 if (keypress=32)|(joyb(0)&1)
2970 if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
2980 sprite 53 image tableau(cursorRow, cursorCol)
2990 discardval=cursorVal
3000 tableau(cursorRow, cursorCol) = 255
3010 cardsleft = cardsleft - 1
3020 if cursorRow > 0
3030 cursorRow = cursorRow - 1
3040 getcursorval()
3050 updatecursorpos()
3060 endif
3070 print "Press!"
3080 renderboard()
3090 endif
3100 endif
3110 if (keypress=100)|(joyy(0)=-1)
3120 if discardptr < 52
3130 discardptr = discardptr + 1
3140 sprite 53 image ?($7800+discardptr) to 126, 206
3150 getdiscardval()
3160 renderboard()
3170 endif
3180 endif
3190 endproc
3200 proc gameloop()
3210 frames=0
3220 setup()
3230 updatecursorpos()
3240 getcursorval()
3250 sprite 53 image ?($7800+discardptr) to 126, 206
3260 repeat
3270 checkforlose()
3280 checkforwin()
3290 if event(tevent, 5)
3300 updateinput()
3310 if debugmode=true
3320 printdebugstuff()
3330 endif
3340 frames = frames + 1
3350 endif
3360 if frames = 3
3370 slowupdateinput()
3380 frames = 0
3390 endif
3400 until isRunning=0
3410 endproc
ÿÿÿÿ
