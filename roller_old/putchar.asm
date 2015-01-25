// Worst case: 441 cycles (Buffer+Char+Sprite)
// Best case: 117 (Buffer)

putchar:
	// *******************
	// Save buffer (79)
	// *******************		
	
	sta savechar
	sty savey
	stx savex
	
	lda bfrltbl,y	
	sta ptrmisc1	
	sta ptrmisc2
	sta ptrmisc3	
	lda bfrhtbl,y
	sta ptrmisc1+1	// ptrmisc1 <= [bfrltbl+64*y] (single char table)
	clc
	adc #>[bufferlo-buffer]	
	sta ptrmisc2+1	// ptrmisc2 <= [bfrlotbl+64*y] (Low byte of address to char)	
	adc #>[bufferhi-bufferlo]
	sta ptrmisc3+1	// ptrmisc3 <= [bfrlotbl+64*y] (High byte of address to char)		
	lax savechar	
	ldy savex	
	sta (ptrmisc1),y
	lda chartablelo,x	
	sta ptrmisc1
	sta (ptrmisc2),y
	lda chartablehi,x	
	sta ptrmisc1+1
	sta (ptrmisc3),y	

	// *************
	// Screen update
	// *************
	// - Nothing: 27+5+6 -> 38
	// - Sprite only: 27+5+3 -> 35		(+sprite routine)
	// - Screen only: 26+23+5+6 -> 60
	// - Screen+sprite: 26+23+5+3 -> 57 (+sprite routine)
	
	tya			// Carry clear (Last add never overflows)
	adc #$29		// +28+1 (Carry clear)
	sbc rightpos	// -rightpost-1 => +28-rightpost
	and #$3f
	tay	
	ldx savey
	lda comparetable,y	
	asl
	sta skipscreen+2
	bcc skipscreen
	lda scnltbl,x
	sta ptrmisc3
	lda scnhtbl,x
	sta ptrmisc3+1
	lda savechar
	sta (ptrmisc3),y
skipscreen:	
	sec
	bcs *
exexit:
	rts
.byte $00
	jmp sprcheckleft	
.byte $00
	jmp sprcheckright

// **************************************
// Write to right sprite (17+24*8+11*8+8) =>305
// ************************************** 
	
sprcheckright:
	tya
	sbc #$24	
	lsr
	ror
	ora kindmove
	rol
	rol	// Carry cleared (acc value between 0/7)
	tay		
	lda rightlospr,y
	adc spritelo+25*0,x
	sta rightspr1+1
	lda righthispr,y
	adc spritehi+25*0,x
	sta rightspr1+2
	lda rightlospr,y
	adc spritelo+25*1,x
	sta rightspr2+1
	lda righthispr,y
	adc spritehi+25*1,x
	sta rightspr2+2			
	lda rightlospr,y
	adc spritelo+25*2,x
	sta rightspr3+1
	lda righthispr,y
	adc spritehi+25*2,x
	sta rightspr3+2		
	lda rightlospr,y
	adc spritelo+25*3,x
	sta rightspr4+1
	lda righthispr,y
	adc spritehi+25*3,x
	sta rightspr4+2			
	lda rightlospr,y
	adc spritelo+25*4,x
	sta rightspr5+1
	lda righthispr,y
	adc spritehi+25*4,x
	sta rightspr5+2		
	lda rightlospr,y
	adc spritelo+25*5,x
	sta rightspr6+1
	lda righthispr,y
	adc spritehi+25*5,x
	sta rightspr6+2			
	lda rightlospr,y
	adc spritelo+25*6,x
	sta rightspr7+1
	lda righthispr,y
	adc spritehi+25*6,x
	sta rightspr7+2		
	lda rightlospr,y
	adc spritelo+25*7,x
	sta rightspr8+1
	lda righthispr,y
	adc spritehi+25*7,x
	sta rightspr8+2		

copytosprite:	
	ldy #$00
	lda (ptrmisc1),y
rightspr1:
	sta $ffff
	iny
	lda (ptrmisc1),y
rightspr2:
	sta $ffff
	iny	
	lda (ptrmisc1),y
rightspr3:
	sta $ffff
	iny
	lda (ptrmisc1),y
rightspr4:
	sta $ffff
	iny		
	lda (ptrmisc1),y
rightspr5:
	sta $ffff
	iny
	lda (ptrmisc1),y
rightspr6:
	sta $ffff
	iny	
	lda (ptrmisc1),y
rightspr7:
	sta $ffff
	iny
	lda (ptrmisc1),y
rightspr8:
	sta $ffff
	rts
	
// **************************************
// Write to left sprite (17+24*8+11*8+8) =>305
// ************************************** 	
	
sprcheckleft:	
	tya
	adc #$03	//Carry set => +4
	alr #$07
	ror
	ora kindmove
	rol
	rol	// Carry cleared (and #$07)
	tay		
	lda leftlospr,y
	adc spritelo+25*0,x
	sta rightspr1+1
	lda lefthispr,y	
	adc spritehi+25*0,x
	sta rightspr1+2		
	lda leftlospr,y
	adc spritelo+25*1,x
	sta rightspr2+1
	lda lefthispr,y
	adc spritehi+25*1,x
	sta rightspr2+2			
	lda leftlospr,y
	adc spritelo+25*2,x
	sta rightspr3+1
	lda lefthispr,y
	adc spritehi+25*2,x
	sta rightspr3+2		
	lda leftlospr,y
	adc spritelo+25*3,x
	sta rightspr4+1
	lda lefthispr,y
	adc spritehi+25*3,x
	sta rightspr4+2			
	lda leftlospr,y
	adc spritelo+25*4,x
	sta rightspr5+1
	lda lefthispr,y
	adc spritehi+25*4,x
	sta rightspr5+2		
	lda leftlospr,y
	adc spritelo+25*5,x
	sta rightspr6+1
	lda lefthispr,y
	adc spritehi+25*5,x
	sta rightspr6+2			
	lda leftlospr,y
	adc spritelo+25*6,x
	sta rightspr7+1
	lda lefthispr,y
	adc spritehi+25*6,x
	sta rightspr7+2		
	lda leftlospr,y
	adc spritelo+25*7,x
	sta rightspr8+1
	lda lefthispr,y
	adc spritehi+25*7,x
	sta rightspr8+2		
	jmp copytosprite

// Sprite update table LEFT
// ------------------------

leftlospr:
.byte	<[spriteLL1+1],<[spriteLL1+2],<[spriteL1+0],<[spriteL1+1],<[spriteL1+2],<[spriteLL1+0],0,0
.byte	<[spriteLL1+0],<[spriteLL1+1],<[spriteLL1+2],<[spriteL1+0],<[spriteL1+1],<[spriteL1+2],0,0
.byte	<[spriteL1+2],<[spriteLL1+0],<[spriteLL1+1],<[spriteLL1+2],<[spriteL1+0],<[spriteL1+1],0,0
.byte	<[spriteL1+1],<[spriteL1+2],<[spriteLL1+0],<[spriteLL1+1],<[spriteLL1+2],<[spriteL1+0],0,0
.byte	<[spriteL1+0],<[spriteL1+1],<[spriteL1+2],<[spriteLL1+0],<[spriteLL1+1],<[spriteLL1+2],0,0
.byte	<[spriteLL1+2],<[spriteL1+0],<[spriteL1+1],<[spriteL1+2],<[spriteLL1+0],<[spriteLL1+1],0,0

lefthispr:
.byte	>[spriteLL1+1],>[spriteLL1+2],>[spriteL1+0],>[spriteL1+1],>[spriteL1+2],>[spriteLL1+0],0,0
.byte	>[spriteLL1+0],>[spriteLL1+1],>[spriteLL1+2],>[spriteL1+0],>[spriteL1+1],>[spriteL1+2],0,0
.byte	>[spriteL1+2],>[spriteLL1+0],>[spriteLL1+1],>[spriteLL1+2],>[spriteL1+0],>[spriteL1+1],0,0
.byte	>[spriteL1+1],>[spriteL1+2],>[spriteLL1+0],>[spriteLL1+1],>[spriteLL1+2],>[spriteL1+0],0,0
.byte	>[spriteL1+0],>[spriteL1+1],>[spriteL1+2],>[spriteLL1+0],>[spriteLL1+1],>[spriteLL1+2],0,0
.byte	>[spriteLL1+2],>[spriteL1+0],>[spriteL1+1],>[spriteL1+2],>[spriteLL1+0],>[spriteLL1+1],0,0

.align $0040

// Screen/sprites update lookup table
// ----------------------------------
comparetable:
.byte	$81,$81,$80,$80	// Mixed zone left
.byte	$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte	$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte	$80,$80,$83,$83	// Mixed zone right
.byte	$03,$03,$03,$03	// Border right
.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte	$01,$01,$01,$01	// Border left


// Char definition pointer table
// -----------------------------
	
.align $0040
.pc=* "Sprite includes"
	
// Sprite table
// ------------
	
spritelo:
.import c64 "sprtbll.bin"

scnltbl:
.byte <[charscreen2+$0000],<[charscreen2+$0028],<[charscreen2+$0050],<[charscreen2+$0078],<[charscreen2+$00a0],<[charscreen2+$00c8],<[charscreen2+$00f0]
.byte <[charscreen2+$0118],<[charscreen2+$0140],<[charscreen2+$0168],<[charscreen2+$0190],<[charscreen2+$01b8],<[charscreen2+$01e0],<[charscreen2+$0208]
.byte <[charscreen2+$0230],<[charscreen2+$0258],<[charscreen2+$0280],<[charscreen2+$02a8],<[charscreen2+$02d0],<[charscreen2+$02f8],<[charscreen2+$0320]
.byte <[charscreen2+$0348],<[charscreen2+$0370],<[charscreen2+$0398],<[charscreen2+$03c0]

scnhtbl:
.byte >[charscreen2+$0000],>[charscreen2+$0028],>[charscreen2+$0050],>[charscreen2+$0078],>[charscreen2+$00a0],>[charscreen2+$00c8],>[charscreen2+$00f0]
.byte >[charscreen2+$0118],>[charscreen2+$0140],>[charscreen2+$0168],>[charscreen2+$0190],>[charscreen2+$01b8],>[charscreen2+$01e0],>[charscreen2+$0208]
.byte >[charscreen2+$0230],>[charscreen2+$0258],>[charscreen2+$0280],>[charscreen2+$02a8],>[charscreen2+$02d0],>[charscreen2+$02f8],>[charscreen2+$0320]
.byte >[charscreen2+$0348],>[charscreen2+$0370],>[charscreen2+$0398],>[charscreen2+$03c0]

.align $0100
spritehi:
.import c64 "sprtblh.bin"

rightlospr:
.byte	0,0,<[spriteRR1+0],<[spriteRR1+1],<[spriteRR1+2],<[spriteR1+0],<[spriteR1+1],<[spriteR1+2]
.byte	0,0,<[spriteR1+2],<[spriteRR1+0],<[spriteRR1+1],<[spriteRR1+2],<[spriteR1+0],<[spriteR1+1]
.byte	0,0,<[spriteR1+1],<[spriteR1+2],<[spriteRR1+0],<[spriteRR1+1],<[spriteRR1+2],<[spriteR1+0]
.byte	0,0,<[spriteR1+0],<[spriteR1+1],<[spriteR1+2],<[spriteRR1+0],<[spriteRR1+1],<[spriteRR1+2]
.byte	0,0,<[spriteRR1+2],<[spriteR1+0],<[spriteR1+1],<[spriteR1+2],<[spriteRR1+0],<[spriteRR1+1]
.byte	0,0,<[spriteRR1+1],<[spriteRR1+2],<[spriteR1+0],<[spriteR1+1],<[spriteR1+2],<[spriteRR1+0]


.align $0040

// Sprite update table RIGHT
// -------------------------

righthispr:
.byte	0,0,>[spriteRR1+0],>[spriteRR1+1],>[spriteRR1+2],>[spriteR1+0],>[spriteR1+1],>[spriteR1+2]
.byte	0,0,>[spriteR1+2],>[spriteRR1+0],>[spriteRR1+1],>[spriteRR1+2],>[spriteR1+0],>[spriteR1+1]
.byte	0,0,>[spriteR1+1],>[spriteR1+2],>[spriteRR1+0],>[spriteRR1+1],>[spriteRR1+2],>[spriteR1+0]
.byte	0,0,>[spriteR1+0],>[spriteR1+1],>[spriteR1+2],>[spriteRR1+0],>[spriteRR1+1],>[spriteRR1+2]
.byte	0,0,>[spriteRR1+2],>[spriteR1+0],>[spriteR1+1],>[spriteR1+2],>[spriteRR1+0],>[spriteRR1+1]
.byte	0,0,>[spriteRR1+1],>[spriteRR1+2],>[spriteR1+0],>[spriteR1+1],>[spriteR1+2],>[spriteRR1+0]
