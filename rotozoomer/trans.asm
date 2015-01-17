.const	linepos	=	$40
.const	savey	=	$41
.const	counter	=	$42

trans:	
	sei
	lda #$00
	sta $d012
	lda #<rst0
	sta $fffe
	lda #>rst0
	sta $ffff
	lda #$01
	sta $d01a
	lda #$35
	sta $01
	lda #$7f
	sta $dc0d
	bit $dc0d
	lda #$00	
	sta $d011
	lsr $d019	
	jsr transinit
	cli	
	jmp *


// Raster 0 effetto
// ****************	
.pc=* "Raster 0"
rst0:
	pha
	txa
	pha
	tya
	pha
	lsr $d019
	cli
	lda linepos
	sta $d012
	lda #<rstfx1
	sta $fffe
	lda #>rstfx1
	sta $ffff	
	ldy counter
	ldx sinus,y
	lda jmptbl,x
	sta jumper+1
	lda jmptbh,x
	sta jumper+2
	inc counter
	jsr $1003
	pla
	tay
	pla
	tax
	pla
	rti		

.pc=* "Raster Fx 1 - Presync"	
rstfx1:
	sta savea		//3 + 7 + 2-9
	lsr $d019		//6
	clc				//2
	lda.a linepos	//4
	adc #$02		//2
	sta $d012		//4
	lda #<rstfx2	//2
	sta $fffe		//4
	lda #>rstfx2	//2
	sta $ffff		//4	
	lda #$02		//2
	stx savex		//3
	sty savey		//3
	cli				//2 => 52/59
	.fill  6,NOP
	.fill 32,NOP	

.pc=* "Raster Fx 2 - Sync"		
rstfx2:
	ldx #$08	// 2+5*(8-1)+4 = 46	=> 7+2+0/1
!:
	dex			// 
	bne !-		// - 55+0/1
	ldx #$01	// 2
	bit $ff	
	lda $d012	// 4 
	cmp $d012	// 4
	beq jumper
jumper:
	jmp jmp0
cont:		
	lsr $d019	
	lda #<rst0
	sta $fffe
	lda #>rst0
	sta $ffff
	lda #$00
	sta $d012	
	pla
	pla
	pla
	lda savea
	ldx savex
	ldy savey
	rti
		
			
transinit:
	lda #[312/2]-1
	sta linepos
	rts
	
jmp0:
	stx $d020	// 4
	ldx #$09
!:	
	dex
	bne !-
	bit $ff
	sty $d020	// 4
	jmp cont
	
jmp1:
	nop
	stx $d020	// 4
	ldx #$08
!:	
	dex
	bne !-
	nop
	nop
	sty $d020	// 4
	jmp cont
	
jmp2:
	bit $ff	
	stx $d020	// 4
	ldx #$08
!:	
	dex
	bne !-	
	nop
	sty $d020	// 4
	jmp cont
	
jmp3:
	nop
	nop
	stx $d020	// 4
	ldx #$08
!:	
	dex
	bne !-	
	sty $d020	// 4
	jmp cont	
	
jmp4:
	nop
	bit $ff
	stx $d020	// 4
	ldx #$07
!:	
	dex
	bne !-	
	bit $ff
	sty $d020	// 4
	jmp cont		

jmp5:
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$06
!:	
	dex
	bne !-	
	nop
	nop
	nop
	sty $d020	// 4
	jmp cont		

jmp6:
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$06
!:	
	dex
	bne !-	
	nop
	nop
	sty $d020	// 4
	jmp cont			
	
jmp7:
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$06
!:	
	dex
	bne !-	
	nop	
	sty $d020	// 4
	jmp cont				

jmp8:
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$06
!:	
	dex
	bne !-	
	sty $d020	// 4
	jmp cont

jmp9:
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$05
!:	
	dex
	bne !-		
	bit $ff
	sty $d020	// 4
	jmp cont	
	
jmp10:
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$04
!:	
	dex
	bne !-	
	nop
	nop
	nop
	sty $d020	// 4
	jmp cont	

jmp11:
	nop
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$04
!:	
	dex
	bne !-		
	nop
	nop
	sty $d020	// 4
	jmp cont		
	
jmp12:
	nop
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$04
!:	
	dex
	bne !-	
	nop
	sty $d020	// 4
	jmp cont			
	
jmp13:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$04
!:	
	dex
	bne !-	
	sty $d020	// 4
	jmp cont

jmp14:
	nop
	nop
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$03
!:	
	dex
	bne !-	
	bit $ff
	sty $d020	// 4
	jmp cont
	
jmp15:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$02
!:	
	dex
	bne !-
	nop
	nop
	nop	
	sty $d020	// 4
	jmp cont	
	
jmp16:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$02
!:	
	dex
	bne !-	
	nop
	nop	
	sty $d020	// 4
	jmp cont		
	
jmp17:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$02
!:	
	dex
	bne !-		
	nop	
	sty $d020	// 4
	jmp cont			
	
jmp18:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4
	ldx #$02
!:	
	dex
	bne !-			
	sty $d020	// 4
	jmp cont
	
jmp19:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4
	ldx #$01
!:	
	dex
	bne !-	
	bit $ff	
	sty $d020	// 4
	jmp cont	
	
jmp20:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4	
	nop
	nop
	bit $ff	
	sty $d020	// 4
	jmp cont
	
jmp21:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	stx $d020	// 4	
	nop
	bit $ff	
	sty $d020	// 4
	jmp cont	

jmp22:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bit $ff
	stx $d020	// 4		
	bit $ff	
	sty $d020	// 4
	jmp cont			
	
jmp23:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	tya
	ldy #$00	
	stx $d020	// 4			
	sta $d020,y	// 5
	jmp cont			
	

jmptbl:
.byte <jmp0,<jmp1,<jmp2,<jmp3,<jmp4,<jmp5,<jmp6,<jmp7,<jmp8,<jmp9,<jmp10,<jmp11,<jmp12,<jmp13,<jmp14,<jmp15,<jmp16,<jmp17,<jmp18,<jmp19,<jmp20,<jmp21,<jmp22,<jmp23
jmptbh:
.byte >jmp0,>jmp1,>jmp2,>jmp3,>jmp4,>jmp5,>jmp6,>jmp7,>jmp8,>jmp9,>jmp10,>jmp11,>jmp12,>jmp13,>jmp14,>jmp15,>jmp16,>jmp17,>jmp18,>jmp19,>jmp20,>jmp21,>jmp22,>jmp23

sinus:
.fill 256,floor(11.5+11.5*sin(PI*i/128))
