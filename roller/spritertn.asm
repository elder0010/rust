// *******************************
// * Sprite move & copy routines *
// *******************************

// *****************
// * Move To Right *
// *****************

// 1° move right

rmr1:
	ldx #$60
	stx spr0
	ldx #$48
	stx spr1
	ldx #$E8
	stx spr2
	ldx #$08
	stx spr3	
	ldx #$1C 
	stx sprhi	
	sec
	sbc #$02
	tax		
	jsr preparepointers
	jsr updatespriteRR1
	txa
	sec
	sbc #$2a
	jsr preparepointers	
	jsr	clrspriteLL1
	jsr updatespriteLL2
	jmp backfromrm

// 2° move right

rmr2:
	ldx #$68
	stx spr0
	ldx #$50
	stx spr1
	ldx #$f0
	stx spr2
	ldx #$10
	stx spr3	
	ldx #$1C
	stx sprhi
	sec
	sbc #$02
	tax		
	jsr preparepointers	
	jsr updatespriteR3
	txa
	sec
	sbc #$2a
	jsr preparepointers		
	jsr	clrspriteL3
	jsr updatespriteLL1
	jmp backfromrm

// 3° move right

rmr3:
	ldx #$70
	stx spr0
	ldx #$58
	stx spr1
	ldx #$00
	stx spr2
	ldx #$e0
	stx spr3	
	ldx #$2C
	stx sprhi	
	sec
	sbc #$02
	tax		
	jsr preparepointers	
	jsr updatespriteR2
	txa
	sec
	sbc #$2a
	jsr preparepointers	
	jsr	clrspriteL2
	jsr updatespriteL3
	jmp backfromrm

// 4° move right

rmr4:
	ldx #$48
	stx spr0	
	ldx #$60
	stx spr1	
	ldx #$08
	stx spr2	
	ldx #$e8
	stx spr3		
	ldx #$2C
	stx sprhi	
	sec
	sbc #$02
	tax		
	jsr preparepointers	
	jsr updatespriteR1
	txa
	sec
	sbc #$2a
	jsr preparepointers		
	jsr	clrspriteL1
	jsr updatespriteL2
	jmp backfromrm

// 5° move right

rmr5:
	ldx #$50
	stx spr0
	ldx #$68
	stx spr1
	ldx #$10
	stx spr2
	ldx #$f0
	stx spr3	
	ldx #$2C
	stx sprhi	
	sec
	sbc #$02
	tax		
	jsr preparepointers	
	jsr updatespriteRR3
	txa
	sec
	sbc #$2a
	jsr preparepointers
	jsr	clrspriteLL3
	jsr updatespriteL1
	jmp backfromrm

// 6° move right

rmr6:
	ldx #$58
	stx spr0
	ldx #$70
	stx spr1
	ldx #$e0
	stx spr2
	ldx #$00
	stx spr3	
	ldx #$1C
	stx sprhi	
	sec
	sbc #$02
	tax		
	jsr preparepointers	
	jsr updatespriteRR2
	txa
	sec
	sbc #$2a
	jsr preparepointers		
	jsr	clrspriteLL2
	jsr updatespriteLL3
	jmp backfromrm

	
// *****************
// * Move To Left *
// *****************

// 1° move left	
	
rml1:
	ldx #$50
	stx spr0
	ldx #$68
	stx spr1
	ldx #$10
	stx spr2
	ldx #$f0
	stx spr3
	ldx #$2C 
	stx sprhi
	tax
	jsr preparepointers
	jsr clrspriteLL3
	jsr updatespriteLL1
	txa
	sec
	sbc #$14
	jsr preparepointers	
	jsr updatespriteRR2
	jmp backfromrm

// 2° move left

rml2:
	ldx #$48
	stx spr0
	ldx #$60
	stx spr1
	ldx #$08
	stx spr2
	ldx #$e8
	stx spr3
	ldx #$2C
	stx sprhi
	tax
	jsr preparepointers
	jsr clrspriteL1
	jsr updatespriteLL2
	txa
	sec
	sbc #$14
	jsr preparepointers		
	jsr updatespriteRR3
	jmp backfromrm	
	
// 3° move left
	
rml3:
	ldx #$70
	stx spr0
	ldx #$58
	stx spr1
	ldx #$00
	stx spr2
	ldx #$e0
	stx spr3
	ldx #$2C
	stx sprhi
	tax
	jsr preparepointers
	jsr clrspriteL2
	jsr updatespriteLL3
	txa
	sec
	sbc #$14
	jsr preparepointers		
	jsr updatespriteR1
	jmp backfromrm              	
	
// 4° move left
	
rml4:
	ldx #$68
	stx spr0	
	ldx #$50
	stx spr1	
	ldx #$f0
	stx spr2	
	ldx #$10
	stx spr3	
	ldx #$1C
	stx sprhi
	tax
	jsr preparepointers
	jsr clrspriteL3
	jsr updatespriteL1
	txa
	sec
	sbc #$14
	jsr preparepointers		
	jsr updatespriteR2
	jmp backfromrm

// 5° move left

rml5:
	ldx #$60
	stx spr0
	ldx #$48
	stx spr1
	ldx #$e8
	stx spr2
	ldx #$08
	stx spr3
	ldx #$1C
	stx sprhi
	tax
	jsr preparepointers
	jsr clrspriteLL1
	jsr updatespriteL2
	txa
	sec
	sbc #$14
	jsr preparepointers
	jsr updatespriteR3
	jmp backfromrm

// 6° move left

rml6:
	ldx #$58
	stx spr0
	ldx #$70
	stx spr1
	ldx #$e0
	stx spr2
	ldx #$00
	stx spr3
	ldx #$1C
	stx sprhi
	tax
	jsr preparepointers
	jsr clrspriteLL2
	jsr updatespriteL3
	txa
	sec
	sbc #$14
	jsr preparepointers		
	jsr updatespriteRR1	
	jmp backfromrm
	
// Jump tables
	
.align $10
rmrjmptbl:
.byte	<rmr1,>rmr1
.byte	<rmr2,>rmr2
.byte	<rmr3,>rmr3
.byte	<rmr4,>rmr4
.byte	<rmr5,>rmr5
.byte	<rmr6,>rmr6

.align $10
rmljmptbl:
.byte	<rml1,>rml1
.byte	<rml2,>rml2
.byte	<rml3,>rml3
.byte	<rml4,>rml4
.byte	<rml5,>rml5
.byte	<rml6,>rml6


// Jump table sequence

rsequence:
.byte $2,$0,$4,$0,$6,$0,$8,$0,$a,$0,$0

lsequence:
.byte $a,$0,$0,$0,$2,$0,$4,$0,$6,$0,$8
