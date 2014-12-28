//;;-------------------------------------------------------------------------
//;; Calcola punti della linea usando l'algoritmo di bresenham
//;;-------------------------------------------------------------------------
.const	cnt_x	=	$10

draw_line:
//; *********************************************************
//; - Determino la direzione di incremento della coordinata Y
//; - Determino il delta Y
//; *********************************************************
 		ldx #INX
b_y_2_0:
		lda #$00		
		sta to_y+1
		sta last_y+1
        sec
b_y_1_0: 
		sbc #y_1
        bcs skip1
        eor #$ff
        adc #1
        ldx #DEX
skip1:
        sta delta_y+1
        sta t_y_1+1
		sta t_y_2+1
		stx stepx1
		stx stepx2

		
//; *********************************************************
//; - Determino la direzione di incremento della coordinata X
//; - Determino il delta X
//; *********************************************************	
		ldx #INY
b_x_2_0:
        lda #$00
        sta to_x+1
		sta last_x+1
        sec
b_x_1_0:
        sbc #x_1
        bcs skip2
        eor #$ff
        adc #1
		ldx #DEY
skip2:
		stx stepy1
		stx stepy2


//; ********************************
//; Carico le coordinate di partenza
//; ********************************		
b_x_1_1:		
		ldy #$00	//; Carico X iniziale
b_y_1_1:
		ldx #$00	//; Carico Y iniziale
 

//; ***********************************************
//; Confronto delta X (in accumulatore) con delta Y
//; ***********************************************
delta_y:
		cmp #0
		bcc steep	//; Salto se il delta Y è maggiore del delta X
 
		
//; *****************
//; Delta X > Delta Y
//; *****************
		
		sta t_x_1+1	
		lsr		
		sta errx+1	//; Errx= delta/2 (Fondamentale, avevi ragione Elder)

//; *************************************
//; Loop principale con Delta X > Delta Y
//; *************************************
loopx:		
		sty $10		//; Salvo la coordinata X corrente
		tya			//;	Y=coordx/2 perchè 2 "pixel" per carattere
		lsr
		tay			
		
//; **************************
//; Disegno del pixel corrente
//; **************************
target_buffer_lo:	//; Determino lo byte della linea
		lda targetLowBuffer1,x
		sta scr_1+1	
		sta calc_ok+1
target_buffer_hi:	//; Determino hi byte della linea
		lda targetHiBuffer1,x
		sta scr_1+2
		sta calc_ok+2
scr_1:		
		lda $ffff,y		//; Leggo la coppia di pixel
		bcc pari		//; In base al lsb decido quale pixelone aggiornare
		and #$0f		//; Se dispari salvo lo byte e aggiorno hi byte
line_col_sx_1:
		ora #$10
		jmp calc_ok
pari:
		and #$f0		//; Se pari salvo hi byte e aggiorno lo byte
line_col_dx_1:
		ora #$01
calc_ok: 
		sta $ffff,y	//; Storo la coppia di pixel rielaborata
	
//; ****************************************
//; Impostazioni limiti orizzontali per fill
//; ****************************************
		tya				//; Controllo i limiti orizzontali per il filling
draw_min_bf_1:			//; ...Elders voodoo...
		cmp min_x_a_1,x
		bcs no_min
is_min:
draw_min_bf_2:
		sta min_x_a_1,x	
no_min:
draw_max_bf_1:
		cmp max_x_a_1,x
		bcc end_cmp1
draw_max_bf_2:
		sta max_x_a_1,x
end_cmp1:

//; ***********************************
//; Prosecuzione algoritmo di Bresenham 
//; ***********************************
		ldy $10		//; Ricarico la coordinata Y			
errx:
		lda #$00	//; Carico il delta
		sec
t_y_1:
		sbc #0		//; delta=delta-dY
		bcs skip3	//; Abbiamo sforato, se no allora niente aggiornamento della coordinata Y
t_x_1:   
		adc #0		//; delta=delta+dX
stepx1:   
		inx			//; Ok, bisogna aggiornare anche la coordinata Y
skip3:   
		sta errx+1		
stepy1:   
		iny
to_x:   
		cpy #0
		bne loopx		
		jmp post_process
 
steep:
//; *****************
//; Delta Y > Delta X
//; *****************

		sta t_x_2+1
		lsr
		sta erry+1
	
//; *************************************
//; Loop principale con Delta Y > Delta X
//; *************************************	
loopy:
		sty $10		


		tya 			//;	Y=coordx/2
		lsr
		tay		
target_buffer_lo_a:		//; Determino lo byte della linea
		lda targetLowBuffer1,x
		sta scr_2+1
		sta calc_ok_a+1
target_buffer_hi_a:		//; Determino hi byte della linea		
		lda targetHiBuffer1,x
		sta scr_2+2
		sta calc_ok_a+2
scr_2:
		lda $ffff,y
		bcc pari_a
dispari_a:
		and #$0f
line_col_sx_2:		
		ora #$10
		jmp calc_ok_a
pari_a:
		and #$f0
line_col_dx_2:
		ora #$0f
calc_ok_a: 
		sta $ffff,y	//; Disegno il pixel
	

		tya
draw_min_bf_3:
		cmp min_x_a_1,x		//; Controllo i bordi del poligono
		bcs no_min_a
is_min_a:
draw_min_bf_4:
		sta min_x_a_1,x		
no_min_a:
draw_max_bf_3:
		cmp max_x_a_1,x
		bcc end_cmp2
draw_max_bf_4:
		sta max_x_a_1,x
end_cmp2:
		
		ldy $10 
erry:    
		lda #$00		//; Y=Y-deltaX
		sec
t_x_2:   
		sbc #0
		bcs skip4		
t_y_2:   
		adc #0			//; Y=Y+deltaY
stepy2:
		iny
skip4:   
		sta erry+1
 
 		
stepx2:   
		inx
to_y:    
		cpx #0
		bne loopy

//; ************
//; Punto finale
//; ************
post_process:		
last_x:
		ldy #$00
last_y:		
		ldx #$00
		
		tya 	//;	Y=coordx/2
		lsr
		
/*		
		//; In teoria 'sto blocco (che disegna l'ultimo punto) sarebbe necessario, in pratica tutto funziona meglio senza!
		tay
		
		lda line_col_sx_2+1
		sta	line_col_sx_3+1
		lda line_col_dx_2+1
		sta	line_col_dx_3+1
		lda target_buffer_lo_a
		sta target_buffer_lo_b
		lda target_buffer_hi_a
		sta target_buffer_hi_b				
		
target_buffer_lo_b:		//; Determino lo byte della linea
		lda targetLowBuffer1,x
		sta pixptr
target_buffer_hi_b:		//; Determino hi byte della linea		
		lda targetHiBuffer1,x
		sta pixptr+1
		lda (pixptr),y
		bcc pari_b
dispari_b:
		and #$0f
line_col_sx_3:		
		ora #$10
		jmp calc_ok_b
pari_b:
		and #$f0
line_col_dx_3:
		ora #$0f
calc_ok_b: 
		sta (pixptr),y	//; Disegno il pixel
		tya
*/
		
		
draw_min_bf_5:
		cmp min_x_a_1,x		//; Controllo i bordi del poligono
		bcs no_min_c
is_min_c:
draw_min_bf_6:
		sta min_x_a_1,x		
no_min_c:
draw_max_bf_5:
		cmp max_x_a_1,x
		bcc end_cmp3
draw_max_bf_6:
		sta max_x_a_1,x
end_cmp3:

		rts
 


 

.align $100
.pc = * "clean buffers"
clean_buffer_0:
.fill $100,$0


/*
.pc = $a000 "data vettori"
//;;.import source "data/basic.asm"
.import source "data/polygon.asm"
 */
/*
.pc = $a000 "Tabelle schermo per bresenham"
.import source "data/line_screen_address.asm"
*/
 
 