
outro_fade:
	
		:set_addr_zp(bmp_screen+$28*25,addr_1)
		:set_addr_zp($d800+$28*25,addr_2)
		:set_addr_zp(pixel_dest+$28*25*8,addr_3)
		

another:
		lda #$00 //;Brown brown

		ldy #$27
!:
		sta (addr_1),y
		sta (addr_2),y
		dey
		bpl !-


		ldx #0
pixelblank:
		lda #$ff
		ldy #8
!:
		sta (addr_3),y
		dey
		bpl !-

		:advance_pixel_block(addr_3)
		inx
		cpx #4
		bne pixelblank


		:go_down_one_line(addr_1)
		:go_down_one_line(addr_2)
		:go_down_one_line(addr_3)

		inc rct+1
rct:
		lda #0
		cmp #26
		beq !+

		:wait_frame()
		:wait_frame()

		jmp another
!:

		//;Pulisco lo schermo
		lda #0
		sta $d01c //;lo faccio ora servirà nel tunnel ma non ho voglia di ricompilare
		ldx #0
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		sta bmp_screen+$100,x
		sta bmp_screen+$200,x
		sta bmp_screen+$300,x
		dex
		bne !-
		rts

.macro go_down_one_line(addr){
		sec 
		lda addr
		sbc #$28
		sta addr
		bcs !+
		dec addr+1
!:
}

.macro advance_pixel_block(addr){
		sec 
		lda addr
		sbc #$8
		sta addr
		bcs !+
		dec addr+1
!:
}

fade_out_ptr:
.byte $0


.align $50
final_fade_table:
.byte DARK_GRAY,DARK_GRAY,DARK_GRAY
.byte ORANGE,ORANGE,ORANGE
.byte GRAY,GRAY,GRAY
.byte LIGHT_RED,LIGHT_RED,LIGHT_RED
.byte ORANGE,ORANGE,ORANGE
.byte RED,RED,RED 
.byte BROWN,BROWN,BROWN

fade_out_everything:
		lda #0
	//	sta sprite_enable+1
	//	sta sprite_enabler2+1


		ldx fade_out_ptr
		lda final_fade_table,x

		sta lcol1+1
		sta lcol2+1
	//;	sta lcol3+1
		sta lcol4+1
		sta lcol5+1
		sta lcol6+1
		sta lcol7+1
		sta lcol8+1
		sta lcol9+1
		sta lcol10+1
		sta lcol11+1

		sta sprcol1+1
		sta sprcol2+1
		sta sprcol3+1
		sta sprcol4+1
		sta sprcol5+1
		sta sprcol6+1

		inc fade_out_ptr
		lda fade_out_ptr
		cmp #21
		bne !+
		:set_addr(null_sprites,FINAL_FADE_FUNCTION)
		lda #0
		sta fade_out_ptr

		lda #>final_irq
		sta irq_on_hi+1

		lda #<final_irq
		sta irq_on_lo+1

		lda #$10
		sta next_irq_d012+1

		lda #$9b
		sta next_irq_d011+1

!:

		rts

final_irq:
		:open_irq()

		asl $d019

		ldx fade_out_ptr
		lda final_fade_table,x
		sta $d021

		inc fade_out_ptr
		lda fade_out_ptr
		cmp #21
		bne !+
		lda #20
		sta fade_out_ptr
!:

		jsr $1003

		:close_irq()
		rti