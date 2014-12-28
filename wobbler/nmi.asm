//;NMI init
.align $40
init_nmi:
		lda #$7f
		sta $dc0d
		sta $dd0d //; Clear IRQ interruptmask for CIA

		lda $dd0d
		lda $dc0d

//;punto irq CIA
		lda #<nmi
		sta $fffa //; Set low IRQ adress in selected bank
		lda #>nmi
		sta $fffb //; Set high IRQ adress in selected bank
		

		lda $dd0e
		ora #%10011000
		and #%11110110
	//;	sta $dd0e //; count o2 pulses and forceload and continious and stop
	
		//; timer A
		tay //; Save for later use in y

		lda #$c7 
		sta $dd04

		lda #$4c
		sta $dd05
	
		lda #$81
		sta $dd0d //; Activate CIA timer A irq
	
		tya
		ora #%00000001 //; Start CIA Timer A
		tax
		
		
.var nmi_bmp_line = $ba //;Linea dove switchare char mode bmp mode		
		//; aspetto per far partire il cia
waitrst:
		lda $d012
		cmp #nmi_bmp_line
		bne waitrst
		stx $dd0e 
		rts

.align $40	
nmi:
		sty $ff
	
bitmap_mode:
		ldy #$3b
trigger_d011:
		sty $d011

priority_set:		
		ldy #$00
		sty $d01b
		
		ldy $dd0d
		ldy $ff
		rti

nothing:
		sta $ff
		lda $dd0d
		lda $ff
		rti