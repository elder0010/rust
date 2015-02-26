@echo off
echo *********
echo * CLEAR *
echo *********
REM
REM Delete D64,PRG and SYM 
REM

set BINPATH="bin"
set BUILDPATH="build"


Echo * Main D64 *
Echo ************
call %BINPATH%\cleaner %BUILDPATH%\rust.d64

Echo * Manager *
Echo ***********
call %BINPATH%\cleaner manager\OpenerCheck\Fire
call %BINPATH%\cleaner manager\OpenerCheck
call %BINPATH%\cleaner manager

Echo * Roller *
Echo **********
call %BINPATH%\cleaner roller\risingwater
call %BINPATH%\cleaner roller

Echo * Tunnel *
Echo **********
call %BINPATH%\cleaner tunnel

Echo * Twister *
Echo ***********
call %BINPATH%\cleaner twister

Echo * Rotozoomer *
Echo **************
call %BINPATH%\cleaner rotozoomer

Echo * End tuner RL Encoder *
Echo ************************
call %BINPATH%\cleaner endtunerlenc

Echo * Clock *
Echo *********
call %BINPATH%\cleaner clock\fresh
call %BINPATH%\cleaner clock
