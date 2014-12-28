init_sprites:
		lda #0
		sta $d015

		lda #$ff
		sta $d017
		sta $d01d

		lda #0
		sta $d01b

		//;bne !- ?

		//;Resetto lo sprite per sicurezza
		lda #0
		ldx #$40
!:
		sta sprite_bar,x
		dex
		bpl !-		

		//;Creo l'ultimo sprite (sopra)
		lda #$ff
		ldx #$3*4-1
!:
		sta sprite_bar,x
		dex
		bpl !-

		lda #[sprites/$40] 
		ldx #2
!:
		sta screenChars+$03f8,x
		dex
		bpl !-

		clc
		adc #1
		sta $d002
		sta $d003

		lda #$80
		sta $d010

		lda #PURPLE
		sta cover_sprite_colour
		rts



mplex_sprite_bar:
		sec
		lda irq_line_stop
		
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f

		rts

point_sprite_barra:
		lda #[sprite_bar/$40] 
		ldx #8
!:
		sta screenChars+$03f8,x
		sta screenPixels_final+$03f8,x
		dex
		bpl !-

		sec
sprite_line:
		lda #$ff
		sbc #1
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f

		ldx #8
!:
		lda cover_sprite_colour
		sta $d027,x
		dex
		bpl !-
		clc
		lda #22
		sta $d000
		adc #46
		sta $d004
		adc #46
		sta $d006
		adc #46
		sta $d008
		adc #46
		sta $d00a
		adc #46
		sta $d00c
		adc #46
		sta $d00e

		lda #$ff
		sta $d015

		lda #0
		sta $d017
		rts


.align $10

color_cycle_tbl:
.byte LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN
.byte GREEN,GREEN,GREEN
.byte GRAY,GRAY,GRAY
.byte PURPLE

/*
.byte LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN
.byte CYAN,CYAN,CYAN
.byte LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE,PURPLE
*/
chrs_tbl:
.byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
.byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$15

fade_in_sprites:
		ldx fade_pt

		lda color_cycle_tbl,x
		sta bgcl1+1
		sta cover_sprite_colour
		ldy #$b0
		:wait()
		sta $d020

		lda chrs_tbl,x
		sta chrs1+1
dly:
		lda #0
		eor #$ff
		sta dly+1
		beq !+
		inc fade_pt
		lda fade_pt
		cmp #16
		bne !+
		lda #>no_fade
		sta fade_rt+2
		lda #<no_fade
		sta fade_rt+1
		lda #0
		sta bgcl1+1

		lda #$ee //;inc
		sta goincr
!:
		rts

no_fade:
		rts

.var y_offs_logo = 2
.var correzione_offset = $155
draw_logo:
		ldx #0
!:

		lda logo_lut,x
		sta screenChars+y_offs_logo*$28,x
		lda logo_lut+$100,x
		sta screenChars+y_offs_logo*$28+$100,x
		lda logo_lut+correzione_offset,x
		sta screenChars+y_offs_logo*$28+correzione_offset,x
		dex
		bne !-

		lda #0
		ldx #$28
!:
		sta $d800,x
		sta $d800+$27,x
		dex
		bpl !-

		lda #>nocol
		sta skp+2
		lda #<nocol
		sta skp+1

		rts

draw_logo_cols:
		ldx #$a0
!:
		lda logo_cols,x
		sta $d800+y_offs_logo*$28,x

		lda logo_cols+$a0,x
		sta $d800+$a0+y_offs_logo*$28,x

		lda logo_cols+$100,x
		sta $d800+y_offs_logo*$28+$100,x

		lda logo_cols+$1a0,x
		sta $d800+y_offs_logo*$28+$1a0,x

		lda logo_cols+correzione_offset,x
		sta $d800+y_offs_logo*$28+correzione_offset,x
		dex
		bne!-

		//;Ritocchino
		lda #BLUE
		ldx #18
!:
		sta $d800+[16*$28]+$10,x
		dex
		bne !-

		lda #0
		sta $d800+[16*$28]+$25
		rts

ritocchino_finale_colori:
		ldx #$28
		lda #0
!:
		sta $d800+$28*17,x
		sta $d800+$28*18,x
		sta $d800+$28*19,x
		dex
		bpl !-

		rts

.var start_line = 10
.var num_lines = 5
draw_logo_intro:
		ldx #$28
!:
		lda logo_lut+[start_line*$28],x

		.for(var t=0;t<25;t++)
		{
			sta screenChars+t*$28,x
		}
		dex
		bne !-

		ldx #$28
!:
		lda line_col
		sta $d800+0*$28,x
		sta $d800+0*$22,x
		sta $d800+7*$28,x
		sta $d800+14*$28,x
		sta $d800+21*$28,x
		lda line_col+1
		sta $d800+1*$28,x
		sta $d800+8*$28,x
		sta $d800+15*$28,x
		sta $d800+22*$28,x
		lda line_col+2
		sta $d800+2*$28,x
		sta $d800+9*$28,x
		sta $d800+16*$28,x
		sta $d800+23*$28,x
		lda line_col+3
		sta $d800+3*$28,x
		sta $d800+10*$28,x
		sta $d800+17*$28,x
		sta $d800+24*$28,x
		lda line_col+4
		sta $d800+4*$28,x
		sta $d800+11*$28,x
		sta $d800+18*$28,x
		sta $d800+25*$28,x
		lda line_col+5
		sta $d800+5*$28,x
		sta $d800+12*$28,x
		sta $d800+19*$28,x
		
		lda line_col+6
		sta $d800+6*$28,x
		sta $d800+13*$28,x
		sta $d800+20*$28,x
		dex
		bne !-
		
		
		ldy #25
!:
		lda #BLUE
l1:
		sta $d801
l3:
		sta $d822
l2:
		sta $d800+$25

		:go_down_one_line(l1)
		:go_down_one_line(l2)
		:go_down_one_line(l3)
		dey
		bne !-

	
		rts

.align $5
line_col:
.byte RED,PURPLE,LIGHT_BLUE,CYAN,LIGHT_GREEN,YELLOW,WHITE



.pc = * "close routine"
//;Blocca i gli irq dove necessario
close_scene:
		rts


//;-------------------------------------------------
//;Fade finale del logo
arrow_fade:

		lda $1728
		cmp #$36
		bne !+
		inc can_dl+1		
		//;inc $d020
!:
		
can_dl:
		lda #0
		beq !+
		inc fdl+1
fdl:
		lda #0
		cmp #6
		bne !+

		lda #1
		sta can_fade_away+1
!:

can_fade_away:
		lda #0
		bne !+
.if(MUSIC_SYNC==1){
		rts
		}
!:


wtt:
		lda #0
		eor #$ff
		sta wtt+1
		bne skp2

		jmp nomove
skp2: 
		lda #>$d800+[y_offs_logo*$28]
		sta blackline+2
		lda #<$d800+[y_offs_logo*$28]
		sta blackline+1


start_offs:
		ldx #0
		ldy #0
!:
		lda #0
		
blackline:
		sta $d800+[y_offs_logo*$28],x
		
		:go_down_one_line(blackline) 
		iny
end_offs:
		cpy #15
		bne !-
		inc start_offs+1
nomove:
		lda start_offs+1
		cmp #$28
		bne !+

		lda chrs_tbl
		sta chrs1+1

		lda irq_line_stop
		sta line_mov+1
		lda #1
		sta must_go_outro+1
!:
		
		rts

.import source "outro_irq.asm"

.macro go_down_one_line(target){
	clc
	lda target+1
	adc #40
	sta target+1
	bcc !+
	inc target+2
!:
}

clear_charset:
		lda #0
		ldx #0
!:
		.for(var t=0;t<8;t++){
			sta $2800+t*$100,x
		}
		dex
		bne !-

		rts
