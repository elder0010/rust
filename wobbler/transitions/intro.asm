.pc = * "init wait"
init_wait_irq:
		:open_irq()
		asl $d019
	//	inc $d020
		jsr music.play
	//	dec $d020

		lda init_finished
		beq !+
		lda #<intro_girl_irq 
		sta $fffe
		lda #>intro_girl_irq 
		sta $ffff
		
		lda #$1b
		sta $d011
	//	lda #$f9
	//	sta $d012
!:
		:close_irq()
		rti

init_finished:
.byte $0
	
intro_girl_irq:
		:open_irq()
		
		asl $d019
		
		lda can_wobble
		bne go_wobble
		jmp skip_wobble
go_wobble:
		//;Wobblo il wobblabile
		ldx left_wobble_pt
		lda border_wave,x
		tax
		sta FILLER_SPRITE_Y_INTRO+1 //;Mi segno l'altezza da una parte
		
		ldy right_wobble_pt
		lda border_wave,y
		tay
		
		//;La tristezza è che devo muovermi gli sprite a penna pure nell'intro
FILLER_SPRITE_Y_INTRO:		
		lda #$ff
		adc #29
		sta $d001
		sta $d003
		
		lda #30
		sta $d000
		lda #60
		sta $d002
	
		lda #border_colour
		sta $d027
		sta $d028
		sta $d025
		sta $d026
		
		lda #$03
		sta $d015
		
		lda #2
		sta $d010
		
		jsr draw_chars
		
		inc left_wobble_pt
		lda left_wobble_pt
		cmp #50
		bne !+
		inc can_wobble_right+1
!:
can_wobble_right:
		lda #0
		beq !+
		inc right_wobble_pt
!:
skip_wobble:
		inc pre_delay+1
pre_delay:	
		lda #0
		cmp #$2
		bne !+
		lda #1
		sta can_wobble
!:	
	//	inc $d020
		jsr music.play	
	//	dec $d020	
		:close_irq()
		rti
		
can_wobble:
.byte $0


//;Disegno le colonne: sul bordo sx e dx ci sono i due caratteri 1, 2
//;ATTENZIONE SE MUOVI questa funzione cambia anche il valore dell'indirizzo
//;Su wobbler/plex_test.asm linea 101 e rotti
.pc = $5b42 "draw_columns" 
draw_columns:

//;COLORO LE COLONNE A SX E A DX..	
.pc = * "COL COLONNE"

		lda #1
		ldx #0
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		dex
		bne !-
		
colour_colonne:
		lda #border_colour
sx_01:
		sta $d800
sx_02:
		sta $d800+1
dx_03:
		sta $d800+$25
dx_04:
		sta $d800+$26
		
		:go_down_one_line(sx_01)
		:go_down_one_line(sx_02)
		
		:go_down_one_line(dx_03)
		:go_down_one_line(dx_04)

		inc linect+1
linect:
		lda #0
		cmp #25
		bne colour_colonne
	
//;COLORO LE PRIME DUE RIGHE
		lda #border_colour
!:
		sta $d800+$28,x
		sta $d800,x
		inx
		cpx #$27
		bne !-
		
//;DISEGNO IL BORDO TOP
		ldx #0
		lda #5
!:
		sta SCREEN_1,x
		inx
		cpx #41
		bne !-
		
		ldx #0
		lda #6
!:
		sta SCREEN_1+$28,x
		inx
		cpx #41
		bne !-

//;BORDO SX
		ldx #1
		ldy #2
.var offs = $28

draw_bordo_sx:		
		lda #1
of_sx_0:
		stx SCREEN_1
of_sx_1:
		sty SCREEN_1+1
		
		:go_down_one_line(of_sx_0)
		:go_down_one_line(of_sx_1)
		
		inc linect1+1
linect1:
		lda #0
		cmp #25
		bne of_sx_0
				
.eval offs = 0

//;RESET CHARS PER BORDO DX		
		lda #0
		ldx #15
!:
		sta char_base+$b3*$8,x
		sta char_base+$11*$8,x
		dex
		bpl !-

		lda #$ff
		lda #0
		ldx #7
!:
		sta char_base+$2b*$8,x
		dex
		bpl !-

//;BORDO DX
		ldx #$b3
		ldy #$b4	
draw_bordo_dx:		
of_dx_0:
		stx SCREEN_1+$25
of_dx_1:
		sty SCREEN_1+1+$25
		
		:go_down_one_line(of_dx_0)
		:go_down_one_line(of_dx_1)
		
		inc linect2+1
linect2:
		lda #0
		cmp #25
		bne of_dx_0
		rts

.macro go_down_one_line(register){
		clc
		lda register+1
		adc #$28
		sta register+1
		bcc !+
		inc register+2
!:
}

//;---------------------------------------------------------------
//;Pulitura schermo altrimenti si vede di tutto sotto agli sprites
//;---------------------------------------------------------------
cl_scrn:
		ldy #0
lnn:
		lda #$11
		ldx #2	
cls_ln:
		sta SCREEN_1+2+[$28*2],x
		inx
		cpx #$23
		bne cls_ln
		:go_down_one_line(cls_ln)
		iny
		cpy #17
		bne lnn
		rts