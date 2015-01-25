@echo off
REM Clean builds
REM ************
REM Usage:
REM   cleaner path
set "d64=%1%\*.d64"
set "prg=%1%\*.prg"
set "sym=%1%\*.sym"
IF EXIST %d64% del /F %d64%
IF EXIST %prg% del /F %prg%
IF EXIST %sym% del /F %sym%


