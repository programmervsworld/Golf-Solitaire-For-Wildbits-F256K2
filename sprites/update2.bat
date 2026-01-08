REM spritebuild.py is the x1 core way, spritebuilder2.py needs to be used on x2 cores otherwise
REM the output will be shifted off by one byte
REM python spritebuild.py sprites.def
python spritebuild2.py sprites.def
move graphics.bin ../sprites.bin
