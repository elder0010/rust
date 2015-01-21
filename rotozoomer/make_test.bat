@echo off
echo **************
echo * ROTOZOOMER *
echo **************
set "BIN=..\bin"
java -jar %BIN%\KickAss.jar fade.asm -symbolfile
java -jar %BIN%\KickAss.jar chunky_include.asm -symbolfile
java -jar %BIN%\KickAss.jar rotozoomer.asm -o rotozoomer.prg -symbolfile :test=1
%BIN%\exomizer sfx basic "Frame\frame.kla" rotozoomer.prg chunky_include.prg -o rotest.prg
