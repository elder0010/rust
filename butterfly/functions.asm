//.var sprites_reverse_source = $9400
//.var sprites_source = $8500

mega_reloc:
		jsr tetris_assets+$a10 //;$3310 - reloc routine della roba tetris
		//;Riloco gli sprites reverse
		ldx #0
!:
		lda sprites_reverse_source,x
		sta sprites_reverse,x

		lda sprites_reverse_source+$100,x
		sta sprites_reverse+$100,x

		lda sprites_reverse_source+$200,x
		sta sprites_reverse+$200,x

		lda sprites_reverse_source+$300,x
		sta sprites_reverse+$300,x

		lda sprites_reverse_source+$400,x
		sta sprites_reverse+$400,x

		lda sprites_reverse_source+$500,x
		sta sprites_reverse+$500,x

		lda sprites_reverse_source+$600,x
		sta sprites_reverse+$600,x

		dex
		bne !-
		
		ldx #0
		//;Riloco gli sprites dritti
!:
		lda sprites_source,x
		sta sprites,x

		lda sprites_source+$100,x
		sta sprites+$100,x

		lda sprites_source+$200,x
		sta sprites+$200,x

		lda sprites_source+$300,x
		sta sprites+$300,x

		lda sprites_source+$400,x
		sta sprites+$400,x

		lda sprites_source+$500,x
		sta sprites+$500,x

		lda sprites_source+$600,x
		sta sprites+$600,x

		lda sprites_source+$700,x
		sta sprites+$700,x

		lda sprites_source+$800,x
		sta sprites+$800,x

		lda sprites_source+$900,x
		sta sprites+$900,x

		lda sprites_source+$a00,x
		sta sprites+$a00,x

		lda sprites_source+$b00,x
		sta sprites+$b00,x


		lda sprites_source+$b00+$3e,x
		sta sprites+$b00+$3e,x

		dex
		bne !-

		//;creo il filler sprite
		lda #$ff
		ldx #$40
!:
		sta filler_sprite,x
		dex
		bpl !-
		rts