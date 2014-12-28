// FX story
// ********

.var blockfade=List()
.eval blockfade.add(2,3,4,5,6,7)
.var linefade=List()
.eval linefade.add(2,3,4,5,6)
story:

// up/lo bar => BLACK

:fade(STOP,0,BLOCK,TOWHITE,2)
:fade(STOP,0,BLOCK,TOWHITE,2)
:fade(STOP,0,BLOCK,TOWHITE,2)
:fade(STOP,0,BLOCK,TOWHITE,2)
:fade(STOP,0,BLOCK,TOWHITE,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,2)
:fade(STOP,0,BLOCK,TOBLACK,1)

// Start moving

:move(2,4)
:move(3,4)
:move(4,4)
:move(5,4)
:move(6,4)
:move(7,4)
:move(8,1)

// Fade in borders

:fade(MOVE,1,LINE,TOWHITE,2)
:fade(MOVE,1,LINE,TOWHITE,2)
:fade(MOVE,1,LINE,TOWHITE,2)
:fade(MOVE,1,LINE,TOWHITE,2)
:fade(MOVE,1,LINE,TOWHITE,2)
:fade(MOVE,1,LINE,TOWHITE,2)
:fade(MOVE,1,LINE,TOWHITE,1)
:fade(MOVE,1,LINE,TOBLACK,1)

:fade(MOVE,7,LINE,TOWHITE,2)
:fade(MOVE,7,LINE,TOWHITE,2)
:fade(MOVE,7,LINE,TOWHITE,2)
:fade(MOVE,7,LINE,TOWHITE,2)
:fade(MOVE,7,LINE,TOWHITE,2)
:fade(MOVE,7,LINE,TOWHITE,2)
:fade(MOVE,7,LINE,TOWHITE,1)
:fade(MOVE,7,LINE,TOBLACK,1)

.for(var i=0;i<6;i++) {
.if (i<5) {
	:fade(MOVE,linefade.get(i),LINE,TOWHITE,2)
	:fade(MOVE,linefade.get(i),LINE,TOWHITE,2)
	:fade(MOVE,linefade.get(i),LINE,TOWHITE,2)
	:fade(MOVE,linefade.get(i),LINE,TOWHITE,2)
	:fade(MOVE,linefade.get(i),LINE,TOWHITE,2)
	:fade(MOVE,linefade.get(i),LINE,TOWHITE,2)
}
:fade(MOVE,blockfade.get(i),BLOCK,TOWHITE,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOWHITE,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOWHITE,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOWHITE,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOWHITE,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOWHITE,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
:fade(MOVE,blockfade.get(i),BLOCK,TOBLACK,2)
.if (i>0) {
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	:fade(MOVE,linefade.get(i-1),LINE,TOBLACK,2)
	}
}
:move(6,6)
:move(4,4)
:move(2,2)
:stopall()
