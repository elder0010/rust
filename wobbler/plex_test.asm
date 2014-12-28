//;--------------------------------------
//;------WOBBLER
//;--------------------------------------
.var TEST_MODE = 0
.var MUSIC_SYNC = 1
.var music = LoadSid("../tentacoli/rust_current.sid")

.var border_wave = $3f00 

.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"
.import source "bmp_wobbler/variables.asm" //;variabili bmp wobbler

.if (TEST_MODE == 1){		
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(code)
}
	
.pc = $8400 "code"		
code:
.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()

		lda #1
		sta $d021
		lda #border_colour
		sta $d020
		
		asl $d019
//;Punto irq raster
		lda #$29
		sta $d018
		:bank_1()
}		
		

		lda #0
		sta $50
		sta x_offset	

!:
		lda $d012
		cmp #$56
		bne !-
		lda #<intro_irq 
		sta $fffe
		lda #>intro_irq 
		sta $ffff
	
		lda #$1b
		sta $d011
		
		lda #$fa
		sta $d012
!:
		lda $d012
		cmp #$45
		bne !-
		jsr init_nmi

wait_for_sort:
		jsr sort_sprites
		jsr update_sprite_coords

.if (TEST_MODE == 1){		
		cli
}
		jsr point_safe_sprites
		
		//inc must_fade_tizia+1
		jsr update_sprite_coords
		jsr relocate_stuff
		jsr display_bmp
		jsr point_sprites

intro_wait:
		inc relocated_ok
	
		jsr initsprites
		jsr place_cover_sprites
		inc must_fade_tizia+1
wait_for_outro:
		jmp *
go_outro:
		jsr redraw_columns //;Ridisegno la parte finale in char mode prima di stoppare l'NMI	
!:
		lda #$79
		cmp $d012
		bne !-

		lda #<closing_irq 
		sta $fffe
		lda #>closing_irq 
		sta $ffff

		lda #<nothing
		sta $fffa //; Set low IRQ adress in selected bank
		lda #>nothing
		sta $fffb //; Set high IRQ adress in selected bank
	
wait_scene:
		jmp *

.import source "nmi.asm"
//;--------------------------------------
//;Punto al volo gli sprites di sicurezza
//;mentre riloco altrimenti sglitcha bene
//;sull'intro
point_safe_sprites:
		lda #$ff
		ldx #$40
!:
		sta safe_sprite_zone,x
		dex
		bpl !-

		lda #[safe_sprite_zone/$40]
		ldx #8
!:
		sta sprite_pt_01,x
		dex
		bpl !-

		rts

//;------------------------------------
//;Mega reloc routine
relocate_stuff:		
		ldx #0
!:
		lda sprites_source,x
		sta sprites_destination,x
		lda sprites_source+$100,x
		sta sprites_destination+$100,x
		lda sprites_source+$200,x
		sta sprites_destination+$200,x
		dex
		bne !-
		rts
//;--------------------------------------


.import source "irqs.asm"
	
top_irq_wobble:
		:open_irq()

		asl $d019				   			   			   			
		lda #$1b
		sta $d011
	
plex_irq_line:
		lda #$ff
		sta $d012
		
		//;---PUNTO IRQ DI SOTTO----
		lda #<top_irq 
		sta $fffe
		lda #>top_irq 
		sta $ffff
		//;------------------------------
	
		:close_irq()
		rti

.pc = * "bottom irq"
bottom_irq:
		:open_irq()
		asl $d019
		
		lda #$1b
		sta $d011

		lda #1
		sta sprupdateflag
		
		lda #MAXSPR
		sta numsprites
			
		jsr sort_sprites

//;---------------------------------
//;RIPOSIZIONO I PRIMI 8 SPRITES
		ldy #$7
		ldx #$e
!:		
		lda sortspry,y
		sta $d001,x
  
		lda sortsprx,y
		sta $d000,x
		
		lda sortsprf,y
		sta sprite_pt_01,y   //;for color & frame
		
		lda #DARK_GRAY
		sta $d027,y
	
		dey
		dex
		dex
				
		bpl !-
//;-----------------------	
must_fade_sprites:
		lda #0
		bne !+
		jsr fade_sprites
!:
		lda sortsprx_hi+7
		sta $d010
	
		clc
		lda sortspry+fst_irq
		adc #21
		sta plex_irq_line+1
		sta $d012		
		
		lda #<top_irq
		ldx #>top_irq

		sta $fffe
		stx $ffff	

		bit $d011 
        bpl *-3
        bit $d011
        bmi *-3

		lda #$1b
		sta $d011

		cli
	//	inc $d020
		jsr music.play
	//	dec $d020
	
dl:		
		lda $e3
		cmp #2
		beq !+
		
		jsr update_sprite_coords
		inc $e3
		jmp skp
!:	
		lda #0
		sta $e3

skp:	
		lda #$ff
		sta $d01b
		

		//;lda #LIGHT_RED
sprite_col_00:
		lda #PURPLE
		sta $d025

sprite_col_01:		
		lda #BLACK
		sta $d026
		
		ldx pt_x_offset
		lda exit_sinus,x
		sta x_offset
		
		lda counter_giri
		cmp #3
		bmi !+
		
		lda #$ff
		sta priority_set+1 //;disabilito la priorita CONTROLLARE
	
		inc pt_x_offset
		lda pt_x_offset
		cmp #$80
		bne !+

		lda #$3
		sta $d015

		//;Mantengo gli sprite congelati a dx
		lda #4
		sta counter_giri
		dec pt_x_offset
		
		lda #[safe_sprite_zone/$40]
		sta sprite_pt_01
		sta sprite_pt_01+1

		lda #0
		sta priority_set+1

		lda #DARK_GRAY
		sta $d027
		sta $d028
		sta $d025
		sta $d026

		lda #2
		sta $d010
	
		lda #<pre_outro_irq 
		sta $fffe
		lda #>pre_outro_irq 
		sta $ffff
		lda #$1b
		sta $d011

		lda #$fc
		sta $d012
		//;stoppo i timer
	//	lda #0
	//	sta $dc0e
	//	sta $dc0f
!:
		jsr wob_bitmap
		:close_irq()
		rti

pt_x_offset:
.byte $0

//;Quanti giri di tabella sè fatto il plexer..
counter_giri:
.byte $0

.pc = * "plexer"
.import source "plexer.asm"

.pc = * "intro tizia code"
.import source "transitions\starter.asm"

.pc = * "sprites definition source"
.align $40 
sprites_source:
.import binary "sprite_pallette.raw"

.pc = * "left right border functions"
.import source "functions.asm"

//;-----------------------------------
//;INIT DEL BMP - pulisce lo schermo 
//;(superiore e inferiore) e disegna 
//;le "colonne" da wobblare
//;-----------------------------------
display_bmp:		
		
		lda #$b1
		ldy #8
bk:
.for(var t=17;t<25;t++){
		sta SCREEN_1+[t*$28],y
		sta SCREEN_1+[t*$28]+1,y

		sta SCREEN_1+[t*$28]+$25,y
		sta SCREEN_1+[t*$28]+$26,y
}
		dey
		bpl bk


//;SE COMPARE SPORCIZIA SULLO SCHERMO SUPERIORE CONTROLLARE QUI
		ldy #0
anothoriz:
		ldx #3
		//;blank char
		lda #$f0
horiz_blank:
		sta SCREEN_1+4*$28,x
		inx
		cpx #20
		bne horiz_blank
		:go_down_one_line(horiz_blank)
		iny
		cpy #12
		bne anothoriz

		ldy #0
anoth:
		lda #$11
		ldx #8
!:
bmpl:
		sta $4b4d,x
		dex
		bpl !-
		:go_down_one_line(bmpl)
		iny
		cpy #5
		bne anoth

//;Pulisco i pixel sporchi
		lda #0
		ldx #0
!:
		sta $7418,x
		sta $7558,x
		dex
		bne !-
		rts

.macro go_down_one_line(target){
		clc
		lda target+1
		adc #40
		sta target+1
		bcc !+
		inc target+2
!:
}

.align $20
fade_table_c0:
.byte BLACK,BLACK,BLACK,BROWN,BROWN,BROWN,RED,RED,RED,GRAY,GRAY,GRAY,ORANGE,ORANGE,ORANGE,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,YELLOW,YELLOW,YELLOW
fade_table_c1:
.byte YELLOW,YELLOW,YELLOW,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,CYAN,CYAN,CYAN,LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE,GRAY,GRAY,GRAY,BLUE,BLUE,BLUE,BLACK,BLACK,BLACK

fade_pt_spr:
.byte $0



.import source "bmp_wobbler/wob_routine_bmp.asm"




/*
//;TUTTO GIA IN MEMORIA
.pc = $3f00 "border wave sintable"
//border_wave:
.import source "sintables\border.asm"

/*
.pc = char_base "border charsets"
.import source "border-charsets.asm"
*/

.pc = bitmap_start "bitmap"
.import binary "girl/girl_bmp.prg"
	
.pc = $995a "closing irq"
pre_outro_irq:
		:open_irq()
		
		lda #$1b
		sta $d011

		asl $d019
	
		jsr music.play

		jsr keep_on_wobbling

can_final_fade:
		lda #0
//		beq !+
//		jmp nof
//!:
		jsr clean_tizia
nof:
		:close_irq()
		rti

closing_irq:
		:open_irq()
		
		lda #3
		sta $d015

		asl $d019

d011_swtch:	
		lda #$1b
		sta $d011

		jsr keep_on_wobbling

		ldx fade_pt
		lda fade_border,x
		sta $d021
		
		inc fade_pt
		lda fade_pt
		cmp #9
		bne !+
		
		lda #0
		sta d011_swtch+1
		lda #$7f
		sta $dc0d
		sta $dd0d
		
		/*
		lda #<quit_scene
		sta wait_scene+1
		
		lda #>quit_scene
		sta wait_scene+2
		*/
		lda #8
		sta fade_pt
		jmp nfade
!:
		
nfade:
		jsr $1003
		:close_irq()
		rti

fade_pt:
.byte $0

fade_border:
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte GRAY,GRAY,GRAY,GRAY,DARK_GRAY,DARK_GRAY
		
quit_scene:
		rts



.pc = * "intro irq"
.import source "pre_plexer.asm"


redraw_columns:
		//;BORDO SX
		ldx #1
		ldy #2
.var offs = $28

draw_bordo_sx:		
of_sx_0:
		stx SCREEN_1+$28*16
of_sx_1:
		sty SCREEN_1+1+$28*16
		
		:go_down_one_line(of_sx_0)
		:go_down_one_line(of_sx_1)
		
		inc linect1+1
linect1:
		lda #16
		cmp #25
		bne of_sx_0
				
.eval offs = 0

//;BORDO DX
		ldx #$b3
		ldy #$b4
	
draw_bordo_dx:		
of_dx_0:
		stx SCREEN_1+$25+$28*16
of_dx_1:
		sty SCREEN_1+1+$25+$28*16
		
		:go_down_one_line(of_dx_0)
		:go_down_one_line(of_dx_1)
		
		inc linect2+1
linect2:
		lda #16
		cmp #25
		bne of_dx_0
		rts

fade_sprites:
		//;ldy fade_pt_spr
		lda fade_table_c0
		sta sprite_col_00+1

fade_sprites2:
		lda fade_table_c1
		sta sprite_col_01+1

		inc fade_sprites+1
		inc fade_sprites2+1

		inc volte+1
volte:
		lda #0
		cmp #19
		bne !+
		inc must_fade_sprites+1
!:
		rts