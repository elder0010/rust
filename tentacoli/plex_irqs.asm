top_irq:
		:open_irq()
		asl $d019
		cli
		lda #1
		sta plex_ct

		tax
		lda #0
		sta frame_pt_0
		:reposition_line_0()
		:point_line_0()
		:set_irq(plex_irq)

		ldx plex_ct
		lda $d011
		and #$7f
		ora valori_d011,x
		sta $d011
		sta nmi_val+1
		
		inc plex_ct

		:close_irq()
		rti


plex_irq:
		sta save_a
		stx save_x
		sty save_y

		asl $d019
		cli
	
		lda plex_ct
		tax
		lsr
		bcs !+
		:point_line_1()
		:reposition_line_1() //;Setto la y
		
		jmp endrep
!:
		:point_line_0()
		:reposition_line_0() //;Setto la y

endrep:	
		lda #$3b
		inc zp_del_male
		and $d011
		ora valori_d011,x
		sta nmi_val+1
		sta $d011
		dec zp_del_male
		
		inc plex_ct
		lda plex_ct
n_plex:
		cmp #7
		bne !+
		jsr go_to_manager_irq
!:
		lda save_a
		ldx save_x
		ldy save_y
		
		rti

go_to_manager_irq:
		:set_irq(manage_irq)

manage_irq_line:
		lda #$4a
		sta $d012

		.for(var t=0;t<=14;t++){
			nop
		}
		lda $d011
		and #$7f
		sta nmi_val+1
		sta $d011
		
		rts


manage_irq:
		:open_irq()
		asl $d019

		lda #0
		sta $dd0e

		lda #$d2
		sta $dd04
		lda #$2a
		sta $dd05

		lda #$19
		sta $dd0e


	//	inc $d020
		jsr $1003
	//	dec $d020
		
		:set_irq(top_irq)
		
		lda altezze_sprites
		sta $d012

		lda #$33
		sta $d011

		lda $d011
		and #$7f
		ora valori_d011
		ora #$8
		sta $d011
		sta nmi_val+1

move_routine:
		jsr no_move_y //;Calcolo le nuove coordinate di start
		jsr calc_y_sprites //;aggiorno le y degli sprites sulla base dello start corrente
		jsr draw_frame //;aggiorno la tabella dei frames
		jsr wob_frame //;wobblo su x

		lda #$ff
		sta $d015
		
can_go_fld:
		lda #0
		beq !+

		lda #0
		sta $d015

		lda #$7f
		sta $dc0d
		sta $dd0d
		lda $dd0d
		lda $dc0d

		//;via al FLD!
		lda #<idler_irq
		sta $fffe
		lda #>idler_irq
		sta $ffff
		
		lda #$fe
		sta $d012
		lda #$3b
		sta $d011
wtr:
		lda $d012
		cmp #$fa
		bne wtr
		//lda #$b0
		//sta $d012

!:		

		

		:close_irq()
		rti

.macro reposition_line_0(){
		lda altezze_sprites,x 
		sta $d012

		sta $d001
		sta $d003
		sta $d005
		sta $d007
}

.macro reposition_line_1(){
		lda altezze_sprites,x
		sta $d012
	
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f		
}

.macro point_line_0(){

		ldy frame_pt_0
		lda current_pt_tbl,y
		sta schermo_sprites+$03f8

		iny
		lda current_pt_tbl,y
		sta schermo_sprites+$03f9
	
		iny
		lda current_pt_tbl,y
		sta schermo_sprites+$03fa

		iny
		lda current_pt_tbl,y
		sta schermo_sprites+$03fb
	
		iny
		sty frame_pt_0	
}

.macro point_line_1(){

		ldy frame_pt_0
		lda current_pt_tbl,y
		sta schermo_sprites+$03fc

		iny
		lda current_pt_tbl,y
		sta schermo_sprites+$03fd
	
		iny
		lda current_pt_tbl,y
		sta schermo_sprites+$03fe

		iny
		lda current_pt_tbl,y
		sta schermo_sprites+$03ff

		iny
		sty frame_pt_0
}