@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level test.prg -o txo.prg
