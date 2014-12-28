intro_irq:
		:open_irq()

		jsr keep_on_wobbling

		lda #$1b
		sta $d011

		jsr $1003

must_fade_tizia:
		lda #0
		beq !+
		jsr draw_tizia
!:
		asl $d019
		:close_irq()
		rti

//;---------------------------------------------------------
//;Questa funzione continua a far wobblare tutta la baracca
//;Nell'intro e nell'outro
//;---------------------------------------------------------
keep_on_wobbling:
		//;Wobblo il wobblabile
		ldx left_wobble_pt
		lda border_wave,x
		tax
		sta FILLER_SPRITE_Y_INTRO+1 //;Mi segno l'altezza da una parte

		ldy right_wobble_pt
		lda border_wave,y
		tay
		
		clc
		//;La tristezza è che devo muovermi gli sprite a penna pure nell'intro
FILLER_SPRITE_Y_INTRO:		
		lda #$ff
		adc #30
		sta $d001
		sta $d003
			
		lda #30
		sta $d000
		lda #60
		sta $d002

		jsr wobble_borders
		jsr wob_bitmap		
		rts

//;Draw tizia
draw_tizia:
		:set_addr(screenPixels+$1f40+[16*$28],src_gr)
		:set_addr(screenChars+[16*$28],line_gr)

		ldy #0
start_gr:
		ldx #2
src_gr:
		lda screenPixels+$1f40+[16*$28],x
line_gr:
		sta screenChars+[16*$28],x
		inx
end_gr:
		cpx #3
		bne src_gr
		:go_down_one_line(src_gr)
		:go_down_one_line(line_gr)
		iny
		cpy #9
		bne start_gr

		inc end_gr+1

		lda end_gr+1
		cmp #$26
		bne !+
		lda #0
		sta must_fade_tizia+1

		.pc = * "trigger"
		:trigger_plexer()
!:
		rts

//;------------------------------------------
//;Fade finale della tizia
clean_tizia:
	
		:set_addr(screenChars+[16*$28],cline_gr)

		ldy #0
cstart_gr:
		ldx #3
crsrc_gr:
		lda #$11
cline_gr:
		sta screenChars+[16*$28],x
		inx
cend_gr:
		cpx #$4
		bne crsrc_gr
		:go_down_one_line(cline_gr)
		iny
		cpy #9
		bne cstart_gr

		inc cend_gr+1

		lda #<quit_scene
		sta wait_scene+1
		
		lda #>quit_scene
		sta wait_scene+2

		lda cend_gr+1
		cmp #$25
		bne !+

		//;jsr redraw_columns //;Ridisegno la parte finale in char mode prima di stoppare l'NMI
		:set_addr(go_outro,wait_for_outro)
!:
		rts

.macro trigger_plexer(){

		lda #<glitch_absorber_irq 
		sta $fffe
		lda #>glitch_absorber_irq 
		sta $ffff

		lda #$fe
		sta $d012
		
		lda #$1b
		sta $d011

	//	lda #$ff
	//	sta $d012

		//jsr $1003
}

glitch_absorber_irq:
		:open_irq()

		lda #$9b
		sta $d011
		//inc $d020
		jsr $1003
		jsr keep_on_wobbling
		//dec $d020

		lda #0
		sta fade_pt_spr

		lda $1786
		cmp #$32 //;arpeggiata di sid
.if(MUSIC_SYNC==1){
		bne !+
}
		lda #0
		sta flg+1
!:
flg:
		lda #1
		bne !+
		inc frame_retouch+1
frame_retouch:
		lda #0
		cmp #8 //;Sid sync fine tuning
		bne !+
		lda #$fb
		sta $d012
		:d011($1b)
		lda #0
		sta $e3
		:set_irq(bottom_irq)
		jsr $1003
!:
		asl $d019
		:close_irq()
		rti