.var TEST_MODE=0
.var music = LoadSid("psycho.sid")

.import source "hatgirl.sym"
.import source "variables.asm"
.import source "../common/functions.asm"


.if (TEST_MODE == 1){	
	:BasicUpstart2(scene_startx)
	.pc=music.location "Music" .fill music.size, music.getData(i)
}



.pc = $2800 "charset"
screenChars:
.var charsetPic = LoadPicture("data/charset.gif", List().add($000000, $ffffff))
.function picToCharset(byteNo, picture) {
	.var ypos = [byteNo&7] + 8*[[byteNo>>9]&1] 
	.var xpos = 2*[[byteNo>>3]&$3f] + [[byteNo>>10]&1]
	.return picture.getSinglecolorByte(xpos,ypos)		
}
.fill $800, picToCharset(i,charsetPic)
.print "Write text routine "+toHexString(write_texts)
.pc = $3000 "scene start"
scene_startx:
.if (TEST_MODE == 1){
		sei
		
		lda #0				
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()	


		lda #DARK_GRAY
		sta $d021
		sta $d020
		lda #$ff
		sta $d015


		lda #DARK_GRAY
		ldx #0
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		dex
		bne !-

!:
		lda $d012
		cmp #$9e
		bne !-

		:set_irq(irq1)
 		:d011($3b)
 		:d012($f9)
		:bank_0()

		lda #[[[screenPixels & $3fff] / $0400] << 4] + [[[screenChars & $3fff] / $0800] << 1]
		sta $d018
}

		jsr blank_text_sprites

 		lda #0
 		sta can_fade_sprites
 		
 		ldx #0
!:
 		sta screenPixels,x
 		sta screenPixels+$100,x
 		sta screenPixels+$200,x
 		sta screenPixels+$300,x
 		dex
 		bne !-
 		

 		lda #0
 		sta $3fff

 		

.print "point text sprites "+toHexString(point_text_sprites)
.print "SPRITE_HANDLER_FUNCTION "+toHexString(SPRITE_HANDLER_FUNCTION)
!:
		lda $d012
		cmp #$d5
		bne !-


		jsr point_text_sprites

		//;abilito il bank switching
 		//;cambiando gli indirizzi farlocchi in $dd00
 		:set_addr($dd00,bank_switch_0)
 		:set_addr($dd00,bank_switch_1)
 		:set_addr(text1,text_string)

 		lda #$ff
 		sta sprite_enabler2+1


 		:set_addr(handle_texts,sprite_handler_function) //;quella che li fa fadare

 .if(TEST_MODE==1){
 		lda #DARK_GRAY
		jsr colour_sprites
 		cli
 }

 		//;massimo fomento raggiungibile
 		//;attesa cassa techno prima del fade nomi
 		//;per alzare il panico al party, dove tutti penseranno
 		//;"Ah è finito il demo" E INVECE NO!!!!
!:
 		lda $173f
 		cmp #$03
 		bne !-

 		lda #HOW_MUCH_TEXT_DELAY
 		sta text_delay

		jsr write_texts
	
!:
		lda can_go_outro
		beq !-
		jsr outro_fade
		:set_addr(fade_out_everything,FINAL_FADE_FUNCTION)
		rts

.align $100
text1:
.text " elder0010  "
.byte 0
text2:
.text " freshness  "
.byte 0
text3:
.text " psycho8580 "
.byte 0
text4:
.text "    cons    "
.byte 0
text5:
.text "almightygod "
.byte 0
text6:
.text "   raina    "
.byte 0
text7:
.text "    adam    "
.byte 0
text8:
.text "            "
.byte 0

.import source "sprite_functions.asm"
irq1:	
		:open_irq()
		asl $d019

		lda #$13
		sta $d011
		ldy #$90
		:wait()
		lda #$1b
		sta $d011

		jsr handle_texts
		jsr $1003

		:close_irq()
		rti
.import source "outro.asm"
