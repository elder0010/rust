.import source "init.asm"

//;--------------------------------------
//;Gestione della scena
//;--------------------------------------
manage_scene:
	lda #0
	sta collision_happened

	jsr clean_pezzo
	
	lda #$ff
	sta clean_md+1
	jsr draw_pezzo

	inc current_y

	jsr check_collisione_bordo
	jsr check_collisione_pezzo

	lda collision_happened
	beq !+
	jsr next_token
!:

	rts

//;--------------------------------------
//;Pulisce l'ultimo pezzo disegnato
//;--------------------------------------
clean_pezzo:
	lda #0
	sta clean_md+1
	
	:go_up_two_line(schermo)
	:go_up_two_line(colour_ram)
	jsr draw_pezzo
	:go_up_one_line(schermo)
	:go_up_one_line(colour_ram)
	
	rts



//;--------------------------------------
//;Disegna il prox pezzo
//;--------------------------------------
draw_pezzo:

	lda #0
	sta righe_pezzo //;quante righe abbiamo fatto?

	:get_indirizzo_pezzo(quadretto)

	ldx #0
drawline:
	ldy start_offset


quadretto:
	lda $ffff,x
	sta tmp_1
	beq nodraw //;il quadratino va effettivamente disegnato?
	cmp #$ff //;ho finito la riga?
	beq newriga

	//;Controlliamo la riga. se sto scrivendo su $03ff in giu va saltato!
	lda schermo+2
	cmp #$3
	bne !+
	jmp nodraw
!:

godrw:
	lda tmp_1
clean_md:
	and #$ff
schermo:
	sta screenChars,y

colore:
	lda #LIGHT_RED
colour_ram:
	sta $d800,y

nodraw:
	inx
	iny
	jmp quadretto
newriga:
	inx //;Il counter per la lettura del pezzo deve andare avanti 
		//;altrimenti resterei bloccato su $ff
	:go_down_one_line(schermo)
	:go_down_one_line(colour_ram)

	inc righe_pezzo
	lda righe_pezzo
	cmp #2
	bne drawline
fine:
	rts

//;--------------------------------------
//;Controlla le collisioni sull'ultimo pezzo disegnato
//;--------------------------------------
check_collisione_bordo:
	lda #25
	sta low_border+1
	//;Per prima cosa vediamo se ho sbattuto sul bordo inferiore
	lda current_y
low_border:
	cmp #24
	bne !+
	inc collision_happened
	jmp skip_collision
!:
skip_collision:
	rts

check_collisione_pezzo:
	//;devo verificare se sulla prossima locazione in cui andrò a scrivere cè un 
	//;char = 1. in caso cè collisione.

	//;Per prima cosa devo analizzare la seconda riga del pezzo che sto disegnando 
	:get_indirizzo_pezzo(col_scr) 

	lda #0
	sta righe_pezzo

	//;Copio l'indirizzo dello schermo su cui scrivero'
	lda schermo+1
	sta col_char+1
	lda schermo+2
	sta col_char+2
	

	//;ldx current_pezzo
	lda larghezze_pezzi,x
	sta p_len+1

	ldx #0
	ldy #0
col_scr:
	lda $ffff,y //;se il quadratino è vuoto non può collidere
	beq dontcollide 


	//;Altrimenti puo collidere. In x cè l'offset del pezzo corrente, al quale dobbiamo
	//;aggiungere lo start offset
	stx tmp_1
	clc
	txa
	adc start_offset
	tax //;Ora in X cè l'offset della riga da controllare
col_char:
	lda $ffff,x
	beq !+
	inc collision_happened
	//;inc $d020
	jmp endc
!:
	ldx tmp_1
dontcollide:
	iny
	inx
p_len:
	cpx #3
	bne col_scr
nx_line:	
	//;:go_down_one_line(col_char)

	iny
	ldx #0
	inc righe_pezzo
	lda righe_pezzo
	cmp #2
	bne col_scr


endc:
	rts

//;--------------------------------------
//;Passa al prox token
//;--------------------------------------
next_token:
	lda #0
	sta current_y
	inc current_pezzo
	ldx current_pezzo
	lda start_offsets,x
	clc 
	adc #7
	sta start_offset
	lda sequenza_pezzi,x
	tax
	lda colori_pezzi,x
	sta colore+1
	jsr reset_screen_pointers
	inc pezzi_caduti
	lda pezzi_caduti
	cmp #numero_pezzi_da_mostrare
	bne !+

	lda #0
	sta go_tetris+1

	//;Jumpo alla prox scena
	:set_addr($9400,post_load_wait)
!:
	rts

.macro get_indirizzo_pezzo(target){
	ldx current_pezzo
	lda sequenza_pezzi,x
	tax

	lda indirizzi_pezzi_lo,x
	sta target+1

	lda indirizzi_pezzi_hi,x
	sta target+2
}

.macro get_indirizzo_seconda_linea_pezzo(target){
	ldx current_pezzo
	lda sequenza_pezzi,x
	tax

	lda indirizzi_pezzi_lo_2,x
	sta target+1

	lda indirizzi_pezzi_hi_2,x
	sta target+2

}

.macro go_down_one_line(target){
	clc
	lda target+1
	adc #40
	sta target+1
	bcc !+
	inc target+2
!:
}

.macro go_up_two_line(target){
	sec
	lda target+1
	sbc #80
	sta target+1
	bcs !+
	dec target+2
!:
}

.macro go_up_one_line(target){
	sec
	lda target+1
	sbc #40
	sta target+1
	bcs !+
	dec target+2
!:
}

//;--------------------------------------
//;Scrolla il teschio
//;--------------------------------------
scroll_screen:
	clc 
	lda $d016
	adc #1
	and #7
	sta tmp_1
	bne !+
	jsr copy_skull
!:
	
	lda $d016
	and #$f8
	ora tmp_1


	sta $d016

	inc framect+1
framect:
	lda #0
	cmp #$6f
	bne !+
	lda #<tetris_irq
	sta irq_sw_lo+1
	lda #>tetris_irq
	sta irq_sw_hi+1
!:
	rts

copy_skull:
	
	:set_addr(screenChars,src)
	:set_addr(screenChars+1,trg)

//;Scroll screen 1 char
	ldy #0
line:
	ldx #larghezza_teschio
src:
	lda screenChars,x
trg:
	sta screenChars+1,x
	dex
	bpl src

	:go_down_one_line(src)
	:go_down_one_line(trg)
	iny
	cpy #25
	bne line

//;Feed next char
	:set_addr(skull_screen_src,skull_src)
	:set_addr(screenChars,first_line)

line_ct:
	ldx #larghezza_teschio

	ldy #0

skull_src:
	lda skull_screen_src,x
	clc
	adc #2
first_line:
	sta screenChars

	:go_down_one_line(skull_src)
	:go_down_one_line(first_line)

	iny
	cpy #25
	bne skull_src


	dec line_ct+1
/*
	lda line_ct+1
	cmp #$fe
	bne !+
	lda #<tetris_irq
	sta irq_sw_lo+1
	lda #>tetris_irq
	sta irq_sw_hi+1
!:
*/
	rts
