.pc = * "bmp wob routine start"	
//;-----------------------------------
//;WOBBLA IL BORDO SX
//;-----------------------------------
wob_bordo_sx:

		lda bitmap_char_1
		ldx #0
!:
.var girl_start = pixels_tizia_start

.var start = 16

.for(var x=start;x<=24;x++){
		sta pixels_tizia_start,x
		.eval linea = linea+1
		.eval pixels_tizia_start = screenPixels + linea*40*8 + char*8 
}
		inx
		cpx #8
		bne !-
		
		.var endy = 25
		.eval linea = 17
.if(extra_line){
		.eval linea = 16
		.eval endy = 26
}
		.eval char = char+1
		lda bitmap_char_2
		ldx #0
!:
.for(var x=18;x<=endy;x++){
		sta pixels_tizia_start,x
		.eval linea = linea+1
		.eval pixels_tizia_start = screenPixels + linea*40*8 + char*8 
}
		inx
		cpx #8
		bne !-
		rts

.eval linea = 17
.eval char = 37
//;-----------------------------------
//;WOBBLA IL BORDO DX
//;-----------------------------------
wob_bordo_dx:
	
		.eval linea = 16
		.eval start = 16
	
		lda bitmap_char_2
		ldx #0
!:
.for(var x=start;x<=26;x++){
		sta pixels_tizia_start,x
		.eval pixels_tizia_start = screenPixels + linea*40*8 + char*8 
		.eval linea = linea+1
}
		inx
		cpx #8
		bne !-

		.eval linea = 16
		.eval char = char+1
		.eval pixels_tizia_start = screenPixels + linea*40*8 + char*8 
		
		lda bitmap_char_1
		ldx #0
!:
.for(var x=start;x<=26;x++){
		sta pixels_tizia_start,x
		.eval pixels_tizia_start = screenPixels + linea*40*8 + char*8 
		.eval linea = linea+1
}
		inx
		cpx #8
		bne !-
		rts

//;MAIN DA CHIAMARE
.var left_border_char_start = char_base+8
.var right_border_char_start = char_base+$8*$b3
wob_bitmap:
		lda left_border_char_start //;primo_byte_primo_char_sx
		sta bitmap_char_1 //; variabile zeropage
		
		lda left_border_char_start+8 //;primo_byte_secondo_char_sx
		sta bitmap_char_2 //; variabile zeropage
		jsr wob_bordo_sx

		lda right_border_char_start+8 //;primo_byte_primo_char_dx
		sta bitmap_char_1 //; variabile zeropage
		
		lda right_border_char_start //;primo_byte_secondo_char_dx
		sta bitmap_char_2 //; variabile zeropage	
	
		jsr wob_bordo_dx

		rts
	
.pc = * "bmp wob routine end"		