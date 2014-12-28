//;---RASTER TRANSITION
has_finished_clear_screen:
.byte $0

.var NEW_D020_COL = DARK_GRAY
.var NEW_D021_COL = WHITE
.pc = * "RASTER TRANSITION"
wait_irq:
		:open_irq()
		asl $d019
		
		//;Salto nel clear loop
		lda #<clear_screen_loop
		sta FLD_WAIT +1 
		lda #>clear_screen_loop
		sta FLD_WAIT +2
		
		lda has_finished_clear_screen
		cmp #1
		bne !+
		
		//;Hi res
		lda #$c0
		sta $d016

		inc pre_border_wobble_delay+1
		
pre_border_wobble_delay:
		lda #0
		cmp #$1
		bne !+
		
		lda #<raster_top_irq
		sta $fffe
		lda #>raster_top_irq
		sta $ffff
		
		lda #$0b
		sta $d011
		lda #$0
		sta $d012
		
!:		
	//	inc $d020
		jsr music.play
	//	dec $d020
		:close_irq()
		rti
		
//;-------------------------------------------------------

raster_top_irq:
		:open_irq()
			
		asl $d019				   			   			   			
		lda d011_value
		//;and #%01111111 
		sta $d011
		
		nop
TIME_IRQ:		
		lda #$20
		sta $d012
		
		//;---PUNTO IRQ DI SOTTO----
IRQ_CHOOSE_LO:
		lda #<raster_bottom_irq
		sta $fffe
IRQ_CHOOSE_HI:
		lda #>raster_bottom_irq
		sta $ffff
		//;------------------------------
	
		
		//; give stable raster
		ldx $d012
		inx
		cpx $d012
		bne * - 3
		ldy #$0a
		dey
		bne * - 1
		inx
		cpx $d012
		nop
		beq Time_1
		nop
		bit $24
Time_1:	
		ldy #$09
		dey
		bne * - 1
		nop
		nop
		inx
		cpx $d012
		nop
		beq Time_2
		bit $24
Time_2:	
		ldy #$0a
		dey
		bne * - 1
		inx
		cpx $d012
		bne Time_3
Time_3:	
		nop
		
		
TOP_COL_020:		
		lda #BLUE
		sta $d020
TOP_COL_021:
		lda #BLUE
		sta $d021
		

		:close_irq()
		rti
		

raster_bottom_irq:
		:open_irq()
		
		ldx #NEW_D020_COL
		ldy #NEW_D021_COL
		lda $d012
		cmp $d012
		beq *-3
		
		stx $d020
		
		sty $d021
		
			
		//;---PUNTO IRQ DI SOTTO----
		lda #<raster_top_irq
		sta $fffe
		lda #>raster_top_irq
		sta $ffff
		//;------------------------------
		
		ldy #$1b
		 
		clc
LINE_IRQ:		
		lda wobbler_pointer+144
	
	//	lda wobbler_pointer+140
		adc #$33
		
		bcc !+
		ldy #$9b
	
!:
		sty d011_value

		sta TIME_IRQ+1
		
		inc LINE_IRQ+1
		
		lda #0
		sta $d012
		
		inc cntr+1	
cntr:
		lda #0
		cmp #$e0+5
	
		bpl !+
		
	
		//;---PUNTO IRQ DI SOTTO----
		lda #<top_border_wobble_irq
		//sta $fffe
		sta IRQ_CHOOSE_LO+1
		
		lda #>top_border_wobble_irq
		//sta $ffff
		sta IRQ_CHOOSE_HI+1
		//;------------------------------
		
		
!:
		lda #$1b
		sta $d011
		
	//	inc $d020
		jsr $1003
	//	dec $d020
		
		asl $d019
		:close_irq()
		rti


top_border_wobble_irq:
		:open_irq()
		
		ldx #NEW_D020_COL
		ldy #NEW_D021_COL
		lda $d012
		cmp $d012
		beq *-3
		
		stx $d020

		sty $d021
		asl $d019
		//;---PUNTO IRQ DI SOTTO----
		lda #<raster_top_irq
		sta $fffe
		lda #>raster_top_irq
		sta $ffff
		//;------------------------------
				
		lda #$28
		sta $d012
		
		lda #$9b
		sta $d011
next_pt:	
		lda wobbler_pointer+228
		sta TIME_IRQ+1
		
		inc next_pt+1
		
		cmp #1
		bne !+
		//;---FINE TRANSIZIONE----
		lda #<transition_end_irq
		sta $fffe
		lda #>transition_end_irq
		sta $ffff
		//;------------------------------
!:
	//	inc $d020
		jsr $1003
	//	dec $d020
		:close_irq()
		rti


d011_value:
.byte $9b

can_init_next_scene:
.byte $0

can_go_wobble:
.byte $0

transition_end_irq:
		:open_irq()
		
		lda #1
		sta can_init_next_scene
		
		asl $d019
		//inc $d020
		jsr $1003
		//dec $d020
		
		lda can_go_wobble
		beq !+
		
		//;---VIA COL WOBBLE----
		lda #<init_wait_irq
		sta $fffe
		lda #>init_wait_irq
		sta $ffff
		
		lda #$1b
		sta $d011
		lda #$fe
		sta $d012

		//;------------------------------
		
		lda #1
		sta init_finished
		
		lda #$ff
		sta $d015

		lda #$ff
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
!:
		:close_irq()
		rti