@ECHO OFF
SET BIN="..\bin"
call make_blob.bat
%BIN%\exomizer level -c blob.prg -o tbl.prg
del blob.prg
del blob.sym