@echo off
echo ****************
echo * TWISTER TEST *
echo ****************
set "BIN=..\bin"

REM Create twister texture
cd Textures
twist.exe
cd ..
Echo Twister texture created

REM Make twister
java -jar %BIN%\KickAss.jar sbt.asm -o sbt.prg -symbolfile :test=1



