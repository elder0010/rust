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
                lda #$00                     //   ;for the actual sprite display
                sta sprirqcounter            //   ;routine
               
		
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
 clearloop: sta spry,x                  //    ;lowest Y-coordinate ($ff);
                dex                         //    ;these will "fall" to the
                cpx sortedsprites           //    ;bottom of the sorted table
                bcs  clearloop

//;PROCEDURA DI SORTING - rippata da cadaver che ha rippato da dragon breed quindi si può fare!
 cleardone: ldx #$00
 sortloop:  ldy sortorder+1,x            //   ;Sorting code. Algorithm
                lda spry,y                   //   ;ripped from Dragon Breed :-)
                ldy sortorder,x
                cmp spry,y
                bcs  sortskip
                stx  sortreload+1
 sortswap:  lda sortorder+1,x
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
 sortreload:ldx #$00
 sortskip:  inx
                cpx #MAXSPR-1
                bcc  sortloop
                ldx sortedsprites
                lda #$ff                    //   ;$ff is the endmark for the
                sta sortspry,x              //   ;sprite interrupt routine
                ldx #$00
 sortloop3: ldy sortorder,x             //   ;Final loop:
                lda spry,y                  //   ;Now copy sprite variables to
                sta sortspry,x              //   ;the sorted table
                lda sprx,y
                sta sortsprx,x
                lda sprf,y
                sta sortsprf,x
                lda sprc,y
                sta sortsprc,x
                inx
                cpx sortedsprites
                bcc  sortloop3
				
				jmp  nonewsprites //;Yeah devo resettare pure $d015
								
			
point_sprites:
				ldx #0
				lda #$50
!:
				sta sprite_pt_01,x
				sta sprf,x
			//;	sta sprc,x
			//	adc #1
				inx
				cpx #MAXSPR
			
				bne !-
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
				//lda sprite_xy_pointers,x
				//inc sprite_xy_pointers,x				
			
				lda sprite_x_table,x
				sta sprx,y

				lda sprite_y_table,x
				sta spry,y
				
				txa
				axs #STEP

startloop:				
				dey
				bpl loopxy
				
				rts
				
//;INIT MULTIPLEXER
initsprites:    lda #$00
                sta sortedsprites
				sta $d01c
                sta sprupdateflag
                ldx #MAXSPR-1                //   ;Init the order table with a
is_orderlist:   txa                           //  ;0,1,2,3,4,5... order
                sta sortorder,x
                dex
                bpl is_orderlist
                rts

.align	$0040
sprx:           .fill MAXSPR,0             //;Unsorted sprite table
.align	$0040
spry:           .fill MAXSPR,0
.align	$0040
sprc:           .byte 0,1,2,3,4,5,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
.align	$0040
sprf:           .fill MAXSPR,0
.align	$0040
sortsprx:       .fill MAXSPR,0                 //;Sorted sprite table
.align	$0040
sortspry:       .fill MAXSPR+1,0               //;Must be one byte extra for the
.align	$0040								   //;$ff endmark
sortsprc:       .fill MAXSPR,0
.align	$0040
sortsprf:       .fill MAXSPR,0


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
				
				
sprite_xy_pointers:
.var shift=0

.for (var l=0; l<=MAXSPR; l++){	
	.byte $0+shift
	.eval shift = shift+8
}

.align $100
sprite_y_table:
.fill $100,50+abs(floor([[[128-i]*[200-21]]/128]))
//.fill $100,50+floor([200-21]/2)+floor([200-21]/2)*sin(i*3.1415/$80)
/*
.align $100

.byte 140,138,136,134,132,130,128,126,124,122,120,118,116,114,112,111
.byte 109,107,105,103,102,100,98,97,95,93,92,90,89,87,86,84
.byte 83,81,80,79,77,76,75,74,73,72,71,70,69,68,67,66
.byte 65,65,64,63,63,62,62,61,61,61,60,60,60,60,60,60
.byte 60,60,60,60,60,60,60,61,61,62,62,63,63,64,64,65
.byte 66,67,67,68,69,70,71,72,73,74,76,77,78,79,81,82
.byte 83,85,86,88,89,91,92,94,96,97,99,101,103,104,106,108
.byte 110,112,113,115,117,119,121,123,125,127,129,131,133,135,137,139
.byte 140,142,144,146,148,150,152,154,156,158,160,162,164,166,167,169
.byte 171,173,175,176,178,180,182,183,185,187,188,190,191,193,194,196
.byte 197,198,200,201,202,203,205,206,207,208,209,210,211,212,212,213
.byte 214,215,215,216,216,217,217,218,218,219,219,219,219,219,219,219
.byte 219,219,219,219,219,219,218,218,218,217,217,216,216,215,214,214
.byte 213,212,211,210,209,208,207,206,205,204,203,202,200,199,198,196
.byte 195,193,192,190,189,187,186,184,182,181,179,177,176,174,172,170
.byte 168,167,165,163,161,159,157,155,153,151,149,147,145,143,141,140
*/


.align $100
sprite_x_table:
.fill $100,32+floor([255-32-24]/2)+floor([255-32-24]/2)*sin([3*[i+$80]*3.1415]/$80)
/*
sprite_x_table:
.byte 125,117,111,104,97,90,84,78,72,66,60,55,51,47,43,39
.byte 37,34,32,31,30,30,30,30,31,33,35,38,41,45,49,53
.byte 58,63,69,74,81,87,93,100,107,114,121,128,135,142,149,156
.byte 162,168,175,180,186,191,196,200,204,208,211,214,216,218,219,219
.byte 219,219,218,217,215,212,210,206,202,198,194,189,183,177,171,165
.byte 159,152,145,138,132,125,117,111,104,97,90,84,78,72,66,60
.byte 55,51,47,43,39,37,34,32,31,30,30,30,30,31,33,35
.byte 38,41,45,49,53,58,63,69,74,81,87,93,100,107,114,121
.byte 128,135,142,149,156,162,168,175,180,186,191,196,200,204,208,211
.byte 214,216,218,219,219,219,219,218,217,215,212,210,206,202,198,194
.byte 189,183,177,171,165,159,152,145,138,132,125,117,111,104,97,90
.byte 84,78,72,66,60,55,51,47,43,39,37,34,32,31,30,30
.byte 30,30,31,33,35,38,41,45,49,53,58,63,69,74,81,87
.byte 93,100,107,114,121,128,135,142,149,156,162,168,175,180,186,191
.byte 196,200,204,208,211,214,216,218,219,219,219,219,218,217,215,212
.byte 210,206,202,198,194,189,183,177,171,165,159,152,145,138,132,125
*/



random_junk:
.byte 2,4,1,3,7,8,1,3,4,5,6,0,2,54,23,2,1,23,5,5,6,7,7,5,1,10,40,34,20

