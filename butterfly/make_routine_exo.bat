@ECHO OFF
SET BIN="..\bin"
call make_routine.bat
%BIN%\exomizer level -c butterfly_routine.prg -o btr.prg
del butterfly_routine.prg