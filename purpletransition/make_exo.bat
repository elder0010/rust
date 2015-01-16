@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level purpletransition.prg -o purple.prg
del purpletransition.prg