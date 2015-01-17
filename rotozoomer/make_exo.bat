@echo off
echo *****************
echo * -> ROTOZOOMER *
echo *****************
set "BIN=..\bin"
java -jar %BIN%\KickAss.jar rotozoomer.asm -o rotozoomer.prg -symbolfile -vicesymbols
%BIN%\exomizer level -c rotozoomer.prg -o ro.prg

