.const	screen	=	$c000
.const	spronvic=	$c500
.const	screen2	=	$b800
.const	charmap	=	$c800
.var	change	=	$a700
.var	adapt	=	$a600

.const	test	=	$fe
.const 	draw	=	$fd


firestart:
	jsr resetmemory
	jsr buildchg
	jsr initio
	jsr initirq
	jmp *

	
// Init IRQ handlers
// *****************	
initirq:
	sei
	lda #<fireirq
	sta $fffe
	lda #>fireirq
	sta $ffff
	lda #$01
	sta $d01a
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda $dc0d
	lda $dd0d
	lda #$35
	sta $01	
	lda #$00
	sta $d012
	lda #$1b	
	sta $d011
	lsr $d019
	cli
	rts	
	
// Init I/O ($d41b and screen)	
// ***************************
initio:
	lda #$00
	sta $d418
	lda #$ff
	sta $d40e
	sta $d40f
	lda #$80
	sta $d412	
	lsr $d019
	lda #$00
	sta $d020
	sta $d021	
	lda $dd00
	and #$fc
	ora #[3-floor(screen/$4000)]
	sta $dd00
	lda #[[screen&$3fff]/$040]|[[charmap&$3fff]/$0400]
	sta $d018
	ldx #<floor([spronvic&$3fff]/$40)
	stx screen+$3f8
	inx
	stx screen+$3f9
	inx
	stx screen+$3fa	
	lda #$07
	sta $d015
	clc
	lda #$18+[[320-24*3]/2]
	sta $d000
	adc #$18
	sta $d002
	adc #$18
	sta $d004
	lda #$80
	sta $d001
	sta $d003
	sta $d005
	lda #$07
	sta $d01b
	lda #WHITE
	sta $d027
	sta $d028
	sta $d029
	rts	
	
// Initialize screen & color memory
// ********************************
resetmemory:
	lda #$00
	tax
!:
	lda #$00
	sta screen,x
	sta screen+$100,x
	sta screen+$200,x
	sta screen+$300,x
	lda #RED
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x		
	lda sprites,x
	sta spronvic,x
	dex
	bne !-	
	ldx #39
	lda #$00
!:
	sta $d800+24*40,x	
	dex
	bpl !-
	ldx #[4*8-1]
!:
	txa
	and #$01
	tay	
	lda #$00
	sta charmap,x
	lda dither1,y
	sta charmap+$20,x	
	lda dither2,y
	sta charmap+$40,x
	sta charmap+$60,x
	lda dither3,y
	sta charmap+$80,x
	sta charmap+$a0,x		
	lda #$ff
	sta charmap+$c0,x
	sta charmap+$e0,x		
	sta charmap+$100,x
	sta charmap+$120,x			
	sta charmap+$140,x
	sta charmap+$160,x			
	sta charmap+$180,x
	sta charmap+$1a0,x			
	sta charmap+$1c0,x
	sta charmap+$1e0,x			
	dex
	bpl !-	
	rts	

dither1:
.byte $88,$22
dither2:
.byte $aa,$55
dither3:
.byte $bb,$dd


// IRQ handler
// ***********
fireirq:	
	jsr rnd
	jsr fire	
!:
	lsr $d019	
	rti

	
// Main fire effect
// ****************
fire:
 .for(var y=5;y<25;y++)
  {  
	lda screen+y*40+39
	asl
	tax
	lda change,x 
	sta screen+[y-1]*40+39
	ldy #38
!:
	lda screen+y*40,y
	asl
	adc screen+y*40-1,y
	adc screen+y*40+1,y
	tax
	lda change,x 
	sta screen+[y-1]*40,y
	dey
	bne !-
	lda screen+y*40
	asl
	tax
	lda change,x 
	sta screen+[y-1]*40	
   }   
 rts

 
// Generate random values
// **********************
rnd:
	ldx test	
	ldy #39
!:
	ldx $d41b
	lda adapt,x	
	sta screen+[24*40],y
	inx
	dey
	bpl !- 
	stx test
	rts
	
	
// Build change
// ************	
buildchg:			// Build change table
	ldx #$00
bcloop:
	txa
	sec
	sbc #$04
	bcs !+
	lda #$00
!: 
    lsr
	lsr
	sta change,x
	dex
	bne bcloop
	ldx #$00		// Build adapt table
	ldy #$00
baloop:	
	clc
	adc #$38
	bcc bastore
	inx	
bastore:
	stx adapt
	inc bastore+1	
	bne baloop
	rts	

// Sprites
sprites:	
.import binary "sprites.raw"	