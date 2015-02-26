.function getLineAddresses(base,y) {    
	.return [base+$800*mod(y,2)] + [floor(y/2)*$28]    
}


.var screenHeight = SIZEY

.print "Chunky pointers: "+toHexString(*)
targetLowBuffer1:
.for (var i = 0 ; i < screenHeight;i++)
    .byte <[getLineAddresses($6000,YOFFSET+screenHeight-i-1)+XOFFSET]

targetHiBuffer1:
.for (var i = 0 ; i < screenHeight;i++)
    .byte >[getLineAddresses($6000,YOFFSET+screenHeight-i-1)+XOFFSET]

targetLowBuffer2:
.for (var i = 0 ; i < screenHeight;i++)
    .byte <[getLineAddresses($6400,YOFFSET+screenHeight-i-1)+XOFFSET]
	
targetHiBuffer2:
.for (var i = 0 ; i < screenHeight;i++)
    .byte >[getLineAddresses($6400,YOFFSET+screenHeight-i-1)+XOFFSET]
