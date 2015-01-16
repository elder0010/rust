@ECHO OFF
SET BIN="..\bin"
call make_outro.bat
%BIN%\exomizer level outro.prg -o hatout.prg
del outro.prg