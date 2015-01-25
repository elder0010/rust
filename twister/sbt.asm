.var	TEST_MODE = 0
.if (cmdLineVars.get("test")==null) .eval TEST_MODE=0
							   else .eval TEST_MODE=cmdLineVars.get("test").asNumber()

// 42-43 => 260-261
// Real: 44-45 => 262-263

.const	startline	=	42
.const	stopline	=	260

.var	maincode
.if (TEST_MODE==1)	.eval maincode	=	$7000
			else	.eval maincode	=	$B000
.var maploader	=	$8000	
.var map		=	$c000		

.const	charpage	=	floor([maincode&$3fff]/$0400)+3

.const	nextscene	=	$4f
.const	saveacc		=	$50
.const	savex		=	$51
.const	savey		=	$52

.const	rastline	=	$54
.const	firstline	=	$55
.const	lastline	=	$56
.const	afterf9		=	$57

// Sprite X coordinate
// *******************
.const	sprite0_2	=	$60
.const	sprite1_2	=	$61
.const	sprite2_2	=	$62
.const	sprite3_2	=	$63
.const	sprite4_2	=	$64
.const	sprite5_2	=	$65
.const	sprite6_2	=	$66
.const	sprite7_2	=	$67
.const	spriteh_2	=	$68

.const	sprite0_1	=	$69
.const	sprite1_1	=	$6a
.const	sprite2_1	=	$6b
.const	sprite3_1	=	$6c
.const	sprite4_1	=	$6d
.const	sprite5_1	=	$6e
.const	sprite6_1	=	$6f
.const	sprite7_1	=	$70
.const	spriteh_1	=	$71

.var	barindex	=	$72
.var	horiz1		=	$73
.var	horiz2		=	$74
.var	ypos1		=	$75
.var	ypos2		=	$76
.var	ycounter1	=	$77
.var	ycounter2	=	$78

.var	c1_1	=	$7a
.var	c2_1	=	$7b
.var	c3_1	=	$7c

.var	c1_2	=	$7d
.var	c2_2	=	$7e
.var	c3_2	=	$7f

.var	left	=	$80
.var	right	=	$82
.var	exitjmp	=	$84
.var	storyptr=	$86
.var	waitbyte=	$88

.var	ub		=	$90
.var	lb		=	$91

.var	bg1		=	$92
.var	bg2		=	$93

.var	ext		=	$94

.var	rm0		=	$95
.var	rm1		=	$96
.var	rm2		=	$97
.var	rm3		=	$98
.var	rm4		=	$99
.var	rm5		=	$9a

.var	framewait	=	$a0
.var	cmd			=	$a1
.var	loopinst	=	$a2
.var	multicount	=	$a3
.var	looping		=	$a4
.var	mcloopfix	=	$a5
.var	instrlen	=	$a6
.var	curmove		=	$a7
.var	val64		=	$a8
.var	upsize		=	$a9
.var	losize		=	$aa
.var	waitvalue	=	$ab
.var	waitmode	=	$ac

.const upbar  = List().add(LIGHT_GREY,BLUE)
.const midbar = List().add(PURPLE,LIGHT_BLUE,CYAN,YELLOW,LIGHT_RED,ORANGE,BLUE)
.const lobar  = List().add(LIGHT_GREY,BLACK)

.if (TEST_MODE==1) :BasicUpstart2(start)

.var sid=LoadSid("..\SID\rust.sid")

.if (TEST_MODE==1) {
	.pc=sid.location "Rust by psicho (SID)"
	.fill sid.size, sid.getData(i)
}

.pc=maincode "Code"
start:
	stx exitjmp
	sty exitjmp+1
	lda #$00
	.if (TEST_MODE==1) {
		lda #$00
		jsr sid.init
		lda #$7f
		sta $dc0d
		sta $dd0d
		bit $dc0d
		bit $dd0d
		lda $d011
		ora #$80
		sta $d011
		lda #$ff
		sta $d012
		lda #$01
		sta $d01a
		lsr $d019
	}
	jsr preset
	jsr waitbottom			
	jsr copymem
	.if (TEST_MODE==1)	jmp *
	rts
.if (TEST_MODE==0)	.fill 47,0	// Align
	
waitbottom:
!:
	lda $d011
	asl
	lda $d012
	ror
	cmp #150
	bcc !-
	sei
	.if (TEST_MODE==1) {
		lda #$35
		sta $01
	}
	lda #<transirq1
	sta $fffe
	lda #>transirq1
	sta $ffff
	lda #startline-1
	sta $d012
	lda #$1b
	sta $d011
	lsr $d019
	cli
	rts	
	
transirq1:
	pha		// 3 + 7 + 2/9
	txa		// 2
	pha		// 3
	tya		// 2
	pha		// 3
	ldx #upbar.get(0)	// 2 - 24/31
	lda $d012
!:	
	cmp $d012
	beq !-
	stx $d020			// 4
	lsr $d019			// 6
	lda #249			// 2
	sta $d012			// 4
	lda #<transirq2		// 2
	sta $fffe			// 4
	lda #>transirq2		// 2
	sta $ffff			// 4
	ldx #upbar.get(1)	// 2 - 30/37
	lda $d012
!:	
	cmp $d012
	beq !-
	stx $d020
	stx $d021
	lda #$ba
	sta $d018
	lda $dd00
	and #$fc
	ora #[3-floor(maincode/$4000)]
	sta $dd00	
	jsr sid.play		
	pla
	tay
	pla
	tax
	pla
	rti
	
	
transirq2:
	pha		// 3 + 7 + 2/9
	lsr $d019			// 6
	lda #<stopline-1	// 2
	sta $d012			// 4
	lda #<transirq3
	sta $fffe
	lda #>transirq3
	sta $ffff
	lda #$d3			// 2
	sta $d011			// 4
	pla
	rti	
		
transirq3:
	pha		// 3 + 7 + 2/9
	txa		// 2
	pha		// 3
	tya		// 2
	pha		// 3
	ldx #lobar.get(0)	// 2 - 24/31
	lda $d012
!:	
	cmp $d012
	beq !-
	stx $d020			// 4
	stx $d021
	lsr $d019			// 6
	lda #$00			// 2
	sta $d012			// 4
	lda #<sidirq
	sta $fffe
	lda #>sidirq
	sta $ffff
	lda #$43			// 2
	sta $d011			// 4
	ldx #lobar.get(1)	// 2 - 36/43
	nop
	nop
	nop
	nop
	nop
//	lda $d012
//!:	
//	cmp $d012
//	beq !-
	stx $d020
	stx $d021
	lda #[charpage*16+0]
	sta $d018	
	lda $dd00	//4 Ok
	and #$fc	//2	
	ora #[3-floor(maincode/$4000)]	//2
	sta $dd00	//4	
	lda #$ff
	sta $d015	
	pla
	tay
	pla
	tax
	pla
	rti
	
		
// Preset configuration
// ********************
preset:
	lda #$00	
	sta waitmode
	sta [floor(map/$4000)*$4000]+$39ff	
	sta barindex
	sta curmove
	sta horiz2
	sta horiz1	
	lda #upbar.get(1)	// "Empty" screen
	sta $d022
	sta $d023
	sta $d024
	ldx #$00	
!:
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	dex
	bne !-
	ldx #$07
	lda #[charpage*$10]+14	// Empty sprite
!:
	sta [floor(maincode/$4000)*$4000]+charpage*$0400+$3f8,x
	dex
	bpl !-
	// Init line positions
	sec	
	lda #stopline
	sta lastline
	sbc #[249+4]
	sta afterf9
	sec
	lda #startline
	sta firstline
	sbc #$03
	sta rastline		
	// Init colors
	lda #BLUE
	sta rm0
	sta rm1
	sta rm2
	sta rm3
	sta rm4
	sta rm5
	sta bg1
	sta bg2
	sta c1_1
	sta c2_1
	sta c3_1
	sta c1_2
	sta c2_2
	sta c3_2
	lda #upbar.get(0)
	sta ub
	sta lb
	lda #BLACK
	sta ext
	jsr updatepos	
	lda #$00
	sta $d01d	
	lda #$ff
	sta $d01c
	lda #$c8
	sta $d016
	ldx #$0e
	sec
	lda firstline
	sbc #$07
!:
	sta $d001,x
	clc	
	adc #$01
	dex
	dex
	bpl !-	
	lda #<story
	sta storyptr
	lda #>story
	sta storyptr+1
	lda #$00
	sta framewait
	sta loopinst
	sta looping
	rts

// First IRQ routine
// *****************
fstirq:	
	lsr $d019
	lda $d011
	and #$67
	sta $d011	// Open u/l border
	lda #$00
	sta $d012
	lda #<sidirq
	sta $fffe
	lda #>sidirq
	sta $ffff
	rti

// Sid player	
// **********
sidirq:
	pha
	txa
	pha
	tya
	pha	
	lda #<mainirqpre	// 2
	sta $fffe			// 4
	lda #>mainirqpre	// 2
	sta $ffff			// 4
	ldx rastline		// 3
	dex
	dex
	stx $d012			// 4		
	lsr $d019
	lda $d011
	and #$7f
	sta $d011	
	jsr parse
	jsr updatecolors
	cli
	jsr sid.play
	pla
	tay
	pla
	tax
	pla
	rti

.align $080	
	
// Main IRQ routine Pre sync
// *************************
mainirqpre:
	sta saveacc
	stx savex
	sty savey
	lsr $d019	
	ldx rastline
	//inx
	stx $d012
	lda #<mainirq
	sta $fffe	
	cli
	.fill 16,NOP
	.fill 32,NOP
	.byte $02	// Check byte

// Main IRQ routine sync
// *********************

mainirq:	
	ldx #$00	//2
	stx $dc0f	//4		
	stx $dc0e	//4		
	lda #$48	//2
	sta $d011	//4	
	
	lda $dd00	//4
	and #$fc					//2			
	ora #[3-floor(map/$4000)]	//2	
	sta fstdd00val+1	//4	
	
	.fill 3,NOP	//6
	bit $ff	
	lsr $d019	// 6 Sync			
				
	lda ypos2	//3
	sta $dc06	//4		
	ldy #$ff	//2		
	sty $dc07	//4
	ldx ycounter2		//4
	lda sintablestr,x	//4
	sta $dc04			//4
	ldx #$00			//2
	stx $dc05			//4		
	lda #$41	//2
	sta $dc0f	//4	
	lda #$01	//2
	sta $dc0e	//4
	lda c2_1	//3	
	bit $ff		//3
	
	
// Upper BAR
// *********			
	
	sta $d025	//4
	lda c3_1	//3
	sta $d026	//4	
	lda c1_1	//3	
	sta $d027	//4
	sta $d028	//4
	sta $d029	//4
	sta $d02a	//4
	sta $d02b	//4
	sta $d02c	//4
	sta $d02d	//4		
ru0:
	ldy #upbar.get(0)	// 2 - 44
	sty $d020	//4
	sty $d021	//4 1° color bar
	
	sta $d02e
ru1:
	ldy #upbar.get(1)
	lda #$c8
	sta $d016
	stx $d017	//4
	lda $dc06	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff	//4		
	sty $d020	//4 
	sty $d021	//4 2° color bar
		
// First Twister
// *************		
	ldx #$00	//2
	ldy #$ff	//2
	stx $d017	//4
	sty $d017	//4	
	sta map+[charpage*$0400]+$03f8	//4
	sta map+[charpage*$0400]+$03f9	//4
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4	
fstdd00val:	
	lda #$00	//2
	sta $dd00	//4	
	lsr $d016	//6
			
	.fill 3,NOP	//6
	lda $dc06	//4
	sta map+[charpage*$0400]+$03f8	//4	
	stx $d017	//4
	sty $d017	//4		
	sta map+[charpage*$0400]+$03f9	//4
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	ldx	#$c8	//2
	stx $d016	//4
	lsr $d016	//6 - 40
	
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	inc $d017	//6
	sty $d017	//4		
	sta map+[charpage*$0400]+$03fe		//4
	sta map+[charpage*$0400]+$0300,y	//5
	ldy.a upsize//4
	nop
	jmp mainloop//3	

.align $0040	
mainloop:		// Upper Twister
	stx $d016	//4
	lsr $d016	//6 - 46		
	lda $dc06	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff	//4
	dey			//2
	beq	midbar1	//2/3
	inc $d017	//4 00
	dec $d017	//6 FF
	stx $d016	//4
	lsr $d016	//6 - 46		
	sta map+[charpage*$0400]+$03f8	//4
	sta map+[charpage*$0400]+$03f9-$c8,x	//5
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	dey			//2
	beq	midbar2	//3/2		
	inc $d017	//6	00
	dec $d017	//6	FF
	jmp mainloop//3
	
// Middle BAR
// **********
midbar2:		// Middle bar
	bit $ff		//3
midbar1:
	sty $d017	//4 00
	dec $d017	//6 FF
	stx $d016	//4
	lsr $d016-$c8,x	//7
	
	stx $d016	//4	
	lda $dd00	//4 OK
	and #$fc	//2
	ora #[3-floor(maincode/$4000)]	//2
	sta $dd00	//4		TESTEST	
	.fill 7,NOP	//14
	lda #$00	//2
	sta $dc0f	//4		
	sta $dc0e	//4		
	lsr $d016	//6
	
	lda.a ypos1	//4
	sta $dc06	//4		
	ldy #$ff	//2		
	sty $dc07	//4	
	ldx ycounter1		//4
	lda sintablestr,x	//4
	sta $dc04			//4
	ldx #$00			//2
	nop			//2
	stx $d017	//4	
	stx $dc05	//4		
	lda #$41	//2	
	ldx rm0		//3
	stx $d020	//4
	stx $d021	//4		
	
	sta $dc0f	//4	
	lda #$01	//2
	sta $dc0e	//4	
	ldx #$04	//2+5*3+4
!:
	dex			//2
	bne !-		//3/2
	
	nop			//2
	ldx rm1		//3
	stx $d020
	stx $d021
		
	.fill 5,NOP	//14
	lda c1_2	//3
	sta $d027	//4
	sta $d028	//4
	sta $d029	//4
	sta $d02a	//4
	sta $d02b	//4
	ldx rm2		//3
	stx $d020
	stx $d021
		
	sta $d02c	//4
	sta $d02d	//4
	sta $d02e	//4
	lda c2_2	//3
	sta $d025	//4
	lda c3_2	//3
	sta $d026	//4	
	lda sprite0_2	//3
	sta $d000		//4
	ldx rm3			//3
	stx $d020
	stx $d021
			
	nop				//2	
	lda sprite1_2	//3
	sta $d002		//4
	lda sprite2_2	//3
	sta $d004		//4
	lda sprite3_2	//3
	sta $d006		//4
	lda spriteh_2	//3
	sta $d010		//4	
	ldy losize		//3	
	ldx rm4			//3
	stx $d020
	stx $d021
		
	lda sprite4_2	//3
	sta $d008		//4
	lda sprite5_2	//3
	sta $d00a		//4
	lda sprite6_2	//3
	sta $d00c		//4
	lda sprite7_2	//3
	sta $d00e		//4	
	lda $dc06		//4
	ldx.a rm5		//4
	stx $d020
	stx $d021	
		
	sta map+[charpage*$0400]+$03f8	//4
	sta map+[charpage*$0400]+$03f9	//4
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff	//4
	ldx.a bg2	//4
	stx $d020
	stx $d021	
	
	
	lda $dd00	//4 OK
	and #$fc	//2
	ora #[3-floor(map/$4000)]	//2
	sta $dd00	//4
	lda #$ff	//2
	sta $d017	//4
	nop			//2
	nop			//2
	bit $ff		//3
	ldx #$c8	//2
	jmp mainloop2	//3
	
.align $0040
// Second Twister
// **************	
mainloop2:		// Lower Twister (Before F9)
	stx $d016	//4
	lsr $d016	//6 - 46		
	lda $dc06	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff	//4
	dey			//2
	beq	midbar12//2/3
	inc $d017	//4 00
	dec $d017	//6 FF
	stx $d016	//4
	lsr $d016	//6 - 46		
	sta map+[charpage*$0400]+$03f8	//4
	sta map+[charpage*$0400]+$03f9-$c8,x	//5
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	dey			//2
	beq	midbar22//3/2		
	inc $d017	//6	00
	dec $d017	//6	FF
	jmp mainloop2//3		
	
// Manage up/lo border opening
// ***************************
midbar12:	
	sty $d017		//4
	dec $d017		//6
	stx $d016		//4
	lsr $d016-$c8,x	//7
	sta map+[charpage*$0400]+$03f8		//4
	sta map+[charpage*$0400]+$03f9-$c8,x	//5
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	sty $d017	//6	00
	ldy #$40	//2
	sty $d011	//4
	dec $d017	//6	FF	
	ldy afterf9	//3
	stx $d016	//4
	lsr $d016	//6 - 46		
	lda $dc06	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff-$c8,x	//5
	inc $d017	//4 00
	dec $d017	//6 FF	
	jmp mainloop3_1	
midbar22:	
	bit $ff		//3
	sty $d017	//4
	dec $d017	//6	
	stx $d016	//4
	lsr $d016-$c8,x	//7 - 46		
	lda $dc06	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff	//4
	sty $d017	//4
	ldy #$40	//2
	sty $d011	//4
	dec $d017	//6	
	stx $d016	//4
	lsr $d016	//6 - 46		
	sta map+[charpage*$0400]+$03f8	//4
	sta map+[charpage*$0400]+$03f9-$c8,x	//5
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	ldy.a afterf9	
	inc $d017	//6	00
	dec $d017	//6	FF
	jmp mainloop3_2	//3	
	
.align $040
mainloop3_2:	// Lower Twister (After F9)
	stx $d016	//4
	lsr $d016	//6 - 46		
	lda $dc06	//4
	sta map+[charpage*$0400]+$03fc	//4
	sta map+[charpage*$0400]+$03fd	//4
	sta map+[charpage*$0400]+$03fe	//4
	sta map+[charpage*$0400]+$03ff	//4
	dey			//2
	beq	midbar13//2/3
	inc $d017	//4 00
	dec $d017	//6 FF
mainloop3_1:
	stx $d016	//4
	lsr $d016	//6 - 46		
	sta map+[charpage*$0400]+$03f8	//4
	sta map+[charpage*$0400]+$03f9-$c8,x	//5
	sta map+[charpage*$0400]+$03fa	//4
	sta map+[charpage*$0400]+$03fb	//4
	dey			//2
	beq	midbar23//3/2		
	inc $d017	//6	00
	dec $d017	//6	FF
	jmp mainloop3_2//3		

// Lower BAR
// **********
midbar23:		// Lower bar
	bit $ff		//3
midbar13:
	sty $d017	//4 00
	dec $d017	//6 FF
	stx $d016	//4
	lsr $d016-$c8,x	//7
	
	stx $d016	//4
	lda $dd00	//4 Ok
	and #$fc	//2	
	ora #[3-floor(maincode/$4000)]	//2
	sta $dd00	//4		
	lda #>sidirq	// 2
	sta $ffff		// 4	
	
storeh2:
	.fill 9,NOP	//18
	lsr $d016	//6
	nop
	.fill 4,NOP
	ldx #$03	//2
!:
	nop			//2
	dex			//2
	bne !-		//3/2 => 7*2+6 => 20
	stx $d017	//4
	bit $ff		//3
	ldx lb		//3
	stx $d020	//4
	stx $d021	//4	
	lda #<sidirq	// 2
	sta $fffe		// 4	
	lda ext
	ldx #$04	//2
!:
	dex			//2
	bne !-		//3/2 => 5*3+4 => 19		
	stx $d012		// 4	
	nop			//2
	sta $d020	//4
	sta $d021	//4		
	jsr	updatepos
	pla
	pla
	pla	
	ldx savex
	ldy savey
	lda saveacc
	rti

// Update variables
// ****************
updatepos:
	lda curmove
	lsr	
	bcc !+	
	inc horiz1
	bne !+
	pha
	lda h1byte+2
	eor	#$01
	sta h1byte+2
	pla
!:
	lsr
	bcc !+
	inc horiz2	
	bne !+
	pha
	lda h2byte+2
	eor	#$01
	sta h2byte+2
	pla	
!:		
	lsr
	bcc !+
	inc ycounter1
	inc ycounter1
!:	
	lsr
	bcc !+
	dec ypos1
	dec ypos1
	dec ypos1		
!:		
	lsr
	bcc !+
	inc ycounter2	
	
!:	
	lsr
	bcc !+
	dec ypos2
	dec ypos2
!:
	lsr
	bcc !+
	inc barindex	
!:
	ldx barindex
	lda upsizesin,x
	sta upsize
	sec	
	lda #249-13
	sbc firstline
	sec	
	sbc upsize
	sta losize		
	lda #$80
	sta spriteh_1
	sta spriteh_2		
	ldx horiz1
h1byte:
	lda sintablex,x
	ldx #$00
	ldy #$00	
	clc	
!:	
	sta sprite0_1,y	
	sta $d000,x
	adc #$18
	ror spriteh_1
	iny
	inx
	inx	
	bcc !-
	lda spriteh_1
	asl
	sec
	sbc #$01
	eor #$ff
	sta spriteh_1
	sta $d010 	
	ldx horiz2
h2byte:
	lda sintablex+$100,x
	ldx #$00
	ldy #$00	
	clc	
!:	
	sta sprite0_2,y		
	adc #$18
	ror spriteh_2
	iny
	inx
	inx	
	bcc !-
	lda spriteh_2
	asl
	sec
	sbc #$01
	eor #$ff
	sta spriteh_2		
	rts

// Move/Decode textures
// ********************
copymem:
	ldx #$35
	lda #<map
	ora #$03
	sta savetx+1
	lda #>map
	sta savetx+2
	lda #<maploader
	sta loadtx+1
loop:		
	lda #>maploader
	sta loadtx+2	
	ldy #47
loadtx:
	lda $ffff
	sei	
	dec $01
savetx:
	sta $ffff,y	
	stx $01	
	cli	
	inc loadtx+2
	dey	
	bpl loadtx	
	clc
	lda savetx+1
	adc #$40
	sta savetx+1
	bcc !+
	inc savetx+2
!:
	inc loadtx+1
	bne loop
	rts

	
updatecolors:
	// Copy upper bar colors
	lda ub
	sta ru0+1
	lda bg1
	sta ru1+1
	rts

	
.import source "macro.asm"
.import source "storyparser.asm"		

.pc=maincode+$9ff		// Idle byte
.byte $00

.pc=* "Sinus table (Horizontal)"
.align $0200
sintablex:
.byte 55,53,52,50,49,47
.byte 46,45,44,43,42,41
.byte 40,39,38,38,37,37
.byte 37,37,36,36,36,36
.byte 37,37,37,38,38,38
.byte 39,40,40,41,42,43
.byte 43,44,45,46,47,48
.byte 49,50,51,52,53,54
.byte 55,56,57,58,59,59
.byte 60,61,62,62,63,64
.byte 64,65,65,66,66,66
.byte 66,66,66,66,66,66
.byte 66,65,65,64,64,63
.byte 62,62,61,60,59,58
.byte 57,55,54,53,52,50
.byte 49,47,46,44,43,41
.byte 39,38,36,34,32,31
.byte 29,27,26,24,22,21
.byte 19,17,16,14,13,12
.byte 10,9,8,7,6,5
.byte 4,3,2,2,1,1
.byte 0,0,0,0,0,0
.byte 1,1,2,2,3,4
.byte 5,6,7,9,10,12
.byte 14,15,17,19,21,24
.byte 26,29,31,34,36,39
.byte 42,45,48,51,54,57
.byte 61,64,67,71,74,77
.byte 81,84,88,91,95,98
.byte 102,105,108,112,115,118
.byte 122,125,128,131,134,137
.byte 140,143,145,148,151,153
.byte 156,158,160,162,164,166
.byte 168,169,171,172,173,175
.byte 176,177,177,178,179,179
.byte 180,180,180,180,180,180
.byte 179,179,179,178,177,176
.byte 176,175,174,173,171,170
.byte 169,167,166,165,163,161
.byte 160,158,157,155,153,152
.byte 150,148,146,145,143,141
.byte 140,138,136,135,133,132
.byte 130,129,127,126,125,124
.byte 123,121,120,120,119,118
.byte 117,116,116,115,115,114
.byte 114,114,114,114,114,114
.byte 114,114,114,115,115,116
.byte 116,117,117,118,119,119
.byte 120,121,122,123,124,125
.byte 126,127,128,129,130,131
.byte 132,133,134,134,135,136
.byte 137,138,139,139,140,141
.byte 141,142,142,143,143,143
.byte 144,144,144,144,144,143
.byte 143,143,142,142,141,140
.byte 140,139,138,137,136,134
.byte 133,132,130,129,127,125
.byte 124,122,120,118,116,114
.byte 112,110,108,105,103,101
.byte 99,96,94,92,89,87
.byte 84,82,80,77,75,73
.byte 71,68,66,64,62,60
.byte 58,56,54,52,51,49
.byte 48,46,45,44,42,41
.byte 40,39,39,38,37,37
.byte 37,36,36,36,36,37
.byte 37,37,38,39,39,40
.byte 41,42,44,45,46,48
.byte 49,51,53,55,56,58
.byte 60,63,65,67,69,71
.byte 74,76,79,81,83,86
.byte 88,91,93,96,98,101
.byte 103,105,108,110,112,115
.byte 117,119,121,123,125,127
.byte 128,130,132,133,135,136
.byte 137,138,139,140,141,142
.byte 142,143,143,143,144,144
.byte 144,143,143,143,142,142
.byte 141,140,139,138,137,136
.byte 134,133,131,130,128,126
.byte 125,123,121,119,117,115
.byte 112,110,108,106,103,101
.byte 99,96,94,92,89,87
.byte 85,82,80,78,75,73
.byte 71,69,67,65,63,61
.byte 59,57

.pc=* "Sinus table (Size)"
upsizesin: 
.fill 256,floor(100+80*sin(2*PI*i/256)) //60

.pc=* "Sinus table (Twister)"
sintablestr: 
.fill 256,floor(90+70*sin(2*PI*i/256))

.pc=* "Scene storyboard"
.import source "story.asm"

.pc=maploader "Texture map"
.import binary "Textures\texture.bin"
	