@ECHO OFF
SET BIN="..\bin"
call make_sprites.bat
%BIN%\exomizer level sprite_routine.prg -o sprhat.prg
del sprite_routine.prg