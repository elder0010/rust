@echo off
echo **********
echo * ROLLER *
echo **********
set BIN="..\bin"
del in.prg
del over.prg
cd "risingwater"
java -jar "..\\%BIN%\kickass.jar" rising.asm
copy rising.prg .. /Y
cd ..
java -jar %BIN%\kickass.jar over.asm
%BIN%\exomizer level over.prg -q -o in.prg


