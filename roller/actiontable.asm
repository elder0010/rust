// Action tables:

// SCROLLTABLE
// -----------
// Scroll function has the following parameters:
// - timing: how long (in frame) does the action last (0-63)
// - action: left/stop/right/end
// The table basically is a set of "left/stop/right" and must be terminated with "end"

scrolltable:
.byte	scroll(4,left),scroll(4,stop),scroll(28,left)	// "Aligned" scroll (fix full border left bug)
.byte	scroll(63,stop),scroll(63,stop)
.byte	scroll(60,stop),scroll(48,stop)

.for(var i=0;i<3;i++) {
	.byte	scroll(63,right),scroll(1,right)	// "Aligned" scroll (fix full border left bug)
	.byte	scroll(58,stop),scroll(48,stop)

	.byte	scroll(63,left),scroll(1,left)		// "Aligned" scroll (fix full border left bug)
	.byte	scroll(58,stop),scroll(48,stop)
}

.byte	scroll(37,stop)
.byte	scroll(12,right)
.byte	scroll(1,stop)
.byte	scroll(20,right)
.byte	scroll(1,end)

// 63+1+63+63+63+61+1 => 315 -> 1011

// LINETABLE
// ---------
// Block function has the following parameters:
// - direction: writing direction left/right/up/down
// - number: character number (0-31)
// - type: chr (PETSCII $A0), txt (characters loaded from text label)
// Volume function has the following parameters:
// - volume: set volume to this value
// Beware, there's no terminator: effect total lenght should match scrolltable


linetable:
.for(var i=0;i<5;i++) {
	// Descending spirals
	.byte block(right,3+[i!=0?1:0],chr),block(down,3,chr),block(left,2,chr),block(up,1,chr),block(right,1,chr),block(up,1,chr),block(left,2,chr),block(down,3,chr)
	.byte block(right,3,chr),block(down,3,chr),block(left,2,chr),block(up,1,chr),block(right,1,chr),block(up,1,chr),block(left,2,chr),block(down,3,chr)
	.byte block(right,3,chr),block(down,3,chr),block(left,2,chr),block(up,1,chr),block(right,1,chr),block(up,1,chr),block(left,2,chr),block(down,3,chr)
	.byte block(right,3,chr),block(down,3,chr),block(left,2,chr),block(up,1,chr),block(right,1,chr),block(up,1,chr),block(left,2,chr),block(down,3,chr)
	.byte block(right,3,chr),block(down,3,chr),block(left,2,chr),block(up,1,chr),block(right,1,chr),block(up,1,chr),block(left,2,chr),block(down,3,chr)
	.byte block(right,3,chr),block(down,3,chr),block(left,2,chr),block(up,1,chr),block(right,1,chr),block(up,1,chr),block(left,2,chr),block(down,3,chr)
	// Lasto row connection
	.byte block(right,7,chr),block(up,1,chr)
	// Ascending spirals
	.byte block(left,3,chr),block(up,3,chr),block(right,2,chr),block(down,1,chr),block(left,1,chr),block(down,1,chr),block(right,2,chr),block(up,3,chr)
	.byte block(left,3,chr),block(up,3,chr),block(right,2,chr),block(down,1,chr),block(left,1,chr),block(down,1,chr),block(right,2,chr),block(up,3,chr)
	.byte block(left,3,chr),block(up,3,chr),block(right,2,chr),block(down,1,chr),block(left,1,chr),block(down,1,chr),block(right,2,chr),block(up,3,chr)
	.byte block(left,3,chr),block(up,3,chr),block(right,2,chr),block(down,1,chr),block(left,1,chr),block(down,1,chr),block(right,2,chr),block(up,3,chr)
	.byte block(left,3,chr),block(up,3,chr),block(right,2,chr),block(down,1,chr),block(left,1,chr),block(down,1,chr),block(right,2,chr),block(up,3,chr)
	.byte block(left,3,chr),block(up,3,chr),block(right,2,chr),block(down,1,chr),block(left,1,chr),block(down,1,chr),block(right,2,chr),block(up,2,chr)
}

.byte block(down,10,chr)
.byte block(left,5,txt),block(down,1,txt)
.byte block(right,4,txt),block(down,1,txt)
.byte block(left,4,txt),block(down,1,txt)
.byte block(right,4,txt),block(down,1,txt)
.byte block(left,4,txt),block(down,1,txt)

.byte block(down,1,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,9,chr),volume($1e),block(right,9,chr),volume($1d)
.byte block(left,9,chr),volume($1c),block(right,9,chr),volume($1b)
.byte block(left,9,chr),volume($1a),block(right,9,chr),volume($19)
.byte block(left,9,chr),volume($18),block(right,9,chr),volume($17)
.byte block(left,9,chr),volume($16),block(right,9,chr),volume($15)
.byte block(left,9,chr),volume($14),block(right,9,chr),volume($13)
.byte block(left,9,chr),volume($12),block(right,9,chr),volume($11)
.byte block(left,9,chr),volume($10),block(right,9,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,15,chr),block(right,15,chr)
.byte block(left,15,chr),block(right,15,chr)

// TEXT
// ----
// Put text e/o characters to be used on linetable (they'll be loaded sequentially)

text:
.byte 160
.byte	95,32,32,32,105
.byte	32,85,91,73,32
.byte	32,115,86,107,32
.byte	32,74,113,75,32
.byte	233,32,32,32,223
.byte	160

// Misc Variables
// --------------

blockdirection:
.byte	$00
blockcount:
.byte	$01
blockX:
.byte	$00
blockY:
.byte	$00

scrollwait:
.byte $01
joy:
.byte stop

