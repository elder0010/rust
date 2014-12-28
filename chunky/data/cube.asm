//-----------------------------------------------------------------------------------------
// Objects 
//-----------------------------------------------------------------------------------------
.var Cube = List().add( Vector(1,1,1),  Vector(1,1,-1),  Vector(1,-1,1),  Vector(1,-1,-1),
					    Vector(-1,1,1), Vector(-1,1,-1), Vector(-1,-1,1), Vector(-1,-1,-1))

.var lista_facce_accese = List()

//------------------------------------------------------------------------------------------
// Macro for doing the precalculation
//-----------------------------------------------------------------------------------------
.macro PrecalcObject(object, animLength, nrOfXrot, nrOfYrot, nrOfZrot) {
	

	// Rotate the coordinate and place the coordinates of each frams in a list
	.define frames {
		.var frames = List()
		.for(var frameNr=0; frameNr<animLength;frameNr++) {
			// Set up the transform matrix
			.var aX = toRadians(frameNr*360*nrOfXrot/animLength)
			.var aY = toRadians(frameNr*360*nrOfYrot/animLength)
			.var aZ = toRadians(frameNr*360*nrOfZrot/animLength)
			.var zp = 2.5	// z coordinate for the projection plane
			.var m = ScaleMatrix(40,40,0)*PerspectiveMatrix(zp)*MoveMatrix(1.1,0,zp+5)*RotationMatrix(aX,aY,aZ)  		
		//	.var m = ScaleMatrix(30,30,0)*PerspectiveMatrix(zp)*MoveMatrix(0,0,zp+5)*RotationMatrix(aX,aY,aZ)  		
	
			// Transform the coordinates		
			.var coords = List()
			.var tmp
			.for (var ix=0; ix<object.size(); ix++) {
				
				
				.eval tmp = m*object.get(ix)
	
				
				.eval coords.add(m*object.get(ix))			
			}
			
				
				
			.eval frames.add(coords)
		}
	}

	.var tmp 
	.var lista_coordinate = List()
	
	// Dump the list to the memory
	.for (var coordNr=0; coordNr<object.size(); coordNr++) {
		.for (var xy=0;xy<2; xy++) {
	
			.fill animLength, 25+round(frames.get(i).get(coordNr).get(xy))
		
		}
	}


//;--------------------------------------------------------------------------------
//;Calcolo quali piani sono disegnabili in ogni frame
//;--------------------------------------------------------------------------------
	.pc = * "piani disegnabili"
	//;Dumpo la memoria in una mega lista
	.var cube_movements = LoadBinary("../cube_movements.raw")
	
	.var p1
	.var p2
	.var p3
	
	.var facce = 0
	
	.for(var frameNr=0; frameNr<animLength;frameNr++) {
		//;Per ogni frame vedo se le facce 0-5 sono disegnabili.
	
		//;accendero' il bit relativo alla faccia
		.eval facce = 0
		
		//;Questi sono i 3 punti che individuano il piano
		.eval p1 = List()
		.eval p2 = List()
		.eval p3 = List()
		
		
		//;faccia 0(b1;a3;n0)				
		.eval p1 = get_xy(2,frameNr)
		.eval p2 = get_xy(1,frameNr)
		.eval p3 = get_xy(3,frameNr)
		
		.if(is_plane_drawable(p1,p2,p3)<0){
			.eval facce = facce | 1
		}
		.eval calc_angle(p1,p2,p3,lista_color0)
		
	
		//;faccia 1(7 6 2)
		.eval p1 = get_xy(2,frameNr)
		.eval p2 = get_xy(7,frameNr)
		.eval p3 = get_xy(6,frameNr)
		
		
		.if(is_plane_drawable(p1,p2,p3)<0){
			.eval facce = facce | 2
		}
		.eval calc_angle(p1,p2,p3,lista_color1)
		
		
		//;faccia 2 (4 7 5)
		.eval p1 = get_xy(4,frameNr)
		.eval p2 = get_xy(7,frameNr)
		.eval p3 = get_xy(5,frameNr)
			
		.if(is_plane_drawable(p1,p2,p3)<0){
			.eval facce = facce | 4
		}
		.eval calc_angle(p1,p2,p3,lista_color2)
		
						
		//;faccia 3 (1 4 5)
		.eval p1 = get_xy(1,frameNr)
		.eval p2 = get_xy(4,frameNr)
		.eval p3 = get_xy(5,frameNr)		

		.if(is_plane_drawable(p1,p2,p3)<0){
			.eval facce = facce | 8
		}
		.eval calc_angle(p1,p2,p3,lista_color3)
		
				
		//;Faccia 4 (2 6 0)
		.eval p1 = get_xy(2,frameNr)
		.eval p2 = get_xy(6,frameNr)
		.eval p3 = get_xy(0,frameNr)

		.if(is_plane_drawable(p1,p2,p3)<0){
			.eval facce = facce | 16
		}
		.eval calc_angle(p1,p2,p3,lista_color4)
		
				
		//;Faccia 5 (7 5 3)
		.eval p1 = get_xy(3,frameNr)
		.eval p2 = get_xy(1,frameNr)
		.eval p3 = get_xy(7,frameNr)
		
		.if(is_plane_drawable(p1,p2,p3)<0){
			.eval facce = facce | 32
		}
		.eval calc_angle(p1,p2,p3,lista_color5)
		
	//	.print facce
		
		.eval lista_facce_accese.add(facce)
	}	
}


//;Restituisce le coordinate x e y del punto pt al frame 
.function get_xy(pt,frame){
	.var point = List()
	.var x
	.var y
			
	.eval x = round(frames.get(frame).get(pt).get(0))
	.eval y = round(frames.get(frame).get(pt).get(1))
	
	.eval point.add(x)
	.eval point.add(y)
		
	.return point
//;	X	lda cubeCoords+pt*$200,x	
//;	Y	lda cubeCoords+$100+pt*$200,x	
}
	
.function get_color(angle)
{
	.var col=0
	.if (angle<=0 && angle> -46) 		.eval col = 0
	.if (angle<= -46 && angle> -300)	.eval col = 1
	.if (angle<= -300 && angle> -486)	.eval col = 2
	.if (angle<= -486 && angle> -728)	.eval col = 3
	.if (angle<= -728)					.eval col = 4
	.return col
}
	
.function calc_angle(p1,p2,p3,lista_colori){
	  
	.var c = 0
	.var x3 = p3.get(0)-25
	.var x1 = p1.get(0)-25
	.var y2 = p2.get(1)-25
	.var y1 = p1.get(1)-25
	.var x2 = p2.get(0)-25
	.var y3 = p3.get(1)-25
	
	
	.eval c = [x3-x1]*[y2-y1]-[x2-x1]*[y3-y1]

	.var col=get_color(c)
	.eval lista_colori.add(col)	
}	
	
.function is_plane_drawable(p1,p2,p3){
  //;  c=(x3-x1)*(y2-y1)-(x2-x1)*(y3-y1)

  
	.var c = 0
	.var x3 = p3.get(0)-25
	.var x1 = p1.get(0)-25
	.var y2 = p2.get(1)-25
	.var y1 = p1.get(1)-25
	.var x2 = p2.get(0)-25
	.var y3 = p3.get(1)-25
	
	
	.eval c = [x3-x1]*[y2-y1]-[x2-x1]*[y3-y1]
	.eval c=c/0

	/*
	.print "X1 "+x1
	.print "X2 "+x2
	.print "X3 "+x3
	.print "Y1 "+y1
	.print "Y2 "+y2
	.print "Y3 "+y3
	*/
	
	//.print "C "+c	
	
	.return c	
	/*
	.if(c<=0){
		.return true
	}
	
	.if(c>0){
		.return false
	}
	*/
	
}



//-------------------------------------------------------------------------------
// The vector data
//-----------------------------------------------------------------------------------------
.align $100
.pc = * "coordinate cubo"
cubeCoords: :PrecalcObject(Cube,FrameNumber,2,-1,1)

.pc = *  "facce disegnabili"
facce_disegnabili:
.for(var frameNr=0; frameNr<FrameNumber;frameNr++) {
//.print lista_facce_accese.get(frameNr)
	.byte lista_facce_accese.get(frameNr)
}