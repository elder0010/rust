@echo off
echo *********************
echo * -> SID RL ENCODED *
echo *********************
set "BIN=..\bin"
java -jar %BIN%\KickAss.jar sidcll.asm
%BIN%\exomizer level sidcll.prg -o ms.prg
