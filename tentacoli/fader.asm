//;.var scrpos  = $7f40
//;.var colpos  = $8328


//;.var scr     = $5c00
//;.var screencolour = $6000

//;.var col     = $d800
//;.var bkgcol  = $8710





main_fade:
		//;resetting all the pointers
		jsr reset_pointers
		
fade_loop:		
	
		ldx PT_ONE //;offset of the current row! (points the current 8X8 square)
col_src:	
		lda colpos,x //;fetching the current colour to fade from the image
		and #%00001111	
		
		tax	//;we need to have the colour in X to make the fade_colour routine work ;)
		
		lda table_lo,x
		//;now we have in A and Y the address of the fade table of the current colour
		sta FADE_TABLE_C+1
		
		lda table_hi,x
		sta FADE_TABLE_C+2
		
		ldy PT_ZERO //;fade pointer - points the current colour in the fade table
		ldx PT_ONE 	//; we have to reload offset in X since fade_colour mess up the values
		
FADE_TABLE_C:
		lda $ffff,y //;this value will be changed after the jsr fade_colour will be executed - see above
					//;in y there is the fade pointer
	
col_morph:
		sta $d800,x 

//;----------------------------------------------------------------
//;HIGH bits of screen memory - same procedure as above
scr_morph_high:	
		
		//;Moving the HIGH bits in the lower position to calculate the correct fade table
		lda scrpos,x
		lsr
		lsr
		lsr
		lsr
		and #%00001111 
		
		tax
		
		lda table_lo,x
		sta FADE_TABLE_S+1
		
		lda table_hi,x
		sta FADE_TABLE_S+2
		
		ldy PT_ZERO //;fade pointer
		ldx PT_ONE
		
FADE_TABLE_S:
		lda $ffff,y
		asl	//;after loading the fade colour, i have to put his bits back in the high positions
		asl
		asl
		asl
		sta TEMP //;then store in TEMP
		
//;---------------------------------------------------------------------------------
//;LOW bits of screen mem
		ldx PT_ONE
scr_src_low:
		lda scrpos,x
		and #%00001111 //;no need to move bits now! i'm just setting to 0 the higher stuff..
		
		//;again, point the correct fadetable for the fetched colour
		tax
	
		lda table_lo,x
		sta FADE_TABLE_SL+1
		
		lda table_hi,x
		sta FADE_TABLE_SL+2
		
		ldx PT_ONE
		ldy PT_ZERO //;fade pointer
		
FADE_TABLE_SL:
		lda $ffff,y
		
		//;mixing up the higher and lower bits 
		ora TEMP
		ora TEMP2
	
scr_morph_high2:		
		sta scr,x
		
		
		
		
		inc PT_ONE
		lda PT_ONE
		cmp #$28
		bne fade_loop //;finished one fadeloop for one row
		


	//	jsr wait_raster
			
		lda #$0
		sta PT_ONE
		sta TEMP
		sta TEMP2
		
	
				
		//;the fadetables are 8 bytes long :)
		inc PT_ZERO
			
		ldy PT_ZERO
		jsr wait_raster
		
		cpy #$8
		beq !+
		jmp fade_loop
!:

		//; this row is done! time to go to the next one
		//; by adding $28 to every col and screen source and destinations.
		//; if we cross the value $ff we have to increase the high bit 
		//; of the register of 1. see the macro, nothing special :D
		:inc_line(col_src)
		:inc_line(col_morph)
		:inc_line(scr_morph_high)
		:inc_line(scr_src_low)
		:inc_line(scr_morph_high2)
		
		//;resetting all the pointers
		jsr reset_pointers
		
		//;After 25 rows, the fade should stop, of course
		inc row_counter
		lda row_counter
		cmp #25
		beq !+

		jmp fade_loop
!:
		jmp JMP_ME

		
		
reset_pointers:
	
		ldx #$0
		stx PT_ZERO 
		stx PT_ONE
		stx TEMP
		stx TEMP2
		rts
		
		

  
wait_raster:

backd:
		
!:
		bit $d011 
        bpl !-
!:
        bit $d011
        bmi !-

!:
		bit $d011 
        bpl !-
!:
        bit $d011
        bmi !-

		
		rts
		


.macro inc_line(register){
		
		lda register+1
		clc
		adc #$28
		sta register+1
		bcc !+
		inc register+2
!:
}


.align $100
	.import source "fader_libs.asm"
	