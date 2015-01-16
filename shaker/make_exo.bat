@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level shaker.prg -o carp.prg
del shaker.prg