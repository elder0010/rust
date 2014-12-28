intro_reloc_irq:
		:open_irq()
		asl $d019
		lda #$35
		sta $01
		
		lda #1
		sta reloc_loop+1

		jsr $1003
		
		lda #$31
		sta $01
		:close_irq()
		rti

reloc_loop:
		lda #0
		beq reloc_loop

		//;Ora posso disegnare gli screen anche spizzando sotto l'IO 
		jsr draw_screens
		rts