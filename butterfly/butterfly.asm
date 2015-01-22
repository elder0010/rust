//---------------------------------------------
//BUTTERFLY INTRO (Fld + transition)
//---------------------------------------------

.var TEST_MODE=0
.var music = LoadSid("loop.sid")
.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"
.import source "butterfly_routine.sym"

.if (TEST_MODE == 1){
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(code)
}

.pc = $9d00 "code start"
code:
	.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
}
		lda $7fff
		sta $ff

		lda #1
		sta linee_fld

		lda #$f0
		sta sine_pt_intro

		lda #$24
		sta intro_irq_line

		jsr move_irqs

!:
		lda $d012
		cmp #$84
		bne !-

		lda #<music_irq
		sta $fffe
		lda #>music_irq
		sta $ffff

		lda #$ff
		sta $d012

		lda #$3b
		sta $d011

.if (TEST_MODE == 1){
		cli
}

blinker_not_finished:
		lda #0
		beq blinker_not_finished

		lda #0
		sta $d017
        sta $d01d
        sta $d015
        sta sine_pt
		sta plex_irq_ct
		sta sprite_pointer
		sta plex_irq_ct
		sta x_pt
		sta wob_pt
		sta puntatori_pt

        //Punto i filler sprites
        lda #[filler_sprite/$40]
        sta screenChars+$03f8

		// Select VIC bank
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

		// Set VIC screen and font pointers
		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018

		lda #13
		sta y_pt

		inc finished_reloc
.if(TEST_MODE==0){
		rts

		.pc = $9d90 "come back da load blob"
post_load:
		jsr mega_reloc
		jsr place_sprites
		jsr calc_x_sprites
		jsr clear_screen_sprites

.pc = $9d9c "scene_wait"
scene_wait:
		jmp *

.pc = $9d9f "scene_finished"
scene_finished:
		rts

}
.if(TEST_MODE==1){
		jmp *
}

nmi:	rti

.pc = $9e25 "intro"
.import source "intro.asm"

.pc = * "fld_intro"
.import source "fld_intro.asm"

.pc = * "functions"
.import source "functions.asm"
