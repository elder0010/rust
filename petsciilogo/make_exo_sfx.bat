@ECHO OFF
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar ..\purpletransition\purpletransition.asm -o ..\purpletransition\purpletransition.prg
%BIN%\exomizer sfx $9800 ..\purpletransition\purpletransition.prg -o ..\purpletransition\purple_exo.prg