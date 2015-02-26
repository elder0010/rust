// Constants
// *********
.const	raster	=	$2f
.const	t8lines	=	63*312-1

// NMI handler
// ***********
.pc=$4c4c
	bit $ea
	nop		
	
	sta irqsaveacc		// 3
	jmp mainirq			// 3

// ******************
// Activation routine
// ******************
stabletimer:		
	lda #<stablefstirq
	ldx #>stablefstirq
	sta $fffe
	stx $ffff	
	lda #$01
	sta $d01a
	lda #raster	
	sta $d012
	lda #$1b
	sta $d011
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda $dc0d
	lda $dd0d
	lsr $d019		
	rts

irqback:
.byte $00,$00	// Save original IRQ handler
	
.pc=$4cba
.byte $4f,$4c,$4e,$4c,$4d,$4c,$4c

// $4c4f - no jitter
// $4e4c - 1
// $4c4e - 2
// $4d4c - 3
// $4c4d - 4
// $4c4c - 5

// Negate buffer
// -------------
negatebuffer:
	lda #$31
	sta $01
	ldx #$00
nbloop:	
	.for(var i=0;i<8;i++) {
		lda $d000+$100*i,x
		eor #$ff
		sta charrom+$0100*i,x
	}
	.for(var i=0;i<4;i++) {
		lda $0400+$100*i,x
		sta charscreen2+$0100*i,x
	}	
	dex
	bne nbloop
	lda #$35	
	sta $01		
	rts
.print "Fragmented code 3: " + toHexString(negatebuffer) + " - " + toHexString(*)


.pc=$4d4c		
	jmp $4c4f	
	
// ************************************************************************
// Double IRQ routine
.pc=*	"Double raster stab - First IRQ" 
stablefstirq:
	stx sisavex+1
	sta sisavea+1
	lda #<stablesecirq
	sta $fffe
	lsr $d019
	inc $d012
	cli
	tsx
	.fill 15,NOP		
	brk

	
.pc=*	"Double raster stab - 2nd IRQ"
stablesecirq:
	lda #<$dc05		// Set NMI handler
	sta $fffe
	lda #>$dc05
	sta $ffff			
	lsr $d019		// IRQ Acknowledge
	lda #$00		// Reset timer A and B
	sta $dc0e
	sta $dc0f
	lda #<t8lines
	sta $dc06
	lda #>t8lines
	sta $dc07		
	nop
	nop
	nop
	lda #raster+1
	txs				// Reload correct stack pointer
	cmp $d012		//4 - 63+0/1
	beq synced		//2/3
synced:		
	bit $ea	
	lda #$6c
	sta $dc05		
	nop
	lda #$91
	sta $dc0f
	lda #$00
	sta $d01a	
	lda #$82
	sta $dc0d		
	lda $dc0d
	lda #RTI
    sta $dc0c	
sisavex:
	ldx #$00
sisavea:
	lda #$00	
	rti

	
// SetBufTbl
// ----------
setbuftbl:
	lda #<[buffer] //+$3f*$40]
	ldy #>[buffer] //+$3f*$40]
	ldx #$00
sbtloop:		
	sta bfrltbl,x
	clc
	adc #$40	
	sta sbtval+1
	tya
	sta bfrhtbl,x		
	bcc !+
	iny
!:
sbtval:
	lda #$00
	inx
	cpx #$40
	bne sbtloop
	rts	
	
	
.pc=$4e4c	
	sta.a irqsaveacc		// 4
	jmp mainirq
	
	