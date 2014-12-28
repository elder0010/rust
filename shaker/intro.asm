irq_waster:
		:open_irq()
		asl $d019
		lda #$ff
		sta $d015
		
	//	inc $d020
		jsr $1003
	//	dec $d020
		jsr fade_out_sprites //;OCCHIO QUI Cé UN CMP $d012

intro_end:
		lda #1
		bne !+
		:set_irq(music_irq)
		//;:d011($3b)
		inc wait_for_colours+1		
!:	
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
		
		lda #$fb
		sta $d012
		
		lda #external_border_color
		sta $d021

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
        ora #$38
        sta $d011

        dex 
        bne fld_loop 
		
		ldy #30
		:wait()
		nop
		nop
		nop
		nop
		lda #0
		sta $d021
	
//;Loop che spinge giu il resto della grafica
skip:			
		:close_irq()
		rti

music_irq:
		:open_irq()

		asl $d019

		ldy #20
		:wait()

		lda #external_border_color
		sta $d020		
		
next_irq_hi:
		lda #>top_irq
		sta $ffff
next_irq_lo:
		lda #<top_irq
		sta $fffe
	
		lda # [[screenChars ^ $ffff] >> 14]
		sta $dd00

		lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018

next_irq_d012:		
		lda #$27
		sta $d012
		
		lda #$3b
		sta $d011
		
		lda #0
		sta $d021

		jsr calcola_fld

		//inc $d020
		jsr $1003
		//dec $d020
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
	
		sec
		sbc #8
		sta sine_pt
		
		
		lda #$fc
		sta next_irq_d012+1
		//;sta $d012
		
		lda #<bitmap_down_irq
		sta next_irq_lo+1
		lda #>bitmap_down_irq
		sta next_irq_hi+1
		
!:
		rts


//;----------------------------------------------------
//;Finita la transizione, vado stabile
//;----------------------------------------------------
bitmap_irq:
		:open_irq()
		
		lda #0
		sta $d021

		jsr move_filler_sprites
		
		asl $d019
		
		lda #$fc
		sta $d012

		lda #$3b
		sta $d011

nxt_irq_lo:		
		lda #<bitmap_down_irq
		sta $fffe
nxt_irq_hi:	
		lda #>bitmap_down_irq
		sta $ffff
		
		:close_irq()
		rti
		

bitmap_down_irq:
		:open_irq()
		asl $d019

	//	inc $d020
		jsr $1003
	//	dec $d020

	//;	jsr move_filler_sprites_bottom
	
		lda #0
		sta $d021

		lda #$3b
		sta $d011

		lda #$14
		sta $d012

can_go_scene:
		lda #0
		beq !+
	
	//;	lda #$fc
	//;	sta $d012

		lda #<illegal_bottom_irq  //;via alla machinery illegal mode ma dal prox frame!
		sta nxt_irq_lo+1
		lda #>illegal_bottom_irq
		sta nxt_irq_hi+1

		//;jmp sk
!:
		lda #<bitmap_irq
		sta $fffe
		lda #>bitmap_irq
		sta $ffff
sk:
		:close_irq()
		rti
		
.import source "functions.asm"

.align $100
.pc = * "sine"
.import source "data/starting_sine.asm"
