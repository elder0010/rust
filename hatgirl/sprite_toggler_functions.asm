init_sprites:
		ldx #0
		stx $d017
		stx $d01d
		stx $d00a
		stx $d00e

		clc 
		lda #[hat_sprites_target&$3fff]/[$40]	
!:
		sta bmp_screen+$03f8,x
		adc #1
		inx
		cpx #7
		bne !-

sprcol1:	
		lda #ORANGE
		ldx #$a
!:
		sta $d025,x
		dex
		bpl !-

		.var SPRITE_BASE_Y = $1d
		lda #SPRITE_BASE_Y
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		
		.var SPRITE_BASE_X = $7e

		lda #SPRITE_BASE_X
		sta $d000

		lda #SPRITE_BASE_X+24
		sta $d002
		sta $d004

		lda #SPRITE_BASE_X+24+24
		sta $d006

		lda #198
		sta $d008

		lda #198+18
		sta $d00c

		lda #$ff
		sta $d01c

	//	lda #0
	//	sta $d00a
	//	sta $d00e
		rts


set_sprite_colours:
sprcol2:
		lda #LIGHT_GRAY
		sta $d025
sprcol3:
		lda #DARK_GRAY
		sta $d026
sprcol4:
		lda #BROWN
		sta $d027
sprcol5:
		lda #GRAY
		sta $d028
sprcol6:
		lda #BLACK
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c
		sta $d02d
		sta $d02e
		rts