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
1130 spritecounter = 1
1140 cardx = 32
1150 cardy = 24
1160 for r=0 to 6
1170 cardx = 16
1180 for c=0 to 4
1190 cardno = tableau(r,c)
1200 sprite spritecounter image cardno to cardx,cardy
1210 cardx = cardx + 32
1220 spritecounter = spritecounter + 1
1230 next
1240 cardy = cardy + 24
1250 next
1260 endproc
1270 proc shuffledeck()
1280 cls
1290 printcenter("Shuffling!",0)
1300 swapidx=0:swapval=0
1310 for x=0 to 51
1320 swapidx=random(50)+1
1330 swapval=?(deck+swapidx)
1340 ?(deck+swapidx)=?(deck)
1350 ?(deck)=swapval
1360 swapidx=random(50)+1
1370 swapval=?(deck+swapidx)
1380 ?(deck+swapidx)=?(deck+51)
1390 ?(deck+51)=swapval
1400 next
1410 cls
1420 endproc
1430 proc dealtoboard()
1440 index=0
1450 for r=0 to 7
1460 for c=0 to 5
1470 tableau(r,c)=?(deck+index)
1480 index=index+1
1490 next
1500 next
1510 cardsleft=index
1520 endproc
1530 proc update()
1540 endproc
1550 proc bitmaplut(bitmapno,lutno)
1560 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1570 add$="53504,53512,53520"
1580 value=val(itemget$(add$,bitmapno+1,","))
1590 current=?(value)
1600 poke value,(1|1<<lutno)
1610 else
1620 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1630 endif
1640 endproc
1650 proc loadpal(addr,lutno)
1660 lutaddr=$D000+(lutno*$400)
1670 poke 1,1
1680 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1690 endproc
1700 proc printcenter(msg$, yoffset)
1710 xoffset=len(msg$)\2
1720 print at 30+yoffset,(40-xoffset)msg$
1730 endproc
1740 proc setup()
1750 initboard()
1760 shuffledeck()
1770 dealtoboard()
1780 renderboard()
1790 endproc
1800 proc gameloop()
1810 setup()
1820 endproc
ÿÿÿÿ
