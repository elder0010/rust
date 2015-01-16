@ECHO OFF
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar plex_test.asm -o plex_test.prg
%BIN%\exomizer level plex_test.prg -o plexer.prg