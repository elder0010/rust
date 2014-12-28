.print "ScreenRam: "+toHexString(ScreenRam)
.print "ColorRam: "+toHexString(ColorRam)
.print "Bmp Screen: "+toHexString(bmp_screen)
.print "$d800: "+toHexString($d800)


//;-------------------------------------------------------------
//; Generates the fade sequence by looping on the seq file
//; And calculating the screen address to use in the fade l8r
//;-------------------------------------------------------------
generate_fade_sequence:
		lda #0
		sta current_offs_lo
		sta current_offs_hi

		//;initialize the frame length table
		ldx #0
!:
		sta frame_len,x
		dex
		bne !-

		lda #1
		sta fade_step
		tax

		ldy #0
screen_loop:
		cpx fade_sequence
		//;cpx fade_step
		bne !+
//;------------------------------------
		lda current_offs_lo
fdsqlo:
		sta fade_seq_lo

		lda current_offs_hi
fdsqhi:
		sta fade_seq_hi 
		
		:inc_addr(fdsqlo)
		:inc_addr(fdsqhi)

		//;ldx fade_step
		inc frame_len,x
//;------------------------------------
!:
		clc
		lda current_offs_lo
		adc #1
		sta current_offs_lo
		bcc !+
		inc current_offs_hi
!:
		:inc_addr(screen_loop)

		//;Finished looping on the screen?
		iny
		bne !+
		inc ctt+1
!:
ctt:
		lda #0
		cmp #4
		bne !+
	
		lda #0
		sta current_offs_lo
		sta current_offs_hi
		sta ctt+1
		:set_addr(fade_sequence,screen_loop)
	
		inx 
fdpt_1:
		cpx #FADE_DEPTH
		bne !+
		lda #1
		sta fade_step
		rts
!:	
		jmp screen_loop
		

.macro inc_addr(addr){
		clc
		lda addr+1
		adc #1
		sta addr+1
		bcc !+
		inc addr+2
!:
}


fade_block_set:		
		lda #0
		sta fade_pt
		sta tmp_1

		ldx fade_step
		lda frame_len,x
		sta cur_len

		lda step_fade+1
		sta stor_addr1_lo

		lda step_fade+2
		sta stor_addr1_hi

		lda loaddr+1
		sta stor_addr2_lo

		lda loaddr+2
		sta stor_addr2_hi

//;------------------------------------
step_fade:
		lda fade_seq_hi
		sta num2hi
loaddr:
		lda fade_seq_lo
		sta num2lo

		jsr point_block

		jsr fade_block

		:inc_addr(step_fade)
		:inc_addr(loaddr)

		inc tmp_1
		lda tmp_1
		cmp cur_len
		bne step_fade
//;------------------------------------
		lda #0
		sta tmp_1

		inc fade_pt
		lda fade_pt
fade_anim_len:
		cmp #7
		beq !+

		lda stor_addr1_lo
		sta step_fade+1
		sta loaddr+1

		lda stor_addr1_hi
		sta step_fade+2

		//;lda stor_addr2_lo
		//;sta loaddr+1

		lda stor_addr2_hi
		sta loaddr+2

		:wait_frame()

		jmp step_fade
!:	

		inc fade_step
		lda fade_step
fdpt_2:
		cmp #FADE_DEPTH
		beq !+

	
		jmp fade_block_set
!:

		rts


//;-------------------------------------------------------------
//;Points an 8x8 block to fade. 
//; The block offset from the start of the screen is identified
//; by a 16bit value stored in num2hi/num2lo
//;-------------------------------------------------------------
point_block:

//;Calc the target ScreenRam source / dest using the offset
//;ScreenRam src e dest
		ldy #>ScreenRam
		lda #<ScreenRam
	
		:add16bit()

		//;lda reslo
		stx screen_ram_src+1
		sta screen_ram_src+2

//;Calc the target ColorRam source / dest using the offset
		ldy #>ColorRam
		lda #<ColorRam
		
		:add16bit()

		stx color_ram_src+1
		sta color_ram_src+2

//;dst
		ldy #>bmp_screen
		lda #<bmp_screen
		
		:add16bit()

		stx screen_ram_dst+1
		stx color_ram_dst+1
		sta screen_ram_dst+2

//;Dst
		lda #>$d800
		adc num2hi			
		sta color_ram_dst+2

//;And now the pixels: we need to multiply *8 to get the current 
//;8 bytes to copy
		asl num2lo
		rol	num2hi
		asl num2lo
		rol	num2hi
		asl num2lo
		rol	num2hi

//;Pixel src e dest
		ldy #>pic1
		lda #<pic1
		
		:add16bit()

		stx pixel_src_lo+1
		sta pixel_src_hi+1

		lda #>pixel_dest
		adc num2hi		
		sta pixel_dest_hi+1	
		rts

//;-----------------------------------------
//;Fades an 8x8 block pointed by point_block
//;-----------------------------------------
fade_block:
		//;Get the colour to fade: ScreenRam (2 colours), ColorRam (1 colour)
		//;And store it in variables
screen_ram_src:		
		lax ScreenRam
		//;tax
		and #$f0 
	//;	sta col_1
		tay //;save for later
		txa
		and #$0f
		tax //;Col_2
		lda fade_table_addr_lo,x
		sta fade_table_2

color_ram_src:
		lda ColorRam
		and #$0f
		tax
		lda fade_table_addr_lo,x
		sta fade_table_3

		//;Then, let's point the fade tables for each colour
		//;ldx col_1 already in Y
		ldx tolonibble,y //;This colours is in the high nybble so we need 
						 //;to shift it
		//;tax
		lda fade_table_addr_lo,x
		sta fade_table_1
	
//;--------------------------------------------------------------
//;Main fade routine
fade_again:
		//;Get the current colour by searching in the (pointed) fade table
		ldy fade_pt
		lax (fade_table_1),y
		//;tax
		lda (fade_table_2),y
		//;ldy current_col_1	//;packing the 2 nybbles to get a byte (already in x)
		ora tohinibble,x
screen_ram_dst:
		sta bmp_screen		

		lda (fade_table_3),y
color_ram_dst:
		sta $d800

pixel_src_hi:		
		lda #>pic1
		sta pixel_src+1

pixel_src_lo:	
		lda #<pic1
		sta pixel_src
		sta pixel_dst

pixel_dest_hi:
		lda #>pixel_dest
		sta pixel_dst+1

		//;If it's the first step of the fade we need to copy the actual pixels
		//;on the block
		tya //;lda fade_pt
		bne nocopypx
		ldy #7
.for(var p=0;p<8;p++){
		lda (pixel_src),y
		sta (pixel_dst),y
		dey
}
nocopypx:
		rts
//;--------------------------------------------------------------

.macro add16bit(){
		clc				
	//;	lda num1lo
		adc num2lo
		tax
		//;sta reslo			
		tya
		adc num2hi			
		//;sta reshi			
}





.align $80
.pc = * "fade tables"
.import source "fade_tables.asm"		

.pc = * "toXnibble tabs"
.align $100
tolonibble:
.fill $100,floor(i/16)


tohinibble:
.fill $100,[i*16]


.pc = * "init fade"
init_fade:
	
		lda fade_table_addr_hi
		sta fade_table_1+1
		sta fade_table_2+1
		sta fade_table_3+1

		:set_addr(fade_seq_lo,fdsqlo)
		:set_addr(fade_seq_hi,fdsqhi)

		:set_addr(fade_seq_hi,step_fade)
		:set_addr(fade_seq_lo,loaddr)

		ldx #0
		lda #0
!:
		sta frame_len,x
		dex
		bne !-

		ldx #$0
!:
		lda #$fe
		sta fade_seq_lo_addr,x
		sta fade_seq_lo_addr+$100,x
		sta fade_seq_lo_addr+$200,x
		sta fade_seq_lo_addr+$300,x

		lda #$00
		sta fade_seq_hi_addr,x
		sta fade_seq_hi_addr+$100,x
		sta fade_seq_hi_addr+$200,x
		sta fade_seq_hi_addr+$300,x
		dex
		bne !-
		rts

/*
.align $100
.pc = * "frame_len"
frame_len:
.fill $100,0
*/

/*
.pc = fade_seq_lo_addr "fade_seq_lo"
fade_seq_lo:
.fill $400,0
*/
//;.pc = fade_seq_hi_addr "fade_seq_hi"
//;fade_seq_hi:
//;.fill $400,0

