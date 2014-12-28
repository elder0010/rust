//;.var screenChars  = $4800 //;Schermo
.var screenChars  = $4800 //;Schermo

.var screenPixels = $6000 //;Bitmap

.var bitmap_char_1 = $a1
.var bitmap_char_2 = $a2

.var extra_line = true //;Setta a true per avere 8 px di bitmap in piu

//.var screen_colours = $23 //;valore del foreground e backgroundcolor della wobble area
.var screen_colours = $b1

//;Settaggi banco e schermo
.var banco = [[screenChars ^ $ffff] >> 14]
.var schermo_d018 =	 [[[screenChars & $3fff] / $0400] << 4] + [[[screenPixels & $3fff] / $0800] << 1]

//;Variabili che servono alle routine di filling, ignora pure
.var char = 0
.var linea = 17

//;Dove inizia il bitmap
.var pixels_tizia_start = screenPixels + linea*40*8
.var bitmap_start = screenPixels+$1540

