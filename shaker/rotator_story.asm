rotator_part_1:
		
colfd:
		ldx #254
		lda tmp_colour_table,x
		sta colour_table,x
		dec colfd+1

		cpx #$60
		bne !+
		lda #>rotator_part_2
		sta raster_anim_routine+2

		lda #<rotator_part_2
		sta raster_anim_routine+1
	
!:
		rts

rotator_part_2:
	
colfd2:
		ldx #28
		lda #0
		sta colour_table,x
		dec colfd2+1

		cpx #180
		bne !+
		lda #>rotator_part_3
		sta raster_anim_routine+2

		lda #<rotator_part_3
		sta raster_anim_routine+1
!:
		rts


rotator_part_3:
	
colfd3:
		ldx #158
		lda tmp_colour_table,x
		sta colour_table,x
		inc colfd3+1

		cpx #149
		bne !+
		lda #>rotator_part_4
		sta raster_anim_routine+2

		lda #<rotator_part_4
		sta raster_anim_routine+1
!:
		rts


rotator_part_4:
colfd4:
		//;ldx #104
		ldx #110
		lda #0
		sta colour_table,x
		sta colour_table+1,x
		inc colfd4+1

		cpx #109
		bne !+
		lda #>rotator_part_5
		sta raster_anim_routine+2

		lda #<rotator_part_5
		sta raster_anim_routine+1
!:
		rts

rotator_part_5:
colfd6:
	ldx #228

		lda tmp_colour_table,x
		sta colour_table,x
		inc colfd6+1

		cpx #$60
		bne !+
		
		inc giri_finali+1
giri_finali:
		lda #0
		cmp #3
		bne !+
		lda #>rotator_part_6
		sta raster_anim_routine+2

		lda #<rotator_part_6
		sta raster_anim_routine+1
!:

		rts


rotator_part_6:
colfd7:
		ldx #228

		lda #0
		sta colour_table,x
		inc colfd7+1

		cpx #175
		bne !+

		inc exit_scene+1
!:

		rts

