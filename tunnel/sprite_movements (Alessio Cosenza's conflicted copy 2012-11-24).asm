//;Move sprites
move_sprites:
	
		ldx #0
		ldy #0
		sty $d010
sprt_loop:	
		stx $10
		sty $11

//;Animazione sprite su Y		
		clc					
		lda $d001,y		
		adc #1
		sta $d001,y
		sec
		sbc #SPRITE_Y_START //;Tolgo l'offset Y, altrimenti vado "a vuoto" sulla tabella
		tay

		lda sprite_table_pointer,x
		tax
movement_function:		
		jsr spingi_avanti //;Questa funzione cambia a seconda se sto andando avanti o indietro
		
		//;Test per $d010
		//;Devo accenderlo se mi trovo a dx
		bcc nod10res
		lda $d010
		ldx $10
		ora sprite_d010_enabler,x
		sta $d010 
nod10res:
		
//;----------------------------------		
		ldx $10
		clc
		lda sprite_table_pointer,x
		adc #1
		cmp #$40
		bne !+
		
		lda #SPRITE_Y_START
		sta $d001,y
		
		clc
current_restart:
		lda sprite_x_min_lo
current_modifier:
		adc curspeed
		adc #81
		sta $d000,y	
	
		bcc no_d010_reset
		lda $d010
		ldx $10
		ora sprite_d010_enabler,x
		sta $d010
		
no_d010_reset:
		ldx $10
		lda #0	//;Resetto il puntatore dell'oscillazione su X
!:
		sta sprite_table_pointer,x

		ldx $10
		iny
		iny
		inx
		cpx #8
		beq exit_loop
		jmp sprt_loop
exit_loop:

		inc timerino+1
timerino:
		lda #0
		cmp #$a0
		bne !+
		lda #1
		sta can_move+1
!:
		
//;-------------------------------------------------------
//;Ora calcolo lo shift da applicare su x

shift_phase:
		//;lda speed_wobble
		ldx #$0
		
		lda shift_values,x
		sta curspeed

		lda direzione
		bne indietro
avanti:			
		
		lda shift_phase+1
		cmp #$40
		bne !+
		lda direzione
		eor #$ff
		sta direzione
			
		lda #>tira_indietro
		sta movement_function+2
		
		lda #<tira_indietro
		sta movement_function+1
		
		lda #0
		sta shift_phase+1
		sta curspeed
		
		lda #>sprite_x_max_lo
		sta current_restart+2
		
		lda #<sprite_x_max_lo
		sta current_restart+1
		
		lda #SBC_ZP
		sta current_modifier
		
!:

can_move:		
		lda #0
		bne !+
		jmp no_move
!:	
		inc shift_phase+1
		jmp end_movement
indietro:

		inc shift_phase+1
		lda shift_phase+1
		cmp #$40
		bne !+
		
		lda #0
		sta shift_phase+1
		sta curspeed
		
		
		lda direzione
		eor #$ff
		sta direzione
			
		lda #>spingi_avanti
		sta movement_function+2
		
		lda #<spingi_avanti
		sta movement_function+1
		
		lda #>sprite_x_min_lo
		sta current_restart+2
		
		lda #<sprite_x_min_lo
		sta current_restart+1
		
		lda #ADC_ZP
		sta current_modifier
!:


end_movement:



no_move:

		rts

direzione:
.byte $0



//;-------------------------------------------------------------------------
//;Spingi avanti - sposta gli sprite da SX a DX
//;-------------------------------------------------------------------------
//;Aggiungo il valore di shift calcolato
spingi_avanti:
		clc
		lda sprite_x_min_lo,x
SPD:
		adc curspeed
		bcc !+
		sbc #34 //;Zozzata incredibile, chiedere il perchè a fresh :|
!:
		cmp sprite_x_max_lo,y
		bcs max //;Se è piu grande torno al max
		beq max
		jmp nxt //;Altrimenti vado al next		
max:		
		//inc $d020
		lda sprite_x_max_lo,y	
nxt:
		adc #82 //;Seno x min!
		
		ldy $11
		sta $d000,y

		rts
		
		
//;-------------------------------------------------------------------------
//;Tira indietro - sposta gli sprite da DX a SX
//;-------------------------------------------------------------------------
//;Sottraggo il valore di shift calcolato
tira_indietro:
		sec
		lda sprite_x_max_lo,x
		sbc curspeed
		bcs !+ //;Se sottraggo una velocita maggiore del minimo, devo riazzerare
			   //;Oppure finirò in overflow ed esploderà il mondo facendo saltare
			   //;La cmp successiva
		lda #$0
!:
		cmp sprite_x_min_lo,y
		bcc max2 //;Se è piu piccolo torno al min
		beq max2
		jmp nxt2 //;Altrimenti vado al next		
max2:		
	//	inc $d020
		lda sprite_x_min_lo,y	
nxt2:
		adc #82 //;Seno x min!
		
		ldy $11
		sta $d000,y

		rts

.align $100
.import source "sintables\sine.asm"