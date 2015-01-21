@echo off
echo ***********
echo * EXOMIZE *
echo ***********
set "BIN=..\bin"

REM Create twister texture
cd Textures
twist.exe
cd ..
Echo Twister texture created

REM Make twister
java -jar %BIN%\KickAss.jar sbt.asm -o sbt.prg -symbolfile

REM Make fotozoomer fade

cd "..\rotozoomer"
java -jar %BIN%\KickAss.jar fade.asm

REM Make chunky routines (will be used in rotozoomer)

java -jar %BIN%\KickAss.jar chunky_include.asm

REM Merge everything
cd "..\twister"
java -jar %BIN%\KickAss.jar merge.asm
%BIN%\exomizer level -c merge.prg -o tw.prg

