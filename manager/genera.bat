@echo off
echo *************
echo * -> LOADER *
echo *************
set BINPATH="..\..\bin"
del loader.prg
%BINPATH%\dasm loader.s
ren a.prg loader.prg
cd "..\Opener Check"
java -jar %BINPATH%\kickass.jar mod.asm
del check.prg
ren mod.prg check.prg
copy check.prg "..\OK - Manager" /Y
cd "..\OK - Manager"
java -jar %BINPATH%\kickass.jar manager.asm
%BINPATH%\exomizer sfx $0840 manager.prg -q -n
del manager.prg
del loader.prg
ren a.out loader.prg
