1000 REM "Setup Variables and Start Loop"
1010 cls:cursorCol=0:cursorRow=6:isRunning=1:tevent=0
1020 debugmode=true:cursorVal=0:cardsleft=0
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
1460 sprite 53 image 53 to 132, 2102
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
1660 for r=0 to 7
1670 for c=0 to 5
1680 tableau(r,c)=?($7800+index)
1690 index=index+1
1700 next
1710 next
1720 cardsleft=index
1730 endproc
1740 proc update()
1750 endproc
1760 proc bitmaplut(bitmapno,lutno)
1770 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1780 add$="53504,53512,53520"
1790 value=val(itemget$(add$,bitmapno+1,","))
1800 current=?(value)
1810 poke value,(1|1<<lutno)
1820 else
1830 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1840 endif
1850 endproc
1860 proc loadpal(addr,lutno)
1870 lutaddr=$D000+(lutno*$400)
1880 poke 1,1
1890 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1900 endproc
1910 proc printcenter(msg$, yoffset)
1920 xoffset=len(msg$)\2
1930 print at 30+yoffset,(40-xoffset)msg$
1940 endproc
1950 proc setup()
1960 initboard()
1970 shuffledeck()
1980 dealtoboard()
1990 sprite 0 image 54
2000 renderboard()
2010 endproc
2020 proc printdebugstuff()
2030 print at 0,0 "";
2040 print "col: "+str$(cursorCol)+" "
2050 print "row: "+str$(cursorRow)+" "
2060 print "val: "+str$(cursorVal)+" "
2070 endproc
2080 proc moveleft()
2090 col = cursorCol
2100 row = 6
2110 while col > 0
2120 col = col - 1
2130 row = 6
2140 while row >= 0
2150 if tableau(row, col) < 255
2160 cursorCol = col
2170 cursorRow = row
2180 row = -1
2190 col = 0
2200 endif
2210 row = row - 1
2220 wend
2230 wend
2240 getcursorval()
2250 endproc
2260 proc moveright()
2270 found = 0
2280 for x=(cursorCol+1) to 4
2290 row = 6
2300 if found = 0
2310 while row >= 0
2320 if tableau(row,x) < 255
2330 cursorCol=x
2340 cursorRow=row
2350 row = -1
2360 found = 1
2370 else
2380 row = row - 1
2390 endif
2400 wend
2410 endif
2420 next
2430 getcursorval()
2440 endproc
2450 proc updatecursorpos()
2460 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2470 endproc
2480 proc updateinput()
2490 local keypress
2500 keypress=inkey()
2510 if (keypress=2)|(joyx(0)=-1)
2520 if cursorCol > 0
2530 moveleft()
2540 updatecursorpos()
2550 endif
2560 endif
2570 if (keypress=6)|(joyx(0)=1)
2580 if cursorCol < 4
2590 moveright()
2600 updatecursorpos()
2610 endif
2620 endif
2630 if (keypress=32)|(joyb(0)&1)
2640 tableau(cursorRow, cursorCol) = 255
2650 if cursorRow > 0
2660 cursorRow = cursorRow - 1
2670 updatecursorpos()
2680 endif
2690 print "Press!"
2700 renderboard()
2710 endif
2720 endproc
2730 proc gameloop()
2740 setup()
2750 updatecursorpos()
2760 getcursorval()
2770 repeat
2780 if event(tevent, 5)
2790 updateinput()
2800 if debugmode=true
2810 printdebugstuff()
2820 endif
2830 endif
2840 until isRunning=0
2850 endproc
ÿÿÿÿ
