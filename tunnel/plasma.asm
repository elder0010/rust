.var color_dest  	= $d800
.var plasma_sin_1 = $9100
plasma:
			lda p1
			sta t1
			
			lda p2
			sta t2
			
			//;Resetto the colour ram counter
			lda #<color_dest
			sta scr_dest+1
			lda #>color_dest
			sta scr_dest+2
					
loop_y:
			lda t1 //;LDA t1
			sta t3 //;f_sin+1
			lda t2 //;LDA t2
			sta t4 //;s_sin+1
			
			ldx t1
			lda plasma_sin_1,x
			
			ldx t2
base_st:
			adc plasma_sin_1,x
			
			sta base+1
		 
			ldx #$0
			ldy #$0

//;--------------------------------------------------------
//;LOOP CENTRALE PER X

loop_x:
	
base:			
			lda #$00 //;Questo valore cambia a seconda del giro

			ldx t3
f_sin:
			adc plasma_sin_1,x
			and #1
			
			ldx t4	
s_sin:
			adc plasma_sin_1,x
			and #8
			tax
			lda COLOR_FADER,x
			
scr_dest:
			sta $d800+$28,y
								
			lda t3
WOB:
			adc #5
			sta t3
			 
			lda t4
bright:
			adc #1 //;Quest puo valere 1 2 3
			sta t4
			
			iny
			cpy #37
			bne loop_x
			
//;END LOOP CENTRALE SU X
//;-----------------------------------------------------			
			lda t1
depth:
			adc #1
			sta t1
			
			lda t2
depth_2:
			adc #3 //;1
			sta t2
							
		 //;scr_dest sarebbe lo screen target: aggiungo 40 per SCENDERE di una riga
			lda scr_dest+1
			clc
			adc #40
			sta scr_dest+1
	
			lda scr_dest+2
			adc #$00
			sta scr_dest+2
	
			//;Decremento il contatore delle RIGHE (asse y)
			inc y_count
			lda y_count

			cmp #25
			bne loop_y //;bne loopy!
		
			lda #$0
			sta y_count
			
			lda p2
plasma_speed:
			sbc #80  //;6  //;1    //;QUESTO REGOLA LA VELOCITA
			sta p2

			inc p3



skip_fade_plasma:		
			jmp go_fade_plasma
			
go_fade_plasma:
			//;Fade del plasma
			ldx plasma_fade_pt
			lda plasma_fade_table,x
			sta fade_plasma_col
			sta fade_plasma_col+1
			sta fade_plasma_col+2
			sta fade_plasma_col+3
			
			inc plasma_fade_pt
			lda plasma_fade_pt
			cmp #7
			bne !+
			lda plasma
			
			lda #>plasma
			sta skip_fade_plasma+2
		
			lda #<plasma
			sta skip_fade_plasma+1
			
			:trigger_sprite_movement()
!:
			jsr null_func

plasma_loop:
			jmp plasma


			
//;;PLASMA DATA

plasma_fade_pt:
.byte $0

.pc = * " plasma fade table"
plasma_fade_table:
.byte WHITE, YELLOW, CYAN, LIGHT_GREEN,CYAN,GREEN
plasma_last_byte:
.byte LIGHT_BLUE




//;vertical 
p1:				.byte   $0			
p2:				.byte   $0			
//;horizontal
p3:				.byte   $0			
p4:				.byte   $0			
t1:				.byte   $0			
t2:				.byte   $0			
t3:				.byte   $0			
t4:				.byte   $0
tmp_x:			.byte   $0

screen_count:	.byte  $0
			
y_count:		.byte $0
			
x_count:		.byte $0


.macro trigger_sprite_movement(){
		lda #>go_move
		sta introjmp+2
		
		lda #<go_move
		sta introjmp+1
}
			
post_plasma:
		lda #0
		sta $d015
		
		rts
	
		//;jmp *


