@echo off
echo ******************
echo * SID RL ENCODED *
echo ******************
set "BIN=..\bin"
REM Create difference file runlength encoded
diffsid ..\SID\psycho.sid ..\SID\rust_outro.sid
REM Compile transition
cd ..\clock
java -jar %BIN%\KickAss.jar transition.asm
cd ..\endtunerlenc
REM Compile block
java -jar %BIN%\KickAss.jar sidcll.asm
REM Compress...
%BIN%\exomizer level sidcll.prg -o ms.prg
