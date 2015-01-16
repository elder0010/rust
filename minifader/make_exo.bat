@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level minifader.prg -o squ.prg
del minifader.prg