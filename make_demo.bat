@echo off
echo *************
echo * MAKE DEMO *
echo *************
set BINPATH="bin"
set BUILDPATH="build"
set MAKEALL=1


del %BUILDPATH%\rust.d64
%BINPATH%\cc1541 -S 10 -n "RUST" %BUILDPATH%\rust.d64 -i "ONS"

call %BINPATH%\inmake.bat manager make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write manager\loader.prg rust

call %BINPATH%\inmake.bat roller make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write roller\in.prg 01

call %BINPATH%\inmake.bat tentacoli make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write tentacoli\txo.prg 02

call %BINPATH%\inmake.bat wobbler make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write wobbler\plexer.prg 03

call %BINPATH%\inmake.bat postplexer make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write postplexer\fast.prg 04

call %BINPATH%\inmake.bat minifader make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write minifader\squ.prg 05

call %BINPATH%\inmake.bat chunky make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write chunky\cube.prg 06

call %BINPATH%\inmake.bat purpletransition make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write purpletransition\purple.prg 07

call %BINPATH%\inmake.bat petsciilogo make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write petsciilogo\logo.prg 08

call %BINPATH%\inmake.bat shaker make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write shaker\carp.prg 09

call %BINPATH%\inmake.bat butterfly make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write butterfly\frf.prg 10

call %BINPATH%\inmake.bat butterfly make_routine_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write butterfly\btrout.prg 11

call %BINPATH%\inmake.bat hatgirl make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write hatgirl\hat.prg 12

call %BINPATH%\inmake.bat hatgirl make_bitmaps.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write hatgirl\gra.prg 13
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write hatgirl\grb.prg 14

call %BINPATH%\inmake.bat hatgirl make_sprites_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write hatgirl\sprhat.prg 15

call %BINPATH%\inmake.bat tetris make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write tetris\tt.prg 16

call %BINPATH%\inmake.bat tunnel make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write tunnel\tn.prg 17

call %BINPATH%\inmake.bat tunnel make_blob_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write tunnel\tbl.prg 18

call %BINPATH%\inmake.bat tunnel make_intro_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write tunnel\itn.prg 19

call %BINPATH%\inmake.bat tunnel make_outro_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write tunnel\oun.prg 20

call %BINPATH%\inmake.bat twister make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write twister\tw.prg 21

call %BINPATH%\inmake.bat rotozoomer make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write rotozoomer\ro.prg 22

call %BINPATH%\inmake.bat endtunerlenc make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write endtunerlenc\ms.prg 23

call %BINPATH%\inmake.bat clock make_exo.bat
%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write clock\en.prg 24

%BINPATH%\c1541.exe %BUILDPATH%\rust.d64 -attach %BUILDPATH%\rust.d64 -write note\note.prg note
