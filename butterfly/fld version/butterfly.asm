.import source "variables.asm"
.import source "../common/functions.asm"

:BasicUpstart2(scene_start)

.var music = LoadSid("whipe.sid")
.pc=music.location "Music" .fill music.size, music.getData(i)


.var TEST_MODE=1

.pc = $4000 "bitmap"
.import c64 "data\Mar.prg"

.pc = $6800 "code"
scene_start:
	.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
}

		lda #$ff
		sta $d012
		
		lda #<irq_waster
		sta $fffe
		lda #>irq_waster
		sta $ffff

		lda #$00
		sta $d011
		
		lda #$08
		sta $d016
		
		//; Select VIC bank
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

		//; Set VIC screen and font pointers
		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018
 
		
		//;Copio i pixels
		ldx #0
!:
		lda screenPixels+$1f40,x
		sta screenChars,x
	
		lda screenPixels+$1f40+$100,x
		sta screenChars+$100,x
		
		lda screenPixels+$1f40+$200,x
		sta screenChars+$200,x
		
		lda screenPixels+$1f40+$300,x
		sta screenChars+$300,x
		
		dex
		bne !-
		
		lda #0
		sta sine_pt
		sta $d020
		
		cli	
		jmp *

irq_waster:
		:open_irq()
		
		asl $d019
		
		
		inc irq_delay
		lda irq_delay
		cmp #$96 //;QUANTO DELAY
		bne !+
	

		lda #>music_irq
		sta $ffff
		
		lda #<music_irq
		sta $fffe
	!:

		jsr $1003
		
		
		asl $d019
		:close_irq()
		rti

//;DELAY PRE TRANSAZIONE	
irq_delay:
.byte $0

		
top_irq:
		:open_irq()
		
		asl $d019
		
		lda #<music_irq
		sta $fffe
		lda #>music_irq
		sta $ffff
		
		lda #$f8
		sta $d012
		
		
		ldx linee_fld
		beq skip 
		

fld_first_line:		
		lda #$30
        cmp $d012
        bne *-3

        
fld_loop:
        lda $d012 
        cmp $d012
        beq *-3

        clc
        lda $d011
        adc #1
        and #7
        ora #$30
        sta $d011


        dex 
        bne fld_loop 
		

		ldy #30
		:wait()
		nop
		nop
		nop
		nop
		lda #YELLOW
		sta $d020
	
//;Loop che spinge giu il resto della grafica
skip:			


		:close_irq()
		rti

music_irq:
		:open_irq()
		
		
		ldy #20
		:wait()
		
		lda #external_border_color
		sta $d020
		
		lda #<top_irq
		sta $fffe
		lda #>top_irq
		sta $ffff
		
		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018
		
		lda #$27
		sta $d012
		
		lda #$33
		sta $d011
		
		asl $d019
		
		jsr calcola_fld

		jsr $1003
		
		:close_irq()
		rti
		
		
calcola_fld:
		ldx sine_pt
		lda sine,x
		sta linee_fld
	
		//;Calcolo il nuovo offset di start
		clc
		lda sine_pt
		adc #4
		sta sine_pt
		bcc !+
	
		clc
		sbc #8
		sta sine_pt
		
		lda #$33
		sta $d012
		
		
		//;Finita transizione
		lda #<bitmap_irq
		sta $fffe
		lda #>bitmap_irq
		sta $ffff
!:
		rts
		
		
//;----------------------------------------------------
//;Finita la transizione, vado stabile
//;----------------------------------------------------
bitmap_irq:
		:open_irq()
		
		lda #YELLOW
		sta $d020
		
		asl $d019
		
		lda #$f9
		sta $d012
		
		lda #<bitmap_down_irq
		sta $fffe
		lda #>bitmap_down_irq
		sta $ffff
		
		:close_irq()
		rti
		

bitmap_down_irq:
		:open_irq()
		
		ldy #8
		:wait()
		
		lda #external_border_color
		sta $d020
		
		lda #$33
		sta $d012
		
		lda #<bitmap_irq
		sta $fffe
		lda #>bitmap_irq
		sta $ffff
		
		asl $d019
		
		jsr $1003
		:close_irq()
		rti
		
.pc = $2000 "sine"
sine:
.byte 196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196
.byte 196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196
.byte 195,195,195,194,194,193,193,193,192,192,191,191,190,190,189,189
.byte 188,187,187,186,186,185,184,184,183,182,182,181,180,179,179,178
.byte 177,176,175,175,174,173,172,171,170,169,168,168,167,166,165,164
.byte 163,162,161,160,159,158,157,156,155,153,152,151,150,149,148,147
.byte 146,145,143,142,141,140,139,138,136,135,134,133,132,130,129,128
.byte 127,126,124,123,122,121,119,118,117,116,114,113,112,110,109,108
.byte 107,105,104,103,102,100,99,98,96,95,94,93,91,90,89,87
.byte 86,85,84,82,81,80,79,77,76,75,74,72,71,70,69,68
.byte 66,65,64,63,62,60,59,58,57,56,55,53,52,51,50,49
.byte 48,47,46,45,44,42,41,40,39,38,37,36,35,34,33,33
.byte 32,31,30,29,28,27,26,25,25,24,23,22,21,20,20,19
.byte 18,18,17,16,15,15,14,13,13,12,12,11,10,10,9,9
.byte 8,8,7,7,6,6,6,5,5,4,4,4,3,3,3,3
.byte 2,2,2,2,2,1,1,1,1,1,0,0,0,0,0,0

.pc = $a000 "sprite"

.byte $55,$55,$57
.byte $55,$55,$5F
.byte $55,$FD,$5F
.byte $57,$FF,$5F
.byte $57,$FF,$FF
.byte $57,$FF,$FF
.byte $55,$FF,$FF
.byte $55,$7F,$FD
.byte $55,$7F,$D7
.byte $7F,$FF,$DD
.byte $FF,$FF,$75
.byte $FF,$FF,$75
.byte $7F,$FF,$DD
.byte $55,$7F,$D7
.byte $55,$7F,$FD
.byte $55,$FF,$FF
.byte $57,$FF,$FF
.byte $57,$FF,$FF
.byte $57,$FF,$5F
.byte $55,$FD,$5F
.byte $55,$55,$5F
.byte 0
