reloc_all:
		//;intro sines
		ldx #0
!:
		lda intro_sines,x
		sta sine_1,x
		lda intro_sines+$100,x
		sta sine_2,x
		dex
		bne !-
		
	
		//;Tabella colori
		ldx #0
!:
		lda tabella_colori_start,x
		sta tabella_colori_dest,x
		lda tabella_colori_start+$100,x
		sta tabella_colori_dest+$100,x
		lda tabella_colori_start+$200,x
		sta tabella_colori_dest+$200,x
		lda tabella_colori_start+$300,x
		sta tabella_colori_dest+$300,x
		lda tabella_colori_start+$400,x
		sta tabella_colori_dest+$400,x
		lda tabella_colori_start+$500,x
		sta tabella_colori_dest+$500,x
		lda tabella_colori_start+$600,x
		sta tabella_colori_dest+$600,x
		dex
		bne !-
		
		ldx #0
!:
		lda tabelle_dei_colori,x
		sta tab_colori_0,x
		dex
		bne !-
		rts