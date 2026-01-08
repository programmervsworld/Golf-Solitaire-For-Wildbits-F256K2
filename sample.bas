1000 cls
1010 bload "<yourbackgroundlut>.pal",$7BFF
1020 loadpal($7BFF,1)
1030 bload "<yourbackground>.bin",$10000
1040 bitmap on :bitmaplut(0,1)
1050 end
1060 proc setup()
1070 bitmaplut(0,1)
1080 endproc
1090 proc gameloop()
1100 tevent=0
1110 repeat
1120 if event(tevent,2) then update()
1130 until false
1140 endproc
1150 proc update()
1160 print at 60\2,80\2-2 random(255)
1170 rect solid 140,100 color random(255) to 200,140
1180 endproc
1190 proc bitmaplut(bitmapno,lutno)
1200 if bitmapno>=0&bitmapno<3&lutno>=0&lutno<4
1210 add$="53504,53512,53520"
1220 value=val(itemget$(add$,bitmapno+1,","))
1230 current=?(value)
1240 poke value,(1|1<<lutno)
1250 else
1260 print "bitmaplut must have a bitmap between 0-2 and a lut 0-3!"
1270 endif
1280 endproc
1290 proc loadpal(addr,lutno)
1300 lutaddr=$D000+(lutno*$400)
1310 poke 1,1
1320 for x=0 to 1023:?(lutaddr+x)=?(addr+x):next
1330 endproc
????
