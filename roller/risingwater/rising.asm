// ***********
// * GLOBALS *
// ***********

.const	SPEED	=	$62

// Constants

.const	upper	=	$33
.const	lower	=	$f9
.const	speed	=	$74

// Basic settings

.const	color1	=	$06
.const	color2	=	$0e

// Variables

.const	saveirq		=	$20
.const	retadd		=	$22
.const	sinus	=	$24
.const	baserast=	$25
.const	temp	=	$26
.const	waiter	=	$27

// Constant pointers

.const	screen		=	$C000
.const	empty		=	$C400
.const	font		=	$C800

// Pointers
.var sid=LoadSid("..\..\SID\rust.sid")

.const	sidplay=sid.play

.const	TEST=0

// ****
.if (TEST==1) {

:BasicUpstart2($4000)
.pc=sid.location "loop"
.fill sid.size, sid.getData(i)

.pc=$4000	
	sei
	lda #$06
	sta $d021
	sta $d020
	lda #$7f	
	sta $dc0d
	sta $dd0d
	bit $dd0d
	bit $dc0d
	lda #$00
	sta $d012
	lda $d011
	ora #$10
	and #$7f
	sta $d011	
	lda #$00
	jsr sid.init
	lda #$35
	sta $01
	ldx #<jump
	ldy #>jump
	lda #$01
	sta $d01a
	lsr $d019	
	lda #$a0
	ldx #$00
!:
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	dex 
	bne !-
	jsr start
	cli
jump:	
	jmp *
	}


// CODE
// ****

.pc=$F940
		
start:
	sei
	stx retadd
	sty retadd+1
	lda #SPEED
	sta speed	
	lda #<fadeirq
	sta $fffe
	lda #>fadeirq
	sta $ffff		
	lda #$00
	sta $d015	
	ldy #$3f		// Create empty sprite
!:	
	sta empty,y		
	dey
	bpl !-				
	ldy #$07
!:
	lda #[empty/64]
	sta screen+$3f8,y
	lda #color1
	sta $d027,y
	dey
	bpl !-
	jsr setrasterorder
	jsr setspritepos
	lda #$00
	sta temp	
	sta waiter
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011	
	cli
	rts	

	
// **********************
// * Temporary fade irq *
// **********************
.print "Fade IRQ: "+toHexString(*)
	
fadeirq:
	pha
	txa
	pha
	tya
	pha
	jsr sidplay		
	lsr $d019
	lax temp
	lsr
	inc temp
	ldy #$09
	lda fadetable,x
	bcc !+
	lsr
	lsr
	lsr
	lsr
!:	
	sta $d800+40*10+15,y
	sta $d800+40*11+15,y
	sta $d800+40*12+15,y
	sta $d800+40*13+15,y
	sta $d800+40*14+15,y
	sta $d800+40*15+15,y
	dey
	bpl !-
	cpx #[rstcnt-fadetable]
	bne !+	
	lda #<mainirq	
	sta $fffe
	lda #>mainirq
	sta $ffff
	lda $dd00
	and #$fc
	ora #[3-floor(screen/$4000)]
	sta $dd00
	lda #[floor([font&$3fff]/$400)+16*floor([screen&$3fff]/$400)]
	sta $d018
	lda #$48
	sta $d016	
	ora rsthlist
	sta $d011
	lda rastlist	
	sta $d012	
	lda #$ff
	sta $d01d
	sta $d015	
!:
	pla
	tay
	pla
	tax
	pla	
	rti
		
.print "Variables: "+toHexString(*)	


.pc=$f9ff	"Fix 3fff bug"
.byte $00

sprdat:
.fill 64,[sprite/64]+floor(2.5+[2.5*sin(i*3.1415/32)])

sprite:
.import c64 "sprites\sprites.bin"

.align $0100
d011table:
.for(var i=0;i<256;i++)
	.if (i<lower&&i>=upper) .byte $58
				else	.byte $40

.import source "irq.asm"


.print "Table: "+toHexString(*)
.align $0010
rastlist:
.byte $00,$00,$00,$00
rsthlist:
.byte $00,$00,$00,$00
flaglist:
.byte $00,$00,$00,$00

.align $0020
fadetable:
.byte $5b,$c8,$3d,$1f,$11,$3f,$ed

rstcnt:
.byte $00
savex:
.byte $00
savey:
.byte $00
xpos:
.byte $28
ypos:
.byte $22,$01	
	