// Clean sprite area
// *****************
emptysprite:
	lda #<spritebase
	sta ptr
	lda #>spritebase
	sta ptr+1
	ldx #<spriterows*spritenumber
esloop:
	lda #$00
	ldy #$3f	
!:
	sta (ptr),y
	dey
	bpl !-
	clc
	lda ptr
	adc #$40
	sta ptr
	lda ptr+1
	adc #$00
	sta ptr+1
	dex
	bne esloop
	rts
	
// Write routine
// *************	
writeroutine:	
	inc speedacc
	bne !+
	inc speedadder
!:	
	clc
	lda speedacc
	adc speed
	sta speedacc
	lda speedadder
	adc #$00
	sta speedadder	
	adc writeline	
	cmp #[21*spriterows]
	bcc !+
	lda #$00
!:
	sta writeline	
	tay	
	lda speedadder
	bne !+
	rts
!:
	inc waitline
	lda waitline
	cmp rowsize	
	bcs wrcheck
	and #$07	
	bne wrwrite
wrparse:
	jsr parsespecial
	jsr readline
	ldy writeline
	jmp wrwrite
wrcheck:
	cmp interlinea
	bcc wrwait
	lda #$00
	sta waitline
	jmp wrparse
wrwrite:
	jsr writechar8bit 	
	rts
wrwait:
	jsr skipline
	rts
	
	
// Write char
// **********	
writechar8bit:
	sty lineindex		// Current scroll line
	lda fontline
	clc
	adc #$01	
	and fontsize
	sta fontline			// Current font line		
	ldx #spritenumber*3-1	// X position
wccharloop:	
	ldy textbuffer,x	// Load character code
	lda fontptrlo,y
	ora fontline
	sta fontptr			// Computer font pointer (LO)
	lda fontptrhi,y
	sta fontptr+1		// Computer font pointer (HI)
	ldy lineindex
	clc
	lda sprptrlo,y		// Get Y sprite posizion
	adc sprxlo,x		// Add x sprite position
	sta ptr
	lda sprptrhi,y
	adc sprxhi,x
	sta ptr+1			// Computer sprite position
	ldy #$00
	lda (fontptr),y		// Copy font byte
	sta (ptr),y			// To sprite
	dex					// Got to next column	
	bpl wccharloop
	rts
	
// Skip line
// *********
skipline:
	sty lineindex			// Current scroll line
	ldx #spritenumber*3-1	// X position
slcharloop:	
	ldy lineindex
	clc
	lda sprptrlo,y		// Get Y sprite posizion
	adc sprxlo,x		// Add x sprite position
	sta ptr
	lda sprptrhi,y
	adc sprxhi,x
	sta ptr+1			// Computer sprite position
	ldy #$00
	lda #$00			// Copy font byte
	sta (ptr),y			// To sprite
	dex					// Got to next column
	bpl slcharloop
	rts

	
// Parse special characters
// ************************	
parsespecial:	
	ldy #$00
psloop:
	lda (textptr),y
	cmp #$fa
	bcc psexit
	cmp #$fe
	beq psstop
	cmp #$fd
	beq psinterlinea
	cmp #$fc
	beq psfontsize
	cmp #$fb
	beq psspeed
pscontinue:
	iny
	bne psloop
psexit:
	jmp rlnext
psstop:
	lda #<fld_end_irq
	sta $fffe
	lda #>fld_end_irq
	sta $ffff
	lda #$2a
	sta $d012
	lda #$80
	sta totalend	
	jmp parsespecial
psinterlinea:
	iny
	lda (textptr),y	
	sta intervalue
pssetil:	
	lda flag16bit
	asl
	asl
	asl
	adc intervalue
	sta interlinea
	jmp pscontinue
psfontsize:
	iny
	lda (textptr),y
	and #$01
	sta flag16bit
	clc
	adc #$01
	sta xexpfontbase
	sta yexpfontbase
	sta yexpfont
	lda flag16bit
	asl
	asl
	asl
	adc #$08
	sta rowsize
	jmp pssetil	
psspeed:
	iny
	lda (textptr),y
	sta speed
	jmp pscontinue
	

// Read new text line
// ******************
.pc=* "Read line"
readline:		
	ldx yexpfont
	inx	
	cpx yexpfontbase
	bcc !+
	ldx #$00
!:	
	stx yexpfont
	txa
	asl				// hibit:0 => clc
	ora flag16bit	// 0/1		
	sta fontbase
	lda #$00
	sta xexpfont		
	tax
	tay
rlloop:	
	stx tempx	
	adc fontbase
	tax	
	lda (textptr),y	
	cmp #$ff
	bcs rlexit
	adc fontstruct,x	
	ldx tempx
	sta textbuffer,x	
	inc xexpfont
	lda xexpfont
	cmp xexpfontbase
	bcc !+
	lda #$00
	sta xexpfont
	iny
!:				
	inx
	cpx #spritenumber*3
	bcc rlloop
	beq rlskip
rlexit:	
	lda #spacechar
	ldx tempx
!:
	sta textbuffer,x
	inx
	cpx #spritenumber*3
	bne !-
	iny
rlskip:	
	ldx yexpfont
	inx
	cpx yexpfontbase
	beq rlnext
	rts		
rlnext:
	clc
	tya	
	adc textptr
	sta textptr 
	lda textptr+1
	adc #$00
	sta textptr+1
	rts

// Create font pointer table
// *************************	
createtable:
	lda #<font8x8
	sta fontptrlo
	lda #>font8x8
	sta fontptrhi
	lda #<spritebase
	sta sprptrlo
	lda #>spritebase
	sta sprptrhi	
	ldx #$01
ctloop:
	clc
	lda fontptrlo-1,x	// Font pointer table
	adc #$08
	sta fontptrlo,x
	lda fontptrhi-1,x
	adc #$00
	sta fontptrhi,x	
	lda sprptrhi-1,x	// Sprite pointer table
	sta sprptrhi,x		
	clc
	lda sprptrlo-1,x
	adc #$03
	sta sprptrlo,x
	and #$3f
	eor #$3f
	bne !+	
	lda sprptrlo,x
	adc #<[spritenumber*$40]-$3f
	sta sprptrlo,x
	lda sprptrhi,x
	adc #>[spritenumber*$40]-$3f
	sta sprptrhi,x		
!:	
	inx
	bne ctloop
	rts

// X coordinate sprite helper
// **************************
sprxlo:
.fill spritenumber*3,<[mod(i,3)+floor(i/3)*$40]
sprxhi:
.fill spritenumber*3,>[mod(i,3)+floor(i/3)*$40]


// Font offsets
// ************
fontstruct:
.for(var i=0;i<5;i++) .byte NChar*i

