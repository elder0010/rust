@echo off
echo ****************
echo * -> MAKE DEMO *
echo ****************
set BINPATH="..\bin\"
set BUILDPATH="..\bin\"


del "../testbuild/rust.d64"
%BINPATH%cc1541 -S 10 -n "RUST" "../testbuild/rust.d64" -i "ONS"

%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write temp\loader.prg rust
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write temp\in.prg 01

call tentacoli\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write tentacoli\txo.prg 02

call wobbler\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write wobbler\plexer.prg 03

call postplexer\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write postplexer\fast.prg 04

call minifader\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write minifader\squ.prg 05

call chunky\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write chunky\cube.prg 06

call purpletransition\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write purpletransition\purple.prg 07

call petsciilogo\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write petsciilogo\logo.prg 08

call shaker\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write shaker\carp.prg 09

call butterfly\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write butterfly\frf.prg 10

call butterfly\make_routine_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write butterfly\btrout.prg 11

call hatgirl\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write hatgirl\hat.prg 12

call hatgirl\make_bitmaps.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write hatgirl\gra.prg 13
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write hatgirl\grb.prg 14

call hatgirl\make_sprites_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write hatgirl\sprhat.prg 15

call tetris\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write tetris\tt.prg 16

call tunnel\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write tunnel\tn.prg 17

call tunnel\make_blob_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write tunnel\tbl.prg 18

call tunnel\make_intro_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write tunnel\itn.prg 19

call tunnel\make_intro_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write temp\oun.prg 20

%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write temp\tw.prg 21
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write temp\ro.prg 22
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write temp\ms.prg 23

call clock\make_exo.bat
%BINPATH%c1541.exe ..\testbuild\rust.d64 -attach ..\testbuild\rust.d64 -write clock\en.prg 24

