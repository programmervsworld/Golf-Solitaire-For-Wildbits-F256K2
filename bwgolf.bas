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
1230 cardx = 92
1240 for c=0 to 4
1250 cardno = tableau(r,c)
1260 tableaux(r,c)=cardx
1270 tableauy(r,c)=cardy
1280 if cardno < 255
1290 sprite spritecounter image cardno to cardx,cardy
1300 else
1310 sprite spritecounter off
1320 endif
1330 cardx = cardx + 33
1340 spritecounter = spritecounter  - 1
1350 next
1360 cardy = cardy + 24
1370 next
1380 sprite 52 image 52 to 90, 208
1390 sprite 53 image 53 to 132, 2102
1400 endproc
1410 proc shuffledeck()
1420 cls
1430 printcenter("Shuffling!",0)
1440 swapidx=0:swapval=0
1450 for x=0 to 51
1460 swapidx=random(50)+1
1470 swapval=?(deck+swapidx)
1480 ?(deck+swapidx)=?(deck)
1490 ?(deck)=swapval
1500 swapidx=random(50)+1
1510 swapval=?(deck+swapidx)
1520 ?(deck+swapidx)=?(deck+51)
1530 ?(deck+51)=swapval
1540 next
1550 cls
1560 endproc
1570 proc dealtoboard()
1580 index=0
1590 for r=0 to 7
1600 for c=0 to 5
1610 tableau(r,c)=?(deck+index)
1620 index=index+1
1630 next
1640 next
1650 cardsleft=index
1660 endproc
1670 proc update()
1680 endproc
1690 proc bitmaplut(bitmapno,lutno)
1700 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1710 add$="53504,53512,53520"
1720 value=val(itemget$(add$,bitmapno+1,","))
1730 current=?(value)
1740 poke value,(1|1<<lutno)
1750 else
1760 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1770 endif
1780 endproc
1790 proc loadpal(addr,lutno)
1800 lutaddr=$D000+(lutno*$400)
1810 poke 1,1
1820 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1830 endproc
1840 proc printcenter(msg$, yoffset)
1850 xoffset=len(msg$)\2
1860 print at 30+yoffset,(40-xoffset)msg$
1870 endproc
1880 proc setup()
1890 initboard()
1900 shuffledeck()
1910 dealtoboard()
1920 sprite 0 image 54
1930 renderboard()
1940 endproc
1950 proc printdebugstuff()
1960 print at 0,0 "";
1970 print "col: "+str$(cursorCol)+" "
1980 print "row: "+str$(cursorRow)+" "
1990 endproc
2000 proc moveleft()
2010 col = cursorCol
2020 row = 6
2030 while col > 0
2040 col = col - 1
2050 row = 6
2060 while row >= 0
2070 if tableau(row, col) < 255
2080 cursorCol = col
2090 cursorRow = row
2100 row = -1
2110 col = 0
2120 endif
2130 row = row - 1
2140 wend
2150 wend
2160 endproc
2170 proc moveright()
2180 found = 0
2190 for x=(cursorCol+1) to 4
2200 row = 6
2210 if found = 0
2220 while row >= 0
2230 if tableau(row,x) < 255
2240 cursorCol=x
2250 cursorRow=row
2260 row = -1
2270 found = 1
2280 else
2290 row = row - 1
2300 endif
2310 wend
2320 endif
2330 next
2340 endproc
2350 proc updatecursorpos()
2360 sprite 0 to tableaux(cursorRow,cursorCol),tableauy(cursorRow,cursorCol)
2370 endproc
2380 proc updateinput()
2390 local keypress
2400 keypress=inkey()
2410 if (keypress=2)|(joyx(0)=-1)
2420 if cursorCol > 0
2430 moveleft()
2440 updatecursorpos()
2450 endif
2460 endif
2470 if (keypress=6)|(joyx(0)=1)
2480 if cursorCol < 4
2490 moveright()
2500 updatecursorpos()
2510 endif
2520 endif
2530 if (keypress=32)|(joyb(0)&1)
2540 tableau(cursorRow, cursorCol) = 255
2550 if cursorRow > 0
2560 cursorRow = cursorRow - 1
2570 updatecursorpos()
2580 endif
2590 print "Press!"
2600 renderboard()
2610 endif
2620 endproc
2630 proc gameloop()
2640 setup()
2650 updatecursorpos()
2660 repeat
2670 if event(tevent, 5)
2680 updateinput()
2690 if debugmode=true
2700 printdebugstuff()
2710 endif
2720 endif
2730 until isRunning=0
2740 endproc
ÿÿÿÿ
