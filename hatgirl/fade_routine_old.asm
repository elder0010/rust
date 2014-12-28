point_block:
		
		ldx #180

		.var x = 180
//;ScreenRam src e dest
		lda #<ScreenRam+x
		sta screen_ram_src+1
		lda #>ScreenRam+x
		sta screen_ram_src+2

		lda #<bmp_screen+x
		sta screen_ram_dst+1
		lda #>bmp_screen+x
		sta screen_ram_dst+2

//;Color ram src e dest
		lda #<ColorRam+x
		sta color_ram_src+1
		lda #>ColorRam+x
		sta color_ram_src+2

		lda #<$d800+x
		sta color_ram_dst+1
		lda #>$d800+x
		sta color_ram_dst+2

//;Pixel src e dest
		lda #<pic1+[x*8]
		sta pixel_src_lo+1

		lda #>pic1+[x*8]
		sta pixel_src_hi+1


		lda #<pixel_dest+[x*8]
		sta pixel_dest_lo+1

		lda #>pixel_dest+[x*8]
		sta pixel_dest_hi+1

		rts


//;------------------------------------
//;Fade un blocco da 8
//;------------------------------------
fade_block:
		jsr point_block

		lda #0
		sta fade_pt

		//;Per prima cosa vediamo qualè il colore da fadare
		//;E lo storiamo in variabili 
screen_ram_src:		
		lda ScreenRam
		tax
		and #$0f
		sta col_1
		lda tolonibble,x
		sta col_2

color_ram_src:
		lda ColorRam
		and #$0f
		sta col_3


		//;Poi puntiamo le tabelle di fade di ogni colore
		ldx col_1
		lda fade_table_addr_lo,x
		sta fade_table_1
		lda fade_table_addr_hi,x
		sta fade_table_1+1

		ldx col_2
		lda fade_table_addr_lo,x
		sta fade_table_2
		lda fade_table_addr_hi,x
		sta fade_table_2+1

		ldx col_3
		lda fade_table_addr_lo,x
		sta fade_table_3
		lda fade_table_addr_hi,x
		sta fade_table_3+1

fade_again:
		//; uso la tabella per determinare il colore corrente
		ldy fade_pt
		lda (fade_table_1),y
		sta current_col_1

		lda (fade_table_2),y
		sta current_col_2

		lda (fade_table_3),y
		sta current_col_3
		jmp gofade

gofade:
		lda current_col_1
		ldy current_col_2 //;Forse questi due sono da invertire
		ora tohinibble,y

screen_ram_dst:
		sta bmp_screen		

		lda current_col_3
color_ram_dst:
		sta $d800

pixel_src_hi:		
		lda #>pic1
		sta pixel_src+1

pixel_src_lo:	
		lda #<pic1
		sta pixel_src

pixel_dest_hi:
		lda #>pixel_dest
		sta pixel_dst+1

pixel_dest_lo:
		lda #<pixel_dest
		sta pixel_dst

		ldx fade_pt
		bne nocopypx
		ldy #7
!:
		lda (pixel_src),y
		sta (pixel_dst),y
		dey
		bpl !-
nocopypx:

		:wait_frame()
		inc fade_pt
		lda fade_pt
		cmp #8
		bne fade_again
		rts

.align $80
.import source "fade_tables.asm"		


.align $100
tolonibble:
.fill 256,floor(i/16)

.align $100
tohinibble:
.fill 256,[floor(i/16)] << 4



