////;--------------------------------------
////;------WOBBLER VARIABLES
////;--------------------------------------

.var SCREEN_1 = $4800

.var sprite_pt_01 = SCREEN_1+$03f8
.var sprite_pt_02 = SCREEN_1+$03f9
.var sprite_pt_03 = SCREEN_1+$03fa
.var sprite_pt_04 = SCREEN_1+$03fb
.var sprite_pt_05 = SCREEN_1+$03fc
.var sprite_pt_06 = SCREEN_1+$03fd
.var sprite_pt_07 = SCREEN_1+$03fe
.var sprite_pt_09 = SCREEN_1+$03ff

.var D018_SCREEN_1 = $20

.var left_wobble_pt = $f2
.var right_wobble_pt = $f1

.var char_base = $6000

.var x_offset = ZP12

.var border_colour = DARK_GRAY
.var girl_colour = BLACK

.var girl_face_start = $0290 //;Offset dallo schermo corrente per includere la lut della tipa

//;-----------plexer variables
.var MAXSPR          = 16 //;Maximum number of sprites
.var STEP	= 5
.const debug_top_sprites=false //;sprite superiori in nero per debug

.var numsprites      = ZP3     //;Number of sprites that the main program wants
                                //;to pass to the sprite sorter
.var sprupdateflag   = ZP13      //;Main program must write a nonzero value here
                                //;when it wants new sprites to be displayed
.var sortedsprites   = ZP11     //;Number of sorted sprites for the raster
                               //;interrupt
							   
.var sortorder       = ZP16+1           //;Order-table for sorting. Needs as many bytes
.var sortorderlast   = ZP16+MAXSPR           //;as there are sprites.


.var current_sprite_cnt = ZP20
.var global_sprite_cnt = ZP14


//;Queste locazioni sono diventate variabili, altrimenti il programma è inutilmente grande :D

//;.var border_wave = $3f00 //;SCOMMENTARE PER RICOMPILARE

.var patterns_sx = $5a38
.var patterns_dx = $5a61
.var charset_tizia_start = $4098
.var girl_screen_start = SCREEN_1+girl_face_start
.var sprites_destination = $5400
//.var exit_sinus = $3100
.var sintable_x_hi = $6900

.const savea	=	$70
.const savex	=	$71
.const savey	=	$72
.const oldCIA 	= 	$73
//;Zona "Safe" per puntare gli sprite 
//;mentre riloco il mondo..
.var safe_sprite_zone = $6800


//;Colori sprites	
/*			
.var COL1 = LIGHT_RED
.var COL2 = PURPLE
.var COL3 = BLUE
*/				

.macro init_scene_plexer(){
	:bank_1()
	
	/*
	lda #40
	sta left_wobble_pt
	sta ZP10
	lda #90
	sta right_wobble_pt
	*/
	
	lda #0
	sta left_wobble_pt
	sta ZP10
	sta x_offset
	lda #0
	sta right_wobble_pt
	
	//;lda #D018_SCREEN_1
	//;sta $d018
	
	lda #$ff
	//;sta $d015
	sta $d01c
	sta $d01b
}