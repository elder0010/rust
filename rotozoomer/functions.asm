//;--------------------------------------
//;------RUST COMMON MACROS
//;--------------------------------------


.macro clear_screen(screen){
		ldx #0
		lda #blank_char
!:
		sta screen,x
		sta screen+$100,x
		sta screen+$200,x
		sta screen+$300,x
		dex
		bne !-
}


//;Per cambiare bank
.macro bank_0(){
	lda $DD00
	and #%11111100
	ora #%00000011
	sta $DD00
}

.macro bank_1(){
	lda $DD00
	and #%11111100
	ora #%00000010
	sta $DD00
}

.macro bank_2(){
	lda $DD00
	and #%11111100
	ora #%00000001
	sta $DD00
}

.macro bank_3(){
	lda $DD00
	and #%11111100
	ora #%00000000
	sta $DD00
}

//;--------------------------
.macro open_irq(){
	pha txa pha tya pha
}

.macro close_irq(){
	pla tay pla tax pla
}

.macro turn_off_cia_turn_on_raster_irq(){
		lda #$7f
		ldx #$01
		sta $dc0d    
		sta $dd0d 
		stx $d01a    

		lda $dc0d    
		lda $dd0d   
		asl $d019    
}

.macro kill_nmi(){
		lda #<nmi sta $fffa
		lda #>nmi sta $fffb
		jmp !+
		
nmi:
		rti
!:
}

//;--------------------------
.macro kernal_off(){
		lda #$35
		sta $01
}

.macro kernal_on(){
		lda #$35
		sta $01
}
//;------------------------

.macro wait(){
!:
		dey
		bne !-
}