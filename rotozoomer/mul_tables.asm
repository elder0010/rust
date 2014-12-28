.align $100
.pc = * "mul tables"
square1_lo:
.for(var x=0;x<512;x++){
	.byte <[[x*x]/4]

}

square1_hi:
.for(var x=0;x<512;x++){
	.byte >[[x*x]/4] 
}

//;f(x)=int((x-255)*(x-255)/4)
square2_lo:
.for(var x=0;x<512;x++){
	.byte <[[[x-255]*[x-255]]/4]
}


square2_hi:
.for(var x=0;x<512;x++){
	.byte >[[[x-255]*[x-255]]/4]
}

