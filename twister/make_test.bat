@echo off
echo *****************
echo * -> ROTOZOOMER *
echo *****************
set "BIN=..\bin"

REM Make twister
java -jar %BIN%\KickAss.jar sbt.asm -o sbt.prg -symbolfile -vicesymbols :test=1



