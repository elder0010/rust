.import source "variables.asm"
.import source "../common/functions.asm"

.var music = LoadSid("Blueberry.sid")
.pc=music.location "Music" .fill music.size, music.getData(i)


:BasicUpstart2(scene_start)

.var TEST_MODE = 1

scene_start:
	
		.if (TEST_MODE == 1){
		sei
		lda #0
		jsr music.init
		:kernal_off()
	
}
		lda #$1b
		sta $d011
		
		lda #0
		sta $d015
		
		//;banco
		:bank_0()
		
		jsr init_nmi
		
		cli

		jmp *
	
		
nmi:
		pha
		lda $dd0d
	
		
		lda #$3b
		sta $d011
		
		pla
		rti
		
irq:
		:open_irq()
		
		asl $d019

		inc $d020
		
		ldy #$15
		:wait()
		
		dec $d020
		
		lda #$fb
		sta $d012
		
		lda #<music_irq
		sta $fffe //; Set low IRQ adress in selected bank
		lda #>music_irq
		sta $ffff //; Set high IRQ adress in selected bank
		
		:close_irq()
		rti
		

music_irq:
		:open_irq()
		
		asl $d019
		
		inc $d020
		jsr $1003
		dec $d020
		
		lda #$1b
		sta $d011
		
		ldx rst_pt
		lda ras,x
		sta $d012
		
		lda #<irq
		sta $fffe //; Set low IRQ adress in selected bank
		lda #>irq
		sta $ffff //; Set high IRQ adress in selected bank
		
		inc rst_pt
		
		:close_irq()
		rti
	
	
init_nmi:
	
		lda #$7f
		sta $dc0d
	
		lda #1
		sta $d01a
		sta $d019
		
//;punto irq CIA
		lda #<nmi
		sta $fffa //; Set low IRQ adress in selected bank
		lda #>nmi
		sta $fffb //; Set high IRQ adress in selected bank
		
		
//;Punto irq raster
		lda #<irq
		sta $fffe //; Set low IRQ adress in selected bank
		lda #>irq
		sta $ffff //; Set high IRQ adress in selected bank
		
		
//;Abilito tutti gli interrupts
//;generati dai timer
		lda #$7f 
		sta $dd0d //; Clear IRQ interruptmask for CIA
		
/*

;Timer A control register. Bits:
;Bit #0: 0 = Stop timer; 1 = Start timer.
;Bit #1: 1 = Indicate timer underflow on port B bit #6.
;Bit #2: 0 = Upon timer underflow, invert port B bit #6; 1 = upon timer underflow, generate a positive edge on port B bit #6 for 1 system cycle.
;Bit #3: 0 = Timer restarts upon underflow; 1 = Timer stops upon underflow.
;Bit #4: 1 = Load start value into timer.
;Bit #5: 0 = Timer counts system cycles; 1 = Timer counts positive edges on CNT pin.
;Bit #6: Serial shift register direction; 0 = Input, read; 1 = Output, write.
;Bit #7: TOD speed; 0 = 60 Hz; 1 = 50 Hz.
*/
		lda $dd0e
		ora #%10011000
		and #%11110110
	//;	sta $dd0e //; count o2 pulses and forceload and continious and stop
	
		//; timer A
		tay //; Save for later use in y

		lda #$c7
		sta $dd04

		lda #$4c
		sta $dd05
	
		lda #$81
		sta $dd0d //; Activate CIA timer A irq
	
		tya
		ora #%00000001 //; Start CIA Timer A
		tax
		
.var nmi_bmp_line = $b8 //;Linea dove switchare char mode bmp mode		
waitrst:
		//; aspetto per far partire il cia
		lda $d012
		cmp #nmi_bmp_line
		bne waitrst
		
		nop
		nop
		nop
		
		bit $24
		bit $24

		stx $dd0e 
		asl $d019
		lda $dd0d
		lda $dc0d
		rts
		
	
	
.pc = $2000
ras:
.byte 135,130,126,122,118,115,111,107,104,101,97,95,92,89,87,85
.byte 84,82,81,80,80,80,80,80,81,82,83,84,86,88,91,93
.byte 96,99,102,106,109,113,117,120,124,128,132,137,141,145,149,152
.byte 156,160,163,167,170,173,176,178,181,183,185,186,187,188,189,189
.byte 189,189,189,188,187,185,184,182,180,177,174,172,168,165,162,158
.byte 154,151,147,143,139,135,130,126,122,118,115,111,107,104,101,97
.byte 95,92,89,87,85,84,82,81,80,80,80,80,80,81,82,83
.byte 84,86,88,91,93,96,99,102,106,109,113,117,120,124,128,132
.byte 137,141,145,149,152,156,160,163,167,170,173,176,178,181,183,185
.byte 186,187,188,189,189,189,189,189,188,187,185,184,182,180,177,174
.byte 172,168,165,162,158,154,151,147,143,139,135,130,126,122,118,115
.byte 111,107,104,101,97,95,92,89,87,85,84,82,81,80,80,80
.byte 80,80,81,82,83,84,86,88,91,93,96,99,102,106,109,113
.byte 117,120,124,128,132,137,141,145,149,152,156,160,163,167,170,173
.byte 176,178,181,183,185,186,187,188,189,189,189,189,189,188,187,185
.byte 184,182,180,177,174,172,168,165,162,158,154,151,147,143,139,135


rst_pt:
.byte $0

