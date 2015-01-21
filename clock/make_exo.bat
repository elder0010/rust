@ECHO OFF
echo ***********
echo * EXOMIZE *
echo ***********
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level clock.prg -o en.prg
del clock.prg