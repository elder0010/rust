// **************************
// Fast chunky implementation
// Freshness - 2013
// **************************

// Usage:
// Import source and:
// - call 	"prechunky"
// - call	"startchunky"
// Make sure you're in full RAM mode (only I/O present) and there's a valid IRQ handler in $fffe/$ffff

// Configurable parameters:

.const	vicbank	=	1	// VIC bank (0,1,2,3)
.const	order	=	1	// Order (1,2)
// Se 1: bitmap $0000-$1fff, LUTs $2000-$3000	- Free zone: $3600-$3fff
// Se 2: bitmap $2000-$3fff, LUTs $0000-$1000	- Free zone: $1600-$1fff 


// Constants
// *********
.const	raster	=	$1C
.const	t8lines	=	63*8-1
.const	tjitter	=	9-1
.const	v1both	=	$37+[order==1 ? $80:$08]
.const	v2d018	=	$17+[order==1 ? $80:$08]
.const	v2d011	=	$33+[order==1 ? $08:$00]

// Zero page variables
// *******************
.const	temp	=	$30	// 1 byte
.const	frstrst	=	$32	// 1 byte
.const	saveacc	=	$33	// 1 byte
.const	irqback	=	$34	// 2 byte
.const	pointer	=	$36	// 2 byte

.import source "variables.asm"

// *******************************************
// Initialization routine (Screen/Environment)
// *******************************************

.pc=[[vicbank*$40]+[order==1 ? $20:$00]+$10]*$100	"Main chunky code"
prechunky:	
	lda #$00
	sta stopchunky
	sta stopstatus
	lda $fffe			// Save IRQ vectors
	sta irqback
	lda $ffff
	sta irqback+1	
	jsr installstackjt	// Prepare (part of the) stack to be used as jumptable
	jsr preparescreen	// Prepare bitmap RAM for chunky
	rts	
	
// *************************
// Chunky activation routine
// *************************

startchunky:
!:
	bit $d011
	bmi !-
!:
	bit $d011
	bpl !-
	sei	
	lda #<fstirq
	ldx #>fstirq
	sta $fffe
	stx $ffff	
	lda #$01
	sta $d01a
	lda #raster
	sta frstrst
	sta $d012	
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda $dc0d
	lda $dd0d
	lsr $d019	
	lda $dd00
	and #$fc
	ora #[3-vicbank]
	sta $dd00
	lda #$d8
	sta $d016	
	cli
	rts

// ************************************************************************
// Double raster IRQ routine
.print "Double raster stab - First IRQ: "+toHexString(*)
fstirq:
	stx savex+1
	sta savea+1
	lda #<secirq
	sta $fffe
	lsr $d019
	inc $d012
	cli
	tsx
	.fill 15,NOP		
	brk

	
.print "Double raster stab - 2nd IRQ: "+toHexString(*)
secirq:
	lda #<$dd05		// Set NMI handler on timer
	sta $fffa
	lda #>$dd05	
	sta $fffb			
	lsr $d019		// IRQ Acknowledge
	lda #raster		// Set next raster irq
	sta $d012			
	lda #$00		// Reset timers A and B
	sta $dd0e
	sta $dd0f
	lda #<t8lines
	sta $dd06
	lda #>t8lines
	sta $dd07		
	lda #raster+1
	txs				// Reload correct stack pointer
	cmp $d012		//4 - 63+0/1
	beq synced		//2/3
synced:
	lda #$6c
	sta $dd05
	lda #$00
	sta $d01a	
	sta $dd0e	
	lda #$82
	sta $dd0d	
	lda #RTI
    sta $DD0C  
	bit $ea
	lda #$91
	sta $dd0f
	lda #<bottomirq
	sta $fffe
	lda #>bottomirq
	sta $ffff
	lda #$01
	sta $d01a
	lda #$fc
	sta $d012
	sty savey+1
	jsr $1003
savey:
	ldy #$00
savex:
	ldx #$00
savea:
	lda #$00	
	rti

// *********************
// Bottom IRQ - Stop NMI
// *********************
bottomirq:
	pha	
	lsr $d019	
	lda #<serviceirq
	sta $fffe
	lda #>serviceirq
	sta $ffff
	lda #$00
	sta $d012
	lda #$7f
	sta $dd0d	
	pla
	rti
	
// ******************
// Top IRQ - Stop NMI
// ******************
topirq:
	pha
	lsr $d019
	lda #<bottomirq
	sta $fffe
	lda #>bottomirq
	sta $ffff
	lda #$fc	
	sta $d012
	lda stopstatus	
	bne !+
	lsr stopchunky	
	rol stopstatus	
	bne !+	
	lda $dd0d
	lda #$82
	sta $dd0d
!:
	lsr flippage
	bcc v2eventop
	jsr switchscreen
v2eventop:	
	lda #v2d018
	sta $d018
	lda #$3b
	sta $d011	
	pla
	rti	
	
// ********************************
// Service IRQ (called by raster 0)
// ********************************
serviceirq:
	pha	
	lsr $d019
	lda #>bfservice
	pha
	lda #<bfservice
	pha
	php	
	lda #<topirq
	sta $fffe
	lda #>topirq
	sta $ffff	
	lda #46
	sta $d012
	cli
	jmp (irqback)
bfservice:		
	pla
	rti		
	
// Jitteing management routines
// ****************************
// $x5x5 +0 Max delay
// $x4x5 +1
// $x5x4 +2
// $x3x5 +3
// $x5x3 +4
// $x2x5 +5
// $x5x2 +6
// $x1x5 +7 Min delay

// Added delay: 7	
// *******************
.pc=[[vicbank*$40+[order==1 ? $20:$00]+$11]*$100+vicbank*$40+[order==1 ? $20:$00]+$15]	"Routine for jitter 7"	
	jmp [[vicbank*$40+[order==1 ? $20:$00]+$15]*$100+vicbank*$40+[order==1 ? $20:$00]+$13]

.print "Inbetween code 1: "+toHexString(*)
.import source "chunky_functions.asm"
	
// Added delay: 5
// *******************
.pc=[[vicbank*$40+[order==1 ? $20:$00]+$12]*$100+vicbank*$40+[order==1 ? $20:$00]+$15]	"Routine for jitter 5"	
	jmp [[vicbank*$40+[order==1 ? $20:$00]+$15]*$100+vicbank*$40+[order==1 ? $20:$00]+$14]

// Move koala
// **********
movekoala:
	ldy #$00					// Copy charscreen 2/3/4
!:
	.for (var i=0;i<4;i++) {
		lda $6c00+i*$100,y
		sta $6000+i*$100,y
		sta $6400+i*$100,y
		sta $6800+i*$100,y
	}
	dey
	bne	!-
	rts	
	

// Prepare bitmap for chunky
// *************************
.print "Inbetween code 2: "+toHexString(*)

preparescreen:
	php	
	lda #$a5
	ldy #00
!:
	.for(var i=floor(YOFFSET/2);i<floor([SIZEY+YOFFSET]/2);i++)
		sta $4000+i*320+XOFFSET*8,y	
	iny
	cpy #[SIZEX*4]
	bne !-	
	plp
	rts
		
// Added delay: 3
// *******************
.pc=[[vicbank*$40+[order==1 ? $20:$00]+$13]*$100+vicbank*$40+[order==1 ? $20:$00]+$15]	"Routine for jitter 3"	
	jmp [[vicbank*$40+[order==1 ? $20:$00]+$15]*$100+vicbank*$40+[order==1 ? $20:$00]+$15]

.import source "math.asm"
	
// Added delay: 1
// *******************
.pc=[[vicbank*$40+[order==1 ? $20:$00]+$14]*$100+vicbank*$40+[order==1 ? $20:$00]+$15]	"Routine for jitter 1"	
	sta.a saveacc	
v1odd:
	lda #v1both
	sta $d018
	lda #[v1both|8]
	sta $d011	
	lda #v2d011
	sta $d011
v2odd:	
	lda #v2d018
	sta $d018	
	lda saveacc
	jmp $dd0c	

// Jump table to be copied on stack
// ********************************
jumptable:
.byte	vicbank*$40+[order==1 ? $20:$00]+$15,vicbank*$40+[order==1 ? $20:$00]+$15,vicbank*$40+[order==1 ? $20:$00]+$14
.byte	vicbank*$40+[order==1 ? $20:$00]+$15,vicbank*$40+[order==1 ? $20:$00]+$13,vicbank*$40+[order==1 ? $20:$00]+$15
.byte	vicbank*$40+[order==1 ? $20:$00]+$12,vicbank*$40+[order==1 ? $20:$00]+$15,vicbank*$40+[order==1 ? $20:$00]+$11

// Flip screen (for double buffering)
// **********************************
switchscreen:
	lda v2even+1
	eor #$10
	sta v2even+1
	sta v2eventop+1
	sta v2odd+1	
	lda v1even+1
	eor #$10
	sta v1even+1
	sta v1odd+1
	rts

// Move current stack to get room for the jump table
// *************************************************
installstackjt:
	sei
	ldx #$00		// Move down stack
!:
	lda $0119,x
	sta $0100,x
	inx
	cpx #$e8
	bne !-	
	tsx				// Update stack pointer
	txa
	axs #$19		
	txs
	ldx #$08		// Copy jumptable
!:
	lda jumptable,x
	sta $01e7,x
	dex
	bpl !-
	cli
	rts	
	
// Added delay: 0/2/4/6
// *************************
.pc=[[vicbank*$40+[order==1 ? $20:$00]+$15]*$100+vicbank*$40+[order==1 ? $20:$00]+$12]	"Jitter routines: 8,6,4,2"	
	nop
	nop
	nop	
	sta saveacc	// 3 + 7 (IRQ) + 7 (Jitter) + 5 (jmp indirect)
v1even:
	lda #v1both	// 2	
	sta $d018	// 4
	lda #[v1both|8]
	sta $d011	// 4 + 40 (Bad line)
	lda #v2d011	// 2
	sta $d011	// 4
v2even:	
	lda #v2d018	// 2
	sta $d018	// 4
	lda saveacc	// 3	
	jmp $dd0c	// 3 + 7 (RTI) => 97

.pc=$75a0	"Import fader"
.import source "fade.sym"
.import c64 "fade.prg"
.import source "upblock.asm"
