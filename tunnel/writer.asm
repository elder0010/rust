//;------------------------------------------------------------------
//;Prepara lo sprite da shrinkare - in x cè l'indice dello sprite 
//;Che sta per uscire dal tunnel
//;------------------------------------------------------------------
.var zp2 = ZP2

.var scroll_screen = $400
prepare_next_sprite:
		stx $a0
		sty $a1
		
		
		//;Aggiorno i puntatori dal buffer al set di 3 sprites
		lda sprite_target_1_lo,x
		sta TARGET_SPRT_0+1
		
		lda sprite_target_1_lo,x
		sta TARGET_SPRT_0+1
		
		lda sprite_target_2_lo,x
		sta TARGET_SPRT_2+1
		
		lda sprite_target_2_hi,x
		sta TARGET_SPRT_2+2
		
		lda sprite_target_3_lo,x
		sta TARGET_SPRT_3+1
		
		lda sprite_target_3_hi,x
		sta TARGET_SPRT_3+2
		
		lda #0
		sta buffer_area_pt
		
		jsr get_chars_to_print
		jsr prepare_char_addresses
		
		ldx #0
!:		lda chars_to_print,x
		jsr write_char
		inx
		
		cpx #4
		bne !-

end_write:
		ldx $a0
		ldy $a1
		rts


prepare_char_addresses:
		ldx #0
!:		
		lda #0
		sta zp2
		
		lda chars_to_print,x
		asl   //;    ; multiply A * 8 to get charset pointer
        rol zp2
        asl
        rol zp2
        asl
        rol zp2

        sta char_address_lo,x
		
		lda zp2
        clc          // ; now add charset base address
        adc #>$3800  //; lower/upper charset in chargen
        sta char_address_hi,x

		inx 
		cpx #4
		bne !-
		rts

write_char:
		stx xback
		
		lda char_address_lo,x
		sta source+1
		
		lda char_address_hi,x
		sta source+2
		
		lda buffer_area_address_lo,x //;Hi non serve, è sempre $04XX
		sta target+1
		
        ldy #0
        ldx #0
source:
        lda $ffff,y
			
.pc = * "TARGET"
target:
        sta buffer_area+1,x

		inx
		inx
		inx

        iny //;next row of the char
        cpy #8
        bne source
		
		ldx xback
		rts
		

//;Zone del buffer in cui scrivere: alto sx, basso sx, alto dx, basso dx
.align $4
//;Zone del buffer in cui scrivere: alto sx, basso sx, alto dx, basso dx
.align $100
buffer_area_address_lo:
.byte 00,24,1,25

buffer_area_address_hi:
.byte 09,09,09,09

.pc = * "Indirizzi chars"
char_address_lo:
.fill $4,0

char_address_hi:
.fill $4,0

buffer_area_pt:
.byte $90

current_char:
.byte $0

//;------------------------------------------------------------------
//;Restituisce i due caratteri da printare
//;------------------------------------------------------------------
get_chars_to_print:
txtPtr: 
	lda scroll_text
	bne noWrap
	inc zeroct+1
zeroct:
	lda #0
	cmp #1
	bne noWrap
	lda #0
	sta $d015
	:set_addr(fade_plasma_out,plasma_fade_out_fn)
	:set_addr(null_func,goshrt)
	:set_addr(null_func,func1)
	:set_addr(null_func,func2)
noWrap:
	ora scroll_charNo
	sta chars_to_print
	clc
	adc #$40	
	sta chars_to_print+1
	
	adc #$40
	sta chars_to_print+2
		
	adc #$40
	sta chars_to_print+3

over:
	clc
	lda txtPtr+1
	adc #1
	sta txtPtr+1
	bcc !+
	inc txtPtr+2
!:
	rts


scroll_xpos: .byte 0
scroll_speed: .byte 2

chars_to_print:
.fill $4,$0
scroll_charNo: .byte 0

xback:
.byte $0

plasma_fade_out_pt:
.byte $0

fade_plasma_out:
		ldx plasma_fade_out_pt
		lda plasma_fd_out_tbl,x
		sta COLOR_FADER

		inc plasma_fade_out_pt
		lda plasma_fade_out_pt
		cmp #42
		bne !+
		:set_addr(final_blanker_d800,plasma_fade_out_fn)
		:set_addr(post_plasma,skip_fade_plasma)
!:
		rts


final_blanker_d800:
		lda #2
		ldx #$27
!:
addr_d800:
		sta $d800,x
		dex
		bpl !-

		clc
		lda addr_d800+1
		adc #$28
		sta addr_d800+1
		bcc!+
		inc addr_d800+2
!:
		inc line_c+1
line_c:		
		lda #0
		cmp #25
		bne !+
		:set_addr(null_func,plasma_fade_out_fn)
!:
		rts