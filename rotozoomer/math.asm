m16x8:			// 16bit*8bit => 16 bit (hi) [Xa]x[Y] => [AY_]	(X kept)
				stx T1
				sty T2+1
                sta sm1a+1
                sta sm3a+1
                eor #$ff
                sta sm2a+1
                sta sm4a+1
                txa				
                sta sm1b+1
                sta sm3b+1
                eor #$ff
                sta sm2b+1
                sta sm4b+1
                           
sm1a:           lda square1_lo,y
sm2a:           cmp square2_lo,y                
sm3a:           lda square1_hi,y
sm4a:           sbc square2_hi,y
                sta _AA+1

                sec
sm1b:           lda square1_lo,y
sm2b:           sbc square2_lo,y
                sta _cc+1
sm3b:           lda square1_hi,y
sm4b:           sbc square2_hi,y
                sta _CC+1

                clc
_AA:            lda #0
_cc:            adc #0
                tay
				lda #00
_CC:            adc #00				
                bit T1
                bpl !+				
				sec
T2:				
				sbc #$00
!:				
                rts
				
				
// Create 4 tables of square for multiplication routines
// *****************************************************
createtable:
	lda #$0
	sta lo
	sta mi
	sta hi
	sta oddhi
	sta oddmi
	ldy #$01
	sty oddlo	
ctloop1:	
	lda lo
	sta clo
	lda mi
	sta cmi
	lda hi
	sta chi
	
	lsr chi	
	ror cmi
	ror clo
	lsr chi	
	ror cmi
	ror clo
	
	lda cmi
sq1l:	
	sta square1_hi,x
	lda clo
sq1h:		
	sta square1_lo,x
	
	clc
	lda lo
	adc oddlo
	sta lo
	lda mi
	adc oddmi
	sta mi
	lda hi
	adc oddhi
	sta hi
	
	clc
	lda oddlo
	adc #$02
	sta oddlo
	lda oddmi
	adc #$00
	sta oddmi
	lda oddhi
	adc #$00
	sta oddhi	
	
	inx
	bne ctloop1
	inc sq1h+2
	inc sq1l+2	
	dey
	bpl ctloop1
	
	ldy #$ff
	ldx #$00
ctloop2:
	lda square1_lo,y
	sta square2_lo,x
	lda square1_hi,y
	sta square2_hi,x	
	lda square1_lo,x
	sta square2_lo+$100,x
	lda square1_hi,x
	sta square2_hi+$100,x		
	dey
	inx
	bne ctloop2
	rts

	