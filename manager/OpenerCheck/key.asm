//*********************************************************
// Routine for reading keyboard or joy port 1 independently
//*********************************************************
// $00  => No input
// $00-$1f	=> Joystick
// $80-$ff	=> Keyboard

.const	cia1pra		=	$dc00
.const	cia1prb		=	$dc01
.const	cia1ddra	=	$dc02
.const	cia1ddrb	=	$dc03

GetKeyJoy:
	lda #$7F
	sta GKJtemp
	ldy #$ff	
	sty cia1ddra	
	lda #$00
	sta cia1ddrb  
	sec
GKJreadcia:  
	ldx GKJtemp  	
	sty cia1pra
	lda cia1prb
	stx cia1pra
	ldx cia1prb
	sty cia1pra
	and cia1prb	
	eor #$ff
	bne GKJIsJoy
	txa
	eor #$ff
	bne GKJIsKey  
	ror GKJtemp	
	bcs GKJreadcia
GKJIsJoy:
	ldx #$00
	stx $dc00	
	and #$ff
	rts  
GKJIsKey: 
	lsr GKJtemp
	iny
	bcs GKJIsKey	
	sty GKJtemp
	asl GKJtemp
	asl GKJtemp
	asl GKJtemp	
	ldy #$ff
GKJFindKey:
	iny
	lsr
	bcc GKJFindKey
	tya
	ora GKJtemp
	eor #$80
	bne GKJIsJoy	