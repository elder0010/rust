.var TEST_MODE=0
.var music = LoadSid("psycho.sid")

.import source "variables.asm"
.import source "../common/functions.asm"


.if (TEST_MODE == 1){	
	:BasicUpstart2(scene_start)
	.pc=music.location "Music" .fill music.size, music.getData(i)
}

.pc = pic0 "BMP 0"
.import c64 "data/fr0.prg" //loading picture in koala format

.pc = pic1 "BMP 1"
.if(TEST_MODE==1){
.import c64 "data/fr1.prg" //loading picture in koala format
}

.pc = pic2 "BMP 2"
.if(TEST_MODE==1){
.import c64 "data/fr2.prg" //loading picture in koala format
}

.pc=fade_sequence "fade sequence"
.import binary "data/frame1.fade"

.pc = frame2_fade_tbl
.import binary "data/frame2.fade"

.pc = hat_sprites "sprites cappello"
.import binary "data/sprites.raw"

.pc = $c800 "scene_start"
scene_start:
.if(TEST_MODE==1){
		sei
		lda #0
		jsr $1000
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		lda #BROWN
		sta $d020
}
			
		lda #$0b
		sta $d011

!:
		lda $d012
		cmp #$7a
		bne !-

		lda irq_table
		sta $d012
		:set_irq(intro_irq_0)

		jsr init_environment

		lda #$d8
		sta $d016

		lda #$a0
		sta $d018

		:bank_1()

		jsr init_sprites
		jsr display_pic_intro

.if(TEST_MODE==1){
		cli
		jmp can_go_bmp_fade
}
.if(TEST_MODE==0){
		jmp goload
}
goload:
		rts //;Parte il load della prima immagine (GIRLA)

.pc = $c865 "post bmp1 load"
postbmp1_load:
		rts //;Parte il load della seconda immagine (GIRLB)
		
//}		
.pc = * "post bmp2 load"

!:
can_go_bmp_fade:
		lda #0
		beq !-

		jmp main_code

	
.pc = * "intro"
.import source "intro.asm"

.var stabilizer_irq_line = $1a
.pc = $c9f0 "irq 0"
stabilizer_irq:
		sta reseta1 //;3
        stx resetx1 //;3
        sty resety1 //;3 

		//;Fino a qui CASO PEGGIORE max 18 cicli
		lda #<irq_0 sta $fffe //;6
		lda #>irq_0 sta $ffff //;6

		asl $d019 //;6
		inc $d012 //;6 

		tsx
		cli //;2 
		.for (var x=0;x<10;x++){
			nop //;2
		}
		brk
	
.pc = *+1
irq_0:
		txs //;2
		
		ldx #$08    //; Wait exactly  2+(8-1)*5 = 37 cicli
!:		dex       	//  ;lines worth of
		bne !-    	// ;cycles for compare
		bit $ea     //;Minus compare
		nop         //;cycles
		
		lda #stabilizer_irq_line+1  	//;2 
		cmp $d012   //;4
		beq !+		//;2 o 3 a seconda DEL CASO! quindi questo blocco sono 8 o 9
!:		
		lda #$a0
		sta $d018

sprite_enable:
		ldx #$0
		stx $d015

		lda #$c6
.pc = * "bank_switch_1"
bank_switch_1:
		sta $efff

lcol1:
		lda #0

.pc = * "black_delay_0"
black_delay_0:
		ldy #$9
		:wait()

		sta $d020
		sta $d021
lcol2:
		lda #ORANGE

.pc = * "black delay"
orange_delay:
		ldy #8 //;OCCHIO QUESTO CAMBIA QUANDO PARTE IL FADE SPRITES
		:wait()
		nop
		sta $d020
		sta $d021

		asl $d019
		:d012($32)
		:set_irq(irq_top_screen)
		lda reseta1
		ldx resetx1
		ldy resety1
		rti

irq_top_screen:
		:open_irq()
		:d012($72)

		asl $d019
		:set_irq(irq_1)
		nop
		nop
		nop
lcol3:
		lda #BLACK
		sta $d021

		:close_irq()
		rti

irq_1:
		:open_irq()
lcol4:	
		lda #BLACK
		ldy #7
		:wait()
		nop
		nop
		sta $d020
		
		ldy #$2
		:wait()

lcol5:
		lda #RED
		sta $d020

		asl $d019
		:d012($8b)
		:set_irq(irq_2)
		:close_irq()
		rti

irq_2:
		:open_irq()

lcol6:
		lda #BLACK
		sta $d020
	
		ldy #$a
		:wait()
lcol7:		
		lda #GRAY
		sta $d020

		asl $d019
sprite_handler_function:
//;Questa diventerà point_text_sprites definita in sprite_functions.asm
		jsr null_sprites

		:d012($b4)
		
		:set_irq(irq_3)
		:close_irq()
		rti

irq_3:
		:open_irq()

		ldy #8
		:wait()
lcol8:
		lda #BLACK
		sta $d020
	
		ldy #$9
		:wait()
lcol9:		
		lda #BROWN
		sta $d020

sprite_enabler2:
		lda #$00
		sta $d015

		jsr $1003
		asl $d019

		:d012($f9)
		
		:set_irq(irq)
		:close_irq()
		rti

irq:
		:open_irq()
		
		asl $d019		
		:d012($20)
		:set_irq(hat_sprite_toggler_irq)
		//:d012($1d)
		//:set_irq(irq_0)
lcol10:
		ldx #0
vbrd_trg:
		lda #$3b
vborder_0:
		sta $d011 //;diventerà $d011

		ldy #$d
		:wait()

		stx $d020
		
		ldy #11
		:wait()
		nop
lcol11:
		lda #DARK_GRAY
		sta $d020
		sta $d021

		lda #$9b
vborder_1:
		sta $d011 //;diventerà $d011

		lda #$1b
//;diventera $d018
d018_val_0:
		sta $d018

		lda #$c7
.pc = * "bank_switch_0"
bank_switch_0:
		sta $efff
		

can_go_sprites:
		lda #0
		beq nofade_spr

		jsr fade_sprites
nofade_spr:
		
		:close_irq()
 		rti

.pc = * "sprite hat toggler irq"
 hat_sprite_toggler_irq:
 		:open_irq()

 		asl $d019
//;------------------------------------------------------
//;questi ripunteranno all'intro durante l'outro (loalz)
next_irq_d012:
 		lda #stabilizer_irq_line
 		sta $d012

next_irq_d011:
		lda #$3b
		sta $d011

irq_on_lo:
		lda #<stabilizer_irq
		sta $fffe
irq_on_hi:
		lda #>stabilizer_irq
		sta $ffff
//;------------------------------------------------------
		lda #0
		sta $d015
		sta $d010

can_fade_hat_sprites:
 		lda #0
 		beq !+
 		//inc $d020
 		jsr init_sprites
 		jsr set_sprite_colours
 		//dec $d020
!:

FINAL_FADE_FUNCTION:
		jsr null_sprites
 		:close_irq()
 		rti

null_sprites:
		rts

//;-------------------------------------------------------------------
//;CODICE DEL MAIN DELLA SCENA
//;-------------------------------------------------------------------
main_code:
	
		jsr init_fade
		jsr generate_fade_sequence
		jsr fade_block_set	

		jsr align_image
		jsr align_sprites
	
		jsr init_fade
		jsr generate_fade_sequence
		jsr fade_block_set	
		//;jsr display_pic
		lda #0
		sta $7fff
		lda #$33
		sta vbrd_trg+1
		inc can_go_sprites+1

.if(TEST_MODE==0){
		rts
}
		jmp *





.import source "sprite_toggler_functions.asm"

.pc =functions_and_fade_routine "functions"
.import source "functions.asm"

.pc = fade_routine "fade_routine"
.import source "fade_routine.asm"
