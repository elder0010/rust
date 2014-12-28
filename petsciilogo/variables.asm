.var screenChars  = $0400 //; the 40x25 buffer
.var screenPixels = $3800 //; the pixel data for font or bitmap ($1000 or $9000 are always charrom)
.var screenPixels_final = $2800

.var sprites = $2a00

.var frame_ct = $28

.var fade_pt = $97

.var sinus_pt = $90
.var irq_line = $a5
.var irq_line_stop = $a6
.var irq_line_value = $a7

.var bottom_sprite_pos= $ef

.var reseta1 = $d0
.var resetx1 = $d1
.var resety1 = $d2

.var sprite_bar = $3800
.print "SPRITE BAR"+toHexString(sprite_bar)

.var blob_address = $3000

.var cover_sprite_colour = $98
.var tmp_1 = $9a

.var GIRI_DI_WOB = $1
