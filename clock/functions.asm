relocate_text:
		ldx #0
!:
.for(var t=0;t<8;t++){
		lda scrolltext_source+[t*$100],x
		sta scrolltext+[t*$100],x
}
		dex
		bne !-
		rts

clean_charscreen:
		lda #0
		ldx #0
!:
		sta temp_charscreen,x
		sta temp_charscreen+$100,x
		sta temp_charscreen+$200,x
		sta temp_charscreen+$300,x
		dex
		bne !-
		rts


clock_init_sprites:

		ldx #8
!:
		//;lda #WHITE
		//;sta $d027,x

		lda #[[bubble_sprite-$3fff]/$40]
		sta screenChars+$03f8,x
		sta temp_charscreen+$03f8,x
		dex
		bpl !-

/*
		lda #LIGHT_BLUE
		sta $d02d

		lda #CYAN
		sta $d025
		lda #WHITE
		sta $d026


		lda #0
		sta $d017
		sta $d01b
		sta $d01d
		sta $d00d

		lda #%01000000
		sta $d01c

		lda #%01000000
		sta $d015
*/
		rts



clear_final_screen:
		lda #$20
		ldx #0
!:
		sta $0400,x
		sta $0400+$100,x
		sta $0400+$200,x
		sta $0400+$300,x
		dex 
		bne !-
		rts

display_bitmap:
		ldx #0
!:
		lda screenPixels+$1f40,x
		sta screenChars,x
		lda screenPixels+$1f40+$100,x
		sta screenChars+$100,x
		lda screenPixels+$1f40+$200,x
		sta screenChars+$200,x
		lda screenPixels+$1f40+$300-$8,x
		sta screenChars+$300-$8,x

		lda screenPixels+$2328,x
		sta $d800,x
		lda screenPixels+$2328+$100,x
		sta $d800+$100,x
		lda screenPixels+$2328+$200,x
		sta $d800+$200,x
		lda screenPixels+$2328+$300,x
		sta $d800+$300,x
		dex
		bne !-
		rts

.pc = * "wob pic x"
wob_pic_x:
		ldx x_wob_pt
		lda $d016
		and #$f8
		ora sin_table,x
		sta $d016
		//inc x_wob_pt //;spostato in transition / move bubble
		rts

wob_pic_y:
		ldx y_wob_pt
		lda d011val
		and #$78
		ora sin_table_y,x
		sta d011val
		inc y_wob_pt
		rts

