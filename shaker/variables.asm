
.var frame_count_lo = $b7
.var frame_count_hi = $b8

.var screenChars  = $6400 //; the 40x25 buffer
.var screenPixels = $4000 //; the pixel data for font or bitmap ($1000 or $9000 are always charrom)
.var linee_fld = $40
.var restanti_fld = $41
.var sine_pt = $42
.var tmp = $59
.var tmp_2 = $73
.var top_y_pos = $c4
.var bottom_y_pos = $35
.var external_border_color = PURPLE

.var fade_pt = $97 

//;Colori bordo
.var COLOUR_1 = PURPLE
.var COLOUR_2 = LIGHT_RED

.var fade_pt_1 = $f000
.var fade_pt_2 = $f001

.var col_1 = $92
.var col_2 = $93
.var ct = $90

.var reseta1 = $50
.var resetx1 = $51
.var resety1 = $52


.var illegal_end = $e1
.var ILLEGAL_START = $67

.var tmp_5 = $89

.var raster_sine_pt = $93

.var rotator_screen = $c800+40*7

.var rotator_chars = $c000