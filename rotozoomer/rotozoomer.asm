.var	TEST_MODE = 0
.if (cmdLineVars.get("test")==null) .eval TEST_MODE=0
							   else .eval TEST_MODE=cmdLineVars.get("test").asNumber()							   

// Absolute address
// ****************							   
.const	texturebuffer	=	$8000	// Exploded texture map
.const	sidorgpos		=	$a000	// Original sid position (to be relocated)
.const	sidendpos		=	$c000	// Relocated sid position
.const	sidrightpos		=	$1000	// Place SID where it can be played
.const	andora			=	$0400	// Tabella di conversione coord Y
.const	nextfade		=	$0400	// Tabella di fade
.const	maincode		=	$3000	// Maincode position
.const	bitmap			=	$4000	// Bitmap (koala) position
.const	cllorgpos		=	$c400	// CLL load position
.const	cllendpos		=	$7ea0	// CLL transition final position

// Constants
// *********
.const	fxlength		=	350		// Lunghezza in frame dell'effetto (450)
.const	EndColor		= 	BLUE	// Ultimo colore del rotozoomer
.const	waitframe		=	40		// Wait first frame

// Fadetable
// *********
.const	nextfadetbl	=	List().add(6,1,11,15,8,10,9,13,14,2,3,4,5,1,12,7)



// **********
// Rotozoomer
// **********

.var sid = LoadSid("..\SID\psycho.sid")

.if (TEST_MODE == 1){	
	.pc=sid.location "Music" .fill sid.size, sid.getData(i)
	:BasicUpstart2(scene_start)
}

.pc=bitmap
.import c64 "Frame\frame.kla"

.import source "chunky_macro.asm"
.import source "variables.asm"
.import source "chunky_include.sym"				// Blocco linkato

// Tabelle precalcolate
// ********************
.pc=maincode "Sinus tables"
sinl:
.fill 256,<floor($fff*sin(3.1415*i/64))
sinh:
.fill 256,>floor($fff*sin(3.1415*i/64))
possinl:
.fill 256,<floor($7fff*sin(3.1415*i/96))
possinh:
.fill 256,>floor($7fff*sin(3.1415*i/96))
zoomtab:
.fill 256,128+120*sin(i*PI/64)*cos(i*PI/128)

// Main code
.pc=* "Start code"
scene_start:	
	stx back+1
	sty back+2
	.if (TEST_MODE == 1){		
		lda #0
		jsr sid.init
	}	
	sei
	lda #$00
	sta $d011	
	sta $d015
	sta bgcol	
	lda #$00
	ldx #<fakeirq
	ldy #>fakeirq
	jsr waitrst
	jsr irqinit	
	sec
	jsr waitrst
	jsr initfader		// Outer block		
	lda $dd00
	and #$fc
	ora #$02
	sta $dd00
	lda #$b0+[[bitmap&$3fff]/$0400]
	sta $d018
	lda #$d8
	sta $d016
	lda #$3b
	sta $d011	
	lda #$00
	ldx #<fadesidirq
	ldy #>fadesidirq	
	jsr waitrst
	jsr irqinit	
	jsr movesid
!:
	lda $90
	bne !-	
	jsr movekoala	
	jsr preparetexture	// Esplosione texture ($4000 bytes)	
	jsr createtable		// Creazione tabelle di quadrati
	jsr createandoratbl	// Creazione tabella andora (fx)
	jsr initvar			
	jsr prechunky		
	sei
	jsr startchunky	
	ldx #waitframe
fskip:
	bit $d011
	bpl fskip
!:
	bit $d011
	bmi !-	
	dex
	bne fskip
	jmp main	

	
// Wait RST
// ********
waitrst:
	bit $d011
	bmi waitrst
!:
	bit $d011
	bpl !-	
	rts

// Predisposizione della texture in memoria
// ****************************************
.pc=* "Main code"
preparetexture:
	ldy #$00
	ldx #$00
texturesource:
	lda imagefile,y		
	pha
	lsr
	lsr
	lsr
	lsr
texturedest1:
	sta texturebuffer+0,x	
	sta texturebuffer+$80,x	
	asl
	asl
	asl
	asl
	sta texturebuffer+1,x	
	sta texturebuffer+$81,x	
	pla
	and #$0f
texturedest2:
	sta texturebuffer+2,x	
	sta texturebuffer+$82,x	
	asl
	asl
	asl
	asl
	sta texturebuffer+3,x	
	sta texturebuffer+$83,x	
	iny
	txa
	axs #<[$100-4]	
	cpx #$80
	bne texturesource
	ldx #$00
	inc texturedest1+2
	inc texturedest1+5
	inc texturedest1+8+4
	inc texturedest1+11+4
	inc texturedest2+2
	inc texturedest2+5
	inc texturedest2+8+4
	inc texturedest2+11+4
	cpy #$00
	bne texturesource
	inc texturesource+2
	lda texturesource+2	
	cmp #>[imagefile+64*32]
	beq !+
	jmp texturesource
!:	
	rts	


fakeirq:
	pha
	txa
	pha
	tya
	pha	
	lsr $d019
	cli
fakeirqsid:
	jsr sid.play
	pla
	tay
	pla
	tax
	pla
	rti

irqinit:
	sei 		
	sta $d012
	stx $fffe	
	sty $ffff
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda $dc0d
	lda $dd0d
	lda #$01
	sta $d01a	
	lda $d011
	and #$7f
	sta $d011	
	lda #$35
	sta $01		
	lsr $d019
	cli
	rts	

bgcolor:
.byte WHITE,LIGHT_GREEN,YELLOW,LIGHT_GRAY,CYAN,LIGHT_RED,GREEN,GRAY,LIGHT_BLUE,ORANGE,PURPLE,DARK_GRAY,RED,BROWN,BLUE,BLACK
	
// Inizializza tutte le variabili
initvar:
	lda #$10
	sta nextscenecounter
	lda #<fxlength
	sta fcl
	lda #>fxlength
	sta fch
	lda #$00
	sta counter2
	sta endpart		
	sta flippage
	sta ulo
	sta vlo
	sta uhi
	sta vhi	
	sta angle1
	lda #$ff
	sta counter3
	lda #$01
	sta flipdata	
	lda #$20
	sta angle2
	lda #$40
	sta angle3	
	jsr updatefx
	rts

.print "Main FX routine: "+toHexString(*)
main:	
		bit endpart		
		bmi endscene				
		dec fcl
		bne maincont
		dec fch		
		bpl maincont
		dec endpart	
maincont:		
		jsr flipscreen
		jsr compute
		jsr updatefx
		jmp main

// Final scene
// ***********		
endscene: 
			bmi endscene+2
			ldx counter3
			lda #>[andora+$200]
			sta andora+$100,x
			dex
			stx counter3			
			ldx counter2			
			sta andora,x
			inx
			stx counter2			
			bne maincont
veryend:			
			jsr flipscreen
			jsr compute
			jsr updatefx			
			jsr flipscreen
			jsr compute
			jsr updatefx						
			jsr waitrst			
			sei
			lda #$7f
			sta $dd0d
			bit $dd0d
			lda #$b0
			sta $d018			
			lda #$00
			ldx #<fakeirq
			ldy #>fakeirq
			jsr irqinit
			clc
			jsr initfader		// Outer block		
			jsr waitrst
			lda #$00
			ldx #<fadesidirq
			ldy #>fadesidirq				
			jsr irqinit
		!:
			lda $90
			bne !-
			jsr waitrst
			lda #$00
			ldx #<fakeirq
			ldy #>fakeirq
			jsr irqinit			
			lda #$20
			ldx #$00
		!:
			sta $0400,x
			sta $0500,x
			sta $0600,x
			sta $0700,x
			dex
			bne !-
			ldx #50
		!:
			jsr waitrst		// Lose some frames
			dex
			bne !-
			lda #$13
			sta $d011
			lda $dd00
			and #$fc
			ora #$03
			sta $dd00
			lda #$15
			sta $d018			
		endfadeloop1:
			lda $d011
			asl
			lda $d012
			ror
			cmp #150
			bcc endfadeloop1
			lda $d020			
			and #$0f
			tax
			cpx #WHITE
			beq !+
			lda fadetowhite,x
			sta $d020
		!:
			lda $d021
			and #$0f
			tay			
			cpy #WHITE
			beq !+
			lda fadetowhite,y
			sta $d021			
		!:
			bit $d011
			bmi !-
			cpy #WHITE
			bne endfadeloop1
			cpx #WHITE
			bne endfadeloop1
			lda #BIT_ABS
			sta fakeirqsid
			jsr placesid
			lda #$00
			jsr sidrightpos
			lda #JSR_ABS
			sta fakeirqsid
			jsr movecll
		endfadeloop2:
			lda $d011
			asl
			lda $d012
			ror
			cmp #150
			bcc endfadeloop2
			lda $d020			
			and #$0f
			tax
			cpx #LIGHT_BLUE
			beq !+
			lda fadetoblack,x
			sta $d020
		!:
			lda $d021
			and #$0f
			tay			
			cpy #BLUE
			beq !+
			lda fadetoblack,y
			sta $d021
		!:
			bit $d011
			bmi !-
			cpy #BLUE
			bne endfadeloop2
			cpx #LIGHT_BLUE
			bne endfadeloop2
			rts					// Next scene
			
// Change screen
// *************		
flipscreen:		
		lda $d011
		asl
		lda $d012
		ror
		cmp #$10
		bcc flipscreen
		sei
		lda #$01
		sta flippage
		eor flipdata		
		sta flipdata
		cli
		beq page_1		
page_0:		
		:point_screen_1()
		rts
page_1:
		:point_screen_2()		
		rts	
	
// Calcola il nuovo angolo/zoom in base alle tabelle precalc
// *********************************************************		
updatefx:		
		// Aggiorna indice zoom
		
		ldy zoompos
		iny
		sty zoompos
		lda zoomtab,y
		sta zoom

		// Aggiorna indice rotazione

		inc angle1
		inc angle2
		inc angle3	

		// Applica lo zoom alla rotazione (multiplicando)
		
		ldy angle2	// u(x)=cos(phi) => sin(90+phi)		
		ldx sinh,y		
		lda sinl,y
		ldy zoom
		jsr m16x8	// [Xa]x[Y] => [AY_]
		sty	incxulo
		sty incyvlo
		sta incxuhi
		sta incyvhi
				
		ldy angle1	// v(x)=sin(phi)
		ldx sinh,y		
		lda sinl,y
		ldy zoom
		jsr m16x8	// [Xa]x[Y] => [AY_]
		sty incxvlo
		sta incxvhi

		ldy angle3	// u(y)=cos(90+phi) => sin(180+phi)
		ldx sinh,y		
		lda sinl,y
		ldy zoom
		jsr m16x8	// [Xa]x[Y] => [AY_]
		sty incyulo
		sta incyuhi		

		// Aggiorna indice offset
		
		ldx movepos
		inx
		cpx #$C0
		bne !+
		ldx #$00
	!:
		stx movepos		
		
		// Applica l'offset verticale ed orizzontale
		
		lda possinl,x
		sta ulo
		lda possinh,x
		sta uhi
		txa
		axs #$d0
		lda possinl,x
		sta vlo
		lda possinh,x
		sta vhi		
		rts

// ********************************
// Routine di disegno dell'immagine	
// ********************************
.print "Compute routine: "+toHexString(*)
compute:	
	lda incyulo		// 3
	sta iyul+1		// 4
	lda incyuhi		// 3
	sta iyuh+1		// 4
	lda incyvlo		// 3
	sta iyvl+1		// 4
	lda incyvhi		// 3
	sta iyvh+1		// 4
	clc				// 2
	lda yvlo		// 3
yvl:adc incyvlo		// 3
	sta yvlo		// 3
	txa				// 2
yvh:adc incyvhi		// 3		
	clc				// 2
	lda yulo		// 3
	adc incxulo		// 3	
	lda incxuhi		// 3
	adc #$00		// 2
	sta fixedincx+1	// 4
	lda #SIZEY-1	// 2
	sta rowcounter	// 3
	lda ulo			// 3
	sta yulo		// 3
	lda uhi			// 3
	sta yuhi		// 3
	lda vlo			// 3

	sta yvlo		// 3
	lda vhi			// 3
	sta yvhi		// 3
	lda incxulo		// 3
	asl				// 2
	sta tmpxulo		// 3
	lda incxuhi		// 3
	rol				// 2
	sta tmpxuhi		// 3 
	lda uhi			// 3 Calcolo u(x)
	tay				// 2
	alr #$fc		// 2
	sta pixloop+$b	// 4
	ldx ulo			// 3 - 104
	.for(var i=1;i<SIZEX/2;i++)
	{
		txa				// 2 - Carry always clear
		adc tmpxulo		// 3
		tax				// 2
		tya				// 2
		adc tmpxuhi		// 3	
		tay				// 2		
		alr #$fc		// 2		
		sta pixloop+$b+i*20	// 4 - 20*23
	}
	ldy vhi				// 3
	sty pixloop+1		// 3 Calcolo v(x)		
	ldx vlo				// 3 - 9
	.for(var i=1;i<SIZEX;i++)
	{
		clc				// 2
		txa				// 2
		adc incxvlo		// 3
		tax				// 2
		tya				// 2
		adc incxvhi		// 3
		tay				// 2
		.if ([i&1]==1)	sta pixloop+$6+floor(i/2)*20	// 4 - 20*47
				else	sta pixloop+$1+floor(i/2)*20	// 4 - 20*47
	}	
	ldx yvhi		// 3	
rowloop:	
	ldy rowcounter	// 3
target_buffer_lo:
	lda $ffff,y		// 4
	sta ptr			// 3
target_buffer_hi:	
	lda $ffff,y		// 4
	sta ptr+1		// 3
	lda yuhi		// 3
	alr #$fc		// 2
	sta left		// 3
	lda	yuhi		// 3
fixedincx:
	adc #00			// 2
	alr #$fc		// 2
	ora #$01		// 2
	sta right		// 3 - 37
.print "Pixel loop: "+toHexString(*)
pixloop:
	.for(var i=0;i<SIZEX/2;i++)
	{		
		lda andora,x		// 4
		sta left+1			// 3
		lda andora,x		// 4
		sta right+1			// 3		
		ldy #0				// 2 PIXEL SX: Prendo u(x)		
		lda (left),y		// 5 Aggiungo u(y) che si trova nel lobyte di (left) -> CARICO COL. NEL LONIBBLE (bit0=0)		
		ora (right),y		// 5 Aggiungo u(y) che si trova nel lobyte di (right) -> CARICO COL. NEL HINIBBLE (bit0=1)
		ldy #i				// 2 Salvo nell'area di memoria opportuna
		sta (ptr),y			// 6 - 34/35 => 18 cicli per pixel -> 34*24
	}
	dec rowcounter	// 5
	bmi !+			// 2/3
	lda yulo		// 3
iyul:
	adc #$00		// 2
	sta yulo		// 3
	lda yuhi		// 3
iyuh:
	adc #$00		// 2	
	sta yuhi		// 3	
	clc				// 2
	lda yvlo		// 3
iyvl:
	adc #$00		// 2
	sta yvlo		// 3
	txa				// 2
iyvh:
	adc #$00		// 2
	tax				// 2
	jmp rowloop		// 3 - (37+(SIZEX/2)*34+42)xSIZEY+[SIZEX-1+SIZEX/2-1]*20+104+9+3  => 44476 (48x48) => 19.3 cycles/pixel
!:	
	rts

// Crea la tabella AndOra (e crea un'area di memoria vuota a cui puntare)
// **********************************************************************
createandoratbl:
	ldx #$00
!:
	txa
	lsr
	lsr
	ora #$80
	sta andora,x
	sta andora+$100,x
	lda #EndColor*16+EndColor
	sta andora+$200,x
	sta andora+$300,x
	inx
	bne !-
	rts

// Prepare nextfade table
// **********************
preparefadetbl:
	ldx #$00
!:
	txa
	and #$0f
	tay
	lda fadetable,y
	sta nextfade,x
	txa
	lsr
	lsr
	lsr
	lsr
	tay
	lda fadetable,y
	asl
	asl
	asl
	asl
	ora nextfade,x
	sta nextfade,x
	inx
	bne !-
	rts

// Move SID/CLL to safe area
// *************************
movesid:
	ldx #$00
msload:
	lda sidorgpos,x
mssave:	
	sta sidendpos,x
	inx
	bne msload
	inc msload+2
	inc mssave+2
	lda msload+2
	cmp #[>sidorgpos]+$10
	bne msload
	rts
	
// Place SID right area
// ********************
// divval:
// cmpval:
placesid:		
	lda #<sidendpos
	sta ptr
	lda #>sidendpos
	sta ptr+1
	ldy #$00
	lda (ptr),y		// Load separator value
	sta divval
	iny
	bne psstart		// Update pointers
psloop1:
	sec
psloop2:	
	ldy #$00
	lax (ptr),y		// Load current command
	beq psend		// End => DONE
	sbc divval		// Skip or block or end?	
	iny				// It's a command so update ptr position
	bcc psskip		// It's a block then no need to copy anything (X has the correct value)
	tax				// Save in X for later use
	adc #$00		// Add 1 (carry=1)
	sta cmpval		// Save compare value
psload:	
	lda (ptr),y		// Load next values
pssave:	
	sta sidrightpos-1,y	// And save them in the correct position
	iny	
	cpy cmpval			// Check if we've reached the end of the block
	bne psload
	clc
psskip:					// In both case X keeps save ptr update	
	txa
	adc pssave+1
	sta pssave+1
	bcc psupdptr
	inc pssave+2
psstart:
	clc
psupdptr:				// And Y keeps load ptr update	
	tya
	adc ptr
	sta ptr
	bcc psloop1
	inc ptr+1
	bcs psloop2
psend:
	rts	
	
// Move CLL to end area
// ********************
movecll:
	ldx #$00
mcload:
	lda cllorgpos,x
mcsave:	
	sta cllendpos,x
	inx
	bne mcload
	inc mcload+2
	inc mcsave+2
	lda mcload+2
	cmp #[>cllorgpos]+$03
	bne mcload
	rts
	
//fadein:
//	lda 

// Fader finale
// ************
fadetable:
.fill 16,nextfadetbl.get(i)

back:
	.if (TEST_MODE==1)	bit.a $0000
		else			jmp $0000
