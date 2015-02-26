// **********************************************************
// * Open border, multiplex sprite and move screen to right *
// **********************************************************

openmoveright:				
	stx $d016			// 4 56						01	-> SPRITE 1	
	
	// Open sideborder
				
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	02
	stx $d016			// 4 =>38			
	sta $d016			// 4		Line 1				03	
	ldy row00+$26
	sty row00+$27
	ldy row00+$25
	sty row00+$26
	ldy row00+$24
	sty row00+$25
	ldy row00+$23
	sty row00+$24	
	ldy row00+$22
	sty row00+$23
	ldy row00+$21			
	stx $d016			// 4
	sta $d016			// 4		Line 2				04
	sty row00+$22	
	ldy row00+$20
	sty row00+$21
	ldy row00+$1f
	sty row00+$20
	ldy row00+$1e
	sty row00+$1f
	ldy row00+$1d
	sty row00+$1e	
	ldy row00+$1c
	sty row00+$1d	
	stx $d016			// 4
	sta $d016			// 4		Line 3				05	
	ldy row00+$1b
	sty row00+$1c
	ldy row00+$1a
	sty row00+$1b
	ldy row00+$19
	sty row00+$1a
	ldy row00+$18
	sty row00+$19	
	ldy row00+$17
	sty row00+$18	
	ldy row00+$16		
	stx $d016			// 4
	sta $d016			// 4		Line 4				06
	sty row00+$17	
	ldy row00+$15
	sty row00+$16
	ldy row00+$14
	sty row00+$15
	ldy row00+$13
	sty row00+$14
	ldy row00+$12
	sty row00+$13	
	ldy row00+$11
	sty row00+$12
	stx $d016			// 4
	sta $d016			// 4		Line 5				07
	ldy row00+$10
	sty row00+$11
	ldy row00+$0F
	sty row00+$10
	ldy row00+$0E
	sty row00+$0F
	ldy row00+$0D
	sty row00+$0E	
	ldy row00+$0C
	sty row00+$0D	
	ldy row00+$0B		
	stx $d016			// 4
	sta $d016			// 4		Line 6				08
	sty row00+$0C
	ldy row00+$0A
	sty row00+$0B
	ldy row00+$09
	sty row00+$0A
	ldy row00+$08
	sty row00+$09
	ldy row00+$07
	sty row00+$08	
	ldy row00+$06
	sty row00+$07
	stx $d016			// 4
	sta $d016			// 4		Line 7				09
	ldy row00+$05
	sty row00+$06
	ldy row00+$04
	sty row00+$05
	ldy row00+$03
	sty row00+$04
	ldy row00+$02
	sty row00+$03	
	ldy row00+$01
	sty row00+$02	
	ldy row00+$00		
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	10
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				11
	sty row00+$01
	ldy row01+$26
	sty row01+$27
	ldy row01+$25
	sty row01+$26
	ldy row01+$24
	sty row01+$25
	ldy row01+$23
	sty row01+$24	
	ldy row01+$22
	sty row01+$23
	stx $d016			// 4
	sta $d016			// 4		Line 2				12
	ldy row01+$21
	sty row01+$22	
	ldy row01+$20
	sty row01+$21
	ldy row01+$1f
	sty row01+$20
	ldy row01+$1e
	sty row01+$1f
	ldy row01+$1d
	sty row01+$1e	
	ldy row01+$1c	
	stx $d016			// 4
	sta $d016			// 4		Line 3				13
	sty row01+$1d		
	ldy row01+$1b
	sty row01+$1c
	ldy row01+$1a
	sty row01+$1b
	ldy row01+$19
	sty row01+$1a
	ldy row01+$18
	sty row01+$19	
	ldy row01+$17
	sty row01+$18		
	stx $d016			// 4
	sta $d016			// 4		Line 4				14
	ldy row01+$16	
	sty row01+$17	
	ldy row01+$15
	sty row01+$16
	ldy row01+$14
	sty row01+$15
	ldy row01+$13
	sty row01+$14
	ldy row01+$12
	sty row01+$13	
	ldy row01+$11	
	stx $d016			// 4
	sta $d016			// 4		Line 5				15
	sty row01+$12
	ldy row01+$10
	sty row01+$11
	ldy row01+$0F
	sty row01+$10
	ldy row01+$0E
	sty row01+$0F
	ldy row01+$0D
	sty row01+$0E	
	ldy row01+$0C
	sty row01+$0D		
	stx $d016			// 4
	sta $d016			// 4		Line 6				16
	ldy row01+$0B
	sty row01+$0C
	ldy row01+$0A
	sty row01+$0B
	ldy row01+$09
	sty row01+$0A
	ldy row01+$08
	sty row01+$09
	ldy row01+$07
	sty row01+$08	
	ldy row01+$06		
	stx $d016			// 4
	sta $d016			// 4		Line 7				17
	sty row01+$07
	ldy row01+$05
	sty row01+$06
	ldy row01+$04
	sty row01+$05
	ldy row01+$03
	sty row01+$04
	ldy row01+$02
	sty row01+$03	
	ldy row01+$01
	sty row01+$02		
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	18
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				19
	ldy row01+$00				
	sty row01+$01
	ldy row02+$26
	sty row02+$27
	ldy row02+$25
	sty row02+$26
	ldy row02+$24
	sty row02+$25
	ldy row02+$23
	sty row02+$24	
	ldy row02+$22		
	stx $d016			// 4
	sta $d016			// 4		Line 2				20
	sty row02+$23	
	ldy row02+$21
	sty row02+$22	
	ldy row02+$20
	sty row02+$21
	ldy row02+$1f
	sty row02+$20
	ldy row02+$1e
	sty row02+$1f
	ldy row02+$1d
	sty row02+$1e			
	stx $d016			// 4
	sta $d016			// 4		Line 3				00 - SPRITE 2	
	:wait44yspr(1)		// WAIT		
	stx $d016			// 4
	sta $d016			// 4		Line 4				01
	ldy row02+$1c		
	sty row02+$1d		
	ldy row02+$1b
	sty row02+$1c
	ldy row02+$1a
	sty row02+$1b
	ldy row02+$19
	sty row02+$1a
	ldy row02+$18
	sty row02+$19	
	ldy row02+$17	
	stx $d016			// 4
	sta $d016			// 4		Line 5				02
	sty row02+$18					
	ldy row02+$16	
	sty row02+$17	
	ldy row02+$15
	sty row02+$16
	ldy row02+$14
	sty row02+$15
	ldy row02+$13
	sty row02+$14
	ldy row02+$12
	sty row02+$13		
	stx $d016			// 4
	sta $d016			// 4		Line 6				03
	ldy row02+$11
	sty row02+$12
	ldy row02+$10
	sty row02+$11
	ldy row02+$0F
	sty row02+$10
	ldy row02+$0E
	sty row02+$0F
	ldy row02+$0D
	sty row02+$0E	
	ldy row02+$0C
	stx $d016			// 4
	sta $d016			// 4		Line 7				04
	sty row02+$0D				
	ldy row02+$0B
	sty row02+$0C
	ldy row02+$0A
	sty row02+$0B
	ldy row02+$09
	sty row02+$0A
	ldy row02+$08
	sty row02+$09
	ldy row02+$07
	sty row02+$08		
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	05
	stx $d016			// 4 =>38		
	sta $d016			// 4		Line 1				06
	ldy row02+$06		
	sty row02+$07
	ldy row02+$05
	sty row02+$06
	ldy row02+$04
	sty row02+$05
	ldy row02+$03
	sty row02+$04
	ldy row02+$02
	sty row02+$03	
	ldy row02+$01		
	stx $d016			// 4
	sta $d016			// 4		Line 2				07
	sty row02+$02
	ldy row02+$00				
	sty row02+$01
	ldy row03+$26
	sty row03+$27
	ldy row03+$25
	sty row03+$26
	ldy row03+$24
	sty row03+$25
	ldy row03+$23
	sty row03+$24	
	stx $d016			// 4
	sta $d016			// 4		Line 3				08
	ldy row03+$22
	sty row03+$23	
	ldy row03+$21
	sty row03+$22	
	ldy row03+$20
	sty row03+$21
	ldy row03+$1f
	sty row03+$20
	ldy row03+$1e
	sty row03+$1f
	ldy row03+$1d	
	stx $d016			// 4
	sta $d016			// 4		Line 4				09
	sty row03+$1e	
	ldy row03+$1c		
	sty row03+$1d		
	ldy row03+$1b
	sty row03+$1c
	ldy row03+$1a
	sty row03+$1b
	ldy row03+$19
	sty row03+$1a
	ldy row03+$18
	sty row03+$19		
	stx $d016			// 4
	sta $d016			// 4		Line 5				10
	ldy row03+$17
	sty row03+$18
	ldy row03+$16	
	sty row03+$17	
	ldy row03+$15
	sty row03+$16
	ldy row03+$14
	sty row03+$15
	ldy row03+$13
	sty row03+$14
	ldy row03+$12	
	stx $d016			// 4
	sta $d016			// 4		Line 6				11
	sty row03+$13
	ldy row03+$11
	sty row03+$12
	ldy row03+$10
	sty row03+$11
	ldy row03+$0F
	sty row03+$10
	ldy row03+$0E
	sty row03+$0F
	ldy row03+$0D
	sty row03+$0E				
	stx $d016			// 4
	sta $d016			// 4		Line 7				12
	ldy row03+$0C
	sty row03+$0D				
	ldy row03+$0B
	sty row03+$0C
	ldy row03+$0A
	sty row03+$0B
	ldy row03+$09
	sty row03+$0A
	ldy row03+$08
	sty row03+$09
	ldy row03+$07	
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	13
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				14
	sty row03+$08		
	ldy row03+$06		
	sty row03+$07
	ldy row03+$05
	sty row03+$06
	ldy row03+$04
	sty row03+$05
	ldy row03+$03
	sty row03+$04
	ldy row03+$02
	sty row03+$03		
	stx $d016			// 4
	sta $d016			// 4		Line 2				15
	ldy row03+$01			
	sty row03+$02
	ldy row03+$00				
	sty row03+$01
	ldy row04+$26
	sty row04+$27
	ldy row04+$25
	sty row04+$26
	ldy row04+$24
	sty row04+$25
	ldy row04+$23	
	stx $d016			// 4
	sta $d016			// 4		Line 3				16
	sty row04+$24
	ldy row04+$22
	sty row04+$23	
	ldy row04+$21
	sty row04+$22	
	ldy row04+$20
	sty row04+$21
	ldy row04+$1f
	sty row04+$20
	ldy row04+$1e
	sty row04+$1f	
	stx $d016			// 4
	sta $d016			// 4		Line 4				17
	ldy row04+$1d			
	sty row04+$1e	
	ldy row04+$1c		
	sty row04+$1d		
	ldy row04+$1b
	sty row04+$1c
	ldy row04+$1a
	sty row04+$1b
	ldy row04+$19
	sty row04+$1a
	ldy row04+$18			
	stx $d016			// 4
	sta $d016			// 4		Line 5				18
	sty row04+$19		
	ldy row04+$17
	sty row04+$18
	ldy row04+$16	
	sty row04+$17	
	ldy row04+$15
	sty row04+$16
	ldy row04+$14
	sty row04+$15
	ldy row04+$13
	sty row04+$14
	stx $d016			// 4
	sta $d016			// 4		Line 6				19
	ldy row04+$12	
	sty row04+$13
	ldy row04+$11
	sty row04+$12
	ldy row04+$10
	sty row04+$11
	ldy row04+$0F
	sty row04+$10
	ldy row04+$0E
	sty row04+$0F
	ldy row04+$0D
	stx $d016			// 4
	sta $d016			// 4		Line 7				20 - SPRITE 3 (-1)	
	:wait44yspr(2)		// WAIT
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	00
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				01
	sty row04+$0E
	ldy row04+$0C
	sty row04+$0D				
	ldy row04+$0B
	sty row04+$0C
	ldy row04+$0A
	sty row04+$0B
	ldy row04+$09
	sty row04+$0A
	ldy row04+$08
	sty row04+$09
	stx $d016			// 4
	sta $d016			// 4		Line 2				02
	ldy row04+$07			
	sty row04+$08		
	ldy row04+$06		
	sty row04+$07
	ldy row04+$05
	sty row04+$06
	ldy row04+$04
	sty row04+$05
	ldy row04+$03
	sty row04+$04
	ldy row04+$02	
	stx $d016			// 4
	sta $d016			// 4		Line 3				03
	sty row04+$03		
	ldy row04+$01			
	sty row04+$02
	ldy row04+$00				
	sty row04+$01
	ldy row05+$26
	sty row05+$27
	ldy row05+$25
	sty row05+$26
	ldy row05+$24
	sty row05+$25	
	stx $d016			// 4
	sta $d016			// 4		Line 4				04
	ldy row05+$23	
	sty row05+$24
	ldy row05+$22
	sty row05+$23	
	ldy row05+$21
	sty row05+$22	
	ldy row05+$20
	sty row05+$21
	ldy row05+$1f
	sty row05+$20
	ldy row05+$1e	
	stx $d016			// 4
	sta $d016			// 4		Line 5				05	
	sty row05+$1f	
	ldy row05+$1d			
	sty row05+$1e	
	ldy row05+$1c		
	sty row05+$1d		
	ldy row05+$1b
	sty row05+$1c
	ldy row05+$1a
	sty row05+$1b
	ldy row05+$19
	sty row05+$1a	
	stx $d016			// 4
	sta $d016			// 4		Line 6				06
	ldy row05+$18			
	sty row05+$19		
	ldy row05+$17
	sty row05+$18
	ldy row05+$16	
	sty row05+$17	
	ldy row05+$15
	sty row05+$16
	ldy row05+$14
	sty row05+$15
	ldy row05+$13
	stx $d016			// 4
	sta $d016			// 4		Line 7				07			
	sty row05+$14
	ldy row05+$12	
	sty row05+$13
	ldy row05+$11
	sty row05+$12
	ldy row05+$10
	sty row05+$11
	ldy row05+$0F
	sty row05+$10
	ldy row05+$0E
	sty row05+$0F	
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	08
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				09
	ldy row05+$0D
	sty row05+$0E
	ldy row05+$0C
	sty row05+$0D				
	ldy row05+$0B
	sty row05+$0C
	ldy row05+$0A
	sty row05+$0B
	ldy row05+$09
	sty row05+$0A
	ldy row05+$08	
	stx $d016			// 4
	sta $d016			// 4		Line 2				10	
	sty row05+$09
	ldy row05+$07			
	sty row05+$08		
	ldy row05+$06		
	sty row05+$07
	ldy row05+$05
	sty row05+$06
	ldy row05+$04
	sty row05+$05
	ldy row05+$03
	sty row05+$04		
	stx $d016			// 4
	sta $d016			// 4		Line 3				11
	ldy row05+$02	
	sty row05+$03		
	ldy row05+$01			
	sty row05+$02
	ldy row05+$00				
	sty row05+$01	
	ldy row06+$26
	sty row06+$27
	ldy row06+$25
	sty row06+$26
	ldy row06+$24		
	stx $d016			// 4
	sta $d016			// 4		Line 4				12
	sty row06+$25	
	ldy row06+$23	
	sty row06+$24
	ldy row06+$22
	sty row06+$23	
	ldy row06+$21
	sty row06+$22	
	ldy row06+$20
	sty row06+$21
	ldy row06+$1f
	sty row06+$20
	stx $d016			// 4
	sta $d016			// 4		Line 5				13
	ldy row06+$1e		
	sty row06+$1f	
	ldy row06+$1d			
	sty row06+$1e	
	ldy row06+$1c		
	sty row06+$1d		
	ldy row06+$1b
	sty row06+$1c
	ldy row06+$1a
	sty row06+$1b
	ldy row06+$19	
	stx $d016			// 4
	sta $d016			// 4		Line 6				14
	sty row06+$1a	
	ldy row06+$18			
	sty row06+$19		
	ldy row06+$17
	sty row06+$18
	ldy row06+$16	
	sty row06+$17	
	ldy row06+$15
	sty row06+$16
	ldy row06+$14
	sty row06+$15	
	stx $d016			// 4
	sta $d016			// 4		Line 7				15
	ldy row06+$13	
	sty row06+$14
	ldy row06+$12	
	sty row06+$13
	ldy row06+$11
	sty row06+$12
	ldy row06+$10
	sty row06+$11
	ldy row06+$0F
	sty row06+$10
	ldy row06+$0E
	stx $d016			// 4

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	16
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				17
	sty row06+$0F	
	ldy row06+$0D
	sty row06+$0E
	ldy row06+$0C
	sty row06+$0D				
	ldy row06+$0B
	sty row06+$0C
	ldy row06+$0A
	sty row06+$0B
	ldy row06+$09
	sty row06+$0A
	stx $d016			// 4
	sta $d016			// 4		Line 2				18
	ldy row06+$08	
	sty row06+$09
	ldy row06+$07			
	sty row06+$08		
	ldy row06+$06		
	sty row06+$07
	ldy row06+$05
	sty row06+$06
	ldy row06+$04
	sty row06+$05
	ldy row06+$03
	stx $d016			// 4
	sta $d016			// 4		Line 3				19	
	sty row06+$04		
	ldy row06+$02	
	sty row06+$03		
	ldy row06+$01			
	sty row06+$02
	ldy row06+$00				
	sty row06+$01		
	ldy row07+$26
	sty row07+$27
	ldy row07+$25
	sty row07+$26
	stx $d016			// 4
	sta $d016			// 4		Line 4				20 - SPRITE 4 (-1)
	:wait44yspr(3)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				00	
	ldy row07+$24		
	sty row07+$25	
	ldy row07+$23	
	sty row07+$24
	ldy row07+$22
	sty row07+$23	
	ldy row07+$21
	sty row07+$22	
	ldy row07+$20
	sty row07+$21
	ldy row07+$1f
	stx $d016			// 4
	sta $d016			// 4		Line 6				01	
	sty row07+$20	
	ldy row07+$1e		
	sty row07+$1f	
	ldy row07+$1d			
	sty row07+$1e	
	ldy row07+$1c		
	sty row07+$1d		
	ldy row07+$1b
	sty row07+$1c
	ldy row07+$1a
	sty row07+$1b
	stx $d016			// 4
	sta $d016			// 4		Line 7				02
	ldy row07+$19	
	sty row07+$1a	
	ldy row07+$18			
	sty row07+$19		
	ldy row07+$17
	sty row07+$18
	ldy row07+$16	
	sty row07+$17	
	ldy row07+$15
	sty row07+$16
	ldy row07+$14
	stx $d016			// 4	
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	03
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				04
	sty row07+$15
	ldy row07+$13	
	sty row07+$14
	ldy row07+$12	
	sty row07+$13
	ldy row07+$11
	sty row07+$12
	ldy row07+$10
	sty row07+$11
	ldy row07+$0F
	sty row07+$10	
	stx $d016			// 4
	sta $d016			// 4		Line 2				05
	ldy row07+$0E
	sty row07+$0F	
	ldy row07+$0D
	sty row07+$0E
	ldy row07+$0C
	sty row07+$0D				
	ldy row07+$0B
	sty row07+$0C
	ldy row07+$0A
	sty row07+$0B
	ldy row07+$09
	stx $d016			// 4
	sta $d016			// 4		Line 3				06
	sty row07+$0A
	ldy row07+$08	
	sty row07+$09
	ldy row07+$07			
	sty row07+$08		
	ldy row07+$06		
	sty row07+$07
	ldy row07+$05
	sty row07+$06
	ldy row07+$04
	sty row07+$05
	stx $d016			// 4
	sta $d016			// 4		Line 4				07
	ldy row07+$03
	sty row07+$04		
	ldy row07+$02	
	sty row07+$03		
	ldy row07+$01			
	sty row07+$02
	ldy row07+$00				
	sty row07+$01				
	ldy row08+$26
	sty row08+$27
	ldy row08+$25
	stx $d016			// 4
	sta $d016			// 4		Line 5				08	
	sty row08+$26
	ldy row08+$24		
	sty row08+$25	
	ldy row08+$23	
	sty row08+$24
	ldy row08+$22
	sty row08+$23	
	ldy row08+$21
	sty row08+$22	
	ldy row08+$20
	sty row08+$21
	stx $d016			// 4
	sta $d016			// 4		Line 6				09	
	ldy row08+$1f
	sty row08+$20	
	ldy row08+$1e		
	sty row08+$1f	
	ldy row08+$1d			
	sty row08+$1e	
	ldy row08+$1c		
	sty row08+$1d		
	ldy row08+$1b
	sty row08+$1c
	ldy row08+$1a
	stx $d016			// 4
	sta $d016			// 4		Line 7				10	
	sty row08+$1b
	ldy row08+$19	
	sty row08+$1a	
	ldy row08+$18			
	sty row08+$19		
	ldy row08+$17
	sty row08+$18
	ldy row08+$16	
	sty row08+$17	
	ldy row08+$15
	sty row08+$16
	stx $d016			// 4	

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	11
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				12	
	ldy row08+$14
	sty row08+$15
	ldy row08+$13	
	sty row08+$14
	ldy row08+$12	
	sty row08+$13
	ldy row08+$11
	sty row08+$12
	ldy row08+$10
	sty row08+$11
	ldy row08+$0F
	stx $d016			// 4
	sta $d016			// 4		Line 2				13	
	sty row08+$10	
	ldy row08+$0E
	sty row08+$0F	
	ldy row08+$0D
	sty row08+$0E
	ldy row08+$0C
	sty row08+$0D				
	ldy row08+$0B
	sty row08+$0C
	ldy row08+$0A
	sty row08+$0B
	stx $d016			// 4
	sta $d016			// 4		Line 3				14	
	ldy row08+$09
	sty row08+$0A
	ldy row08+$08	
	sty row08+$09
	ldy row08+$07			
	sty row08+$08		
	ldy row08+$06		
	sty row08+$07
	ldy row08+$05
	sty row08+$06
	ldy row08+$04
	stx $d016			// 4
	sta $d016			// 4		Line 4				15	
	sty row08+$05
	ldy row08+$03
	sty row08+$04
	ldy row08+$02
	sty row08+$03
	ldy row08+$01
	sty row08+$02
	ldy row08+$00
	sty row08+$01
	ldy row09+$26
	sty row09+$27
	stx $d016			// 4
	sta $d016			// 4		Line 5				16	
	ldy row09+$25
	sty row09+$26
	ldy row09+$24
	sty row09+$25
	ldy row09+$23
	sty row09+$24
	ldy row09+$22
	sty row09+$23
	ldy row09+$21
	sty row09+$22
	ldy row09+$20
	stx $d016			// 4
	sta $d016			// 4		Line 6				17
	sty row09+$21
	ldy row09+$1f
	sty row09+$20
	ldy row09+$1e
	sty row09+$1f
	ldy row09+$1d
	sty row09+$1e
	ldy row09+$1c
	sty row09+$1d
	ldy row09+$1b
	sty row09+$1c
	stx $d016			// 4
	sta $d016			// 4		Line 5				16	
	ldy row09+$1a
	sty row09+$1b
	ldy row09+$19
	sty row09+$1a
	ldy row09+$18
	sty row09+$19
	ldy row09+$17
	sty row09+$18
	ldy row09+$16
	sty row09+$17
	ldy row09+$15	
	stx $d016			// 4	

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	19 
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 3				20 - SPRITE 5 (-1)
	:wait44yspr(4)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 1				00
	
	sty row09+$16
	ldy row09+$14
	sty row09+$15
	ldy row09+$13
	sty row09+$14
	ldy row09+$12
	sty row09+$13
	ldy row09+$11
	sty row09+$12
	ldy row09+$10
	sty row09+$11
	stx $d016			// 4
	sta $d016			// 4		Line 5				16	
	ldy row09+$0f
	sty row09+$10
	ldy row09+$0e
	sty row09+$0f
	ldy row09+$0d
	sty row09+$0e
	ldy row09+$0c
	sty row09+$0d
	ldy row09+$0b
	sty row09+$0c
	ldy row09+$0a		
	stx $d016			// 4
	sta $d016			// 4		Line 4				02
	sty row09+$0b
	ldy row09+$09
	sty row09+$0a
	ldy row09+$08
	sty row09+$09
	ldy row09+$07
	sty row09+$08
	ldy row09+$06
	sty row09+$07
	ldy row09+$05
	sty row09+$06
	stx $d016			// 4
	sta $d016			// 4		Line 5				16	
	ldy row09+$04
	sty row09+$05
	ldy row09+$03
	sty row09+$04
	ldy row09+$02
	sty row09+$03
	ldy row09+$01
	sty row09+$02
	ldy row09+$00
	sty row09+$01
	ldy row10+$26
	stx $d016			// 4
	sta $d016			// 4		Line 6				04	
	sty row10+$27
	ldy row10+$25
	sty row10+$26
	ldy row10+$24
	sty row10+$25
	ldy row10+$23
	sty row10+$24
	ldy row10+$22
	sty row10+$23
	ldy row10+$21
	sty row10+$22	
	stx $d016			// 4
	sta $d016			// 4		Line 5				16		
	ldy row10+$20
	sty row10+$21
	ldy row10+$1f
	sty row10+$20
	ldy row10+$1e
	sty row10+$1f
	ldy row10+$1d
	sty row10+$1e
	ldy row10+$1c
	sty row10+$1d
	ldy row10+$1b
	stx $d016			// 4		

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	06
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				07		
	sty row10+$1c
	ldy row10+$1a
	sty row10+$1b
	ldy row10+$19
	sty row10+$1a
	ldy row10+$18
	sty row10+$19
	ldy row10+$17
	sty row10+$18
	ldy row10+$16
	sty row10+$17
	stx $d016			// 4
	sta $d016			// 4		Line 2				08
	ldy row10+$15
	sty row10+$16
	ldy row10+$14		
	sty row10+$15
	ldy row10+$13
	sty row10+$14
	ldy row10+$12
	sty row10+$13
	ldy row10+$11
	sty row10+$12
	ldy row10+$10
	stx $d016			// 4
	sta $d016			// 4		Line 3				09
	sty row10+$11
	ldy row10+$0f
	sty row10+$10
	ldy row10+$0e
	sty row10+$0f
	ldy row10+$0d
	sty row10+$0e
	ldy row10+$0c
	sty row10+$0d
	ldy row10+$0b
	sty row10+$0c
	stx $d016			// 4
	sta $d016			// 4		Line 4				10		
	ldy row10+$0a
	sty row10+$0b
	ldy row10+$09		
	sty row10+$0a
	ldy row10+$08
	sty row10+$09
	ldy row10+$07
	sty row10+$08
	ldy row10+$06
	sty row10+$07
	ldy row10+$05
	stx $d016			// 4
	sta $d016			// 4		Line 5				11		
	sty row10+$06
	ldy row10+$04
	sty row10+$05
	ldy row10+$03
	sty row10+$04
	ldy row10+$02
	sty row10+$03
	ldy row10+$01
	sty row10+$02
	ldy row10+$00
	sty row10+$01
	stx $d016			// 4
	sta $d016			// 4		Line 6				12			
	ldy row11+$26	
	sty row11+$27
	ldy row11+$25
	sty row11+$26
	ldy row11+$24
	sty row11+$25
	ldy row11+$23
	sty row11+$24
	ldy row11+$22
	sty row11+$23
	ldy row11+$21
	stx $d016			// 4
	sta $d016			// 4		Line 7				13	
	sty row11+$22	
	ldy row11+$20
	sty row11+$21
	ldy row11+$1f
	sty row11+$20
	ldy row11+$1e
	sty row11+$1f
	ldy row11+$1d
	sty row11+$1e
	ldy row11+$1c
	sty row11+$1d
	stx $d016			// 4		

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	14
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				15		
	ldy row11+$1b		
	sty row11+$1c
	ldy row11+$1a
	sty row11+$1b
	ldy row11+$19
	sty row11+$1a
	ldy row11+$18
	sty row11+$19
	ldy row11+$17
	sty row11+$18
	ldy row11+$16
	stx $d016			// 4
	sta $d016			// 4		Line 2				16		
	sty row11+$17
	ldy row11+$15
	sty row11+$16
	ldy row11+$14		
	sty row11+$15
	ldy row11+$13
	sty row11+$14
	ldy row11+$12
	sty row11+$13
	ldy row11+$11
	sty row11+$12
	stx $d016			// 4
	sta $d016			// 4		Line 3				17		
	ldy row11+$10
	sty row11+$11
	ldy row11+$0f
	sty row11+$10
	ldy row11+$0e
	sty row11+$0f
	ldy row11+$0d
	sty row11+$0e
	ldy row11+$0c
	sty row11+$0d
	ldy row11+$0b
	stx $d016			// 4
	sta $d016			// 4		Line 4				18
	sty row11+$0c
	ldy row11+$0a
	sty row11+$0b
	ldy row11+$09		
	sty row11+$0a
	ldy row11+$08
	sty row11+$09
	ldy row11+$07
	sty row11+$08
	ldy row11+$06
	sty row11+$07
	stx $d016			// 4
	sta $d016			// 4		Line 5				19		
	ldy row11+$05
	sty row11+$06
	ldy row11+$04
	sty row11+$05
	ldy row11+$03
	sty row11+$04
	ldy row11+$02
	sty row11+$03
	ldy row11+$01
	sty row11+$02
	ldy row11+$00
	stx $d016			// 4
	sta $d016			// 4		Line 6				20 - SPRITE 6 (-1)
	:wait44yspr(5)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 7				00	
	sty row11+$01
	ldy row12+$26	
	sty row12+$27
	ldy row12+$25
	sty row12+$26
	ldy row12+$24
	sty row12+$25
	ldy row12+$23
	sty row12+$24
	ldy row12+$22
	sty row12+$23
	stx $d016			// 4		
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	01
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				02
	ldy row12+$21	
	sty row12+$22	
	ldy row12+$20
	sty row12+$21
	ldy row12+$1f
	sty row12+$20
	ldy row12+$1e
	sty row12+$1f
	ldy row12+$1d
	sty row12+$1e
	ldy row12+$1c
	stx $d016			// 4
	sta $d016			// 4		Line 2				03	
	sty row12+$1d
	ldy row12+$1b		
	sty row12+$1c
	ldy row12+$1a
	sty row12+$1b
	ldy row12+$19
	sty row12+$1a
	ldy row12+$18
	sty row12+$19
	ldy row12+$17
	sty row12+$18
	stx $d016			// 4
	sta $d016			// 4		Line 3				04	
	ldy row12+$16
	sty row12+$17
	ldy row12+$15
	sty row12+$16
	ldy row12+$14		
	sty row12+$15
	ldy row12+$13
	sty row12+$14
	ldy row12+$12
	sty row12+$13
	ldy row12+$11
	stx $d016			// 4
	sta $d016			// 4		Line 4				05	
	sty row12+$12
	ldy row12+$10
	sty row12+$11
	ldy row12+$0f
	sty row12+$10
	ldy row12+$0e
	sty row12+$0f
	ldy row12+$0d
	sty row12+$0e
	ldy row12+$0c
	sty row12+$0d
	stx $d016			// 4
	sta $d016			// 4		Line 5				06		
	ldy row12+$0b
	sty row12+$0c
	ldy row12+$0a
	sty row12+$0b
	ldy row12+$09		
	sty row12+$0a
	ldy row12+$08
	sty row12+$09
	ldy row12+$07
	sty row12+$08
	ldy row12+$06
	stx $d016			// 4
	sta $d016			// 4		Line 6				07		
	sty row12+$07
	ldy row12+$05
	sty row12+$06
	ldy row12+$04
	sty row12+$05
	ldy row12+$03
	sty row12+$04
	ldy row12+$02
	sty row12+$03
	ldy row12+$01
	sty row12+$02
	stx $d016			// 4
	sta $d016			// 4		Line 7				08	
	ldy row12+$00
	sty row12+$01	
	ldy row13+$26	
	sty row13+$27
	ldy row13+$25
	sty row13+$26
	ldy row13+$24
	sty row13+$25
	ldy row13+$23
	sty row13+$24
	ldy row13+$22
	stx $d016			// 4		
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	09
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				10	
	sty row13+$23
	ldy row13+$21	
	sty row13+$22	
	ldy row13+$20
	sty row13+$21
	ldy row13+$1f
	sty row13+$20
	ldy row13+$1e
	sty row13+$1f
	ldy row13+$1d
	sty row13+$1e	
	stx $d016			// 4
	sta $d016			// 4		Line 2				11	
	ldy row13+$1c
	sty row13+$1d
	ldy row13+$1b		
	sty row13+$1c
	ldy row13+$1a
	sty row13+$1b
	ldy row13+$19
	sty row13+$1a
	ldy row13+$18
	sty row13+$19
	ldy row13+$17
	stx $d016			// 4
	sta $d016			// 4		Line 3				12		
	sty row13+$18
	ldy row13+$16
	sty row13+$17
	ldy row13+$15
	sty row13+$16
	ldy row13+$14		
	sty row13+$15
	ldy row13+$13
	sty row13+$14
	ldy row13+$12
	sty row13+$13
	stx $d016			// 4
	sta $d016			// 4		Line 4				13		
	ldy row13+$11
	sty row13+$12
	ldy row13+$10
	sty row13+$11
	ldy row13+$0f
	sty row13+$10
	ldy row13+$0e
	sty row13+$0f
	ldy row13+$0d
	sty row13+$0e
	ldy row13+$0c
	stx $d016			// 4
	sta $d016			// 4		Line 5				14	
	sty row13+$0d
	ldy row13+$0b
	sty row13+$0c
	ldy row13+$0a
	sty row13+$0b
	ldy row13+$09		
	sty row13+$0a
	ldy row13+$08
	sty row13+$09
	ldy row13+$07
	sty row13+$08
	stx $d016			// 4
	sta $d016			// 4		Line 6				15		
	ldy row13+$06
	sty row13+$07
	ldy row13+$05
	sty row13+$06
	ldy row13+$04
	sty row13+$05
	ldy row13+$03
	sty row13+$04
	ldy row13+$02
	sty row13+$03
	ldy row13+$01
	stx $d016			// 4
	sta $d016			// 4		Line 7				16		
	sty row13+$02
	ldy row13+$00
	sty row13+$01
	ldy row14+$26	
	sty row14+$27
	ldy row14+$25
	sty row14+$26
	ldy row14+$24
	sty row14+$25
	ldy row14+$23
	sty row14+$24
	stx $d016			// 4		
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	17
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				18		
	ldy row14+$22
	sty row14+$23
	ldy row14+$21	
	sty row14+$22	
	ldy row14+$20
	sty row14+$21
	ldy row14+$1f
	sty row14+$20
	ldy row14+$1e
	sty row14+$1f
	ldy row14+$1d
	stx $d016			// 4
	sta $d016			// 4		Line 2				19
	
	sty row14+$1e
	ldy row14+$1c
	sty row14+$1d
	ldy row14+$1b		
	sty row14+$1c
	ldy row14+$1a
	sty row14+$1b
	ldy row14+$19
	sty row14+$1a
	ldy row14+$18
	sty row14+$19
	stx $d016			// 4
	sta $d016			// 4		Line 3				20 - SPRITE 7 (-1)
	:wait44yspr(6)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 4				00	
	ldy row14+$17
	sty row14+$18
	ldy row14+$16
	sty row14+$17
	ldy row14+$15
	sty row14+$16
	ldy row14+$14		
	sty row14+$15
	ldy row14+$13
	sty row14+$14
	ldy row14+$12
	stx $d016			// 4
	sta $d016			// 4		Line 5				01		
	sty row14+$13
	ldy row14+$11
	sty row14+$12
	ldy row14+$10
	sty row14+$11
	ldy row14+$0f
	sty row14+$10
	ldy row14+$0e
	sty row14+$0f
	ldy row14+$0d
	sty row14+$0e
	stx $d016			// 4
	sta $d016			// 4		Line 6				02		
	ldy row14+$0c
	sty row14+$0d
	ldy row14+$0b
	sty row14+$0c
	ldy row14+$0a
	sty row14+$0b
	ldy row14+$09		
	sty row14+$0a
	ldy row14+$08
	sty row14+$09
	ldy row14+$07
	stx $d016			// 4
	sta $d016			// 4		Line 7				03		
	sty row14+$08
	ldy row14+$06
	sty row14+$07
	ldy row14+$05
	sty row14+$06
	ldy row14+$04
	sty row14+$05
	ldy row14+$03
	sty row14+$04
	ldy row14+$02
	sty row14+$03
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	04
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				05
	ldy row14+$01
	sty row14+$02
	ldy row14+$00
	sty row14+$01
	ldy row15+$26	
	sty row15+$27
	ldy row15+$25
	sty row15+$26
	ldy row15+$24
	sty row15+$25
	ldy row15+$23
	stx $d016			// 4
	sta $d016			// 4		Line 2				06		
	sty row15+$24
	ldy row15+$22
	sty row15+$23
	ldy row15+$21	
	sty row15+$22	
	ldy row15+$20
	sty row15+$21
	ldy row15+$1f
	sty row15+$20
	ldy row15+$1e
	sty row15+$1f
	stx $d016			// 4
	sta $d016			// 4		Line 3				07		
	ldy row15+$1d
	sty row15+$1e
	ldy row15+$1c
	sty row15+$1d
	ldy row15+$1b		
	sty row15+$1c
	ldy row15+$1a
	sty row15+$1b
	ldy row15+$19
	sty row15+$1a
	ldy row15+$18
	stx $d016			// 4
	sta $d016			// 4		Line 4				08		
	sty row15+$19
	ldy row15+$17
	sty row15+$18
	ldy row15+$16
	sty row15+$17
	ldy row15+$15
	sty row15+$16
	ldy row15+$14		
	sty row15+$15
	ldy row15+$13
	sty row15+$14
	stx $d016			// 4
	sta $d016			// 4		Line 5				09		
	ldy row15+$12
	sty row15+$13
	ldy row15+$11
	sty row15+$12
	ldy row15+$10
	sty row15+$11
	ldy row15+$0f
	sty row15+$10
	ldy row15+$0e
	sty row15+$0f
	ldy row15+$0d
	stx $d016			// 4
	sta $d016			// 4		Line 6				10		
	sty row15+$0e
	ldy row15+$0c
	sty row15+$0d
	ldy row15+$0b
	sty row15+$0c
	ldy row15+$0a
	sty row15+$0b
	ldy row15+$09		
	sty row15+$0a
	ldy row15+$08
	sty row15+$09
	stx $d016			// 4
	sta $d016			// 4		Line 7				11		
	ldy row15+$07
	sty row15+$08
	ldy row15+$06
	sty row15+$07
	ldy row15+$05
	sty row15+$06
	ldy row15+$04
	sty row15+$05
	ldy row15+$03
	sty row15+$04
	ldy row15+$02
	stx $d016			// 4		

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	12
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				13		
	sty row15+$03
	ldy row15+$01
	sty row15+$02
	ldy row15+$00
	sty row15+$01
	ldy row16+$26	
	sty row16+$27
	ldy row16+$25
	sty row16+$26
	ldy row16+$24
	sty row16+$25
	stx $d016			// 4
	sta $d016			// 4		Line 2				14
	ldy row16+$23
	sty row16+$24
	ldy row16+$22
	sty row16+$23
	ldy row16+$21	
	sty row16+$22	
	ldy row16+$20
	sty row16+$21
	ldy row16+$1f
	sty row16+$20
	ldy row16+$1e	
	stx $d016			// 4
	sta $d016			// 4		Line 3				15		
	sty row16+$1f
	ldy row16+$1d
	sty row16+$1e
	ldy row16+$1c
	sty row16+$1d
	ldy row16+$1b		
	sty row16+$1c
	ldy row16+$1a
	sty row16+$1b
	ldy row16+$19
	sty row16+$1a
	stx $d016			// 4
	sta $d016			// 4		Line 4				16		
	ldy row16+$18
	sty row16+$19
	ldy row16+$17
	sty row16+$18
	ldy row16+$16
	sty row16+$17
	ldy row16+$15
	sty row16+$16
	ldy row16+$14		
	sty row16+$15
	ldy row16+$13
	stx $d016			// 4
	sta $d016			// 4		Line 5				17		
	sty row16+$14
	ldy row16+$12
	sty row16+$13
	ldy row16+$11
	sty row16+$12
	ldy row16+$10
	sty row16+$11
	ldy row16+$0f
	sty row16+$10
	ldy row16+$0e
	sty row16+$0f
	stx $d016			// 4
	sta $d016			// 4		Line 6				18		
	ldy row16+$0d
	sty row16+$0e
	ldy row16+$0c
	sty row16+$0d
	ldy row16+$0b
	sty row16+$0c
	ldy row16+$0a
	sty row16+$0b
	ldy row16+$09		
	sty row16+$0a
	ldy row16+$08
	stx $d016			// 4
	sta $d016			// 4		Line 7				19 - SPRITE 8 (-2)
	:wait44yspr(7)		// WAIT
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	20
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				00	
	sty row16+$09
	ldy row16+$07
	sty row16+$08
	ldy row16+$06
	sty row16+$07
	ldy row16+$05
	sty row16+$06
	ldy row16+$04
	sty row16+$05
	ldy row16+$03
	sty row16+$04
	stx $d016			// 4
	sta $d016			// 4		Line 2				01		
	ldy row16+$02
	sty row16+$03
	ldy row16+$01
	sty row16+$02
	ldy row16+$00
	sty row16+$01	
	ldy row17+$26	
	sty row17+$27
	ldy row17+$25
	sty row17+$26
	ldy row17+$24
	stx $d016			// 4
	sta $d016			// 4		Line 3				02		
	sty row17+$25
	ldy row17+$23
	sty row17+$24
	ldy row17+$22
	sty row17+$23
	ldy row17+$21	
	sty row17+$22	
	ldy row17+$20
	sty row17+$21
	ldy row17+$1f
	sty row17+$20
	stx $d016			// 4
	sta $d016			// 4		Line 4				03	
	ldy row17+$1e
	sty row17+$1f
	ldy row17+$1d
	sty row17+$1e
	ldy row17+$1c
	sty row17+$1d
	ldy row17+$1b		
	sty row17+$1c
	ldy row17+$1a
	sty row17+$1b
	ldy row17+$19
	stx $d016			// 4
	sta $d016			// 4		Line 5				04		
	sty row17+$1a
	ldy row17+$18
	sty row17+$19
	ldy row17+$17
	sty row17+$18
	ldy row17+$16
	sty row17+$17
	ldy row17+$15
	sty row17+$16
	ldy row17+$14		
	sty row17+$15
	stx $d016			// 4
	sta $d016			// 4		Line 6				05		
	ldy row17+$13
	sty row17+$14
	ldy row17+$12
	sty row17+$13
	ldy row17+$11
	sty row17+$12
	ldy row17+$10
	sty row17+$11
	ldy row17+$0f
	sty row17+$10
	ldy row17+$0e
	stx $d016			// 4
	sta $d016			// 4		Line 7				06		
	sty row17+$0f
	ldy row17+$0d
	sty row17+$0e
	ldy row17+$0c
	sty row17+$0d
	ldy row17+$0b
	sty row17+$0c
	ldy row17+$0a
	sty row17+$0b
	ldy row17+$09		
	sty row17+$0a
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	07
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				08		
	ldy row17+$08
	sty row17+$09
	ldy row17+$07
	sty row17+$08
	ldy row17+$06
	sty row17+$07
	ldy row17+$05
	sty row17+$06
	ldy row17+$04
	sty row17+$05
	ldy row17+$03
	stx $d016			// 4
	sta $d016			// 4		Line 2				09		
	sty row17+$04
	ldy row17+$02
	sty row17+$03
	ldy row17+$01
	sty row17+$02
	ldy row17+$00
	sty row17+$01	
	ldy row18+$26	
	sty row18+$27
	ldy row18+$25
	sty row18+$26	
	stx $d016			// 4
	sta $d016			// 4		Line 3				10
	ldy row18+$24
	sty row18+$25
	ldy row18+$23
	sty row18+$24
	ldy row18+$22
	sty row18+$23
	ldy row18+$21	
	sty row18+$22	
	ldy row18+$20
	sty row18+$21
	ldy row18+$1f	
	stx $d016			// 4
	sta $d016			// 4		Line 4				11	
	sty row18+$20
	ldy row18+$1e
	sty row18+$1f
	ldy row18+$1d
	sty row18+$1e
	ldy row18+$1c
	sty row18+$1d
	ldy row18+$1b		
	sty row18+$1c
	ldy row18+$1a
	sty row18+$1b
	stx $d016			// 4
	sta $d016			// 4		Line 5				12		
	ldy row18+$19
	sty row18+$1a
	ldy row18+$18
	sty row18+$19
	ldy row18+$17
	sty row18+$18
	ldy row18+$16
	sty row18+$17
	ldy row18+$15
	sty row18+$16
	ldy row18+$14		
	stx $d016			// 4
	sta $d016			// 4		Line 6				13		
	sty row18+$15
	ldy row18+$13
	sty row18+$14
	ldy row18+$12
	sty row18+$13
	ldy row18+$11
	sty row18+$12
	ldy row18+$10
	sty row18+$11
	ldy row18+$0f
	sty row18+$10
	stx $d016			// 4
	sta $d016			// 4		Line 7				14		
	ldy row18+$0e
	sty row18+$0f
	ldy row18+$0d
	sty row18+$0e
	ldy row18+$0c
	sty row18+$0d
	ldy row18+$0b
	sty row18+$0c
	ldy row18+$0a
	sty row18+$0b
	ldy row18+$09		
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	15
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				16		
	sty row18+$0a
	ldy row18+$08
	sty row18+$09
	ldy row18+$07
	sty row18+$08
	ldy row18+$06
	sty row18+$07
	ldy row18+$05
	sty row18+$06
	ldy row18+$04
	sty row18+$05
	stx $d016			// 4
	sta $d016			// 4		Line 2				17		
	ldy row18+$03
	sty row18+$04
	ldy row18+$02
	sty row18+$03
	ldy row18+$01
	sty row18+$02
	ldy row18+$00
	sty row18+$01	
	ldy row19+$26	
	sty row19+$27
	ldy row19+$25
	stx $d016			// 4
	sta $d016			// 4		Line 3				18	
	sty row19+$26
	ldy row19+$24
	sty row19+$25
	ldy row19+$23
	sty row19+$24
	ldy row19+$22
	sty row19+$23
	ldy row19+$21	
	sty row19+$22	
	ldy row19+$20
	sty row19+$21
	stx $d016			// 4
	sta $d016			// 4		Line 4				19 - SPRITE 9 (-2)
	:wait44yspr(8)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 5				20		
	ldy row19+$1f
	sty row19+$20
	ldy row19+$1e
	sty row19+$1f
	ldy row19+$1d
	sty row19+$1e
	ldy row19+$1c
	sty row19+$1d
	ldy row19+$1b		
	sty row19+$1c
	ldy row19+$1a
	stx $d016			// 4
	sta $d016			// 4		Line 6				00
	sty row19+$1b
	ldy row19+$19
	sty row19+$1a
	ldy row19+$18
	sty row19+$19
	ldy row19+$17
	sty row19+$18
	ldy row19+$16
	sty row19+$17
	ldy row19+$15
	sty row19+$16
	stx $d016			// 4
	sta $d016			// 4		Line 7				01		
	ldy row19+$14		
	sty row19+$15
	ldy row19+$13
	sty row19+$14
	ldy row19+$12
	sty row19+$13
	ldy row19+$11
	sty row19+$12
	ldy row19+$10
	sty row19+$11
	ldy row19+$0f
	stx $d016			// 4			
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	02
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				03		
	sty row19+$10
	ldy row19+$0e
	sty row19+$0f
	ldy row19+$0d
	sty row19+$0e
	ldy row19+$0c
	sty row19+$0d
	ldy row19+$0b
	sty row19+$0c
	ldy row19+$0a
	sty row19+$0b
	stx $d016			// 4
	sta $d016			// 4		Line 2				04		
	ldy row19+$09		
	sty row19+$0a
	ldy row19+$08
	sty row19+$09
	ldy row19+$07
	sty row19+$08
	ldy row19+$06
	sty row19+$07
	ldy row19+$05
	sty row19+$06
	ldy row19+$04
	stx $d016			// 4
	sta $d016			// 4		Line 3				05		
	sty row19+$05
	ldy row19+$03
	sty row19+$04
	ldy row19+$02
	sty row19+$03
	ldy row19+$01
	sty row19+$02
	ldy row19+$00
	sty row19+$01	
	ldy row20+$26	
	sty row20+$27
	stx $d016			// 4
	sta $d016			// 4		Line 4				06	
	ldy row20+$25
	sty row20+$26
	ldy row20+$24
	sty row20+$25
	ldy row20+$23
	sty row20+$24
	ldy row20+$22
	sty row20+$23
	ldy row20+$21	
	sty row20+$22	
	ldy row20+$20	
	stx $d016			// 4
	sta $d016			// 4		Line 5				07
	sty row20+$21
	ldy row20+$1f
	sty row20+$20
	ldy row20+$1e
	sty row20+$1f
	ldy row20+$1d
	sty row20+$1e
	ldy row20+$1c
	sty row20+$1d
	ldy row20+$1b		
	sty row20+$1c
	stx $d016			// 4
	sta $d016			// 4		Line 6				08		
	ldy row20+$1a
	sty row20+$1b
	ldy row20+$19
	sty row20+$1a
	ldy row20+$18
	sty row20+$19
	ldy row20+$17
	sty row20+$18
	ldy row20+$16
	sty row20+$17
	ldy row20+$15
	stx $d016			// 4
	sta $d016			// 4		Line 7				09		
	sty row20+$16
	ldy row20+$14		
	sty row20+$15
	ldy row20+$13
	sty row20+$14
	ldy row20+$12
	sty row20+$13
	ldy row20+$11
	sty row20+$12
	ldy row20+$10	
	sty row20+$11
	stx $d016			// 4		
	
	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	10
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				11		
	ldy row20+$0f
	sty row20+$10
	ldy row20+$0e
	sty row20+$0f
	ldy row20+$0d
	sty row20+$0e
	ldy row20+$0c
	sty row20+$0d
	ldy row20+$0b
	sty row20+$0c
	ldy row20+$0a
	stx $d016			// 4
	sta $d016			// 4		Line 2				12		
	sty row20+$0b
	ldy row20+$09		
	sty row20+$0a
	ldy row20+$08
	sty row20+$09
	ldy row20+$07
	sty row20+$08
	ldy row20+$06
	sty row20+$07
	ldy row20+$05
	sty row20+$06
	stx $d016			// 4
	sta $d016			// 4		Line 3				13		
	ldy row20+$04
	sty row20+$05
	ldy row20+$03
	sty row20+$04
	ldy row20+$02
	sty row20+$03
	ldy row20+$01
	sty row20+$02
	ldy row20+$00
	sty row20+$01
	ldy row21+$26
	stx $d016			// 4
	sta $d016			// 4		Line 4				14		
	sty row21+$27
	ldy row21+$25
	sty row21+$26
	ldy row21+$24
	sty row21+$25
	ldy row21+$23
	sty row21+$24
	ldy row21+$22
	sty row21+$23
	ldy row21+$21	
	sty row21+$22	
	stx $d016			// 4
	sta $d016			// 4		Line 5				15		
	ldy row21+$20
	sty row21+$21
	ldy row21+$1f
	sty row21+$20
	ldy row21+$1e
	sty row21+$1f
	ldy row21+$1d
	sty row21+$1e
	ldy row21+$1c
	sty row21+$1d
	ldy row21+$1b		
	stx $d016			// 4
	sta $d016			// 4		Line 6				16		
	sty row21+$1c
	ldy row21+$1a
	sty row21+$1b
	ldy row21+$19
	sty row21+$1a
	ldy row21+$18
	sty row21+$19
	ldy row21+$17
	sty row21+$18
	ldy row21+$16
	sty row21+$17
	stx $d016			// 4
	sta $d016			// 4		Line 7				17		
	ldy row21+$15
	sty row21+$16
	ldy row21+$14		
	sty row21+$15
	ldy row21+$13
	sty row21+$14
	ldy row21+$12
	sty row21+$13
	ldy row21+$11
	sty row21+$12
	ldy row21+$10
	stx $d016			// 4		
	
sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)		18
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				19 - SPRITE 10 (-2)
	:wait44yspr(9)		// WAIT
	stx $d016			// 4
	sta $d016			// 4		Line 2				20		
	sty row21+$11
	ldy row21+$0f
	sty row21+$10
	ldy row21+$0e
	sty row21+$0f
	ldy row21+$0d
	sty row21+$0e
	ldy row21+$0c
	sty row21+$0d
	ldy row21+$0b
	sty row21+$0c
	stx $d016			// 4
	sta $d016			// 4		Line 3				00		
	ldy row21+$0a
	sty row21+$0b
	ldy row21+$09		
	sty row21+$0a
	ldy row21+$08
	sty row21+$09
	ldy row21+$07
	sty row21+$08
	ldy row21+$06
	sty row21+$07
	ldy row21+$05
	stx $d016			// 4
	sta $d016			// 4		Line 4				01		
	sty row21+$06
	ldy row21+$04
	sty row21+$05
	ldy row21+$03
	sty row21+$04
	ldy row21+$02
	sty row21+$03
	ldy row21+$01
	sty row21+$02
	ldy row21+$00
	sty row21+$01	
	stx $d016			// 4
	sta $d016			// 4		Line 5				02
	ldy row22+$26	
	sty row22+$27
	ldy row22+$25
	sty row22+$26
	ldy row22+$24
	sty row22+$25
	ldy row22+$23
	sty row22+$24
	ldy row22+$22
	sty row22+$23
	ldy row22+$21	
	stx $d016			// 4
	sta $d016			// 4		Line 6				03	
	sty row22+$22	
	ldy row22+$20
	sty row22+$21
	ldy row22+$1f
	sty row22+$20
	ldy row22+$1e
	sty row22+$1f
	ldy row22+$1d
	sty row22+$1e
	ldy row22+$1c
	sty row22+$1d
	stx $d016			// 4
	sta $d016			// 4		Line 7				04	
	ldy row22+$1b		
	sty row22+$1c
	ldy row22+$1a
	sty row22+$1b
	ldy row22+$19
	sty row22+$1a
	ldy row22+$18
	sty row22+$19
	ldy row22+$17
	sty row22+$18
	ldy row22+$16	
	stx $d016			// 4			

	sta $d016-mode38,x	// 5 =>40 Bad line (Line 0)	05
	stx $d016			// 4 =>38
	sta $d016			// 4		Line 1				06	
	sty row22+$17
	ldy row22+$15
	sty row22+$16
	ldy row22+$14		
	sty row22+$15
	ldy row22+$13
	sty row22+$14
	ldy row22+$12
	sty row22+$13
	ldy row22+$11
	sty row22+$12
	stx $d016			// 4
	sta $d016			// 4		Line 2				07	
	ldy row22+$10
	sty row22+$11
	ldy row22+$0f
	sty row22+$10
	ldy row22+$0e
	sty row22+$0f
	ldy row22+$0d
	sty row22+$0e
	ldy row22+$0c
	sty row22+$0d
	ldy row22+$0b
	stx $d016			// 4
	sta $d016			// 4		Line 3				08
	sty row22+$0c
	ldy row22+$0a
	sty row22+$0b
	ldy row22+$09		
	sty row22+$0a
	ldy row22+$08
	sty row22+$09
	ldy row22+$07
	sty row22+$08
	ldy row22+$06
	sty row22+$07
	stx $d016			// 4
	sta $d016			// 4		Line 4				09		
	ldy row22+$05
	sty row22+$06
	ldy row22+$04
	sty row22+$05
	ldy row22+$03
	sty row22+$04
	ldy row22+$02
	sty row22+$03
	ldy row22+$01
	sty row22+$02
	ldy row22+$00	

	stx $d016			// 4
	sta $d016			// 4		Line 5				10
	sty row22+$01
	ldy row23+$26	
	sty row23+$27
	ldy row23+$25
	sty row23+$26
	ldy row23+$24
	sty row23+$25
	ldy row23+$23
	sty row23+$24
	ldy row23+$22
	sty row23+$23
	stx $d016			// 4
	sta $d016			// 4		Line 6				11
	// Generic 44 + open low border

	ldx #mode24
	stx $d011	
	tsx
	ldy row23+$21	
	sty row23+$22	
	ldy row23+$20
	sty row23+$21
	ldy row23+$1f
	sty row23+$20
	ldy row23+$1e
	sty row23+$1f
	ldy row23+$1d
	stx $d016			// 4
	sta $d016			// 4		Line 7				12		
	sty row23+$1e
	ldy row23+$1c		
	sty row23+$1d
	ldy row23+$1b		
	sty row23+$1c
	ldy row23+$1a
	sty row23+$1b
	ldy row23+$19
	sty row23+$1a
	ldy row23+$18
	sty row23+$19	
	stx $d016			// 4			
	
	lda #<floor(emptysprite/64)
	sta charscreen2+$3fa
	sta charscreen2+$3fb
	sta charscreen2+$3fc
	sta charscreen2+$3fd
	
	ldy row23+$17
	sty row23+$18
	ldy row23+$16
	sty row23+$17
	ldy row23+$15
	sty row23+$16
	ldy row23+$14		
	sty row23+$15
	ldy row23+$13
	sty row23+$14
	ldy row23+$12
	sty row23+$13
	ldy row23+$11
	sty row23+$12
	ldy row23+$10
	sty row23+$11
	ldy row23+$0f
	sty row23+$10
	ldy row23+$0e
	sty row23+$0f
	ldy row23+$0d
	sty row23+$0e
	ldy row23+$0c
	sty row23+$0d
	ldy row23+$0b
	sty row23+$0c
	ldy row23+$0a
	sty row23+$0b
	ldy row23+$09		
	sty row23+$0a
	ldy row23+$08
	sty row23+$09
	ldy row23+$07
	sty row23+$08
	ldy row23+$06
	sty row23+$07
	ldy row23+$05
	sty row23+$06
	ldy row23+$04
	sty row23+$05
	ldy row23+$03
	sty row23+$04
	ldy row23+$02
	sty row23+$03
	ldy row23+$01
	sty row23+$02
	ldy row23+$00
	sty row23+$01	
	ldy row24+$26	
	sty row24+$27
	ldy row24+$25
	sty row24+$26
	ldy row24+$24
	sty row24+$25
	ldy row24+$23
	sty row24+$24
	ldy row24+$22
	sty row24+$23
	ldy row24+$21	
	sty row24+$22	
	ldy row24+$20
	sty row24+$21
	ldy row24+$1f
	sty row24+$20
	ldy row24+$1e
	sty row24+$1f
	ldy row24+$1d
	sty row24+$1e
	ldy row24+$1c
	sty row24+$1d
	ldy row24+$1b		
	sty row24+$1c
	ldy row24+$1a
	sty row24+$1b
	ldy row24+$19
	sty row24+$1a
	ldy row24+$18
	sty row24+$19
	ldy row24+$17
	sty row24+$18
	ldy row24+$16
	sty row24+$17
	ldy row24+$15
	sty row24+$16
	ldy row24+$14		
	sty row24+$15
	ldy row24+$13
	sty row24+$14
	ldy row24+$12
	sty row24+$13
	ldy row24+$11
	sty row24+$12
	ldy row24+$10
	sty row24+$11
	ldy row24+$0f
	sty row24+$10
	ldy row24+$0e
	sty row24+$0f
	ldy row24+$0d
	sty row24+$0e
	ldy row24+$0c
	sty row24+$0d
	ldy row24+$0b
	sty row24+$0c
	ldy row24+$0a
	sty row24+$0b
	ldy row24+$09		
	sty row24+$0a
	ldy row24+$08
	sty row24+$09
	ldy row24+$07
	sty row24+$08
	ldy row24+$06
	sty row24+$07
	ldy row24+$05
	sty row24+$06
	ldy row24+$04
	sty row24+$05
	ldy row24+$03
	sty row24+$04
	ldy row24+$02
	sty row24+$03
	ldy row24+$01
	sty row24+$02
	ldy row24+$00
	sty row24+$01
	
	lda rightpos
	clc
	adc #$17
	and #$3f
	tax	
	lda buffer+$0000,x
	sta row00
	lda buffer+$0040,x
	sta row01
	lda buffer+$0080,x
	sta row02	
	lda buffer+$00C0,x
	sta row03
	lda buffer+$0100,x
	sta row04
	lda buffer+$0140,x
	sta row05		
	lda buffer+$0180,x
	sta row06
	lda buffer+$01C0,x
	sta row07
	lda buffer+$0200,x
	sta row08	
	lda buffer+$0240,x
	sta row09
	lda buffer+$0280,x
	sta row10
	lda buffer+$02C0,x
	sta row11
	lda buffer+$0300,x
	sta row12	
	lda buffer+$0340,x
	sta row13
	lda buffer+$0380,x
	sta row14
	lda buffer+$03C0,x
	sta row15		
	lda buffer+$0400,x
	sta row16
	lda buffer+$0440,x
	sta row17
	lda buffer+$0480,x
	sta row18	
	lda buffer+$04C0,x
	sta row19
	lda buffer+$0500,x
	sta row20
	lda buffer+$0540,x
	sta row21
	lda buffer+$0580,x
	sta row22	
	lda buffer+$05C0,x
	sta row23
	lda buffer+$0600,x
	sta row24
	jmp backtoirq
