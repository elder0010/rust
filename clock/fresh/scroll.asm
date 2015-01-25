//.var wob_pic_x=0
//.var wob_pic_y=0

// Ricordarsi di commentare l'import source "text" alla fine del file
// per compilare la versione da usare

.var TEST_MODE2=0

// Memory configuration
// ********************
.const	orgvidbuffer	=	$6800	// Original charscreen
.const	videobuffer1	=	$6400	// First charscreen
.const	videobuffer2	=	$6000	// Second charscreen
.const	bitmap			=	$4000	// Koala bitmap
.const	spritebase		=	$6a00	// Sprite wall definition area
.const	fontptrlo		=	$6800	// Computed font lookup table (LO)
.const	fontptrhi		=	$6900	// Computed font lookup table (HI)
.const	font8x8			=	$3800	// Special 8/16 charset ($800)
.const	sprptrlo		=	$0400	// Computer sprite base lookup table (LO)
.const	sprptrhi		=	$0500	// Computer sprite base lookup table (HI)
.const	scrolltext		=	$e000	// Scroller text
.const	textbuffer		=	$0600	// Text buffer

// Customizable constants
// **********************
.var	usedsprites		=	List().add(0,1,2,3,4,5,7)
.var	minval			=	21						// Minimum Y value
.var	spriterows		=	12						// Sprite rows number
.var	FONTCOLOR		=	WHITE					// Sprite color
.var	StartSpeed		=	$40						// Scroll programmed speed
.var	SPEED			=	1						// Scroll real speed
.var	spacechar		=	$20						// Code for empty block
.var	NChar			=	45

// Zero page variables
// *******************

// IRQ helpers
// ***********
.var savea		=	$d0
.var savex		=	$d1
.var savey		=	$d2

// Routine helpers
// ***************
.var tempx		=	$d3


.var xexpfont		=	$d4
.var yexpfont		=	$d5
.var xexpfontbase	=	$d6
.var yexpfontbase	=	$d7
.var flag16bit		=	$d8
.var xincrement		=	$d9
.var fontbase		=	$da
.var interlinea		=	$db
.var intervalue		=	$dc
.var speed			=	$dd
.var speedacc		=	$de
.var speedadder		=	$df

// Miscellaneous
// *************
.var fontsize	=	$e0
.var counter	=	$e3
.var temp		=	$e4
.var RC			=	$e5
.var nxtraster	=	$e6
.var blnextd018 =	$e7
.var d011val	=	$e8
.var fontline	=	$eb
.var lineindex	=	$ec
.var writeline	=	$ed
.var waitline	=	$ee
.var rowsize	=	$ef

// Pointers
// ********
.var textptr	=	$f0	// 16 bit
.var ptr		=	$f2	// 16 bit
.var fontptr	=	$f4 // 16 bit




// Computed constants - don't touch
// ********************************
.var	d018val1		=	floor([videobuffer1&$3fff]/$40)|floor([bitmap&$3fff]/$0400)
.var	d018val2		=	floor([videobuffer2&$3fff]/$40)|floor([bitmap&$3fff]/$0400)
.var	spritenumber	=	usedsprites.size()		// Sprite number

.var sid = LoadSid("..\..\SID\rust.sid")

/*
.if (TEST_MODE2==1) {
.pc=sid.location "Music" .fill sid.size, sid.getData(i)
:BasicUpstart2(start)

.var charsetPic = LoadPicture("data/charset-bold.gif", List().add($000000, $ffffff))

.function picToCharset(byteNo, picture,max) {
	.var ypos = [byteNo&7] + 8*[[[byteNo/[max*16]]&1]]
	.var xpos = 2*[mod([byteNo>>3],max)] + [[byteNo/[max*8]]&1]
	.return picture.getSinglecolorByte(xpos,ypos)		
}
.var data = LoadBinary("data/charbin")

.pc=font8x8
.fill NChar*8,data.get(i)
.fill NChar*8*4, picToCharset(i,charsetPic,NChar)
}
*/


.pc=$2800
start:
	.if (TEST_MODE2==1) {
	lda #$00
	jsr sid.init
	lda $dd00
	and #$fc
	ora #[3-floor(bitmap/$4000)]
	sta $dd00	
	}
	ldx #$00
!:
	.for(var i=0;i<4;i++) {
		lda orgvidbuffer+i*$100,x
		sta videobuffer1+i*$100,x
		sta videobuffer2+i*$100,x
	}
	dex
	bne !-	
	lda #d018val1
	sta $d018
	jsr createtable
	jsr preset
	jsr emptysprite
!:	
	bit $d011
	bmi !-
!:	
	bit $d011
	bpl !-	
	jsr initirq
!:
	.if (TEST_MODE2==1) jmp *
				 else   rts

// Start first IRQ
// ***************	
initirq:	
	sei		
	lda #$7f
	sta $dd0d
	sta $dc0d
	bit $dd0d
	bit $dc0d
	lda #$01
	sta $d01a
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	sta d011val
	lda #$35
	sta $01
	lda #<preirq1
	sta $fffe
	lda #>preirq1
	sta $ffff		
	lda #$00
	sta $d015	
	lsr $d019	
	cli
	rts

// Sprite Initialization
// *********************
preset:
	lda #[320-spritenumber*24]/2
	jsr scrollsetx
	lda #FONTCOLOR
	jsr scrollsetcolor
	lda #minval
	jsr scrollsety
	lda #$00
	sta $d010
	sta $d01b
	sta $d017
	sta speedadder
	sta speedacc		
	sta intervalue
	sta [[bitmap&$C000]|$3fff]
	lda #StartSpeed
	sta speed
	lda #$08
	sta writeline
	lda #<scrolltext
	sta textptr
	lda #>scrolltext
	sta textptr+1
	lda #$ff
	sta fontline	
	sta waitline	
	lda #$07
	sta fontsize
	lda #$01
	sta flag16bit	
	sta yexpfont	
	lda #$10
	sta rowsize	
	sta interlinea	
	rts
	
// Create stable raster IRQ for starting timer
// *******************************************	
.align $20			// Next Irq after <32 bytes
preirq1:	
	sta savea		// 3+7+2/9
	lsr $d019		// 6 
	lda #<preirq2	// 2
	sta $fffe		// 4
	inc $d012		// 6
	cli				// 2
	.fill 17,NOP	
preirq2:
	lda #<sidirq	// 2+7+2/3
	sta $fffe		// 4
	lda #>sidirq	// 2
	sta $ffff		// 4	
	lsr $d019		// 6
	lda #$00		// 2	
	sta $dc0f		// 4	
	sta $dc07		// 4
	sta $d012		// 4		
	lda #21-1		// 2
	sta $dc06		// 4
	pla				// 4
	pla				// 4
	lda $d012		// 4
	cmp $d012		// 4 - 63(+1)
	beq !+
!:
	sty savey
	lda #$11		// 2 - 55(+1)	
	sta $dc0f		// 4		lda #$ff	
	lda #$ff
	sta $d015
	stx savex	
	lda #$00
	jsr scrollsety
	jsr sid.play	
	pla
	lda $dc06	
	ldy savey
	ldx savex
	lda savea
	rti

	
// Sid player and frame scroller init
// **********************************
sidirq:
	pha
	txa
	pha
	tya
	pha	
	lsr $d019
	lda d018table
	sta $d018
	clc						// First video buffer
	lda shapetable			// Init first shape
	jsr scrollsetshape
	lda ytable				// Init first plex
	jsr scrollsety
	tax
	inx
	stx $d012
	lda #$00
	sta counter
	lda #<plexirq
	sta $fffe
	lda #>plexirq
	sta $ffff		
	cli						// Let there be IRQ!
	lda d011val
	and #$7f
	sta $d011				
	and #$07
	sta RC					// Save current RC
	jsr sid.play			// SID PLAYER (placeholder)
	.if (TEST_MODE2==0) {
		jsr wob_pic_x
		jsr wob_pic_y
		jsr move_bubble
	}
	pla
	tay
	pla
	tax
	pla
	rti
		
		
// Main plexing IRQ (Bad line version)
// ***********************************
.align $0020	// We don't want to cross page boundary on stabilization branch
.pc=* "Bad line main plexing IRQ"
blplexirq:
	sta savea
	stx savex
	ldx $dc06
	lda waittbl,x	
	lsr	
	sta blfiwt+1
	bcc blfiwt	
blfiwt:
	bpl blfiwt
	nop
	nop
	nop	
	nop
	lda blnextd018	// 1 cycle more thank nonbl version
	sta $d018
	jmp irqset
	
// Main plexing IRQ
// ****************		
.align $0020	// We don't want to cross page boundary on stabilization branch
.pc=* "Main plexing IRQ"
plexirq:
	sta savea
	stx savex
	ldx $dc06
	lda waittbl,x
	lsr	
	sta fiwt+1
	bcc fiwt	
fiwt:
	bpl fiwt
	nop
	nop
	nop	
	nop
nextd018:
	lda #$00
	sta $d018
irqset:
	sty savey
	lsr $d019
	ldx #$08	// Waste some cycles
!:
	dex
	bne !-	
	ldx counter
	inx
	cpx #[spriterows-1]
	bne irqcontinue
	lda $d011		// Start new frame
	and #$7f
	sta $d011	
	lda #$00
	sta $d012
	lda #<sidirq
	sta $fffe
	lda #>sidirq
	sta $ffff	
	cli
	jsr writeroutine
	bit totalend
	bmi irqcommon
	jsr scrollsprites		
	lda #$00		
	sta speedadder
	sta counter
	beq irqcommon
irqcontinue:		// Continue current frame
	stx counter
	lda ytable,x
	jsr scrollsety
	sec
	sbc #$01
	sta nxtraster	
	lax counter
	lsr
	lda d018table,x	
	sta nextd018+1
	sta blnextd018
	lda counter	
	lda shapetable,x
	jsr scrollsetshape
	ldx #<plexirq
	ldy #>plexirq
	lda nxtraster
	cmp #$30
	bcc !+			// No badlines under $30
	cmp #$f8
	bcs !+			// No badlines after $F7
	and #$07
	cmp RC	
	bne !+			// No badlines if (lower bits $d012) != RC
	ldx #<blplexirq
	ldy #>blplexirq
	dec nxtraster
!:
	stx $fffe	
	sty $ffff	
	lda nxtraster
	sta $d012
irqcommon:	
	ldy savey
	ldx savex
	lda savea
	rti			


	
scrollsprites:	
	sec
	ldx #$01
	lda ytable
	sbc speedadder
	cmp #minval+1
	bcs !+
	dex
	jsr !+
	jmp fixshapes
!:
	sta ytable
	clc
!:
	adc #21
	sta ytable,x
	inx
	cpx #spriterows
	bcc !-
	rts
fixshapes:
	lda shapetable
	sta temp
	ldx #$00
!:
	lda shapetable+1,x
	sta shapetable,x
	inx
	cpx #spriterows
	bcc !-
	lda temp
	sta shapetable+spriterows-1
	rts

	
// Set Y coordinate for plexing
// ****************************	
scrollsety:
	ldy #spritenumber-1
!:
	ldx xinvspritetable,y
	sta $d000+1,x	
	dey
	bpl !-
	rts
	
// Set X coordinate of sprites
// ***************************	
scrollsetx:	
	clc
	sta $d000
	ldy #spritenumber-1	
!:
	ldx xinvspritetable,y
	adc #$18
	sta $d000,x
	dey
	bpl !-		
	rts
	
// Set color of sprites
// ********************
scrollsetcolor:		
	ldy #spritenumber-1	
!:	
	ldx shapespritetable,y	
	sta $d027,x
	dey
	bpl !-	
	rts
	
// Set shape of sprites
// ********************
scrollsetshape:			
	ldy #spritenumber-1
	bcs shape2
!:
	ldx shapespritetable,y
	sta videobuffer1+$3f8,x
	adc #$01
	dey
	bpl !-
	rts
shape2:	
	clc
!:
	ldx shapespritetable,y
	sta videobuffer2+$3f8,x
	adc #$01
	dey
	bpl !-
	rts
	
totalend:
.byte $00
	
.align $0010
// Tabella dei cicli di wait per stabilizzazione
// *********************************************
waittbl:
.byte 9,8,7,6,5,4,3,2,1,0,0,0,0,0,0

// Tabella posizioni raster/sprite
// *******************************
ytable:
.for(var i=0;i<16;i++)
	.byte minval+SPEED+i*21

// Tabella shapes sprite
// *********************
shapetable:
.for(var i=0;i<16;i++)
	.byte [[spritebase&$3fff]/$40]+i*spritenumber
	
// Tabella valori d018
// *******************
d018table:
.for(var i=0;i<16;i++)
	.byte [i&1]==0 ? d018val1 : d018val2

// VIC x sprite coordinate displacements
// *************************************
xinvspritetable:
.fill spritenumber,usedsprites.get(spritenumber-i-1)*2

// VIC x sprite coordinate displacements
// *************************************
shapespritetable:
.fill spritenumber,usedsprites.get(spritenumber-i-1)

// Font writing
// ************
.import source "write.asm"
.import source "macro.asm"


//scrolltext:
//.import source "text.asm"
