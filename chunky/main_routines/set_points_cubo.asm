.var draw_offs = 15

.align $100

setta_B1A3:
		ldx move_pt
		:point_start(1)
		:point_end(3)
		rts

setta_A3R2:
		ldx move_pt
		:point_start(3)
		:point_end(2)
		rts	
		

setta_R2N0:
		ldx move_pt
		:point_start(2)
		:point_end(0)
		rts	

setta_N0B1:
		ldx move_pt
		:point_start(0)
		:point_end(1)
		rts	
		
setta_B1N0:
		ldx move_pt
		:point_start(1)
		:point_end(0)
		rts
		

setta_A3G7:
		ldx move_pt
		:point_start(3)
		:point_end(7)
		rts	

setta_G7BL6:
		ldx move_pt
		:point_start(7)
		:point_end(6)
		rts	

setta_BL6R2:
		ldx move_pt
		:point_start(6)
		:point_end(2)
		rts	

setta_G7VE5:
		ldx move_pt
		:point_start(7)
		:point_end(5)
		rts	
		

setta_VE5VI4:
		ldx move_pt
		:point_start(5)
		:point_end(4)
		rts	
		
setta_VI4BL6:
		ldx move_pt
		:point_start(4)
		:point_end(6)
		rts	
		
setta_VE5BI1:
		ldx move_pt
		:point_start(5)
		:point_end(1)
		rts	
		
setta_VI4N0:
		ldx move_pt
		:point_start(0)
		:point_end(4)
		rts	

setta_N0V14:
		ldx move_pt
		:point_end(0)
		:point_start(4)
		rts	
		
		
.macro point_start(pt){
		lda cubeCoords+pt*2*FrameNumber,x
		sta b_x_1_0+1
		sta b_x_1_1+1
			
		lda cubeCoords+[1+pt*2]*FrameNumber,x
		sta b_y_1_0+1 
		sta b_y_1_1+1
}

.macro point_end(pt){
		lda cubeCoords+pt*2*FrameNumber,x
		sta b_x_2_0+1 
	//	sta b1x+1	
		
		lda cubeCoords+[1+pt*2]*FrameNumber,x
		sta b_y_2_0+1
	//	sta b1y+1
}


.macro point_start_xy(x,y){
		lda #x
		sta b_x_1_0+1
		sta b_x_1_1+1
			
		lda #y
		sta b_y_1_0+1 
		sta b_y_1_1+1
}

.macro point_end_xy(x,y){
		lda #x
		
		sta b_x_2_0+1 
	//	sta b1x+1	
		
		lda #y
		sta b_y_2_0+1
	//	sta b1y+1
}




