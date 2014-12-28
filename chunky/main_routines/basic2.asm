.pc = $0c00 "maincode"
MainCode:		
	/*
		bit $d011
		bpl * - 3
		bit $d011
		bmi * - 3
*/

!:
		lda $d012
		cmp #$f0
		bcc !-
	
		lda _pageflip
		eor #$ff
		sta _pageflip
		beq page_1
page_0:
		:point_screen_2()
		jmp nopage
page_1:
		:point_screen_1()
nopage:

		lda #YELLOW
		sta $d020
			
		lda #0
		sta dot_pt
		//;Pulisco la linea precedente
	
		jsr pulisci

		
		//;Calcolo i prossimi punti
		ldx vector_point_1
		lda vector_x,x
		sta x_2
		
	//	inx
		lda vector_y,x
		sta y_2
		
		lda vector_point_1
		cmp #120
		bne !+
		lda #$ff
		sta vector_point_1
!:
		inc vector_point_1	
	//;	inc vector_point_1	
	
		lda #60
		sta x_2
		
		lda #1
		sta y_2
		
		lda #RED
		sta $d020
		//;Calcolo la prox linea con bresenham
		jsr draw_line
		
		//;E ci metto il segnaposto per fermarmi
		lda #0
		
		ldx pointer_coordinate
		sta punti_x,x
		sta punti_y,x
		
		lda #0
		sta dot_pt
	  
		lda #BLUE
		sta $d020
		//;Adesso devo disegnare tutti i punti!
		jsr disegna_punti	
	
		lda #0
		sta $d020

		jmp MainCode


		

//;-------------------------------------------------------------------------
//; Macro per double buffering
//;-------------------------------------------------------------------------
.macro point_screen_1(){
		lda #>targetLowBuffer1
		sta target_buffer_lo+2
		lda #>targetLowBuffer2
		sta c_target_buffer_lo+2
		
		lda #<targetLowBuffer1
		sta target_buffer_lo+1
		lda #<targetLowBuffer2
		sta c_target_buffer_lo+1
		
		lda #>targetHiBuffer1
		sta target_buffer_hi+2
		lda #>targetHiBuffer2
		sta c_target_buffer_hi+2
		
		lda #<targetHiBuffer1
		sta target_buffer_hi+1
		lda #<targetHiBuffer2
		sta c_target_buffer_hi+1
}

.macro point_screen_2(){
		lda #>targetLowBuffer2
		sta target_buffer_lo+2
		lda #>targetLowBuffer1
		sta c_target_buffer_lo+2
		
		lda #<targetLowBuffer2
		sta target_buffer_lo+1
		lda #<targetLowBuffer1
		sta c_target_buffer_lo+1
		
		lda #>targetHiBuffer2
		sta target_buffer_hi+2
		lda #>targetHiBuffer1
		sta c_target_buffer_hi+2
		
		lda #<targetHiBuffer2
		sta target_buffer_hi+1
		lda #<targetHiBuffer1
		sta c_target_buffer_hi+1
}

