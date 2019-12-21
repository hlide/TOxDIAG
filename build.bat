@echo off
: Compilation
lwasm -9 -fihex -o TOxDIAG.hex TOxDIAG.asm
hex2bin -e bin -b TOxDIAG.hex
: 27128 16 ko
copy /b TOxDIAG.bin + /b TOxDIAG.bin TOxDIAG-27128.bin
: 27256 32 ko
copy /b TOxDIAG-27128.bin + /b TOxDIAG-27128.bin TOxDIAG-27256.bin
: Move
move TOxDIAG-27128.bin build
move TOxDIAG-27256.bin build
: Clean
del TOxDIAG.hex
del TOxDIAG.bin