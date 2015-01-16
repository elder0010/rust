@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer sfx $9800 ..\shaker\shaker.prg -o ..\shaker\shaker_exo.prg