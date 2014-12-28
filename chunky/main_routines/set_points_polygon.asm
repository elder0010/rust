.var draw_offs = 15
setta_punti_AB:
set_points_a:
		//;Vedere storie di speedcoding su set points basic
		ldx wobble_a+draw_offs

		//;X1
		lda a_vector_x,x
		sta b_x_1_0+1
		sta b_x_1_1+1
	
		
		//;Y1
		lda a_vector_y,x
		sta b_y_1_0+1 //;Speedcoding mania (per bresenham)
		sta b_y_1_1+1


set_points_b:
		ldx wobble_b+draw_offs	
		
		lda b_vector_x,x
		sta b_x_2_0+1 //;Speedcoding mania (per bresenham)
		sta b1x+1
		
		lda b_vector_y,x
		sta b_y_2_0+1 //;Speedcoding mania (per bresenham)
		sta b1y+1
		rts
		
setta_punti_AC:
		//;X1 e Y1 lascio quelli di A
		
set_points_c:
		ldx wobble_c+draw_offs	
		
		lda c_vector_x,x
		sta b_x_2_0+1 //;Speedcoding mania (per bresenham)

		lda c_vector_y,x
		sta b_y_2_0+1 //;Speedcoding mania (per bresenham)
		
		rts


setta_punti_CB:
		
		//;X2 e Y2 lascio quelli di C
		//;Devo settare SOLO B su x1 y1
b1x:
		lda #50 //;Self modificato da prima (Setta punti AB)
		sta b_x_1_0+1
		sta b_x_1_1+1
b1y:	
		lda #30
		sta b_y_1_0+1 //;Speedcoding mania (per bresenham)
		sta b_y_1_1+1
		
		rts