.align $100
fade_pt:
.byte $0

fade_screen:
.byte LIGHT_GREEN,LIGHT_GREEN
.byte LIGHT_GREEN,LIGHT_GREEN
.byte CYAN,CYAN
.byte CYAN,CYAN
.byte BLUE,BLUE
.byte BLUE,BLUE
.byte PURPLE,DARK_GRAY

scritta:
.byte 0

fade_border:
.byte GRAY,GRAY,GRAY,GRAY
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte WHITE,WHITE

fadept:
.byte 0

fade_bd_irq:
		:open_irq()
		asl $d019

		ldx fadept
		lda fade_border,x
		sta $d020
		sta $d021
		inc fadept

		lda fadept
		cmp #10
		bne !+
		lda #<scritte_irq 		
		sta $fffe
		lda #>scritte_irq 
		sta $ffff
		lda #$1d
		sta $d011

		lda #$ff
		sta $d012

		lda #$1b
		sta $d018

!:
		jsr $1003

		:close_irq()
		rti


scritte_irq:
		:open_irq()
		asl $d019

		//;lda #$1d				// Mi metto in modalità 25 righe
		//;sta $d011
		
		ldx fade_pt
		lda fade_screen,x
		jsr fade_scritta
		
		inc fade_pt
		lda fade_pt
		cmp #9
		bne !+
		
		inc delay
		lda delay
		cmp #$3f //;delay tra scritte
		bne nonxt
		
		lda #0
		sta delay
		sta fade_pt
		
		inc pt_scr
		ldx pt_scr
		lda indirizzi_scritte_lo,x
		sta trg+1
		
		lda indirizzi_scritte_hi,x
		sta trg+2
		
		cpx #3
		bmi !+

		lda #$fa
		sta $d012	
		
		:set_irq(music_sync_irq)
		/*
		lda #<bottom_irq 		
		sta $fffe
		lda #>bottom_irq 
		sta $ffff
		*/
		
		lda #0
		sta fade_pt
	
nonxt:
		lda #8
		sta fade_pt
!:
		//inc $d020
		jsr $1003
		//dec $d020
		:close_irq()
		rti

music_sync_irq:
		:open_irq()

		asl $d019


		lda $1732
		cmp #$e9
.if(MUSIC_SYNC==1){
		bne !+
}
		inc can_polish+1
!:

can_polish:
		lda #0 
		beq !+
		inc sync_polish+1
sync_polish:
		lda #0
		cmp #$19
		bne !+
		:set_irq(bottom_irq)
!:
	//	inc $d020
		jsr $1003
	//	dec $d020
		:close_irq()
		rti
fade_scritta:
		ldx #80
!:
trg:
		sta $d833,x
		
		dex
		bpl !-
		rts
		

.align $10
indirizzi_scritte_lo:
.byte $33,$9a,$02

indirizzi_scritte_hi:
.byte $d8,$d9,$db

pt_scr:
.byte 0

delay:
.byte 0





