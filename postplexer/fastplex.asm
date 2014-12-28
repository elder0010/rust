//;------------
//;-- PLEXER -- 
//;------------

.var TEST_MODE = 0
.var MUSIC_SYNC = 1
.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"

.if (TEST_MODE == 1){		
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(code)
}
.const savea	=	$70
.const savex	=	$71
.const savey	=	$72

// ****************
// Comparto grafico
// ****************		

.pc = $2800 "Charset"
charset:
// Importa il tuo charset qua!
.var charsetPic = LoadPicture("data/charset.gif", List().add($000000, $ffffff))
.function picToCharset(byteNo, picture) {
	.var ypos = [byteNo&7] + 8*[[byteNo>>9]&1] 
	.var xpos = 2*[[byteNo>>3]&$3f] + [[byteNo>>10]&1]
	.return picture.getSinglecolorByte(xpos,ypos)		
}
.fill $800, picToCharset(i,charsetPic)


.align $0040		
.pc = * "sprite definition"
sprites:
.import binary "sprites.raw"
// Importa il tuo sprite qua!
	

.pc = * "Code"		
code:

.if (TEST_MODE == 1){
		sei
		
		lda #0					// Inizializzazioni varie (musica, IRQ, NMI)
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()	
		
		lda #WHITE				// Setto lo sfondo
		sta $d021
		
		lda #DARK_GRAY
		sta $d020
}
		
		ldx #0
	.if(TEST_MODE==1){
		stx $d011
	}
		stx $d015
		stx $3fff

		.if(TEST_MODE==1){
			lda #$ff
			sta $d01c
		}
	
		:bank_0()
		
		lda #$c8
		sta $d016
		
		//;ldx #0 already 0
!:	
		lda #$40
		sta SCREEN_1,x
		sta SCREEN_1+$100,x
		sta SCREEN_1+$200,x
		sta SCREEN_1+$300,x
		
		lda #1
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		
		dex
		bne !-

		jsr print_text

!:
		lda $d012
		cmp #$76
		bne !-

		lda #$0
		sta $d012
		sta frame_lo
		sta frame_hi
		//;sta $d011 already 0
		
		lda #<fade_bd_irq 		
		sta $fffe
		lda #>fade_bd_irq 
		sta $ffff

.if (TEST_MODE == 1){
		lsr $d019
		cli							// Inizia l'effetto
}
		
		lda #$ff				// Creo un "tappo" per la routine di sorting
		sta spry+MAXSPR
		lda #MAXSPR
		sta sortorder+MAXSPR
		sta numsprites			// Imposto il numero di sprite
		ldy #floor([sprites&$3fff]/$40)	// Forma dello sprite
		ldx #DARK_GRAY					// Colore dello sprite
		jsr init_sprites_data	// Inizializzazione	(Routine da rivedere)
		
		jsr init_sprites			// Inizializza i registri degli sprite
		jsr update_sprite_coords	// Crea la prima serie di valori di coordinata
		jsr sort_sprites			// Effettua il primo ordinamento

		lda #0
		sta $d015

wait_scene:		
		jmp *
go_load:
		.if(TEST_MODE==1){
			jmp *
		}
		rts


scroll_charNo: .byte 0
print_text:
		lda #$04
		sta $fa
		
		lda #$83-$28-$28
		sta $f9
curchar:		
		lda text1
		beq !+
		jsr put_char_2x
		inc curchar+1
		jmp curchar
!:		
	
		lda #$05
		sta $fa
		
		lda #$a0+$22-$28
		sta $f9
curchar2:		
		lda text2
		beq !+
		jsr put_char_2x
		inc curchar2+1
		jmp curchar2
!:		

		lda #$07
		sta $fa
		
		lda #$2
		sta $f9
curchar3:		
		lda text3
		beq !+
		jsr put_char_2x
		inc curchar3+1
		jmp curchar3
!:		
		rts

put_char_2x:
		pha 
		ldy #0
		ora scroll_charNo
		sta ($f9),y
	
		clc
		adc #$40
		ldy #40
		sta ($f9),y
		
		lda scroll_charNo
		eor #$80
		sta scroll_charNo
		
		inc $f9
		
		ldy #0
		pla
		ora scroll_charNo
		sta ($f9),y
		
		clc
		adc #$40
		ldy #40
		sta ($f9),y
		
		inc $f9
		
		lda scroll_charNo
		eor #$80
		sta scroll_charNo
		rts
		
.align $40
.pc = * "texts"
text1: 
.text "onslaught"
.byte 0
text2: 
.text "brings you"
.byte 0
text3: 
.text "a new demo"
.byte 0

		
	
// ***********************
// Routine di multiplexing
// ***********************

.import source "irqs.asm"

// ************************************
// Bottom IRQ - Apertura bordo e logica
// ************************************
.pc=* "Bottom IRQ"


bottom_irq:
		:open_irq()
		asl $d019		

		lda #$13			// Apro il bordo inferiore/superiore
		sta $d011		
	
	//	lda #$90|[3-floor(SCREEN_1/$4000)]
	//	sta $dd00
				
		jsr build_sprites	// Determino le nuove coordinate degli sprite					
	
		ldy #$7				// Posiziono i primi 8 sprites
		ldx #$e
!:		
		lda sortspry,y		// Y
		sta $d001,x 
		lda sortsprx,y		// X
		sta $d000,x		
		lda sortsprf,y		// Shape
		sta sprite_pt_01,y
		lda sortsprc,y		// Color 
		sta $d027,y	
		dey
		dex
		dex				
		bpl !-		
		lda sortsprx_hi+7	// Sistemo l'hibit della coordinata X
		sta $d010

		lda must_fade_sprites
		beq !+
fade_fn:
		jsr fade_spr	
!:
		
		lda frame_pt
		cmp #$6e
		bne !+
		inc ctt+1
ctt:
		lda #0
		cmp #5 //;Numero di giri
		bne !+
		lda #1
		sta must_fade_sprites
		
		lda #>fade_out_spr
		sta fade_fn+2
		
		lda #<fade_out_spr
		sta fade_fn+1		
!:

		lda #8				// Il prossimo sprite da considerare è l'ottavo
		sta global_sprite_cnt  		
		
		lda #$1d			// Torno in modalità 25 righe per l'apertura bordo
		sta $d011
		
		lda rsttbl+6		// Imposto il nuovo raster IRQ
		sta $d012				
		lda #<top_irq 		// Che punta al primo IRQ handler del plexer
		sta $fffe
		lda #>top_irq 
		sta $ffff		
		
		jsr anim_sprites
		cli					// Da questo momento in poi gli IRQ (nested) sono permessi
		
		//inc $d020
		jsr music.play				// SID player
		//dec $d020
		jsr update_sprite_coords	// Aggiornamento delle coordinate degli sprites
		jsr sort_sprites			// Ordinameto degli sprites
		
		:close_irq()
		rti

must_fade_sprites:
.byte $1

fade_pt_sp:
.byte $0

fade_spr:
		ldx fade_pt_sp
		lda fade_sprites_tbl,x
		ldy #10
!:
		sta $d025,y
		dey
		bpl !-
		
		inc fade_pt_sp
		lda fade_pt_sp
		cmp #24
		bne !+
		dec must_fade_sprites
		lda #YELLOW
		sta $d025
		lda #BLACK
		sta $d026	
!:	
		rts

fade_out_spr:
		ldx fade_pt_sp
		lda fade_sprites_tbl,x
		ldy #10
!:
		sta $d025,y
		dey
		bpl !-

		dec fade_pt_sp
		lda fade_pt_sp
		bne !+
		dec must_fade_sprites
		lda #WHITE
		sta $d025
		lda #WHITE
		sta $d026
		
		//;Disabilito il bottom irq per il prox giro
		lda #<end_irq
		sta plx_irq_target_lo+1
		
		lda #>end_irq
		sta plx_irq_target_hi+1
!:	

		rts
		
anim_sprites:
		ldx frame_pt
		lda frame_tbl,x
		ldy #MAXSPR
!:
		sta sprf,y
		dey
		bpl !-
		
		inc frame_pt
	
		rts
		
// *********************************************************
// Routines per l'aggiornamento e l'ordinamento degli sprite		
// *********************************************************
.import source "plexer.asm"

// *********************************************************
// Funzioni varie	
// *********************************************************
.pc = * "intro"
.import source "intro.asm"

.print floor([sprites&$3fff]/$40)
.align $30
fade_sprites_tbl:
.byte LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte GREEN,GREEN,GREEN,GREEN
.byte GRAY,GRAY,GRAY,GRAY
.byte LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE
.byte BLUE,BLUE,BLUE,BLUE,DARK_GRAY


.align $100
frame_tbl:
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,1+192,1+192,1+192,1+192,1+192,2+192,2+192,2+192,2+192,3+192,3+192
.byte 3+192,3+192,4+192,4+192,4+192,4+192,5+192,5+192,5+192,5+192,5+192,6+192,6+192,6+192,6+192,6+192
.byte 6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192,6+192
.byte 5+192,5+192,5+192,5+192,5+192,4+192,4+192,4+192,4+192,3+192,3+192,3+192,2+192,2+192,2+192,2+192
.byte 1+192,1+192,1+192,1+192,1+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192
.byte 0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192,0+192

frame_pt:
.byte 0

end_irq:
		:open_irq()
		asl $d019
		
		lda #0
		sta $d015
		
		jsr count_frames
		jsr $1003
		
		lda #>go_load
		sta wait_scene+2
		
		lda #<go_load
		sta wait_scene+1
		
		:close_irq()
		rti

count_frames:
		clc
		lda frame_lo
		adc #1
		sta frame_lo
		bcc !+
		inc frame_hi
!:
		rts

