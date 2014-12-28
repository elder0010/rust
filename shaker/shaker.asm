.var TEST_MODE=0
.var music = LoadSid("Videogamer.sid")

.import source "variables.asm"
.import source "../common/functions.asm"


.if (TEST_MODE == 1){	
:BasicUpstart2(scene_start)
.pc=music.location "Music" .fill music.size, music.getData(i)
}

.pc = screenPixels "bitmap"
.import c64 "data/bmp.prg"
data_screen: 
.pc = * "screen data"
.import c64 "data/scr.prg"

.align $40
.pc = * "filler sprite"
filler_sprite:
.fill 45,00
.fill 19,$ff

.pc = $6800 "colours"
data_col:
.import binary "data/colours.prg"





.pc = * "final Irq"
final_irq:
		:open_irq()
		asl $d019

		jsr $1003
		jsr frame_count
		inc scene_end+1
		:close_irq()
		rti



.pc = $7fff
.byte 0


.pc = $9800 "code"
scene_start:
	.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
		lda #BLUE
		sta $d020
		sta $d021
}	

		ldx #0
		stx $d015
		stx ct
		stx frame_count_lo
		stx frame_count_hi
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		dex
		bne !-

		lda #$9
		sta fade_pt

		lda #44
		sta sine_pt
		
		lda #64
		sta raster_sine_pt

		lda #$d8
		sta $d016


		lda #$ff
!:
		sta $0400,x
		sta $0400+$100,x
		sta $0400+$200,x
		sta $0400+$300-$8,x
		sta screenChars,x
		sta screenChars+$100,x
		sta screenChars+$200,x
		sta screenChars+$300,x
		dex
		bne !-

		jsr reloc_all
		
	

		//;jsr move_filler_sprites_bottom

!:
		lda $d012
		cmp #$56
		bne !-
		
	//	lda #$0b
	//	sta $d011
		:d012($fc)
		lda #<irq_waster
		sta $fffe
		lda #>irq_waster
		sta $ffff

!:
		lda $d012
		cmp #$e4
		bne !-
		jsr init_filler_sprite
		jsr move_filler_sprites


wait_for_colours:
		lda #0
		beq wait_for_colours

		jsr draw_pic
		jsr draw_pic_colours

kill_colours:
		lda #0
		beq kill_colours

		lda #0
		ldx #0
!:
		sta $d918,x
		sta $d9fa,x
		dex
		bne !-

		lda #0
!:
		sta rotator_screen,x
		sta rotator_screen+$100,x
		dex
		bne !-


wait_redraw_pic:
		lda #0
		beq wait_redraw_pic
		jsr draw_pic_colours

scene_end:
		lda #0
		lda scene_end+1
		beq scene_end
		rts

		//;Riloco il charset a $c000
reloc_all:
		ldx #0
!:
.for(var t=0;t<7;t++){
		lda rotator_chars_src+t*$100,x
		sta rotator_chars+t*$100,x
}
		dex
		bne !-

		//;Preparo la tabella dei colori a 0
		lda #0
!:
		sta colour_table,x
		dex
		bne !-
		rts
//.import source "sprite_intro.asm"

.import source "intro.asm"



.import source "main.asm"

//.import source "outro.asm"
