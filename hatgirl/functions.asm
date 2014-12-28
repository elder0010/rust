.pc= * "display pic"
display_pic:
		ldx #0
!:
		lda ScreenRam,x
		sta bmp_screen,x
		lda ScreenRam+$100,x
		sta bmp_screen+$100,x
		lda ScreenRam+$200,x
		sta bmp_screen+$200,x
		lda ScreenRam+$2e8,x
		sta bmp_screen+$2e8,x

		lda ColorRam,x
		sta $d800,x
		lda ColorRam+$100,x
		sta $d800+$100,x
		lda ColorRam+$200,x
		sta $d800+$200,x
		lda ColorRam+$2e8,x
		sta $d800+$2e8,x
		dex
		bne !-

		ldx #0
		ldy #0
		:set_addr_zp(pic1,addr_1)
		:set_addr_zp(pixel_dest,addr_2)


!:
		lda (addr_1),y
		sta (addr_2),y
		dey
		bne !-

		inc addr_1+1
		inc addr_2+1
		inx
		cpx #32
		bne !-

		rts


display_pic_intro:
		ldx #0
!:
		lda ScreenRam_intro,x
		sta bmp_screen,x
		lda ScreenRam_intro+$100,x
		sta bmp_screen+$100,x
		lda ScreenRam_intro+$200,x
		sta bmp_screen+$200,x
		lda ScreenRam_intro+$2e8,x
		sta bmp_screen+$2e8,x

		lda ColorRam_intro,x
		sta $d800,x
		lda ColorRam_intro+$100,x
		sta $d800+$100,x
		lda ColorRam_intro+$200,x
		sta $d800+$200,x
		lda ColorRam_intro+$2e8,x
		sta $d800+$2e8,x
		dex
		bne !-

		ldx #0
		ldy #0
		:set_addr_zp(pic0,addr_1)
		:set_addr_zp(pixel_dest,addr_2)

!:
		lda (addr_1),y
		sta (addr_2),y
		dey
		bne !-

		inc addr_1+1
		inc addr_2+1
		inx
		cpx #32
		bne !-

		rts


.pc = * "align image"
align_image:
		
		lda #FADE_DEPTH_FRAME_2
		sta fdpt_1+1
		sta fdpt_2+1

		:set_addr_zp(pic1,addr_1)
		:set_addr_zp(pic2,addr_2)

		ldx #0
cplimg:
		ldy #0
!:
		lda (addr_2),y
		sta (addr_1),y
		dey
		bne !-
		inx

		inc addr_1+1
		inc addr_2+1

		cpx #$27
		bne cplimg

//;allineo la fade table
		:set_addr_zp(fade_sequence,addr_1)
		:set_addr_zp(frame2_fade_tbl,addr_2)

		ldx #0
cpltbl:
		ldy #0
!:
		lda (addr_2),y
		sta (addr_1),y
		dey
		bne !-
		inx

		inc addr_1+1
		inc addr_2+1

		cpx #$4
		bne cpltbl

		rts

fade_sprites:
		lda #$7f
		sta  sprite_enable+1

		lda #7
		sta orange_delay+1
		
spr_fd_pt:
		ldx #0
		lda sprite_fade_table,x
		ldy #8
!:
		sta $d027,y
		dey
		bpl !-

		inc spr_fd_pt+1
		cpx #10
		bne !+

		lda #0
		sta can_go_sprites+1
		inc can_fade_hat_sprites+1
		jsr set_sprite_colours
!:
		rts

align_sprites:
		ldx #0
!:
		lda hat_sprites,x
		sta hat_sprites_target,x

		lda hat_sprites+$100,x
		sta hat_sprites_target+$100,x
		dex
		bne !-
		rts

init_environment:
		ldx #0
		stx can_go_outro
		stx outro_flip
		lda #0
!:
		sta $d800,x
		sta $d800+$100,x
		sta $d800+$200,x
		sta $d800+$300,x
		sta bmp_screen,x
		sta bmp_screen+$100,x
		sta bmp_screen+$200,x
		sta bmp_screen+$300,x
		dex
		bne !-

		lda #$70
		ldx #16
!:
		sta $d000,x
		dex
		bpl !-

		rts

