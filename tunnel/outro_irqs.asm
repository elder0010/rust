.import source "tunnel.sym"


.var	TEST_MODE = 0
.if (cmdLineVars.get("test")==null) .eval TEST_MODE=0
							   else .eval TEST_MODE=cmdLineVars.get("test").asNumber()

.const	savea		=	$30
.const	savex		=	$31
.const	savey		=	$32
.const	rstcount	=	$33
.const	temp		=	$34
.const	storyptr	=	$36
.const	band		=	$38
.const	dir			=	$39
.const	moveindex	=	$3a
.const	movewait	=	$3b
.const	cmd			=	$3c
.const	wait		=	$3d
.const	stop		=	$3f

.const	flag		=	$1f

.var sid=LoadSid("psycho.sid")

.if (TEST_MODE==1) {
	:BasicUpstart2(start)
	.var music = LoadSid("psycho.sid")
	.pc=music.location "Music" 
	.fill music.size, music.getData(i)
}

.if (TEST_MODE==1) .pc=$4000
			  else .pc=$F000
start:
	stx exit+1
	sty exit+2
	.if (TEST_MODE==1) {
		lda #$00
		jsr sid.init
	}
	lda #$00
	sta moveindex
	sta movewait
	sta cmd
	sta wait
	sta band
	sta dir
	sta stop
	sta rstcount
	lda #<story
	sta storyptr
	lda #>story
	sta storyptr+1	
	lda #BIT_ABS
	sta player_to_kill		// Sorry Elder, you won't play the SID in this frame!
	lda #$00
	sta $d015
waitrst:
	lda $d011
	asl
	lda $d012
	ror
	cmp #150
	bne waitrst
	sei
	lda #$00
	sta $d011
	sta $d012
	lda #<preirq
	sta $fffe
	lda #>preirq
	sta $ffff		
.if(TEST_MODE==1){
	lda #$7f
	sta $dc0d
	bit $dc0d
	lda #$01
	sta $d01a
	lda #$35
	sta $01
	lsr $d019
}
	cli
	.if (TEST_MODE==1)	jmp *
	rts

.pc=* "TEST"
preirq:
	pha
	txa
	pha
	tya
	pha
	lsr $d019
	cli		
	jsr calcrast
	jsr parsestory	
	lda rasttbl+1
	sta $d012	
	lda rasttbh+1
	sta $d011
	lda bndcol
	sta $d020
	lda #$01
	sta rstcount
	lda #<rastirq1
	sta $fffe
	lda #>rastirq1
	sta $ffff
	jsr sid.play
	pla
	tay
	pla
	tax
	pla
	rti
	
rastirq1:	
	sta savea			// 3+7+2/9
	stx savex			// 3
	ldx rstcount		// 3
	clc					// 2
	lda rasttbl,x		// 4
	adc #$02			// 2
	sta $d012			// 4		
	rol					// 2
	ora rasttbh,x		// 4
	lsr					// 2
	lda #$00			// 2
	ror					// 2
	sta $d011			// 4
	lsr $d019			// 6
	lda #<rastirq2		// 2
	sta $fffe			// 4
	lda #>rastirq2		// 2
	sta $ffff			// 4
	lda rstcol,x		// 4
	cli					// 2 - 66+(7)
	.fill 31,NOP		// Next line

rastirq2:	
	pha				//3	+9+0/1
	inx				//2
	txa				//2
	and #$07		//2
	tax				//2
	lda lorst,x		//4
	sta $fffe		//4
	lda hirst,x		//4
	sta $ffff		//4
	lda rasttbh,x	//4
	lsr				//2
	ror				//2
	sta $d011		//4
	pla				//4	
	stx rstcount	//3	
	ldx $d012		//4
	cpx $d012		//4
	beq !+			//2/3
!:
	sta $d020		//4 55
	ldx rstcount	//3
	lda rasttbl,x	//4
	sta $d012		//4
	lda bndcol,x	//4
	lsr $d019		//6
	tax				//2
	pla				//4
	pla				//4	
	pla				//4
	lda.a savea		//4 - 39
	.fill 10,NOP	//20
	stx $d020		//4	
	ldx savex	
	rti
	
	
calcrast:
	ldy #$01
	ldx rastpt,y
	clc
	lda sinus,x
	adc #$14
	sta rasttbl,y
	lda #$00
	adc #$00
	sta rasttbh,y
!:	
	ldx rastpt+1,y
	clc
	lda rasttbl,y	
	adc sinus,x
	sta rasttbl+1,y
	lda rasttbh,y	
	adc #$00
	sta rasttbh+1,y	
	iny
	cpy #$07	
	bne !-
	.for(var j=0;j<2;j++)
		.for(var i=1;i<8;i++)
		 {
			lsr rasttbh+i
			ror rasttbl+i
		}
	sec
	lda rasttbl+7
	sbc rasttbl+1
	cmp #203	
	beq !+
	rts
!:
	rts

	
// Parse/exec story configuration
// ******************************
parsestory:
	ldy #$00			// Check wait byte
	dec wait
	bpl domove
	lda (storyptr),y	// Exit?
	sta cmd
	bne !+
	jsr exit			// YES!
	jmp domove
!:
	inc storyptr
	bne !+
	inc storyptr+1
!:
	jsr doparse
domove:
	bit cmd
	bpl docolor
	dec moveindex
	bpl docolor
	lda movewait
	sta moveindex
	.for(var i=1;i<8;i++) inc rastpt+i
docolor:
	bit cmd
	bvc doexit
	ldx band 
	lda bndcol,x	
	clc
	adc dir
	tay
	lda fadetowhite,y
	sta bndcol,x
doexit:
	rts
	
	
doparse:
	bit cmd				// Check color conf
	bvc checkmove
	ldx #$01
	lda cmd	
	sax wait			// Save wait	
	ldx #$0f
	lsr	
	sax band			// Save band
	and #$10	
	sta dir				// Save dir
	rts
checkmove:
	bit cmd				// Check move conf
	bpl checkwait	
	lda cmd
	ldx #$07	
	sax wait
	lda cmd
	lsr
	lsr
	lsr	
	sax movewait
	rts
checkwait:
	lda cmd	
	ldx #$1f
	sax wait
	and #$20
	beq !+	
	eor #$A0
	sta cmd
!:
	rts

	
exit:
	bit exit
	lda #$80
	sta flag
	sta wait
	rts


.align $8
.pc=* "Tabelle"
lorst:
.byte	<preirq,<rastirq1,<rastirq1,<rastirq1,<rastirq1,<rastirq1,<rastirq1,<rastirq1
hirst:
.byte	>preirq,>rastirq1,>rastirq1,>rastirq1,>rastirq1,>rastirq1,>rastirq1,>rastirq1
rasttbl:
.byte	<0,<40,<90,<120,<200,<220,<240,<300
rasttbh:
.byte	>0,>40,>90,>120,>200,>220,>240,>300
.align $10
bndcol:
.byte	PURPLE,RED,RED,RED,RED,RED,RED,RED
rstcol:
.byte	BROWN,BROWN,RED,RED,RED,RED,RED,BROWN
rastpt:
.fill	8,36+23*i	//28-24
fadetowhite:
.byte	$06,$01,$0b,$0f,$08,$0a,$09,$0d,$0e,$02,$03,$04,$05,$01,$0c,$07
fadetoblack:
.byte	$00,$0d,$09,$0a,$0b,$0c,$00,$0f,$04,$06,$05,$02,$0e,$07,$08,$03
.pc=* "Sinus"
sinus:
.fill	256,floor(140+100*sin(2*i*PI/128))

.const	MOVE	=	1
.const	STOP	=	0
.const	BLOCK	=	0
.const	LINE	=	1
.const	TOBLACK	=	1
.const	TOWHITE	=	0

.import source "story.asm"


/*
10ssswww OK
M1drbbbw OK
001wwwww OK
00000000 OK
*/

// *****
// MACRO
// *****

// Activate sinus movement
// ***********************
// speed: 1 slow - 8 fast
// wait: number of frame
.macro move(speed,wait) {
	.byte	128|[[[8-speed]&7]*8]|[[wait-1]&7]
}

// Change bar color
// ****************
// move: STOP/MOVE, stop or continue last move settings)
// block: 0-7, number of the affected block
// type: LINE/BLOCK, type of affected block (LINEs are the lines between BLOCKs)
// dir: TOBLACK/TOWHITE, direction of the fade
// wait: 1-2 number of frame (and so number of color changes)
.macro fade(move,block,type,dir,wait) {
	.byte	[[move&1]*128]|64|[[dir&1]*32]|[[type&1]*16]|[[block&7]*2]|[[wait-1]&1]
}

// Continue last movement
// **********************
// wait: 1-32, number of frame
.macro continue(wait) {
	.byte  32|[[wait-1]&31]
}

// Pause effects
// **********************
// wait: 1-32, number of frame
.macro stop(wait) {
	.byte	[wait-1]&31
}
	
// Stop and go to next scene
// *************************
.macro stopall() {
	.byte 0
}


