.const	zp=$10
.const	irq=zp+4
.const	flag=$1f
.const	initloader=$0e8c

// Scene/Load manager

.pc=$840
	sei
	lda #<fakeirq
	sta $fffe
	sta irq
	lda #>fakeirq
	sta $ffff
	sta irq+1
	lda #<kernirq
	sta $0314
	lda #>kernirq
	sta $0315	
	lda #$7f
	sta $dd0d
	sta $dc0d
	lda $dc0d	
	lda $dd0d
	jsr initloader
nextcommand:
	lda #$00
	sta zp
	ldy sbposition
	lda sbposition+1
	sta zp+1
	lda (zp),y
	sta command
	inc sbposition
	bne !+
	inc sbposition+1
!:	
	tsx
	stx savestack
	asl command
	bcc skipjump		// JUMP
	jmp cmdjump
skipjump:	
	asl command
	bcc skipload		// LOAD (no flags)
	jmp cmdload
skipload:	
	asl command
	bcc skipcall		// CALL to SUBROUTINE
	jmp cmdcall
skipcall:
	asl command
	bcc skipldst		// LOAD (with flags)
	jmp cmdcall	
skipldst:
	jmp nextcommand

// Jump for subroutine
// *******************	
	
subjmp:
	jmp (zp+2)

// ************
// * COMMANDS *
// ************

// JUMP
// ----

cmdjump:
	jsr getjmpaddr
	ldx #<retadd
	ldy #>retadd		
	lda #$35
	sta $01
	jmp (zp+2)
retadd:	
	sei
	ldx savestack
	txs
	lda irq
	sta $fffe
	lda irq+1
	sta $ffff
	cli
	jmp skipjump

// LOAD
// ----

cmdload:
    ldx filename
	ldy filename+1	
	jsr load
	jsr nextfile
	jmp skipload
	
// CALL
// ----
	
cmdcall:
	jsr getjmpaddr
	ldx #<stopirqroutine
	ldy #>stopirqroutine
	lda #$35
	sta $01
	jsr subjmp
	cli
	jmp skipcall
	
// LOAD (w/ flags)
// ---------------

cmdldst:
	sei	
	lda #$01
	sta flag
	cli
    ldx filename
	ldy filename+1	
	jsr load
	jsr nextfile
	sei
	eor #$41
	ora flag
	sta flag
	cli
!:
	lda flag
	bmi !-	
	jmp skipldst
	
// Jump for subroutine
// *******************	
	
stopirqroutine:
	pha
	lda #$00
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	lda irq
	sta $fffe
	lda irq+1
	sta $ffff
	pla	
	rti
	
// Get nextjump address
// ********************
	
getjmpaddr:
	ldy jtposition 
	lda jtposition+1
	sta zp+1
	lda (zp),y
	sta zp+2
	iny
	lda (zp),y
	sta zp+3
	clc
	lda jtposition
	adc #$02
	sta jtposition
	lda jtposition+1
	adc #$00
	sta jtposition+1	
	rts
	
// Get next file name
// ******************
	
nextfile:	
	lda #$00
	sta zp
	ldy filename
	lda filename+1	
	sta zp+1	
	clc
nfloop:
	bcs nffound
	lda (zp),y
	bne !+
	sec
!:	
	iny	
	bne nfloop
	inc zp+1
	bne nfloop
nffound:
	sty filename
	lda zp+1
	sta filename+1
	rts

waitjump:
	jmp *	
	
// Start SID
// *********	

sidplayer:
	stx spret+1
	sty spret+2
	jsr $1000
	lda #<sidirq
	sta irq	
	lda #>sidirq
	sta irq+1
spret:
	jmp $0000

// SID IRQ player
// **************	

sidirq:
	pha
	txa
	pha
	tya
	pha
	lsr $d019
	jsr $1003
	pla
	tay
	pla
	tax
	pla
	rti
	

// Fake IRQ handler
// ****************

fakeirq:	
	lsr $d019
	rti

// ***************
// $0314/$0315 IRQ
// ***************

kernirq:
	lda $01
	pha
	lda #$35
	sta $01
	brk
	nop	
	pla
	sta $01
	pla
	tay
	pla
	tax
	pla
	rti
	
// Generic variables
// -----------------

.print "Variable position:"+toHexString(*)	

filename:
.byte	<loadtable,>loadtable
	
sbposition:
.byte	<commandlist,>commandlist

jtposition:
.byte	<jumptable,>jumptable

command:
.byte	$00

savestack:
.byte	$00

.import source "conf.asm"

.pc=2730
load:
.import c64 "loader.prg"

// Configuration macros
// ********************

.macro addr(y) {
.byte	<y,>y
}
.pc=$1000
.import c64 "check.prg"