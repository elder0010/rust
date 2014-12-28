pre_fade_tizia_irq:
		:open_irq()
		asl $d019
		
		lda relocated_ok
		beq !+
	
tiziairq:
		lda #<fade_tizia_irq 
		sta $fffe
		lda #>fade_tizia_irq 
		sta $ffff	
!:		
		jsr music.play
		
		:close_irq()
		rti

relocated_ok:
		.byte $0
		
fade_tizia_irq:
		:open_irq()
		
		jsr music.play
		
		jsr wobble_borders
		//;Qui siamo ancora con soli due sprites, per cui è necessario seguire il movimento
		jsr follow_cover_sprites 		
switch:		
		lda #0
		beq !+
		

		inc ctn+1
ctn:
		lda #0
		cmp #13
		bne !+
		lda #<pre_plexer_irq 
		sta $fffe
		lda #>pre_plexer_irq 
		sta $ffff
		lda #$ff
		sta $d012
!:
		lda switch+1
		eor #$ff
		sta switch+1
		
		asl $d019
				
		:close_irq()
		rti



pre_plexer_irq:
		:open_irq()
	
		jsr wobble_borders
		jsr follow_cover_sprites

		inc ctn2+1
		
ctn2:
		lda #0
		cmp #$2
		bne !+
		
		lda #$fa
		sta $d012
		
		lda #<bottom_irq 
		sta $fffe
		lda #>bottom_irq 
		sta $ffff
		
		
		cli //;Roba oscura per evitare glitch chiedere motivi voodoo a freshness
!:
		
		jsr music.play
		
		asl $d019
		
		:close_irq()
		rti
		
wobble_borders:
		//;Wobblo il wobblabile
		ldx left_wobble_pt
		lda border_wave,x
		tax

		sta FILLER_SPRITE_Y+1 //;Mi segno l'altezza da una parte
	
		ldy right_wobble_pt
		lda border_wave,y
		tay
		
		jsr draw_chars
		jsr place_cover_sprites
		inc left_wobble_pt
		inc right_wobble_pt
		
		rts

follow_cover_sprites:
		lda FILLER_SPRITE_Y+1 //;Vedi funzione wobble_borders
		adc #30
		sta $d001
		sta $d003
		rts
		
