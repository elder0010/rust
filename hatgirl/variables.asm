//;$3d
.const FADE_DEPTH = 29
.const FADE_DEPTH_FRAME_2 =  68 //;68


//;Zp addressing stuff
.var pixel_src = $b8
.var pixel_dst = $ba

.var addr_1 = $40
.var addr_2 = $42

.var pic0 = $4000
.var pic1 = $a000
.var pic2 = $7000

.var ScreenRam= pic1+$1f40
.var ColorRam = pic1+$1f40+$3e8

.var ScreenRam_intro= pic0+$1f40
.var ColorRam_intro = pic0+$1f40+$3e8

.var fade_seq_lo_addr = $9800
.var fade_seq_lo =  fade_seq_lo_addr
.var fade_seq_hi_addr = $f000
.var fade_seq_hi = fade_seq_hi_addr

.var  frame_len = $cf00

.var functions_and_fade_routine = $3200
.var fade_routine =   $3a00

/*
.var ScreenRam2= pic2+$1f40
.var ColorRam2 = pic2+$1f40+$3e8
*/

//;.var hat_sprites = $6400

.var hat_sprites = $3800
.var hat_sprites_target = $6400

.var bmp_screen = $6800
.var pixel_dest = $4000 //;Dove devono finire i pixels
.var fade_sequence = $3400
.var frame2_fade_tbl = $2c00 //;seconda fade table

.var fade_pt = $47

.var col_1 = $48
.var col_2 = $49
.var col_3 = $4a


.var current_col_1 = $4b
.var current_col_2 = $4c
.var current_col_3 = $4d

.var fade_table_1 = $50
.var fade_table_2 = $52
.var fade_table_3 = $54



.var num1hi = $6b
.var num1lo = $56

.var num2hi = $57
.var num2lo = $58

.var reshi = $59
.var reslo = $5a
.var fade_step = $5b


.var current_offs_lo = $61
.var current_offs_hi = $62


.var tmp_1 = $64
.var cur_len = $65

.var stor_addr1_lo = $66
.var stor_addr1_hi = $67
.var stor_addr2_lo = $68
.var stor_addr2_hi = $69

.var tmp_2 = $6a

.var irq_tmpa = $6b
.var irq_tmpx = $6c
.var irq_tmpy = $6d


//;Sprite writer variables
.var SPRITE_HANDLER_FUNCTION = $cab5 //;indirizzo di null_sprites in hatgirl.asm linea 240
.var BANK_SWITCH_0_LOCATION = $cb48 //;Indirizzi placeholder che dovranno diventare $dd00
.var BANK_SWITCH_1_LOCATION = $ca03 //;prenderli da hatgirl.asm linea 335 e 154
.var SPRITE_ENABLER = $cae6

.var scroll_charNo = $73
.var screenPixels = $0400
.var text_sprites = $0400
.var can_fade_sprites = $77
.var text_delay = $78
.const HOW_MUCH_TEXT_DELAY = 60
.var tmp_4 = $79
.var tmp_5 = $7a
.var tmp_6 = $7b
.var tmp_3 = $7c

.var can_go_outro = $7d
.var outro_flip = $7e


.var addr_3 = $80


.var reseta1 = $87
.var resetx1 = $88
.var resety1 = $89