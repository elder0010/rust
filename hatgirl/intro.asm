.align 7*3
irq_table:
.byte $00,$1c,$72,$8b,$b4,$fa,$30-2


d011_table:
.byte $00,$00,$00,$00,$00,$00,$80



.align 20
irq_ptr:
.byte $0

current_fade_pt:
.byte $0

bg_colour:
.byte DARK_GRAY,ORANGE,RED
.byte GRAY,BROWN,DARK_GRAY,BROWN

cur_colour:
.byte BROWN,BROWN,BROWN
.byte BROWN,BROWN,BROWN
.byte BROWN

cur_line_colour:
.byte BROWN,BROWN,BROWN
.byte BROWN,BROWN,BROWN
.byte BROWN

.align 30
fade_tbl:
.byte RED,RED,RED
.byte DARK_GRAY,DARK_GRAY,DARK_GRAY
.byte ORANGE,ORANGE,ORANGE
.byte GRAY,GRAY,GRAY
.byte LIGHT_RED,LIGHT_RED,LIGHT_RED
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte YELLOW,YELLOW,YELLOW
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte LIGHT_RED,LIGHT_RED,LIGHT_RED
.byte GRAY,GRAY,GRAY


.align 30
fade_tbl_lines:
.byte YELLOW,YELLOW,YELLOW
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte RED,RED,RED
.byte DARK_GRAY,DARK_GRAY,DARK_GRAY
.byte ORANGE,ORANGE,ORANGE
.byte GRAY,GRAY,GRAY
.byte PURPLE,PURPLE,PURPLE
.byte DARK_GRAY,DARK_GRAY,DARK_GRAY
.byte BLUE,BLUE,BLUE
.byte BLACK,BLACK,BLACK

fade_ptr:
.byte 0

intro_irq_0:
		sta irq_tmpa
		stx irq_tmpx
		sty irq_tmpy
		asl $d019
		ldy #6
		:wait()

		ldx irq_ptr
		lda cur_line_colour,x
		sta $d020

		ldy #10
		:wait()

		
		lda cur_colour,x
		sta $d020

		inc irq_ptr
		lda irq_ptr
		cmp #2
		bne !+

		jsr $1003
!:
		cmp #6
		bne !+
		
		lda #0
		sta irq_ptr
can_mv_intro:
		lda #0
		bne !+
fn_handler:
		jsr fade_zones
!:

continue_outro:
		lda #0
		bne !+
		ldx irq_ptr
		lda irq_table,x
		sta $d012	

		lda d011_table,x
		sta $d011


		lda #<intro_irq_0
		sta $fffe

		lda #>intro_irq_0
		sta $ffff
		jmp out_irq
!:
//;---------------------------------------
//;DOPO IL FADE VIENE LANCIATO SOLO QUESTO
		:d012($20)
		:d011($9b)

irq_off_lo:
		lda #<hat_sprite_toggler_irq
		sta $fffe
irq_off_hi:
		lda #>hat_sprite_toggler_irq
		sta $ffff
//;---------------------------------------
out_irq:

		lda irq_tmpa
		ldx irq_tmpx
		ldy irq_tmpy
		rti



fade_zones:
		ldy current_fade_pt
		ldx fade_ptr
		lda fade_tbl,x
		sta cur_colour,y
		sta cur_line_colour,y

		inc fade_ptr
		lda fade_ptr
		cmp #30
		bne !+

		lda bg_colour,y
		sta cur_colour,y
		sta cur_line_colour,y

		inc current_fade_pt
		lda #0
		sta fade_ptr
		lda current_fade_pt
		cmp #7
		bne !+
		:set_addr(fade_lines,fn_handler)
		lda #1
		sta current_fade_pt
!:
		rts

fade_lines:


		ldy current_fade_pt
		ldx fade_ptr
		lda fade_tbl,x		
		sta cur_line_colour,y
		inc fade_ptr
		lda fade_ptr
		cmp #30
		bne !+
		inc current_fade_pt
		lda #0
		sta fade_ptr
		sta cur_line_colour,y

		lda current_fade_pt
		cmp #7
		bne !+
		

		lda #1
		sta continue_outro+1

		inc can_go_bmp_fade+1
!:


		rts
	

