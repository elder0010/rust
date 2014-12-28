fld_top_irq:
		:open_irq()
		asl $d019
		jsr do_fld

goup:
		dec linee_fld
		bne skip
		
		:set_irq(clock_irq)
		:d012($fa)
		:d011($33)

		lda #1
		sta linee_fld
		jmp exit	
skip:
		
		:d012($fa)
		lda $d011
		ora #$20
		sta $d011

irqlo:
		lda #<fld_bottom_irq
		sta $fffe
irqhi:
		lda #>fld_top_irq
		sta $ffff
	
exit:
		:close_irq()
		rti
		
linee_fld:
.byte $b0

fld_bottom_irq:
		:open_irq()
		asl $d019
		
		:d011($33)
		:d012($2a)
		:set_irq(fld_top_irq)

		lda #[[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]
		sta $d018

		:bank_1()
		jsr wob_pic_x
		jsr move_bubble
		jsr music.play

		:close_irq()
		rti

.pc = * "fld_end_irq"
fld_end_irq:
		:open_irq()	
		asl $d019

can_fade_out:
		lda #0
		beq !+
fd_vl:
		lda #$ff
		beq enddemo
		lsr
		lsr
		lsr
		lsr
		sta $1718
		dec fd_vl+1
		jmp !+
enddemo:
		sei //;RUST is over.. 
		:set_addr(killall,$fff9)
		lda #$10
		sta $dd04
		lda #0
		sta $dd05
		lda #$81
		sta $dd0d
		lda #$11
		sta $dd0e
killall:
		jmp *
!:

fldjmp:
		jsr do_fld
!:
		lda $d012
		cmp #$ff
		bne !-

		inc linee_fld

		jsr wob_pic_x
		jsr move_bubble

d011sw:
		lda #$33
		sta $d011

		inc ctt+1
ctt:
		lda #0
		cmp #$b4
		bne !+

		dec linee_fld
		dec ctt+1
		lda $d00d
		cmp #$fe
		bne !+

		lda #JMP_ABS
		sta fldjmp

		:set_addr(nothing,fldjmp)
		lda #0
		sta d011sw+1
		sta $d011
		inc can_fade_out+1
!:
nothing:
		jsr $1003
		:close_irq()
		rti

do_fld:	
		lda #$33
		sta $d011

		ldx linee_fld
		bne !+
		jmp skip
!: 
	
fld_first_line:		
		lda #$38
        cmp $d012
        bne *-3

fld_loop:
        lda $d012 
        cmp $d012
        beq *-3
       
        clc
        lda $d011

        adc #1
        and #7
        ora #$30
        sta $d011
        dex 
        bne fld_loop 
		
		rts

