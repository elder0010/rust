:BasicUpstart2($1000)

.var 	map=$c000

.pc=$1000	
	sei
	lda #$7f
	sta $dd0d
	bit $dd0d
	ldx #$35
	stx $01
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
	nop	//sei	
	dec $01
savetx:
	sta $ffff,y	
	stx $01	
	nop	//cli	
	inc loadtx+2
	dey	
	bpl loadtx	
	clc
	lda savetx+1
	adc #$40
	sta savetx+1
	lda savetx+2
	adc #$00
	sta savetx+2
	inc loadtx+1
	bne loop
	lda #$37
	sta $01
	cli
	rts
		
.pc=$8000
maploader:
.import binary "texture2.bin"
