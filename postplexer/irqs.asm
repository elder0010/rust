.align $0100
.pc=*	"IRQs" 

// Tipo di plexer
// 2 - Ogni due sprite visualizzati si multiplexa

.const	addval=20		// 21 valore di default (con raster attivi calare di 1)
.const	raster=false	// Visualizzazione raster $d021

// ****************************
// Struttura delle chiamate IRQ
// ****************************
// A = Sprite 0,1
// B = Sprite 2,3
// C = Sprite 4,5
// D = Sprite 6,7

// Offset 0000: top_irq_2_1, gestione A => top_irq_2_2 (Cambio Lo byte)
// Offset 0080: top_irq_2_2, gestione B => top_irq_2_3 (Cambio Hi byte)
// Offset 0100: top_irq_2_4, gestione D => top_irq_2_1 (Cambio Lo byte)
// Offset 0180: top_irq_2_3, gestione C => top_irq_2_4 (Cambio Hi byte)

// Facendo così mi basta cambiare un byte dell'IRQ pointer per saltare alla routine successiva

// *****************
// Gestione costanti
// *****************

.var	fst_irq	=	1
.var	top_irq	=	top_irq_2_1

// *********************************
// IRQ per plexing di due sprite (A)
// *********************************
top_irq_2_1:
		.if (raster) inc $d021
		sta savea	// Salvataggio fast dei registri (non uso stack perchè non nidifico gli IRQ)		
		sty savey
		
		lsr $d019				// IRQ Ack
		
		ldy global_sprite_cnt	// Carico puntatore globale							
		
		lda rsttbl,y			// Imposto il prossimo IRQ
		sta $d012 
		
		lda sortspry,y		// Multiplexo la coordinata Y di entrambi
		sta $d001
		lda sortspry+1,y
		sta $d003
  
		lda sortsprx,y		// Idem per la coordinata X
		sta $d000
		lda sortsprx+1,y
		sta $d002
				
		lda sortsprx_hi+1,y	// Imposto il nuovo stato del bit alto della coordinata X
		sta $d010
  
			/*
		lda sortsprf,y		// Imposto gli sprite pointer
		sta sprite_pt_01
		lda sortsprf+1,y
		sta sprite_pt_01+1
		
		lda sortsprc,y 		// Imposto i colori
		sta $d027
		lda sortsprc+1,y  
		sta $d028
			*/
			
		iny					// Passo ai prox 2 sprite  
		iny						
		sty global_sprite_cnt		
			  
		cpy #MAXSPR			// Abbiamo finito?
		bpl ti2_finished_1
 
		lda #<top_irq_2_2	// No, passiamo alla prossima coppia
		sta $fffe
		
		ldy savey		
		lda savea  
		.if (raster) dec $d021
		rti
ti2_finished_1:
		jmp irqstop 
  
  
.align $0080
// *********************************
// IRQ per plexing di due sprite (B)
// *********************************
top_irq_2_2:
		.if (raster) inc $d021
		sta savea
		sty savey
		
		lsr $d019
		
		ldy global_sprite_cnt
		
		lda rsttbl,y
		sta $d012 
		
		lda sortspry,y
		sta $d001+4
		lda sortspry+1,y
		sta $d003+4
  
		lda sortsprx,y
		sta $d000+4
		lda sortsprx+1,y
		sta $d002+4
				
		lda sortsprx_hi+1,y
		sta $d010
  
		lda sortsprf,y
		sta sprite_pt_01+2
		lda sortsprf+1,y
		sta sprite_pt_01+1+2
		lda sortsprc,y
		sta $d027+2
		lda sortsprc+1,y  
		sta $d028+2
			
		iny
		iny
						
		sty global_sprite_cnt		
			  
		cpy #MAXSPR
		bpl ti2_finished_2
 
		lda #>top_irq_2_3
		sta $ffff
		
		ldy savey		
		lda savea  
		.if (raster) dec $d021
		rti
ti2_finished_2:
		jmp irqstop 
  
  
.align $0080
// *********************************
// IRQ per plexing di due sprite (D)
// *********************************
top_irq_2_4:
		.if (raster) inc $d021
		sta savea
		sty savey
		
		lsr $d019
		
		ldy global_sprite_cnt
		
		lda rsttbl,y
		sta $d012 
		
		lda sortspry,y
		sta $d001+12
		lda sortspry+1,y
		sta $d003+12
  
		lda sortsprx,y
		sta $d000+12
		lda sortsprx+1,y
		sta $d002+12
				
		lda sortsprx_hi+1,y
		sta $d010
  
		lda sortsprf,y
		sta sprite_pt_01+6
		lda sortsprf+1,y
		sta sprite_pt_01+1+6
		lda sortsprc,y
		sta $d027+6
		lda sortsprc+1,y  
		sta $d028+6
			
		iny
		iny
						
		sty global_sprite_cnt		
			  
		cpy #MAXSPR
		bpl ti2_finished_4
 
		lda #>top_irq_2_1
		sta $ffff
		
		ldy savey		
		lda savea  
		.if (raster) dec $d021
		rti
ti2_finished_4:
		jmp irqstop 


.align $0080
// *********************************
// IRQ per plexing di due sprite (C)
// *********************************
top_irq_2_3:
		.if (raster) inc $d021
		sta savea
		sty savey
		
		lsr $d019
		
		ldy global_sprite_cnt
		
		lda rsttbl,y
		sta $d012 
		
		lda sortspry,y
		sta $d001+8
		lda sortspry+1,y
		sta $d003+8
  
		lda sortsprx,y
		sta $d000+8
		lda sortsprx+1,y
		sta $d002+8
				
		lda sortsprx_hi+1,y
		sta $d010
  
		lda sortsprf,y
		sta sprite_pt_01+4
		lda sortsprf+1,y
		sta sprite_pt_01+1+4
		lda sortsprc,y
		sta $d027+4
		lda sortsprc+1,y  
		sta $d028+4
			
		iny
		iny
						
		sty global_sprite_cnt		
			  
		cpy #MAXSPR
		bpl ti2_finished_3
 
		lda #<top_irq_2_4
		sta $fffe
		
		ldy savey		
		lda savea  
		.if (raster) dec $d021
		rti
ti2_finished_3:
		jmp irqstop 
		
// ******
// Common
// ******  
// IRQ di fine plexing ed apertura bordo
  
irqstop: 
  lda #$fa
  sta $d012
plx_irq_target_lo:
  lda #<bottom_irq 
  sta $fffe
plx_irq_target_hi:
  lda #>bottom_irq 
  
  sta $ffff
  ldy savey  
  lda savea
  .if (raster) dec $d021
  rti
 
