.var TEST_MODE=0
.var music = LoadSid("loop.sid")

.import source "variables.asm"
.import source "../common/functions.asm"


.if (TEST_MODE == 1){	
	:BasicUpstart2(kernal)
	.pc=music.location "Music" .fill music.size, music.getData(i)

.pc = $9800 "kernal killer"
kernal:
		:kernal_off()
		jmp scene_start
}

.pc = $f400 "code"
scene_start:
	.if (TEST_MODE == 1){
		
		lda #0
		jsr music.init
		:kernal_off()
	

		lda #BLUE
		sta $d020

		lda #BLUE
		sta $d021
		:turn_off_cia_turn_on_raster_irq()
		
}
		:set_irq(absorber_irq)

		lda #0
		sta $d015
		sta frame_ct
		sta fade_pt

		ldx #0
		lda #0
!:
		sta screenChars,x
		sta screenChars+$100,x
		sta screenChars+$200,x
		sta screenChars+$300,x
		dex
		bne !-

		jsr init_sprites
		jsr move_sprites

		lda #$c8
		sta $d016
		
		lda #165
		sta sin_pt
		
		//; Select VIC bank
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

		//; Set VIC screen and font pointers
		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018

		//;:wait_frame()
!:
		lda $d012
		cmp #$e4
		bne !-

		inc go_scene+1
		
.if(TEST_MODE==1){
		cli
}
!:
can_load:
		lda #$fe
		bne !-

		rts
//;Routine a cui jumpare dopo il load 
//;per far partire il mini outro
.pc = $f480 "after_load"
		inc finished_load+1 
next_scene_addr:
		jmp next_scene_addr
	
absorber_irq:
		:open_irq()
		asl $d019
		lda #$1b
		sta $d011

go_scene:
		lda #0
		beq !+
		
		lda $1729
		cmp #$1f
		bne !+
		:set_irq(irq)
		lda #$f8
		sta $d012
		lda #$1b
		sta $d011
		lda #3 
		sta $d015
		
!:

//;		inc $d020
		jsr $1003
//;		dec $d020
		:close_irq()
		rti

irq:
		:open_irq()
		asl $d019
fade_rt:
		jsr fade_in_sprites

	//	inc $d020
		jsr move_sprites
	//	dec $d020

		jsr $1003

		inc can_load+1

		ldx sin_pt
		lda sintable,x
store_cury:
		sta cur_y
		
//;Finito di caricare, 
finished_load:
		lda #0
		beq !+
		jsr move_up_sprites
!:

		:close_irq()
		rti

.align $40 
.pc = * "sprites start"
sprites_source:
.import binary "sprites/rings.raw"
.import source "functions.asm"

.align $100 
.pc = * "sintable"
sintable:
.import source "data/sin.asm"