#!/bin/bash

rm -f build/bwgolf.bas
rm -f build/sprites.bin

cat src/game.bas | python3 number.py > build/bwgolf.bas

cd sprites
./update2.sh

cd ../backgrounds
python3 png2raw.py fnxversionp3f.png background 320 240
mv background.bin ../build/
mv background.pal ../build/

cd ../build/

zip game.zip background.bin background.pal bwgolf.bas sprites.bin

#sudo python3 fnxmgr.zip --copy sprites.bin
#read -n 1 -s -p "Press any key to continue..."

#sudo python3 fnxmgr.zip --copy background.pal
#read -n 1 -s -p "Press any key to continue..."

#sudo python3 fnxmgr.zip --copy background.bin
#read -n 1 -s -p "Press any key to continue..."

sudo python3 fnxmgr.zip --binary bwgolf.bas --address 28000
