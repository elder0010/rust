//;NMI init
.align $40
.pc = * "init nmi"
init_nmi:
//;punto irq 
		lda #$7f
		sta $dc0d
		sta $dd0d
		lda #0
		sta $dd0e

		lda #<nmi_bottom
		sta $fffa //; Set low IRQ adress in selected bank
		lda #>nmi_bottom
		sta $fffb //; Set high IRQ adress in selected bank
		
		lda #$81
		sta $dd0d

		lda $dd0e
		ora #%10011001
		and #%11110111
	//;	sta $dd0e //; count o2 pulses and forceload and continious and stop
		tax

.pc = * "init nmi timer"
		lda #$15
		sta $dd04

		lda #$4d
		sta $dd05
	
.var nmi_bmp_line = $fa
		//; aspetto per far partire il cia
waitrst:
		lda $d012
		cmp #nmi_bmp_line
		bne waitrst
		
		lda #$81
		sta $dd0d //; Activate CIA timer A irq

		.for(var b=0;b<2;b++){
			nop
		}
		stx $dd0e 
		bit $dd0d
		rts


	.align $40
//;--------------------------------------------------------------
.pc = * "nmi top"
nmi_top:
		sta $f0
		sty $f1
		lda $dd0d
		
	/*
;		//inc $d020
;.pc = * "nmi bottom timer"
;		lda #$c2
;		sta $dd04

;		lda #$3e
;		sta $dd05

;		lda $dd0e
;		ora #%10011001
;		and #%11110111
;		sta $dd0e
*/

		lda #<nmi_bottom
		sta $fffa //; Set low IRQ adress in selected bank

		lda #>nmi_bottom
		sta $fffb //; Set high IRQ adress in selected bank


		lda #$0
		sta $d015
		sta $dd0e
		
		//dec $d020

		ldy $f1
		lda $f0
		rti
//;--------------------------------------------------------------
.align $40
.pc = * "nmi bottom"
nmi_bottom:
		pha 
		bit $dd0d
.pc = * "nmi top timer"		
		lda #0
		sta $dd0e

		lda #$8a
		sta $dd04
		lda #$0d
		sta $dd05

		lda #$19
		sta $dd0e

		lda #<nmi_top
		sta $fffa //; Set low IRQ adress in selected bank
		lda #>nmi_top
		sta $fffb //; Set high IRQ adress in selected bank

		lda zp_del_male
		beq nmi_val
		pla
		and #$f7

		sta $d011
		rti		
nmi_val:	
		lda #$00
		and #$f7
		sta $d011


		pla
		rti
//;--------------------------------------------------------------