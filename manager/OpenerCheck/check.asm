.const	flag	=	$fa

// Main check routine
// ******************

check:
	lda #$00
	sta flag
	lda $d015
	beq nosprite
	lda #$01
	sta flag
nosprite:
	lda $d018
	and #$fe
	cmp #$14
	beq nod018
	lda flag
	ora #$02
	sta flag
nod018:
	lda $dd00
	and #$03
	cmp #$03
	beq nodd00
	lda flag
	ora #$02
	sta flag
nodd00:
	lda $d011
	and #$7f
	cmp #$1b
	beq nod011
	lda flag
	ora #$02
	sta	flag
nod011:	
	lda $d016
	and #$3f
	cmp #$08
	beq nod016
	lda flag
	ora #$02
	sta	flag
nod016:	
	lda $d020
	and #$0f
	cmp #$0e
	beq nod020
	lda flag
	ora #$02
	sta	flag
nod020:
	lda $d021
	and #$0f
	cmp #$06
	beq nod021
	lda flag
	ora #$02
	sta	flag
nod021:
	jsr checkd800
	beq nod800
	lda flag
	ora #$04
	sta flag
nod800:
	lda flag
	rts

// Check $d800 correctness
// ***********************	
	
checkd800:
	ldx #$00
cdloop:
	lda $d800,x
	and #$0f
	cmp #$0e
	bne cdfound
	lda $d900,x
	and #$0f
	cmp #$0e	
	bne cdfound
	lda $da00,x
	and #$0f
	cmp #$0e	
	bne cdfound
	lda $dae8,x
	and #$0f
	cmp #$0e	
	bne cdfound	
	dex
	bne cdloop
	lda #$00
	rts
cdfound:
	lda #$01
	rts
