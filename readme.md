# F256K2 Basic Development Project Template
I find myself repeating this layout over and over again working with basic projects for the wildbits f256k2. Thought I'd just share it in case it helps anyone else out in getting started.

To use it with windows/powershell you should just have to hit F5. But the build.ps1 script can be adapted to do whatever you generally need it to.

You will need to configure the scripts in here to change the names to whatever you want them to do and add some sprites.

## Usage

1. Clone the project
1. Rename it
1. Modify or add your own `.bas` file to the source directory and put some code in there
1. Change `build.sh` in the root of the project to support your new names.
1. See the sprites readme for adding sprites.
1. Double check the foenixmgr.ini file and make sure you are using the com port your f256k/k2 is plugged into
1. Run `build.sh` and look in the build dir for a full zip.
1. Profit! Just kidding theres no money in this!


## Notes

* This project is setup to work on the actual hardware as I don't typically use the emulator. It can, however, be adapted to any workflow you like.
* The source code in the `/src` directory will be auto-numbered and saved in the root of the project during the build.
* The `build.sh` can be commented and uncommented at will so you don't have to build everything everytime. For instance, I frequently comment out the sprite lines if I'm not created new sprites on each deploy.
