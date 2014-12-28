outro_sequence:
line_mov:
	lda #$50
	sta irq_line_stop

	inc line_mov+1
	inc line_mov+1

	lda line_mov+1
	cmp #$f7
	bne !+
	lda #1
	sta final_fd+1
!:

final_fd:
	lda #0
	beq nogox
	
!:
	lda $d012
	cmp #$23
	bcc !-

	ldx final_fd_pt
	lda final_fade_tbl,x
	cmp #BLUE
	bne !+
	//;FINE SCENA
	dec final_fd_pt
	lda #0
	sta $d011
	sta $d015
	sta open_brd+1

	//;Indirizzo dello shaker
	:set_addr($9800,post_load_wait)
!:
	sta bgcl1+1
	sta $d020

	ldy #8
!:
	sta $d027,y
	dey
	bpl !-

	inc final_fd_pt
	dec line_mov+1
	dec line_mov+1
nogox:
	rts

final_fd_pt:
.byte $0
.align 16
final_fade_tbl:
.byte DARK_GRAY,DARK_GRAY,GRAY,GRAY,LIGHT_GRAY,LIGHT_GRAY,WHITE,WHITE
.byte LIGHT_GREEN,LIGHT_GREEN,CYAN,CYAN,LIGHT_BLUE,LIGHT_BLUE,BLUE
