@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer sfx $9800 shaker.prg -o shaker_exo.prg