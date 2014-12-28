.var TEST_MODE=1

.import source "variables.asm"
.import source "../common/functions.asm"

:BasicUpstart2(scene_start)

.var music = LoadSid("Videogamer.sid")
.pc=music.location "Music" .fill music.size, music.getData(i)


.var ct = $34

.pc = $9800 "code"
scene_start:
	.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
}	
	
		lda #0
		sta $d011

		lda #$a0
		sta $d012
		
		lda #<irq_bottom
		sta $fffe
		lda #>irq_bottom
		sta $ffff

		lda #$c8
		sta $d016
		
		//; Select VIC bank
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

		//; Set VIC screen and font pointers
		lda # [[[rotator_screen & $3fff] / $0400] << 4] + [[[rotator_chars & $3fff] / $0800] << 1]
		sta $d018
		
		:bank_3()

		lda #$1b
		sta $d011

		lda #0
		sta tmp
		sta ct

		ldx #0
		lda #0
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		dex
		bne !-

		ldx #0
		lda #$ff
!:
		sta $c800,x
		sta $c800+$100,x
		sta $c800+$200,x
		sta $c800+$300,x
		dex
		bne !-

		cli	
		

		jmp *


.import source "rotator_routine.asm"

