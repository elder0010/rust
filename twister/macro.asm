// 1yxxxxxx => middle bar per bit fade in/out
// 01yxxxxx => upbar,bg1,bg2,lobar,ext per fade in/out
// 001ttttt => continue for t frame
// 0001 movements (TO DO)
// 00001xxx => Loop next instruction

.const	TOWHITE	=	1
.const	TOBLACK	=	0

.const	UPTWISTER	=	0
.const	BOTWISTER	=	1

// Fade bar color up or down 
// *************************
// bars is the bitmap representing each raster in the bar
.macro	barcolor(dir,bars)
{
	.byte $80|[[dir&1]*64]|[bars&63]
}

// Fade bg/raster color up or down 
// *******************************
// bars is the bitmap representing each raster/background in the screen
.macro	forecolor(dir,cols)
{
	.byte $40|[[dir&1]*32]|[cols&31]
}

// Fade twister color up or down 
// *****************************
// twist refer to up/lo twister
.macro	twistcolor(dir,twist,cols)
{
	.byte $20|[[dir&1]*16]|[[twist&1]*8]|[cols&7]
}

// Skip frames
// ***********
// Skip <frames> frames
.macro	continue(frames)
{
	.byte $10|[[frames-1]&15]
}

// Loop
// ****
// Loop <n> times next instruction (2-9)
.macro	loop(n)
{
	.byte $08|[[n-1]&7]
}

// Multi instruction
// *****************
// Execut <n> instruction in the same frame (1-4)
.macro	multi(n)
{
	.byte $04|[[n-1]&3]
}

// Wait instruction
// ****************
// Wait for <address> to reach <value>
.macro	wait(address,value)
{
	.byte $02,<address,>address,value&$ff
}

// Move instruction
// ****************
// Execut <n> instruction in the same frame (1-4)
.macro	move(move)
{
	.byte $01,<move
}

// Stop
// ****
// Stop effect
.macro	stop()
{
	.byte $00
}
