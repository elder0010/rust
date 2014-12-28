//;--------------------------------------
//;------TENTACLE STUFF
//;--------------------------------------
.var TEST_MODE = 1

.pc = $9e30 "includes"
.import source "../../common/zeropage.asm"
.import source "../../common/functions.asm"
.import source "../variables.asm"
.import source "../tentacoli_functions.asm"

.if (TEST_MODE == 1){

	.pc=music.location "Music" .fill music.size, music.getData(i)	
	:BasicUpstart2(code)
}

.pc = $5000 "code"

code:
.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()
}		
		:init_scene()
	
		lda #$2a
		sta $d012
		
	
		lda #<idler_irq
		sta $fffe
		lda #>idler_irq
		sta $ffff
	
		
		lda #0
		sta $d010
	/*	
		lda #BLUE
		sta $d020
		sta $d021
	*/
		sta $8710
		 
	//;	lda #$00
	//;	sta $d011
		
		lda #$33
		sta $d011
		
		lda #$fa
		sta $d005
		
		//lda #$1d
		
		
.if (TEST_MODE == 1){
		cli
}

.if (TEST_MODE == 0){
		nop
}		
		

		lda #$f
		sta $d015
!:		
		lda $d011
		cmp #$b3
		bne !-

		:display_bitmap()
JMP_ME:		
		jmp *
		
clear_screen_loop:
		
		lda #0
		ldx #0
!:
		sta schermo_sprites,x
		sta schermo_sprites+$100,x 
		sta schermo_sprites+$200,x
		sta schermo_sprites+$300,x
	
		dex
		bne !-

		
		inc has_finished_clear_screen
		
		jmp *


	
.align $100

top_irq:
		:open_irq()
		asl $d019
		
		lda $d012
!:		cmp $d012
		bne !-


		lda #$3b
		sta $d011
		
		ldy #19
		:wait()

		
fld_loop:		
		//;E vai con il FLD
!:		lda $d012
		cmp $d012
		bne !-
	
		ldy #4
		:wait()
		
		clc
		lda $d011
		adc #$1
		and #$7
		ora #$30
		sta $d011
	
		inc lines_done
		
		ldy lines_done
		cpy max_fld_lines
		bne fld_loop
fine:
		
		ldx fld_pointer
		lda wobbler_pointer,x
		tax

		lda fld_table,x
		sta max_fld_lines
		
		lda #0
		sta lines_done
	
		inc fld_pointer
		
		lda fld_pointer
		cmp #$9a
		bne !+
		lda #<wait_irq
		sta $fffe
		lda #>wait_irq
		sta $ffff
		
		lda #$50
		sta $d012
		lda #$0b
		sta $d011
		
	
!:
	
		jsr music.play
		
		:close_irq()
		rti


//;IDLE DELAY PRE FLD
idler_irq:
		:open_irq()
		asl $d019
	
		inc delayer_tk +1
		
delayer_tk:		
		lda #0
		cmp #$1 //;Delay
		bne !+
		lda #<top_irq
		sta $fffe
		lda #>top_irq
		sta $ffff
!:
		jsr music.play
		:close_irq()
		
		rti

.import source "raster.asm"
.pc = $8da0 "scroller_routine"
pop_in_tentacles:
//inc $d020

.pc = * "copier"
.var SCROLL_END = 0

.eval SCROLL_END = sprites+$40*0
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*1
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*2
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*3
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*4
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*5
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*6
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*7
:scroll_sprite_offset(SCROLL_END)
.eval SCROLL_END = sprites+$40*8
:scroll_sprite(SCROLL_END)
	


SOURCE_0:
		lda $ffff
		sta sprites_foot
SOURCE_1:	
		lda $ffff+1
		sta sprites_foot+1

SOURCE_2:	
		lda $ffff+2
		sta sprites_foot+2


		clc
		lda SOURCE_0+1
		adc #3
		sta SOURCE_0+1
		bcc !+
		inc SOURCE_0+2
!:
		clc
		lda SOURCE_1+1
		adc #3
		sta SOURCE_1+1
		bcc !+
		inc SOURCE_1+2
!:
		clc
		lda SOURCE_2+1
		adc #3
		sta SOURCE_2+1
		bcc !+
		inc SOURCE_2+2
!:

		inc sprite_line_cnt
		lda sprite_line_cnt
		cmp #21
		bne !+
	
	//;RIMETTERE
		
		inc memory_pt
		ldx memory_pt
		lda sprite_memory_pointers_lo,x
		sta SOURCE_0+1

		sta SOURCE_1+1

		sta SOURCE_2+1
		inc SOURCE_1+1
		inc SOURCE_2+1
		inc SOURCE_2+1
		
		lda sprite_memory_pointers_hi,x
		sta SOURCE_0+2
		sta SOURCE_1+2
		sta SOURCE_2+2
		
		lda #$0
		sta sprite_line_cnt
!:

		rts
			

.pc = $8a40 "fader routine"
.import source "../fader.asm"



.pc = $3000

.align $100
fld_table:
.byte 100,97,95,92,90,87,85,83,80,78,75,73,71,68,66,64
.byte 61,59,57,55,53,51,48,46,44,42,40,38,36,35,33,31
.byte 29,28,26,24,23,21,20,18,17,16,14,13,12,11,10,9
.byte 8,7,6,5,5,4,3,3,2,2,1,1,1,1,1,1
.byte 1,1,1,1,1,1,2,2,3,3,4,4,5,6,7,7
.byte 8,9,10,11,13,14,15,16,18,19,20,22,24,25,27,28
.byte 30,32,34,36,37,39,41,43,45,47,49,52,54,56,58,60
.byte 63,65,67,69,72,74,77,79,81,84,86,89,91,93,96,98
.byte 101,103,106,108,110,113,115,118,120,122,125,127,130,132,134,136
.byte 139,141,143,145,147,150,152,154,156,158,160,162,163,165,167,169
.byte 171,172,174,175,177,179,180,181,183,184,185,186,188,189,190,191
.byte 192,192,193,194,195,195,196,196,197,197,198,198,198,198,198,198
.byte 198,198,198,198,198,198,197,197,196,196,195,194,194,193,192,191
.byte 190,189,188,187,186,185,183,182,181,179,178,176,175,173,171,170
.byte 168,166,164,163,161,159,157,155,153,151,148,146,144,142,140,138
.byte 135,133,131,128,126,124,121,119,116,114,112,109,107,104,102,100

.align $100
wobbler_pointer:
	  .byte 85,93,100,108,117,125
      .byte 132,139,144,151,156,162
      .byte 166,168,172,172,174,174
      .byte 173,172,169,168,164,161
      .byte 158,155,150,148,145,143
      .byte 141,139,138,137,137,138
      .byte 139,142,144,147,150,154
      .byte 157,161,166,169,173,176
      .byte 180,182,185,187,188,188
      .byte 189,188,187,186,185,182
      .byte 180,176,174,172,169,166
      .byte 163,160,158,157,156,155
      .byte 155,156,157,158,160,162
      .byte 164,168,170,175,179,181
      .byte 185,188,192,193,197,197
      .byte 198,198,199,198,197,193
      .byte 192,188,185,182,179,174
      .byte 170,167,164,161,158,157
      .byte 156,156,156,157,158,162
      .byte 166,169,173,178,184,189
      .byte 195,201,207,212,218,224
      .byte 229,234,238,242,244,247
      .byte 250,253,254,255,254,255
      .byte 254,253,250,247,244,240
      .byte 235,230,224,217,211,204
      .byte 197,188,182,174,167,161
      .byte 155,149,144,141,136,132
      .byte 130,129,128,129,129,129
      .byte 130,132,135,137,139,141
      .byte 144,145,148,149,150,150
      .byte 150,150,149,147,144,142
      .byte 139,136,131,128,123,120
      .byte 116,112,107,104,100,98
      .byte 95,93,92,91,91,89
      .byte 89,91,92,93,94,97
      .byte 99,99,101,102,104,104
      .byte 104,102,101,99,97,93
      .byte 89,83,80,73,67,61
      .byte 55,48,41,35,29,21
      .byte 17,12,7,5,2,0
      .byte 0,0,1,4,5,8
      .byte 14,19,25,31,38,44
      .byte 52,60,68,76
fld_pointer:
.byte 226

max_fld_lines:
.byte $1

lines_done:
.byte $0

dimezzatore:
.byte $0

