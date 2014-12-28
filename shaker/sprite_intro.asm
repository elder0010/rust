init_rings_sprites:
		
	//	lda #0
	//	sta $d015

		sta $d01c

		lda #$9b
		sta $d000
		lda #$ff
		sta $d001

		lda #$ff
		sta $d017
		sta $d01d
	

		lda #[rings_sprites]/$40
		ldx #0
!:
		sta screenChars+$03f8,x
		inx
		cpx #8
		bne !-

		lda #1
		sta $d027
		lda #BLACK
		sta $d028

		lda #$3
		sta $d015

		rts

move_rings:
	
		dec $d001

		clc
		lda $d000
		adc #2
		sta $d002
		lda $d001
		adc #2
		sta $d003

		lda tmp
		and #2
		bne nogo
	
		clc
		lda screenChars+$03f8
		adc #1
		cmp #[rings_sprites/$40]+20
		bne !+
		lda #[rings_sprites]/$40 
!:
		sta  screenChars+$03f8
		sta  screenChars+$03f9

nogo:
		inc tmp
		rts

