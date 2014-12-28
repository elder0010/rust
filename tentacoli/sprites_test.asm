//;--------------------------------------
//;TENTACLE SCENE
//;--------------------------------------
.var TEST_MODE = 0
.var MUSIC_SYNC = 1
.var music = LoadSid("rust_current.sid")

.if (TEST_MODE == 1){
	.pc=music.location "Music" .fill music.size, music.getData(i)	
	:BasicUpstart2(code)
}

.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "tn_variables.asm"
.import source "../wobbler/variables.asm"

.pc = $5000 "code"
//;Risorse della transizione
code:
.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		lda #BLUE
		sta $d021
		sta $d020

		lda #$f9
		sta $d012
}		

		lda #0
		sta $d015
		sta $7fff
		sta $79ff
		lda $dd00
		and #$fc
		ora #$02
		sta $dd00
		lda #0
		sta $d011
	
		:turn_off_cia_turn_on_raster_irq()
		
	//;	:wait_frame()
	//;	asl $d019
	//;	:set_irq(intro_irq)

		sta altezza_reached
		sta altezza_pt
		sta row_counter
		sta ZP5
		sta ZP27
		sta TEMP
		sta TEMP2
		sta TEMP3
		sta PT_ZERO
		sta PT_ONE
		sta row_counter
		sta plex_ct
		sta zp_del_male
		sta plex_ct

		lda #$d8
		sta $d016

		jsr clear_bitmap

		lda #start_bordo_inferiore
		sta start_line

		jsr init_sprites
		jsr no_move_y //;Calcolo le nuove coordinate di start
		jsr calc_y_sprites //;aggiorno le y degli sprites sulla base dello start corrente
		jsr draw_frame //;aggiorno la tabella dei frames
		jsr wob_frame //;wobblo su x

		inc plex_ct
		:bank_1()

		lda #[[[schermo_sprites & $3fff] / $0400] << 4] + [[[schermo_sprites+$800 & $3fff] / $0800] << 1] | $8
		sta $d018

	//	lda #$f9
	//	sta $d012

!:
		lda #$83
		cmp $d012
		bne !-
	
		jsr init_nmi
		
		lda #$ff
		sta $d015
		lda #0
		sta $d010

!:
		lda $d012
		cmp #$64
		bne !-

		lda #$f9
		sta $d012
		:set_irq(intro_irq)

		lda $d011
		and #$7f
		sta nmi_val+1
		sta $d011

.if(TEST_MODE==1){
		cli
}
can_go_fd:
		lda #0
		beq can_go_fd
		
		:wait_frame()

		jmp main_fade

loop:
		jmp *
		
		//;Post fader stuff
JMP_ME:
		:wait_frame()

		inc wst+1
wst: //;Delay tentacoli fermi prima di scendere
		lda #0
		cmp #$a4
		bne JMP_ME

		:set_addr(move_down_tentacles,move_routine)

FLD_WAIT:
		jmp FLD_WAIT

clear_screen_loop:
	
		lda #0
	//	sta $d015
		ldx #0
!:
		sta schermo_sprites,x
		sta schermo_sprites+$100,x 
		sta schermo_sprites+$200,x
		sta schermo_sprites+$300,x
	
		dex
		bne !-

		//inc has_finished_clear_screen

		jmp main_pre_loader

		//;jmp *
.pc = * "MAIN PRE LOADER"
main_pre_loader:

		lda #$11
		ldx #0
!:
		sta SCREEN_1,x
		sta SCREEN_1+$100,x
		sta SCREEN_1+$200,x
		sta SCREEN_1+$300,x
		dex
		bne !-

		jsr cl_scrn
		//inc has_finished_clear_screen
		:init_scene_plexer()
		
		//;Riloco sintable del wobble e charset bordo
		ldx #0
!:
		lda border_wave,x
		sta $3f00,x
		dex
		bne !-

		ldx #$0
!:
		lda border_charset,x
		sta char_base,x
		inx
		cpx #$97
		bne !-
		
		//;Preparo lo sprite vuoto per tappare i bordi
		lda #$ff
!:
		sta $5400,x
		inx
		cpx #$40
		bne !-
		
		//;E lo punto :D
		lda #$50
		sta SCREEN_1+$03f8
		sta SCREEN_1+$03f9
		
		jsr draw_columns
		//;inc init_finished
		inc has_finished_clear_screen
	//;Mosso in raster.asm
	//	lda #$29
	//	sta $d018

		inc can_go_wobble
.if(TEST_MODE==1){
		jmp *
}
		rts



.import source "plex_irqs.asm"
.import source "tn_functions.asm"


intro_irq:
		:open_irq()
		
		jsr $1003
		lda $1019
		cmp #$07
.if(MUSIC_SYNC==1){
		bne !+
}
		lda #0
		sta $d010
	
		lda #$4a
		sta $d012

		lda $d011
		and #$7f
		sta nmi_val+1
		sta $d011


		lda #$57
		sta $d012
		:set_irq(manage_irq)

		inc can_go_fd+1
!:
		asl $d019

		:close_irq()
		rti

.pc = * "intro transition functions"
.import source "..\wobbler\functions.asm"

.pc = sprites_location "sprites"
sprites_source:
.import source "sprites.asm"


.pc = $5900 "border wave sintable"
border_wave:
.import source "..\wobbler\sintables\border.asm"

.pc = * "border charsets"
border_charset:
.import source "..\wobbler\border-charsets.asm"

.pc = * "intro transition code"
.import source "..\wobbler\transitions\intro.asm"

.pc = $5cd7 "fld routine"
.import source "transition\fld_source.asm"

.pc = $6000 "picture"
.import c64 "pic.prg"

.pc = * "fader routine"
.import source "fader.asm"

.pc = * "frames table"
.import source "data/sprite_address_table.asm"

.pc = * "y movement tables"
.import source "data/tentacles_y.asm"
.import source "data/frames_wob.asm"

.pc = $3d00 "raster transition"
.import source "transition\raster.asm"