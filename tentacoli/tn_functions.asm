//;-----------------------------------
//;Init degli sprites
//;-----------------------------------
init_sprites:
		lda #0
		sta $d017
		sta $d01d

		jsr wob_x_sprites
		jsr calc_y_sprites

	//;	lda #$00
	//;	sta addr
		lda #$d0
		sta addr+1
		sta addr2+1
		lda #$ff
		ldx #16
!:
		sta $d000,x
		dex
		bpl !-

		lda #SPRITE_COL_1
		sta $d025

		lda #SPRITE_COL_2 
		sta $d026

		lda #SPRITE_COL_3
		ldx #8
!:
		sta $d027,x
		dex
		bpl !-

		lda #$ff
		sta $d01c
		sta $d010
		rts

wob_x_sprites:
		
		lda #0
		sta sprte_ct+1
		sta row_ct+1

sprte_ct:
		ldx #0
		lda frame_wob_pt_table,x
		tay
		inc frame_wob_pt_table,x
		cmp #128
		bne !+
		lda #0
		sta frame_wob_pt_table,x
		tya
!:
		tay //;a questo punto ho in mano il puntatore alla sintable dei frame
		lda frames_wob,y
		tay //;e ho in mano il frame da visualizzare per la colonna di sprites

row_ct:
		ldx #0
		
!:
		//;Per ogni riga, quali sono i frames da visualizzare?
		lda frames_pt_tbl,y //;Quale frame lo dice Y
		sta frame_sprites,x //;quale sprite lo dice X
		tya
		clc
		adc #6
		tay
		inx
		cpx #4 //;4 sprites
		bne !-
		inx

		rts

//;--------------------------------------------------------
//;Prepara la tabella dei frames di tutti gli sprites (24)
//;--------------------------------------------------------
draw_frame:
		
		//;devo disegnare 6 linee di frames
col_ct:
		ldx #0
		clc
start_loop:
//;------------------------------------------------------------
//;Increment e reset del counter per il frame
		lda frame_wob_pt_table,x //;Puntatore WOB colonna
		clc
		adc #1
		sta frame_wob_pt_table,x
		cmp #128 //;se passo 128 lo devo resettare
		bne !+
		lda #0
		sta frame_wob_pt_table,x
!:
//;------------------------------------------------------------
		tay 
		lda frames_wob,y
		tay

		lda frames_pt_tbl,y

		sta current_pt_tbl,x
		inx
		cpx #4
		bne start_loop
//;-------------------------------------------------------------
//;Bene ora ho lo start di ogni colonna (la prima riga). 
//;devo disegnare tutte le colonne andando giu e incrementando di 8
		ldx #0
		stx fr_ofs+1
		
!:
		clc
		lda current_pt_tbl,x
fr_ofs:
		adc #0
		:set_column() //;Calcola i frames per una colonna
		inx
		cpx #2
		bne nor_fr

		clc
		lda fr_ofs+1
		adc #4
		sta fr_ofs+1
	
nor_fr:
		cpx #4
		bne !-
	
		rts

.macro set_column(){
		stx tmp_1
		sta tmp_2

		clc
		ldy #0
cll:
		txa
		adc #4 //;faccio scendere di 4 il puntatore sul target
		tax
		lda tmp_2
		adc #8
		sta tmp_2
		sta current_pt_tbl,x
		iny
		cpy #6
		bne cll

		ldx tmp_1
}

//;-------------------------------------------------------------
//;Wob wob su asse x
//;-------------------------------------------------------------
wob_frame:
		
		lda #$00
		sta addr
		lda #$08
		sta addr2

		ldx #0
!:
		lda wob_pt_x,x //;Puntatore WOB colonna
		inc wob_pt_x,x

		tay
		clc
		lda x_wob,y
		adc x_offsets_base,x
	
		ldy #0
		sta (addr),y   //;Itero $d000 / $d002 / $d004 / $d006
		sta (addr2),y  //;Itero $d008 / $d00a / $d00c / $d00e

		inc addr
		inc addr

		inc addr2
		inc addr2

		inx
		cpx #4
		bne !-

		rts


//;-------------------------------------------------------------
//;Prepara la tabella delle altezze per il plex (irq e sprites)
//;-------------------------------------------------------------
	
		.print "ALTEZZE "+toHexString(altezze_sprites)
		.print "VALORI D011 "+toHexString(valori_d011)

.var table_start = 129 //;101
calc_y_sprites:
		ldx #0
		ldy #0
starty:
		lda tentacoli_y_d012+table_start,y
		sta altezze_sprites,x

		tya
		clc
		adc #21
		tay

		inx
		cpx #8
		bne starty

		ldx #0
		ldy #0
starty2:
		lda tentacoli_y_d011+table_start,y
		
		sta valori_d011,x

		tya
		clc
		adc #21
		tay

		inx
		cpx #8
		bne starty2
		rts

.pc = * "nmi irqs"
.import source "nmi.asm"

//;-------------------------------------------------------------
//;Fa salire su gli sprites
//;-------------------------------------------------------------
no_move_y:
		lda #0
		cmp #delay_pre_scene
		bne !+
		:set_addr(move_y,move_routine)		
!:
		inc no_move_y+1
		rts

move_y:
		lda #1
		bne !+
		jmp skip_move
!:
		inc delayer+1
delayer:
		lda #0
		cmp #3
		beq !+
		
		jmp skip_move
!:
		lda #0
		sta delayer+1

		sec
		lda starty+1

		sbc #1
		sta starty+1

		bcs !+
		dec starty+2
!:

		sec
		lda starty2+1
		sbc #1
		sta starty2+1
		bcs !+
		dec starty2+2
!:
		inc altezza_reached
		lda altezza_reached
		
		cmp #altezza_tentacoli
		bne !+
		dec move_y+1
!:
skip_move:
		rts

clear_bitmap:
		ldx #0
		lda #$66
init_loop:
		sta scr,x
		sta scr+$100,x
		sta scr+$200,x
		sta scr +$300,x
	  
		sta col,x
		sta col+$100,x	
		sta col+$200,x
		sta col+$300,x
		
		dex
		bne init_loop
		rts

trigger_go_down_movement:
		rts


move_down_tentacles:
		inc delayer2+1
delayer2:
		lda #0
		cmp #1
		beq !+
		jmp skip_move2
!:
		lda #0
		sta delayer2+1

		clc
		lda starty+1
		adc #2
		sta starty+1

		bcc !+
		inc starty+2
!:
		clc
		lda starty2+1
		adc #2
		sta starty2+1
		bcc !+
		inc starty2+2
!:
		dec altezza_reached
		lda altezza_reached
		cmp #57
		bne !+

		:set_addr(no_move_y,move_routine)

		lda #1
		sta can_go_fld+1

		lda #$7f
		sta $dc0d
		sta $dd0d
		lda $dc0d
		lda $dd0d

!:
skip_move2:
		rts

position_cover_sprites:
			//;punto gli sprites
		
		ldy #8
!:
		lda #[spriteData&$3fff]/$40
		sta schermo_sprites+$03f8,y
		lda #BLUE
		sta $d027,y
		dey
		bpl !-

		lda #$f5
		ldx #0
		stx $d01c
!:
		sta $d001,x
		inx
		inx
		cpx #16
		bne !-

		lda #$20
		clc
		ldx #0
!:
		sta $d000,x
		adc #40
		inx
		inx
		cpx #16
		bne !-

		lda #$c0
		sta $d010

		ldx #$40
		lda #$ff
		sta $d01d
!:
		sta spriteData,x
		dex
		bpl !-

		sta $d015
		rts