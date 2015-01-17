story:

//*******
// START
//*******

// Step wait: 192
// **************

:wait($1741,$18)	// Wait first SID event


// 1° step
:move(64)
:loop(8)	:barcolor(TOWHITE,%111111)
:loop(8)	:barcolor(TOWHITE,%111111)
:continue(10)
:loop(3)	:barcolor(TOBLACK,%111111)	// Lightgreen,yellow,lightgray
:loop(2)	:barcolor(TOBLACK,%110011)	// Cyan,Lightred
:loop(5)	:barcolor(TOBLACK,%100001)	// Green,Grey,Lightblue,Orange,Purple
// 1+16+20 => 192-37 => 155
:loop(8)	:continue(16)	// 128
:loop(3)	:continue(9)	// 27


// 2° step
:move(64|16|4)
:loop(8)	:multi(2)	:twistcolor(TOWHITE,BOTWISTER,%111)	:forecolor(TOWHITE,8)
:loop(8)	:multi(2)	:twistcolor(TOWHITE,BOTWISTER,%111)	:forecolor(TOWHITE,8)
:continue(10)
:loop(6)	:multi(2)	:twistcolor(TOBLACK,BOTWISTER,%111)	:forecolor(TOBLACK,8)
:loop(6)	:multi(2)	:twistcolor(TOBLACK,BOTWISTER,%111)	:forecolor(TOBLACK,8)
// 1+16+10+12 => 192-39 => 153
:loop(8)	:continue(16)	// 128
:loop(5)	:continue(5)	// 25


// 3° step
:move(64|32|16|8|4)
:loop(8)	:twistcolor(TOWHITE,UPTWISTER,%111)
:loop(8)	:twistcolor(TOWHITE,UPTWISTER,%111)
:continue(10)
:loop(8)	:twistcolor(TOBLACK,UPTWISTER,%111)
:twistcolor(TOBLACK,UPTWISTER,%111)
:loop(3)	:twistcolor(TOBLACK,UPTWISTER,%011)
:twistcolor(TOBLACK,UPTWISTER,%001)
// 1+16+10+8+1+3+1 => 192-40 => 152
:loop(8)	:continue(16)	// 128
:loop(3)	:continue(8)	// 24


// 4° step
:move(255)
:loop(8)	:twistcolor(TOWHITE,BOTWISTER,%111)	
:loop(8)	:twistcolor(TOWHITE,BOTWISTER,%111)
:continue(10)
:twistcolor(TOBLACK,BOTWISTER,%101)
:loop(5)	:twistcolor(TOBLACK,BOTWISTER,%100)
// 1+16+10+1+5 => 192-33 => 159
:loop(8)	:continue(15)	// 120
:loop(3)	:continue(13)	// 39

//********
// MIDDLE
//******** 

// 2 delays (192x5)
:loop(8)	:continue(16)
:loop(8)	:continue(16)
:loop(8)	:continue(16)
:loop(8)	:continue(16)
:loop(8)	:continue(8)


//******
// EXIT
//******

// 5° Step
:loop(8)	:twistcolor(TOWHITE,BOTWISTER,%111)	
:continue(10)
:loop(6)	:twistcolor(TOBLACK,BOTWISTER,%111)
:loop(6)	:twistcolor(TOBLACK,BOTWISTER,%111)
// 8+10+12 => 48-30 => 18
:loop(2)	:continue(9)	// 18

// 6° Step
:loop(8)	:twistcolor(TOWHITE,UPTWISTER,%111)	
:loop(5)	:twistcolor(TOWHITE,UPTWISTER,%111)	
:continue(10)
:loop(7)	:twistcolor(TOBLACK,UPTWISTER,%111)
:loop(7)	:twistcolor(TOBLACK,UPTWISTER,%111)
// 8+5+10+14 => 48-27 => 21
:loop(7)	:continue(3)	// 21

// 7° Step
:loop(6)	:multi(2)	:twistcolor(TOWHITE,BOTWISTER,%111)	:forecolor(TOWHITE,8)
:loop(6)	:multi(2)	:twistcolor(TOWHITE,BOTWISTER,%111)	:forecolor(TOWHITE,8)
:continue(10)
:loop(7)	:multi(2)	:twistcolor(TOBLACK,BOTWISTER,%111)	:forecolor(TOBLACK,8)
:loop(7)	:multi(2)	:twistcolor(TOBLACK,BOTWISTER,%111)	:forecolor(TOBLACK,8)
// 12+10+14 => 48-36 => 12
:continue(12)			// 12

// 8° Step
:loop(2)	:barcolor(TOWHITE,%111111)
:loop(8)	:barcolor(TOWHITE,%111111)
:continue(10)
:loop(7)	:barcolor(TOBLACK,%111111)
:loop(7)	:barcolor(TOBLACK,%111111)
// 2+8+10+14 => 48-34 => 14
:continue(14)				// 14

// 9° Step
:wait($1786,$24)
:loop(7)	:multi(4)	:barcolor(TOWHITE,%111111)	:twistcolor(TOWHITE,BOTWISTER,%111)	:twistcolor(TOWHITE,UPTWISTER,%111)	:forecolor(TOWHITE,%1100)
:loop(7)	:multi(4)	:barcolor(TOWHITE,%111111)	:twistcolor(TOWHITE,BOTWISTER,%111)	:twistcolor(TOWHITE,UPTWISTER,%111)	:forecolor(TOWHITE,%1100)
:continue(10)
:loop(8)	:multi(4)	:barcolor(TOBLACK,%111111)	:twistcolor(TOBLACK,BOTWISTER,%111)	:twistcolor(TOBLACK,UPTWISTER,%111)	:forecolor(TOBLACK,%1100)
:loop(8)	:multi(4)	:barcolor(TOBLACK,%111111)	:twistcolor(TOBLACK,BOTWISTER,%111)	:twistcolor(TOBLACK,UPTWISTER,%111)	:forecolor(TOBLACK,%1100)
// 1+14+10+16 => 48-41 => 7
:continue(7)				// 8

// 10° Step
:loop(2)	:forecolor(TOWHITE,%00011)
:continue(10)
:loop(8)	:forecolor(TOBLACK,%00011)
:loop(8)	:forecolor(TOBLACK,%00011)
// 2+10+16 => 48-28 => 20
:loop(2)	:continue(10)	// 20

storyend:
:stop()
