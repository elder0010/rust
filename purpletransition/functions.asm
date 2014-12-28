init_sprites:
		lda #0
		sta $d015
		sta $d01b
		lda #$ff
		sta $d017
		sta $d01d

		//;Riloco gli sprites
		ldx #0
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

		dex
		bne !-

		lda #$fe
		sta sprites+$304
		lda #00
		sta sprites+$305
		lda #03
		sta sprites+$306
		lda #01
		sta sprites+$307

		lda #[sprites/$40] 
		ldx #2
!:
		sta screenChars+$03f8,x
		dex
		bpl !-

		lda #LIGHT_RED
		sta $d027

		lda #RED
		sta $d028

		lda #$a0
		sta $d000

		ldx sin_pt
		lda sintable,x
		sta $d001 
		clc
		adc #1
		sta $d002
		sta $d003
		rts

move_sprites:
		
		lda cur_y
		sta $d001 

		clc
		adc #1
		sta $d003

		lda $d000
		clc
		adc #1
		sta $d002

//;----------------------------------------
//;Animo gli sprites: un frame si uno no
//;----------------------------------------
anim_sprites:
		lda #0
		eor #$ff
		sta anim_sprites+1
		beq !+
		rts
!:
		ldx #2
!:
		inc screenChars+$03f7,x
		dex
		bpl !- 

		//;animazione finita?
		inc frame_ct
		lda frame_ct
		cmp #20
		bne noreset_frames
		lda #0
		sta frame_ct
		lda #[sprites/$40] 
		ldx #2
!:
		sta screenChars+$03f8,x
		dex
		bpl !-
noreset_frames:
		rts

move_up_sprites:
		inc sin_pt
		inc sin_pt

		lda #BLUE
		sta fade_sprite_tbl_bottom
		sta fade_sprite_tbl_top

		//;Siamo arrivati al bordo?
		lda $d001
		cmp #63
		bne !+
		lda #1
		sta final_exit+1
		//;Disabilito l'aggiornamento di cur_y dalla sintable
		lda #$fe 
		sta store_cury+1
!:

final_exit:
		lda #0
		beq !+
		jsr fade_out_sprites
!:
		rts

.align $10
fade_sprite_tbl_top:
.byte BROWN,BROWN,RED,RED,ORANGE,ORANGE,LIGHT_RED,LIGHT_RED

fade_sprite_tbl_bottom:
.byte BLACK,BLACK,DARK_GRAY,DARK_GRAY,GRAY,GRAY,RED,RED

fade_in_sprites:
		ldx fade_pt
		lda fade_sprite_tbl_top,x
		sta $d027

		lda fade_sprite_tbl_bottom,x
		sta $d028
dly:
		lda #0
		eor #$ff
		sta dly+1
		beq !+
		inc fade_pt
		lda fade_pt
		cmp #7
		bne !+
		lda #>no_fade
		sta fade_rt+2
		lda #<no_fade
		sta fade_rt+1
!:
		rts

no_fade:
		rts


fade_out_sprites:
		ldx fade_pt
		lda fade_sprite_tbl_top,x
		sta $d027

		lda fade_sprite_tbl_bottom,x
		sta $d028

dly2:
		lda #0
		eor #$ff
		sta dly2+1
		beq !+
		dec fade_pt
		lda fade_pt
		bne !+
		lda #0
		sta $d015
		//;finalmente abbiamo finito, togglo il jump alla prox scena
		lda #>$3a00
		sta next_scene_addr+2
		lda #<$3a00
		sta next_scene_addr+1
!:
		rts
