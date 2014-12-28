//;--------------------------------------
//;------WOBBLER FUNCTIONS
//;--------------------------------------

	
//;X contiene l'offset del carattere per il bordo SX
//;Y contiene l'offset del carattere per il bordo DX

.var top_border_char_start_shift = char_base+$28
.var left_border_char_start_shift = char_base+$08

.var char_11 = char_base+$8*$11
.var char_b1 = char_base+$8*$b1
.var char_b2 = char_base+$8*$b2
.var char_b3 = char_base+$8*$b3
.var char_b4 = char_base+$8*$b4

.pc = * "DRAW CHARS"
draw_chars:
//;Sopra ci sono i caratteri 5,6 da fillare
	//	inc $d020
		sty $40
		stx $41
		
		ldy #16
		lda #0 //;resetto il char
		
!:		sta top_border_char_start_shift,y
		dey
		bne !-
	
		inx
		
		//;X controlla l'altezza del char
		lda #$ff
		ldy #0
!:		
		sta top_border_char_start_shift,y
		
		iny
		dex
		bne !-
		
		ldy $40
		ldx $41


//;A sx ci sono i caratteri 1,2 da fillare
		lda patterns_sx,x
.var offs_char = 0
.for(var x=0;x<8;x++){		
		sta left_border_char_start_shift+offs_char
		.eval offs_char = offs_char+1
		
}

.eval offs_char = 0
		lda patterns_sx+16,x
.for(var x=0;x<8;x++){		
		sta left_border_char_start_shift+offs_char+8
		.eval offs_char = offs_char+1
}
	

//;A dx ci sono i caratteri 3,4 da fillare
		lda patterns_dx,y
.for(var x=0;x<8;x++){		
		sta char_b4+x			
}	


		lda patterns_dx+16,y
.for(var x=0;x<8;x++){		
		sta char_b3+x
}
		
		//;e ora ridisegno i due chars speciali
		cpy #$8
		bcs case_b
case_a:				//;8/15
		lda patterns_dx,y
		ldx #7
!:
		sta char_b1,x
		dex
		bpl !-		

		ldx #$11
		ldy #$b1
		jmp endcase
case_b:				//;0/7

 		lda patterns_dx+16,y
 		ldx #7
!:
		sta char_b1,x
		dex
		bpl !-

		ldx #$b1
		ldy #$b4
endcase:	
		stx $4aa5
		sty $4aa6

	//	dec $d020
		rts
		