//;--------------------------------------
//;Init stuff
//;--------------------------------------
init_scene:
	
	lda #$c0
	sta $d016

	lda start_offsets
	sta start_offset
		
	lda #0
	sta clean_or_draw
	sta fade_pt
	sta pezzi_caduti
	sta delay_timer
	sta current_y
	sta current_pezzo
	sta $d015
	jsr reset_screen_pointers

	jsr clear_screen
	jsr prepare_charset
	//;ldx current_pezzo
	rts


prepare_charset:
	//;Riloco il charset

	lda #0
	ldx #8
!:
	sta screenPixels,x
	dex
	bne !-

	lda #$fe
	ldx #16
!:
	sta screenPixels,x
	dex
	cpx #8
	bne !-



	ldx #0
!:
//;Copio il charset
.for(var t=0;t<8;t++){	
	lda skull_chars_src+[t*$100],x
	sta screenPixels+[t*$100],x	
}
	dex
	bne !-


	rts


clear_screen:

	lda #0
	ldx #0
!:
.for(var t=0;t<4;t++){	
	//clc	
	//lda skull_screen_src+[t*$100],x
	//adc #2

	sta screenChars+[t*$100],x	
}
	dex
	bne !-

	lda #SKULL_COLOUR
!:
	sta $d800,x
	sta $d800+$100,x
	sta $d800+$200,x
	sta $d800+$300,x
	dex
	bne !-
	

//;Pulisco lo schermo, per linea
	lda #0
	ldy #0
!:
	ldx #13

tg:
	sta screenChars,x
	inx
	cpx #40
	bne tg

	:go_down_one_line(tg)
	iny
	lda #0
	cpy #26
	bne !-


	rts

//;--------------------------------------
//;Resetta i puntatori da capo
//;--------------------------------------
reset_screen_pointers:
	
	lda #>$d800
	sta colour_ram+2

	lda #<$d800
	sta colour_ram+1
	
	lda #>screenChars
	sta schermo+2

	lda #<screenChars
	sta schermo+1

	rts

