//;-------------------------------------------------------------------------
//; Polygon routine
//;-------------------------------------------------------------------------
.pc = $c000 "maincode"
.align $8
and_table:
.byte %00000001
.byte %00000010
.byte %00000100
.byte %00001000
.byte %00010000
.byte %00100000
.byte %01000000
.byte %10000000

MainCode:		
		//;jsr set_points_a
		
		lda #148
		sta move_pt
		
mainloop:	
		lda $d012
		cmp #$e0
		bne mainloop
		
		

		lda _pageflip
		eor #$ff
		sta _pageflip
		beq page_1
page_0:
		//;jsr point_screen_1
		:point_screen_1()
		jmp nopage
page_1:
		//;jsr point_screen_2
		:point_screen_2()
		
nopage:
	
clean_routine:
		jsr colour_clean_a
		
			
		
		lda #0
		sta pointer_coordinate

		
		jmp fskip_3
//;--------------------------------------
//;Faccia 0
//;--------------------------------------		
		ldx move_pt
		lda facce_disegnabili,x
		and and_table+0
		bne !+
		jmp fskip_0
!:
		//;Devo settare max_min a seconda dello schermo

		:set_colour_face_1()

		jsr clean_buffer
		
		jsr setta_B1A3
		jsr draw_line
		

		jsr setta_A3R2
		jsr draw_line
	
		//;jmp fskip_5
		
		jsr setta_R2N0
		jsr draw_line
	
		jsr setta_N0B1
		jsr draw_line

		jsr colour_fill
fskip_0:		
		

		
//;--------------------------------------
//;Faccia 1
//;--------------------------------------
		
		ldx move_pt
		lda facce_disegnabili,x
		and and_table+1
		bne !+
		jmp fskip_1
!:		
		:set_colour_face_2()
		jsr clean_buffer
	
		jsr setta_A3R2
		jsr draw_line

		jsr setta_BL6R2
		jsr draw_line

		jsr setta_G7BL6
		jsr draw_line

		jsr setta_A3G7
		jsr draw_line

		jsr colour_fill
fskip_1:		

		
//;--------------------------------------
//;Faccia 2
//;--------------------------------------	
		ldx move_pt
		lda facce_disegnabili,x
		and and_table+2
		bne !+
		jmp fskip_2
!:		
		:set_colour_face_3()
		jsr clean_buffer
	
		jsr setta_G7BL6
		jsr draw_line

		jsr setta_VI4BL6
		jsr draw_line

		jsr setta_VE5VI4
		jsr draw_line

		jsr setta_G7VE5
		jsr draw_line

		jsr colour_fill
fskip_2:		
		
//;--------------------------------------
//;Faccia 3
//;--------------------------------------		
		ldx move_pt
		lda facce_disegnabili,x
		and and_table+3
		bne !+
		jmp fskip_3
!:		

		:set_colour_face_4()
		jsr clean_buffer

		jsr setta_VE5BI1
		jsr draw_line
		
		jsr setta_N0B1
		jsr draw_line
	
		jsr setta_VI4N0
		jsr draw_line

		jsr setta_VE5VI4
		jsr draw_line

		jsr colour_fill
fskip_3:			

		
//;--------------------------------------
//;Faccia 4
//;--------------------------------------			
		ldx move_pt
		lda facce_disegnabili,x
		and and_table+4
		bne !+
		jmp fskip_4
!:		
		
		:set_colour_face_5()
		jsr clean_buffer
	
		jsr setta_BL6R2
		jsr draw_line

		jsr setta_VI4BL6
		jsr draw_line
		
		jsr setta_VI4N0
		jsr draw_line
	
	
		jsr setta_R2N0
		jsr draw_line

		//jsr colour_fill
		
fskip_4:	
		
//;--------------------------------------
//;Faccia 5
//;--------------------------------------	
		ldx move_pt
		lda facce_disegnabili,x
		and and_table+5
		bne !+
		jmp fskip_5
!:
		
		:set_colour_face_6()
		jsr clean_buffer
	
		jsr setta_A3G7
		jsr draw_line

		jsr setta_B1A3
		jsr draw_line

		jsr setta_VE5BI1
		jsr draw_line

		jsr setta_G7VE5
		jsr draw_line
		
		jsr colour_fill
fskip_5:			

	
		
		/*
		inc move_pt
	*/	
	//	inc move_pt
	
		inc move_pt
	//	jmp mainloop
		
		inc _pageflip
		jmp outloop

outloop:
		
		jmp *

	


