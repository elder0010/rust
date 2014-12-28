//;-------------------------------------------------------------------------
//; Clear del frame
//;-------------------------------------------------------------------------
/*
pulisci:
	
		lda #0
		sta dot_pt
		tay
c_next_point:
	//;	ldy #0
		
clean_max:
		cpy #0
		//;cmp (which_max),y
		beq c_end_line //;ho finito di pulire la retta
		
		//;tax
c_buffer_lo_inside:	
		lda clean_buffer_0_lo,y //;era x prima della lax
		sta screen_target_c+1
		
c_buffer_hi_inside:	
		lda clean_buffer_0_hi,y //;era x prima della lax
		sta screen_target_c+2

which_y_load:		
		ldx y_add_0,y 
	//;	tay
		
		lda #$00
screen_target_c:
		sta $ffff,x
		//;sta (target_base_screen),y
		
		//;inc dot_pt
		
		iny
		jmp c_next_point
c_end_line:		
	
		rts
*/
		

init_scene:
		
		lda #11
		sta current_x
		
		lda #0
		sta current_y
		sta dot_pt
		sta puntatore_pt
		sta vector_point_1
		sta vector_point_2
		
		
		lda #<max_points
		sta which_max
		
		lda #>max_points
		sta which_max+1
		//;coords
		lda #30
		sta x_1
		
		lda #40
		sta y_1
		
		//;PUNTI BUONI
		lda #40
		sta x_2
		
		lda #39
		sta y_2
		
		rts
		

		
.pc = * "line calc function"
.import source "line_calc.asm"




//;-------------------------------------------------------------------------
//; Setta i punti da disegnare e incrementa i counter per il prox frame
//;-------------------------------------------------------------------------
//;.macro set_points(){
//;.import source "main_routines/set_points_basic.asm"
//;.import source "main_routines/set_points_polygon.asm"
.import source "main_routines/set_points_cubo.asm"
//}		




//;-------------------------------------------------------------------------
//; Macro per double buffering
//;-------------------------------------------------------------------------
.macro point_screen_1(){
//point_screen_1:

		
		lda #>targetHiBuffer1
		sta target_buffer_hi+2
		sta target_buffer_hi_a+2
		sta fill_bf_src_hi+2
	
		
		lda #<targetHiBuffer1
		sta target_buffer_hi+1
		sta target_buffer_hi_a+1
		sta fill_bf_src_hi+1
	
		
		lda #>colour_clean_a
		sta clean_routine+2
		
		
		
	//	rts
}



.macro point_screen_2(){
//;point_screen_2:


		lda #>targetHiBuffer2
		sta target_buffer_hi+2
		sta target_buffer_hi_a+2
		sta fill_bf_src_hi+2
	
		
		lda #<targetHiBuffer2
		sta target_buffer_hi+1
		sta target_buffer_hi_a+1
		sta fill_bf_src_hi+1

		
		
		lda #>colour_clean_b
		sta clean_routine+2
	
}






//;--------------------------------------
//;MACRO COLORI					
//;--------------------------------------
.macro set_colour_face_1(){

		ldx move_pt
		lda colori_frames_0,x
		
		tax
		lda tab_colori_0,x
		
		sta $20
		sta fill_col_all_1+1
		
		and #$f0
		sta fill_col_sx_1+1
		sta fill_col_sx_2+1
		 
		sta line_col_sx_1+1
		sta line_col_sx_2+1
		
		lda $20
		and #$0f
		sta fill_col_dx_1+1
		sta line_col_dx_1+1
		sta line_col_dx_2+1
		sta fill_col_dx_2+1	 
}

.macro set_colour_face_2(){
		ldx move_pt
		lda colori_frames_1,x
		
		tax
		lda tab_colori_1,x
		
		sta $20
		sta fill_col_all_1+1
		
		and #$f0
		sta fill_col_sx_1+1
		sta fill_col_sx_2+1
		 
		sta line_col_sx_1+1
		sta line_col_sx_2+1
		
		lda $20
		and #$0f
		sta fill_col_dx_1+1
		sta line_col_dx_1+1
		sta line_col_dx_2+1
		sta fill_col_dx_2+1	 
		 
}

.macro set_colour_face_3(){
			ldx move_pt
		lda colori_frames_2,x
		
		tax
		lda tab_colori_2,x
		
		sta $20
		sta fill_col_all_1+1
		
		and #$f0
		sta fill_col_sx_1+1
		sta fill_col_sx_2+1
		 
		sta line_col_sx_1+1
		sta line_col_sx_2+1
		
		lda $20
		and #$0f
		sta fill_col_dx_1+1
		sta line_col_dx_1+1
		sta line_col_dx_2+1
		sta fill_col_dx_2+1	 
		 	
}

.macro set_colour_face_4(){
			ldx move_pt
		lda colori_frames_3,x
		
		tax
		lda tab_colori_3,x
		
		sta $20
		sta fill_col_all_1+1
		
		and #$f0
		sta fill_col_sx_1+1
		sta fill_col_sx_2+1
		 
		sta line_col_sx_1+1
		sta line_col_sx_2+1
		
		lda $20
		and #$0f
		sta fill_col_dx_1+1
		sta line_col_dx_1+1
		sta line_col_dx_2+1
		sta fill_col_dx_2+1	 
		 	
}

.macro set_colour_face_5(){
		ldx move_pt
		lda colori_frames_4,x
		
		tax
		lda tab_colori_4,x
		
		sta $20
		sta fill_col_all_1+1
		
		and #$f0
		sta fill_col_sx_1+1
		sta fill_col_sx_2+1
		 
		sta line_col_sx_1+1
		sta line_col_sx_2+1
		
		lda $20
		and #$0f
		sta fill_col_dx_1+1
		sta line_col_dx_1+1
		sta line_col_dx_2+1
		sta fill_col_dx_2+1	 
		 
		 	
}

.macro set_colour_face_6(){
		ldx move_pt
		lda colori_frames_5,x
		
		tax
		lda tab_colori_5,x
		
		sta $20
		sta fill_col_all_1+1
		
		and #$f0
		sta fill_col_sx_1+1
		sta fill_col_sx_2+1
		 
		sta line_col_sx_1+1
		sta line_col_sx_2+1
		
		lda $20
		and #$0f
		sta fill_col_dx_1+1
		sta line_col_dx_1+1
		sta line_col_dx_2+1
		sta fill_col_dx_2+1	 
		
}


/*
disegna_pic_debug:
		
		
//;Disegno la pic
		ldx #0
!:
	

		lda $9000,x
		sta offset_0,x
		sta offset_2,x
		
		lda $9000+$100,x
		sta offset_0+$100,x
		sta offset_2+$100,x
		
		lda $9000+$200,x
		sta offset_0+$200,x
		sta offset_2+$200,x
	
		lda $9000+$300,x
		sta offset_0+$300,x
		sta offset_2+$300,x
	
	
		lda $9400,x
		sta offset_1,x
		sta offset_3,x
		
		lda $9400+$100,x
		sta offset_1+$100,x
		sta offset_3+$100,x
	
		lda $9400+$200,x
		sta offset_1+$200,x
		sta offset_3+$200,x
	
		lda $9400+$300,x
		sta offset_1+$300,x
		sta offset_3+$300,x


		dex
		bne !-
		rts
	
prepara_pic:
		
		//;Disegno la pic
		ldx #0
!:
		lda $9000,x
		sta source_buffer_0,x
		
		lda $9000+$100,x
		sta source_buffer_0+$100,x
		
		lda $9000+$200,x
		sta source_buffer_0+$200,x
	
		lda $9000+$300,x
		sta source_buffer_0+$300,x
	
		lda $9400,x
		sta source_buffer_1,x

		lda $9400+$100,x
		sta source_buffer_1+$100,x
		
		lda $9400+$200,x
		sta source_buffer_1+$200,x
	
		lda $9400+$300,x
		sta source_buffer_1+$300,x
		
		dex
		bne !-
		rts
*/			
//;Test CIA Type
testCIAVersion:
		//; Set NMI vector
		lda #<continue
		sta $fffa
		lda #>continue
		sta $fffb

		lda #$81  //;also don't forget to set mask. Setting $01 to an appropriate value will also help :-) (Bitbreaker/Oxyron)
		sta $dd0d

		//; Set timer to 5 cycles
		lda #4
		sta $dd04
		lda #0
		sta $dd05

		//; Clear the detection flag
		sta oldCIA

		//; Fire a 1-shot timer
		lda #%10011001
		sta $dd0e

		//; This should be interrupted before the INC
		//; only if it's a newer chip.
		lda $dd0d
		lda $dd0d
		inc oldCIA
		
		jmp * //; just in case

continue:
		lda $dd0d
		pla
		pla
		pla
		
		rts

draw_ritocchi:
		
		:point_screen_1()
		jsr prefill_faccia_1

		:point_screen_2()
		jsr prefill_faccia_1		
		
		rts
		
.macro pixelletto(v,x,y){
		lda #v
		sta getLineAddresses($6000,y)+x
		sta getLineAddresses($6800,y)+x
}

