#!/bin/bash

rm -f sample.bas
rm -f sprites.bin

cat src/game.bas | python3 number.py > bwgolf.bas
cd sprites
./update2.sh

cd ..
sudo python3 fnxmgr.zip --copy sprites.bin
read -n 1 -s -p "Press any key to continue..."

#sudo python3 fnxmgr.zip --copy background.pal
#read -n 1 -s -p "Press any key to continue..."

#sudo python3 fnxmgr.zip --copy background.bin
#read -n 1 -s -p "Press any key to continue..."

sudo python3 fnxmgr.zip --binary bwgolf.bas --address 28000
