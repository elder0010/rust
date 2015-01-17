.pc=* "Story parse routines"

// Fetch instruction
// *****************
parse:
	ldy #$00
	bit waitmode
	bpl !+
	lda (waitbyte),y
	cmp waitvalue
	beq !+
	rts
!:
	sty waitmode
	dec framewait
	bmi readinst
	rts
readinst:	
	lda (storyptr),y
	sta cmd	
	bne !+
	jmp exit
!:
	jsr xparse
advance:
	lsr loopinst	
	bcs !+	
	clc
	lda storyptr	
	adc instrlen
	sta storyptr
	lda storyptr+1
	adc #$00	
	sta storyptr+1	
!:
	rts
	
// Decode instruction
// ******************	
xparse:
	asl			// Check 1xxx.xxxx
	bcc !+
	jmp pcbar
!:
	asl			// Check 01xx.xxxx
	bcc !+
	jmp pcfor
!:
	asl			// Check 001x.xxxx
	bcc !+
	jmp ptwst
!:
	asl			// Check 0001.xxxx
	bcc !+
	jmp pcont
!:
	asl			// Check 0000.1xxx
	bcc !+
	jmp ploop
!:
	asl			// Check 0000.01xx
	bcc !+
	jmp pmult
!:
	asl			// Check 0000.001x
	bcc !+
	jmp pwait	
!:	
	jmp pmove	// Exec  0000.0001
	

// Execute instruction
// *******************	
	
// Change bar color
// ****************
pcbar:	
	ldy #<fadetoblack
	asl
	bcc !+
	ldy #<fadetowhite
!:
	sty fdtbl1+1	
	ldx #$00
fdloop1:
	lsr cmd
	bcc !+	
	ldy rm0,x	
fdtbl1:	
	lda fadetoblack,y
	sta rm0,x
!:
	inx
	cpx #6
	bne fdloop1
	lda #$00
	sta framewait
	lda #$01
	sta instrlen
	rts
	
// Change fore color
// *****************
pcfor:
	ldy #<fadetoblack
	asl	
	bcc !+
	ldy #<fadetowhite
!:
	sty fdtbl2+1	
	ldx #$00
fdloop2:
	lsr cmd
	bcc !+	
	ldy ub,x	
fdtbl2:	
	lda fadetoblack,y
	sta ub,x
!:
	inx
	cpx #5
	bne fdloop2
	lda #$00
	sta framewait
	lda #$01
	sta instrlen
	rts
	
// Change twister color
// ********************
ptwst:	
	ldy #<fadetoblack
	asl
	bcc !+
	ldy #<fadetowhite
!:
	sty fdtbl3+1
	ldy #<c1_1
	asl
	bcc !+
	ldy #<c1_2
!:
	sty twstl+1	
	sty twsts+1
	ldx #$00
fdloop3:
	lsr cmd
	bcc !+	
twstl:
	ldy c1_1,x	
fdtbl3:	
	lda fadetoblack,y
twsts:
	sta c1_1,x
!:
	inx
	cpx #3
	bne fdloop3
	lda #$00
	sta framewait
	lda #$01
	sta instrlen
	rts
	
// Continue
// ********	
pcont:
	lda cmd
	and #$0f
	sta framewait
	lda #$01
	sta instrlen	
	rts
	
// Loop
// ****
ploop:
	lda cmd
	and #$07
	tax
	lda power2,x
	sta loopinst
	inc storyptr
	bne !+
	inc storyptr+1
!:
	jmp readinst

// Multi instruction 
// *****************
pmult:
	lda cmd
	and #$03
	sta multicount
	lda #$01
	sta mcloopfix	
pmloop:
	lda #$00
	sta framewait	
	ldy multicount
	iny	
	lda (storyptr),y
	sta cmd
	jsr xparse
	clc
	lda mcloopfix
	adc instrlen
	sta mcloopfix
	dec multicount
	bpl pmloop
	lda #$00
	sta framewait	
	lda mcloopfix	
	sta instrlen
	rts
	
// Move instruction 
// ****************
pmove:
	ldy #$01
	lda (storyptr),y
	sta curmove	
	lda #$02
	sta instrlen
	lda #$00
	sta framewait
	rts	
	
// Wait instruction 
// ****************
pwait:
	iny
	lda (storyptr),y
	sta waitbyte-1,y
	cpy #$02
	bne pwait
	iny	
	lda (storyptr),y
	sta waitvalue
	iny
	sty instrlen
	lda #$00
	sta framewait	
	ror				// Carry set from previous comparison
	sta waitmode
	rts
	
// Exit effects
// ************
exit:
	lda #<storyend
	sta storyptr
	lda #>storyend
	sta storyptr+1
	lda #$80
	sta $1f
	lda #$00
	sta framewait
	sta instrlen
	jmp advance

power2:
.fill 8,[1<<[i+1]]-1
	
.align $20
fadetowhite:
.byte	$06,$01,$0b,$0f,$08,$0a,$09,$0d,$0e,$02,$03,$04,$05,$01,$0c,$07
fadetoblack:
.byte	$00,$0d,$09,$0a,$0b,$0c,$00,$0f,$04,$06,$05,$02,$0e,$07,$08,$03	

//       00  01  02  03  04  05  06  07  08  09  0a  0b  0c  0d  0e  0f
	