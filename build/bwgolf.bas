1000 REM "Setup Variables and Start Loop"
1010 cls:cursorCol=0:cursorRow=6:isRunning=1:tevent=0:spscreen=1
1020 debugmode=false:cursorVal=0:cardsleft=0:discardptr=0:discardval=0
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
1190 spscreen=1
1200 if discardptr = 52
1210 sprites off
1220 text "You Lose!" dim 2 color 1 to 100,100
1230 text "Press FIRE to try again" dim 1 color 1 to 70,120
1240 repeat
1250 if (joyb(0)&1) then spscreen=0
1260 until spscreen=0
1270 cursorCol=0:cursorRow=6
1280 cls:gameloop()
1290 endif
1300 endproc
1310 proc checkforwin()
1320 spscreen=1
1330 if cardsleft = 0
1340 sprites on
1350 text "You Won!" dim 2 color 1 to 100,100
1360 text "Press FIRE to try again" dim 1 color 1 to 70,120
1370 repeat
1380 for x = 0 to 51
1390 sprite x image x to random(320),random(240)
1400 next
1410 if (joyb(0)&1)
1420 spscreen=0
1430 endif
1440 until spscreen = 0
1450 cursorCol=0:cursorRow=6
1460 cls:gameloop()
1470 endif
1480 endproc
1490 proc getcursorval()
1500 card = tableau(cursorRow,cursorCol)+1
1510 while card > 13
1520 card = card - 13
1530 wend
1540 cursorVal = card
1550 endproc
1560 proc getdiscardval()
1570 disc = ?($7800+discardptr)+1
1580 while disc > 13
1590 disc = disc - 13
1600 wend
1610 discardval = disc
1620 endproc
1630 proc renderboard()
1640 spritecounter = 35
1650 cardx = 32
1660 cardy = 24
1670 for r=0 to 6
1680 cardx = 90
1690 for c=0 to 4
1700 cardno = tableau(r,c)
1710 tableaux(r,c)=cardx
1720 tableauy(r,c)=cardy
1730 if cardno < 255
1740 sprite spritecounter image cardno to cardx,cardy
1750 else
1760 sprite spritecounter off
1770 endif
1780 cardx = cardx + 36
1790 spritecounter = spritecounter  - 1
1800 next
1810 cardy = cardy + 24
1820 next
1830 sprite 52 image 52 to 92, 208
1840 endproc
1850 proc shuffledeck()
1860 cls
1870 printcenter("Shuffling!",0)
1880 swapidx=0:swapval=0
1890 for x=0 to 51
1900 swapidx=random(50)+1
1910 swapval=?($7800+swapidx)
1920 ?($7800+swapidx)=?($7800)
1930 ?($7800)=swapval
1940 swapidx=random(50)+1
1950 swapval=?($7800+swapidx)
1960 ?($7800+swapidx)=?($7800+51)
1970 ?($7800+51)=swapval
1980 next
1990 cls
2000 endproc
2010 proc dealtoboard()
2020 index=0
2030 for r=0 to 6
2040 for c=0 to 4
2050 tableau(r,c)=?($7800+index)
2060 index=index+1
2070 next
2080 next
2090 cardsleft=index
2100 discardptr=35
2110 endproc
2120 proc update()
2130 endproc
2140 proc bitmaplut(bitmapno,lutno)
2150 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
2160 add$="53504,53512,53520"
2170 value=val(itemget$(add$,bitmapno+1,","))
2180 current=?(value)
2190 poke value,(1|1<<lutno)
2200 else
2210 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
2220 endif
2230 endproc
2240 proc loadpal(addr,lutno)
2250 lutaddr=$D000+(lutno*$400)
2260 poke 1,1
2270 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
2280 endproc
2290 proc printcenter(msg$, yoffset)
2300 xoffset=len(msg$)\2
2310 print at 30+yoffset,(40-xoffset)msg$
2320 endproc
2330 proc setup()
2340 initboard()
2350 shuffledeck()
2360 dealtoboard()
2370 sprite 0 image 53
2380 renderboard()
2390 getdiscardval()
2400 endproc
2410 proc printdebugstuff()
2420 print at 0,0 "";
2430 print "col: "+str$(cursorCol)+" "
2440 print "row: "+str$(cursorRow)+" "
2450 print "val: "+str$(cursorVal)+" "
2460 print "lef: "+str$(cardsleft)+" "
2470 print "dis: "+str$(discardptr)+" "
2480 print "dsv: "+str$(discardval)+" "
2490 endproc
2500 proc moveleft()
2510 col = cursorCol
2520 row = 6
2530 while col > 0
2540 col = col - 1
2550 row = 6
2560 while row >= 0
2570 if tableau(row, col) < 255
2580 cursorCol = col
2590 cursorRow = row
2600 row = -1
2610 col = 0
2620 endif
2630 row = row - 1
2640 wend
2650 wend
2660 getcursorval()
2670 endproc
2680 proc moveright()
2690 found = 0
2700 for x=(cursorCol+1) to 4
2710 row = 6
2720 if found = 0
2730 while row >= 0
2740 if tableau(row,x) < 255
2750 cursorCol=x
2760 cursorRow=row
2770 row = -1
2780 found = 1
2790 else
2800 row = row - 1
2810 endif
2820 wend
2830 endif
2840 next
2850 getcursorval()
2860 endproc
2870 proc updatecursorpos()
2880 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2890 endproc
2900 proc updateinput()
2910 local keypress
2920 keypress=inkey()
2930 if (keypress=2)|(joyx(0)=-1)
2940 if cursorCol > 0
2950 moveleft()
2960 updatecursorpos()
2970 endif
2980 endif
2990 if (keypress=6)|(joyx(0)=1)
3000 if cursorCol < 4
3010 moveright()
3020 updatecursorpos()
3030 endif
3040 endif
3050 endproc
3060 proc slowupdateinput()
3070 if (keypress=32)|(joyb(0)&1)
3080 if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
3090 sprite 53 image tableau(cursorRow, cursorCol)
3100 discardval=cursorVal
3110 tableau(cursorRow, cursorCol) = 255
3120 cardsleft = cardsleft - 1
3130 if cursorRow > 0
3140 cursorRow = cursorRow - 1
3150 getcursorval()
3160 updatecursorpos()
3170 endif
3180 renderboard()
3190 endif
3200 endif
3210 if (keypress=100)|(joyy(0)=-1)
3220 if discardptr < 52
3230 discardptr = discardptr + 1
3240 sprite 53 image ?($7800+discardptr) to 126, 206
3250 getdiscardval()
3260 renderboard()
3270 endif
3280 endif
3290 endproc
3300 proc gameloop()
3310 frames=0
3320 setup()
3330 updatecursorpos()
3340 getcursorval()
3350 sprite 53 image ?($7800+discardptr) to 126, 206
3360 repeat
3370 checkforlose()
3380 checkforwin()
3390 if event(tevent, 5)
3400 updateinput()
3410 if debugmode=true
3420 printdebugstuff()
3430 endif
3440 frames = frames + 1
3450 endif
3460 if frames = 3
3470 slowupdateinput()
3480 frames = 0
3490 endif
3500 until isRunning=0
3510 endproc
ÿÿÿÿ
