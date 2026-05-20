1000 cls
1010 deck=$7800
1020 dim tableau(7,5):cardsleft=0
1030 bitmap on
1040 bitmap clear 10
1050 sprites on
1060 bload "sprites.bin", $30000
1070 gameloop()
1080 end
1090 proc initboard()
1100 for x=1 to 52:?(deck+x)=x:next
1110 endproc
1120 proc renderboard()
1130 spritecounter = 35
1140 cardx = 32
1150 cardy = 24
1160 for r=0 to 6
1170 cardx = 90
1180 for c=0 to 4
1190 cardno = tableau(r,c)
1200 sprite spritecounter image cardno to cardx,cardy
1210 cardx = cardx + 32
1220 spritecounter = spritecounter  - 1
1230 next
1240 cardy = cardy + 24
1250 next
1260 sprite 52 image 52 to 90, 208
1270 sprite 53 image 53 to 132, 210
1280 endproc
1290 proc shuffledeck()
1300 cls
1310 printcenter("Shuffling!",0)
1320 swapidx=0:swapval=0
1330 for x=0 to 51
1340 swapidx=random(50)+1
1350 swapval=?(deck+swapidx)
1360 ?(deck+swapidx)=?(deck)
1370 ?(deck)=swapval
1380 swapidx=random(50)+1
1390 swapval=?(deck+swapidx)
1400 ?(deck+swapidx)=?(deck+51)
1410 ?(deck+51)=swapval
1420 next
1430 cls
1440 endproc
1450 proc dealtoboard()
1460 index=0
1470 for r=0 to 7
1480 for c=0 to 5
1490 tableau(r,c)=?(deck+index)
1500 index=index+1
1510 next
1520 next
1530 cardsleft=index
1540 endproc
1550 proc update()
1560 endproc
1570 proc bitmaplut(bitmapno,lutno)
1580 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1590 add$="53504,53512,53520"
1600 value=val(itemget$(add$,bitmapno+1,","))
1610 current=?(value)
1620 poke value,(1|1<<lutno)
1630 else
1640 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1650 endif
1660 endproc
1670 proc loadpal(addr,lutno)
1680 lutaddr=$D000+(lutno*$400)
1690 poke 1,1
1700 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1710 endproc
1720 proc printcenter(msg$, yoffset)
1730 xoffset=len(msg$)\2
1740 print at 30+yoffset,(40-xoffset)msg$
1750 endproc
1760 proc setup()
1770 initboard()
1780 shuffledeck()
1790 dealtoboard()
1800 renderboard()
1810 endproc
1820 proc gameloop()
1830 setup()
1840 endproc
ÿÿÿÿ
