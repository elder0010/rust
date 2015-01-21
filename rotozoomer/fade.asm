.var	TEST_MODE = 0
.if (cmdLineVars.get("test")==null) .eval TEST_MODE=0
							   else .eval TEST_MODE=cmdLineVars.get("test").asNumber()

// Pointers
// ********
.var	colptr	=	$80
.var	charptr	=	$82
.var	endchar	=	$84
.var	endcol	=	$86
.var	orgchar	=	$88
.var	orgcol	=	$8a
.var	fadeptr	=	$8c
.var	nextirq	=	$8e

// Miscellaneous
// *************
.var	sweep	=	$90
.var	temp2	=	$91
.var	position=	$92
.var	column	=	$93
.var	temp	=	$94
.var	row		=	$95
.var	lomask	=	$96
.var	himask	=	$97
.var	counter	=	$98

.const	barsize	=	7

.var orgchartable	=	$4000+$1f40
.var orgcoltable	=	orgchartable+1000
.var endchartable	=	$e000
.var endcoltable	=	$e400
.var ffadetable		=	$e800
.var lfadetable		=	$e900
.var hfadetable		=	$ea00
.var charscreen		=	$6C00
.var colscreen		=	$d800


.var sid=LoadSid("..\SID\psycho.sid")

.if (TEST_MODE==1) {
	.pc=sid.location "Rust by psicho (SID)"
	.fill sid.size, sid.getData(i)
}


.if (TEST_MODE==1) {
:BasicUpstart2(start)
	.pc=$2800
}
else {
	.pc=$75a0
}

.var towhite=List()
.eval towhite.add($06,$01,$0b,$0f,$08,$0a,$09,$0d,$0e,$02,$03,$04,$05,$01,$0c,$07)
.var toblack=List()
.eval toblack.add($00,$0d,$09,$0a,$0b,$0c,$00,$0f,$04,$06,$05,$02,$0e,$07,$08,$03)

// Init memory tables
// ******************	
// C: 0 - Fade to black
//    1 - Fade to white
// Next IRQ: >y:<x
initfader:
	stx nextirq
	sty nextirq+1
	lda # [[16/[barsize+1]]+[mod(16,[barsize+1])!=0 ? 1 : 0]]+1
	sta sweep
	ldx #<fadetowhite
	ldy #>fadetowhite
	bcs !+
	ldx #<fadetoblack
	ldy #>fadetoblack	
!:	
	stx fadeptr
	sty fadeptr+1
	ldx #STA_IZPY
	lda #LDA_IZPY
	bcs !+
	ldx #BIT_ZP
	lda #BIT_ZP
!:
	sta tpc1
	sta tpc2	
	stx lpc1
	stx lpc2
	ldy #$00
!:
	sty temp2
	tya
	and #$0f
	tay
	lda (fadeptr),y
	sta temp	
	lda temp2
	lsr
	lsr
	lsr
	lsr
	tay
	lda (fadeptr),y
	asl
	asl
	asl
	asl
	ora temp
	ldy temp2
	sta ffadetable,y	
	and #$f0
	sta temp2
	tya
	and #$0f
	ora temp2
	sta hfadetable,y
	tya
	and #$f0
	ora temp
	sta lfadetable,y
	dey
	bne !-	
	sty position
	//sty $d021	=> GREY DOTS FIX
	//sty $d020	
	lda #<orgchartable
	sta orgchar
	lda #>orgchartable
	sta orgchar+1
	lda #<orgcoltable
	sta orgcol
	lda #>orgcoltable
	sta orgcol+1
	sty endcol	
	lda #>endcoltable
	sta endcol+1
	sty endchar
	lda #>endchartable
	sta endchar+1	
	sty charptr	
	lda #>charscreen
	sta charptr+1
	sty colptr		
	lda #>colscreen
	sta colptr+1		
!:
	lda #$00
lpc1:
	sta (colptr),y
lpc2:
	sta (charptr),y
tpc1:
	lda (orgcol),y	
	sta (endcol),y
tpc2:
	lda (orgchar),y	
	sta (endchar),y	
	iny
	bne !-
	inc colptr+1
	inc charptr+1
	inc orgcol+1
	inc endcol+1
	inc orgchar+1	
	inc endchar+1	
	lda charptr+1
	and #$03	
	bne !-
	lda #DEC_ZP
	sta endirq
	lda #$0f
	sta lomask
	lda #$f0
	sta himask
	rts	
	
	
fadeirq:
	pha
	txa
	pha
	tya
	pha
	lsr $d012
	lda #$00
	sta $d012
	lsr $d019	
	cli
	lda #<fadesidirq
	sta $fffe
	lda #>fadesidirq
	sta $ffff
	sec
	lax position
	sbc #barsize
	bcs !+
	lda #$00
!:
	sta column
	txa
	cmp #40
	bcc !+
	lda #39
!:
	sec	
	sbc column
	sta counter
	txa
	beq !+
	cmp #40+[barsize-1]
	bcc contirq		
!:
	lda endirq 
	eor #[INC_ZP^DEC_ZP]
	sta endirq
	dec sweep
	bne contirq
	lda nextirq
	sta $fffe
	lda nextirq+1
	sta $ffff	
	jmp endirq
contirq:	
	lda column
	sta charptr
	sta colptr
	sta endchar
	sta endcol
	lda #>charscreen
	sta charptr+1	
	lda #>colscreen
	sta colptr+1		
	lda #>endchartable
	sta endchar+1
	lda #>endcoltable
	sta endcol+1		
	lda #25
	sta row		
	clc
doloop:
	ldy counter
	loop:		
		lax (charptr),y		
		eor (endchar),y
		beq ok
		bit lomask
		beq hm		
		bit himask
		beq lm
		lda ffadetable,x
		bcc csave
	hm:
		lda hfadetable,x
		bcc csave
	lm:
		lda lfadetable,x
	csave:
		sta (charptr),y	
	ok:
		lax (colptr),y
		eor (endcol),y
		and #$0f
		beq ok2
		lda lfadetable,x
		sta (colptr),y
	ok2:		
		dey		
		bpl loop	
		
	lda charptr
	adc #40
	sta charptr
	sta colptr
	sta endcol
	sta endchar
	bcc !+
	inc charptr+1
	inc colptr+1	
	inc endchar+1
	inc endcol+1	
	clc	
!:	
	dec row
	bne doloop
endirq:
	dec position
exitirq:
	pla
	tay
	pla
	tax
	pla
	rti

fadesidirq:
	pha
	txa
	pha
	tya
	pha
	lsr $d019
	lda #<fadeirq
	sta $fffe
	lda #>fadeirq
	sta $ffff
	lda #$e0
	sta $d012
	jsr sid.play
	jmp exitirq
	
	
fadetoblack:
.for(var i=0;i<16;i++) 
	.byte	toblack.get(i)
fadetowhite:
.for(var i=0;i<16;i++) 
	.byte	towhite.get(i)

.if (TEST_MODE==1) {
.pc=$4000
.import c64 "Frame\frame.kla"
}