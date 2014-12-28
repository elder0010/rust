//;---------------------------------------------
//;BUTTERFLY Routine (code + sprites)
//;---------------------------------------------
.var MUSIC_SYNC =1
.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"

//;.var outro_irq_top = $a453
//;.var nx_irq_line = $a4d3

/*
.pc = $7500 "lut teschio"
.import binary "../tetris/data/skull/screen.raw"
*/

.pc = $7994 "raster 1"
raster1:
		pha txa pha tya pha 
		asl $d019
	
cover_sprite_1_x:
		lda #$60
		sta $d000

cover_sprite_1_y:
		lda #$60
		sta $d001		

		ldx sprite_pointer

		lda sprites_y,x
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		ldy #3
		:wait()
		
		clc
		lda puntatori,x
		sta screenChars+$03f9
		adc #1
		sta screenChars+$03fa
		adc #1
		sta screenChars+$03fb
		adc #1
		sta screenChars+$03fc
		adc #1
		sta screenChars+$03fd
		adc #1
		sta screenChars+$03fe
		adc #1
		sta screenChars+$03ff
		
		inc sprite_pointer

		inc plex_irq_ct
		
		lda plex_irq_ct
		tax
		
		cmp #7
		beq msx_irq
		//;Setto il prox irq
		sec
		lda sprites_y,x
		sbc #2
		sta $d012
	
	//	inc $d020
		
		nop
		nop
		
		jmp new_irq
		
msx_irq:		
		lda #<reflection_irq
		sta $fffe
		lda #>reflection_irq
		sta $ffff

reflex_irq_line:	
		lda #$a5
		sta $d012
		
		lda #0
		sta plex_irq_ct
		sta sprite_pointer
		sta wob_pt
		sta puntatori_pt
		
skip:		
		ldy #150
		:wait()
		
		nop
		nop
lower_bt_col:		
		lda #REFLEX_COLOUR
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c
		sta $d02d
		sta $d02e

		lda $d010
		and #$fe
		sta $d010

		lda #BROWN
		sta $d027
		sta $d02e

cover_sprite_2_x:
		lda #$80
		sta $d000

cover_sprite_2_y:
		lda #$200
		sta $d001	
	
		//ldy #BROWN
		//sty $d015
		//;sty $d020

new_irq:		
		
		pla tay pla tax pla
		rti
		
reflection_irq:
		pha txa pha tya pha 

		ldy #UNDER_COLOUR	
		bit $24
		bit $24
bg_1:		
		sty $d020
bg_2:
		sty $d021

		ldx sprite_pointer
		
		lda sprites_y_reverse,x

		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		bit $24

	
		ldy #12
		:wait()

		//;ldy #$ff
	
		clc
		lda puntatori_reverse,x
		sta screenChars+$03f9
		adc #1
		sta screenChars+$03fa
		adc #1
		sta screenChars+$03fb
		adc #1
		sta screenChars+$03fc
		adc #1
		sta screenChars+$03fd
		adc #1
		sta screenChars+$03fe
		adc #1
		sta screenChars+$03ff
		//;sty $d015
		//;	sty $d021	
		lda #$9
		sta $d011
	
		inc sprite_pointer

		inc plex_irq_ct
lower_fix_col:		
		ldy #BROWN //;questo diventerà rosso
		sty $d02e

		lda plex_irq_ct
		tax
		cmp #4
		beq msx_irq_r
		//;Setto il prox irq
		sec
		lda sprites_y_reverse,x
		sbc #3
		sta $d012
	
		jmp new_irq_r
		
msx_irq_r:		
		lda #<raster2
		sta $fffe
		lda #>raster2
		sta $ffff
		
		lda #$fa
		sta $d012
		
new_irq_r:		
		asl $d019	

		//;Tolgo i gray dots
		lda #04
		sta bg_1+2
		sta bg_2+2
	
		pla tay pla tax pla
		rti
	
.pc = * "raster 2"	
raster2:
		pha txa pha tya pha 

		/*Idle state*/
		lda #0
		sta $d011
!:
		bit $d011
		bpl !-

		lda #$8
		sta $d011

		jsr $1003
		//;jsr shuffle_x_sprites

		lda must_fade_butterfly
		beq !+
		jsr fade_butterfly
!:

		jsr calc_x_sprites
		jsr calc_y_sprites
		
//;CALCOLO Y SPRITE COVER
		ldx sprite_pointer
		sec
		lda sprites_y,x
		sbc #22
		sta cover_sprite_1_y+1	
		clc
		ldx x_pt
		asl $d019	
   			   			   			
		//;lda #$0 sta $d012

		lda #<bg_irq sta $fffe
		lda #>bg_irq sta $ffff
		
		lda #0
		sta plex_irq_ct
		sta sprite_pointer
		sta puntatori_pt
		sta $d012


upper_bt_col:		
		lda #BUTTERFLY_COLOUR
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c
		sta $d02d
		sta $d02e
		sta $d02f

		lda #ORANGE
		sta $d027
		
		//;Tolgo i gray dots
		lda #$d0
		sta bg_1+2
		sta bg_2+2

		lda y_pt
.pc = * "Final delay"
		cmp #$a3
		bne !+
		inc giri_f+1
giri_f:
		lda #0
		cmp #4
		bne !+
		lda #$ce //;DEC
		sta fade_dir

		lda #0
		sta fade_chk+1
		dec fade_ptr
		lda #1
		sta must_fade_butterfly
		sta final_check+1
!:

		//;Attendo il fade finale per puntare l'irq di outro
final_check:
		lda #0
		beq !+

		lda must_fade_butterfly
		bne !+
		lda #<outro_irq_top sta $fffe
		lda #>outro_irq_top sta $ffff
		lda #0
		sta $d015
		lda #$0b
		sta $d011
		lda #$0
		sta $d012

		clc
		lda reflex_irq_line+1
		adc #8
		sta nx_irq_line+1

!:
		pla tay pla tax pla
	
		rti	

.pc = $7bb9 "bg_irq"
bg_irq:
		:open_irq()
		asl $d019	
   			   			
   		lda #BG_COLOUR
		sta $d020
		sta $d021

		lda #$2 sta $d012

		lda #<raster1 sta $fffe
		lda #>raster1 sta $ffff
		:close_irq()
		rti


calc_y_sprites:
		clc
		ldx #0
		//;lda #41
		inc y_pt
		ldy y_pt

		sec
		lda sine_y,y
		sbc #6	
		sta sprites_y,x
		clc
!:		
		adc #21
		sta sprites_y,x
		inx 
		cpx #7
		bne !-
		
		clc
		lda sine_y,y
		adc #$99
		sta reflex_irq_line+1
		
		sec
		sbc #10
		ldx #0
		sta sprites_y_reverse,x
		clc
!:		
		adc #21
		sta sprites_y_reverse,x
		inx 
		cpx #4
		bne !-

		lda sprites_y_reverse+3
		sta cover_sprite_2_y+1
		
		rts 

.pc = * "calc_x_sprites"
calc_x_sprites:

		lda #0
		sta $d010
		
		ldx x_pt
		lda sine_x,x
	
		clc   
		ldx #0
		ldy #14
!:
		sta $d000,x
		adc #24
		bcc nod  
		stx temp
		ldy temp  
nod:
		inx
		inx
		
		cpx #16
		bne !-
		tya
		lsr
		tay
		lda d010_mask,y
		sta $d010

		lda $d010
		and #$fe
		sta $d010

		.var cover_x_under = 1
		//;Calcolo la X del cover sprite 1
		clc
		lda $d002
		adc #cover_x_under
		sta cover_sprite_2_x+1

		adc #145-cover_x_under
		sta cover_sprite_1_x+1
		bcc !+
		lda $d010
		ora #1
		sta $d010
!:
		inc x_pt
		rts
		
.align $8
.pc = * "d010 mask"
d010_mask:

.byte %11111110
.byte %11111100
.byte %11111000
.byte %11110000
.byte %11100000
.byte %11000000
.byte %10000000
.byte %00000000

.pc = * "clear_screen_sprites"
clear_screen_sprites:
		
		ldx #0
!:
		lda #BG_COLOUR
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$16a,x
		lda #UNDER_COLOUR
		sta $d800+$264,x
		sta $d800+$300,x

		lda #0
		sta screenChars,x
		sta screenChars+$100,x
		sta screenChars+$200,x
		sta screenChars+$300,x

		dex
		bne !-
		
		ldx #0
		lda #$0
!:
		sta $d000,x
		inx
		inx
		cpx #16
		bne !-

		rts

must_fade_butterfly:
.byte $1

fade_table:
.byte ORANGE,WHITE,WHITE,WHITE,WHITE
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte LIGHT_RED

fade_table_btn:
.byte BROWN,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte GRAY,GRAY,GRAY,GRAY
.byte RED

fade_ptr:
.byte $0

fade_delay:
.byte $0

.pc = $7cbb "fade_butterfly"
fade_butterfly:
	
		//lda fade_delay
		//cmp #butterfly_fade_delay //;delay pre fade_table_btn
		lda $1782
		cmp #$81
nogo:	bne !+
okfd:
		//;dec fade_delay
		lda #<okfd
		sta nogo+1

		ldx fade_ptr
		lda fade_table,x
		sta upper_bt_col+1

		lda fade_table_btn,x
		sta lower_bt_col+1
		sta lower_fix_col+1
fade_dir:
		inc fade_ptr
fade_chk:
		cpx #9
		bne !+
		dec must_fade_butterfly
!:
		
		//;inc fade_delay
		rts	
.pc = $7ce5 "fine fade_butterfly"
puntatori:
.byte [sprites/$40]
.byte [sprites/$40]+[7]*1
.byte [sprites/$40]+[7]*2
.byte [sprites/$40]+[7]*3
.byte [sprites/$40]+[7]*4
.byte [sprites/$40]+[7]*5
.byte [sprites/$40]+[7]*6


sprites_y:
.byte $0,$0,$0,$0,$0,$0,$0

.var spr_base = $b0
sprites_wob_y:
.byte spr_base,spr_base+22,spr_base+[22*2],spr_base+[22*3],spr_base+[22*4],spr_base+[22*5]
.byte spr_base+[22*5],spr_base+[22*6]

puntatori_wob:
.byte [sprites/$40], [sprites/$40]+1, [sprites/$40]+2, [sprites/$40]+3, [sprites/$40]+4, [sprites/$40]+5, [sprites/$40]+6, [sprites/$40]+7
.byte [sprites/$40]+[7]*1,[sprites/$40]+[7]*1+1,[sprites/$40]+[7]*1+2,[sprites/$40]+[7]*1+3,[sprites/$40]+[7]*1+4,[sprites/$40]+[7]*1+5,[sprites/$40]+[7]*1+6,[sprites/$40]+[7]*1+7
.byte [sprites/$40]+[7]*2,[sprites/$40]+[7]*2+1,[sprites/$40]+[7]*2+2,[sprites/$40]+[7]*2+3,[sprites/$40]+[7]*2+4,[sprites/$40]+[7]*2+5,[sprites/$40]+[7]*2+6,[sprites/$40]+[7]*7

.byte [sprites/$40]+[7]*3
.byte [sprites/$40]+[7]*4
.byte [sprites/$40]+[7]*5
.byte [sprites/$40]+[7]*6


.pc = * "place_sprites"
place_sprites:
		
		ldx #0
		
		lda #52
!:
		sta $d001,x
		inx
		inx
		cpx #16
		bne !-
		
		clc 
		lda #40
		ldx #0
!:
		sta $d000,x
		adc #24
		inx
		inx
		cpx #16
		bne !-
		
		lda #$fe
		sta $d015
		
		rts

.pc = $8500 "sprites source"
sprites_source:
.import source "sprites.inc.asm"

.pc = * "sine y"
.import source "data/sine_y.asm"

.pc = * "sine x"
.import source "data/sine_x.asm"

.align $100
.pc = * "sprites reverse source"
sprites_reverse_source:
.import source "sprites_reverse.inc.asm"

.pc = $2800 "outro"
.import source "outro.asm"

.pc = $2900 "tetris assets"
tetris_assets:
.var tetris_asset_source = *
.import source "../tetris/assets.asm" 
