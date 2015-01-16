@ECHO OFF
SET BIN="..\bin"
call make_outro.bat
%BIN%\exomizer level outro.prg -o oun.prg
del outro.prg