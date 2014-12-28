// **** 
// SORT
// ****

// ****************
// Pre-sort routine
// ****************
sort_sprites:
				jsr beginsort
nonewsprites:
                ldx numsprites		//;quanti $d015 devo resettare? tanti quanti sono gli sprites sortati
                cpx #$09				
                bcc  notmorethan8  //;Se ci sono meno di 9 sprites devo resettare $d015 solo di 8
                ldx #$08
notmorethan8:
                lda d015tbl,x                //  ;Now put the right value to
                sta $d015                    //   ;$d015, based on number of
                beq  nospritesatall       	 // ;sprites                                             
nospritesatall:
				rts
				
// ***********************
// Bubble sort ottimizzato
// ***********************
 beginsort: 
				ldx #MAXSPR-2		// Parto dalla fine e vado a scalare
				jmp startsort		// L'inizio del loop è al centro
 sortsavex:
                stx  sortreload+1	// Salvo il valore di X
				lda sortorder+1,x	// Swap 1 (Y = SortOrder,x)
                sta sortorder,x		// SortOrder+1,x => SortOrder,x
                sty sortorder+1,x	// SortOrder,x => SortOrder+1,x
                inx                
                lda spry,y			// "Bubble" check (Y = SortOrder,x)
                ldy sortorder+1,x
                cmp spry,y				
                bcc sortreload		// La "bolla" si ferma?
 sortswaploop:  
				lda sortorder,x		// Swap 2 (Y = SortOrder+1,x)
                sta sortorder+1,x	// SortOrder,x => SortOrder+1,x
                sty sortorder,x		// SortOrder+1,x => SortOrder,x
                inx
                tay					// In A avevo SortOrder+1, lo recupero
                lda spry,y			// "Bubble" check (Y = SortOrder,x)
				ldy sortorder+1,x				
                cmp spry,y												
                bcs sortswaploop	// Se la "bolla" non si è ancora fermata ciclo
 sortreload:
				ldx #$00			// Ripristino X
				dex					// Controllo se sono alla fine
				bmi sortquit
 startsort:
				ldy sortorder+1,x	// Ripristino Y corretto
 sortloop:                  
				lda spry,y    		// Confronto a scendere (mi porto dietro il vecchio Y)
				ldy sortorder,x
				cmp spry,y
				bcc sortsavex
				dex                
                bpl  sortloop
								
 sortquit:				
				rts
				
// ******************************************
// Build sprite table based on sorted y-coord
// ******************************************							
build_sprites:				
                ldx #$00
				clc
 sortloop3:
				ldy sortorder,x             //   Carico l'indice dell'x esimo sprite

                lda spry,y                  //   Copio la coordinata y
                sta sortspry,x
				adc #addval					//	 Imposto la tabella IRQ precalcolata (carry sempre a 0)
				sta rsttbl+[[3-fst_irq]*2+1],x
                lda sprx,y                  //   Copio la coordinata x
                sta sortsprx,x
                lda sprf,y                  //   Copio il ptr alla definizione
                sta sortsprf,x
                lda sprc,y                  //   Copio il colore
				sta sortsprc,x
			
				lda sprx_hi,y				//  Gestione D010				
				bne spriteon
spriteoff:
				lda sortsprx_hi-1,x			// 	Leggo il vecchio valore di D010
				and masktbl,x				//	Maschero l'attuale sprite
				sta sortsprx_hi,x 			//;e storo nella tabellona generale
	
                inx
				cpx #MAXSPR
                bcc  sortloop3				
				rts				 			//;Yeah devo resettare pure $d015
spriteon:				
				lda sortsprx_hi-1,x			// 	Leggo il vecchio valore di D010		
				ora oratbl,x				//  Accendo lo sprite	
				sta sortsprx_hi,x 			//;e storo nella tabellona generale
	
                inx
				cpx #MAXSPR
                bcc  sortloop3				
				rts				 			//;Yeah devo resettare pure $d015				
					
					
// *****************
// Init sprites data			
// *****************
// Imposta forma (Y) e colore (X) di tutto gli sprite			
init_sprites_data:
				stx isd_col+1
				ldx #MAXSPR-1				
				lda #floor([sprites&$3fff]/$40)	
				sta sprf+MAXSPR
!:				
				tya
				sta sprf,x
isd_col:
				lda #$00
				sta sprc,x
				txa				
                sta sortorder,x				//  ;0,1,2,3,4,5... order				
				/*
				clc
				lda sprf+1,x
				adc #$01
				cmp #floor([sprites&$3fff]/$40)+$0a
				bne isd_skp
				lda #floor([sprites&$3fff]/$40)				
isd_skp:
				sta sprf,x				
				*/
				dex				
			
				bpl !-

				rts				
				
sprcounter:				
.byte $00
//;Scrive l'array di coordinate x/y per tutti gli sprites
update_sprite_coords:
				dec sprcounter
				ldx sprcounter
				clc
				ldy #MAXSPR
				jmp startloop
loopxy:			
				lda sprite_x_table,x
				sta sprx,y				
				lda sprite_x_table_hi,x
				sta sprx_hi,y				
				lda sprite_y_table,x
				sta spry,y				
				txa
				axs #STEP

startloop:				
				dey
				bpl loopxy				
				rts
		

// ************************
// Inizializzazione sprites
// ************************
init_sprites:
				lda #$ff
				sta $d015				
				
				lda #$00
				sta $d01b
				lda #PURPLE
				sta $d025
				lda #BLACK
				sta $d026				
                rts
				
// **************
// Masking tables
// **************
d015tbl:        .byte %00000000                  //////;Table of sprites that are "on"
                .byte %00000001                  //////;for $d015
                .byte %00000011
                .byte %00000111
                .byte %00001111
                .byte %00011111
                .byte %00111111
                .byte %01111111
                .byte %11111111

oratbl:
.for(var i=0;i<floor(MAXSPR/8)+1;i++)
{
.byte %00000001	
.byte %00000010
.byte %00000100
.byte %00001000
.byte %00010000
.byte %00100000
.byte %01000000
.byte %10000000
}

masktbl:
.for(var i=0;i<floor(MAXSPR/8)+1;i++)
{
.byte %11111110
.byte %11111101
.byte %11111011
.byte %11110111
.byte %11101111
.byte %11011111
.byte %10111111
.byte %01111111
}					
	
// ************
// Coordinate Y
// ************
// Range limitato (20/240) e linearità (!!) altrimenti il plexer salta (si perdono sprite)
.align $100
sprite_y_table:
.fill $100,20+abs(floor([[[128-i]*[220]]/128]))

// ************
// Coordinate X
// ************
// Massima libertà sulle posizioni e sulla variazione
.align $100
sprite_x_table:
.fill $100,[40+floor([320-32-24]/2)+floor([320-32-24]/2)*sin([3*[i+$80]*3.1415]/$80)]&$ff

.align $100
sprite_x_table_hi:
.fill $100,floor([40+floor([320-32-24]/2)+floor([320-32-24]/2)*sin([3*[i+$80]*3.1415]/$80)]/256)

// ************
// Sprites data
// ************

.align	$0040
sprx:           .fill MAXSPR,0             //;Unsorted sprite table
.align	$0040
sprc:           .fill MAXSPR,0
.align	$0040
sprx_hi:        .fill MAXSPR,0         
.align	$0040
sprf:           .fill MAXSPR,0
.align	$0040
sortsprx:       .fill MAXSPR,0                 //;Sorted sprite table
.align	$0040
sortspry:       .fill MAXSPR,0                //;Must be one byte extra for the
.align	$0040									//;$ff endmark
sortsprc:       .fill MAXSPR,0
.align	$0040
sortsprf:       .fill MAXSPR,0
.align  $0080
rsttbl:			.fill 5+MAXSPR,0
.align	$0080
.byte $0
sortsprx_hi:    .fill MAXSPR,0
.align	$0080
spry:           .fill MAXSPR,0

	
