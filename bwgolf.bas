1000 cls
1010 deck=$7800
1020 dim tableau(7,5):cardsleft=0
1030 printcenter("Loading backgrounds!", 0)
1040 bload "background.pal", $7BFF
1050 loadpal($7BFF, 1)
1060 bload "background.bin", $10000
1070 bitmap on:bitmaplut(0,1)
1080 cls: printcenter("Loading Sprites!", 0)
1090 bload "sprites.bin", $30000
1100 sprites on
1110 cls:gameloop()
1120 end
1130 proc initboard()
1140 for x=1 to 52:?(deck+x)=x:next
1150 endproc
1160 proc renderboard()
1170 spritecounter = 35
1180 cardx = 32
1190 cardy = 24
1200 for r=0 to 6
1210 cardx = 90
1220 for c=0 to 4
1230 cardno = tableau(r,c)
1240 sprite spritecounter image cardno to cardx,cardy
1250 cardx = cardx + 32
1260 spritecounter = spritecounter  - 1
1270 next
1280 cardy = cardy + 24
1290 next
1300 sprite 52 image 52 to 90, 208
1310 sprite 53 image 53 to 132, 210
1320 endproc
1330 proc shuffledeck()
1340 cls
1350 printcenter("Shuffling!",0)
1360 swapidx=0:swapval=0
1370 for x=0 to 51
1380 swapidx=random(50)+1
1390 swapval=?(deck+swapidx)
1400 ?(deck+swapidx)=?(deck)
1410 ?(deck)=swapval
1420 swapidx=random(50)+1
1430 swapval=?(deck+swapidx)
1440 ?(deck+swapidx)=?(deck+51)
1450 ?(deck+51)=swapval
1460 next
1470 cls
1480 endproc
1490 proc dealtoboard()
1500 index=0
1510 for r=0 to 7
1520 for c=0 to 5
1530 tableau(r,c)=?(deck+index)
1540 index=index+1
1550 next
1560 next
1570 cardsleft=index
1580 endproc
1590 proc update()
1600 endproc
1610 proc bitmaplut(bitmapno,lutno)
1620 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1630 add$="53504,53512,53520"
1640 value=val(itemget$(add$,bitmapno+1,","))
1650 current=?(value)
1660 poke value,(1|1<<lutno)
1670 else
1680 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1690 endif
1700 endproc
1710 proc loadpal(addr,lutno)
1720 lutaddr=$D000+(lutno*$400)
1730 poke 1,1
1740 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1750 endproc
1760 proc printcenter(msg$, yoffset)
1770 xoffset=len(msg$)\2
1780 print at 30+yoffset,(40-xoffset)msg$
1790 endproc
1800 proc setup()
1810 initboard()
1820 shuffledeck()
1830 dealtoboard()
1840 renderboard()
1850 endproc
1860 proc gameloop()
1870 setup()
1880 endproc
ÿÿÿÿ
