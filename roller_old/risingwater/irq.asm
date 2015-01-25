// ***************
// * IRQ Routine *
// ***************

.align $0100
mainirq:
	pha				// 3
	txa				// 2
	pha				// 3
	tya				// 2
	pha				// 3
	lsr $d019		// 6
	lax rstcnt		// 4	
	bne skipfstline	// 3 - 26
aircolor:
	tay
	lda ypos+1
	lsr	
	lda ypos
	ror
	cmp #$07
	bcc !+
	lda #color2	
	sta $d020
	sta $d021	
!:
	jmp sidexit
skipfstline:	
	lsr flaglist,x	// 7	
	bcs sidebrtn	// 3 - 12
	tay
	ldx rastlist,y
	lda d011table,x
	sta $d011
	ldx rstcnt
	lsr flaglist,x
	bcc lightexit
	jmp endframe
lightexit:	
	iny				// Normal ESCO routine exit
	sty rstcnt
	lda $d011
	and #$7f
	ora rsthlist,y
	sta $d011
	lda rastlist,y
	sta $d012
	cli	
	pla
	tay
	pla
	tax
	pla
	rti
sidebrtn:
	lda rastlist,x	// 4	
	adc #$02		// 2 carry always set (bcs)
	sta $d012		// 4
	tsx				// 2
	lda #<nextirq	// 2
	sta $fffe		// 4
	cli				// 2 - 22 (60)
	.fill 70,NOP
	.byte $02
	brk
	
nextirq:	
	lda sinus
	and #$3f
	tay
	lda sprdat,y
	sta screen+$3f8
	sta screen+$3f9
	sta screen+$3fa
	sta screen+$3fb
	sta screen+$3fc
	lsr $d019	
	sta screen+$3fd
	sta screen+$3fe	
	sta screen+$3ff
	txs
	ldx $d012	
	ldy #$0b
	bit $ff
	
	// Sideborder loop
	// ***************

sbloop:
	bit $ff		// 3
	.fill 7,NOP	// 16
	dec $d016	// 6
	inc $d016	// 6	
	inx			// 2	
	lda d011table,x	// 4
	sta $d011	// 4	
	nop			// 2
	dey			// 2
	bne sbloop	// 3/2
	
	ldy #$02	// 2 - 18
	lda #$ff	// 2
	sta $d017	// 4
	nop
	nop
	nop
	nop
	nop
sbloop2:	
	dec $d016		// 6
	inc $d016		// 6	
	bit $ff			// 3	
	lda #<mainirq	// 2
	sta $fffe		// 4
	inx				// 2
	lda d011table,x	// 4
	sta $d011		// 4		
	lda #$06		// 2
	sta $d021		// 4		
	sta $d020		// 4	
	dey				// 2
	bne sbloop2		// 3/2

	lax rstcnt
	tay
	lsr flaglist,x
	bcs endframe
	jmp lightexit
endframe:	
	lda #[empty/64]
	sta screen+$3f8
	sta screen+$3f9
	sta screen+$3fa
	sta screen+$3fb	
	sta screen+$3fc
	sta screen+$3fd
	sta screen+$3fe
	sta screen+$3ff
skipempty:
	lda #$00
	sta $d017
	sec
	lda waiter
	sbc speed
	sta waiter
	lda ypos
	sbc #$00
	sta ypos
	lda ypos+1
	sbc #$00
	sta ypos+1
	lda ypos
	cmp #$08
	bcs !+
	lda ypos+1	
	bne !+	
	sta $d015
	//lda #$06
	//sta $d021
	//sta $d020	
	pla
	tay
	pla
	tax
	lda #$80
	sta $1f	
	pla
	jmp (retadd)
	
!:
	jsr setspritepos
	jsr setrasterorder
	lda $d011
	asl
	lda $d012
	ror
	cmp #$04
	bcs !+
	ldy #$00
	jmp aircolor
!:
	lda rastlist
	sta $d012
	lda $d011
	and #$7f
	ora rsthlist
	sta $d011		
	pla
	tay
	pla
	tax
	pla	
	rti

sidexit:
	iny				// Normal ESCO routine exit
	sty rstcnt
	lda $d011
	and #$7f
	ora rsthlist,y
	sta $d011
	lda rastlist,y
	sta $d012
	cli	
	jsr sidplay
	pla
	tay
	pla
	tax
	pla
	rti

	
// ******************************
// * Determina ordine interrupt *
// ******************************
		
setrasterorder:
	lda ypos
	and #$f8
	sec
	sbc #$04
	pha
	lda ypos+1
	sbc #$00
	beq rsttest2
	lda #$00		// * 100->						
	sta rsthlist+1	// Raster H List
	sta rsthlist+2
	lda #$80
	sta rsthlist+3
	pla
rsttest1:			// - - |
	sta rastlist+3
	lda #upper		// Raster list
	sta rastlist+1
	lda #lower
	sta rastlist+2				
	lda #$03		// Flag list
	sta flaglist+3
	lda #$00
	sta flaglist+1
	sta flaglist+2
	jmp endrst	
rsttest2:	
	sta rsthlist+1
	sta rsthlist+2
	sta rsthlist+3	
	pla	
	cmp #lower-1	
	bcs rsttest1	// * FD->FF
	cmp #$e8
	bcc rsttest3
	sta rastlist+2
	lda #upper		// ED->FC
	sta rastlist+1
	lda #$00		
	sta flaglist+1
	lda #$03
	sta flaglist+2	
	jmp endrst
rsttest3:
	cmp #$38
	bcc rsttest4
	sta rastlist+2
	lda #upper	// 3D-EC
	sta rastlist+1
	lda #lower
	sta rastlist+3
	lda #$00
	sta flaglist+1
	lda #$01
	sta flaglist+2
	lda #$02
	sta flaglist+3
	jmp endrst
rsttest4:
	cmp #$20
	bcc rsttest5
	sta rastlist+1	// 2D-3C
	lda #lower
	sta rastlist+2
	lda #$01
	sta flaglist+1
	lda #$02
	sta flaglist+2		
	jmp endrst
rsttest5:	
	sta rastlist+1	// 00-2C
	lda #upper
	sta rastlist+2
	lda #lower
	sta rastlist+3	
	lda #$01
	sta flaglist+1
	lda #$00
	sta flaglist+2
	lda #$02
	sta flaglist+3	
endrst:
	lda #$00
	sta rstcnt
	inc sinus
	rts

// Set sprite position
// *******************	

setspritepos:	
	sec
	lda ypos
	sbc #$09
	ldy #$0e
!:
	sta $d001,y
	dey
	dey
	bpl !-
skipy:	
	lda #$00
	sta temp
	clc	
	lda xpos
	ldy #$00	
!:
	sta $d000,y
	adc #$30
	ror temp
	iny
	iny
	cpy #$0c
	bne !-		
	sta $d00c
	adc #$A8-1
	ror temp
	sta $d00e		
	lda temp	// 0001 0000 => 0000 1111 
	sbc #$00
	eor #$ff
	sta $d010
	rts
