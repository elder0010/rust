colour_fill:
		
		//;Diciamo che devo fillare una linea
		ldx #48
		
another_line:	
	
		
fill_bf_src_lo:
		lda targetLowBuffer1,x
		sta drw+1
		sta drw_1+1

		sta minl+1
		sta maxl+1
		sta stormin+1
		sta stormax+1
	
		
fill_bf_src_hi:
		lda targetHiBuffer1,x
		sta drw+2
		sta drw_1+2

		sta minl+2
		sta maxl+2
		sta stormax+2
		sta stormin+2
	
		lda min_x_a_1,x
		cmp #$ff
		bne !+
		jmp skip_line
!:	
		

		cmp max_x_a_1,x
		bcc !+
		jmp skip_line
!:

		sta line_start+1
		
		
		
fill_max_bf_1:
		lda max_x_a_1,x
		sta line_end+1
		
		//;Mi appunto come inizia e finisce la linea prima di disegnarla
fill_min_bf_3:
		ldy min_x_a_1,x
	
minl:
		lda $ffff,y
		sta 07
		and #$0f
		bne !+
		lda 07
fill_col_sx_1:
		ora #$04
		sta 07
		jmp A1
!:	
		lda 07
		and #$0f
fill_col_sx_2:
		ora #$40
		sta 07
A1:		


fill_max_bf_3:		
		
		ldy max_x_a_1,x
maxl:
		lda $ffff,y
		sta 08
		and #$f0
		bne !+
		lda 08
		and #$f0
fill_col_dx_1:
		ora #$04
		sta 08

		jmp AO
!:	
		lda 08
		and #$f0
fill_col_dx_2:
		ora #$04
		sta 08
AO:		


		//;e vai col drawing
fill_col_all_1:
		lda #$44
line_start:		
		ldy #0		
drw:
		sta $ffff,y
		iny
drw_1:		
		sta $ffff,y
		iny

		
line_end:
		cpy #0
		bmi drw

	
//;Adesso devo ritoccare il max e il min		
		ldy line_start+1
		lda 07
stormin:
		sta $ffff,y



		ldy line_end+1
		lda 08
	
stormax:
		sta $ffff,y
	
skip_line:	
		dex
		beq !+
		jmp another_line
!:

		
		rts


//;CLEAN DELLO SCHERMO
.pc = $7000
colour_clean_b:
		

		lda #bg_colour
		
.for (var i = 1 ; i <= 18;i++) {
		.for (var y = 9 ; y< 34;y++) {
			sta getLineAddresses($6800,i)+y
		}
}		

.for (var i = 19; i <= 34;i++) {
		.for (var y = 8 ; y< 14;y++) {
			sta getLineAddresses($6800,i)+y
		}
		
		.for (var y = 26 ; y< 33;y++) {
			sta getLineAddresses($6800,i)+y
		}
}

.for (var i = 35 ; i <= 49;i++) {
		.for (var y = 9 ; y< 34;y++) {
			sta getLineAddresses($6800,i)+y
		}
}
		rts

.pc = $a000
colour_clean_a:
		

another_line_c:	
	

		
		lda #bg_colour
		
.for (var i = 1 ; i <= 18;i++) {
		.for (var y = 9 ; y< 34;y++) {
			sta getLineAddresses($6000,i)+y
		}
}		

.for (var i = 19; i <= 34;i++) {
			.for (var y = 8 ; y< 14;y++) {
			sta getLineAddresses($6000,i)+y
		}
		
		.for (var y = 26 ; y< 33;y++) {
			sta getLineAddresses($6000,i)+y
		}
}

.for (var i = 35 ; i <= 49;i++) {
		.for (var y = 9 ; y< 34;y++) {
			sta getLineAddresses($6000,i)+y
		}
}

		rts


//;-------------------------------------------------------------------------
//; Buffer per fillare le linee
//;-------------------------------------------------------------------------
.pc = $c700 "colour fill buffers"
.pc = * "MIN A"
min_x_a_1:
.fill 50,$ff

.align 50
.pc = $c800
.pc = * "MAX X A"
max_x_a_1:
.fill 50,0


.align $100
min_x_b_1:
.fill 50,$ff

.align $100
max_x_b_1:
.fill 50,0

clean_buffer:
				//;Pulisco i max / min buffer
		lda #$ff

		.var t
		
		.for(t=1;t<=48;t++){
			sta min_x_a_1+t
		}

		
		lda #0
		
		.for(t=1;t<=48;t++){
			sta max_x_a_1+t
		}
		
		rts
		