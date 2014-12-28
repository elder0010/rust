.var TEST_MODE=0

.var music = LoadSid("Loop.sid")
.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"
.import source "assets.sym"

.if (TEST_MODE == 1){		
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(code)
}

.if (TEST_MODE == 0){	
.pc = $f000 "code start"
}else{
.pc = $4000 "code start"
}
code:
	.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
	
}
	//	lda #$0b 
	//	sta $d011

	
		
		jsr init_scene

		
		//; Select VIC bank
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

		//; Set VIC screen and font pointers
		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018
 
.if (TEST_MODE == 1){
		lda #BACKGROUND_COLOUR
		sta $d021
		sta $d020
}	
		jsr waste_frames
!:
		lda $d012 
		cmp #$96
		bne !-
		
		lda #<music_irq
		sta $fffe
		lda #>music_irq
		sta $ffff
		
		lda #$56
		sta $d012

		lda #$1b
		sta $d011

.if (TEST_MODE == 1){
		cli
scene_wait:
		jmp *
}
		
scene_finished:
		rts


.pc = $f030 "post blob load wait"
post_blob_load_wait: //;Questo fa subito rts, perche devo caricare il resto del tunnel!
		rts

.pc = $f033 "post load wait"
post_load_wait:
go_next:
		jmp *


//;--------------------------------------
//;fade border e Scrolla il teschio
//;--------------------------------------
scroll_irq:
		:open_irq()
		asl $d019

	//;	:set_addr(scene_finished,scene_wait)
		lda #<music_irq
		sta $fffe

	//	lda #>music_irq
	//	sta $ffff
		
		lda #$56
		sta $d012


must_fade_screen:
		lda #1
		beq go_scrn
	
		jsr fade_screen
!:
		lda $d012
		cmp #$2a
		bne !-

raster_cl:
		lda #BROWN
		sta $d020
		
		jmp noscrl
go_scrn:

		jsr scroll_screen
	
noscrl:
		
		:close_irq()
		rti



//;--------------------------------------
//;Scena generale
//;--------------------------------------
music_irq:
		:open_irq()
		asl $d019
	
		jsr $1003

		//;lda #<tetris_irq
irq_sw_lo:
		lda #<scroll_irq
		sta $fffe
		//;lda #>tetris_irq
irq_sw_hi:
		lda #>scroll_irq
		sta $ffff
		
		//;lda #$fa
		lda #$fa
		sta $d012

		:close_irq()
		rti

tetris_irq:
		:open_irq()
		asl $d019

		lda #<music_irq
		sta $fffe
		lda #>music_irq
		sta $ffff
		
		lda #$56
		sta $d012

go_tetris:
		lda #0
		beq !+
		clc
		lda delay_timer
		adc #1
		sta delay_timer
		cmp #delay_counter
		bne !+
		lda #0
		sta delay_timer
		jsr manage_scene
!:
		:close_irq()
		rti

fade_screen:
		ldx fade_pt
		
		lda fade_screen_tbl,x
		cmp #BORDER_COLOUR
		bne !+
		dec must_fade_screen+1
		inc go_tetris+1
!:
		inc fade_pt
		sta raster_cl+1
		rts

fade_screen_tbl:
.byte RED,RED,RED,ORANGE,ORANGE,ORANGE
.byte LIGHT_RED,LIGHT_RED,LIGHT_RED
.byte YELLOW,YELLOW,YELLOW
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte GRAY,GRAY,GRAY
.byte DARK_GRAY,DARK_GRAY,DARK_GRAY
.byte BORDER_COLOUR



.pc = * "functions"
.import source "functions.asm"



.align $30
.pc = * "lut pezzi"
lut_pezzi:
.import source "data/pezzi.asm"


waste_frames:

!:
		lda $1740
		cmp #5
		bne !-

		ldx #0
!:
		:wait_frame()
		inx
		cpx #10
		bne !-
		rts
/*
.align $100 
.pc = * "sequenza pezzi"
.import source "data/sequenza_pezzi.asm"
*/
/*
.align $100
.pc = * "x offsets partenze"
.import source "data/start_offsets.asm"
*/
/*
.pc = * "skull chars"
skull_chars_src:
.import binary "data/skull/chars.raw"
*/

.pc = $ec00 "skull screen"
skull_screen_src:
.import binary "data/skull/screen.raw"



