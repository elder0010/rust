.var frame_count_lo = $b7
.var frame_count_hi = $b8

.var screenChars  = $6400 //; the 40x25 buffer
.var screenPixels = $4000 //; the pixel data for font or bitmap ($1000 or $9000 are always charrom)

.var numero_giri_farfalla = 1

.var sine_pt = $fd

.var temp = $40

.var x_pt = $e4
.var y_pt = $eb

.var blinker_pt = $e7

.var wob_pt = $e8
.var puntatori_pt = $39
.var sprite_pointer = $fd
.var plex_irq_ct = $f4
.var external_border_color = PURPLE

.var can_move_butterfly = $9e

//;.var BUTTERFLY_COLOUR = LIGHT_RED

.var BUTTERFLY_COLOUR = ORANGE
.var BG_COLOUR = ORANGE

.var UNDER_COLOUR = BROWN

//;.var REFLEX_COLOUR = RED
.var REFLEX_COLOUR = BROWN

//;Intro vars
.var irq_1_line = $74
.var irq_2_line = $75
.var irq_3_line = $76
.var irq_4_line = $77
.var irq_5_line = $78
.var wob_1_line = $79
.var wob_2_line = $7a
.var wob_3_line = $7b
.var intro_irq_line = $9c

.const IRQ_1_COL = ORANGE
.const IRQ_2_COL = BLACK
.const IRQ_3_COL = RED

.const WOB_LINE_COL = BLACK
.const WOB_ZONE_1_COL = DARK_GRAY
.const WOB_ZONE_2_COL = LIGHT_RED
.const IRQ_4_COL = BLACK
.const IRQ_5_COL = BROWN

.var linea_irq_di_transizione = $a5
.var butterfly_fade_delay = $3f //;delay per la farfalla



.var linee_fld = $d7
.var restanti_fld = $d8
.var sine_pt_intro = $d9
.var tmp = $da
.var tmp_2 = $db
.var top_y_pos = $dc
.var bottom_y_pos = $dd


.var sine = $ad00



//;-------------------------------------------------------
//;Relocation variables
.var sprites_reverse = $4000
.var sprites = $4740
.var filler_sprite = $5400