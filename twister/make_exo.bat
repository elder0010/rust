@echo off
echo *****************
echo * -> ROTOZOOMER *
echo *****************
set "BIN=..\bin"

REM Make twister
java -jar %BIN%\KickAss.jar sbt.asm -o sbt.prg -symbolfile -vicesymbols

REM Make fotozoomer fade

cd "..\rotofader"
java -jar %BIN%\KickAss.jar fade.asm

REM Make chunky routines (will be used in rotozoomer)

cd "..\rotozoomer"
java -jar %BIN%\KickAss.jar chunky_include.asm

REM Merge everything
cd "..\twister"
java -jar %BIN%\KickAss.jar merge.asm
%BIN%\exomizer level -c merge.prg -o tw.prg

