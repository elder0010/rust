# Rust

![Rust](http://csdb.dk/gfx/releases/125000/125612.png "Rust")

A demo for the Commodore 64 by Onslaught

### Provided in the repository
- 6502 Assembly Source code ([Kick Assembler] format)
- Executable binaries
- Windows make procedure

### Compiling

You'll need [Java] to compile. To check if you have it use this command:
```
java -version
```
To compile the whole demo, simply use the included make procedure:
```
make_demo.bat
```
Each scene folder has an internal "make" command to compile it. for example:
```
postplexer\make.bat
```
### Todo's
- Translate all comments to English
- Makefile for Linux / OSX

### Credits
- Elder0010 - Code
- Freshness - Code
- Psycho8580- Music
- CONS - Graphics
- AlmightyGod - Graphics
- Raina - Graphics
- Adam - Graphics

### Notes
The make_demo.bat creates a working copy of the program, but the directory art will not be automatically added to the .d64: you will need to do this manually. You will find the directory_art.d64 to use in the \bin folder.

### External links
[Rust on CSDB]
[Onslaught Homepage]

**Free Software, Hell Yeah!**

[Kick Assembler]:http://www.theweb.dk/KickAssembler/Main.php
[Java]:http://java.com/en/download/index.jsp
[Rust on CSDB]:http://csdb.dk/release/?id=125612
[Onslaught Homepage]:http://www.atlantis-prophecy.org/onslaught/