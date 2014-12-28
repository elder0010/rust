char_sx:
//;Il primo è vuoto
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000

//;I successivi 6 (2 a sx, 2 a dx, 2 sopra) caratteri sono vuoti, ci copierò dentro i bytes dei caratteri successivi a seconda del caso
//;I caratteri sono 2 per il bordo SX e due per il bordo DX
left_border_char_start:
.fill 16,0

right_border_char_start:
.fill 16,0

top_border_char_start:
.fill 16,0

.pc = * "patterns_sx"
patterns_sx:
//;E poi ci sono i pattern di riempimento, per tutti i casi (17 totali)
//;primo carattere
.byte %00000000
.byte %10000000
.byte %11000000
.byte %11100000
.byte %11110000
.byte %11111000
.byte %11111100
.byte %11111110
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111

//;secondo carattere
patterns_sx_2: 
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %10000000
.byte %11000000
.byte %11100000
.byte %11110000
.byte %11111000
.byte %11111100
.byte %11111110
.byte %11111111

//;ALTRI CARATTERI DEL CHARSET BUONI PER ALTRI UTILIZZI
//;DAL 5 in poi!
.byte %0010100
.byte %0001000
.byte %0010100
.byte %0001000
.byte %0010100
.byte %0001000
.byte %0010100
.byte %0001000

.pc = * "patterns_dx"
patterns_dx:
.byte %00000000
.byte %00000001
.byte %00000011
.byte %00000111
.byte %00001111
.byte %00011111
.byte %00111111
.byte %01111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111
.byte %11111111

patterns_dx_2:
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000001
.byte %00000011
.byte %00000111
.byte %00001111
.byte %00011111
.byte %00111111
.byte %01111111
.byte %11111111

//;per il top mi bastano due caratteri vuoti da riempire con i valori 0,16
patterns_top:
.fill 16,0