.var SCENE_TEST_MODE = 0

//;-------------------------------------------------------------------------
.var RasterRow = $1d //; May not be a line with sprites or a badline
.var _rx = $a3
.var _ry = $a4
.var _pageflip = $b5

.if (SCENE_TEST_MODE == 1){
	.var music = LoadSid("Tristate.sid")
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(scene_start)
}

//.pc = $0f10
//;-------------------------------------------------------------------------
.pc = $3a10 "chunky routine init"
scene_start:
	
.if (SCENE_TEST_MODE == 1){
	sei
//;-------------------------------------------------------------------------
//; Turn all sprites off
//;-------------------------------------------------------------------------
	lda #$00
	
	jsr $1000
	
	lda #0
	sta $d021
	sta $d020
	jsr init_scene
}

	lda #0
	sta move_pt
		
	//;jsr init_scene
	
//;-------------------------------------------------------------------------
//; Wait for VBLANC
//;-------------------------------------------------------------------------
	bit $d011
	bpl * - 3
	bit $d011
	bmi * - 3

	
//;-------------------------------------------------------------------------
//; Perform halfvariance polling
//;-------------------------------------------------------------------------

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
//;QUI é STATO SMANETTATO	
//;	nop
	bit $24
	bit $24
	nop
	bit $24
	//nop
	
//;-------------------------------------------------------------------------
//; Raster is stable here.
//; Launch a continous timer which a count of 63.
//;-------------------------------------------------------------------------
	lda #$3e
	sta $dc04
	sty $dc05
	lda #$11
	sta $dc0e

	
	
//;-------------------------------------------------------------------------
//; Initialize everything needed to be inited here
//;-------------------------------------------------------------------------
	//; Set multicolor-mode and turn on the bitmap, in the process set
	//; the high end of the raster to 0, point the screenmemory to
	//; $0000 - $3fff, allocated positions are:
	//; Bitmap @ $4000
	//; Screen 1 = $6000
	//; Screen 2 = $6400
	//; Screen 3 = $6800 (For doublebuffering)
	//; Screen 4 = $6c00 (For doublebuffering)
	
.macro fire_up_chunky_screen(){	
	lda #$3b
	sta $d011
	lda $d016
	ora #%00010000
	sta $d016
	lda $dd00
	and #%11111100
	ora #%00000010
	sta $dd00
}

	ldx #0
	stx _pageflip


	//;jsr fill_screen_pixels
	
	//jsr disegna_pic_debug
//;jmp *	
//;-------------------------------------------------------------------------
//; Setup irq-code
//;-------------------------------------------------------------------------
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda #1
	sta $d01a
	sta $d019
//;-------------------------------------------------------------------------
//; Setup interrupt position
//;-------------------------------------------------------------------------
	lda #RasterRow
	sta $d012
//;-------------------------------------------------------------------------
.if (SCENE_TEST_MODE ==1){	
	
	lda #$35
	sta $01	
	
	}
	
	lda #<irq
	sta $fffe
	lda #>irq
	sta $ffff
	lda $dc0d
	lda $dd0d
		
	
	asl $d019
	

	jsr testCIAVersion
	lda oldCIA
	beq !+
	ldx #<nmiirq_old_cia
	ldy #>nmiirq_old_cia
	jmp store_irq
!:
	lda #>_p_1_new+1
	sta P1_0+2
	sta P1_1+2
	lda #<_p_1_new+1
	sta P1_0+1
	sta P1_1+1
	
	lda #>_p_2_new+1
	sta P2_0+2
	sta P2_1+2
	lda #<_p_2_new+1
	sta P2_0+1
	sta P2_1+1
	
	ldx #<nmiirq_new_cia
	ldy #>nmiirq_new_cia
	jmp store_irq
	
store_irq:
	stx $fffa
	sty $fffb
	
	lda $dc0d
	lda $dd0d

//;-------------------------------------------------------------------------
//; Setup the nmi-irq - quale devo puntare? dipende dal CIA model! Woho!
//;-------------------------------------------------------------------------
/*
WHICH_IRQ_LO:
	lda #<nmiirq_old_cia
	sta $fffa
WHICH_IRQ_HI:
	lda #>nmiirq_old_cia
	sta $fffb
*/
//;-------------------------------------------------------------------------
//; Setup the timer adjusted to work every eight row, (63 * 8) - 1 cycles
//;-------------------------------------------------------------------------
	lda #$f7
	sta $dd04
	lda #$01
	sta $dd05
	
	.if(SCENE_TEST_MODE==1){
	
	lda #bg_colour
	sta $d020
	sta $d021
	}
	
	:fire_up_chunky_screen()

	lda #0
	sta $d015

	cli
	
	
	jmp gort
//;-------------------------------------------------------------------------
//; Here is the maincode executed
//;-------------------------------------------------------------------------
	.import source "main_routines/cubo.asm"
//;	.import source "main_routines/polygon.asm"
//;	.import source "main_routines/basic.asm"
//;-------------------------------------------------------------------------
irq:
//;-------------------------------------------------------------------------
//; Save the registers
//;-------------------------------------------------------------------------
	pha
	php
	stx _rx
	sty _ry
//;-------------------------------------------------------------------------
//; Stabilize the raster
//;-------------------------------------------------------------------------
	lda $dc04
	and #7
	sta Time_4 + 1
	lda #7
	sec
Time_4:	
	sbc #4
	sta Time_5 + 1

Time_5:
	bpl * + 2
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$24
	nop

//;-------------------------------------------------------------------------
//; Stable raster here, start the nmi-irq if the raster is on the beginning of the screen
//;-------------------------------------------------------------------------

	lda $d012
	cmp #RasterRow + 8
	bcs StopNMI
	lda _pageflip	//;3	 3
	bmi _page_2	//;2 3	 5  6
	lda #$81	//;2	 7
P2_0:
	sta _p_2 + 1	//;4	11

	lda #$91	//;2	13
P1_0:
	sta _p_1 + 1	//;4	17

	nop		//;2	19
	jmp start_nmi	//;3	22
_page_2:	

	lda #$a1	//;  2	    8
P2_1:
	sta _p_2 + 1	//;  4	   12

	lda #$b1	//;  2	   14
P1_1:
	sta _p_1 + 1	//;  4	   18
	nop		//;  2	   20
	nop		//;  2	   22
start_nmi:
	bit $ea		//;3 3	25 25 

	lda #$11
	sta $dd0e
	lda #$81
	sta $dd0d
	lda $dd0d
//;-------------------------------------------------------------------------
//; Set raster-row for ending the NMI here
//;-------------------------------------------------------------------------
	lda #$f8
	sta $d012
//;-------------------------------------------------------------------------
//; Restore all registers
//;-------------------------------------------------------------------------
	plp
	pla
	ldx _rx
	ldy _ry
//;-------------------------------------------------------------------------
//; Return from irq here
//;-------------------------------------------------------------------------
	asl $d019
	rti
//;-------------------------------------------------------------------------
//; Stop the NMI-irq, play music and stuff
//;-------------------------------------------------------------------------
StopNMI:
		lda _p_2 + 1	//; Restore $d018 for the first row
		sta $d018
		lda #RasterRow
		sta $d012
		lda #$00
		sta $dd0e
		
		jsr $1003
		
		
	lda can_fade_out
		beq !+
		jsr final_fade
		jmp skpx
!:
		
		lda move_pt
		bne !+
		inc giri_ct+1
giri_ct:
		lda #0
		cmp #7 //;NUMERO DI GIRI
		bne !+
		lda #1
		sta can_fade_out
!:
skpx:
		lda #0
		beq nostop


		lda #0
		sta $dd0e

		lda #$7f
		sta $dc0d
		sta $dd0d
		lda $dd0d
		lda $ddd0

		lda #$04
		sta d10+2
		sta d11+2
		sta d12+2
		sta d13+2

		:set_irq(safe_load_irq)

		lda #$1b
		sta $d011
		lda #$f9
		sta $d012

		//;:kill_nmi()
nostop:
//;-------------------------------------------------------------------------
//; Restore all registers
//;-------------------------------------------------------------------------
		plp
		pla
		ldx _rx
		ldy _ry
//;-------------------------------------------------------------------------
//; Return from irq here
//;-------------------------------------------------------------------------
		asl $d019
		rti

.import source "nmi_irqs.asm"


safe_load_irq:
		:open_irq()
		asl $d019	
	//	inc $d020
		jsr $1003
	//	dec $d020
		:close_irq()
		rti


.pc = $3000 "cube preload data"
.import source "data/cube.asm"

.pc = $9800
.import source "functions.asm"
.import source "chunky_functions.asm"

.pc = $bc00 "fill routine"
.import source "fill_routine.asm"

//;	.byte $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9
//;	.byte $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9
//;	.byte $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9
//;	.byte $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9
//;	.byte $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9
//;	.byte $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $c9
//;	bit $ea

//.pc = $2000 "tabelle colori"

