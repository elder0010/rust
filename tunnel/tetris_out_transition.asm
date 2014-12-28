.align 24
.pc = * "fadeout"
fade_out_tbl:
.byte RED,RED,RED
.byte LIGHT_RED,LIGHT_RED,LIGHT_RED
.byte YELLOW,YELLOW,YELLOW
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte GRAY,GRAY,GRAY
.byte ORANGE,ORANGE,ORANGE
.byte DARK_GRAY,DARK_GRAY,DARK_GRAY
.byte BLACK


.pc = * "fade d021 out"
fade_d021_out:

		
		ldx fade_d021_pt
		lda fade_out_tbl,x
		sta $d021

		inc fade_d021_pt
		lda fade_d021_pt
		cmp #22
		bne !+
		dec fade_d021_pt
		:set_addr(erase_tetris_charset,bg_fn)
!:
		rts

erase_tetris_charset:
		ldx tetris_erase_sequence
		lda tetris_erase_sequence,x
		tax
		lda #0
		sta $2808,x //;eraso il charset

		inc tetris_erase_sequence
		lda tetris_erase_sequence
		cmp #16
		bne !+
		:set_addr(fade_d020_in,bg_fn) 
		
		lda #$80
		sta $d011

		lda #$c0
		sta $d016
!:
		rts

fade_d020_in:
		ldx fade_d021_pt
		lda fade_out_tbl,x
		sta $d020
		
		dec fade_d021_pt
		bne !+
		:set_addr(null_func,bg_fn) 
!:
		rts



