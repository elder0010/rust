//;------------------------------------------------------------------
//;Routines per shrinkare gli sprites
//;------------------------------------------------------------------
point_next_sprite_to_shrink:
		
		lda #0
		sta should_shrink+1
		
		ldx #0
		ldy #0
sprite_check_loop:		
		//;Adesso vediamo se lo sprite è da shrinkare
		lda shrink_step_counter,x
		tay
		lda sprite_table_pointer,x
		cmp shrink_points,y //;Lo sprite ha raggiunto il punto in cui dev'essere shrinkato?
		bne nostep
		//;inc $d021
		lda #1
		sta should_shrink+1
		
		//lda #7
		stx sprite_to_shrink //;indico chi deve essere shrinkato
		//stx $d021
		
		lda shrink_step_counter,x //;Finiti gli step? resetto
		sta step
		clc
		inc shrink_step_counter,x //;Subirà uno shrink al prox step..
		lda shrink_step_counter,x //;Finiti gli step? resetto
		cmp #6
		bne !+
		lda #0
		sta shrink_step_counter,x
		sta step
		sta should_shrink+1
		//;Devo scrivere una nuova lettera
	
		jsr prepare_next_sprite
		//;inc $d020
		
		jmp no_shrink_toggle
!:	
		
		jmp no_shrink_toggle //;appena ne trovo uno da shrinkare esco
nostep:
		inx
		cpx #8
		bne sprite_check_loop
		
no_shrink_toggle:

		rts
		

.align $8
shrink_step_counter:
.byte $0,$0,$0,$0,$0,$0,$0,$0

shrink_points:
.byte 35,42,49,61,62

//;Puntatore del prossimo shrink pointer da checkare!
sprite_segment:
.fill $8,$0


.import source "writer.asm"

//;------------------------------------------------------------------
//;Calcola le coordinate e lo step di uno sprite da shrinkare
//;Lo sprite shrinkato è quello puntato in calc_sprite_shrink_target
//;------------------------------------------------------------------
calc_sprite_shrink_target:
		ldx sprite_to_shrink
		
		//;Punto lo sprite da shrinkare
		lda sprite_target_1_lo,x
		tay
		
		lda sprite_target_1_hi,x
		tax
	
	//;Default sprite scommentare per debug
	//	ldx #$7c
	//	ldy #$40
		
		stx SOURCE_SPRITE_0+2
		stx SOURCE_SPRITE_1+2
		stx TARGET_SPRT_0+2
		stx TARGET_SPRT_1+2
		
		sty SOURCE_SPRITE_0+1
		sty TARGET_SPRT_0+1
		sty TARGET_SPRT_1+1
		iny
		sty SOURCE_SPRITE_1+1
		
		//;Aggiorno i puntatori dal buffer al set di 3 sprites
		ldx sprite_to_shrink
		lda sprite_target_2_lo,x
		sta TARGET_SPRT_2+1
		
		lda sprite_target_2_hi,x
		sta TARGET_SPRT_2+2
		
		lda sprite_target_3_lo,x
		sta TARGET_SPRT_3+1
		
		lda sprite_target_3_hi,x
		sta TARGET_SPRT_3+2
		
		
	//	sta $d021
		rts



.var sprite_pos_bank_1 = List()
.var sprite_pos_bank_2 = List()
.var sprite_pos_bank_3 = List()

.for(var x=0; x<=8;x++){
	.eval sprite_pos_bank_1.add(SPRITE_AREA_1+[$40*x])
	.eval sprite_pos_bank_2.add(SPRITE_AREA_2+[$40*x])
	.eval sprite_pos_bank_3.add(SPRITE_AREA_3+[$40*x])
}

.align $8
.pc = * "puntatori sprites"
sprite_target_1_lo:
.for (var n=0; n < sprite_pos_bank_1.size() ; n++) {
	.byte [sprite_pos_bank_1.get(n)]
}
sprite_target_2_lo:
.for (var n=0; n < sprite_pos_bank_2.size() ; n++) {
	.byte [sprite_pos_bank_2.get(n)]
}
sprite_target_3_lo:
.for (var n=0; n < sprite_pos_bank_3.size() ; n++) {
	.byte [sprite_pos_bank_3.get(n)]
}

sprite_target_1_hi:
.for (var n=0; n < sprite_pos_bank_1.size() ; n++) {
	.byte sprite_pos_bank_1.get(n)>>8
}

sprite_target_2_hi:
.for (var n=0; n < sprite_pos_bank_2.size() ; n++) {
	.byte sprite_pos_bank_2.get(n)>>8
}
sprite_target_3_hi:
.for (var n=0; n < sprite_pos_bank_3.size() ; n++) {
	.byte sprite_pos_bank_3.get(n)>>8
}


//;------------------------------------------------------------------
//;Questa funzione shrinka uno sprite.
//;Step è lo SHRINK STEP per lo sprite che si intende shrinkare
//;Lo sprite shrinkato è quello puntato in calc_sprite_shrink_target
//;------------------------------------------------------------------
shrink_sprites:

should_shrink: //;In realtà, anche se la funzione viene chiamata ad ogni frame non devo shrinkare 
		lda #0 //;sempre ma solo quando lo step per lo sprite corrente viene incrementato
		bne goshr
		rts
goshr:
		
		ldx #0
		ldy #0
			
		lda step
//;---------------------------------------
//;SHRINKO SU X
//;---------------------------------------
!:
SOURCE_SPRITE_0:
		lda source_sprite,x
		lsr 
		sta buffer_area,x
		clc
		
SOURCE_SPRITE_1:		
		lda source_sprite+1,x
		asl
		sta buffer_area+1,x
		
		clc
		
		txa
		adc #3
		tax
		cpx #3*16
		bmi !-	
		
//;---------------------------------------
//;SHRINKO SU Y
//;---------------------------------------
shrinky:		
		ldx #0
		
		clc
		
		//;Moltiplico per 3 (step*2 + step)
		lda step
		asl
		adc step
		
//;Copio riga su successiva e la azzero
		tay
!:	
		lda buffer_area,y
		sta buffer_area+3,y
		
		lda #0
		sta buffer_area,y

		iny
		
		inx
		cpx #2
		bne !-
		
//;Copio riga su precedente e la azzero		
		lda #42
		ldx #0
sxx:
		cpx step
		beq ok
		sbc #2
		inx
		jmp sxx
ok:		
		tay
		
		ldx #0
!:	
		lda buffer_area+3,y
		sta buffer_area,y
		
		lda #0
		sta buffer_area+3,y

		iny
		
		inx
		cpx #2
		bne !-
		
		//inc step
				
no_shrink:	
		rts

buffer_to_sprite:
		ldx #$3f
!:	
		lda buffer_area,x
TARGET_SPRT_0:
		sta $0900,x
TARGET_SPRT_2:
		sta $0900,x
TARGET_SPRT_3:
		sta $0900,x
		dex
		bpl !-
		
		rts

sprite_to_buffer:
		ldx #$3f
!:	
TARGET_SPRT_1:
		lda source_sprite,x
		sta buffer_area,x
		dex
		bpl !-
		
		rts
		
	
.macro go_down_one_line(target){
		clc
		lda target
		adc #3
		sta target
		
}	
.macro go_up_one_line(target){
		sec
		lda target
		sbc #3
		sta target
}	
