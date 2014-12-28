//;------------------------------------------------------------------
//;Tunnel intro transition
//;------------------------------------------------------------------
fade_tunnel:
		
		jmp fade_pt
		
exit_fade:	
		rts
		
fade_pt:
		ldx #0
		
		ldy #0
!:
		lda fade_table,x
		sta (base_fade),y
		
		inc noc+1
		
		clc
		lda base_fade
		adc #$28
		sta base_fade
		bcc noc
		inc base_fade+1
noc:
		lda #0
		cmp #29
		bne !-
		
		lda #$ff
		sta noc+1
		
		lda #0
		//eor #$ff
		sta eor_delayer
	
		bne !+
	
			
start_ofs:		
		inc fade_pt+1
		
		lda fade_pt+1
		cmp #6
		bne !+
		
		inc row_shift
		
		lda #0
		sta fade_pt+1
	
		lda row_shift
		cmp #41
		bne !+
		
		lda #>exit_fade
		sta fade_tunnel+2
		
		lda #<exit_fade
		sta fade_tunnel+1
		
		lda #>plasma
		sta pre_plasma+2
		
		lda #<plasma
		sta pre_plasma+1
	
!:

		//;Si riparte da sopra..
		lda #$d8
		sta base_fade+1

//;Ma con un offset da sinistra
		lda row_shift
		sta base_fade
		
		rts


fade_table:
.byte LIGHT_GREEN,CYAN,GREEN,LIGHT_BLUE,PURPLE,PURPLE,BLUE

eor_delayer:
.byte $0

row_shift:
.byte 0



