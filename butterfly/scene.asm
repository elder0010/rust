scene:


	
	lda #7
	sta giri_di_plexer+1
	
	jmp *

//;	jsr draw_line
	jmp scene
	

offset_moving_irq:
	ldx moving_irq_pt
	lda moving_irq_table,x
	sta post_plex_start+1
	inc moving_irq_pt
	rts
	
/**
.var starting_y = $24 //;y iniziale degli sprite
moving_irq_table:
.byte starting_y,starting_y+[21*1],starting_y+[21*2],starting_y+[21*3]
.byte starting_y+[21*4],starting_y+[21*5],starting_y+[21*6]

moving_irq_pt:
.byte $0

//;-------------------------------------------------------------------------
//; Calcola punti della linea usando l'algoritmo di bresenham
//; al termine avrò le coordinate di tutti i punti della retta in
//; punti_x e punti_y
//;-------------------------------------------------------------------------
//;coords
.var x_1 = 8
.var y_1 = 190

.var x_2 = 78
.var y_2 = 20

.var plot_lo = $59
.var plot_hi = $56

.var pointer_coordinate = $2000
draw_line:
		lda #0
		sta pointer_coordinate
	
//;init
 
		ldx #$e8        //;inx
		lda #y_2
		sta to_y+1
        sec
        sbc #y_1
        bcs skip1
        eor #$ff
        adc #1
        ldx #$ca        //;dex - change direction
skip1:
        sta d_y+1
        sta t_y_1+1
		sta t_y_2+1
		stx incx1
		stx incx2
 
		ldx #$c8        //;iny
        lda #x_2
        sta to_x+1
        sec
        sbc #x_1
        bcs skip2
        eor #$ff
        adc #1
		ldx #$88        //;dey - change direction
skip2:
		stx incy1
		stx incy2
		
		ldy #x_1
		ldx #y_1
 
//;loop
 
//;start y in x-register
//;start x in y-register
//;delta x in a-register
 
d_y:
		cmp #0
		bcc steep
 
		sta t_x_1+1
		lsr
		sta errx+1
loopx:
		clc                 //;needed, as previous cmp could set carry. could be saved if we always count up and branch with bcc//;
	
		
	
		//;QUA
		:store_point()
		
errx:
		lda #$00
		sec
t_y_1:
		sbc #0
		bcs skip3
 
//;one might also swap cases (bcc here) and duplicate the loopend. saves more or less cycles as the subtract-case occurs more often than the add-case. Copying the whole loop to zeropage also save cycles as sta errx+1 is only 3 cycles then. (Bitbreaker)
 
t_x_1:   
		adc #0
incx1:   
		inx
skip3:   
		sta errx+1
 
incy1:   
		iny
to_x:   
		cpy #0
		bne loopx
		rts
 
steep:
		sta t_x_2+1
		lsr
		sta erry+1
loopy:
       
		clc                 //;needed, as previous cmp could set carry. could be saved if we always count up and branch with bcc//;
	
		//;QUA
		:store_point()
		
erry:    
		lda #$00
		sec
t_x_2:   
		sbc #0
		bcs skip4
 
t_y_2:   
		adc #0
incy2:
		iny
skip4:   
		sta erry+1
 
incx2:   
		inx
to_y:    
		cpx #0
		bne loopy
		rts
 

//;Salva le coordinate in una lista
.macro store_point(){


		sta $cc10
		sty $cc24
		stx $cc32
		
		
		
	//	sty $2400 //;In y cè la X
	//	stx $2401 //; IN X Cé LA Y corrente!
		
		
		txa
		pha
		
		ldx pointer_coordinate
			
		pla
	//	sta punti_y,x
		sta $0400,x
		tya
		sta $0500,x
	//	sta punti_x,x
		
		inc pointer_coordinate
	
		
		
		
		lda $cc10
		ldy $cc24
		ldx $cc32
}

.pc = $c000
y_char_lo:
 y_char_hi:
 
 x_char:
 
 x_pixel_char:
 
 punti_y:
 
 punti_x:
 */