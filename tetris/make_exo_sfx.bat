@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer sfx $7900 tetris.prg -o ..\butterfly\tetris_exo.prg