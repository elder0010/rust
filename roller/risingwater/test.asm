.pc=$2000
test:
	sei
	lda #$7f
	sta $dc0d
	sta $dd0d	
	lda $dc0d
	lda $dd0d
	lda #$f9
	sta $d012
	lda $d011
	and #$7f
	sta $d011
	lda #$35
	sta $01
	lda #<irq
	sta $fffe
	lda #>irq
	sta $ffff
	lda #$01
	sta $3fff
	lda #$01
	sta $d01a
	lsr $d019
	lda #$00
	sta $d001
	lda #$90
	sta $d000
	lda #$01
	sta $d015
	cli
	jmp *
	
irq:
	pha
	lsr $d019
	lda $d012
	cmp #$35
	bne !+ 
	lda #$18
	sta $d011
	lda #$f9
	sta $d012
	lda #$00
	sta $d020
	jmp irqexit	
!:
	cmp #$f9
	bne !+ 
	lda #$00
	sta $d011
	lda #$00
	sta $d012
	jmp irqexit
!:		
	lda $3fff
	cmp #$80
	rol
	sta $3fff
	lda #$35
	sta $d012
	lda #$01
	sta $d020
	inc $d001
irqexit:
	pla
	rti
	