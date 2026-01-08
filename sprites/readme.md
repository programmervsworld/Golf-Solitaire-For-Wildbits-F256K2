# Sprites area
Sprites in SuperBasic are different from how you would load them in assembly or C therefore they have to use these python programs included to make them. They generally have a special header format in their binary representation.

To make a binary, just add all your sprites here and add their names to the sprites.def file. The number at the end represents something specific to the third parties spritebuilder ability to rotate images for you in 90 degree angles. Use at your own discretion :) I keep mine at 0 and make new sprites if I want them rotated usually.

Once done running update2.bat will load them all into a .bin file and place it at the root of the project.

There's two versions of spritebuilder.py in here right now because I had to do some hacking to get it to work on the new x2 core.

* spritebuilder.py is for the older x1 core
* spritebuilder2.py is for the new x2 core and add a few bits to make sure the load uses even number addresses. (It is a hack though, mileage may vary but it mostly works consistently)