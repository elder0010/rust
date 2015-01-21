@echo off
echo **********
echo * LOADER *
echo **********
set "BIN=..\bin"
del loader.prg
%BIN%\dasm loader.s
ren a.prg loader.prg
cd openercheck
java -jar ..\\%BIN%\KickAss.jar mod.asm -o mod.prg
del check.prg
ren mod.prg check.prg
copy check.prg .. /Y
cd..
java -jar %BIN%\KickAss.jar manager.asm -o manager.prg
%BIN%\exomizer sfx $0814 manager.prg -n
del manager.prg
del loader.prg
ren a.out loader.prg
