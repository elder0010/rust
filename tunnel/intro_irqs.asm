.var tetris_screen = $0400

.import source "tunnel.sym"
.import source "../common/zeropage.asm"
.import source "../common/functions.asm"

.pc = $f000 "intro irqs"
//;----------------------------------------
intro_top:
	:open_irq()
	asl $d019

	ldy #5
	:wait()
	bit $24

	lda #BROWN
	sta $d020

	ldy #12
	:wait()

.pc = * "intro d012 col"
INTRO_D021_COL:
	lda #RED
	sta $d020
	
	lda #$80
	sta $d012

	lda #0
	sta $d011

	:set_irq(intro_center)

	:close_irq()
	rti
//;----------------------------------------
intro_center:
	:open_irq()
	asl $d019

irq_sw_lo:
	lda #<intro_bottom
	sta $fffe
irq_sw_hi:
	lda #>intro_bottom
	sta $ffff


move_fn:
	jsr move_bottom

bottom_irq_pos:
	lda #$28
	sta $d012

bottom_d011:
	lda #$90
	sta $d011



	:close_irq()
	rti
//;----------------------------------------
intro_bottom:
	:open_irq()
	asl $d019


	ldy #5
	:wait()
	bit $24

	lda #BROWN
	sta $d020

	ldy #11
	:wait()
	nop

	lda #PURPLE
	sta $d020

	lda #$b
	sta $d011

top_irq_pos:
	lda #$4
	sta $d012
	
	:set_irq(intro_top)

	jsr $1003
	cli

	:close_irq()
	rti
//;----------------------------------------

move_bottom:
	
	sec
	lda bottom_irq_pos+1
	sbc #1
	sta bottom_irq_pos+1
	bcs !+
	lda #$0
	sta bottom_d011+1
!:

	lda bottom_irq_pos+1
	cmp #$fb
	bne !+
	:set_addr(move_top,move_fn)
!:
	rts

move_top:
	clc
	lda top_irq_pos+1
	adc #1
	sta top_irq_pos+1

	cmp #$2f
	bne !+
	//;Vai con l'intro
	lda #<bottom_irq 
	sta irq_sw_lo+1
	lda #>bottom_irq 
	sta irq_sw_hi+1
	lda #$ff
	sta $d015

	lda #RED
	sta $d021
!:

	rts
