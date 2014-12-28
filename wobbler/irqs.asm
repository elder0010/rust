.align $0100

// Scelta plexer
// 1 - Ogni sprite viene multiplexato subito dopo la sua visualizzazione
// 2 - Ogni due sprite visualizzati si multiplexa
// 4 - Ogni quattro ""

.const	plexer=4		// 1,2,4
.const	addval=21		// 21 valore di default (con raster attivi calare di 1)
.const	raster=false		// Visualizzazione raster $d021

// ****************************
// Gestione multiconfigurazione
// ****************************

.var	fst_irq=0
.var	top_irq=0

.eval top_irq	=	top_irq_2
.eval fst_irq	=	1

// *****************************
// IRQ per plexing di due sprite
// *****************************

top_irq_2:
		.if (raster) inc $d021
		sta savea	// Salvataggio fast dei registri (non uso stack perchè non nidifico gli IRQ)
		stx savex
		sty savey
		
		lax global_sprite_cnt	// Carico puntatore globale
		tay						// lo metto in y per un uso successivo
		axs #$05				// passo a 5 posizioni prima
		stx $d019				// IRQ Ack (X è sicuramente dispari)
		lda sortspry,x			// carico la coordinata y dello sprite puntato e
		adc #addval-1			// aggiungo 21 (carry set dall axs) per determinare
		sta $d012				// il prossimo raster IRQ
ti2_mod:  	
		ldx #$00				// Carico l indice di partenza degli sprite hw da plexare
   
		lda sortspry,y		// Multiplexo la coordinata Y di entrambi
		sta $d001,x
		lda sortspry+1,y
		sta $d003,x	
  
		lda sortsprx,y		// Idem per la coordinata X
		sta $d000,x
		lda sortsprx+1,y
		sta $d002,x
		
		//;$d010 handling
		lda sortsprx_hi+1,y
		sta $d010
	
		txa					// x=x/2
		lsr
		tax
  	
		lda sortsprf,y		// Imposto pointer
		sta sprite_pt_01,x
		lda sortsprf+1,y
		sta sprite_pt_01+1,x
	
	//	lda sortsprc,y 		// Imposto colore
	//	sta $d027,x    
		
	//	lda sortsprc+1,y  
	//	sta $d028,x
		
		iny			// Passo ai prox 2 sprite  
		iny

		tya			// Calcolo i prossimi hw sprite
		asl
		and #$0f
		sta ti2_mod+1
	  
		sty global_sprite_cnt
  
		cpy #MAXSPR
		bpl ti2_finished

ti2_endirq:  
		ldy savey
		ldx savex
		lda savea  
		.if (raster) dec $d021
		rti
ti2_finished:
		lda #$00
		sta ti2_mod+1
		jmp irqstop 
  


  
  
// ******
// Common
// ******  
  
irqstop:   
		lda #$fe
		sta $d012
		lda #8
		sta global_sprite_cnt   
		lda #<bottom_irq 
		sta $fffe
		lda #>bottom_irq 
		sta $ffff
!:
		lda $d012
		cmp #$f7
		bne !-
		jsr wobble_borders
		ldy savey
		ldx savex
		lda savea
		.if (raster) dec $d021
		rti
 
