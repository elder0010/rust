//;Sort routine

sort_sprites:
				lda sprupdateflag               //;New sprites to be sorted?
				beq  nonewsprites
				lda #$00
				sta sprupdateflag
                lda numsprites               // ;Take number of sprites given
                                             //   ;by the main program
                sta sortedsprites            //   ;If itïs zero, donït need to
                bne  beginsort           //   ;sort
					
nonewsprites:
                ldx sortedsprites	 //;quanti $d015 devo resettare? tanti quanti sono gli sprites sortati
                cpx #$09				
                bcc  notmorethan8  //;Se ci sono meno di 9 sprites devo resettare $d015 solo di 8
                ldx #$08
notmorethan8:
                lda d015tbl,x                 //  ;Now put the right value to
                sta $d015                    //   ;$d015, based on number of
                beq  nospritesatall        // ;sprites
                                              //  ;Now init the sprite-counter
           //;     lda #$00                     //   ;for the actual sprite display
          //;      sta sprirqcounter            //   ;routine
               
		
				//rts               //  ;Go directly; we might be late
nospritesatall:
				rts
//; VAI COL SORT				
//;RESETTA LA TABELLA DELLE Y - pone a $ff tutti gli sprite NON usati
beginsort: 
                ldx #MAXSPR
                dex
                cpx sortedsprites
                bcc  cleardone //;Certo! se gli sprite sortati sono tanti quanti il totale, salta la procedura
                lda #$ff                    //    ;Mark unused sprites with the
clearloop: 
				sta spry,x                  //    ;lowest Y-coordinate ($ff);
                dex                         //    ;these will "fall" to the
                cpx sortedsprites           //    ;bottom of the sorted table
                bcs  clearloop

//;PROCEDURA DI SORTING - rippata da cadaver che ha rippato da dragon breed quindi si può fare!
cleardone: 
				ldx #$00
sortloop:  
				ldy sortorder+1,x            //   ;Sorting code. Algorithm
                lda spry,y                   //   ;ripped from Dragon Breed :-)
                ldy sortorder,x
                cmp spry,y
                bcs  sortskip
                stx  sortreload+1
sortswap:  
				lda sortorder+1,x
                sta sortorder,x
                sty sortorder+1,x
                cpx #$00
                beq  sortreload
                dex
                ldy sortorder+1,x
                lda spry,y
                ldy sortorder,x
                cmp spry,y
                bcc  sortswap
sortreload:
				ldx #$00
sortskip:  
				inx
                cpx #MAXSPR-1
                bcc sortloop
                ldx sortedsprites
                lda #$ff                    //   ;$ff is the endmark for the
                sta sortspry,x              //   ;sprite interrupt routine


                ldx #$00
				//;stx ZP7						//=> Modifica
sortloop3: 
				ldy sortorder,x             //   ;Final loop:
                lda spry,y                  //   ;Now copy sprite variables to
                
             
                sta sortspry,x              //   ;the sorted table
                lda sprx,y
                sta sortsprx,x
                lda sprf,y
                sta sortsprf,x
           //     lda sprc,y
			//	sta sortsprc,x
				
				//;Gestione $d010 
				//;Salvo il valore di X in una zeropage
				stx $f3
					
				//;Mi trasformo il valore di X in un counter che va da 0 a 7
				txa
				and #$07
				sta $a0
				//;tax  <- no, il counter lo recupero dopo
				
				lda sprx_hi,y
				lsr //;Sposto il valore letto, che può essere 0 o 1 nel carry
				
				lda sortsprx_hi-1,x
				ldx $a0
				and masktbl,x  //;resetto il valore $d015 per l'offset 0-7
				bcc skip //;se il carry è 0 skippo, altrimenti accendo il bit 0-7
				ora oratbl,x
skip:
				ldx $f3
				sta sortsprx_hi,x //;e storo nella tabellona generale
				
                inx
                cpx sortedsprites
                bcc  sortloop3
				
				jmp  nonewsprites //;Yeah devo resettare pure $d015
								
			
point_sprites:
				ldx #2
				clc
				lda #$50
				sta sprf
				sta sprf+1
!:
				sta sprite_pt_01,x
				sta sprf,x
				inx
				cpx #MAXSPR-2
				bne !-
				
				lda #$5a
				sta sprf,x
				inx
				sta sprf,x
				
				dex
				lda #DARK_GRAY
				sta sprc,x
				inx
				sta sprc,x
				
				lda #$ff
				sta $d01c

				rts

.pc = * "SPRCNT"
sprcounter:				
.byte $50

table_switcher:
.byte $1

//;Scrive l'array di coordinate x/y per tutti gli sprites
update_sprite_coords:
				//dec sprcounter
				sec
				lda sprcounter
speedanim:
				sbc #1
				sta sprcounter
				bcs !+
				inc counter_giri
!:
				ldx sprcounter
				clc
				ldy #MAXSPR-2 //;Gli ultimi 2 li devo usare per il bordo superiore
				jmp startloop
loopxy:			
				//lda sprite_xy_pointers,x
				//inc sprite_xy_pointers,x				
				clc
BASE_X:			
				lda sprite_x_table,x
				adc x_offset
				sta sprx,y
				bcc !+
				lda #1
				jmp store_x_hi
!:
				lda sprite_x_table_hi,x
store_x_hi:
				sta sprx_hi,y
		
BASE_Y:		
				lda sprite_y_table,x
				sta spry,y
				
				txa
				axs #STEP

startloop:				
				dey
				bpl loopxy
				rts
				
				
//;Giro di animazione
				//;lda #$50
.var sprite_pointer_base = $50
				ldx #0
				clc
frame:				
				lda sprf,x
				adc #1
				cmp #sprite_pointer_base+19
				bne !+
				lda #sprite_pointer_base
!:
				sta sprf,x
				inx
				cpx #MAXSPR-2
				bne frame
			
		//;		inc sprf+2
//;
				lda sprcounter
				and #1
				
				beq !+
				inc sprcounter
!:
				lda #1
stspd:
				sta speedanim+1
				rts
				
//;
place_cover_sprites:
				//;Posiziono gli ultimi 2
				ldy #MAXSPR-2
				clc
FILLER_SPRITE_Y:
				lda #$ff
				adc #30
				sta spry,y
			
				iny

				sta spry,y
				
				lda #DARK_GRAY
				sta sprc+MAXSPR-2
				sta sprc+MAXSPR-1
		
				rts

				
//;INIT MULTIPLEXER
initsprites:   
			
				lda #$00
                sta sortedsprites
				
                sta sprupdateflag
                ldx #MAXSPR                //   ;Init the order table with a
is_orderlist:   txa                           //  ;0,1,2,3,4,5... order
                sta sortorder,x
                dex
                bpl is_orderlist
		
		
				//;Penultimo sprite in alto a sx
				ldy #MAXSPR-2
				lda #24
				sta sprx,y
				
			//;	lda #40
			//;	sta spry,y
				
				lda #0
				sta sprx_hi,y
				
			//	lda #COL3
			//	sta sprc,y
				
				//;Ultimo sprite in alto a dx
				iny
				
		//;		lda #40
		//;		sta spry,y
				
				lda #60
				sta sprx,y
				
				lda #1
				sta sprx_hi,y
				
				.if(debug_top_sprites){
					lda #BLACK
				}else{ 
					lda #LIGHT_BLUE
				}
				
				//;sta sprc,y
			
				//;SPRITE PRIORITY BUG DA SISTEMARE
				//;lda #0
				lda #$ff
				sta $d01b
						
                rts

.align	$0040
sprx:           .fill MAXSPR,0             //;Unsorted sprite table
.align	$0040
spry:           .fill MAXSPR,0
.align	$0040

.pc = * "colours"
sprc:           .fill MAXSPR, LIGHT_RED
.align	$0040

sprx_hi:        .fill MAXSPR,0         
.align	$0040
.pc = * "sprite frames"
sprf:           .fill MAXSPR,0
.align	$0040

sortsprx:       .fill MAXSPR,0                 //;Sorted sprite table
.align	$0040
sortspry:       .fill MAXSPR,0                //;Must be one byte extra for the
.align	$0040									//;$ff endmark


sortsprc:       .fill MAXSPR,0
.align	$0040
sortsprf:       .fill MAXSPR,0

.align $0040
.byte $0
sortsprx_hi:       
				.fill MAXSPR,0

d015tbl:        .byte %00000000                  //////;Table of sprites that are "on"
                .byte %00000001                  //////;for $d015
                .byte %00000011
                .byte %00000111
                .byte %00001111
                .byte %00011111
                .byte %00111111
                .byte %01111111
                .byte %11111111

physicalsprtbl1:.byte 0,1,2,3,4,5,6,7            //////;Indexes to frame & color
                .byte 0,1,2,3,4,5,6,7            //////;registers
                .byte 0,1,2,3,4,5,6,7
                .byte 0,1,2,3,4,5,6,7
                .byte 0,1,2,3,4,5,6,7
                .byte 0,1,2,3,4,5,6,7
                .byte 0,1,2,3,4,5,6,7
                .byte 0,1,2,3,4,5,6,7

physicalsprtbl2:.byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14
                .byte 0,2,4,6,8,10,12,14

andtbl:         .byte 255-1
ortbl:          .byte 1
                .byte 255-2
                .byte 2
                .byte 255-4
                .byte 4
                .byte 255-8
                .byte 8
                .byte 255-16
                .byte 16
                .byte 255-32
                .byte 32
                .byte 255-64
                .byte 64
                .byte 255-128
                .byte 128
				

oratbl:
.byte %00000001	
.byte %00000010
.byte %00000100
.byte %00001000
.byte %00010000
.byte %00100000
.byte %01000000
.byte %10000000

masktbl:
.byte %11111110
.byte %11111101
.byte %11111011
.byte %11110111
.byte %11101111
.byte %11011111
.byte %10111111
.byte %01111111
	
	
	
sprite_xy_pointers:
.var shift=0

.for (var l=0; l<=MAXSPR; l++){	
	.byte $0+shift
	.eval shift = shift+8
}

.align $100
.pc = * "Movements table"
.import source "movements/rod2.asm"

exit_sinus:
.import source "sintables/exit.asm"	
