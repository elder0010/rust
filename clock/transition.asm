.var TEST_MODE=0


.const accu = $89
.var SPEED = $8a
.const screenChars  = $7800 //; the 40x25 buffer
.const screenPixels = $4000 //; the pixel data for font or bitmap ($1000 or $9000 are always charrom)
.const x_wob_pt = $40
.const y_wob_pt = $41
.const bubble_x_wob = $43


.import source "../common/functions.asm"

.if (TEST_MODE == 1){	
	.var music = LoadSid("intro.sid")
	:BasicUpstart2(scene_start)
	.pc=music.location "Music" .fill music.size, music.getData(i)
}


.pc = $7fc0 "bubble sprite"
bubble_sprite:
.import binary "data/bubble_sprite.raw"

.pc = $7ea0 "scene start"
scene_start:
.if (TEST_MODE == 1){
		sei
		lda #0
		jsr $1000
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
		
		lda #LIGHT_BLUE
		sta $d020

		lda #BLUE
		sta $d021
}	

		jsr clean_screen
		jsr init_sprites

		lda #[[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018

		lda #$d8
		sta $d016

		:bank_1()

!:
		lda $d012
		cmp #$74
		bne !-
		

		:d011($13)
		:d012($fa)
		:set_irq(irq)

.if(TEST_MODE==1){
		cli
		jmp *
}
		rts
irq:
		:open_irq()
		asl $d019
		jsr move_bubble

		jsr $1003
	
		:close_irq()
		rti

.pc = * "functions"
.import source "transition_functions.asm"



.pc = $8000
.pc = * "sintable"
sin_table:
.import source "data/sin_x.asm"

.pc = * "bubble start x"
bubble_start_x:
.byte $f4,$80,$e0,$a9,$f0,$75,$b6,$e8
.byte $90,$5f,$86,$c6,$a4,$80,$b5,$82


bubble_speed:
.byte 190,210,160,220,180,192,174,201
.byte 184,214,194,170,204,171,168,205



.pc = * "move bubble function"
move_bubble:
		ldx bubble_x_wob
		lda bubble_start_x,x
		ldy x_wob_pt
		clc
		adc sin_table,y
		sta $d00c
dlr:
		lda #0
		eor #$ff
		sta dlr+1
		beq endmov

		lda accu
		sec
		adc SPEED
		sta accu

		bcc endmov

		//;sec carry already set
		lda $d00d
		sbc #1
		sta $d00d
		bcs endmov
		clc
		lda bubble_x_wob
		adc #1
		and #$0f
		sta bubble_x_wob
		tax
		lda bubble_speed,x
		sta SPEED
endmov:
		inc x_wob_pt
		rts



//;.import binary "data/startx.raw"
//;;.import source "data/bubble_x.asm"
