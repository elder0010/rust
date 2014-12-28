//;--------------------------------------
//;SQUARES FADER
//;--------------------------------------

.var TEST_MODE = 0

.var music = LoadSid("../tentacoli/psycho.sid")

.import source "../common/zeropage.asm"
.import source "../common/functions.asm"
.import source "variables.asm"

.if (TEST_MODE == 1){		
	.pc=music.location "Music" .fill music.size, music.getData(i)
	:BasicUpstart2(code)
}
.const numero_giri	=	$f2
.const screen_char = $f4

.var charset = $2800

code:
.if (TEST_MODE == 1){
.pc = $7000  "code"	
		:kernal_off()
		jmp $f000	
}

.pc = $f000 "codice transizione"
.if (TEST_MODE == 1){
		sei
		lda #0	
		sta $3fff
		jsr music.init
		:kernal_off()
		:turn_off_cia_turn_on_raster_irq()
		:kill_nmi()	
		
		lda #WHITE	
		sta $d020	
		sta $d021
		
		:bank_0()
		lda #[floor([SCREEN_1&$3fff]/$0400)*16]+floor([charset&$3fff]/$0400)
		sta $d018	
}		
	
.pc = * "MAIN_ROUTINE"	
main_routine:
		lda #$00				
		sta numero_giri	
		sta snare_hits
		jsr prepare_char
		
		ldx #0
		lda #BLUE
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		dex
		bne !-
		
		lda #$40
		ldx #$30
!:
		sta $0400,x
		dex 
		bpl !-

!:
		lda $d012
		cmp #$96
		bne !-

		lda #$15			
		sta $d011
	
		lda #$fc
		sta $d012	
	
		lda #<fade_irq	
		sta $fffe
		lda #>fade_irq	 //;rilocato 
		sta $ffff

.if (TEST_MODE == 1){
		asl $d019
		cli					
}
		rts

.pc = * "Fade Irq"		
fade_irq:
		:open_irq()
		asl $d019
		
		jsr put_square

		jsr put_square
		
		lda numero_giri
		cmp #4
		bne !+
		lda #<end_irq 		
		sta $fffe
		lda #>end_irq 
		sta $ffff
!:
		jsr count_frames
		jsr $1003

		//;jsr check_rullante

		:close_irq()
		rti
		
.pc = * "END_IRQ"		
end_irq:
		:open_irq()
		asl $d019

		jsr $1003
		jsr count_frames
		
		ldx border_fade_pt
		lda border_fade_tbl,x

!:
		ldy $d012
		cpy #$2a
		bne !-

		sta $d020
		
		inc border_fade_pt
		
		lda border_fade_pt
		cmp #16
		bne !+
		dec border_fade_pt
		
		lda #BLUE
		sta $d021
		lda #$80
		sta $1f
!:
		
		//;jsr check_rullante

		:close_irq()
		rti



.pc = * "PREPARE_CHAR"
prepare_char:
		lda #$ff
		ldx #9
!:
		sta charset,x
		dex
		bpl !-
		rts

put_square:
		fade_start_lo:
		lda screen_target_lo
		sta tg_scr+1

fade_start_hi:	
		lda screen_target_hi
		sta tg_scr+2
		
		lda #0
tg_scr:
		sta $ffff
		
		clc
		lda fade_start_lo+1
		adc #1
		sta fade_start_lo+1
		bcc !+
		inc fade_start_lo+2
!:
		clc
		lda fade_start_hi+1
		adc #1
		sta fade_start_hi+1
		bcc !+
		inc fade_start_hi+2
		inc numero_giri
!:		
		rts
		


.pc = $f100 "fade_tbl"
.import source "fade_tbl.asm"


.align $10 
border_fade_tbl:
.byte YELLOW,YELLOW,YELLOW
.byte LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN
.byte CYAN,CYAN,CYAN
.byte LIGHT_BLUE,LIGHT_BLUE,LIGHT_BLUE
.byte PURPLE,PURPLE,PURPLE
.byte BLUE

border_fade_pt:
.byte $0

/*
check_rullante:
		//;Contiamo i colpi di rullante..
		lda $171c
		cmp #$40
		bne !+
		inc $d021
		inc $d020
		inc snare_hits
!:
		rts
*/
.const frame_lo = $98
.const frame_hi = $99
count_frames:
		clc
		lda frame_lo
		adc #1
		sta frame_lo
		bcc !+
		inc frame_hi
!:
		rts