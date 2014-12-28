.macro init_chunky_screen(){
//;-------------------------------------------------------------------------
//; Wait for VBLANC
//;-------------------------------------------------------------------------
		//:wait_frame()
	!:
		bit $d011
		bpl !-
	!:
		bit $d011
		bmi !-

//;-------------------------------------------------------------------------
//; Perform halfvariance polling
//;-------------------------------------------------------------------------
		ldx $d012
		inx
		cpx $d012
		bne * - 3
		ldy #$0a
		dey
		bne * - 1
		inx
		cpx $d012
		nop
		beq Time_1
		nop
		bit $24
Time_1:
		ldy #$09
		dey
		bne * - 1
		nop
		nop
		inx
		cpx $d012
		nop
		beq Time_2
		bit $24
Time_2:	
		ldy #$0a
		dey
		bne * - 1
		inx
		cpx $d012
		bne Time_3
Time_3:
	//;QUI é STATO SMANETTATO	
	//;	nop
		nop
		
		nop
		bit $24
		bit $24
		//nop
		

	
//;-------------------------------------------------------------------------
//; Raster is stable here.
//; Launch a continous timer which a count of 63.
//;-------------------------------------------------------------------------
		lda #$3e
		sta $dc04
		sty $dc05
		lda #$11
		sta $dc0e

		ldx #0
		stx _pageflip

		lda #$7f
		sta $dc0d
		sta $dd0d
		lda #1
		sta $d01a
		sta $d019
//;-------------------------------------------------------------------------
//; Setup interrupt position
//;-------------------------------------------------------------------------
		lda #RasterRow
		sta $d012

		lda #<irq
		sta $fffe
		lda #>irq
		sta $ffff
		lda $dc0d
		lda $dd0d
	
	//	asl $d019


		jsr testCIAVersion
		lda oldCIA
		beq !+
		ldx #<nmiirq_old_cia
		ldy #>nmiirq_old_cia
		jmp store_irq
!:
		lda #>_p_1_new+1
		sta P1_0+2
		sta P1_1+2
		lda #<_p_1_new+1
		sta P1_0+1
		sta P1_1+1
	
		lda #>_p_2_new+1
		sta P2_0+2
		sta P2_1+2
		lda #<_p_2_new+1
		sta P2_0+1
		sta P2_1+1

		ldx #<nmiirq_new_cia
		ldy #>nmiirq_new_cia
		jmp store_irq
	
store_irq:
		stx $fffa
		sty $fffb
		
		lda $dc0d
		lda $dd0d

//;-------------------------------------------------------------------------
//; Setup the timer adjusted to work every eight row, (63 * 8) - 1 cycles
//;-------------------------------------------------------------------------
		lda #$f7
		sta $dd04
		lda #$01
		sta $dd05

		:fire_up_chunky_screen()

		}


.macro fire_up_chunky_screen(){	
	lda #$3b
	sta $d011
	lda $d016
	ora #%00010000
	sta $d016
	lda $dd00
	and #%11111100
	ora #%00000010
	sta $dd00
}


testCIAVersion:

		//; Set NMI vector
		lda #<continue
		sta $fffa
		lda #>continue
		sta $fffb

		lda #$81  //;also don't forget to set mask. Setting $01 to an appropriate value will also help :-) (Bitbreaker/Oxyron)
		sta $dd0d

		//; Set timer to 5 cycles
		lda #4
		sta $dd04
		lda #0
		sta $dd05

		//; Clear the detection flag
		sta oldCIA

		//; Fire a 1-shot timer
		lda #%10011001
		sta $dd0e

		//; This should be interrupted before the INC
		//; only if it's a newer chip.
		lda $dd0d
		lda $dd0d
		inc oldCIA
		
		jmp * //; just in case

continue:
		lda $dd0d
		pla
		pla
		pla
		
		rts




disegna_pic_debug:
		
		
//;Disegno la pic
		ldx #0
!:

		lda $9000,x
		sta offset_0,x
		sta offset_2,x
		
		lda $9000+$100,x
		sta offset_0+$100,x
		sta offset_2+$100,x
		
		lda $9000+$200,x
		sta offset_0+$200,x
		sta offset_2+$200,x
	
		lda $9000+$300,x
		sta offset_0+$300,x
		sta offset_2+$300,x
	
	
	
		lda $9400,x
		sta offset_1,x
		sta offset_3,x

	

		lda $9400+$100,x
		sta offset_1+$100,x
		sta offset_3+$100,x
	
		lda $9400+$200,x
		sta offset_1+$200,x
		sta offset_3+$200,x
	
		lda $9400+$300,x
		sta offset_1+$300,x
		sta offset_3+$300,x


		dex
		bne !-
		rts

fill_screen_pixels:	
	ldx #0
	lda #%10100101
FillScreen:
	sta $4000, x
	sta $4100, x
	sta $4200, x
	sta $4300, x
	sta $4400, x
	sta $4500, x
	sta $4600, x
	sta $4700, x
	sta $4800, x
	sta $4900, x
	sta $4a00, x
	sta $4b00, x
	sta $4c00, x
	sta $4d00, x
	sta $4e00, x
	sta $4f00, x
	sta $5000, x
	sta $5100, x
	sta $5200, x
	sta $5300, x
	sta $5400, x
	sta $5500, x
	sta $5600, x
	sta $5700, x
	sta $5800, x
	sta $5900, x
	sta $5a00, x
	sta $5b00, x
	sta $5c00, x
	sta $5d00, x
	sta $5e00, x
	sta $5f00, x
	inx
	bne FillScreen
	
	/**
	ldy #0
	.var pointer = $32
	 lda #$00
	 sty pointer 
	 lda #$40
	 sta pointer+1
	 lda #$00
	 ldy #$18
!:
	 sta (pointer),y
	 dey

	 bpl !-
	 clc
	 lda pointer
	 adc #$40
	 sta pointer
	 lda pointer+1
	 adc #$01
	 sta pointer+1
	 cmp #$60 
	 lda #$00
	 ldy #$18
	 bcc !-
	*/
	
	ldx #0
	lda #$11
SetColorloop:
	sta $6000, x
	sta $6400, x
	sta $6100, x
	sta $6500, x
	sta $6200, x
	sta $6600, x
	sta $6300, x
	sta $6700, x
	sta $6000 + $800, x
	sta $6400 + $800, x
	sta $6100 + $800, x
	sta $6500 + $800, x
	sta $6200 + $800, x
	sta $6600 + $800, x
	sta $6300 + $800, x
	sta $6700 + $800, x
	dex
	bne SetColorloop	


	 rts