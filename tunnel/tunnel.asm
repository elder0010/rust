//;--------------------------------------
//;------TUNNEL
//;--------------------------------------
.var TEST_MODE = 0

.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"
//;.import source "additional_variables.asm"

.if (TEST_MODE == 1){		
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(code)

}

//.pc = $e000
//.import source "blobbed_data.asm"

//;.pc $ef00
.if(TEST_MODE==1){
	//;.import source "intro_irqs.asm"
}

.pc = $9400 "code"		
code:
.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
}		
		:d011($9b)
		:d012($20)
		:set_irq(intro_w_irq)
		rts //; carico l'intro transition
.pc = * "come back da load intro"

	
		lda #0
		sta $d015
		sta step
		
	
.if(TEST_MODE==1){
		cli
}


		lda #RED
		ldx #0
!:
	
		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $db00,x

		dex
		bne !-

		jsr draw_screens
		jsr init_sprites
		
		/*
		lda #$ff
		sta $d015
		*/
		:bank_1()
			
		lda row_shift
		sta base_fade
		lda #$d8
		sta base_fade+1
		
		jsr point_next_sprite_to_shrink
		jsr calc_sprite_shrink_target //;Punto il primo sprite
		jsr sprite_to_buffer
	//	jsr prepare_next_sprite //;Ci scrivo la lettera
		jsr move_sprites
		
		//;Tragico fix sul charset
		lda #$ff
		sta $6124		

		inc finished_relc+1 

.if (TEST_MODE == 1){		
		cli
}

pre_plasma:	
		jmp *

plasma_out:
		jmp *


intro_w_irq:
		:open_irq()
		asl $d019

finished_relc:
		lda #0
		beq !+
		:set_irq($f000) //;intro_top_irq 
		:d012($0)
		:d011($0)
!:
		jsr $1003

bg_fn:
		jsr fade_d021_out //;fade_d021_out

		:close_irq()
		rti

	
.pc = * "plasma routine"
.import source "plasma.asm"

.pc = * "tetris out transition"
.import source "tetris_out_transition.asm"

.pc = * "top irq"		
top_irq:
		:open_irq()
		
		asl $d019
		
		lda #<splitter_irq 
		sta $fffe
		lda #>splitter_irq 
		sta $ffff
		
		lda #$8a
		sta $d012
		lda #$1b
		sta $d011

		nop
		nop
		nop
		
		lda #line_colour
		sta $d020
		
		ldy #10
		:wait()
		
		nop
		nop
		
		lda #border_colour
		sta $d020
		
		:close_irq()
		rti
	


splitter_irq:
		:open_irq()

		asl $d019
		
	//;	inc $d020	
		ldx #0
!:
		lda $d001,x
		eor #$ff
		clc
		adc #low_sprite_y
		sta $d001,x
		
		inx
		inx
		cpx #16
		bne !-
//;		dec $d020
		
//;------------------------------------
//;Ugly timing stuff per switch charset
		lda #$9a
!:		cmp $d012
		bne !-
		
		ldy #8
!:		dey
		bne !-
//;------------------------------------
DOWN_D018:		
		lda #$c2
		sta $d018

//;Inverto le coordinate su x	
		ldx #0
		stx $d010
		
		ldy #0
!:
		lda $d000,x
		eor #$ff
		clc
		adc #98
		sta $d000,x
		
		//;Controllo $d010..
		and #%11000000
		bne skp
		lda $d010
		ora sprite_d010_enabler,y
		sta $d010
skp:
		inx
		inx
		iny
		cpx #16
		bne !-
//;-------------------------------------	
			
		lda #<bottom_irq 
		sta $fffe
		lda #>bottom_irq 
		sta $ffff
		
		lda #$fb
		sta $d012
		
		jsr calc_sprite_shrink_target
		
		jsr shrink_sprites
	
		:close_irq()
		rti

.align 18
frame_table_up:
.byte $c0,$d4,$e8,$20,$3a,$20

frame_table_down:
.byte $c2,$d6,$ea,$28,$3c,$28

bank_table:
.byte $2,$2,$2,$1,$1,$0

frame_pt:
.byte $0

delayer:
.byte $0

.import source "shrinker.asm"
.import source "functions.asm"

.pc = $bd00 "robette"


.pc = * "scroll text"
scroll_text:
.text "arsenic booze design "
.text "camelot celticdesign chorus crest elysium fairlight focus genesis project hokuto force ian coog kenobit laxity level 64 "
.pc = * "ROTTUME"
.text "no name noice nostalgia offence oxyron panda design pikkiomania prosonix raffox role samar the dreams triad trsi         "
.byte 0
.byte 0
.byte 0


.pc = * "bottom_irq"
bottom_irq:
		:open_irq()

		asl $d019
		
		ldy #6
		:wait()
		
		lda #line_colour
		sta $d020

		
		ldy #$a
		:wait()
		
		nop
		
		lda #external_colour
		sta $d020


		ldx #0
!:
		lda $d001,x
		eor #$ff
		clc
		adc #low_sprite_y
		sta $d001,x
		
		inx
		inx
		cpx #16
		bne !-

introjmp:	
		jmp go_fade //;Intro fade
go_fade:
		jsr fade_tunnel
	
		jmp nomove
		
go_move:
		
		jsr move_sprites
nomove:
	//;	dec $d020
	
		jsr next_frame
irq_top_lo:	
		lda #<top_irq 
		sta $fffe
irq_top_hi:	
		lda #>top_irq 
		sta $ffff
		
	//	inc $d020
skip_shr_rt:
	//;	jmp noshrnkrt
//;------------------------------------------------------------------
//;Vediamo se c'è qualcuno da shrinkare, e chi è il fortunello
goshrt:		
		jsr point_next_sprite_to_shrink
func1:
		jsr buffer_to_sprite
func2:
		jsr sprite_to_buffer
noshrnkrt:		
		
		
		lda #$30
		sta $d012
		lda #$1b
		sta $d011

		cli

plasma_fade_out_fn:
		jsr null_func

	//;	dec $d020
plasma_d800fade_out_fn:
		jsr null_func

		
.pc = * "music play"
player_to_kill:
		jsr music.play
		:close_irq()
		rti

.pc = $9100
plasmasin:
 .align $100

.byte 1,1,1,1,1,1,1,2,2,2,3,3,4,4,5,5
.byte 6,6,7,8,8,9,9,10,11,11,12,13,13,14,14,15
.byte 15,15,16,16,17,17,17,17,17,17,17,17,17,17,17,17
.byte 17,17,16,16,15,15,15,14,14,13,13,12,11,11,10,9
.byte 9,8,8,7,6,6,5,5,4,4,3,3,2,2,2,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,3
.byte 3,4,4,5,5,6,6,7,8,8,9,9,10,11,11,12
.byte 13,13,14,14,15,15,15,16,16,17,17,17,17,17,17,17
.byte 17,17,17,17,17,17,17,16,16,15,15,15,14,14,13,13
.byte 12,11,11,10,9,9,8,8,7,6,6,5,5,4,4,3
.byte 3,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,2,2,2,3,3,4,4,5,5,6,6,7,8,8,9
.byte 9,10,11,11,12,13,13,14,14,15,15,15,16,16,17,17
.byte 17,17,17,17,17,17,17,17,17,17,17,17,16,16,15,15
.byte 15,14,14,13,13,12,11,11,10,9,9,8,8,7,6,6
.byte 5,5,4,4,3,3,2,2,2,1,1,1,1,1,1,1


null_func:
		rts

fade_d021_pt:	
.byte $0

tetris_erase_pt:
.byte $0

.align $8
tetris_erase_sequence:
.byte 0,0,3,3,7,7,2,2,1,1,5,5,4,4,6,6

.pc = $ba00 "intro transition"
.import source "transitions\intro.asm"