@ECHO OFF
echo **************
echo * CLOCK TEST *
echo **************
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar transition.asm -o transition.prg
java -jar %BIN%\KickAss.jar clock.asm -o clock.prg  :test=true

%BIN%\exomizer sfx basic clock.prg -o en_test.prg
del clock.prg