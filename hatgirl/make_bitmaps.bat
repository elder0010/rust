@ECHO OFF
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar girl1.asm -o girl1.prg
java -jar %BIN%\KickAss.jar girl2.asm -o girl2.prg
%BIN%\exomizer level -c girl1.prg -o gra.prg
%BIN%\exomizer level -c girl2.prg -o grb.prg
del girl1.prg
del girl2.prg
del girl1.sym
del gir2.sym

