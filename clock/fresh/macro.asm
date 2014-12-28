// Text macro
// **********
.const	s16	=	1
.const	s8	=	0

.macro addrow(strn) {	
	.var ch
	.for(var i=0;i<strn.size();i++) 
	{
		.eval ch=strn.charAt(i)
		.if (ch>='a'&&ch<='z') .eval ch=[ch-'a'+1]
			else .if (ch>='A'&&ch<='Z') .eval ch=[ch-'A'+1]
				else .if (ch>='0'&&ch<='9') .eval ch=[33+ch-'0']
					else .if (ch=='!'||ch=='?') .eval ch=[43+ch-'!']	
						else .eval ch=' '
		.byte ch
	}	
	.if ([mod(strn.size(),spritenumber*3)]!=0)
		.byte $ff
}

.macro interlinea(val) {
	.if (val>255-8) .print "WARNING: interlinea non valido"
	.byte $fd,8+val
}

.macro stop() {
	.byte $fe,$00
}

.macro setfontsize(s) {
	.byte $fc,[s&1]
}

.macro setspeed(s) {
	.if (s==0) .eval s=1
	.byte $fb,[s-1]
}
	
