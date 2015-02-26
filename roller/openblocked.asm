// *********************************
// * Open border, multiplex sprite *
// *********************************

openblocked:		
	stx $d016			// 4 56						01	-> SPRITE 1
	
	// Open sideborder
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	02
	stx $d016			// 4 =>38			
	sta $d016			// 4		Line 1				03
	
	jsr idlerow38	
	jsr idlerow32
	
	jsr wait38			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				20
	jsr wait44			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				00 - SPRITE 2	
	:wait44yspr(1)		// WAIT		
	stx $d016			// 4
	sta $d016			// 4		Line 4				01
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				02
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				03
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				04
	jsr wait44				// WAIT
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	05
	stx $d016			// 4 =>38		
	sta $d016			// 4		Line 1				06
	
	jsr idlerow38
	
	jsr wait38			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				15
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				16
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				17
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				18
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				19
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				20 - SPRITE 3 (-1)
	:wait44yspr(2)		// WAIT
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	00
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				01
	
	jsr idlerow38
	jsr idlerow32

	jsr wait38			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				18
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				19
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				20 - SPRITE 4 (-1)
	:wait44yspr(3)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				00
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				01	
	:ysprite(4)			// 44
	stx $d016			// 4
	sta $d016			// 4		Line 7				02
	jsr wait44				// WAIT
	stx $d016			// 4	
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	03
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				04
	
	jsr idlerow38	
	jsr idlerow32
	
	:incsprite()		// WAIT 38
	stx $d016			// 4
	sta $d016			// 4		Line 1				00
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				01
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				02
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				03
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				04
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				05
	jsr wait44				// WAIT
	stx $d016			// 4		

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	06
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				07
	
	jsr idlerow38
	
	jsr wait38				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				16
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				17
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				18
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				19
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				20 - SPRITE 6 (-1)
	:wait44yspr(5)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				00
	jsr wait44				// WAIT
	stx $d016			// 4		
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	01
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				02
	
	jsr idlerow38	
	jsr idlerow32
	
	jsr wait38				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				19
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				20 - SPRITE 7 (-1)
	:wait44yspr(6)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				00
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				01
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				02
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				03
	jsr wait44				// WAIT
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	04
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				05
	
	jsr idlerow38
	
	jsr wait38				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				14
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				15
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				16
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				17
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				18
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				19 - SPRITE 8 (-2)
	:wait44yspr(7)		// WAIT
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	20
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				00
	
	jsr idlerow38
	jsr idlerow32
	
	jsr wait38				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				17
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				18
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				19 - SPRITE 9 (-2)
	:wait44yspr(8)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				20
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				00	
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				01	
	:ysprite(9)			// WAIT	
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	02
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				03
	
	jsr idlerow38
	jsr idlerow32
	
	:incsprite()		// 38 WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				20
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				00
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				01
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				02
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				03
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				04
	jsr wait44				// WAIT
	stx $d016			// 4			

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	05
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				06
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				07
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				08
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				09
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				10
	jsr wait44				// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				11
	:wait44open()		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				12
	jsr wait44				// WAIT
	stx $d016			// 4			
	
	lda #<floor(emptysprite/64)
	sta charscreen2+$3fa
	sta charscreen2+$3fb
	sta charscreen2+$3fc
	sta charscreen2+$3fd
	
	jmp backtoirq

// Single wait44/38
// ****************	
wait44:	
	nop
	nop	
	nop
wait38:	
	nop
	nop
	nop
wait32:
	nop
	nop
	nop	
	pha
	pla
	pha
	pla
	rts	
		
		
// Idle Row	
// ********
idlerow38:	
	nop
	nop
	nop
idlerow32:
	jsr wait32			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				12
	jsr wait44			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 3				13
	jsr wait44			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				14
	jsr wait44			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				15
	jsr wait44			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 6				16
	jsr wait44			// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				17
	jsr wait44			// WAIT	
	stx $d016			// 4
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	10
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				11	
	rts
		