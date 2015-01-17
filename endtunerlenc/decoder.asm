.const	modarea	=	$1000	// Memory area to be modified
.const	rledata	=	$c000	// 0 terminated RLE data
.const	ptr		=	$70		// Pointer
.const	divval	=	$72		// Separator value
.const	cmpval	=	$73		// Comparison value (Separator+1)

// RLE decoder for skipping data already present in memory
// *******************************************************
decoder:		
	lda #<rledata
	sta ptr
	lda #>rledata
	sta ptr+1
	ldy #$00
	lda (ptr),y		// Load separator value
	sta divval
	iny
	bne psstart		// Update pointers
psloop1:
	sec
psloop2:	
	ldy #$00
	lax (ptr),y		// Load current command
	beq psend		// End => DONE
	sbc divval		// Skip or Block?	
	iny				// It's a command so update ptr position
	bcc psskip		// It's a block then no need to copy anything (X has the correct value)
	tax				// Save in X for later use
	adc #$00		// Add 1 (carry=1)
	sta cmpval		// Save compare value
psload:	
	lda (ptr),y		// Load next values
pssave:	
	sta modarea-1,y	// And save them in the correct position
	iny	
	cpy cmpval		// Check if we've reached the end of the block
	bne psload
	clc
psskip:				// In both case X keeps save ptr update	
	txa
	adc pssave+1
	sta pssave+1
	bcc psupdptr
	inc pssave+2
psstart:
	clc
psupdptr:			// And Y keeps load ptr update	
	tya
	adc ptr
	sta ptr
	bcc psloop1
	inc ptr+1
	bcs psloop2
psend:
	rts	