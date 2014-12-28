set_points:
		next_x1:		
		lda wobble_v1
	//	sta x_1
		sta b_x_1_0+1
		sta b_x_1_1+1
		
next_y1:		
		lda wobble_v2
	//	sta y_1
		sta b_y_1_0+1 //;Speedcoding mania (per bresenham)
		sta b_y_1_1+1
		
next_x2:		
		lda wobble_v3+50
	//	sta x_2
		sta b_x_2_0+1 //;Speedcoding mania (per bresenham)
									
next_y2:		
		lda wobble_v4+20
	//	sta y_2
		sta b_y_2_0+1 //;Speedcoding mania (per bresenham)
		
		inc next_x1+1
		inc next_y1+1	
		inc next_x2+1	
		inc next_y2+1
		
		rts