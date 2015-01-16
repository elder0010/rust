@ECHO OFF
SET BIN="..\bin"
call make_intro.bat
%BIN%\exomizer level intro.prg -o itn.prg
del intro.prg