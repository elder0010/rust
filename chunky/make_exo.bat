@ECHO OFF
SET BIN="..\bin"
call make.bat
%BIN%\exomizer level -c transition\transition.prg -o cube.prg
del transition\transition.prg