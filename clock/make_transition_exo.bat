@ECHO OFF
echo ***********
echo * EXOMIZE *
echo ***********
SET BIN="..\bin"
call make_transition.bat
%BIN%\exomizer level -c transition.prg -o cll.prg
del transition.prg