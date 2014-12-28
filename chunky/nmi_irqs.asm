//;-------------------------------------------------------------------------
//; NMI PER IL VECCHIO CIA
//;-------------------------------------------------------------------------
.align $100
nmiirq_old_cia:
//;-------------------------------------------------------------------------
//; Stabilize the raster
//;-------------------------------------------------------------------------
	sta reg_a + 1
	
	//;nop //;Wasto un altro ciclo
	
	lda $dd04
	eor #$e7
	sta time_6 + 1

time_6:	
	bpl *
	cmp #$c9
	cmp #$c9
	cmp #$24
	nop

//;-------------------------------------------------------------------------
//; Stable raster here, create badline for fli and restore to next badline
//;-------------------------------------------------------------------------
_p_1:	
	lda #$91
	sta $d018
	lda #$3f
d10:
	sta $d011
	bit $24
	
	
_p_2:
	lda #$81
	sta $d018
	lda #$3b
d11:
	sta $d011
	
//;-------------------------------------------------------------------------
//; Trigger new NMI, restore A and return from IRQ here
//;-------------------------------------------------------------------------
	lda $dd0d
reg_a:	
	lda #0 //;questo non dovrebbe essere come ho cambiato io ?
//;	lda reg_a + 1

	rti
	
	
//;-------------------------------------------------------------------------
//; NMI PER IL VECCHIO CIA
//;-------------------------------------------------------------------------
.align $100
nmiirq_new_cia:
//;-------------------------------------------------------------------------
//; Stabilize the raster
//;-------------------------------------------------------------------------
	sta reg_a_new + 1
	
	nop //;Wasto un altro ciclo
	
	lda $dd04
	eor #$e7
	sta time_6_new + 1

time_6_new:	
	bpl *
	cmp #$c9
	cmp #$c9
	cmp #$24
	nop

//;-------------------------------------------------------------------------
//; Stable raster here, create badline for fli and restore to next badline
//;-------------------------------------------------------------------------
_p_1_new:	
	lda #$91
	sta $d018
	lda #$3f
d12:
	sta $d011
_p_2_new:
	lda #$81
	sta $d018
	lda #$3b
d13:
	sta $d011
//;	inc $d020
//;-------------------------------------------------------------------------
//; Trigger new NMI, restore A and return from IRQ here
//;-------------------------------------------------------------------------
	lda $dd0d
reg_a_new:	
	lda #0 //;questo non dovrebbe essere come ho cambiato io ?
//;	lda reg_a_new + 1
	rti
	

final_fade:

		ldx fade_tb_pt_out
		lda fade_tb_outro,x
		ldy #7
!:
		sta tab_colori_0,y
		dey
		bpl !-
		rts
		
inc_fade_ptr:
		inc fade_tb_pt_out
		lda fade_tb_pt_out
		cmp #6
		bne !+

		lda #>end_scene
		sta out_x+2
		lda #<end_scene
		sta out_x+1

		inc skpx+1
!:
		rts
		
.align $4
fade_tb_outro:
.byte $dd,$33,$ee,$44,$66


fade_tb_pt_out:
.byte $0