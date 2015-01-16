@ECHO OFF
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar assets.asm
del assets.prg
