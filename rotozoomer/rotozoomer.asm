//;-------------------------------------------------------------------------
//; Rotozoomer
//;-------------------------------------------------------------------------

.var TEST_MODE = 1

.if (TEST_MODE == 1){
	.var music = LoadSid("../butterfly/loop.sid")
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(scene_start)
}

.import source "../common/functions.asm"
.import source "variables.asm"


.pc = $2000 "sine"
.fill 256,round(127.5+8*sin(toRadians(i*360/256)))

.pc = $3a10 "scene_start"
scene_start:
.if (TEST_MODE == 1){
		sei
		lda #0
		jsr $1000
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
}
		
		lda #0
		sta $d015

		
		lda #0
		sta T1
		sta T1+1
		sta T2
		sta T2+1
		sta PRODUCT
		sta PRODUCT+1
		sta PRODUCT+2
		sta PRODUCT+3
		sta PRODUCT+4
		sta PRODUCT+5


		lda #$00
		sta T1
		lda #$27
		sta T1+1

		lda #$e0
		sta T2
		lda #$00
		sta T2+1
		
		//;jsr multiply_8bit_signed
		
		jsr multiply_16bit_unsigned
		jsr multiply_16bit_signed


		//inc $d020

		//;jmp *

		:init_chunky_screen()

		jsr fill_screen_pixels
		
		//jsr disegna_pic_debug
		
		//jsr ruota_pic

		lda #1
		sta $d020

		cli

		jmp main


.import source "nmi_irqs.asm"

.import source "chunky_functions.asm"

.import source "functions.asm"

.pc = * "Math stuff"
.import source "math.asm"

.pc = * "sin cos tables"
.import source "data/sin_cos_tables.asm"

.align $100
.pc = * "routine"

main:	
	//	lda $d012
	//	cmp #$ea
	//	bne main
		
		lda _pageflip
		eor #$ff
		sta _pageflip
		beq page_1
page_0:
		
		:point_screen_1()
		jmp nopage
page_1:
		:point_screen_2()
nopage:

	

		ldx #0

target_buffer_lo:
		lda targetLowBuffer1,x
		sta screen_pos+1

target_buffer_hi:
		lda targetHiBuffer1,x
		sta screen_pos+2

		lda #0
		sta row_count

		lda #0
		sta u_lo
		sta u_hi
		sta v_lo
		sta v_hi

//;incx_u, incx_v
		lda #$00
		sec
val_incx_uhi:
		sbc #$010
		sta pixel1.incxuhi
		sta pixel2.incxuhi		

val_incx_vhi:
		lda #$00
		sta pixel1.incxvhi
		sta pixel2.incxvhi		

//;incx_u, incx_v
val_incy_vlo:
		lda #$00
		sta incy_vlo
val_incy_vhi:
		lda #$10
		sta incy_vhi

val_incy_ulo:
		lda #$00
		sta incy_ulo

val_incy_uhi:
		lda #$00
		sta incy_uhi
		
		ldx u_hi
		stx store_u_hi

		lda v_hi
		sta store_v_hi

		lda #$18
		sta counter

//;-------------------------------------
//;Disegno una riga
//;-------------------------------------
another2pixels:
pixel1: :calc_offset(1)
		sta tmp_1
pixel2: :calc_offset(0)
		ora tmp_1
		
		ldy counter
screen_pos:
		sta $ffff,y
		dey		
		sty counter
		
		bne  another2pixels
//;-------------------------------------		
anotherrow:
	
		inc row_count
		lda row_count
		cmp #42
		beq !+
		
		lda store_u_hi
		adc incy_uhi		
		sta store_u_hi
		tax

		clc
		lda store_v_hi
		adc incy_vhi
		sta v_hi
		sta store_v_hi		

//;-------------------------------------
//;Vado giu di una riga
//;-------------------------------------
		ldy row_count

nxt_line_bf_lo:
		lda targetLowBuffer1,y
		sta screen_pos+1
nxt_line_bf_hi:
		lda targetHiBuffer1,y
		sta screen_pos+2
//;-------------------------------------

		lda #$18
		sta counter
		
		jmp another2pixels
!:
		
		ldx zoom_sin_pt
		lda zoom_sin,x
		sta val_incx_uhi+1
		sta val_incy_vhi+1
		inc zoom_sin_pt

	//	dec val_incx_uhi+1
	//	dec val_incy_vhi+1
	
		ldx roto_sin_pt_2
		
		lda roto_sin,x
		clc 
		adc #$f0
opc_1:
		sta val_incx_vhi+1

		lda #0
		sec
		sbc roto_sin,x

		sec
		sbc #$f0

opc_2:
		sta val_incy_uhi+1

		inc roto_sin_pt_2
		inc roto_sin_pt_2


		jmp main



.macro calc_offset(hlflag)
{
		txa
.label incxuhi=*+1
		axs #$00

		clc
		lda v_hi
.label incxvhi=*+1
		adc #$00
		sta v_hi

		and #$f0
		ora tolonibble,x
		tay

texture:
		.if (hlflag==0) lda source_buffer_0_lo,y
				else	lda source_buffer_0_hi,y
}


.align $100
tolonibble:
.fill 256,floor(i/16)


.align $100
zoom_sin:
.byte 0,0,0,0,1,1,2,3,4,5,6,7,9,10,12,13
.byte 15,16,18,19,20,22,23,24,25,26,27,28,28,29,29,29
.byte 29,29,29,29,28,28,27,26,25,24,23,21,20,19,17,16
.byte 14,13,11,10,8,7,6,5,4,3,2,1,1,0,0,0
.byte 0,0,0,0,1,1,2,3,4,5,7,8,9,11,12,13
.byte 15,16,18,19,21,22,23,24,25,26,27,28,29,29,29,29
.byte 29,29,29,29,28,27,27,26,25,24,22,21,20,18,17,15
.byte 14,12,11,10,8,7,6,4,3,2,2,1,0,0,0,0
.byte 0,0,0,0,1,2,2,3,4,6,7,8,10,11,12,14
.byte 15,17,18,20,21,22,24,25,26,27,27,28,29,29,29,29
.byte 29,29,29,29,28,27,26,25,24,23,22,21,19,18,16,15
.byte 13,12,11,9,8,7,5,4,3,2,1,1,0,0,0,0
.byte 0,0,0,1,1,2,3,4,5,6,7,8,10,11,13,14
.byte 16,17,19,20,21,23,24,25,26,27,28,28,29,29,29,29
.byte 29,29,29,28,28,27,26,25,24,23,22,20,19,18,16,15
.byte 13,12,10,9,7,6,5,4,3,2,1,1,0,0,0,0




roto_sin:
.byte 20,19,18,17,16,15,14,13,12,11,10,9,8,8,7,6
.byte 5,5,4,3,3,2,2,1,1,1,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,1,1,1,2,2,3,4,4,5
.byte 5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19
.byte 20,21,22,23,24,25,26,26,27,28,29,30,31,32,32,33
.byte 34,35,35,36,36,37,37,38,38,38,39,39,39,39,39,39
.byte 39,39,39,39,39,39,39,38,38,37,37,36,36,35,35,34
.byte 33,33,32,31,30,29,29,28,27,26,25,24,23,22,21,20
.byte 19,18,17,16,15,14,13,12,11,10,10,9,8,7,6,6
.byte 5,4,4,3,3,2,2,1,1,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,2,2,3,3,4,4,5
.byte 6,7,7,8,9,10,11,12,13,13,14,15,16,17,18,19
.byte 20,21,22,23,24,25,26,27,28,29,30,30,31,32,33,34
.byte 34,35,35,36,37,37,38,38,38,39,39,39,39,39,39,39
.byte 39,39,39,39,39,39,38,38,38,37,37,36,36,35,34,34
.byte 33,32,31,31,30,29,28,27,26,25,24,23,22,21,20,20
