@ECHO OFF
echo *********
echo * CLOCK *
echo *********
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar transition.asm -o transition.prg
java -jar %BIN%\KickAss.jar clock.asm -o clock.prg
