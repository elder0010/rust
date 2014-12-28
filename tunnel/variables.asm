//;--------------------------------------------
//;Tunnel colours
.var external_colour = PURPLE
.var line_colour = BROWN
.var border_colour = RED
.var bg_colour = RED
.var plasma_1_col = PURPLE
.var plasma_2_col = LIGHT_BLUE
.var text_color = WHITE
/*
.var external_colour = PURPLE
.var line_colour = BROWN
.var border_colour = ORANGE
.var bg_colour = ORANGE
.var plasma_1_col = LIGHT_RED
.var plasma_2_col = GRAY
.var text_color = WHITE
*/
//;--------------------------------------------
//;Opcode constants
.var ADC_IMM = $69
.var ADC_ABS = $6d
.var ADC_ZP = $65
.var SBC_IMM = $e9
.var SBC_ABS = $ed
.var SBC_ZP = $e5
.var BCC = $90
.var BCS = $B0
.var BEQ = $F0
.var BNE = $D0
.var CLC = $18
.var SEC = $38
//;--------------------------------------------
.var source_sprite = $ffff

.var buffer_area = $0400

.var x_byte_2 = ZP3
.var step = ZP13

//;.var buffer_free = ZP23
.var curspeed = ZP31
.var current_offset = ZP15
.var base_fade = ZP23

//;Sprite movement variables
.var SPRITE_Y_START = $35
.var low_sprite_y = 28
.var CORREZIONE_Y = 10
.var x_min = 0

//;Tunnel variables
.var music = LoadSid("../tentacoli/psycho.sid")

/*
.pc = $2000
frame_6_table_down:
.import binary "frames6/06_d_screen.raw"

.pc = $2800 "ultimo screen"
frame_6_table_up:
.import binary "frames6/06_u_screen.raw"
*/

.if(TEST_MODE==0){
.var frame_6_table_up = $c800
.var frame_6_table_down = $e000
}
.pc = $3800 "Charset"
charset:

.var charsetPic = LoadPicture("charset-bold.gif", List().add($000000, $ffffff))
.function picToCharset(byteNo, picture) {
	.var ypos = [byteNo&7] + 8*[[byteNo>>9]&1] 
	.var xpos = 2*[[byteNo>>3]&$3f] + [[byteNo>>10]&1]
	.return picture.getSinglecolorByte(xpos,ypos)		
}
.fill $800, picToCharset(i,charsetPic)


.pc = $4000 "tunnel charsets frame 1 2"
.import binary "frames6/01_u_char.raw"
.import binary "frames6/01_d_char.raw"

.import binary "frames6/02_u_char.raw"
.import binary "frames6/02_d_char.raw"

.pc = * "questi"
.import binary "frames6/03_u_char.raw"
.import binary "frames6/03_d_char.raw"


.var FRAME_1_SCREEN = $7000
.var FRAME_2_SCREEN = $7400
.var FRAME_3_SCREEN = $7800


//;SOPRA A 104 SOTTO A 96
.pc = $7000 "tunnel screens 1-3"
.import binary "frames6/screen-1-3.raw"

//.pc = $7c40 "sprite_area 1"
.var SPRITE_AREA_1 = $7c00
sprites_area_1:
//.import binary "spritetest.raw"

//
//.import binary "spritetest.raw"
//.fill $40*6,$ff

.pc = $8800 "tunnel screens 4-5"
.import binary "frames6/screen-4-5.raw"

.pc = $8000 "tunnel chars 2"
.import binary "frames6/04_u_char.raw"


.var FRAME_4_SCREEN = $8800
.var FRAME_5_SCREEN = $8c00
.var FRAME_6_SCREEN = $c800

.pc = $a000  "tunnel chars 2 ultimo charset"
.import binary "frames6/04_d_char.raw"

.import binary "frames6/05_u_char.raw"
.import binary "frames6/05_d_char.raw"

.pc = $c000 "penultimo charset"
.import binary "frames6/06_u_char.raw"

.pc = $c800 "ultimo screen"
frame_6_table_up:
.import binary "frames6/06_u_screen.raw"





.var SPRITE_AREA_2 = $b800
.var SPRITE_AREA_3 = $e800
/*
frame_1_table_up:
.import binary "frames6/01_u_screen.raw"
frame_1_table_down:
.import binary "frames6/01_d_screen.raw"

frame_2_table_up:
.import binary "frames6/02_u_screen.raw"
frame_2_table_down:
.import binary "frames6/02_d_screen.raw"

frame_3_table_up:
.import binary "frames6/03_u_screen.raw"
frame_3_table_down:
.import binary "frames6/03_d_screen.raw"

frame_4_table_up:
.import binary "frames6/04_u_screen.raw"
frame_4_table_down:
.import binary "frames6/04_d_screen.raw"

frame_5_table_up:
.import binary "frames6/05_u_screen.raw"
frame_5_table_down:
.import binary "frames6/05_d_screen.raw"

frame_6_table_up:
.import binary "frames6/06_u_screen.raw"
frame_6_table_down:
.import binary "frames6/06_d_screen.raw"
*/