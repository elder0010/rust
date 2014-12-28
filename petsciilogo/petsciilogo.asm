.var TEST_MODE=0
.var MUSIC_SYNC=1
.var music = LoadSid("psycho.sid")

.import source "variables.asm"
.import source "../common/functions.asm"


.pc = blob_address "blob data" 
.import source "loaded_blob.asm"


.if (TEST_MODE == 1){	
	:BasicUpstart2(scene_start)
	.pc=music.location "Music" .fill music.size, music.getData(i)
	
}

.pc = $3a00 "scene start"
scene_start:
		
.if (TEST_MODE == 1){
		sei
		lda #0
	
		jsr music.init
		:kernal_off()

		lda #BLUE
		sta $d020

		lda #BLUE
		sta $d021
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()

}	
		jsr trigger_first_irq

		/*
		lda $d011
		and #%11101111
		sta $d011
		*/
		lda #0
		sta frame_ct
		sta fade_pt
		sta $3fff

		jsr draw_logo_intro

		jsr init_sprites
	
		jsr clear_charset

		lda #$cb
		sta $d016

		lda #$30
		sta sinus_pt

	
		//; Select VIC bank
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

	

.if (TEST_MODE == 1){
		cli
		jmp post_load_wait
}

.if(TEST_MODE==0){
		rts
}		


.if(TEST_MODE==0){
//;Finiro' qui quando il loader avrà caricato tutto.
//;Il logo sarà pronto e visualizzato
.pc = $3a40 "post load wait"
}
post_load_wait:
		jmp *

trigger_first_irq:

		lda #$00 sta $d011
!:
		lda $d012
		cmp #$46
		bne !-

    	lda #<first_play_irq sta $fffe
    	lda #>first_play_irq sta $ffff
    	lda #$f9 sta $d012
    	rts

//;.align $100
//;.import source "double_irq.asm"
//;.import source "polling_irq.asm"

.import source "sprite_irq.asm"

//;--------------------------------------------
//;Irq temporaneo per assorbire il glitch audio
first_play_irq:
		:open_irq()
		asl $d019
		
		
		inc wt_dl+1
wt_dl:
		lda #0
		cmp #$10 //;Delay sempre buono per mettere a tempo btw ;) 
		bne !+

		jsr move_irq
		jsr point_sprite_barra
		
		lda #<raster_bottom_irq sta $fffe
    	lda #>raster_bottom_irq sta $ffff

    	//lda #$1b
    	//sta $d011
    	lda irq_line_stop
    	sta $d012
    	sta sprite_line+1
!:

   	//	inc $d020
    	jsr $1003
    //	dec $d020
		:close_irq()
		rti
//;--------------------------------------------

irq:
		:open_irq()

		lda #0
		sta $d011
		bit $d011
		bpl *-3
		bmi *-3
open_brd:
		lda #$0b
		sta $d011
		asl $d019

		jsr move_irq
		
		//;temporary msx player
first_msx_play:
		jsr $1003

aux_msx:
        jsr fakeplayer

		lda #<stabilizer_irq sta $fffe
    	lda #>stabilizer_irq sta $ffff

    	lda irq_line
    	sta $d012
    	sta sprite_line+1
		lda #$1a
		sta $d011

		inc load_wt+1
load_wt:
		lda #0
		bne !+
		inc gr+1
gr:
		lda #0
		cmp #GIRI_DI_WOB
		bne !+
		lda #<outro
		sta otr_wt+1
		lda #>outro
		sta otr_wt+2
!:
otr_wt:
		jmp no_outro
outro:
		lda sinus_pt
		cmp #$b0
		bne !+
		lda #1
		sta must_draw_logo+1
!:
must_draw_logo:
		lda #0
		beq nocol
	
skp:
		jmp clrt
clrt:
		jsr draw_logo_cols
	
		lda #>draw_logo
		sta clrt+2
		lda #<draw_logo
		sta clrt+1
		lda #1
		sta must_outro+1
nocol:


must_outro:
		lda #0
		beq !+
		lda sinus_pt
		cmp #$40
		bne !+

		lda irq_line
		sta force_line+1
		inc must_force_line+1
		jsr ritocchino_finale_colori
!:

must_force_line:
		lda #0
		beq !+

force_line:
		lda #$ff
		sta $d012
		sta sprite_line+1

		lda irq_line_stop
		cmp #193
		bne !+
		dec sinus_pt
		inc must_fade_out_logo+1
!:

no_outro:
		jsr point_sprite_barra


must_fade_out_logo:
		lda #0
		beq !+

		jsr arrow_fade
!:

must_go_outro:
		lda #0
		beq !+
		jsr outro_sequence
!:

fade_rt:
		jsr fade_in_sprites
		
		:close_irq()
		rti


.import source "functions.asm"

move_irq:
		ldx sinus_pt

		lda sinus,x
		sta irq_line

		clc
y_add:
		adc #20
		sta irq_line_stop

		clc 
		adc #8
		sta bottom_sprite_pos
	
		inc sinus_pt

goincr:
		and y_add+1 //;Diventerà inc

		lda y_add+1
		cmp #52
		bne !+
		dec y_add+1

		//;Finito di ingrandire, muovo il player dal bordo al centro..
		lda #>$1003
		sta aux_msx+2
		lda #<$1003
		sta aux_msx+1

		lda #>fakeplayer
		sta first_msx_play+2
		lda #<fakeplayer
		sta first_msx_play+1
!:
		rts