// *********
// CONSTANTS
// *********

// Screen base address
// -------------------

.const	row00	=	charscreen2+$000
.const	row01 	=	charscreen2+$028
.const	row02 	=	charscreen2+$050
.const	row03 	=	charscreen2+$078
.const	row04	=	charscreen2+$0A0
.const	row05	=	charscreen2+$0C8
.const	row06	=	charscreen2+$0F0
.const	row07	=	charscreen2+$118
.const	row08	=	charscreen2+$140
.const	row09	=	charscreen2+$168
.const	row10	=	charscreen2+$190
.const	row11	=	charscreen2+$1b8
.const	row12	=	charscreen2+$1e0
.const	row13	=	charscreen2+$208
.const	row14	=	charscreen2+$230
.const	row15	=	charscreen2+$258
.const	row16	=	charscreen2+$280
.const	row17	=	charscreen2+$2a8
.const	row18	=	charscreen2+$2d0
.const	row19	=	charscreen2+$2f8
.const	row20	=	charscreen2+$320
.const	row21	=	charscreen2+$348
.const	row22	=	charscreen2+$370
.const	row23	=	charscreen2+$398
.const	row24	=	charscreen2+$3c0

// Missing sprite & h/l buffer
// ---------------------------
.const	bfrltbl	=	$0380
.const	bfrhtbl	=	$03c0

// Char definition pointer table
// -----------------------------
.const	chartablelo	=	$0400
.const	chartablehi	=	$0500


// Basic settings
.const	firstline	=	$30
.const	frstborder	=	$31
.const	mode40		=	$c8
.const	mode38		=	$c0
.const	mode25		=	$1b
.const	mode24		=	$13

// Block directions

.const	down		=	$00
.const	left		=	$01
.const	right		=	$02
.const	up			=	$03

// Scroll behavior

.const	stop		=	$03
.const	end			=	$00

// Text/Char mode

.const	chr			= 	$00
.const	txt			= 	$01

// Constant pointers

.const	charscreen	=	$0400
.const	colorscreen	=	$d800

// *********
// VARIABLES
// *********

.const	zpbl1		=	$30
.const	zpbl2		=	$40
.const	zpbl3		=	$50
.const	zpbl4		=	$60

// Global scope

.const	fgcolor		=	$b0
.const	irqsaveacc	=	$b3
.const	irqsavex	=	$b4
.const	irqsavey	=	$b5
.const	irqsavestack=	$b6
.const	fullpos		=	$b7
.const	curpos		=	$b8
.const	speed		=	$b9
.const	kindmove	=	$ba
.const	spr0		=	$bb
.const	spr1		=	$bc
.const	spr2		=	$bd
.const	spr3		=	$be
.const	sprhi		=	$bf

// Reused variables...
.const	temp		=	$c0	// Temporary
.const	dummy		=	$c1	// "
.const	ptrmisc1	=	$c2	// "
.const	ptrmisc2	=	$c4	// "
.const	ptrmisc3	=	$c6	// "
.const	finetune	=	$c8	// Get rewritten every frame!
.const	savechar	=	$c9	// Used in putchar
.const	savey		=	$ca	// "
.const	savex		=	$cb	// "
.const	val64		=	$cc	// Value $40 for bit

// ****************************************
// * c0-f1: Range used on sprite routines *
// ****************************************

.const	charblockj	=	$a2
.const	charrightj	=	$a4
.const	charleftj	=	$a6
.const	scrollpointer	=	$a8
.const	linepointer		=	$aa
.const	textpointer		=	$ac
.const	leftpos		=	$ae
.const	rightpos	=	$af


// **************
// DATA & BUFFERS
// **************

//.var sid=LoadSid("whipe.sid")
//;.var sid=LoadSid("loop.sid")
.var sid=LoadSid("psycho.sid")
//.var microsid=LoadSid("lightforce.sid")
.var microsid=LoadSid("rusttune.sid")

.pc=sid.location "loop"
.fill sid.size, sid.getData(i)

	.import source "openmac.asm"	// Only virtual definitions (ie 0 bytes)

// ****
// CODE
// ****
.pc=$2800 "Main code"
start:
	stx retadd+1
	sty retadd+2
	sei			
	jsr negatebuffer	// Negate chars
	jsr preparebuffer	// Init buffers (LO/HI and charcode)
	jsr switchscreen	// Ok, we can switch to bank 1
	jsr	setchartbl		// Build some precalc table
	jsr setbuftbl		// Build temporary buffer
	jsr preparebufferpointers	// Create first sprite position
	jsr initvar			// Miscellaneous var init
	jsr initsprite		// Sprite initialization
	jsr microsid.init	
	jsr stabletimer		// GO!
	cli
	jmp *
	
// Executed in stable raster
// *************************
mainirq:
	stx irqsavex		// 3
	sty irqsavey		// 3
	tsx					// 2		
	stx irqsavestack
	lda #<[spriteLL1/$40]
	sta charscreen2+$3fc
	lda #<[spriteL1/$40]
	sta charscreen2+$3fd
	lda #<[spriteR1/$40]
	sta charscreen2+$3fa
	lda #<[spriteRR1/$40]
	sta charscreen2+$3fb
	ldy #mode25			// 2	4		
	lda #mode40			// 2
	sta $d016			// 4 ACC = 40 column mode
	ora finetune		// 2	
	ldx #mode38			// 2
	txs					// 2 S/X = 38 column mode	
	sty $d011			// 4 29						
	
.const	fixjmp=*+1
	jmp (charblockj)	// 6w	// Full screen move to *Right*
backtoirq:
	ldx irqsavestack
	txs
	lda #$00
	sta $d015
	ldy fixjmp
	cpy #charblockj
	beq dontupdatesprite
	
	ldx #$30		// Enable charrom
	stx $01	
	ldx kindmove
	cpy #charleftj
	beq goleft	

	lda rsequence,x	// Update sprite right direction
	sta kindmove	
	ora #<rmrjmptbl
	sta jmprmr+1		
	ldx rightpos
	dex
	txa
	and #$3f
	sta rightpos	
	lda rightpos	
jmprmr:
	jmp (rmrjmptbl)	// Speedcode right sprite direction
goleft:
	lda #$0a		// Update sprite right direction
	sbc kindmove
	ora #<rmljmptbl
	sta jmprml+1
	lda lsequence,x
	sta kindmove		
	ldx rightpos
	inx
	txa
	and #$3f
	sta rightpos	
	adc #$16	
jmprml:
	jmp (rmljmptbl)	// Speedcode left sprite direction	
backfromrm:
	lda #$35
	sta $01			// Update sprite left direction		
	
dontupdatesprite:	
	lda #$3c
	sta $d015
	lda curpos	
	sta finetune	
	lda spr0
	ora finetune
	sta $d004
	lda spr1	
	ora finetune
	sta $d006
	lda spr2	
	ora finetune
	sta $d008
	lda spr3	
	ora finetune
	sta $d00a	
	lda sprhi
	sta $d010
	
	// Check position for scroll
	// -------------------------
	
	lax fullpos
	clc
	adc speed
	sta fullpos	
	lsr
	alr #$0e
	sta curpos	
	ldy #charblockj
	txa
	eor fullpos
	and #$20
	beq skipmove
	lda fullpos
	and #$9f
	sta fullpos 
	ldy #charleftj	
	bit speed
	bmi skipmove
	ldy #charrightj
skipmove:	
	sty fixjmp
	
	// Check "joy" for speed change
	// ----------------------------
	
	lda joy	
	ldx speed
	alr #$03
	bcs joyleft
	dex
	cpx #$df
	bne noof
	ldx #$E0	
	bne noof
joyleft:	
	bne noof
	inx
	cpx #$21
	bne noof
	ldx #$20	
noof:
	stx speed
	
	lda #frstborder
	sta $d005
	sta $d007
	sta $d009
	sta $d00b
	
	// Block list control routine
	// --------------------------
	
	ldy #$00
	dec blockcount
	bne blockok
	inc linepointer
	bne !+
	inc linepointer+1
!:		
	lda (linepointer),y
	bit val64
	beq !+
	and #$1f
	sta $d418
	lda #block(right,1,chr)	
!:	
	sta blockdirection	
	lsr
	alr #$3e
	sta blockcount
blockok:

	// Putchar (possibly update position)
	// ----------------------------------

	lda (textpointer),y
	ldx blockX
	ldy blockY
	jsr putchar
	lax blockdirection	
	bpl !+
	inc textpointer
	bne !+
	inc textpointer+1
!:
	
	// Cursor position update
	// ----------------------
	
	txa
	ldx blockX
	ldy blockY	
	and #$03
	asl
	sta movecurs+1
movecurs:	
	bpl movecurs
	iny	
	.byte $29	
	dex
	.byte $29				
	inx
	.byte $29		
	dey
	stx blockX
	sty blockY
	
	// Scroll speed update
	// -------------------
	
	dec scrollwait
	bne skipscrupd
	inc scrollpointer
	bne !+
	inc scrollpointer+1
!:	
	ldy #$00
	lda (scrollpointer),y
	sta joy
	lsr
	lsr
	sta scrollwait
	lda joy
	and #$03	
	beq stopeffect	
skipscrupd:	

	// IRQ END
	// -------
	
	jsr microsid.play
	ldy irqsavey
	ldx irqsavex
	lda irqsaveacc	
	jmp $dc0c		

	
// Initialization routines
// -----------------------
	
.print "IRQ: " + toHexString(start) + " - " + toHexString(*)
	
stopeffect:
	sei
	lda $dc0d
	lda #$7f
	sta $dc0d
	lda #$00
	sta $d012
	lda #$01
	sta $d01a
	lda #$c8
	sta $d016
	lda #$1b
	sta $d011	
retadd:
	jmp *


// ************************
// Variables initialization
// ************************
	
initvar:
	lda #$40
	sta val64
	lda #mode40
	sta temp
	lda #$28
	sta rightpos
	lda #$00
	sta leftpos	
	lda #$02
	sta kindmove
	lda #$00
	sta curpos
	sta finetune
	sta fullpos
	lda #$00
	sta speed
	lda #<openblocked
	sta charblockj
	lda #>openblocked
	sta charblockj+1
	lda #<openmoveright
	sta charrightj
	lda #>openmoveright
	sta charrightj+1
	lda #<openmoveleft
	sta charleftj
	lda #>openmoveleft
	sta charleftj+1	
	lda #<[scrolltable-1]
	sta scrollpointer
	lda #>[scrolltable-1]
	sta scrollpointer+1	
	lda #<[linetable-1]	
	sta linepointer
	lda #>[linetable-1]
	sta linepointer+1	
	lda #<[text]	
	sta textpointer
	lda #>[text]
	sta textpointer+1	
	rts

// Change to bank 1 screen
// -----------------------	
	
switchscreen:	
!:
	lda $d011
	bmi !-
!:
	lda $d011
	bpl !-	
	lda #[floor([charrom-[charrom&$C000]]/$400)]|[16*floor([charscreen2-[charscreen2&$C000]]/$0400)]
	sta $d018	
	lda $dd00
	and #$fc
	ora #[[3-floor(charrom/$4000)]|$c4]
	sta $dd00
	lda $d021
	sta fgcolor
	ldx $d020
	stx $d021	
	ldx #$00
!:
	.for (var i=0;i<4;i++)
		sta colorscreen+$100*i,x
	dex
	bne !-
	lda #$3c
	sta $d015	
	rts
	
	
// Prepare copy buffer
// -------------------

preparebufferpointers:
	ldx #$3F
pbp_loop:
	ldy buffer+$0000,x
	lda chartablelo,y
	sta bufferlo+$0000,x
	lda chartablehi,y
	sta bufferhi+$0000,x	
	dex
	bpl pbp_loop
	ldx #$3F	
	clc
	lda pbp_loop+1
	adc #$40
	sta pbp_loop+1
	lda pbp_loop+2
	adc #$00
	sta pbp_loop+2		
	lda pbp_loop+7
	adc #$40
	sta pbp_loop+7
	lda pbp_loop+8
	adc #$00
	sta pbp_loop+8				
	lda pbp_loop+13
	adc #$40
	sta pbp_loop+13
	lda pbp_loop+14
	adc #$00
	sta pbp_loop+14
	lda pbp_loop+2
	cmp #>[buffer+$640]
	bne pbp_loop
	lda pbp_loop+1
	cmp #<[buffer+$640]
	bne pbp_loop		
	rts	

	
.print "Main block code: " + toHexString(stopeffect) + " - " + toHexString(*)
	
// **************
// * Inclusions *
// **************
.align $0100
// Buffer main
buffer:
.fill 64*25,160
.print "Buffer: " + toHexString(buffer) + " - " + toHexString(*)

// Initialize sprite	
	
initsprite:	
	lda #floor([emptysprite&$3fff]/$40)
	sta charscreen2+$3fa
	sta charscreen2+$3fb
	sta charscreen2+$3fc
	sta charscreen2+$3fd
	lda #$68
	sta $d004
	sta spr0
	lda #$50
	sta $d006
	sta spr1	
	lda #$f0
	sta $d008
	sta spr2
	lda #$10
	sta $d00a	
	sta spr3
	lda #$1C
	sta $d010
	sta sprhi
	lda #frstborder
	sta $d005
	sta $d007	
	sta $d009
	sta $d00b
	lda #$00
	sta $d017	
	ldx fgcolor	
	stx $d029	
	stx $d02a	
	stx $d02b	
	stx $d02c	
	lda #$00
	sta $d01c
	ldx #$30
	stx $01	
	lda #$27
	jsr preparepointers		
	jsr updatespriteRR1
	lda #$26
	jsr preparepointers		
	jsr updatespriteR3
	ldx #$35
	stx $01		
	rts

// Buffer pointers
.align $0100
bufferlo:
.fill 64*25,<[160*8]
.print "Buffer (LO): " + toHexString(bufferlo) + " - " + toHexString(*)


// SetCharTbl
// ----------
setchartbl:
	lda #<charrom	
	ldy #>charrom	
	ldx #$00
sctloop:		
	sta chartablelo,x
	clc
	adc #$08	
	sta sctval+1
	tya
	sta chartablehi,x		
	bcc !+
	iny
!:
sctval:
	lda #$00
	inx
	bne sctloop
	rts


// Prepare copy buffer
// -------------------
preparebuffer:
	ldx #$27
pb_loop:		
	lda row00,x
	sta buffer+$0000,x	
	lda row01,x
	sta buffer+$0040,x
	lda row02,x
	sta buffer+$0080,x
	lda row03,x
	sta buffer+$00C0,x
	lda row04,x
	sta buffer+$0100,x	
	lda row05,x
	sta buffer+$0140,x
	lda row06,x
	sta buffer+$0180,x
	lda row07,x
	sta buffer+$01C0,x	
	lda row08,x
	sta buffer+$0200,x		
	lda row09,x
	sta buffer+$0240,x
	lda row10,x
	sta buffer+$0280,x
	lda row11,x
	sta buffer+$02C0,x	
	lda row12,x
	sta buffer+$0300,x	
	lda row13,x
	sta buffer+$0340,x
	lda row14,x
	sta buffer+$0380,x
	lda row15,x
	sta buffer+$03C0,x	
	lda row16,x
	sta buffer+$0400,x			
	lda row17,x
	sta buffer+$0440,x
	lda row18,x
	sta buffer+$0480,x
	lda row19,x
	sta buffer+$04C0,x	
	lda row20,x
	sta buffer+$0500,x
	lda row21,x
	sta buffer+$0540,x
	lda row22,x
	sta buffer+$0580,x
	lda row23,x
	sta buffer+$05C0,x	
	lda row24,x
	sta buffer+$0600,x		
	dex
	bmi pb_cont
	jmp pb_loop
pb_cont:
	rts

.print "Fragmented code 2: " + toHexString(preparebuffer) + " - " + toHexString(*)
	
.align $0100
bufferhi:
.fill 64*25,>[[160*8]+charrom]
.print "Buffer (HI): " + toHexString(bufferhi) + " - " + toHexString(*)

// Screen
.align $0800
charrom:
.fill $0800,0
charscreen2:
.fill $0400,0

.print "Charscreen: "+toHexString(charscreen2)
.print "Charrom: "+toHexString(charrom)

.import source "timer.asm"
.print "Timer: " + toHexString(pcadr) + " - " + toHexString(*)

.pc=$4e60

// putchar on screen/buffer
pcadr:
.import source "putchar.asm"
.print "Putchar: " + toHexString(pcadr) + " - " + toHexString(*)

// sprite definitions
overspr:
.import source "overspr.asm"
.print "Sprites: " + toHexString(overspr) + " - " + toHexString(*)

// action table
.import source "actiontable.asm"
.print "Action Table: "+toHexString(*)

// open sideborder + move char right
.import source "openmoveright.asm"
.print "OpenMoveRight: "+toHexString(*)

// base sprite routines
spritertn:
.import source "spritertn.asm"
.print "SpriteRtn: " + toHexString(spritertn) + " - " + toHexString(*)

.align $0200	// Fix $3fff bug!

// open sideborder + move char left
.import source "openmoveleft.asm"
.print "OpenMoveLeft: "+toHexString(*)

// open sideborder + stay
.import source "openblocked.asm"
.print "OpenBlocked: "+toHexString(*)

// sprite copy routines
.import source "chartosprite.asm"	
.print "CharToSprite: "+toHexString(*)

.pc=$ef00 "Micro SID"

.pc=microsid.location "Lightforce (SID)"
.fill microsid.size, microsid.getData(i)


.pc=$F940	"Trasition"
.import c64 "rising.prg"	//Transition
