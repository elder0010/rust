//;-----------------------------------------------------
//;Apertura zona centrale con illegal mode
//;-----------------------------------------------------

stabilizer_outro_irq:
		sta reseta1 //;3
        stx resetx1 //;3
        sty resety1 //;3 

		//;Fino a qui CASO PEGGIORE max 18 cicli

		lda #<illegal_top_outro_irq sta $fffe //;6
		lda #>illegal_top_outro_irq sta $ffff //;6

		asl $d019 //;6
		inc $d012 //;6 
		
		tsx

		cli //;2 
		.for (var x=0;x<10;x++){
			nop //;2
		}
  		
		brk
	
.align $2
.pc = *+1

illegal_top_outro_irq:
		txs //;2
		
		ldx #$08    //; Wait exactly  2+(8-1)*5 = 37 cicli
!:		dex       	//  ;lines worth of
		bne !-    	// ;cycles for compare
		bit $ea     //;Minus compare
		nop         //;cycles

		//;39

		lda #60  	//;2 
		cmp $d012   //;4
		beq !+		//;2 o 3 a seconda DEL CASO! quindi questo blocco sono 8 o 9
!:
		//;47 cicli (a cui vanno aggiunti i 7-14 di varianza prima)
		//;a questo punto sono 2 rasterlines sotto il primo irq e ho raster stabile

		ldy #9
		:wait()
		
		lda #$7b
		sta $d011

		ldx #$3b

		lda illegal_end



		//lda #$a0
!:
		cmp $d012
		bne !- 
		stx $d011

		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018


		asl $d019

		lda #<illegal_bottom_outro_irq sta $fffe
		lda #>illegal_bottom_outro_irq sta $ffff

	
		lda #$fa
		sta $d012
		
		lda reseta1
		ldx resetx1
		ldy resety1
		rti


illegal_bottom_outro_irq:
		:open_irq()

		asl $d019
		
		lda #<stabilizer_outro_irq sta $fffe
		lda #>stabilizer_outro_irq sta $ffff
		
		lda #ILLEGAL_START

		sta $d012

		ldx illegal_pt
		lda illegal_table,x
		clc
		adc #4
		sta illegal_end
		inc illegal_pt

		lda illegal_pt
		cmp #98
		bne !+
		
		lda #<final_irq sta $fffe
		lda #>final_irq sta $ffff

		lda #$f9
		sta $d012
	
!:
		jsr $1003
		jsr frame_count

		:close_irq()
		rti