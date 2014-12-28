.const sprites_location = $4400
.const schermo_sprites = $4000

.var start_line = $a2
.var plex_ct = $92

.var save_a = $43
.var save_x = $44
.var save_y = $45
.var tmp_1 = $46
.var tmp_2 = $47
.var tmp_3 = $90
.var frame_pt_0 = $88
.var frame_pt_1 = $89

.var addr = $4a
.var addr2 = $4c

.var altezza_reached = $4e
.var altezza_pt = $4f
.var can_change_d011 = $55

//;QUanto attendere prima di far partire i tentacles
.var delay_pre_scene = $23
.var altezza_tentacoli = 117 //;quanto far salire i tentacoli

//;Distanza dal quale deve partire l'effetto
.const start_bordo_inferiore = $e0

//;Fader variables
.var TEMP  = $56
.var TEMP2 = $57
.var TEMP3 = $58

.var PT_ZERO = $59
.var PT_ONE = $5a
.var row_counter = $5b

.var scrpos  = $7f40
.var scr    = schermo_sprites
.var colpos  = $8328
.var col     = $d800
.var bkgcol  = $8710

.var zp_del_male = $d7

/*
.var SPRITE_COL_1 = BROWN
.var SPRITE_COL_2 = ORANGE
.var SPRITE_COL_3 = LIGHT_RED
*/
/*
.var SPRITE_COL_1 = LIGHT_BLUE
.var SPRITE_COL_2 = LIGHT_GREEN
.var SPRITE_COL_3 = GREEN
*/

/*
.var SPRITE_COL_1 = LIGHT_BLUE
.var SPRITE_COL_2 = CYAN
.var SPRITE_COL_3 = LIGHT_GREEN
*/

/*
.var SPRITE_COL_1 = LIGHT_BLUE
.var SPRITE_COL_2 = GREEN
.var SPRITE_COL_3 = YELLOW
*/

/*
.var SPRITE_COL_1 = PURPLE
.var SPRITE_COL_2 = LIGHT_RED
.var SPRITE_COL_3 = YELLOW
*/

.var SPRITE_COL_1 = PURPLE
.var SPRITE_COL_2 = LIGHT_RED
.var SPRITE_COL_3 = YELLOW