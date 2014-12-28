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
		jsr point_screen_1 //RIMETTERE 1
	
		jmp nopage
page_1:

		jsr point_screen_2
nopage:
//inc $d020					
		//;Pulisco lo schermo
		jsr pulisci
		
		jsr colour_clean
	
		lda #0
		sta pointer_coordinate
		
		jsr setta_punti_AB
		jsr draw_line
		
		jsr setta_punti_AC
		jsr draw_line
		
		jsr setta_punti_CB
		jsr draw_line
		
		lda pointer_coordinate
		ldy #0
which_max_write:
		sta (which_max),y
	
		
		jsr colour_fill

		
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