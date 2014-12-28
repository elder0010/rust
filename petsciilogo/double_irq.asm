stabilizer_irq:
		sta reseta1 //;3
        stx resetx1 //;3
        sty resety1 //;3 

		//;Fino a qui CASO PEGGIORE max 18 cicli

		lda #<logo_irq sta $fffe //;6
	//;	lda #>logo_irq sta $ffff //;6

		asl $d019 //;6
		inc $d012 //;6 
		
		tsx

		cli //;2 
		.fill 70,NOP
		.byte $02
		brk
	
logo_irq:

		txs //;2
		
		ldx #$08    //; Wait exactly  2+(8-1)*5 = 37 cicli
!:		dex       	//  ;lines worth of
		bne !-    	// ;cycles for compare
		bit $ea     //;Minus compare
		nop        //;cycles

		//;39

blk_irq:
		lda #40+1  	//;2 
		cmp $d012   //;4
		beq !+		//;2 o 3 a seconda DEL CASO! quindi questo blocco sono 8 o 9
!:
		//;47 cicli (a cui vanno aggiunti i 7-14 di varianza prima)
		//;a questo punto sono 2 rasterlines sotto il primo irq e ho raster stabile




		lda #0
		sta $d020
		sta $d021
	

		ldx #BLUE

		
		ldy #$56
		:wait()

		stx $d020
		stx $d021

			lda #$f9
		sta $d012

		lda #<irq sta $fffe
		lda #>irq sta $ffff

		lda reseta1
		ldx resetx1
		ldy resety1
		rti