waster_irq:
		:open_irq()

		jsr $1003
		jsr frame_count
		asl $d019

		lda frame_count_lo
.pc = * "FRAME DELAY"
		cmp #$52 //delay per messa a sync
		bne nofd
		inc cangoscene+1
nofd:

cangoscene:
		lda #0
		beq skipall

		inc delay+1
delay:
		ldx #0
		lda screen_table,x
wtr:
		ldy $d012
		cpy #$27
		bne wtr
		sta $d020
		sta $d021
		cpx #31

		bne !+
		inc blinker_not_finished+1

		lda #$0
		sta $d011

		lda #<wait_reloc_irq sta $fffe
		lda #>wait_reloc_irq sta $ffff
!:
skipall:
		:close_irq()
		rti

finished_reloc:
.byte $0

screen_table:
.byte LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE
.byte LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE
.byte CYAN,CYAN,CYAN
.byte CYAN,CYAN,CYAN
.byte GRAY,GRAY,GRAY
.byte GRAY,GRAY,GRAY
.byte PURPLE,PURPLE,PURPLE
.byte PURPLE,PURPLE,PURPLE
.byte ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE
.byte ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE,ORANGE

wait_reloc_irq:
		:open_irq()
		asl $d019

		lda finished_reloc
		beq !+
		lda #<start_irq_top sta $fffe
		lda #>start_irq_top sta $ffff
!:
		jsr $1003

		:close_irq()
		rti

//----------------------------------------------
//Set di irq per aprire la scena
start_irq_top:
		:open_irq()

		asl $d019

		lda #IRQ_1_COL
		sta $d020

		lda #<start_irq_center sta $fffe
		lda #>start_irq_center sta $ffff
		lda #$5a
		sta $d012

		lda #0
		sta $d011

		dec intro_irq_line

		jsr $1003

		:close_irq()
		rti

.pc = * "start irq center"
start_irq_center:
		:open_irq()

		asl $d019
		lda #<start_irq_top sta $fffe
		lda #>start_irq_top sta $ffff

		lda #$00
		sta $d012
		sta $d011
!:
		lda $d012
		cmp intro_irq_line
		bne !-

		lda $d012
!:
		cmp $d012
		beq !+
		bcs !-
!:
.pc = * "DELAYER"
		ldy #7 //10
		:wait()
		bit $24

		lda #IRQ_2_COL
		sta $d020

		ldy #24
		:wait()
		lda #BROWN
		sta $d020

		lda intro_irq_line
		cmp #$a0
		bne !+
		lda #$0
		sta $d011

		lda #$0
		sta $d012

		lda #<irq_1 sta $fffe
		lda #>irq_1 sta $ffff

		jsr $1003
!:
		:close_irq()
		rti

//----------------------------------------------

irq_1:
		:open_irq()

		lda #IRQ_1_COL
		sta $d020

!:
		lda $d012
		cmp irq_2_line
		bne !-

		ldy #9
		:wait()
		bit $24

rt_c_0:
		lda #IRQ_2_COL
		sta $d020

!:
		lda $d012
		cmp irq_3_line
		bne !-

		bit $24
		ldy #9
		:wait()

rt_c_1:
		lda #IRQ_3_COL
		sta $d020
//--------------------------------------------------------------------
//WOB ZONE
!:
		lda $d012
		cmp wob_1_line
		bne !-

		ldy #10
		:wait()

line_cl:
		lda #WOB_LINE_COL
		sta $d020
rt_c_2:
		ldx #WOB_ZONE_1_COL
		ldy #11
		:wait()

		stx $d020
//---------------------------------------------------------------------
!:
		lda $d012
		cmp irq_4_line
		bne !-

		ldy #10
		:wait()
rt_c_3:
		lda #IRQ_4_COL
		sta $d020

!:
		lda $d012
		cmp irq_5_line
		bne !-

		ldy #10
		:wait()
		nop
		nop

		lda #IRQ_5_COL
		sta $d020

		asl $d019

		lda #<intro_msx_irq
		sta $fffe

		lda #>intro_msx_irq
		sta $ffff

		lda #$80
		sta $d011

		lda #$10
		sta $d012

		asl $d019

		:close_irq()
		rti

intro_msx_irq:
		:open_irq()

		jsr move_irqs

		lda scene_state
		cmp #3
		beq go_to_butterfly
		lda #<irq_1
		sta $fffe

		lda #>irq_1
		sta $ffff

		lda #$0
		sta $d011

		lda #0
		sta $d012

		jmp skip_btr

go_to_butterfly:
		lda #$1 sta $d012

		lda #<switch_top_irq sta $fffe
		lda #>switch_top_irq sta $ffff

		asl $d019

		lda #$0
		sta $d011
skip_btr:
		asl $d019

		jsr $1003

		:close_irq()
		rti

move_irqs:
		lda #$0
		sta irq_1_line

		ldx intro_wob_pt
		lda intro_sine,x
		sta irq_2_line

		clc
spessore_1:
		adc #2 //SPESSORE LINEA NERA SUPERIORE
		sta irq_3_line

		ldy scene_state //0 intro 1 scena 2 end
		beq INTRO
		cpy #1
		bne OUTRO
//----------------------------------------------------
SCENE:
		adc secondary_wob,x
		jmp go_add_wob
//----------------------------------------------------
OUTRO:
		cpy #4
		bne !+
!:
		jsr close_bar
		sec
close_range:
		sbc #0
		clc
		adc secondary_wob,x
		jmp go_add_wob
//----------------------------------------------------
INTRO:
		jsr open_bar
		sec
open_range:
		sbc #58 //48
		clc
		adc secondary_wob,x
go_add_wob:
		sta irq_4_line
spessore_2:
		adc #2
		sta irq_5_line

		sec
		lda irq_4_line
		sbc #1
		sta $57

recalc:
		//Ora calcolo la zona di wob
		lda internal_wob_pt
		sta $56
		clc
		lda irq_3_line
		adc $56
		adc #1

		cmp $57
		bcs !+
		sta wob_1_line
		jmp bye_endx
!:
		lda #0
		sta internal_wob_pt

		//Inverto i colori
		lda rt_c_1+1
		sta $58
		lda rt_c_2+1
		sta rt_c_1+1
		lda $58
		sta rt_c_2+1

		jmp recalc
bye_endx:
		inc intro_wob_pt
		inc internal_wob_pt

		:manage_scene()
		rts

//-------------------------------------------------------------------
//Set di interrupt per switchare sulla farfalla
switch_top_irq:
		:open_irq()

		asl $d019
		lda #BG_COLOUR
		sta $d020

		lda #0
		sta $7fff

		lda #linea_irq_di_transizione sta $d012

		lda #<switch_bottom_irq sta $fffe
		lda #>switch_bottom_irq sta $ffff

		lda #$10
		sta $d011

		:close_irq()
		rti

switch_bottom_irq:
		:open_irq()

		asl $d019

		lda #$f8 sta $d012
		lda #$1b sta $d011
		lda #<raster2 sta $fffe
		lda #>raster2 sta $ffff

		ldy #2
		:wait()

		lda #UNDER_COLOUR
		sta $d020
		sta $d021

		:close_irq()
		rti


open_border_irq:
		:open_irq()
		asl $d019

		lda #<raster2 sta $fffe
		lda #>raster2 sta $ffff

		lda #$02
		sta $d012

		lda #$1b
		sta $d011

		jsr $1003

		:close_irq()
		rti
//--------------------------------------------------------------------

intro_wob_pt:
.byte $0

internal_wob_pt:
.byte $0

scene_state:
.byte $0

open_bar:
		dec open_range+1
		ldy open_range+1
		bne !+
		inc scene_state
!:
		rts

close_bar:
		inc close_range+1
		ldy close_range+1
		cpy #86
		bne !+
		inc scene_state
!:
		rts

.macro manage_scene(){
		lda intro_wob_pt
		cmp #$eb
		bne !+
		dec volte+1
volte:
		lda #2 //numero di giri
		bne !+
		inc scene_state
!:
		lda volte+1
		bne !+
		lda intro_wob_pt
		cmp #$3e
		bmi !+
		ldx mini_fd_pt
		lda mini_raster_fade_table,x
		sta rt_c_0+1
		sta rt_c_1+1
		sta line_cl+1
		sta rt_c_2+1
		sta rt_c_3+1
		inc mini_fd_pt

		lda #1
		sta spessore_1+1
		sta spessore_2+1
!:
}

.align $8
mini_raster_fade_table:
.byte RED,RED,ORANGE,ORANGE,LIGHT_RED,LIGHT_RED

mini_fd_pt:
.byte $0

.align $100
.pc = * "intro sine"
intro_sine:
.import source "data/intro_sine.asm"

.macro stable_raster(){
		ldx $d012
		inx
		cpx $d012
		bne * - 3
		ldy #$0a
		dey
		bne * - 1
		inx
		cpx $d012
		nop
		beq Time_1
		nop
		bit $24
Time_1:
		ldy #$09
		dey
		bne * - 1
		nop
		nop
		inx
		cpx $d012
		nop
		beq Time_2
		bit $24
Time_2:
		ldy #$0a
		dey
		bne * - 1
		inx
		cpx $d012
		bne Time_3
Time_3:
		nop
}
