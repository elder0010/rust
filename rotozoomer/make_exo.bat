@echo off
echo ************
echo * EXOMIZER *
echo ************
set "BIN=..\bin"
call make.bat
%BIN%\exomizer level -c rotozoomer.prg -o ro.prg

