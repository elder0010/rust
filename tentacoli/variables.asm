.var music = LoadSid("Last_Try.sid")
.var blank_char = $20 //;serve per blankare lo schermo

//;Schermo sprites
.var schermo_sprites = $4000

.var mplex_count = ZP1
.var sprite_pointer_0 = ZP2

.var irq_d012_pt = ZP13
.var line_counter = ZP9
.var memory_pt = ZP10
.var sprite_line_cnt = ZP11


//;Zero page pointers

.var TEMP  = ZP20
.var TEMP2 = ZP21
.var TEMP3 = ZP22

.var PT_ZERO = ZP5
.var PT_ONE = ZP27

.var delay_ticker = ZP19
.var pre_fade_ticker = ZP16
.var intro_tentacoli_delay = ZP26
row_counter:
.byte $0
//;Sprites tentacoli


.pc = $4400 "sprites"
sprites:
/*
.import binary "sprites.raw"
*/


.pc = $6000 "picture"
.import c64 "pic.prg"

.pc = $9d00 "puntatori e varie"

.var offset_sprites = sprites-schermo_sprites


.align $100
//;Tabella di puntatori agli sprites - sono 9 puntate
sprite_address:
.byte [offset_sprites/$40]

sprite_memory_pointers_lo:
.byte <sprites_source,<sprites_source+$40,<sprites_source+$40*2,<sprites_source+$40*3,<sprites_source+$40*4
.byte <sprites_source+$40*5,<sprites_source+$40*6,<sprites_source+$40*7,<sprites_source+$40*8,<sprites_source+$40*9

sprite_memory_pointers_hi:
.byte >sprites_source,>sprites_source+$40,>sprites_source+$40*2,>sprites_source+$40*3,>sprites_source+$40*4
.byte >sprites_source+$40*5,>sprites_source+$40*6,>sprites_source+$40*7,>sprites_source+$40*8,>sprites_source+$40*9



//;Linee di ripetizione degli sprites (irq)
.var base_repeat_irq = $67
.var CORREZIONE = 2

multiplex_d012:
.byte base_repeat_irq+$15
.byte base_repeat_irq+$15*2
.byte base_repeat_irq+$15*3
.byte base_repeat_irq+$15*4-1
.byte base_repeat_irq+$15*5  //;ALTEZZA DEL GRIGIO
.byte base_repeat_irq+$15*6  //;ALTEZZA DEL ROSSO
.byte base_repeat_irq+$15*7

altezze_sprites:
.byte $68,$7d,$92,$a7,$bc,$d1,$e6,$fb,$10

altezza_pointer:
.byte $0

altezza_tentacoli:
.byte $0

altezza_tentacoli_dec:
.byte $0


tentacles_x:
.byte 5,4,4,4,4,3,3,3,3,2,2,2,2,2,1,1
.byte 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
.byte 1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,4
.byte 5,5,5,5,6,6,6,6,6,7,7,7,7,8,8,8
.byte 8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8
.byte 8,8,8,7,7,7,7,7,6,6,6,6,5,5,5,5
.byte 4,4,4,4,3,3,3,3,2,2,2,2,2,1,1,1
.byte 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
.byte 1,1,1,2,2,2,2,3,3,3,3,3,4,4,4,4
.byte 5,5,5,5,6,6,6,6,7,7,7,7,7,8,8,8
.byte 8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8
.byte 8,8,7,7,7,7,7,6,6,6,6,5,5,5,5,5

tentacles_wobble_pt:
.byte $0
.byte $20
.byte $40
.byte $90


.var TENTACLES_0_X = 80
.var TENTACLES_1_X = 125
.var TENTACLES_2_X = 180
.var TENTACLES_3_X = 242



.pc = $8800 "sprites_source"
sprites_source:
.import source "sprites.asm"
//;.import binary "sprites.raw"