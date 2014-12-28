//;-------------------------------------------------------------------------
//; Polygon routine
//;-------------------------------------------------------------------------
.pc = $c200 "maincode"
MainCode:		
		//;jsr set_points_a
	
mainloop:	
		lda $d012
		cmp #$f6
		bne mainloop
		

	
		lda _pageflip
		eor #$ff
		sta _pageflip
		beq page_1
page_0:
		jsr point_screen_1 
	
		jmp nopage
page_1:

		jsr point_screen_2
nopage:
//inc $d020					
		//;Pulisco lo schermo
		jsr pulisci
		
		//;inc $d020
		
	//;	jsr colour_clean
	
		lda #0
		sta pointer_coordinate
		
		jsr setta_B1A3
		jsr draw_line
		
		jsr setta_A3G7
		jsr draw_line
		
		jsr setta_G7VE5
		jsr draw_line
		
		jsr setta_VE5B1
		jsr draw_line
		
		jsr setta_N0R2
		jsr draw_line
		
		jsr setta_R2BL6
		jsr draw_line
		
		jsr setta_BL6VI4
		jsr draw_line
		
		jsr setta_VI4N0
		jsr draw_line
		
		jsr setta_B1N0
		jsr draw_line
		
		
		jsr setta_VE5VI4
		jsr draw_line
		
		jsr setta_G7BL6
		jsr draw_line
		
		jsr setta_A3R2
		jsr draw_line
		
		
		lda #0
	//	sta move_pt
		
		inc move_pt
		
		lda move_pt
		cmp #20
		bne !+
		
		dec move_pt
!:
		
		/*
		jsr setta_punti_AB
		jsr draw_line
		
		jsr setta_punti_AC
		jsr draw_line
		
		jsr setta_punti_CB
		jsr draw_line
		*/
		
		
		lda pointer_coordinate
		ldy #0
which_max_write:
		sta (which_max),y
	
		
	//;	jsr colour_fill

		
		jsr move_points
	

	

		
		jmp mainloop

outloop:
		
		jmp *
		
		
move_points:
		
		//;Muovo i punti
	
		inc set_points_a+1



	inc set_points_a+1

		inc set_points_a+1
		inc set_points_a+1
			
		
		inc set_points_b+1
		inc set_points_b+1
			
		inc set_points_b+1
		inc set_points_b+1

			
		inc set_points_c+1
		inc set_points_c+1
		inc set_points_c+1
	
	//	inc $d020
		
		rts