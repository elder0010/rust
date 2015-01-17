// Zero page
// *********
.var firstval	=	$e0
.var counter	=	$e1
.var slow		= 	$e2
.var shigh		=	$e3
.var low		= 	$e4
.var high		=	$e5
.var temp2		=	$e6
.var save1		=	$e7

// Number of tests
// ***************
.var number		=	$e0

sidtest:
	jsr detectsid	
	beq isemu
	cmp #$02
	beq is6581
	rts
is6581:
	lda #<string6581
	sta slow
	lda #>string6581
	sta shigh
	jmp effect
isemu:						// It's some kind of emulation (fastsid/ccs)
	lda #<stringemu
	sta slow
	lda #>stringemu
	sta shigh
effect:	
	jsr savestring
	lda $d800		// Whole screen character flash (To white)
	sta firstval
	lda #WHITE
	ldx #<colfiller
	ldy #>colfiller
	clc
	jsr fader	
	sta firstval
	lda #BLUE		// Whole screen character fade out
	ldx #<colfiller
	ldy #>colfiller
	sec
	jsr fader
	jsr printstring	// Print "Transparent" string	
	sta firstval	// Double rows character fade in (To white)
	lda #WHITE
	ldx #<msgfiller
	ldy #>msgfiller
	clc
	jsr fader			
!:
	jsr GetKeyJoy
	and #$ff
	beq !-
	bpl !-	
	eor #$80	
	cmp #$19
	beq fadeend
	cmp #$27
	beq fadecontinue
	cmp #$15
	bne !-
	jmp firestart	// Hidden scene!
fadecontinue:
	sei
	lda #$37
	sta $01
	jmp 64738
fadeend:		
	lda $d800+12*40	// Double rows character fade out
	sta firstval
	lda #BLUE
	ldx #<msgfiller
	ldy #>msgfiller
	sec
	jsr fader		
	jsr loadstring	// Reload saved rows
	lda $d800		// Whole screen character fade in
	sta firstval
	lda #LIGHT_BLUE
	ldx #<colfiller
	ldy #>colfiller
	clc
	jsr fader
	rts

// Wait retrace
// ************	
waitrt:
	bit $d011
	bmi waitrt
!:
	bit $d011
	bpl !-	
	rts
	
// Whole screen filler
// *******************
colfiller:
	ldx #$00		// 25*256
!:
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne !-
	rts
	
// Single line filler
// ******************	
msgfiller:
	ldx #79
!:
	sta $d800+12*40,x

	dex
	bpl !-
	rts	
	
// Single line filler
// ******************	
printstring:	
	ldy #00
	lda #<[$0400+12*40]
	sta low
	lda #>[$0400+12*40]
	sta high
!:
	lda (slow),y
	beq psexit
	cmp #$ff
	beq psnextline
	sta (low),y
pscont:
	iny
	jmp !-
psnextline:
	tya
	sta temp2
	lda #39
	sbc temp2
	clc
	adc low	
	sta low
	bcc pscont
	inc high
	jmp pscont
psexit:
	rts		

	
// *********************	
// Generic Fader routine
// *********************
// Carry: 0 To white, 1 to black
// A: Exit value
// X: <update routine
// Y: >update routine
// firstval: first value
fader:				// Fade out whole screen
	stx fadejmp+1
	sty fadejmp+2
	sta fadecmp+1
	ldx #<fadetowhite
	ldy #>fadetowhite
	bcc fadecommon
	ldx #<fadetoblack
	ldy #>fadetoblack	
fadecommon:
	stx fadedir+1
	sty fadedir+2
	lda firstval
fadeloop:
	jsr waitrt	
	and #$0f
	tax
fadedir:
	lda fadetowhite,x	
fadejmp:
	jsr colfiller
fadecmp:
	cmp #WHITE
	bne fadeloop
	rts
	
// Single line saver
// *****************	
savestring:	
	ldx #79
!:
	lda $0400+12*40,x
	sta savedata,x
	dex
	bpl !-
	rts			
	
// Single line saver
// *****************	
loadstring:	
	ldx #79
!:	
	lda savedata,x
	sta $0400+12*40,x
	dex
	bpl !-
	rts				
	
// Test SID by evaluating osc3 delay
// *********************************	
detectsid:
	sei	
	lda #$00
	ldx #$18
!:
	sta $d400,x
	dex
	bne !-
	jsr waitrt
	lda #$ff
	sta $d40e	// 4
	sta $d40f	// 4
	ldx #<number
	stx counter
	ldy #$00
	tya
dsloop:		
	clc
	ldx #$ff	// 2
	stx $d412	// 4
	ldx	#$20	// 2
	stx $d412	// 4	
	adc $d41b	// 4		
	bcc nohi	// 2 6/3
	iny			// 2	
nohi:	
	dec counter	// 5
	bne dsloop	// 3 - 30/31	
	cli
	ldx #$02
	cpy #>[2*number]
	bne test6581
	cmp #<[2*number]
	beq sid8580
test6581:	
	cpy #>[3*number]
	bne sidemu
	cmp #<[3*number]
	beq sid6581
sidemu:				// A=2
	dex	
sid8580:			// A=1
	dex	
sid6581:			// A=0
	txa
	rts

		

.var towhite=List()
.eval towhite.add($06,$01,$0b,$0f,$08,$0a,$09,$0d,$0e,$02,$03,$04,$05,$01,$0c,$07)
.var toblack=List()
.eval toblack.add($00,$0d,$09,$0a,$0b,$0c,$00,$0f,$04,$06,$05,$02,$0e,$07,$08,$03)
fadetoblack:
.for(var i=0;i<16;i++) 
	.byte	toblack.get(i)
fadetowhite:
.for(var i=0;i<16;i++) 
	.byte	towhite.get(i)		

string6581:
.text "     this demo requires a sid 8580"
.byte $ff
.text "  do you want to continue anyway? (y/n)"
.byte $00	
stringemu:
.text "   please check that your emulator is"
.byte $ff
.text "using sid 8580 and press <y> to continue"
.byte $00	

savedata:	