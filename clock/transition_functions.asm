clean_screen:
		ldx #0
		lda #BLUE
!:	

		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x

		dex
		bne !-

		rts

init_sprites:

		ldx #8
!:
		lda #WHITE
		sta $d027,x

		lda #[[bubble_sprite-$3fff]/$40]
		sta screenChars+$03f8,x
		dex
		bpl !-

		lda #LIGHT_BLUE
		sta $d02d

		ldx #16
		lda #0
		sta bubble_x_wob
		sta $d017
		sta $d01b
		sta $d01d
!:
		sta $d000
		dex
		bpl !-

		lda #CYAN
		sta $d025
		lda #WHITE
		sta $d026

		lda #%01000000
		sta $d01c

		lda #$40
		sta $d015

		lda bubble_speed
		sta SPEED

		rts



