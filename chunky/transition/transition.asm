.var TEST_MODE = 0
.var MUSIC_SYNC = 1

.var lista_color0 = List()
.var lista_color1 = List()
.var lista_color2 = List()
.var lista_color3 = List()
.var lista_color4 = List()
.var lista_color5 = List()
.var FrameNumber=128


.import source "variables.asm"
.import source "../variables.asm"
.var music = LoadSid("../../tentacoli/Psycho.sid")

.import source "../../common/functions.asm"
.if (TEST_MODE == 1){

.pc=music.location "Music" .fill music.size, music.getData(i)

:BasicUpstart2(transition)
}


.pc = $3900
sprite:
.fill $40,$ff

sprite_final:
.import binary "bottom_sprite.raw"

.pc = $cc00 "intro code start"
transition:
//;-------------------------------------------------------------------------
	
.if (TEST_MODE == 1){
	sei
	
//;-------------------------------------------------------------------------
//; Turn all sprites off
//;-------------------------------------------------------------------------
	lda #$6
	sta $d020
	sta $d021
}
	
!:
	lda $d012
	cmp #$75
	bne !-
	lda #>irq_waster
	sta $ffff
	
	lda #<irq_waster
	sta $fffe
	
//	:d011(0)
//	:d012($fc)

	jsr clear_screen
	
	lda #0
	sta wob_pt
	//;sta $3fff
	sta sprite_y_start
	sta can_fade_out

	:bank_0()
	
	
	jsr point_sprites
	jsr reloc_all
	jsr fill_screen_pixels
	jsr colour_clean_a
	jsr colour_clean_b
	jsr draw_ritocchi
	
	
back:	
	lda transition_end
	beq back

	jmp scene_start

	jmp back
	
transition_end:
.byte $0

.pc = * "safe irq"
irq_waster:
	:open_irq()
	
	asl $d019


dlx:
	lda frame_lo
.pc = * "delay amount"
delay_amount:
	cmp #$1d
	bne !+
		
	//lda #$fc
	//sta $d012

	lda #>music_irq
	sta $ffff
	
	lda #<music_irq
	sta $fffe
!:
	jsr count_frames
	
	jsr $1003

	:close_irq()
	rti

//;DELAY PRE TRANSAZIONE	
irq_delay:
.byte $0
	
irq_top:	
	:open_irq()

	lda #$3f
	sta $d015
	
	lda #>irq_1
	sta $ffff
	
	lda #<irq_1
	sta $fffe
	
	asl $d019
	
	lda #$f9
	sta $d012
	
	ldy #0
	
plex_loop:	
	
//	inc $d020
	clc
	lda sprite_y_start
	
	sta $d001
	sta $d003
	sta $d005
	sta $d007
	sta $d009
	sta $d00b
	sta $d00d
	sta $d00f
	
	lda sprite_y_start
	adc tab_pixel,y
	sta sprite_y_start
	
//	dec $d020
	
	clc
	lda $d012
	adc tab_ritardi,y
!:
	cmp $d012
	bcs !-
	
	lda puntatori,y
	sta screen+$03f8
	sta screen+$03f9
	sta screen+$03fa
	sta screen+$03fb
	sta screen+$03fc
	sta screen+$03fd
	
	iny
	cpy #6
	bne plex_loop

	:close_irq()
	rti	

.align $6
tab_ritardi:
.byte 18,18,18,18,19
tab_pixel:
.byte 21,21,21,21,21

puntatori:
.byte sprite/[$40],sprite/[$40],sprite/[$40],sprite/[$40],sprite/[$40],sprite/[$40],sprite_final/[$40]

/*
check_rullante:
		//;Contiamo i colpi di rullante..
		lda $171c
		cmp #$40
		bne !+
		inc snare_hits
		inc $d020
		inc $d021
!:
		rts
*/


count_frames:
		clc
		lda frame_lo
		adc #1
		sta frame_lo
		bcc !+
		inc frame_hi
!:
		rts

//;----------------------------------------------
//;Apertura bordo 1
//;----------------------------------------------	
irq_1:
	:open_irq()
	
	lda #$fc
	sta $d012
	
	lda $d011
	and #$f7
	sta $d011

	lda #>music_irq
	sta $ffff
	
	lda #<music_irq
	sta $fffe
	
	asl $d019

	:close_irq()
	rti	
	
//;----------------------------------------------
//;Apertura bordo 2
//;----------------------------------------------		
music_irq:
:open_irq()
	
	asl $d019
		
	lda #>irq_top
	sta $ffff
	
	lda #<irq_top
	sta $fffe
	
	ldx wob_pt
	
	lda sine_1,x
	sta sprite_y_start
	
	sec
	lda sprite_y_start
	sbc #5
	sta $d012
	
	lda $d011
	ora #8
	sta $d011
	
	lda #0
	sta $d015

	inc wob_pt
	

//;vecchia sincronia a frame	
	lda wob_pt
	cmp #$57
	bne !+	
	
	inc giri
	lda giri
	cmp #2
	bne !+
	inc transition_end
!:
	
	jsr $1003
	jsr move_sprites_x
	
	:close_irq()
	rti
	
move_sprites_x:
	
	lda #0
	sta $d010

	clc
	
	inc addr_x+1
	
addr_x:	
	lda sine_2+21 //;Questo fa il fine tuning della fine
	sta $d000

	
	adc #21
	sta $d002

	adc #21
	sta $d004

	
	adc #21
	sta $d006
	bcc !+
	tay
	lda $d010
	ora #%00001000
	sta $d010
	tya
!:

	adc #21
	sta $d008
	bcc !+
	tay
	lda $d010
	ora #%00010000
	sta $d010
	tya

!:


	adc #16
	sta $d00a
	bcc !+
	
	lda $d010
	ora #%00100000
	sta $d010
	
!:

	ldx fade_tb_pt
	lda fade_tb,x
	sta $d027
	sta $d028
	sta $d029
	sta $d02a
	sta $d02b
	sta $d02c
	
	inc fade_tb_pt
	lda fade_tb_pt
	cmp #25
	bne !+
	dec fade_tb_pt
!:
	
	//sta sine_2
	
	rts
	
	
giri:
.byte $0


clear_screen:
	lda space
	ldx #0
!:
	sta screen,x
	sta screen+$100,x
	sta screen+$200,x
	sta screen+$300,x
	dex
	bne !-
	
	rts

space:
.text " "

point_sprites:
	lda #sprite/[$40]
	sta screen+$03f8
	sta screen+$03f9
	sta screen+$03fa
	sta screen+$03fb
	sta screen+$03fc
	sta screen+$03fd

	lda #$0
	sta $d010
	
	lda #$ff
	sta $d027
	sta $d028
	sta $d029
	sta $d02a
	sta $d02b
	sta $d02c
	sta $d02d
	
	lda #0
	sta $d01c
	rts


fade_tb:	
.byte $ee,$ee,$ee,$ee,$33,$33,$33,$33,$dd
.byte $dd,$dd,$dd
.byte $11,$11,$11,$11,$dd,$dd,$dd,$dd,$33
.byte $33,$33,$33,$ff

fade_tb_pt:
.byte $0
	
.macro wait_rst(line){
!:
	lda $d012
	cmp line
	bne !-
}


fill_screen_pixels:	
	ldx #0
	lda #%10100101
FillScreen:
	sta $4000, x
	sta $4100, x
	sta $4200, x
	sta $4300, x
	sta $4400, x
	sta $4500, x
	sta $4600, x
	sta $4700, x
	sta $4800, x
	sta $4900, x
	sta $4a00, x
	sta $4b00, x
	sta $4c00, x
	sta $4d00, x
	sta $4e00, x
	sta $4f00, x
	sta $5000, x
	sta $5100, x
	sta $5200, x
	sta $5300, x
	sta $5400, x
	sta $5500, x
	sta $5600, x
	sta $5700, x
	sta $5800, x
	sta $5900, x
	sta $5a00, x
	sta $5b00, x
	sta $5c00, x
	sta $5d00, x
	sta $5e00, x
	sta $5f00, x
	inx
	bne FillScreen
	

	ldy #00
.var pointer = $53
	lda #$00
	sty pointer 
	lda #$40
	sta pointer+1
	lda #$00
	ldy #$2f
!:
	sta (pointer),y
	dey
	bpl !-
	clc
	lda pointer
	adc #$40
	sta pointer
	lda pointer+1
	adc #$01
	sta pointer+1
	cmp #$70 
	lda #$00
	ldy #$2f
	bcc !-
	

	
	ldx #0
	lda #$66
SetColorloop:
	sta $6000, x
	sta $6400, x
	sta $6100, x
	sta $6500, x
	sta $6200, x
	sta $6600, x
	sta $6300, x
	sta $6700, x
	sta $6000 + $800, x
	sta $6400 + $800, x
	sta $6100 + $800, x
	sta $6500 + $800, x
	sta $6200 + $800, x
	sta $6600 + $800, x
	sta $6300 + $800, x
	sta $6700 + $800, x
	dex
	bne SetColorloop	

	 rts
.pc = * "intro code end"
.import source "../ninja.asm"
