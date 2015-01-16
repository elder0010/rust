@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level butterfly.prg -o frf.prg
del butterfly.prg