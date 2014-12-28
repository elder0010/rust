.pc = $0c00 "maincode"
MainCode:		
		jsr set_points

mainloop:	
!:
		lda $d012
		cmp #$f0
		bne !-

	
		lda _pageflip
		eor #$ff
		sta _pageflip
		beq page_1
page_0:
		jsr point_screen_1	
		lda #LIGHT_RED
		jmp nopage
page_1:

		jsr point_screen_2
nopage:
	
			
//		lda #YELLOW
		sta $d020
		
		//;Pulisco lo schermo
		jsr pulisci
		
		
		lda #RED
		sta $d020
		
		//;Calcolo la linea con bresenham
		jsr draw_line
		//; metto il segnaposto per fermarmi sul disegnatore..
		lda pointer_coordinate
		sta clean_max+1
		sta draw_max+1
		
		/*
		ldy #0
		sta (which_max),y
		*/
		
		lda #BLUE
		sta $d020
		//;Adesso devo disegnare tutti i punti!
		jsr disegna_punti	
	
		//;Dopodiche incremento il counter per il prox frame
		jsr set_points
		
		lda #0
		sta $d020

		jmp mainloop
