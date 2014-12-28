verde:
.byte 0,1,1,$ff
verde_2:
.byte 1,1,0,$ff

blu:
.byte 1,0,0,$ff
blu_2:
.byte 1,1,1,$ff

viola:
.byte 0,1,0,$ff
viola_2:
.byte 1,1,1,$ff

cyan:
.byte 0,0,0,0,$ff
cyan_2:
.byte 1,1,1,1,$ff

giallo:
.byte 1,1,$ff
giallo_2:
.byte 1,1,$ff

arancione:
.byte 0,0,1,$ff
arancione_2:
.byte 1,1,1,$ff

rosso:
.byte 1,1,0,$ff
rosso_2:
.byte 0,1,1,$ff

larghezze_pezzi:
.byte 2,3,3,4,2,3,3

indirizzi_pezzi_lo:
.byte <verde,<blu,<viola,<cyan,<giallo,<arancione,<rosso
indirizzi_pezzi_hi:
.byte >verde,>blu,>viola,>cyan,>giallo,>arancione,>rosso

.align $40
indirizzi_pezzi_lo_2:
.byte <verde_2,<blu_2,<viola_2,<cyan_2,<giallo_2,<arancione_2,<rosso_2
indirizzi_pezzi_hi_2:
.byte >verde_2,>blu_2,>viola_2,>cyan_2,>giallo_2,>arancione_2,>rosso_2

colori_pezzi:
.byte LIGHT_GRAY,LIGHT_RED,LIGHT_BLUE,LIGHT_GREEN,YELLOW,ORANGE,LIGHT_GRAY


.align 50
righe_schermo_lo:
.for (var x=0; x<26;x++){
	.byte <[screenChars+[x*$28]]
}

righe_schermo_hi:
.for (var x=0; x<26;x++){
	.byte >[screenChars+[x*$28]]
}
