.align $100

rotator_stabilizer_irq:
		sta reseta1 //;3
        stx resetx1 //;3
        sty resety1 //;3 

		//;Fino a qui CASO PEGGIORE max 18 cicli

		lda #<irq_top sta $fffe //;6
		lda #>irq_top sta $ffff //;6

		asl $d019 //;6
		inc $d012 //;6 
	
		ldy # [[[rotator_screen & $3fff] / $0400] << 4] + [[[rotator_chars & $3fff] / $0800] << 1]
		sty $d018
		tsx

		cli //;2 
		.for (var x=0;x<10;x++){
			nop //;2
		}
  		
		brk
	
.align $100
.pc = *+1

irq_top:
		txs //;2
		
		ldx #$08    //; Wait exactly  2+(8-1)*5 = 37 cicli
!:		dex       	//  ;lines worth of
		bne !-    	// ;cycles for compare
		bit $ea     //;Minus compare
		nop         //;cycles

		//;39

		lda #ILLEGAL_START+1  	//;2 
		cmp $d012   //;4
		beq !+		//;2 o 3 a seconda DEL CASO! quindi questo blocco sono 8 o 9
!:

		bit $24
		bit $24
			
		ldy #6
		:wait()

pt_rt:
		ldx #0
		lda colour_table,x

		lda #$7b
		ldy #0
		sty $dd00

		bit $24
		sta $d011
		ldy #10
		:wait()

	
		lda colour_table,x

		ldy #$1b
		sty $d011
//y_cr:
		.var t
		.var col_reg = $d021
		.for ( t=0;t<11;t++)
		{
			
		
			sta col_reg
			inx
			lda colour_table,x
			ldy #1
			:wait()
			nop
			nop


			sta col_reg
			inx
			lda colour_table,x  

			ldy #10  
			:wait()
			nop
			
			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

		}


			sta col_reg
			inx
			lda colour_table,x
			ldy #1
			:wait()
			nop
			nop


			sta col_reg
			inx
			lda colour_table,x  

			ldy #10  
			:wait()
			nop
			
			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda colour_table,x

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda #0

			ldy #10  
			:wait()
			nop

			sta col_reg
			inx
			lda $2400,x

			ldy #7
			:wait()
			
			nop

			:bank_1()

			lda #$3b
			sta $d011

			lda # [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
			sta $d018

			lda #0
			sta $d021
			
			lda #$d8
			sta $d016

			lda #$ef
			sta $d012

			lda #<irq_bottom
			sta $fffe
			lda #>irq_bottom
			sta $ffff

			asl $d019

			lda reseta1
			ldx resetx1
			ldy resety1
			rti

irq_bottom:
		:open_irq()

			asl $d019

			jsr $1003
			jsr frame_count
		

			lda #<rotator_stabilizer_irq sta $fffe
			lda #>rotator_stabilizer_irq sta $ffff
			
			lda #ILLEGAL_START
			sta $d012
			jsr draw_frame

			ldx raster_sine_pt
			lda raster_sine,x
		
			sta pt_rt+1

raster_anim_routine:
			jsr rotator_part_1

			inc raster_sine_pt

exit_scene:
			lda #0
			beq !+
			inc wait_redraw_pic+1
			lda #<stabilizer_outro_irq sta $fffe
			lda #>stabilizer_outro_irq sta $ffff

			lda #$cb
			sta illegal_end
!:
			:close_irq()
			rti

.import source "rotator_story.asm"


draw_frame:
	
end:
			clc
			lda tmp_5		
			sbc #1		//; sommo 1
			and #$03	//; mi tengo nel range 0-7
			ora #$18	//; e sistemo gli altri flag
			//sta y_cr+1
			sta tmp_5
			and #$07	//; torno in range 0-7
			bne !+
			
			jsr choose_frame_table

			jsr copy_line
			
			inc dsp_cnt+1
dsp_cnt:	
			lda #0
			clc
			lsr
			bcc !+
			inc ct
!:

			lda ct
			cmp #50
			bne !+
			lda #0
			sta ct
!:
			rts

choose_frame_table:
			lda #$ff
			eor #$ff
			sta choose_frame_table+1
			beq !+
//;screen_1
			lda #>rotator_frame_address_lo
			sta frame_tbl_addr_lo+2

			lda #<rotator_frame_address_lo
			sta frame_tbl_addr_lo+1

			lda #>rotator_frame_address_hi
			sta frame_tbl_addr_hi+2

			lda #<rotator_frame_address_hi
			sta frame_tbl_addr_hi+1
		
			jmp endchs
!:
//;screen_2

			lda #>rotator_frame_address_lo_2
			sta frame_tbl_addr_lo+2

			lda #<rotator_frame_address_lo_2
			sta frame_tbl_addr_lo+1

			lda #>rotator_frame_address_hi_2
			sta frame_tbl_addr_hi+2

			lda #<rotator_frame_address_hi_2
			sta frame_tbl_addr_hi+1
endchs:

			rts


copy_line:
		ldy ct

frame_tbl_addr_lo:
		lda rotator_frame_address_lo,y
		sta ll+1
frame_tbl_addr_hi:
		lda rotator_frame_address_hi,y
		sta ll+2

		lda #>rotator_screen
		sta ss+2

		lda #<rotator_screen
		sta ss+1

		
		ldy #0
newline:
		ldx #35
ll:
		lda frames_1,x
ss:
		sta rotator_screen,x
		dex
		bpl ll

		:go_down_one_line(ll)
		:go_down_one_line(ss)

		iny
		cpy #12
		bne newline

		rts
.macro go_down_one_line(line){
		clc
		lda line+1
		adc #40
		sta line+1
		bcc !+
		inc line+2
!:

}

.pc = * "outro routine"
.import source "outro.asm"


frame_count:
		clc
		lda frame_count_lo
		adc #1
		sta frame_count_lo
		bcc !+
		inc frame_count_hi
!:
		//inc $d020
		rts

.align $100
.pc = * "temp colours"
tmp_colour_table:
.import source "data/rotator_colors.asm"

frames_1:
.import binary "data/frames/screen_1/f1.raw"
.import binary "data/frames/screen_1/f2.raw"
.import binary "data/frames/screen_1/f1.raw"


.pc = $9f00 "rotator_frames"
frames_2:
.import binary "data/frames/screen_2/f1.raw"
.import binary "data/frames/screen_2/f2.raw"
.import binary "data/frames/screen_2/f1.raw"



.pc = * "rotator_frame_address"
.var tt = 0
.align 50
rotator_frame_address_lo:
.for (tt=0;tt<110;tt++){
	.byte <frames_1+[tt*40]
}

rotator_frame_address_lo_2:
.for (tt=0;tt<110;tt++){
	.byte <frames_2+[tt*40]
}


rotator_frame_address_hi:
.for (tt=0;tt<110;tt++){
	.byte >frames_1+[tt*40]
}

rotator_frame_address_hi_2:
.for (tt=0;tt<110;tt++){
	.byte >frames_2+[tt*40]
}

.align $100
.pc = *"sine"
.import source "data/rotator_sine.asm"
.import source "data/raster_sine.asm"



.pc = * "rotator chars"
rotator_chars_src:
.import binary "data/frames/rotator_chars.raw"

.align $100
.pc = * "colour table"
colour_table:
