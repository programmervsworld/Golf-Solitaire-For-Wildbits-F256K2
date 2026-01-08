# Sprite Handling in SuperBasic

Sprite handling in SuperBasic works a bit differently than in assembly or C. Because of this, sprites must be prepared using the Python helper tools included in this repository rather than being loaded directly.

SuperBasic sprites require a specific binary format and header, which these tools generate for you automatically.

## Adding Sprites

1. Place all your sprite image files into the sprites directory.
1. Add each sprite’s name to the sprites.def file.

Each entry in sprites.def ends with a number. This value is used by the third-party spritebuilder tool to optionally generate 90-degree rotated versions of a sprite.

* 0 = no automatic rotation
* Other values enable rotation support (use at your own discretion)

Personally, I keep this value at 0 and create separate sprite images when I need rotated versions.

## Building the Sprite Binary

Once your sprites and sprites.def are set up:

* Run `update2.bat`
* This will:
    * Process all sprites
    * Pack them into a single `.bin` file
* Place the resulting binary at the root of the project

This ```.bin``` file is what your SuperBasic program loads at runtime.

## About the Sprite Builder Scripts

There are currently two versions of the sprite builder script included:

* `spritebuilder.py`
    * For the older x1 core
* `spritebuilder2.py`
    * For the new x2 core
    * Adds extra handling to ensure sprites are loaded at even memory addresses
    * This was a workaround (“hack”) required for compatibility
    * While not perfect, it has proven to work consistently in practice

## Notes

* Sprite memory alignment matters on the x2 core.
* If you encounter issues, try simplifying sprites or verifying alignment.
* This setup is designed to reduce friction and get you coding faster, not to be a perfect long-term sprite pipeline.