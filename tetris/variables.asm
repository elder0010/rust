.var screenChars  = $0400 //; the 40x25 buffer
.var screenPixels = $2800 //; the pixel data for font or bitmap ($1000 or $9000 are always charrom)

.var BACKGROUND_COLOUR = BROWN
.var TILES_COLOUR = BLACK
.var SKULL_COLOUR = BLACK
.var BORDER_COLOUR = BLACK

.var numero_pezzi_da_mostrare = 30 //;quanti pezzi devono cadere prima di chiudere l'animazione

.var current_pezzo = $50
.var contatore_pezzo = $51
.var righe_pezzo = $52

.var start_offset = $58

.var clean_or_draw = $59
.var delay_timer = $5a
.var current_y = $5b

//;Lunghezza del pezzo corrente (per collisioni)
.var p_length = $5c
.var tmp_1 = $5d
.var collision_happened = $5e

.var delay_counter = $2 //;Quanto delay per l'animazione NON éUNO ZERO PAGE MA UN NUMERO

.var larghezza_teschio = 12
.var fade_pt = $69
.var pezzi_caduti = $6a
//;.var skull_screen_src = $ec00 //;Copiato dalla scena della farfalla

.var addr_scr = $70

