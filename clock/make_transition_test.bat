@ECHO OFF
echo *******************
echo * TEST TRANSITION *
echo *******************
SET BIN="..\bin"
java -jar %BIN%\KickAss.jar transition.asm -o trans_test.prg :test=true
%BIN%\exomizer sfx basic -c trans_test.prg -o cll_test.prg
del trans_test.prg