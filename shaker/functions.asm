draw_pic:
		//;Copio i pixels
		ldx #0
!:
		lda data_screen,x
		sta screenChars,x
	
		lda data_screen+$100,x
		sta screenChars+$100,x
		
		lda data_screen+$200,x
		sta screenChars+$200,x
		
		lda data_screen+$300-$8,x
		sta screenChars+$300-$8,x
		
		dex
		bne !-
		rts

draw_pic_colours:
		ldx #0
!:
		lda data_col,x
		sta $d800,x

		lda data_col+$100,x
		sta $d800+$100,x

		lda data_col+$200,x
		sta $d800+$200,x

		lda data_col+$300,x
		sta $d800+$300,x
		dex
		bne !-
		rts
		
.const INITIAL_Y_TOP = $23
.const INITIAL_Y_BOTTOM = $e5

init_filler_sprite:
		lda #$10
		clc
		ldx #0
!:
		sta $d000,x
		adc #44

		inx
		inx
		cpx #16
		bne !-

		ldx #8
		lda #external_border_color
!:
		sta $d027,x
		dex
		bpl !-


		lda #INITIAL_Y_TOP //;Posizione y iniziale
		sta top_y_pos

		lda #INITIAL_Y_BOTTOM
		sta bottom_y_pos

		//;normal h double w
		lda #0
		sta $d017
		lda #$ff
		sta $d01d

		
		//;Sprite priority
		lda #0
		sta $d01b

		lda #[filler_sprite]/$40
		ldx #0
!:
		sta screenChars+$03f8,x
		inx
		cpx #8
		bne !-

		lda #%11000000
		sta $d010

		lda #$0
		ldx #0
!:
		sta filler_sprite,x
		inx
		cpx #45
		bne !-

		lda #$ff
!:
		sta filler_sprite,x
		inx
		cpx #$40
		bne !-
		.print screenChars+$03f8

		rts

move_filler_sprites:
		lda bottom_y_pos //;Posizione y iniziale
		ldx #0
		
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f

		inc bottom_y_pos
		lda bottom_y_pos
		cmp #INITIAL_Y_BOTTOM+16
		bne !+
		//;ARIMETTERE
		inc can_go_scene+1
		dec bottom_y_pos
		lda #0
		sta $d015
!:
 		rts

/*
 ;move_filler_sprites_bottom:
;		lda bottom_y_pos //;Posizione y iniziale
;		ldx #0
;!:
;		sta $d001,x
;		inx
;		inx
;		cpx #16
;		bne !-

;		inc bottom_y_pos
;		lda bottom_y_pos
;		cmp #INITIAL_Y_BOTTOM+16
;		bne !+
;		dec bottom_y_pos
;!:
;		rts
*/

//;------------------------------------------------------
//;Fade degli sprites del loader (rotellina)
fade_out_sprites:
!:
		lda $d012
		cmp #$29
		bne !-
		ldx fade_pt
		lda fade_screen_tbl,x
		sta $d020
		sta $d021
dly2:
		lda #0
		eor #$ff
		sta dly2+1
		beq !+
		dec fade_pt
		lda fade_pt
		bne !+
		dec intro_end+1
!:
		rts

.align $10
fade_screen_tbl:
.byte PURPLE,PURPLE,PURPLE,GRAY,GRAY,GRAY,DARK_GRAY,DARK_GRAY,DARK_GRAY


