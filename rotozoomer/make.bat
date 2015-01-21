@echo off
echo **************
echo * ROTOZOOMER *
echo **************
set "BIN=..\bin"

REM Make rotozoomer fader (will be linked in rotozoomer)
java -jar %BIN%\KickAss.jar fade.asm -symbolfile

REM Make chunky routines (will be used in rotozoomer)
cd "..\rotozoomer"
java -jar %BIN%\KickAss.jar chunky_include.asm

REM Make rotozoomer
java -jar %BIN%\KickAss.jar rotozoomer.asm -o rotozoomer.prg -symbolfile
