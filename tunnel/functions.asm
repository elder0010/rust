
//;Disegna il prossimo frame del tunnel
next_frame:
		inc delayer
		lda delayer
		cmp #2
		bne !+

		lda #0
		sta delayer
		
		inc frame_pt
		lda frame_pt
		cmp #6
		bne !+
		lda #0
		sta frame_pt
!:	
		ldx frame_pt
		lda frame_table_up,x
		sta UP_D018+1
		
		lda frame_table_down,x
		sta DOWN_D018+1
		
UP_D018:		
		lda #$c0
		sta $d018
		
		lda $DD00
		and #%11111100
		ora bank_table,x
		sta $DD00
		rts

init_sprites:
		//;Copio gli sprites da $7c40 a SPRITE AREA 2 e SPRITE AREA 3 (gli altri due banchi)
		//;Sono 8 sprites = $200 bytes
		
		/*
		ldx #0
!:		
		lda $7c40,x
		sta SPRITE_AREA_2,x
		sta SPRITE_AREA_3,x
		lda $7c40+$100,x
		sta SPRITE_AREA_2+$100,x
		sta SPRITE_AREA_3+$100,x
		dex
		bne !-
		*/

		ldx #0
		lda #0
!:
		sta SPRITE_AREA_1,x
		sta SPRITE_AREA_2,x
		sta SPRITE_AREA_3,x
		sta SPRITE_AREA_1+$100,x
		sta SPRITE_AREA_2+$100,x
		sta SPRITE_AREA_3+$100,x 
		sta sprites_area_1,x
		sta sprites_area_1+$100,x
		sta buffer_area,x
		sta buffer_area+$100,x
		sta buffer_area+$200,x
		sta buffer_area+$300,x
		dex
		bne !-
		
		stx $d010
		
		ldx #$ff
		ldx #0
		stx $d017 //;2x height
		stx $d01d //;2x width
		
		//;Punto gli sprites: banco 1
		ldx #0
		stx $d01c
		lda #[sprites_area_1-$4000]/$40
!:
		sta FRAME_1_SCREEN+$03f8,x
		sta FRAME_2_SCREEN+$03f8,x
		sta FRAME_3_SCREEN+$03f8,x
		clc
		adc #1
		inx
		cpx #8
		bne !-
		
		//;Punto gli sprites: banco 2
		ldx #0
		
		lda #[SPRITE_AREA_2-$8000]/$40
!:
		sta FRAME_4_SCREEN+$03f8,x
		sta FRAME_5_SCREEN+$03f8,x
		clc
		adc #1
		inx
		cpx #8
		bne !-
		
		//;Punto gli sprites: banco 3
		ldx #0
		
		lda #[SPRITE_AREA_3-$c000]/$40
!:
		sta FRAME_6_SCREEN+$03f8,x
		clc
		adc #1
		inx
		cpx #8
		bne !-
		
	
		lda #text_color
		ldx #0
!:
		sta $D027,x
		
		inx
		cpx #8
		bne !-


//;-----------------------------------
//;Posiziono gli sprites	
		ldx #0
		ldy #0
				
sprite_pos:
		clc
		lda sprite_x_min_lo
		adc #82
	
		sta $d000,y
		
cury:
		lda #SPRITE_Y_START
		sta $d001,y
		
		inc cury+1
		
		inx
		iny
		iny
		cpx #8
		bne sprite_pos
	
		rts


draw_screens:
		jsr mv_scr
		jsr drw_scr

		rts
		

.import source "sprite_movements.asm"

.pc = $ba70 "move screens"
.var frame_6_table_down = $e800
mv_scr:
			//;Sposto primo screen a $2800
		ldx #0
!:
.for(var t=0;t<=7;t++){
		lda frame_6_table_down+t*$100,x
		sta $2800+t*$100,x
}	
		dex
		bne !-

		//;Sposto secondo screen a $3000
		ldx #0
!:
.for(var t=0;t<=7;t++){
		lda frame_6_table_up+t*$100,x
		sta $3000+t*$100,x
}	
		dex
		bne !-

		rts

drw_scr:

		//;FRAME 6 TABLE UP
		ldx #0
!:
		lda $3000,x
		sta FRAME_6_SCREEN,x
		
		lda $3000+$100,x
		sta FRAME_6_SCREEN+$100,x
		dex
		bne !-
			
		ldx #0
!:

		lda $2800+$200,x
		sta FRAME_6_SCREEN+$200,x
		
		lda $2800+$300,x
		sta FRAME_6_SCREEN+$300,x

		dex
		bne !-
		rts