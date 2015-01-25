@echo off
echo ***************
echo * ROLLER TEST *
echo ***************
set BIN="..\bin"
del in.prg
del over.prg
cd "risingwater"
java -jar "..\\%BIN%\kickass.jar" rising.asm
copy rising.prg .. /Y
cd ..
java -jar %BIN%\kickass.jar over.asm :test=true
%BIN%\exomizer sfx basic over.prg -q -o in_test.prg


