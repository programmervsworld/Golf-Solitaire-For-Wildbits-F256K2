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
1230 text "Press FIRE or SPACE!" dim 1 color 1 to 90,120
1240 repeat
1250 keypress=inkey()
1260 if (keypress=32)|(joyb(0)&1) then spscreen=0
1270 until spscreen=0
1280 cursorCol=0:cursorRow=6
1290 cls:gameloop()
1300 endif
1310 endproc
1320 proc checkforwin()
1330 spscreen=1
1340 if cardsleft = 0
1350 sprites on
1360 text "You Won!" dim 2 color 1 to 100,100
1370 text "Press FIRE to try again" dim 1 color 1 to 70,120
1380 repeat
1390 for x = 0 to 51
1400 sprite x image x to random(320),random(240)
1410 next
1420 if (joyb(0)&1)
1430 spscreen=0
1440 endif
1450 until spscreen = 0
1460 cursorCol=0:cursorRow=6
1470 cls:gameloop()
1480 endif
1490 endproc
1500 proc getcursorval()
1510 card = tableau(cursorRow,cursorCol)+1
1520 while card > 13
1530 card = card - 13
1540 wend
1550 cursorVal = card
1560 endproc
1570 proc getdiscardval()
1580 disc = ?($7800+discardptr)+1
1590 while disc > 13
1600 disc = disc - 13
1610 wend
1620 discardval = disc
1630 endproc
1640 proc renderboard()
1650 spritecounter = 35
1660 cardx = 32
1670 cardy = 24
1680 leftdigit = int(cardsleft / 10)
1690 rightdigit = cardsleft % 10
1700 for r=0 to 6
1710 cardx = 90
1720 for c=0 to 4
1730 cardno = tableau(r,c)
1740 tableaux(r,c)=cardx
1750 tableauy(r,c)=cardy
1760 if cardno < 255
1770 sprite spritecounter image cardno to cardx,cardy
1780 else
1790 sprite spritecounter off
1800 endif
1810 cardx = cardx + 36
1820 spritecounter = spritecounter  - 1
1830 next
1840 cardy = cardy + 24
1850 next
1860 sprite 52 image 52 to 92, 208
1870 sprite 54 image 54 + leftdigit to 23,108
1880 sprite 55 image 54 + rightdigit to 44,108
1890 endproc
1900 proc shuffledeck()
1910 cls
1920 printcenter("Shuffling!",0)
1930 swapidx=0:swapval=0
1940 for x=0 to 51
1950 swapidx=random(50)+1
1960 swapval=?($7800+swapidx)
1970 ?($7800+swapidx)=?($7800)
1980 ?($7800)=swapval
1990 swapidx=random(50)+1
2000 swapval=?($7800+swapidx)
2010 ?($7800+swapidx)=?($7800+51)
2020 ?($7800+51)=swapval
2030 next
2040 cls
2050 endproc
2060 proc dealtoboard()
2070 index=0
2080 for r=0 to 6
2090 for c=0 to 4
2100 tableau(r,c)=?($7800+index)
2110 index=index+1
2120 next
2130 next
2140 cardsleft=index
2150 discardptr=35
2160 endproc
2170 proc update()
2180 endproc
2190 proc bitmaplut(bitmapno,lutno)
2200 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
2210 add$="53504,53512,53520"
2220 value=val(itemget$(add$,bitmapno+1,","))
2230 current=?(value)
2240 poke value,(1|1<<lutno)
2250 else
2260 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
2270 endif
2280 endproc
2290 proc loadpal(addr,lutno)
2300 lutaddr=$D000+(lutno*$400)
2310 poke 1,1
2320 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
2330 endproc
2340 proc printcenter(msg$, yoffset)
2350 xoffset=len(msg$)\2
2360 print at 30+yoffset,(40-xoffset)msg$
2370 endproc
2380 proc setup()
2390 initboard()
2400 shuffledeck()
2410 dealtoboard()
2420 sprite 0 image 53
2430 renderboard()
2440 getdiscardval()
2450 endproc
2460 proc printdebugstuff()
2470 print at 0,0 "";
2480 print "col: "+str$(cursorCol)+" "
2490 print "row: "+str$(cursorRow)+" "
2500 print "val: "+str$(cursorVal)+" "
2510 print "lef: "+str$(cardsleft)+" "
2520 print "dis: "+str$(discardptr)+" "
2530 print "dsv: "+str$(discardval)+" "
2540 endproc
2550 proc moveleft()
2560 col = cursorCol
2570 row = 6
2580 while col > 0
2590 col = col - 1
2600 row = 6
2610 while row >= 0
2620 if tableau(row, col) < 255
2630 cursorCol = col
2640 cursorRow = row
2650 row = -1
2660 col = 0
2670 endif
2680 row = row - 1
2690 wend
2700 wend
2710 getcursorval()
2720 endproc
2730 proc moveright()
2740 found = 0
2750 for x=(cursorCol+1) to 4
2760 row = 6
2770 if found = 0
2780 while row >= 0
2790 if tableau(row,x) < 255
2800 cursorCol=x
2810 cursorRow=row
2820 row = -1
2830 found = 1
2840 else
2850 row = row - 1
2860 endif
2870 wend
2880 endif
2890 next
2900 getcursorval()
2910 endproc
2920 proc updatecursorpos()
2930 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2940 endproc
2950 proc updateinput()
2960 local keypress
2970 keypress=inkey()
2980 if (keypress=2)|(joyx(0)=-1)
2990 if cursorCol > 0
3000 moveleft()
3010 updatecursorpos()
3020 endif
3030 endif
3040 if (keypress=6)|(joyx(0)=1)
3050 if cursorCol < 4
3060 moveright()
3070 updatecursorpos()
3080 endif
3090 endif
3100 if (keypress=32)|(joyb(0)&1)
3110 if discardval = (cursorVal - 1)|discardval = (cursorVal + 1)
3120 sprite 53 image tableau(cursorRow, cursorCol)
3130 discardval=cursorVal
3140 tableau(cursorRow, cursorCol) = 255
3150 cardsleft = cardsleft - 1
3160 if cursorRow > 0
3170 cursorRow = cursorRow - 1
3180 getcursorval()
3190 updatecursorpos()
3200 endif
3210 renderboard()
3220 endif
3230 endif
3240 if (keypress=100)|(joyy(0)=-1)
3250 if discardptr < 52
3260 discardptr = discardptr + 1
3270 sprite 53 image ?($7800+discardptr) to 126, 206
3280 getdiscardval()
3290 renderboard()
3300 endif
3310 endif
3320 endproc
3330 proc slowupdateinput()
3340 
3350 endproc
3360 proc gameloop()
3370 frames=0
3380 setup()
3390 updatecursorpos()
3400 getcursorval()
3410 sprite 53 image ?($7800+discardptr) to 126, 206
3420 repeat
3430 checkforlose()
3440 checkforwin()
3450 if event(tevent, 5)
3460 updateinput()
3470 if debugmode=true
3480 printdebugstuff()
3490 endif
3500 frames = frames + 1
3510 endif
3520 if frames = 3
3530 slowupdateinput()
3540 frames = 0
3550 endif
3560 until isRunning=0
3570 endproc
ÿÿÿÿ
