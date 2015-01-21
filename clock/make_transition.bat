@ECHO OFF
echo **************
echo * TRANSITION *
echo **************
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar transition.asm -o transition.prg
