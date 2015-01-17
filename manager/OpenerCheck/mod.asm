.const	cflag	=	$f1
.const	GKJtemp	=	$f2
.const	hispr	=	$f3
.const	command	=	$f4
.const	irq		=	$f5
.const	ypos	=	$f7
.const	vald011	=	$f9
.const	vald016	=	$fa
.const	vald018	=	$fb
.const	valdd00	=	$fc
.const	vald020	=	$fd
.const	vald021	=	$fe
.const	temp	=	$ff

.pc=$1000

maintest:
	jmp setirq	

// Main check routine
// ******************
setirq:
	jsr check
	sei
	sta command
	beq skipall
	sei
	lda #$35
	sta $01	
	lda $fffe
	sta irq
	lda $ffff
	sta irq+1
	lda #$01
	sta $d01a
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda $dc0d
	lda $dd0d
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	lsr $d019
	lda #$00
	sta cflag	
	jsr skipexit
!:
	bit cflag
	bpl !-
	rts	
skipexit:	
	lsr command
	bcc skipsprite
	jsr setirq1
	cli
	rts
skipsprite:
	lsr command
	bcc skipscreen
	jsr setirq2
	cli
	rts
skipscreen:
	lsr command
	bcc skipend
	jsr setirq3
	cli
	rts
skipend:	
	lda irq
	sta $fffe
	lda irq+1
	sta $ffff
	cli
	lda #$80
	sta cflag
skipall:
	jmp sidtest	

// Screen window FX (IRQ Setting)
// ******************************
	
setirq1:	
	lda #<spriteirq
	sta $fffe
	lda #>spriteirq
	sta $ffff
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	lsr $d019
	lda #$10
	sta temp
	rts	
	
// Screen window FX (IRQ Setting)
// ******************************
	
setirq2:
	lda #<screenirq
	sta $fffe
	lda #>screenirq
	sta $ffff
	lda #$05
	sta ypos
	lda #$00
	sta ypos+1
	lda $d020
	sta vald020
	lda $d021
	sta vald021
	lda $d011
	and #$7f
	sta vald011
	lda $d016
	sta vald016
	lda $d018
	sta vald018
	lda $dd00
	and #$03
	sta valdd00
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	lda #$aa
	sta temp
	lsr $d019
	rts
	
// Screen window FX (IRQ Setting)
// ******************************
	
setirq3:	
	lda #<fadeirq
	sta $fffe
	lda #>fadeirq
	sta $ffff
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	lsr $d019
	lda #$10
	sta temp
	rts

// Sprite FX
// *********
	
spriteirq:
	pha
	txa
	pha
	tya
	pha
	lsr $d019
	lda $d015
	sta temp
	ldx #$FE
	lda $d010
	sta hispr
spritetest:	
	ldy $d025
	lda fadesprite,y
	sta $d025
	ldy $d026
	lda fadesprite,y
	sta $d026	
	inx
	inx	
	lda temp
	bne !+
	jmp nomoresprite
!:
	lsr temp
	bcc spritetest
!:	
	clc
	txa
	lsr
	tay
	lda hispr
	ora mask8,y
	ldy #$00
	eor #$ff			
	beq dexstep
	lda $d000,x
	cmp #$95
	bcc !+
dexstep:
	jsr dexspr
	ldy #$01
!:
	cmp #$94
	bcs !+	
	jsr inxspr
	ldy #$01
!:
	lda $d001,x
	cmp #$95
	bcc !+
	jsr deyspr
	ldy #$01
!:
	cmp #$94
	bcs !+
	jsr inyspr	
	ldy #$01
!:
	cpy #$01
	beq spritetest
	txa
	lsr
	tay
	lda $d027,y
	tay
	lda fadesprite,y
	pha
	txa
	lsr
	tay
	pla
	sta $d027,y
	cmp #$06
	bne spritetest
	txa
	lsr
	tay
	lda $d015
	and mask8,y
	sta $d015 
	jmp spritetest
dexspr:
	dec $d000,x
	lda $d000,x
	cmp #$ff
	bne !+
	txa
	lsr
	tay
	lda $d010
	and mask8,y
	sta $d010
!:
	rts
inxspr:
	inc $d000,x
	rts	
deyspr:
	dec $d001,x
	rts	
inyspr:
	inc $d001,x
	rts		
nomoresprite:
	cpx #$00
	bne !+
	lda #$00
	sta $d017
	sta $d01d
	sta $d01c
	jsr skipsprite
!:
	pla
	tay
	pla
	tax
	pla
	rti

// Windows FX
// **********

screenirq:
	pha
	lsr $d019
	lda #$06
	sta $d021
	lda #$0e
	sta $d020
	lda #$15
	sta $d018
	lda #$c8
	sta $d016
	lda $dd00	
	ora #$03
	sta $dd00	
	lda temp
	cmp #$80
	rol
	sta temp
	bcc lower
upper:
	inc ypos
	bne !+
	inc ypos+1
!:
	lda ypos+1
	beq !+
	lda ypos
	cmp #$22
	bne !+
	lda #$1b
	sta $d011
	jsr skipscreen
	pla
	rti
!:	
	lda ypos+1
	lsr
	ror
	ora #$1b	
	sta $d011
	lda ypos
	sta $d012
	pla
	rti
lower:
	lda #$00
	sta $d012
	lda vald011
	sta $d011
	lda vald018
	sta $d018
	lda vald016
	sta $d016
	lda $dd00
	and #$fc
	ora valdd00
	sta $dd00
	lda vald020
	sta $d020
	lda vald021
	sta $d021
	pla
	rti

// Fade FX
// *******

fadeirq:
	lsr $d019
	pha
	txa
	pha
	tya
	pha
	ldy #$00
dfloop:
	ldx $d800,y
	lda fadetable,x
	sta $d800,y
	ldx $d900,y
	lda fadetable,x
	sta $d900,y
	ldx $da00,y
	lda fadetable,x
	sta $da00,y
	ldx $db00,y
	lda fadetable,x
	sta $db00,y
	dey
	bne dfloop
	dec temp	
	bne !+
	jsr skipend
!:
	pla
	tay
	pla
	tax
	pla
	rti


// Fake irq
// ********
	
fakeirq:
	lsr $d019
	rti
	
.import source "check.asm"
.import source "key.asm"
	
.align	$0100
fadetable:
.for(var i=0;i<16;i++)
	.byte $06,$0D,$0B,$0A,$08,$0E,$09,$0F,$0C,$02,$05,$04,$0E,$07,$0E,$03
mask8:
.byte $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f
fadesprite:
.for(var i=0;i<16;i++)
	.byte $06,$0d,$09,$0a,$0b,$0e,$06,$0f,$04,$06,$05,$02,$08,$07,$0c,$03

.import source "fire\fire.asm"

.import source "siddetect.asm"
