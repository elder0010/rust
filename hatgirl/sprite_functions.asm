blank_text_sprites:
		
		lax #$0
!:
		sta text_sprites,x
		sta text_sprites+$100,x
		dex
		bne !-
		rts

.pc = * "POINT TEXT SPRITES FUNCTION"
point_text_sprites:
		clc
		ldx #0
		lda #[text_sprites/$40]
!:
		sta screenPixels+$03f8,x
		adc #1
		inx
		cpx #8
		bne !-

		lda #$80
		sta $d010

		lda #0
		sta $d01c

		jsr position_text_sprites

		rts

.var SPRITE_X_BASE = $68
.var SPRITE_Y = $5
position_text_sprites:
		clc
		ldx #0
		
		lda #SPRITE_X_BASE
!:
		sta $d000,x
		adc #24
		inx
		inx
		cpx #16
		bne !-

		lda #SPRITE_Y
		ldx #0
!:
		sta $d001,x
		inx
		inx
		cpx #16
		bne !-

		rts

.align $10
sprite_tbl_lo:
.for (var x=0;x<8;x++){
	.byte <text_sprites+[$40*x]
}
sprite_tbl_hi:
.for (var x=0;x<8;x++){
	.byte >text_sprites+[$40*x]
}

sprite_addr_pt:
.byte $0

text_fade_pt:
.byte $0

.align 19
text_fade_tbl: //;19

.byte BROWN,BROWN,BROWN
.byte RED,RED,RED
.byte GRAY,GRAY,GRAY
.byte ORANGE,ORANGE,ORANGE
.byte LIGHT_RED,LIGHT_RED,LIGHT_RED
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte WHITE,WHITE,WHITE,WHITE

text_sequence_lo:
.byte <text1,<text2,<text3,<text4,<text5,<text6,<text7,<text8

text_sequence_hi:
.byte >text1,>text2,>text3,>text4,>text5,>text6,>text7,>text8

text_sequence_pt:
.byte 0

//;QUESTA VIENE CHIAMATA NELL'IRQ
handle_texts:
		lda #DARK_GRAY
		sta col_spr+1

		jsr point_text_sprites

		lda can_fade_sprites
		beq gotimer
		ldx text_fade_pt
		
		lda text_fade_tbl,x
		sta col_spr+1

		inc text_fade_pt
		lda text_fade_pt
		cmp #19
		bne nofade
		lda #0
		sta can_fade_sprites
		sta text_fade_pt
		lda #WHITE 
		sta handle_texts+1
		jmp end
gotimer:
		inc text_delay
		
nofade:
end:
col_spr:
		lda #0
		jsr colour_sprites
		rts

colour_sprites:
		ldx #8
!:
		sta $d027,x
		dex
		bpl !-
		rts

write_texts:
		jsr reset_writer
		jsr print_text
		lda #1
		sta can_fade_sprites
!:		
		lda text_delay
		cmp #HOW_MUCH_TEXT_DELAY
		bcc !-
volte:
		lda #0
		cmp #8
		beq fine_testi

		ldx text_sequence_pt

		lda text_sequence_lo,x
		sta text_string+1

		lda text_sequence_hi,x
		sta text_string+2

		inc text_sequence_pt
		inc volte+1

		lda #0
		sta text_delay

		lda #DARK_GRAY
		jsr colour_sprites

		jmp write_texts
fine_testi:
		inc can_go_outro
		rts


reset_writer:
		lda #0
		sta scroll_charNo
		sta charct+1
		sta sprite_addr_pt
		rts

print_text:
		//;calcolo l'indirizzo di target dello sprite
		:set_addr_y(text_sprites,trg_sprite)
curchar:		
//;-----------------------------------------------
text_string:
		lda text1
		beq finish_text
		sta tmp_4

		ldy #0
		sty sprite_offs+1
		sty scroll_charNo

		ldy trg_sprite+1
		sty tmp_5
		ldy trg_sprite+2
		sty tmp_6

		jsr put_char
//;-----------------------------------------------
		lda scroll_charNo
		eor #$80
		sta scroll_charNo
	
		ldy tmp_5
		sty trg_sprite+1
		
		ldy tmp_6
		sty trg_sprite+2
		
		jsr advance_sprite
	
		lda #0
		sta sprite_offs+1

		lda tmp_4
		jsr put_char
//;-----------------------------------------------
		inc curchar+1
		
		jsr advance_sprite
	
		jmp curchar
finish_text:	
		rts

advance_sprite:
		inc charct+1
charct:
		lda #0
		cmp #3
		bne plaingo

		inc sprite_addr_pt
		ldx sprite_addr_pt
		lda sprite_tbl_lo,x
		sta trg_sprite+1
		lda sprite_tbl_hi,x
		sta trg_sprite+2

		lda #0
		sta charct+1
		rts

plaingo:
		clc
		lda trg_sprite+1
		adc #1
		sta trg_sprite+1
		bcc !+
		inc trg_sprite+2
!:
		rts

put_char:
		sta tmp_2

		ldy #0
		sty tmp_3
//;--------------------------------------------------------------------
wr_chr:
		ora scroll_charNo	

		ldy #0
		sty tmp_1

		//;Ho in mano il numero del char, lo moltiplico *8
		//;Per avere l'offset nel charset
		asl
		rol tmp_1
		asl
		rol tmp_1
		asl
		rol tmp_1

		sta src_charset+1 //;bassi

		clc 
		lda tmp_1
		adc #>[screenChars]
		sta src_charset+2 //;alti

sprite_offs:
		ldy #0

		ldx #0
!:	
src_charset:
		lda $ffff,x
trg_sprite:
		sta $ffff,y

		iny
		iny
		iny

		inx

		cpx #8
		bne !-
//;--------------------------------------------------------------------
		inc tmp_3
		lda tmp_3
		cmp #2
		beq !+

		//;mi sposto sulla seconda riga dello sprite
		clc
		lda trg_sprite+1
		adc #24
		sta trg_sprite+1
		bcc noincsprite
		inc trg_sprite+2
noincsprite:
		//;mi sposto sulla seconda riga del charset
		lda tmp_2
		clc
		adc #$40
		sta tmp_2
		jmp wr_chr
!:
		sec
		lda trg_sprite+1
		sbc #24
		sta trg_sprite+1
		bcs nodecsprite
		dec trg_sprite+2
nodecsprite:
		rts
		