.var snare_hits = $86 //;ATTENZIONE SE CAMBI CAMBIARE ANCHE SU MINIFADER!
.const frame_lo = $98
.const frame_hi = $99

.var SCREEN_1 = $0400 //;Already defined in postplexer, same value!
.var SCREEN_2 = $0800


.var source_base_screen = $34
//;$35 è usato per l'indirizzamento in zero page
.var target_base_screen = $37
//;$38 è usato per l'indirizzamento in zero page

//;zp
.var plot_lo = $fe
.var plot_hi = $ff
.var pointer_coordinate = $fd 
.var oldCIA = $45

//;punti per bresenham
.var x_1 = $50
.var y_1 = $51

.var x_2 = $52
.var y_2 = $53



//;Punti per il chunky pixel plotter
.var current_x = $60
.var current_y = $61
.var dot_pt = $62
.var puntatore_pt = $63

.var vector_point_1 = $68
.var vector_point_2 = $69

.var which_max = $7b
.var move_pt = $57

.var can_fade_out = $d7

.const bg_colour = $66

//;Colori del cubo
.const col_1_sx = $20
.const col_1_dx = $02
.const col_1_all = $22


.const col_2_sx = $30
.const col_2_dx = $03
.const col_2_all = $33

.const col_3_sx = $90
.const col_3_dx = $09
.const col_3_all = $99

.const col_4_sx = $50
.const col_4_dx = $05
.const col_4_all = $55

.const col_5_sx = $60
.const col_5_dx = $06
.const col_5_all = $66

.const col_6_sx = $70
.const col_6_dx = $07
.const col_6_all = $77

