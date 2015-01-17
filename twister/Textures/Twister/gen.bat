@echo off
twist
copy test.bin ..\sbt /Y
cd ..
call kick sbt.asm
cd twister

