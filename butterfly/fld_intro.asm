top_irq:
		:open_irq()
		asl $d019

		lda #<music_irq
		sta $fffe
		lda #>music_irq
		sta $ffff

		lda #$f8
		sta $d012

		lda #PURPLE
		sta $d021

		ldx linee_fld
		beq skipfld

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
		lda #0
		sta $d021

//Loop che spinge giu il resto della grafica
skipfld:
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

		lda #$27
		sta $d012

		lda #$33
		sta $d011

		asl $d019

		lda #0
		sta $d021
		sta $7fff

		jsr $1003
		jsr frame_count
		jsr calcola_fld

		:close_irq()
		rti


calcola_fld:
		ldx sine_pt_intro
		lda sine,x
		sta linee_fld

		//Calcolo il nuovo offset di start
		sec
		lda sine_pt_intro
		sbc #4
		sta sine_pt_intro
		inc ctt+1
ctt:
		lda #0
		cmp #30
		bne !+

		clc
		sbc #8
		sta sine_pt

		lda #$fa
		sta $d012

		lda #$0b
		sta $d011

		//Finita transizione
		lda #<waster_irq
		sta $fffe
		lda #>waster_irq
		sta $ffff

		lda $ff
		sta $7fff
!:
		rts

frame_count:
		clc
		lda frame_count_lo
		adc #1
		sta frame_count_lo
		bcc !+
		inc frame_count_hi
!:

		rts
