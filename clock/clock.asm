.var	TEST_MODE
.if (cmdLineVars.get("test")==null) .eval TEST_MODE=false
							   else .eval TEST_MODE=cmdLineVars.get("test").asBoolean()
							   
.var music = LoadSid("..\SID\rust_outro.sid")

.import source "variables.asm"
.import source "../common/functions.asm"
.import source "transition.sym"

.if (TEST_MODE){	
	:BasicUpstart2(clock_scene_start)
	.pc=music.location "Music" .fill music.size, music.getData(i)
}



.pc = $2800 "freshness scrolling machine"
.import source "fresh/scroll.asm"


.pc = $3800 "charset"
.var charsetPic = LoadPicture("data/charset-bold.gif", List().add($000000, $ffffff))
.function picToCharset(byteNo, picture,max) {
 .var ypos = [byteNo&7] + 8*[[[byteNo/[max*16]]&1]]
 .var xpos = 2*[mod([byteNo>>3],max)] + [[byteNo/[max*8]]&1]
 .return picture.getSinglecolorByte(xpos,ypos)  
}
.var data = LoadBinary("data/charbin")
.fill 27*8,data.get(i)  // Letters
.fill 5*8,data.get(49*8+i) // Specials
.fill 1*8,0     // Space
.fill 10*8,data.get(48*8+i) // Numbers
.fill 2*8,0     // Left empty
.fill NChar*8*4, picToCharset(i,charsetPic,NChar)



.pc = screenPixels "bitmap"
.import c64 "data/steamclock.prg"


.pc = $3fc0 "bubble sprite copy"
.import binary "data/bubble_sprite.raw"

.pc = $3300 "scene start"
clock_scene_start:
.if (TEST_MODE){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
		
		lda #LIGHT_BLUE
		sta $d020

		lda #BLUE
		sta $d021

		lda #0
		sta $d011	
}
		jsr relocate_text
		jsr clean_charscreen
		jsr clock_init_sprites
		:bank_0()
		lda #[[[temp_charscreen & $3fff] / $0400] << 4] + [[[temp_charset & $3fff] / $0800] << 1]
		sta $d018

		lda #0
		sta $7fff
		sta finished_scroll
		lda #36
		sta y_wob_pt

		lda #$33
		sta d011val
		
		jsr display_bitmap
	
		lda #$d8
		sta $d016

!:
		lda $d012
		cmp #$74
		bne !-

		:d012($fa)
		:set_irq(msx_sync_irq)
				
.if(TEST_MODE) {
		lsr $d019
		cli
}

can_scroll:
		lda #0		
		beq can_scroll		
		jsr start //;jsr to scroll routine
		jmp *


clock_irq:
		:open_irq()
		asl $d019
		jsr wob_pic_x
		jsr wob_pic_y

		lda d011val
		sta $d011

		jsr move_bubble
		jsr $1003

		inc dlf+1
dlf:
		lda #0
		cmp #3
		bne !+
		lda #1
		sta can_scroll+1 //;via allo scroll

!:

//;Quando si vuole far partire l'FLD al contrario basta fare un inc finished_scroll
		lda finished_scroll
		beq !+
		:set_irq(fld_top_irq)
		:d012($2a)
		
!:
		:close_irq()
		rti

end_irq:
		:open_irq()
		asl $d019
		jsr $1003
		:close_irq()
		rti


.pc = * "functions"
.import source "functions.asm"

msx_sync_irq:
		:open_irq()
		asl $d019		
		lda $1731
		cmp #$86		
		.if (TEST_MODE) lda #$00
		bne !+		
		:set_irq(fld_bottom_irq)
!:	
		jsr wob_pic_x
		jsr move_bubble
		jsr $1003
		:close_irq()
		rti

.align $100
.pc = * "sintable"
.import source "data/sin_y.asm"
.import source "fld.asm"

.pc = $6800
.import	source "fresh/text.asm"


.if (TEST_MODE) {
	.pc = $7ea0 "bubble sprite"
	.import c64 "transition.prg"
}