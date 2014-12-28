//;-----------------------------------------------------
//;Apertura zona centrale con illegal mode
//;-----------------------------------------------------

rotator_stabilizer_irq:
		sta reseta1 //;3
        stx resetx1 //;3
        sty resety1 //;3 

		//;Fino a qui CASO PEGGIORE max 18 cicli

		lda #<rotator_top_irq sta $fffe //;6
		lda #>rotator_top_irq sta $ffff //;6

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

rotator_top_irq:
		txs //;2
		
		ldx #$08    //; Wait exactly  2+(8-1)*5 = 37 cicli
!:		dex       	//  ;lines worth of
		bne !-    	// ;cycles for compare
		bit $ea     //;Minus compare
		nop         //;cycles

		//;39

		lda #ILLEGAL_START+1  	//;2 
		cmp $d012   //;4
		beq !+		//;2 o 3 a seconda DEL CASO! quindi questo blocco sono 8 o 9
!:
		//;47 cicli (a cui vanno aggiunti i 7-14 di varianza prima)
		//;a questo punto sono 2 rasterlines sotto il primo irq e ho raster stabile

y_offs:
		lda #$1b
		sta $d011
		lda #$c8
		sta $d016

		lda # [[[rotator_screen & $3fff] / $0400] << 4] + [[[rotator_chars & $3fff] / $0800] << 1]
		sta $d018

		lda #0
		sta $dd00


		lda $d012
!:
		cmp $d012
		bne !-
		//;Vai con la tabella
		
		nop
		nop
		
pt_rt:
		ldx #0
		lda colour_table,x
		.var t
		.for ( t=0;t<10;t++)
		{
			
		
			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta $d021
			inx
			lda colour_table,x  

			ldy #1
			:wait()
			nop
			nop

			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta $d021
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

		}


		lda #0
		sta $d021


		ldx #$3b
		stx $d011
		:bank_1()

		lda #$d8
		sta $d016

		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018

		asl $d019

		lda #<rotator_bottom_irq sta $fffe
		lda #>rotator_bottom_irq sta $ffff

	
		lda #$fb
		sta $d012
		
		lda reseta1
		ldx resetx1
		ldy resety1
		rti


rotator_bottom_irq:
		:open_irq()
			
		lda #<rotator_stabilizer_irq sta $fffe
		lda #>rotator_stabilizer_irq sta $ffff
		
		lda #ILLEGAL_START
		sta $d012

		inc $d020
		jsr $1003
		dec $d020

		lda #0
		sta $d021

		jsr draw_frame

		asl $d019
	//	inc pt_rt+1
		:close_irq()
		rti


draw_frame:
		clc
		lda #0
		sta yfs+1

		ldy $16

		inc $16

		lda rotator_frame_address_lo,y
		sta ff1+1
		adc #40
		bcc !+
		inc yfs+1
!:
		sta ff2+1

		lda rotator_frame_address_hi,y
		sta ff1+2
yfs:
		adc #0
		sta ff2+2


		ldy #0
		ldx #0
!:
ff1:
		lda frames,x
		sta rotator_screen,x
ff2:
		lda frames+40,x
		sta rotator_screen+40,x
		dex
		bne !-
		rts

.align $100
.pc = * "colour table"
.import source "data/rotator_colors.asm"
.align $100
.pc = * "rotator_frame_address"
.var tt = 0
.align $100
rotator_frame_address_lo:
.for (tt=0;tt<50;tt++){
	.byte <frames+[tt*40]
}

.align $100
rotator_frame_address_hi:
.for (tt=0;tt<50;tt++){
	.byte >frames+[tt*40]
}


.pc = $a000 "rotator_frames"
frames:
.import binary "data/rotator_1.raw"


.pc = $c000 "rotator chars"
rotator_chars:
.import binary "data/rotator_char.raw"

.pc = $c940 - 40
rotator_screen:



